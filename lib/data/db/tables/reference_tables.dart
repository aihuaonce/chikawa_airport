import 'package:drift/drift.dart';

//參考表
//病患-性別表
class Sex extends Table {
  IntColumn get sexId => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
}

//病患-國籍表
class Nationality extends Table {
  IntColumn get nationalityId => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get code => text().withLength(min: 1, max: 10).nullable()();
}

//飛航-航空公司表
class Airline extends Table {
  IntColumn get airlineId => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get name => text()();
}

//飛航-旅行狀態表
class TravelStatus extends Table {
  IntColumn get travelStatusId => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get name => text()();
}

//飛航-地點表
class Location extends Table {
  IntColumn get locationId => integer().autoIncrement()();
  TextColumn get code => text()(); // TPE / NRT
  TextColumn get name => text()();
  TextColumn get countryCode => text()(); // TW / JP
}

//事故-一級地點表
class IncidentPlaceCategory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//事故-二級地點表
class IncidentPlaceCategory2 extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId =>
      integer().references(IncidentPlaceCategory, #id)();

  TextColumn get name => text()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//事故通報單位表
class ReportingUnit extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
