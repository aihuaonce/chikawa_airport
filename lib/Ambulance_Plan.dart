import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/models/ambulance_data.dart';
import 'data/models/medication_record_model.dart';
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
    return InkWell(
      onTap: () async {
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            t.addMedicationRecord, // "+ 新增藥物記錄"
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ... (Helper widgets _buildSectionTitle, _buildTitleWithInput, etc. are unchanged)
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
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
        ElevatedButton(onPressed: _onSave, child: Text(widget.t.saveAndClose)),
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
