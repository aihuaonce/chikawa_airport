import 'package:flutter/material.dart';
import 'nav2.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  int mainSymptom = 0;
  int history = 0;
  int allergy = 0;
  int diagnosisCategory = 0;
  int classify = 0;

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
                          _SectionTitle('疾病管制器篩檢'),
                          _StatefulCheckbox(),
                          const SizedBox(height: 24),

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
                            children: [
                              _CheckBoxItem('外傷'),
                              _CheckBoxItem('心電圖'),
                              _CheckBoxItem('其他'),
                            ],
                          ),
                          const SizedBox(height: 32),

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
                              _StatefulCheckbox(),
                            ],
                          ),
                          const SizedBox(height: 24),

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
                      onPressed: () {},
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
                  decoration: const InputDecoration(
                    hintText: '請填寫ICD-10代碼',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                _SectionTitle('副診斷1的ICD-10'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
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
                  decoration: const InputDecoration(
                    hintText: '請填寫ICD-10代碼',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),

                _SectionTitle('依據分類'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _RadioItem(
                      '第一級：後陣急救',
                      value: 0,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第二級：急診',
                      value: 1,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第三級：急診',
                      value: 2,
                      groupValue: classify,
                      onChanged: (v) => setState(() => classify = v!),
                    ),
                    _RadioItem(
                      '第四級：非緊急',
                      value: 3,
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
                    _CheckBoxItem('動脈採血'),
                    _CheckBoxItem('靜脈採血'),
                    _CheckBoxItem('外科處置'),
                    _CheckBoxItem('內科處置'),
                    _CheckBoxItem('藥物處方'),
                    _CheckBoxItem('醫療器材使用'),
                    _CheckBoxItem('CPR'),
                    _CheckBoxItem('其他'),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionTitle('處理摘要'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _CheckBoxItem('水劑'),
                    _CheckBoxItem('EKG心電圖'),
                    _CheckBoxItem('血壓量測'),
                    _CheckBoxItem('配藥'),
                    _CheckBoxItem('藥物使用'),
                    _CheckBoxItem('CPR'),
                    _CheckBoxItem('其他'),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionTitle('處理結果'),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    _CheckBoxItem('繼續搭機旅行'),
                    _CheckBoxItem('轉送醫院自行回家'),
                    _CheckBoxItem('轉送醫院由同事陪同'),
                    _CheckBoxItem('轉送醫院由家屬陪同'),
                    _CheckBoxItem('轉送醫院由警察陪同'),
                    _CheckBoxItem('轉送醫院由PIS陪同'),
                    _CheckBoxItem('死亡'),
                    _CheckBoxItem('拒絕轉診'),
                  ],
                ),
                const SizedBox(height: 24),

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

//可勾選可取消元件
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
