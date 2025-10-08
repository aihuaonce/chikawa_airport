import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

// 引入 nav5.dart 以獲取 AmbulanceDataProvider
import 'nav5.dart';

class AmbulanceExpensesPage extends StatefulWidget {
  final int visitId;
  const AmbulanceExpensesPage({super.key, required this.visitId});

  @override
  State<AmbulanceExpensesPage> createState() => _AmbulanceExpensesPageState();
}

class _AmbulanceExpensesPageState extends State<AmbulanceExpensesPage> {
  // 為這個頁面上的所有文字輸入框建立 TextEditingController
  final TextEditingController _staffFeeController = TextEditingController();
  final TextEditingController _oxygenFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 在 initState 中，從 Provider 讀取一次資料，來設定 Controller 的初始值
    final dataProvider = context.read<AmbulanceDataProvider>();
    final recordData = dataProvider.ambulanceRecordData;

    _staffFeeController.text = recordData.staffFee.value?.toString() ?? '';
    _oxygenFeeController.text = recordData.oxygenFee.value?.toString() ?? '';
  }

  @override
  void dispose() {
    // 釋放所有 Controller 以避免記憶體洩漏
    _staffFeeController.dispose();
    _oxygenFeeController.dispose();
    super.dispose();
  }

  // 總費用的計算現在直接在 build 方法中從 Provider 讀取，不再需要本地的 _totalFee 和 _updateTotalFee 方法

  @override
  Widget build(BuildContext context) {
    const double inputWidth = 120; // 統一寬度

    // 使用 Consumer 來監聽 DataProvider 的變化並建構 UI
    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        final recordData = dataProvider.ambulanceRecordData;

        // 從 Provider 中即時計算總費用
        final totalFee =
            (recordData.staffFee.value ?? 0) +
            (recordData.oxygenFee.value ?? 0);

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
                width: 800,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 救護車費用含醫護人員 ---
                    _buildTitleWithInput(
                      title: '救護車費用含醫護人員:',
                      controller: _staffFeeController,
                      hint: '請填寫整數',
                      inputWidth: inputWidth,
                      onChanged: (value) {
                        final fee = int.tryParse(value);
                        dataProvider.updateAmbulanceRecord(
                          recordData.copyWith(
                            staffFee: Value(fee),
                            // 當費用更新時，也同步更新總費用
                            totalFee: Value(
                              (fee ?? 0) + (recordData.oxygenFee.value ?? 0),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // --- 氧氣使用費用 ---
                    _buildTitleWithInput(
                      title: '氧氣使用費用:',
                      controller: _oxygenFeeController,
                      hint: '請填寫整數',
                      inputWidth: inputWidth,
                      onChanged: (value) {
                        final fee = int.tryParse(value);
                        dataProvider.updateAmbulanceRecord(
                          recordData.copyWith(
                            oxygenFee: Value(fee),
                            // 當費用更新時，也同步更新總費用
                            totalFee: Value(
                              (recordData.staffFee.value ?? 0) + (fee ?? 0),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // --- 總費用 ---
                    Row(
                      children: [
                        const Text(
                          '總費用',
                          style: TextStyle(
                            color: Color.fromARGB(255, 61, 61, 61),
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: inputWidth,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$totalFee', // 直接顯示計算後的總費用
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- 收費情形 ---
                    const Text(
                      '收費情形:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      children: ['已收費', '連新國際醫院代收', '未收費'].map((option) {
                        return _buildRadioOption(
                          option,
                          recordData
                              .chargeStatus
                              .value, // groupValue 來自 Provider
                          (val) {
                            dataProvider.updateAmbulanceRecord(
                              recordData.copyWith(chargeStatus: Value(val)),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // --- 若選擇已收費 ---
                    if (recordData.chargeStatus.value == '已收費') ...[
                      const Text(
                        '已收費:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: ['現金', '刷卡'].map((option) {
                          return _buildRadioOption(
                            option,
                            recordData.paidType.value, // groupValue 來自 Provider
                            (val) {
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(paidType: Value(val)),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],

                    // --- 若選擇未收費 ---
                    if (recordData.chargeStatus.value == '未收費') ...[
                      const Text(
                        '未收費:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: ['欠款', '匯款', '統一請款'].map((option) {
                          return _buildRadioOption(
                            option,
                            recordData
                                .unpaidType
                                .value, // groupValue 來自 Provider
                            (val) {
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(unpaidType: Value(val)),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- 小積木 (Helper Widgets) ---

  Widget _buildTitleWithInput({
    required String title,
    required TextEditingController controller,
    required String hint,
    required double inputWidth,
    required ValueChanged<String> onChanged, // 新增 onChanged 回調
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Spacer(),
        SizedBox(
          width: inputWidth,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
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
            onChanged: onChanged, // 綁定 onChanged 事件
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(
    String text,
    String? groupValue,
    Function(String?) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: text,
          groupValue: groupValue,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
