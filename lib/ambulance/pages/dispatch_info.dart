import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DispatchInfo extends StatefulWidget {
  final int ambulanceId;

  const DispatchInfo({super.key, required this.ambulanceId});

  @override
  State<DispatchInfo> createState() => _DispatchInfoState();
}

class _DispatchInfoState extends State<DispatchInfo> {
  // 樣式顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Colors.white;

  // 控制器
  final TextEditingController _dispatchTimeController = TextEditingController();
  final TextEditingController _arrivalSceneController = TextEditingController();
  final TextEditingController _leavingSceneController = TextEditingController();
  final TextEditingController _arrivalHospitalController =
      TextEditingController();
  final TextEditingController _leavingHospitalController =
      TextEditingController();
  final TextEditingController _returnStandbyController =
      TextEditingController();

  // 狀態變數
  String _transportReason = '病情需要'; // 病情需要, 病人/家屬要求

  @override
  void dispose() {
    _dispatchTimeController.dispose();
    _arrivalSceneController.dispose();
    _leavingSceneController.dispose();
    _arrivalHospitalController.dispose();
    _leavingHospitalController.dispose();
    _returnStandbyController.dispose();
    super.dispose();
  }

  // 更新時間為現在
  void _updateNow(TextEditingController controller) {
    setState(() {
      controller.text = DateFormat(
        'yyyy/MM/dd HH:mm:ss',
      ).format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一排：車牌 與 地點
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '車牌號碼 License Plate No.',
                _buildTextField(hint: '輸入車牌號碼'),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '發生地點 Incident Location',
                _buildTextField(hint: '輸入發生地點'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：地點備註 (全寬)
        _buildFieldWrapper(
          '地點備註 Location Remarks',
          _buildTextField(hint: '請詳述具體地點資訊...', maxLines: 3),
        ),

        const SizedBox(height: 24),

        // 第三排：出勤時間 與 到達現場時間
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                '出勤日期與時間 Dispatch Time',
                _dispatchTimeController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTimeField(
                '到達現場時間 Arrival Time',
                _arrivalSceneController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第四排：送往醫院 與 運送原因
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '送往醫院或地點 Hospital/Destination',
                _buildTextField(hint: '輸入醫院名稱'),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '運送原因 Transport Reason',
                _buildSegmentedControl(
                  ['病情需要', '病人/家屬要求'],
                  _transportReason,
                  (v) => setState(() => _transportReason = v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第五排：離開現場時間 與 到達醫院時間
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                '離開現場時間 Leaving Scene',
                _leavingSceneController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTimeField(
                '到達醫院時間 Arrival Hospital',
                _arrivalHospitalController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第六排：離開醫院時間 與 返回待命時間
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                '離開醫院時間 Leaving Hospital',
                _leavingHospitalController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTimeField(
                '返回待命時間 Return to Standby',
                _returnStandbyController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件 ---

  Widget _buildTimeField(String label, TextEditingController controller) {
    return _buildFieldWrapper(
      label,
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              hint: 'YYYY/MM/DD HH:mm:ss',
              controller: controller,
              readOnly: true,
            ),
          ),
          const SizedBox(width: 8),
          _buildNowButton(() => _updateNow(controller)),
        ],
      ),
    );
  }

  Widget _buildNowButton(VoidCallback onPressed) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.withValues(alpha: 0.1),
          foregroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text(
          'NOW',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt,
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
      children: [
        _buildLabel(label.toUpperCase()),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 44 : null,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          filled: true,
          fillColor: bgField,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
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
      ),
    );
  }
}
