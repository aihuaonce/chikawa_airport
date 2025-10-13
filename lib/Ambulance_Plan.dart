import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class AmbulancePlanPage extends StatefulWidget {
  final int visitId;
  const AmbulancePlanPage({super.key, required this.visitId});

  @override
  State<AmbulancePlanPage> createState() => _AmbulancePlanPageState();
}

class _AmbulancePlanPageState extends State<AmbulancePlanPage> {
  // 【修改】使用固定的 Key 來管理狀態，而非顯示文字
  static const List<String> emergencyTreatmentKeys = [
    'airway',
    'trauma',
    'transport',
    'cpr',
    'medication',
    'other',
  ];
  static const List<String> airwayTreatmentKeys = [
    'oral',
    'nasal',
    'suction',
    'heimlich',
    'cannula',
    'mask',
    'nrm',
    'bvm',
    'lma',
    'igel',
    'ett',
    'other',
  ];
  static const List<String> traumaTreatmentKeys = [
    'collar',
    'cleaning',
    'hemostasis',
    'fixation',
    'backboard',
    'scoop',
    'other',
  ];
  static const List<String> transportMethodKeys = ['self', 'appropriate'];
  static const List<String> cprMethodKeys = ['auto', 'manual', 'aed', 'defib'];
  static const List<String> medicationProcedureKeys = [
    'iv',
    'glucose',
    'aspirin',
    'ntg',
    'bronchodilator',
  ];
  static const List<String> otherEmergencyProcedureKeys = [
    'warmth',
    'support',
    'restraints',
    'refuseOxygen',
    'monitoring',
    'other',
  ];
  static const List<String> relationshipKeys = ['patient', 'family', 'rep'];

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

  // 【新增】將 Key 映射到翻譯文字的輔助方法
  Map<String, String> _getTranslatedOptions(AppTranslations t) {
    return {
      // Emergency
      'airway': t.airwayTreatment,
      'trauma': t.traumaTreatment,
      'transport': t.transport,
      'cpr': t.cpr,
      'medication': t.medicationProcedure,
      'other': t.otherProcedure,
      // Airway
      'oral': t.oralAirway, 'nasal': t.nasalAirway, 'suction': t.suction,
      'heimlich': t.heimlichManeuver, 'cannula': t.nasalCannula, 'mask': t.mask,
      'nrm': t.nonRebreatherMask, 'bvm': t.bvm, 'lma': t.lma, 'igel': t.igel,
      'ett': t.endotrachealTube,
      // Trauma
      'collar': t.cervicalCollar,
      'cleaning': t.woundCleaning,
      'hemostasis': t.hemostasisBandaging,
      'fixation': t.fractureFixation,
      'backboard': t.longBackboard,
      'scoop': t.scoopStretcher,
      // Transport
      'self': t.walkToVehicle, 'appropriate': t.appropriateTransport,
      // CPR
      'auto': t.autoCpr,
      'manual': t.manualCpr,
      'aed': t.aed,
      'defib': t.manualDefibrillator,
      // Medication
      'iv': t.ivFluid, 'glucose': t.oralGlucose, 'aspirin': t.assistAspirin,
      'ntg': t.assistNtg, 'bronchodilator': t.assistBronchodilator,
      // Other Emergency
      'warmth': t.warmth,
      'support': t.psychologicalSupport,
      'restraints': t.restraints,
      'refuseOxygen': t.refuseOxygen, 'monitoring': t.vitalSignsMonitoring,
      // Relationship
      'patient': t.patient, 'family': t.familyMember, 'rep': t.representative,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context); // 【新增】
    final optionLabels = _getTranslatedOptions(t); // 【新增】

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
                      _buildSectionTitle(t.emergencyTreatment),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: emergencyTreatmentKeys.map((key) {
                          return _buildCheckboxOption(
                            optionLabels[key]!,
                            data.emergencyTreatments[key] ?? false,
                            (val) {
                              final newMap = Map<String, bool>.from(
                                data.emergencyTreatments,
                              );
                              newMap[key] = val;
                              data.updatePlan(emergencyTreatments: newMap);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      if (data.emergencyTreatments['airway'] == true)
                        _buildSubOptions(
                          t.airwayTreatment,
                          airwayTreatmentKeys,
                          optionLabels,
                          data.airwayTreatments,
                          'airwayOtherController',
                          (newMap) => data.updatePlan(airwayTreatments: newMap),
                        ),
                      if (data.emergencyTreatments['trauma'] == true)
                        _buildSubOptions(
                          t.traumaTreatment,
                          traumaTreatmentKeys,
                          optionLabels,
                          data.traumaTreatments,
                          null,
                          (newMap) => data.updatePlan(traumaTreatments: newMap),
                        ),
                      if (data.emergencyTreatments['transport'] == true)
                        _buildSubOptions(
                          t.transport,
                          transportMethodKeys,
                          optionLabels,
                          data.transportMethods,
                          null,
                          (newMap) => data.updatePlan(transportMethods: newMap),
                        ),
                      if (data.emergencyTreatments['cpr'] == true)
                        _buildSubOptions(
                          t.cpr,
                          cprMethodKeys,
                          optionLabels,
                          data.cprMethods,
                          null,
                          (newMap) => data.updatePlan(cprMethods: newMap),
                        ),
                      if (data.emergencyTreatments['medication'] == true)
                        _buildSubOptions(
                          t.medicationProcedure,
                          medicationProcedureKeys,
                          optionLabels,
                          data.medicationProcedures,
                          null,
                          (newMap) =>
                              data.updatePlan(medicationProcedures: newMap),
                        ),
                      if (data.emergencyTreatments['other'] == true)
                        _buildSubOptions(
                          t.otherProcedure,
                          otherEmergencyProcedureKeys,
                          optionLabels,
                          data.otherEmergencyProcedures,
                          'otherEmergencyOtherController',
                          (newMap) =>
                              data.updatePlan(otherEmergencyProcedures: newMap),
                        ),

                      _buildSectionTitle(t.bodyDiagram),
                      const SizedBox(height: 6),
                      Center(/* ... 人形圖 UI ... */),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.editBodyDiagram)),
                              ),
                          child: Text(t.clickToEditDiagram),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTitleWithInput(
                        t.bodyDiagramNote,
                        _controllers['bodyDiagramNoteController']!,
                        t.enterNote,
                      ),
                      const SizedBox(height: 12),

                      _buildSectionTitle(t.aslTreatment),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: [
                          _buildCheckboxOption(
                            t.endotrachealTube,
                            data.aslType == 'ett',
                            (v) => data.updatePlan(aslType: v ? 'ett' : null),
                          ),
                          _buildCheckboxOption(
                            t.aslManualDefib,
                            data.aslType == 'defib',
                            (v) => data.updatePlan(aslType: v ? 'defib' : null),
                          ),
                        ],
                      ),
                      if (data.aslType == 'ett') ...[
                        const SizedBox(height: 8),
                        _buildTitleWithInput(
                          t.ettNumber,
                          _controllers['ettSizeController']!,
                          t.enterEttNumber,
                        ),
                        const SizedBox(height: 8),
                        _buildTitleWithInput(
                          t.ettDepth,
                          _controllers['ettDepthController']!,
                          t.enterEttDepth,
                        ),
                      ],
                      if (data.aslType == 'defib') ...[
                        const SizedBox(height: 8),
                        _buildTitleWithInput(
                          t.manualDefibCount,
                          _controllers['manualDefibCountController']!,
                          t.enterDefibCount,
                        ),
                        const SizedBox(height: 8),
                        _buildTitleWithInput(
                          t.manualDefibJoules,
                          _controllers['manualDefibJoulesController']!,
                          t.enterDefibJoules,
                        ),
                      ],
                      const SizedBox(height: 12),

                      _buildTitleWithInput(
                        t.onlineMedicalDirection,
                        _controllers['guideController']!,
                        t.enterInstructions,
                      ),
                      const SizedBox(height: 12),

                      _buildTitleWithInput(
                        t.receivingUnit,
                        _controllers['receivingUnitController']!,
                        t.enterReceivingUnit,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            t.receivingTime,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat(
                              t.yearMonthDayHourMinuteFormat,
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
                            child: Text(t.updateTime),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildSectionTitle(t.refuseTransport),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: [
                          _buildRadioOption(
                            t.no,
                            false,
                            data.isRejection,
                            (v) => data.updatePlan(isRejection: v),
                          ),
                          _buildRadioOption(
                            t.yes,
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
                              Text(
                                t.refusalStatement,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.refusalText,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '${t.name}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _controllers['rejectionNameController']!,
                                      onChanged: (_) => _saveToProvider(),
                                      decoration: InputDecoration(
                                        hintText: t.enterName,
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
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

                      _buildSectionTitle(t.relationship),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: relationshipKeys.map((key) {
                          return _buildRadioOption(
                            optionLabels[key]!,
                            key,
                            data.relationshipType,
                            (v) => data.updatePlan(relationshipType: v),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      _buildTitleWithInput(
                        t.representativeName,
                        _controllers['contactNameController']!,
                        t.enterRepresentativeName,
                      ),
                      const SizedBox(height: 8),
                      _buildTitleWithInput(
                        t.representativePhone,
                        _controllers['contactPhoneController']!,
                        t.enterRepresentativePhone,
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

  // Helper Widgets (已更新以適應多語系)
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
    List<String> optionKeys,
    Map<String, String> optionLabels,
    Map<String, bool> stateMap,
    String? otherControllerKey,
    Function(Map<String, bool>) onUpdate,
  ) {
    final t = AppTranslations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          children: optionKeys.map((key) {
            return _buildCheckboxOption(
              optionLabels[key]!,
              stateMap[key] ?? false,
              (val) {
                final newMap = Map<String, bool>.from(stateMap);
                newMap[key] = val;
                onUpdate(newMap);
              },
            );
          }).toList(),
        ),
        if (otherControllerKey != null && stateMap['other'] == true) ...[
          const SizedBox(height: 8),
          _buildTitleWithInput(
            t.otherExplanation,
            _controllers[otherControllerKey]!,
            t.enterOtherExplanationHint,
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
