import 'package:flutter/material.dart';

class AmbulanceFees extends StatefulWidget {
  final int medicalId;
  const AmbulanceFees({super.key, required this.medicalId});

  @override
  State<AmbulanceFees> createState() => _AmbulanceFeesState();
}

class _AmbulanceFeesState extends State<AmbulanceFees> {
  // 樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // --- 狀態變數 ---
  double _ambulanceFee = 0;
  double _oxygenFee = 0;

  // 收費情形狀態
  String _paymentStatus = '未收費'; // 已收費, 聯新國際醫院代收, 未收費
  String? _selectedSubOption; // 子選項狀態

  @override
  Widget build(BuildContext context) {
    double totalAmount = _ambulanceFee + _oxygenFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 費用輸入網格
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '救護車費用(含醫務人員) AMBULANCE FEE',
                _buildNumberField(
                  onChanged: (v) => setState(() => _ambulanceFee = v),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '氧氣使用費用 OXYGEN USAGE FEE',
                _buildNumberField(
                  onChanged: (v) => setState(() => _oxygenFee = v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. 總費用顯示
        _buildLabel('總費用 TOTAL FEE'),
        const SizedBox(height: 8),
        _buildTotalAmountBadge(totalAmount),

        const SizedBox(height: 32),

        // 3. 收費情形
        _buildLabel('收費情形 PAYMENT STATUS'),
        const SizedBox(height: 10),
        _buildMainStatusToggle(),

        // 4. 動態子選項區塊
        if (_paymentStatus == '已收費') ...[
          const SizedBox(height: 16),
          _buildSubOptionContainer(
            label: '已收費方式 PAID METHOD',
            options: ['現金 Cash', '刷卡 Card'],
          ),
        ],

        if (_paymentStatus == '未收費') ...[
          const SizedBox(height: 16),
          _buildSubOptionContainer(
            label: '未收費類別 UNPAID TYPE',
            options: ['欠款 Arrears', '匯款 Remittance', '統一請款 Unified Billing'],
          ),
        ],

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件 ---

  // 主收費狀態切換 (Segmented Control)
  Widget _buildMainStatusToggle() {
    final options = ['已收費', '聯新國際醫院代收', '未收費'];
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSelected = _paymentStatus == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _paymentStatus = opt;
                _selectedSubOption = null; // 切換主項時重置子項
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 子選項卡片容器 (參考您之前的 SubContainer 樣式)
  Widget _buildSubOptionContainer({
    required String label,
    required List<String> options,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: options.map((opt) {
              bool isSel = _selectedSubOption == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSel,
                onSelected: (val) =>
                    setState(() => _selectedSubOption = val ? opt : null),
                selectedColor: primaryColor.withValues(alpha: 0.1),
                checkmarkColor: primaryColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: isSel ? primaryColor : borderColor),
                ),
                labelStyle: TextStyle(
                  color: isSel ? primaryColor : textDark,
                  fontSize: 13,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 總費用顯示塊
  Widget _buildTotalAmountBadge(double amount) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTAL AMOUNT',
            style: TextStyle(
              color: textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '\$ ',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                amount.toStringAsFixed(2),
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 基礎元件 ---

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 8), field],
    );
  }

  Widget _buildNumberField({required Function(double) onChanged}) {
    return SizedBox(
      height: 44,
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        onChanged: (v) => onChanged(double.tryParse(v) ?? 0.0),
        decoration: InputDecoration(
          hintText: '0.00',
          prefixText: '\$ ',
          prefixStyle: const TextStyle(
            color: textMuted,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
