import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/ambulance_data.dart';

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

  // --- 顏色設定與選項 (靜態) ---
  final Color optColor = const Color(0xFF2F5C56);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<AmbulanceData>();
    _controllers['chiefComplaint']!.text = data.chiefComplaint ?? '';
    _controllers['allergyOther']!.text = data.allergyOther ?? '';
    _controllers['pmhOther']!.text = data.pmhOther ?? '';
    _controllers['nonTraumaAcuteOther']!.text = data.nonTraumaAcuteOther ?? '';
    _controllers['traumaGeneralOther']!.text = data.traumaGeneralOther ?? '';
    _controllers['fallHeight']!.text = data.fallHeight ?? '';
    _controllers['burnDegree']!.text = data.burnDegree ?? '';
    _controllers['burnArea']!.text = data.burnArea ?? '';
    _controllers['traumaOther']!.text = data.traumaOther ?? '';
  }

  @override
  void dispose() {
    _controllers.forEach((_, ctrl) => ctrl.dispose());
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<AmbulanceData>();
    data.updateSituation(
      chiefComplaint: _controllers['chiefComplaint']!.text,
      allergyOther: _controllers['allergyOther']!.text,
      pmhOther: _controllers['pmhOther']!.text,
      nonTraumaAcuteOther: _controllers['nonTraumaAcuteOther']!.text,
      traumaGeneralOther: _controllers['traumaGeneralOther']!.text,
      fallHeight: _controllers['fallHeight']!.text,
      burnDegree: _controllers['burnDegree']!.text,
      burnArea: _controllers['burnArea']!.text,
      traumaOther: _controllers['traumaOther']!.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        // --- 根據 Provider data 動態決定 UI 顯示邏輯 ---
        final bool pickedNonTrauma = data.traumaClass.contains('非創傷');
        final bool pickedTrauma = data.traumaClass.contains('創傷');
        final bool pickedAcute = data.nonTraumaType.contains('急症');
        final bool pickedGeneralDisease = data.nonTraumaType.contains('一般疾病');
        final bool pickedTraumaGeneral = data.traumaTypePicked.contains('一般外傷');
        final bool pickedTraumaMech = data.traumaTypePicked.contains('受傷機轉');
        final bool pickedFall = data.traumaTypePicked.contains('墜落傷');
        final bool pickedBurn = data.traumaTypePicked.contains('燒燙傷');
        final bool pickedTraumaOther = data.traumaTypePicked.contains('其他');

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title('創傷分類'),
                      ..._traumaClassOptions.map(
                        (e) => _checkboxTile(
                          label: e,
                          isChecked: data.traumaClass.contains(e),
                          onChanged: (isChecked) {
                            final newSet = Set<String>.from(data.traumaClass);
                            if (isChecked)
                              newSet.add(e);
                            else
                              newSet.remove(e);
                            data.updateSituation(traumaClass: newSet);
                          },
                        ),
                      ),
                      if (pickedNonTrauma) ...[
                        _title('非創傷類別'),
                        ..._nonTraumaTypes.map(
                          (e) => _checkboxTile(
                            label: e,
                            isChecked: data.nonTraumaType.contains(e),
                            onChanged: (isChecked) {
                              final newSet = Set<String>.from(
                                data.nonTraumaType,
                              );
                              if (isChecked)
                                newSet.add(e);
                              else
                                newSet.remove(e);
                              data.updateSituation(nonTraumaType: newSet);
                            },
                          ),
                        ),
                        if (pickedAcute) ...[
                          _title('非創傷急症'),
                          ..._nonTraumaAcuteOptions.map(
                            (e) => _checkboxTile(
                              label: e,
                              isChecked: data.nonTraumaAcutePicked.contains(e),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.nonTraumaAcutePicked,
                                );
                                if (isChecked)
                                  newSet.add(e);
                                else
                                  newSet.remove(e);
                                data.updateSituation(
                                  nonTraumaAcutePicked: newSet,
                                );
                              },
                            ),
                          ),
                          if (data.nonTraumaAcutePicked.contains('其他'))
                            _tightField(
                              label: '非創傷其他急症',
                              controller: _controllers['nonTraumaAcuteOther']!,
                            ),
                        ],
                        if (pickedGeneralDisease) ...[
                          _title('非創傷一般疾病'),
                          ..._nonTraumaGeneralOptions.map(
                            (e) => _checkboxTile(
                              label: e,
                              isChecked: data.nonTraumaGeneralPicked.contains(
                                e,
                              ),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.nonTraumaGeneralPicked,
                                );
                                if (isChecked)
                                  newSet.add(e);
                                else
                                  newSet.remove(e);
                                data.updateSituation(
                                  nonTraumaGeneralPicked: newSet,
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                      if (pickedTrauma) ...[
                        _title('創傷類別'),
                        ..._traumaTypeOptions.map(
                          (e) => _checkboxTile(
                            label: e,
                            isChecked: data.traumaTypePicked.contains(e),
                            onChanged: (isChecked) {
                              final newSet = Set<String>.from(
                                data.traumaTypePicked,
                              );
                              if (isChecked)
                                newSet.add(e);
                              else
                                newSet.remove(e);
                              data.updateSituation(traumaTypePicked: newSet);
                            },
                          ),
                        ),
                        if (pickedTraumaOther)
                          _tightField(
                            label: '其他創傷',
                            controller: _controllers['traumaOther']!,
                          ),
                        if (pickedTraumaGeneral) ...[
                          _title('創傷—一般外傷'),
                          ..._traumaGeneralBodyOptions.map(
                            (e) => _checkboxTile(
                              label: e,
                              isChecked: data.traumaGeneralBodyPicked.contains(
                                e,
                              ),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.traumaGeneralBodyPicked,
                                );
                                if (isChecked)
                                  newSet.add(e);
                                else
                                  newSet.remove(e);
                                data.updateSituation(
                                  traumaGeneralBodyPicked: newSet,
                                );
                              },
                            ),
                          ),
                          if (data.traumaGeneralBodyPicked.contains('其他'))
                            _tightField(
                              label: '其他—一般外傷',
                              controller: _controllers['traumaGeneralOther']!,
                            ),
                        ],
                        if (pickedTraumaMech) ...[
                          _title('創傷—受傷機轉'),
                          ..._traumaMechanismOptions.map(
                            (e) => _checkboxTile(
                              label: e,
                              isChecked: data.traumaMechanismPicked.contains(e),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.traumaMechanismPicked,
                                );
                                if (isChecked)
                                  newSet.add(e);
                                else
                                  newSet.remove(e);
                                data.updateSituation(
                                  traumaMechanismPicked: newSet,
                                );
                              },
                            ),
                          ),
                        ],
                        if (pickedFall)
                          _tightField(
                            label: '高度(公尺)',
                            controller: _controllers['fallHeight']!,
                          ),
                        if (pickedBurn) ...[
                          _tightField(
                            label: '燒燙傷度數',
                            controller: _controllers['burnDegree']!,
                          ),
                          _tightField(
                            label: '燒燙傷面積(%)',
                            controller: _controllers['burnArea']!,
                          ),
                        ],
                      ],
                      _title('過敏史'),
                      ..._allergyOptions.map(
                        (e) => _checkboxTile(
                          label: e,
                          isChecked: data.allergy.contains(e),
                          onChanged: (isChecked) {
                            final newSet = Set<String>.from(data.allergy);
                            if (isChecked)
                              newSet.add(e);
                            else
                              newSet.remove(e);
                            data.updateSituation(allergy: newSet);
                          },
                        ),
                      ),
                      if (data.allergy.contains('其他'))
                        _tightField(
                          label: '其他過敏史',
                          controller: _controllers['allergyOther']!,
                        ),
                      _inlineField('病患主訴', _controllers['chiefComplaint']!),
                      _title('家屬或同事、友人代訴'),
                      _radioTile(
                        '否',
                        false,
                        data.isProxyStatement,
                        (val) => data.updateSituation(isProxyStatement: val),
                      ),
                      _radioTile(
                        '是',
                        true,
                        data.isProxyStatement,
                        (val) => data.updateSituation(isProxyStatement: val),
                      ),
                      _title('過去病史'),
                      ..._pmhOptions.map(
                        (e) => _checkboxTile(
                          label: e,
                          isChecked: data.pmh.contains(e),
                          onChanged: (isChecked) {
                            final newSet = Set<String>.from(data.pmh);
                            if (isChecked)
                              newSet.add(e);
                            else
                              newSet.remove(e);
                            data.updateSituation(pmh: newSet);
                          },
                        ),
                      ),
                      if (data.pmh.contains('其他'))
                        _tightField(
                          label: '其他過去病史',
                          controller: _controllers['pmhOther']!,
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

  // --- UI 小積木 ---
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
  }) => Padding(
    padding: const EdgeInsets.only(left: 40, top: 2, bottom: 4),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: TextFormField(
        controller: controller,
        onChanged: (_) => _saveToProvider(),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );

  Widget _inlineField(String label, TextEditingController controller) =>
      Padding(
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
                  onChanged: (_) => _saveToProvider(),
                  decoration: const InputDecoration(
                    hintText: '請填寫病患主訴',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
