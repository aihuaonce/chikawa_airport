import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../db/database.dart';

enum SaveStatus { idle, saving, success }

class MedicalViewModel extends ChangeNotifier {
  final AppDatabase db;
  final int medicalId;

  // ========== 病患資料快取 ==========
  PatientData? _patientCache;
  PatientData? get patient => _patientCache;

  // ========== 飛航記錄快取 ==========
  FlightRecordData? _flightCache;
  FlightRecordData? get flightRecord => _flightCache;

  List<LocationData> _transitLocations = [];
  List<LocationData> get transitLocations => _transitLocations;

  // ========== 參考資料快取 ==========
  List<NationalityData> _nationalityOptions = [];
  List<NationalityData> get nationalityOptions => _nationalityOptions;

  List<SexData> _sexOptions = [];
  List<SexData> get sexOptions => _sexOptions;

  List<AirlineData> _airlineOptions = [];
  List<AirlineData> get airlineOptions => _airlineOptions;

  List<TravelStatusData> _travelStatusOptions = [];
  List<TravelStatusData> get travelStatusOptions => _travelStatusOptions;

  List<LocationData> _locationOptions = [];
  List<LocationData> get locationOptions => _locationOptions;

  // ========== 延遲存檔與狀態 ==========
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalViewModel(this.db, this.medicalId);

  // 初始化：從資料庫抓到記憶體
  Future<void> init() async {
    // 載入病患資料
    _patientCache = await db.medicalDao.getPatientByMedicalId(medicalId);

    // 載入飛航記錄
    _flightCache = await db.flightDao.getFlightByMedicalId(medicalId);

    // 載入參考資料
    await _loadReferenceData();

    // 載入經過點
    if (_flightCache != null) {
      await _loadTransitLocations();
    }

    notifyListeners();
  }

  // 載入參考資料（性別、國籍）
  Future<void> _loadReferenceData() async {
    try {
      // 載入性別選項
      _sexOptions = await db.referenceDao.getAllSex();

      // 載入國籍選項
      _nationalityOptions = await db.referenceDao.getAllNationality();

      // 飛航相關參考資料
      _airlineOptions = await db.referenceDao.getAllAirline();
      _travelStatusOptions = await db.referenceDao.getAllTravelStatus();
      _locationOptions = await db.referenceDao.getAllLocation();

      debugPrint('系統：已載入 ${_sexOptions.length} 個性別選項');
      debugPrint('系統：已載入 ${_nationalityOptions.length} 個國籍選項');
      debugPrint('系統：已載入 ${_airlineOptions.length} 個航空公司選項');
      debugPrint('系統：已載入 ${_travelStatusOptions.length} 個旅行狀態選項');
      debugPrint('系統：已載入 ${_locationOptions.length} 個地點選項');
    } catch (e) {
      debugPrint('系統：載入參考資料失敗 - $e');
    }
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

  // ========== 病患資料更新 ==========
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
    _updatePatientCacheAndSave(_patientCache!.copyWith(telephone: Value(phone)));
  }

  void updateAddress(String address) {
    if (_patientCache == null) return;
    _updatePatientCacheAndSave(_patientCache!.copyWith(address: Value(address)));
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

  // ========== 飛航記錄更新 ==========
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

  // 經過點操作（不需要 debounce，直接寫入）
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
    try {
      await db.flightDao.deleteTransitLocation(transitId);
      await _loadTransitLocations();
      notifyListeners();
      debugPrint('系統：已刪除經過點');
    } catch (e) {
      debugPrint('系統：刪除經過點失敗 - $e');
    }
  }

  // ========== 查詢輔助方法 ==========
  NationalityData? getNationalityById(int? id) {
    if (id == null || _nationalityOptions.isEmpty) return null;
    try {
      return _nationalityOptions.firstWhere((n) => n.nationalityId == id);
    } catch (e) {
      return null;
    }
  }

  SexData? getSexById(int? id) {
    if (id == null || _sexOptions.isEmpty) return null;
    try {
      return _sexOptions.firstWhere((s) => s.sexId == id);
    } catch (e) {
      return null;
    }
  }

  AirlineData? getAirlineById(int? id) {
    if (id == null || _airlineOptions.isEmpty) return null;
    try {
      return _airlineOptions.firstWhere((a) => a.airlineId == id);
    } catch (e) {
      return null;
    }
  }

  TravelStatusData? getTravelStatusById(int? id) {
    if (id == null || _travelStatusOptions.isEmpty) return null;
    try {
      return _travelStatusOptions.firstWhere((t) => t.travelStatusId == id);
    } catch (e) {
      return null;
    }
  }

  LocationData? getLocationById(int? id) {
    if (id == null || _locationOptions.isEmpty) return null;
    try {
      return _locationOptions.firstWhere((l) => l.locationId == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<LocationData>> searchLocations(String keyword) async {
    if (keyword.isEmpty) return _locationOptions;
    try {
      return await db.referenceDao.searchLocation(keyword);
    } catch (e) {
      debugPrint('系統：搜尋地點失敗 - $e');
      return [];
    }
  }

  // ========== 延遲存檔邏輯 ==========
  void _autoSave() {
    // 如果 2 秒內使用者有再輸入，就取消上一次的計時
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _saveStatus = SaveStatus.saving;

    // 重新計時 2 秒後寫入資料庫
    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      _saveStatus = SaveStatus.saving;
      notifyListeners();

      debugPrint('系統：正在自動存檔至資料庫...');

      try {
        // 儲存病患資料
        if (_patientCache != null) {
          await db.medicalDao.updatePatient(_patientCache!);
          debugPrint('系統：病患資料已儲存');
        }

        // 儲存飛航記錄
        if (_flightCache != null) {
          await db.flightDao.updateFlight(_flightCache!);
          debugPrint('系統：飛航記錄已儲存');
        }

        _saveStatus = SaveStatus.success;
        notifyListeners();

        // 3 秒後回到閒置狀態
        Future.delayed(const Duration(seconds: 3), () {
          _saveStatus = SaveStatus.idle;
          notifyListeners();
        });
      } catch (e) {
        debugPrint('系統：自動存檔失敗 - $e');
        _saveStatus = SaveStatus.idle;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();

    // 確保最後一份資料有存到
    if (_patientCache != null) {
      db.medicalDao.updatePatient(_patientCache!);
    }
    if (_flightCache != null) {
      db.flightDao.updateFlight(_flightCache!);
    }

    super.dispose();
  }
}