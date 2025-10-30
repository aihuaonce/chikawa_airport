import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';
import 'daos.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Visits,
    PatientProfiles,
    AccidentRecords,
    FlightLogs,
    Treatments,
    MedicalCosts,
    MedicalCertificates,
    Undertakings,
    ElectronicDocuments,
    NursingRecords,
    ReferralForms,
    AmbulanceRecords,
    MedicationRecords,
    VitalSignsRecords,
    ParamedicRecords,
    EmergencyRecords,
  ],
  daos: [
    VisitsDao,
    PatientProfilesDao,
    AccidentRecordsDao,
    FlightLogsDao,
    TreatmentsDao,
    MedicalCostsDao,
    MedicalCertificatesDao,
    UndertakingsDao,
    ElectronicDocumentsDao,
    NursingRecordsDao,
    ReferralFormsDao,
    AmbulanceRecordsDao,
    MedicationRecordsDao,
    VitalSignsRecordsDao,
    ParamedicRecordsDao,
    EmergencyRecordsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) async => m.createAll());
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_v1.db'));
    return NativeDatabase.createInBackground(file);
  });
}
