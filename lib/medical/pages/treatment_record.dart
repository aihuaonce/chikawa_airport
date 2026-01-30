import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../../data/models/medical/treatment_view.dart';
import '../../data/db/database.dart';
import '../widgets/icd10_search_sheet.dart';

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

  // 主訴相關
  final List<String> _selectedSymptoms = [];

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
  String _leftPupilReaction = '+';
  String _rightPupilReaction = '+';
  int? _gcsTotal; // GCS Total 自動計算，不儲存到 Controller

  // 病史
  String _pastHistoryStatus = '無';
  String _allergyStatus = '無';

  // 處置項目選擇
  final List<int> _selectedActionItemIds = [];

  // 協助人員
  final List<String> _assistStaffList = [];
  late TextEditingController _assistStaffController;

  // 健康評估表 controller（數據來自 ViewModel）
  final Map<int, Map<String, TextEditingController>>
  _healthAssessmentControllers = {};

  // 特別註記
  final List<String> _selectedSpecialNotes = [];

  @override
  void initState() {
    super.initState();
    _otherSymptomController = TextEditingController();
    _supplementaryNotesController = TextEditingController();
    _pastHistoryDetailController = TextEditingController();
    _allergyDetailController = TextEditingController();
    _actionSummaryOtherController = TextEditingController();
    _assistStaffController = TextEditingController();

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
    _assistStaffController.dispose();

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
      // 載入狀態值（使用 ?? '無' 確保不會是 null）
      _pastHistoryStatus = history.pastHistoryStatus;
      _allergyStatus = history.allergyStatus;
    }

    final treatment = viewModel.treatment;
    if (treatment != null) {
      _actionSummaryOtherController.text = treatment.actionSummaryOther ?? '';

      // 解析處理摘要 (Names -> IDs)
      if (treatment.actionSummary != null &&
          treatment.actionSummary!.isNotEmpty) {
        final names = treatment.actionSummary!.split(',');
        _selectedActionItemIds.clear();
        for (final name in names) {
          try {
            final item = viewModel.actionItems.firstWhere(
              (item) => item.name == name.trim(),
            );
            _selectedActionItemIds.add(item.id);
          } catch (e) {
            // 忽略找不到的項目
          }
        }
      }

      // 載入 ICD-10 資料
      _tentativeController.text = treatment.tentative ?? '';
      _secondaryDiagnosis1Controller.text = treatment.secondaryDiagnosis1 ?? '';
      _secondaryDiagnosis2Controller.text = treatment.secondaryDiagnosis2 ?? '';
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
      _leftPupilReaction = latestConsciousnessExam.leftPupilReaction ?? '+';
      _rightPupilReaction = latestConsciousnessExam.rightPupilReaction ?? '+';

      // 理學檢查
      _headNeckController.text = latestConsciousnessExam.headNeckExam ?? '';
      _chestController.text = latestConsciousnessExam.chestExam ?? '';
      _abdomenController.text = latestConsciousnessExam.abdomenExam ?? '';
      _extremitiesController.text =
          latestConsciousnessExam.extremitiesExam ?? '';
      _otherPhysicalExamController.text =
          latestConsciousnessExam.otherPhysicalExam ?? '';

      // 意識狀態
      _isAlert = latestConsciousnessExam.consciousnessLevel == 'alert';

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
                  viewModel.updateChiefComplaint(
                    chiefComplaintTypeId: id,
                    selectedSymptoms: '',
                  );
                  _selectedSymptoms.clear();
                },
              ),
            ],
          ],
        ),
        if (complaint?.chiefComplaintTypeId != null) ...[
          const SizedBox(height: 12),
          _buildSymptomGrid(viewModel, complaint!),
          if (_selectedSymptoms.contains('其它')) ...[
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
    // 取得最新的醫療評估

    // 注意：使用已初始化的 Controllers，而非每次重建都建立新的
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 12,
      childAspectRatio: 3.5,
      children: [
        // 體溫 - 使用 _tempController
        _buildVitalFieldWithController(
          label: '體溫 Temp (°C)',
          controller: _tempController,
          onChanged: () => _onVitalSignChanged(viewModel),
        ),
        // 脈搏 - 使用 _pulseController
        _buildVitalFieldWithController(
          label: '脈搏 Pulse (bpm)',
          controller: _pulseController,
          onChanged: () => _onVitalSignChanged(viewModel),
        ),
        // 呼吸 - 使用 _breathController
        _buildVitalFieldWithController(
          label: '呼吸 RR (/min)',
          controller: _breathController,
          onChanged: () => _onVitalSignChanged(viewModel),
        ),
        // 血壓 - 使用 _systolicController 和 _diastolicController
        _buildBloodPressureWithControllers(
          systolicController: _systolicController,
          diastolicController: _diastolicController,
          onChanged: () => _onVitalSignChanged(viewModel),
        ),
        // 血氧 - 使用 _spo2Controller
        _buildVitalFieldWithController(
          label: '血氧 SpO2 (%)',
          controller: _spo2Controller,
          onChanged: () => _onVitalSignChanged(viewModel),
        ),
        // 空位（保持6格佈局）
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildConsciousnessSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 意識清晰 Checkbox（變更時自動儲存，勾選時清除 GCS 資料）
        _buildCheckboxTile(
          label: '意識清晰 Alert & Oriented',
          value: _isAlert,
          onChanged: (v) {
            setState(() => _isAlert = v!);
            if (_isAlert) {
              // 勾選意識清晰時，清除 GCS 資料
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
          // GCS 輸入框（簡化版，保留自動計算）
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
              // Total（只讀，自動計算）
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
          // 瞳孔檢查（簡化版）
          Row(
            children: [
              Expanded(
                child: _buildPupilSection(
                  '左瞳孔 Left Pupil',
                  (v) {
                    setState(() => _leftPupilReaction = v);
                    _onConsciousnessAndExamChanged(viewModel);
                  },
                  _leftPupilReaction,
                  _leftPupilSizeController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPupilSection(
                  '右瞳孔 Right Pupil',
                  (v) {
                    setState(() => _rightPupilReaction = v);
                    _onConsciousnessAndExamChanged(viewModel);
                  },
                  _rightPupilReaction,
                  _rightPupilSizeController,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        // 理學檢查（2x2 Grid，簡化版）
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: 4,
          children: [
            _buildLabeledFieldWithController(
              '頭頸部 Head/Neck',
              '',
              _headNeckController,
              () => _onConsciousnessAndExamChanged(viewModel),
            ),
            _buildLabeledFieldWithController(
              '胸部 Chest',
              '',
              _chestController,
              () => _onConsciousnessAndExamChanged(viewModel),
            ),
            _buildLabeledFieldWithController(
              '腹部 Abdomen',
              '',
              _abdomenController,
              () => _onConsciousnessAndExamChanged(viewModel),
            ),
            _buildLabeledFieldWithController(
              '四肢 Extremities',
              '',
              _extremitiesController,
              () => _onConsciousnessAndExamChanged(viewModel),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 其它理學檢查
        _buildLabeledFieldWithController(
          '其它理學檢查 Other Observations...',
          '',
          _otherPhysicalExamController,
          () => _onConsciousnessAndExamChanged(viewModel),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildHistorySection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('過去病史 Past Medical History'),
        const SizedBox(height: 4),
        _buildSegmentedControl(['無', '不詳', '有'], _pastHistoryStatus, (v) {
          setState(() {
            _pastHistoryStatus = v;
            // 如果切換到「無」或「不詳」，清除詳細資料
            if (v == '無' || v == '不詳') {
              _pastHistoryDetailController.clear();
            }
          });
          // 同步到 ViewModel 並觸發 auto-save
          viewModel.updatePastHistoryStatus(v);
        }),
        if (_pastHistoryStatus == '有') ...[
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
        _buildSegmentedControl(['無', '不詳', '有'], _allergyStatus, (v) {
          setState(() {
            _allergyStatus = v;
            // 如果切換到「無」或「不詳」，清除詳細資料
            if (v == '無' || v == '不詳') {
              _allergyDetailController.clear();
            }
          });
          // 同步到 ViewModel 並觸發 auto-save
          viewModel.updateAllergyStatus(v);
        }),
        if (_allergyStatus == '有') ...[
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
                    _buildTextField(hint: '請註明醫院名稱'),
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
        if (_selectedActionItemIds.contains(
          viewModel.actionItems
              .firstWhere(
                (item) => item.name == '其他',
                orElse: () => viewModel.actionItems.first,
              )
              .id,
        )) ...[
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
        bool isSelected = _selectedActionItemIds.contains(item.id);
        return FilterChip(
          label: Text(item.name, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (sel) {
            setState(() {
              if (sel) {
                _selectedActionItemIds.add(item.id);
              } else {
                _selectedActionItemIds.remove(item.id);
              }
            });
            // 更新到 ViewModel - 將選中的 ID 列表轉為逗號分隔的字串
            final actionSummary = _selectedActionItemIds
                .map((id) {
                  final item = viewModel.actionItems.firstWhere(
                    (a) => a.id == id,
                    orElse: () => viewModel.actionItems.first,
                  );
                  return item.name;
                })
                .join(',');
            viewModel.updateActionSummary(actionSummary);
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

    // 取得已指派的主要醫師和護理師
    final primaryDoctor = viewModel.staffAssignments
        .where((a) => a.staffRole == 'Doctor' && a.isPrimary)
        .firstOrNull;
    final primaryNurse = viewModel.staffAssignments
        .where((a) => a.staffRole == 'Nurse' && a.isPrimary)
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('院長/負責人 Director Name'),
        const SizedBox(height: 4),
        _buildTextField(hint: ''),
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
                          staffRole: 'Doctor',
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
                                    staffRole: 'Nurse',
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
                            _buildSignaturePad('點擊開啟簽名板'),
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
                  _buildTextField(hint: '姓名 / 員工編號'),
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
                  _buildSignaturePad('點擊開啟簽名板'),
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
              child: _buildTextField(
                hint: '輸入人員姓名...',
                controller: _assistStaffController,
              ),
            ),
            const SizedBox(width: 8),
            _buildActionIconBtn(
              Icons.person_add_alt_1,
              primaryColor.withValues(alpha: 0.1),
              primaryColor.withValues(alpha: 0.2),
              onTap: () {
                if (_assistStaffController.text.isNotEmpty) {
                  setState(() {
                    _assistStaffList.add(_assistStaffController.text);
                    _assistStaffController.clear();
                  });
                }
              },
            ),
          ],
        ),
        if (_assistStaffList.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _assistStaffList
                .map(
                  (staff) => Chip(
                    label: Text(staff, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () =>
                        setState(() => _assistStaffList.remove(staff)),
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

  Widget _buildSignaturePad(String placeholder) {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgField,
        border: Border.all(color: borderColor, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          placeholder,
          style: TextStyle(
            color: textMuted.withValues(alpha: 0.5),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
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
            final bool isSelected = _selectedSpecialNotes.contains(note);
            return FilterChip(
              label: Text(note),
              selected: isSelected,
              onSelected: (sel) {
                setState(() {
                  if (sel) {
                    _selectedSpecialNotes.add(note);
                  } else {
                    _selectedSpecialNotes.remove(note);
                  }
                });
                // 更新到資料庫
                viewModel.updateSpecialNotes(
                  selectedNotes: _selectedSpecialNotes.join(','),
                );
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
        _buildTextField(hint: '請輸入其他需要補充的特殊狀況...', maxLines: 3),
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

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DiagnosisCategoryData>(
          value: selectedCategory,
          hint: Text(
            '請選取診斷分類',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: viewModel.diagnosisCategories
              .map(
                (cat) => DropdownMenuItem<DiagnosisCategoryData>(
                  value: cat,
                  child: Text(
                    cat.name,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) {
              viewModel.updateTentativeCategoryId(val.id);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTreatmentOnSiteDropdown(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final selectedTreatment = treatment?.treatmentOnSiteId != null
        ? viewModel.getTreatmentOnSiteById(treatment!.treatmentOnSiteId)
        : null;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TreatmentOnSiteData>(
          value: selectedTreatment,
          hint: Text(
            '請選取現場處置',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: viewModel.treatmentOnSites
              .map(
                (treatment) => DropdownMenuItem<TreatmentOnSiteData>(
                  value: treatment,
                  child: Text(
                    treatment.name,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) {
              viewModel.updateTreatmentOnSiteId(val.id);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTreatmentResultDropdown(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final selectedResult = treatment?.resultId != null
        ? viewModel.getTreatmentResultById(treatment!.resultId)
        : null;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TreatmentResultData>(
          value: selectedResult,
          hint: Text(
            '請選取處置結果',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: viewModel.treatmentResults
              .map(
                (result) => DropdownMenuItem<TreatmentResultData>(
                  value: result,
                  child: Text(
                    result.name,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) {
              viewModel.updateResultId(val.id);
            }
          },
        ),
      ),
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

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MedicalStaffData>(
          value: selectedStaff,
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: staffList
              .map(
                (staff) => DropdownMenuItem<MedicalStaffData>(
                  value: staff,
                  child: Text(
                    staff.name,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => onChanged(val?.id),
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
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
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
      consciousnessLevel: _isAlert ? 'alert' : 'altered',
      gcsE: _gcsEController.text,
      gcsV: _gcsVController.text,
      gcsM: _gcsMController.text,
      gcs: gcsTotal,
      leftPupilReaction: _leftPupilReaction,
      leftPupilSize: double.tryParse(_leftPupilSizeController.text),
      rightPupilReaction: _rightPupilReaction,
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
        return FilterChip(
          label: Text(s, style: const TextStyle(fontSize: 12)),
          selected: _selectedSymptoms.contains(s),
          onSelected: (sel) {
            setState(() {
              if (sel) {
                _selectedSymptoms.add(s);
              } else {
                _selectedSymptoms.remove(s);
              }
            });
            // 更新到資料庫
            viewModel.updateChiefComplaint(
              selectedSymptoms: _selectedSymptoms.join(','),
            );
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
