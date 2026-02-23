// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_dao.dart';

// ignore_for_file: type=lint
mixin _$EmergencyDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $ConsciousnessLevelRefTable get consciousnessLevelRef =>
      attachedDatabase.consciousnessLevelRef;
  $PupilReactionRefTable get pupilReactionRef =>
      attachedDatabase.pupilReactionRef;
  $MedicalAssessmentTable get medicalAssessment =>
      attachedDatabase.medicalAssessment;
  $EmergencyTreatmentTable get emergencyTreatment =>
      attachedDatabase.emergencyTreatment;
  $FirstAidLogTable get firstAidLog => attachedDatabase.firstAidLog;
  $EmergencyAssistStaffTable get emergencyAssistStaff =>
      attachedDatabase.emergencyAssistStaff;
  EmergencyDaoManager get managers => EmergencyDaoManager(this);
}

class EmergencyDaoManager {
  final _$EmergencyDaoMixin _db;
  EmergencyDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
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
  $$EmergencyTreatmentTableTableManager get emergencyTreatment =>
      $$EmergencyTreatmentTableTableManager(
        _db.attachedDatabase,
        _db.emergencyTreatment,
      );
  $$FirstAidLogTableTableManager get firstAidLog =>
      $$FirstAidLogTableTableManager(_db.attachedDatabase, _db.firstAidLog);
  $$EmergencyAssistStaffTableTableManager get emergencyAssistStaff =>
      $$EmergencyAssistStaffTableTableManager(
        _db.attachedDatabase,
        _db.emergencyAssistStaff,
      );
}
