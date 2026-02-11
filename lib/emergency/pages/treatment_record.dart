import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyTreatmentRecord extends StatefulWidget {
  final int emergencyId;

  const EmergencyTreatmentRecord({super.key, required this.emergencyId});

  @override
  State<EmergencyTreatmentRecord> createState() =>
      _EmergencyTreatmentRecordState();
}

class _EmergencyTreatmentRecordState extends State<EmergencyTreatmentRecord> {
  // --- 1. 樣式與顏色定義 ---
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);
  static const Color headerBg = Color(0xFFF8FAFC);

  // --- 2. 控制器定義 ---
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _intubationTimeController =
      TextEditingController();
  final TextEditingController _ivLineTimeController = TextEditingController();
  final TextEditingController _cprStartTimeController = TextEditingController();
  final TextEditingController _cprEndTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _endRecordController = TextEditingController();
  final TextEditingController _assistStaffInputController =
      TextEditingController();

  final TextEditingController _initEController = TextEditingController();
  final TextEditingController _initVController = TextEditingController();
  final TextEditingController _initMController = TextEditingController();
  int? _initGcsTotal;
  final TextEditingController _postEController = TextEditingController();
  final TextEditingController _postVController = TextEditingController();
  final TextEditingController _postMController = TextEditingController();
  int? _postGcsTotal;

  // --- 3. 狀態變數與資料列表 ---
  final List<Map<String, dynamic>> _firstAidMedsLogs = [];
  final List<String> _assistStaffList = [];

  String _leftPupilReaction = '+';
  String _rightPupilReaction = '+';
  String? _tempStatus;
  String? _intubationMethod;
  String _postLeftPupilReaction = '+';
  String _postRightPupilReaction = '+';
  String? _postRespirationMode;
  String _firstAidResult = '轉診';
  String? _aidDoctor;
  String? _aidNurse;
  String? _aidEmt;

  void _calculateGcs(bool isPost) {
    setState(() {
      int e =
          int.tryParse(
            isPost ? _postEController.text : _initEController.text,
          ) ??
          0;
      int v =
          int.tryParse(
            isPost ? _postVController.text : _initVController.text,
          ) ??
          0;
      int m =
          int.tryParse(
            isPost ? _postMController.text : _initMController.text,
          ) ??
          0;

      if (e > 0 && v > 0 && m > 0) {
        if (isPost)
          _postGcsTotal = e + v + m;
        else
          _initGcsTotal = e + v + m;
      } else {
        if (isPost)
          _postGcsTotal = null;
        else
          _initGcsTotal = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // 初始化時間
    _startTimeController.text = DateFormat('HH:mm:ss').format(DateTime.now());
  }

  @override
  void dispose() {
    // 銷毀控制器，釋放記憶體
    _startTimeController.dispose();
    _intubationTimeController.dispose();
    _ivLineTimeController.dispose();
    _cprStartTimeController.dispose();
    _cprEndTimeController.dispose();
    _endRecordController.dispose();
    _assistStaffInputController.dispose();
    _initEController.dispose();
    _initVController.dispose();
    _initMController.dispose();
    _postEController.dispose();
    _postVController.dispose();
    _postMController.dispose();
    super.dispose();
  }

  // 格式化顯示其他藥物
  String _formatOtherMeds(List<dynamic> meds) {
    if (meds.isEmpty) return '--';
    return meds.map((m) => "${m['name']}(${m['dose']})").join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 頂部基本資訊
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救開始時間 First Aid Start Time',
                _buildTimePickerField(_startTimeController),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildFieldWrapper(
                '診斷 Diagnosis',
                _buildTextField(hint: '例如: Sudden Cardiac Arrest'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildFieldWrapper(
                '發生情境 Incident Context',
                _buildTextField(hint: '例如: Collapsed near gate'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),

        // 2. 病況
        _buildSubTitle('病況 Patient Condition'),
        const SizedBox(height: 16),
        _buildLabel('GCS 指數評估'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hint: 'E',
                controller: _initEController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(false),
              ),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: _buildTextField(
                hint: 'V',
                controller: _initVController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(false),
              ),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: _buildTextField(
                hint: 'M',
                controller: _initMController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(false),
              ),
            ),
            const SizedBox(width: 8),
            _buildGcsBox('Total', totalValue: _initGcsTotal, isTotal: true),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildPupilSection(
                '左瞳孔 Left Pupil',
                _leftPupilReaction,
                (v) => setState(() => _leftPupilReaction = v),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildPupilSection(
                '右瞳孔 Right Pupil',
                _rightPupilReaction,
                (v) => setState(() => _rightPupilReaction = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '心跳 Heart Rate (次/分)',
                _buildTextField(hint: 'BPM'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '呼吸 Respiration (次/分)',
                _buildTextField(hint: 'RR'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '血壓 Blood Pressure',
                _buildTextField(hint: 'mm/Hg'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '體溫/皮膚 Temp/Skin',
                _buildDropdownField(
                  hint: '選擇狀態',
                  value: _tempStatus,
                  items: ['溫暖 Warm', '冰冷 Cold'],
                  onChanged: (v) => setState(() => _tempStatus = v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 3. 插管
        _buildColoredSection(
          title: '插管 Intubation',
          color: bgField,
          child: Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '開始時間',
                  _buildTimePickerField(_intubationTimeController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '插管方式',
                  _buildDropdownField(
                    hint: '選擇方式',
                    value: _intubationMethod,
                    items: ['ET', 'LMA', 'I-GEL', 'Failure'],
                    onChanged: (v) => setState(() => _intubationMethod = v),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '管號 Size',
                  _buildTextField(hint: 'Size'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '備註 Notes',
                  _buildTextField(hint: 'Remarks'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 4. 靜脈注射
        _buildColoredSection(
          title: '靜脈注射 IV Line',
          color: bgField,
          child: Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '開始時間',
                  _buildTimePickerField(_ivLineTimeController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '針頭尺寸 Needle Size',
                  _buildTextField(hint: 'Gauge'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '記錄 Notes',
                  _buildTextField(hint: 'Location/Status'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 5. 胸外按壓
        _buildColoredSection(
          title: '胸外按壓 Cardiac Massage',
          icon: Icons.favorite,
          color: const Color(0xFFFEF2F2),
          titleColor: const Color(0xFFDC2626),
          child: Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '開始時間',
                  _buildTimePickerField(_cprStartTimeController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '結束時間',
                  _buildTimePickerField(_cprEndTimeController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '記錄 Notes',
                  _buildTextField(hint: 'CPR Outcome'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 6. 急救處置及用藥記錄表
        _buildTableContainer(
          title: '急救處置及用藥記錄表 FIRST AID & MEDS LOG',
          onAdd: () => _showFirstAidLogModal(),
          child: _buildFirstAidMedsTable(),
        ),

        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),

        // 7. 急救後病況
        _buildPostFirstAidConditionSection(),

        const SizedBox(height: 32),

        // 8. 急救結束與簽署區塊
        _buildFinalSigningSection(),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 元件實作 ---

  Widget _buildFirstAidMedsTable() {
    final flexes = [3, 2, 2, 2, 3, 2, 2, 3, 1];
    final labels = [
      '記錄時間',
      '心跳',
      '血壓',
      '呼吸',
      'O2(L/min;%)',
      'Shock(J)',
      'Epi(mg)',
      '其他藥物',
      '',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1100,
        child: Column(
          children: [
            _buildTableHeaderRow(labels, flexes),
            if (_firstAidMedsLogs.isEmpty) _buildEmptyRow(),
            ..._firstAidMedsLogs.asMap().entries.map((entry) {
              int idx = entry.key;
              var data = entry.value;
              return _buildDataRow(flexes, [
                _buildCompactTimeField(data['time']),
                Center(
                  child: Text(
                    data['hr'] ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    data['bp'] ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    data['rr'] ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    data['o2'] ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    data['shock'] ?? '--',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    data['epi'] ?? '--',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _formatOtherMeds(data['otherMeds'] ?? []),
                  style: const TextStyle(fontSize: 11, color: textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
                _buildDeleteBtn(
                  () => setState(() => _firstAidMedsLogs.removeAt(idx)),
                ),
              ]);
            }),
          ],
        ),
      ),
    );
  }

  void _showFirstAidLogModal() {
    final TextEditingController timeCtrl = TextEditingController(
      text: DateFormat('HH:mm:ss').format(DateTime.now()),
    );
    final TextEditingController hrCtrl = TextEditingController();
    final TextEditingController bpCtrl = TextEditingController();
    final TextEditingController rrCtrl = TextEditingController();
    final TextEditingController o2Ctrl = TextEditingController();
    final TextEditingController shockCtrl = TextEditingController();
    final TextEditingController epiCtrl = TextEditingController();
    List<Map<String, String>> tempOtherMeds = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '新增急救處置與用藥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildFieldWrapper(
                            '記錄時間',
                            _buildTextField(hint: '', controller: timeCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            '心跳 (BPM)',
                            _buildTextField(hint: '請輸入心跳', controller: hrCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            '血壓 (mmHg)',
                            _buildTextField(hint: '請輸入血壓', controller: bpCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFieldWrapper(
                            '呼吸 (RR)',
                            _buildTextField(hint: '請輸入呼吸', controller: rrCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            'O2 (L;%)',
                            _buildTextField(
                              hint: '例：Ambu 15L',
                              controller: o2Ctrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            'DC Shock (J)',
                            _buildTextField(
                              hint: '若無則空白',
                              controller: shockCtrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            'Epinephrine',
                            _buildTextField(hint: '若無則空白', controller: epiCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('使用其它藥物記錄 OTHER MEDS'),
                        TextButton.icon(
                          onPressed: () => setModalState(
                            () => tempOtherMeds.add({'name': '', 'dose': ''}),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('新增藥物'),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    ...tempOtherMeds.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildTextField(
                                hint: '藥物名稱',
                                onChanged: (v) => e.value['name'] = v,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                hint: '劑量',
                                onChanged: (v) => e.value['dose'] = v,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => setModalState(
                                () => tempOtherMeds.removeAt(e.key),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _firstAidMedsLogs.add({
                                  'time': timeCtrl.text,
                                  'hr': hrCtrl.text,
                                  'bp': bpCtrl.text,
                                  'rr': rrCtrl.text,
                                  'o2': o2Ctrl.text,
                                  'shock': shockCtrl.text,
                                  'epi': epiCtrl.text,
                                  'otherMeds': List<Map<String, String>>.from(
                                    tempOtherMeds,
                                  ),
                                });
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('確認加入'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 表格對齊工具 ---

  Widget _buildTableHeaderRow(List<String> labels, List<int> flexes) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: labels
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                flex: flexes[e.key],
                child: Text(
                  e.value,
                  style: const TextStyle(
                    color: Color(0xFF5E878D),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDataRow(List<int> flexes, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                flex: flexes[e.key],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: e.value,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- 基礎組件 ---

  Widget _buildTimePickerField(TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(hint: 'HH:mm:ss', controller: controller),
        ),
        const SizedBox(width: 8),
        _buildNowButton(controller),
      ],
    );
  }

  Widget _buildCompactTimeField(String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.access_time, size: 12, color: textMuted),
      ],
    );
  }

  Widget _buildNowButton(TextEditingController controller) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: () => setState(
          () => controller.text = DateFormat('HH:mm:ss').format(DateTime.now()),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: primaryColor.withValues(alpha: 0.05),
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'NOW',
          style: TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    Function(String)? onChanged,
    Color? textColor,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 44 : null,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: textAlign,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14,
          color: textColor ?? textDark,
          fontWeight: textColor != null ? FontWeight.bold : FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: textMuted, fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
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
      ),
    );
  }

  Widget _buildTableContainer({
    required String title,
    required VoidCallback onAdd,
    required Widget child,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5E878D),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'Add Row',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildColoredSection({
    required String title,
    required Widget child,
    required Color color,
    IconData? icon,
    Color titleColor = primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: titleColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
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

  Widget _buildDeleteBtn(VoidCallback onTap) => IconButton(
    icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 18),
    onPressed: onTap,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
  );
  Widget _buildEmptyRow() => Container(
    padding: const EdgeInsets.all(16),
    alignment: Alignment.center,
    child: const Text(
      '無記錄，請點擊 Add Row 新增',
      style: TextStyle(color: textMuted, fontSize: 12),
    ),
  );
  Widget _buildSubTitle(String text) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      color: primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    ),
  );
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
  );
  Widget _buildFieldWrapper(String label, Widget field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildLabel(label), const SizedBox(height: 6), field],
  );
  Widget _buildGcsBox(String label, {int? totalValue, bool isTotal = false}) {
    return Container(
      width: 110,
      height: 44,
      decoration: BoxDecoration(
        color: isTotal ? primaryColor.withValues(alpha: 0.05) : Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        isTotal ? (totalValue != null ? 'Total: $totalValue' : 'Total') : label,
        style: TextStyle(
          color: isTotal && totalValue != null
              ? primaryColor
              : textMuted.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPupilSection(
    String side,
    String currentReact,
    Function(String) onReact,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(side),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: ['+', '-', '±'].map((opt) {
                  bool isSel = currentReact == opt;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onReact(opt),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTextField(hint: 'mm', textAlign: TextAlign.center),
          ),
        ],
      ),
    ],
  );
  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) => Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(8),
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
                  style: const TextStyle(fontSize: 14, color: textDark),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );

  Widget _buildPostFirstAidConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubTitle('急救後病況 Post-Resuscitation Status'),
        const SizedBox(height: 20),

        _buildLabel('GCS 指數評估'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hint: 'E',
                controller: _postEController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                hint: 'V',
                controller: _postVController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                hint: 'M',
                controller: _postMController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(true),
              ),
            ),
            const SizedBox(width: 8),
            _buildGcsBox('Total', totalValue: _postGcsTotal, isTotal: true),
            const Spacer(),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _buildPupilSection(
                '左瞳孔 Left Pupil',
                _postLeftPupilReaction,
                (v) => setState(() => _postLeftPupilReaction = v),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildPupilSection(
                '右瞳孔 Right Pupil',
                _postRightPupilReaction,
                (v) => setState(() => _postRightPupilReaction = v),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '心跳 Heart Rate',
                _buildTextField(hint: 'BPM'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '呼吸 Respiration',
                _buildDropdownField(
                  hint: '選擇方式',
                  value: _postRespirationMode,
                  items: ['自發性呼吸', '呼吸器', 'Ambu'],
                  onChanged: (v) => setState(() => _postRespirationMode = v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '血壓 Blood Pressure',
                _buildTextField(hint: 'mm/Hg'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '其它補充 Others',
                _buildTextField(hint: '補充說明...'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 40,
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 12,
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

  Widget _buildFinalSigningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubTitle('急救結束記錄與簽署 Final Documentation'),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '急救結束時間 End Time',
                _buildTimePickerField(_endTimeController),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '急救結果 Result',
                _buildSegmentedControl(
                  ['轉診', '死亡', '其它'],
                  _firstAidResult,
                  (v) => setState(() => _firstAidResult = v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildFieldWrapper(
          '急救結束記錄 End of Care Notes',
          _buildTextField(
            hint: '請輸入急救結束時的總結紀錄...',
            maxLines: 3,
            controller: _endRecordController,
          ),
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救醫師 Doctor',
                _buildDropdownField(
                  hint: '選擇醫師',
                  value: _aidDoctor,
                  items: const ['醫師 A', '醫師 B', '醫師 C'],
                  onChanged: (v) => setState(() => _aidDoctor = v),
                ),
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(child: SizedBox()),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救護理師 Nurse',
                _buildDropdownField(
                  hint: '選擇護理師',
                  value: _aidNurse,
                  items: const ['護理師 A', '護理師 B'],
                  onChanged: (v) => setState(() => _aidNurse = v),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '護理師簽名 Nurse Signature',
                _buildSignaturePad('護理師簽署'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救 EMT',
                _buildDropdownField(
                  hint: '選擇 EMT',
                  value: _aidEmt,
                  items: const ['EMT A', 'EMT B'],
                  onChanged: (v) => setState(() => _aidEmt = v),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                'EMT 簽名 EMT Signature',
                _buildSignaturePad('EMT 簽署'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        _buildLabel('協助人員表 Assist Staff'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hint: '輸入人員姓名後點擊右側新增...',
                controller: _assistStaffInputController,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_assistStaffInputController.text.isNotEmpty) {
                    setState(() {
                      _assistStaffList.add(_assistStaffInputController.text);
                      _assistStaffInputController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('新增人員'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  foregroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_assistStaffList.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _assistStaffList
                .map(
                  (name) => Chip(
                    label: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: bgField,
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.red,
                    ),
                    onDeleted: () =>
                        setState(() => _assistStaffList.remove(name)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: borderColor),
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
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgField,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.draw_outlined, size: 16, color: textMuted),
          const SizedBox(width: 8),
          Text(
            placeholder,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.5),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
