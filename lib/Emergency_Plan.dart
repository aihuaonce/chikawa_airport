import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class EmergencyPlanPage extends StatefulWidget {
  final int visitId;
  const EmergencyPlanPage({super.key, required this.visitId});

  @override
  State<EmergencyPlanPage> createState() => _EmergencyPlanPageState();
}

class _EmergencyPlanPageState extends State<EmergencyPlanPage> {
  static const Color primaryDark = Color(0xFF274C4A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pageBackground = Color(0xFFE8F4F7);
  static const Color cardBackground = Colors.white;
  static const Color borderColor = Color(0xFFCBD5E1);
  static const Color labelColor = Color(0xFF4A5568);

  // Controllers
  final diagnosisController = TextEditingController();
  final situationController = TextEditingController();
  final eController = TextEditingController();
  final vController = TextEditingController();
  final mController = TextEditingController();
  final heartRateController = TextEditingController();
  final respirationRateController = TextEditingController();
  final bloodPressureController = TextEditingController();
  final leftPupilSizeController = TextEditingController();
  final rightPupilSizeController = TextEditingController();
  final airwayContentController = TextEditingController();
  final insertionRecordController = TextEditingController();
  final ivNeedleSizeController = TextEditingController();
  final ivLineRecordController = TextEditingController();
  final cardiacMassageRecordController = TextEditingController();
  final endRecordController = TextEditingController();
  final nurseSignatureController = TextEditingController();
  final emtSignatureController = TextEditingController();
  final otherHospitalController = TextEditingController();
  final otherEndResultController = TextEditingController();
  final postResuscitationEController = TextEditingController();
  final postResuscitationVController = TextEditingController();
  final postResuscitationMController = TextEditingController();
  final postResuscitationHeartRateController = TextEditingController();
  final postResuscitationBloodPressureController = TextEditingController();
  final postResuscitationLeftPupilSizeController = TextEditingController();
  final postResuscitationRightPupilSizeController = TextEditingController();
  final otherSupplementsController = TextEditingController();

  // 【註】人員名單通常不進行翻譯，因此保留為靜態數據
  final List<String> VisitingStaff = [
    '方詩旋',
    '夏瑿正',
    '江汪財',
    '呂學政',
    '周志勃',
    '金靜歌',
    '徐丕',
    '康曉婭',
  ];
  final List<String> RegisteredNurses = [
    '陳思穎',
    '邱靜鈴',
    '莊漾媛',
    '洪豔',
    '范育婕',
    '陳簡妤',
    '蔡可萱',
    '粘瑞詩',
  ];
  final List<String> EMTs = ['王文義', '游進昌', '胡勇淳', '黃逸斌', '峯承軒', '張致綸', '劉呈軒'];
  final List<String> _helperNames = [
    '方詩婷',
    '夏增正',
    '江旺財',
    '呂學政',
    '海欣茹',
    '洪雲敏',
    '徐氏',
    '康曉朗',
    '黎裕昌',
    '戴逸旻',
    '廖詠怡',
    '許婷涵',
    '陳小山',
    '王悅朗',
    '劉金宇',
    '彭士書',
    '熊得志',
    '顧小',
    '蔡心文',
    '程皓',
    '楊敏庭',
    '羅尹彤',
    '廖哲用',
    '陳國平',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<EmergencyData>();
    diagnosisController.text = data.diagnosis ?? '';
    situationController.text = data.situation ?? '';
    eController.text = data.evmE ?? '';
    vController.text = data.evmV ?? '';
    mController.text = data.evmM ?? '';
    heartRateController.text = data.heartRate ?? '';
    respirationRateController.text = data.respirationRate ?? '';
    bloodPressureController.text = data.bloodPressure ?? '';
    leftPupilSizeController.text = data.leftPupilSize ?? '';
    rightPupilSizeController.text = data.rightPupilSize ?? '';
    airwayContentController.text = data.airwayContent ?? '';
    insertionRecordController.text = data.insertionRecord ?? '';
    ivNeedleSizeController.text = data.ivNeedleSize ?? '';
    ivLineRecordController.text = data.ivLineRecord ?? '';
    cardiacMassageRecordController.text = data.cardiacMassageRecord ?? '';
    endRecordController.text = data.endRecord ?? '';
    nurseSignatureController.text = data.nurseSignature ?? '';
    emtSignatureController.text = data.emtSignature ?? '';
    otherHospitalController.text = data.otherHospital ?? '';
    otherEndResultController.text = data.otherEndResult ?? '';
    postResuscitationEController.text = data.postResuscitationEvmE ?? '';
    postResuscitationVController.text = data.postResuscitationEvmV ?? '';
    postResuscitationMController.text = data.postResuscitationEvmM ?? '';
    postResuscitationHeartRateController.text =
        data.postResuscitationHeartRate ?? '';
    postResuscitationBloodPressureController.text =
        data.postResuscitationBloodPressure ?? '';
    postResuscitationLeftPupilSizeController.text =
        data.postResuscitationLeftPupilSize ?? '';
    postResuscitationRightPupilSizeController.text =
        data.postResuscitationRightPupilSize ?? '';
    otherSupplementsController.text = data.otherSupplements ?? '';
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    situationController.dispose();
    eController.dispose();
    vController.dispose();
    mController.dispose();
    heartRateController.dispose();
    respirationRateController.dispose();
    bloodPressureController.dispose();
    leftPupilSizeController.dispose();
    rightPupilSizeController.dispose();
    airwayContentController.dispose();
    insertionRecordController.dispose();
    ivNeedleSizeController.dispose();
    ivLineRecordController.dispose();
    cardiacMassageRecordController.dispose();
    endRecordController.dispose();
    nurseSignatureController.dispose();
    emtSignatureController.dispose();
    otherHospitalController.dispose();
    otherEndResultController.dispose();
    postResuscitationEController.dispose();
    postResuscitationVController.dispose();
    postResuscitationMController.dispose();
    postResuscitationHeartRateController.dispose();
    postResuscitationBloodPressureController.dispose();
    postResuscitationLeftPupilSizeController.dispose();
    postResuscitationRightPupilSizeController.dispose();
    otherSupplementsController.dispose();

    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<EmergencyData>();
    data.updatePlan(
      diagnosis: diagnosisController.text,
      situation: situationController.text,
      evmE: eController.text,
      evmV: vController.text,
      evmM: mController.text,
      heartRate: heartRateController.text,
      respirationRate: respirationRateController.text,
      bloodPressure: bloodPressureController.text,
      leftPupilSize: leftPupilSizeController.text,
      rightPupilSize: rightPupilSizeController.text,
      airwayContent: airwayContentController.text,
      insertionRecord: insertionRecordController.text,
      ivNeedleSize: ivNeedleSizeController.text,
      ivLineRecord: ivLineRecordController.text,
      cardiacMassageRecord: cardiacMassageRecordController.text,
      endRecord: endRecordController.text,
      nurseSignature: nurseSignatureController.text,
      emtSignature: emtSignatureController.text,
      otherHospital: otherHospitalController.text,
      otherEndResult: otherEndResultController.text,
      postResuscitationEvmE: postResuscitationEController.text,
      postResuscitationEvmV: postResuscitationVController.text,
      postResuscitationEvmM: postResuscitationMController.text,
      postResuscitationHeartRate: postResuscitationHeartRateController.text,
      postResuscitationBloodPressure:
          postResuscitationBloodPressureController.text,
      postResuscitationLeftPupilSize:
          postResuscitationLeftPupilSizeController.text,
      postResuscitationRightPupilSize:
          postResuscitationRightPupilSizeController.text,
      otherSupplements: otherSupplementsController.text,
    );
  }

  Future<void> _showDoctorDialog(AppTranslations t) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(t.selectDoctorDialogTitle),
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: ListView(
                children: VisitingStaff.map((item) {
                  return ListTile(
                    title: Text(item),
                    onTap: () => Navigator.pop(context, item),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
    if (result != null && mounted) {
      context.read<EmergencyData>().updatePlan(selectedDoctor: result);
    }
  }

  Future<void> _showNurseDialog(AppTranslations t) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(t.selectNurseDialogTitle),
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: ListView(
                children: RegisteredNurses.map((item) {
                  return ListTile(
                    title: Text(item),
                    onTap: () => Navigator.pop(context, item),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
    if (result != null && mounted) {
      context.read<EmergencyData>().updatePlan(selectedNurse: result);
    }
  }

  Future<void> _showEMTDialog(AppTranslations t) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(t.selectEMTDialogTitle),
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: ListView(
                children: EMTs.map((item) {
                  return ListTile(
                    title: Text(item),
                    onTap: () => Navigator.pop(context, item),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
    if (result != null && mounted) {
      context.read<EmergencyData>().updatePlan(selectedEMT: result);
    }
  }

  Future<void> _showHelperSelectionDialog(AppTranslations t) async {
    final data = context.read<EmergencyData>();
    List<String> tempSelected = List.from(data.selectedAssistants);

    List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(t.selectAssistantsDialogTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _helperNames.map((name) {
                    return CheckboxListTile(
                      title: Text(name),
                      value: tempSelected.contains(name),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true)
                            tempSelected.add(name);
                          else
                            tempSelected.remove(name);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(t.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: white,
                  ),
                  child: Text(t.confirm),
                  onPressed: () => Navigator.of(context).pop(tempSelected),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      data.updatePlan(selectedAssistants: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Container(
          color: pageBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  title: t.emergencyBasicInfo,
                  child: Column(
                    children: [
                      _buildTimeSection(
                        title: t.firstAidStartTime,
                        timeValue: data.firstAidStartTime ?? DateTime.now(),
                        onUpdateTime: () =>
                            data.updatePlan(firstAidStartTime: DateTime.now()),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.diagnosis,
                        diagnosisController,
                        t.enterDiagnosis,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.situationDescription,
                        situationController,
                        t.enterSituationDescription,
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: t.patientCondition,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.consciousness,
                        style: const TextStyle(fontSize: 14, color: labelColor),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLabeledSmallTextField('E', eController),
                          const SizedBox(width: 16),
                          _buildLabeledSmallTextField('V', vController),
                          const SizedBox(width: 16),
                          _buildLabeledSmallTextField('M', mController),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        t.heartRate,
                        heartRateController,
                        t.enterValue,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.respirationRate,
                        respirationRateController,
                        t.enterValue,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        t.bloodPressure,
                        bloodPressureController,
                        t.enterSystolicDiastolic,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        t.bodyTemperature,
                        style: const TextStyle(fontSize: 14, color: labelColor),
                      ),
                      Row(
                        children: [
                          _buildTappableRadioOption(
                            title: t.tempCold,
                            groupValue: data.temperature,
                            onChanged: (v) => data.updatePlan(temperature: v),
                          ),
                          _buildTappableRadioOption(
                            title: t.tempWarm,
                            groupValue: data.temperature,
                            onChanged: (v) => data.updatePlan(temperature: v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        t.pupils,
                        style: const TextStyle(fontSize: 14, color: labelColor),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLabeledSmallTextField(
                            t.leftPupilSize,
                            leftPupilSizeController,
                          ),
                          const SizedBox(width: 16),
                          _buildLabeledSmallTextField(
                            t.rightPupilSize,
                            rightPupilSizeController,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildPupilLightReflexRow(
                        label: t.leftPupilReaction,
                        groupValue: data.leftPupilReaction,
                        onChanged: (v) => data.updatePlan(leftPupilReaction: v),
                      ),
                      _buildPupilLightReflexRow(
                        label: t.rightPupilReaction,
                        groupValue: data.rightPupilReaction,
                        onChanged: (v) =>
                            data.updatePlan(rightPupilReaction: v),
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: t.emergencyProcedures,
                  child: Column(
                    children: [
                      _buildTimeSection(
                        title: t.intubationStartTime,
                        timeValue: data.intubationStartTime ?? DateTime.now(),
                        onUpdateTime: () => data.updatePlan(
                          intubationStartTime: DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            t.intubationMethod,
                            style: const TextStyle(color: labelColor),
                          ),
                          _buildTappableRadioOption(
                            title: 'ET',
                            groupValue: data.insertionMethod,
                            onChanged: (v) =>
                                data.updatePlan(insertionMethod: v),
                          ),
                          _buildTappableRadioOption(
                            title: 'LMA',
                            groupValue: data.insertionMethod,
                            onChanged: (v) =>
                                data.updatePlan(insertionMethod: v),
                          ),
                          _buildTappableRadioOption(
                            title: 'Igel',
                            groupValue: data.insertionMethod,
                            onChanged: (v) =>
                                data.updatePlan(insertionMethod: v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.airwayContentCode,
                        airwayContentController,
                        t.enterAirwayContentCode,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.intubationRecord,
                        insertionRecordController,
                        t.enterIntubationRecord,
                      ),

                      const Divider(height: 32, thickness: 0.5),
                      _buildTimeSection(
                        title: t.onIvLineStartTime,
                        timeValue: data.onIVLineStartTime ?? DateTime.now(),
                        onUpdateTime: () =>
                            data.updatePlan(onIVLineStartTime: DateTime.now()),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.ivNeedleSize,
                        ivNeedleSizeController,
                        t.enterIvNeedleSize,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.onIvLineRecord,
                        ivLineRecordController,
                        t.enterOnIvLineRecord,
                      ),
                      const Divider(height: 32, thickness: 0.5),
                      _buildTimeSection(
                        title: t.cardiacMassageStartTime,
                        timeValue:
                            data.cardiacMassageStartTime ?? DateTime.now(),
                        onUpdateTime: () => data.updatePlan(
                          cardiacMassageStartTime: DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTimeSection(
                        title: t.cardiacMassageEndTime,
                        timeValue: data.cardiacMassageEndTime ?? DateTime.now(),
                        onUpdateTime: () => data.updatePlan(
                          cardiacMassageEndTime: DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.cardiacMassageRecord,
                        cardiacMassageRecordController,
                        t.enterCardiacMassageRecord,
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: t.postResuscitationStatus,
                  child: _buildPostResuscitationStatusSection(data, t),
                ),

                _buildInfoCard(
                  title: t.emergencyEndAndResult,
                  child: Column(
                    children: [
                      _buildTimeSection(
                        title: t.firstAidEndTime,
                        timeValue: data.firstAidEndTime ?? DateTime.now(),
                        onUpdateTime: () =>
                            data.updatePlan(firstAidEndTime: DateTime.now()),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.firstAidEndRecord,
                        endRecordController,
                        t.enterValue,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            t.emergencyResult,
                            style: const TextStyle(color: labelColor),
                          ),
                          _buildTappableRadioOption(
                            title: t.resultReferral,
                            groupValue: data.endResult,
                            onChanged: (v) => data.updatePlan(endResult: v),
                          ),
                          _buildTappableRadioOption(
                            title: t.resultDeath,
                            groupValue: data.endResult,
                            onChanged: (v) => data.updatePlan(endResult: v),
                          ),
                          _buildTappableRadioOption(
                            title: t.other,
                            groupValue: data.endResult,
                            onChanged: (v) => data.updatePlan(endResult: v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: t.participatingPersonnel,
                  child: Column(
                    children: [
                      _buildSelectorField(
                        t.emergencyDoctor,
                        data.selectedDoctor ?? '',
                        () => _showDoctorDialog(t),
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildSelectorField(
                        t.emergencyNurse,
                        data.selectedNurse ?? '',
                        () => _showNurseDialog(t),
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.nurseSignature,
                        nurseSignatureController,
                        t.signatureStamp,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      _buildSelectorField(
                        t.emergencyEMT,
                        data.selectedEMT ?? '',
                        () => _showEMTDialog(t),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        t.emtSignature,
                        emtSignatureController,
                        t.signatureStamp,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: t.assistantPersonnelList,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 100),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: data.selectedAssistants.isNotEmpty
                            ? Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: data.selectedAssistants
                                    .map((name) => Chip(label: Text(name)))
                                    .toList(),
                              )
                            : Text(
                                t.noAssistantsSelected,
                                style: const TextStyle(color: Colors.grey),
                              ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _showHelperSelectionDialog(t),
                        child: Text(
                          t.addEditAssistants,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 24),
      color: cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryDark,
              ),
            ),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: labelColor)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => _saveToProvider(),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaryDark, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledSmallTextField(
    String label,
    TextEditingController controller,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: labelColor)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            onChanged: (_) => _saveToProvider(),
            decoration: InputDecoration(
              hintText: '...',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: borderColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostResuscitationStatusSection(
    EmergencyData data,
    AppTranslations t,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 意識 (GCS)
        Text(
          t.consciousness,
          style: const TextStyle(fontSize: 14, color: labelColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildLabeledSmallTextField('E', postResuscitationEController),
            const SizedBox(width: 16),
            _buildLabeledSmallTextField('V', postResuscitationVController),
            const SizedBox(width: 16),
            _buildLabeledSmallTextField('M', postResuscitationMController),
          ],
        ),
        const SizedBox(height: 16),

        _buildTextField(
          t.heartRate,
          postResuscitationHeartRateController,
          t.enterValue,
        ),
        const SizedBox(height: 16),

        Text(
          t.respiration,
          style: const TextStyle(fontSize: 14, color: labelColor),
        ),
        Row(
          children: [
            _buildTappableRadioOption(
              title: t.spontaneousRespiration,
              groupValue: data.postResuscitationRespirationMethod,
              onChanged: (v) =>
                  data.updatePlan(postResuscitationRespirationMethod: v),
            ),
            _buildTappableRadioOption(
              title: t.ventilator,
              groupValue: data.postResuscitationRespirationMethod,
              onChanged: (v) =>
                  data.updatePlan(postResuscitationRespirationMethod: v),
            ),
            _buildTappableRadioOption(
              title: "Ambu",
              groupValue: data.postResuscitationRespirationMethod,
              onChanged: (v) =>
                  data.updatePlan(postResuscitationRespirationMethod: v),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildTextField(
          t.bloodPressure,
          postResuscitationBloodPressureController,
          t.enterSystolicDiastolic,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            _buildLabeledSmallTextField(
              t.leftPupilSizeLabel,
              postResuscitationLeftPupilSizeController,
            ),
            const SizedBox(width: 16),
            _buildLabeledSmallTextField(
              t.rightPupilSizeLabel,
              postResuscitationRightPupilSizeController,
            ),
          ],
        ),
        const SizedBox(height: 8),

        _buildPupilLightReflexRow(
          label: t.leftPupilReaction,
          groupValue: data.postResuscitationLeftPupilLightReflex,
          onChanged: (v) =>
              data.updatePlan(postResuscitationLeftPupilLightReflex: v),
        ),
        _buildPupilLightReflexRow(
          label: t.rightPupilReaction,
          groupValue: data.postResuscitationRightPupilLightReflex,
          onChanged: (v) =>
              data.updatePlan(postResuscitationRightPupilLightReflex: v),
        ),
        const SizedBox(height: 16),

        _buildTextField(
          t.otherSupplements,
          otherSupplementsController,
          t.enterSupplementaryNotes,
        ),
      ],
    );
  }

  Widget _buildPupilLightReflexRow({
    required String label,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    double labelWidth = 60;
    return Row(
      children: [
        SizedBox(width: labelWidth, child: Text(label)),
        const SizedBox(width: 8),
        _buildTappableRadioOption(
          title: "+",
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        _buildTappableRadioOption(
          title: "-",
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        _buildTappableRadioOption(
          title: "±",
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTimeSection({
    required String title,
    required DateTime timeValue,
    required VoidCallback onUpdateTime,
  }) {
    final t = AppTranslations.of(context);
    final formattedTime = DateFormat(
      t.fullDateTimeSecondsFormat,
    ).format(timeValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: labelColor)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onUpdateTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Text(t.updateTime),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectorField(
    String label,
    String value,
    VoidCallback onTap, {
    bool isRequired = false,
  }) {
    final t = AppTranslations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: labelColor),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isRequired && value.isEmpty ? Colors.red : borderColor,
              ),
            ),
            child: Text(
              value.isEmpty
                  ? (isRequired ? t.tapToSelectRequired : t.tapToSelect)
                  : value,
              style: TextStyle(
                fontSize: 16,
                color: value.isEmpty ? Colors.grey.shade500 : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTappableRadioOption({
    required String title,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(title),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: title,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: primaryDark,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
