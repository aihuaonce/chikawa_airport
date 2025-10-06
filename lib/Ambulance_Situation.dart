import 'package:flutter/material.dart';

class AmbulanceSituationPage extends StatefulWidget {
  const AmbulanceSituationPage({super.key});

  @override
  State<AmbulanceSituationPage> createState() => _AmbulanceSituationPageState();
}

class _AmbulanceSituationPageState extends State<AmbulanceSituationPage> {
  // --- Controllers ---
  final _allergyOtherCtrl = TextEditingController();
  final _ccCtrl = TextEditingController();
  final _pmhOtherCtrl = TextEditingController();
  final _nonTraumaAcuteOtherCtrl = TextEditingController();
  final _traumaGeneralOtherCtrl = TextEditingController();
  final _fallHeightCtrl = TextEditingController();
  final _burnDegreeCtrl = TextEditingController();
  final _burnAreaCtrl = TextEditingController();
  final _traumaOtherCtrl = TextEditingController();

  // --- States ---
  final Set<String> _traumaClass = {};
  final Set<String> _nonTraumaType = {};
  final Set<String> _nonTraumaAcutePicked = {};
  final Set<String> _nonTraumaGeneralPicked = {};
  final Set<String> _traumaTypePicked = {};
  final Set<String> _traumaGeneralBodyPicked = {};
  final Set<String> _traumaMechanismPicked = {};
  final Set<String> _allergy = {};
  String? _proxyRadio;
  final Set<String> _pmh = {};

  // --- 顏色設定 ---
  final Color optColor = const Color(0xFF2F5C56); // 墨綠色

  // --- 選項 ---
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
    '其他'
  ];

  // --- 狀態判斷 ---
  bool get _pickedNonTrauma => _traumaClass.contains('非創傷');
  bool get _pickedTrauma => _traumaClass.contains('創傷');
  bool get _pickedAcute => _nonTraumaType.contains('急症');
  bool get _pickedGeneralDisease => _nonTraumaType.contains('一般疾病');
  bool get _pickedTraumaGeneral => _traumaTypePicked.contains('一般外傷');
  bool get _pickedTraumaMech => _traumaTypePicked.contains('受傷機轉');
  bool get _pickedFall => _traumaTypePicked.contains('墜落傷');
  bool get _pickedBurn => _traumaTypePicked.contains('燒燙傷');
  bool get _pickedTraumaOther => _traumaTypePicked.contains('其他');

  @override
  void dispose() {
    _allergyOtherCtrl.dispose();
    _ccCtrl.dispose();
    _pmhOtherCtrl.dispose();
    _nonTraumaAcuteOtherCtrl.dispose();
    _traumaGeneralOtherCtrl.dispose();
    _fallHeightCtrl.dispose();
    _burnDegreeCtrl.dispose();
    _burnAreaCtrl.dispose();
    _traumaOtherCtrl.dispose();
    super.dispose();
  }

  // --- UI helpers ---
  Widget _title(String s) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(s, style: const TextStyle(fontWeight: FontWeight.w700)),
      );

  Widget _checkboxTile(String label, Set<String> set) {
    final checked = set.contains(label);
    return CheckboxListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      checkColor: Colors.white,
      activeColor: optColor,
      side: BorderSide(color: optColor, width: 2),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return optColor; // 勾選時：綠底
        }
        return Colors.white; // 沒勾選：白底
      }),
      title: Text(label),
      value: checked,
      onChanged: (v) => setState(() {
        if (v == true) {
          set.add(label);
        } else {
          set.remove(label);
        }
      }),
    );
  }

  Widget _radioTile(String label, String value) {
    final selected = _proxyRadio == value;
    return RadioListTile<String>(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return optColor;
        }
        return Colors.grey.shade400;
      }),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      groupValue: _proxyRadio,
      onChanged: (v) => setState(() => _proxyRadio = v),
      selected: selected,
    );
  }

  // ✅ 讓「其他」的輸入框更靠近上一行
  Widget _tightField({
  required String label,
  required TextEditingController controller,
  String? suffix,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 40, top: 2, bottom: 4), // 原本 32 → 改成 40 對齊
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );
}

  // ✅ 病患主訴 橫向排列
  Widget _inlineField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '請填寫病患主訴', // ✅ 加回提示文字
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Card(
          color: Colors.white,
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title('創傷分類'),
                ..._traumaClassOptions.map((e) => _checkboxTile(e, _traumaClass)),

                if (_pickedNonTrauma) ...[
                  _title('非創傷類別'),
                  ..._nonTraumaTypes.map((e) => _checkboxTile(e, _nonTraumaType)),

                  if (_pickedAcute) ...[
                    _title('非創傷急症'),
                    ..._nonTraumaAcuteOptions.map((e) => _checkboxTile(e, _nonTraumaAcutePicked)),
                    if (_nonTraumaAcutePicked.contains('其他'))
                      _tightField(label: '非創傷其他急症', controller: _nonTraumaAcuteOtherCtrl),
                  ],

                  if (_pickedGeneralDisease) ...[
                    _title('非創傷一般疾病'),
                    ..._nonTraumaGeneralOptions.map((e) => _checkboxTile(e, _nonTraumaGeneralPicked)),
                  ],
                ],

                if (_pickedTrauma) ...[
                  _title('創傷類別'),
                  ..._traumaTypeOptions.map((e) => _checkboxTile(e, _traumaTypePicked)),
                  if (_pickedTraumaOther)
                    _tightField(label: '其他創傷', controller: _traumaOtherCtrl),

                  if (_pickedTraumaGeneral) ...[
                    _title('創傷—一般外傷'),
                    ..._traumaGeneralBodyOptions.map((e) => _checkboxTile(e, _traumaGeneralBodyPicked)),
                    if (_traumaGeneralBodyPicked.contains('其他'))
                      _tightField(label: '其他—一般外傷', controller: _traumaGeneralOtherCtrl),
                  ],
                ],

                _title('過敏史'),
                ..._allergyOptions.map((e) => _checkboxTile(e, _allergy)),
                if (_allergy.contains('其他'))
                  _tightField(label: '其他過敏史', controller: _allergyOtherCtrl),

                _inlineField('病患主訴', _ccCtrl),

                _title('家屬或同事、友人代訴'),
                _radioTile('否', '否'),
                _radioTile('是', '是'),

                _title('過去病史'),
                ..._pmhOptions.map((e) => _checkboxTile(e, _pmh)),
                if (_pmh.contains('其他'))
                  _tightField(label: '其他過去病史', controller: _pmhOtherCtrl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
