import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'data/models/emergency_data.dart';

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

  final List<String> VisitingStaff = ['方詩旋', '夏瑿正', '江汪財', '呂學政', '周志勃', '金靜歌', '徐丕', '康曉婭'];
  final List<String> RegisteredNurses = ['陳思穎', '邱靜鈴', '莊漾媛', '洪豔', '范育婕', '陳簡妤', '蔡可萱', '粘瑞詩'];
  final List<String> EMTs = ['王文義', '游進昌', '胡勇淳', '黃逸斌', '峯承軒', '張致綸', '劉呈軒'];
  final List<String> _helperNames = [
    '方詩婷', '夏增正', '江旺財', '呂學政', '海欣茹', '洪雲敏', '徐氏', '康曉朗',
    '黎裕昌', '戴逸旻', '廖詠怡', '許婷涵', '陳小山', '王悅朗', '劉金宇', '彭士書',
    '熊得志', '顧小', '蔡心文', '程皓', '楊敏庭', '羅尹彤', '廖哲用', '陳國平',
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
    );
  }

  Future<void> _showDoctorDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇急救醫師'),
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
    if (result != null) {
      context.read<EmergencyData>().updatePlan(selectedDoctor: result);
    }
  }

  Future<void> _showNurseDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇急救護理師'),
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
    if (result != null) {
      context.read<EmergencyData>().updatePlan(selectedNurse: result);
    }
  }

  Future<void> _showEMTDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇急救EMT'),
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
    if (result != null) {
      context.read<EmergencyData>().updatePlan(selectedEMT: result);
    }
  }

  Future<void> _showHelperSelectionDialog() async {
    final data = context.read<EmergencyData>();
    List<String> tempSelected = List.from(data.selectedAssistants);
    
    List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('選擇協助人員姓名'),
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
                  child: const Text('取消'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: white,
                  ),
                  child: const Text('確定'),
                  onPressed: () => Navigator.of(context).pop(tempSelected),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      data.updatePlan(selectedAssistants: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Container(
          color: pageBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  title: '急救基本資料',
                  child: Column(
                    children: [
                      _buildTimeSection(
                        title: '急救開始時間',
                        timeValue: data.firstAidStartTime ?? DateTime.now(),
                        onUpdateTime: () => data.updatePlan(firstAidStartTime: DateTime.now()),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('診斷', diagnosisController, '請輸入診斷'),
                      const SizedBox(height: 16),
                      _buildTextField('發生情況', situationController, '請輸入發生情況'),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: '病況',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('意識', style: TextStyle(fontSize: 14, color: labelColor)),
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
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('心跳(次/分)', heartRateController, '請輸入'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('呼吸(次/分)', respirationRateController, '請輸入'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('血壓(mmHg)', bloodPressureController, '請輸入收縮壓/舒張壓'),
                      const SizedBox(height: 16),
                      const Text('體溫', style: TextStyle(fontSize: 14, color: labelColor)),
                      Row(
                        children: [
                          _buildTappableRadioOption(
                            title: '冰冷',
                            groupValue: data.temperature,
                            onChanged: (v) => data.updatePlan(temperature: v),
                          ),
                          _buildTappableRadioOption(
                            title: '溫暖',
                            groupValue: data.temperature,
                            onChanged: (v) => data.updatePlan(temperature: v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('瞳孔', style: TextStyle(fontSize: 14, color: labelColor)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLabeledSmallTextField('左 Size(mm)', leftPupilSizeController),
                          const SizedBox(width: 16),
                          _buildLabeledSmallTextField('右 Size(mm)', rightPupilSizeController),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: '急救處置',
                  child: Column(
                    children: [
                      _buildTimeSection(
                        title: '插管開始時間',
                        timeValue: data.intubationStartTime ?? DateTime.now(),
                        onUpdateTime: () => data.updatePlan(intubationStartTime: DateTime.now()),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('插管方式', style: TextStyle(color: labelColor)),
                          _buildTappableRadioOption(
                            title: 'ET',
                            groupValue: data.insertionMethod,
                            onChanged: (v) => data.updatePlan(insertionMethod: v),
                          ),
                          _buildTappableRadioOption(
                            title: 'LMA',
                            groupValue: data.insertionMethod,
                            onChanged: (v) => data.updatePlan(insertionMethod: v),
                          ),
                          _buildTappableRadioOption(
                            title: 'Igel',
                            groupValue: data.insertionMethod,
                            onChanged: (v) => data.updatePlan(insertionMethod: v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('氣管內容氣碼', airwayContentController, '請輸入氣管內容氣碼'),
                      const SizedBox(height: 16),
                      _buildTextField('插管記錄', insertionRecordController, '請輸入插管記錄'),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: '急救結束與結果',
                  child: Column(
                    children: [
                      _buildTimeSection(
                        title: '急救結束時間',
                        timeValue: data.firstAidEndTime ?? DateTime.now(),
                        onUpdateTime: () => data.updatePlan(firstAidEndTime: DateTime.now()),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('急救結束紀錄', endRecordController, '請輸入'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('急救結果', style: TextStyle(color: labelColor)),
                          _buildTappableRadioOption(
                            title: '轉診',
                            groupValue: data.endResult,
                            onChanged: (v) => data.updatePlan(endResult: v),
                          ),
                          _buildTappableRadioOption(
                            title: '死亡',
                            groupValue: data.endResult,
                            onChanged: (v) => data.updatePlan(endResult: v),
                          ),
                          _buildTappableRadioOption(
                            title: '其他',
                            groupValue: data.endResult,
                            onChanged: (v) => data.updatePlan(endResult: v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: '參與人員',
                  child: Column(
                    children: [
                      _buildSelectorField(
                        '急救醫師',
                        data.selectedDoctor ?? '',
                        _showDoctorDialog,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildSelectorField(
                        '急救護理師',
                        data.selectedNurse ?? '',
                        _showNurseDialog,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('護理師簽名', nurseSignatureController, '簽章', maxLines: 2),
                      const SizedBox(height: 16),
                      _buildSelectorField('急救EMT', data.selectedEMT ?? '', _showEMTDialog),
                      const SizedBox(height: 16),
                      _buildTextField('EMT簽名', emtSignatureController, '簽章', maxLines: 2),
                    ],
                  ),
                ),

                _buildInfoCard(
                  title: '協助人員列表',
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
                            : const Text('尚未選擇協助人員', style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _showHelperSelectionDialog,
                        child: const Text('加入/編輯協助人員', style: TextStyle(color: Colors.blue)),
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
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark)),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryDark, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledSmallTextField(String label, TextEditingController controller) {
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: borderColor)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection({required String title, required DateTime timeValue, required VoidCallback onUpdateTime}) {
    final formattedTime = DateFormat('yyyy年MM月dd日 HH時mm分ss秒').format(timeValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: labelColor)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Text(formattedTime, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onUpdateTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('更新時間'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectorField(String label, String value, VoidCallback onTap, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: labelColor)),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 14)),
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
              border: Border.all(color: isRequired && value.isEmpty ? Colors.red : borderColor),
            ),
            child: Text(
              value.isEmpty ? (isRequired ? '點擊選擇 (必填)' : '點擊選擇') : value,
              style: TextStyle(fontSize: 16, color: value.isEmpty ? Colors.grey.shade500 : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTappableRadioOption({required String title, required String? groupValue, required ValueChanged<String?> onChanged}) {
    return InkWell(
      onTap: () => onChanged(title),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(value: title, groupValue: groupValue, onChanged: onChanged, activeColor: primaryDark, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
            Text(title),
          ],
        ),
      ),
    );
  }
}