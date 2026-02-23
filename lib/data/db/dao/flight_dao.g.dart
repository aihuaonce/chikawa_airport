// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_dao.dart';

// ignore_for_file: type=lint
mixin _$FlightDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $AirlineTable get airline => attachedDatabase.airline;
  $TravelStatusTable get travelStatus => attachedDatabase.travelStatus;
  $LocationTable get location => attachedDatabase.location;
  $FlightRecordTable get flightRecord => attachedDatabase.flightRecord;
  $FlightTransitLocationsTable get flightTransitLocations =>
      attachedDatabase.flightTransitLocations;
  FlightDaoManager get managers => FlightDaoManager(this);
}

class FlightDaoManager {
  final _$FlightDaoMixin _db;
  FlightDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$AirlineTableTableManager get airline =>
      $$AirlineTableTableManager(_db.attachedDatabase, _db.airline);
  $$TravelStatusTableTableManager get travelStatus =>
      $$TravelStatusTableTableManager(_db.attachedDatabase, _db.travelStatus);
  $$LocationTableTableManager get location =>
      $$LocationTableTableManager(_db.attachedDatabase, _db.location);
  $$FlightRecordTableTableManager get flightRecord =>
      $$FlightRecordTableTableManager(_db.attachedDatabase, _db.flightRecord);
  $$FlightTransitLocationsTableTableManager get flightTransitLocations =>
      $$FlightTransitLocationsTableTableManager(
        _db.attachedDatabase,
        _db.flightTransitLocations,
      );
}
