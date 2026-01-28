import 'package:flutter/material.dart';

class MedicalFees extends StatefulWidget {
  final int medicalId;

  const MedicalFees({super.key, required this.medicalId});

  @override
  State<MedicalFees> createState() => _MedicalFeesState();
}

class _MedicalFeesState extends State<MedicalFees> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  String _paymentMethod = '自付';
  double _consultFee = 0;
  double _ambulanceFee = 0;
  String _selfPayType = '現金';
  String _collectionStatus = '尚未收款';
  String _currency = '台幣';
  bool _receiptIssued = false;
  bool _userAgreed = false;

  @override
  Widget build(BuildContext context) {
    double totalAmount = _consultFee + _ambulanceFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('付款方式 Payment Method'),
        const SizedBox(height: 8),
        _buildMainPaymentMethodSelector(),
        const SizedBox(height: 16),

        // 狀態/類型切換
        _buildDynamicConditionSection(),

        // 根據付款方式出現的額外資訊 (修正：若無內容則不佔空間)
        _buildExtraInfoFields(),

        const SizedBox(height: 24),

        // 費用輸入
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '出診費 Consultation Fee',
                _buildNumberField(
                  onChanged: (v) => setState(() => _consultFee = v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '救護車費用 Ambulance Fee',
                _buildNumberField(
                  onChanged: (v) => setState(() => _ambulanceFee = v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        _buildLabel('總費用 Total Amount'),
        const SizedBox(height: 8),
        _buildTotalAmountBadge(totalAmount),
        const SizedBox(height: 24),

        _buildFieldWrapper(
          '收費備註 Fee Remarks',
          _buildTextField(hint: '請輸入收費相關備註...', maxLines: 3),
        ),
        const SizedBox(height: 24),

        _buildConsentBox(),
        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: _buildSignatureSection('同意人簽名 Consenter Signature'),
            ),
            const SizedBox(width: 24),
            Expanded(child: _buildSignatureSection('見證人簽名 Witness Signature')),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildDynamicConditionSection() {
    switch (_paymentMethod) {
      case '自付':
        return _buildFieldWrapper(
          '自付方式 Payment Type',
          _buildSegmentedControl(
            ['現金', '刷卡'],
            _selfPayType,
            (v) => setState(() => _selfPayType = v),
          ),
        );
      case '統一請款':
      case '收費異常':
        return _buildFieldWrapper(
          '收款狀態 Status',
          _buildSegmentedControl(
            ['尚未收款', '已收款', '不需要'],
            _collectionStatus,
            (v) => setState(() => _collectionStatus = v),
          ),
        );
      case '總院會核代收':
        return _buildFieldWrapper(
          '收款狀態 Status',
          _buildSegmentedControl(
            ['尚未收款', '已收款'],
            _collectionStatus,
            (v) => setState(() => _collectionStatus = v),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildExtraInfoFields() {
    bool showCurrency =
        (_paymentMethod == '自付' && _selfPayType == '現金') ||
        (_paymentMethod != '自付');

    // 如果沒有任何額外資訊要顯示，直接回傳空元件，避免產生 SizedBox 的間距
    if (!showCurrency && _paymentMethod == '自付') return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 24), // 統一在此處處理與上方動態區塊的間距
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end, // 確保底部對齊
            children: [
              if (showCurrency)
                Expanded(
                  child: _buildFieldWrapper(
                    '選擇貨幣 Currency',
                    _buildDropdownField(_currency, [
                      '台幣',
                      '美金',
                      '人民幣',
                      '日幣',
                      '加幣',
                    ], (v) => setState(() => _currency = v!)),
                  ),
                ),
              if (showCurrency &&
                  (_paymentMethod == '統一請款' || _paymentMethod == '總院會核代收'))
                const SizedBox(width: 16),

              if (_paymentMethod == '統一請款')
                Expanded(
                  child: _buildFieldWrapper(
                    '申請人 Applicant',
                    _buildTextField(hint: '輸入姓名'),
                  ),
                )
              else if (_paymentMethod == '總院會核代收')
                Expanded(child: _buildReceiptIssuedToggle()) // 這裡已修正對齊
              else if (showCurrency && _paymentMethod != '自付')
                Expanded(child: const SizedBox()),
            ],
          ),
          if (_paymentMethod == '統一請款') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFieldWrapper(
                    '申請單位 Unit',
                    _buildTextField(hint: '輸入單位名稱'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '聯絡電話 Phone',
                    _buildTextField(hint: '輸入聯絡電話'),
                  ),
                ),
              ],
            ),
          ],
          if (_paymentMethod == '總院會核代收') ...[
            const SizedBox(height: 16),
            _buildFieldWrapper(
              '急診櫃檯簽收框 Counter Receipt',
              _buildSignaturePad('Emergency Counter Signature Area'),
            ),
          ],
          if (_paymentMethod == '收費異常') ...[
            const SizedBox(height: 16),
            _buildFieldWrapper(
              '收費異常原因 Reason',
              _buildTextField(hint: '請說明收費異常原因...', maxLines: 2),
            ),
          ],
        ],
      ),
    );
  }

  // 修正對齊問題的收據勾選組件
  Widget _buildReceiptIssuedToggle() {
    return InkWell(
      onTap: () => setState(() => _receiptIssued = !_receiptIssued),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44, // 固定的 44px
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _receiptIssued
              ? primaryColor.withValues(alpha: 0.05)
              : Colors.white,
          border: Border.all(
            color: _receiptIssued ? primaryColor : borderColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // 核心修正：垂直置中
          children: [
            Icon(
              _receiptIssued ? Icons.check_box : Icons.check_box_outline_blank,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '已開立收據並轉交',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmountBadge(double amount) {
    return Container(
      height: 54,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'TWD\$',
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount.toStringAsFixed(0),
            style: const TextStyle(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // --- 其餘輔助組件保持不變 ---
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildTextField({required String hint, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildMainPaymentMethodSelector() {
    final List<String> methods = ['自付', '統一請款', '總院會核代收', '收費異常'];
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // 淺灰色背景軌道
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: methods.map((m) {
          bool isSel = _paymentMethod == m;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _paymentMethod = m;
                // 安全檢查：若切換到總院代收，收款狀態不能是「不需要」
                if (m == '總院會核代收' && _collectionStatus == '不需要') {
                  _collectionStatus = '尚未收款';
                }
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSel
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  m,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 12,
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

  Widget _buildNumberField({required Function(double) onChanged}) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        initialValue: '0',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        onChanged: (v) {
          double value = double.tryParse(v) ?? 0;
          onChanged(value);
        },
        decoration: InputDecoration(
          prefixText: r'$ ',
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

  Widget _buildDropdownField(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSel = current == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 11,
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

  Widget _buildSignaturePad(String placeholder) {
    return AspectRatio(
      aspectRatio: 2.5 / 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.draw_outlined, color: borderColor, size: 36),
                  const SizedBox(height: 4),
                  Text(
                    placeholder,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '重簽 CLEAR',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentBox() {
    Color activeCol = _userAgreed ? primaryColor : Colors.grey;
    return InkWell(
      onTap: () => setState(() => _userAgreed = !_userAgreed),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: activeCol.withValues(alpha: 0.05),
          border: Border.all(color: activeCol.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _userAgreed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: activeCol,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '了解醫護人員說明需醫療收費之緣由且同意',
                    style: TextStyle(
                      color: activeCol,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'I understand the explanation of the medical charges and agree to them.',
                    style: TextStyle(
                      color: activeCol.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureSection(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        _buildSignaturePad('Digital Signature Area'),
      ],
    );
  }

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 6), field],
    );
  }
}
