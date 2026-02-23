import 'package:drift/drift.dart';

@DataClassName('SyncLogEntry')
class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityName => text()();
  IntColumn get recordId => integer()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  IntColumn get status => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
}

@DataClassName('SyncConfigEntry')
class SyncConfigTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
}

class SyncStatus {
  static const int synced = 0;
  static const int pending = 1;
  static const int conflict = 2;
  static const int failed = 3;
}

class SyncOperation {
  static const String insert = 'insert';
  static const String update = 'update';
  static const String delete = 'delete';
}
