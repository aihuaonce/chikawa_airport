import 'package:chikawa_airport/data/models/reference_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';
import '../../data/models/medical/certificate_view.dart';
import '../../data/models/medical/treatment_view.dart';
import '../widgets/reference_search_sheet.dart';

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

  // 初始化標誌
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _chineseAdviceController.dispose();
    _englishAdviceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // 同步 ViewModel 資料到 Controllers（只執行一次）
  void _updateControllers(
    MedicalCertificateViewModel viewModel,
    TreatmentViewModel treatmentViewModel,
  ) {
    if (_isInitialized) return;

    // 檢查關鍵資料是否已載入
    if (treatmentViewModel.treatment == null) {
      return;
    }

    final certificate = viewModel.certificate;
    if (certificate != null) {
      _diagnosisController.text = certificate.diagnosisResult ?? '';

      // 若診斷結果為空，嘗試從處置記錄帶入 (Item 3)
      if (_diagnosisController.text.isEmpty) {
        final treatment = treatmentViewModel.treatment;
        if (treatment != null) {
          _diagnosisController.text = treatment.tentative ?? '';
        }
      }

      _chineseAdviceController.text = certificate.chineseAdvice ?? '';
      _englishAdviceController.text = certificate.englishAdvice ?? '';
      if (certificate.issuanceDate != null) {
        _dateController.text =
            DateFormat('yyyy-MM-dd').format(certificate.issuanceDate!);
      } else {
        _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    }

    _isInitialized = true;
  }

  // 帶入囑言範本
  void _applyTemplate(bool isFitToFly) {
    final viewModel = context.read<MedicalCertificateViewModel>();
    final diagnosis = _diagnosisController.text; // 取得當前診斷結果

    setState(() {
      if (isFitToFly) {
        _chineseAdviceController.text =
            "病人於今日因上述$diagnosis原因，接受本機場醫療中心緊急醫療出診，目前生命徵象穩定適宜飛行。(以下空白)";
        _englishAdviceController.text =
            "Due to above $diagnosis reasons, the patient received an outreach emergency medical. He/She is fit to fly.(Blank Below)";
      } else {
        _chineseAdviceController.text =
            "病人於今日因上述$diagnosis原因，接受本醫療中心緊急醫療出診，建議轉診至醫院進行進一步檢查及治療。(以下空白)";
        _englishAdviceController.text =
            "Due to above $diagnosis reasons, the patient received an outreach emergency medical. It is suggested to transfer to hospital for further evaluation and management.(Blank Below)";
      }
    });

    // 自動儲存到資料庫
    viewModel.updateChineseAdvice(_chineseAdviceController.text);
    viewModel.updateEnglishAdvice(_englishAdviceController.text);
  }

  // 選擇日期
  Future<void> _selectDate(MedicalCertificateViewModel viewModel) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.certificate?.issuanceDate ?? DateTime.now(),
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
      viewModel.updateIssuanceDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 ViewModel
    final viewModel = context.watch<MedicalCertificateViewModel>();
    final treatmentViewModel = context.watch<TreatmentViewModel>();
    final refService = context.watch<ReferenceService>();

    // 同步資料到 Controllers（只執行一次）
    _updateControllers(viewModel, treatmentViewModel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 診斷分類（新增 - 正規化）
        _buildLabel('診斷分類 Diagnosis Category'),
        const SizedBox(height: 8),
        _buildDiagnosisCategoryDropdown(viewModel, refService),

        const SizedBox(height: 24),

        // 1. 診斷結果
        _buildFieldWrapper(
          '診斷結果 Diagnosis Result',
          _buildTextField(
            hint: '請輸入診斷結果內容...',
            controller: _diagnosisController,
            maxLines: 4,
            onChanged: (val) => viewModel.updateDiagnosisResult(val),
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
            onChanged: (val) => viewModel.updateChineseAdvice(val),
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
            onChanged: (val) => viewModel.updateEnglishAdvice(val),
          ),
        ),

        const SizedBox(height: 24),

        // 5. 開立日期
        SizedBox(
          width: 250,
          child: _buildFieldWrapper(
            '開立日期 Issuance Date',
            _buildTextField(
              hint: '請選擇日期',
              controller: _dateController,
              suffixIcon: Icons.calendar_today,
              readOnly: true,
              onTap: () => _selectDate(viewModel),
            ),
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // 診斷分類下拉（從參考表讀取）
  Widget _buildDiagnosisCategoryDropdown(
    MedicalCertificateViewModel viewModel,
    ReferenceService refService,
  ) {
    final treatmentViewModel = context.watch<TreatmentViewModel>();
    final treatment = treatmentViewModel.treatment;
    final certificateCategory = viewModel.selectedCategory;
    final treatmentCategory = treatment?.tentativeCategoryId != null
        ? treatmentViewModel.getDiagnosisCategoryById(
            treatment!.tentativeCategoryId,
          )
        : null;
    final selectedCategory = certificateCategory ?? treatmentCategory;

    final text = selectedCategory?.name ?? '';

    return _buildSelectionField(
      text: text,
      hint: '請選取診斷分類',
      icon: Icons.category,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<DiagnosisCategoryData>(
          context,
          title: '選擇診斷分類',
          searchFunction: treatmentViewModel.searchDiagnosisCategories,
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
          viewModel.updateDiagnosisCategoryId(result.id);
          treatmentViewModel.updateTentativeCategoryId(result.id);
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
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
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
