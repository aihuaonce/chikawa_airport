import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

// 引入 nav5.dart 以獲取 AmbulanceDataProvider 和 SavableStateMixin
import 'nav5.dart'; // 假設 SavableStateMixin 定義在 nav5.dart 或其引用的檔案中

class AmbulanceExpensesPage extends StatefulWidget {
  final int visitId;
  const AmbulanceExpensesPage({super.key, required this.visitId});

  @override
  State<AmbulanceExpensesPage> createState() => _AmbulanceExpensesPageState();
}

// ✅ 1. 引入 Mixins
class _AmbulanceExpensesPageState extends State<AmbulanceExpensesPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  final _staffFeeController = TextEditingController();
  final _oxygenFeeController = TextEditingController();

  // ✅ 2. 實現 wantKeepAlive
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // 使用 context.read 在 initState 中安全地讀取一次資料
    final dataProvider = context.read<AmbulanceDataProvider>();
    final recordData = dataProvider.ambulanceRecordData;

    _staffFeeController.text = recordData.staffFee.value?.toString() ?? '';
    _oxygenFeeController.text = recordData.oxygenFee.value?.toString() ?? '';
  }

  @override
  void dispose() {
    _staffFeeController.dispose();
    _oxygenFeeController.dispose();
    super.dispose();
  }

  // ✅ 3. 實現 saveData 方法
  @override
  Future<void> saveData() async {
    // 這個方法將由外部（如 Nav5Page 的統一儲存按鈕）呼叫
    try {
      final dataProvider = context.read<AmbulanceDataProvider>();
      final recordData = dataProvider.ambulanceRecordData;

      final staffFee = int.tryParse(_staffFeeController.text);
      final oxygenFee = int.tryParse(_oxygenFeeController.text);
      final totalFee = (staffFee ?? 0) + (oxygenFee ?? 0);

      // 一次性更新所有相關欄位
      dataProvider.updateAmbulanceRecord(
        recordData.copyWith(
          staffFee: Value(staffFee),
          oxygenFee: Value(oxygenFee),
          totalFee: Value(totalFee),
          // chargeStatus, paidType 等欄位已經在 Provider 中，無需在這裡重複設定
        ),
      );
    } catch (e) {
      // 如果發生錯誤，將其拋出，讓呼叫者（儲存按鈕）處理
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 4. 必須呼叫 super.build(context)
    super.build(context);

    const double inputWidth = 120;

    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        final recordData = dataProvider.ambulanceRecordData;

        // ✅ 5. 狀態同步：確保 Controller 的文字與 Provider 的資料一致
        // 這可以防止在其他地方修改資料後，此頁面顯示舊資料
        final providerStaffFee = recordData.staffFee.value?.toString() ?? '';
        if (_staffFeeController.text != providerStaffFee) {
          _staffFeeController.text = providerStaffFee;
        }

        final providerOxygenFee = recordData.oxygenFee.value?.toString() ?? '';
        if (_oxygenFeeController.text != providerOxygenFee) {
          _oxygenFeeController.text = providerOxygenFee;
        }

        // ✅ 6. 總費用從 Controller 即時計算，提供立即的 UI 反應
        final totalFee =
            (int.tryParse(_staffFeeController.text) ?? 0) +
            (int.tryParse(_oxygenFeeController.text) ?? 0);

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
                        // ✅ 7. onChanged 只更新本地狀態 (setState)，不直接呼叫 Provider
                        setState(() {});
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
                        setState(() {});
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
                              '$totalFee', // 顯示從 Controller 計算的總費用
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
                          recordData.chargeStatus.value,
                          (val) {
                            // ✅ 8. Radio Button 這類簡單選項可以直接更新 Provider
                            dataProvider.updateAmbulanceRecord(
                              recordData.copyWith(
                                chargeStatus: Value(val),
                                // 清空依賴於 chargeStatus 的選項
                                paidType: const Value(null),
                                unpaidType: const Value(null),
                              ),
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
                            recordData.paidType.value,
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
                            recordData.unpaidType.value,
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

  // --- Helper Widgets (無需修改) ---

  Widget _buildTitleWithInput({
    required String title,
    required TextEditingController controller,
    required String hint,
    required double inputWidth,
    required ValueChanged<String> onChanged,
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
            onChanged: onChanged,
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
