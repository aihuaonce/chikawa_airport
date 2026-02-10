import 'package:drift/drift.dart';
import 'reference_tables.dart';
import 'medical_tables.dart';

// 救護車派遣紀錄表
@DataClassName('AmbulanceRecord')
class AmbulanceRecords extends Table {
  IntColumn get ambulanceId => integer().autoIncrement()();
  
  // 關聯到 MedicalRecord (可選，視業務邏輯而定，這裡保留彈性)
  IntColumn get medicalId => integer().nullable()();

  // 車牌號碼
  TextColumn get licensePlate => text().nullable()();

  // 發生地點 (正規化：關聯到 IncidentPlaceCategory)
  IntColumn get incidentLocationId => integer().nullable().references(IncidentPlaceCategory, #id)();

  // 發生地點二級 (正規化：關聯到 IncidentPlaceCategory2)
  IntColumn get incidentLocation2Id => integer().nullable().references(IncidentPlaceCategory2, #id)();
  
  // 地點備註
  TextColumn get locationRemarks => text().nullable()();

  // 出勤時間
  DateTimeColumn get dispatchTime => dateTime().nullable()();
  
  // 到達現場時間
  DateTimeColumn get arrivalTime => dateTime().nullable()();

  // 送往醫院 (正規化：關聯到 ReferralHospital)
  IntColumn get hospitalId => integer().nullable().references(ReferralHospital, #id)();

  // 運送原因 (病情需要 / 病人家屬要求)
  TextColumn get transportReason => text().nullable()();

  // 離開現場時間
  DateTimeColumn get leavingSceneTime => dateTime().nullable()();

  // 到達醫院時間
  DateTimeColumn get arrivalHospitalTime => dateTime().nullable()();

  // 離開醫院時間
  DateTimeColumn get leavingHospitalTime => dateTime().nullable()();

  // 返回待命時間
  DateTimeColumn get returnStandbyTime => dateTime().nullable()();

  // 建立與更新時間
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 救護車個人財物表
@DataClassName('AmbulancePersonalPropertyData')
class AmbulancePersonalProperty extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 關聯到 MedicalRecord
  IntColumn get medicalId => integer().unique().references(MedicalRecord, #medicalId)();

  // 財務明細
  TextColumn get financialDetails => text().nullable()();
  
  // 是否經手
  BoolColumn get isHandled => boolean().withDefault(const Constant(false))();
  
  // 保管人姓名
  TextColumn get custodianName => text().nullable()();
  
  // 保管人簽名
  BlobColumn get custodianSignature => blob().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
