import 'dart:async';
import 'package:chikawa_airport/data/db/dao/flight_dao.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';
import '../sync_service_provider.dart';

enum SaveStatus { idle, saving, success }

class MedicalViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;
  final SyncServiceProvider? syncProvider;

  //  ??????
  PatientData? _patientCache;
  PatientData? get patient => _patientCache;

  //  ??????
  FlightRecordData? _flightCache;
  FlightRecordData? get flightRecord => _flightCache;

  List<TransitLocationWithData> _transitLocations = [];
  List<TransitLocationWithData> get transitLocations => _transitLocations;

  //?? refService
  List<NationalityData> get nationalityOptions => refService.nationalityList;
  List<SexData> get sexOptions => refService.sexList;
  List<VisitReasonData> get visitReasonOptions => refService.visitReasonList;
  List<AirlineData> get airlineOptions => refService.airlineList;
  List<TravelStatusData> get travelStatusOptions => refService.travelStatusList;
  List<LocationData> get locationOptions => refService.locationList;
  //  ???????
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalViewModel(
    this.db,
    this.refService,
    this.medicalId, {
    this.syncProvider,
  });

  // ???
  Future<void> init() async {
    // ????????????????
    final results = await Future.wait([
      db.medicalDao.getPatientByMedicalId(medicalId),
      db.flightDao.getFlightByMedicalId(medicalId),
    ]);

    _patientCache = results[0] as PatientData?;
    _flightCache = results[1] as FlightRecordData?;

    if (_flightCache == null) {
      debugPrint('?????????????????');
      await _createDefaultFlightRecord();
      _flightCache = await db.flightDao.getFlightByMedicalId(medicalId);
    }

    if (_flightCache != null) {
      await _loadTransitLocations();
    }

    notifyListeners();
  }

  Future<void> _loadTransitLocations() async {
    if (_flightCache == null) return;
    try {
      _transitLocations = await db.flightDao.getTransitLocations(
        _flightCache!.flightRecordId,
      );
      debugPrint('?????? ${_transitLocations.length} ????');
    } catch (e) {
      debugPrint('?????????? - $e');
    }
  }

  //????????
  Future<void> _createDefaultFlightRecord() async {
    try {
      await db.flightDao.createFlightRecord(
        medicalId: medicalId,
        airlineId: null,
        flightNumber: '',
        travelStatusId: null,
        departureLocationId: null,
        arrivalLocationId: null,
      );

      debugPrint('????????????');
    } catch (e) {
      debugPrint('????????????? - $e');
    }
  }

  //  ??????
  void _updatePatientCacheAndSave(PatientData newData) {
    _patientCache = newData;
    notifyListeners();
    _autoSave();
  }

  void updatePatientName(String name) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(_patientCache!.copyWith(name: Value(name)));
  }

  void updateSexId(int sexId) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(_patientCache!.copyWith(sexId: Value(sexId)));
  }

  void updateVisitReasonId(int visitReasonId) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(visitReasonId: Value(visitReasonId)),
    );
  }

  void updateNationalityId(int nationalityId) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(nationalityId: Value(nationalityId)),
    );
  }

  void updatePassport(String passport) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(passportOrIdNo: Value(passport)),
    );
  }

  void updateIdNo(String idNo) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(_patientCache!.copyWith(idNo: Value(idNo)));
  }

  void updatePhone(String phone) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(telephone: Value(phone)),
    );
  }

  void updateAddress(String address) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(address: Value(address)),
    );
  }

  void updateBirthday(DateTime date) {
    if (_patientCache == null) return;

    _updatePatientCacheAndSave(_patientCache!.copyWith(birthday: Value(date)));
  }

  //  ??????
  void _updateFlightCacheAndSave(FlightRecordData newData) {
    _flightCache = newData;
    notifyListeners();
    _autoSave();
  }

  void updateAirlineId(int airlineId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(airlineId: Value(airlineId)),
    );
  }

  void updateFlightNumber(String flightNumber) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(flightNumber: flightNumber),
    );
  }

  void updateTravelStatusId(int travelStatusId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(travelStatusId: Value(travelStatusId)),
    );
  }

  void updateDepartureLocationId(int locationId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(departureLocationId: Value(locationId)),
    );
  }

  void updateArrivalLocationId(int locationId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(arrivalLocationId: Value(locationId)),
    );
  }

  Future<void> addTransitLocation(int locationId) async {
    if (_flightCache == null) return;

    try {
      await db.flightDao.addTransitLocation(
        _flightCache!.flightRecordId,
        locationId,
        _transitLocations.length,
      );

      await _loadTransitLocations();
      notifyListeners();
      debugPrint('?????????');
    } catch (e) {
      debugPrint('?????????? - $e');
    }
  }

  Future<void> removeTransitLocation(int transitId) async {
    if (_flightCache == null) return;
    try {
      await db.flightDao.deleteTransitLocation(transitId);

      await _loadTransitLocations();
      notifyListeners();
      debugPrint('?????????');
    } catch (e) {
      debugPrint('?????????? - $e');
    }
  }

  //  ?????? (?????? refService ????)
  NationalityData? getNationalityById(int? id) {
    if (id == null) return null;
    try {
      return refService.nationalityList.firstWhere(
        (n) => n.nationalityId == id,
      );
    } catch (e) {
      return null;
    }
  }

  SexData? getSexById(int? id) {
    if (id == null) return null;
    try {
      return refService.sexList.firstWhere((s) => s.sexId == id);
    } catch (e) {
      return null;
    }
  }

  VisitReasonData? getVisitReasonById(int? id) {
    if (id == null) return null;
    try {
      return refService.visitReasonList.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  AirlineData? getAirlineById(int? id) {
    if (id == null) return null;
    try {
      return refService.airlineList.firstWhere((a) => a.airlineId == id);
    } catch (e) {
      return null;
    }
  }

  TravelStatusData? getTravelStatusById(int? id) {
    if (id == null) return null;
    try {
      return refService.travelStatusList.firstWhere(
        (t) => t.travelStatusId == id,
      );
    } catch (e) {
      return null;
    }
  }

  LocationData? getLocationById(int? id) {
    if (id == null) return null;
    try {
      return refService.locationList.firstWhere((l) => l.locationId == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<LocationData>> searchLocations(String keyword) async {
    // ??????????????????????????
    if (keyword.isEmpty) return refService.locationList;
    try {
      return await db.referenceDao.searchLocation(keyword);
    } catch (e) {
      debugPrint('????????? - $e');
      return [];
    }
  }

  // === ?????? (??) ===

  Future<List<AirlineData>> searchAirlines(String keyword) async {
    // ???????
    // 1. ? keyword ??????????? (isOther=false)
    // 2. ? keyword ??????????????? (?? isOther)
    // ???UI ???????? "??????" ??

    try {
      if (keyword.isEmpty) {
        // ?????
        return await db.referenceDao.getAllAirline(isOther: false);
      } else {
        // ????
        return await db.referenceDao.searchAirline(keyword);
      }
    } catch (e) {
      debugPrint('??????????? - $e');
      // ?????????
      // ???refService.airlineList ???????? (?? importAirlines ?????)
      // ?????? isOther
      final lower = keyword.toLowerCase();
      if (keyword.isEmpty) {
        return refService.airlineList.where((a) => !a.isOther).toList();
      }
      return refService.airlineList
          .where(
            (a) =>
                a.name.toLowerCase().contains(lower) ||
                a.code.toLowerCase().contains(lower),
          )
          .toList();
    }
  }

  // ????????????????
  Future<List<AirlineData>> getOtherAirlines() async {
    try {
      return await db.referenceDao.getAllAirline(isOther: true);
    } catch (e) {
      return refService.airlineList.where((a) => a.isOther).toList();
    }
  }

  Future<List<NationalityData>> searchNationalities(String keyword) async {
    if (keyword.isEmpty) return refService.nationalityList;
    try {
      return await db.referenceDao.searchNationality(keyword);
    } catch (e) {
      debugPrint('????????? - $e');
      final lower = keyword.toLowerCase();
      return refService.nationalityList
          .where(
            (n) =>
                n.name.toLowerCase().contains(lower) ||
                (n.nameEn?.toLowerCase().contains(lower) ?? false),
          )
          .toList();
    }
  }

  Future<List<TravelStatusData>> searchTravelStatus(String keyword) async {
    if (keyword.isEmpty) return refService.travelStatusList;
    final lower = keyword.toLowerCase();
    return refService.travelStatusList
        .where(
          (t) =>
              t.name.toLowerCase().contains(lower) ||
              t.code.toLowerCase().contains(lower),
        )
        .toList();
  }

  //  ??????
  void _autoSave() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _saveStatus = SaveStatus.saving;

    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      debugPrint('?????????????...');
      unawaited(_saveToDatabase());
    });
  }

  Future<void> _saveToDatabase() async {
    try {
      await db.transaction(() async {
        if (_patientCache != null) {
          await db.medicalDao.updatePatient(_patientCache!);
        }
        if (_flightCache != null) {
          await db.flightDao.updateFlight(_flightCache!);
        }
      });

      debugPrint('????????');

      // ??????

      if (!hasListeners) return;

      _saveStatus = SaveStatus.success;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));

      if (!hasListeners) return;

      _saveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('????????? - $e');
      if (!hasListeners) return;
    }
  }

  @override
  void dispose() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      // ???dispose ????????? db ????
      _saveToDatabase();
    }
    super.dispose();
  }
}
