// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_dao.dart';

// ignore_for_file: type=lint
mixin _$IncidentDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $IncidentPlaceCategoryTable get incidentPlaceCategory =>
      attachedDatabase.incidentPlaceCategory;
  $IncidentPlaceCategory2Table get incidentPlaceCategory2 =>
      attachedDatabase.incidentPlaceCategory2;
  $ReportingUnitTable get reportingUnit => attachedDatabase.reportingUnit;
  $IncidentRecordTable get incidentRecord => attachedDatabase.incidentRecord;
  IncidentDaoManager get managers => IncidentDaoManager(this);
}

class IncidentDaoManager {
  final _$IncidentDaoMixin _db;
  IncidentDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$IncidentPlaceCategoryTableTableManager get incidentPlaceCategory =>
      $$IncidentPlaceCategoryTableTableManager(
        _db.attachedDatabase,
        _db.incidentPlaceCategory,
      );
  $$IncidentPlaceCategory2TableTableManager get incidentPlaceCategory2 =>
      $$IncidentPlaceCategory2TableTableManager(
        _db.attachedDatabase,
        _db.incidentPlaceCategory2,
      );
  $$ReportingUnitTableTableManager get reportingUnit =>
      $$ReportingUnitTableTableManager(_db.attachedDatabase, _db.reportingUnit);
  $$IncidentRecordTableTableManager get incidentRecord =>
      $$IncidentRecordTableTableManager(
        _db.attachedDatabase,
        _db.incidentRecord,
      );
}
