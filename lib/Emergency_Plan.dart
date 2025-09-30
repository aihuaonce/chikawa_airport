import 'package:flutter/material.dart';

class EmergencyPlanPage extends StatefulWidget {
  const EmergencyPlanPage({super.key});

  @override
  State<EmergencyPlanPage> createState() => _EmergencyPlanPageState();
}

class _EmergencyPlanPageState extends State<EmergencyPlanPage> {
  // 顏色定義
  static const Color primaryLight = Color(0xFF83ACA9);
  static const Color primaryDark = Color(0xFF274C4A);
  static const Color white = Color(0xFFFFFFFF);

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
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController nurseNameController = TextEditingController();
  final TextEditingController emtNameController = TextEditingController();
  final TextEditingController assistantNameController = TextEditingController();

  // 選擇狀態
  String? temperature;
  String? leftPupilReaction;
  String? rightPupilReaction;
  String? insertionMethod;
  String? respirationType;
  String? endResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 急救開始時間
            _buildTimeSection(title: '急救開始時間', time: '2025年09月27日 16時15分07秒'),
            const SizedBox(height: 12),

            // 診斷
            _buildTextField('診斷', diagnosisController, '請輸入診斷'),
            const SizedBox(height: 12),

            // 發生情況
            _buildTextField('發生情況', situationController, '請輸入發生情況'),
            const SizedBox(height: 20),

            // 病況區塊
            _buildSectionHeader('病況'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // 意識 E V M
                  Row(
                    children: [
                      const SizedBox(width: 60, child: Text('意識')),
                      const SizedBox(width: 30, child: Text('E')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(eController, '請輸入'),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('V')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(vController, '請輸入'),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('M')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(mController, '請輸入'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 心跳
                  _buildVitalSignRow('心跳(次/分)', heartRateController),
                  const SizedBox(height: 12),

                  // 呼吸
                  _buildVitalSignRow('呼吸(次/分)', respirationRateController),
                  const SizedBox(height: 12),

                  // 血壓
                  _buildVitalSignRow(
                    '血壓(mmHg)',
                    bloodPressureController,
                    hint: '請輸入收縮壓/舒張壓',
                  ),
                  const SizedBox(height: 12),

                  // 體溫
                  Row(
                    children: [
                      const SizedBox(width: 100, child: Text('體溫')),
                      Radio<String>(
                        value: '冰冷',
                        groupValue: temperature,
                        onChanged: (value) =>
                            setState(() => temperature = value),
                        activeColor: primaryDark,
                      ),
                      const Text('冰冷'),
                      const SizedBox(width: 16),
                      Radio<String>(
                        value: '溫暖',
                        groupValue: temperature,
                        onChanged: (value) =>
                            setState(() => temperature = value),
                        activeColor: primaryDark,
                      ),
                      const Text('溫暖'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 瞳孔 Size
                  Row(
                    children: [
                      const SizedBox(width: 60, child: Text('瞳孔')),
                      const SizedBox(width: 80, child: Text('Size(mm)')),
                      const SizedBox(width: 30, child: Text('左')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          leftPupilSizeController,
                          '請輸入',
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('右')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          rightPupilSizeController,
                          '請輸入',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 瞳孔 L-R
                  Row(
                    children: [
                      const SizedBox(width: 60),
                      const SizedBox(width: 80, child: Text('L-R')),
                      const SizedBox(width: 30, child: Text('左')),
                      _buildPupilReaction(true),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('右')),
                      _buildPupilReaction(false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 急救處置
            _buildSectionHeader('急救處置'),
            _buildTimeSection(title: '插管開始時間', time: '2025年09月27日 16時15分07秒'),
            const SizedBox(height: 12),

            // 插管方式
            Row(
              children: [
                const SizedBox(width: 100, child: Text('插管方式')),
                Radio<String>(
                  value: 'ET',
                  groupValue: insertionMethod,
                  onChanged: (value) => setState(() => insertionMethod = value),
                  activeColor: primaryDark,
                ),
                const Text('ET'),
                Radio<String>(
                  value: 'LMA',
                  groupValue: insertionMethod,
                  onChanged: (value) => setState(() => insertionMethod = value),
                  activeColor: primaryDark,
                ),
                const Text('LMA'),
                Radio<String>(
                  value: 'Igel',
                  groupValue: insertionMethod,
                  onChanged: (value) => setState(() => insertionMethod = value),
                  activeColor: primaryDark,
                ),
                const Text('Igel'),
                Radio<String>(
                  value: 'Failure',
                  groupValue: insertionMethod,
                  onChanged: (value) => setState(() => insertionMethod = value),
                  activeColor: primaryDark,
                ),
                const Text('Failure'),
              ],
            ),
            const SizedBox(height: 12),

            _buildTextField('氣管內容氣碼', airwayContentController, '請輸入氣管內容氣碼'),
            const SizedBox(height: 12),

            _buildTextField('插管記錄', insertionRecordController, '請輸入插管記錄'),
            const SizedBox(height: 20),

            // On IV Line
            _buildTimeSection(
              title: 'On IV Line開始時間',
              time: '2025年09月27日 16時15分07秒',
            ),
            const SizedBox(height: 12),

            _buildTextField('注射針頭尺寸', ivNeedleSizeController, '請輸入注射針頭尺寸'),
            const SizedBox(height: 12),

            _buildTextField(
              'On IV Line記錄',
              ivLineRecordController,
              '請輸入On IV Line記錄',
            ),
            const SizedBox(height: 20),

            // Cardiac Massage
            _buildTimeSection(
              title: 'Cardiac Massage開始時間',
              time: '2025年09月27日 16時15分07秒',
            ),
            const SizedBox(height: 12),

            _buildTimeSection(
              title: 'Cardiac Massage結束時間',
              time: '2025年09月27日 16時15分07秒',
            ),
            const SizedBox(height: 12),

            _buildTextField(
              'Cardiac Massage記錄',
              cardiacMassageRecordController,
              '請輸入Cardiac Massage記錄',
            ),
            const SizedBox(height: 20),

            // 急救處置及用藥紀錄表
            _buildSectionHeader('急救處置及用藥紀錄表'),
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                border: TableBorder.all(color: primaryLight),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: primaryLight.withOpacity(0.2),
                    ),
                    children: const [
                      _TableHeader('時間'),
                      _TableHeader('心跳(bpm)'),
                      _TableHeader('血壓(mmHg)'),
                      _TableHeader('呼吸(次/分)'),
                      _TableHeader('O2(L/Min;%)'),
                      _TableHeader('DC Shock(J)'),
                      _TableHeader('Epinephrin...'),
                      _TableHeader('使用其他藥物...'),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '加入資料行',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 急救後病況
            _buildSectionHeader('急救後病況'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 60, child: Text('意識')),
                      const SizedBox(width: 30, child: Text('E')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          TextEditingController(),
                          '請輸入',
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('V')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          TextEditingController(),
                          '請輸入',
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('M')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          TextEditingController(),
                          '請輸入',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildVitalSignRow('心跳(次/分)', TextEditingController()),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 100, child: Text('呼吸')),
                      Radio<String>(
                        value: '自發性呼吸',
                        groupValue: respirationType,
                        onChanged: (value) =>
                            setState(() => respirationType = value),
                        activeColor: primaryDark,
                      ),
                      const Text('自發性呼吸'),
                      Radio<String>(
                        value: '呼吸器',
                        groupValue: respirationType,
                        onChanged: (value) =>
                            setState(() => respirationType = value),
                        activeColor: primaryDark,
                      ),
                      const Text('呼吸器'),
                      Radio<String>(
                        value: 'Ambu',
                        groupValue: respirationType,
                        onChanged: (value) =>
                            setState(() => respirationType = value),
                        activeColor: primaryDark,
                      ),
                      const Text('Ambu'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildVitalSignRow(
                    '血壓(mmHg)',
                    TextEditingController(),
                    hint: '請輸入收縮壓/舒張壓',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 60, child: Text('瞳孔')),
                      const SizedBox(width: 80, child: Text('Size(mm)')),
                      const SizedBox(width: 30, child: Text('左')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          TextEditingController(),
                          '請輸入',
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(width: 30, child: Text('右')),
                      SizedBox(
                        width: 80,
                        child: _buildSmallTextField(
                          TextEditingController(),
                          '請輸入',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('其他補充', TextEditingController(), '請輸入補充說明'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 急救結束時間
            _buildTimeSection(title: '急救結束時間', time: '2025年09月27日 16時29分13秒'),
            const SizedBox(height: 12),

            _buildTextField('急救結束紀錄', endRecordController, '請輸入(例：由聯新國際醫院接手)'),
            const SizedBox(height: 12),

            // 急救結果
            Row(
              children: [
                const SizedBox(width: 100, child: Text('急救結果')),
                Radio<String>(
                  value: '轉診',
                  groupValue: endResult,
                  onChanged: (value) => setState(() => endResult = value),
                  activeColor: primaryDark,
                ),
                const Text('轉診'),
                Radio<String>(
                  value: '死亡',
                  groupValue: endResult,
                  onChanged: (value) => setState(() => endResult = value),
                  activeColor: primaryDark,
                ),
                const Text('死亡'),
                Radio<String>(
                  value: '其他',
                  groupValue: endResult,
                  onChanged: (value) => setState(() => endResult = value),
                  activeColor: primaryDark,
                ),
                const Text('其他'),
              ],
            ),
            const SizedBox(height: 12),

            _buildRequiredTextField(
              '急救醫師',
              doctorNameController,
              '點擊選擇醫師的姓名（必填）',
            ),
            const SizedBox(height: 12),

            _buildRequiredTextField(
              '急救護理師',
              nurseNameController,
              '點擊選擇護理師的姓名（必填）',
            ),
            const SizedBox(height: 12),

            _buildTextField('護理師簽名', TextEditingController(), '簽章'),
            const SizedBox(height: 12),

            _buildTextField('急救EMT', emtNameController, '點擊選擇EMT的姓名'),
            const SizedBox(height: 12),

            _buildTextField('EMT簽名', TextEditingController(), '簽章'),
            const SizedBox(height: 20),

            // 協助人員列表
            _buildSectionHeader('協助人員列表'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [Expanded(child: Text('協助人員姓名'))],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('加入資料行', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 儲存按鈕
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
                    horizontal: 48,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('儲存處置紀錄', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade700,
        ),
      ),
    );
  }

  Widget _buildTimeSection({required String title, required String time}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(title)),
          Text(time, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('更新時間'),
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
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label)),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: primaryLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: primaryLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: primaryDark, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Row(
            children: [
              Text(label),
              const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignRow(
    String label,
    TextEditingController controller, {
    String hint = '請輸入',
  }) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(child: _buildSmallTextField(controller, hint)),
      ],
    );
  }

  Widget _buildSmallTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildPupilReaction(bool isLeft) {
    String? groupValue = isLeft ? leftPupilReaction : rightPupilReaction;
    return Row(
      children: [
        Radio<String>(
          value: '+',
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              if (isLeft) {
                leftPupilReaction = value;
              } else {
                rightPupilReaction = value;
              }
            });
          },
          activeColor: primaryDark,
        ),
        const Text('+'),
        Radio<String>(
          value: '-',
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              if (isLeft) {
                leftPupilReaction = value;
              } else {
                rightPupilReaction = value;
              }
            });
          },
          activeColor: primaryDark,
        ),
        const Text('-'),
        Radio<String>(
          value: '±',
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              if (isLeft) {
                leftPupilReaction = value;
              } else {
                rightPupilReaction = value;
              }
            });
          },
          activeColor: primaryDark,
        ),
        const Text('±'),
      ],
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
    doctorNameController.dispose();
    nurseNameController.dispose();
    emtNameController.dispose();
    assistantNameController.dispose();
    super.dispose();
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

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
