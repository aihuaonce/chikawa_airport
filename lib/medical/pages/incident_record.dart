import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncidentRecord extends StatefulWidget {
  final int medicalId;

  const IncidentRecord({super.key, required this.medicalId});

  @override
  State<IncidentRecord> createState() => _IncidentRecordState();
}

class _IncidentRecordState extends State<IncidentRecord> {
  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // 控制器
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notifTimeController = TextEditingController();
  final TextEditingController _occTimeController = TextEditingController();
  final TextEditingController _departureTimeController =
      TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _examTimeController = TextEditingController();

  // 下拉選單狀態
  String? _selectedUnit;
  String? _selectedLocation;
  bool _occArrived = false;

  // 自動計算邏輯狀態
  String _timeSpentDisplay = "0.00";
  bool _within10Mins = false;
  bool _hasCalculated = false;

  @override
  void dispose() {
    _dateController.dispose();
    _notifTimeController.dispose();
    _occTimeController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    _examTimeController.dispose();
    super.dispose();
  }

  // 更新時間並計算
  void _updateNow(TextEditingController controller) {
    setState(() {
      controller.text = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    _calculateTimeDifference();
  }

  // 計算邏輯
  void _calculateTimeDifference() {
    if (_notifTimeController.text.isEmpty ||
        _arrivalTimeController.text.isEmpty) {
      return;
    }

    try {
      DateFormat format = DateFormat("HH:mm:ss");
      DateTime start = format.parse(_notifTimeController.text);
      DateTime end = format.parse(_arrivalTimeController.text);

      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      Duration diff = end.difference(start);
      double minutes = diff.inSeconds / 60.0;

      setState(() {
        _timeSpentDisplay = minutes.toStringAsFixed(2);
        _within10Mins = minutes <= 10.0;
        _hasCalculated = true;
      });
    } catch (e) {
      debugPrint("時間格式解析錯誤");
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '事發日期 Incident Date',
                _buildTextField(
                  hint: '請選擇日期',
                  controller: _dateController,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: _selectDate,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '通報時間 Notification Time',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: _notifTimeController,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildFieldWrapper(
          '通報單位 Notification Unit',
          _buildDropdownField(
            hint: '請選取通報單位',
            value: _selectedUnit,
            items: const [
              'T1-OCC',
              'T2-OCC',
              '華航',
              '長榮',
              '虎航',
              '星宇',
              '采盟',
              '昇恆昌',
              '病人或家屬',
              '其它',
            ],
            onChanged: (val) => setState(() => _selectedUnit = val),
          ),
        ),

        if (_selectedUnit == '其它') ...[
          const SizedBox(height: 12),
          _buildTextField(hint: '請註明其它通報單位'),
        ],

        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '通報人員 Notification Person',
                _buildTextField(hint: '請輸入姓名'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '接獲電話 Incoming Phone',
                _buildTextField(hint: '分機或手機號碼'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '通報 OCC 時間 Notification to OCC',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: _occTimeController,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '醫護出發時間 Team Departure',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: _departureTimeController,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCheckboxRow(
          '營運控制 (OCC) 已到達現場 OCC Arrived at Scene',
          _occArrived,
          (v) => setState(() => _occArrived = v!),
        ),

        const SizedBox(height: 40),

        _buildFieldWrapper(
          '事故地點 Location',
          _buildDropdownField(
            hint: '請選取事故地點',
            value: _selectedLocation,
            items: const ['第一航廈', '第二航廈', '遠端機坪', '貨運站&機坪其它', '諾富特飯店', '飛機機艙內'],
            onChanged: (val) => setState(() => _selectedLocation = val),
          ),
        ),
        const SizedBox(height: 20),
        _buildFieldWrapper(
          '地點備註 Location Remarks',
          _buildTextField(hint: '鄰近店家、柱號、登機口等詳細資訊...'),
        ),

        const SizedBox(height: 40),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '醫護到達時間 Medical Arrival',
                _buildTimeFieldWithButton(
                  'ARRIVED',
                  controller: _arrivalTimeController,
                  isArrival: true,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '檢查時間 Examination Time',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: _examTimeController,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(flex: 2, child: _buildTimeSpentBadge(_timeSpentDisplay)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPerformanceIndicator(_within10Mins, _hasCalculated),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 元件 ---

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildTimeFieldWithButton(
    String btnText, {
    required TextEditingController controller,
    bool isArrival = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(hint: 'HH:mm:ss', controller: controller),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 44,
          child: OutlinedButton(
            onPressed: () => _updateNow(controller),
            style: OutlinedButton.styleFrom(
              backgroundColor: isArrival
                  ? primaryColor.withValues(alpha: 0.05)
                  : Colors.white,
              foregroundColor: primaryColor,
              side: BorderSide(
                color: isArrival
                    ? primaryColor.withValues(alpha: 0.2)
                    : borderColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(
              btnText,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? suffixIcon,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: textMuted, size: 18)
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: items
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
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

  Widget _buildCheckboxRow(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSpentBadge(String time) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '花費時間 TIME SPENT',
            style: TextStyle(
              color: textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: time,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const TextSpan(
                  text: ' MIN',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 是否在10分鐘內到達
  Widget _buildPerformanceIndicator(bool isSuccess, bool hasCalculated) {
    Color mainColor;
    Color bgColor;
    IconData icon;
    String label;

    if (!hasCalculated) {
      mainColor = textMuted;
      bgColor = Colors.grey.withValues(alpha: 0.05);
      icon = Icons.help_outline;
      label = '等待計算中...';
    } else {
      mainColor = isSuccess ? Colors.green : Colors.red;
      bgColor = isSuccess
          ? Colors.green.withValues(alpha: 0.05)
          : Colors.red.withValues(alpha: 0.05);
      icon = isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded;
      label = isSuccess ? '10分鐘內到達 Within 10 Mins' : '未在10分鐘內到達 Over 10 Mins';
    }

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: mainColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: mainColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: mainColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
