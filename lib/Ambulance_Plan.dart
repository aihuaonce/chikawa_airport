import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:drift/drift.dart' show Value;

import 'nav5.dart';
import 'data/db/app_database.dart';

class AmbulancePlanPage extends StatefulWidget {
  final int visitId;
  const AmbulancePlanPage({super.key, required this.visitId});

  @override
  State<AmbulancePlanPage> createState() => _AmbulancePlanPageState();
}

class _AmbulancePlanPageState extends State<AmbulancePlanPage> {
  // --- 顏色定義 ---
  static const Color primaryLight = Color(0xFF83ACA9);
  static const Color primaryDark = Color(0xFF274C4A);
  static const Color white = Color(0xFFFFFFFF);

  // --- 選項列表 ---
  static const List<String> emergencyTreatmentOptions = [
    '呼吸道處置',
    '創傷處置',
    '搬運',
    '心肺復甦術',
    '藥物處置',
    '其他處置',
  ];
  static const List<String> airwayTreatmentOptions = [
    '口咽呼吸道',
    '鼻咽呼吸道',
    '抽吸',
    '哈姆立克法',
    '鼻管',
    '面罩',
    '非再呼吸型面罩',
    'BVM(正壓輔助呼吸)',
    'LMA',
    'Igel',
    '氣管內管',
    '其他',
  ];
  static const List<String> traumaTreatmentOptions = [
    '頸圈',
    '清洗傷口',
    '止血、包紮',
    '骨折固定',
    '長背板固定',
    '鏟式擔架固定',
    '其他',
  ];
  static const List<String> transportMethodOptions = ['自行上車', '以適當方式搬運'];
  static const List<String> cprMethodOptions = [
    '自動心肺復甦機',
    'CPR',
    '使用AED',
    '手動電擊器',
  ];
  static const List<String> medicationProcedureOptions = [
    '靜脈輸液',
    '口服葡萄糖液/粉',
    '協助使用Aspirin',
    '協助使用NTG',
    '協助使用支氣管擴張劑',
  ];
  static const List<String> otherEmergencyProcedureOptions = [
    '保暖',
    '心理支持',
    '約束帶',
    '拒絕使用氧氣',
    '生命徵象監測',
    '其他',
  ];

  // --- 文字控制器 ---
  final Map<String, TextEditingController> _controllers = {
    'guideController': TextEditingController(),
    'receivingUnitController': TextEditingController(),
    'contactNameController': TextEditingController(),
    'contactPhoneController': TextEditingController(),
    'bodyDiagramNoteController': TextEditingController(),
    'airwayOtherController': TextEditingController(),
    'traumaOtherController': TextEditingController(),
    'otherEmergencyOtherController': TextEditingController(),
    'ettSizeController': TextEditingController(),
    'ettDepthController': TextEditingController(),
    'manualDefibCountController': TextEditingController(),
    'manualDefibJoulesController': TextEditingController(),
    'rejectionNameController': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    final dataProvider = context.read<AmbulanceDataProvider>();
    final recordData = dataProvider.ambulanceRecordData;

    _controllers['guideController']!.text = recordData.guideNote.value ?? '';
    _controllers['receivingUnitController']!.text =
        recordData.receivingUnit.value ?? '';
    _controllers['contactNameController']!.text =
        recordData.contactName.value ?? '';
    _controllers['contactPhoneController']!.text =
        recordData.contactPhone.value ?? '';
    _controllers['bodyDiagramNoteController']!.text =
        recordData.bodyDiagramNote.value ?? '';
    _controllers['ettSizeController']!.text = recordData.ettSize.value ?? '';
    _controllers['ettDepthController']!.text = recordData.ettDepth.value ?? '';
    _controllers['manualDefibCountController']!.text =
        recordData.manualDefibCount.value ?? '';
    _controllers['manualDefibJoulesController']!.text =
        recordData.manualDefibJoules.value ?? '';
    _controllers['rejectionNameController']!.text =
        recordData.rejectionName.value ?? '';
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        final recordData = dataProvider.ambulanceRecordData;

        Map<String, bool> getJsonMap(Value<String> jsonValue) {
          try {
            return Map<String, bool>.from(jsonDecode(jsonValue.value));
          } catch (e) {
            return {};
          }
        }

        final emergencyTreatments = getJsonMap(
          recordData.emergencyTreatmentsJson,
        );

        return Container(
          color: const Color(0xFFF5F5F5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('急救處置'),
                const SizedBox(height: 12),
                _buildCheckboxGroup(
                  dataProvider,
                  'emergencyTreatmentsJson',
                  emergencyTreatmentOptions,
                ),
                const SizedBox(height: 20),

                if (emergencyTreatments['呼吸道處置'] == true)
                  _buildAirwayOptions(dataProvider),
                if (emergencyTreatments['創傷處置'] == true)
                  _buildTraumaOptions(dataProvider),
                if (emergencyTreatments['搬運'] == true)
                  _buildTransportOptions(dataProvider),
                if (emergencyTreatments['心肺復甦術'] == true)
                  _buildCprOptions(dataProvider),
                if (emergencyTreatments['藥物處置'] == true)
                  _buildMedicationOptions(dataProvider),
                if (emergencyTreatments['其他處置'] == true)
                  _buildOtherEmergencyOptions(dataProvider),

                _buildSectionHeader('人形圖'),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryLight),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.add_circle_outline,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('開啟人形圖編輯功能')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDark,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('點擊按鈕開始編輯人形圖'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: '人形圖備註',
                  controller: _controllers['bodyDiagramNoteController']!,
                  hint: '請填寫備註內容',
                  onChanged: (val) => dataProvider.updateAmbulanceRecord(
                    recordData.copyWith(bodyDiagramNote: Value(val)),
                  ),
                ),
                const SizedBox(height: 20),

                _buildMedicationTable(context, dataProvider),
                const SizedBox(height: 20),

                _buildASLSection(dataProvider),
                const SizedBox(height: 12),

                _buildTextField(
                  label: '線上指導醫師指導說明',
                  controller: _controllers['guideController']!,
                  hint: '請填寫指導說明',
                  onChanged: (val) => dataProvider.updateAmbulanceRecord(
                    recordData.copyWith(guideNote: Value(val)),
                  ),
                ),
                const SizedBox(height: 20),

                _buildVitalSignsTable(context, dataProvider),
                const SizedBox(height: 20),

                _buildParamedicTable(context, dataProvider),
                const SizedBox(height: 20),

                _buildTextField(
                  label: '接收單位',
                  controller: _controllers['receivingUnitController']!,
                  hint: '請填寫接收單位',
                  onChanged: (val) => dataProvider.updateAmbulanceRecord(
                    recordData.copyWith(receivingUnit: Value(val)),
                  ),
                ),
                const SizedBox(height: 12),

                _buildReceivingTime(dataProvider),
                const SizedBox(height: 12),

                _buildRejectionSection(dataProvider),
                const SizedBox(height: 12),

                _buildRelationshipSection(dataProvider),
                const SizedBox(height: 12),

                _buildTextField(
                  label: '關係人姓名',
                  controller: _controllers['contactNameController']!,
                  hint: '請填寫關係人的姓名',
                  onChanged: (val) => dataProvider.updateAmbulanceRecord(
                    recordData.copyWith(contactName: Value(val)),
                  ),
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  label: '關係人連絡電話',
                  controller: _controllers['contactPhoneController']!,
                  hint: '請填寫關係人的連絡電話',
                  onChanged: (val) => dataProvider.updateAmbulanceRecord(
                    recordData.copyWith(contactPhone: Value(val)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- UI 小積木 ---

  Widget _buildSectionHeader(String title) => Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: (newValue) => onChanged(newValue ?? false),
        activeColor: primaryDark,
      ),
      Text(label),
    ],
  );

  Widget _buildCheckboxGroup(
    AmbulanceDataProvider provider,
    String fieldName,
    List<String> options,
  ) {
    Map<String, bool> getJsonMap(Value<String> jsonValue) {
      try {
        return Map<String, bool>.from(jsonDecode(jsonValue.value));
      } catch (e) {
        return {};
      }
    }

    // 根據欄位名稱選擇對應的 JSON 欄位
    Value<String> jsonValue;
    switch (fieldName) {
      case 'emergencyTreatmentsJson':
        jsonValue = provider.ambulanceRecordData.emergencyTreatmentsJson;
        break;
      case 'airwayTreatmentsJson':
        jsonValue = provider.ambulanceRecordData.airwayTreatmentsJson;
        break;
      case 'traumaTreatmentsJson':
        jsonValue = provider.ambulanceRecordData.traumaTreatmentsJson;
        break;
      case 'transportMethodsJson':
        jsonValue = provider.ambulanceRecordData.transportMethodsJson;
        break;
      case 'cprMethodsJson':
        jsonValue = provider.ambulanceRecordData.cprMethodsJson;
        break;
      case 'medicationProceduresJson':
        jsonValue = provider.ambulanceRecordData.medicationProceduresJson;
        break;
      case 'otherEmergencyProceduresJson':
        jsonValue = provider.ambulanceRecordData.otherEmergencyProceduresJson;
        break;
      default:
        jsonValue = const Value('{}');
    }

    final currentMap = getJsonMap(jsonValue);

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: options
          .map(
            (option) => _buildCheckbox(
              label: option,
              value: currentMap[option] ?? false,
              // ✅ 改呼叫 updateJsonSet
              onChanged: (newValue) =>
                  provider.updateJsonSet(fieldName, option, newValue),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: primaryLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: primaryLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: primaryDark, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableCheckboxSection(
    AmbulanceDataProvider provider,
    String title,
    String fieldName,
    List<String> options,
    String? otherControllerKey,
  ) {
    Map<String, bool> getJsonMap(Value<String> jsonValue) {
      try {
        return Map<String, bool>.from(jsonDecode(jsonValue.value));
      } catch (e) {
        return {};
      }
    }

    // 同樣直接選擇對應的欄位
    Value<String> jsonValue;
    switch (fieldName) {
      case 'airwayTreatmentsJson':
        jsonValue = provider.ambulanceRecordData.airwayTreatmentsJson;
        break;
      case 'traumaTreatmentsJson':
        jsonValue = provider.ambulanceRecordData.traumaTreatmentsJson;
        break;
      case 'transportMethodsJson':
        jsonValue = provider.ambulanceRecordData.transportMethodsJson;
        break;
      case 'cprMethodsJson':
        jsonValue = provider.ambulanceRecordData.cprMethodsJson;
        break;
      case 'medicationProceduresJson':
        jsonValue = provider.ambulanceRecordData.medicationProceduresJson;
        break;
      case 'otherEmergencyProceduresJson':
        jsonValue = provider.ambulanceRecordData.otherEmergencyProceduresJson;
        break;
      default:
        jsonValue = const Value('{}');
    }

    final currentMap = getJsonMap(jsonValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 8),
        _buildCheckboxGroup(provider, fieldName, options),
        if (otherControllerKey != null && currentMap['其他'] == true)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildTextField(
              label: '其他',
              controller: _controllers[otherControllerKey]!,
              hint: '請填寫其他的處置',
              onChanged: (val) {
                // 這裡可補上對應更新邏輯
              },
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAirwayOptions(AmbulanceDataProvider provider) =>
      _buildExpandableCheckboxSection(
        provider,
        '呼吸道處置',
        'airwayTreatmentsJson',
        airwayTreatmentOptions,
        'airwayOtherController',
      );

  Widget _buildTraumaOptions(AmbulanceDataProvider provider) =>
      _buildExpandableCheckboxSection(
        provider,
        '創傷處置',
        'traumaTreatmentsJson',
        traumaTreatmentOptions,
        'traumaOtherController',
      );

  Widget _buildTransportOptions(AmbulanceDataProvider provider) =>
      _buildExpandableCheckboxSection(
        provider,
        '搬運',
        'transportMethodsJson',
        transportMethodOptions,
        null,
      );

  Widget _buildCprOptions(AmbulanceDataProvider provider) =>
      _buildExpandableCheckboxSection(
        provider,
        '心肺復甦術',
        'cprMethodsJson',
        cprMethodOptions,
        null,
      );

  Widget _buildMedicationOptions(AmbulanceDataProvider provider) =>
      _buildExpandableCheckboxSection(
        provider,
        '藥物處置',
        'medicationProceduresJson',
        medicationProcedureOptions,
        null,
      );

  Widget _buildOtherEmergencyOptions(AmbulanceDataProvider provider) =>
      _buildExpandableCheckboxSection(
        provider,
        '急救-其他處置',
        'otherEmergencyProceduresJson',
        otherEmergencyProcedureOptions,
        'otherEmergencyOtherController',
      );

  Widget _buildASLSection(AmbulanceDataProvider provider) {
    final recordData = provider.ambulanceRecordData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 120,
              child: Text(
                'ASL處理',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            _buildCheckbox(
              label: '氣管內管',
              value: recordData.aslType.value == '氣管內管',
              onChanged: (v) {
                provider.updateAmbulanceRecord(
                  recordData.copyWith(aslType: Value(v ? '氣管內管' : null)),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildCheckbox(
              label: '手動電擊',
              value: recordData.aslType.value == '手動電擊',
              onChanged: (v) {
                provider.updateAmbulanceRecord(
                  recordData.copyWith(aslType: Value(v ? '手動電擊' : null)),
                );
              },
            ),
          ],
        ),
        if (recordData.aslType.value == '氣管內管')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                _buildTextField(
                  label: '氣管內管號碼',
                  controller: _controllers['ettSizeController']!,
                  hint: '請填寫氣管內管號碼',
                  onChanged: (v) => provider.updateAmbulanceRecord(
                    recordData.copyWith(ettSize: Value(v)),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: '氣管內管固定公分數(cm)',
                  controller: _controllers['ettDepthController']!,
                  hint: '請填寫固定公分數(cm)',
                  onChanged: (v) => provider.updateAmbulanceRecord(
                    recordData.copyWith(ettDepth: Value(v)),
                  ),
                ),
              ],
            ),
          ),
        if (recordData.aslType.value == '手動電擊')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                _buildTextField(
                  label: '手動電擊次數',
                  controller: _controllers['manualDefibCountController']!,
                  hint: '請填寫手動電擊次數',
                  onChanged: (v) => provider.updateAmbulanceRecord(
                    recordData.copyWith(manualDefibCount: Value(v)),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: '手動電擊焦耳數',
                  controller: _controllers['manualDefibJoulesController']!,
                  hint: '請填寫手動電擊焦耳數',
                  onChanged: (v) => provider.updateAmbulanceRecord(
                    recordData.copyWith(manualDefibJoules: Value(v)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReceivingTime(AmbulanceDataProvider provider) {
    final recordData = provider.ambulanceRecordData;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 120,
            child: Text('接收時間', style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            DateFormat(
              'yyyy年MM月dd日 HH時mm分',
            ).format(recordData.receivingTime.value ?? DateTime.now()),
            style: const TextStyle(fontSize: 15),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => provider.updateAmbulanceRecord(
              recordData.copyWith(receivingTime: Value(DateTime.now())),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('更新時間'),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionSection(AmbulanceDataProvider provider) {
    final recordData = provider.ambulanceRecordData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 120,
              child: Text(
                '是否拒絕送醫',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Radio<bool>(
              value: false,
              groupValue: recordData.isRejection.value,
              onChanged: (v) => provider.updateAmbulanceRecord(
                recordData.copyWith(isRejection: Value(v!)),
              ),
              activeColor: primaryDark,
            ),
            const Text('否'),
            const SizedBox(width: 16),
            Radio<bool>(
              value: true,
              groupValue: recordData.isRejection.value,
              onChanged: (v) => provider.updateAmbulanceRecord(
                recordData.copyWith(isRejection: Value(v!)),
              ),
              activeColor: primaryDark,
            ),
            const Text('是'),
          ],
        ),
        if (recordData.isRejection.value == true)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEFE3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '拒絕醫療聲明:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('本人聲明,救護人員以解釋病情與送醫之需要,但我拒絕救護與送醫。'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('姓名:'),
                    Expanded(
                      child: TextField(
                        controller: _controllers['rejectionNameController']!,
                        decoration: const InputDecoration(
                          hintText: '請填寫姓名',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (val) => provider.updateAmbulanceRecord(
                          recordData.copyWith(rejectionName: Value(val)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRelationshipSection(AmbulanceDataProvider provider) {
    final recordData = provider.ambulanceRecordData;
    return Row(
      children: [
        const SizedBox(
          width: 120,
          child: Text('關係人身分', style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        Radio<String>(
          value: '病患',
          groupValue: recordData.relationshipType.value,
          onChanged: (v) => provider.updateAmbulanceRecord(
            recordData.copyWith(relationshipType: Value(v)),
          ),
          activeColor: primaryDark,
        ),
        const Text('病患'),
        const SizedBox(width: 16),
        Radio<String>(
          value: '家屬',
          groupValue: recordData.relationshipType.value,
          onChanged: (v) => provider.updateAmbulanceRecord(
            recordData.copyWith(relationshipType: Value(v)),
          ),
          activeColor: primaryDark,
        ),
        const Text('家屬'),
        const SizedBox(width: 16),
        Radio<String>(
          value: '關係人',
          groupValue: recordData.relationshipType.value,
          onChanged: (v) => provider.updateAmbulanceRecord(
            recordData.copyWith(relationshipType: Value(v)),
          ),
          activeColor: primaryDark,
        ),
        const Text('關係人'),
      ],
    );
  }

  // --- 動態表格 ---

  Widget _buildMedicationTable(
    BuildContext context,
    AmbulanceDataProvider provider,
  ) {
    final records = provider.medicationRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('給藥紀錄表'),
        const SizedBox(height: 8),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primaryLight),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border(bottom: BorderSide(color: primaryLight)),
                ),
                child: const Row(
                  children: [
                    Expanded(child: Text('時間', textAlign: TextAlign.center)),
                    Expanded(child: Text('藥名', textAlign: TextAlign.center)),
                    Expanded(child: Text('途徑', textAlign: TextAlign.center)),
                    Expanded(child: Text('劑量', textAlign: TextAlign.center)),
                    Expanded(child: Text('執行者', textAlign: TextAlign.center)),
                  ],
                ),
              ),
              ...records.map(
                (record) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          record.recordTime != null
                              ? DateFormat('HH:mm').format(record.recordTime!)
                              : '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.name ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.route ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.dose ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.executor ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  final result = await _showMedicationDialog(context);
                  if (result != null) {
                    await provider.addMedicationRecord(result);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFF5F5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: primaryDark, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '加入資料行',
                        style: TextStyle(
                          color: primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignsTable(
    BuildContext context,
    AmbulanceDataProvider provider,
  ) {
    final records = provider.vitalSignsRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('生命徵象紀錄表'),
        const SizedBox(height: 8),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primaryLight),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border(bottom: BorderSide(color: primaryLight)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '時間',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '意識',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '體溫',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '脈搏',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '呼吸',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '血壓',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '血氧',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'GCS',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              ...records.map(
                (record) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          record.recordTime != null
                              ? DateFormat('HH:mm').format(record.recordTime!)
                              : '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.consciousness ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.temperature ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.pulse ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.respiration ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.bloodPressure ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.spo2 ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          record.gcs ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  final result = await _showVitalSignsDialog(context);
                  if (result != null) {
                    await provider.addVitalSignsRecord(result);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFF5F5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: primaryDark, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '加入資料行',
                        style: TextStyle(
                          color: primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParamedicTable(
    BuildContext context,
    AmbulanceDataProvider provider,
  ) {
    final records = provider.paramedicRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('隨車救護人員紀錄表'),
        const SizedBox(height: 8),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primaryLight),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border(bottom: BorderSide(color: primaryLight)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('姓名', textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('簽名', textAlign: TextAlign.center),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              ...records.map(
                (record) => Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          record.name ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.grey.shade100,
                          ),
                          child: record.signature == null
                              ? const Center(
                                  child: Text(
                                    '無簽名',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : Image.memory(
                                  record.signature!,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await provider.deleteParamedicRecord(record.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  final result = await _showParamedicDialog(context);
                  if (result != null) {
                    await provider.addParamedicRecord(result);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFF5F5F5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: primaryDark, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '加入資料行',
                        style: TextStyle(
                          color: primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 對話框 ---

  Future<MedicationRecordsCompanion?> _showMedicationDialog(
    BuildContext context,
  ) async {
    DateTime recordTime = DateTime.now();
    final nameController = TextEditingController();
    final routeController = TextEditingController();
    final doseController = TextEditingController();
    final executorController = TextEditingController();

    return await showDialog<MedicationRecordsCompanion>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('創建 藥物紀錄'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDialogRow(
                      '紀錄時間',
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              'yyyy年MM月dd日 HH時mm分ss秒',
                            ).format(recordTime),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => recordTime = DateTime.now()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('更新時間'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDialogInput('藥名', nameController, '請輸入藥名'),
                    const SizedBox(height: 8),
                    _buildDialogInput('途徑', routeController, '請輸入途徑'),
                    const SizedBox(height: 8),
                    _buildDialogInput('劑量', doseController, '請輸入劑量'),
                    const SizedBox(height: 8),
                    _buildDialogInput('執行者', executorController, '請輸入執行者'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('捨棄'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final companion = MedicationRecordsCompanion.insert(
                        visitId: widget.visitId,
                        recordTime: Value(recordTime),
                        name: Value(nameController.text),
                        route: Value(routeController.text),
                        dose: Value(doseController.text),
                        executor: Value(executorController.text),
                      );
                      Navigator.pop(context, companion);
                    }
                  },
                  child: const Text('儲存並關閉'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<VitalSignsRecordsCompanion?> _showVitalSignsDialog(
    BuildContext context,
  ) async {
    DateTime recordTime = DateTime.now();
    bool atHospital = false;
    String? consciousness = '清';

    final triageController = TextEditingController();
    final tempController = TextEditingController();
    final pulseController = TextEditingController();
    final respController = TextEditingController();
    final bpController = TextEditingController();
    final spo2Controller = TextEditingController();
    final gcsEController = TextEditingController();
    final gcsVController = TextEditingController();
    final gcsMController = TextEditingController();

    return await showDialog<VitalSignsRecordsCompanion>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('創建 生命徵象紀錄'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDialogRow(
                      '紀錄時間',
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              'yyyy年MM月dd日 HH時mm分ss秒',
                            ).format(recordTime),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => recordTime = DateTime.now()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('更新時間'),
                          ),
                        ],
                      ),
                    ),
                    _buildDialogRow(
                      '是否抵達醫院後',
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: atHospital,
                            onChanged: (v) => setState(() => atHospital = v!),
                          ),
                          const Text('是'),
                          Radio<bool>(
                            value: false,
                            groupValue: atHospital,
                            onChanged: (v) => setState(() => atHospital = v!),
                          ),
                          const Text('否'),
                        ],
                      ),
                    ),
                    _buildDialogRow(
                      '檢傷站',
                      Expanded(
                        child: _buildDialogTextField(triageController, '請填寫'),
                      ),
                    ),
                    _buildDialogRow(
                      '意識情況',
                      Row(
                        children: [
                          Radio<String>(
                            value: '清',
                            groupValue: consciousness,
                            onChanged: (v) => setState(() => consciousness = v),
                          ),
                          const Text('清'),
                          Radio<String>(
                            value: '聲',
                            groupValue: consciousness,
                            onChanged: (v) => setState(() => consciousness = v),
                          ),
                          const Text('聲'),
                          Radio<String>(
                            value: '痛',
                            groupValue: consciousness,
                            onChanged: (v) => setState(() => consciousness = v),
                          ),
                          const Text('痛'),
                          Radio<String>(
                            value: '否',
                            groupValue: consciousness,
                            onChanged: (v) => setState(() => consciousness = v),
                          ),
                          const Text('否'),
                        ],
                      ),
                    ),
                    _buildDialogRow(
                      '體溫(°C)',
                      Expanded(
                        child: _buildDialogTextField(tempController, '請填寫體溫度數'),
                      ),
                    ),
                    _buildDialogRow(
                      '脈搏(次/min)',
                      Expanded(
                        child: _buildDialogTextField(
                          pulseController,
                          '請填寫脈搏次數',
                        ),
                      ),
                    ),
                    _buildDialogRow(
                      '呼吸(次/min)',
                      Expanded(
                        child: _buildDialogTextField(respController, '請填寫呼吸次數'),
                      ),
                    ),
                    _buildDialogRow(
                      '血壓(mmHg)',
                      Expanded(
                        child: _buildDialogTextField(bpController, '請填寫血壓數值'),
                      ),
                    ),
                    _buildDialogRow(
                      '血氧(%)',
                      Expanded(
                        child: _buildDialogTextField(spo2Controller, '請填寫血氧濃度'),
                      ),
                    ),
                    _buildDialogRow(
                      'GCS-E',
                      Expanded(
                        child: _buildDialogTextField(gcsEController, '請填寫'),
                      ),
                    ),
                    _buildDialogRow(
                      'GCS-V',
                      Expanded(
                        child: _buildDialogTextField(gcsVController, '請填寫'),
                      ),
                    ),
                    _buildDialogRow(
                      'GCS-M',
                      Expanded(
                        child: _buildDialogTextField(gcsMController, '請填寫'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('捨棄'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final gcsE = int.tryParse(gcsEController.text) ?? 0;
                    final gcsV = int.tryParse(gcsVController.text) ?? 0;
                    final gcsM = int.tryParse(gcsMController.text) ?? 0;
                    final gcsTotal = gcsE + gcsV + gcsM;

                    final companion = VitalSignsRecordsCompanion.insert(
                      visitId: widget.visitId,
                      recordTime: Value(recordTime),
                      atHospital: Value(atHospital),
                      triageStation: Value(triageController.text),
                      consciousness: Value(consciousness),
                      temperature: Value(tempController.text),
                      pulse: Value(pulseController.text),
                      respiration: Value(respController.text),
                      bloodPressure: Value(bpController.text),
                      spo2: Value(spo2Controller.text),
                      gcs: Value(
                        gcsTotal > 0
                            ? '$gcsTotal (E${gcsE}V${gcsV}M${gcsM})'
                            : null,
                      ),
                    );
                    Navigator.pop(context, companion);
                  },
                  child: const Text('儲存並關閉'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<ParamedicRecordsCompanion?> _showParamedicDialog(
    BuildContext context,
  ) async {
    final nameController = TextEditingController();
    Uint8List? signatureBytes;
    final signatureController = SignatureController(
      penStrokeWidth: 3.0,
      penColor: Colors.black,
    );

    return await showDialog<ParamedicRecordsCompanion>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('創建 隨車救護人員記錄'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Text(
                            '姓名',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: '請輸入姓名',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Text(
                            '簽名',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final bytes = await _showSignatureDialog(
                                context,
                                signatureController,
                              );
                              if (bytes != null) {
                                setState(() {
                                  signatureBytes = bytes;
                                });
                              }
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                              child: signatureBytes == null
                                  ? const Center(
                                      child: Text(
                                        '點此簽章',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : Image.memory(
                                      signatureBytes!,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    signatureController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text('捨棄'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final companion = ParamedicRecordsCompanion.insert(
                        visitId: widget.visitId,
                        name: Value(nameController.text),
                        signature: Value(signatureBytes),
                      );
                      signatureController.dispose();
                      Navigator.pop(context, companion);
                    }
                  },
                  child: const Text('儲存並關閉'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Uint8List?> _showSignatureDialog(
    BuildContext context,
    SignatureController controller,
  ) async {
    controller.clear();

    return await showDialog<Uint8List>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('請在下方簽名'),
          content: SizedBox(
            width: 300,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Signature(
                controller: controller,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.clear();
              },
              child: const Text('清除'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.isNotEmpty) {
                  final bytes = await controller.toPngBytes();
                  Navigator.pop(context, bytes);
                }
              },
              child: const Text('採納並簽署'),
            ),
          ],
        );
      },
    );
  }

  // --- 對話框輔助 Widget ---

  Widget _buildDialogRow(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildDialogInput(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }
}
