import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';
import '../../services/firebase_service.dart';

enum SaveStatus { idle, saving, success }

class TreatmentViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  bool _isDisposed = false;

  // === 各種資料快取 ===

  // 醫療主表記錄
  MedicalRecordData? _medicalRecord;
  MedicalRecordData? get medicalRecord => _medicalRecord;

  // 病患基本資料
  PatientData? _patient;
  PatientData? get patient => _patient;

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

  // 獲取最新的生命徵象評估（過濾出有溫度、脈搏等資料的記錄，並按時間倒序排列）
  MedicalAssessmentData? get latestVitalSigns {
    try {
      // 過濾出有生命徵象資料的評估
      final validAssessments = _medicalAssessments.where((assessment) {
        return assessment.temperature != null ||
            assessment.pulse != null ||
            assessment.breath != null ||
            assessment.systolic != null ||
            assessment.diastolic != null ||
            assessment.spo2 != null;
      }).toList();

      if (validAssessments.isEmpty) return null;

      // 按時間倒序排列（最新的在前面）
      validAssessments.sort(
        (a, b) => b.assessmentTime.compareTo(a.assessmentTime),
      );

      return validAssessments.first;
    } catch (e) {
      // 找不到時回傳 null
      return null;
    }
  }

  // 病史記錄
  MedicalHistoryData? _medicalHistory;
  MedicalHistoryData? get medicalHistory => _medicalHistory;

  // 處置/診斷記錄（主要快取）
  TreatmentData? _treatment;
  TreatmentData? get treatment => _treatment;

  // 藥物記錄列表
  List<MedicationData> _medications = [];
  List<MedicationData> get medications => _medications;

  // 醫療人員指派列表
  List<MedicalStaffAssignmentData> _staffAssignments = [];
  List<MedicalStaffAssignmentData> get staffAssignments => _staffAssignments;

  // 特別註記
  SpecialNotesData? _specialNotes;
  SpecialNotesData? get specialNotes => _specialNotes;

  // 轉診單/切結書
  ReferralFormData? _referralForm;
  ReferralFormData? get referralForm => _referralForm;

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

  // Health Assessment Debounce Timers
  final Map<int, Timer> _healthAssessmentDebounceTimers = {};

  TreatmentViewModel(this.db, this.refService, this.medicalId);

  // === 初始化 ===
  Future<void> init() async {
    await _loadAllData();
    notifyListeners();
  }

  Future<void> _loadAllData() async {
    // 載入醫療主表記錄
    _medicalRecord = await db.medicalDao.getMedicalById(medicalId);

    // 載入病患資料
    _patient = await db.medicalDao.getPatientByMedicalId(medicalId);

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

    if (_medicalHistory != null) {
      // 從 ID 獲取對應的狀態名稱
      _cachedPastHistoryStatusId = _medicalHistory!.pastHistoryStatusId;
      _cachedAllergyStatusId = _medicalHistory!.allergyStatusId;
      _cachedPastHistoryDetail = _medicalHistory!.pastHistoryDetail;
      _cachedAllergyDetail = _medicalHistory!.allergyDetail;
    } else {
      // 如果沒有病史記錄，初始化默認值
      // 預設為 null 或根據業務邏輯設定
    }

    // 載入處置/診斷
    _treatment = await db.treatmentDao.getTreatment(medicalId);
    if (_treatment == null) {
      await _createDefaultTreatment();
      _treatment = await db.treatmentDao.getTreatment(medicalId);
    }

    // 載入藥物記錄
    await _reloadMedications();

    // 載入醫療人員指派
    _staffAssignments = await db.treatmentDao.getStaffAssignments(medicalId);

    // 載入特別註記
    _specialNotes = await db.treatmentDao.getSpecialNotes(medicalId);

    // 載入多對多關聯資料（症狀、處置項目、特別註記）
    await _loadMultiSelectData();

    // 載入轉診單/切結書
    _referralForm = await db.referralFormDao.getFormByMedicalId(medicalId);
    if (_referralForm == null) {
      await db.referralFormDao.createForm(medicalId);
      _referralForm = await db.referralFormDao.getFormByMedicalId(medicalId);
    }

    await _loadMultiSelectData();
  }

  // === 建立預設處置記錄 ===
  Future<void> _createDefaultTreatment() async {
    try {
      await db.treatmentDao.insertTreatment(
        TreatmentCompanion.insert(
          medicalId: medicalId,
          transportRequired: const Value(false),
          syncStatus: const Value(1), // 待同步
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
          relation: Value(relation),
          temperature: Value(temperature),
          syncStatus: const Value(1), // 待同步
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
    double? temperature,
  }) async {
    // 1. Optimistic Update (更新本地快取，但不通知 UI 以避免重建)
    final index = _healthAssessments.indexWhere(
      (a) => a.assessmentFormId == assessmentFormId,
    );
    if (index != -1) {
      _healthAssessments[index] = _healthAssessments[index].copyWith(
        name: name,
        relation: Value(relation),
        temperature: Value(temperature),
      );
    }

    // 2. Debounce Save (延遲 2 秒寫入資料庫)
    if (_healthAssessmentDebounceTimers.containsKey(assessmentFormId)) {
      _healthAssessmentDebounceTimers[assessmentFormId]?.cancel();
    }

    _healthAssessmentDebounceTimers[assessmentFormId] = Timer(
      const Duration(seconds: 5),
      () async {
        try {
          await db.treatmentDao.updateHealthAssessment(
            HealthAssessmentFormCompanion(
              assessmentFormId: Value(assessmentFormId),
              medicalId: Value(medicalId),
              name: Value(name),
              relation: Value(relation),
              temperature: Value(temperature),
              syncStatus: const Value(1), // 觸發 Firestore 同步
            ),
          );
          debugPrint('系統:更新健康評估表成功 (Debounced)');
          _healthAssessmentDebounceTimers.remove(assessmentFormId);
        } catch (e) {
          debugPrint('系統:更新健康評估表失敗 - $e');
        }
      },
    );
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
    _patient = await db.medicalDao.getPatientByMedicalId(medicalId);
    notifyListeners();
  }

  // ===================================================================
  // 主訴更新
  // ===================================================================

  Timer? _chiefComplaintDebounceTimer;

  // 自動儲存主訴
  void _autoSaveChiefComplaint() {
    if (_chiefComplaintDebounceTimer?.isActive ?? false) {
      _chiefComplaintDebounceTimer!.cancel();
    }

    _chiefComplaintDebounceTimer = Timer(const Duration(seconds: 5), () async {
      debugPrint('系統:正在自動儲存主訴資料...');
      try {
        if (_chiefComplaint == null) return;
        // 確保 syncStatus=1 以觸發 Firestore 同步
        await db.treatmentDao.updateChiefComplaint(
          _chiefComplaint!.copyWith(syncStatus: 1).toCompanion(true),
        );
        debugPrint('系統:主訴自動存檔成功');
      } catch (e) {
        debugPrint('系統:主訴自動存檔失敗 - $e');
      }
    });
  }

  void updateChiefComplaint({
    int? chiefComplaintTypeId,
    String? selectedSymptoms,
    String? otherSymptomDetail,
    String? chiefComplaintFinal,
    String? supplementaryNotes,
    DateTime? onsetTime,
    String? reportedBy,
    bool? isConfirmed,
  }) {
    // 檢查是否切換了主訴類型
    final bool typeChanged =
        chiefComplaintTypeId != null &&
        _chiefComplaint != null &&
        _chiefComplaint!.chiefComplaintTypeId != chiefComplaintTypeId;

    // 如果類型改變且有選中的症狀，先清除資料庫中的症狀關聯
    if (typeChanged && _selectedSymptomIds.isNotEmpty) {
      _clearAllSymptoms();
      // 清除 otherSymptomDetail - 傳遞空字串給後續處理
      otherSymptomDetail = '';
    } else if (typeChanged) {
      // 沒有選中症狀但類型改變，也要清除 otherSymptomDetail
      otherSymptomDetail = '';
    }

    if (_chiefComplaint == null) {
      // 第一次建立，需立即寫入 DB 取得 ID
      _createChiefComplaint(
        chiefComplaintTypeId: chiefComplaintTypeId,
        selectedSymptoms: selectedSymptoms,
        otherSymptomDetail: otherSymptomDetail,
        chiefComplaintFinal: chiefComplaintFinal,
        supplementaryNotes: supplementaryNotes,
        onsetTime: onsetTime,
        reportedBy: reportedBy,
        isConfirmed: isConfirmed,
      );
      return;
    }

    // 更新本地物件
    _chiefComplaint = _chiefComplaint!.copyWith(
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
      onsetTime: onsetTime != null ? Value(onsetTime) : const Value.absent(),
      reportedBy: reportedBy != null ? Value(reportedBy) : const Value.absent(),
      isConfirmed: isConfirmed,
    );

    // 觸發自動存檔
    _autoSaveChiefComplaint();

    // 判斷是否需要通知 UI
    // 如果只有文字欄位變更 (otherSymptomDetail, supplementaryNotes)，則不通知
    // 其他欄位變更 (Type, Symptoms 等) 則通知
    bool shouldNotify = true;
    if (chiefComplaintTypeId == null &&
        selectedSymptoms == null &&
        onsetTime == null &&
        reportedBy == null &&
        isConfirmed == null &&
        (otherSymptomDetail != null ||
            supplementaryNotes != null ||
            chiefComplaintFinal != null)) {
      shouldNotify = false;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> _createChiefComplaint({
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
          syncStatus: const Value(1), // 待同步
        ),
      );
      _chiefComplaint = await db.treatmentDao.getChiefComplaint(medicalId);
      notifyListeners();
      debugPrint('系統:主訴建立成功');
    } catch (e) {
      debugPrint('系統:主訴建立失敗 - $e');
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
          syncStatus: const Value(1), // 待同步
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
      // 先取得要刪除的資料（用於刪除 Firestore）
      final media = _medicalMediaList.firstWhere(
        (m) => m.mediaId == mediaId,
        orElse: () => throw Exception('找不到影像'),
      );

      // 刪除本地資料
      await db.treatmentDao.deleteMedicalMedia(mediaId);
      await _reloadMedicalMedia();

      // 刪除 Firestore 遠端資料
      try {
        await FirebaseService().deleteDocument(
          'medical_media',
          mediaId.toString(),
        );
        debugPrint('系統:已刪除 Firestore 醫療影像 $mediaId');
      } catch (e) {
        debugPrint('系統:刪除 Firestore 醫療影像失敗 - $e');
      }

      debugPrint('系統:刪除醫療影像成功');
    } catch (e) {
      debugPrint('系統:刪除醫療影像失敗 - $e');
    }
  }

  // 根據類型取得影像列表
  List<MedicalMediaData> getMediaByType(String mediaType) {
    return _medicalMediaList
        .where((media) => media.mediaType == mediaType)
        .toList();
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
    int? consciousnessLevelId,
    int? gcs,
    String? gcsE,
    String? gcsM,
    String? gcsV,
    int? leftPupilReactionId,
    double? leftPupilSize,
    int? rightPupilReactionId,
    double? rightPupilSize,
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
          consciousnessLevelId: Value(consciousnessLevelId),
          gcs: Value(gcs),
          gcsE: Value(gcsE),
          gcsM: Value(gcsM),
          gcsV: Value(gcsV),
          leftPupilReactionId: Value(leftPupilReactionId),
          leftPupilSize: Value(leftPupilSize),
          rightPupilReactionId: Value(rightPupilReactionId),
          rightPupilSize: Value(rightPupilSize),
          headNeckExam: Value(headNeckExam),
          chestExam: Value(chestExam),
          abdomenExam: Value(abdomenExam),
          extremitiesExam: Value(extremitiesExam),
          otherPhysicalExam: Value(otherPhysicalExam),
          triageId: Value(triageId),
          syncStatus: const Value(1), // 待同步
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

    // 從現有記錄初始化 assessment IDs
    for (final assessment in _medicalAssessments) {
      // 檢查是否為生命徵象記錄（有體溫、脈搏等）
      final isVitalSigns =
          assessment.temperature != null ||
          assessment.pulse != null ||
          assessment.breath != null ||
          assessment.systolic != null ||
          assessment.diastolic != null ||
          assessment.spo2 != null;

      // 檢查是否為意識與理學檢查記錄（有意識等級、GCS等）
      final isConsciousnessExam =
          assessment.consciousnessLevelId != null ||
          assessment.gcs != null ||
          assessment.gcsE != null ||
          assessment.gcsV != null ||
          assessment.gcsM != null ||
          assessment.leftPupilReactionId != null ||
          assessment.rightPupilReactionId != null ||
          assessment.headNeckExam != null ||
          assessment.chestExam != null;

      if (isVitalSigns || isConsciousnessExam) {
        // 所有資料存在同一個 assessment 記錄
        if (_medicalAssessmentId == null) {
          _medicalAssessmentId = assessment.assessmentId;
          debugPrint('系統:找到醫療評估記錄 ID: ${assessment.assessmentId}');
        }
      }
    }

    notifyListeners();
  }

  // 統一的醫療評估記錄 ID（生命徵象 + 意識與理學檢查都存在這裡）
  int? _medicalAssessmentId;

  // ===================================================================
  // 生命徵象自動儲存（參考 incident_view.dart 模式）
  // ===================================================================

  Timer? _vitalSignsDebounceTimer;
  SaveStatus _vitalSignsSaveStatus = SaveStatus.idle;
  SaveStatus get vitalSignsSaveStatus => _vitalSignsSaveStatus;

  // 生命徵象快取（用於自動儲存）
  double? _cachedTemperature;
  int? _cachedPulse;
  int? _cachedBreath;
  int? _cachedSystolic;
  int? _cachedDiastolic;
  int? _cachedSpo2;
  bool _vitalSignsChanged = false; // 追蹤是否有變更

  void updateVitalSignsCache({
    double? temperature,
    int? pulse,
    int? breath,
    int? systolic,
    int? diastolic,
    int? spo2,
  }) {
    // 檢查是否有實際變更
    final changed =
        temperature != _cachedTemperature ||
        pulse != _cachedPulse ||
        breath != _cachedBreath ||
        systolic != _cachedSystolic ||
        diastolic != _cachedDiastolic ||
        spo2 != _cachedSpo2;

    if (!changed) return; // 沒有變更，不觸發儲存

    _vitalSignsChanged = true;
    _cachedTemperature = temperature;
    _cachedPulse = pulse;
    _cachedBreath = breath;
    _cachedSystolic = systolic;
    _cachedDiastolic = diastolic;
    _cachedSpo2 = spo2;
    _autoSaveVitalSigns();
  }

  void _autoSaveVitalSigns() {
    if (_vitalSignsDebounceTimer?.isActive ?? false) {
      _vitalSignsDebounceTimer!.cancel();
    }
    _vitalSignsSaveStatus = SaveStatus.saving;

    _vitalSignsDebounceTimer = Timer(const Duration(seconds: 5), () async {
      debugPrint('系統:正在自動儲存生命徵象...');
      unawaited(_saveVitalSignsToDatabase());
    });
  }

  Future<void> _saveVitalSignsToDatabase() async {
    if (_isDisposed) return;
    try {
      // 檢查是否有資料需要儲存
      final hasData =
          _cachedTemperature != null ||
          _cachedPulse != null ||
          _cachedBreath != null ||
          _cachedSystolic != null ||
          _cachedDiastolic != null ||
          _cachedSpo2 != null;

      if (!hasData) {
        debugPrint('系統:生命徵象無資料，跳過儲存');
        return;
      }

      // 使用統一的 ID，存在同一個記錄裡
      if (_medicalAssessmentId != null) {
        // 更新現有記錄（包含生命徵象和意識與理學檢查）
        await db.treatmentDao.updateMedicalAssessment(
          MedicalAssessmentCompanion(
            temperature: Value(_cachedTemperature),
            pulse: Value(_cachedPulse),
            breath: Value(_cachedBreath),
            systolic: Value(_cachedSystolic),
            diastolic: Value(_cachedDiastolic),
            spo2: Value(_cachedSpo2),
            // 同時更新意識與理學檢查的欄位
            consciousnessLevelId: Value(_cachedConsciousnessLevelId),
            gcsE: Value(_cachedGcsE),
            gcsV: Value(_cachedGcsV),
            gcsM: Value(_cachedGcsM),
            gcs: Value(_cachedGcs),
            leftPupilReactionId: Value(_cachedLeftPupilReactionId),
            leftPupilSize: Value(_cachedLeftPupilSize),
            rightPupilReactionId: Value(_cachedRightPupilReactionId),
            rightPupilSize: Value(_cachedRightPupilSize),
            headNeckExam: Value(_cachedHeadNeckExam),
            chestExam: Value(_cachedChestExam),
            abdomenExam: Value(_cachedAbdomenExam),
            extremitiesExam: Value(_cachedExtremitiesExam),
            otherPhysicalExam: Value(_cachedOtherPhysicalExam),
            syncStatus: const Value(1), // 待同步
          ),
          _medicalAssessmentId!,
        );
        debugPrint('系統:生命徵象更新成功 (id: $_medicalAssessmentId)');
      } else {
        // 新增新的醫療評估記錄（包含生命徵象）
        final newId = await db.treatmentDao.insertMedicalAssessment(
          MedicalAssessmentCompanion.insert(
            medicalId: medicalId,
            temperature: Value(_cachedTemperature),
            pulse: Value(_cachedPulse),
            breath: Value(_cachedBreath),
            systolic: Value(_cachedSystolic),
            diastolic: Value(_cachedDiastolic),
            spo2: Value(_cachedSpo2),
            // 同時儲存意識與理學檢查
            consciousnessLevelId: Value(_cachedConsciousnessLevelId),
            gcsE: Value(_cachedGcsE),
            gcsV: Value(_cachedGcsV),
            gcsM: Value(_cachedGcsM),
            gcs: Value(_cachedGcs),
            leftPupilReactionId: Value(_cachedLeftPupilReactionId),
            leftPupilSize: Value(_cachedLeftPupilSize),
            rightPupilReactionId: Value(_cachedRightPupilReactionId),
            rightPupilSize: Value(_cachedRightPupilSize),
            headNeckExam: Value(_cachedHeadNeckExam),
            chestExam: Value(_cachedChestExam),
            abdomenExam: Value(_cachedAbdomenExam),
            extremitiesExam: Value(_cachedExtremitiesExam),
            otherPhysicalExam: Value(_cachedOtherPhysicalExam),
            syncStatus: const Value(1), // 待同步
          ),
        );
        _medicalAssessmentId = newId;
        debugPrint('系統:生命徵象新增成功 (id: $newId)');
      }

      await _reloadMedicalAssessments();
      debugPrint('系統:生命徵象自動儲存成功');

      if (!hasListeners) return;

      _vitalSignsSaveStatus = SaveStatus.success;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));

      if (!hasListeners) return;

      _vitalSignsSaveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('系統:生命徵象自動儲存失敗 - $e');
      if (!hasListeners) return;
      _vitalSignsSaveStatus = SaveStatus.idle;
      notifyListeners();
    }
  }

  // ===================================================================
  // 意識與理學檢查自動儲存（獨立於生命徵象）
  // ===================================================================

  Timer? _consciousnessExamDebounceTimer;
  SaveStatus _consciousnessExamSaveStatus = SaveStatus.idle;
  SaveStatus get consciousnessExamSaveStatus => _consciousnessExamSaveStatus;

  // 意識與理學檢查快取（用於自動儲存）
  bool? _cachedIsAlert;
  int? _cachedConsciousnessLevelId;
  String? _cachedGcsE;
  String? _cachedGcsV;
  String? _cachedGcsM;
  int? _cachedGcs;
  int? _cachedLeftPupilReactionId;
  double? _cachedLeftPupilSize;
  int? _cachedRightPupilReactionId;
  double? _cachedRightPupilSize;
  String? _cachedHeadNeckExam;
  String? _cachedChestExam;
  String? _cachedAbdomenExam;
  String? _cachedExtremitiesExam;
  String? _cachedOtherPhysicalExam;

  // ===================================================================
  // 病史與過敏快取（用於自動儲存）
  // ===================================================================

  Timer? _historyDebounceTimer;
  SaveStatus _historySaveStatus = SaveStatus.idle;
  SaveStatus get historySaveStatus => _historySaveStatus;

  // 病史快取變數
  int? _cachedPastHistoryStatusId;
  String? _cachedPastHistoryDetail;
  int? _cachedAllergyStatusId;
  String? _cachedAllergyDetail;

  // 獲取最新的意識與理學檢查評估
  MedicalAssessmentData? get latestConsciousnessExam {
    try {
      // 過濾出有意識或理學檢查資料的評估
      final validAssessments = _medicalAssessments.where((assessment) {
        return assessment.consciousnessLevelId != null ||
            assessment.gcs != null ||
            assessment.gcsE != null ||
            assessment.gcsV != null ||
            assessment.gcsM != null ||
            assessment.leftPupilReactionId != null ||
            assessment.leftPupilSize != null ||
            assessment.rightPupilReactionId != null ||
            assessment.rightPupilSize != null ||
            assessment.headNeckExam != null ||
            assessment.chestExam != null ||
            assessment.abdomenExam != null ||
            assessment.extremitiesExam != null ||
            assessment.otherPhysicalExam != null;
      }).toList();

      if (validAssessments.isEmpty) return null;

      // 按時間倒序排列
      validAssessments.sort(
        (a, b) => b.assessmentTime.compareTo(a.assessmentTime),
      );

      return validAssessments.first;
    } catch (e) {
      return null;
    }
  }

  void updateConsciousnessAndExamCache({
    bool? isAlert,
    int? consciousnessLevelId,
    String? gcsE,
    String? gcsV,
    String? gcsM,
    int? gcs,
    int? leftPupilReactionId,
    double? leftPupilSize,
    int? rightPupilReactionId,
    double? rightPupilSize,
    String? headNeckExam,
    String? chestExam,
    String? abdomenExam,
    String? extremitiesExam,
    String? otherPhysicalExam,
  }) {
    // 檢查是否有實際變更
    final changed =
        isAlert != _cachedIsAlert ||
        consciousnessLevelId != _cachedConsciousnessLevelId ||
        gcsE != _cachedGcsE ||
        gcsV != _cachedGcsV ||
        gcsM != _cachedGcsM ||
        gcs != _cachedGcs ||
        leftPupilReactionId != _cachedLeftPupilReactionId ||
        leftPupilSize != _cachedLeftPupilSize ||
        rightPupilReactionId != _cachedRightPupilReactionId ||
        rightPupilSize != _cachedRightPupilSize ||
        headNeckExam != _cachedHeadNeckExam ||
        chestExam != _cachedChestExam ||
        abdomenExam != _cachedAbdomenExam ||
        extremitiesExam != _cachedExtremitiesExam ||
        otherPhysicalExam != _cachedOtherPhysicalExam;

    if (!changed) return; // 沒有變更，不觸發儲存

    _cachedIsAlert = isAlert;
    _cachedConsciousnessLevelId = consciousnessLevelId;
    _cachedGcsE = gcsE;
    _cachedGcsV = gcsV;
    _cachedGcsM = gcsM;
    _cachedGcs = gcs;
    _cachedLeftPupilReactionId = leftPupilReactionId;
    _cachedLeftPupilSize = leftPupilSize;
    _cachedRightPupilReactionId = rightPupilReactionId;
    _cachedRightPupilSize = rightPupilSize;
    _cachedHeadNeckExam = headNeckExam;
    _cachedChestExam = chestExam;
    _cachedAbdomenExam = abdomenExam;
    _cachedExtremitiesExam = extremitiesExam;
    _cachedOtherPhysicalExam = otherPhysicalExam;
    _autoSaveConsciousnessAndExam();
  }

  void _autoSaveConsciousnessAndExam() {
    if (_consciousnessExamDebounceTimer?.isActive ?? false) {
      _consciousnessExamDebounceTimer!.cancel();
    }
    _consciousnessExamSaveStatus = SaveStatus.saving;

    _consciousnessExamDebounceTimer = Timer(
      const Duration(seconds: 5),
      () async {
        debugPrint('系統:正在自動儲存意識與理學檢查...');
        unawaited(_saveConsciousnessAndExamToDatabase());
      },
    );
  }

  Future<void> _saveConsciousnessAndExamToDatabase() async {
    if (_isDisposed) return;
    try {
      // 檢查是否有資料需要儲存
      final hasData =
          _cachedConsciousnessLevelId != null ||
          _cachedGcsE != null ||
          _cachedGcsV != null ||
          _cachedGcsM != null ||
          _cachedGcs != null ||
          _cachedLeftPupilReactionId != null ||
          _cachedLeftPupilSize != null ||
          _cachedRightPupilReactionId != null ||
          _cachedRightPupilSize != null ||
          _cachedHeadNeckExam != null ||
          _cachedChestExam != null ||
          _cachedAbdomenExam != null ||
          _cachedExtremitiesExam != null ||
          _cachedOtherPhysicalExam != null;

      if (!hasData) {
        debugPrint('系統:意識與理學檢查無資料，跳過儲存');
        return;
      }

      // 如果已有 assessmentId，更新現有記錄；否則新增
      if (_medicalAssessmentId != null) {
        // 更新時同時保留生命徵象資料
        await db.treatmentDao.updateMedicalAssessment(
          MedicalAssessmentCompanion(
            consciousnessLevelId: Value(_cachedConsciousnessLevelId),
            gcsE: Value(_cachedGcsE),
            gcsV: Value(_cachedGcsV),
            gcsM: Value(_cachedGcsM),
            gcs: Value(_cachedGcs),
            leftPupilReactionId: Value(_cachedLeftPupilReactionId),
            leftPupilSize: Value(_cachedLeftPupilSize),
            rightPupilReactionId: Value(_cachedRightPupilReactionId),
            rightPupilSize: Value(_cachedRightPupilSize),
            headNeckExam: Value(_cachedHeadNeckExam),
            chestExam: Value(_cachedChestExam),
            abdomenExam: Value(_cachedAbdomenExam),
            extremitiesExam: Value(_cachedExtremitiesExam),
            otherPhysicalExam: Value(_cachedOtherPhysicalExam),
            // 同時保留生命徵象
            temperature: Value(_cachedTemperature),
            pulse: Value(_cachedPulse),
            breath: Value(_cachedBreath),
            systolic: Value(_cachedSystolic),
            diastolic: Value(_cachedDiastolic),
            spo2: Value(_cachedSpo2),
            syncStatus: const Value(1), // 待同步
          ),
          _medicalAssessmentId!,
        );
        debugPrint('系統:意識與理學檢查更新成功 (id: $_medicalAssessmentId)');
      } else {
        // 新增新的醫療評估記錄（意識與理學檢查）
        final newId = await db.treatmentDao.insertMedicalAssessment(
          MedicalAssessmentCompanion.insert(
            medicalId: medicalId,
            consciousnessLevelId: Value(_cachedConsciousnessLevelId),
            gcsE: Value(_cachedGcsE),
            gcsV: Value(_cachedGcsV),
            gcsM: Value(_cachedGcsM),
            gcs: Value(_cachedGcs),
            leftPupilReactionId: Value(_cachedLeftPupilReactionId),
            leftPupilSize: Value(_cachedLeftPupilSize),
            rightPupilReactionId: Value(_cachedRightPupilReactionId),
            rightPupilSize: Value(_cachedRightPupilSize),
            headNeckExam: Value(_cachedHeadNeckExam),
            chestExam: Value(_cachedChestExam),
            abdomenExam: Value(_cachedAbdomenExam),
            extremitiesExam: Value(_cachedExtremitiesExam),
            otherPhysicalExam: Value(_cachedOtherPhysicalExam),
            // 同時儲存生命徵象
            temperature: Value(_cachedTemperature),
            pulse: Value(_cachedPulse),
            breath: Value(_cachedBreath),
            systolic: Value(_cachedSystolic),
            diastolic: Value(_cachedDiastolic),
            spo2: Value(_cachedSpo2),
            syncStatus: const Value(1), // 待同步
          ),
        );
        _medicalAssessmentId = newId;
        debugPrint('系統:意識與理學檢查新增成功 (id: $newId)');
      }

      await _reloadMedicalAssessments();
      debugPrint('系統:意識與理學檢查自動儲存成功');

      if (!hasListeners) return;

      _consciousnessExamSaveStatus = SaveStatus.success;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));

      if (!hasListeners) return;

      _consciousnessExamSaveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('系統:意識與理學檢查自動儲存失敗 - $e');
      if (!hasListeners) return;
      _consciousnessExamSaveStatus = SaveStatus.idle;
      notifyListeners();
    }
  }

  // ===================================================================
  // 病史更新
  // ===================================================================

  Future<void> updateMedicalHistory({
    int? pastHistoryStatusId,
    String? pastHistoryDetail,
    int? allergyStatusId,
    String? allergyDetail,
  }) async {
    try {
      if (_medicalHistory == null) {
        // 新增記錄
        await db.treatmentDao.insertMedicalHistory(
          MedicalHistoryCompanion.insert(
            medicalId: medicalId,
            pastHistoryStatusId: Value(pastHistoryStatusId),
            allergyStatusId: Value(allergyStatusId),
            pastHistoryDetail: Value(pastHistoryDetail),
            allergyDetail: Value(allergyDetail),
            syncStatus: const Value(1), // 待同步到 Firestore
          ),
        );
      } else {
        // 更新現有記錄
        // 檢查狀態是否為 'none' 或 'unknown'，若是則清除詳細資料
        final Value<String?> effectivePastHistoryDetail;

        final pastStatus = pastHistoryStatusId != null
            ? _getHistoryStatusById(pastHistoryStatusId)
            : null;

        if (pastStatus != null &&
            (pastStatus.code == 'none' || pastStatus.code == 'unknown')) {
          effectivePastHistoryDetail = Value<String?>(null);
        } else if (pastHistoryDetail != null) {
          effectivePastHistoryDetail = Value(pastHistoryDetail);
        } else {
          effectivePastHistoryDetail = const Value.absent();
        }

        final Value<String?> effectiveAllergyDetail;
        final allergyStatus = allergyStatusId != null
            ? _getHistoryStatusById(allergyStatusId)
            : null;

        if (allergyStatus != null &&
            (allergyStatus.code == 'none' || allergyStatus.code == 'unknown')) {
          effectiveAllergyDetail = Value<String?>(null);
        } else if (allergyDetail != null) {
          effectiveAllergyDetail = Value(allergyDetail);
        } else {
          effectiveAllergyDetail = const Value.absent();
        }

        await db.treatmentDao.updateMedicalHistory(
          MedicalHistoryCompanion(
            historyId: Value(_medicalHistory!.historyId),
            medicalId: Value(_medicalHistory!.medicalId),
            pastHistoryStatusId: pastHistoryStatusId != null
                ? Value(pastHistoryStatusId)
                : const Value.absent(),
            pastHistoryDetail: effectivePastHistoryDetail,
            allergyStatusId: allergyStatusId != null
                ? Value(allergyStatusId)
                : const Value.absent(),
            allergyDetail: effectiveAllergyDetail,
            syncStatus: const Value(1), // 確保 syncStatus=1 以觸發 Firestore 同步
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

  // 統一更新病史快取並觸發自動儲存
  void _updateHistoryCacheAndSave({
    int? pastHistoryStatusId,
    String? pastHistoryDetail,
    int? allergyStatusId,
    String? allergyDetail,
    bool notify = true,
  }) {
    // 更新快取
    if (pastHistoryStatusId != null) {
      _cachedPastHistoryStatusId = pastHistoryStatusId;
    }
    if (pastHistoryDetail != null) {
      _cachedPastHistoryDetail = pastHistoryDetail;
    }
    if (allergyStatusId != null) {
      _cachedAllergyStatusId = allergyStatusId;
    }
    if (allergyDetail != null) {
      _cachedAllergyDetail = allergyDetail;
    }

    _historySaveStatus = SaveStatus.saving;
    if (notify) notifyListeners();
    _autoSaveHistory();
  }

  // 公開的病史更新方法（供 UI 呼叫）
  void updatePastHistoryStatusId(int? id) {
    _updateHistoryCacheAndSave(pastHistoryStatusId: id);
  }

  void updatePastHistoryDetail(String detail) {
    _updateHistoryCacheAndSave(pastHistoryDetail: detail, notify: false);
  }

  void updateAllergyStatusId(int? id) {
    _updateHistoryCacheAndSave(allergyStatusId: id);
  }

  void updateAllergyDetail(String detail) {
    _updateHistoryCacheAndSave(allergyDetail: detail, notify: false);
  }

  // 病史自動儲存機制
  void _autoSaveHistory() {
    if (_historyDebounceTimer?.isActive ?? false) {
      _historyDebounceTimer!.cancel();
    }

    _historyDebounceTimer = Timer(const Duration(seconds: 5), () async {
      debugPrint('系統:正在自動儲存病史資料...');
      unawaited(_saveHistoryToDatabase());
    });
  }

  Future<void> _saveHistoryToDatabase() async {
    if (_isDisposed) return;
    try {
      await updateMedicalHistory(
        pastHistoryStatusId: _cachedPastHistoryStatusId,
        pastHistoryDetail: _cachedPastHistoryDetail,
        allergyStatusId: _cachedAllergyStatusId,
        allergyDetail: _cachedAllergyDetail,
      );

      debugPrint('系統:病史資料已儲存');

      if (!hasListeners) return;

      _historySaveStatus = SaveStatus.success;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));

      if (!hasListeners) return;

      _historySaveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('系統:病史自動儲存失敗 - $e');
      if (!hasListeners) return;
      _historySaveStatus = SaveStatus.idle;
      notifyListeners();
    }
  }

  // ===================================================================
  // 處置/診斷更新（主要功能，使用自動存檔）
  // ===================================================================

  void _updateTreatmentCacheAndSave(
    TreatmentData newData, {
    bool notify = true,
  }) {
    _treatment = newData;
    if (notify) notifyListeners();
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
      notify: false,
    );
  }

  void updateSecondaryDiagnosis1(String? diagnosis) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(secondaryDiagnosis1: Value(diagnosis)),
      notify: false,
    );
  }

  void updateSecondaryDiagnosis2(String? diagnosis) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(secondaryDiagnosis2: Value(diagnosis)),
      notify: false,
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

    // 自動連動 MedicalRecord 狀態
    final items = actionSummary?.split(',') ?? [];
    // 根據需求：
    // 1. 選擇建議轉診 (Suggest Referral) -> hasAmbulance = true
    // 2. 選擇 CPR -> isEmergency = true
    // 3. 不勾就是 false (Unchecked means false)
    final hasReferral = items.contains('建議轉診');
    final hasCPR = items.contains('CPR');

    // 更新 MedicalRecord
    db.medicalDao
        .updateMedicalStatus(
          medicalId,
          hasAmbulance: hasReferral,
          isEmergency: hasCPR,
        )
        .then((_) => _reloadMedicalRecord());
  }

  void updateActionSummaryOther(String? other) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(actionSummaryOther: Value(other)),
      notify: false,
    );
  }

  // 動態處置細項更新
  void updateEkgInterpretation(String? value) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(ekgInterpretation: Value(value)),
      notify: false,
    );
  }

  void updateGlucose(String? value) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(glucose: Value(value)),
      notify: false,
    );
  }

  void updateIntubationMethod(String? value) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(intubationMethod: Value(value)),
      notify: false,
    );
  }

  void updateOxygenMethod(String? value) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(oxygenMethod: Value(value)),
      notify: false,
    );
  }

  void updateOxygenFlow(double? value) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(oxygenFlow: Value(value)),
      notify: false,
    );
  }

  void updateCertificateLogs(String? value) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(certificateLogs: Value(value)),
      notify: false,
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
      notify: false,
    );
  }

  void updateReferralHospitalId(int? hospitalId) {
    if (_treatment == null) return;

    // 如果選擇了特定醫院，自動同步到 referralHospitalFinal (後續結果的醫院名稱)
    Value<String?>? newReferralHospitalFinal;
    if (hospitalId != null) {
      final hospital = getReferralHospitalById(hospitalId);
      if (hospital != null && !hospital.isOther) {
        // 如果是主要合約醫院（非 Other），同步名稱
        newReferralHospitalFinal = Value(hospital.name);
      }
    }

    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(
        referralHospitalId: Value(hospitalId),
        referralHospitalFinal: newReferralHospitalFinal ?? const Value.absent(),
      ),
    );
  }

  void updateReferralHospitalFinal(String? hospitalName) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(referralHospitalFinal: Value(hospitalName)),
    );
  }

  void updateAmbulanceStaffId(int? staffId) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(ambulanceStaffId: Value(staffId)),
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

  void updateAssistStaff(String? staffList) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(assistStaff: Value(staffList)),
    );
  }

  void updateTreatmentTime(DateTime? time) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(_treatment!.copyWith(treatmentTime: time));
  }

  // 其它影像描述更新
  void updateOtherPhotoDescription(String? description) {
    if (_treatment == null) return;
    _updateTreatmentCacheAndSave(
      _treatment!.copyWith(otherPhotoDescription: Value(description)),
      notify: false, // 避免頻繁觸發 UI 重繪
    );
  }

  // ===================================================================
  // 醫療人員搜尋
  // ===================================================================

  Future<List<MedicalStaffData>> searchMedicalStaff(String query) async {
    if (query.isEmpty) return medicalStaffList;

    final lowerQuery = query.toLowerCase();
    return medicalStaffList.where((staff) {
      final nameMatch = staff.name.toLowerCase().contains(lowerQuery);
      final idMatch =
          staff.employeeId?.toLowerCase().contains(lowerQuery) ?? false;
      return nameMatch || idMatch;
    }).toList();
  }

  // ===================================================================
  // 醫療人員指派
  // ===================================================================

  Future<void> addStaffAssignment({
    required String staffRoleCode,
    int? staffId,
    String? staffName,
    bool isPrimary = false,
  }) async {
    try {
      debugPrint(
        '系統:addStaffAssignment start medicalId=$medicalId role=$staffRoleCode staffId=$staffId staffName=$staffName isPrimary=$isPrimary',
      );

      final roleId = getRoleIdByCode(staffRoleCode);
      if (roleId == null) {
        debugPrint('系統: 找不到醫療人員角色代碼 $staffRoleCode');
        return;
      }

      // 防止重複的主責人員：若新增的是主責，先刪除舊的主責
      if (isPrimary) {
        final existingPrimary = _staffAssignments.where(
          (a) => a.staffRoleId == roleId && a.isPrimary,
        );
        for (var assignment in existingPrimary) {
          debugPrint(
            '系統:addStaffAssignment delete existing primary assignmentId=${assignment.staffAssignmentId} roleId=${assignment.staffRoleId} staffId=${assignment.staffId}',
          );
          await db.treatmentDao.deleteStaffAssignment(
            assignment.staffAssignmentId,
          );
        }
      }

      // 如果是新增，檢查該人員是否有全域簽名，若有則自動帶入
      Uint8List? signature;
      if (staffId != null) {
        final staff = refService.getMedicalStaffById(staffId);
        if (staff != null) {
          if (staff.signature != null) {
            signature = staff.signature;
          }
          // 如果沒有提供 staffName，則使用 Reference 中的名字
          if (staffName == null || staffName.isEmpty) {
            staffName = staff.name;
          }
        }
      }

      await db.treatmentDao.insertStaffAssignment(
        MedicalStaffAssignmentCompanion.insert(
          medicalId: medicalId,
          staffRoleId: Value(roleId),
          staffId: Value(staffId),
          staffName: Value(staffName),
          isPrimary: Value(isPrimary),
          signature: Value(signature),
        ),
      );
      await _reloadStaffAssignments();
      debugPrint(
        '系統:新增醫療人員指派成功 role=$staffRoleCode roleId=$roleId staffId=$staffId currentAssignments=${_staffAssignments.map((a) => '${a.staffAssignmentId}:${a.staffRoleId}:${a.staffId}:${a.isPrimary}').join(',')}',
      );
    } catch (e) {
      debugPrint('系統:新增醫療人員指派失敗 role=$staffRoleCode staffId=$staffId - $e');
    }
  }

  Future<void> removeStaffAssignment(int staffAssignmentId) async {
    try {
      await db.treatmentDao.deleteStaffAssignment(staffAssignmentId);
      await _reloadStaffAssignments();
      debugPrint('系統:刪除醫療人員指派成功');
    } catch (e) {
      debugPrint('系統:刪除醫療人員指派失敗 - $e');
    }
  }

  Future<void> _reloadStaffAssignments() async {
    _staffAssignments = await db.treatmentDao.getStaffAssignments(medicalId);
    notifyListeners();
  }

  Future<void> updateStaffSignature(
    int staffAssignmentId,
    Uint8List signature,
  ) async {
    try {
      final assignment = _staffAssignments.firstWhere(
        (a) => a.staffAssignmentId == staffAssignmentId,
      );

      await db.treatmentDao.updateStaffAssignment(
        assignment
            .toCompanion(true)
            .copyWith(
              signature: Value(signature),
              signedAt: Value(DateTime.now()),
            ),
      );

      // 同步更新全域簽名到 MedicalStaff 表
      if (assignment.staffId != null) {
        await db.referenceDao.updateMedicalStaffSignature(
          assignment.staffId!,
          signature,
        );
        // 重新載入參考資料中的醫療人員列表，以確保快取更新
        await refService.initialize();
      }

      await _reloadStaffAssignments();
      debugPrint('系統:簽名更新成功');
    } catch (e) {
      debugPrint('系統:簽名更新失敗 - $e');
    }
  }

  Future<void> updateEmtName(String name) async {
    // Legacy method for text input (deprecated but kept for compatibility)
    // Should use addStaffAssignment with staffId instead
    debugPrint(
      'Warning: updateEmtName is deprecated. Use addStaffAssignment instead.',
    );
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
            syncStatus: const Value(1), // 待同步
          ),
        );
      } else {
        await db.treatmentDao.updateSpecialNotes(
          SpecialNotesCompanion(
            noteId: Value(_specialNotes!.noteId),
            medicalId: Value(_specialNotes!.medicalId),
            selectedNotes: selectedNotes != null
                ? Value(selectedNotes)
                : const Value.absent(),
            otherNotes: otherNotes != null
                ? Value(otherNotes)
                : const Value.absent(),
            syncStatus: const Value(1), // 確保 syncStatus=1 以觸發 Firestore 同步
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
  // 藥物記錄 CRUD
  // ===================================================================

  Future<void> _reloadMedications() async {
    _medications = await db.treatmentDao.getMedications(medicalId);
    notifyListeners();
  }

  Future<void> addMedication() async {
    try {
      await db.treatmentDao.insertMedication(
        MedicationsCompanion.insert(medicalId: medicalId),
      );
      await _reloadMedications();
      debugPrint('系統:新增藥物記錄成功');
    } catch (e) {
      debugPrint('系統:新增藥物記錄失敗 - $e');
    }
  }

  Future<void> deleteMedication(int medicationId) async {
    try {
      await db.treatmentDao.deleteMedication(medicationId);
      await _reloadMedications();
      debugPrint('系統:刪除藥物記錄成功');
    } catch (e) {
      debugPrint('系統:刪除藥物記錄失敗 - $e');
    }
  }

  // 統一新增或更新藥物 (支援 Dialog 使用)
  Future<void> saveMedication(MedicationsCompanion medication) async {
    try {
      if (medication.medicationId.present) {
        // Update
        await db.treatmentDao.updateMedication(medication);
        debugPrint('系統:更新藥物記錄成功');
      } else {
        // Insert
        await db.treatmentDao.insertMedication(medication);
        debugPrint('系統:新增藥物記錄成功');
      }
      await _reloadMedications();
    } catch (e) {
      debugPrint('系統:儲存藥物記錄失敗 - $e');
    }
  }

  // 統一更新藥物欄位
  Future<void> updateMedication({
    required int medicationId,
    String? name,
    String? method,
    String? frequency,
    String? days,
    String? dose,
    String? unit,
    String? remarks,
  }) async {
    try {
      await db.treatmentDao.updateMedication(
        MedicationsCompanion(
          medicationId: Value(medicationId),
          medicalId: Value(medicalId),
          name: name != null ? Value(name) : const Value.absent(),
          method: method != null ? Value(method) : const Value.absent(),
          frequency: frequency != null
              ? Value(frequency)
              : const Value.absent(),
          days: days != null ? Value(days) : const Value.absent(),
          dose: dose != null ? Value(dose) : const Value.absent(),
          unit: unit != null ? Value(unit) : const Value.absent(),
          remarks: remarks != null ? Value(remarks) : const Value.absent(),
          syncStatus: const Value(1), // 確保 syncStatus=1 以觸發 Firestore 同步
        ),
      );
      // 更新列表但保持 UI 狀態
      await _reloadMedications();
    } catch (e) {
      debugPrint('系統:更新藥物記錄失敗 - $e');
    }
  }

  // ===================================================================
  // 查詢輔助方法
  // ===================================================================

  HistoryStatusRefData? _getHistoryStatusById(int id) {
    try {
      return refService.historyStatusList.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  int? getRoleIdByCode(String code) {
    try {
      return refService.medicalStaffRoleList
          .firstWhere((r) => r.code == code)
          .id;
    } catch (e) {
      return null;
    }
  }

  String? getStaffRoleCode(int? id) {
    if (id == null) return null;
    try {
      return refService.medicalStaffRoleList.firstWhere((r) => r.id == id).code;
    } catch (e) {
      return null;
    }
  }

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

  // 取得隨車人員資料
  MedicalStaffData? get ambulanceStaff {
    if (_treatment?.ambulanceStaffId == null) return null;
    return getMedicalStaffById(_treatment!.ambulanceStaffId);
  }

  // ===================================================================
  // ICD-10 搜尋
  // ===================================================================

  Future<List<Icd10CodeData>> searchIcd10(String query) async {
    if (query.isEmpty) return [];
    return await db.icd10Dao.search(query);
  }

  // === 搜尋輔助方法 (新增) ===

  Future<List<DiagnosisCategoryData>> searchDiagnosisCategories(
    String keyword,
  ) async {
    if (keyword.isEmpty) return refService.diagnosisCategories;
    final lower = keyword.toLowerCase();
    return refService.diagnosisCategories
        .where((d) => d.name.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<TreatmentOnSiteData>> searchTreatmentOnSites(
    String keyword,
  ) async {
    if (keyword.isEmpty) return refService.treatmentOnSites;
    final lower = keyword.toLowerCase();
    return refService.treatmentOnSites
        .where((t) => t.name.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<TreatmentResultData>> searchTreatmentResults(
    String keyword,
  ) async {
    if (keyword.isEmpty) return refService.treatmentResults;
    final lower = keyword.toLowerCase();
    return refService.treatmentResults
        .where((r) => r.name.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<ReferralHospitalData>> searchReferralHospitals(
    String keyword, {
    bool includeAll = false,
  }) async {
    // 預設只顯示 'isOther' 為 true 的醫院 (排除主要合約醫院)
    // 若 includeAll 為 true，則顯示所有醫院
    final sourceList = includeAll
        ? refService.referralHospitals
        : refService.referralHospitals.where((h) => h.isOther).toList();

    if (keyword.isEmpty) return sourceList;
    final lower = keyword.toLowerCase();
    return sourceList
        .where((h) => h.name.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<DrugRefData>> searchDrugs(String keyword) async {
    if (keyword.isEmpty) return refService.drugList;
    final lower = keyword.toLowerCase();
    return refService.drugList
        .where(
          (d) =>
              d.name.toLowerCase().contains(lower) ||
              d.category.toLowerCase().contains(lower),
        )
        .toList();
  }

  // === 多對多關係資料快取 ===
  List<int> _selectedSymptomIds = [];
  List<int> _selectedActionIds = [];
  List<int> _selectedSpecialNoteIds = [];

  // === 正規化參考表資料 Getters ===
  List<HistoryStatusRefData> get historyStatuses =>
      refService.historyStatusList;
  List<HistoryStatusRefData> get allergyStatuses =>
      refService.historyStatusList;

  // UI 應優先使用快取值以達到即時更新效果 (Optimistic UI)
  int? get selectedHistoryStatusId =>
      _cachedPastHistoryStatusId ?? _medicalHistory?.pastHistoryStatusId;

  int? get selectedAllergyStatusId =>
      _cachedAllergyStatusId ?? _medicalHistory?.allergyStatusId;

  // === 多對多關係 Getters ===
  List<int> get selectedSymptomIds => _selectedSymptomIds;
  List<int> get selectedActionIds => _selectedActionIds;
  List<int> get selectedSpecialNoteIds => _selectedSpecialNoteIds;
  bool get hasOtherSymptomSelected =>
      _selectedSymptomIds.contains(_getOtherSymptomId());
  bool get hasOtherActionSelected =>
      _selectedActionIds.contains(_getOtherActionId());

  // 獲取當前主訴類型的「其它」症狀 ID
  int? _getOtherSymptomId() {
    if (_chiefComplaint?.chiefComplaintTypeId == null) return null;

    // 取得當前類型的所有症狀細項
    final typeId = _chiefComplaint!.chiefComplaintTypeId!;
    final details = getChiefComplaintDetails(typeId);

    // 在當前類型中找「其它」或「其他」
    try {
      return details.firstWhere((d) => d.name == '其它' || d.name == '其他').id;
    } catch (e) {
      debugPrint('系統:找不到「其它」症狀 ID for typeId=$typeId');
      return null;
    }
  }

  // 獲取「其它」處置項目的 ID
  int? _getOtherActionId() {
    try {
      return actionItems.firstWhere((a) => a.name == '其他').id;
    } catch (e) {
      return null;
    }
  }

  // === 多對多關係操作方法 ===

  // 症狀選擇
  Future<void> toggleSymptom(int symptomId) async {
    if (_chiefComplaint == null) return;
    try {
      await db.treatmentDao.toggleChiefComplaintSymptom(
        _chiefComplaint!.complaintId,
        symptomId,
      );
      await _reloadSymptomIds();
      debugPrint('系統:症狀選擇已切換 ID=$symptomId');
    } catch (e) {
      debugPrint('系統:症狀選擇切換失敗 - $e');
    }
  }

  Future<void> _clearAllSymptoms() async {
    if (_chiefComplaint == null) return;
    try {
      await db.treatmentDao.clearChiefComplaintSymptoms(
        _chiefComplaint!.complaintId,
      );
      _selectedSymptomIds = [];
      notifyListeners();
      debugPrint('系統:已清除主訴症狀關聯 (主訴類型切換)');
    } catch (e) {
      debugPrint('系統:清除主訴症狀失敗 - $e');
    }
  }

  Future<void> _reloadSymptomIds() async {
    if (_chiefComplaint == null) {
      _selectedSymptomIds = [];
    } else {
      _selectedSymptomIds = await db.treatmentDao.getChiefComplaintSymptomIds(
        _chiefComplaint!.complaintId,
      );
    }
    notifyListeners();
  }

  // 處置項目選擇
  Future<void> toggleActionItem(int actionItemId) async {
    if (_treatment == null) return;
    try {
      await db.treatmentDao.toggleTreatmentAction(
        _treatment!.treatmentId,
        actionItemId,
      );
      await _reloadActionIds();

      // 同步更新 actionSummary 欄位（供 Firestore 同步使用）
      await _syncActionSummaryToTreatment();

      // 同步更新 MedicalRecord 狀態
      // 1. 取得目前所有選中的項目名稱
      final selectedItems = actionItems
          .where((item) => _selectedActionIds.contains(item.id))
          .map((item) => item.name)
          .toList();

      // 2. 判斷是否包含關鍵項目
      final hasCPR = selectedItems.contains('CPR');
      final hasReferral = selectedItems.contains('建議轉診');

      // 3. 更新 MedicalRecord
      await db.medicalDao.updateMedicalStatus(
        medicalId,
        isEmergency: hasCPR,
        hasAmbulance: hasReferral,
      );
      await _reloadMedicalRecord();

      debugPrint('系統:處置項目選擇已切換 ID=$actionItemId, CPR=$hasCPR, 轉診=$hasReferral');
    } catch (e) {
      debugPrint('系統:處置項目選擇切換失敗 - $e');
    }
  }

  // 同步 actionSummary 到 Treatment 表（供 Firestore 同步）
  Future<void> _syncActionSummaryToTreatment() async {
    if (_treatment == null) return;

    final selectedNames = actionItems
        .where((item) => _selectedActionIds.contains(item.id))
        .map((item) => item.name)
        .toList();

    final actionSummaryStr = selectedNames.join(',');

    await db.treatmentDao.updateTreatment(
      TreatmentCompanion(
        treatmentId: Value(_treatment!.treatmentId),
        actionSummary: Value(actionSummaryStr),
        syncStatus: const Value(1),
      ),
    );

    // 重新載入 treatment
    _treatment = await db.treatmentDao.getTreatment(medicalId);
  }

  Future<void> _reloadActionIds() async {
    if (_treatment == null) {
      _selectedActionIds = [];
    } else {
      _selectedActionIds = await db.treatmentDao.getTreatmentActionIds(
        _treatment!.treatmentId,
      );
    }
    notifyListeners();
  }

  // 特別註記選擇
  Future<void> toggleSpecialNote(int noteRefId) async {
    try {
      // 確保 SpecialNotes 記錄存在
      if (_specialNotes == null) {
        await db.treatmentDao.insertSpecialNotes(
          SpecialNotesCompanion.insert(
            medicalId: medicalId,
            syncStatus: const Value(1), // 待同步
          ),
        );
        _specialNotes = await db.treatmentDao.getSpecialNotes(medicalId);
      }

      if (_specialNotes != null) {
        await db.treatmentDao.toggleSpecialNote(
          _specialNotes!.noteId,
          noteRefId,
        );
        // 更新 syncStatus 觸發上傳
        await db.treatmentDao.updateSpecialNotes(
          SpecialNotesCompanion(
            noteId: Value(_specialNotes!.noteId),
            syncStatus: const Value(1),
          ),
        );
        _specialNotes = await db.treatmentDao.getSpecialNotes(medicalId);
        await _reloadSpecialNoteIds();
        debugPrint('系統:特別註記選擇已切換 ID=$noteRefId');
      }
    } catch (e) {
      debugPrint('系統:特別註記選擇切換失敗 - $e');
    }
  }

  Future<void> _reloadSpecialNoteIds() async {
    if (_specialNotes == null) {
      _selectedSpecialNoteIds = [];
    } else {
      _selectedSpecialNoteIds = await db.treatmentDao.getSpecialNoteIds(
        _specialNotes!.noteId,
      );
    }
    notifyListeners();
  }

  // === 正規化參考表更新方法 ===

  // 更新病史狀態
  Future<void> updateHistoryStatus(int? statusId) async {
    if (_medicalHistory == null) return;
    try {
      await db.treatmentDao.updateMedicalHistory(
        MedicalHistoryCompanion(
          historyId: Value(_medicalHistory!.historyId),
          pastHistoryStatusId: Value(statusId),
        ),
      );
      _medicalHistory = await db.treatmentDao.getMedicalHistory(medicalId);
      notifyListeners();
      debugPrint('系統:病史狀態已更新 ID=$statusId');
    } catch (e) {
      debugPrint('系統:病史狀態更新失敗 - $e');
    }
  }

  // === 多對多關係資料載入 ===

  Future<void> _loadMultiSelectData() async {
    await _reloadSymptomIds();
    await _reloadActionIds();
    await _reloadSpecialNoteIds();
  }

  // ===================================================================
  // 轉診單/切結書 CRUD
  // ===================================================================

  Timer? _referralFormDebounceTimer;
  SaveStatus _referralFormSaveStatus = SaveStatus.idle;
  SaveStatus get referralFormSaveStatus => _referralFormSaveStatus;

  void updateReferralContactInfo({
    String? name,
    String? phone,
    String? address,
    String? idNo,
  }) {
    if (_referralForm == null) return;
    _referralForm = _referralForm!.copyWith(
      contactName: name != null ? Value(name) : const Value.absent(),
      contactPhone: phone != null ? Value(phone) : const Value.absent(),
      contactAddress: address != null ? Value(address) : const Value.absent(),
      contactIdNo: idNo != null ? Value(idNo) : const Value.absent(),
    );
    notifyListeners();
    _autoSaveReferralForm();
  }

  void updateReferralConsent({
    String? otherRelationship,
    Uint8List? signature,
    DateTime? consentDateTime,
  }) {
    if (_referralForm == null) return;
    final existingConsentDateTime = _referralForm!.consentDateTime;
    final nextConsentDateTime =
        consentDateTime ??
        (signature != null
            ? existingConsentDateTime ?? DateTime.now()
            : existingConsentDateTime);
    _referralForm = _referralForm!.copyWith(
      otherRelationship: otherRelationship != null
          ? Value(otherRelationship)
          : const Value.absent(),
      consentSignature: signature != null
          ? Value(signature)
          : const Value.absent(),
      consentDateTime:
          consentDateTime != null ||
              (signature != null && existingConsentDateTime == null)
          ? Value(nextConsentDateTime)
          : const Value.absent(),
    );
    notifyListeners();
    _autoSaveReferralForm();
  }

  void _autoSaveReferralForm() {
    if (_referralFormDebounceTimer?.isActive ?? false) {
      _referralFormDebounceTimer!.cancel();
    }
    _referralFormSaveStatus = SaveStatus.saving;

    _referralFormDebounceTimer = Timer(const Duration(seconds: 5), () async {
      if (_isDisposed) return;
      debugPrint('系統:正在自動儲存轉診單/切結書...');
      await _saveReferralFormToDatabase();
    });
  }

  Future<void> _saveReferralFormToDatabase() async {
    if (_referralForm == null) return;
    if (_isDisposed) return;
    try {
      await db.referralFormDao.updateContactInfo(
        _referralForm!.formId,
        name: _referralForm!.contactName,
        phone: _referralForm!.contactPhone,
        address: _referralForm!.contactAddress,
        idNo: _referralForm!.contactIdNo,
      );
      await db.referralFormDao.updateConsent(
        _referralForm!.formId,
        otherRelationship: _referralForm!.otherRelationship,
        consentDateTime: _referralForm!.consentDateTime,
      );
      if (_referralForm!.consentSignature != null) {
        await db.referralFormDao.updateConsentSignature(
          _referralForm!.formId,
          _referralForm!.consentSignature!,
        );
      }

      debugPrint('系統:轉診單/切結書自動存檔成功');
      if (_isDisposed || !hasListeners) return;
      _referralFormSaveStatus = SaveStatus.success;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 3));
      if (_isDisposed || !hasListeners) return;
      _referralFormSaveStatus = SaveStatus.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('系統:轉診單/切結書自動存檔失敗 - $e');
      if (_isDisposed || !hasListeners) return;
      _referralFormSaveStatus = SaveStatus.idle;
      notifyListeners();
    }
  }

  // ===================================================================
  // 延遲存檔邏輯
  // ===================================================================

  void _autoSave() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _saveStatus = SaveStatus.saving;

    _debounceTimer = Timer(const Duration(seconds: 5), () async {
      debugPrint('系統:正在自動存檔處置記錄至資料庫...');
      unawaited(_saveToDatabase());
    });
  }

  Future<void> _saveToDatabase() async {
    if (_isDisposed) return;
    try {
      if (_treatment != null) {
        // 確保 syncStatus=1 以觸發 Firestore 同步
        await db.treatmentDao.updateTreatment(
          _treatment!.copyWith(syncStatus: 1).toCompanion(true),
        );
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
    // 取消處置記錄的延遲儲存
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      try {
        _saveToDatabase();
      } catch (e) {
        debugPrint('系統:處置記錄儲存失敗 - $e');
      }
    }
    // 生命徵象儲存（參考 incident_view.dart 模式）
    if (_vitalSignsDebounceTimer?.isActive ?? false) {
      _vitalSignsDebounceTimer!.cancel();
      try {
        _saveVitalSignsToDatabase();
      } catch (e) {
        debugPrint('系統:生命徵象儲存失敗 - $e');
      }
    }
    // 意識與理學檢查儲存
    if (_consciousnessExamDebounceTimer?.isActive ?? false) {
      _consciousnessExamDebounceTimer!.cancel();
      try {
        _saveConsciousnessAndExamToDatabase();
      } catch (e) {
        debugPrint('系統:意識與理學檢查儲存失敗 - $e');
      }
    }
    // 病史與過敏儲存
    if (_historyDebounceTimer?.isActive ?? false) {
      _historyDebounceTimer!.cancel();
      try {
        _saveHistoryToDatabase();
      } catch (e) {
        debugPrint('系統:病史儲存失敗 - $e');
      }
    }
    // 轉診單/切結書儲存
    if (_referralFormDebounceTimer?.isActive ?? false) {
      _referralFormDebounceTimer!.cancel();
      try {
        _saveReferralFormToDatabase();
      } catch (e) {
        debugPrint('系統:轉診單儲存失敗 - $e');
      }
    }
    _isDisposed = true;
    super.dispose();
  }
}
