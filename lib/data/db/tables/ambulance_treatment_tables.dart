import 'package:drift/drift.dart';
import 'medical_tables.dart';

// 救護車處置紀錄表 (Main Record)
@DataClassName('AmbulanceTreatmentRecordData')
class AmbulanceTreatmentRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到 MedicalRecord (一對一)
  IntColumn get medicalId =>
      integer().unique().references(MedicalRecord, #medicalId)();

  // 線上指導醫師指示
  TextColumn get doctorInstructions => text().nullable()();

  // 接收單位
  TextColumn get receivingHospital => text().nullable()();

  // 接收時間 (儲存 HH:mm:ss 字串)
  TextColumn get receivingTime => text().nullable()();

  // 是否拒絕送醫
  BoolColumn get isRefusedHospital =>
      boolean().withDefault(const Constant(false))();

  // 關係人身分 (病患/家屬/關係人)
  TextColumn get relationship =>
      text().withDefault(const Constant('病患 Patient'))();

  // 關係人姓名
  TextColumn get relativeName => text().nullable()();

  // 關係人電話
  TextColumn get relativePhone => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get remoteId => text().nullable()();
  DateTimeColumn get lastModified => dateTime().nullable()();
}

// 處置大類 (Reference)
@DataClassName('AmbulanceTreatmentCategoryData')
class AmbulanceTreatmentCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()(); // e.g., 'AIRWAY', 'TRAUMA'
  TextColumn get name => text()(); // e.g., '呼吸道處置'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// 處置細項 (Reference)
@DataClassName('AmbulanceTreatmentItemData')
class AmbulanceTreatmentItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到大類
  IntColumn get categoryId =>
      integer().references(AmbulanceTreatmentCategories, #id)();

  TextColumn get name => text()(); // e.g., '口咽呼吸道', 'CPR'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // 是否為"其他"選項 (觸發輸入框)
  BoolColumn get isOther => boolean().withDefault(const Constant(false))();
}

// 處置紀錄-項目關聯表 (Join Table with Details)
@DataClassName('AmbulanceTreatmentRecordItemData')
class AmbulanceTreatmentRecordItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到紀錄
  IntColumn get recordId => integer().references(
    AmbulanceTreatmentRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();

  // 關聯到細項
  IntColumn get itemId => integer().references(
    AmbulanceTreatmentItems,
    #id,
    onDelete: KeyAction.cascade,
  )();

  // --- 詳細欄位 (Specific Fields) ---

  // 呼吸道 -> 氣管內管
  TextColumn get tubeSize => text().nullable()(); // 號碼
  TextColumn get fixationDepth => text().nullable()(); // 固定公分數

  // CPR -> 手動電擊器
  TextColumn get shockCount => text().nullable()(); // 電擊次數
  TextColumn get shockJoules => text().nullable()(); // 焦耳數

  // 其他 -> 描述
  TextColumn get otherDescription => text().nullable()();

  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
}

// 藥物紀錄表
@DataClassName('AmbulanceMedicationLogData')
class AmbulanceMedicationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recordId => integer().references(
    AmbulanceTreatmentRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get time => text().nullable()();
  TextColumn get drugName => text().nullable()();
  TextColumn get route => text().nullable()(); // 使用方式
  TextColumn get dose => text().nullable()(); // 劑量
  TextColumn get emtName => text().nullable()(); // EMT姓名

  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
}

// 生命徵象紀錄表
@DataClassName('AmbulanceVitalSignData')
class AmbulanceVitalSigns extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recordId => integer().references(
    AmbulanceTreatmentRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get time => text().nullable()();
  BoolColumn get atHospital =>
      boolean().withDefault(const Constant(false))(); // 到院

  // GCS
  TextColumn get avpu => text().nullable()();
  TextColumn get gcsE => text().nullable()();
  TextColumn get gcsV => text().nullable()();
  TextColumn get gcsM => text().nullable()();
  TextColumn get gcsTotal => text().nullable()();

  TextColumn get temperature => text().nullable()();
  TextColumn get pulse => text().nullable()();
  TextColumn get respirationRate => text().nullable()();
  TextColumn get bloodPressure => text().nullable()();
  TextColumn get spo2 => text().nullable()();

  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
}

// 隨車人員表
@DataClassName('AmbulanceEscortStaffData')
class AmbulanceEscortStaff extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recordId => integer().references(
    AmbulanceTreatmentRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get name => text().nullable()();
  BlobColumn get signature => blob().nullable()();

  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
}
