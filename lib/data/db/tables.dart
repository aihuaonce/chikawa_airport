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

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

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
