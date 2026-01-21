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
