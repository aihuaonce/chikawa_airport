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

//飛航紀錄表
class FlightRecord extends Table {
  IntColumn get flightRecordId => integer().autoIncrement()();

  IntColumn get medicalId =>
      integer().unique().references(MedicalRecord, #medicalId)();

  IntColumn get airlineId => integer().references(Airline, #airlineId)();
  TextColumn get flightNumber => text()();

  IntColumn get travelStatusId =>
      integer().references(TravelStatus, #travelStatusId)();

  IntColumn get departureLocationId =>
      integer().references(Location, #locationId)();

  IntColumn get arrivalLocationId =>
      integer().references(Location, #locationId)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

//飛航-經過點表
class FlightTransitLocations extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 關聯到原本的飛航記錄
  IntColumn get flightRecordId => integer().references(
    FlightRecord,
    #flightRecordId,
    onDelete: KeyAction.cascade,
  )();

  // 關聯到地點表
  IntColumn get locationId => integer().references(Location, #locationId)();

  // 排序：例如第一站、第二站
  IntColumn get stopOrder => integer().withDefault(const Constant(0))();
}
