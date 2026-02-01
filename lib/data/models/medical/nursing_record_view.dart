import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class NursingRecordViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // 護理記錄列表
  List<NursingRecordData> _records = [];
  List<NursingRecordData> get records => _records;

  // 醫護人員列表（護理師）
  List<MedicalStaffData> get nurses =>
      refService.medicalStaffList.where((s) => s.role == 'NURSE').toList();

  // 護理常用語
  List<NursingPhraseData> get phrases => refService.nursingPhraseList;

  // 延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  // 編輯中的記錄 ID（用於內嵌編輯）
  int? _editingRecordId;
  int? get editingRecordId => _editingRecordId;

  NursingRecordViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    await _loadRecords();
    notifyListeners();
  }

  // 載入所有護理記錄
  Future<void> _loadRecords() async {
    try {
      _records = await db.nursingRecordDao.getRecordsByMedicalId(medicalId);
      debugPrint('系統：已載入 ${_records.length} 筆護理記錄');
    } catch (e) {
      debugPrint('系統：載入護理記錄失敗 - $e');
    }
  }

  // 新增護理記錄
  Future<void> addRecord({
    required DateTime recordTime,
    required String content,
    int? nurseId,
  }) async {
    try {
      final newId = await db.nursingRecordDao.insertRecord(
        medicalId: medicalId,
        recordTime: recordTime,
        content: content,
        nurseId: nurseId,
      );

      // 重新載入列表
      await _loadRecords();
      notifyListeners();

      debugPrint('系統：已新增護理記錄 ID=$newId');
    } catch (e) {
      debugPrint('系統：新增護理記錄失敗 - $e');
    }
  }

  // 更新護理記錄
  Future<void> updateRecord(
    int recordId, {
    DateTime? recordTime,
    String? content,
    int? nurseId,
  }) async {
    try {
      await db.nursingRecordDao.updateRecord(
        recordId,
        recordTime: recordTime,
        content: content,
        nurseId: nurseId,
      );

      // 更新本地快取
      final index = _records.indexWhere((r) => r.recordId == recordId);
      if (index != -1) {
        _records[index] = _records[index].copyWith(
          recordTime: recordTime ?? _records[index].recordTime,
          content: content ?? _records[index].content,
          nurseId: nurseId != null
              ? Value(nurseId)
              : Value(_records[index].nurseId),
        );
        notifyListeners();
      }

      debugPrint('系統：已更新護理記錄 ID=$recordId');
    } catch (e) {
      debugPrint('系統：更新護理記錄失敗 - $e');
    }
  }

  // 更新記錄內容（用於內嵌編輯）
  void updateRecordContent(int recordId, String content) {
    final index = _records.indexWhere((r) => r.recordId == recordId);
    if (index == -1) return;

    _records[index] = _records[index].copyWith(content: content);
    notifyListeners();

    _debounceSave(
      () => db.nursingRecordDao.updateRecord(recordId, content: content),
    );
  }

  // 更新記錄時間
  void updateRecordTime(int recordId, DateTime recordTime) {
    final index = _records.indexWhere((r) => r.recordId == recordId);
    if (index == -1) return;

    _records[index] = _records[index].copyWith(recordTime: recordTime);
    notifyListeners();

    _debounceSave(
      () => db.nursingRecordDao.updateRecord(recordId, recordTime: recordTime),
    );
  }

  // 更新護理師
  void updateRecordNurse(int recordId, int? nurseId) {
    final index = _records.indexWhere((r) => r.recordId == recordId);
    if (index == -1) return;

    _records[index] = _records[index].copyWith(nurseId: Value(nurseId));
    notifyListeners();

    _debounceSave(
      () => db.nursingRecordDao.updateRecord(recordId, nurseId: nurseId),
    );
  }

  // 刪除護理記錄
  Future<void> deleteRecord(int recordId) async {
    try {
      await db.nursingRecordDao.deleteRecord(recordId);
      _records.removeWhere((r) => r.recordId == recordId);
      notifyListeners();
      debugPrint('系統：已刪除護理記錄 ID=$recordId');
    } catch (e) {
      debugPrint('系統：刪除護理記錄失敗 - $e');
    }
  }

  // 新增簽名
  Future<void> addSignature(int recordId, Uint8List signature) async {
    try {
      await db.nursingRecordDao.updateSignature(recordId, signature);

      // 更新本地快取
      final index = _records.indexWhere((r) => r.recordId == recordId);
      if (index != -1) {
        _records[index] = _records[index].copyWith(signature: Value(signature));
        notifyListeners();
      }

      debugPrint('系統：已新增護理記錄簽名 ID=$recordId');
    } catch (e) {
      debugPrint('系統：新增護理記錄簽名失敗 - $e');
    }
  }

  // 設置編輯中記錄
  void setEditingRecord(int? recordId) {
    _editingRecordId = recordId;
    notifyListeners();
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
        debugPrint('系統：護理記錄已自動儲存');
      } catch (e) {
        debugPrint('系統：護理記錄儲存失敗 - $e');
        _saveStatus = SaveStatus.idle;
      }
      notifyListeners();

      Future.delayed(const Duration(seconds: 2), () {
        _saveStatus = SaveStatus.idle;
        notifyListeners();
      });
    });
  }

  // 根據護理師 ID 取得姓名
  String? getNurseNameById(int? nurseId) {
    if (nurseId == null) return null;
    try {
      final nurse = nurses.firstWhere((n) => n.id == nurseId);
      return nurse.name;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
