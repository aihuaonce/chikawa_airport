// lib/NursingRecordPage.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/nursing_record_data.dart';
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
    try {
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('儲存護理記錄失敗: $e')));
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
    // 將每筆記錄物件轉換為 Map
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
                  const Text(
                    '護理記錄表',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildHeader(),
                  // 已新增的資料行
                  ...dataModel.nursingRecords.map(
                    (record) => _buildRecordRow(dataModel, record),
                  ),
                  _buildAddRowButton(dataModel),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F3F6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('紀錄時間', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text('紀錄', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('護理師姓名', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('護理師簽名', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 48), // 刪除按鈕的空間
        ],
      ),
    );
  }

  Widget _buildRecordRow(
    NursingRecordData dataModel,
    NursingRecordEntry record,
  ) {
    // 為每一行的 TextField 建立獨立的 Controller
    final timeController = TextEditingController(text: record.time);
    final recordController = TextEditingController(text: record.record);
    final nurseNameController = TextEditingController(text: record.nurseName);
    final nurseSignController = TextEditingController(text: record.nurseSign);

    // 監聽 TextField 的變化，並更新 Model
    timeController.addListener(() {
      record.time = timeController.text;
    });
    recordController.addListener(() {
      record.record = recordController.text;
    });
    nurseNameController.addListener(() {
      record.nurseName = nurseNameController.text;
    });
    nurseSignController.addListener(() {
      record.nurseSign = nurseSignController.text;
    });

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: _buildTextField(timeController, '時間')),
          Expanded(flex: 3, child: _buildTextField(recordController, '內容')),
          Expanded(flex: 2, child: _buildTextField(nurseNameController, '姓名')),
          Expanded(flex: 2, child: _buildTextField(nurseSignController, '簽名')),
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

  Widget _buildAddRowButton(NursingRecordData dataModel) {
    return InkWell(
      onTap: () => dataModel.addRecord(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: const Text(
          '＋ 加入資料行',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
