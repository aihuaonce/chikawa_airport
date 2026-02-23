import 'package:drift/drift.dart';
import 'medical_tables.dart';

// 聯絡人基本資料表
class Contact extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  TextColumn get name => text()(); // 姓名
  TextColumn get phone => text().nullable()(); // 電話
  TextColumn get mobile => text().nullable()(); // 手機
  TextColumn get address => text().nullable()(); // 地址
  TextColumn get note => text().nullable()(); // 備註
  
  // 關聯到病患表
  IntColumn get patientId => integer().nullable().references(Patient, #patientId)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  TextColumn get remoteId => text().nullable()();
  DateTimeColumn get lastModified => dateTime().nullable()();
}
