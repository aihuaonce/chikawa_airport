import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalCertificate extends StatefulWidget {
  final int medicalId;

  const MedicalCertificate({super.key, required this.medicalId});

  @override
  State<MedicalCertificate> createState() => _MedicalCertificateState();
}

class _MedicalCertificateState extends State<MedicalCertificate> {
  // 樣式顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // 控制器
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _chineseAdviceController =
      TextEditingController();
  final TextEditingController _englishAdviceController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 預設日期為今天
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _chineseAdviceController.dispose();
    _englishAdviceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- 功能函數 ---

  // 帶入囑言範本
  void _applyTemplate(bool isFitToFly) {
    setState(() {
      if (isFitToFly) {
        _chineseAdviceController.text =
            "病人於今日因上述[請填寫診斷]原因，接受本機場醫療中心緊急醫療出診，目前生命徵象穩定適宜飛行。(以下空白)";
        _englishAdviceController.text =
            "Due to above [請填寫診斷] reasons, the patient received an outreach emergency medical. He/She is fit to fly.(Blank Below)";
      } else {
        _chineseAdviceController.text =
            "病人於今日因上述[請填寫診斷]原因，接受本醫療中心緊急醫療出診，建議轉診至醫院進行進一步檢查及治療。(以下空白)";
        _englishAdviceController.text =
            "Due to above [請填寫診斷] reasons, the patient received an outreach emergency medical. It is suggested to transfer to hospital for further evaluation and management.(Blank Below)";
      }
    });
  }

  // 選擇日期
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 診斷結果
        _buildFieldWrapper(
          '診斷結果 Diagnosis Result',
          _buildTextField(
            hint: '請輸入診斷結果內容...',
            controller: _diagnosisController,
            maxLines: 4,
          ),
        ),

        const SizedBox(height: 24),

        // 2. 預設囑言片語按鈕
        _buildLabel('預設囑言片語 Default Advice Phrases'),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTemplateButton(
              label: '適宜飛行 Fit to Fly',
              icon: Icons.flight_takeoff,
              onPressed: () => _applyTemplate(true),
            ),
            const SizedBox(width: 12),
            _buildTemplateButton(
              label: '轉診後送 Referral',
              icon: Icons.medical_services_outlined,
              onPressed: () => _applyTemplate(false),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 3. 中文囑言
        _buildFieldWrapper(
          '中文囑言 Chinese Advice',
          _buildTextField(
            hint: '請輸入中文囑言內容...',
            controller: _chineseAdviceController,
            maxLines: 4,
          ),
        ),

        const SizedBox(height: 24),

        // 4. 英文囑言
        _buildFieldWrapper(
          '英文囑言 English Advice',
          _buildTextField(
            hint: 'Enter English advice content...',
            controller: _englishAdviceController,
            maxLines: 4,
          ),
        ),

        const SizedBox(height: 24),

        // 5. 開立日期
        SizedBox(
          width: 250, // 限制日期欄位寬度
          child: _buildFieldWrapper(
            '開立日期 Issuance Date',
            _buildTextField(
              hint: '請選擇日期',
              controller: _dateController,
              suffixIcon: Icons.calendar_today,
              readOnly: true,
              onTap: _selectDate,
            ),
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 組件實作 ---

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
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        fontSize: 14,
        color: textDark,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: primaryColor, size: 18)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
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
    );
  }

  Widget _buildTemplateButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: Colors.white,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}
