// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambulance_dao.dart';

// ignore_for_file: type=lint
mixin _$AmbulanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $IncidentPlaceCategoryTable get incidentPlaceCategory =>
      attachedDatabase.incidentPlaceCategory;
  $IncidentPlaceCategory2Table get incidentPlaceCategory2 =>
      attachedDatabase.incidentPlaceCategory2;
  $ReferralHospitalTable get referralHospital =>
      attachedDatabase.referralHospital;
  $AmbulanceRecordsTable get ambulanceRecords =>
      attachedDatabase.ambulanceRecords;
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $AmbulancePersonalPropertyTable get ambulancePersonalProperty =>
      attachedDatabase.ambulancePersonalProperty;
  $AmbulanceFeesTable get ambulanceFees => attachedDatabase.ambulanceFees;
  $AmbulanceSceneRecordsTable get ambulanceSceneRecords =>
      attachedDatabase.ambulanceSceneRecords;
  $AmbulanceReferenceItemsTable get ambulanceReferenceItems =>
      attachedDatabase.ambulanceReferenceItems;
  $AmbulanceSceneItemLinksTable get ambulanceSceneItemLinks =>
      attachedDatabase.ambulanceSceneItemLinks;
  $ReportingUnitTable get reportingUnit => attachedDatabase.reportingUnit;
  $IncidentRecordTable get incidentRecord => attachedDatabase.incidentRecord;
  $ReferralPurposeTable get referralPurpose => attachedDatabase.referralPurpose;
  $RelationshipTypeTable get relationshipType =>
      attachedDatabase.relationshipType;
  $ReferralFormsTable get referralForms => attachedDatabase.referralForms;
  $MedicalStaffTable get medicalStaff => attachedDatabase.medicalStaff;
  $TreatmentTable get treatment => attachedDatabase.treatment;
  AmbulanceDaoManager get managers => AmbulanceDaoManager(this);
}

class AmbulanceDaoManager {
  final _$AmbulanceDaoMixin _db;
  AmbulanceDaoManager(this._db);
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
  $$ReferralHospitalTableTableManager get referralHospital =>
      $$ReferralHospitalTableTableManager(
        _db.attachedDatabase,
        _db.referralHospital,
      );
  $$AmbulanceRecordsTableTableManager get ambulanceRecords =>
      $$AmbulanceRecordsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceRecords,
      );
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$AmbulancePersonalPropertyTableTableManager get ambulancePersonalProperty =>
      $$AmbulancePersonalPropertyTableTableManager(
        _db.attachedDatabase,
        _db.ambulancePersonalProperty,
      );
  $$AmbulanceFeesTableTableManager get ambulanceFees =>
      $$AmbulanceFeesTableTableManager(_db.attachedDatabase, _db.ambulanceFees);
  $$AmbulanceSceneRecordsTableTableManager get ambulanceSceneRecords =>
      $$AmbulanceSceneRecordsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceSceneRecords,
      );
  $$AmbulanceReferenceItemsTableTableManager get ambulanceReferenceItems =>
      $$AmbulanceReferenceItemsTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceReferenceItems,
      );
  $$AmbulanceSceneItemLinksTableTableManager get ambulanceSceneItemLinks =>
      $$AmbulanceSceneItemLinksTableTableManager(
        _db.attachedDatabase,
        _db.ambulanceSceneItemLinks,
      );
  $$ReportingUnitTableTableManager get reportingUnit =>
      $$ReportingUnitTableTableManager(_db.attachedDatabase, _db.reportingUnit);
  $$IncidentRecordTableTableManager get incidentRecord =>
      $$IncidentRecordTableTableManager(
        _db.attachedDatabase,
        _db.incidentRecord,
      );
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
  $$MedicalStaffTableTableManager get medicalStaff =>
      $$MedicalStaffTableTableManager(_db.attachedDatabase, _db.medicalStaff);
  $$TreatmentTableTableManager get treatment =>
      $$TreatmentTableTableManager(_db.attachedDatabase, _db.treatment);
}
