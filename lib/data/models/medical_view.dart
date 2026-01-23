import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../db/database.dart';

enum SaveStatus { idle, saving, success }

class MedicalViewModel extends ChangeNotifier {
  final AppDatabase db;
  final int medicalId;

  // --- 快取區 ---
  PatientData? _patientCache;
  PatientData? get patient => _patientCache;

  // 參考資料快取
  List<NationalityData> _nationalityOptions = [];
  List<NationalityData> get nationalityOptions => _nationalityOptions;

  List<SexData> _sexOptions = [];
  List<SexData> get sexOptions => _sexOptions;

  // 延遲存檔用的計時器 (Debounce)
  Timer? _debounceTimer;

  // 儲存狀態
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalViewModel(this.db, this.medicalId);

  // 初始化：從資料庫抓到記憶體
  Future<void> init() async {
    // 載入患者資料
    _patientCache = await db.medicalDao.getPatientByMedicalId(medicalId);

    // 載入參考資料
    await _loadReferenceData();

    notifyListeners();
  }

  // 載入參考資料（性別、國籍）
  Future<void> _loadReferenceData() async {
    try {
      // 載入性別選項
      _sexOptions = await db.referenceDao.getAllSex();

      // 載入國籍選項
      _nationalityOptions = await db.referenceDao.getAllNationality();

      debugPrint('系統：已載入 ${_sexOptions.length} 個性別選項');
      debugPrint('系統：已載入 ${_nationalityOptions.length} 個國籍選項');
    } catch (e) {
      debugPrint('系統：載入參考資料失敗 - $e');
    }
  }

  // 2. 更新快取並觸發自動存檔
  void _updateCacheAndSave(PatientData newData) {
    _patientCache = newData;
    notifyListeners();
    _autoSave();
  }

  // 更新患者姓名
  void updatePatientName(String name) {
    if (_patientCache == null) return;
    _updateCacheAndSave(_patientCache!.copyWith(name: Value(name)));
  }

  // 更新性別 ID
  void updateSexId(int sexId) {
    if (_patientCache == null) return;
    _updateCacheAndSave(_patientCache!.copyWith(sexId: Value(sexId)));
  }

  // 更新國籍 ID
  void updateNationalityId(int nationalityId) {
    if (_patientCache == null) return;
    _updateCacheAndSave(
      _patientCache!.copyWith(nationalityId: Value(nationalityId)),
    );
  }

  void updatePassport(String idNo) {
    if (_patientCache == null) return;
    _updateCacheAndSave(_patientCache!.copyWith(passportOrIdNo: Value(idNo)));
  }

  void updatePhone(String phone) {
    if (_patientCache == null) return;
    _updateCacheAndSave(_patientCache!.copyWith(telephone: Value(phone)));
  }

  void updateAddress(String address) {
    if (_patientCache == null) return;
    _updateCacheAndSave(_patientCache!.copyWith(address: Value(address)));
  }

  void updateBirthday(DateTime date) {
    if (_patientCache == null) return;

    // 計算年齡
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }

    _updateCacheAndSave(
      _patientCache!.copyWith(birthday: Value(date), age: Value(age)),
    );
  }

  // 根據 nationalityId 取得國籍物件
  NationalityData? getNationalityById(int? id) {
    if (id == null || _nationalityOptions.isEmpty) return null;
    try {
      return _nationalityOptions.firstWhere((n) => n.nationalityId == id);
    } catch (e) {
      return null;
    }
  }

  // 根據 sexId 取得性別物件
  SexData? getSexById(int? id) {
    if (id == null || _sexOptions.isEmpty) return null;
    try {
      return _sexOptions.firstWhere((s) => s.sexId == id);
    } catch (e) {
      return null;
    }
  }

  // 3. 延遲存檔邏輯 (Debounce)
  void _autoSave() {
    // 如果 2 秒內使用者有再輸入，就取消上一次的計時
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _saveStatus = SaveStatus.saving;

    // 重新計時 2 秒後寫入資料庫
    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      if (_patientCache != null) {
        _saveStatus = SaveStatus.saving;
        notifyListeners();

        debugPrint('系統：正在自動存檔至資料庫...');
        await db.medicalDao.updatePatient(_patientCache!);

        _saveStatus = SaveStatus.success;
        notifyListeners();

        // 3 秒後回到閒置狀態
        Future.delayed(const Duration(seconds: 3), () {
          _saveStatus = SaveStatus.idle;
          notifyListeners();
        });
      }
    });
  }

  // 當頁面關閉時，確保最後一份資料有存到
  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (_patientCache != null) {
      db.medicalDao.updatePatient(_patientCache!);
    }
    super.dispose();
  }
}
