import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class TelexDocumentViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // TELEX 文件資料快取
  TelexDocumentData? _documentCache;
  TelexDocumentData? get document => _documentCache;

  // 站點列表
  List<StationRefData> get stations => refService.stationList;

  StationRefData? get selectedToStation {
    if (_documentCache?.toStationId == null) return null;
    return stations.firstWhere(
      (s) => s.id == _documentCache!.toStationId,
      orElse: () => stations.first,
    );
  }

  StationRefData? get selectedFromStation {
    if (_documentCache?.fromStationId == null) return null;
    return stations.firstWhere(
      (s) => s.id == _documentCache!.fromStationId,
      orElse: () => stations.first,
    );
  }

  // 延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  TelexDocumentViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    // 載入 TELEX 文件資料
    _documentCache = await db.telexDao.getTelexByMedicalId(medicalId);

    // 如果不存在，建立預設記錄
    if (_documentCache == null) {
      debugPrint('系統：TELEX 文件不存在，建立預設記錄');
      await _createDefaultTelex();
      _documentCache = await db.telexDao.getTelexByMedicalId(medicalId);
    }

    notifyListeners();
  }

  // 建立預設 TELEX 文件
  Future<void> _createDefaultTelex() async {
    try {
      // 使用預設站點（T1_OCC 和 T1_MED）
      final toStation = refService.stationList.firstWhere(
        (s) => s.code == 'T1_OCC',
        orElse: () => refService.stationList.first,
      );
      final fromStation = refService.stationList.firstWhere(
        (s) => s.code == 'T1_MED',
        orElse: () => refService.stationList.first,
      );

      await db.telexDao.createTelex(
        medicalId,
        toStationId: toStation.id,
        fromStationId: fromStation.id,
      );
      debugPrint('系統：已建立預設 TELEX 文件');
    } catch (e) {
      debugPrint('系統：建立預設 TELEX 文件失敗 - $e');
      // 如果沒有站點資料，建立空的記錄
      await db.telexDao.createTelex(medicalId);
    }
  }

  // 更新收件站點
  void updateToStation(int? stationId) {
    if (_documentCache == null) return;
    _documentCache = _documentCache!.copyWith(toStationId: Value(stationId));
    notifyListeners();
    _debounceSave(
      () => db.telexDao.updateToStation(_documentCache!.documentId, stationId),
    );
  }

  // 更新寄件站點
  void updateFromStation(int? stationId) {
    if (_documentCache == null) return;
    _documentCache = _documentCache!.copyWith(fromStationId: Value(stationId));
    notifyListeners();
    _debounceSave(
      () =>
          db.telexDao.updateFromStation(_documentCache!.documentId, stationId),
    );
  }

  // 延遲存檔
  void _debounceSave(Future<int> Function() saveFunc) {
    _debounceTimer?.cancel();
    _saveStatus = SaveStatus.saving;
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      try {
        await saveFunc();
        _saveStatus = SaveStatus.success;
        debugPrint('系統：TELEX 文件已自動儲存');
      } catch (e) {
        debugPrint('系統：TELEX 文件儲存失敗 - $e');
        _saveStatus = SaveStatus.idle;
      }
      notifyListeners();

      // 2秒後重置狀態
      Future.delayed(const Duration(seconds: 2), () {
        _saveStatus = SaveStatus.idle;
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
