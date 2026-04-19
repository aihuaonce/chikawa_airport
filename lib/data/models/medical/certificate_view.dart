import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class MedicalCertificateViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // 證明書資料快取
  MedicalCertificateData? _certificateCache;
  MedicalCertificateData? get certificate => _certificateCache;

  // 診斷分類快取
  List<DiagnosisCategoryData> get diagnosisCategories =>
      refService.diagnosisCategories;

  DiagnosisCategoryData? get selectedCategory {
    if (_certificateCache?.diagnosisCategoryId == null) return null;
    return diagnosisCategories.firstWhere(
      (c) => c.id == _certificateCache!.diagnosisCategoryId,
      orElse: () => diagnosisCategories.first,
    );
  }

  // 延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalCertificateViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    // 載入證明書資料
    await _loadCertificate();
    notifyListeners();
  }

  // 載入診斷證明書
  Future<void> _loadCertificate() async {
    _certificateCache = await db.certificateDao.getCertificateByMedicalId(
      medicalId,
    );

    // 如果不存在，建立預設記錄
    if (_certificateCache == null) {
      debugPrint('系統：診斷證明書不存在，建立預設記錄');
      await _createDefaultCertificate();
      _certificateCache = await db.certificateDao.getCertificateByMedicalId(
        medicalId,
      );
    }
  }

  // 重新整理（同步後呼叫）
  Future<void> refresh() async {
    await _loadCertificate();
    notifyListeners();
    debugPrint('系統：診斷證明書已重新整理');
  }

  // 建立預設診斷證明書
  Future<void> _createDefaultCertificate() async {
    try {
      await db.certificateDao.createCertificate(medicalId);
      debugPrint('系統：已建立預設診斷證明書');
    } catch (e) {
      debugPrint('系統：建立預設診斷證明書失敗 - $e');
    }
  }

  // 更新診斷結果
  void updateDiagnosisResult(String? value) {
    if (_certificateCache == null) return;
    _certificateCache = _certificateCache!.copyWith(
      diagnosisResult: Value(value),
    );
    notifyListeners();
    _autoSave();
  }

  // 更新診斷分類
  void updateDiagnosisCategoryId(int? categoryId) {
    if (_certificateCache == null) return;
    _certificateCache = _certificateCache!.copyWith(
      diagnosisCategoryId: Value(categoryId),
    );
    notifyListeners();
    _autoSave();
  }

  // 更新中文囑言
  void updateChineseAdvice(String? value) {
    if (_certificateCache == null) return;
    _certificateCache = _certificateCache!.copyWith(
      chineseAdvice: Value(value),
    );
    notifyListeners();
    _autoSave();
  }

  // 更新英文囑言
  void updateEnglishAdvice(String? value) {
    if (_certificateCache == null) return;
    _certificateCache = _certificateCache!.copyWith(
      englishAdvice: Value(value),
    );
    notifyListeners();
    _autoSave();
  }

  // 更新開立日期
  void updateIssuanceDate(DateTime? date) {
    if (_certificateCache == null) return;
    _certificateCache = _certificateCache!.copyWith(issuanceDate: Value(date));
    notifyListeners();
    _autoSave();
  }

  // 自動存檔
  void _autoSave() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _saveStatus = SaveStatus.saving;
    // notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      debugPrint('系統：正在自動存檔診斷證明書...');
      await _saveToDatabase();
    });
  }

  Future<void> _saveToDatabase() async {
    try {
      if (_certificateCache != null) {
        await db.certificateDao.updateCertificate(_certificateCache!);
      }
      _saveStatus = SaveStatus.success;
      debugPrint('系統：診斷證明書已儲存');
      notifyListeners();

      Future.delayed(const Duration(seconds: 2), () {
        _saveStatus = SaveStatus.idle;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('系統：診斷證明書儲存失敗 - $e');
      _saveStatus = SaveStatus.idle;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      _saveToDatabase();
    }
    super.dispose();
  }
}
