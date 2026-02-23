// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nursing_record_dao.dart';

// ignore_for_file: type=lint
mixin _$NursingRecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $MedicalStaffTable get medicalStaff => attachedDatabase.medicalStaff;
  $NursingRecordsTable get nursingRecords => attachedDatabase.nursingRecords;
  NursingRecordDaoManager get managers => NursingRecordDaoManager(this);
}

class NursingRecordDaoManager {
  final _$NursingRecordDaoMixin _db;
  NursingRecordDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$MedicalStaffTableTableManager get medicalStaff =>
      $$MedicalStaffTableTableManager(_db.attachedDatabase, _db.medicalStaff);
  $$NursingRecordsTableTableManager get nursingRecords =>
      $$NursingRecordsTableTableManager(
        _db.attachedDatabase,
        _db.nursingRecords,
      );
}
