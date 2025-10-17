import 'package:drift/drift.dart';

/// 1) 個案主檔（HomePage 列表就讀這張）
class Visits extends Table {
  IntColumn get visitId => integer().autoIncrement()();

  // HomePage 顯示用的摘要欄位（分頁各自回寫）
  TextColumn get patientName => text().nullable()(); // 之後在姓名頁回寫
  TextColumn get gender => text().nullable()(); // 個人資料頁回寫
  TextColumn get nationality => text().nullable()(); // 個人資料頁回寫
  TextColumn get dept => text().nullable()(); // 之後在科別頁回寫
  TextColumn get note => text().nullable()(); // 之後某頁回寫
  TextColumn get filledBy => text().nullable()(); // 之後某頁回寫

  // ✅ 新增：急救記錄專用欄位
  BoolColumn get hasEmergencyRecord =>
      boolean().withDefault(const Constant(false))(); // 標記是否為急救記錄
  DateTimeColumn get incidentDateTime => dateTime().nullable()(); // 事發時間
  TextColumn get emergencyResult => text().nullable()(); // 急救結果

  DateTimeColumn get uploadedAt =>
      dateTime().withDefault(currentDateAndTime)(); // 建立/更新時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get indexes => [
    {patientName},
    {gender},
    {nationality},
    {dept},
    {uploadedAt},
    {hasEmergencyRecord}, // ✅ 新增索引
    {incidentDateTime}, // ✅ 新增索引
  ];
}

/// 2) 個人資料（PersonalInformationPage 對應）
class PatientProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到主檔（必填，不 nullable）
  IntColumn get visitId => integer()();

  // 個人資料欄位
  DateTimeColumn get birthday => dateTime().nullable()();
  IntColumn get age => integer().nullable()(); // ✅ 建議加 age 欄位
  TextColumn get gender => text().nullable()(); // 與主檔同步
  TextColumn get reason => text().nullable()();
  TextColumn get nationality => text().nullable()(); // 與主檔同步
  TextColumn get idNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get photoPath => text().nullable()();

  TextColumn get bodyMapJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {visitId},
  ];

  @override
  List<Set<Column>> get indexes => [
    {visitId},
    {gender},
    {nationality},
  ];
}

class AccidentRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到主檔（必填，不 nullable）
  IntColumn get visitId => integer().unique()(); // 唯一索引確保一筆 Visit 只有一筆紀錄

  // 時間相關
  DateTimeColumn get incidentDate => dateTime().nullable()(); // 事發日期
  DateTimeColumn get notifyTime => dateTime().nullable()(); // 通報時間
  DateTimeColumn get pickUpTime => dateTime().nullable()(); // 通報營運控制中心時間
  DateTimeColumn get medicArriveTime => dateTime().nullable()(); // 醫護到達時間
  DateTimeColumn get ambulanceDepartTime => dateTime().nullable()(); // 醫護出發時間
  DateTimeColumn get checkTime => dateTime().nullable()(); // 檢查時間
  DateTimeColumn get landingTime => dateTime().nullable()(); // 落地時間

  // 基本資訊
  IntColumn get reportUnitIdx => integer().nullable()(); // 通報單位索引
  TextColumn get otherReportUnit => text().nullable()(); // 其他通報單位
  TextColumn get notifier => text().nullable()(); // 通報人員
  TextColumn get phone => text().nullable()(); // 電話
  IntColumn get placeIdx => integer().nullable()(); // 事故地點主群組索引
  TextColumn get placeNote => text().nullable()(); // 地點備註

  // ✅ 新增：各地點群組的子項目索引
  IntColumn get t1PlaceIdx => integer().nullable()(); // 第一航廈子地點索引
  IntColumn get t2PlaceIdx => integer().nullable()(); // 第二航廈子地點索引
  IntColumn get remotePlaceIdx => integer().nullable()(); // 遠端機坪子地點索引
  IntColumn get cargoPlaceIdx => integer().nullable()(); // 貨運站子地點索引
  IntColumn get novotelPlaceIdx => integer().nullable()(); // 諾富特子地點索引
  IntColumn get cabinPlaceIdx => integer().nullable()(); // 機艙內子地點索引

  BoolColumn get occArrived =>
      boolean().withDefault(const Constant(false))(); // 營運控制中心到達現場
  TextColumn get cost => text().nullable()(); // 花費時間(分秒)
  IntColumn get within10min => integer().nullable()(); // 10分鐘內到達 (0:是, 1:否)

  // 未在10分鐘內到達的原因
  BoolColumn get reasonLanding =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get reasonOnline => boolean().withDefault(const Constant(false))();
  BoolColumn get reasonOther => boolean().withDefault(const Constant(false))();
  TextColumn get reasonOtherText => text().nullable()(); // 其他原因

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class FlightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer()(); // 關聯到 Visits

  IntColumn get airlineIndex => integer().nullable()();
  BoolColumn get useOtherAirline =>
      boolean().withDefault(const Constant(false))();
  TextColumn get otherAirline => text().nullable()();

  TextColumn get flightNo => text().nullable()();

  IntColumn get travelStatusIndex => integer().nullable()();
  TextColumn get otherTravelStatus => text().nullable()();

  TextColumn get departure => text().nullable()();
  TextColumn get via => text().nullable()();
  TextColumn get destination => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Treatments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // 疾病管制署篩檢
  BoolColumn get screeningChecked =>
      boolean().withDefault(const Constant(false))();
  TextColumn get screeningMethodsJson =>
      text().nullable()(); // JSON-encoded Map<String, bool>
  TextColumn get otherScreeningMethod => text().nullable()();
  TextColumn get healthDataJson =>
      text().nullable()(); // JSON-encoded List<Map<String, String>>

  // 主訴
  IntColumn get mainSymptom => integer().nullable()();
  TextColumn get traumaSymptomsJson => text().nullable()();
  TextColumn get nonTraumaSymptomsJson => text().nullable()();
  TextColumn get symptomNote => text().nullable()();
  TextColumn get nonTraumaHeadSymptomsJson => text().nullable()();
  TextColumn get nonTraumaChestSymptomsJson => text().nullable()();
  TextColumn get nonTraumaAbdomenSymptomsJson => text().nullable()();
  TextColumn get nonTraumaLimbsSymptomsJson => text().nullable()();
  TextColumn get nonTraumaOtherSymptomsJson => text().nullable()();

  // 照片類型
  TextColumn get photoTypesJson => text().nullable()();

  // 身體檢查
  TextColumn get bodyCheckHead => text().nullable()();
  TextColumn get bodyCheckChest => text().nullable()();
  TextColumn get bodyCheckAbdomen => text().nullable()();
  TextColumn get bodyCheckLimbs => text().nullable()();
  TextColumn get bodyCheckOther => text().nullable()();

  // 生命徵象
  TextColumn get temperature => text().nullable()();
  TextColumn get pulse => text().nullable()();
  TextColumn get respiration => text().nullable()();
  TextColumn get bpSystolic => text().nullable()();
  TextColumn get bpDiastolic => text().nullable()();
  TextColumn get spo2 => text().nullable()();
  BoolColumn get consciousClear =>
      boolean().withDefault(const Constant(true))();
  TextColumn get evmE => text().nullable()();
  TextColumn get evmV => text().nullable()();
  TextColumn get evmM => text().nullable()();
  IntColumn get leftPupilScale => integer().nullable()();
  TextColumn get leftPupilSize => text().nullable()();
  IntColumn get rightPupilScale => integer().nullable()();
  TextColumn get rightPupilSize => text().nullable()();

  // 病史
  IntColumn get history => integer().nullable()();
  IntColumn get allergy => integer().nullable()();

  // 初步診斷
  TextColumn get initialDiagnosis => text().nullable()();
  IntColumn get diagnosisCategory => integer().nullable()();
  TextColumn get selectedICD10Main => text().nullable()();
  TextColumn get selectedICD10Sub1 => text().nullable()();
  TextColumn get selectedICD10Sub2 => text().nullable()();
  IntColumn get triageCategory => integer().nullable()();

  // 處理摘要 & 後續
  TextColumn get onSiteTreatmentsJson => text().nullable()();
  BoolColumn get ekgChecked => boolean().withDefault(const Constant(false))();
  TextColumn get ekgReading => text().nullable()();
  BoolColumn get sugarChecked => boolean().withDefault(const Constant(false))();
  TextColumn get sugarReading => text().nullable()();
  BoolColumn get suggestReferral =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get intubationChecked =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get cprChecked => boolean().withDefault(const Constant(false))();
  BoolColumn get oxygenTherapyChecked =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get medicalCertificateChecked =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get prescriptionChecked =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get otherChecked => boolean().withDefault(const Constant(false))();
  TextColumn get otherSummary => text().nullable()();
  IntColumn get referralPassageType => integer().nullable()();
  IntColumn get referralAmbulanceType => integer().nullable()();
  IntColumn get referralHospitalIdx => integer().nullable()();
  TextColumn get referralOtherHospital => text().nullable()();
  TextColumn get referralEscort => text().nullable()();
  IntColumn get intubationType => integer().nullable()();
  IntColumn get oxygenType => integer().nullable()();
  TextColumn get oxygenFlow => text().nullable()();
  TextColumn get medicalCertificateTypesJson => text().nullable()();
  TextColumn get prescriptionRowsJson => text().nullable()();
  TextColumn get followUpResultsJson => text().nullable()();
  IntColumn get otherHospitalIdx => integer().nullable()();

  // 人員
  TextColumn get selectedMainDoctor => text().nullable()();
  TextColumn get selectedMainNurse => text().nullable()();
  TextColumn get nurseSignature => text().nullable()();
  TextColumn get selectedEMT => text().nullable()();
  TextColumn get emtSignature => text().nullable()();
  TextColumn get helperNamesText => text().nullable()();
  TextColumn get selectedHelpersJson => text().nullable()();

  // 特別註記
  TextColumn get specialNotesJson => text().nullable()();
  TextColumn get otherSpecialNote => text().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class MedicalCosts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()(); // 確保一個 Visit 只有一筆費用紀錄

  // 費用收取方式
  TextColumn get chargeMethod => text().nullable()();

  // 費用（以文字儲存）
  TextColumn get visitFee => text().nullable()();
  TextColumn get ambulanceFee => text().nullable()();

  // 備註
  TextColumn get note => text().nullable()();

  // 圖片與簽名檔案路徑（預留欄位）
  TextColumn get photoPath => text().nullable()();
  TextColumn get agreementSignaturePath => text().nullable()();
  TextColumn get witnessSignaturePath => text().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class MedicalCertificates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // 診斷內容
  TextColumn get diagnosis => text().nullable()();

  // 囑言片語選項
  IntColumn get instructionOption => integer().nullable()();

  // 中、英文囑言
  TextColumn get chineseInstruction => text().nullable()();
  TextColumn get englishInstruction => text().nullable()();

  // 開立日期
  DateTimeColumn get issueDate => dateTime().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Undertakings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // 中文區塊欄位
  TextColumn get signerName => text().nullable()();
  TextColumn get signerId => text().nullable()();
  BoolColumn get isSelf => boolean().withDefault(const Constant(false))();
  TextColumn get relation => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get doctor => text().nullable()();

  // 簽名圖片資料
  BlobColumn get signatureBytes => blob().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ElectronicDocuments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // TO 選項的索引
  IntColumn get toSelectedIndex => integer().nullable()();

  // FROM 選項的索引
  IntColumn get fromSelectedIndex => integer().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class NursingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // 將多筆護理記錄的 List<Map> 轉換為 JSON 字串儲存
  TextColumn get recordsJson => text().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ReferralForms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // 聯絡人資料
  TextColumn get contactName => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  TextColumn get contactAddress => text().nullable()();

  // 診斷 ICD-10-CM/PCS 病名
  TextColumn get mainDiagnosis => text().nullable()();
  TextColumn get subDiagnosis1 => text().nullable()();
  TextColumn get subDiagnosis2 => text().nullable()();

  // 檢查及治療摘要
  DateTimeColumn get lastExamDate => dateTime().nullable()();
  DateTimeColumn get lastMedicationDate => dateTime().nullable()();

  // 轉診目的
  IntColumn get referralPurposeIdx => integer().nullable()();
  TextColumn get furtherExamDetail => text().nullable()();
  TextColumn get otherPurposeDetail => text().nullable()();

  // 診治醫生資訊
  IntColumn get doctorIdx => integer().nullable()();
  TextColumn get otherDoctorName => text().nullable()();
  IntColumn get deptIdx => integer().nullable()();
  TextColumn get otherDeptName => text().nullable()();
  BlobColumn get doctorSignature => blob().nullable()();

  // 轉診院所資訊
  DateTimeColumn get issueDate => dateTime().nullable()();
  DateTimeColumn get appointmentDate => dateTime().nullable()();
  TextColumn get appointmentDept => text().nullable()();
  TextColumn get appointmentRoom => text().nullable()();
  TextColumn get appointmentNumber => text().nullable()();
  TextColumn get referralHospitalName => text().nullable()();
  IntColumn get referralDeptIdx => integer().nullable()();
  TextColumn get otherReferralDept => text().nullable()();
  TextColumn get referralDoctorName => text().nullable()();
  TextColumn get referralAddress => text().nullable()();
  TextColumn get referralPhone => text().nullable()();

  // 同意人資訊
  BlobColumn get consentSignature => blob().nullable()();
  TextColumn get relationToPatient => text().nullable()();
  DateTimeColumn get consentDateTime => dateTime().nullable()();

  // 紀錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 在您的 table 定義檔案中
// 修改 AmbulanceRecords 表

class AmbulanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // --- 對應 Ambulance_Information.dart ---
  TextColumn get plateNumber => text().nullable()();
  IntColumn get placeGroupIdx => integer().nullable()();
  IntColumn get t1PlaceIdx => integer().nullable()(); // <-- 名稱是 t1PlaceIdx
  IntColumn get t2PlaceIdx => integer().nullable()(); // <-- 名稱是 t2PlaceIdx
  IntColumn get remotePlaceIdx => integer().nullable()();
  IntColumn get cargoPlaceIdx => integer().nullable()();
  IntColumn get novotelPlaceIdx => integer().nullable()();
  IntColumn get cabinPlaceIdx => integer().nullable()();
  TextColumn get placeNote => text().nullable()();

  DateTimeColumn get dutyTime => dateTime().nullable()();
  DateTimeColumn get arriveSceneTime =>
      dateTime().nullable()(); // <-- 名稱是 arriveSceneTime
  DateTimeColumn get leaveSceneTime =>
      dateTime().nullable()(); // <-- 名稱是 leaveSceneTime
  DateTimeColumn get arriveHospitalTime => dateTime().nullable()();
  DateTimeColumn get leaveHospitalTime => dateTime().nullable()();
  DateTimeColumn get backStandbyTime => dateTime().nullable()();

  IntColumn get destinationHospitalIdx => integer().nullable()();
  TextColumn get otherDestinationHospital => text().nullable()();
  TextColumn get destinationHospital => text().nullable()();

  // --- 對應 Ambulance_Personal.dart ---
  TextColumn get patientBelongings => text().nullable()();
  TextColumn get belongingsHandled => text().nullable()();
  TextColumn get custodianName => text().nullable()();
  BlobColumn get custodianSignature => blob().nullable()();

  // --- 對應 Ambulance_Situation.dart ---
  TextColumn get chiefComplaint => text().nullable()();

  // --- 對應 Ambulance_Plan.dart ---

  // 【修正 JSON 欄位定義】
  // 將所有 .nullable() 移除，並使用 .withDefault(const Constant('{}'))
  // 來確保欄位永遠不會是 null，這樣在解碼 JSON 時更安全
  TextColumn get emergencyTreatmentsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get airwayTreatmentsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get traumaTreatmentsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get transportMethodsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get cprMethodsJson => text().withDefault(const Constant('{}'))();
  TextColumn get medicationProceduresJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get otherEmergencyProceduresJson =>
      text().withDefault(const Constant('{}'))();

  TextColumn get bodyDiagramNote => text().nullable()();
  TextColumn get bodyDiagramPath => text().nullable()();

  TextColumn get airwayOther => text().nullable()();
  TextColumn get otherEmergencyOther => text().nullable()();

  TextColumn get aslType => text().nullable()();
  TextColumn get ettSize => text().nullable()();
  TextColumn get ettDepth => text().nullable()();
  TextColumn get manualDefibCount => text().nullable()();
  TextColumn get manualDefibJoules => text().nullable()();

  TextColumn get guideNote => text().nullable()();
  TextColumn get receivingUnit => text().nullable()();
  DateTimeColumn get receivingTime => dateTime().nullable()();

  BoolColumn get isRejection => boolean().withDefault(const Constant(false))();
  TextColumn get rejectionName => text().nullable()();

  TextColumn get relationshipType => text().nullable()();
  TextColumn get contactName => text().nullable()();
  TextColumn get contactPhone => text().nullable()();

  // --- 對應 Ambulance_Expenses.dart ---
  IntColumn get staffFee => integer().nullable()();
  IntColumn get oxygenFee => integer().nullable()();
  IntColumn get totalFee => integer().nullable()();
  TextColumn get chargeStatus => text().nullable()();
  TextColumn get paidType => text().nullable()();
  TextColumn get unpaidType => text().nullable()();

  // --- 對應 Ambulance_Situation.dart ---
  // 將 Set<String> 轉為 JSON 儲存，並提供預設值 '[]' (空的 JSON 陣列)
  TextColumn get traumaClassJson => text().withDefault(const Constant('[]'))();
  TextColumn get nonTraumaTypeJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get nonTraumaAcutePickedJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get nonTraumaGeneralPickedJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get traumaTypePickedJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get traumaGeneralBodyPickedJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get traumaMechanismPickedJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get allergyJson => text().withDefault(const Constant('[]'))();
  TextColumn get pmhJson => text().withDefault(const Constant('[]'))();

  // 文字輸入欄位
  TextColumn get allergyOther => text().nullable()();
  TextColumn get pmhOther => text().nullable()();
  TextColumn get nonTraumaAcuteOther => text().nullable()();
  TextColumn get traumaGeneralOther => text().nullable()();
  TextColumn get fallHeight => text().nullable()();
  TextColumn get burnDegree => text().nullable()();
  TextColumn get burnArea => text().nullable()();
  TextColumn get traumaOther => text().nullable()();

  // Radio Button
  BoolColumn get isProxyStatement => boolean().nullable()(); // 是否代訴

  // --- 紀錄時間 ---
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 給藥紀錄表
class MedicationRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId =>
      integer().references(Visits, #visitId)(); // 關聯到 Visit

  DateTimeColumn get recordTime => dateTime().nullable()();
  TextColumn get name => text().nullable()(); // 藥名
  TextColumn get route => text().nullable()(); // 途徑
  TextColumn get dose => text().nullable()(); // 劑量
  TextColumn get executor => text().nullable()(); // 執行者
}

// 生命徵象紀錄表
class VitalSignsRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().references(Visits, #visitId)();

  DateTimeColumn get recordTime => dateTime().nullable()();
  BoolColumn get atHospital => boolean().withDefault(const Constant(false))();
  TextColumn get triageStation => text().nullable()(); // 檢傷站
  TextColumn get consciousness => text().nullable()(); // 意識情況
  TextColumn get temperature => text().nullable()(); // 體溫
  TextColumn get pulse => text().nullable()(); // 脈搏
  TextColumn get respiration => text().nullable()(); // 呼吸
  TextColumn get bloodPressure => text().nullable()(); // 血壓
  TextColumn get spo2 => text().nullable()(); // 血氧
  TextColumn get gcs => text().nullable()(); // GCS 分數 (e.g., "15 (E4V5M6)")
}

// 隨車救護人員紀錄表
class ParamedicRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().references(Visits, #visitId)();

  TextColumn get name => text().nullable()();
  BlobColumn get signature => blob().nullable()(); // 簽名
}

class EmergencyRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId => integer().unique()();

  // Personal (個人資料)
  TextColumn get patientName => text().nullable()(); // ✅ 新增：病患姓名
  TextColumn get idNumber => text().nullable()();
  TextColumn get passportNumber => text().nullable()();
  TextColumn get gender => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();

  // Flight (飛航記錄)
  IntColumn get sourceIndex => integer().nullable()();
  IntColumn get purposeIndex => integer().nullable()();
  IntColumn get airlineIndex => integer().nullable()();
  BoolColumn get useOtherAirline =>
      boolean().withDefault(const Constant(false))();
  TextColumn get selectedOtherAirline => text().nullable()();
  TextColumn get nationality => text().nullable()();

  // Accident (事故記錄)
  DateTimeColumn get incidentDateTime => dateTime().nullable()();
  IntColumn get placeGroupIdx => integer().nullable()();
  IntColumn get t1Selected => integer().nullable()();
  IntColumn get t2Selected => integer().nullable()();
  IntColumn get remoteSelected => integer().nullable()();
  IntColumn get cargoSelected => integer().nullable()();
  IntColumn get novotelSelected => integer().nullable()();
  IntColumn get cabinSelected => integer().nullable()();
  TextColumn get placeNote => text().nullable()();

  // Plan (處置記錄)
  DateTimeColumn get firstAidStartTime => dateTime().nullable()();
  DateTimeColumn get intubationStartTime => dateTime().nullable()();
  DateTimeColumn get onIVLineStartTime => dateTime().nullable()();
  DateTimeColumn get cardiacMassageStartTime => dateTime().nullable()();
  DateTimeColumn get cardiacMassageEndTime => dateTime().nullable()();
  DateTimeColumn get firstAidEndTime => dateTime().nullable()();

  TextColumn get diagnosis => text().nullable()();
  TextColumn get situation => text().nullable()();

  // 病況
  TextColumn get evmE => text().nullable()();
  TextColumn get evmV => text().nullable()();
  TextColumn get evmM => text().nullable()();
  TextColumn get heartRate => text().nullable()();
  TextColumn get respirationRate => text().nullable()();
  TextColumn get bloodPressure => text().nullable()();
  TextColumn get temperature => text().nullable()();
  TextColumn get leftPupilSize => text().nullable()();
  TextColumn get rightPupilSize => text().nullable()();
  TextColumn get leftPupilReaction => text().nullable()();
  TextColumn get rightPupilReaction => text().nullable()();

  // 急救處置
  TextColumn get insertionMethod => text().nullable()();
  TextColumn get airwayContent => text().nullable()();
  TextColumn get insertionRecord => text().nullable()();
  TextColumn get ivNeedleSize => text().nullable()();
  TextColumn get ivLineRecord => text().nullable()();
  TextColumn get cardiacMassageRecord => text().nullable()();
  TextColumn get postResuscitationEvmE => text().nullable()();
  TextColumn get postResuscitationEvmV => text().nullable()();
  TextColumn get postResuscitationEvmM => text().nullable()();
  TextColumn get postResuscitationHeartRate => text().nullable()();
  TextColumn get postResuscitationRespirationMethod => text().nullable()();
  TextColumn get postResuscitationBloodPressure => text().nullable()();
  TextColumn get postResuscitationLeftPupilSize => text().nullable()();
  TextColumn get postResuscitationRightPupilSize => text().nullable()();
  TextColumn get postResuscitationLeftPupilLightReflex => text().nullable()();
  TextColumn get postResuscitationRightPupilLightReflex => text().nullable()();
  TextColumn get otherSupplements => text().nullable()();

  // 急救結束與結果
  TextColumn get endRecord => text().nullable()();
  TextColumn get endResult => text().nullable()();
  TextColumn get selectedHospital => text().nullable()();
  TextColumn get otherHospital => text().nullable()();
  TextColumn get otherEndResult => text().nullable()();
  DateTimeColumn get deathTime => dateTime().nullable()();

  // 參與人員
  TextColumn get selectedDoctor => text().nullable()();
  TextColumn get selectedNurse => text().nullable()();
  TextColumn get selectedEMT => text().nullable()();
  TextColumn get nurseSignature => text().nullable()();
  TextColumn get emtSignature => text().nullable()();

  // 協助人員列表（JSON）
  TextColumn get selectedAssistantsJson =>
      text().withDefault(const Constant('[]'))();

  // 用藥記錄表（JSON）
  TextColumn get medicationRecordsJson =>
      text().withDefault(const Constant('[]'))();

  // 記錄時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
