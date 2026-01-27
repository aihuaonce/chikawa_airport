import 'package:flutter/material.dart';

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

  bool _cdcPassed = false;
  String _screeningMethod = '';
  final List<Map<String, String>> _healthAssessments = [];

  String? _complaintType; // Trauma, NonTrauma
  final List<String> _selectedSymptoms = [];

  bool _photoTrauma = false;
  bool _photoEcg = false;
  bool _photoOther = false;

  bool _isAlert = true;
  String _leftPupilReaction = '+';
  String _rightPupilReaction = '+';

  String _pastHistoryStatus = '無';
  String _allergyStatus = '無';

  String? _selectedDiagCat;
  final List<String> _diagCategories = [
    'Mild Neurologic(headache、dizziness、vertigo)',
    'Severe Neurologic(syncope、seizure、CVA)',
    'Gl non-OP (AGE Epigas mild bleeding)',
    'Gl surgical (app cholecystitis PPU)',
    'Mild Trauma(含head injury、non-surgical intervention)',
    'Severe Trauma (surgical intervention)',
    'Mild CV (Palpitation Chest pain H/T hypo)',
    'Severe CV (AMl Arrythmia Shock Others)',
    'RESP(Asthma、CoPD)',
    'Fever (cause undetermined)',
    'Musculoskeletal',
    'DM (hypoglycemia or hyperglycemia)',
    'GU (APN Stone or others)',
    'OHCA',
    'Derma',
    'GYN',
    'OPH/ENT',
    'Psychiatric (nervous、anxious、Alcohols/drug)',
    'Others',
  ];

  int? _triageLevel; // 1-5
  String? _selectedSiteTreatment;
  String? _selectedOutcome;
  final List<String> _summaryOfAction = [];

  String? _selectedPhysician;
  String? _selectedNurse;
  final List<String> _assistStaffList = [];
  final TextEditingController _assistStaffController = TextEditingController();

  final List<String> _physicians = ['醫師 A', '醫師 B', '醫師 C', '醫師 D'];
  final List<String> _nurses = ['護理師 A', '護理師 B', '護理師 C', '護理師 D'];

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
  void dispose() {
    _assistStaffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCard(
                title: '篩檢與評估 CDC Screening',
                icon: Icons.assignment_ind_outlined,
                child: _buildCdcSection(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCard(
                title: '主訴類別 Chief Complaint',
                icon: Icons.medical_information_outlined,
                child: _buildComplaintSection(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildCard(
          title: '影像記錄 Photo Records',
          icon: Icons.photo_camera,
          child: _buildPhotoSection(),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCard(
                title: '生命徵象 Vital Signs',
                icon: Icons.monitor_heart,
                child: _buildVitalSignsSection(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCard(
                title: '意識與理學檢查 Consciousness & Exam',
                icon: Icons.psychology,
                child: _buildConsciousnessSection(),
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
                child: _buildHistorySection(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildCard(
                title: '診斷與代碼 Diagnosis & ICD-10',
                icon: Icons.medical_information,
                child: _buildDiagnosisSection(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildCard(
          title: '檢傷與處置 Outcome & Treatment',
          icon: Icons.emergency_outlined,
          child: _buildOutcomeTreatmentSection(),
        ),
        const SizedBox(height: 20),
        _buildCard(
          title: '醫護人員與簽章 Staff & Signs',
          icon: Icons.app_registration_rounded,
          child: _buildStaffSignsSection(),
        ),
        const SizedBox(height: 20),
        _buildCard(
          title: '特別註記 Special Notes',
          icon: Icons.note_alt_outlined,
          child: _buildSpecialNotesSection(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- 各區塊實作 ---

  Widget _buildCdcSection() {
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
                onPressed: () => setState(
                  () => _healthAssessments.add({
                    'name': '',
                    'relation': '',
                    'temp': '',
                  }),
                ),
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
          _buildHealthAssessmentList(),
        ],
      ],
    );
  }

  Widget _buildComplaintSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('主訴類別 Type'),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildTypeButton('外傷 Trauma', Icons.healing, 'Trauma'),
            const SizedBox(width: 8),
            _buildTypeButton(
              '非外傷 Non-trauma',
              Icons.medical_services,
              'NonTrauma',
            ),
          ],
        ),
        if (_complaintType != null) ...[
          const SizedBox(height: 12),
          _buildSymptomGrid(),
          if (_selectedSymptoms.contains('其它')) ...[
            const SizedBox(height: 8),
            _buildTextField(hint: '請註明其它主訴'),
          ],
        ],
        const SizedBox(height: 16),
        _buildLabel('補充說明 Supplementary Notes'),
        const SizedBox(height: 4),
        _buildTextField(hint: '患者詳細情況描述...', maxLines: 2),
      ],
    );
  }

  Widget _buildPhotoSection() {
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

        if (_photoTrauma) _buildPhotoGrid('外傷影像 Trauma Photos'),
        if (_photoEcg) _buildPhotoGrid('心電圖紀錄 ECG Records'),
        if (_photoOther) ...[
          _buildPhotoGrid('其它影像 Other Photos'),
          const SizedBox(height: 8),
          _buildTextField(hint: '請註明影像內容...'),
        ],
      ],
    );
  }

  Widget _buildPhotoGrid(String label) {
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
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: List.generate(4, (index) => _buildPhotoSlot()),
        ),
      ],
    );
  }

  Widget _buildPhotoSlot() {
    return Container(
      decoration: BoxDecoration(
        color: bgField,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, style: BorderStyle.solid),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
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

  Widget _buildSmallCheckbox(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
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

  Widget _buildVitalSignsSection() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 12,
      childAspectRatio: 4,
      children: [
        _buildVitalField('體溫 Temp (°C)', ''),
        _buildVitalField('脈搏 Pulse (bpm)', ''),
        _buildVitalField('呼吸 RR (/min)', ''),
        _buildVitalField('血壓 BP (mmHg)', ''),
        _buildVitalField('血氧 SpO2 (%)', ''),
      ],
    );
  }

  Widget _buildConsciousnessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxTile(
          label: '意識清晰 Alert & Oriented',
          value: _isAlert,
          onChanged: (v) => setState(() => _isAlert = v!),
        ),
        if (!_isAlert) ...[
          const SizedBox(height: 12),
          _buildLabel('GCS 指數評估'),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildTextField(hint: 'E', textAlign: TextAlign.center),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(hint: 'V', textAlign: TextAlign.center),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(hint: 'M', textAlign: TextAlign.center),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(
                  hint: 'Total',
                  textAlign: TextAlign.center,
                  fillColor: primaryColor.withValues(alpha: 0.05),
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
                  (v) => _leftPupilReaction = v,
                  _leftPupilReaction,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPupilSection(
                  '右瞳孔 Right Pupil',
                  (v) => _rightPupilReaction = v,
                  _rightPupilReaction,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: 4,
          children: [
            _buildLabeledField('頭頸部 Head/Neck', ''),
            _buildLabeledField('胸部 Chest', ''),
            _buildLabeledField('腹部 Abdomen', ''),
            _buildLabeledField('四肢 Extremities', ''),
          ],
        ),
        const SizedBox(height: 10),
        _buildLabeledField('其它理學檢查 Other Observations...', ''),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('過去病史 Past Medical History'),
        const SizedBox(height: 4),
        _buildSegmentedControl(
          ['無', '不詳', '有'],
          _pastHistoryStatus,
          (v) => setState(() => _pastHistoryStatus = v),
        ),
        if (_pastHistoryStatus == '有') ...[
          const SizedBox(height: 8),
          _buildTextField(hint: '列出慢性病或手術史...', maxLines: 2),
        ],

        const SizedBox(height: 16),

        _buildLabel('過敏史 Allergy History'),
        const SizedBox(height: 4),
        _buildSegmentedControl(
          ['無', '不詳', '有'],
          _allergyStatus,
          (v) => setState(() => _allergyStatus = v),
        ),
        if (_allergyStatus == '有') ...[
          const SizedBox(height: 8),
          _buildTextField(hint: '註明藥物或食物過敏狀況...'),
        ],
      ],
    );
  }

  Widget _buildDiagnosisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('診斷類別 Category'),
        const SizedBox(height: 4),
        _buildDropdownField(
          hint: '請選取類別',
          value: _selectedDiagCat,
          items: _diagCategories,
          onChanged: (v) => setState(() => _selectedDiagCat = v),
        ),
        const SizedBox(height: 16),
        _buildIcdRow('初步診斷 Preliminary (ICD-10)', '例如: I10'),
        const SizedBox(height: 12),
        _buildIcdRow('副診斷 1 Secondary ICD-10 #1', '代碼'),
        const SizedBox(height: 12),
        _buildIcdRow('副診斷 2 Secondary ICD-10 #2', '代碼'),
      ],
    );
  }

  Widget _buildOutcomeTreatmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('檢傷分類 Triage Level'),
        const SizedBox(height: 8),
        _buildTriageSelector(),

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
                  _buildDropdownField(
                    hint: '請選取現場主要處置',
                    value: _selectedSiteTreatment,
                    items: const ['諮詢衛教', '內科處置', '外科處置', '拒絕處置', '疑似傳染病診療'],
                    onChanged: (v) =>
                        setState(() => _selectedSiteTreatment = v),
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
                    value: _selectedOutcome,
                    items: const [
                      '繼續搭機飛行',
                      '休息觀察與自行回家',
                      '轉聯新國際醫院',
                      '轉林口長庚醫院',
                      '轉其它醫院',
                      '建議轉診門診追蹤',
                      '死亡',
                      '拒絕轉診',
                    ],
                    onChanged: (v) => setState(() => _selectedOutcome = v),
                  ),
                  if (_selectedOutcome == '轉其它醫院') ...[
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
        _buildActionSummaryGrid(),
        if (_summaryOfAction.contains('其它')) ...[
          const SizedBox(height: 12),
          _buildTextField(hint: '請詳述其它處理項目...', maxLines: 2),
        ],
      ],
    );
  }

  Widget _buildTriageSelector() {
    final List<Map<String, dynamic>> levels = [
      {'val': 1, 'color': Colors.red, 'num': '1', 'desc': '復甦急救'},
      {'val': 2, 'color': Colors.orange, 'num': '2', 'desc': '危急'},
      {'val': 3, 'color': Colors.yellow.shade700, 'num': '3', 'desc': '緊急'},
      {'val': 4, 'color': Colors.green, 'num': '4', 'desc': '次緊急'},
      {'val': 5, 'color': Colors.blue, 'num': '5', 'desc': '非緊急'},
    ];

    return Row(
      children: levels.map((l) {
        bool isSel = _triageLevel == l['val'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _triageLevel = l['val']),
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

  Widget _buildActionSummaryGrid() {
    final List<String> actions = [
      '冰敷',
      'EKG心電圖',
      '血糖',
      '傷口處置',
      '簽四聯單',
      '建議轉診',
      '插管',
      'CPR',
      '其它',
      '氧氣使用',
      '診斷書',
      '抽痰',
      '藥物使用',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((action) {
        final bool isSelected = _summaryOfAction.contains(action);
        return FilterChip(
          label: Text(action, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selected
                  ? _summaryOfAction.add(action)
                  : _summaryOfAction.remove(action);
            });
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

  Widget _buildStaffSignsSection() {
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
                  _buildDropdownField(
                    hint: '請選擇主責醫師',
                    value: _selectedPhysician,
                    items: _physicians,
                    onChanged: (v) => setState(() => _selectedPhysician = v),
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
                              value: _selectedNurse,
                              items: _nurses,
                              onChanged: (v) =>
                                  setState(() => _selectedNurse = v),
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

  Widget _buildSpecialNotesSection() {
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
                  selected
                      ? _selectedSpecialNotes.add(note)
                      : _selectedSpecialNotes.remove(note);
                });
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

  // --- 輔助組件 ---

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

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
    Color? fillColor,
    TextEditingController? controller,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 40 : null,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.3),
            fontSize: 12,
          ),
          filled: true,
          fillColor: fillColor ?? Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: primaryColor, width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _buildIcdRow(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildTextField(hint: hint)),
            const SizedBox(width: 8),
            _buildActionIconBtn(Icons.search, Colors.white, borderColor),
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

  Widget _buildActionIconBtn(
    IconData icon,
    Color bg,
    Color border, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryColor, size: 18),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
          items: items
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s,
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

  Widget _buildLabeledField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        _buildTextField(hint: hint),
      ],
    );
  }

  Widget _buildVitalField(String label, String hint) {
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
        _buildTextField(hint: hint),
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
              child: _buildTextField(hint: 'mm', textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthAssessmentList() {
    return Column(
      children: _healthAssessments
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(child: _buildTextField(hint: '姓名')),
                  const SizedBox(width: 6),
                  Expanded(child: _buildTextField(hint: '關係')),
                  const SizedBox(width: 6),
                  SizedBox(width: 60, child: _buildTextField(hint: '體溫')),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _healthAssessments.removeAt(entry.key)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSymptomGrid() {
    final options = _complaintType == 'Trauma'
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
              onSelected: (sel) => setState(
                () => sel
                    ? _selectedSymptoms.add(s)
                    : _selectedSymptoms.remove(s),
              ),
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

  Widget _buildTypeButton(String label, IconData icon, String type) {
    bool isSel = _complaintType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _complaintType = type;
          _selectedSymptoms.clear();
        }),
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );
}
