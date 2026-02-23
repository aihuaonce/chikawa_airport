// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dao.dart';

// ignore_for_file: type=lint
mixin _$ContactDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $SexTable get sex => attachedDatabase.sex;
  $VisitReasonTable get visitReason => attachedDatabase.visitReason;
  $NationalityTable get nationality => attachedDatabase.nationality;
  $PatientTable get patient => attachedDatabase.patient;
  $ContactTable get contact => attachedDatabase.contact;
  ContactDaoManager get managers => ContactDaoManager(this);
}

class ContactDaoManager {
  final _$ContactDaoMixin _db;
  ContactDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$SexTableTableManager get sex =>
      $$SexTableTableManager(_db.attachedDatabase, _db.sex);
  $$VisitReasonTableTableManager get visitReason =>
      $$VisitReasonTableTableManager(_db.attachedDatabase, _db.visitReason);
  $$NationalityTableTableManager get nationality =>
      $$NationalityTableTableManager(_db.attachedDatabase, _db.nationality);
  $$PatientTableTableManager get patient =>
      $$PatientTableTableManager(_db.attachedDatabase, _db.patient);
  $$ContactTableTableManager get contact =>
      $$ContactTableTableManager(_db.attachedDatabase, _db.contact);
}
