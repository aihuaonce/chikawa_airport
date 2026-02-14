import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'emergency_dao.g.dart';

@DriftAccessor(
  tables: [
    EmergencyTreatment,
    FirstAidLog,
    EmergencyAssistStaff,
    MedicalAssessment,
    MedicalRecord,
  ],
)
class EmergencyDao extends DatabaseAccessor<AppDatabase>
    with _$EmergencyDaoMixin {
  EmergencyDao(super.db);

  // 獲取或創建急救處置記錄
  Future<EmergencyTreatmentData> getOrCreateEmergencyTreatment(
    int medicalId,
  ) async {
    final existing = await (select(
      emergencyTreatment,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();

    if (existing != null) {
      return existing;
    }

    // 如果不存在，則創建
    final id = await into(emergencyTreatment).insert(
      EmergencyTreatmentCompanion(
        medicalId: Value(medicalId),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return (select(
      emergencyTreatment,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  // 更新急救處置記錄 (使用 write 進行部分更新)
  Future<int> updateEmergencyTreatment(EmergencyTreatmentCompanion companion) {
    return (update(
      emergencyTreatment,
    )..where((t) => t.id.equals(companion.id.value))).write(companion);
  }

  // 獲取最新的醫療評估 (By medicalId)
  Future<MedicalAssessmentData?> getLatestAssessment(int medicalId) {
    return (select(medicalAssessment)
          ..where((t) => t.medicalId.equals(medicalId))
          ..orderBy([(t) => OrderingTerm.desc(t.assessmentId)])
          ..limit(1))
        .getSingleOrNull();
  }

  // 獲取或創建關聯的醫療評估 (Initial 或 Post)
  Future<MedicalAssessmentData> getOrCreateAssessment(
    int? assessmentId,
    int medicalId,
  ) async {
    if (assessmentId != null) {
      final existing = await (select(
        medicalAssessment,
      )..where((t) => t.assessmentId.equals(assessmentId))).getSingleOrNull();
      if (existing != null) return existing;
    }

    // 創建新的評估記錄
    final newId = await into(medicalAssessment).insert(
      MedicalAssessmentCompanion(
        medicalId: Value(medicalId),
        assessmentTime: Value(DateTime.now()),
      ),
    );

    return (select(
      medicalAssessment,
    )..where((t) => t.assessmentId.equals(newId))).getSingle();
  }

  // 更新醫療評估 (使用 write 進行部分更新)
  Future<int> updateAssessment(MedicalAssessmentCompanion companion) {
    return (update(medicalAssessment)
          ..where((t) => t.assessmentId.equals(companion.assessmentId.value)))
        .write(companion);
  }

  // 獲取急救藥物記錄
  Future<List<FirstAidLogData>> getFirstAidLogs(int emergencyTreatmentId) {
    return (select(firstAidLog)
          ..where((t) => t.emergencyTreatmentId.equals(emergencyTreatmentId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  // 新增急救藥物記錄
  Future<int> addFirstAidLog(FirstAidLogCompanion companion) {
    return into(firstAidLog).insert(companion);
  }

  // 刪除急救藥物記錄
  Future<int> deleteFirstAidLog(int id) {
    return (delete(firstAidLog)..where((t) => t.id.equals(id))).go();
  }

  // 獲取協助人員列表
  Future<List<EmergencyAssistStaffData>> getAssistStaff(
    int emergencyTreatmentId,
  ) {
    return (select(
      emergencyAssistStaff,
    )..where((t) => t.emergencyTreatmentId.equals(emergencyTreatmentId))).get();
  }

  // 新增協助人員
  Future<int> addAssistStaff(EmergencyAssistStaffCompanion companion) {
    return into(emergencyAssistStaff).insert(companion);
  }

  // 刪除協助人員
  Future<int> deleteAssistStaff(int id) {
    return (delete(emergencyAssistStaff)..where((t) => t.id.equals(id))).go();
  }
}
