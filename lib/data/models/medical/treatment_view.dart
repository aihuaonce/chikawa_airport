import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class TreatmentViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // === 各種資料快取 ===

  // 醫療主表記錄
  MedicalRecordData? _medicalRecord;
  MedicalRecordData? get medicalRecord => _medicalRecord;

  // 健康評估表列表
  List<HealthAssessmentFormData> _healthAssessments = [];
  List<HealthAssessmentFormData> get healthAssessments => _healthAssessments;

  // 主訴記錄
  ChiefComplaintData? _chiefComplaint;
  ChiefComplaintData? get chiefComplaint => _chiefComplaint;

  // 醫療影像列表
  List<MedicalMediaData> _medicalMediaList = [];
  List<MedicalMediaData> get medicalMediaList => _medicalMediaList;

  // 醫療評估列表
  List<MedicalAssessmentData> _medicalAssessments = [];
  List<MedicalAssessmentData> get medicalAssessments => _medicalAssessments;

  // 病史記錄
  MedicalHistoryData? _medicalHistory;
  MedicalHistoryData? get medicalHistory => _medicalHistory;

  // 處置/診斷記錄（主要快取）
  TreatmentData? _treatment;
  TreatmentData? get treatment => _treatment;

  // 醫療人員指派列表
  List<MedicalStaffAssignmentData> _staffAssignments = [];
  List<MedicalStaffAssignmentData> get staffAssignments => _staffAssignments;

  // 特別註記
  SpecialNotesData? _specialNotes;
  SpecialNotesData? get specialNotes => _specialNotes;

  // === 參考資料（從 refService 取得）===

  List<ChiefComplaintTypeData> get complaintTypes =>
      refService.chiefComplaintTypes;
  List<ChiefComplaintDetailData> getChiefComplaintDetails(int typeId) =>
      refService.getChiefComplaintDetailsByType(typeId);
  List<DiagnosisCategoryData> get diagnosisCategories =>
      refService.diagnosisCategories;
  List<TriageLevelData> get triageLevels => refService.triageLevels;
  List<TreatmentOnSiteData> get treatmentOnSites => refService.treatmentOnSites;
  List<TreatmentResultData> get treatmentResults => refService.treatmentResults;
  List<ReferralHospitalData> get referralHospitals =>
      refService.referralHospitals;
  List<ActionItemData> get actionItems => refService.actionItems;
  List<MedicalStaffData> get medicalStaffList => refService.medicalStaffList;
  List<SpecialNoteRefData> get specialNoteRefs => refService.specialNoteRefs;

  // === 延遲存檔與狀態 ===
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  TreatmentViewModel(this.db, this.refService, this.medicalId);

  // === 初始化 ===
  Future<void> init() async {
    await _loadAllData();
    notifyListeners();
  }

  Future<void> _loadAllData() async {
    // 載入醫療主表記錄
    _medicalRecord = await db.medicalDao.getMedicalById(medicalId);

    // 載入健康評估表
    _healthAssessments = await db.treatmentDao.getHealthAssessments(medicalId);

    // 載入主訴
    _chiefComplaint = await db.treatmentDao.getChiefComplaint(medicalId);

    // 載入醫療影像
    _medicalMediaList = await db.treatmentDao.getMedicalMediaList(medicalId);

    // 載入醫療評估
    _medicalAssessments = await db.treatmentDao.getMedicalAssessments(
      medicalId,
    );

    // 載入病史
    _medicalHistory = await db.treatmentDao.getMedicalHistory(medicalId);

    // 載入處置/診斷
    _treatment = await db.treatmentDao.getTreatment(medicalId);
    if (_treatment == null) {
      await _createDefaultTreatment();
      _treatment = await db.treatmentDao.getTreatment(medicalId);
    }

    // 載入醫療人員指派
    _staffAssignments = await db.treatmentDao.getStaffAssignments(medicalId);

    // 載入特別註記
    _specialNotes = await db.treatmentDao.getSpecialNotes(medicalId);
  }

  // === 建立預設處置記錄 ===
  Future<void> _createDefaultTreatment() async {
    try {
      await db.treatmentDao.insertTreatment(
        TreatmentCompanion.insert(
          medicalId: medicalId,
          transportRequired: const Value(false),
        ),
      );
      debugPrint('系統:已建立預設處置記錄');
    } catch (e) {
      debugPrint('系統:建立預設處置記錄失敗 - $e');
    }
  }

  // ===================================================================
  // 健康評估表 CRUD
  // ===================================================================

  Future<void> addHealthAssessment({
    required String name,
    required String relation,
    double? temperature,
  }) async {
    try {
      await db.treatmentDao.insertHealthAssessment(
        HealthAssessmentFormCompanion.insert(
          medicalId: medicalId,
          name: name,
          relation: relation,
          temperature: temperature ?? 0.0,
        ),
      );
      await _reloadHealthAssessments();
      debugPrint('系統:新增健康評估表成功');
    } catch (e) {
      debugPrint('系統:新增健康評估表失敗 - $e');
    }
  }

  Future<void> deleteHealthAssessment(int id) async {
    try {
      await db.treatmentDao.deleteHealthAssessment(id);
      await _reloadHealthAssessments();
      debugPrint('系統:刪除健康評估表成功');
    } catch (e) {
      debugPrint('系統:刪除健康評估表失敗 - $e');
    }
  }

  Future<void> updateHealthAssessment({
    required int assessmentFormId,
    required String name,
    required String relation,
    required double temperature,
  }) async {
    try {
      await db.treatmentDao.updateHealthAssessment(
        HealthAssessmentFormCompanion(
          assessmentFormId: Value(assessmentFormId),
          medicalId: Value(medicalId),
          name: Value(name),
          relation: Value(relation),
          temperature: Value(temperature),
        ),
      );
      await _reloadHealthAssessments();
      debugPrint('系統:更新健康評估表成功');
    } catch (e) {
      debugPrint('系統:更新健康評估表失敗 - $e');
    }
  }

  // ===================================================================
  // CDC 篩檢相關
  // ===================================================================

  Future<void> updateCDCStatus({
    required bool cdcPassed,
    required String screeningMethod,
  }) async {
    try {
      // 更新 Medical 表中的 CDC 篩檢狀態（不是 Treatment 表）
      await db.medicalDao.updateCDCStatus(
        medicalId: medicalId,
        cdcPassed: cdcPassed,
        screeningMethod: screeningMethod,
      );
      await _reloadMedicalRecord();
      debugPrint('系統:CDC 篩檢狀態已更新（Medical 表）');
    } catch (e) {
      debugPrint('系統:更新 CDC 篩檢狀態失敗 - $e');
    }
  }

  Future<void> _reloadHealthAssessments() async {
    _healthAssessments = await db.treatmentDao.getHealthAssessments(medicalId);
    notifyListeners();
  }

  Future<void> _reloadMedicalRecord() async {
    _medicalRecord = await db.medicalDao.getMedicalById(medicalId);
    notifyListeners();
  }

  // ===================================================================
  // 主訴更新
  // ===================================================================

  Future<void> updateChiefComplaint({
    int? chiefComplaintTypeId,
    String? selectedSymptoms,
    String? otherSymptomDetail,
    String? chiefComplaintFinal,
    String? supplementaryNotes,
    DateTime? onsetTime,
    String? reportedBy,
    bool? isConfirmed,
  }) async {
    try {
      if (_chiefComplaint == null) {
        // 建立新記錄
        await db.treatmentDao.insertChiefComplaint(
          ChiefComplaintCompanion.insert(
            medicalId: medicalId,
            chiefComplaintTypeId: Value(chiefComplaintTypeId),
            selectedSymptoms: Value(selectedSymptoms),
            otherSymptomDetail: Value(otherSymptomDetail),
            chiefComplaintFinal: Value(chiefComplaintFinal),
            supplementaryNotes: Value(supplementaryNotes),
            onsetTime: Value(onsetTime),
            reportedBy: Value(reportedBy),
            isConfirmed: Value(isConfirmed ?? false),
          ),
        );
      } else {
        // 更新現有記錄
        await db.treatmentDao.updateChiefComplaint(
          ChiefComplaintCompanion(
            complaintId: Value(_chiefComplaint!.complaintId),
            chiefComplaintTypeId: chiefComplaintTypeId != null
                ? Value(chiefComplaintTypeId)
                : const Value.absent(),
            selectedSymptoms: selectedSymptoms != null
                ? Value(selectedSymptoms)
                : const Value.absent(),
            otherSymptomDetail: otherSymptomDetail != null
                ? Value(otherSymptomDetail)
                : const Value.absent(),
            chiefComplaintFinal: chiefComplaintFinal != null
                ? Value(chiefComplaintFinal)
                : const Value.absent(),
            supplementaryNotes: supplementaryNotes != null
                ? Value(supplementaryNotes)
                : const Value.absent(),
            onsetTime: onsetTime != null
                ? Value(onsetTime)
                : const Value.absent(),
            reportedBy: reportedBy != null
                ? Value(reportedBy)
                : const Value.absent(),
            isConfirmed: isConfirmed != null
                ? Value(isConfirmed)
                : const Value.absent(),
          ),
        );
      }
      _chiefComplaint = await db.treatmentDao.getChiefComplaint(medicalId);
      notifyListeners();
      debugPrint('系統:主訴更新成功');
    } catch (e) {
      debugPrint('系統:主訴更新失敗 - $e');
    }
  }

  // ===================================================================
  // 醫療影像 CRUD
  // ===================================================================

  Future<void> addMedicalMedia({
    required String mediaType,
    required String base64Data,
    String? description,
  }) async {
    try {
      await db.treatmentDao.insertMedicalMedia(
        MedicalMediaCompanion.insert(
          medicalId: medicalId,
          mediaType: mediaType,
          base64Data: base64Data,
          description: Value(description),
        ),
      );
      await _reloadMedicalMedia();
      debugPrint('系統:新增醫療影像成功');
    } catch (e) {
      debugPrint('系統:新增醫療影像失敗 - $e');
    }
  }

  Future<void> _reloadMedicalMedia() async {
    _medicalMediaList = await db.treatmentDao.getMedicalMediaList(medicalId);
    notifyListeners();
  }

  Future<void> deleteMedicalMedia(int mediaId) async {
    try {
      await db.treatmentDao.deleteMedicalMedia(mediaId);
      await _reloadMedicalMedia();
      debugPrint('系統:刪除醫療影像成功');
    } catch (e) {
      debugPrint('系統:刪除醫療影像失敗 - $e');
    }
  }

  // 根據類型取得影像列表
  List<MedicalMediaData> getMediaByType(String mediaType) {
    return _medicalMediaList.where((media) => media.mediaType == mediaType).toList();
  }

  // ===================================================================
  // 醫療評估 CRUD
  // ===================================================================

  Future<void> addMedicalAssessment({
    double? temperature,
    int? pulse,
    int? breath,
    int? systolic,
    int? diastolic,
    int? spo2,
    int? painScore,
    String? consciousnessLevel,
    int? gcs,
    String? gcsE,
    String? gcsM,
    String? gcsV,
    String? leftPupilReaction,
    int? leftPupilSize,
    String? rightPupilReaction,
    int? rightPupilSize,
    String? headNeckExam,
    String? chestExam,
    String? abdomenExam,
    String? extremitiesExam,
    String? otherPhysicalExam,
    int? triageId,
  }) async {
    try {
      await db.treatmentDao.insertMedicalAssessment(
        MedicalAssessmentCompanion.insert(
          medicalId: medicalId,
          temperature: Value(temperature),
          pulse: Value(pulse),
          breath: Value(breath),
          systolic: Value(systolic),
          diastolic: Value(diastolic),
          spo2: Value(spo2),
          painScore: Value(painScore),
          consciousnessLevel: Value(consciousnessLevel),
          gcs: Value(gcs),
          gcsE: Value(gcsE),
          gcsM: Value(gcsM),
          gcsV: Value(gcsV),
          leftPupilReaction: Value(leftPupilReaction),
          leftPupilSize: Value(leftPupilSize),
          rightPupilReaction: Value(rightPupilReaction),
          rightPupilSize: Value(rightPupilSize),
          headNeckExam: Value(headNeckExam),
          chestExam: Value(chestExam),
          abdomenExam: Value(abdomenExam),
          extremitiesExam: Value(extremitiesExam),
          otherPhysicalExam: Value(otherPhysicalExam),
          triageId: Value(triageId),
        ),
      );
      await _reloadMedicalAssessments();
      debugPrint('系統:新增醫療評估成功');
    } catch (e) {
      debugPrint('系統:新增醫療評估失敗 - $e');
    }
  }

  Future<void> _reloadMedicalAssessments() async {
    _medicalAssessments = await db.treatmentDao.getMedicalAssessments(
      medicalId,
    );
    notifyListeners();
  }

  // ===================================================================
  // 生命徵象自動儲存
  // ===================================================================

  Timer? _vitalSignsDebounceTimer;

  Future<void> updateVitalSigns({
    double? temperature,
    int? pulse,
    int? breath,
    int? systolic,
    int? diastolic,
    int? spo2,
  }) async {
    // 取消之前的延遲儲存
    if (_vitalSignsDebounceTimer?.isActive ?? false) {
      _vitalSignsDebounceTimer!.cancel();
    }

    // 設定新的延遲儲存（2秒後執行）
    _vitalSignsDebounceTimer = Timer(const Duration(seconds: 2), () async {
      await _saveVitalSignsToDatabase(
        temperature: temperature,
        pulse: pulse,
        breath: breath,
        systolic: systolic,
        diastolic: diastolic,
        spo2: spo2,
      );
    });
  }

  Future<void> _saveVitalSignsToDatabase({
    double? temperature,
    int? pulse,
    int? breath,
    int? systolic,
    int? diastolic,
    int? spo2,
  }) async {
    try {
      // 新增新的醫療評估記錄（生命徵象）
      await db.treatmentDao.insertMedicalAssessment(
        MedicalAssessmentCompanion.insert(
          medicalId: medicalId,
          temperature: Value(temperature),
          pulse: Value(pulse),
          breath: Value(breath),
          systolic: Value(systolic),
          diastolic: Value(diastolic),
          spo2: Value(spo2),
        ),
      );
      await _reloadMedicalAssessments();
      debugPrint('系統:生命徵象自動儲存成功');
    } catch (e) {
      debugPrint('系統:生命徵象自動儲存失敗 - $e');
    }
  }

  // ===================================================================
  // 病史更新
  // ===================================================================

  Future<void> updateMedicalHistory({
    String? pastHistoryStatus,
    String? pastHistoryDetail,
    String? allergyStatus,
    String? allergyDetail,
  }) async {
    try {
      if (_medicalHistory == null) {
        await db.treatmentDao.insertMedicalHistory(
          MedicalHistoryCompanion.insert(
            medicalId: medicalId,
            pastHistoryStatus: pastHistoryStatus ?? '無',
            allergyStatus: allergyStatus ?? '無',
            pastHistoryDetail: Value(pastHistoryDetail),
            allergyDetail: Value(allergyDetail),
          ),
        );
      }
      _medicalHistory = await db.treatmentDao.getMedicalHistory(medicalId);
      notifyListeners();
      debugPrint('系統:病史更新成功');
    } catch (e) {
      debugPrint('系統:病史更新失敗 - $e');
    }
  }

  // ===================================================================
  // 處置/診斷更新（主要功能，使用自動存檔）
  // ===================================================================

  void _updateTreatmentCacheAndSave(TreatmentData newData) {
    _treatment = newData;
    notifyListeners();
    _autoSave();
  }

  // 診斷相關
  void updateTentativeCategoryId(int? categoryId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(tentativeCategoryId: Value(categoryId)),
    );
  }

  void updateTentative(String? tentative) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(tentative: Value(tentative)),
    );
  }

  void updateSecondaryDiagnosis1(String? diagnosis) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(secondaryDiagnosis1: Value(diagnosis)),
    );
  }

  void updateSecondaryDiagnosis2(String? diagnosis) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(secondaryDiagnosis2: Value(diagnosis)),
    );
  }

  // 檢傷分級
  void updateTriageId(int? triageId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(triageId: Value(triageId)),
    );
  }

  // 處置相關
  void updateTreatmentOnSiteId(int? onSiteId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(treatmentOnSiteId: Value(onSiteId)),
    );
  }

  void updateActionSummary(String? actionSummary) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(actionSummary: Value(actionSummary)),
    );
  }

  void updateActionSummaryOther(String? other) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(actionSummaryOther: Value(other)),
    );
  }

  // 結果相關
  void updateResultId(int? resultId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(resultId: Value(resultId)),
    );
  }

  void updateTransportRequired(bool? required) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(transportRequired: Value(required)),
    );
  }

  void updateTransportMethod(String? method) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(transportMethod: Value(method)),
    );
  }

  void updateReferralHospitalId(int? hospitalId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(referralHospitalId: Value(hospitalId)),
    );
  }

  void updateReferralHospitalFinal(String? hospitalName) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(referralHospitalFinal: Value(hospitalName)),
    );
  }

  void updateArrivalTime(DateTime? time) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(arrivalTime: Value(time)),
    );
  }

  void updateClearanceId(int? clearanceId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(clearanceId: Value(clearanceId)),
    );
  }

  void updateExpeditedClearanceId(int? expeditedId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(expeditedClearanceId: Value(expeditedId)),
    );
  }

  void updateDoctorOrderCh(String? order) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(doctorOrderCh: Value(order)),
    );
  }

  void updateDoctorOrderEn(String? order) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(doctorOrderEn: Value(order)),
    );
  }

  void updateDirectorName(String? name) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(directorName: Value(name)),
    );
  }

  void updateTreatmentTime(DateTime? time) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(_treatment!.copyWith(treatmentTime: time));
  }

  // ===================================================================
  // 醫療人員指派
  // ===================================================================

  Future<void> addStaffAssignment({
    required String staffRole,
    int? staffId,
    String? staffName,
    bool isPrimary = false,
  }) async {
    try {
      // 防止重複的主責人員：若新增的是主責，先刪除舊的主責
      if (isPrimary) {
        final existingPrimary = _staffAssignments.where(
          (a) => a.staffRole == staffRole && a.isPrimary,
        );
        for (var assignment in existingPrimary) {
          await db.treatmentDao.deleteStaffAssignment(
            assignment.staffAssignmentId,
          );
        }
      }

      await db.treatmentDao.insertStaffAssignment(
        MedicalStaffAssignmentCompanion.insert(
          medicalId: medicalId,
          staffRole: staffRole,
          staffId: Value(staffId),
          staffName: Value(staffName),
          isPrimary: Value(isPrimary),
        ),
      );
      await _reloadStaffAssignments();
      debugPrint('系統:新增醫療人員指派成功');
    } catch (e) {
      debugPrint('系統:新增醫療人員指派失敗 - $e');
    }
  }

  Future<void> _reloadStaffAssignments() async {
    _staffAssignments = await db.treatmentDao.getStaffAssignments(medicalId);
    notifyListeners();
  }

  // ===================================================================
  // 特別註記更新
  // ===================================================================

  Future<void> updateSpecialNotes({
    String? selectedNotes,
    String? otherNotes,
  }) async {
    try {
      if (_specialNotes == null) {
        await db.treatmentDao.insertSpecialNotes(
          SpecialNotesCompanion.insert(
            medicalId: medicalId,
            selectedNotes: Value(selectedNotes),
            otherNotes: Value(otherNotes),
          ),
        );
      }
      _specialNotes = await db.treatmentDao.getSpecialNotes(medicalId);
      notifyListeners();
      debugPrint('系統:特別註記更新成功');
    } catch (e) {
      debugPrint('系統:特別註記更新失敗 - $e');
    }
  }

  // ===================================================================
  // 查詢輔助方法
  // ===================================================================

  ChiefComplaintTypeData? getComplaintTypeById(int? id) {
    if (id == null) return null;
    try {
      return complaintTypes.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  DiagnosisCategoryData? getDiagnosisCategoryById(int? id) {
    if (id == null) return null;
    try {
      return diagnosisCategories.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  TriageLevelData? getTriageLevelById(int? id) {
    if (id == null) return null;
    try {
      return triageLevels.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  TreatmentOnSiteData? getTreatmentOnSiteById(int? id) {
    if (id == null) return null;
    try {
      return treatmentOnSites.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  TreatmentResultData? getTreatmentResultById(int? id) {
    if (id == null) return null;
    try {
      return treatmentResults.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  ReferralHospitalData? getReferralHospitalById(int? id) {
    if (id == null) return null;
    try {
      return referralHospitals.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  MedicalStaffData? getMedicalStaffById(int? id) {
    if (id == null) return null;
    try {
      return medicalStaffList.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  // ===================================================================
  // 延遲存檔邏輯
  // ===================================================================

  void _autoSave() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _saveStatus = SaveStatus.saving;

    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      debugPrint('系統:正在自動存檔處置記錄至資料庫...');
      unawaited(_saveToDatabase());
    });
  }

  Future<void> _saveToDatabase() async {
    try {
      if (_treatment != null) {
        await db.treatmentDao.updateTreatment(_treatment!.toCompanion(true));
      }

      debugPrint('系統:處置記錄已儲存');

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
