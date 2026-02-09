import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmbulanceTreatmentItems extends StatefulWidget {
  final int medicalId;
  const AmbulanceTreatmentItems({super.key, required this.medicalId});

  @override
  State<AmbulanceTreatmentItems> createState() =>
      _AmbulanceTreatmentItemsState();
}

class _AmbulanceTreatmentItemsState extends State<AmbulanceTreatmentItems> {
  // --- 1. 顏色與樣式定義 ---
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);
  static const Color headerBg = Color(0xFFF8FAFC);

  // --- 2. 狀態變數 ---
  final List<String> _selectedCategories = [];
  final Map<String, List<String>> _selectedSubItems = {
    '呼吸道處置': [],
    '創傷處置': [],
    '搬運': [],
    '心肺復甦術': [],
    '藥物處置': [],
    '其它處置': [],
  };

  final List<Map<String, String>> _medicationList = [];
  final List<Map<String, dynamic>> _vitalSignsList = [];
  final List<Map<String, String>> _escortStaffList = [];
  bool _isRefused = false;
  String _relationship = '病患 Patient';

  final TextEditingController _receivingTimeController = TextEditingController(
    text: '-- : -- : --',
  );

  @override
  void dispose() {
    _receivingTimeController.dispose();
    super.dispose();
  }

  // --- 3. 邏輯方法 ---

  // 計算單一列的 GCS 總分
  String _calculateGcsTotal(Map<String, dynamic> data) {
    int e = int.tryParse(data['e'] ?? '0') ?? 0;
    int v = int.tryParse(data['v'] ?? '0') ?? 0;
    int m = int.tryParse(data['m'] ?? '0') ?? 0;
    if (e == 0 && v == 0 && m == 0) return '--';
    return (e + v + m).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('急救處置大類 EMERGENCY CATEGORIES'),
        const SizedBox(height: 10),
        _buildMainCategoryGrid(),
        if (_selectedCategories.isNotEmpty) _buildDynamicSubActionSections(),
        const SizedBox(height: 24),
        _buildFieldWrapper(
          '線上指導醫師指導說明 DOCTOR\'S INSTRUCTIONS',
          _buildTextField(hint: '請輸入醫師指示內容...', maxLines: 2),
        ),
        const SizedBox(height: 32),

        // 4. 藥物記錄表
        _buildTableContainer(
          title: '藥物記錄表 MEDICATION LOG',
          onAdd: () => setState(
            () => _medicationList.add({
              'time': DateFormat('HH:mm:ss').format(DateTime.now()), // 加上 :ss
            }),
          ),
          child: _buildMedicationTable(),
        ),
        const SizedBox(height: 32),

        // 5. 生命徵象記錄表 (含 EVM 自動計算)
        _buildTableContainer(
          title: '生命徵象記錄表 VITAL SIGNS LOG',
          onAdd: () => setState(
            () => _vitalSignsList.add({
              'time': DateFormat('HH:mm:ss').format(DateTime.now()), // 加上 :ss
              'atHosp': false, 'avpu': '清', 'e': '', 'v': '', 'm': '',
            }),
          ),
          child: _buildVitalSignsTable(),
        ),
        const SizedBox(height: 32),

        // 6. 隨車人員表
        _buildTableContainer(
          title: '隨車人員表 ESCORT STAFF',
          onAdd: () => setState(() => _escortStaffList.add({'name': ''})),
          child: _buildEscortStaffTable(),
        ),
        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),
        _buildBottomInfoSection(),
        const SizedBox(height: 80),
      ],
    );
  }

  // 4. 表格實作

  Widget _buildVitalSignsTable() {
    // 欄位比例分配 (總計 23)
    final flexes = [3, 1, 2, 1, 1, 1, 2, 2, 2, 2, 3, 2, 1];
    final labels = [
      '時間',
      '到院',
      'AVPU',
      'E',
      'V',
      'M',
      'GCS',
      '體溫(°C)',
      '脈搏(次/min)',
      '呼吸(次/min)',
      '血壓(mmHg)',
      '血氧(%)',
      '',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SizedBox(
              width: 1100,
              child: Column(
                children: [
                  _buildTableHeaderRow(labels, flexes),
                  if (_vitalSignsList.isEmpty) _buildEmptyRow(),
                  ..._vitalSignsList.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var data = entry.value;
                    return _buildDataRow(flexes, [
                      _buildCompactTimeField(data['time']),
                      Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: data['atHosp'],
                            onChanged: (v) =>
                                setState(() => data['atHosp'] = v),
                            activeColor: primaryColor,
                          ),
                        ),
                      ),
                      _buildSimpleDropdown(
                        ['清', '聲', '痛', '否'],
                        data['avpu'],
                        (v) => setState(() => data['avpu'] = v),
                      ),
                      _buildCompactTextField(
                        'E',
                        (v) => setState(() => data['e'] = v),
                        data['e'],
                      ),
                      _buildCompactTextField(
                        'V',
                        (v) => setState(() => data['v'] = v),
                        data['v'],
                      ),
                      _buildCompactTextField(
                        'M',
                        (v) => setState(() => data['m'] = v),
                        data['m'],
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          _calculateGcsTotal(data),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      _buildCompactTextField('°C'),
                      _buildCompactTextField('BPM'),
                      _buildCompactTextField('RR'),
                      _buildCompactTextField('BP'),
                      _buildCompactTextField('%'),
                      _buildDeleteBtn(
                        () => setState(() => _vitalSignsList.removeAt(idx)),
                      ),
                    ]);
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicationTable() {
    final flexes = [2, 3, 3, 2, 2, 1];
    final labels = [
      '時間 TIME',
      '藥品名稱 DRUG NAME',
      '使用方式 ROUTE',
      '劑量單位 DOSE',
      'EMT姓名 EMT NAME',
      '',
    ];
    return Column(
      children: [
        _buildTableHeaderRow(labels, flexes),
        if (_medicationList.isEmpty) _buildEmptyRow(),
        ..._medicationList.asMap().entries.map(
          (e) => _buildDataRow(flexes, [
            _buildCompactTimeField(e.value['time'] ?? '--:--'),
            _buildCompactTextField('Drug Name'),
            _buildCompactTextField('Route'),
            _buildCompactTextField('Dose'),
            _buildCompactTextField('Name'),
            _buildDeleteBtn(
              () => setState(() => _medicationList.removeAt(e.key)),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildEscortStaffTable() {
    final flexes = [5, 5, 1];
    final labels = ['隨車人員姓名 NAME', '簽名 SIGNATURE', ''];
    return Column(
      children: [
        _buildTableHeaderRow(labels, flexes),
        if (_escortStaffList.isEmpty) _buildEmptyRow(),
        ..._escortStaffList.asMap().entries.map(
          (e) => _buildDataRow(flexes, [
            _buildCompactTextField('Enter Name'),
            const Center(
              child: Text(
                'Sign here',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: textMuted,
                  fontSize: 12,
                ),
              ),
            ),
            _buildDeleteBtn(
              () => setState(() => _escortStaffList.removeAt(e.key)),
            ),
          ]),
        ),
      ],
    );
  }

  // 5. 表格對齊工具方法

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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: e.value,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // 6. 基礎輸入與 UI 元件

  Widget _buildCompactTextField(
    String hint, [
    Function(String)? onChanged,
    String? value,
  ]) {
    return SizedBox(
      height: 36,
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: borderColor, fontSize: 11),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildCompactTimeField(String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: textDark,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.access_time, size: 12, color: textMuted),
      ],
    );
  }

  Widget _buildSimpleDropdown(
    List<String> items,
    String? val,
    Function(String?) onChg,
  ) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          isDense: true,
          isExpanded: true,
          items: items
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
          onChanged: onChg,
        ),
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
      '無資料，請點擊 Add Row 新增',
      style: TextStyle(color: textMuted, fontSize: 12),
    ),
  );

  // 其他佈局元件

  Widget _buildMainCategoryGrid() {
    final categories = ['呼吸道處置', '創傷處置', '搬運', '心肺復甦術', '藥物處置', '其它處置'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        bool isSel = _selectedCategories.contains(cat);
        return InkWell(
          onTap: () => setState(
            () => isSel
                ? _selectedCategories.remove(cat)
                : _selectedCategories.add(cat),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSel ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSel ? primaryColor : borderColor,
                width: 1.5,
              ),
            ),
            child: Text(
              cat,
              style: TextStyle(
                color: isSel ? Colors.white : textDark,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDynamicSubActionSections() {
    return Column(
      children: _selectedCategories.map((cat) {
        List<String> options = [];
        if (cat == '呼吸道處置') {
          options = [
            '口咽呼吸道',
            '鼻咽呼吸道',
            '抽吸',
            '哈姆立克法',
            '鼻管',
            '面罩',
            '非再呼吸型面罩',
            'BVM',
            'LMA',
            'I-Gel',
            '氣管內管',
            '其它',
          ];
        }
        if (cat == '創傷處置') {
          options = ['頸圈', '清洗傷口', '止血、包紮', '骨折固定', '長背板固定', '鏟式擔架固定', '其它'];
        }
        if (cat == '搬運') {
          options = ['自行上車', '適當方式搬運'];
        }
        if (cat == '心肺復甦術') {
          options = ['自動心肺復甦機', 'CPR', '使用AED', '手動電擊器'];
        }
        if (cat == '藥物處置') {
          options = ['靜脈輸液', '口服葡萄糖', 'Aspirin', 'NTG', '支氣管擴張劑'];
        }
        if (cat == '其它處置') {
          options = ['保暖', '心理支持', '約束帶', '拒絕氧氣', '監測', '其它'];
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 1. 選項按鈕區
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((opt) {
                  bool isSelected =
                      _selectedSubItems[cat]?.contains(opt) ?? false;
                  return FilterChip(
                    label: Text(opt, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedSubItems[cat]!.add(opt);
                        } else {
                          _selectedSubItems[cat]!.remove(opt);
                        }
                      });
                    },
                    selectedColor: primaryColor.withValues(alpha: 0.1),
                    checkmarkColor: primaryColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? primaryColor : borderColor,
                      ),
                    ),
                  );
                }).toList(),
              ),

              // 2. 核心連動：內嵌 ALS 詳細欄位

              // 呼吸道處置 -> 氣管內管
              if (cat == '呼吸道處置' && _selectedSubItems[cat]!.contains('氣管內管'))
                _buildEmbeddedDetailBox(
                  Row(
                    children: [
                      Expanded(child: _buildTextField(hint: '氣管內管號碼 Size')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField(hint: '固定公分數 (cm)')),
                    ],
                  ),
                ),

              // 心肺復甦術 -> 手動電擊器
              if (cat == '心肺復甦術' && _selectedSubItems[cat]!.contains('手動電擊器'))
                _buildEmbeddedDetailBox(
                  Row(
                    children: [
                      Expanded(child: _buildTextField(hint: '手動電擊次數')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField(hint: '手動電擊焦耳數 (J)')),
                    ],
                  ),
                ),

              // 通用：其它 -> 輸入框
              if (_selectedSubItems[cat]!.contains('其它'))
                _buildEmbeddedDetailBox(
                  _buildTextField(hint: '請輸入其它處置細節描述...'),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 輔助組件：內嵌的詳細資訊灰框
  Widget _buildEmbeddedDetailBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
      ),
      child: child,
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

  Widget _buildBottomInfoSection() {
    const double horizontalGap = 16.0;

    return Column(
      children: [
        // 第一排：接收單位、接收時間、送醫意願
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '接收單位 RECEIVING UNIT',
                _buildTextField(hint: 'Enter Hospital/Unit Name'),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '接收時間 RECEIVING TIME',
                _buildReceivingTimeField(),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '送醫意願 ADMISSION STATUS',
                _buildRefusalBox(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // 第二排：關係人身份、姓名、聯絡電話
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '關係人身份 RELATIONSHIP',
                _buildDropdownField2(
                  hint: '',
                  value: _relationship,
                  items: ['病患 Patient', '家屬 Family', '關係人 Associate'],
                  onChanged: (v) => setState(() => _relationship = v!),
                ),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '姓名 NAME',
                _buildTextField(hint: 'Enter Full Name'),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '聯絡電話 PHONE',
                _buildTextField(hint: 'Enter Contact Number'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefusalBox() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: _isRefused,
              onChanged: (v) => setState(() => _isRefused = v!),
              activeColor: Colors.redAccent,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '是否拒絕送醫 Refusal',
              style: TextStyle(
                color: Color(0xFFB91C1C),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivingTimeField() {
    return InkWell(
      onTap: () {
        // 點擊整塊區域直接更新為現在時間（含秒）
        setState(() {
          _receivingTimeController.text = DateFormat(
            'HH:mm:ss',
          ).format(DateTime.now());
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _receivingTimeController.text,
                style: TextStyle(
                  color: _receivingTimeController.text == '-- : -- : --'
                      ? textMuted.withValues(alpha: 0.4)
                      : textDark,
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Icon(
              Icons.access_time,
              size: 18,
              color: textMuted.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF5E878D),
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );
  Widget _buildFieldWrapper(String label, Widget field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildLabel(label), const SizedBox(height: 6), field],
  );
  Widget _buildTextField({required String hint, int maxLines = 1}) => TextField(
    maxLines: maxLines,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.4)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
  Widget _buildDropdownField2({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) => Container(
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
        icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
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
}
