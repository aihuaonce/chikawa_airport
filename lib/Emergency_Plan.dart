import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyPlanPage extends StatefulWidget {
  const EmergencyPlanPage({super.key});

  @override
  State<EmergencyPlanPage> createState() => _EmergencyPlanPageState();
}

class _EmergencyPlanPageState extends State<EmergencyPlanPage> {
  // ==================== 顏色與樣式定義 (Style Definition) ====================
  static const Color primaryLight = Color(0xFF83ACA9);
  static const Color primaryDark = Color(0xFF274C4A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pageBackground = Color(0xFFE8F4F7); // 頁面背景色
  static const Color cardBackground = Colors.white; // 卡片背景色
  static const Color borderColor = Color(0xFFCBD5E1); // 邊框顏色
  static const Color labelColor = Color(0xFF4A5568); // 標籤文字顏色
  // =======================================================================

  // 時間狀態變數
  late DateTime firstAidStartTime;
  late DateTime intubationStartTime;
  late DateTime onIVLineStartTime;
  late DateTime cardiacMassageStartTime;
  late DateTime cardiacMassageEndTime;
  late DateTime firstAidEndTime;

  // 表單控制器
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController situationController = TextEditingController();
  final TextEditingController eController = TextEditingController();
  final TextEditingController vController = TextEditingController();
  final TextEditingController mController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController respirationRateController =
      TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController leftPupilSizeController = TextEditingController();
  final TextEditingController rightPupilSizeController =
      TextEditingController();

  // 急救處置
  final TextEditingController airwayContentController = TextEditingController();
  final TextEditingController insertionRecordController =
      TextEditingController();
  final TextEditingController ivNeedleSizeController = TextEditingController();
  final TextEditingController ivLineRecordController = TextEditingController();
  final TextEditingController cardiacMassageRecordController =
      TextEditingController();

  // 急救結束
  final TextEditingController endRecordController = TextEditingController();
  // 簽名控制器
  final TextEditingController nurseSignatureController =
      TextEditingController();
  final TextEditingController emtSignatureController = TextEditingController();

  final TextEditingController assistantNameController = TextEditingController();

  // 轉診醫院的 Controller
  final TextEditingController otherHospitalController = TextEditingController();
  final TextEditingController otherEndResultController =
      TextEditingController();

  // 選擇狀態
  String? temperature;
  String? leftPupilReaction;
  String? rightPupilReaction;
  String? insertionMethod;
  String? respirationType;
  String? endResult;
  String? selectedHospital;

  // 人員選擇狀態 & 列表
  String? selectedDoctor;
  String? selectedNurse;
  String? selectedEMT;

  final List<String> VisitingStaff = [
    '方詩旋',
    '古璿正',
    '江汪財',
    '呂學政',
    '周志勃',
    '金霍歌',
    '徐丕',
    '康曉妍',
  ];

  final List<String> RegisteredNurses = [
    '陳思穎',
    '邱靜鈴',
    '莊杼媛',
    '洪萱',
    '范育婕',
    '陳珮妤',
    '蔡可葳',
    '粘瑞華',
  ];

  final List<String> EMTs = ['王文義', '游進昌', '胡勝捷', '黃逸斌', '吳承軒', '張致綸', '劉呈軒'];

  // 急救處置及用藥紀錄表 State
  final List<Map<String, String>> _medicationRecords = [];

  // 協助人員列表 State
  List<String> _selectedAssistants = [];
  final List<String> _helperNames = [
    '方詩婷',
    '古增正',
    '江旺財',
    '呂學政',
    '海欣茹',
    '洪雲敏',
    '徐杰',
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
    '楊敏度',
    '羅尹彤',
    '廖名用',
    '陳國平',
    '蘇敬婷',
    '黃梨梅',
    '朱森學',
    '陳思穎',
    '邵詩婷',
    '莊抒捷',
    '洪萱',
    '林育緯',
    '唐詠婷',
    '蔡可葳',
    '粘瑞敏',
    '黃馨儀',
    '陳冠羽',
    '陳怡玲',
    '吳雅柔',
    '何文豪',
    '王文義',
    '游恩晶',
    '胡雅捷',
    '黃逸誠',
    '吳季軒',
    '劉曉華',
    '張峻維',
    '劉昱軒',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    firstAidStartTime = now;
    intubationStartTime = now;
    onIVLineStartTime = now;
    cardiacMassageStartTime = now;
    cardiacMassageEndTime = now;
    firstAidEndTime = now;
  }

  // ==================== Dialog 相關方法 ====================

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
      setState(() {
        selectedDoctor = result;
      });
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
      setState(() {
        selectedNurse = result;
      });
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
      setState(() {
        selectedEMT = result;
      });
    }
  }

  // ============== 恢復：用藥紀錄 Dialog ==============
  void _showAddMedicationRecordDialog() {
    final controllers = {
      'heartRate': TextEditingController(),
      'bloodPressure': TextEditingController(),
      'respiration': TextEditingController(),
      'o2': TextEditingController(),
      'dcShock': TextEditingController(),
      'epinephrine': TextEditingController(),
    };

    List<Map<String, TextEditingController>> otherDrugControllers = [];
    DateTime recordTime = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void clearDialogFields() {
              controllers.forEach((key, controller) => controller.clear());
              otherDrugControllers.forEach((drug) {
                drug['name']!.dispose();
                drug['dose']!.dispose();
              });
              otherDrugControllers.clear();
              recordTime = DateTime.now();
            }

            void saveData() {
              String otherDrugsSummary = otherDrugControllers
                  .map((drug) => '${drug['name']!.text}: ${drug['dose']!.text}')
                  .where((item) => item.isNotEmpty && !item.startsWith(': '))
                  .join(', ');

              setState(() {
                _medicationRecords.add({
                  "time": DateFormat('HH:mm:ss').format(recordTime),
                  "heartRate": controllers['heartRate']!.text,
                  "bp": controllers['bloodPressure']!.text,
                  "respiration": controllers['respiration']!.text,
                  "o2": controllers['o2']!.text,
                  "dcShock": controllers['dcShock']!.text,
                  "epinephrine": controllers['epinephrine']!.text,
                  "otherDrugs": otherDrugsSummary,
                });
              });
            }

            return AlertDialog(
              title: const Text("新增/編輯記錄表"),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "記錄時間",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            DateFormat(
                              'yyyy年MM月dd日 HH時mm分ss秒',
                            ).format(recordTime),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => setDialogState(
                              () => recordTime = DateTime.now(),
                            ),
                            child: const Text("更新時間"),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildDialogTextField(
                        controllers['heartRate']!,
                        "心跳(bpm)",
                        "請輸入心跳",
                      ),
                      _buildDialogTextField(
                        controllers['bloodPressure']!,
                        "血壓(mmHg)",
                        "請輸入血壓",
                      ),
                      _buildDialogTextField(
                        controllers['respiration']!,
                        "呼吸(次/分)",
                        "請輸入呼吸次數",
                      ),
                      _buildDialogTextField(
                        controllers['o2']!,
                        "O2(L/Min;%)",
                        "請輸入氧氣用量(例:Ambu 15L)",
                      ),
                      _buildDialogTextField(
                        controllers['dcShock']!,
                        "DC Shock(J)",
                        "請輸入電擊情況, 若無則空白",
                      ),
                      _buildDialogTextField(
                        controllers['epinephrine']!,
                        "Epinephrine(mg)",
                        "請輸入腎上腺素用量(例:1mg), 若無則空白",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "使用其他藥物紀錄表",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Expanded(
                                  child: Text(
                                    "藥物名稱",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "使用劑量",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            ...otherDrugControllers.map((controllers) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllers['name'],
                                      decoration: const InputDecoration(
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: controllers['dose'],
                                      decoration: const InputDecoration(
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    otherDrugControllers.add({
                                      'name': TextEditingController(),
                                      'dose': TextEditingController(),
                                    });
                                  });
                                },
                                child: const Text(
                                  "加入資料行",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("捨棄"),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveData();
                    setDialogState(() => clearDialogFields());
                  },
                  child: const Text("儲存, 新增另項"),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveData();
                    Navigator.pop(context);
                  },
                  child: const Text("儲存並關閉"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showHelperSelectionDialog() async {
    List<String> tempSelected = List.from(_selectedAssistants);
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
      setState(() {
        _selectedAssistants = result;
      });
    }
  }

  // =========================================================

  @override
  Widget build(BuildContext context) {
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
                    timeValue: firstAidStartTime,
                    onUpdateTime: () =>
                        setState(() => firstAidStartTime = DateTime.now()),
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
                  const Text(
                    '意識',
                    style: TextStyle(fontSize: 14, color: labelColor),
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          '心跳(次/分)',
                          heartRateController,
                          '請輸入',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          '呼吸(次/分)',
                          respirationRateController,
                          '請輸入',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '血壓(mmHg)',
                    bloodPressureController,
                    '請輸入收縮壓/舒張壓',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '體溫',
                    style: TextStyle(fontSize: 14, color: labelColor),
                  ),
                  Row(
                    children: [
                      _buildTappableRadioOption(
                        title: '冰冷',
                        groupValue: temperature,
                        onChanged: (v) => setState(() => temperature = v),
                      ),
                      _buildTappableRadioOption(
                        title: '溫暖',
                        groupValue: temperature,
                        onChanged: (v) => setState(() => temperature = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '瞳孔',
                    style: TextStyle(fontSize: 14, color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLabeledSmallTextField(
                        '左 Size(mm)',
                        leftPupilSizeController,
                      ),
                      const SizedBox(width: 16),
                      _buildLabeledSmallTextField(
                        '右 Size(mm)',
                        rightPupilSizeController,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('左 L-R', style: TextStyle(color: labelColor)),
                      _buildPupilReaction(true),
                      const SizedBox(width: 24),
                      const Text('右 L-R', style: TextStyle(color: labelColor)),
                      _buildPupilReaction(false),
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
                    timeValue: intubationStartTime,
                    onUpdateTime: () =>
                        setState(() => intubationStartTime = DateTime.now()),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('插管方式', style: TextStyle(color: labelColor)),
                      _buildTappableRadioOption(
                        title: 'ET',
                        groupValue: insertionMethod,
                        onChanged: (v) => setState(() => insertionMethod = v),
                      ),
                      _buildTappableRadioOption(
                        title: 'LMA',
                        groupValue: insertionMethod,
                        onChanged: (v) => setState(() => insertionMethod = v),
                      ),
                      _buildTappableRadioOption(
                        title: 'Igel',
                        groupValue: insertionMethod,
                        onChanged: (v) => setState(() => insertionMethod = v),
                      ),
                      _buildTappableRadioOption(
                        title: 'Failure',
                        groupValue: insertionMethod,
                        onChanged: (v) => setState(() => insertionMethod = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '氣管內容氣碼',
                    airwayContentController,
                    '請輸入氣管內容氣碼',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('插管記錄', insertionRecordController, '請輸入插管記錄'),
                  const Divider(height: 32),
                  _buildTimeSection(
                    title: 'On IV Line開始時間',
                    timeValue: onIVLineStartTime,
                    onUpdateTime: () =>
                        setState(() => onIVLineStartTime = DateTime.now()),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '注射針頭尺寸',
                    ivNeedleSizeController,
                    '請輸入注射針頭尺寸',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'On IV Line記錄',
                    ivLineRecordController,
                    '請輸入On IV Line記錄',
                  ),
                  const Divider(height: 32),
                  _buildTimeSection(
                    title: 'Cardiac Massage開始時間',
                    timeValue: cardiacMassageStartTime,
                    onUpdateTime: () => setState(
                      () => cardiacMassageStartTime = DateTime.now(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeSection(
                    title: 'Cardiac Massage結束時間',
                    timeValue: cardiacMassageEndTime,
                    onUpdateTime: () =>
                        setState(() => cardiacMassageEndTime = DateTime.now()),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Cardiac Massage記錄',
                    cardiacMassageRecordController,
                    '請輸入Cardiac Massage記錄',
                  ),
                ],
              ),
            ),

            // ============== 恢復：用藥紀錄表卡片 ==============
            _buildInfoCard(
              title: '急救處置及用藥紀錄表',
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(color: borderColor),
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1.2),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1.2),
                      5: FlexColumnWidth(1.2),
                      6: FlexColumnWidth(1.2),
                      7: FlexColumnWidth(1.5),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                        children: const [
                          _TableHeader('時間'),
                          _TableHeader('心跳'),
                          _TableHeader('血壓'),
                          _TableHeader('呼吸'),
                          _TableHeader('O2'),
                          _TableHeader('DC Shock'),
                          _TableHeader('Epinephrin'),
                          _TableHeader('其他藥物'),
                        ],
                      ),
                      ..._medicationRecords
                          .map(
                            (record) => TableRow(
                              children: [
                                _TableCell(record['time'] ?? ''),
                                _TableCell(record['heartRate'] ?? ''),
                                _TableCell(record['bp'] ?? ''),
                                _TableCell(record['respiration'] ?? ''),
                                _TableCell(record['o2'] ?? ''),
                                _TableCell(record['dcShock'] ?? ''),
                                _TableCell(record['epinephrine'] ?? ''),
                                _TableCell(record['otherDrugs'] ?? ''),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ),
                  InkWell(
                    onTap: _showAddMedicationRecordDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: borderColor),
                          right: BorderSide(color: borderColor),
                          bottom: BorderSide(color: borderColor),
                        ),
                      ),
                      child: const Text(
                        '加入資料行',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildInfoCard(
              title: '急救結束與結果',
              child: Column(
                children: [
                  _buildTimeSection(
                    title: '急救結束時間',
                    timeValue: firstAidEndTime,
                    onUpdateTime: () =>
                        setState(() => firstAidEndTime = DateTime.now()),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '急救結束紀錄',
                    endRecordController,
                    '請輸入(例：由聯新國際醫院接手)',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('急救結果', style: TextStyle(color: labelColor)),
                      _buildTappableRadioOption(
                        title: '轉診',
                        groupValue: endResult,
                        onChanged: (v) => setState(() => endResult = v),
                      ),
                      _buildTappableRadioOption(
                        title: '死亡',
                        groupValue: endResult,
                        onChanged: (v) => setState(() => endResult = v),
                      ),
                      _buildTappableRadioOption(
                        title: '其他',
                        groupValue: endResult,
                        onChanged: (v) => setState(() => endResult = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (endResult == '轉診') _buildReferralHospitalSelection(),
                  if (endResult == '死亡')
                    _buildTimeSection(
                      title: '死亡時間',
                      timeValue: firstAidEndTime,
                      onUpdateTime: () =>
                          setState(() => firstAidEndTime = DateTime.now()),
                    ),
                  if (endResult == '其他')
                    _buildTextField(
                      '其他急救結果',
                      otherEndResultController,
                      '請輸入其他急救結果',
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
                    selectedDoctor ?? '',
                    _showDoctorDialog,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '醫師簽名',
                    TextEditingController(),
                    '簽章',
                    maxLines: 2,
                  ), // 假設需要醫師簽名
                  const SizedBox(height: 16),
                  _buildSelectorField(
                    '急救護理師',
                    selectedNurse ?? '',
                    _showNurseDialog,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '護理師簽名',
                    nurseSignatureController,
                    '簽章',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildSelectorField(
                    '急救EMT',
                    selectedEMT ?? '',
                    _showEMTDialog,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'EMT簽名',
                    emtSignatureController,
                    '簽章',
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            // ============== 恢復：協助人員列表卡片 ==============
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
                    child: _selectedAssistants.isNotEmpty
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _selectedAssistants
                                .map((name) => Chip(label: Text(name)))
                                .toList(),
                          )
                        : const Text(
                            '尚未選擇協助人員',
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _showHelperSelectionDialog,
                    child: const Text(
                      '加入/編輯協助人員',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('處置紀錄已儲存'),
                      backgroundColor: primaryDark,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('儲存處置紀錄'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==================== 輔助 Widgets (Helper Widgets) ====================

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
            decoration: InputDecoration(
              hintText: '...',
              isDense: true,
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
                horizontal: 8,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection({
    required String title,
    required DateTime timeValue,
    required VoidCallback onUpdateTime,
  }) {
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
              child: const Text('更新時間'),
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
              value.isEmpty ? (isRequired ? '點擊選擇 (必填)' : '點擊選擇') : value,
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

  Widget _buildReferralHospitalSelection() {
    final List<String> hospitals = [
      '聯新國際醫院',
      '林口長庚醫院',
      '衛生福利部桃園醫院',
      '衛生福利部桃園療養院',
      '桃園經國敏盛醫院',
      '聖保祿醫院',
      '中壢天晟醫院',
      '桃園榮民總醫院',
      '三峽恩主公醫院',
      '其他',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('轉診醫院名稱', style: TextStyle(fontSize: 14, color: labelColor)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              ...hospitals.map((name) {
                return InkWell(
                  onTap: () => setState(() => selectedHospital = name),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Radio<String>(
                          value: name,
                          groupValue: selectedHospital,
                          onChanged: (value) =>
                              setState(() => selectedHospital = value),
                          activeColor: primaryDark,
                        ),
                        Text(name),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        if (selectedHospital == '其他')
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _buildTextField(
              '其他醫院名稱',
              otherHospitalController,
              '請輸入其他轉診醫院名稱',
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

  Widget _buildPupilReaction(bool isLeft) {
    String? groupValue = isLeft ? leftPupilReaction : rightPupilReaction;
    void onChanged(String? value) {
      setState(() {
        if (isLeft)
          leftPupilReaction = value;
        else
          rightPupilReaction = value;
      });
    }

    return Row(
      children: [
        _buildTappableRadioOption(
          title: '+',
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        _buildTappableRadioOption(
          title: '-',
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        _buildTappableRadioOption(
          title: '±',
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ============== 恢復：用藥紀錄 Dialog 的輔助輸入框 ==============
  Widget _buildDialogTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
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
    assistantNameController.dispose();
    otherHospitalController.dispose();
    otherEndResultController.dispose();
    super.dispose();
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}