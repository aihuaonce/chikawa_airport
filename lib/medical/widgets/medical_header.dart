import 'package:flutter/material.dart';

class MedicalHeader extends StatelessWidget {
  const MedicalHeader({super.key});

  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: textDark),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    const Flexible(
                      child: Text(
                        '主診單 Primary Consultation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              _buildHeaderActions(),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'SELECT SECTION',
            style: TextStyle(
              color: textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          _buildSectionSelector(),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    const Size buttonSize = Size(130, 40);

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_as_outlined, size: 16),
            label: const Text('暫存 Save'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              fixedSize: buttonSize,
              side: const BorderSide(color: primaryColor, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                fixedSize: buttonSize,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '下一部分 Next',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.account_circle_outlined, color: primaryColor, size: 22),
          SizedBox(width: 12),
          Text(
            '個人資料 (Personal Info)',
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Icon(Icons.keyboard_arrow_down, color: textMuted, size: 20),
        ],
      ),
    );
  }
}
