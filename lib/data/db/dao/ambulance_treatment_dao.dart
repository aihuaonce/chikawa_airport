import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/ambulance_treatment_tables.dart';

part 'ambulance_treatment_dao.g.dart';

@DriftAccessor(
  tables: [
    AmbulanceTreatmentRecords,
    AmbulanceTreatmentCategories,
    AmbulanceTreatmentItems,
    AmbulanceTreatmentRecordItems,
    AmbulanceMedicationLogs,
    AmbulanceVitalSigns,
    AmbulanceEscortStaff,
  ],
)
class AmbulanceTreatmentDao extends DatabaseAccessor<AppDatabase>
    with _$AmbulanceTreatmentDaoMixin {
  AmbulanceTreatmentDao(super.db);

  // --- Initialization ---

  Future<void> initializeTreatmentData() async {
    final count = await (select(
      ambulanceTreatmentCategories,
    ).get()).then((l) => l.length);
    if (count > 0) return;

    await batch((batch) async {
      // 1. Airway
      final airwayId = await into(ambulanceTreatmentCategories).insert(
        AmbulanceTreatmentCategoriesCompanion.insert(
          code: 'AIRWAY',
          name: '呼吸道處置',
          sortOrder: const Value(1),
        ),
      );
      final airwayItems = [
        '口咽呼吸道',
        '鼻咽呼吸道',
        '抽吸',
        '哈姆立克法',
        '鼻管',
        '面罩',
        '非再呼吸型面罩',
        'BVM',
        'LMA',
        'I-Gel',
        '氣管內管',
        '其它',
      ];
      _insertItems(batch, airwayId, airwayItems);

      // 2. Trauma
      final traumaId = await into(ambulanceTreatmentCategories).insert(
        AmbulanceTreatmentCategoriesCompanion.insert(
          code: 'TRAUMA',
          name: '創傷處置',
          sortOrder: const Value(2),
        ),
      );
      final traumaItems = [
        '頸圈',
        '清洗傷口',
        '止血、包紮',
        '骨折固定',
        '長背板固定',
        '鏟式擔架固定',
        '其它',
      ];
      _insertItems(batch, traumaId, traumaItems);

      // 3. Transport
      final transportId = await into(ambulanceTreatmentCategories).insert(
        AmbulanceTreatmentCategoriesCompanion.insert(
          code: 'TRANSPORT',
          name: '搬運',
          sortOrder: const Value(3),
        ),
      );
      final transportItems = ['自行上車', '適當方式搬運'];
      _insertItems(batch, transportId, transportItems);

      // 4. CPR
      final cprId = await into(ambulanceTreatmentCategories).insert(
        AmbulanceTreatmentCategoriesCompanion.insert(
          code: 'CPR',
          name: '心肺復甦術',
          sortOrder: const Value(4),
        ),
      );
      final cprItems = ['自動心肺復甦機', 'CPR', '使用AED', '手動電擊器'];
      _insertItems(batch, cprId, cprItems);

      // 5. Drug
      final drugId = await into(ambulanceTreatmentCategories).insert(
        AmbulanceTreatmentCategoriesCompanion.insert(
          code: 'DRUG',
          name: '藥物處置',
          sortOrder: const Value(5),
        ),
      );
      final drugItems = ['靜脈輸液', '口服葡萄糖', 'Aspirin', 'NTG', '支氣管擴張劑'];
      _insertItems(batch, drugId, drugItems);

      // 6. Other
      final otherId = await into(ambulanceTreatmentCategories).insert(
        AmbulanceTreatmentCategoriesCompanion.insert(
          code: 'OTHER',
          name: '其它處置',
          sortOrder: const Value(6),
        ),
      );
      final otherItems = ['保暖', '心理支持', '約束帶', '拒絕氧氣', '監測', '其它'];
      _insertItems(batch, otherId, otherItems);
    });
  }

  void _insertItems(Batch batch, int catId, List<String> names) {
    for (var i = 0; i < names.length; i++) {
      batch.insert(
        ambulanceTreatmentItems,
        AmbulanceTreatmentItemsCompanion.insert(
          categoryId: catId,
          name: names[i],
          sortOrder: Value(i + 1),
          isOther: Value(names[i] == '其它'),
        ),
      );
    }
  }

  // --- Reference Getters ---

  Future<List<AmbulanceTreatmentCategoryData>> getCategories() {
    return (select(
      ambulanceTreatmentCategories,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  }

  Future<List<AmbulanceTreatmentItemData>> getItemsByCategory(int catId) {
    return (select(ambulanceTreatmentItems)
          ..where((t) => t.categoryId.equals(catId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  // Also provide a way to get items by category code if needed
  Future<List<AmbulanceTreatmentItemData>> getItemsByCategoryCode(
    String code,
  ) async {
    final cat = await (select(
      ambulanceTreatmentCategories,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
    if (cat == null) return [];
    return getItemsByCategory(cat.id);
  }

  // --- Record CRUD ---

  Future<AmbulanceTreatmentRecordData?> getRecord(int medicalId) {
    return (select(
      ambulanceTreatmentRecords,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // Create or Update Record
  Future<int> updateRecord(AmbulanceTreatmentRecordsCompanion companion) async {
    // Check if exists
    final medicalId = companion.medicalId.value;
    final existing = await getRecord(medicalId);

    if (existing != null) {
      await (update(
        ambulanceTreatmentRecords,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return existing.id;
    } else {
      return await into(ambulanceTreatmentRecords).insert(companion);
    }
  }

  // --- Item Links Management ---

  Future<List<AmbulanceTreatmentRecordItemData>> getRecordItems(int recordId) {
    return (select(
      ambulanceTreatmentRecordItems,
    )..where((t) => t.recordId.equals(recordId))).get();
  }

  // Get joined data (Item + Link Details)
  Future<List<JoinedTreatmentItem>> getJoinedRecordItems(int recordId) async {
    final query = select(ambulanceTreatmentRecordItems).join([
      innerJoin(
        ambulanceTreatmentItems,
        ambulanceTreatmentItems.id.equalsExp(
          ambulanceTreatmentRecordItems.itemId,
        ),
      ),
      innerJoin(
        ambulanceTreatmentCategories,
        ambulanceTreatmentCategories.id.equalsExp(
          ambulanceTreatmentItems.categoryId,
        ),
      ),
    ]);

    query.where(ambulanceTreatmentRecordItems.recordId.equals(recordId));

    final rows = await query.get();
    return rows.map((row) {
      return JoinedTreatmentItem(
        item: row.readTable(ambulanceTreatmentItems),
        link: row.readTable(ambulanceTreatmentRecordItems),
        category: row.readTable(ambulanceTreatmentCategories),
      );
    }).toList();
  }

  Future<void> addOrUpdateItemLink(
    AmbulanceTreatmentRecordItemsCompanion companion,
  ) async {
    // Check if link exists for this record and item
    final recordId = companion.recordId.value;
    final itemId = companion.itemId.value;

    final existing =
        await (select(ambulanceTreatmentRecordItems)..where(
              (t) => t.recordId.equals(recordId) & t.itemId.equals(itemId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (update(
        ambulanceTreatmentRecordItems,
      )..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      await into(ambulanceTreatmentRecordItems).insert(companion);
    }
  }

  Future<void> removeItemLink(int recordId, int itemId) async {
    await (delete(ambulanceTreatmentRecordItems)
          ..where((t) => t.recordId.equals(recordId) & t.itemId.equals(itemId)))
        .go();
  }

  // --- Medication Logs ---

  Future<List<AmbulanceMedicationLogData>> getMedicationLogs(int recordId) {
    return (select(ambulanceMedicationLogs)
          ..where((t) => t.recordId.equals(recordId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.time),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
  }

  Future<int> addMedicationLog(AmbulanceMedicationLogsCompanion companion) {
    return into(ambulanceMedicationLogs).insert(companion);
  }

  Future<void> deleteMedicationLog(int id) {
    return (delete(
      ambulanceMedicationLogs,
    )..where((t) => t.id.equals(id))).go();
  }

  // --- Vital Signs ---

  Future<List<AmbulanceVitalSignData>> getVitalSigns(int recordId) {
    return (select(ambulanceVitalSigns)
          ..where((t) => t.recordId.equals(recordId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.time),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
  }

  Future<int> addVitalSign(AmbulanceVitalSignsCompanion companion) {
    return into(ambulanceVitalSigns).insert(companion);
  }

  Future<void> updateVitalSign(AmbulanceVitalSignsCompanion companion) async {
    // Assuming id is present in companion for updates
    if (companion.id.present) {
      await (update(
        ambulanceVitalSigns,
      )..where((t) => t.id.equals(companion.id.value))).write(companion);
    }
  }

  Future<void> deleteVitalSign(int id) {
    return (delete(ambulanceVitalSigns)..where((t) => t.id.equals(id))).go();
  }

  // --- Escort Staff ---

  Future<List<AmbulanceEscortStaffData>> getEscortStaff(int recordId) {
    return (select(
      ambulanceEscortStaff,
    )..where((t) => t.recordId.equals(recordId))).get();
  }

  Future<int> addEscortStaff(AmbulanceEscortStaffCompanion companion) {
    return into(ambulanceEscortStaff).insert(companion);
  }

  Future<void> deleteEscortStaff(int id) {
    return (delete(ambulanceEscortStaff)..where((t) => t.id.equals(id))).go();
  }
}

class JoinedTreatmentItem {
  final AmbulanceTreatmentItemData item;
  final AmbulanceTreatmentRecordItemData link;
  final AmbulanceTreatmentCategoryData category;

  JoinedTreatmentItem({
    required this.item,
    required this.link,
    required this.category,
  });
}
