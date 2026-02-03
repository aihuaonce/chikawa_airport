import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

//匯入Table
import 'tables/reference_tables.dart';
import 'tables/medical_tables.dart';
import 'tables/icd10_tables.dart';
import 'tables/normalization_tables.dart';

//匯入DAO
import 'dao/reference_dao.dart';
import 'dao/medical_dao.dart';
import 'dao/flight_dao.dart';
import 'dao/incident_dao.dart';
import 'dao/treatment_dao.dart';
import 'dao/icd10_dao.dart';
import 'dao/certificate_dao.dart';
import 'dao/telex_dao.dart';
import 'dao/medical_fee_dao.dart';
import 'dao/nursing_record_dao.dart';
import 'dao/referral_form_dao.dart';

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
    ChiefComplaintDetail,
    DiagnosisCategory,
    TriageLevel,
    TreatmentOnSite,
    TreatmentResult,
    ReferralHospital,
    ActionItem,
    MedicalStaff,
    SpecialNoteRef,
    NursingPhrase,
    PaymentMethod,
    CollectionStatus,
    CurrencyRef,
    ReferralPurpose,
    StationRef,
    RelationshipType,
    HistoryStatusRef,
    MedicalStaffRole,
    PupilReactionRef,
    ConsciousnessLevelRef,
    DrugRef,

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
    MedicalCertificates,
    MedicalFees,
    NursingRecords,
    ReferralForms,
    TelexDocuments,
    ChiefComplaintSymptomLinks,
    TreatmentActionLinks,
    SpecialNoteLinks,
    Medications,

    //ICD-10
    Icd10Code,
  ],
  daos: [
    ReferenceDao,
    MedicalDao,
    FlightDao,
    IncidentDao,
    TreatmentDao,
    Icd10Dao,
    CertificateDao,
    TelexDao,
    MedicalFeeDao,
    NursingRecordDao,
    ReferralFormDao,
  ],
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

  @override
  Icd10Dao get icd10Dao => Icd10Dao(this);

  @override
  CertificateDao get certificateDao => CertificateDao(this);
  @override
  TelexDao get telexDao => TelexDao(this);

  @override
  MedicalFeeDao get medicalFeeDao => MedicalFeeDao(this);
  @override
  NursingRecordDao get nursingRecordDao => NursingRecordDao(this);
  @override
  ReferralFormDao get referralFormDao => ReferralFormDao(this);
}
