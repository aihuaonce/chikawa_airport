import 'package:flutter/material.dart';

class EmergencyFlightLog extends StatelessWidget {
  final int emergencyId;

  const EmergencyFlightLog({super.key, required this.emergencyId});

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
        // 第一排：來源 與 為何至機場
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 來源
            Expanded(
              child: _buildFieldWrapper(
                '來源 SOURCE',
                _buildReadOnlyField(value: '', suffixIcon: Icons.expand_more),
              ),
            ),

            const SizedBox(width: 32),

            // 為何至機場
            Expanded(
              child: _buildFieldWrapper(
                '為何至機場 REASON FOR VISIT',
                _buildReadOnlyField(value: '', suffixIcon: Icons.expand_more),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：航空公司 與 國籍
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 航空公司
            Expanded(
              child: _buildFieldWrapper(
                '航空公司 AIRLINE',
                _buildReadOnlyField(
                  value: '',
                  suffixIcon: Icons.corporate_fare,
                ),
              ),
            ),

            const SizedBox(width: 32),

            // 國籍
            Expanded(
              child: _buildFieldWrapper(
                '國籍 NATIONALITY',
                _buildReadOnlyField(value: '', suffixIcon: Icons.public),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- UI 共用元件方法 ---

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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

  Widget _buildReadOnlyField({required String value, IconData? suffixIcon}) {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgReadOnly,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
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
