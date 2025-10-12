import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/ambulance_data.dart';

class AmbulanceExpensesPage extends StatefulWidget {
  final int visitId;
  const AmbulanceExpensesPage({super.key, required this.visitId});

  @override
  State<AmbulanceExpensesPage> createState() => _AmbulanceExpensesPageState();
}

class _AmbulanceExpensesPageState extends State<AmbulanceExpensesPage> {
  final _staffFeeController = TextEditingController();
  final _oxygenFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<AmbulanceData>();
    _staffFeeController.text = data.staffFee?.toString() ?? '';
    _oxygenFeeController.text = data.oxygenFee?.toString() ?? '';
  }

  @override
  void dispose() {
    _staffFeeController.dispose();
    _oxygenFeeController.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<AmbulanceData>();
    final staffFee = int.tryParse(_staffFeeController.text);
    final oxygenFee = int.tryParse(_oxygenFeeController.text);
    final totalFee = (staffFee ?? 0) + (oxygenFee ?? 0);

    data.updateExpenses(
      staffFee: staffFee,
      oxygenFee: oxygenFee,
      totalFee: totalFee,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double inputWidth = 120;

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        // 確保 Controller 的文字與 Provider 的資料一致
        final providerStaffFee = data.staffFee?.toString() ?? '';
        if (_staffFeeController.text != providerStaffFee) {
          _staffFeeController.text = providerStaffFee;
        }

        final providerOxygenFee = data.oxygenFee?.toString() ?? '';
        if (_oxygenFeeController.text != providerOxygenFee) {
          _oxygenFeeController.text = providerOxygenFee;
        }

        // 總費用從 Controller 即時計算
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
                    _buildTitleWithInput(
                      title: '救護車費用含醫護人員:',
                      controller: _staffFeeController,
                      hint: '請填寫整數',
                      inputWidth: inputWidth,
                      onChanged: (value) {
                        setState(() {});
                        _saveToProvider();
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTitleWithInput(
                      title: '氧氣使用費用:',
                      controller: _oxygenFeeController,
                      hint: '請填寫整數',
                      inputWidth: inputWidth,
                      onChanged: (value) {
                        setState(() {});
                        _saveToProvider();
                      },
                    ),
                    const SizedBox(height: 12),

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
                              '$totalFee',
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
                        return _buildRadioOption(option, data.chargeStatus, (
                          val,
                        ) {
                          data.updateExpenses(
                            chargeStatus: val,
                            paidType: null,
                            unpaidType: null,
                          );
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    if (data.chargeStatus == '已收費') ...[
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
                            data.paidType,
                            (val) => data.updateExpenses(paidType: val),
                          );
                        }).toList(),
                      ),
                    ],

                    if (data.chargeStatus == '未收費') ...[
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
                            data.unpaidType,
                            (val) => data.updateExpenses(unpaidType: val),
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
