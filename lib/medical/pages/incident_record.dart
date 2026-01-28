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
  late TextEditingController _incomingPhoneController;
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
    _incomingPhoneController = TextEditingController();
    _incidentPlaceFinalController = TextEditingController();
  }

  @override
  void dispose() {
    _notificationPersonController.dispose();
    _incomingPhoneController.dispose();
    _incidentPlaceFinalController.dispose();
    super.dispose();
  }

  // 當 ViewModel 資料載入後,同步到 Controller
  void _updateControllers(IncidentRecordData incident) {
    if (_isInitialized) return;
    _notificationPersonController.text = incident.notificationPerson ?? '';
    _incomingPhoneController.text = incident.incomingPhone ?? '';
    _incidentPlaceFinalController.text = incident.incidentPlaceFinal ?? '';
    _isInitialized = true;
  }

  // 計算時間差異
  void _calculateTimeDifference(IncidentViewModel viewModel) {
    final incident = viewModel.incidentRecord;
    if (incident == null ||
        incident.notificationTime == null ||
        incident.medicalArrivalTime == null) {
      setState(() {
        _hasCalculated = false;
        _timeSpentDisplay = "0.00";
      });
      return;
    }

    try {
      final diff = incident.medicalArrivalTime!.difference(
        incident.notificationTime!,
      );
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

  // 更新時間並計算
  void _updateNow(IncidentViewModel viewModel, Function(DateTime?) updateFn) {
    updateFn(DateTime.now());
    // 觸發重新計算
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTimeDifference(viewModel);
    });
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
                  controller: TextEditingController(
                    text: DateFormat(
                      'yyyy-MM-dd',
                    ).format(incident.incidentDate),
                  ),
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () => _selectDate(viewModel),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '通報時間 Notification Time',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: TextEditingController(
                    text: incident.notificationTime != null
                        ? DateFormat(
                            'HH:mm:ss',
                          ).format(incident.notificationTime!)
                        : '',
                  ),
                  viewModel: viewModel,
                  onTimeSelected: (time) =>
                      viewModel.updateNotificationTime(time),
                  onPressed: () => _updateNow(
                    viewModel,
                    (time) => viewModel.updateNotificationTime(time),
                  ),
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
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '接獲電話 Incoming Phone',
                _buildTextField(
                  hint: '分機或手機號碼',
                  controller: _incomingPhoneController,
                  onChanged: (val) => viewModel.updateIncomingPhone(val),
                ),
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
                  controller: TextEditingController(
                    text: incident.notificationToOccTime != null
                        ? DateFormat(
                            'HH:mm:ss',
                          ).format(incident.notificationToOccTime!)
                        : '',
                  ),
                  viewModel: viewModel,
                  onTimeSelected: (time) =>
                      viewModel.updateNotificationToOccTime(time),
                  onPressed: () => _updateNow(
                    viewModel,
                    (time) => viewModel.updateNotificationToOccTime(time),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '醫護出發時間 Team Departure',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: TextEditingController(
                    text: incident.teamDepartureTime != null
                        ? DateFormat(
                            'HH:mm:ss',
                          ).format(incident.teamDepartureTime!)
                        : '',
                  ),
                  viewModel: viewModel,
                  onTimeSelected: (time) =>
                      viewModel.updateTeamDepartureTime(time),
                  onPressed: () => _updateNow(
                    viewModel,
                    (time) => viewModel.updateTeamDepartureTime(time),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCheckboxRow(
          '營運控制 (OCC) 已到達現場 OCC Arrived at Scene',
          incident.occArrived,
          (v) => viewModel.updateOccArrived(v!),
        ),

        const SizedBox(height: 40),

        _buildFieldWrapper(
          '事故地點 Location',
          _buildPlaceCategoryDropdown(viewModel, incident),
        ),

        // 只有當有二級選項時才顯示二級地點選單（沒有標籤）
        if (viewModel.currentCategory2Options.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildPlaceCategory2Dropdown(viewModel, incident),
        ],

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

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '醫護到達時間 Medical Arrival',
                _buildTimeFieldWithButton(
                  'ARRIVED',
                  controller: TextEditingController(
                    text: incident.medicalArrivalTime != null
                        ? DateFormat(
                            'HH:mm:ss',
                          ).format(incident.medicalArrivalTime!)
                        : '',
                  ),
                  isArrival: true,
                  viewModel: viewModel,
                  onTimeSelected: (time) =>
                      viewModel.updateMedicalArrivalTime(time),
                  onPressed: () => _updateNow(
                    viewModel,
                    (time) => viewModel.updateMedicalArrivalTime(time),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '檢查時間 Examination Time',
                _buildTimeFieldWithButton(
                  'NOW',
                  controller: TextEditingController(
                    text: incident.examinationTime != null
                        ? DateFormat(
                            'HH:mm:ss',
                          ).format(incident.examinationTime!)
                        : '',
                  ),
                  viewModel: viewModel,
                  onTimeSelected: (time) =>
                      viewModel.updateExaminationTime(time),
                  onPressed: () => _updateNow(
                    viewModel,
                    (time) => viewModel.updateExaminationTime(time),
                  ),
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
    required VoidCallback onPressed,
    required IncidentViewModel viewModel,
    required Function(DateTime?) onTimeSelected,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            hint: 'HH:mm:ss',
            controller: controller,
            readOnly: true,
            onTap: () => _selectTime(context, controller.text, onTimeSelected),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 44,
          child: OutlinedButton(
            onPressed: onPressed,
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

  // 修改後的時間選擇器
  Future<void> _selectTime(
    BuildContext context,
    String currentTimeStr,
    Function(DateTime?) onTimeSelected,
  ) async {
    // 解析當前時間或使用現在時間
    TimeOfDay initialTime;
    try {
      if (currentTimeStr.isNotEmpty) {
        final parts = currentTimeStr.split(':');
        initialTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } else {
        initialTime = TimeOfDay.now();
      }
    } catch (e) {
      initialTime = TimeOfDay.now();
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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

  Widget _buildTextField({
    required String hint,
    IconData? suffixIcon,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
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

  Widget _buildReportingUnitDropdown(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    final selectedUnit = viewModel.getReportingUnitById(
      incident.reportingUnitId,
    );

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportingUnitData>(
          value: selectedUnit,
          hint: Text(
            '請選取通報單位',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: viewModel.reportingUnitOptions
              .map(
                (ReportingUnitData unit) => DropdownMenuItem<ReportingUnitData>(
                  value: unit,
                  child: Text(
                    unit.name,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) {
              viewModel.updateReportingUnitId(val.id);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlaceCategoryDropdown(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    final selectedCategory = viewModel.getPlaceCategoryById(
      incident.incidentPlaceCategoryId,
    );

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<IncidentPlaceCategoryData>(
          value: selectedCategory,
          hint: Text(
            '請選取事故地點',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: viewModel.placeCategoryOptions
              .map(
                (IncidentPlaceCategoryData category) =>
                    DropdownMenuItem<IncidentPlaceCategoryData>(
                      value: category,
                      child: Text(
                        category.name,
                        style: const TextStyle(fontSize: 14, color: textDark),
                      ),
                    ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) {
              viewModel.updateIncidentPlaceCategoryId(val.id);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlaceCategory2Dropdown(
    IncidentViewModel viewModel,
    IncidentRecordData incident,
  ) {
    final category2Options = viewModel.currentCategory2Options;
    final selectedCategory2 = viewModel.getPlaceCategory2ById(
      incident.incidentPlaceCategory2Id,
    );

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<IncidentPlaceCategory2Data>(
          value: selectedCategory2,
          hint: Text(
            '請選取地點',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: category2Options
              .map(
                (IncidentPlaceCategory2Data category2) =>
                    DropdownMenuItem<IncidentPlaceCategory2Data>(
                      value: category2,
                      child: Text(
                        category2.name,
                        style: const TextStyle(fontSize: 14, color: textDark),
                      ),
                    ),
              )
              .toList(),
          onChanged: (val) => viewModel.updateIncidentPlaceCategory2Id(val?.id),
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
