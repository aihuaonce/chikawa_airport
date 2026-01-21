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

  // 延遲存檔用的計時器 (Debounce)
  Timer? _debounceTimer;

  // 儲存狀態
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalViewModel(this.db, this.medicalId);

  // 初始化：從資料庫抓到記憶體
  Future<void> init() async {
    _patientCache = await db.medicalDao.getPatientByMedicalId(medicalId);
    notifyListeners();
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
  void updateSexId(int index) {
    if (_patientCache == null) return;
    _updateCacheAndSave(_patientCache!.copyWith(sexId: Value(index)));
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
