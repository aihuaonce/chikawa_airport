import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class IncidentViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // 事故記錄快取
  IncidentRecordData? _incidentCache;
  IncidentRecordData? get incidentRecord => _incidentCache;

  // 二級地點動態載入
  List<IncidentPlaceCategory2Data> _currentCategory2Options = [];
  List<IncidentPlaceCategory2Data> get currentCategory2Options =>
      _currentCategory2Options;

  // 使用 refService 取得參考資料（一級地點和通報單位是預載的）
  List<IncidentPlaceCategoryData> get placeCategoryOptions =>
      refService.incidentPlaceCategories;
  List<ReportingUnitData> get reportingUnitOptions => refService.reportingUnits;

  // 延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  IncidentViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    _incidentCache = await db.incidentDao.getByMedicalId(medicalId);

    if (_incidentCache == null) {
      debugPrint('系統:事故記錄不存在,建立預設記錄');
      await _createDefaultIncidentRecord();
      _incidentCache = await db.incidentDao.getByMedicalId(medicalId);
    }

    // 如果已有一級地點，載入對應的二級地點
    if (_incidentCache != null) {
      await _loadCategory2Options(_incidentCache!.incidentPlaceCategoryId);
    }

    notifyListeners();
  }

  // 載入二級地點選項
  Future<void> _loadCategory2Options(int categoryId) async {
    try {
      _currentCategory2Options = await refService.getCategory2ByParent(
        categoryId,
      );
      debugPrint('系統:已載入 ${_currentCategory2Options.length} 個二級地點選項');
    } catch (e) {
      debugPrint('系統:載入二級地點失敗 - $e');
      _currentCategory2Options = [];
    }
  }

  // 建立預設事故記錄
  Future<void> _createDefaultIncidentRecord() async {
    try {
      if (refService.incidentPlaceCategories.isEmpty ||
          refService.reportingUnits.isEmpty) {
        debugPrint('系統:參考資料未初始化,無法建立事故記錄');
        return;
      }

      final now = DateTime.now();
      await db.incidentDao.createIncidentRecord(
        medicalId: medicalId,
        incidentDate: now,
        incidentPlaceCategoryId: refService.incidentPlaceCategories.first.id,
        reportingUnitId: refService.reportingUnits.first.id,
        notificationTime: now,
        beforeLanding: false,
        occArrived: false,
      );

      debugPrint('系統:已建立預設事故記錄');
    } catch (e) {
      debugPrint('系統:建立預設事故記錄失敗 - $e');
    }
  }

  // 事故記錄更新
  void _updateIncidentCacheAndSave(IncidentRecordData newData) {
    // 檢查是否有變更，有變更才設 syncStatus = 1
    final oldData = _incidentCache;
    final hasChanges =
        oldData == null ||
        oldData.incidentDate != newData.incidentDate ||
        oldData.incidentPlaceCategoryId != newData.incidentPlaceCategoryId ||
        oldData.incidentPlaceCategory2Id != newData.incidentPlaceCategory2Id ||
        oldData.incidentPlaceFinal != newData.incidentPlaceFinal ||
        oldData.notificationTime != newData.notificationTime ||
        oldData.notificationPerson != newData.notificationPerson ||
        oldData.reportingUnitId != newData.reportingUnitId ||
        oldData.incomingPhone != newData.incomingPhone ||
        oldData.notificationToOccTime != newData.notificationToOccTime ||
        oldData.teamDepartureTime != newData.teamDepartureTime ||
        oldData.occArrived != newData.occArrived ||
        oldData.beforeLanding != newData.beforeLanding ||
        oldData.landingTime != newData.landingTime ||
        oldData.medicalArrivalTime != newData.medicalArrivalTime ||
        oldData.examinationTime != newData.examinationTime;

    if (hasChanges) {
      _incidentCache = newData.copyWith(syncStatus: 1);
    } else {
      _incidentCache = newData;
    }
    notifyListeners();
    _autoSave();
  }

  // === 基本資訊更新 ===
  void updateIncidentDate(DateTime date) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(_incidentCache!.copyWith(incidentDate: date));
  }

  void updateNotificationTime(DateTime? time) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(notificationTime: Value(time)),
    );
  }

  void updateNotificationPerson(String? person) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(notificationPerson: Value(person)),
    );
  }

  void updateReportingUnitId(int unitId) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(reportingUnitId: unitId),
    );
  }

  // 接獲電話
  void updateIncomingPhone(String? phone) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(incomingPhone: Value(phone)),
    );
  }

  // 通報 OCC 時間
  void updateNotificationToOccTime(DateTime? time) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(notificationToOccTime: Value(time)),
    );
  }

  // 醫護出發時間
  void updateTeamDepartureTime(DateTime? time) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(teamDepartureTime: Value(time)),
    );
  }

  // OCC 已到達
  void updateOccArrived(bool arrived) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(_incidentCache!.copyWith(occArrived: arrived));
  }

  // === 地點資訊更新 ===

  // 更新一級地點時，同時載入對應的二級地點選項
  Future<void> updateIncidentPlaceCategoryId(int categoryId) async {
    if (_incidentCache == null) return;

    // 先清空二級地點
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(
        incidentPlaceCategoryId: categoryId,
        incidentPlaceCategory2Id: const Value(null),
        incidentPlaceFinal: const Value(null),
      ),
    );

    // 載入新的二級地點選項
    await _loadCategory2Options(categoryId);
    notifyListeners(); // 確保 UI 更新
  }

  void updateIncidentPlaceCategory2Id(int? category2Id) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(incidentPlaceCategory2Id: Value(category2Id)),
    );
  }

  void updateIncidentPlaceFinal(String? finalPlace) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(incidentPlaceFinal: Value(finalPlace)),
    );
  }

  // === 落地資訊更新 ===
  void updateBeforeLanding(bool beforeLanding) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(beforeLanding: beforeLanding),
    );
  }

  void updateLandingTime(DateTime? time) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(landingTime: Value(time)),
    );
  }

  // 🆕 新增：醫護到達時間
  void updateMedicalArrivalTime(DateTime? time) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(medicalArrivalTime: Value(time)),
    );
  }

  // 🆕 新增：檢查時間
  void updateExaminationTime(DateTime? time) {
    if (_incidentCache == null) return;
    _updateIncidentCacheAndSave(
      _incidentCache!.copyWith(examinationTime: Value(time)),
    );
  }

  // === 查詢輔助方法 ===
  IncidentPlaceCategoryData? getPlaceCategoryById(int? id) {
    if (id == null) return null;
    try {
      return refService.incidentPlaceCategories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // 從當前載入的二級選項中查詢
  IncidentPlaceCategory2Data? getPlaceCategory2ById(int? id) {
    if (id == null) return null;
    try {
      return _currentCategory2Options.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  ReportingUnitData? getReportingUnitById(int? id) {
    if (id == null) return null;
    try {
      return refService.reportingUnits.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  // === 搜尋輔助方法 (新增) ===

  Future<List<ReportingUnitData>> searchReportingUnits(String keyword) async {
    if (keyword.isEmpty) return refService.reportingUnits;
    final lower = keyword.toLowerCase();
    return refService.reportingUnits
        .where((u) => u.name.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<IncidentPlaceCategoryData>> searchPlaceCategories(
    String keyword,
  ) async {
    if (keyword.isEmpty) return refService.incidentPlaceCategories;
    final lower = keyword.toLowerCase();
    return refService.incidentPlaceCategories
        .where((c) => c.name.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<IncidentPlaceCategory2Data>> searchPlaceCategories2(
    String keyword,
  ) async {
    if (keyword.isEmpty) return _currentCategory2Options;
    final lower = keyword.toLowerCase();
    return _currentCategory2Options
        .where((c) => c.name.toLowerCase().contains(lower))
        .toList();
  }

  // === 延遲存檔邏輯 ===
  void _autoSave() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _saveStatus = SaveStatus.saving;

    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      debugPrint('系統:正在自動存檔至資料庫...');
      unawaited(_saveToDatabase());
    });
  }

  Future<void> _saveToDatabase() async {
    try {
      if (_incidentCache != null) {
        await db.incidentDao.updateIncident(_incidentCache!);
      }

      debugPrint('系統:事故記錄已儲存');

      if (!hasListeners) return;

      _saveStatus = SaveStatus.success;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));

      if (!hasListeners) return;

      _saveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('系統:自動存檔失敗 - $e');
      if (!hasListeners) return;
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
