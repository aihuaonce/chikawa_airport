import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/ambulance_tables.dart';
import '../tables/ambulance_scene_tables.dart';
import '../tables/reference_tables.dart';
import '../tables/medical_tables.dart';

part 'ambulance_dao.g.dart';

@DriftAccessor(
  tables: [
    AmbulanceRecords,
    AmbulancePersonalProperty,
    AmbulanceFees,
    AmbulanceSceneRecords,
    AmbulanceReferenceItems,
    AmbulanceSceneItemLinks,
    IncidentPlaceCategory,
    IncidentPlaceCategory2,
    ReferralHospital,
    IncidentRecord,
    ReferralForms,
    Treatment,
  ],
)
class AmbulanceDao extends DatabaseAccessor<AppDatabase>
    with _$AmbulanceDaoMixin {
  AmbulanceDao(super.db);

  // --- 救護車現場紀錄相關 (AmbulanceSceneRecords) ---

  // 取得現場紀錄
  Future<AmbulanceSceneRecordData?> getSceneRecord(int medicalId) {
    return (select(
      ambulanceSceneRecords,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立或更新現場紀錄
  Future<int> updateSceneRecord(AmbulanceSceneRecordsCompanion data) async {
    final existing =
        await (select(ambulanceSceneRecords)
              ..where((t) => t.medicalId.equals(data.medicalId.value)))
            .getSingleOrNull();

    if (existing != null) {
      await (update(
        ambulanceSceneRecords,
      )..where((t) => t.medicalId.equals(data.medicalId.value))).write(data);
      return existing.id;
    } else {
      return into(ambulanceSceneRecords).insert(data);
    }
  }

  // --- 參考選項相關 (AmbulanceReferenceItems) ---

  // 根據類別取得選項
  Future<List<AmbulanceReferenceItemData>> getReferenceItemsByCategory(
    String category,
  ) {
    return (select(ambulanceReferenceItems)
          ..where((t) => t.category.equals(category))
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  // 取得已選取的選項 ID
  Future<List<int>> getSelectedLinkIds(
    int sceneRecordId,
    String category,
  ) async {
    final query = select(ambulanceSceneItemLinks).join([
      innerJoin(
        ambulanceReferenceItems,
        ambulanceReferenceItems.id.equalsExp(ambulanceSceneItemLinks.itemId),
      ),
    ]);

    query.where(ambulanceSceneItemLinks.sceneRecordId.equals(sceneRecordId));
    query.where(ambulanceReferenceItems.category.equals(category));

    final result = await query.get();
    return result
        .map((row) => row.readTable(ambulanceReferenceItems).id)
        .toList();
  }

  // 取得已選取的選項名稱 (UI顯示用)
  Future<List<String>> getSelectedLinkNames(
    int sceneRecordId,
    String category,
  ) async {
    final query = select(ambulanceSceneItemLinks).join([
      innerJoin(
        ambulanceReferenceItems,
        ambulanceReferenceItems.id.equalsExp(ambulanceSceneItemLinks.itemId),
      ),
    ]);

    query.where(ambulanceSceneItemLinks.sceneRecordId.equals(sceneRecordId));
    query.where(ambulanceReferenceItems.category.equals(category));

    final result = await query.get();
    return result
        .map((row) => row.readTable(ambulanceReferenceItems).name)
        .toList();
  }

  // 更新選取的選項 (全刪全加模式)
  Future<void> updateSelectedLinks(
    int sceneRecordId,
    String category,
    List<String> selectedNames,
  ) async {
    await transaction(() async {
      // 1. 找出該類別的所有 Item ID
      final allItems = await getReferenceItemsByCategory(category);
      final nameToIdMap = {for (var item in allItems) item.name: item.id};

      // 2. 刪除該 SceneRecord 下，屬於該 Category 的所有連結
      // 由於 Drift delete join 比較複雜，這裡先查詢出要刪除的 Link IDs
      final linksToDelete =
          await (select(ambulanceSceneItemLinks).join([
                  innerJoin(
                    ambulanceReferenceItems,
                    ambulanceReferenceItems.id.equalsExp(
                      ambulanceSceneItemLinks.itemId,
                    ),
                  ),
                ])
                ..where(
                  ambulanceSceneItemLinks.sceneRecordId.equals(sceneRecordId),
                )
                ..where(ambulanceReferenceItems.category.equals(category)))
              .map((row) => row.readTable(ambulanceSceneItemLinks).id)
              .get();

      if (linksToDelete.isNotEmpty) {
        await (delete(
          ambulanceSceneItemLinks,
        )..where((t) => t.id.isIn(linksToDelete))).go();
      }

      // 3. 插入新的連結
      for (final name in selectedNames) {
        final itemId = nameToIdMap[name];
        if (itemId != null) {
          await into(ambulanceSceneItemLinks).insert(
            AmbulanceSceneItemLinksCompanion(
              sceneRecordId: Value(sceneRecordId),
              itemId: Value(itemId),
            ),
          );
        }
      }
    });
  }

  // 初始化參考資料
  Future<void> initializeAmbulanceReferenceData() async {
    final count = await (select(
      ambulanceReferenceItems,
    ).get()).then((list) => list.length);
    if (count > 0) return;

    // 定義初始資料
    final data = <String, List<String>>{
      'TraumaGroup': [
        '一般外傷',
        '受傷機轉',
        '溺水',
        '摔跌傷',
        '墜落傷',
        '穿刺傷',
        '燒燙傷',
        '電擊傷',
        '生物咬螫傷',
        '到院前心肺功能停止',
        '其它',
      ],
      'GeneralTrauma': ['頸部外傷', '胸部外傷', '腹部外傷', '背部外傷', '肢體外傷', '其它'],
      'Mechanism': ['因交通事故', '非交通事故'],
      'NonTraumaGroup': ['急症', '一般疾病'],
      'Acute': [
        '呼吸問題(喘)',
        '呼吸道問題',
        '昏迷',
        '胸痛/胸悶',
        '腹痛',
        '中毒',
        '癲癇',
        '路倒',
        '精神異常',
        '孕婦急產',
        'OHCA',
        '其它',
      ],
      'GeneralDisease': ['頭痛/頭暈', '昏倒/昏厥', '發燒', '噁心/嘔吐', '肢體無力'],
      'Allergy': ['食物', '藥物', '其它'],
      'History': ['高血壓', '糖尿病', '氣喘', '心臟疾病', '其它'],
    };

    await batch((batch) {
      data.forEach((category, items) {
        for (var i = 0; i < items.length; i++) {
          batch.insert(
            ambulanceReferenceItems,
            AmbulanceReferenceItemsCompanion.insert(
              category: category,
              name: items[i],
              sortOrder: Value(i + 1),
            ),
          );
        }
      });
    });
  }

  // 取得救護車紀錄
  Future<AmbulanceRecord?> getAmbulanceRecord(int id) {
    return (select(
      ambulanceRecords,
    )..where((t) => t.ambulanceId.equals(id))).getSingleOrNull();
  }

  // 透過 medicalId 取得救護車紀錄 (如果有的話)
  Future<AmbulanceRecord?> getAmbulanceRecordByMedicalId(int medicalId) {
    return (select(
      ambulanceRecords,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 取得個人財物紀錄
  Future<AmbulancePersonalPropertyData?> getPersonalProperty(int medicalId) {
    return (select(
      ambulancePersonalProperty,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 更新個人財物紀錄
  Future<int> updatePersonalProperty(
    AmbulancePersonalPropertyCompanion data,
  ) async {
    // 檢查是否已存在
    final existing =
        await (select(ambulancePersonalProperty)
              ..where((t) => t.medicalId.equals(data.medicalId.value)))
            .getSingleOrNull();

    if (existing != null) {
      // 如果存在，執行更新
      await (update(
        ambulancePersonalProperty,
      )..where((t) => t.medicalId.equals(data.medicalId.value))).write(data);
      return existing.id;
    } else {
      // 如果不存在，執行插入
      return into(ambulancePersonalProperty).insert(data);
    }
  }

  // --- 救護車收費相關 ---

  // 取得救護車收費紀錄
  Future<AmbulanceFeeData?> getAmbulanceFee(int medicalId) {
    return (select(
      ambulanceFees,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 更新救護車收費紀錄
  Future<int> updateAmbulanceFee(AmbulanceFeesCompanion data) async {
    // 檢查是否已存在
    final existing =
        await (select(ambulanceFees)
              ..where((t) => t.medicalId.equals(data.medicalId.value)))
            .getSingleOrNull();

    if (existing != null) {
      // 如果存在，執行更新
      await (update(
        ambulanceFees,
      )..where((t) => t.medicalId.equals(data.medicalId.value))).write(data);
      return existing.feeId;
    } else {
      // 如果不存在，執行插入
      return into(ambulanceFees).insert(data);
    }
  }

  // 建立救護車紀錄
  Future<int> createAmbulanceRecord(AmbulanceRecordsCompanion data) {
    return into(ambulanceRecords).insert(data);
  }

  // 更新救護車紀錄
  Future<bool> updateAmbulanceRecord(AmbulanceRecordsCompanion data) {
    return update(ambulanceRecords).replace(data);
  }

  // 插入或更新
  Future<int> insertOrUpdateAmbulanceRecord(
    AmbulanceRecordsCompanion data,
  ) async {
    return into(ambulanceRecords).insertOnConflictUpdate(data);
  }

  // 取得地點列表
  Future<List<IncidentPlaceCategoryData>> getIncidentLocations() {
    return (select(
      incidentPlaceCategory,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }

  // 搜尋地點
  Future<List<IncidentPlaceCategoryData>> searchIncidentLocations(
    String query,
  ) {
    return (select(incidentPlaceCategory)
          ..where((t) => t.name.contains(query))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  // 取得二級地點列表
  Future<List<IncidentPlaceCategory2Data>> getIncidentLocation2s(
    int categoryId,
  ) {
    return (select(incidentPlaceCategory2)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  // 搜尋二級地點
  Future<List<IncidentPlaceCategory2Data>> searchIncidentLocation2s(
    String query,
    int? categoryId,
  ) {
    var stmt = select(incidentPlaceCategory2)
      ..where((t) => t.name.contains(query));

    if (categoryId != null) {
      stmt = stmt..where((t) => t.categoryId.equals(categoryId));
    }

    return (stmt..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  // 取得醫院列表
  Future<List<ReferralHospitalData>> getHospitals() {
    return (select(
      referralHospital,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }

  // 搜尋醫院
  Future<List<ReferralHospitalData>> searchHospitals(String query) {
    return (select(referralHospital)
          ..where((t) => t.name.contains(query))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  // 取得相關 IncidentRecord
  Future<IncidentRecordData?> getIncidentRecordByMedicalId(int medicalId) {
    return (select(
      incidentRecord,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 取得相關 ReferralForm
  Future<ReferralFormData?> getReferralFormByMedicalId(int medicalId) {
    return (select(
      referralForms,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 取得相關 Treatment
  Future<TreatmentData?> getTreatmentByMedicalId(int medicalId) {
    return (select(
      treatment,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // --- 人形圖相關 ---

  // 取得人形圖 JSON
  Future<String?> getBodyMap(int medicalId) async {
    final record = await (select(
      ambulanceRecords,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
    return record?.bodyMapJson;
  }

  // 更新人形圖 JSON
  Future<void> updateBodyMap(int medicalId, String? bodyMapJson) async {
    // 檢查記錄是否存在
    final existing = await (select(
      ambulanceRecords,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();

    if (existing != null) {
      // 記錄存在，正常更新
      await (update(
        ambulanceRecords,
      )..where((t) => t.medicalId.equals(medicalId))).write(
        AmbulanceRecordsCompanion(
          bodyMapJson: Value(bodyMapJson),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // 記錄不存在，先建立新記錄
      await into(ambulanceRecords).insert(
        AmbulanceRecordsCompanion.insert(
          medicalId: Value(medicalId),
          bodyMapJson: Value(bodyMapJson),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(1), // 待同步
        ),
      );
    }
  }

  // 確保救護車記錄存在
  Future<void> ensureAmbulanceRecord(int medicalId) async {
    final existing = await (select(
      ambulanceRecords,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();

    if (existing == null) {
      await into(ambulanceRecords).insert(
        AmbulanceRecordsCompanion.insert(
          medicalId: Value(medicalId),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(1), // 待同步
        ),
      );
    }
  }
}
