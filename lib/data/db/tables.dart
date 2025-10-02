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
