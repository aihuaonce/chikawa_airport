import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({super.key});

  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgLight = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: bgLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildNavButton('上一頁', isDisabled: true),
              const SizedBox(width: 8),
              _buildPageButton('1', active: true),
              _buildPageButton('2'),
              _buildPageButton('3'),
              const SizedBox(width: 8),
              _buildNavButton('下一頁'),
            ],
          ),

          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '雲端同步中',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 上/下一頁按鈕
  Widget _buildNavButton(String text, {bool isDisabled = false}) {
    return OutlinedButton(
      onPressed: isDisabled ? null : () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: textDark,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        side: BorderSide(
          color: isDisabled ? borderColor.withOpacity(0.5) : borderColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: isDisabled ? textMuted.withOpacity(0.5) : textDark,
        ),
      ),
    );
  }

  // 數字頁碼
  Widget _buildPageButton(String text, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 36,
        height: 36,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: active ? primaryColor : Colors.white,
            foregroundColor: active ? Colors.white : textDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: active ? Colors.transparent : borderColor,
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
