// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_form_dao.dart';

// ignore_for_file: type=lint
mixin _$ReferralFormDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $ReferralPurposeTable get referralPurpose => attachedDatabase.referralPurpose;
  $RelationshipTypeTable get relationshipType =>
      attachedDatabase.relationshipType;
  $ReferralFormsTable get referralForms => attachedDatabase.referralForms;
  ReferralFormDaoManager get managers => ReferralFormDaoManager(this);
}

class ReferralFormDaoManager {
  final _$ReferralFormDaoMixin _db;
  ReferralFormDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$ReferralPurposeTableTableManager get referralPurpose =>
      $$ReferralPurposeTableTableManager(
        _db.attachedDatabase,
        _db.referralPurpose,
      );
  $$RelationshipTypeTableTableManager get relationshipType =>
      $$RelationshipTypeTableTableManager(
        _db.attachedDatabase,
        _db.relationshipType,
      );
  $$ReferralFormsTableTableManager get referralForms =>
      $$ReferralFormsTableTableManager(_db.attachedDatabase, _db.referralForms);
}
