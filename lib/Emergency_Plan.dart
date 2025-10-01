import 'package:flutter/material.dart';

class EmergencyPlanPage extends StatefulWidget {
  const EmergencyPlanPage({super.key});

  @override
  State<EmergencyPlanPage> createState() => _EmergencyPlanPageState();
}

class _EmergencyPlanPageState extends State<EmergencyPlanPage> {
  // 表單控制器
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController eController = TextEditingController();
  final TextEditingController vController = TextEditingController();
  final TextEditingController mController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController respirationController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController leftPupilController = TextEditingController();
  final TextEditingController rightPupilController = TextEditingController();

  // 選擇狀態
  String? temperature;
  String? leftPupilReaction;
  String? rightPupilReaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 急救開始時間
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '急救開始時間',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '2025年09月27日 16時15分07秒',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: 更新時間功能
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('更新時間'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 診斷
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text('診斷')),
                      Expanded(
                        child: TextField(
                          controller: diagnosisController,
                          decoration: const InputDecoration(
                            hintText: '請輸入診斷',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 發生情況
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text('發生情況')),
                      Expanded(
                        child: TextField(
                          controller: conditionController,
                          decoration: const InputDecoration(
                            hintText: '請輸入發生情況',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 病況區塊
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD), // 淺橘色背景
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFE69C)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '病況',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 意識 E、V、M
                  Row(
                    children: [
                      const SizedBox(width: 60, child: Text('意識')),
                      Expanded(
                        child: Row(
                          children: [
                            const Text('E'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: eController,
                                decoration: const InputDecoration(
                                  hintText: '請輸入',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text('V'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: vController,
                                decoration: const InputDecoration(
                                  hintText: '請輸入',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text('M'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: mController,
                                decoration: const InputDecoration(
                                  hintText: '請輸入',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 心跳
                  Row(
                    children: [
                      const SizedBox(width: 100, child: Text('心跳(次/分)')),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: heartRateController,
                          decoration: const InputDecoration(
                            hintText: '請輸入',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 呼吸
                  Row(
                    children: [
                      const SizedBox(width: 100, child: Text('呼吸(次/分)')),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: respirationController,
                          decoration: const InputDecoration(
                            hintText: '請輸入',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 血壓
                  Row(
                    children: [
                      const SizedBox(width: 100, child: Text('血壓(mmHg)')),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: bloodPressureController,
                          decoration: const InputDecoration(
                            hintText: '請輸入收縮壓/舒張壓',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 體溫
                  Row(
                    children: [
                      const SizedBox(width: 60, child: Text('體溫')),
                      Radio<String>(
                        value: '冰冷',
                        groupValue: temperature,
                        onChanged: (value) {
                          setState(() {
                            temperature = value;
                          });
                        },
                      ),
                      const Text('冰冷'),
                      const SizedBox(width: 16),
                      Radio<String>(
                        value: '溫暖',
                        groupValue: temperature,
                        onChanged: (value) {
                          setState(() {
                            temperature = value;
                          });
                        },
                      ),
                      const Text('溫暖'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 瞳孔
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 60, child: Text('瞳孔')),
                      Expanded(
                        child: Column(
                          children: [
                            // Size(mm)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 80,
                                  child: Text('Size(mm)'),
                                ),
                                const Text('左'),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: leftPupilController,
                                    decoration: const InputDecoration(
                                      hintText: '請輸入',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text('右'),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: rightPupilController,
                                    decoration: const InputDecoration(
                                      hintText: '請輸入',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // L-R 反應
                            Row(
                              children: [
                                const SizedBox(width: 80, child: Text('L-R')),
                                const Text('左'),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: '+',
                                      groupValue: leftPupilReaction,
                                      onChanged: (value) {
                                        setState(() {
                                          leftPupilReaction = value;
                                        });
                                      },
                                    ),
                                    const Text('+'),
                                    Radio<String>(
                                      value: '-',
                                      groupValue: leftPupilReaction,
                                      onChanged: (value) {
                                        setState(() {
                                          leftPupilReaction = value;
                                        });
                                      },
                                    ),
                                    const Text('-'),
                                    Radio<String>(
                                      value: '±',
                                      groupValue: leftPupilReaction,
                                      onChanged: (value) {
                                        setState(() {
                                          leftPupilReaction = value;
                                        });
                                      },
                                    ),
                                    const Text('±'),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                const Text('右'),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: '+',
                                      groupValue: rightPupilReaction,
                                      onChanged: (value) {
                                        setState(() {
                                          rightPupilReaction = value;
                                        });
                                      },
                                    ),
                                    const Text('+'),
                                    Radio<String>(
                                      value: '-',
                                      groupValue: rightPupilReaction,
                                      onChanged: (value) {
                                        setState(() {
                                          rightPupilReaction = value;
                                        });
                                      },
                                    ),
                                    const Text('-'),
                                    Radio<String>(
                                      value: '±',
                                      groupValue: rightPupilReaction,
                                      onChanged: (value) {
                                        setState(() {
                                          rightPupilReaction = value;
                                        });
                                      },
                                    ),
                                    const Text('±'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 儲存按鈕
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 儲存處置紀錄邏輯
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('處置紀錄已儲存'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274C4A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('儲存處置紀錄'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 清理控制器
    diagnosisController.dispose();
    conditionController.dispose();
    eController.dispose();
    vController.dispose();
    mController.dispose();
    heartRateController.dispose();
    respirationController.dispose();
    bloodPressureController.dispose();
    leftPupilController.dispose();
    rightPupilController.dispose();
    super.dispose();
  }
}