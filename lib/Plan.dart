import 'package:flutter/material.dart';
import 'nav2.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("新增資料行"),
          content: const Text("這裡可以放輸入表單"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("儲存"),
            ),
          ],
        );
      },
    );
  }

  int mainSymptom = -1;
  int history = 0;
  int allergy = 0;
  int diagnosisCategory = 0;
  int classify = 0;

  final List<Map<String, String>> healthData = [];

  void _addHealthData() {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final tempController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("新增健康評估"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "姓名"),
              ),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(labelText: "關係"),
              ),
              TextField(
                controller: tempController,
                decoration: const InputDecoration(labelText: "體溫"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF83ACA9),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  healthData.add({
                    "name": nameController.text,
                    "relation": relationController.text,
                    "temp": tempController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("儲存"),
            ),
          ],
        );
      },
    );
  }

  bool consciousClear = true;

  bool screeningChecked = false;
  final Map<String, bool> screeningMethods = {
    '喉頭採檢': false,
    '抽血檢驗': false,
    '其他': false,
  };

  Map<String, bool> photoTypes = {'外傷': false, '心電圖': false, '其他': false};

  bool ekgChecked = false;
  bool sugarChecked = false;
  TextEditingController ekgController = TextEditingController();
  TextEditingController sugarController = TextEditingController();

  bool transferOtherHospital = false;
  int selectedOtherHospital = -1;
  final List<String> otherHospitals = [
    '桃園經國敏盛醫院',
    '聖保祿醫院',
    '衛生福利部桃園醫院',
    '衛生福利部桃園療養院',
    '桃園榮民總醫院',
    '三峽恩主公醫院',
    '其他',
  ];

  // ICD獨立
  String? selectedICD10Main;
  String? selectedICD10Sub1;
  String? selectedICD10Sub2;

  Future<void> _showICD10Dialog(ValueChanged<String> onSelected) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇ICD-10'),
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: ListView(
                children: icd10List.map((item) {
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
        onSelected(result);
      });
    }
  }

  final List<String> icd10List = [
    'A00 Cholera - 霍亂',
    'A00.0 Cholera due to Vibrio cholerae 01, biovar cholerae - 血清型01霍亂弧菌霍亂',
    'A00.1 Cholera due to Vibrio cholerae 01, biovar eltor - 血清型01霍亂弧菌El Tor霍亂',
    'A00.9 Cholera, unspecified - 霍亂',
    'A01 Typhoid and paratyphoid fevers - 傷寒及副傷寒',
    'A01.0 Typhoid fever - 傷寒',
    'A01.01 Typhoid fever, unspecified - 傷寒',
    'A01.01 Typhoid meningitis - 傷寒腦膜炎',
  ];

  bool suggestReferral = false;
  int referralHospital = -1;
  int referralType = 0;
  int rescueType = 0;
  TextEditingController referralOtherController = TextEditingController();
  TextEditingController referralEscortController = TextEditingController();

  final List<String> referralHospitals = [
    '聯新國際醫院',
    '林口長庚醫院',
    '衛生福利部桃園醫院',
    '衛生福利部桃園療養院',
    '桃園國際敏盛醫院',
    '聖保祿醫院',
    '中壢天晟醫院',
    '桃園榮民總醫院',
    '三峽恩主公醫院',
    '其他',
  ];

  bool intubationChecked = false;
  int intubationType = 0;
  bool cprChecked = false;
  bool oxygentherpyChecked = false;
  int oxygentype = 0;

  bool medicalCertificateChecked = false;
  final Map<String, bool> medicalCertificateTypes = {
    '中文診斷書': false,
    '英文診斷書': false,
    '中英文適航證明': false,
  };

  bool otherChecked = false;
  TextEditingController otherController = TextEditingController();

  bool prescriptionChecked = false;

  List<Map<String, String>> prescriptionRows = [];
  Future<void> _showPrescriptionDialog() async {
    Map<String, String>? result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String? selectedDrug;
        String? selectedUsage;
        String? selectedFreq;
        String? selectedDays;
        String? selectedDoseUnit;
        String note = '';

        final drugCategories = {
          '口服藥': [
            'Augmentin syrup',
            'Peace 藥錠',
            'Wempyn 潰瘍寧',
            'Ciprofloxacin',
            'Ibuprofen 佈洛芬',
          ],
          '注射劑': [
            'Ventolin 吸入劑',
            'Wycillin 筋注劑',
            'N/S 250ml',
            'D5W 250ml',
            'KCL 添加液',
          ],
          '點滴注射': ['D5S 500ml', 'Lactated Ringer\'s 乳酸林格氏液'],
          // 可以根據需要添加更多分類
        };

        final usageOptions = ['口服', '靜脈注射', '肌肉注射', '皮下注射'];
        final freqOptions = ['QD', 'BID', 'TID', 'QID', 'PRN'];
        final daysOptions = ['1 天', '3 天', '5 天', '7 天'];
        final doseUnitOptions = ['mg', 'g', 'tab', 'amp', 'vial'];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('新增藥物記錄'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('藥品名稱'),
                    ...drugCategories.entries.map((categoryEntry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              categoryEntry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            children: categoryEntry.value.map((drug) {
                              return ChoiceChip(
                                label: Text(drug),
                                selected: selectedDrug == drug,
                                onSelected: (_) =>
                                    setState(() => selectedDrug = drug),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '使用方式'),
                      items: usageOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedUsage = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '服用頻率'),
                      items: freqOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedFreq = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '服用天數'),
                      items: daysOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedDays = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '劑量單位'),
                      items: doseUnitOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedDoseUnit = v,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: '備註'),
                      onChanged: (v) => note = v,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      '藥品名稱': selectedDrug ?? '',
                      '使用方式': selectedUsage ?? '',
                      '服用頻率': selectedFreq ?? '',
                      '服用天數': selectedDays ?? '',
                      '劑量單位': selectedDoseUnit ?? '',
                      '備註': note,
                    });
                  },
                  child: const Text('儲存'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        prescriptionRows.add(result);
      });
    }
  }

  String? selectedMainDoctor;
  Future<void> _showMainDoctorDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇主責醫師'),
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
        selectedMainDoctor = result;
      });
    }
  }

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

  String? selectedMainNurse;
  Future<void> _showMainNurseDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇主責護理師'),
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
        selectedMainNurse = result;
      });
    }
  }

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

  String? selectedEMT;
  Future<void> _showEMTDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('選擇EMT'),
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

  final List<String> EMTs = ['王文義', '游進昌', '胡勝捷', '黃逸斌', '吳承軒', '張致綸', '劉呈軒'];

  List<String> _selectedHelpers = [];
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
  Future<void> _showHelperSelectionDialog() async {
    List<String> tempSelected = List.from(_selectedHelpers);

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
                          if (checked == true) {
                            tempSelected.add(name);
                          } else {
                            tempSelected.remove(name);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('確定'),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelected); // 返回多選的值
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedHelpers = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      selectedIndex: 3,
      child: Container(
        color: const Color(0xFFE6F6FB),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 900,
            margin: const EdgeInsets.symmetric(vertical: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ======= 上方左右分欄區塊 =======
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 左側欄位
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('疾病管制署篩檢'),
                          InkWell(
                            onTap: () => setState(
                              () => screeningChecked = !screeningChecked,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: screeningChecked,
                                  activeColor: const Color(0xFF83ACA9),
                                  onChanged: (v) => setState(
                                    () => screeningChecked = v ?? false,
                                  ),
                                ),
                                const Text(''),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 篩檢區塊（依勾選狀態顯示/隱藏）
                          if (screeningChecked) ...[
                            const SizedBox(height: 16),
                            _SectionTitle('篩檢方式'),
                            Wrap(
                              spacing: 24,
                              runSpacing: 8,
                              children: screeningMethods.keys.map((label) {
                                return InkWell(
                                  onTap: () => setState(
                                    () => screeningMethods[label] =
                                        !(screeningMethods[label] ?? false),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: screeningMethods[label],
                                        activeColor: const Color(0xFF83ACA9),
                                        onChanged: (v) => setState(
                                          () => screeningMethods[label] =
                                              v ?? false,
                                        ),
                                      ),
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            _SectionTitle('其他篩檢方式'),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: '請填寫其他篩檢方式',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _SectionTitle('健康評估'),
                            Container(
                              width: double.infinity,
                              color: const Color(0xFFF1F3F6),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '姓名',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '關係',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '體溫',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 顯示已新增的資料
                            ...healthData.map((row) {
                              return Container(
                                width: double.infinity,
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(row["name"] ?? ""),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(row["relation"] ?? ""),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(row["temp"] ?? ""),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            InkWell(
                              onTap: _addHealthData,
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                child: const Text(
                                  '加入資料行',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          _SectionTitle('主訴'),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => setState(() => mainSymptom = 0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: mainSymptom,
                                      onChanged: (v) => setState(
                                        () => mainSymptom = v as int,
                                      ),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('外傷'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => mainSymptom = 1),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: mainSymptom,
                                      onChanged: (v) => setState(
                                        () => mainSymptom = v as int,
                                      ),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('非外傷'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          if (mainSymptom == 0) ...[
                            _SectionTitle('外傷'),
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _CheckBoxItem('鈍挫傷'),
                                _CheckBoxItem('扭傷'),
                                _CheckBoxItem('撕裂傷'),
                                _CheckBoxItem('擦傷'),
                                _CheckBoxItem('肢體變形'),
                                _CheckBoxItem('其他'),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (mainSymptom == 1) ...[
                            _SectionTitle('非外傷'),
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _CheckBoxItem('頭頸部'),
                                _CheckBoxItem('胸部'),
                                _CheckBoxItem('腹部'),
                                _CheckBoxItem('四肢'),
                                _CheckBoxItem('其他'),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          _SectionTitle('補充說明'),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: '填寫主訴補充說明',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 24),

                          _SectionTitle('照片類型'),
                          Wrap(
                            spacing: 16,
                            children: photoTypes.keys.map((label) {
                              return InkWell(
                                onTap: () => setState(
                                  () => photoTypes[label] =
                                      !(photoTypes[label] ?? false),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: photoTypes[label],
                                      activeColor: const Color(0xFF83ACA9),
                                      onChanged: (v) => setState(
                                        () => photoTypes[label] = v ?? false,
                                      ),
                                    ),
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),

                          if (photoTypes['外傷'] == true) ...[
                            _SectionTitle('外傷照片'),
                            _PhotoGrid(title: '外傷照片'),
                            const SizedBox(height: 16),
                          ],

                          if (photoTypes['心電圖'] == true) ...[
                            _SectionTitle('心電圖照片'),
                            _PhotoGrid(title: '心電圖照片'),
                            const SizedBox(height: 16),
                          ],

                          if (photoTypes['其他'] == true) ...[
                            _SectionTitle('其他照片'),
                            _PhotoGrid(title: '其他照片'),
                            const SizedBox(height: 16),
                          ],

                          // 身體檢查區塊
                          _SectionTitle('身體檢查'),
                          const SizedBox(height: 8),
                          _BodyCheckInput('頭頸部'),
                          const SizedBox(height: 8),
                          _BodyCheckInput('胸部'),
                          const SizedBox(height: 8),
                          _BodyCheckInput('腹部'),
                          const SizedBox(height: 8),
                          _BodyCheckInput('四肢'),
                          const SizedBox(height: 8),
                          _BodyCheckInput('其他'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    // 右側欄位
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('語音輸入：'),
                          const Text(
                            '這裡依序輸入體溫、脈搏、呼吸、血壓、血氧、血糖',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF83ACA9),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: const Text('確認'),
                          ),
                          const SizedBox(height: 24),

                          _SectionTitle('體溫(°C)'),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: '輸入數字',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _SectionTitle('脈搏(次/min)'),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: '輸入整數',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _SectionTitle('呼吸(次/min)'),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: '輸入整數',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _SectionTitle('血壓(mmHg)'),
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: '整數',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('/'),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: '整數',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _SectionTitle('血氧(%)'),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: '輸入數字',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              _SectionTitle('意識清晰'),
                              InkWell(
                                onTap: () => setState(
                                  () => consciousClear = !consciousClear,
                                ),
                                child: Checkbox(
                                  value: consciousClear,
                                  activeColor: const Color(0xFF83ACA9),
                                  onChanged: (v) => setState(
                                    () => consciousClear = v ?? false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          if (!consciousClear) ...[
                            Row(
                              children: const [
                                Text(
                                  'E',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true, // 減少高度
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 32),
                                Text(
                                  'V',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 32),
                                Text(
                                  'M',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: const [
                                Text(
                                  'GCS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Text('0'),
                              ],
                            ),
                            const SizedBox(height: 24),

                            _SectionTitle('左瞳孔縮放'),
                            Row(
                              children: [
                                _RadioCircle(label: '+'),
                                _RadioCircle(label: '-'),
                                _RadioCircle(label: '±'),
                              ],
                            ),
                            const SizedBox(height: 8),

                            _SectionTitle('左瞳孔大小 (mm)'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: '輸入數字',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            _SectionTitle('右瞳孔縮放'),
                            Row(
                              children: [
                                _RadioCircle(label: '+'),
                                _RadioCircle(label: '-'),
                                _RadioCircle(label: '±'),
                              ],
                            ),
                            const SizedBox(height: 8),

                            _SectionTitle('右瞳孔大小 (mm)'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: '輸入數字',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          _SectionTitle('過去病史'),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => setState(() => history = 0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: history,
                                      onChanged: (v) =>
                                          setState(() => history = v as int),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('無'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => history = 1),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: history,
                                      onChanged: (v) =>
                                          setState(() => history = v as int),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('不詳'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => history = 2),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: history,
                                      onChanged: (v) =>
                                          setState(() => history = v as int),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('有'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _SectionTitle('過敏史'),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => setState(() => allergy = 0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: allergy,
                                      onChanged: (v) =>
                                          setState(() => allergy = v as int),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('無'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => allergy = 1),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: allergy,
                                      onChanged: (v) =>
                                          setState(() => allergy = v as int),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('不詳'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => allergy = 2),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: allergy,
                                      onChanged: (v) =>
                                          setState(() => allergy = v as int),
                                      activeColor: Color(0xFF83ACA9),
                                    ),
                                    const Text('有'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ===== 初步診斷區塊 =====
                const SizedBox(height: 40),
                _SectionTitle('初步診斷'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '請填寫初步診斷',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                _SectionTitle('初步診斷類別'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RadioItem(
                      'Mild Neurologic(headache、dizziness、vertigo)',
                      value: 0,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Severe Neurologic(syncope、seizure、CVA)',
                      value: 1,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'GI non-OP (AGE Epigas mild bleeding)',
                      value: 2,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'GI surgical (app cholecystitis PPU)',
                      value: 3,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Mild Trauma(含head injury、non-surgical intervention)',
                      value: 4,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Severe Trauma (surgical intervention)',
                      value: 5,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Mild CV (Palpitation Chest pain H/T hypo)',
                      value: 6,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Severe CV (AMI Arrythmia Shock Others)',
                      value: 7,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'RESP(Asthma、COPD)',
                      value: 8,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Fever (cause undetermined)',
                      value: 9,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Musculoskeletal',
                      value: 10,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'DM (hypoglycemia or hyperglycemia)',
                      value: 11,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'GU (APN Stone or others)',
                      value: 12,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'OHCA',
                      value: 13,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Derma',
                      value: 14,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'GYN',
                      value: 15,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'OPH/ENT',
                      value: 16,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Psychiatric (nervous、anxious、Alcohols/drug)',
                      value: 17,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                    _RadioItem(
                      'Others',
                      value: 18,
                      groupValue: diagnosisCategory,
                      onChanged: (v) => setState(() => diagnosisCategory = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _SectionTitle('初步診斷的ICD-10'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _showICD10Dialog((v) => selectedICD10Main = v),
                      child: const Text('ICD10CM搜尋'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('GOOGLE搜尋'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(
                    text: selectedICD10Main ?? '',
                  ),
                  decoration: const InputDecoration(
                    hintText: '請填寫ICD-10代碼',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 24),

                // 副診斷1的ICD-10
                _SectionTitle('副診斷1的ICD-10'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _showICD10Dialog((v) => selectedICD10Sub1 = v),
                      child: const Text('ICD10CM搜尋'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('GOOGLE搜尋'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(
                    text: selectedICD10Sub1 ?? '',
                  ),
                  decoration: const InputDecoration(
                    hintText: '請填寫ICD-10代碼',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 32),

                // 副診斷2的ICD-10
                _SectionTitle('副診斷2的ICD-10'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _showICD10Dialog((v) => selectedICD10Sub2 = v),
                      child: const Text('ICD10CM搜尋'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('GOOGLE搜尋'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(
                    text: selectedICD10Sub2 ?? '',
                  ),
                  decoration: const InputDecoration(
                    hintText: '請填寫ICD-10代碼',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 32),

                _SectionTitle('檢傷分類'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _RadioItem(
                      '第一級：復甦急救',
                      value: 0,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第二級：危急',
                      value: 1,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第三級：緊急',
                      value: 2,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第四級：次緊急',
                      value: 3,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第五級：非緊急',
                      value: 4,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionTitle('現場處置'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _CheckBoxItem('諮詢衛教'),
                    _CheckBoxItem('內科處置'),
                    _CheckBoxItem('外科處置'),
                    _CheckBoxItem('拒絕處置'),
                    _CheckBoxItem('疑似傳染病診療'),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionTitle('處理摘要'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _CheckBoxItem('冰敷'),
                    InkWell(
                      onTap: () => setState(() => ekgChecked = !ekgChecked),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: ekgChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => ekgChecked = v ?? false),
                          ),
                          const Text(
                            'EKG心電圖',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => sugarChecked = !sugarChecked),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: sugarChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => sugarChecked = v ?? false),
                          ),
                          const Text(
                            '血糖',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    _CheckBoxItem('傷口處置'),
                    _CheckBoxItem('簽四聯單'),
                    InkWell(
                      onTap: () =>
                          setState(() => suggestReferral = !suggestReferral),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: suggestReferral,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => suggestReferral = v ?? false),
                          ),
                          const Text(
                            '建議轉診',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(
                        () => intubationChecked = !intubationChecked,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: intubationChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => intubationChecked = v ?? false),
                          ),
                          const Text(
                            '插管',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => cprChecked = !cprChecked),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: cprChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => cprChecked = v ?? false),
                          ),
                          const Text(
                            'CPR',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(
                        () => oxygentherpyChecked = !oxygentherpyChecked,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: intubationChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => intubationChecked = v ?? false),
                          ),
                          const Text(
                            '氧氣使用',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(
                        () => medicalCertificateChecked =
                            !medicalCertificateChecked,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: medicalCertificateChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) => setState(
                              () => medicalCertificateChecked = v ?? false,
                            ),
                          ),
                          const Text(
                            '診斷書',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    _CheckBoxItem('抽痰'),
                    InkWell(
                      onTap: () => setState(
                        () => prescriptionChecked = !prescriptionChecked,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: prescriptionChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) => setState(
                              () => prescriptionChecked = v ?? false,
                            ),
                          ),
                          const Text(
                            '藥物使用',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => otherChecked = !otherChecked),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: otherChecked,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) =>
                                setState(() => otherChecked = v ?? false),
                          ),
                          const Text(
                            '其他',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (ekgChecked) ...[
                  _SectionTitle('心電圖判讀'),
                  TextField(
                    controller: ekgController,
                    decoration: const InputDecoration(
                      hintText: '請填寫判讀結果',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (sugarChecked) ...[
                  _SectionTitle('血糖(mg/dL)'),
                  TextField(
                    controller: sugarController,
                    decoration: const InputDecoration(
                      hintText: '請填寫血糖記錄',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (suggestReferral) ...[
                  // 通關方式
                  _SectionTitle('通關方式', color: Colors.black),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => referralType = 0),
                        child: Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: referralType,
                              onChanged: (v) =>
                                  setState(() => referralType = v as int),
                              activeColor: Color(0xFF274C4A),
                            ),
                            const Text('一般通關'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => referralType = 1),
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: referralType,
                              onChanged: (v) =>
                                  setState(() => referralType = v as int),
                              activeColor: Color(0xFF274C4A),
                            ),
                            const Text('緊急通關'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 救護車
                  _SectionTitle('救護車', color: Colors.black),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => rescueType = 0),
                        child: Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: rescueType,
                              onChanged: (v) =>
                                  setState(() => rescueType = v as int),
                              activeColor: Color(0xFF274C4A),
                            ),
                            const Text('醫療中心'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => rescueType = 1),
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: rescueType,
                              onChanged: (v) =>
                                  setState(() => rescueType = v as int),
                              activeColor: Color(0xFF274C4A),
                            ),
                            const Text('民間'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => rescueType = 2),
                        child: Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: rescueType,
                              onChanged: (v) =>
                                  setState(() => rescueType = v as int),
                              activeColor: Color(0xFF274C4A),
                            ),
                            const Text('消防隊'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 轉送醫院
                  _SectionTitle('轉送醫院', color: Colors.black),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(referralHospitals.length, (i) {
                      return InkWell(
                        onTap: () => setState(() => referralHospital = i),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: referralHospital,
                              onChanged: (v) =>
                                  setState(() => referralHospital = v!),
                              activeColor: Color(0xFF274C4A),
                            ),
                            Flexible(child: Text(referralHospitals[i])),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  // 其他轉送醫院
                  _SectionTitle('其他轉送醫院?', color: Colors.black),
                  TextField(
                    controller: referralOtherController,
                    decoration: const InputDecoration(
                      hintText: '請填寫其他轉送醫院',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 隨車人員
                  _SectionTitle('隨車人員(舊)', color: Colors.black),
                  TextField(
                    controller: referralEscortController,
                    decoration: const InputDecoration(
                      hintText: '請填寫隨車人員的姓名',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 隨車人員log
                  _SectionTitle('隨車人員'),
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF1F3F6),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '隨車人員姓名',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('加入資料行', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 產生救護車紀錄單
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF274C4A),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('產生救護車紀錄單'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (intubationChecked) ...[
                  _SectionTitle('插管方式'),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => intubationType = 0),
                        child: Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: intubationType,
                              onChanged: (v) =>
                                  setState(() => intubationType = v as int),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            const Text('Endotracheal tube'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => intubationType = 1),
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: intubationType,
                              onChanged: (v) =>
                                  setState(() => intubationType = v as int),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            const Text('LMA'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                if (cprChecked) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // 產生急救記錄單的功能
                      },
                      child: const Text('產生急救記錄單'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (oxygentherpyChecked) ...[
                  _SectionTitle('氧氣使用'),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => oxygentype = 0),
                        child: Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: oxygentype,
                              onChanged: (v) =>
                                  setState(() => oxygentype = v as int),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            const Text('鼻導管N/C'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => oxygentype = 1),
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: oxygentype,
                              onChanged: (v) =>
                                  setState(() => oxygentype = v as int),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            const Text('面罩Mask'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => oxygentype = 2),
                        child: Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: oxygentype,
                              onChanged: (v) =>
                                  setState(() => oxygentype = v as int),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            const Text('非再吸入面罩'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => oxygentype = 3),
                        child: Row(
                          children: [
                            Radio(
                              value: 3,
                              groupValue: oxygentype,
                              onChanged: (v) =>
                                  setState(() => oxygentype = v as int),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            const Text('Ambu'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionTitle('氧氣流量(L/MIN)', color: Color(0xFF83ACA9)),
                      TextField(
                        controller: referralEscortController,
                        decoration: const InputDecoration(
                          hintText: '請填寫氧氣流量',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                if (medicalCertificateChecked) ...[
                  const SizedBox(height: 16),
                  _SectionTitle('診斷書種類'),
                  Wrap(
                    spacing: 24,
                    runSpacing: 8,
                    children: medicalCertificateTypes.keys.map((label) {
                      return InkWell(
                        onTap: () => setState(
                          () => medicalCertificateTypes[label] =
                              !(medicalCertificateTypes[label] ?? false),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: medicalCertificateTypes[label],
                              activeColor: const Color(0xFF83ACA9),
                              onChanged: (v) => setState(
                                () =>
                                    medicalCertificateTypes[label] = v ?? false,
                              ),
                            ),
                            Text(
                              label,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                if (prescriptionChecked) ...[
                  _SectionTitle('藥物記錄表'),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF1F3F6),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '藥品名稱',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '使用方式',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '服用頻率',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '服用天數',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '劑量',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '劑量單位',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '備註',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ...prescriptionRows.map((row) {
                    return Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text(row['藥品名稱'] ?? '')),
                          Expanded(flex: 2, child: Text(row['使用方式'] ?? '')),
                          Expanded(flex: 2, child: Text(row['服用頻率'] ?? '')),
                          Expanded(flex: 2, child: Text(row['服用天數'] ?? '')),
                          Expanded(flex: 2, child: Text(row['劑量'] ?? '')),
                          Expanded(flex: 2, child: Text(row['劑量單位'] ?? '')),
                          Expanded(flex: 2, child: Text(row['備註'] ?? '')),
                        ],
                      ),
                    );
                  }).toList(),

                  InkWell(
                    onTap: _showPrescriptionDialog,
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: const Text(
                        '加入資料行',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],

                if (otherChecked) ...[
                  _SectionTitle('其他處理摘要'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: otherController,
                    decoration: const InputDecoration(
                      hintText: '請填寫其他處理摘要',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                _SectionTitle('後續結果'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _CheckBoxItem('繼續搭機旅行'),
                    _CheckBoxItem('休息觀察或自行回家'),
                    _CheckBoxItem('轉聯新國際醫院'),
                    _CheckBoxItem('轉林口長庚醫院'),
                    StatefulBuilder(
                      builder: (context, setSBState) => InkWell(
                        onTap: () {
                          setState(
                            () =>
                                transferOtherHospital = !transferOtherHospital,
                          );
                          setSBState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: transferOtherHospital,
                              activeColor: const Color(0xFF83ACA9),
                              onChanged: (v) {
                                setState(
                                  () => transferOtherHospital = v ?? false,
                                );
                                setSBState(() {});
                              },
                            ),
                            const Text(
                              '轉其他醫院',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _CheckBoxItem('建議轉診門診追蹤'),
                    _CheckBoxItem('死亡'),
                    _CheckBoxItem('拒絕轉診'),
                  ],
                ),
                const SizedBox(height: 24),

                if (transferOtherHospital) ...[
                  _SectionTitle('其他醫院'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(otherHospitals.length, (i) {
                      return InkWell(
                        onTap: () => setState(() => selectedOtherHospital = i),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: selectedOtherHospital,
                              onChanged: (v) =>
                                  setState(() => selectedOtherHospital = v!),
                              activeColor: Color(0xFF83ACA9),
                            ),
                            Flexible(
                              child: Text(
                                otherHospitals[i],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ],

                // 醫師/主責醫師
                _SectionTitle('院長'),
                const SizedBox(height: 16),

                _SectionTitle('主責醫師', color: Colors.red),
                GestureDetector(
                  onTap: _showMainDoctorDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: selectedMainDoctor ?? '',
                      ),
                      decoration: const InputDecoration(
                        hintText: '點擊選擇醫師的姓名（必填）',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionTitle('主責護理師', color: Colors.red),
                GestureDetector(
                  onTap: _showMainNurseDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: selectedMainNurse ?? '',
                      ),
                      decoration: const InputDecoration(
                        hintText: '點擊選擇護理師的姓名（必填）',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionTitle('護理師簽名'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                _SectionTitle('EMT姓名', color: Colors.black),
                GestureDetector(
                  onTap: _showEMTDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: selectedEMT ?? '',
                      ),
                      decoration: const InputDecoration(
                        hintText: '點擊選擇EMT的姓名（必填）',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionTitle('EMT簽名'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                _SectionTitle('協助人員姓名'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '請填寫協助人員的姓名',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF1F3F6),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('協助人員姓名'),
                      if (_selectedHelpers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _selectedHelpers
                                .map(
                                  (helper) => Text(
                                    helper,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      else
                        const Text(
                          '尚未選擇協助人員',
                          style: TextStyle(color: Colors.grey),
                        ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _showHelperSelectionDialog,
                        child: const Text(
                          '加入協助人員',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _SectionTitle('特別註記'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _CheckBoxItem('OHCA醫護團隊到場前有CPR'),
                    _CheckBoxItem('OHCA醫護團隊到場前有使用AED但無電擊'),
                    _CheckBoxItem('OHCA醫護團隊到場前有使用AED有電擊'),
                    _CheckBoxItem('現場恢復呼吸'),
                    _CheckBoxItem('使用自動心律復甦機'),
                    _CheckBoxItem('空白'),
                  ],
                ),
                const SizedBox(height: 24),

                _SectionTitle('其他特別註記'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '請輸入其他特別註記',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 標題元件
class _SectionTitle extends StatelessWidget {
  final String text;
  final Color? color;
  const _SectionTitle(this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}

// 單選元件
class _RadioItem extends StatelessWidget {
  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;
  const _RadioItem(
    this.label, {
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: groupValue,
            activeColor: Color(0xFF83ACA9),
            onChanged: onChanged,
          ),
          Flexible(
            child: Text(label, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

// Checkbox 元件
class _CheckBoxItem extends StatefulWidget {
  final String label;
  const _CheckBoxItem(this.label);

  @override
  State<_CheckBoxItem> createState() => _CheckBoxItemState();
}

class _CheckBoxItemState extends State<_CheckBoxItem> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => checked = !checked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: checked,
            activeColor: const Color(0xFF83ACA9),
            onChanged: (v) => setState(() => checked = v ?? false),
          ),
          Text(widget.label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

//非必選元件
class _StatefulCheckbox extends StatefulWidget {
  const _StatefulCheckbox({super.key});
  @override
  State<_StatefulCheckbox> createState() => _StatefulCheckboxState();
}

class _StatefulCheckboxState extends State<_StatefulCheckbox> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => checked = !checked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: checked,
            activeColor: const Color(0xFF83ACA9),
            onChanged: (v) => setState(() => checked = v ?? false),
          ),
        ],
      ),
    );
  }
}

// 身體檢查輸入元件
class _BodyCheckInput extends StatelessWidget {
  final String label;
  const _BodyCheckInput(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 300,
          child: TextField(
            decoration: const InputDecoration(
              hintText: '請輸入檢查資訊',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

// 單選圓圈元件（+/-/±）
class _RadioCircle extends StatefulWidget {
  final String label;
  const _RadioCircle({required this.label});

  @override
  State<_RadioCircle> createState() => _RadioCircleState();
}

class _RadioCircleState extends State<_RadioCircle> {
  static String? selected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => selected = widget.label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: widget.label,
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v),
            activeColor: Color(0xFF83ACA9),
          ),
          Text(widget.label),
        ],
      ),
    );
  }
}

//照片上傳元件
class _PhotoGrid extends StatelessWidget {
  final String title;
  const _PhotoGrid({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text('$title${index + 1}', style: const TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );
  }
}
