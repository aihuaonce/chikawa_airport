import 'package:flutter/material.dart';
import 'nav2.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

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
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (_) {}),
                            ],
                          ),
                          const SizedBox(height: 24),

                          _SectionTitle('主訴'),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('外傷'),
                              Radio(
                                value: 1,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('非外傷'),
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
                              Checkbox(
                                value: true,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          _SectionTitle('過去病史'),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('無'),
                              Radio(
                                value: 1,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('不詳'),
                              Radio(
                                value: 2,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('有'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _SectionTitle('過敏史'),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('無'),
                              Radio(
                                value: 1,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('不詳'),
                              Radio(
                                value: 2,
                                groupValue: 0,
                                onChanged: (_) {},
                                activeColor: Color(0xFF83ACA9),
                              ),
                              const Text('有'),
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
                    _RadioItem('Mild Neurologic(headache、dizziness、vertigo)'),
                    _RadioItem('Severe Neurologic(syncope、seizure、CVA)'),
                    _RadioItem('GI non-OP (AGE Epigas mild bleeding)'),
                    _RadioItem('GI surgical (app cholecystitis PPU)'),
                    _RadioItem(
                      'Mild Trauma(含head injury、non-surgical intervention)',
                    ),
                    _RadioItem('Severe Trauma (surgical intervention)'),
                    _RadioItem('Mild CV (Palpitation Chest pain H/T hypo)'),
                    _RadioItem('Severe CV (AMI Arrythmia Shock Others)'),
                    _RadioItem('RESP(Asthma、COPD)'),
                    _RadioItem('Fever (cause undetermined)'),
                    _RadioItem('Musculoskeletal'),
                    _RadioItem('DM (hypoglycemia or hyperglycemia)'),
                    _RadioItem('GU (APN Stone or others)'),
                    _RadioItem('OHCA'),
                    _RadioItem('Derma'),
                    _RadioItem('GYN'),
                    _RadioItem('OPH/ENT'),
                    _RadioItem('Psychiatric (nervous、anxious、Alcohols/drug)'),
                    _RadioItem('Others'),
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
                    _RadioItem('第一級：後陣急救'),
                    _RadioItem('第二級：急診'),
                    _RadioItem('第三級：急診'),
                    _RadioItem('第四級：非緊急'),
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
class _RadioItem extends StatefulWidget {
  final String label;
  const _RadioItem(this.label);

  @override
  State<_RadioItem> createState() => _RadioItemState();
}

class _RadioItemState extends State<_RadioItem> {
  static int? selectedIndex;
  late final int index;

  @override
  void initState() {
    super.initState();
    index = _radioItemCount++;
  }

  static int _radioItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: selectedIndex,
          activeColor: Color(0xFF83ACA9),
          onChanged: (v) {
            setState(() {
              selectedIndex = v;
            });
          },
        ),
        Flexible(
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: checked,
          activeColor: const Color(0xFF83ACA9),
          onChanged: (v) => setState(() => checked = v ?? false),
        ),
        Text(widget.label, style: const TextStyle(color: Colors.black)),
      ],
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
