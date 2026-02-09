import 'package:flutter/material.dart';

class AmbulanceSceneStatus extends StatefulWidget {
  final int medicalId;
  const AmbulanceSceneStatus({super.key, required this.medicalId});

  @override
  State<AmbulanceSceneStatus> createState() => _AmbulanceSceneStatusState();
}

class _AmbulanceSceneStatusState extends State<AmbulanceSceneStatus> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // --- 狀態變數 ---
  // 修改處：將單選字串改為複選清單
  final List<String> _mainCategories = [];

  final List<String> _selectedTraumaGroups = [];
  final List<String> _selectedNonTraumaGroups = [];

  final List<String> _selectedGeneralTrauma = [];
  final List<String> _selectedMechanism = [];
  final List<String> _selectedAcute = [];
  final List<String> _selectedGeneralDisease = [];

  String _isProxyComplaint = '否';

  String _allergyStatus = '無';
  String _historyStatus = '無';
  final List<String> _selectedAllergies = [];
  final List<String> _selectedHistories = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 案件分類 (改為可複選)
        _buildLabel('案件分類 CATEGORY (可複選)'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildMainCategoryButton('創傷 Trauma', 'Trauma'),
            const SizedBox(width: 12),
            _buildMainCategoryButton('非創傷 Non-Trauma', 'NonTrauma'),
          ],
        ),

        const SizedBox(height: 24),

        // 2. 創傷/非創傷動態區塊
        if (_mainCategories.contains('Trauma')) ...[
          _buildLabel('創傷項目'),
          const SizedBox(height: 10),
          _buildChipGrid(
            options: [
              '一般外傷',
              '受傷機轉',
              '溺水',
              '摔跌傷',
              '墜落傷',
              '穿刺傷',
              '燒燙傷',
              '電擊傷',
              '生物咬螫傷',
              '到院前心肺功能停止',
              '其它',
            ],
            selectedList: _selectedTraumaGroups,
            onChanged: (val) {},
          ),
          if (_selectedTraumaGroups.contains('一般外傷'))
            _buildSubContainer(
              '一般外傷細項',
              _buildChipGrid(
                options: ['頸部外傷', '胸部外傷', '腹部外傷', '背部外傷', '肢體外傷', '其它'],
                selectedList: _selectedGeneralTrauma,
                onChanged: (s) {},
              ),
            ),
          if (_selectedTraumaGroups.contains('受傷機轉'))
            _buildSubContainer(
              '受傷機轉分類',
              _buildChipGrid(
                options: ['因交通事故', '非交通事故'],
                selectedList: _selectedMechanism,
                onChanged: (s) {},
              ),
            ),
          if (_selectedTraumaGroups.contains('墜落傷'))
            _buildSubContainer(
              '墜落傷詳情',
              _buildTextField(hint: '墜落高度', prefixIcon: Icons.height),
            ),
          if (_selectedTraumaGroups.contains('燒燙傷'))
            _buildSubContainer(
              '燒燙傷詳情',
              Row(
                children: [
                  Expanded(child: _buildTextField(hint: '度數')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(hint: '面積', suffixText: '%'),
                  ),
                ],
              ),
            ),
          if (_selectedTraumaGroups.contains('其它'))
            _buildSubContainer(
              '其它創傷說明',
              _buildTextField(
                hint: '請描述其它創傷狀況...',
                prefixIcon: Icons.edit_note,
              ),
            ),

          const SizedBox(height: 24), // 如果同時勾選，保留間距
        ],

        if (_mainCategories.contains('NonTrauma')) ...[
          _buildLabel('非創傷項目'),
          const SizedBox(height: 10),
          _buildChipGrid(
            options: ['急症', '一般疾病'],
            selectedList: _selectedNonTraumaGroups,
            onChanged: (val) {},
          ),
          if (_selectedNonTraumaGroups.contains('急症'))
            _buildSubContainer(
              '急症詳細分類',
              _buildChipGrid(
                options: [
                  '呼吸問題(喘)',
                  '呼吸道問題',
                  '昏迷',
                  '胸痛/胸悶',
                  '腹痛',
                  '中毒',
                  '癲癇',
                  '路倒',
                  '精神異常',
                  '孕婦急產',
                  'OHCA',
                  '其它',
                ],
                selectedList: _selectedAcute,
                onChanged: (s) {},
              ),
            ),
          if (_selectedNonTraumaGroups.contains('一般疾病'))
            _buildSubContainer(
              '一般疾病詳細分類',
              _buildChipGrid(
                options: ['頭痛/頭暈', '昏倒/昏厥', '發燒', '噁心/嘔吐', '肢體無力'],
                selectedList: _selectedGeneralDisease,
                onChanged: (s) {},
              ),
            ),
        ],

        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),

        // 4. 主訴與代訴
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '病患主訴 PATIENT COMPLAINT',
                _buildTextField(hint: '請輸入病患自述內容'),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('家屬或同事友人代訴 PROXY?'),
                  const SizedBox(height: 10),
                  _buildSegmentedControl(
                    ['否 No', '是 Yes'],
                    _isProxyComplaint,
                    (v) => setState(() => _isProxyComplaint = v),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 5. 過敏史區塊
        _buildHistoryToggleSection('過敏史 Allergy History', _allergyStatus, (
          val,
        ) {
          setState(() {
            _allergyStatus = val;
            if (val != '有') _selectedAllergies.clear();
          });
        }),
        if (_allergyStatus == '有') ...[
          const SizedBox(height: 12),
          _buildDynamicHistoryContainer(
            _buildChipGrid(
              options: ['食物', '藥物', '其它'],
              selectedList: _selectedAllergies,
              onChanged: (s) => setState(() {}),
            ),
            _selectedAllergies.isNotEmpty,
            '請註明具體過敏原',
          ),
        ],

        const SizedBox(height: 24),

        // 6. 過去病史區塊
        _buildHistoryToggleSection(
          '過去病史 Past Medical History',
          _historyStatus,
          (val) {
            setState(() {
              _historyStatus = val;
              if (val != '有') _selectedHistories.clear();
            });
          },
        ),
        if (_historyStatus == '有') ...[
          const SizedBox(height: 12),
          _buildDynamicHistoryContainer(
            _buildChipGrid(
              options: ['高血壓', '糖尿病', '氣喘', '心臟疾病', '其它'],
              selectedList: _selectedHistories,
              onChanged: (s) => setState(() {}),
            ),
            _selectedHistories.contains('其它'),
            '請說明其它病史詳情...',
          ),
        ],

        const SizedBox(height: 60),
      ],
    );
  }

  // --- 新增：主類別的複選按鈕 ---
  Widget _buildMainCategoryButton(String label, String value) {
    bool isSelected = _mainCategories.contains(value);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _mainCategories.remove(value);
              // 取消勾選時，清空對應的子項目
              if (value == 'Trauma') {
                _selectedTraumaGroups.clear();
                _selectedGeneralTrauma.clear();
                _selectedMechanism.clear();
              } else {
                _selectedNonTraumaGroups.clear();
                _selectedAcute.clear();
                _selectedGeneralDisease.clear();
              }
            } else {
              _mainCategories.add(value);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : borderColor,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : textDark,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 動態歷史紀錄容器
  Widget _buildDynamicHistoryContainer(
    Widget chips,
    bool showInput,
    String inputHint,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chips,
          if (showInput) ...[
            const SizedBox(height: 16),
            _buildTextField(hint: inputHint, prefixIcon: Icons.edit_note),
          ],
        ],
      ),
    );
  }

  // --- 基礎元件 ---

  Widget _buildSubContainer(String label, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildChipGrid({
    required List<String> options,
    required List<String> selectedList,
    required Function(String) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: options.map((opt) {
        bool isSelected = selectedList.contains(opt);
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected ? selectedList.remove(opt) : selectedList.add(opt);
            });
            onChanged(opt);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? primaryColor : borderColor,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: isSelected ? Colors.white : textDark,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSelected = current == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textMuted,
                    fontSize: 13,
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

  Widget _buildHistoryToggleSection(
    String title,
    String currentVal,
    Function(String) onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title),
        const SizedBox(height: 8),
        _buildSegmentedControl(['無', '不詳', '有'], currentVal, onToggle),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 8), field],
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? prefixIcon,
    String? suffixText,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 18, color: primaryColor)
              : null,
          suffixText: suffixText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
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
}
