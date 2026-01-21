import 'package:drift/drift.dart';
import '../database.dart'; // 導入你的資料庫定義
import '../tables/medical_tables.dart';

part 'medical_dao.g.dart'; // Drift 會自動生成

@DriftAccessor(tables: [MedicalRecord, Patient])
class MedicalDao extends DatabaseAccessor<AppDatabase> with _$MedicalDaoMixin {
  // 建構子
  MedicalDao(AppDatabase db) : super(db);

  // 將剛才的新增邏輯搬到這裡
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
}
