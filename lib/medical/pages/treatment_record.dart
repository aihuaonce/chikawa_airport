import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical/treatment_view.dart';
import '../../data/db/database.dart';

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
  late TextEditingController _directorNameController;
  late TextEditingController _emtNameController;
  late TextEditingController _otherHospitalController;
  late TextEditingController _assistStaffController;
  late TextEditingController _otherNotesController;

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

  // 意識檢查
  bool _isAlert = true;
  String _leftPupilReaction = '+';
  String _rightPupilReaction = '+';
  late TextEditingController _leftPupilSizeController;
  late TextEditingController _rightPupilSizeController;

  // 病史
  String _pastHistoryStatus = '無';
  String _allergyStatus = '無';

  // 處置項目選擇
  final List<String> _summaryOfAction = [];

  // 協助人員
  final List<String> _assistStaffList = [];

  // 特別註記
  final List<String> _selectedSpecialNotes = [];
  final List<String> _specialNoteOptions = [
    'OHCA醫護到達前有CPR',
    'OHCA醫護到達前有使用AED但無電擊',
    'OHCA醫護到達前有使用AED有電擊',
    '現場恢復脈搏',
    '使用自動心肺復甦機',
    '空跑',
  ];

  @override
  void initState() {
    super.initState();
    _otherSymptomController = TextEditingController();
    _supplementaryNotesController = TextEditingController();
    _pastHistoryDetailController = TextEditingController();
    _allergyDetailController = TextEditingController();
    _actionSummaryOtherController = TextEditingController();
    _directorNameController = TextEditingController();
    _emtNameController = TextEditingController();
    _otherHospitalController = TextEditingController();
    _assistStaffController = TextEditingController();
    _otherNotesController = TextEditingController();
    _leftPupilSizeController = TextEditingController();
    _rightPupilSizeController = TextEditingController();
  }

  @override
  void dispose() {
    _otherSymptomController.dispose();
    _supplementaryNotesController.dispose();
    _pastHistoryDetailController.dispose();
    _allergyDetailController.dispose();
    _actionSummaryOtherController.dispose();
    _directorNameController.dispose();
    _emtNameController.dispose();
    _otherHospitalController.dispose();
    _assistStaffController.dispose();
    _otherNotesController.dispose();
    _leftPupilSizeController.dispose();
    _rightPupilSizeController.dispose();
    super.dispose();
  }

  // 當 ViewModel 資料載入後,同步到 Controller
  void _updateControllers(TreatmentViewModel viewModel) {
    if (_isInitialized) return;

    final complaint = viewModel.chiefComplaint;
    if (complaint != null) {
      _otherSymptomController.text = complaint.otherSymptomDetail ?? '';
      _supplementaryNotesController.text = complaint.supplementaryNotes ?? '';
    }

    final history = viewModel.medicalHistory;
    if (history != null) {
      _pastHistoryDetailController.text = history.pastHistoryDetail ?? '';
      _allergyDetailController.text = history.allergyDetail ?? '';
    }

    final treatment = viewModel.treatment;
    if (treatment != null) {
      _actionSummaryOtherController.text = treatment.actionSummaryOther ?? '';
      _directorNameController.text = treatment.directorName ?? '';
    }

    _isInitialized = true;
  }

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

    return Column(
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
          onChanged: (v) => setState(() => _cdcPassed = v!),
        ),
        if (_cdcPassed) ...[
          const SizedBox(height: 16),
          _buildLabel('篩檢方式 Screening Method'),
          const SizedBox(height: 4),
          _buildSegmentedControl(
            ['喉頭採檢', '抽血檢驗', '其它'],
            _screeningMethod,
            (v) => setState(() => _screeningMethod = v),
          ),
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
                onPressed: () =>
                    _showAddHealthAssessmentDialog(context, viewModel),
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
    final selectedType = complaint?.chiefComplaintTypeId != null
        ? viewModel.getComplaintTypeById(complaint!.chiefComplaintTypeId)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('主訴類別 Type'),
        const SizedBox(height: 4),
        Row(
          children: viewModel.complaintTypes.map((type) {
            bool isSel = complaint?.chiefComplaintTypeId == type.id;
            IconData icon = type.code == 'TRAUMA'
                ? Icons.healing
                : Icons.medical_services;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildTypeButton(type.name, icon, isSel, () {
                  viewModel.updateChiefComplaint(chiefComplaintTypeId: type.id);
                  _selectedSymptoms.clear();
                }),
              ),
            );
          }).toList(),
        ),
        if (selectedType != null) ...[
          const SizedBox(height: 12),
          _buildSymptomGrid(viewModel, selectedType),
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
            const SizedBox(width: 12),
            _buildSmallCheckbox(
              'ECG心電圖',
              _photoEcg,
              (v) => setState(() => _photoEcg = v!),
            ),
            const SizedBox(width: 12),
            _buildSmallCheckbox(
              '其它 Other',
              _photoOther,
              (v) => setState(() => _photoOther = v!),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: bgField,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, color: textMuted, size: 32),
                const SizedBox(height: 6),
                Text(
                  '點擊或拖曳上傳影像',
                  style: TextStyle(color: textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignsSection(TreatmentViewModel viewModel) {
    final latestAssessment = viewModel.medicalAssessments.isNotEmpty
        ? viewModel.medicalAssessments.last
        : null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildVitalField(
                '體溫 Temp(°C)',
                '36.5',
                latestAssessment?.temperature?.toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVitalField(
                '脈搏 Pulse(/min)',
                '80',
                latestAssessment?.pulse?.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildVitalField(
                '呼吸 Breath(/min)',
                '18',
                latestAssessment?.breath?.toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVitalField(
                '血氧 SpO2(%)',
                '98',
                latestAssessment?.spo2?.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildVitalField(
                '收縮壓 Sys(mmHg)',
                '120',
                latestAssessment?.systolic?.toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVitalField(
                '舒張壓 Dia(mmHg)',
                '80',
                latestAssessment?.diastolic?.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildVitalField(
          '疼痛指數 Pain(0-10)',
          '0',
          latestAssessment?.painScore?.toString(),
        ),
      ],
    );
  }

  Widget _buildConsciousnessSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('意識狀態 Consciousness'),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildSmallCheckbox(
              'Alert',
              _isAlert,
              (v) => setState(() => _isAlert = v!),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPupilSection(
                'Left Pupil',
                (v) => _leftPupilReaction = v,
                _leftPupilReaction,
                _leftPupilSizeController,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPupilSection(
                'Right Pupil',
                (v) => _rightPupilReaction = v,
                _rightPupilReaction,
                _rightPupilSizeController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistorySection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('過去病史 Past History'),
        const SizedBox(height: 4),
        _buildSegmentedControl(
          ['無', '有', '不詳'],
          _pastHistoryStatus,
          (v) => setState(() => _pastHistoryStatus = v),
        ),
        if (_pastHistoryStatus == '有') ...[
          const SizedBox(height: 8),
          _buildTextField(
            hint: '請輸入病史詳情',
            controller: _pastHistoryDetailController,
            onChanged: (val) =>
                viewModel.updateMedicalHistory(pastHistoryDetail: val),
          ),
        ],
        const SizedBox(height: 16),
        _buildLabel('過敏史 Allergy'),
        const SizedBox(height: 4),
        _buildSegmentedControl(
          ['無', '有', '不詳'],
          _allergyStatus,
          (v) => setState(() => _allergyStatus = v),
        ),
        if (_allergyStatus == '有') ...[
          const SizedBox(height: 8),
          _buildTextField(
            hint: '請輸入過敏物質',
            controller: _allergyDetailController,
            onChanged: (val) =>
                viewModel.updateMedicalHistory(allergyDetail: val),
          ),
        ],
      ],
    );
  }

  Widget _buildDiagnosisSection(TreatmentViewModel viewModel) {
    final treatment = viewModel.treatment;
    final selectedCategory = treatment?.tentativeCategoryId != null
        ? viewModel.getDiagnosisCategoryById(treatment!.tentativeCategoryId)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('診斷分類 Diagnosis Category'),
        const SizedBox(height: 4),
        _buildDropdownField(
          hint: '請選取診斷分類',
          value: selectedCategory?.name,
          items: viewModel.diagnosisCategories.map((cat) => cat.name).toList(),
          onChanged: (val) {
            final category = viewModel.diagnosisCategories.firstWhere(
              (cat) => cat.name == val,
            );
            viewModel.updateTentativeCategoryId(category.id);
          },
        ),
      ],
    );
  }

  Widget _buildOutcomeTreatmentSection(TreatmentViewModel viewModel) {
    final treatment = viewModel.treatment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('檢傷分級 Triage Level'),
        const SizedBox(height: 8),
        _buildTriageSelector(viewModel, treatment),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('現場處置 Scene Treatment'),
                  const SizedBox(height: 4),
                  _buildDropdownField(
                    hint: '請選取現場主要處置',
                    value: treatment?.treatmentOnSiteId != null
                        ? viewModel
                              .getTreatmentOnSiteById(
                                treatment!.treatmentOnSiteId,
                              )
                              ?.name
                        : null,
                    items: viewModel.treatmentOnSites
                        .map((t) => t.name)
                        .toList(),
                    onChanged: (val) {
                      final onSite = viewModel.treatmentOnSites.firstWhere(
                        (t) => t.name == val,
                      );
                      viewModel.updateTreatmentOnSiteId(onSite.id);
                    },
                  ),
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
                  _buildDropdownField(
                    hint: '請選取處理結果',
                    value: treatment?.resultId != null
                        ? viewModel
                              .getTreatmentResultById(treatment!.resultId)
                              ?.name
                        : null,
                    items: viewModel.treatmentResults
                        .map((r) => r.name)
                        .toList(),
                    onChanged: (val) {
                      final result = viewModel.treatmentResults.firstWhere(
                        (r) => r.name == val,
                      );
                      viewModel.updateResultId(result.id);
                    },
                  ),
                  if (treatment?.resultId != null &&
                      viewModel
                              .getTreatmentResultById(treatment!.resultId)
                              ?.name ==
                          '轉其它醫院') ...[
                    const SizedBox(height: 8),
                    _buildTextField(
                      hint: '請註明醫院名稱',
                      controller: _otherHospitalController,
                      onChanged: (val) =>
                          viewModel.updateReferralHospitalFinal(val),
                    ),
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
        if (_summaryOfAction.contains('其它')) ...[
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

  Widget _buildStaffSignsSection(TreatmentViewModel viewModel) {
    final doctors = viewModel.medicalStaffList
        .where((staff) => staff.role == 'Doctor')
        .toList();
    final nurses = viewModel.medicalStaffList
        .where((staff) => staff.role == 'Nurse')
        .toList();

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
        _buildTextField(
          hint: '',
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
                  _buildDropdownField(
                    hint: '請選擇主責醫師',
                    value: primaryDoctor?.staffId != null
                        ? viewModel
                              .getMedicalStaffById(primaryDoctor!.staffId)
                              ?.name
                        : null,
                    items: doctors.map((d) => d.name).toList(),
                    onChanged: (val) {
                      final doctor = doctors.firstWhere((d) => d.name == val);
                      viewModel.addStaffAssignment(
                        staffRole: 'Doctor',
                        staffId: doctor.id,
                        isPrimary: true,
                      );
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
                            _buildDropdownField(
                              hint: '請選擇主責護理師',
                              value: primaryNurse?.staffId != null
                                  ? viewModel
                                        .getMedicalStaffById(
                                          primaryNurse!.staffId,
                                        )
                                        ?.name
                                  : null,
                              items: nurses.map((n) => n.name).toList(),
                              onChanged: (val) {
                                final nurse = nurses.firstWhere(
                                  (n) => n.name == val,
                                );
                                viewModel.addStaffAssignment(
                                  staffRole: 'Nurse',
                                  staffId: nurse.id,
                                  isPrimary: true,
                                );
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
                    text: const TextSpan(
                      text: 'EMT 姓名 EMT Name ',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
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
                  _buildTextField(
                    hint: '姓名 / 員工編號',
                    controller: _emtNameController,
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
            IconButton(
              onPressed: () {
                if (_assistStaffController.text.isNotEmpty) {
                  setState(() {
                    _assistStaffList.add(_assistStaffController.text);
                    _assistStaffController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add_circle, color: primaryColor),
            ),
          ],
        ),
        if (_assistStaffList.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _assistStaffList
                .map(
                  (name) => Chip(
                    label: Text(name, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () =>
                        setState(() => _assistStaffList.remove(name)),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSpecialNotesSection(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _specialNoteOptions.map((note) {
            final bool isSelected = _selectedSpecialNotes.contains(note);
            return FilterChip(
              label: Text(note),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSpecialNotes.add(note);
                  } else {
                    _selectedSpecialNotes.remove(note);
                  }
                });
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
        _buildTextField(
          hint: '請輸入其他需要補充的特殊狀況...',
          maxLines: 3,
          controller: _otherNotesController,
        ),
      ],
    );
  }

  // --- 特殊 UI 組件 ---

  Widget _buildTriageSelector(
    TreatmentViewModel viewModel,
    TreatmentData? treatment,
  ) {
    final List<Map<String, dynamic>> levels = [
      {'val': 1, 'color': Colors.red, 'num': '1', 'desc': '復甦急救'},
      {'val': 2, 'color': Colors.orange, 'num': '2', 'desc': '危急'},
      {'val': 3, 'color': Colors.yellow.shade700, 'num': '3', 'desc': '緊急'},
      {'val': 4, 'color': Colors.green, 'num': '4', 'desc': '次緊急'},
      {'val': 5, 'color': Colors.blue, 'num': '5', 'desc': '非緊急'},
    ];

    return Row(
      children: levels.map((l) {
        final triageLevel = viewModel.triageLevels
            .where((t) => t.level == l['val'])
            .firstOrNull;
        bool isSel = treatment?.triageId == triageLevel?.id;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (triageLevel != null) {
                viewModel.updateTriageId(triageLevel.id);
              }
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSel ? l['color'] : l['color'].withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSel ? l['color'] : l['color'].withValues(alpha: 0.2),
                  width: isSel ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l['num'],
                    style: TextStyle(
                      color: isSel ? Colors.white : l['color'],
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    l['desc'],
                    style: TextStyle(
                      color: isSel ? Colors.white : l['color'],
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
        final bool isSelected = _summaryOfAction.contains(item.name);
        return FilterChip(
          label: Text(item.name, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _summaryOfAction.add(item.name);
              } else {
                _summaryOfAction.remove(item.name);
              }
            });
            viewModel.updateActionSummary(_summaryOfAction.join(','));
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

  Widget _buildTypeButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? primaryColor : textMuted, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? textDark : textMuted,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomGrid(
    TreatmentViewModel viewModel,
    ChiefComplaintTypeData selectedType,
  ) {
    final options = selectedType.code == 'TRAUMA'
        ? ['鈍挫傷', '扭傷', '撕裂傷', '擦傷', '肢體變形', '其它']
        : ['頭頸部', '胸部', '腹部', '四肢', '其它'];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: options
          .map(
            (s) => FilterChip(
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
                viewModel.updateChiefComplaint(
                  selectedSymptoms: _selectedSymptoms.join(','),
                );
              },
              selectedColor: primaryColor.withValues(alpha: 0.1),
              checkmarkColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: borderColor),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHealthAssessmentList(TreatmentViewModel viewModel) {
    return Column(
      children: viewModel.healthAssessments
          .map(
            (assessment) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      assessment.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      assessment.relation,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${assessment.temperature}°C',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    onPressed: () => _showDeleteHealthAssessmentDialog(
                      context,
                      viewModel,
                      assessment,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // --- UI 共用元件 ---

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildSignaturePad(String placeholder) {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgField,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: 開啟簽名板
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  placeholder,
                  style: TextStyle(
                    color: textMuted.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                ),
                const Icon(Icons.edit, size: 16, color: textMuted),
              ],
            ),
          ),
        ),
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
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
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
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgField,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 18, color: textMuted),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 13, color: textDark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSmallCheckbox(
    String label,
    bool val,
    Function(bool?) onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!val),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: Checkbox(
              value: val,
              onChanged: onChanged,
              activeColor: primaryColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: textMuted)),
        ],
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

  Widget _buildVitalField(String label, String hint, String? value) {
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
          hint: hint,
          controller: TextEditingController(text: value ?? ''),
        ),
      ],
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

  Widget _buildPupilSection(
    String side,
    Function(String) onReact,
    String currentReact,
    TextEditingController controller,
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
                (v) => setState(() => onReact(v)),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildTextField(
                hint: 'mm',
                textAlign: TextAlign.center,
                controller: controller,
              ),
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

  // --- 對話框方法 ---

  Future<void> _showAddHealthAssessmentDialog(
    BuildContext context,
    TreatmentViewModel viewModel,
  ) async {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final temperatureController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新增健康評估表'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: relationController,
              decoration: const InputDecoration(
                labelText: '關係',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: temperatureController,
              decoration: const InputDecoration(
                labelText: '體溫 (°C)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final relation = relationController.text.trim();
              final temperatureText = temperatureController.text.trim();

              if (name.isEmpty || relation.isEmpty || temperatureText.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('請填寫所有欄位')));
                return;
              }

              final temperature = double.tryParse(temperatureText);
              if (temperature == null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('體溫格式不正確')));
                return;
              }

              viewModel.addHealthAssessment(
                name: name,
                relation: relation,
                temperature: temperature,
              );

              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已新增健康評估表')));
            },
            child: const Text('新增'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteHealthAssessmentDialog(
    BuildContext context,
    TreatmentViewModel viewModel,
    HealthAssessmentFormData assessment,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除健康評估表'),
        content: Text('確定要刪除 ${assessment.name} 的健康評估表嗎?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              viewModel.deleteHealthAssessment(assessment.medicalId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已刪除健康評估表')));
            },
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }
}
