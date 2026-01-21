import 'package:drift/drift.dart';
import 'reference_tables.dart';

//醫療主表
class MedicalRecord extends Table {
  IntColumn get medicalId => integer().autoIncrement()();

  BoolColumn get isEmergency => boolean().withDefault(const Constant(false))();

  BoolColumn get hasAmbulance => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

//病患基本資料表
class Patient extends Table {
  IntColumn get patientId => integer().autoIncrement()();

  IntColumn get medicalId =>
      integer().unique().references(MedicalRecord, #medicalId)();

  TextColumn get name => text().nullable()();
  TextColumn get anonymizationName => text().nullable()();
  DateTimeColumn get birthday => dateTime().nullable()();
  IntColumn get age => integer().nullable()();

  IntColumn get sexId => integer().nullable().references(Sex, #sexId)();

  TextColumn get passportOrIdNo => text().nullable()();

  IntColumn get nationalityId =>
      integer().nullable().references(Nationality, #nationalityId)();

  TextColumn get telephone => text().nullable()();

  TextColumn get address => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
