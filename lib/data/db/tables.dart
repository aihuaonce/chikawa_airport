import 'package:drift/drift.dart';

/// 1) 個案主檔（HomePage 列表就讀這張）
class Visits extends Table {
  IntColumn get visitId => integer().autoIncrement()();

  // HomePage 顯示用的摘要欄位（分頁各自回寫）
  TextColumn get patientName => text().nullable()();   // 之後在姓名頁回寫
  TextColumn get gender => text().nullable()();        // 個人資料頁回寫
  TextColumn get nationality => text().nullable()();   // 個人資料頁回寫
  TextColumn get dept => text().nullable()();          // 之後在科別頁回寫
  TextColumn get note => text().nullable()();          // 之後某頁回寫
  TextColumn get filledBy => text().nullable()();      // 之後某頁回寫

  DateTimeColumn get uploadedAt =>
      dateTime().withDefault(currentDateAndTime)();    // 建立/更新時間
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

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
  IntColumn get age => integer().nullable()();          // ✅ 建議加 age 欄位
  TextColumn get gender => text().nullable()();         // 與主檔同步
  TextColumn get reason => text().nullable()();
  TextColumn get nationality => text().nullable()();    // 與主檔同步
  TextColumn get idNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get photoPath => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get indexes => [
        {visitId},
        {gender},
        {nationality},
      ];
}
