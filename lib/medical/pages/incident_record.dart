import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/medical/incident_view.dart';
import '../../data/db/database.dart';

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
  late TextEditingController _notificationPersonController;
  late TextEditingController _incidentPlaceFinalController;

  bool _isInitialized = false;

  // 自動計算邏輯狀態
  String _timeSpentDisplay = "0.00";
  bool _within10Mins = false;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _notificationPersonController = TextEditingController();
    _incidentPlaceFinalController = TextEditingController();
  }

  @override
  void dispose() {
    _notificationPersonController.dispose();
    _incidentPlaceFinalController.dispose();
    super.dispose();
  }

  // 當 ViewModel 資料載入後,同步到 Controller
  void _updateControllers(IncidentRecordData incident) {
    if (_isInitialized) return;
    _notificationPersonController.text = incident.notificationPerson ?? '';
    _incidentPlaceFinalController.text = incident.incidentPlaceFinal ?? '';
    _isInitialized = true;
  }

  // 計算時間差異
  void _calculateTimeDifference(IncidentViewModel viewModel) {
    final incident = viewModel.incidentRecord;
    if (incident == null ||
        incident.notificationTime == null ||
        incident.landingTime == null) {
      setState(() {
        _hasCalculated = false;
        _timeSpentDisplay = "0.00";
      });
      return;
    }

    try {
      final diff = incident.landingTime!.difference(incident.notificationTime!);
      final minutes = diff.inSeconds / 60.0;

      setState(() {
        _timeSpentDisplay = minutes.toStringAsFixed(2);
        _within10Mins = minutes <= 10.0;
        _hasCalculated = true;
      });
    } catch (e) {
      debugPrint("時間計算錯誤: $e");
    }
  }

  Future<void> _selectDate(IncidentViewModel viewModel) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.incidentRecord?.incidentDate ?? DateTime.now(),
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
      viewModel.updateIncidentDate(picked);
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    DateTime? initialTime,
    Function(DateTime?) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime != null
          ? TimeOfDay.fromDateTime(initialTime)
          : TimeOfDay.now(),
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
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      onTimeSelected(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IncidentViewModel>();
    final incident = viewModel.incidentRecord;

    if (incident != null) {
      _updateControllers(incident);
      // 每次重建時重新計算時間
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateTimeDifference(viewModel);
      });
    }

    if (incident == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('載入事故記錄中...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '事發日期 Incident Date',
                  _buildDateField(viewModel, incident),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '通報時間 Notification Time',
                  _buildTimeField(
                    viewModel,
                    incident.notificationTime,
                    'NOW',
                    (time) => viewModel.updateNotificationTime(time),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFieldWrapper(
            '通報單位 Notification Unit',
            _buildReportingUnitDropdown(viewModel, incident),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '通報人員 Notification Person',
                  _buildTextField(
                    hint: '請輸入姓名',
                    controller: _notificationPersonController,
                    onChanged: (val) => viewModel.updateNotificationPerson(val),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildFieldWrapper(
            '事故地點 (一級) Location Category',
            _buildPlaceCategoryDropdown(viewModel, incident),
          ),
          const SizedBox(height: 20),

          // 🔧 修正：二級地點選單，使用動態載入的選項
          _buildFieldWrapper(
            '事故地點 (二級) Location Sub-Category',
            _buildPlaceCategory2Dropdown(viewModel, incident),
          ),
          const SizedBox(height: 20),
          _buildFieldWrapper(
            '地點備註 Location Remarks',
            _buildTextField(
              hint: '鄰近店家、柱號、登機口等詳細資訊...',
              controller: _incidentPlaceFinalController,
              onChanged: (val) => viewModel.updateIncidentPlaceFinal(val),
            ),
          ),
          const SizedBox(height: 40),
          _buildCheckboxRow(
            '落地前發生 Before Landing',
            incident.beforeLanding,
            (v) => viewModel.updateBeforeLanding(v!),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '落地時間 Landing Time',
                  _buildTimeField(
                    viewModel,
                    incident.landingTime,
                    'SET TIME',
                    (time) => viewModel.updateLandingTime(time),
                    isArrival: true,
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
                flex: 3,
                child: _buildPerformanceIndicator(
                  _within10Mins,
                  _hasCalculated,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // === UI 元件 ===

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

  // 日期選擇欄位
  Widget _buildDateField(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    final dateStr = DateFormat('yyyy-MM-dd').format(incident.incidentDate);
    return InkWell(
      onTap: () => _selectDate(viewModel),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateStr,
              style: const TextStyle(fontSize: 14, color: textDark),
            ),
            const Icon(Icons.calendar_today, color: textMuted, size: 18),
          ],
        ),
      ),
    );
  }

  // 時間選擇欄位
  Widget _buildTimeField(
    IncidentViewModel viewModel,
    DateTime? currentTime,
    String btnText,
    Function(DateTime?) onTimeSelected, {
    bool isArrival = false,
  }) {
    final timeStr = currentTime != null
        ? DateFormat('HH:mm:ss').format(currentTime)
        : '';

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, currentTime, onTimeSelected),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: borderColor),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  timeStr.isEmpty ? 'HH:mm:ss' : timeStr,
                  style: TextStyle(
                    fontSize: 14,
                    color: timeStr.isEmpty
                        ? textMuted.withValues(alpha: 0.4)
                        : textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 44,
          child: OutlinedButton(
            onPressed: () => onTimeSelected(DateTime.now()),
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

  // 通報單位下拉選單
  Widget _buildReportingUnitDropdown(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    final selectedUnit = viewModel.getReportingUnitById(
      incident.reportingUnitId,
    );

    return DropdownButtonFormField<ReportingUnitData>(
      value: selectedUnit,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
      hint: Text(
        '請選取通報單位',
        style: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: viewModel.reportingUnitOptions.map((unit) {
        return DropdownMenuItem<ReportingUnitData>(
          value: unit,
          child: Text(
            unit.name,
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (ReportingUnitData? newValue) {
        if (newValue != null) {
          viewModel.updateReportingUnitId(newValue.id);
        }
      },
    );
  }

  // 一級地點下拉選單
  Widget _buildPlaceCategoryDropdown(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    final selectedCategory = viewModel.getPlaceCategoryById(
      incident.incidentPlaceCategoryId,
    );

    return DropdownButtonFormField<IncidentPlaceCategoryData>(
      value: selectedCategory,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
      hint: Text(
        '請選取事故地點',
        style: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: viewModel.placeCategoryOptions.map((category) {
        return DropdownMenuItem<IncidentPlaceCategoryData>(
          value: category,
          child: Text(
            category.name,
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (IncidentPlaceCategoryData? newValue) {
        if (newValue != null) {
          // 🔧 修正：使用 async 方法更新，會自動載入新的二級選項
          viewModel.updateIncidentPlaceCategoryId(newValue.id);
        }
      },
    );
  }

  // 🔧 修正：二級地點下拉選單 - 使用動態載入的選項
  Widget _buildPlaceCategory2Dropdown(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    // 使用 ViewModel 中動態載入的二級選項
    final category2Options = viewModel.currentCategory2Options;

    final selectedCategory2 = viewModel.getPlaceCategory2ById(
      incident.incidentPlaceCategory2Id,
    );

    // 如果沒有二級選項，顯示提示
    if (category2Options.isEmpty) {
      return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '請先選擇一級地點',
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return DropdownButtonFormField<IncidentPlaceCategory2Data>(
      value: selectedCategory2,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
      hint: Text(
        '請選取二級地點',
        style: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: category2Options.map((category2) {
        return DropdownMenuItem<IncidentPlaceCategory2Data>(
          value: category2,
          child: Text(
            category2.name,
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (IncidentPlaceCategory2Data? newValue) {
        viewModel.updateIncidentPlaceCategory2Id(newValue?.id);
      },
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
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
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: mainColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
