import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

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

  // --- 選項 Keys (靜態) ---
  // 【修改】使用固定的 Key 來管理選項狀態，而非顯示文字
  static const _traumaClassKeys = ['non_trauma', 'trauma'];
  static const _nonTraumaTypeKeys = ['acute', 'general'];
  static const _nonTraumaAcuteKeys = [
    'breathing',
    'airway',
    'coma',
    'chest_pain',
    'abdominal_pain',
    'poisoning',
    'co_poisoning',
    'seizure',
    'collapsed',
    'psychiatric',
    'labor',
    'ohca',
    'other',
  ];
  static const _nonTraumaGeneralKeys = [
    'headache',
    'fainting',
    'fever',
    'nausea',
    'weakness',
  ];
  static const _traumaTypeKeys = [
    'general',
    'mechanism',
    'drowning',
    'fall_injury',
    'fall_height',
    'puncture',
    'burns',
    'electric',
    'bite',
    'ohca',
    'other',
  ];
  static const _traumaGeneralBodyKeys = [
    'head',
    'chest',
    'abdomen',
    'back',
    'limb',
    'other',
  ];
  static const _traumaMechanismKeys = ['traffic', 'non_traffic'];
  static const _allergyKeys = [
    'none',
    'unknown',
    'food',
    'medication',
    'other',
  ];
  static const _pmhKeys = [
    'none',
    'unknown',
    'hbp',
    'dm',
    'copd',
    'asthma',
    'cvd',
    'heart_disease',
    'kidney',
    'liver',
    'other',
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

  // 【新增】將 Key 映射到翻譯文字的輔助方法
  Map<String, String> _getTranslatedOptions(AppTranslations t) {
    return {
      'non_trauma': t.nonTrauma,
      'trauma': t.trauma,
      'acute': t.acuteCondition,
      'general': t.generalSickness,
      'breathing': t.breathingDifficulty,
      'airway': t.airwayObstruction,
      'coma': t.comaUnconscious,
      'chest_pain': t.chestPainTightness,
      'abdominal_pain': t.abdominalPain,
      'poisoning': t.suspectedPoisoning,
      'co_poisoning': t.suspectedCOPoisoning,
      'seizure': t.seizureConvulsion,
      'collapsed': t.foundCollapsed,
      'psychiatric': t.psychiatricSymptoms,
      'labor': t.precipitousLabor,
      'ohca': t.ohca,
      'other': t.other,
      'headache': t.headacheDizziness,
      'fainting': t.faintingSyncope,
      'fever': t.fever,
      'nausea': t.nauseaVomitingDiarrhea,
      'weakness': t.limbWeakness,
      'mechanism': t.mechanismOfInjury,
      'drowning': t.drowning,
      'fall_injury': t.fallInjury,
      'fall_height': t.fallFromHeight,
      'puncture': t.punctureWound,
      'burns': t.burns,
      'electric': t.electricShock,
      'bite': t.biteSting,
      'head': t.headInjury,
      'chest': t.chestInjury,
      'abdomen': t.abdominalInjury,
      'back': t.backInjury,
      'limb': t.limbInjury,
      'traffic': t.trafficAccident,
      'non_traffic': t.nonTrafficAccident,
      'none': t.none,
      'unknown': t.unknown,
      'food': t.food,
      'medication': t.medication,
      'hbp': t.hypertension,
      'dm': t.diabetes,
      'copd': t.copd,
      'asthma': t.asthma,
      'cvd': t.cerebrovascularDisease,
      'heart_disease': t.heartDisease,
      'kidney': t.kidneyDiseaseDialysis,
      'liver': t.liverDisease,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context); // 【新增】
    final optionLabels = _getTranslatedOptions(t); // 【新增】

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        // 【修改】UI 顯示邏輯改為依賴固定的 key
        final bool pickedNonTrauma = data.traumaClass.contains('non_trauma');
        final bool pickedTrauma = data.traumaClass.contains('trauma');
        final bool pickedAcute = data.nonTraumaType.contains('acute');
        final bool pickedGeneralDisease = data.nonTraumaType.contains(
          'general',
        );
        final bool pickedTraumaGeneral = data.traumaTypePicked.contains(
          'general',
        );
        final bool pickedTraumaMech = data.traumaTypePicked.contains(
          'mechanism',
        );
        final bool pickedFall = data.traumaTypePicked.contains('fall_height');
        final bool pickedBurn = data.traumaTypePicked.contains('burns');
        final bool pickedTraumaOther = data.traumaTypePicked.contains('other');

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
                      _title(t.traumaClassification),
                      ..._traumaClassKeys.map(
                        (key) => _checkboxTile(
                          label: optionLabels[key]!,
                          isChecked: data.traumaClass.contains(key),
                          onChanged: (isChecked) {
                            final newSet = Set<String>.from(data.traumaClass);
                            if (isChecked)
                              newSet.add(key);
                            else
                              newSet.remove(key);
                            data.updateSituation(traumaClass: newSet);
                          },
                        ),
                      ),
                      if (pickedNonTrauma) ...[
                        _title(t.nonTraumaCategory),
                        ..._nonTraumaTypeKeys.map(
                          (key) => _checkboxTile(
                            label: optionLabels[key]!,
                            isChecked: data.nonTraumaType.contains(key),
                            onChanged: (isChecked) {
                              final newSet = Set<String>.from(
                                data.nonTraumaType,
                              );
                              if (isChecked)
                                newSet.add(key);
                              else
                                newSet.remove(key);
                              data.updateSituation(nonTraumaType: newSet);
                            },
                          ),
                        ),
                        if (pickedAcute) ...[
                          _title(t.nonTraumaAcute),
                          ..._nonTraumaAcuteKeys.map(
                            (key) => _checkboxTile(
                              label: optionLabels[key]!,
                              isChecked: data.nonTraumaAcutePicked.contains(
                                key,
                              ),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.nonTraumaAcutePicked,
                                );
                                if (isChecked)
                                  newSet.add(key);
                                else
                                  newSet.remove(key);
                                data.updateSituation(
                                  nonTraumaAcutePicked: newSet,
                                );
                              },
                            ),
                          ),
                          if (data.nonTraumaAcutePicked.contains('other'))
                            _tightField(
                              label: t.otherNonTraumaAcute,
                              controller: _controllers['nonTraumaAcuteOther']!,
                            ),
                        ],
                        if (pickedGeneralDisease) ...[
                          _title(t.nonTraumaGeneral),
                          ..._nonTraumaGeneralKeys.map(
                            (key) => _checkboxTile(
                              label: optionLabels[key]!,
                              isChecked: data.nonTraumaGeneralPicked.contains(
                                key,
                              ),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.nonTraumaGeneralPicked,
                                );
                                if (isChecked)
                                  newSet.add(key);
                                else
                                  newSet.remove(key);
                                data.updateSituation(
                                  nonTraumaGeneralPicked: newSet,
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                      if (pickedTrauma) ...[
                        _title(t.traumaCategory),
                        ..._traumaTypeKeys.map(
                          (key) => _checkboxTile(
                            label: key == 'general'
                                ? t.generalTrauma
                                : optionLabels[key]!, // 特殊處理 'general'
                            isChecked: data.traumaTypePicked.contains(key),
                            onChanged: (isChecked) {
                              final newSet = Set<String>.from(
                                data.traumaTypePicked,
                              );
                              if (isChecked)
                                newSet.add(key);
                              else
                                newSet.remove(key);
                              data.updateSituation(traumaTypePicked: newSet);
                            },
                          ),
                        ),
                        if (pickedTraumaOther)
                          _tightField(
                            label: t.otherTrauma,
                            controller: _controllers['traumaOther']!,
                          ),
                        if (pickedTraumaGeneral) ...[
                          _title(t.traumaGeneralInjury),
                          ..._traumaGeneralBodyKeys.map(
                            (key) => _checkboxTile(
                              label: optionLabels[key]!,
                              isChecked: data.traumaGeneralBodyPicked.contains(
                                key,
                              ),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.traumaGeneralBodyPicked,
                                );
                                if (isChecked)
                                  newSet.add(key);
                                else
                                  newSet.remove(key);
                                data.updateSituation(
                                  traumaGeneralBodyPicked: newSet,
                                );
                              },
                            ),
                          ),
                          if (data.traumaGeneralBodyPicked.contains('other'))
                            _tightField(
                              label: t.otherGeneralTrauma,
                              controller: _controllers['traumaGeneralOther']!,
                            ),
                        ],
                        if (pickedTraumaMech) ...[
                          _title(t.traumaMechanismOfInjury),
                          ..._traumaMechanismKeys.map(
                            (key) => _checkboxTile(
                              label: optionLabels[key]!,
                              isChecked: data.traumaMechanismPicked.contains(
                                key,
                              ),
                              onChanged: (isChecked) {
                                final newSet = Set<String>.from(
                                  data.traumaMechanismPicked,
                                );
                                if (isChecked)
                                  newSet.add(key);
                                else
                                  newSet.remove(key);
                                data.updateSituation(
                                  traumaMechanismPicked: newSet,
                                );
                              },
                            ),
                          ),
                        ],
                        if (pickedFall)
                          _tightField(
                            label: t.heightMeters,
                            controller: _controllers['fallHeight']!,
                          ),
                        if (pickedBurn) ...[
                          _tightField(
                            label: t.burnDegree,
                            controller: _controllers['burnDegree']!,
                          ),
                          _tightField(
                            label: t.burnAreaPercentage,
                            controller: _controllers['burnArea']!,
                          ),
                        ],
                      ],
                      _title(t.allergyHistory),
                      ..._allergyKeys.map(
                        (key) => _checkboxTile(
                          label: optionLabels[key]!,
                          isChecked: data.allergy.contains(key),
                          onChanged: (isChecked) {
                            final newSet = Set<String>.from(data.allergy);
                            if (isChecked)
                              newSet.add(key);
                            else
                              newSet.remove(key);
                            data.updateSituation(allergy: newSet);
                          },
                        ),
                      ),
                      if (data.allergy.contains('other'))
                        _tightField(
                          label: t.otherAllergyHistory,
                          controller: _controllers['allergyOther']!,
                        ),
                      _inlineField(
                        t.chiefComplaint,
                        _controllers['chiefComplaint']!,
                        t.enterChiefComplaintHint,
                      ),
                      _title(t.statementByProxy),
                      _radioTile(
                        t.no,
                        false,
                        data.isProxyStatement,
                        (val) => data.updateSituation(isProxyStatement: val),
                      ),
                      _radioTile(
                        t.yes,
                        true,
                        data.isProxyStatement,
                        (val) => data.updateSituation(isProxyStatement: val),
                      ),
                      _title(t.pastMedicalHistory),
                      ..._pmhKeys.map(
                        (key) => _checkboxTile(
                          label: optionLabels[key]!,
                          isChecked: data.pmh.contains(key),
                          onChanged: (isChecked) {
                            final newSet = Set<String>.from(data.pmh);
                            if (isChecked)
                              newSet.add(key);
                            else
                              newSet.remove(key);
                            data.updateSituation(pmh: newSet);
                          },
                        ),
                      ),
                      if (data.pmh.contains('other'))
                        _tightField(
                          label: t.otherPastMedicalHistory,
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

  // --- UI 小積木 (已更新以適應多語系) ---
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

  Widget _inlineField(
    String label,
    TextEditingController controller,
    String hint,
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
              onChanged: (_) => _saveToProvider(),
              decoration: InputDecoration(
                hintText: hint, // 【修改】
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
