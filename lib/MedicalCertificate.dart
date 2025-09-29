import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/certificate_data.dart';
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
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('儲存診斷證明失敗: $e')));
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
    await dao.upsertByVisitId(
      visitId: widget.visitId,
      diagnosis: dataModel.diagnosis,
      instructionOption: dataModel.instructionOption,
      chineseInstruction: dataModel.chineseInstruction,
      englishInstruction: dataModel.englishInstruction,
      issueDate: dataModel.issueDate,
    );
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
                    // ✨ 新增 SingleChildScrollView 解決溢位問題
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 讓卡片自適應內容高度
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDiagnosisInput(dataModel),
                        const SizedBox(height: 16),
                        _buildRadioRow(dataModel, "預設囑言片語："),
                        const SizedBox(height: 16),
                        _buildChineseInstructionInput(dataModel),
                        const SizedBox(height: 16),
                        _buildEnglishInstructionInput(dataModel),
                        const SizedBox(height: 16),
                        _buildDateRow(dataModel, "開立日期："),
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
      padding: const EdgeInsets.only(top: 8.0), // 增加上邊距讓標籤和輸入框頂部對齊
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

  Widget _buildDiagnosisInput(CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel("診斷：")),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _diagnosisController,
            maxLines: 3,
            decoration: _getInputDecoration("請輸入診斷"),
          ),
        ),
      ],
    );
  }

  Widget _buildChineseInstructionInput(CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel("中文囑言：")),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _chineseController,
            maxLines: 3,
            decoration: _getInputDecoration("請輸入中文囑言"),
          ),
        ),
      ],
    );
  }

  Widget _buildEnglishInstructionInput(CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel("英文囑言：")),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _englishController,
            maxLines: 3,
            decoration: _getInputDecoration(
              "Please enter English instructions",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioRow(CertificateData dataModel, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildLabel(label)),
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
                  String chineseText =
                      "病人於今日因上述False原因，接受本機場醫療中心緊急醫療出診，目前生命徵象穩定適宜飛行。(以下空白)";
                  String englishText =
                      "Due to above reasons, the patient received an outreach emergency medical. He/She is fit to fly.(Blank Below)";
                  dataModel.chineseInstruction = chineseText;
                  dataModel.englishInstruction = englishText;
                  _chineseController.text = chineseText; // 直接更新控制器
                  _englishController.text = englishText; // 直接更新控制器
                  dataModel.update();
                },
              ),
              const Text("適宜飛行"),
              const SizedBox(width: 20),
              Radio<int>(
                value: 2,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  dataModel.instructionOption = value;
                  String chineseText =
                      "病人於今日因上述False原因，接受本醫療中心緊急醫療出診，建議轉診至醫院進行進一步檢查及治療。(以下空白)";
                  String englishText =
                      "Due to above reasons, the patient received an outreach emergency medical. It is suggested to transfer to hospital for further evaluation and management.(Blank Below)";
                  dataModel.chineseInstruction = chineseText;
                  dataModel.englishInstruction = englishText;
                  _chineseController.text = chineseText; // 直接更新控制器
                  _englishController.text = englishText; // 直接更新控制器
                  dataModel.update();
                },
              ),
              const Text("轉診後送"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(CertificateData dataModel, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildLabel(label)),
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
                        : "選擇日期",
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
