import 'package:flutter/material.dart';

class EmergencyIncidentRecord extends StatelessWidget {
  final int emergencyId;

  const EmergencyIncidentRecord({super.key, required this.emergencyId});

  // 顏色與樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgReadOnly = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一排：事發日期與時間 與 事故地點
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 事發日期與時間
            Expanded(
              child: _buildFieldWrapper(
                '事發日期與時間 INCIDENT DATE & TIME',
                _buildReadOnlyField(value: '', suffixIcon: Icons.access_time),
              ),
            ),

            const SizedBox(width: 32),

            // 事故地點
            Expanded(
              child: _buildFieldWrapper(
                '事故地點 INCIDENT LOCATION',
                _buildReadOnlyField(
                  value: '',
                  suffixIcon: Icons.location_on_outlined,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：地點備註
        _buildFieldWrapper(
          '地點備註 LOCATION REMARKS',
          _buildReadOnlyField(
            value: '',
            suffixIcon: Icons.notes,
            isMultiLine: true,
          ),
        ),
      ],
    );
  }

  // --- UI 共用元件方法 (維持風格統一) ---

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String value,
    IconData? suffixIcon,
    bool isMultiLine = false,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 44,
        maxHeight: isMultiLine ? 100 : 44,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgReadOnly,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: isMultiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: textMuted.withValues(alpha: 0.5), size: 18),
        ],
      ),
    );
  }
}
