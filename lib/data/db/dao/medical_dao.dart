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
        ),
      );

      // 2. 建立病患基本資料並關聯 ID
      await into(patient).insert(PatientCompanion.insert(medicalId: medicalId));

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
    return (update(
      patient,
    )..where((tbl) => tbl.medicalId.equals(medicalId))).write(companion);
  }

  // 根據 medicalId 獲取醫療主表記錄
  Future<MedicalRecordData?> getMedicalById(int medicalId) {
    return (select(
      medicalRecord,
    )..where((tbl) => tbl.medicalId.equals(medicalId))).getSingleOrNull();
  }
}

// 首頁清單用
class MedicalRecordWithPatient {
  final MedicalRecordData record;
  final PatientData patient;
  MedicalRecordWithPatient(this.record, this.patient);
}
