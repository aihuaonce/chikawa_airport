// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_dao.dart';

// ignore_for_file: type=lint
mixin _$TreatmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $HealthAssessmentFormTable get healthAssessmentForm =>
      attachedDatabase.healthAssessmentForm;
  $ChiefComplaintTable get chiefComplaint => attachedDatabase.chiefComplaint;
  $MedicalMediaTable get medicalMedia => attachedDatabase.medicalMedia;
  $ConsciousnessLevelRefTable get consciousnessLevelRef =>
      attachedDatabase.consciousnessLevelRef;
  $PupilReactionRefTable get pupilReactionRef =>
      attachedDatabase.pupilReactionRef;
  $MedicalAssessmentTable get medicalAssessment =>
      attachedDatabase.medicalAssessment;
  $HistoryStatusRefTable get historyStatusRef =>
      attachedDatabase.historyStatusRef;
  $MedicalHistoryTable get medicalHistory => attachedDatabase.medicalHistory;
  $MedicalStaffTable get medicalStaff => attachedDatabase.medicalStaff;
  $TreatmentTable get treatment => attachedDatabase.treatment;
  $MedicalStaffRoleTable get medicalStaffRole =>
      attachedDatabase.medicalStaffRole;
  $MedicalStaffAssignmentTable get medicalStaffAssignment =>
      attachedDatabase.medicalStaffAssignment;
  $SpecialNotesTable get specialNotes => attachedDatabase.specialNotes;
  $ChiefComplaintTypeTable get chiefComplaintType =>
      attachedDatabase.chiefComplaintType;
  $ChiefComplaintDetailTable get chiefComplaintDetail =>
      attachedDatabase.chiefComplaintDetail;
  $ChiefComplaintSymptomLinksTable get chiefComplaintSymptomLinks =>
      attachedDatabase.chiefComplaintSymptomLinks;
  $ActionItemTable get actionItem => attachedDatabase.actionItem;
  $TreatmentActionLinksTable get treatmentActionLinks =>
      attachedDatabase.treatmentActionLinks;
  $SpecialNoteRefTable get specialNoteRef => attachedDatabase.specialNoteRef;
  $SpecialNoteLinksTable get specialNoteLinks =>
      attachedDatabase.specialNoteLinks;
  $MedicationsTable get medications => attachedDatabase.medications;
  TreatmentDaoManager get managers => TreatmentDaoManager(this);
}

class TreatmentDaoManager {
  final _$TreatmentDaoMixin _db;
  TreatmentDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$HealthAssessmentFormTableTableManager get healthAssessmentForm =>
      $$HealthAssessmentFormTableTableManager(
        _db.attachedDatabase,
        _db.healthAssessmentForm,
      );
  $$ChiefComplaintTableTableManager get chiefComplaint =>
      $$ChiefComplaintTableTableManager(
        _db.attachedDatabase,
        _db.chiefComplaint,
      );
  $$MedicalMediaTableTableManager get medicalMedia =>
      $$MedicalMediaTableTableManager(_db.attachedDatabase, _db.medicalMedia);
  $$ConsciousnessLevelRefTableTableManager get consciousnessLevelRef =>
      $$ConsciousnessLevelRefTableTableManager(
        _db.attachedDatabase,
        _db.consciousnessLevelRef,
      );
  $$PupilReactionRefTableTableManager get pupilReactionRef =>
      $$PupilReactionRefTableTableManager(
        _db.attachedDatabase,
        _db.pupilReactionRef,
      );
  $$MedicalAssessmentTableTableManager get medicalAssessment =>
      $$MedicalAssessmentTableTableManager(
        _db.attachedDatabase,
        _db.medicalAssessment,
      );
  $$HistoryStatusRefTableTableManager get historyStatusRef =>
      $$HistoryStatusRefTableTableManager(
        _db.attachedDatabase,
        _db.historyStatusRef,
      );
  $$MedicalHistoryTableTableManager get medicalHistory =>
      $$MedicalHistoryTableTableManager(
        _db.attachedDatabase,
        _db.medicalHistory,
      );
  $$MedicalStaffTableTableManager get medicalStaff =>
      $$MedicalStaffTableTableManager(_db.attachedDatabase, _db.medicalStaff);
  $$TreatmentTableTableManager get treatment =>
      $$TreatmentTableTableManager(_db.attachedDatabase, _db.treatment);
  $$MedicalStaffRoleTableTableManager get medicalStaffRole =>
      $$MedicalStaffRoleTableTableManager(
        _db.attachedDatabase,
        _db.medicalStaffRole,
      );
  $$MedicalStaffAssignmentTableTableManager get medicalStaffAssignment =>
      $$MedicalStaffAssignmentTableTableManager(
        _db.attachedDatabase,
        _db.medicalStaffAssignment,
      );
  $$SpecialNotesTableTableManager get specialNotes =>
      $$SpecialNotesTableTableManager(_db.attachedDatabase, _db.specialNotes);
  $$ChiefComplaintTypeTableTableManager get chiefComplaintType =>
      $$ChiefComplaintTypeTableTableManager(
        _db.attachedDatabase,
        _db.chiefComplaintType,
      );
  $$ChiefComplaintDetailTableTableManager get chiefComplaintDetail =>
      $$ChiefComplaintDetailTableTableManager(
        _db.attachedDatabase,
        _db.chiefComplaintDetail,
      );
  $$ChiefComplaintSymptomLinksTableTableManager
  get chiefComplaintSymptomLinks =>
      $$ChiefComplaintSymptomLinksTableTableManager(
        _db.attachedDatabase,
        _db.chiefComplaintSymptomLinks,
      );
  $$ActionItemTableTableManager get actionItem =>
      $$ActionItemTableTableManager(_db.attachedDatabase, _db.actionItem);
  $$TreatmentActionLinksTableTableManager get treatmentActionLinks =>
      $$TreatmentActionLinksTableTableManager(
        _db.attachedDatabase,
        _db.treatmentActionLinks,
      );
  $$SpecialNoteRefTableTableManager get specialNoteRef =>
      $$SpecialNoteRefTableTableManager(
        _db.attachedDatabase,
        _db.specialNoteRef,
      );
  $$SpecialNoteLinksTableTableManager get specialNoteLinks =>
      $$SpecialNoteLinksTableTableManager(
        _db.attachedDatabase,
        _db.specialNoteLinks,
      );
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db.attachedDatabase, _db.medications);
}
