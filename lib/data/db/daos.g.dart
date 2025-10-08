// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$VisitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $VisitsTable get visits => attachedDatabase.visits;
}
mixin _$PatientProfilesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PatientProfilesTable get patientProfiles => attachedDatabase.patientProfiles;
  $VisitsTable get visits => attachedDatabase.visits;
}
mixin _$AccidentRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccidentRecordsTable get accidentRecords => attachedDatabase.accidentRecords;
}
mixin _$FlightLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FlightLogsTable get flightLogs => attachedDatabase.flightLogs;
}
mixin _$TreatmentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TreatmentsTable get treatments => attachedDatabase.treatments;
}
mixin _$MedicalCostsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalCostsTable get medicalCosts => attachedDatabase.medicalCosts;
}
mixin _$MedicalCertificatesDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalCertificatesTable get medicalCertificates =>
      attachedDatabase.medicalCertificates;
}
mixin _$UndertakingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UndertakingsTable get undertakings => attachedDatabase.undertakings;
}
mixin _$ElectronicDocumentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ElectronicDocumentsTable get electronicDocuments =>
      attachedDatabase.electronicDocuments;
}
mixin _$NursingRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $NursingRecordsTable get nursingRecords => attachedDatabase.nursingRecords;
}
mixin _$ReferralFormsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReferralFormsTable get referralForms => attachedDatabase.referralForms;
}
mixin _$AmbulanceRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AmbulanceRecordsTable get ambulanceRecords =>
      attachedDatabase.ambulanceRecords;
  $VisitsTable get visits => attachedDatabase.visits;
  $TreatmentsTable get treatments => attachedDatabase.treatments;
}
mixin _$MedicationRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $VisitsTable get visits => attachedDatabase.visits;
  $MedicationRecordsTable get medicationRecords =>
      attachedDatabase.medicationRecords;
}
mixin _$VitalSignsRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $VisitsTable get visits => attachedDatabase.visits;
  $VitalSignsRecordsTable get vitalSignsRecords =>
      attachedDatabase.vitalSignsRecords;
}
mixin _$ParamedicRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $VisitsTable get visits => attachedDatabase.visits;
  $ParamedicRecordsTable get paramedicRecords =>
      attachedDatabase.paramedicRecords;
}
