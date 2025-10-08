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

// ✅ 1. 引入 Mixins
class _AmbulanceSituationPageState extends State<AmbulanceSituationPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  // ✅ 2. 建立完整的本地狀態
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

  // --- JSON Sets 的本地狀態 ---
  Set<String> _traumaClass = {};
  Set<String> _nonTraumaType = {};
  Set<String> _nonTraumaAcutePicked = {};
  Set<String> _nonTraumaGeneralPicked = {};
  Set<String> _traumaTypePicked = {};
  Set<String> _traumaGeneralBodyPicked = {};
  Set<String> _traumaMechanismPicked = {};
  Set<String> _allergy = {};
  Set<String> _pmh = {};

  // --- 其他選項的本地狀態 ---
  bool? _isProxyStatement;

  // --- 顏色設定與選項 (保持不變) ---
  final Color optColor = const Color(0xFF2F5C56);
  static const _traumaClassOptions = ['非創傷', '創傷'];
  // ... (其他靜態選項列表省略以保持簡潔，實際程式碼中它們會存在)
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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Set<String> _jsonToSet(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      return List<String>.from(jsonDecode(jsonString)).toSet();
    } catch (e) {
      return {};
    }
  }

  void _loadInitialData() {
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

    _traumaClass = _jsonToSet(recordData.traumaClassJson.value);
    _nonTraumaType = _jsonToSet(recordData.nonTraumaTypeJson.value);
    _nonTraumaAcutePicked = _jsonToSet(
      recordData.nonTraumaAcutePickedJson.value,
    );
    _nonTraumaGeneralPicked = _jsonToSet(
      recordData.nonTraumaGeneralPickedJson.value,
    );
    _traumaTypePicked = _jsonToSet(recordData.traumaTypePickedJson.value);
    _traumaGeneralBodyPicked = _jsonToSet(
      recordData.traumaGeneralBodyPickedJson.value,
    );
    _traumaMechanismPicked = _jsonToSet(
      recordData.traumaMechanismPickedJson.value,
    );
    _allergy = _jsonToSet(recordData.allergyJson.value);
    _pmh = _jsonToSet(recordData.pmhJson.value);

    _isProxyStatement = recordData.isProxyStatement.value;
  }

  @override
  void dispose() {
    _controllers.forEach((_, ctrl) => ctrl.dispose());
    super.dispose();
  }

  // ✅ 3. 實現 saveData 方法
  @override
  Future<void> saveData() async {
    final dataProvider = context.read<AmbulanceDataProvider>();

    dataProvider.updateAmbulanceRecord(
      dataProvider.ambulanceRecordData.copyWith(
        chiefComplaint: Value(_controllers['chiefComplaint']!.text),
        allergyOther: Value(_controllers['allergyOther']!.text),
        pmhOther: Value(_controllers['pmhOther']!.text),
        nonTraumaAcuteOther: Value(_controllers['nonTraumaAcuteOther']!.text),
        traumaGeneralOther: Value(_controllers['traumaGeneralOther']!.text),
        fallHeight: Value(_controllers['fallHeight']!.text),
        burnDegree: Value(_controllers['burnDegree']!.text),
        burnArea: Value(_controllers['burnArea']!.text),
        traumaOther: Value(_controllers['traumaOther']!.text),

        traumaClassJson: Value(jsonEncode(_traumaClass.toList())),
        nonTraumaTypeJson: Value(jsonEncode(_nonTraumaType.toList())),
        nonTraumaAcutePickedJson: Value(
          jsonEncode(_nonTraumaAcutePicked.toList()),
        ),
        nonTraumaGeneralPickedJson: Value(
          jsonEncode(_nonTraumaGeneralPicked.toList()),
        ),
        traumaTypePickedJson: Value(jsonEncode(_traumaTypePicked.toList())),
        traumaGeneralBodyPickedJson: Value(
          jsonEncode(_traumaGeneralBodyPicked.toList()),
        ),
        traumaMechanismPickedJson: Value(
          jsonEncode(_traumaMechanismPicked.toList()),
        ),
        allergyJson: Value(jsonEncode(_allergy.toList())),
        pmhJson: Value(jsonEncode(_pmh.toList())),

        isProxyStatement: Value(_isProxyStatement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ 4. 必須呼叫 super.build

    // ✅ 5. 所有邏輯判斷現在基於快速的本地狀態
    bool pickedNonTrauma = _traumaClass.contains('非創傷');
    bool pickedTrauma = _traumaClass.contains('創傷');
    // ... (其他布林判斷也基於本地 Set)
    bool pickedAcute = _nonTraumaType.contains('急症');
    bool pickedGeneralDisease = _nonTraumaType.contains('一般疾病');
    bool pickedTraumaGeneral = _traumaTypePicked.contains('一般外傷');
    bool pickedTraumaMech = _traumaTypePicked.contains('受傷機轉');
    bool pickedFall = _traumaTypePicked.contains('墜落傷');
    bool pickedBurn = _traumaTypePicked.contains('燒燙傷');
    bool pickedTraumaOther = _traumaTypePicked.contains('其他');

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              // ✅ 6. 加入 SingleChildScrollView 避免內容溢出
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('創傷分類'),
                  ..._traumaClassOptions.map(
                    (e) => _checkboxTile(
                      label: e,
                      isChecked: _traumaClass.contains(e),
                      onChanged: (isChecked) => setState(() {
                        if (isChecked)
                          _traumaClass.add(e);
                        else
                          _traumaClass.remove(e);
                      }),
                    ),
                  ),
                  // ... (所有 UI 元件都改為讀取和寫入本地狀態)
                  if (pickedNonTrauma) ...[
                    _title('非創傷類別'),
                    ..._nonTraumaTypes.map(
                      (e) => _checkboxTile(
                        label: e,
                        isChecked: _nonTraumaType.contains(e),
                        onChanged: (isChecked) => setState(() {
                          if (isChecked)
                            _nonTraumaType.add(e);
                          else
                            _nonTraumaType.remove(e);
                        }),
                      ),
                    ),
                    if (pickedAcute) ...[
                      _title('非創傷急症'),
                      ..._nonTraumaAcuteOptions.map(
                        (e) => _checkboxTile(
                          label: e,
                          isChecked: _nonTraumaAcutePicked.contains(e),
                          onChanged: (isChecked) => setState(() {
                            if (isChecked)
                              _nonTraumaAcutePicked.add(e);
                            else
                              _nonTraumaAcutePicked.remove(e);
                          }),
                        ),
                      ),
                      if (_nonTraumaAcutePicked.contains('其他'))
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
                          isChecked: _nonTraumaGeneralPicked.contains(e),
                          onChanged: (isChecked) => setState(() {
                            if (isChecked)
                              _nonTraumaGeneralPicked.add(e);
                            else
                              _nonTraumaGeneralPicked.remove(e);
                          }),
                        ),
                      ),
                    ],
                  ],
                  if (pickedTrauma) ...[
                    _title('創傷類別'),
                    ..._traumaTypeOptions.map(
                      (e) => _checkboxTile(
                        label: e,
                        isChecked: _traumaTypePicked.contains(e),
                        onChanged: (isChecked) => setState(() {
                          if (isChecked)
                            _traumaTypePicked.add(e);
                          else
                            _traumaTypePicked.remove(e);
                        }),
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
                          isChecked: _traumaGeneralBodyPicked.contains(e),
                          onChanged: (isChecked) => setState(() {
                            if (isChecked)
                              _traumaGeneralBodyPicked.add(e);
                            else
                              _traumaGeneralBodyPicked.remove(e);
                          }),
                        ),
                      ),
                      if (_traumaGeneralBodyPicked.contains('其他'))
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
                          isChecked: _traumaMechanismPicked.contains(e),
                          onChanged: (isChecked) => setState(() {
                            if (isChecked)
                              _traumaMechanismPicked.add(e);
                            else
                              _traumaMechanismPicked.remove(e);
                          }),
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
                      isChecked: _allergy.contains(e),
                      onChanged: (isChecked) => setState(() {
                        if (isChecked)
                          _allergy.add(e);
                        else
                          _allergy.remove(e);
                      }),
                    ),
                  ),
                  if (_allergy.contains('其他'))
                    _tightField(
                      label: '其他過敏史',
                      controller: _controllers['allergyOther']!,
                    ),

                  _inlineField('病患主訴', _controllers['chiefComplaint']!),

                  _title('家屬或同事、友人代訴'),
                  _radioTile(
                    '否',
                    false,
                    _isProxyStatement,
                    (val) => setState(() => _isProxyStatement = val),
                  ),
                  _radioTile(
                    '是',
                    true,
                    _isProxyStatement,
                    (val) => setState(() => _isProxyStatement = val),
                  ),

                  _title('過去病史'),
                  ..._pmhOptions.map(
                    (e) => _checkboxTile(
                      label: e,
                      isChecked: _pmh.contains(e),
                      onChanged: (isChecked) => setState(() {
                        if (isChecked)
                          _pmh.add(e);
                        else
                          _pmh.remove(e);
                      }),
                    ),
                  ),
                  if (_pmh.contains('其他'))
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
  }

  // --- UI 小積木 (移除 onChanged 參數) ---
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
