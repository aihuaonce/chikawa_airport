import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

//匯入Table
import 'tables/reference_tables.dart';
import 'tables/medical_tables.dart';

//匯入DAO
import 'dao/reference_dao.dart';
import 'dao/medical_dao.dart';
import 'dao/flight_dao.dart';
import 'dao/incident_dao.dart';
import 'dao/treatment_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    //參考表
    Sex,
    Nationality,
    Airline,
    TravelStatus,
    Location,
    IncidentPlaceCategory,
    IncidentPlaceCategory2,
    ReportingUnit,
    ChiefComplaintType,
    DiagnosisCategory,
    TriageLevel,
    TreatmentOnSite,
    TreatmentResult,
    ReferralHospital,
    ActionItem,
    MedicalStaff,

    //醫療表
    MedicalRecord,
    Patient,
    FlightRecord,
    FlightTransitLocations,
    IncidentRecord,
    ChiefComplaint,
    HealthAssessmentForm,
    MedicalMedia,
    MedicalAssessment,
    MedicalHistory,
    Treatment,
    MedicalStaffAssignment,
    SpecialNotes,
  ],
  daos: [ReferenceDao, MedicalDao, FlightDao, IncidentDao, TreatmentDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      await referenceDao.initializeAllReferenceData();
    },
  );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'medical_records.db'));
      return NativeDatabase(file);
    });
  }
}
