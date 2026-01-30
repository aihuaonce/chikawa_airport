import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReferralForm extends StatefulWidget {
  final int medicalId;

  const ReferralForm({super.key, required this.medicalId});

  @override
  State<ReferralForm> createState() => _ReferralFormState();
}

class _ReferralFormState extends State<ReferralForm> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  final TextEditingController _examDateController = TextEditingController();
  final TextEditingController _medDateController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _scheduledDateController =
      TextEditingController();
  final TextEditingController _consentDateTimeController =
      TextEditingController();
  final TextEditingController _otherRelationController =
      TextEditingController();
  final TextEditingController _otherPurposeController = TextEditingController();

  String? _selectedPurpose;
  String _relationship = '本人 (Self)';

  @override
  void dispose() {
    _examDateController.dispose();
    _medDateController.dispose();
    _orderDateController.dispose();
    _scheduledDateController.dispose();
    _consentDateTimeController.dispose();
    _otherRelationController.dispose();
    super.dispose();
  }

  void _updateNow(TextEditingController controller, {bool isDateTime = false}) {
    String format = isDateTime ? 'yyyy/MM/dd HH:mm' : 'yyyy/MM/dd';
    setState(() {
      controller.text = DateFormat(format).format(DateTime.now());
    });
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: const ColorScheme.light(primary: primaryColor)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => controller.text = DateFormat('yyyy/MM/dd').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 聯絡人資料
        _buildSectionTitle('1. 聯絡人資料 Contact Info'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '姓名 Name',
                _buildTextField(hint: '請輸入姓名'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '電話 Phone',
                _buildTextField(hint: '聯絡電話'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldWrapper('地址 Address', _buildTextField(hint: '詳細居住地址')),

        const SizedBox(height: 32),

        // 2. 診斷病名
        _buildSectionTitle('2. 診斷病名 Diagnosis ICD-10'),
        const SizedBox(height: 12),
        _buildFieldWrapper(
          '主診斷 Primary Diagnosis',
          _buildTextField(hint: '搜尋 ICD-10 代碼或診斷描述'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '副診斷 1 Secondary #1',
                _buildTextField(hint: '選填'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '副診斷 2 Secondary #2',
                _buildTextField(hint: '選填'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 3. 檢查及治療摘要
        _buildSectionTitle('3. 檢查及治療摘要 Summary'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '最近一次檢查結果 Recent Result',
                _buildTextField(hint: '實驗室或影像檢查發現'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '檢查日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _examDateController,
                  readOnly: true,
                  onTap: () => _selectDate(_examDateController),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '最近一次用藥或手術名稱 Medication/Surgery',
                _buildTextField(hint: '藥物名稱或處置流程'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '處置日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _medDateController,
                  readOnly: true,
                  onTap: () => _selectDate(_medDateController),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 4. 轉診目的
        _buildSectionTitle('4. 轉診目的 Purpose of Referral'),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: Row(
            children: [
              _buildPurposeToggle('急診治療'),
              const SizedBox(width: 8),
              _buildPurposeToggle('住院治療'),
              const SizedBox(width: 8),
              _buildPurposeToggle('門診治療'),
              const SizedBox(width: 8),
              _buildPurposeToggle('進一步檢查'),
              const SizedBox(width: 8),
              _buildPurposeToggle('轉回轉出或適當之院所繼續追蹤'),
              const SizedBox(width: 8),
              _buildPurposeToggle('其它'),
            ],
          ),
        ),

        if (_selectedPurpose == '其它') ...[
          const SizedBox(height: 12),
          _buildFieldWrapper(
            '請註明其它目的 Specify Other Purpose',
            _buildTextField(
              hint: '請輸入其它轉診目的說明...',
              controller: _otherPurposeController,
            ),
          ),
        ],

        const SizedBox(height: 32),

        // 5. 醫師交辦與簽署
        _buildSectionTitle('5. 醫師交辦與簽署 Physician & Staff'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '診治醫師姓名 Doctor Name',
                _buildTextField(hint: '醫師姓名'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '診治醫師科別 Department',
                _buildTextField(hint: '科別'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '診治醫師簽名 Signature',
                _buildSignaturePad('請簽署', height: 44),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '開單日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _orderDateController,
                  readOnly: true,
                  onTap: () => _selectDate(_orderDateController),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldWrapper(
          '注意事項 Notes',
          _buildTextField(hint: '特殊醫囑或指示...', maxLines: 3),
        ),

        const SizedBox(height: 32),

        // 6. 建議轉診院所
        _buildSectionTitle('6. 建議轉診院所 Suggested Institution'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '院所名稱 Name',
                _buildTextField(hint: '醫療機構名稱'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '科別 Dept',
                _buildTextField(hint: '建議科別'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '醫師姓名 Doctor',
                _buildTextField(hint: '建議醫師'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '電話 Phone',
                _buildTextField(hint: '聯絡電話'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldWrapper('地址 Address', _buildTextField(hint: '院所詳細地址')),

        const SizedBox(height: 32),

        // 7. 安排就醫
        _buildSectionTitle('7. 安排就醫 Scheduled Visit'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _scheduledDateController,
                  readOnly: true,
                  onTap: () => _selectDate(_scheduledDateController),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFieldWrapper(
                '科別 Dept',
                _buildTextField(hint: '就醫科別'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFieldWrapper(
                '診間 Room',
                _buildTextField(hint: '診間號碼'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFieldWrapper(
                '號碼 No.',
                _buildTextField(hint: '掛號號碼'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 8. 聲明與同意
        _buildSectionTitle('8. 聲明與同意 Declaration & Consent'),
        const SizedBox(height: 12),
        _buildConsentSection(),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件 ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 44 : null,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 13,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
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

  Widget _buildPurposeToggle(String label) {
    bool isSelected = _selectedPurpose == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPurpose = isSelected ? null : label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              if (isSelected)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                      fontSize: 11, // 稍微縮小字體以應付長文字
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignaturePad(String placeholder, {double height = 44}) {
    return Container(
      height: height,
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

  Widget _buildConsentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '經醫師解釋病情及轉診目的後同意轉院。',
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '同意人簽名 Consenter Signature',
                  _buildSignaturePad(
                    'Patient Signature',
                    height: _relationship == '其他 (Other)' ? 168 : 108,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildFieldWrapper(
                      '與病人關係 Relationship',
                      _buildDropdownField(_relationship, [
                        '本人 (Self)',
                        '配偶 (Spouse)',
                        '父母 (Parent)',
                        '子女 (Child)',
                        '其他 (Other)',
                      ], (v) => setState(() => _relationship = v!)),
                    ),
                    if (_relationship == '其他 (Other)') ...[
                      const SizedBox(height: 16),
                      _buildFieldWrapper(
                        '請註明關係 Specify Relationship',
                        _buildTextField(
                          hint: '例如：朋友、同事',
                          controller: _otherRelationController,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildFieldWrapper(
                      '日期與時間 Signature Date/Time',
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              hint: 'YYYY/MM/DD HH:mm',
                              controller: _consentDateTimeController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () => _updateNow(
                                _consentDateTimeController,
                                isDateTime: true,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'NOW',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
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
}
