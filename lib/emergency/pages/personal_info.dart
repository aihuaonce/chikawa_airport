import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyPersonalInfo extends StatefulWidget {
  final int emergencyId;

  const EmergencyPersonalInfo({super.key, required this.emergencyId});

  @override
  State<EmergencyPersonalInfo> createState() => _EmergencyPersonalInfoState();
}

class _EmergencyPersonalInfoState extends State<EmergencyPersonalInfo> {
  // 顏色與樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // 本地控制器與狀態
  final TextEditingController _birthdayController = TextEditingController();
  String? _selectedGender;
  final List<String> _genderOptions = ['男 Male', '女 Female', '其他 Other'];

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  // 選擇日期功能
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 區塊標題
        _buildSectionHeader(
          '個人紀錄 Personal Info',
          'Basic personal details and identification records.',
        ),

        const SizedBox(height: 32),

        // 2. 兩欄式表單網格
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 左側欄位 ---
            Expanded(
              child: Column(
                children: [
                  _buildFieldWrapper(
                    '身分證字號 ID Number',
                    _buildTextField(hint: '請輸入身分證字號'),
                  ),
                  const SizedBox(height: 24),
                  _buildFieldWrapper(
                    '出生日期 Birth Date',
                    _buildTextField(
                      hint: 'YYYY/MM/DD',
                      controller: _birthdayController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 32), // 左右欄間距
            // --- 右側欄位 ---
            Expanded(
              child: Column(
                children: [
                  _buildFieldWrapper(
                    '性別 Gender',
                    _buildDropdownField(
                      hint: '請選擇性別',
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFieldWrapper(
                    '護照號碼 Passport Number',
                    _buildTextField(hint: '請輸入護照號碼'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- UI 共用元件方法 ---

  Widget _buildSectionHeader(String title, String subTitle) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subTitle,
              style: const TextStyle(color: textMuted, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: primaryColor.withValues(alpha: 0.6),
                  size: 18,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
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
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: textDark),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
