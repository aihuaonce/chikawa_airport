// lib/NursingRecordPage.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/nursing_record_data.dart';
import 'l10n/app_translations.dart';
import 'nav2.dart';

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

  final List<String> _nurses = [
    '陳思穎',
    '邱靜鈴',
    '莊漾媛',
    '洪豔',
    '范育婕',
    '陳簡妤',
    '蔡可萱',
    '粘瑞詩',
  ];

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

    // ✅ 正確做法：直接呼叫您在 dataModel 中定義好的新方法
    //    它會自動處理 JSON 轉換和資料庫操作
    await dataModel.saveToDatabase(widget.visitId, dao);
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
    return InkWell(
      onTap: () => _showAddRecordDialog(context, dataModel),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              t.addRow,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddRecordDialog(
    BuildContext context,
    NursingRecordData dataModel,
  ) async {
    final t = AppTranslations.of(context);
    // Dialog 內部的狀態變數
    final recordController = TextEditingController();
    final signatureController = TextEditingController();
    String? selectedNurse;
    String? selectedPhrase;
    final recordTime = DateTime.now();

    // 預設片語清單
    final List<String> presetPhrases = [
      t.phraseReceptionNotified,
      t.phraseNotification1,
      t.phraseNotification2,
      t.phraseNotification3,
      t.phraseArrivedAtScene,
      t.phraseBloodSugarTest,
      t.phraseDiagnosisAndMedication,
      t.phraseIssueCertificate,
      t.phraseReferral,
      t.phraseReferralHandover,
      t.phraseTransferNotification,
      t.phraseGeneralCustoms,
      t.phraseUrgentCustoms,
      t.phraseTransfer1,
      t.phraseTransfer2,
      t.phraseTransfer3,
      t.phraseBilling,
      t.phraseEndOfVisit,
      t.phraseReturnToStandby,
    ];

    // 根據片語產生紀錄文字的輔助函式
    String getPresetText(String phrase) {
      if (phrase == t.phraseReceptionNotified) {
        return '接獲[通報單位][通報人員]通報位於[事故地點]有旅客[主訴]身體不適，需要醫護出診協助。';
      }
      // 您可以在這裡為其他片語新增範本
      return phrase;
    }

    await showDialog(
      context: context,
      barrierDismissible: false, // 避免點擊外部關閉
      builder: (dialogContext) {
        // 使用 StatefulBuilder 來管理 Dialog 自己的 State
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.createNursingRecord),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // 寬一點
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- 紀錄時間 ---
                      _buildDialogStaticField(
                        t.recordTime,
                        DateFormat('yyyy年MM月dd日 HH時mm分ss秒').format(recordTime),
                      ),
                      const SizedBox(height: 16),

                      // --- 預設片語 ---
                      Text(
                        t.presetPhrase,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 0.0,
                        children: presetPhrases.map((phrase) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: phrase,
                                groupValue: selectedPhrase,
                                onChanged: (value) {
                                  setDialogState(() {
                                    selectedPhrase = value;
                                    recordController.text = getPresetText(
                                      value!,
                                    );
                                  });
                                },
                              ),
                              Text(phrase),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // --- 紀錄 ---
                      _buildDialogTextField(t.record, recordController, 5),
                      const SizedBox(height: 16),

                      // --- 護理師姓名 ---
                      _buildDialogSelector(
                        label: t.nurseName,
                        value: selectedNurse ?? t.clickToSelectNurse,
                        onTap: () async {
                          final result = await _showNurseSelectionDialog(
                            context,
                            t,
                          );
                          if (result != null) {
                            setDialogState(() => selectedNurse = result);
                          }
                        },
                        selectedNurse: selectedNurse,
                      ),
                      const SizedBox(height: 16),

                      // --- 護理師簽名 ---
                      _buildDialogTextField(
                        t.nurseSignature,
                        signatureController,
                        3,
                        hint: t.signatureStamp,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text(t.discard),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(t.saveAndAddAnother),
                  onPressed: () {
                    if (selectedNurse != null) {
                      final newRecord = NursingRecordEntry(
                        id: UniqueKey().toString(),
                        time: DateFormat('yyyy/MM/dd HH:mm').format(recordTime),
                        record: recordController.text,
                        nurseName: selectedNurse!,
                        nurseSign: signatureController.text,
                      );
                      dataModel.addRecord(newRecord);

                      // 重設 Dialog 以便新增下一筆
                      setDialogState(() {
                        recordController.clear();
                        signatureController.clear();
                        selectedPhrase = null;
                        selectedNurse = null;
                      });
                    }
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(t.saveAndClose),
                  onPressed: () {
                    if (selectedNurse != null) {
                      final newRecord = NursingRecordEntry(
                        id: UniqueKey().toString(),
                        time: DateFormat('yyyy/MM/dd HH:mm').format(recordTime),
                        record: recordController.text,
                        nurseName: selectedNurse!,
                        nurseSign: signatureController.text,
                      );
                      dataModel.addRecord(newRecord);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- Dialog 內部使用的小組件 ---

  Widget _buildDialogStaticField(String label, String value) {
    return Row(
      children: [
        Text('$label：', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _buildDialogTextField(
    String label,
    TextEditingController controller,
    int maxLines, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogSelector({
    required String label,
    required String value,
    required VoidCallback onTap,
    required String? selectedNurse,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: selectedNurse == null
                    ? Colors.grey.shade600
                    : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _showNurseSelectionDialog(
    BuildContext context,
    AppTranslations t,
  ) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(t.selectNurseDialogTitle),
          children: _nurses.map((nurse) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, nurse),
              child: Text(nurse),
            );
          }).toList(),
        );
      },
    );
  }
}
