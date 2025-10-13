// lib/NursingRecordPage.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/nursing_record_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
import 'nav2.dart'; // 為了使用 SavableStateMixin

class NursingRecordPage extends StatefulWidget {
  final int visitId;
  const NursingRecordPage({super.key, required this.visitId});

  @override
  State<NursingRecordPage> createState() => _NursingRecordPageState();
}

class _NursingRecordPageState extends State<NursingRecordPage>
    with
        AutomaticKeepAliveClientMixin<NursingRecordPage>,
        SavableStateMixin<NursingRecordPage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context); // 【新增】
    try {
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveNursingRecordFailed}$e')),
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
      final dao = context.read<NursingRecordsDao>();
      final dataModel = context.read<NursingRecordData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null && record.recordsJson != null) {
        final List<dynamic> decodedList = jsonDecode(record.recordsJson!);
        dataModel.nursingRecords = decodedList
            .map(
              (item) =>
                  NursingRecordEntry.fromMap(item as Map<String, dynamic>),
            )
            .toList();
      }
      dataModel.update();
    } catch (e) {
      // 錯誤處理
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<NursingRecordsDao>();
    final dataModel = context.read<NursingRecordData>();
    final recordsToSave = dataModel.nursingRecords
        .map((entry) => entry.toMap())
        .toList();
    await dao.upsertByVisitId(visitId: widget.visitId, records: recordsToSave);
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

    return Consumer<NursingRecordData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 900,
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nursingRecordForm, // 【修改】
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHeader(t), // 【修改】
                  ...dataModel.nursingRecords.map(
                    (record) => _buildRecordRow(t, dataModel, record), // 【修改】
                  ),
                  _buildAddRowButton(t, dataModel), // 【修改】
                ],
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

  Widget _buildHeader(AppTranslations t) {
    // 【修改】
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F3F6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              t.recordTime,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ), // 【修改】
          ),
          Expanded(
            flex: 3,
            child: Text(
              t.record,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ), // 【修改】
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.nurseName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ), // 【修改】
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.nurseSignature,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ), // 【修改】
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildRecordRow(
    AppTranslations t, // 【修改】
    NursingRecordData dataModel,
    NursingRecordEntry record,
  ) {
    final timeController = TextEditingController(text: record.time);
    final recordController = TextEditingController(text: record.record);
    final nurseNameController = TextEditingController(text: record.nurseName);
    final nurseSignController = TextEditingController(text: record.nurseSign);

    timeController.addListener(() => record.time = timeController.text);
    recordController.addListener(() => record.record = recordController.text);
    nurseNameController.addListener(
      () => record.nurseName = nurseNameController.text,
    );
    nurseSignController.addListener(
      () => record.nurseSign = nurseSignController.text,
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: _buildTextField(timeController, t.timeHint),
          ), // 【修改】
          Expanded(
            flex: 3,
            child: _buildTextField(recordController, t.contentHint),
          ), // 【修改】
          Expanded(
            flex: 2,
            child: _buildTextField(nurseNameController, t.nameHint),
          ), // 【修改】
          Expanded(
            flex: 2,
            child: _buildTextField(nurseSignController, t.signatureHint),
          ), // 【修改】
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => dataModel.removeRecord(record.id),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildAddRowButton(AppTranslations t, NursingRecordData dataModel) {
    // 【修改】
    return InkWell(
      onTap: () => dataModel.addRecord(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Text(
          t.addRow, // 【修改】
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
