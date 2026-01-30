import 'package:drift/drift.dart';
import 'reference_tables.dart';

//醫療主表
class MedicalRecord extends Table {
  IntColumn get medicalId => integer().autoIncrement()();

  BoolColumn get isEmergency => boolean().withDefault(const Constant(false))();

  BoolColumn get hasAmbulance => boolean().withDefault(const Constant(false))();

  BoolColumn get cdcPassed => boolean().nullable()();

  TextColumn get screeningMethod => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

//病患基本資料表
class Patient extends Table {
  IntColumn get patientId => integer().autoIncrement()();

  IntColumn get medicalId =>
      integer().unique().references(MedicalRecord, #medicalId)();

  TextColumn get name => text().nullable()();
  TextColumn get anonymizationName => text().nullable()();
  DateTimeColumn get birthday => dateTime().nullable()();
  IntColumn get age => integer().nullable()();

  IntColumn get sexId => integer().nullable().references(Sex, #sexId)();

  TextColumn get passportOrIdNo => text().nullable()();

  IntColumn get nationalityId =>
      integer().nullable().references(Nationality, #nationalityId)();

  TextColumn get telephone => text().nullable()();

  TextColumn get address => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//飛航紀錄表
class FlightRecord extends Table {
  IntColumn get flightRecordId => integer().autoIncrement()();

  IntColumn get medicalId =>
      integer().unique().references(MedicalRecord, #medicalId)();

  IntColumn get airlineId => integer().references(Airline, #airlineId)();
  TextColumn get flightNumber => text()();

  IntColumn get travelStatusId =>
      integer().references(TravelStatus, #travelStatusId)();

  IntColumn get departureLocationId =>
      integer().references(Location, #locationId)();

  IntColumn get arrivalLocationId =>
      integer().references(Location, #locationId)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//飛航-經過點表
@DataClassName('FlightTransitLocationData')
class FlightTransitLocations extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到原本的飛航記錄
  IntColumn get flightRecordId => integer().references(
    FlightRecord,
    #flightRecordId,
    onDelete: KeyAction.cascade,
  )();

  // 關聯到地點表
  IntColumn get locationId => integer().references(Location, #locationId)();

  // 排序：例如第一站、第二站
  IntColumn get stopOrder => integer().withDefault(const Constant(0))();
}

//事件紀錄表
class IncidentRecord extends Table {
  IntColumn get incidentId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();
  DateTimeColumn get incidentDate => dateTime()();
  IntColumn get incidentPlaceCategoryId =>
      integer().references(IncidentPlaceCategory, #id)();
  IntColumn get incidentPlaceCategory2Id =>
      integer().references(IncidentPlaceCategory2, #id).nullable()();
  TextColumn get incidentPlaceFinal => text().nullable()();
  DateTimeColumn get notificationTime => dateTime().nullable()();
  TextColumn get notificationPerson => text().nullable()();
  IntColumn get reportingUnitId => integer().references(ReportingUnit, #id)();

  TextColumn get incomingPhone => text().nullable()();
  DateTimeColumn get notificationToOccTime => dateTime().nullable()();
  DateTimeColumn get teamDepartureTime => dateTime().nullable()();
  BoolColumn get occArrived => boolean().withDefault(const Constant(false))();

  BoolColumn get beforeLanding =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get landingTime => dateTime().nullable()();
  DateTimeColumn get medicalArrivalTime => dateTime().nullable()();
  DateTimeColumn get examinationTime => dateTime().nullable()();
}

//處置-CDC健康評估表
class HealthAssessmentForm extends Table {
  IntColumn get assessmentFormId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();
  TextColumn get name => text()();
  TextColumn get relation => text()(); // 關係
  RealColumn get temperature => real()(); // 體溫
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//處置-主訴表
@DataClassName('ChiefComplaintData')
class ChiefComplaint extends Table {
  IntColumn get complaintId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();
  IntColumn get chiefComplaintTypeId => integer().nullable()();
  TextColumn get selectedSymptoms => text().nullable()(); // JSON 或逗號分隔
  TextColumn get otherSymptomDetail => text().nullable()(); // 其它症狀說明
  TextColumn get chiefComplaintFinal => text().nullable()();
  TextColumn get supplementaryNotes => text().nullable()();
  DateTimeColumn get onsetTime => dateTime().nullable()();
  TextColumn get reportedBy =>
      text().nullable()(); // patient / family / crew / staff
  BoolColumn get isConfirmed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//處置-醫療影像表
@DataClassName('MedicalMediaData')
class MedicalMedia extends Table {
  IntColumn get mediaId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();
  TextColumn get mediaType => text()(); // trauma / ecg / other
  TextColumn get base64Data => text()(); // base64 編碼的影像資料
  TextColumn get description => text().nullable()(); // 影像說明
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//處置-醫療評估表
@DataClassName('MedicalAssessmentData')
class MedicalAssessment extends Table {
  IntColumn get assessmentId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();

  // 生命徵象
  RealColumn get temperature => real().nullable()();
  IntColumn get pulse => integer().nullable()();
  IntColumn get breath => integer().nullable()();
  IntColumn get systolic => integer().nullable()();
  IntColumn get diastolic => integer().nullable()();
  IntColumn get spo2 => integer().nullable()();
  IntColumn get painScore => integer().nullable()();

  // 意識評估
  TextColumn get consciousnessLevel =>
      text().nullable()(); // alert / drowsy / unconscious
  IntColumn get gcs => integer().nullable()();
  TextColumn get gcsE => text().nullable()();
  TextColumn get gcsM => text().nullable()();
  TextColumn get gcsV => text().nullable()();

  // 瞳孔反應
  TextColumn get leftPupilReaction => text().nullable()(); // + / - / ±
  IntColumn get leftPupilSize => integer().nullable()(); // mm
  TextColumn get rightPupilReaction => text().nullable()(); // + / - / ±
  IntColumn get rightPupilSize => integer().nullable()(); // mm

  // 理學檢查
  TextColumn get headNeckExam => text().nullable()(); // 頭頸部
  TextColumn get chestExam => text().nullable()(); // 胸部
  TextColumn get abdomenExam => text().nullable()(); // 腹部
  TextColumn get extremitiesExam => text().nullable()(); // 四肢
  TextColumn get otherPhysicalExam => text().nullable()(); // 其它理學檢查

  IntColumn get triageId => integer().nullable()();
  DateTimeColumn get assessmentTime =>
      dateTime().withDefault(currentDateAndTime)();
}

//處置-病史表
@DataClassName('MedicalHistoryData')
class MedicalHistory extends Table {
  IntColumn get historyId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();

  // 過去病史
  TextColumn get pastHistoryStatus => text()(); // 無 / 不詳 / 有
  TextColumn get pastHistoryDetail => text().nullable()();

  // 過敏史
  TextColumn get allergyStatus => text()(); // 無 / 不詳 / 有
  TextColumn get allergyDetail => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//處置-處置診斷表
@DataClassName('TreatmentData')
class Treatment extends Table {
  IntColumn get treatmentId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();

  // 診斷
  IntColumn get tentativeCategoryId => integer().nullable()(); // 診斷類別
  TextColumn get tentative => text().nullable()(); // 初步診斷 (ICD-10)
  TextColumn get secondaryDiagnosis1 => text().nullable()(); // 副診斷 1
  TextColumn get secondaryDiagnosis2 => text().nullable()(); // 副診斷 2

  // 檢傷分類
  IntColumn get triageId => integer().nullable()(); // 1-5 級

  // 處置
  IntColumn get treatmentOnSiteId => integer().nullable()(); // 現場處置
  TextColumn get actionSummary => text().nullable()(); // 處理摘要 (JSON)
  TextColumn get actionSummaryOther => text().nullable()(); // 其它處理項目

  // 結果
  IntColumn get resultId => integer().nullable()(); // 後續結果
  BoolColumn get transportRequired => boolean().nullable()();
  TextColumn get transportMethod => text().nullable()();
  IntColumn get referralHospitalId => integer().nullable()();
  TextColumn get referralHospitalFinal => text().nullable()(); // 其它醫院名稱

  DateTimeColumn get arrivalTime => dateTime().nullable()();
  IntColumn get clearanceId => integer().nullable()();
  IntColumn get expeditedClearanceId => integer().nullable()();

  TextColumn get doctorOrderCh => text().nullable()();
  TextColumn get doctorOrderEn => text().nullable()();

  // 醫護人員
  TextColumn get directorName => text().nullable()(); // 院長/負責人

  DateTimeColumn get treatmentTime =>
      dateTime().withDefault(currentDateAndTime)();
}

//處置-醫療人員指派表
@DataClassName('MedicalStaffAssignmentData')
class MedicalStaffAssignment extends Table {
  IntColumn get staffAssignmentId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();
  TextColumn get staffRole => text()(); // physician / nurse / emt / assist
  IntColumn get staffId => integer().nullable()(); // 關聯到員工表
  TextColumn get staffName => text().nullable()(); // 或直接儲存姓名
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  BlobColumn get signature => blob().nullable()();
  DateTimeColumn get signedAt => dateTime().nullable()();
  DateTimeColumn get assignedAt => dateTime().withDefault(currentDateAndTime)();
}

//處置-特別註記表
@DataClassName('SpecialNotesData')
class SpecialNotes extends Table {
  IntColumn get noteId => integer().autoIncrement()();
  IntColumn get medicalId => integer().references(MedicalRecord, #medicalId)();
  TextColumn get selectedNotes => text().nullable()(); // JSON 或逗號分隔
  TextColumn get otherNotes => text().nullable()(); // 其他特別註記
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
