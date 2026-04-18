import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';
import '../tables/normalization_tables.dart';

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
    ChiefComplaintSymptomLinks,
    TreatmentActionLinks,
    SpecialNoteLinks,
    Medications,
  ],
)
class TreatmentDao extends DatabaseAccessor<AppDatabase>
    with _$TreatmentDaoMixin {
  TreatmentDao(super.db);

  // 藥物記錄 CRUD
  Future<int> insertMedication(MedicationsCompanion data) {
    return into(medications).insert(data);
  }

  Future<List<MedicationData>> getMedications(int medicalId) {
    return (select(
      medications,
    )..where((t) => t.medicalId.equals(medicalId))).get();
  }

  Future<bool> updateMedication(MedicationsCompanion data) {
    return update(medications).replace(data);
  }

  Future<int> deleteMedication(int medicationId) {
    return (delete(
      medications,
    )..where((t) => t.medicationId.equals(medicationId))).go();
  }

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

  Future<bool> updateHealthAssessment(HealthAssessmentFormCompanion data) {
    return update(healthAssessmentForm).replace(data);
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

  Future<int> updateChiefComplaint(ChiefComplaintCompanion data) {
    return update(chiefComplaint).write(data);
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

  Future<int> updateMedicalHistory(MedicalHistoryCompanion data) {
    return (update(
      medicalHistory,
    )..where((t) => t.historyId.equals(data.historyId.value))).write(data);
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
    // Treatment 表有 syncStatus，但 replace 方法無法直接設定
    // 需要在呼叫端確保 syncStatus=1
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

  Future<bool> updateStaffAssignment(MedicalStaffAssignmentCompanion data) {
    return update(medicalStaffAssignment).replace(data);
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

  // 主訴症狀關聯方法（取代 JSON 存儲）

  Future<List<int>> getChiefComplaintSymptomIds(int complaintId) async {
    final links = await (select(
      chiefComplaintSymptomLinks,
    )..where((l) => l.complaintId.equals(complaintId))).get();
    return links.map((l) => l.symptomId).toList();
  }

  Future<void> addChiefComplaintSymptom(int complaintId, int symptomId) async {
    await into(chiefComplaintSymptomLinks).insert(
      ChiefComplaintSymptomLinksCompanion.insert(
        complaintId: complaintId,
        symptomId: symptomId,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> removeChiefComplaintSymptom(
    int complaintId,
    int symptomId,
  ) async {
    await (delete(chiefComplaintSymptomLinks)..where(
          (l) =>
              l.complaintId.equals(complaintId) & l.symptomId.equals(symptomId),
        ))
        .go();
  }

  Future<void> toggleChiefComplaintSymptom(
    int complaintId,
    int symptomId,
  ) async {
    final exists =
        await (select(chiefComplaintSymptomLinks)..where(
              (l) =>
                  l.complaintId.equals(complaintId) &
                  l.symptomId.equals(symptomId),
            ))
            .getSingleOrNull();
    if (exists != null) {
      await removeChiefComplaintSymptom(complaintId, symptomId);
    } else {
      await addChiefComplaintSymptom(complaintId, symptomId);
    }
    // 更新 syncStatus 觸發 Firestore 同步
    await (update(chiefComplaint)
          ..where((t) => t.complaintId.equals(complaintId)))
        .write(ChiefComplaintCompanion(syncStatus: const Value(1)));
  }

  Future<void> clearChiefComplaintSymptoms(int complaintId) async {
    await (delete(
      chiefComplaintSymptomLinks,
    )..where((l) => l.complaintId.equals(complaintId))).go();
  }

  // 處置項目關聯方法（取代 JSON 存儲）

  Future<List<int>> getTreatmentActionIds(int treatmentId) async {
    final links = await (select(
      treatmentActionLinks,
    )..where((l) => l.treatmentId.equals(treatmentId))).get();
    return links.map((l) => l.actionItemId).toList();
  }

  Future<void> addTreatmentAction(int treatmentId, int actionItemId) async {
    await into(treatmentActionLinks).insert(
      TreatmentActionLinksCompanion.insert(
        treatmentId: treatmentId,
        actionItemId: actionItemId,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> removeTreatmentAction(int treatmentId, int actionItemId) async {
    await (delete(treatmentActionLinks)..where(
          (l) =>
              l.treatmentId.equals(treatmentId) &
              l.actionItemId.equals(actionItemId),
        ))
        .go();
  }

  Future<void> toggleTreatmentAction(int treatmentId, int actionItemId) async {
    final exists =
        await (select(treatmentActionLinks)..where(
              (l) =>
                  l.treatmentId.equals(treatmentId) &
                  l.actionItemId.equals(actionItemId),
            ))
            .getSingleOrNull();
    if (exists != null) {
      await removeTreatmentAction(treatmentId, actionItemId);
    } else {
      await addTreatmentAction(treatmentId, actionItemId);
    }
  }

  Future<void> clearTreatmentActions(int treatmentId) async {
    await (delete(
      treatmentActionLinks,
    )..where((l) => l.treatmentId.equals(treatmentId))).go();
  }

  // 特別註記關聯方法（取代 JSON 存儲）

  Future<List<int>> getSpecialNoteIds(int noteId) async {
    final links = await (select(
      specialNoteLinks,
    )..where((l) => l.noteId.equals(noteId))).get();
    return links.map((l) => l.noteRefId).toList();
  }

  Future<void> addSpecialNote(int noteId, int noteRefId) async {
    await into(specialNoteLinks).insert(
      SpecialNoteLinksCompanion.insert(noteId: noteId, noteRefId: noteRefId),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> removeSpecialNote(int noteId, int noteRefId) async {
    await (delete(specialNoteLinks)..where(
          (l) => l.noteId.equals(noteId) & l.noteRefId.equals(noteRefId),
        ))
        .go();
  }

  Future<void> toggleSpecialNote(int noteId, int noteRefId) async {
    final exists =
        await (select(specialNoteLinks)..where(
              (l) => l.noteId.equals(noteId) & l.noteRefId.equals(noteRefId),
            ))
            .getSingleOrNull();
    if (exists != null) {
      await removeSpecialNote(noteId, noteRefId);
    } else {
      await addSpecialNote(noteId, noteRefId);
    }
  }

  Future<void> clearSpecialNotes(int noteId) async {
    await (delete(
      specialNoteLinks,
    )..where((l) => l.noteId.equals(noteId))).go();
  }
}
