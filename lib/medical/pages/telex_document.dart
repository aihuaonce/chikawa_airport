import 'package:flutter/material.dart';

class TelexDocument extends StatefulWidget {
  final int medicalId;

  const TelexDocument({super.key, required this.medicalId});

  @override
  State<TelexDocument> createState() => _TelexDocumentState();
}

class _TelexDocumentState extends State<TelexDocument> {
  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  String _toStation = 'T1 03-3063578';
  String _fromStation = 'T1 03-3834225';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildStationCard(
                title: 'TO: 桃園國際機場股份有限公司營運控制中心',
                options: ['T1 03-3063578', 'T2 03-3063367'],
                selectedValue: _toStation,
                onChanged: (val) => setState(() => _toStation = val!),
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              child: _buildStationCard(
                title: 'FROM: 聯新國際醫院桃園國際機場醫療中心',
                options: ['T1 03-3834225', 'T2 03-3983485'],
                selectedValue: _fromStation,
                onChanged: (val) => setState(() => _fromStation = val!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStationCard({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgField.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: options.map((opt) {
              final bool isSelected = selectedValue == opt;
              return InkWell(
                onTap: () => onChanged(opt),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Radio<String>(
                          value: opt,
                          groupValue: selectedValue,
                          onChanged: onChanged,
                          activeColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        opt,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected ? primaryColor : textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
