import 'dart:async';
import 'package:chikawa_airport/data/db/dao/flight_dao.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class MedicalViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  //  病患資料快取
  PatientData? _patientCache;
  PatientData? get patient => _patientCache;

  //  飛航記錄快取
  FlightRecordData? _flightCache;
  FlightRecordData? get flightRecord => _flightCache;

  List<TransitLocationWithData> _transitLocations = [];
  List<TransitLocationWithData> get transitLocations => _transitLocations;

  //使用 refService
  List<NationalityData> get nationalityOptions => refService.nationalityList;
  List<SexData> get sexOptions => refService.sexList;
  List<AirlineData> get airlineOptions => refService.airlineList;
  List<TravelStatusData> get travelStatusOptions => refService.travelStatusList;
  List<LocationData> get locationOptions => refService.locationList;
  //  延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    // 並行載入病患與飛航資料，速度更快
    final results = await Future.wait([
      db.medicalDao.getPatientByMedicalId(medicalId),
      db.flightDao.getFlightByMedicalId(medicalId),
    ]);

    _patientCache = results[0] as PatientData?;
    _flightCache = results[1] as FlightRecordData?;

    if (_flightCache == null) {
      debugPrint('系統：飛航記錄不存在，建立預設記錄');
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
      debugPrint('系統：已載入 ${_transitLocations.length} 個經過點');
    } catch (e) {
      debugPrint('系統：載入經過點失敗 - $e');
    }
  }

  //建立預設飛航記錄
  Future<void> _createDefaultFlightRecord() async {
    try {
      // 【優化】直接從 refService 拿預設值，不再查資料庫
      if (refService.airlineList.isEmpty ||
          refService.travelStatusList.isEmpty ||
          refService.locationList.isEmpty) {
        debugPrint('系統：參考資料未初始化，無法建立飛航記錄');
        return;
      }

      await db.flightDao.createFlightRecord(
        medicalId: medicalId,
        airlineId: refService.airlineList.first.airlineId,
        flightNumber: '',
        travelStatusId: refService.travelStatusList.first.travelStatusId,
        departureLocationId: refService.locationList.first.locationId,
        arrivalLocationId: refService.locationList.first.locationId,
      );

      debugPrint('系統：已建立預設飛航記錄');
    } catch (e) {
      debugPrint('系統：建立預設飛航記錄失敗 - $e');
    }
  }

  //  病患資料更新
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

  void updateNationalityId(int nationalityId) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(nationalityId: Value(nationalityId)),
    );
  }

  void updatePassport(String idNo) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(
      _patientCache!.copyWith(passportOrIdNo: Value(idNo)),
    );
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

    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }

    _updatePatientCacheAndSave(
      _patientCache!.copyWith(birthday: Value(date), age: Value(age)),
    );
  }

  //  飛航記錄更新
  void _updateFlightCacheAndSave(FlightRecordData newData) {
    _flightCache = newData;
    notifyListeners();
    _autoSave();
  }

  void updateAirlineId(int airlineId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(_flightCache!.copyWith(airlineId: airlineId));
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
      _flightCache!.copyWith(travelStatusId: travelStatusId),
    );
  }

  void updateDepartureLocationId(int locationId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(departureLocationId: locationId),
    );
  }

  void updateArrivalLocationId(int locationId) {
    if (_flightCache == null) return;
    _updateFlightCacheAndSave(
      _flightCache!.copyWith(arrivalLocationId: locationId),
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
      debugPrint('系統：已新增經過點');
    } catch (e) {
      debugPrint('系統：新增經過點失敗 - $e');
    }
  }

  Future<void> removeTransitLocation(int transitId) async {
    if (_flightCache == null) return;
    try {
      await db.flightDao.deleteTransitLocation(transitId);

      await _loadTransitLocations();
      notifyListeners();
      debugPrint('系統：已刪除經過點');
    } catch (e) {
      debugPrint('系統：刪除經過點失敗 - $e');
    }
  }

  //  查詢輔助方法 (優化後直接對 refService 進行查詢)
  NationalityData? getNationalityById(int? id) {
    if (id == null) return null;
    try {
      return refService.nationalityList.firstWhere((n) => n.nationalityId == id);
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
    // 【優化】搜尋時如果沒有關鍵字，直接回傳快取的地點列表
    if (keyword.isEmpty) return refService.locationList;
    try {
      return await db.referenceDao.searchLocation(keyword);
    } catch (e) {
      debugPrint('系統：搜尋地點失敗 - $e');
      return [];
    }
  }

  //  延遲存檔邏輯
  void _autoSave() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _saveStatus = SaveStatus.saving;

    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      debugPrint('系統：正在自動存檔至資料庫...');
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

      debugPrint('系統：資料已儲存');

      if (!hasListeners) return;

      _saveStatus = SaveStatus.success;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));

      if (!hasListeners) return;

      _saveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('系統：自動存檔失敗 - $e');
      if (!hasListeners) return;
      _saveStatus = SaveStatus.idle;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      // 注意：dispose 時執行存檔需要確保 db 還沒關閉
      _saveToDatabase();
    }
    super.dispose();
  }
}
