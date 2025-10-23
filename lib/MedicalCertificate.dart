// MedicalCertificatePage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/certificate_data.dart';
import 'l10n/app_translations.dart';
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

  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${t.saveCertificateFailed}$e')));
      }
      rethrow;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

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
                        _buildDiagnosisInput(t, dataModel),
                        const SizedBox(height: 16),
                        _buildRadioRow(t, dataModel),
                        const SizedBox(height: 16),
                        _buildChineseInstructionInput(t, dataModel),
                        const SizedBox(height: 16),
                        _buildEnglishInstructionInput(t, dataModel),
                        const SizedBox(height: 16),
                        _buildDateRow(t, dataModel),
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
        Expanded(flex: 2, child: _buildLabel(t.diagnosisLabel)),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _diagnosisController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterDiagnosisHint),
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
        Expanded(flex: 2, child: _buildLabel(t.chineseInstructionLabel)),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _chineseController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterChineseInstructionHint),
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
        Expanded(flex: 2, child: _buildLabel(t.englishInstructionLabel)),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _englishController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterEnglishInstructionHint),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioRow(AppTranslations t, CertificateData dataModel) {
    // ✅ 輔助函式，用來更新文字和狀態
    void updateInstructions({
      required int option,
      required String chineseTemplate,
      required String englishTemplate,
    }) {
      dataModel.instructionOption = option;

      // 1. 從 Controller 獲取診斷文字，如果為空，則使用預留位置
      String diagnosis = _diagnosisController.text.trim();
      if (diagnosis.isEmpty) {
        diagnosis = t.diagnosisPlaceholder; // e.g., "[請填寫診斷]"
      }

      // 2. 使用 replaceAll 將模板中的 {diagnosis} 替換掉
      final newChineseText = chineseTemplate.replaceAll(
        '{diagnosis}',
        diagnosis,
      );
      final newEnglishText = englishTemplate.replaceAll(
        '{diagnosis}',
        diagnosis,
      );

      // 3. 更新對應的文字輸入框
      _chineseController.text = newChineseText;
      _englishController.text = newEnglishText;

      // 4. 通知 Provider 資料已更新
      dataModel.update();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.defaultInstructionPhrase)),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  // ✅ 調用我們的新輔助函式
                  updateInstructions(
                    option: value!,
                    chineseTemplate: t.fitToFlyInstructionChinese,
                    englishTemplate: t.fitToFlyInstructionEnglish,
                  );
                },
              ),
              Text(t.fitToFly),
              const SizedBox(width: 20),
              Radio<int>(
                value: 2,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  // ✅ 調用我們的新輔-助函式
                  updateInstructions(
                    option: value!,
                    chineseTemplate: t.referralInstructionChinese,
                    englishTemplate: t.referralInstructionEnglish,
                  );
                },
              ),
              Text(t.referral),
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
        Expanded(flex: 2, child: _buildLabel(t.issueDateLabel)),
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
                        : t.selectDate,
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
