import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/models/ambulance_data.dart';
import 'data/models/medication_record_model.dart';
import 'data/models/paramedic_record_model.dart';
import 'data/models/vital_sign_record_model.dart';
import 'l10n/app_translations.dart';

class AmbulancePlanPage extends StatefulWidget {
  final int visitId;
  const AmbulancePlanPage({super.key, required this.visitId});

  @override
  State<AmbulancePlanPage> createState() => _AmbulancePlanPageState();
}

class _AmbulancePlanPageState extends State<AmbulancePlanPage> {
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
    'airwayOtherController': TextEditingController(),
    'traumaOtherController': TextEditingController(), // 【新增】
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
    _controllers['airwayOtherController']!.text = data.airwayOther ?? '';
    // 【修改】將 traumaOtherController 對應到 bodyDiagramNote
    _controllers['traumaOtherController']!.text = data.bodyDiagramNote ?? '';
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
      airwayOther: _controllers['airwayOtherController']!.text,
      // 【修改】將 traumaOtherController 的值存回 bodyDiagramNote
      bodyDiagramNote: _controllers['traumaOtherController']!.text,
      otherEmergencyOther: _controllers['otherEmergencyOtherController']!.text,
      ettSize: _controllers['ettSizeController']!.text,
      ettDepth: _controllers['ettDepthController']!.text,
      manualDefibCount: _controllers['manualDefibCountController']!.text,
      manualDefibJoules: _controllers['manualDefibJoulesController']!.text,
      rejectionName: _controllers['rejectionNameController']!.text,
    );
  }

  Map<String, String> _getTranslatedOptions(AppTranslations t) {
    return {
      // Emergency
      'airway': t.airwayTreatment,
      'trauma': t.traumaTreatment,
      'transport': t.transport,
      'cpr': t.cpr,
      'medication': t.medicationProcedure,
      'other': t.otherProcedure,
      'oral': t.oralAirway,
      'nasal': t.nasalAirway,
      'suction': t.suction,
      'heimlich': t.heimlichManeuver,
      'cannula': t.nasalCannula,
      'mask': t.mask,
      'nrm': t.nonRebreatherMask,
      'bvm': t.bvm,
      'lma': t.lma,
      'igel': t.igel,
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
      'iv': t.ivFluid,
      'glucose': t.oralGlucose,
      'aspirin': t.assistAspirin,
      'ntg': t.assistNtg,
      'bronchodilator': t.assistBronchodilator,
      'warmth': t.warmth,
      'support': t.psychologicalSupport,
      'restraints': t.restraints,
      'refuseOxygen': t.refuseOxygen,
      'monitoring': t.vitalSignsMonitoring,
      'patient': t.patient, 'family': t.familyMember, 'rep': t.representative,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final optionLabels = _getTranslatedOptions(t);

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        final aslTypes = (data.aslType ?? '')
            .split(',')
            .where((s) => s.isNotEmpty)
            .toSet();
        final isEttSelected = aslTypes.contains('ett');
        final isDefibSelected = aslTypes.contains('defib');

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              // As requested: maxWidth 1000
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  // As requested: Card styles
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(t.emergencyTreatment),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
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
                          'traumaOtherController',
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

                      _buildMedicationSection(t, data),
                      const SizedBox(height: 12),

                      _buildSectionTitle(t.aslTreatment),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: [
                          _buildCheckboxOption(
                            t.endotrachealTube,
                            isEttSelected,
                            (v) {
                              final newTypes = Set<String>.from(aslTypes);
                              if (v) {
                                newTypes.add('ett');
                              } else {
                                newTypes.remove('ett');
                                _controllers['ettSizeController']!.clear();
                                _controllers['ettDepthController']!.clear();
                                data.updatePlan(ettSize: null, ettDepth: null);
                              }
                              data.updatePlan(
                                aslType: newTypes.isEmpty
                                    ? null
                                    : newTypes.join(','),
                              );
                            },
                          ),
                          _buildCheckboxOption(
                            t.aslManualDefib,
                            isDefibSelected,
                            (v) {
                              final newTypes = Set<String>.from(aslTypes);
                              if (v) {
                                newTypes.add('defib');
                              } else {
                                newTypes.remove('defib');
                                _controllers['manualDefibCountController']!
                                    .clear();
                                _controllers['manualDefibJoulesController']!
                                    .clear();
                                data.updatePlan(
                                  manualDefibCount: null,
                                  manualDefibJoules: null,
                                );
                              }
                              data.updatePlan(
                                aslType: newTypes.isEmpty
                                    ? null
                                    : newTypes.join(','),
                              );
                            },
                          ),
                        ],
                      ),
                      if (isEttSelected) ...[
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
                      if (isDefibSelected) ...[
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

                      _buildVitalSignsSection(t, data),
                      const SizedBox(height: 12),

                      const SizedBox(height: 12),
                      _buildParamedicSection(t, data),

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
                              backgroundColor: const Color(
                                0xFF83ACA9,
                              ), // As requested
                              foregroundColor: Colors.white, // As requested
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
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 10,
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

  Widget _buildMedicationSection(AppTranslations t, AmbulanceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(t.medicationRecord),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildMedicationTableHeader(t),
              if (data.medicationRecords.isNotEmpty)
                ...data.medicationRecords.asMap().entries.map((entry) {
                  final index = entry.key;
                  final record = entry.value;
                  return _buildMedicationTableRow(
                    context,
                    t,
                    record,
                    index,
                    data,
                  );
                }),
              _buildAddMedicationRowButton(context, t, data),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationTableHeader(AppTranslations t) {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(t.time, style: headerStyle)),
          Expanded(flex: 2, child: Text(t.medicationName, style: headerStyle)),
          Expanded(flex: 2, child: Text(t.usage, style: headerStyle)),
          Expanded(flex: 2, child: Text(t.doseUnit, style: headerStyle)),
          Expanded(flex: 2, child: Text(t.emtName, style: headerStyle)), // 執行者
          const SizedBox(width: 48), // For actions
        ],
      ),
    );
  }

  // 【修改】移除重複的 _buildAddMedicationRowButton 函式
  Widget _buildAddMedicationRowButton(
    BuildContext context,
    AppTranslations t,
    AmbulanceData data,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF83ACA9), // As requested
            foregroundColor: Colors.white, // As requested
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final result = await showDialog<MedicationRecordModel>(
              context: context,
              builder: (ctx) => _MedicationRecordDialog(t: t),
            );
            if (result != null) {
              final updatedList = List<MedicationRecordModel>.from(
                data.medicationRecords,
              )..add(result);
              data.updatePlan(medicationRecords: updatedList);
            }
          },
          child: Text(t.addMedicationRecord), // "新增藥物記錄"
        ),
      ),
    );
  }

  // ... (Helper widgets _buildSectionTitle, _buildTitleWithInput, etc. are unchanged)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
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
          activeColor: const Color(0xFF274C4A), // As requested
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
          activeColor: const Color(0xFF274C4A), // As requested
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
          runSpacing: 4,
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

  Widget _buildParamedicSection(AppTranslations t, AmbulanceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(t.paramedics), // 假設 t.paramedics = '隨車救護人員'
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildParamedicTableHeader(t),
              if (data.paramedicRecords.isNotEmpty)
                ...data.paramedicRecords.asMap().entries.map((entry) {
                  return _buildParamedicTableRow(
                    context,
                    t,
                    entry.value,
                    entry.key,
                    data,
                  );
                }),
              _buildAddParamedicRowButton(context, t, data),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParamedicTableHeader(AppTranslations t) {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(t.name, style: headerStyle)), // 姓名
          Expanded(flex: 4, child: Text(t.signature, style: headerStyle)), // 簽名
          const SizedBox(width: 48), // 給刪除按鈕留空間
        ],
      ),
    );
  }

  Widget _buildParamedicTableRow(
    BuildContext context,
    AppTranslations t,
    ParamedicRecordModel record,
    int index,
    AmbulanceData data,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(record.name)),
          Expanded(
            flex: 4,
            child: record.signature != null
                ? Container(
                    height: 40, // 限制簽名圖片的高度
                    alignment: Alignment.centerLeft,
                    child: Image.memory(record.signature!, fit: BoxFit.contain),
                  )
                : Text(
                    t.noSignature,
                    style: const TextStyle(color: Colors.grey),
                  ),
          ),
          SizedBox(
            width: 48,
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: () {
                final updatedList = List<ParamedicRecordModel>.from(
                  data.paramedicRecords,
                )..removeAt(index);
                data.updatePlan(paramedicRecords: updatedList);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddParamedicRowButton(
    BuildContext context,
    AppTranslations t,
    AmbulanceData data,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF83ACA9), // As requested
            foregroundColor: Colors.white, // As requested
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final result = await showDialog<ParamedicRecordModel>(
              context: context,
              builder: (ctx) => _ParamedicRecordDialog(t: t),
            );
            if (result != null) {
              final updatedList = List<ParamedicRecordModel>.from(
                data.paramedicRecords,
              )..add(result);
              data.updatePlan(paramedicRecords: updatedList);
            }
          },
          child: Text(t.addParamedic),
        ),
      ),
    );
  }

  Widget _buildVitalSignsSection(AppTranslations t, AmbulanceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("生命徵象記錄"), // 之後可替換為 t.vitalSignsRecord
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildVitalSignsTableHeader(t),
              if (data.vitalSignsRecords.isNotEmpty)
                ...data.vitalSignsRecords.asMap().entries.map((entry) {
                  return _buildVitalSignsTableRow(
                    context,
                    t,
                    entry.value,
                    entry.key,
                    data,
                  );
                }),
              _buildAddVitalSignRowButton(context, t, data),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignsTableHeader(AppTranslations t) {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 12,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const Expanded(flex: 3, child: Text("記錄時間", style: headerStyle)),
          const Expanded(flex: 2, child: Text("到院後", style: headerStyle)),
          const Expanded(flex: 2, child: Text("意識", style: headerStyle)),
          const Expanded(flex: 2, child: Text("體溫", style: headerStyle)),
          const Expanded(flex: 2, child: Text("脈搏", style: headerStyle)),
          const Expanded(flex: 2, child: Text("呼吸", style: headerStyle)),
          const Expanded(flex: 3, child: Text("血壓", style: headerStyle)),
          const Expanded(flex: 2, child: Text("血氧", style: headerStyle)),
          const Expanded(flex: 2, child: Text("GCS", style: headerStyle)),
          const SizedBox(width: 48), // 刪除按鈕的空間
        ],
      ),
    );
  }

  Widget _buildVitalSignsTableRow(
    BuildContext context,
    AppTranslations t,
    VitalSignRecordModel record,
    int index,
    AmbulanceData data,
  ) {
    final textStyle = const TextStyle(fontSize: 12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              DateFormat('HH:mm:ss').format(record.recordTime),
              style: textStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(record.atHospital ? "是" : "否", style: textStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(record.consciousness ?? '-', style: textStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(record.temperature ?? '-', style: textStyle),
          ),
          Expanded(flex: 2, child: Text(record.pulse ?? '-', style: textStyle)),
          Expanded(
            flex: 2,
            child: Text(record.respiration ?? '-', style: textStyle),
          ),
          Expanded(
            flex: 3,
            child: Text(record.bloodPressure ?? '-', style: textStyle),
          ),
          Expanded(flex: 2, child: Text(record.spo2 ?? '-', style: textStyle)),
          Expanded(flex: 2, child: Text(record.gcsTotal, style: textStyle)),
          SizedBox(
            width: 48,
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: () {
                final updatedList = List<VitalSignRecordModel>.from(
                  data.vitalSignsRecords,
                )..removeAt(index);
                data.updatePlan(vitalSignsRecords: updatedList);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddVitalSignRowButton(
    BuildContext context,
    AppTranslations t,
    AmbulanceData data,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF83ACA9), // As requested
            foregroundColor: Colors.white, // As requested
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final result = await showDialog<VitalSignRecordModel>(
              context: context,
              builder: (ctx) => _VitalSignRecordDialog(t: t),
            );
            if (result != null) {
              final updatedList = List<VitalSignRecordModel>.from(
                data.vitalSignsRecords,
              )..add(result);
              data.updatePlan(vitalSignsRecords: updatedList);
            }
          },
          child: const Text("新增生命徵象記錄"), // 之後可替換為 t.addVitalSignRecord
        ),
      ),
    );
  }
}

// Dialog class remains unchanged
class _MedicationRecordDialog extends StatefulWidget {
  final AppTranslations t;
  const _MedicationRecordDialog({required this.t});

  @override
  State<_MedicationRecordDialog> createState() =>
      _MedicationRecordDialogState();
}

class _MedicationRecordDialogState extends State<_MedicationRecordDialog> {
  late DateTime _recordTime;
  final _nameController = TextEditingController();
  final _routeController = TextEditingController();
  final _doseController = TextEditingController();
  final _executorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recordTime = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _routeController.dispose();
    _doseController.dispose();
    _executorController.dispose();
    super.dispose();
  }

  void _onSave() {
    final newRecord = MedicationRecordModel(
      recordTime: _recordTime,
      name: _nameController.text.trim(),
      route: _routeController.text.trim(),
      dose: _doseController.text.trim(),
      executor: _executorController.text.trim(),
    );
    Navigator.of(context).pop(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('yyyy年MM月dd日 HH時mm分ss秒');
    // Define the button style once to be reused, as per your spec
    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF83ACA9), // As requested
      foregroundColor: Colors.white, // As requested
    );

    return AlertDialog(
      title: Text("創建 藥物紀錄"),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("紀錄時間", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(timeFormat.format(_recordTime)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: actionButtonStyle,
                    onPressed: () =>
                        setState(() => _recordTime = DateTime.now()),
                    child: Text(widget.t.updateTime),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputDialogField(
                widget.t.medicationName,
                _nameController,
                "請輸入藥名",
              ),
              const SizedBox(height: 12),
              _buildInputDialogField(widget.t.usage, _routeController, "請輸入途徑"),
              const SizedBox(height: 12),
              _buildInputDialogField(
                widget.t.doseUnit,
                _doseController,
                "請輸入劑量",
              ),
              const SizedBox(height: 12),
              _buildInputDialogField(
                widget.t.emtName,
                _executorController,
                "請輸入執行者",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.t.discard),
        ),
        ElevatedButton(
          style: actionButtonStyle,
          onPressed: _onSave,
          child: Text(widget.t.saveAndClose),
        ),
      ],
    );
  }

  Widget _buildInputDialogField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

// Assume _buildMedicationTableRow is defined elsewhere or not shown in the original snippet,
// so it's omitted here for brevity. You should keep it if it exists in your full code.
Widget _buildMedicationTableRow(
  BuildContext context,
  AppTranslations t,
  MedicationRecordModel record,
  int index,
  AmbulanceData data,
) {
  // This is a placeholder implementation.
  // Please use your actual implementation for this widget.
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.grey.shade200)),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(DateFormat('HH:mm:ss').format(record.recordTime)),
        ),
        Expanded(flex: 2, child: Text(record.name)),
        Expanded(flex: 2, child: Text(record.route)),
        Expanded(flex: 2, child: Text(record.dose)),
        Expanded(flex: 2, child: Text(record.executor)),
        SizedBox(
          width: 48,
          child: IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
            onPressed: () {
              final updatedList = List<MedicationRecordModel>.from(
                data.medicationRecords,
              )..removeAt(index);
              data.updatePlan(medicationRecords: updatedList);
            },
          ),
        ),
      ],
    ),
  );
}

class _ParamedicRecordDialog extends StatefulWidget {
  final AppTranslations t;
  const _ParamedicRecordDialog({required this.t});

  @override
  State<_ParamedicRecordDialog> createState() => _ParamedicRecordDialogState();
}

class _ParamedicRecordDialogState extends State<_ParamedicRecordDialog> {
  final _nameController = TextEditingController();
  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.t.pleaseEnterName),
        ), // t.pleaseEnterName = '請輸入姓名'
      );
      return;
    }

    final signature = await _signatureController.toPngBytes();

    final newRecord = ParamedicRecordModel(
      name: _nameController.text.trim(),
      signature: _signatureController.isNotEmpty ? signature : null,
    );
    Navigator.of(context).pop(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    // Define the button style once to be reused, as per your spec
    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF83ACA9), // As requested
      foregroundColor: Colors.white, // As requested
    );

    return AlertDialog(
      title: Text(widget.t.addParamedic),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.t.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: widget.t.enterName,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.t.signature,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Signature(
                  controller: _signatureController,
                  height: 150,
                  backgroundColor: Colors.grey[100]!,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _signatureController.clear(),
                  child: Text(
                    widget.t.clearSignature,
                  ), // t.clearSignature = '清除簽名'
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.t.discard),
        ),
        ElevatedButton(
          style: actionButtonStyle,
          onPressed: _onSave,
          child: Text(widget.t.saveAndClose),
        ),
      ],
    );
  }
}

class _VitalSignRecordDialog extends StatefulWidget {
  final AppTranslations t;
  const _VitalSignRecordDialog({required this.t});

  @override
  State<_VitalSignRecordDialog> createState() => _VitalSignRecordDialogState();
}

class _VitalSignRecordDialogState extends State<_VitalSignRecordDialog> {
  late DateTime _recordTime;
  bool _atHospital = true;
  String? _consciousness = '清';
  final _triageStationController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _pulseController = TextEditingController();
  final _respirationController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _gcsEController = TextEditingController();
  final _gcsVController = TextEditingController();
  final _gcsMController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recordTime = DateTime.now();
  }

  @override
  void dispose() {
    _triageStationController.dispose();
    _temperatureController.dispose();
    _pulseController.dispose();
    _respirationController.dispose();
    _bloodPressureController.dispose();
    _spo2Controller.dispose();
    _gcsEController.dispose();
    _gcsVController.dispose();
    _gcsMController.dispose();
    super.dispose();
  }

  void _onSave() {
    final newRecord = VitalSignRecordModel(
      recordTime: _recordTime,
      atHospital: _atHospital,
      triageStation: _triageStationController.text.trim(),
      consciousness: _consciousness,
      temperature: _temperatureController.text.trim(),
      pulse: _pulseController.text.trim(),
      respiration: _respirationController.text.trim(),
      bloodPressure: _bloodPressureController.text.trim(),
      spo2: _spo2Controller.text.trim(),
      gcsE: _gcsEController.text.trim(),
      gcsV: _gcsVController.text.trim(),
      gcsM: _gcsMController.text.trim(),
    );
    Navigator.of(context).pop(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('yyyy年MM月dd日 HH時mm分ss秒');
    // Define the button style once to be reused, as per your spec
    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF83ACA9), // As requested
      foregroundColor: Colors.white, // As requested
    );

    return AlertDialog(
      title: const Text("創建 生命徵象記錄"),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeRow(timeFormat, actionButtonStyle),
              _buildAtHospitalRow(),
              _buildConsciousnessRow(),
              _buildTextField("體溫(°C)", _temperatureController, "請填寫體溫度數"),
              _buildTextField("脈搏(次/min)", _pulseController, "請填寫脈搏次數"),
              _buildTextField("呼吸(次/min)", _respirationController, "請填寫呼吸次數"),
              _buildTextField("血壓(mmHg)", _bloodPressureController, "請填寫血壓數值"),
              _buildTextField("血氧(%)", _spo2Controller, "請填寫血氧濃度"),
              _buildTextField("GCS-E", _gcsEController, "請填寫"),
              _buildTextField("GCS-V", _gcsVController, "請填寫"),
              _buildTextField("GCS-M", _gcsMController, "請填寫"),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("捨棄"),
        ),
        ElevatedButton(
          style: actionButtonStyle,
          onPressed: _onSave,
          child: Text("儲存並關閉"),
        ),
      ],
    );
  }

  Widget _buildTimeRow(DateFormat format, ButtonStyle buttonStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text("記錄時間", style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(format.format(_recordTime)),
          const SizedBox(width: 8),
          ElevatedButton(
            style: buttonStyle,
            onPressed: () => setState(() => _recordTime = DateTime.now()),
            child: const Text("更新時間"),
          ),
        ],
      ),
    );
  }

  Widget _buildAtHospitalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text("是否抵達到院後", style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Radio<bool>(
            value: true,
            groupValue: _atHospital,
            activeColor: const Color(0xFF274C4A), // As requested
            onChanged: (v) => setState(() => _atHospital = v!),
          ),
          const Text("是"),
          const SizedBox(width: 16),
          Radio<bool>(
            value: false,
            groupValue: _atHospital,
            activeColor: const Color(0xFF274C4A), // As requested
            onChanged: (v) => setState(() => _atHospital = v!),
          ),
          const Text("否"),
        ],
      ),
    );
  }

  Widget _buildConsciousnessRow() {
    final options = ['清', '聲', '痛', '否'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text("意識情況", style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          ...options.map(
            (option) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: _consciousness,
                  activeColor: const Color(0xFF274C4A), // As requested
                  onChanged: (v) => setState(() => _consciousness = v),
                ),
                Text(option),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
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
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
