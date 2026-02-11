import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import '../../data/db/database.dart';
import 'dart:async';

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

  // Controllers
  final TextEditingController _ambulanceFeeCtrl = TextEditingController();
  final TextEditingController _oxygenFeeCtrl = TextEditingController();
  Timer? _debounce;

  // 收費情形狀態
  String _paymentStatus = '未收費'; // 已收費, 聯新國際醫院代收, 未收費
  String? _selectedSubOption; // 子選項狀態

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _ambulanceFeeCtrl.dispose();
    _oxygenFeeCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 讀取資料
  Future<void> _loadData() async {
    final dao = context.read<AppDatabase>().ambulanceDao;
    final data = await dao.getAmbulanceFee(widget.medicalId);

    if (data != null && mounted) {
      setState(() {
        _ambulanceFee = data.ambulanceFee;
        _oxygenFee = data.oxygenFee;
        _ambulanceFeeCtrl.text = _formatNumber(data.ambulanceFee);
        _oxygenFeeCtrl.text = _formatNumber(data.oxygenFee);
        _paymentStatus = data.paymentStatus ?? '未收費';

        if (_paymentStatus == '已收費') {
          _selectedSubOption = data.paymentMethod;
        } else if (_paymentStatus == '未收費') {
          _selectedSubOption = data.unpaidType;
        } else {
          _selectedSubOption = null;
        }
      });
    }
  }

  String _formatNumber(double value) {
    if (value == 0) return '';
    if (value == value.toInt()) return value.toInt().toString();
    return value.toString();
  }

  // 儲存資料
  void _saveData() {
    final dao = context.read<AppDatabase>().ambulanceDao;
    
    // 根據 paymentStatus 決定 subOptions 的儲存位置
    String? paymentMethod;
    String? unpaidType;

    if (_paymentStatus == '已收費') {
      paymentMethod = _selectedSubOption;
    } else if (_paymentStatus == '未收費') {
      unpaidType = _selectedSubOption;
    }

    final companion = AmbulanceFeesCompanion(
      medicalId: Value(widget.medicalId),
      ambulanceFee: Value(_ambulanceFee),
      oxygenFee: Value(_oxygenFee),
      paymentStatus: Value(_paymentStatus),
      paymentMethod: Value(paymentMethod),
      unpaidType: Value(unpaidType),
    );

    dao.updateAmbulanceFee(companion);
  }

  // 延遲儲存 (用於輸入框)
  void _debounceSave() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _saveData();
    });
  }

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
                  controller: _ambulanceFeeCtrl,
                  onChanged: (v) {
                    setState(() => _ambulanceFee = double.tryParse(v) ?? 0);
                    _debounceSave();
                  },
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '氧氣使用費用 OXYGEN USAGE FEE',
                _buildNumberField(
                  controller: _oxygenFeeCtrl,
                  onChanged: (v) {
                    setState(() => _oxygenFee = double.tryParse(v) ?? 0);
                    _debounceSave();
                  },
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
              onTap: () {
                setState(() {
                  _paymentStatus = opt;
                  _selectedSubOption = null; // 切換主項時重置子項
                });
                _saveData(); // 狀態切換立即儲存
              },
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
                onSelected: (val) {
                  setState(() => _selectedSubOption = val ? opt : null);
                  _saveData(); // 子選項選擇立即儲存
                },
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

  Widget _buildNumberField({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        onChanged: onChanged,
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
