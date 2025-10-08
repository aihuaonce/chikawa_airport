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

class _AmbulancePlanPageState extends State<AmbulancePlanPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  // 選項列表
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

  // 本地 UI 狀態
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

  Map<String, bool> _emergencyTreatments = {};
  Map<String, bool> _airwayTreatments = {};
  Map<String, bool> _traumaTreatments = {};
  Map<String, bool> _transportMethods = {};
  Map<String, bool> _cprMethods = {};
  Map<String, bool> _medicationProcedures = {};
  Map<String, bool> _otherEmergencyProcedures = {};

  String? _aslType;
  bool? _isRejection;
  String? _relationshipType;
  DateTime? _receivingTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Map<String, bool> _jsonToMap(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map) {
        return Map<String, bool>.from(
          decoded.map((key, value) => MapEntry(key.toString(), value as bool)),
        );
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  void _loadInitialData() {
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
    _controllers['airwayOtherController']!.text =
        recordData.airwayOther.value ?? '';
    _controllers['traumaOtherController']!.text =
        recordData.traumaOther.value ?? '';
    _controllers['otherEmergencyOtherController']!.text =
        recordData.otherEmergencyOther.value ?? '';
    _controllers['ettSizeController']!.text = recordData.ettSize.value ?? '';
    _controllers['ettDepthController']!.text = recordData.ettDepth.value ?? '';
    _controllers['manualDefibCountController']!.text =
        recordData.manualDefibCount.value ?? '';
    _controllers['manualDefibJoulesController']!.text =
        recordData.manualDefibJoules.value ?? '';
    _controllers['rejectionNameController']!.text =
        recordData.rejectionName.value ?? '';

    _emergencyTreatments = _jsonToMap(recordData.emergencyTreatmentsJson.value);
    _airwayTreatments = _jsonToMap(recordData.airwayTreatmentsJson.value);
    _traumaTreatments = _jsonToMap(recordData.traumaTreatmentsJson.value);
    _transportMethods = _jsonToMap(recordData.transportMethodsJson.value);
    _cprMethods = _jsonToMap(recordData.cprMethodsJson.value);
    _medicationProcedures = _jsonToMap(
      recordData.medicationProceduresJson.value,
    );
    _otherEmergencyProcedures = _jsonToMap(
      recordData.otherEmergencyProceduresJson.value,
    );

    _aslType = recordData.aslType.value;
    _isRejection = recordData.isRejection.value;
    _relationshipType = recordData.relationshipType.value;
    _receivingTime = recordData.receivingTime.value;
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Future<void> saveData() async {
    final dataProvider = context.read<AmbulanceDataProvider>();

    dataProvider.updateAmbulanceRecord(
      dataProvider.ambulanceRecordData.copyWith(
        guideNote: Value(_controllers['guideController']!.text),
        receivingUnit: Value(_controllers['receivingUnitController']!.text),
        contactName: Value(_controllers['contactNameController']!.text),
        contactPhone: Value(_controllers['contactPhoneController']!.text),
        bodyDiagramNote: Value(_controllers['bodyDiagramNoteController']!.text),
        airwayOther: Value(_controllers['airwayOtherController']!.text),
        traumaOther: Value(_controllers['traumaOtherController']!.text),
        otherEmergencyOther: Value(
          _controllers['otherEmergencyOtherController']!.text,
        ),
        ettSize: Value(_controllers['ettSizeController']!.text),
        ettDepth: Value(_controllers['ettDepthController']!.text),
        manualDefibCount: Value(
          _controllers['manualDefibCountController']!.text,
        ),
        manualDefibJoules: Value(
          _controllers['manualDefibJoulesController']!.text,
        ),
        rejectionName: Value(_controllers['rejectionNameController']!.text),
        emergencyTreatmentsJson: Value(jsonEncode(_emergencyTreatments)),
        airwayTreatmentsJson: Value(jsonEncode(_airwayTreatments)),
        traumaTreatmentsJson: Value(jsonEncode(_traumaTreatments)),
        transportMethodsJson: Value(jsonEncode(_transportMethods)),
        cprMethodsJson: Value(jsonEncode(_cprMethods)),
        medicationProceduresJson: Value(jsonEncode(_medicationProcedures)),
        otherEmergencyProceduresJson: Value(
          jsonEncode(_otherEmergencyProcedures),
        ),
        aslType: Value(_aslType),
        isRejection: Value(_isRejection ?? false),
        relationshipType: Value(_relationshipType),
        receivingTime: Value(_receivingTime),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dataProvider = context.watch<AmbulanceDataProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 1100,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 急救處置
                  _buildSectionTitle('急救處置:'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    children: emergencyTreatmentOptions.map((option) {
                      return _buildCheckboxOption(
                        option,
                        _emergencyTreatments[option] ?? false,
                        (val) =>
                            setState(() => _emergencyTreatments[option] = val),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  if (_emergencyTreatments['呼吸道處置'] == true)
                    _buildSubOptions(
                      '呼吸道處置:',
                      airwayTreatmentOptions,
                      _airwayTreatments,
                      'airwayOtherController',
                    ),
                  if (_emergencyTreatments['創傷處置'] == true)
                    _buildSubOptions(
                      '創傷處置:',
                      traumaTreatmentOptions,
                      _traumaTreatments,
                      'traumaOtherController',
                    ),
                  if (_emergencyTreatments['搬運'] == true)
                    _buildSubOptions(
                      '搬運:',
                      transportMethodOptions,
                      _transportMethods,
                      null,
                    ),
                  if (_emergencyTreatments['心肺復甦術'] == true)
                    _buildSubOptions(
                      '心肺復甦術:',
                      cprMethodOptions,
                      _cprMethods,
                      null,
                    ),
                  if (_emergencyTreatments['藥物處置'] == true)
                    _buildSubOptions(
                      '藥物處置:',
                      medicationProcedureOptions,
                      _medicationProcedures,
                      null,
                    ),
                  if (_emergencyTreatments['其他處置'] == true)
                    _buildSubOptions(
                      '急救-其他處置:',
                      otherEmergencyProcedureOptions,
                      _otherEmergencyProcedures,
                      'otherEmergencyOtherController',
                    ),

                  // 人形圖
                  _buildSectionTitle('人形圖:'),
                  const SizedBox(height: 6),
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
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
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('開啟人形圖編輯功能')),
                          ),
                      child: const Text('點擊按鈕開始編輯人形圖'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTitleWithInput(
                    '人形圖備註:',
                    _controllers['bodyDiagramNoteController']!,
                    '請填寫備註內容',
                  ),
                  const SizedBox(height: 12),

                  // 給藥紀錄表
                  _buildMedicationTable(context, dataProvider),
                  const SizedBox(height: 12),

                  // ASL處理
                  _buildSectionTitle('ASL處理:'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildCheckboxOption(
                        '氣管內管',
                        _aslType == '氣管內管',
                        (v) => setState(() => _aslType = v ? '氣管內管' : null),
                      ),
                      _buildCheckboxOption(
                        '手動電擊',
                        _aslType == '手動電擊',
                        (v) => setState(() => _aslType = v ? '手動電擊' : null),
                      ),
                    ],
                  ),
                  if (_aslType == '氣管內管') ...[
                    const SizedBox(height: 8),
                    _buildTitleWithInput(
                      '氣管內管號碼:',
                      _controllers['ettSizeController']!,
                      '請填寫號碼',
                    ),
                    const SizedBox(height: 8),
                    _buildTitleWithInput(
                      '固定公分數(cm):',
                      _controllers['ettDepthController']!,
                      '請填寫公分數',
                    ),
                  ],
                  if (_aslType == '手動電擊') ...[
                    const SizedBox(height: 8),
                    _buildTitleWithInput(
                      '手動電擊次數:',
                      _controllers['manualDefibCountController']!,
                      '請填寫次數',
                    ),
                    const SizedBox(height: 8),
                    _buildTitleWithInput(
                      '手動電擊焦耳數:',
                      _controllers['manualDefibJoulesController']!,
                      '請填寫焦耳數',
                    ),
                  ],
                  const SizedBox(height: 12),

                  _buildTitleWithInput(
                    '線上指導醫師指導說明:',
                    _controllers['guideController']!,
                    '請填寫指導說明',
                  ),
                  const SizedBox(height: 12),

                  // 生命徵象紀錄表
                  _buildVitalSignsTable(context, dataProvider),
                  const SizedBox(height: 12),

                  // 隨車救護人員紀錄表
                  _buildParamedicTable(context, dataProvider),
                  const SizedBox(height: 12),

                  _buildTitleWithInput(
                    '接收單位:',
                    _controllers['receivingUnitController']!,
                    '請填寫接收單位',
                  ),
                  const SizedBox(height: 8),

                  // 接收時間
                  Row(
                    children: [
                      const Text(
                        '接收時間:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat(
                          'yyyy年MM月dd日 HH時mm分',
                        ).format(_receivingTime ?? DateTime.now()),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _receivingTime = DateTime.now()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('更新時間'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 拒絕送醫
                  _buildSectionTitle('是否拒絕送醫:'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildRadioOption(
                        '否',
                        false,
                        _isRejection,
                        (v) => setState(() => _isRejection = v),
                      ),
                      _buildRadioOption(
                        '是',
                        true,
                        _isRejection,
                        (v) => setState(() => _isRejection = v),
                      ),
                    ],
                  ),
                  if (_isRejection == true) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAEFE3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '拒絕醫療聲明:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '本人聲明,救護人員以解釋病情與送醫之需要,但我拒絕救護與送醫。',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                '姓名: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: TextField(
                                  controller:
                                      _controllers['rejectionNameController']!,
                                  decoration: const InputDecoration(
                                    hintText: '請填寫姓名',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  // 關係人身分
                  _buildSectionTitle('關係人身分:'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    children: ['病患', '家屬', '關係人'].map((option) {
                      return _buildRadioOption(
                        option,
                        option,
                        _relationshipType,
                        (v) => setState(() => _relationshipType = v),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  _buildTitleWithInput(
                    '關係人姓名:',
                    _controllers['contactNameController']!,
                    '請填寫關係人的姓名',
                  ),
                  const SizedBox(height: 8),
                  _buildTitleWithInput(
                    '關係人連絡電話:',
                    _controllers['contactPhoneController']!,
                    '請填寫關係人的連絡電話',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildTitleWithInput(
    String title,
    TextEditingController controller,
    String hint,
  ) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        SizedBox(
          width: 350,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxOption(
    String text,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(val ?? false),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildRadioOption<T>(
    String text,
    T value,
    T? groupValue,
    Function(T?) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSubOptions(
    String title,
    List<String> options,
    Map<String, bool> stateMap,
    String? otherControllerKey,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          children: options.map((option) {
            return _buildCheckboxOption(
              option,
              stateMap[option] ?? false,
              (val) => setState(() => stateMap[option] = val),
            );
          }).toList(),
        ),
        if (otherControllerKey != null && stateMap['其他'] == true) ...[
          const SizedBox(height: 8),
          _buildTitleWithInput(
            '其他說明:',
            _controllers[otherControllerKey]!,
            '請填寫其他處置說明',
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMedicationTable(
    BuildContext context,
    AmbulanceDataProvider provider,
  ) {
    final records = provider.medicationRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('給藥紀錄表:'),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '時間',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '藥名',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '途徑',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '劑量',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '執行者',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ...records.map(
              (record) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      record.recordTime != null
                          ? DateFormat('HH:mm').format(record.recordTime!)
                          : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      record.name ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      record.route ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      record.dose ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      record.executor ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton.icon(
            onPressed: () async {
              final result = await _showMedicationDialog(context);
              if (result != null) {
                await provider.addMedicationRecord(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('加入資料行'),
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
        _buildSectionTitle('生命徵象紀錄表:'),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(0.8),
            2: FlexColumnWidth(1.0),
            3: FlexColumnWidth(1.0),
            4: FlexColumnWidth(1.0),
            5: FlexColumnWidth(1.3),
            6: FlexColumnWidth(1.0),
            7: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              children: const [
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '時間',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '意識',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '體溫',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '脈搏',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '呼吸',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '血壓',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '血氧',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'GCS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            ...records.map(
              (record) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.recordTime != null
                          ? DateFormat('HH:mm').format(record.recordTime!)
                          : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.consciousness ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.temperature ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.pulse ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.respiration ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.bloodPressure ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.spo2 ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      record.gcs ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton.icon(
            onPressed: () async {
              final result = await _showVitalSignsDialog(context);
              if (result != null) {
                await provider.addVitalSignsRecord(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('加入資料行'),
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
        _buildSectionTitle('隨車救護人員紀錄表:'),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FixedColumnWidth(48),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '姓名',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '簽名',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(),
              ],
            ),
            ...records.map(
              (record) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      record.name ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 60,
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
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () async {
                        await provider.deleteParamedicRecord(record.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton.icon(
            onPressed: () async {
              final result = await _showParamedicDialog(context);
              if (result != null) {
                await provider.addParamedicRecord(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('加入資料行'),
          ),
        ),
      ],
    );
  }

  // 對話框
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '藥名',
                        hintText: '請輸入藥名',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: routeController,
                      decoration: const InputDecoration(
                        labelText: '途徑',
                        hintText: '請輸入途徑',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: doseController,
                      decoration: const InputDecoration(
                        labelText: '劑量',
                        hintText: '請輸入劑量',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: executorController,
                      decoration: const InputDecoration(
                        labelText: '執行者',
                        hintText: '請輸入執行者',
                      ),
                    ),
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('是否抵達醫院後:'),
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
                    TextField(
                      controller: triageController,
                      decoration: const InputDecoration(labelText: '檢傷站'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('意識情況:'),
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
                    TextField(
                      controller: tempController,
                      decoration: const InputDecoration(labelText: '體溫(°C)'),
                    ),
                    TextField(
                      controller: pulseController,
                      decoration: const InputDecoration(labelText: '脈搏(次/min)'),
                    ),
                    TextField(
                      controller: respController,
                      decoration: const InputDecoration(labelText: '呼吸(次/min)'),
                    ),
                    TextField(
                      controller: bpController,
                      decoration: const InputDecoration(labelText: '血壓(mmHg)'),
                    ),
                    TextField(
                      controller: spo2Controller,
                      decoration: const InputDecoration(labelText: '血氧(%)'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: gcsEController,
                            decoration: const InputDecoration(
                              labelText: 'GCS-E',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: gcsVController,
                            decoration: const InputDecoration(
                              labelText: 'GCS-V',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: gcsMController,
                            decoration: const InputDecoration(
                              labelText: 'GCS-M',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '姓名',
                        hintText: '請輸入姓名',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '簽名:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
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
                  if (context.mounted) Navigator.pop(context, bytes);
                }
              },
              child: const Text('採納並簽署'),
            ),
          ],
        );
      },
    );
  }
}
