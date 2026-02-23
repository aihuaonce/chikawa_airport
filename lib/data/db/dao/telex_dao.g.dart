// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telex_dao.dart';

// ignore_for_file: type=lint
mixin _$TelexDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $StationRefTable get stationRef => attachedDatabase.stationRef;
  $TelexDocumentsTable get telexDocuments => attachedDatabase.telexDocuments;
  TelexDaoManager get managers => TelexDaoManager(this);
}

class TelexDaoManager {
  final _$TelexDaoMixin _db;
  TelexDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$StationRefTableTableManager get stationRef =>
      $$StationRefTableTableManager(_db.attachedDatabase, _db.stationRef);
  $$TelexDocumentsTableTableManager get telexDocuments =>
      $$TelexDocumentsTableTableManager(
        _db.attachedDatabase,
        _db.telexDocuments,
      );
}
