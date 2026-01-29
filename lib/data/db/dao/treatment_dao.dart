import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'treatment_dao.g.dart';

@DriftAccessor(
  tables: [
    HealthAssessmentForm,
    ChiefComplaint,
    MedicalMedia,
    MedicalAssessment,
    MedicalHistory,
    Treatment,
    MedicalStaffAssignment,
    SpecialNotes,
  ],
)
class TreatmentDao extends DatabaseAccessor<AppDatabase>
    with _$TreatmentDaoMixin {
  TreatmentDao(super.db);

  // CDC 健康評估

  Future<int> insertHealthAssessment(HealthAssessmentFormCompanion data) {
    return into(healthAssessmentForm).insert(data);
  }

  Future<List<HealthAssessmentFormData>> getHealthAssessments(int medicalId) {
    return (select(
      healthAssessmentForm,
    )..where((t) => t.medicalId.equals(medicalId))).get();
  }

  Future<int> deleteHealthAssessment(int assessmentId) {
    return (delete(
      healthAssessmentForm,
    )..where((t) => t.assessmentFormId.equals(assessmentId))).go();
  }

  // 主訴

  Future<int> insertChiefComplaint(ChiefComplaintCompanion data) {
    return into(chiefComplaint).insert(data);
  }

  Future<ChiefComplaintData?> getChiefComplaint(int medicalId) {
    return (select(
      chiefComplaint,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  Future<bool> updateChiefComplaint(ChiefComplaintCompanion data) {
    return update(chiefComplaint).replace(data);
  }

  // 醫療影像

  Future<int> insertMedicalMedia(MedicalMediaCompanion data) {
    return into(medicalMedia).insert(data);
  }

  Future<List<MedicalMediaData>> getMedicalMediaList(int medicalId) {
    return (select(
      medicalMedia,
    )..where((t) => t.medicalId.equals(medicalId))).get();
  }

  Future<int> deleteMedicalMedia(int mediaId) {
    return (delete(medicalMedia)..where((t) => t.mediaId.equals(mediaId))).go();
  }

  // 醫療評估（可多筆）

  Future<int> insertMedicalAssessment(MedicalAssessmentCompanion data) {
    return into(medicalAssessment).insert(data);
  }

  Future<List<MedicalAssessmentData>> getMedicalAssessments(int medicalId) {
    return (select(medicalAssessment)
          ..where((t) => t.medicalId.equals(medicalId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.assessmentTime,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  // 病史

  Future<int> insertMedicalHistory(MedicalHistoryCompanion data) {
    return into(medicalHistory).insert(data);
  }

  Future<MedicalHistoryData?> getMedicalHistory(int medicalId) {
    return (select(
      medicalHistory,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  Future<bool> updateMedicalHistory(MedicalHistoryCompanion data) {
    return update(medicalHistory).replace(data);
  }

  // 處置 / 診斷

  Future<int> insertTreatment(TreatmentCompanion data) {
    return into(treatment).insert(data);
  }

  Future<TreatmentData?> getTreatment(int medicalId) {
    return (select(
      treatment,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  Future<bool> updateTreatment(TreatmentCompanion data) {
    return update(treatment).replace(data);
  }

  // 醫療人員指派

  Future<int> insertStaffAssignment(MedicalStaffAssignmentCompanion data) {
    return into(medicalStaffAssignment).insert(data);
  }

  Future<List<MedicalStaffAssignmentData>> getStaffAssignments(int medicalId) {
    return (select(
      medicalStaffAssignment,
    )..where((t) => t.medicalId.equals(medicalId))).get();
  }

  Future<int> deleteStaffAssignment(int staffAssignmentId) {
    return (delete(
      medicalStaffAssignment,
    )..where((t) => t.staffAssignmentId.equals(staffAssignmentId))).go();
  }

  // 特別註記

  Future<int> insertSpecialNotes(SpecialNotesCompanion data) {
    return into(specialNotes).insert(data);
  }

  Future<SpecialNotesData?> getSpecialNotes(int medicalId) {
    return (select(
      specialNotes,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  Future<bool> updateSpecialNotes(SpecialNotesCompanion data) {
    return update(specialNotes).replace(data);
  }

  // 整包刪除（某次醫療紀錄的全部處置）

  Future<void> deleteAllTreatmentData(int medicalId) async {
    await (delete(
      healthAssessmentForm,
    )..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(
      chiefComplaint,
    )..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(
      medicalMedia,
    )..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(
      medicalAssessment,
    )..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(
      medicalHistory,
    )..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(treatment)..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(
      medicalStaffAssignment,
    )..where((t) => t.medicalId.equals(medicalId))).go();

    await (delete(
      specialNotes,
    )..where((t) => t.medicalId.equals(medicalId))).go();
  }
}
