import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import 'nav5.dart'; // For AmbulanceDataProvider

class AmbulanceSituationPage extends StatefulWidget {
  final int visitId;
  const AmbulanceSituationPage({super.key, required this.visitId});

  @override
  State<AmbulanceSituationPage> createState() => _AmbulanceSituationPageState();
}

class _AmbulanceSituationPageState extends State<AmbulanceSituationPage> {
  // --- Controllers ---
  final Map<String, TextEditingController> _controllers = {
    'allergyOther': TextEditingController(),
    'chiefComplaint': TextEditingController(),
    'pmhOther': TextEditingController(),
    'nonTraumaAcuteOther': TextEditingController(),
    'traumaGeneralOther': TextEditingController(),
    'fallHeight': TextEditingController(),
    'burnDegree': TextEditingController(),
    'burnArea': TextEditingController(),
    'traumaOther': TextEditingController(),
  };

  // --- 顏色設定 ---
  final Color optColor = const Color(0xFF2F5C56);

  // --- 選項 (靜態) ---
  static const _traumaClassOptions = ['非創傷', '創傷'];
  static const _nonTraumaTypes = ['急症', '一般疾病'];
  static const _nonTraumaAcuteOptions = [
    '呼吸問題(喘/呼吸急促)',
    '呼吸道問題(異物噎塞)',
    '昏迷(意識不清)',
    '胸痛/胸悶',
    '腹痛',
    '疑似毒藥物中毒',
    '疑似一氧化碳中毒',
    '癲癇/抽搐',
    '路倒',
    '精神異常',
    '孕婦急產',
    '到院前心肺功能停止',
    '其他',
  ];
  static const _nonTraumaGeneralOptions = [
    '頭痛/頭暈',
    '昏倒/昏厥',
    '發燒',
    '噁心/嘔吐/腹瀉',
    '肢體無力',
  ];
  static const _traumaTypeOptions = [
    '一般外傷',
    '受傷機轉',
    '溺水',
    '摔跌傷',
    '墜落傷',
    '穿刺傷',
    '燒燙傷',
    '電擊傷',
    '生物咬螫傷',
    '到院前心肺功能停止',
    '其他',
  ];
  static const _traumaGeneralBodyOptions = [
    '頭部外傷',
    '胸部外傷',
    '腹部外傷',
    '背部外傷',
    '肢體外傷',
    '其他',
  ];
  static const _traumaMechanismOptions = ['因交通事故', '非交通事故'];
  static const _allergyOptions = ['無', '不詳', '食物', '藥物', '其他'];
  static const _pmhOptions = [
    '無',
    '不詳',
    '高血壓',
    '糖尿病',
    '慢性肺部疾病',
    '氣喘',
    '腦血管疾病',
    '心臟疾病',
    '腎病/洗腎中',
    '肝臟疾病',
    '其他',
  ];

  @override
  void initState() {
    super.initState();
    final dataProvider = context.read<AmbulanceDataProvider>();
    final recordData = dataProvider.ambulanceRecordData;
    _controllers['chiefComplaint']!.text =
        recordData.chiefComplaint.value ?? '';
    _controllers['allergyOther']!.text = recordData.allergyOther.value ?? '';
    _controllers['pmhOther']!.text = recordData.pmhOther.value ?? '';
    _controllers['nonTraumaAcuteOther']!.text =
        recordData.nonTraumaAcuteOther.value ?? '';
    _controllers['traumaGeneralOther']!.text =
        recordData.traumaGeneralOther.value ?? '';
    _controllers['fallHeight']!.text = recordData.fallHeight.value ?? '';
    _controllers['burnDegree']!.text = recordData.burnDegree.value ?? '';
    _controllers['burnArea']!.text = recordData.burnArea.value ?? '';
    _controllers['traumaOther']!.text = recordData.traumaOther.value ?? '';
  }

  @override
  void dispose() {
    _controllers.forEach((_, ctrl) => ctrl.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        final recordData = dataProvider.ambulanceRecordData;

        Set<String> getJsonSet(Value<String> jsonValue) {
          try {
            return List<String>.from(jsonDecode(jsonValue.value)).toSet();
          } catch (e) {
            return {};
          }
        }

        final traumaClass = getJsonSet(recordData.traumaClassJson);
        final nonTraumaType = getJsonSet(recordData.nonTraumaTypeJson);
        final nonTraumaAcutePicked = getJsonSet(
          recordData.nonTraumaAcutePickedJson,
        );
        final nonTraumaGeneralPicked = getJsonSet(
          recordData.nonTraumaGeneralPickedJson,
        );
        final traumaTypePicked = getJsonSet(recordData.traumaTypePickedJson);
        final traumaGeneralBodyPicked = getJsonSet(
          recordData.traumaGeneralBodyPickedJson,
        );
        final traumaMechanismPicked = getJsonSet(
          recordData.traumaMechanismPickedJson,
        );
        final allergy = getJsonSet(recordData.allergyJson);
        final pmh = getJsonSet(recordData.pmhJson);

        bool pickedNonTrauma = traumaClass.contains('非創傷');
        bool pickedTrauma = traumaClass.contains('創傷');
        bool pickedAcute = nonTraumaType.contains('急症');
        bool pickedGeneralDisease = nonTraumaType.contains('一般疾病');
        bool pickedTraumaGeneral = traumaTypePicked.contains('一般外傷');
        bool pickedTraumaMech = traumaTypePicked.contains('受傷機轉');
        bool pickedFall = traumaTypePicked.contains('墜落傷');
        bool pickedBurn = traumaTypePicked.contains('燒燙傷');
        bool pickedTraumaOther = traumaTypePicked.contains('其他');

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Card(
              color: Colors.white,
              elevation: 1.5,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title('創傷分類'),
                    ..._traumaClassOptions.map(
                      (e) => _checkboxTile(
                        label: e,
                        isChecked: traumaClass.contains(e),
                        onChanged: (isChecked) => dataProvider.updateJsonSet(
                          'traumaClassJson',
                          e,
                          isChecked,
                        ),
                      ),
                    ),
                    if (pickedNonTrauma) ...[
                      _title('非創傷類別'),
                      ..._nonTraumaTypes.map(
                        (e) => _checkboxTile(
                          label: e,
                          isChecked: nonTraumaType.contains(e),
                          onChanged: (isChecked) => dataProvider.updateJsonSet(
                            'nonTraumaTypeJson',
                            e,
                            isChecked,
                          ),
                        ),
                      ),
                      if (pickedAcute) ...[
                        _title('非創傷急症'),
                        ..._nonTraumaAcuteOptions.map(
                          (e) => _checkboxTile(
                            label: e,
                            isChecked: nonTraumaAcutePicked.contains(e),
                            onChanged: (isChecked) =>
                                dataProvider.updateJsonSet(
                                  'nonTraumaAcutePickedJson',
                                  e,
                                  isChecked,
                                ),
                          ),
                        ),
                        if (nonTraumaAcutePicked.contains('其他'))
                          _tightField(
                            label: '非創傷其他急症',
                            controller: _controllers['nonTraumaAcuteOther']!,
                            onChanged: (val) =>
                                dataProvider.updateAmbulanceRecord(
                                  recordData.copyWith(
                                    nonTraumaAcuteOther: Value(val),
                                  ),
                                ),
                          ),
                      ],
                      if (pickedGeneralDisease) ...[
                        _title('非創傷一般疾病'),
                        ..._nonTraumaGeneralOptions.map(
                          (e) => _checkboxTile(
                            label: e,
                            isChecked: nonTraumaGeneralPicked.contains(e),
                            onChanged: (isChecked) =>
                                dataProvider.updateJsonSet(
                                  'nonTraumaGeneralPickedJson',
                                  e,
                                  isChecked,
                                ),
                          ),
                        ),
                      ],
                    ],
                    if (pickedTrauma) ...[
                      _title('創傷類別'),
                      ..._traumaTypeOptions.map(
                        (e) => _checkboxTile(
                          label: e,
                          isChecked: traumaTypePicked.contains(e),
                          onChanged: (isChecked) => dataProvider.updateJsonSet(
                            'traumaTypePickedJson',
                            e,
                            isChecked,
                          ),
                        ),
                      ),
                      if (pickedTraumaOther)
                        _tightField(
                          label: '其他創傷',
                          controller: _controllers['traumaOther']!,
                          onChanged: (val) =>
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(traumaOther: Value(val)),
                              ),
                        ),
                      if (pickedTraumaGeneral) ...[
                        _title('創傷—一般外傷'),
                        ..._traumaGeneralBodyOptions.map(
                          (e) => _checkboxTile(
                            label: e,
                            isChecked: traumaGeneralBodyPicked.contains(e),
                            onChanged: (isChecked) =>
                                dataProvider.updateJsonSet(
                                  'traumaGeneralBodyPickedJson',
                                  e,
                                  isChecked,
                                ),
                          ),
                        ),
                        if (traumaGeneralBodyPicked.contains('其他'))
                          _tightField(
                            label: '其他—一般外傷',
                            controller: _controllers['traumaGeneralOther']!,
                            onChanged: (val) =>
                                dataProvider.updateAmbulanceRecord(
                                  recordData.copyWith(
                                    traumaGeneralOther: Value(val),
                                  ),
                                ),
                          ),
                      ],
                      if (pickedTraumaMech) ...[
                        _title('創傷—受傷機轉'),
                        ..._traumaMechanismOptions.map(
                          (e) => _checkboxTile(
                            label: e,
                            isChecked: traumaMechanismPicked.contains(e),
                            onChanged: (isChecked) =>
                                dataProvider.updateJsonSet(
                                  'traumaMechanismPickedJson',
                                  e,
                                  isChecked,
                                ),
                          ),
                        ),
                      ],
                      if (pickedFall) ...[
                        _title('創傷—墜落傷'),
                        _tightField(
                          label: '高度(公尺)',
                          controller: _controllers['fallHeight']!,
                          onChanged: (val) =>
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(fallHeight: Value(val)),
                              ),
                        ),
                      ],
                      if (pickedBurn) ...[
                        _title('創傷—燒燙傷'),
                        _tightField(
                          label: '燒燙傷度數',
                          controller: _controllers['burnDegree']!,
                          onChanged: (val) =>
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(burnDegree: Value(val)),
                              ),
                        ),
                        _tightField(
                          label: '燒燙傷面積(%)',
                          controller: _controllers['burnArea']!,
                          onChanged: (val) =>
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(burnArea: Value(val)),
                              ),
                        ),
                      ],
                    ],
                    _title('過敏史'),
                    ..._allergyOptions.map(
                      (e) => _checkboxTile(
                        label: e,
                        isChecked: allergy.contains(e),
                        onChanged: (isChecked) => dataProvider.updateJsonSet(
                          'allergyJson',
                          e,
                          isChecked,
                        ),
                      ),
                    ),
                    if (allergy.contains('其他'))
                      _tightField(
                        label: '其他過敏史',
                        controller: _controllers['allergyOther']!,
                        onChanged: (val) => dataProvider.updateAmbulanceRecord(
                          recordData.copyWith(allergyOther: Value(val)),
                        ),
                      ),
                    _inlineField(
                      '病患主訴',
                      _controllers['chiefComplaint']!,
                      (val) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(chiefComplaint: Value(val)),
                      ),
                    ),
                    _title('家屬或同事、友人代訴'),
                    _radioTile(
                      '否',
                      false,
                      recordData.isProxyStatement.value,
                      (val) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(isProxyStatement: Value(val!)),
                      ),
                    ),
                    _radioTile(
                      '是',
                      true,
                      recordData.isProxyStatement.value,
                      (val) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(isProxyStatement: Value(val!)),
                      ),
                    ),
                    _title('過去病史'),
                    ..._pmhOptions.map(
                      (e) => _checkboxTile(
                        label: e,
                        isChecked: pmh.contains(e),
                        onChanged: (isChecked) =>
                            dataProvider.updateJsonSet('pmhJson', e, isChecked),
                      ),
                    ),
                    if (pmh.contains('其他'))
                      _tightField(
                        label: '其他過去病史',
                        controller: _controllers['pmhOther']!,
                        onChanged: (val) => dataProvider.updateAmbulanceRecord(
                          recordData.copyWith(pmhOther: Value(val)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _title(String s) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(s, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
  Widget _checkboxTile({
    required String label,
    required bool isChecked,
    required ValueChanged<bool> onChanged,
  }) => CheckboxListTile(
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    dense: true,
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    checkColor: Colors.white,
    activeColor: optColor,
    side: BorderSide(color: optColor, width: 2),
    title: Text(label),
    value: isChecked,
    onChanged: (v) => onChanged(v ?? false),
  );
  Widget _radioTile(
    String label,
    bool value,
    bool? groupValue,
    ValueChanged<bool?> onChanged,
  ) => RadioListTile<bool>(
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    dense: true,
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
  );
  Widget _tightField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(left: 40, top: 2, bottom: 4),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    ),
  );
  Widget _inlineField(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '請填寫病患主訴',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    ),
  );
}
