// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_fee_dao.dart';

// ignore_for_file: type=lint
mixin _$MedicalFeeDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $PaymentMethodTable get paymentMethod => attachedDatabase.paymentMethod;
  $CurrencyRefTable get currencyRef => attachedDatabase.currencyRef;
  $CollectionStatusTable get collectionStatus =>
      attachedDatabase.collectionStatus;
  $MedicalFeesTable get medicalFees => attachedDatabase.medicalFees;
  MedicalFeeDaoManager get managers => MedicalFeeDaoManager(this);
}

class MedicalFeeDaoManager {
  final _$MedicalFeeDaoMixin _db;
  MedicalFeeDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$PaymentMethodTableTableManager get paymentMethod =>
      $$PaymentMethodTableTableManager(_db.attachedDatabase, _db.paymentMethod);
  $$CurrencyRefTableTableManager get currencyRef =>
      $$CurrencyRefTableTableManager(_db.attachedDatabase, _db.currencyRef);
  $$CollectionStatusTableTableManager get collectionStatus =>
      $$CollectionStatusTableTableManager(
        _db.attachedDatabase,
        _db.collectionStatus,
      );
  $$MedicalFeesTableTableManager get medicalFees =>
      $$MedicalFeesTableTableManager(_db.attachedDatabase, _db.medicalFees);
}
