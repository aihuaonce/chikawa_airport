import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import 'data/models/ambulance_data.dart';
import 'data/db/app_database.dart';

class AmbulancePlanPage extends StatefulWidget {
  final int visitId;
  const AmbulancePlanPage({super.key, required this.visitId});

  @override
  State<AmbulancePlanPage> createState() => _AmbulancePlanPageState();
}

class _AmbulancePlanPageState extends State<AmbulancePlanPage> {
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

  final Map<String, TextEditingController> _controllers = {
    'guideController': TextEditingController(),
    'receivingUnitController': TextEditingController(),
    'contactNameController': TextEditingController(),
    'contactPhoneController': TextEditingController(),
    'bodyDiagramNoteController': TextEditingController(),
    'airwayOtherController': TextEditingController(),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<AmbulanceData>();
    _controllers['guideController']!.text = data.guideNote ?? '';
    _controllers['receivingUnitController']!.text = data.receivingUnit ?? '';
    _controllers['contactNameController']!.text = data.contactName ?? '';
    _controllers['contactPhoneController']!.text = data.contactPhone ?? '';
    _controllers['bodyDiagramNoteController']!.text =
        data.bodyDiagramNote ?? '';
    _controllers['airwayOtherController']!.text = data.airwayOther ?? '';
    _controllers['otherEmergencyOtherController']!.text =
        data.otherEmergencyOther ?? '';
    _controllers['ettSizeController']!.text = data.ettSize ?? '';
    _controllers['ettDepthController']!.text = data.ettDepth ?? '';
    _controllers['manualDefibCountController']!.text =
        data.manualDefibCount ?? '';
    _controllers['manualDefibJoulesController']!.text =
        data.manualDefibJoules ?? '';
    _controllers['rejectionNameController']!.text = data.rejectionName ?? '';
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<AmbulanceData>();
    data.updatePlan(
      guideNote: _controllers['guideController']!.text,
      receivingUnit: _controllers['receivingUnitController']!.text,
      contactName: _controllers['contactNameController']!.text,
      contactPhone: _controllers['contactPhoneController']!.text,
      bodyDiagramNote: _controllers['bodyDiagramNoteController']!.text,
      airwayOther: _controllers['airwayOtherController']!.text,
      otherEmergencyOther: _controllers['otherEmergencyOtherController']!.text,
      ettSize: _controllers['ettSizeController']!.text,
      ettDepth: _controllers['ettDepthController']!.text,
      manualDefibCount: _controllers['manualDefibCountController']!.text,
      manualDefibJoules: _controllers['manualDefibJoulesController']!.text,
      rejectionName: _controllers['rejectionNameController']!.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
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
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
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
                            data.emergencyTreatments[option] ?? false,
                            (val) {
                              final newMap = Map<String, bool>.from(
                                data.emergencyTreatments,
                              );
                              newMap[option] = val;
                              data.updatePlan(emergencyTreatments: newMap);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      if (data.emergencyTreatments['呼吸道處置'] == true)
                        _buildSubOptions(
                          '呼吸道處置:',
                          airwayTreatmentOptions,
                          data.airwayTreatments,
                          'airwayOtherController',
                          (newMap) => data.updatePlan(airwayTreatments: newMap),
                        ),
                      if (data.emergencyTreatments['創傷處置'] == true)
                        _buildSubOptions(
                          '創傷處置:',
                          traumaTreatmentOptions,
                          data.traumaTreatments,
                          null, // traumaOtherController 不存在於 AmbulanceData
                          (newMap) => data.updatePlan(traumaTreatments: newMap),
                        ),
                      if (data.emergencyTreatments['搬運'] == true)
                        _buildSubOptions(
                          '搬運:',
                          transportMethodOptions,
                          data.transportMethods,
                          null,
                          (newMap) => data.updatePlan(transportMethods: newMap),
                        ),
                      if (data.emergencyTreatments['心肺復甦術'] == true)
                        _buildSubOptions(
                          '心肺復甦術:',
                          cprMethodOptions,
                          data.cprMethods,
                          null,
                          (newMap) => data.updatePlan(cprMethods: newMap),
                        ),
                      if (data.emergencyTreatments['藥物處置'] == true)
                        _buildSubOptions(
                          '藥物處置:',
                          medicationProcedureOptions,
                          data.medicationProcedures,
                          null,
                          (newMap) =>
                              data.updatePlan(medicationProcedures: newMap),
                        ),
                      if (data.emergencyTreatments['其他處置'] == true)
                        _buildSubOptions(
                          '急救-其他處置:',
                          otherEmergencyProcedureOptions,
                          data.otherEmergencyProcedures,
                          'otherEmergencyOtherController',
                          (newMap) =>
                              data.updatePlan(otherEmergencyProcedures: newMap),
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

                      // 給藥紀錄表 (假設 data provider 提供)
                      // _buildMedicationTable(context, data),
                      const SizedBox(height: 12),

                      // ASL處理
                      _buildSectionTitle('ASL處理:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: [
                          _buildCheckboxOption(
                            '氣管內管',
                            data.aslType == '氣管內管',
                            (v) => data.updatePlan(aslType: v ? '氣管內管' : null),
                          ),
                          _buildCheckboxOption(
                            '手動電擊',
                            data.aslType == '手動電擊',
                            (v) => data.updatePlan(aslType: v ? '手動電擊' : null),
                          ),
                        ],
                      ),
                      if (data.aslType == '氣管內管') ...[
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
                      if (data.aslType == '手動電擊') ...[
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

                      // 生命徵象紀錄表 (假設 data provider 提供)
                      // _buildVitalSignsTable(context, data),
                      const SizedBox(height: 12),

                      // 隨車救護人員紀錄表 (假設 data provider 提供)
                      // _buildParamedicTable(context, data),
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
                            ).format(data.receivingTime ?? DateTime.now()),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                data.updatePlan(receivingTime: DateTime.now()),
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
                            data.isRejection,
                            (v) => data.updatePlan(isRejection: v),
                          ),
                          _buildRadioOption(
                            '是',
                            true,
                            data.isRejection,
                            (v) => data.updatePlan(isRejection: v),
                          ),
                        ],
                      ),
                      if (data.isRejection == true) ...[
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _controllers['rejectionNameController']!,
                                      onChanged: (_) => _saveToProvider(),
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
                            data.relationshipType,
                            (v) => data.updatePlan(relationshipType: v),
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
      },
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
            onChanged: (_) => _saveToProvider(),
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
    Function(Map<String, bool>) onUpdate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          children: options.map((option) {
            return _buildCheckboxOption(option, stateMap[option] ?? false, (
              val,
            ) {
              final newMap = Map<String, bool>.from(stateMap);
              newMap[option] = val;
              onUpdate(newMap);
            });
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
}
