import 'package:flutter/material.dart';

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
  static const Color bgField = Color(0xFFF9FBFC);

  // 本地狀態 (UI 示範用)
  bool _occArrived = false;
  bool _within10Mins = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContentCard(
          title: 'Initial Notification (通報詳情)',
          icon: Icons.info_outline,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildFieldWrapper(
                    'Incident Date (事發日期)',
                    _buildTextField(
                      hint: '請選擇日期',
                      suffixIcon: Icons.calendar_today,
                    ),
                    width: 220,
                  ),
                  _buildFieldWrapper(
                    'Notification Time (通報時間)',
                    _buildTextField(
                      hint: '請輸入時間',
                      suffixIcon: Icons.access_time,
                    ),
                    width: 180,
                  ),
                  _buildFieldWrapper(
                    'Notification Unit (通報單位)',
                    _buildTextField(hint: '例如: Security'),
                    width: 200,
                  ),
                  _buildFieldWrapper(
                    'Notification Person (通報人員)',
                    _buildTextField(hint: '輸入姓名'),
                    width: 180,
                  ),
                  _buildFieldWrapper(
                    'Phone (電話)',
                    _buildTextField(hint: '例如: +852...'),
                    width: 180,
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildContentCard(
                title: 'Logistics (物流及調度)',
                icon: Icons.airport_shuttle_outlined,
                child: Column(
                  children: [
                    _buildFieldWrapper(
                      'Notification to OCC Time (通報OCC時間)',
                      _buildTimeFieldWithButton('Now'),
                    ),
                    const SizedBox(height: 20),
                    _buildFieldWrapper(
                      'Medical Team Departure (醫護出發時間)',
                      _buildTimeFieldWithButton('Now'),
                    ),
                    const SizedBox(height: 24),
                    _buildCheckboxTile(
                      label: 'OCC Arrived at Scene (OCC 到達現場)',
                      value: _occArrived,
                      onChanged: (v) => setState(() => _occArrived = v!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),

            Expanded(
              child: _buildContentCard(
                title: 'Geospatial Data (事故地點)',
                icon: Icons.location_on_outlined,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildFieldWrapper(
                            'Primary Area (主區域)',
                            _buildDropdownField('請選擇區域'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFieldWrapper(
                            'Secondary Location (子地點)',
                            _buildDropdownField('請選擇地點'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildFieldWrapper(
                      'Location Remarks (地點備註)',
                      _buildTextField(
                        hint: '例如: A14 登機門旁、具體店名...',
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildPerformanceSection(),
      ],
    );
  }

  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Response Performance (反應績效)',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: _buildFieldWrapper(
                  'Medical Arrival Time (醫護到達時間)',
                  _buildTimeFieldWithButton('Arrived'),
                ),
              ),
              const SizedBox(width: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: const [
                    Text(
                      'TIME SPENT (分鐘)',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '08:45',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              _buildCheckboxTile(
                label: 'Within 10 Mins (10分鐘內到達)',
                value: _within10Mins,
                onChanged: (v) => setState(() => _within10Mins = v!),
                isSuccessStyle: true,
              ),
              const Spacer(),

              Expanded(
                flex: 2,
                child: _buildFieldWrapper(
                  'Examination Time (檢查時間)',
                  _buildTimeFieldWithButton('Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWrapper(String label, Widget field, {double? width}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: textMuted,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );
  }

  Widget _buildTimeFieldWithButton(String btnText) {
    return Row(
      children: [
        Expanded(child: _buildTextField(hint: '--:--')),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              foregroundColor: primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              btnText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        filled: true,
        fillColor: bgField,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: textMuted, size: 18)
            : null,
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
    );
  }

  Widget _buildDropdownField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgField,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
    bool isSuccessStyle = false,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isSuccessStyle && value
            ? Colors.green.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuccessStyle && value
              ? Colors.green.withValues(alpha: 0.2)
              : borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: isSuccessStyle ? Colors.green : primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSuccessStyle && value ? Colors.green.shade700 : textDark,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
