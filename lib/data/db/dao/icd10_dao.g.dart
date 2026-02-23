// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icd10_dao.dart';

// ignore_for_file: type=lint
mixin _$Icd10DaoMixin on DatabaseAccessor<AppDatabase> {
  $Icd10CodeTable get icd10Code => attachedDatabase.icd10Code;
  Icd10DaoManager get managers => Icd10DaoManager(this);
}

class Icd10DaoManager {
  final _$Icd10DaoMixin _db;
  Icd10DaoManager(this._db);
  $$Icd10CodeTableTableManager get icd10Code =>
      $$Icd10CodeTableTableManager(_db.attachedDatabase, _db.icd10Code);
}
