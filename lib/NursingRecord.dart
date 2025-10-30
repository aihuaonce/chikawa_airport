// lib/NursingRecordPage.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/db/app_database.dart'; // 導入 AppDatabase 以取得資料模型
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
    final t = AppTranslations.of(context);
    try {
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveNursingRecordFailed}$e')),
        );
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
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<NursingRecordData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.nursingRecordForm,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildHeader(t),
                    ...dataModel.nursingRecords.map(
                      (record) => _buildRecordRow(t, dataModel, record),
                    ),
                    _buildAddRowButton(t, dataModel),
                  ],
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

  Widget _buildHeader(AppTranslations t) {
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
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              t.record,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.nurseName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.nurseSignature,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildRecordRow(
    AppTranslations t,
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
          Expanded(flex: 2, child: _buildTextField(timeController, t.timeHint)),
          Expanded(
            flex: 3,
            child: _buildTextField(recordController, t.contentHint),
          ),
          Expanded(
            flex: 2,
            child: _buildTextField(nurseNameController, t.nameHint),
          ),
          Expanded(
            flex: 2,
            child: _buildTextField(nurseSignController, t.signatureHint),
          ),
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
            const Icon(Icons.add, color: Colors.blue),
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

    // ==================== ✅ 1. 讀取資料庫 ====================
    final accidentRecordsDao = context.read<AccidentRecordsDao>();
    final treatmentsDao = context.read<TreatmentsDao>();
    final medicalCostsDao = context.read<MedicalCostsDao>();

    // 使用 visitId 取得相關紀錄
    final accidentRecord = await accidentRecordsDao.getByVisitId(
      widget.visitId,
    );
    final treatment = await treatmentsDao.getByVisitId(widget.visitId);
    final medicalCost = await medicalCostsDao.getByVisitId(widget.visitId);
    // =========================================================

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

    // ==================== ✅ 2. 修改 getPresetText 函式 ====================
    // 根據片語產生紀錄文字的輔助函式，現在接收資料庫模型作為參數
    String getPresetText(
      String phrase,
      AccidentRecord? accidentRecord,
      Treatment? treatment,
      MedicalCost? medicalCost,
    ) {
      // Helper function to safely get string value or placeholder
      String val(String? value, String placeholder) {
        return (value != null && value.isNotEmpty) ? value : placeholder;
      }

      if (phrase == t.phraseReceptionNotified) {
        return '接獲${val(accidentRecord?.reportUnitIdx?.toString(), '[通報單位]')}${val(accidentRecord?.notifier, '[通報人員]')}通報位於${val(accidentRecord?.placeGroup, '')}${val(accidentRecord?.placeDetail, '[事故地點]')}有旅客${val(treatment?.symptomNote, '[主訴]')}身體不適，需要醫護出診協助。';
      } else if (phrase == t.phraseNotification1) {
        return '通知T1-OCC。';
      } else if (phrase == t.phraseNotification2) {
        return '通知T2-OCC。';
      } else if (phrase == t.phraseNotification3) {
        return '通知另外航廈醫護及EMT請求支援。';
      } else if (phrase == t.phraseArrivedAtScene) {
        return '抵達現場，病人意識清楚，坐在椅子上/坐在機艙內/躺在地上，測量生命徵象體溫${val(treatment?.temperature, '[體溫]')}度、脈搏${val(treatment?.pulse, '[脈搏]')}次/分、呼吸${val(treatment?.respiration, '[呼吸]')}次/分、血壓${val(treatment?.bpSystolic, '[血壓收縮壓]')}/${val(treatment?.bpDiastolic, '[血壓舒張壓]')}mmHg、血氧${val(treatment?.spo2, '[血氧飽和度]')}%，自述撕裂傷，醫師診療評估中。';
      } else if (phrase == t.phraseBloodSugarTest) {
        // 使用 sugarReading 欄位
        return '依醫囑執行測血糖${val(treatment?.sugarReading, '[血糖值]')}。';
      } else if (phrase == t.phraseDiagnosisAndMedication) {
        return '醫師診視後，診斷為${val(treatment?.initialDiagnosis, '[初步診斷]')}，向病人解釋後開立${val(treatment?.prescriptionRowsJson, '[藥物]')}使用並衛教。';
      } else if (phrase == t.phraseIssueCertificate) {
        return '開立中文診斷書。';
      } else if (phrase == t.phraseReferral) {
        return '醫師診視後，診斷為${val(treatment?.initialDiagnosis, '[初步診斷]')}，建議轉診至醫院進一步檢查及治療，醫師跟病人及家屬解釋後，表示同意，通知航空公司協助退關/入境後送事宜。';
      } else if (phrase == t.phraseReferralHandover) {
        return '協助醫師打電話至${val(treatment?.referralHospital?.toString(), '[交班單位]')}電話交班。';
      } else if (phrase == t.phraseTransferNotification) {
        return '通知救護車EMT，病人需後送至${val(treatment?.referralHospital?.toString(), '[轉送醫院]')}，請其待命等候病人入關。';
      } else if (phrase == t.phraseGeneralCustoms) {
        return '現由航勤人員協助推輪椅，陪同病人通關。';
      } else if (phrase == t.phraseUrgentCustoms) {
        return '由醫師判斷病人診斷為${val(treatment?.initialDiagnosis, '[初步診斷]')}，由於情況危急，需採緊急機坪通關，告知現場航空公司地勤，請其協助聯繫相關單位。';
      } else if (phrase == t.phraseTransfer1) {
        return '抵達醫療中心/北空橋，協助更換至擔架上。';
      } else if (phrase == t.phraseTransfer2) {
        return '出發前往${val(treatment?.referralHospital?.toString(), '[轉送醫院]')}';
      } else if (phrase == t.phraseTransfer3) {
        return '抵達${val(treatment?.referralHospital?.toString(), '[轉送醫院]')}急診，與急診檢傷護理師交班。';
      } else if (phrase == t.phraseBilling) {
        // 安全地加總費用
        final visitFee = double.tryParse(medicalCost?.visitFee ?? '0') ?? 0;
        final ambulanceFee =
            double.tryParse(medicalCost?.ambulanceFee ?? '0') ?? 0;
        final totalFee = visitFee + ambulanceFee;
        final feeString = totalFee > 0 ? totalFee.toStringAsFixed(0) : '[費用]';
        return '向病人及家屬解釋出診費用${feeString}元，病人表示了解及接受並採${val(medicalCost?.chargeMethod, '[支付方式]')}支付，並請其簽名，開立中文/英文收據一份。';
      } else if (phrase == t.phraseEndOfVisit) {
        return '收拾用物，結束出診。';
      } else if (phrase == t.phraseReturnToStandby) {
        return '返回醫療中心待命。';
      } else {
        return phrase;
      }
    }
    // ====================================================================

    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF83ACA9),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // 使用 StatefulBuilder 來管理 Dialog 自己的 State
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.createNursingRecord),
              backgroundColor: Colors.white,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
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
                                activeColor: const Color(0xFF274C4A),
                                onChanged: (value) {
                                  setDialogState(() {
                                    selectedPhrase = value;
                                    // ==================== ✅ 3. 傳入資料以產生文字 ====================
                                    recordController.text = getPresetText(
                                      value!,
                                      accidentRecord,
                                      treatment,
                                      medicalCost,
                                    );
                                    // =================================================================
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
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF83ACA9),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: actionButtonStyle,
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
                      _saveData();

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
                  style: actionButtonStyle,
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
                      _saveData();
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
