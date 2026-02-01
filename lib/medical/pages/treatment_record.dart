import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../../data/models/medical/treatment_view.dart';
import '../../data/db/database.dart';
import '../widgets/icd10_search_sheet.dart';
import '../widgets/staff_search_sheet.dart';
import '../widgets/reference_search_sheet.dart';

class TreatmentRecord extends StatefulWidget {
  final int medicalId;

  const TreatmentRecord({super.key, required this.medicalId});

  @override
  State<TreatmentRecord> createState() => _TreatmentRecordState();
}

class _TreatmentRecordState extends State<TreatmentRecord> {
  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // 控制器
  late TextEditingController _otherSymptomController;
  late TextEditingController _supplementaryNotesController;
  late TextEditingController _pastHistoryDetailController;
  late TextEditingController _allergyDetailController;
  late TextEditingController _actionSummaryOtherController;

  bool _isInitialized = false;

  // CDC 篩檢相關
  bool _cdcPassed = false;
  String _screeningMethod = '';

  // 影像記錄
  bool _photoTrauma = false;
  bool _photoEcg = false;
  bool _photoOther = false;

  // 生命徵象 Controllers
  late TextEditingController _tempController;
  late TextEditingController _pulseController;
  late TextEditingController _breathController;
  late TextEditingController _systolicController;
  late TextEditingController _diastolicController;
  late TextEditingController _spo2Controller;

  // 意識與理學檢查 Controllers
  late TextEditingController _gcsEController;
  late TextEditingController _gcsVController;
  late TextEditingController _gcsMController;
  late TextEditingController _leftPupilSizeController;
  late TextEditingController _rightPupilSizeController;
  late TextEditingController _headNeckController;
  late TextEditingController _chestController;
  late TextEditingController _abdomenController;
  late TextEditingController _extremitiesController;
  late TextEditingController _otherPhysicalExamController;

  // ICD-10 Controllers
  late TextEditingController _tentativeController;
  late TextEditingController _secondaryDiagnosis1Controller;
  late TextEditingController _secondaryDiagnosis2Controller;

  // 意識檢查狀態（非 Controller，用於 Checkbox 和 SegmentedControl）
  bool _isAlert = true;
  int? _leftPupilReactionId = 1; // 1 = positive (+)
  int? _rightPupilReactionId = 1; // 1 = positive (+)
  int? _gcsTotal; // GCS Total 自動計算，不儲存到 Controller

  // 處置項目選擇 (現在由 ViewModel 管理多對多關聯)
  // 不再需要本地狀態變量

  // 協助人員
  // final List<String> _assistStaffList = [];
  // late TextEditingController _assistStaffController;

  // 負責人與 EMT
  late TextEditingController _directorNameController;
  late TextEditingController _otherSpecialNoteController;

  // 健康評估表 controller（數據來自 ViewModel）
  final Map<int, Map<String, TextEditingController>>
  _healthAssessmentControllers = {};

  @override
  void initState() {
    super.initState();
    _otherSymptomController = TextEditingController();
    _supplementaryNotesController = TextEditingController();
    _pastHistoryDetailController = TextEditingController();
    _allergyDetailController = TextEditingController();
    _actionSummaryOtherController = TextEditingController();
    // _assistStaffController = TextEditingController();
    _directorNameController = TextEditingController();
    _otherSpecialNoteController = TextEditingController();

    // 生命徵象 Controllers
    _tempController = TextEditingController();
    _pulseController = TextEditingController();
    _breathController = TextEditingController();
    _systolicController = TextEditingController();
    _diastolicController = TextEditingController();
    _spo2Controller = TextEditingController();

    // 意識與理學檢查 Controllers
    _gcsEController = TextEditingController();
    _gcsVController = TextEditingController();
    _gcsMController = TextEditingController();
    _leftPupilSizeController = TextEditingController();
    _rightPupilSizeController = TextEditingController();
    _headNeckController = TextEditingController();
    _chestController = TextEditingController();
    _abdomenController = TextEditingController();
    _extremitiesController = TextEditingController();
    _otherPhysicalExamController = TextEditingController();

    // ICD-10 Controllers
    _tentativeController = TextEditingController();
    _secondaryDiagnosis1Controller = TextEditingController();
    _secondaryDiagnosis2Controller = TextEditingController();
  }

  @override
  void dispose() {
    _otherSymptomController.dispose();
    _supplementaryNotesController.dispose();
    _pastHistoryDetailController.dispose();
    _allergyDetailController.dispose();
    _actionSummaryOtherController.dispose();
    // _assistStaffController.dispose();
    _directorNameController.dispose();
    _otherSpecialNoteController.dispose();

    // 清理生命徵象 Controllers
    _tempController.dispose();
    _pulseController.dispose();
    _breathController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _spo2Controller.dispose();

    // 清理意識與理學檢查 Controllers
    _gcsEController.dispose();
    _gcsVController.dispose();
    _gcsMController.dispose();
    _leftPupilSizeController.dispose();
    _rightPupilSizeController.dispose();
    _headNeckController.dispose();
    _chestController.dispose();
    _abdomenController.dispose();
    _extremitiesController.dispose();
    _otherPhysicalExamController.dispose();

    // 清理 ICD-10 Controllers
    _tentativeController.dispose();
    _secondaryDiagnosis1Controller.dispose();
    _secondaryDiagnosis2Controller.dispose();

    // 清理健康評估表的 controller
    for (var controllers in _healthAssessmentControllers.values) {
      controllers['name']?.dispose();
      controllers['relation']?.dispose();
      controllers['temp']?.dispose();
    }
    super.dispose();
  }

  // 當 ViewModel 資料載入後,同步到 Controller
  void _updateControllers(TreatmentViewModel viewModel) {
    if (_isInitialized) return;

    // 從 Medical 表讀取 CDC 狀態
    final medicalRecord = viewModel.medicalRecord;
    if (medicalRecord != null) {
      _cdcPassed = medicalRecord.cdcPassed ?? false;
      _screeningMethod = medicalRecord.screeningMethod ?? '';
    }

    final complaint = viewModel.chiefComplaint;
    if (complaint != null) {
      _otherSymptomController.text = complaint.otherSymptomDetail ?? '';
      _supplementaryNotesController.text = complaint.supplementaryNotes ?? '';
    }

    final history = viewModel.medicalHistory;
    if (history != null) {
      _pastHistoryDetailController.text = history.pastHistoryDetail ?? '';
      _allergyDetailController.text = history.allergyDetail ?? '';
      // 病史狀態現在由 ViewModel 從參考表管理
      // 不再需要從本地狀態變量載入
    }

    final treatment = viewModel.treatment;
    if (treatment != null) {
      _actionSummaryOtherController.text = treatment.actionSummaryOther ?? '';

      // 處置項目現在通過多對多關聯表管理，由 ViewModel 自動載入
      // 不再需要從 JSON 字串解析

      // 載入 ICD-10 資料
      _tentativeController.text = treatment.tentative ?? '';
      _secondaryDiagnosis1Controller.text = treatment.secondaryDiagnosis1 ?? '';
      _secondaryDiagnosis2Controller.text = treatment.secondaryDiagnosis2 ?? '';

      // 載入負責人姓名
      _directorNameController.text = treatment.directorName ?? '';
    }

    // 載入特別註記的其他說明
    final specialNotes = viewModel.specialNotes;
    if (specialNotes != null) {
      // 特別註記現在通過多對多關聯表管理，由 ViewModel 自動載入
      _otherSpecialNoteController.text = specialNotes.otherNotes ?? '';
    }

    // 檢查已有影像，自動勾選對應類型
    final mediaList = viewModel.medicalMediaList;
    if (mediaList.isNotEmpty) {
      _photoTrauma = mediaList.any((media) => media.mediaType == 'trauma');
      _photoEcg = mediaList.any((media) => media.mediaType == 'ecg');
      _photoOther = mediaList.any((media) => media.mediaType == 'other');
    }

    // 載入生命徵象資料到 Controllers
    final latestAssessment = viewModel.latestVitalSigns;
    debugPrint(
      'DEBUG: 載入生命徵象資料 - assessments數量: ${viewModel.medicalAssessments.length}',
    );
    if (latestAssessment != null) {
      debugPrint(
        'DEBUG: 最新評估 - 體溫: ${latestAssessment.temperature}, 脈搏: ${latestAssessment.pulse}',
      );
      _tempController.text = latestAssessment.temperature?.toString() ?? '';
      _pulseController.text = latestAssessment.pulse?.toString() ?? '';
      _breathController.text = latestAssessment.breath?.toString() ?? '';
      _systolicController.text = latestAssessment.systolic?.toString() ?? '';
      _diastolicController.text = latestAssessment.diastolic?.toString() ?? '';
      _spo2Controller.text = latestAssessment.spo2?.toString() ?? '';
      debugPrint(
        'DEBUG: Controller已設定 - 體溫: ${_tempController.text}, 脈搏: ${_pulseController.text}',
      );
    } else {
      debugPrint('DEBUG: 無生命徵象資料');
    }

    // 載入意識與理學檢查資料
    final latestConsciousnessExam = viewModel.latestConsciousnessExam;
    if (latestConsciousnessExam != null) {
      // GCS
      _gcsEController.text = latestConsciousnessExam.gcsE ?? '';
      _gcsVController.text = latestConsciousnessExam.gcsV ?? '';
      _gcsMController.text = latestConsciousnessExam.gcsM ?? '';
      // GCS Total 自動計算，不從資料庫載入，而是根據 E+V+M 計算
      final e = int.tryParse(_gcsEController.text) ?? 0;
      final v = int.tryParse(_gcsVController.text) ?? 0;
      final m = int.tryParse(_gcsMController.text) ?? 0;
      _gcsTotal = e + v + m;

      // 瞳孔
      _leftPupilSizeController.text =
          latestConsciousnessExam.leftPupilSize?.toString() ?? '';
      _rightPupilSizeController.text =
          latestConsciousnessExam.rightPupilSize?.toString() ?? '';
      _leftPupilReactionId = latestConsciousnessExam.leftPupilReactionId ?? 1;
      _rightPupilReactionId = latestConsciousnessExam.rightPupilReactionId ?? 1;

      // 理學檢查
      _headNeckController.text = latestConsciousnessExam.headNeckExam ?? '';
      _chestController.text = latestConsciousnessExam.chestExam ?? '';
      _abdomenController.text = latestConsciousnessExam.abdomenExam ?? '';
      _extremitiesController.text =
          latestConsciousnessExam.extremitiesExam ?? '';
      _otherPhysicalExamController.text =
          latestConsciousnessExam.otherPhysicalExam ?? '';

      // 意識狀態 - 檢查 consciousnessLevelId 是否對應 'alert' (ID = 1)
      _isAlert = latestConsciousnessExam.consciousnessLevelId == 1;

      debugPrint('DEBUG: 意識與理學檢查資料已載入 - GCS: $_gcsTotal');
    } else {
      debugPrint('DEBUG: 無意識與理學檢查資料');
    }

    _isInitialized = true;
  }

  // 同步健康評估表編輯的值到資料庫

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreatmentViewModel>();
    final treatment = viewModel.treatment;

    if (treatment != null) {
      _updateControllers(viewModel);
    }

    if (treatment == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('載入處置記錄中...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  title: '篩檢與評估 CDC Screening',
                  icon: Icons.assignment_ind_outlined,
                  child: _buildCdcSection(viewModel),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildCard(
                  title: '主訴類別 Chief Complaint',
                  icon: Icons.medical_information_outlined,
                  child: _buildComplaintSection(viewModel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCard(
            title: '影像記錄 Photo Records',
            icon: Icons.photo_camera,
            child: _buildPhotoSection(viewModel),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  title: '生命徵象 Vital Signs',
                  icon: Icons.monitor_heart,
                  child: _buildVitalSignsSection(viewModel),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildCard(
                  title: '意識與理學檢查 Consciousness & Exam',
                  icon: Icons.psychology,
                  child: _buildConsciousnessSection(viewModel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  title: '病史與過敏 History',
                  icon: Icons.history_edu,
                  child: _buildHistorySection(viewModel),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildCard(
                  title: '診斷與代碼 Diagnosis & ICD-10',
                  icon: Icons.medical_information,
                  child: _buildDiagnosisSection(viewModel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCard(
            title: '檢傷與處置 Outcome & Treatment',
            icon: Icons.emergency_outlined,
            child: _buildOutcomeTreatmentSection(viewModel),
          ),
          const SizedBox(height: 20),
          _buildCard(
            title: '醫護人員與簽章 Staff & Signs',
            icon: Icons.app_registration_rounded,
            child: _buildStaffSignsSection(viewModel),
          ),
          const SizedBox(height: 20),
          _buildCard(
            title: '特別註記 Special Notes',
            icon: Icons.note_alt_outlined,
            child: _buildSpecialNotesSection(viewModel),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- 各區塊實作 ---

  Widget _buildCdcSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxTile(
          label: '疾病管制署篩檢項目 Passed',
          value: _cdcPassed,
          onChanged: (v) async {
            setState(() => _cdcPassed = v!);
            // 取消勾選時清除篩檢方式資料
            if (!_cdcPassed) {
              _screeningMethod = '';
            }
            // 保存到資料庫
            await viewModel.updateCDCStatus(
              cdcPassed: v!,
              screeningMethod: _cdcPassed ? _screeningMethod : '',
            );
          },
        ),
        if (_cdcPassed) ...[
          const SizedBox(height: 16),
          _buildLabel('篩檢方式 Screening Method'),
          const SizedBox(height: 4),
          _buildSegmentedControl(['喉頭採檢', '抽血檢驗', '其它'], _screeningMethod, (
            v,
          ) async {
            setState(() => _screeningMethod = v);
            // 保存到資料庫
            await viewModel.updateCDCStatus(
              cdcPassed: true,
              screeningMethod: v,
            );
          }),
          if (_screeningMethod == '其它') ...[
            const SizedBox(height: 8),
            _buildTextField(hint: '請輸入其它方式'),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('健康評估表'),
              TextButton(
                onPressed: () async {
                  // 直接添加到資料庫
                  await viewModel.addHealthAssessment(name: '', relation: '');
                },
                child: const Text(
                  '+ 新增',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _buildHealthAssessmentList(viewModel),
        ],
      ],
    );
  }

  Widget _buildComplaintSection(TreatmentViewModel viewModel) {
    final complaint = viewModel.chiefComplaint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('主訴類別 Type'),
        const SizedBox(height: 4),
        Row(
          children: [
            for (var i = 0; i < viewModel.complaintTypes.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              _buildTypeButton(
                viewModel.complaintTypes[i],
                complaint?.chiefComplaintTypeId,
                (id) {
                  // 切換主訴類別時，由 ViewModel 處理關聯表清理
                  viewModel.updateChiefComplaint(chiefComplaintTypeId: id);
                },
              ),
            ],
          ],
        ),
        if (complaint?.chiefComplaintTypeId != null) ...[
          const SizedBox(height: 12),
          _buildSymptomGrid(viewModel, complaint!),
          if (viewModel.hasOtherSymptomSelected) ...[
            const SizedBox(height: 8),
            _buildTextField(
              hint: '請註明其它主訴',
              controller: _otherSymptomController,
              onChanged: (val) =>
                  viewModel.updateChiefComplaint(otherSymptomDetail: val),
            ),
          ],
        ],
        const SizedBox(height: 16),
        _buildLabel('補充說明 Supplementary Notes'),
        const SizedBox(height: 4),
        _buildTextField(
          hint: '患者詳細情況描述...',
          maxLines: 2,
          controller: _supplementaryNotesController,
          onChanged: (val) =>
              viewModel.updateChiefComplaint(supplementaryNotes: val),
        ),
      ],
    );
  }

  Widget _buildPhotoSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildSmallCheckbox(
              '外傷 Trauma',
              _photoTrauma,
              (v) => setState(() => _photoTrauma = v!),
            ),
            const SizedBox(width: 24),
            _buildSmallCheckbox(
              '心電圖 ECG',
              _photoEcg,
              (v) => setState(() => _photoEcg = v!),
            ),
            const SizedBox(width: 24),
            _buildSmallCheckbox(
              '其它 Other',
              _photoOther,
              (v) => setState(() => _photoOther = v!),
            ),
          ],
        ),
        if (_photoTrauma)
          _buildPhotoGrid(viewModel, '外傷影像 Trauma Photos', 'trauma'),
        if (_photoEcg) _buildPhotoGrid(viewModel, '心電圖紀錄 ECG Records', 'ecg'),
        if (_photoOther) ...[
          _buildPhotoGrid(viewModel, '其它影像 Other Photos', 'other'),
          const SizedBox(height: 8),
          _buildTextField(
            hint: '請註明影像內容...',
            onChanged: (val) {
              // 可選：保存描述到資料庫
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoGrid(
    TreatmentViewModel viewModel,
    String label,
    String mediaType,
  ) {
    // 獲取該類型的已儲存照片
    final mediaList = viewModel.getMediaByType(mediaType);
    final storedCount = mediaList.length;
    final emptySlots = 6 - storedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
          children: [
            // 顯示已儲存的照片（帶刪除按鈕）
            ...mediaList.map((media) => _buildPhotoItem(media, viewModel)),
            // 顯示空的上傳槽
            if (emptySlots > 0)
              ...List.generate(
                emptySlots,
                (index) => _buildPhotoUploadBox(index, mediaType, viewModel),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoItem(MedicalMediaData media, TreatmentViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        // 點擊照片顯示大圖預覽
        showDialog(
          context: context,
          builder: (context) {
            final screenSize = MediaQuery.of(context).size;
            final maxHeight = screenSize.height * 0.8;
            final maxWidth = screenSize.width * 0.9;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 大圖顯示（限制高度）
                      Flexible(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Image.memory(
                              base64Decode(media.base64Data),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      // 底部資訊欄
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                media.description ?? '醫療影像',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '點擊關閉',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgField,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
              image: DecorationImage(
                image: MemoryImage(base64Decode(media.base64Data)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 刪除按鈕
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('確認刪除'),
                    content: const Text('確定要刪除這張照片嗎？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('刪除'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await viewModel.deleteMedicalMedia(media.mediaId);
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('照片已刪除')));
                  }
                }
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCheckbox(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadBox(
    int index,
    String mediaType,
    TreatmentViewModel viewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgField,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, style: BorderStyle.solid),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            try {
              // 顯示選擇相機或相簿的選項
              final ImageSource? source = await showDialog<ImageSource>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('選擇照片來源'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, ImageSource.camera),
                        child: const Text('相機'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, ImageSource.gallery),
                        child: const Text('相簿'),
                      ),
                    ],
                  );
                },
              );

              if (source == null) return;

              // 選擇圖片（醫療影像需要較高解析度）
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile = await picker.pickImage(
                source: source,
                maxWidth: 1920,
                maxHeight: 1920,
                imageQuality: 95,
              );

              if (pickedFile == null) return;

              // 讀取檔案並轉換為 base64
              final File imageFile = File(pickedFile.path);
              final List<int> imageBytes = await imageFile.readAsBytes();
              final String base64String = base64Encode(imageBytes);

              // 儲存到資料庫
              await viewModel.addMedicalMedia(
                mediaType: mediaType,
                base64Data: base64String,
                description: '$mediaType photo ${index + 1}',
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已新增 $mediaType 照片 ${index + 1}')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('照片儲存失敗: $e')));
              }
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: textMuted.withValues(alpha: 0.5),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                'TAP TO CAPTURE',
                style: TextStyle(
                  color: textMuted.withValues(alpha: 0.5),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalSignsSection(TreatmentViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildVitalFieldWithController(
                label: '體溫 Temp (°C)',
                controller: _tempController,
                onChanged: () => _onVitalSignChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildVitalFieldWithController(
                label: '脈搏 Pulse (bpm)',
                controller: _pulseController,
                onChanged: () => _onVitalSignChanged(viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildVitalFieldWithController(
                label: '呼吸 RR (/min)',
                controller: _breathController,
                onChanged: () => _onVitalSignChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBloodPressureWithControllers(
                systolicController: _systolicController,
                diastolicController: _diastolicController,
                onChanged: () => _onVitalSignChanged(viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildVitalFieldWithController(
                label: '血氧 SpO2 (%)',
                controller: _spo2Controller,
                onChanged: () => _onVitalSignChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // 保持對齊的佔位
          ],
        ),
      ],
    );
  }

  Widget _buildConsciousnessSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxTile(
          label: '意識清晰 Alert & Oriented',
          value: _isAlert,
          onChanged: (v) {
            setState(() => _isAlert = v!);
            if (_isAlert) {
              _gcsEController.clear();
              _gcsVController.clear();
              _gcsMController.clear();
              _gcsTotal = null;
            }
            _onConsciousnessAndExamChanged(viewModel);
          },
        ),
        if (!_isAlert) ...[
          const SizedBox(height: 12),
          _buildLabel('GCS 指數評估'),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: 'E',
                  controller: _gcsEController,
                  textAlign: TextAlign.center,
                  onChanged: (_) => _updateGCSTotalAndValidate(viewModel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(
                  hint: 'V',
                  controller: _gcsVController,
                  textAlign: TextAlign.center,
                  onChanged: (_) => _updateGCSTotalAndValidate(viewModel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(
                  hint: 'M',
                  controller: _gcsMController,
                  textAlign: TextAlign.center,
                  onChanged: (_) => _updateGCSTotalAndValidate(viewModel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _gcsTotal != null ? 'Total: $_gcsTotal' : 'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _gcsTotal != null ? primaryColor : textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPupilSection(
                  '左瞳孔 Left Pupil',
                  (v) {
                    setState(
                      () => _leftPupilReactionId = v == '+'
                          ? 1
                          : (v == '-' ? 2 : 3),
                    );
                    _onConsciousnessAndExamChanged(viewModel);
                  },
                  _leftPupilReactionId == 1
                      ? '+'
                      : (_leftPupilReactionId == 2 ? '-' : '±'),
                  _leftPupilSizeController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPupilSection(
                  '右瞳孔 Right Pupil',
                  (v) {
                    setState(
                      () => _rightPupilReactionId = v == '+'
                          ? 1
                          : (v == '-' ? 2 : 3),
                    );
                    _onConsciousnessAndExamChanged(viewModel);
                  },
                  _rightPupilReactionId == 1
                      ? '+'
                      : (_rightPupilReactionId == 2 ? '-' : '±'),
                  _rightPupilSizeController,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),

        // --- 這裡改用 Row 佈局取代 GridView ---
        Row(
          children: [
            Expanded(
              child: _buildLabeledFieldWithController(
                '頭頸部 Head/Neck',
                '',
                _headNeckController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLabeledFieldWithController(
                '胸部 Chest',
                '',
                _chestController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildLabeledFieldWithController(
                '腹部 Abdomen',
                '',
                _abdomenController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLabeledFieldWithController(
                '四肢 Extremities',
                '',
                _extremitiesController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildLabeledFieldWithController(
          '其它理學觀察 Other Observations...',
          '',
          _otherPhysicalExamController,
          () => _onConsciousnessAndExamChanged(viewModel),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildHistorySection(TreatmentViewModel viewModel) {
    // 从参考表获取病史状态选项
    final historyStatuses = viewModel.historyStatuses;
    final historyStatusNames = historyStatuses.map((s) => s.name).toList();

    // 获取当前选中的病史状态名称
    String selectedHistoryStatus = '無';
    if (viewModel.selectedHistoryStatusId != null &&
        historyStatuses.isNotEmpty) {
      final status = historyStatuses
          .where((s) => s.id == viewModel.selectedHistoryStatusId)
          .firstOrNull;
      if (status != null) {
        selectedHistoryStatus = status.name;
      }
    }

    // 过敏史使用同样的参考表或单独的状态
    final allergyStatuses = viewModel.allergyStatuses;
    final allergyStatusNames = allergyStatuses.map((s) => s.name).toList();

    String selectedAllergyStatus = '無';
    if (viewModel.selectedAllergyStatusId != null &&
        allergyStatuses.isNotEmpty) {
      final status = allergyStatuses
          .where((s) => s.id == viewModel.selectedAllergyStatusId)
          .firstOrNull;
      if (status != null) {
        selectedAllergyStatus = status.name;
      }
    }

    // 查找"有"（需要详细说明）的状态ID - 通常code为'yes'
    final hasStatusId = historyStatuses
        .where((s) => s.code == 'yes')
        .firstOrNull
        ?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('過去病史 Past Medical History'),
        const SizedBox(height: 4),
        if (historyStatusNames.isNotEmpty)
          _buildSegmentedControl(historyStatusNames, selectedHistoryStatus, (
            v,
          ) {
            final selectedStatus = historyStatuses
                .where((s) => s.name == v)
                .firstOrNull;
            if (selectedStatus != null) {
              // 如果切換到不是"有"的状态，清除詳細資料
              if (selectedStatus.code != 'yes') {
                _pastHistoryDetailController.clear();
              }
              // 同步到 ViewModel 並觸發 auto-save (使用 optimistic update)
              viewModel.updatePastHistoryStatusId(selectedStatus.id);
            }
          })
        else
          // 如果参考表为空，显示加载中
          const Text('載入中...'),
        if (viewModel.selectedHistoryStatusId == hasStatusId) ...[
          const SizedBox(height: 8),
          _buildTextField(
            hint: '列出慢性病或手術史...',
            maxLines: 2,
            controller: _pastHistoryDetailController,
            onChanged: (val) => viewModel.updatePastHistoryDetail(val),
          ),
        ],
        const SizedBox(height: 16),
        _buildLabel('過敏史 Allergy History'),
        const SizedBox(height: 4),
        if (allergyStatusNames.isNotEmpty)
          _buildSegmentedControl(allergyStatusNames, selectedAllergyStatus, (
            v,
          ) {
            final selectedStatus = allergyStatuses
                .where((s) => s.name == v)
                .firstOrNull;
            if (selectedStatus != null) {
              // 如果切換到不是"有"的状态，清除詳細資料
              if (selectedStatus.code != 'yes') {
                _allergyDetailController.clear();
              }
              // 同步到 ViewModel 並觸發 auto-save
              viewModel.updateAllergyStatusId(selectedStatus.id);
            }
          })
        else
          const Text('載入中...'),
        if (viewModel.selectedAllergyStatusId == hasStatusId) ...[
          const SizedBox(height: 8),
          _buildTextField(
            hint: '註明藥物或食物過敏狀況...',
            controller: _allergyDetailController,
            onChanged: (val) => viewModel.updateAllergyDetail(val),
          ),
        ],
      ],
    );
  }

  Widget _buildDiagnosisSection(TreatmentViewModel viewModel) {
    final treatment = viewModel.treatment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('診斷類別 Category'),
        const SizedBox(height: 4),
        _buildDiagnosisCategoryDropdown(viewModel, treatment),
        const SizedBox(height: 16),
        _buildIcdRow(
          '初步診斷 Preliminary (ICD-10)',
          '例如: I10',
          _tentativeController,
          viewModel,
          (code) => viewModel.updateTentative(code),
        ),
        const SizedBox(height: 12),
        _buildIcdRow(
          '副診斷 1 Secondary ICD-10 #1',
          '代碼',
          _secondaryDiagnosis1Controller,
          viewModel,
          (code) => viewModel.updateSecondaryDiagnosis1(code),
        ),
        const SizedBox(height: 12),
        _buildIcdRow(
          '副診斷 2 Secondary ICD-10 #2',
          '代碼',
          _secondaryDiagnosis2Controller,
          viewModel,
          (code) => viewModel.updateSecondaryDiagnosis2(code),
        ),
      ],
    );
  }

  Widget _buildOutcomeTreatmentSection(TreatmentViewModel viewModel) {
    final treatment = viewModel.treatment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('檢傷分類 Triage Level'),
        const SizedBox(height: 8),
        _buildTriageSelector(viewModel),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('現場處置 Scene Treatment'),
                  const SizedBox(height: 4),
                  _buildTreatmentOnSiteDropdown(viewModel, treatment),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('後續結果 Outcome'),
                  const SizedBox(height: 4),
                  _buildTreatmentResultDropdown(viewModel, treatment),
                  if (treatment?.resultId != null &&
                      viewModel
                              .getTreatmentResultById(treatment!.resultId)
                              ?.name ==
                          '轉其它醫院') ...[
                    const SizedBox(height: 8),
                    _buildReferralHospitalDropdown(viewModel, treatment),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildLabel('處理摘要 Summary of Action (可複選)'),
        const SizedBox(height: 8),
        _buildActionSummaryGrid(viewModel),
        // 檢查是否選中了"其他"處置項目
        if (viewModel.hasOtherActionSelected) ...[
          const SizedBox(height: 12),
          _buildTextField(
            hint: '請詳述其它處理項目...',
            maxLines: 2,
            controller: _actionSummaryOtherController,
            onChanged: (val) => viewModel.updateActionSummaryOther(val),
          ),
        ],
      ],
    );
  }

  Widget _buildTriageSelector(TreatmentViewModel viewModel) {
    final treatment = viewModel.treatment;

    return Row(
      children: viewModel.triageLevels.map((triageLevel) {
        bool isSel = treatment?.triageId == triageLevel.id;

        // 解析顏色
        Color color = Colors.grey;
        if (triageLevel.colorCode.startsWith('#')) {
          try {
            String hex = triageLevel.colorCode.replaceAll('#', '');
            if (hex.length == 6) hex = 'FF$hex';
            color = Color(int.parse('0x$hex'));
          } catch (e) {
            // ignore
          }
        } else {
          switch (triageLevel.colorCode.toLowerCase()) {
            case 'red':
              color = Colors.red;
              break;
            case 'orange':
              color = Colors.orange;
              break;
            case 'yellow':
              color = Colors.yellow.shade700;
              break;
            case 'green':
              color = Colors.green;
              break;
            case 'blue':
              color = Colors.blue;
              break;
          }
        }

        return Expanded(
          child: GestureDetector(
            onTap: () {
              viewModel.updateTriageId(triageLevel.id);
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSel ? color : color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSel ? color : color.withValues(alpha: 0.2),
                  width: isSel ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    triageLevel.level.toString(),
                    style: TextStyle(
                      color: isSel ? Colors.white : color,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    triageLevel.name,
                    style: TextStyle(
                      color: isSel ? Colors.white : color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionSummaryGrid(TreatmentViewModel viewModel) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: viewModel.actionItems.map((item) {
        bool isSelected = viewModel.selectedActionIds.contains(item.id);
        return FilterChip(
          label: Text(item.name, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (sel) {
            // 使用 ViewModel 的多对多方法
            viewModel.toggleActionItem(item.id);
          },
          selectedColor: primaryColor.withValues(alpha: 0.1),
          checkmarkColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: isSelected ? primaryColor : borderColor),
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        );
      }).toList(),
    );
  }

  Widget _buildStaffSignsSection(TreatmentViewModel viewModel) {
    // 取得醫師和護理師列表
    final doctors = viewModel.medicalStaffList
        .where((staff) => staff.role == 'Doctor')
        .toList();
    final nurses = viewModel.medicalStaffList
        .where((staff) => staff.role == 'Nurse')
        .toList();
    final emts = viewModel.medicalStaffList
        .where((staff) => staff.role == 'EMT')
        .toList();

    // 取得已指派的主要醫師和護理師
    final primaryDoctor = viewModel.staffAssignments
        .where(
          (a) =>
              viewModel.getStaffRoleCode(a.staffRoleId) == 'DOCTOR' &&
              a.isPrimary,
        )
        .firstOrNull;
    final primaryNurse = viewModel.staffAssignments
        .where(
          (a) =>
              viewModel.getStaffRoleCode(a.staffRoleId) == 'NURSE' &&
              a.isPrimary,
        )
        .firstOrNull;

    // 取得 EMT 指派
    final emtAssignment = viewModel.staffAssignments
        .where((a) => viewModel.getStaffRoleCode(a.staffRoleId) == 'EMT')
        .firstOrNull;

    // 取得 Assist Staff 指派
    final assistAssignments = viewModel.staffAssignments
        .where((a) => viewModel.getStaffRoleCode(a.staffRoleId) == 'ASSIST')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('院長/負責人 Director Name'),
        const SizedBox(height: 4),
        _buildTextField(
          hint: '請輸入負責人姓名',
          controller: _directorNameController,
          onChanged: (val) => viewModel.updateDirectorName(val),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('主責醫師 Lead Physician'),
                  const SizedBox(height: 4),
                  _buildStaffDropdown(
                    viewModel,
                    doctors,
                    primaryDoctor?.staffId,
                    '請選擇主責醫師',
                    (staffId) {
                      if (staffId != null) {
                        viewModel.addStaffAssignment(
                          staffRoleCode: 'DOCTOR',
                          staffId: staffId,
                          isPrimary: true,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('主責護理師 Lead Nurse'),
                            const SizedBox(height: 4),
                            _buildStaffDropdown(
                              viewModel,
                              nurses,
                              primaryNurse?.staffId,
                              '請選擇主責護理師',
                              (staffId) {
                                if (staffId != null) {
                                  viewModel.addStaffAssignment(
                                    staffRoleCode: 'NURSE',
                                    staffId: staffId,
                                    isPrimary: true,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('護理師簽章 Nurse Sign'),
                            const SizedBox(height: 4),
                            _buildSignatureArea(
                              context: context,
                              placeholder: '點擊簽名',
                              signatureData: primaryNurse?.signature,
                              onTap: () {
                                if (primaryNurse == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('請先選擇主責護理師')),
                                  );
                                  return;
                                }
                                _showSignatureDialog(context, '護理師簽章', (
                                  data,
                                ) async {
                                  await viewModel.updateStaffSignature(
                                    primaryNurse.staffAssignmentId,
                                    data,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'EMT 姓名 EMT Name ',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const [
                        TextSpan(
                          text: '(備註：EMT 有到現場協助出診才需填寫)',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStaffDropdown(
                    viewModel,
                    emts,
                    emtAssignment?.staffId,
                    '請選擇 EMT',
                    (staffId) {
                      if (staffId != null) {
                        viewModel.addStaffAssignment(
                          staffRoleCode: 'EMT',
                          staffId: staffId,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('EMT 簽章 EMT Sign'),
                  const SizedBox(height: 4),
                  _buildSignatureArea(
                    context: context,
                    placeholder: '點擊簽名',
                    signatureData: emtAssignment?.signature,
                    onTap: () {
                      if (emtAssignment == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('請先選擇 EMT')),
                        );
                        return;
                      }

                      _showSignatureDialog(context, 'EMT 簽章', (data) async {
                        await viewModel.updateStaffSignature(
                          emtAssignment.staffAssignmentId,
                          data,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildLabel('輔助人員 Assist Staff'),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await StaffSearchSheet.show(
                    context,
                    title: '選擇輔助人員',
                    viewModel: viewModel,
                  );
                  if (result != null) {
                    viewModel.addStaffAssignment(
                      staffRoleCode: 'ASSIST',
                      staffId: result.id,
                      staffName: result.name,
                    );
                  }
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: bgField,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: textMuted.withValues(alpha: 0.5),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '點擊搜尋並新增人員...',
                        style: TextStyle(
                          color: textMuted.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (assistAssignments.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: assistAssignments
                .map(
                  (assignment) => Chip(
                    label: Text(
                      assignment.staffName ?? 'Unknown',
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () {
                      viewModel.removeStaffAssignment(
                        assignment.staffAssignmentId,
                      );
                    },
                    backgroundColor: bgField,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSignatureArea({
    required BuildContext context,
    required String placeholder,
    required VoidCallback onTap,
    Uint8List? signatureData,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80, // 增加高度以顯示簽名
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgField,
          border: Border.all(color: borderColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: signatureData != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  signatureData,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              )
            : Center(
                child: Text(
                  placeholder,
                  style: TextStyle(
                    color: textMuted.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _showSignatureDialog(
    BuildContext context,
    String title,
    Function(Uint8List) onConfirm,
  ) async {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: 500,
          height: 300,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Signature(
            controller: controller,
            backgroundColor: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.clear(),
            child: const Text('清除', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isNotEmpty) {
                final Uint8List? data = await controller.toPngBytes();
                if (data != null) {
                  onConfirm(data);
                }
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('確認'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Widget _buildSpecialNotesSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: viewModel.specialNoteRefs.map((ref) {
            final note = ref.name;
            final bool isSelected = viewModel.selectedSpecialNoteIds.contains(
              ref.id,
            );
            return FilterChip(
              label: Text(note),
              selected: isSelected,
              onSelected: (sel) {
                // 使用 ViewModel 的多对多方法
                viewModel.toggleSpecialNote(ref.id);
              },
              selectedColor: primaryColor.withValues(alpha: 0.1),
              checkmarkColor: primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? primaryColor : textDark,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? primaryColor : borderColor,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _buildLabel('其他特別註記 Other Notes'),
        const SizedBox(height: 8),
        _buildTextField(
          hint: '請輸入其他需要補充的特殊狀況...',
          maxLines: 3,
          controller: _otherSpecialNoteController,
          onChanged: (val) => viewModel.updateSpecialNotes(otherNotes: val),
        ),
      ],
    );
  }

  // --- Dropdown 元件 ---

  Widget _buildTypeButton(
    ChiefComplaintTypeData type,
    int? currentTypeId,
    Function(int) onSelect,
  ) {
    bool isSel = currentTypeId == type.id;

    // 根據 Code 決定圖示與顯示名稱
    IconData icon;
    String label;
    if (type.code == 'TRAUMA') {
      icon = Icons.healing;
      label = '外傷 Trauma';
    } else if (type.code == 'NON_TRAUMA') {
      icon = Icons.medical_services;
      label = '非外傷 Non-trauma';
    } else {
      icon = Icons.help_outline;
      label = type.name;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(type.id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSel ? primaryColor.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSel ? primaryColor : borderColor,
              width: isSel ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSel ? primaryColor : textMuted, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSel ? textDark : textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosisCategoryDropdown(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final selectedCategory = treatment?.tentativeCategoryId != null
        ? viewModel.getDiagnosisCategoryById(treatment!.tentativeCategoryId)
        : null;
    final text = selectedCategory != null ? selectedCategory.name : '';

    return _buildSelectionField(
      text: text,
      hint: '請選取診斷分類',
      icon: Icons.category,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<DiagnosisCategoryData>(
          context,
          title: '選擇診斷分類',
          searchFunction: viewModel.searchDiagnosisCategories,
          initialSelection: selectedCategory,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          viewModel.updateTentativeCategoryId(result.id);
        }
      },
    );
  }

  Widget _buildTreatmentOnSiteDropdown(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final selectedTreatment = treatment?.treatmentOnSiteId != null
        ? viewModel.getTreatmentOnSiteById(treatment!.treatmentOnSiteId)
        : null;
    final text = selectedTreatment != null ? selectedTreatment.name : '';

    return _buildSelectionField(
      text: text,
      hint: '請選取現場處置',
      icon: Icons.medical_services,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<TreatmentOnSiteData>(
          context,
          title: '選擇現場處置',
          searchFunction: viewModel.searchTreatmentOnSites,
          initialSelection: selectedTreatment,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          viewModel.updateTreatmentOnSiteId(result.id);
        }
      },
    );
  }

  Widget _buildTreatmentResultDropdown(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final selectedResult = treatment?.resultId != null
        ? viewModel.getTreatmentResultById(treatment!.resultId)
        : null;
    final text = selectedResult != null ? selectedResult.name : '';

    return _buildSelectionField(
      text: text,
      hint: '請選取處置結果',
      icon: Icons.assignment_return,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<TreatmentResultData>(
          context,
          title: '選擇處置結果',
          searchFunction: viewModel.searchTreatmentResults,
          initialSelection: selectedResult,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          viewModel.updateResultId(result.id);
        }
      },
    );
  }

  Widget _buildReferralHospitalDropdown(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final selectedHospital = treatment?.referralHospitalId != null
        ? viewModel.getReferralHospitalById(treatment!.referralHospitalId)
        : null;
    final text = selectedHospital != null
        ? selectedHospital.name
        : (treatment?.referralHospitalFinal ?? '');

    return _buildSelectionField(
      text: text,
      hint: '請選取轉診醫院',
      icon: Icons.local_hospital,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<ReferralHospitalData>(
          context,
          title: '選擇轉診醫院',
          searchFunction: viewModel.searchReferralHospitals,
          initialSelection: selectedHospital,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          viewModel.updateReferralHospitalId(result.id);
          viewModel.updateReferralHospitalFinal(result.name);
        }
      },
    );
  }

  Widget _buildStaffDropdown(
    TreatmentViewModel viewModel,
    List<MedicalStaffData> staffList,
    int? selectedStaffId,
    String hint,
    Function(int?) onChanged,
  ) {
    final selectedStaff = selectedStaffId != null
        ? viewModel.getMedicalStaffById(selectedStaffId)
        : null;
    final text = selectedStaff != null ? selectedStaff.name : '';

    return _buildSelectionField(
      text: text,
      hint: hint,
      icon: Icons.person,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<MedicalStaffData>(
          context,
          title: hint,
          searchFunction: (query) async {
            if (query.isEmpty) return staffList;
            final lower = query.toLowerCase();
            return staffList
                .where(
                  (s) =>
                      s.name.toLowerCase().contains(lower) ||
                      (s.employeeId?.toLowerCase().contains(lower) ?? false),
                )
                .toList();
          },
          initialSelection: selectedStaff,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                child: Text(
                  item.role.isNotEmpty ? item.role[0] : '?',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                item.name,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${item.role} ${item.employeeId != null ? '(${item.employeeId})' : ''}',
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          onChanged(result.id);
        }
      },
    );
  }

  // 通用選擇欄位元件
  Widget _buildSelectionField({
    required String text,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text.isNotEmpty ? text : hint,
                style: TextStyle(
                  color: text.isNotEmpty
                      ? textDark
                      : textMuted.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_more, size: 20, color: textMuted),
          ],
        ),
      ),
    );
  }

  // --- UI 共用元件 ---

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.start,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
      autofocus: autofocus,
      style: const TextStyle(fontSize: 13, color: textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 13,
        ),
        filled: true,
        fillColor: bgField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? primaryColor.withValues(alpha: 0.05) : bgField,
          border: Border.all(
            color: value ? primaryColor.withValues(alpha: 0.2) : borderColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: options.map((opt) {
          bool isSel = current == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 生命徵象變更時觸發自動儲存
  void _onVitalSignChanged(TreatmentViewModel viewModel) {
    // 更新快取並觸發自動儲存（參考 incident_view.dart 模式）
    viewModel.updateVitalSignsCache(
      temperature: _parseDouble(_tempController.text),
      pulse: _parseInt(_pulseController.text),
      breath: _parseInt(_breathController.text),
      systolic: _parseInt(_systolicController.text),
      diastolic: _parseInt(_diastolicController.text),
      spo2: _parseInt(_spo2Controller.text),
    );
  }

  double? _parseDouble(String text) {
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  int? _parseInt(String text) {
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  // GCS 驗證：檢查數值是否在有效範圍內
  String? _validateGCS(String value, int max, String fieldName) {
    if (value.isEmpty) return null; // 空值不驗證
    final num = int.tryParse(value);
    if (num == null) return '$fieldName 必須為數字';
    if (num < 1 || num > max) {
      return '$fieldName 必須在 1-$max 之間';
    }
    return null; // 驗證通過
  }

  // GCS 自動計算並驗證
  void _updateGCSTotalAndValidate(TreatmentViewModel viewModel) {
    // 驗證各欄位
    final eError = _validateGCS(_gcsEController.text, 4, 'E');
    final vError = _validateGCS(_gcsVController.text, 5, 'V');
    final mError = _validateGCS(_gcsMController.text, 6, 'M');

    // 計算 Total（只有通過驗證的才計入）
    final e = (eError == null) ? (int.tryParse(_gcsEController.text) ?? 0) : 0;
    final v = (vError == null) ? (int.tryParse(_gcsVController.text) ?? 0) : 0;
    final m = (mError == null) ? (int.tryParse(_gcsMController.text) ?? 0) : 0;

    setState(() {
      _gcsTotal = (e > 0 && v > 0 && m > 0) ? (e + v + m) : null;
    });

    // 觸發自動儲存
    _onConsciousnessAndExamChanged(viewModel);
  }

  // 意識與理學檢查變更時觸發自動儲存
  void _onConsciousnessAndExamChanged(TreatmentViewModel viewModel) {
    // 計算 GCS Total
    final e = int.tryParse(_gcsEController.text) ?? 0;
    final v = int.tryParse(_gcsVController.text) ?? 0;
    final m = int.tryParse(_gcsMController.text) ?? 0;
    final gcsTotal = (e > 0 && v > 0 && m > 0) ? (e + v + m) : null;

    viewModel.updateConsciousnessAndExamCache(
      isAlert: _isAlert,
      consciousnessLevelId: _isAlert ? 1 : 2,
      gcsE: _gcsEController.text,
      gcsV: _gcsVController.text,
      gcsM: _gcsMController.text,
      gcs: gcsTotal,
      leftPupilReactionId: _leftPupilReactionId,
      leftPupilSize: double.tryParse(_leftPupilSizeController.text),
      rightPupilReactionId: _rightPupilReactionId,
      rightPupilSize: double.tryParse(_rightPupilSizeController.text),
      headNeckExam: _headNeckController.text,
      chestExam: _chestController.text,
      abdomenExam: _abdomenController.text,
      extremitiesExam: _extremitiesController.text,
      otherPhysicalExam: _otherPhysicalExamController.text,
    );
  }

  // 理學檢查欄位
  Widget _buildLabeledFieldWithController(
    String label,
    String hint,
    TextEditingController controller,
    VoidCallback onChanged, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        _buildTextField(
          hint: hint,
          controller: controller,
          onChanged: (_) => onChanged(),
          maxLines: maxLines,
        ),
      ],
    );
  }

  // 簡化版瞳孔檢查（參考 treatment.dart 設計）
  Widget _buildPupilSection(
    String side,
    Function(String) onReact,
    String currentReact,
    TextEditingController sizeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(side),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildSegmentedControl(
                ['+', '-', '±'],
                currentReact,
                (v) => onReact(v),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildTextField(
                hint: 'mm',
                textAlign: TextAlign.center,
                controller: sizeController,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 使用外部 Controller 的生命徵象欄位（避免每次重建都建立新 Controller）
  Widget _buildVitalFieldWithController({
    required String label,
    required TextEditingController controller,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: textMuted,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.mic, size: 13, color: primaryColor),
          ],
        ),
        const SizedBox(height: 4),
        _buildTextField(
          hint: '',
          controller: controller,
          onChanged: (_) => onChanged?.call(),
        ),
      ],
    );
  }

  // 使用外部 Controllers 的血壓欄位
  Widget _buildBloodPressureWithControllers({
    required TextEditingController systolicController,
    required TextEditingController diastolicController,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '血壓 BP (mmHg)',
              style: TextStyle(
                color: textMuted,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.mic, size: 13, color: primaryColor),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // 收縮壓
            Expanded(
              child: _buildTextField(
                hint: '',
                controller: systolicController,
                onChanged: (_) => onChanged?.call(),
              ),
            ),
            // 斜線
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '/',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
            // 舒張壓
            Expanded(
              child: _buildTextField(
                hint: '',
                controller: diastolicController,
                onChanged: (_) => onChanged?.call(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthAssessmentList(TreatmentViewModel viewModel) {
    return Column(
      children: viewModel.healthAssessments.asMap().entries.map((entry) {
        final index = entry.key;
        final assessment = entry.value;

        // 確保 controller 存在
        if (!_healthAssessmentControllers.containsKey(index)) {
          _healthAssessmentControllers[index] = {
            'name': TextEditingController(text: assessment.name),
            'relation': TextEditingController(text: assessment.relation),
            'temp': TextEditingController(
              text: assessment.temperature.toString(),
            ),
          };
        }

        final controllers = _healthAssessmentControllers[index]!;

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: '姓名',
                  controller: controllers['name'],
                  onChanged: (val) async {
                    setState(() {
                      controllers['name']?.text = val;
                    });
                    // 保存到資料庫
                    final temp =
                        double.tryParse(controllers['temp']?.text ?? '0') ??
                        0.0;
                    await viewModel.updateHealthAssessment(
                      assessmentFormId: assessment.assessmentFormId,
                      name: val,
                      relation: controllers['relation']?.text ?? '',
                      temperature: temp,
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(
                  hint: '關係',
                  controller: controllers['relation'],
                  onChanged: (val) async {
                    setState(() {
                      controllers['relation']?.text = val;
                    });
                    // 保存到資料庫
                    final temp =
                        double.tryParse(controllers['temp']?.text ?? '0') ??
                        0.0;
                    await viewModel.updateHealthAssessment(
                      assessmentFormId: assessment.assessmentFormId,
                      name: controllers['name']?.text ?? '',
                      relation: val,
                      temperature: temp,
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 60,
                child: _buildTextField(
                  hint: '體溫',
                  controller: controllers['temp'],
                  onChanged: (val) async {
                    setState(() {
                      controllers['temp']?.text = val;
                    });
                    // 保存到資料庫
                    final temp = double.tryParse(val) ?? 0.0;
                    await viewModel.updateHealthAssessment(
                      assessmentFormId: assessment.assessmentFormId,
                      name: controllers['name']?.text ?? '',
                      relation: controllers['relation']?.text ?? '',
                      temperature: temp,
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 18,
                ),
                onPressed: () async {
                  // 從資料庫中刪除
                  await viewModel.deleteHealthAssessment(
                    assessment.assessmentFormId,
                  );

                  // 清理 controller
                  _healthAssessmentControllers[index]?['name']?.dispose();
                  _healthAssessmentControllers[index]?['relation']?.dispose();
                  _healthAssessmentControllers[index]?['temp']?.dispose();
                  _healthAssessmentControllers.remove(index);
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSymptomGrid(
    TreatmentViewModel viewModel,
    ChiefComplaintData complaint,
  ) {
    final selectedTypeId = complaint.chiefComplaintTypeId;
    if (selectedTypeId == null) return const SizedBox();

    final details = viewModel.getChiefComplaintDetails(selectedTypeId);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: details.map((detail) {
        final s = detail.name;
        final isSelected = viewModel.selectedSymptomIds.contains(detail.id);
        return FilterChip(
          label: Text(s, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (sel) {
            // 使用 ViewModel 的多对多方法
            viewModel.toggleSymptom(detail.id);
          },
          backgroundColor: Colors.white,
          selectedColor: primaryColor.withValues(alpha: 0.1),
          checkmarkColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: borderColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIcdRow(
    String label,
    String hint,
    TextEditingController controller,
    TreatmentViewModel viewModel,
    Function(String) onCodeSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hint: hint,
                controller: controller,
                onChanged: (val) => onCodeSelected(val),
              ),
            ),
            const SizedBox(width: 8),
            _buildActionIconBtn(
              Icons.search,
              Colors.white,
              borderColor,
              onTap: () async {
                final result = await Icd10SearchSheet.show(
                  context,
                  title: label,
                  initialValue: controller.text,
                  viewModel: viewModel,
                );
                if (result != null) {
                  controller.text = result;
                  onCodeSelected(result);
                }
              },
            ),
            const SizedBox(width: 8),
            _buildActionIconBtn(
              Icons.language,
              const Color(0xFFEFF6FF),
              const Color(0xFFDBEAFE),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildActionIconBtn(
    IconData icon,
    Color bgColor,
    Color borderColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Center(child: Icon(icon, size: 18, color: primaryColor)),
      ),
    );
  }
}
