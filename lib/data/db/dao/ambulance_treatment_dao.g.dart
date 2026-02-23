// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambulance_treatment_dao.dart';

// ignore_for_file: type=lint
mixin _$AmbulanceTreatmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $AmbulanceTreatmentRecordsTable get ambulanceTreatmentRecords =>
      attachedDatabase.ambulanceTreatmentRecords;
  $AmbulanceTreatmentCategoriesTable get ambulanceTreatmentCategories =>
      attachedDatabase.ambulanceTreatmentCategories;
  $AmbulanceTreatmentItemsTable get ambulanceTreatmentItems =>
      attachedDatabase.ambulanceTreatmentItems;
  $AmbulanceTreatmentRecordItemsTable get ambulanceTreatmentRecordItems =>
      attachedDatabase.ambulanceTreatmentRecordItems;
  $AmbulanceMedicationLogsTable get ambulanceMedicationLogs =>
      attachedDatabase.ambulanceMedicationLogs;
  $AmbulanceVitalSignsTable get ambulanceVitalSigns =>
      attachedDatabase.ambulanceVitalSigns;
  $AmbulanceEscortStaffTable get ambulanceEscortStaff =>
      attachedDatabase.ambulanceEscortStaff;
  AmbulanceTreatmentDaoManager get managers =>
      AmbulanceTreatmentDaoManager(this);
}

class AmbulanceTreatmentDaoManager {
  final _$AmbulanceTreatmentDaoMixin _db;
  AmbulanceTreatmentDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$AmbulanceTreatmentRecordsTableTableManager get ambulanceTreatmentRecords =>
      $$AmbulanceTreatmentRecordsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceTreatmentRecords,
      );
  $$AmbulanceTreatmentCategoriesTableTableManager
  get ambulanceTreatmentCategories =>
      $$AmbulanceTreatmentCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceTreatmentCategories,
      );
  $$AmbulanceTreatmentItemsTableTableManager get ambulanceTreatmentItems =>
      $$AmbulanceTreatmentItemsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceTreatmentItems,
      );
  $$AmbulanceTreatmentRecordItemsTableTableManager
  get ambulanceTreatmentRecordItems =>
      $$AmbulanceTreatmentRecordItemsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceTreatmentRecordItems,
      );
  $$AmbulanceMedicationLogsTableTableManager get ambulanceMedicationLogs =>
      $$AmbulanceMedicationLogsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceMedicationLogs,
      );
  $$AmbulanceVitalSignsTableTableManager get ambulanceVitalSigns =>
      $$AmbulanceVitalSignsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceVitalSigns,
      );
  $$AmbulanceEscortStaffTableTableManager get ambulanceEscortStaff =>
      $$AmbulanceEscortStaffTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceEscortStaff,
      );
}
