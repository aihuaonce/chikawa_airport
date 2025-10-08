import 'package:flutter/material.dart';

class AmbulanceExpensesPage extends StatefulWidget {
  const AmbulanceExpensesPage({super.key});

  @override
  State<AmbulanceExpensesPage> createState() => _AmbulanceExpensesPageState();
}

class _AmbulanceExpensesPageState extends State<AmbulanceExpensesPage> {
  final TextEditingController _staffFeeController = TextEditingController();
  final TextEditingController _oxygenFeeController = TextEditingController();
  int _totalFee = 0;

  String? _chargeStatus; // 收費情形
  String? _paidType; // 已收費類型
  String? _unpaidType; // 未收費類型

  void _updateTotalFee() {
    final staff = int.tryParse(_staffFeeController.text) ?? 0;
    final oxygen = int.tryParse(_oxygenFeeController.text) ?? 0;
    setState(() {
      _totalFee = staff + oxygen;
    });
  }

  @override
  void initState() {
    super.initState();
    _staffFeeController.addListener(_updateTotalFee);
    _oxygenFeeController.addListener(_updateTotalFee);
  }

  @override
  void dispose() {
    _staffFeeController.dispose();
    _oxygenFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double inputWidth = 120; // 統一寬度

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 800, // 卡片稍微窄一點
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 救護車費用含醫護人員
                _buildTitleWithInput(
                  title: '救護車費用含醫護人員:',
                  controller: _staffFeeController,
                  hint: '請填寫整數',
                  inputWidth: inputWidth,
                ),
                const SizedBox(height: 12),

                // 氧氣使用費用
                _buildTitleWithInput(
                  title: '氧氣使用費用:',
                  controller: _oxygenFeeController,
                  hint: '請填寫整數',
                  inputWidth: inputWidth,
                ),
                const SizedBox(height: 12),

                // 總費用
                Row(
                  children: [
                    const Text(
                      '總費用',
                      style: TextStyle(color: Color.fromARGB(255, 61, 61, 61), fontSize: 16),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: inputWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$_totalFee',
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

                // 收費情形
                const Text(
                  '收費情形:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildRadioOption('已收費', _chargeStatus,
                        (val) => setState(() => _chargeStatus = val)),
                    _buildRadioOption('連新國際醫院代收', _chargeStatus,
                        (val) => setState(() => _chargeStatus = val)),
                    _buildRadioOption('未收費', _chargeStatus,
                        (val) => setState(() => _chargeStatus = val)),
                  ],
                ),
                const SizedBox(height: 12),

                // 若選擇已收費
                if (_chargeStatus == '已收費') ...[
                  const Text(
                    '已收費:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildRadioOption('現金', _paidType,
                          (val) => setState(() => _paidType = val)),
                      _buildRadioOption('刷卡', _paidType,
                          (val) => setState(() => _paidType = val)),
                    ],
                  ),
                ],

                // 若選擇未收費
                if (_chargeStatus == '未收費') ...[
                  const Text(
                    '未收費:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildRadioOption('欠款', _unpaidType,
                          (val) => setState(() => _unpaidType = val)),
                      _buildRadioOption('匯款', _unpaidType,
                          (val) => setState(() => _unpaidType = val)),
                      _buildRadioOption('統一請款', _unpaidType,
                          (val) => setState(() => _unpaidType = val)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWithInput({
    required String title,
    required TextEditingController controller,
    required String hint,
    required double inputWidth,
  }) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(
      String text, String? groupValue, Function(String?) onChanged) {
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