import 'package:flutter/material.dart';
import 'nav2.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  int mainSymptom = -1;
  int history = 0;
  int allergy = 0;
  int diagnosisCategory = 0;
  int classify = 0;

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
                            Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: const Text(
                                '加入資料行',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            // 更多資料
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
                    _CheckBoxItem('建議轉診'),
                    _CheckBoxItem('插管'),
                    _CheckBoxItem('CPR'),
                    _CheckBoxItem('其他'),
                    _CheckBoxItem('氧氣使用'),
                    _CheckBoxItem('診斷書'),
                    _CheckBoxItem('抽痰'),
                    _CheckBoxItem('藥物使用'),
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
                _SectionTitle('醫師：'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '請填寫醫師姓名',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionTitle('主責醫師', color: Colors.red),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '請填寫主責醫師的姓名（必填）',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionTitle('主責護理師', color: Colors.red),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '請填寫主責護理師的姓名（必填）',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

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

                _SectionTitle('EMT姓名'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '點擊選擇(備註：EMT有到出診現場協助出診時才需填寫)',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

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
                    children: const [
                      Text(
                        '協助人員姓名',
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
