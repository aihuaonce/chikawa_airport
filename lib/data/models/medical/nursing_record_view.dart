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
    Uint8List? signature,
  }) async {
    try {
      final newId = await db.nursingRecordDao.insertRecord(
        medicalId: medicalId,
        recordTime: recordTime,
        content: content,
        nurseId: nurseId,
        signature: signature,
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

  // 根據護理師 ID 取得簽名 (自動帶入)
  Uint8List? getNurseSignature(int? nurseId) {
    if (nurseId == null) return null;
    try {
      final nurse = nurses.firstWhere((n) => n.id == nurseId);
      return nurse.signature;
    } catch (e) {
      return null;
    }
  }

  // 處理片語模板變數替換
  Future<String> applyTemplate(String template) async {
    String result = template;

    // 1. 生命徵象變數替換
    final vitals = await db.treatmentDao.getMedicalAssessments(medicalId);
    if (vitals.isNotEmpty) {
      final latest = vitals
          .first; // Note: Assuming descending order from DAO, first is latest

      // 體溫 {temp}
      result = result.replaceAll(
        '{temp}',
        latest.temperature != null ? '${latest.temperature}' : '--',
      );

      // 血壓 {bp}
      result = result.replaceAll(
        '{bp}',
        (latest.systolic != null && latest.diastolic != null)
            ? '${latest.systolic}/${latest.diastolic}'
            : '--/--',
      );

      // 脈搏 {pulse}
      result = result.replaceAll(
        '{pulse}',
        latest.pulse != null ? '${latest.pulse}' : '--',
      );

      // 血氧 {spo2}
      result = result.replaceAll(
        '{spo2}',
        latest.spo2 != null ? '${latest.spo2}' : '--',
      );

      // 呼吸 {rr}
      result = result.replaceAll(
        '{rr}',
        latest.breath != null ? '${latest.breath}' : '--',
      );

      // 意識 (GCS) {gcs}
      if (latest.gcsE != null || latest.gcsV != null || latest.gcsM != null) {
        final e = latest.gcsE != null ? 'E${latest.gcsE}' : '';
        final v = latest.gcsV != null ? 'V${latest.gcsV}' : '';
        final m = latest.gcsM != null ? 'M${latest.gcsM}' : '';
        result = result.replaceAll('{gcs}', '$e$v$m');
      } else {
        result = result.replaceAll('{gcs}', '--');
      }
    } else {
      // 若無生命徵象，所有相關變數設為 --
      result = result
          .replaceAll('{temp}', '--')
          .replaceAll('{bp}', '--/--')
          .replaceAll('{pulse}', '--')
          .replaceAll('{spo2}', '--')
          .replaceAll('{rr}', '--')
          .replaceAll('{gcs}', '--');
    }

    // 2. 血糖 {bs} - 來自 Treatment 表
    try {
      final treatment = await db.treatmentDao.getTreatment(medicalId);
      if (treatment != null &&
          treatment.glucose != null &&
          treatment.glucose!.isNotEmpty) {
        result = result.replaceAll('{bs}', treatment.glucose!);
      } else {
        result = result.replaceAll('{bs}', '--');
      }
    } catch (_) {
      result = result.replaceAll('{bs}', '--');
    }

    // 3. 主訴 {cc} - 來自 ChiefComplaint 表
    try {
      final ccData = await db.treatmentDao.getChiefComplaint(medicalId);
      if (ccData != null &&
          ccData.chiefComplaintFinal != null &&
          ccData.chiefComplaintFinal!.isNotEmpty) {
        result = result.replaceAll('{cc}', ccData.chiefComplaintFinal!);
      } else {
        result = result.replaceAll('{cc}', '--');
      }
    } catch (_) {
      result = result.replaceAll('{cc}', '--');
    }

    // --- 以下為 [bracket] 格式的行政與轉診資料替換 ---

    // 4. 通報資料 (IncidentRecord)
    // 變數: [通報單位], [通報人員], [事故地點]
    if (result.contains('[通報單位]') ||
        result.contains('[通報人員]') ||
        result.contains('[事故地點]')) {
      try {
        final incident = await db.incidentDao.getByMedicalId(medicalId);
        if (incident != null) {
          // 通報單位
          if (result.contains('[通報單位]')) {
            String unitName = '--';
            // reportingUnitId is non-nullable in generated code but might reference invalid ID?
            // Assuming it's an int, checking for null is redundant if generated code says int.
            // But if it's IntColumn.nullable(), then it's int?.
            // Let's assume nullable based on common sense for references, but linter said check is redundant.
            // If linter says redundant, it means it's NOT nullable.
            // So we remove the check.

            final units = refService.reportingUnits;
            final unit = units
                .where((u) => u.id == incident.reportingUnitId)
                .firstOrNull;
            if (unit != null) unitName = unit.name;

            result = result.replaceAll('[通報單位]', unitName);
          }

          // 通報人員
          if (result.contains('[通報人員]')) {
            result = result.replaceAll(
              '[通報人員]',
              incident.notificationPerson ?? '--',
            );
          }

          // 事故地點
          if (result.contains('[事故地點]')) {
            String place = incident.incidentPlaceFinal ?? '';
            if (place.isEmpty) {
              // 嘗試組合類別名稱
              final cats = refService.incidentPlaceCategories;
              final cat1 = cats
                  .where((c) => c.id == incident.incidentPlaceCategoryId)
                  .firstOrNull;
              if (cat1 != null) {
                place = cat1.name;
                // incidentPlaceCategory2Id might be null if only main category selected
                if (incident.incidentPlaceCategory2Id != null) {
                  final cat2List = await refService.getCategory2ByParent(
                    cat1.id,
                  );
                  final cat2 = cat2List
                      .where((c) => c.id == incident.incidentPlaceCategory2Id)
                      .firstOrNull;
                  if (cat2 != null) place += '-${cat2.name}';
                }
              }
            }
            result = result.replaceAll(
              '[事故地點]',
              place.isNotEmpty ? place : '--',
            );
          }
        } else {
          result = result
              .replaceAll('[通報單位]', '--')
              .replaceAll('[通報人員]', '--')
              .replaceAll('[事故地點]', '--');
        }
      } catch (_) {
        // ignore error
      }
    }

    // 5. 診斷與藥物 (Treatment / Referral / Medications)
    // 變數: [初步診斷], [藥物], [診斷書]
    if (result.contains('[初步診斷]') ||
        result.contains('[藥物]') ||
        result.contains('[診斷書]')) {
      // 初步診斷: 優先看 ReferralForm, 再看 Treatment
      if (result.contains('[初步診斷]')) {
        String diagnosis = '--';
        try {
          final referral = await db.referralFormDao.getFormByMedicalId(
            medicalId,
          );
          if (referral != null &&
              referral.primaryDiagnosis != null &&
              referral.primaryDiagnosis!.isNotEmpty) {
            diagnosis = referral.primaryDiagnosis!;
          } else {
            final treatment = await db.treatmentDao.getTreatment(medicalId);
            if (treatment != null && treatment.tentative != null) {
              diagnosis = treatment.tentative!;
            }
          }
        } catch (_) {}
        result = result.replaceAll('[初步診斷]', diagnosis);
      }

      // 藥物: 查詢用藥紀錄
      if (result.contains('[藥物]')) {
        String medsStr = '--';
        try {
          final meds = await db.treatmentDao.getMedications(medicalId);
          if (meds.isNotEmpty) {
            medsStr = meds.map((m) => m.name).join('、');
          }
        } catch (_) {}
        result = result.replaceAll('[藥物]', medsStr);
      }

      // 診斷書: 檢查是否有開立
      if (result.contains('[診斷書]')) {
        String certStr = '乙種診斷書'; // 預設或檢查是否已開立
        try {
          final cert = await db.certificateDao.getCertificateByMedicalId(
            medicalId,
          );
          if (cert != null) {
            certStr = '乙種診斷書(已開立)';
          } else {
            certStr = '乙種診斷書(未開立)';
          }
        } catch (_) {}
        result = result.replaceAll('[診斷書]', certStr);
      }
    }

    // 6. 轉診與轉送 (Referral / Treatment)
    // 變數: [轉診醫院], [轉送醫院]
    if (result.contains('[轉診醫院]') || result.contains('[轉送醫院]')) {
      String hospitalName = '--';
      try {
        final referral = await db.referralFormDao.getFormByMedicalId(medicalId);
        if (referral != null && referral.hospitalName != null) {
          hospitalName = referral.hospitalName!;
        } else {
          final treatment = await db.treatmentDao.getTreatment(medicalId);
          if (treatment != null && treatment.referralHospitalId != null) {
            final hospitals = refService.referralHospitals;
            final h = hospitals
                .where((h) => h.id == treatment.referralHospitalId)
                .firstOrNull;
            if (h != null) hospitalName = h.name;
          }
        }
      } catch (_) {}
      result = result.replaceAll('[轉診醫院]', hospitalName);
      result = result.replaceAll('[轉送醫院]', hospitalName);
    }

    // 7. 費用與支付 (MedicalFees)
    // 變數: [出診費], [支付方式]
    if (result.contains('[出診費]') || result.contains('[支付方式]')) {
      try {
        final fee = await db.medicalFeeDao.getFeeByMedicalId(medicalId);
        if (fee != null) {
          if (result.contains('[出診費]')) {
            final total = (fee.consultFee) + (fee.ambulanceFee);
            result = result.replaceAll('[出診費]', 'NT\$$total');
          }
          if (result.contains('[支付方式]')) {
            String payment = '--';
            if (fee.paymentMethodId != null) {
              final methods = refService.paymentMethodList;
              final m = methods
                  .where((p) => p.id == fee.paymentMethodId)
                  .firstOrNull;
              if (m != null) payment = m.name;
            }
            result = result.replaceAll('[支付方式]', payment);
          }
        } else {
          result = result.replaceAll('[出診費]', '--').replaceAll('[支付方式]', '--');
        }
      } catch (_) {
        result = result.replaceAll('[出診費]', '--').replaceAll('[支付方式]', '--');
      }
    }

    return result;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
