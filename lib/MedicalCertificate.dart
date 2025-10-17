import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/certificate_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
import 'nav2.dart';

class MedicalCertificatePage extends StatefulWidget {
  final int visitId;
  const MedicalCertificatePage({super.key, required this.visitId});

  @override
  State<MedicalCertificatePage> createState() => _MedicalCertificatePageState();
}

class _MedicalCertificatePageState extends State<MedicalCertificatePage>
    with
        AutomaticKeepAliveClientMixin<MedicalCertificatePage>,
        SavableStateMixin<MedicalCertificatePage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // 文字輸入框控制器
  final _diagnosisController = TextEditingController();
  final _chineseController = TextEditingController();
  final _englishController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _chineseController.dispose();
    _englishController.dispose();
    super.dispose();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context); // 【新增】
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveCertificateFailed}$e')),
        ); // 【修改】
      }
      rethrow;
    }
  }

  // ===============================================
  // 資料處理邏輯
  // ===============================================

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<MedicalCertificatesDao>();
      final dataModel = context.read<CertificateData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null) {
        dataModel.diagnosis = record.diagnosis;
        dataModel.instructionOption = record.instructionOption;
        dataModel.chineseInstruction = record.chineseInstruction;
        dataModel.englishInstruction = record.englishInstruction;
        dataModel.issueDate = record.issueDate;
      }
      _syncDataToControllers(dataModel);
      dataModel.update();
    } catch (e) {
      // 錯誤處理
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<MedicalCertificatesDao>();
    final dataModel = context.read<CertificateData>();

    // ✅ 正確做法：直接呼叫您在 dataModel 中定義好的新方法
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  void _syncDataToControllers(CertificateData dataModel) {
    _diagnosisController.text = dataModel.diagnosis ?? '';
    _chineseController.text = dataModel.chineseInstruction ?? '';
    _englishController.text = dataModel.englishInstruction ?? '';
  }

  void _syncControllersToData() {
    final dataModel = context.read<CertificateData>();
    dataModel.diagnosis = _diagnosisController.text.trim();
    dataModel.chineseInstruction = _chineseController.text.trim();
    dataModel.englishInstruction = _englishController.text.trim();
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context); // 【新增】

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<CertificateData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDiagnosisInput(t, dataModel), // 【修改】
                        const SizedBox(height: 16),
                        _buildRadioRow(t, dataModel), // 【修改】
                        const SizedBox(height: 16),
                        _buildChineseInstructionInput(t, dataModel), // 【修改】
                        const SizedBox(height: 16),
                        _buildEnglishInstructionInput(t, dataModel), // 【修改】
                        const SizedBox(height: 16),
                        _buildDateRow(t, dataModel), // 【修改】
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===============================================
  // Helper Widgets
  // ===============================================

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF83ACA9), width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildDiagnosisInput(AppTranslations t, CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.diagnosisLabel)), // 【修改】
        Expanded(
          flex: 8,
          child: TextField(
            controller: _diagnosisController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterDiagnosisHint), // 【修改】
          ),
        ),
      ],
    );
  }

  Widget _buildChineseInstructionInput(
    AppTranslations t,
    CertificateData dataModel,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildLabel(t.chineseInstructionLabel),
        ), // 【修改】
        Expanded(
          flex: 8,
          child: TextField(
            controller: _chineseController,
            maxLines: 3,
            decoration: _getInputDecoration(
              t.enterChineseInstructionHint,
            ), // 【修改】
          ),
        ),
      ],
    );
  }

  Widget _buildEnglishInstructionInput(
    AppTranslations t,
    CertificateData dataModel,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildLabel(t.englishInstructionLabel),
        ), // 【修改】
        Expanded(
          flex: 8,
          child: TextField(
            controller: _englishController,
            maxLines: 3,
            decoration: _getInputDecoration(
              t.enterEnglishInstructionHint,
            ), // 【修改】
          ),
        ),
      ],
    );
  }

  Widget _buildRadioRow(AppTranslations t, CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: _buildLabel(t.defaultInstructionPhrase),
        ), // 【修改】
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  dataModel.instructionOption = value;
                  _chineseController.text =
                      t.fitToFlyInstructionChinese; // 【修改】
                  _englishController.text =
                      t.fitToFlyInstructionEnglish; // 【修改】
                  dataModel.update();
                },
              ),
              Text(t.fitToFly), // 【修改】
              const SizedBox(width: 20),
              Radio<int>(
                value: 2,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  dataModel.instructionOption = value;
                  _chineseController.text =
                      t.referralInstructionChinese; // 【修改】
                  _englishController.text =
                      t.referralInstructionEnglish; // 【修改】
                  dataModel.update();
                },
              ),
              Text(t.referral), // 【修改】
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(AppTranslations t, CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.issueDateLabel)), // 【修改】
        Expanded(
          flex: 8,
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: dataModel.issueDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                dataModel.issueDate = picked;
                dataModel.update();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dataModel.issueDate != null
                        ? "${dataModel.issueDate!.year}-${dataModel.issueDate!.month.toString().padLeft(2, '0')}-${dataModel.issueDate!.day.toString().padLeft(2, '0')}"
                        : t.selectDate, // 【修改】
                    style: TextStyle(
                      color: dataModel.issueDate != null
                          ? Colors.black
                          : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
