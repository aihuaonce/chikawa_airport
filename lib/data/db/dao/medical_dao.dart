import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'medical_dao.g.dart';

@DriftAccessor(tables: [MedicalRecord, Patient])
class MedicalDao extends DatabaseAccessor<AppDatabase> with _$MedicalDaoMixin {
  MedicalDao(super.db);

  // 建立新的病患記錄，並回傳 medicalId
  Future<int> createNewPatientRecord() async {
    return transaction(() async {
      // 1. 建立醫療主表記錄
      final medicalId = await into(medicalRecord).insert(
        MedicalRecordCompanion.insert(
          isEmergency: const Value(false),
          hasAmbulance: const Value(false),
          syncStatus: const Value(1), // 待同步
        ),
      );

      // 2. 建立病患基本資料並關聯 ID
      await into(patient).insert(
        PatientCompanion.insert(
          medicalId: medicalId,
          syncStatus: const Value(1), // 待同步
        ),
      );

      return medicalId;
    });
  }

  Stream<List<MedicalRecordWithPatient>> watchAllRecords() {
    final query = select(medicalRecord).join([
      leftOuterJoin(
        patient,
        patient.medicalId.equalsExp(medicalRecord.medicalId),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return MedicalRecordWithPatient(
          row.readTable(medicalRecord),
          row.readTable(patient),
        );
      }).toList();
    });
  }

  // 出診單監聽總筆數
  Stream<int> watchTotalCount({
    bool? hasAmbulance,
    bool? isEmergency,
    String? searchKeyword,
  }) {
    final query = select(medicalRecord).join([
      leftOuterJoin(
        patient,
        patient.medicalId.equalsExp(medicalRecord.medicalId),
      ),
    ]);

    if (hasAmbulance != null) {
      query.where(medicalRecord.hasAmbulance.equals(hasAmbulance));
    }
    if (isEmergency != null) {
      query.where(medicalRecord.isEmergency.equals(isEmergency));
    }
    _applySearchFilter(query, searchKeyword);

    return query.watch().map((rows) => rows.length);
  }

  // 出診單分頁監聽記錄與病患資料
  Stream<List<MedicalRecordWithPatient>> watchRecordsPaginated(
    int limit,
    int offset, {
    bool? hasAmbulance,
    bool? isEmergency,
    String? searchKeyword,
  }) {
    final query = select(medicalRecord).join([
      leftOuterJoin(
        patient,
        patient.medicalId.equalsExp(medicalRecord.medicalId),
      ),
    ]);

    if (hasAmbulance != null) {
      query.where(medicalRecord.hasAmbulance.equals(hasAmbulance));
    }
    if (isEmergency != null) {
      query.where(medicalRecord.isEmergency.equals(isEmergency));
    }
    _applySearchFilter(query, searchKeyword);

    query
      ..limit(limit, offset: offset)
      ..orderBy([OrderingTerm.desc(medicalRecord.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return MedicalRecordWithPatient(
          row.readTable(medicalRecord),
          row.readTable(patient),
        );
      }).toList();
    });
  }

  void _applySearchFilter(
    JoinedSelectStatement<HasResultSet, dynamic> query,
    String? searchKeyword,
  ) {
    final keyword = searchKeyword?.trim();
    if (keyword == null || keyword.isEmpty) return;

    final pattern = '%$keyword%';
    query.where(
      patient.name.like(pattern) |
          patient.anonymizationName.like(pattern) |
          patient.passportOrIdNo.like(pattern) |
          patient.idNo.like(pattern) |
          patient.telephone.like(pattern),
    );
  }

  // 根據 medicalId 獲取病患資料
  Future<PatientData?> getPatientByMedicalId(int medicalId) {
    return (select(
      patient,
    )..where((tbl) => tbl.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 更新病患資料
  Future<bool> updatePatient(PatientData data) {
    return update(patient).replace(data);
  }

  // 更新病患資料的特定欄位
  Future<int> updatePatientColumn(int medicalId, PatientCompanion companion) {
    // 加入 syncStatus = 1 待同步
    final updatedCompanion = companion.copyWith(syncStatus: const Value(1));
    return (update(
      patient,
    )..where((tbl) => tbl.medicalId.equals(medicalId))).write(updatedCompanion);
  }

  // 根據 medicalId 獲取醫療主表記錄
  Future<MedicalRecordData?> getMedicalById(int medicalId) {
    return (select(
      medicalRecord,
    )..where((tbl) => tbl.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 取得總筆數
  Future<int> getTotalRecordsCount() {
    return medicalRecord.count().getSingle();
  }

  // 取得特定分頁的資料
  Future<List<MedicalRecordData>> getRecordsPaged(int limit, int offset) {
    return (select(medicalRecord)
          ..limit(limit, offset: offset)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 更新 CDC 篩檢狀態和篩檢方法（在 Medical 表中）
  Future<bool> updateCDCStatus({
    required int medicalId,
    required bool? cdcPassed,
    String? screeningMethod,
  }) {
    return (update(medicalRecord)
          ..where((tbl) => tbl.medicalId.equals(medicalId)))
        .write(
          MedicalRecordCompanion(
            cdcPassed: Value(cdcPassed),
            screeningMethod: Value(
              screeningMethod?.isEmpty ?? true ? null : screeningMethod,
            ),
            syncStatus: const Value(1), // 觸發 Firestore 同步
          ),
        )
        .then((count) => count > 0);
  }

  // 更新 MedicalRecord 的狀態 (Ambulance, Emergency)
  Future<bool> updateMedicalStatus(
    int medicalId, {
    bool? hasAmbulance,
    bool? isEmergency,
  }) {
    return (update(medicalRecord)
          ..where((tbl) => tbl.medicalId.equals(medicalId)))
        .write(
          MedicalRecordCompanion(
            hasAmbulance: hasAmbulance != null
                ? Value(hasAmbulance)
                : const Value.absent(),
            isEmergency: isEmergency != null
                ? Value(isEmergency)
                : const Value.absent(),
          ),
        )
        .then((count) => count > 0);
  }
}

// 首頁清單用
class MedicalRecordWithPatient {
  final MedicalRecordData record;
  final PatientData patient;
  MedicalRecordWithPatient(this.record, this.patient);
}
