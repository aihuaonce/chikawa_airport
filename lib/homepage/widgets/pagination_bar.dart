import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgLight = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    List<int> pageNumbers = List.generate(totalPages, (index) => index + 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: bgLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildNavButton(
                '上一頁',
                isDisabled: currentPage <= 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 8),

              // 動態產生數字按鈕
              ...pageNumbers.map(
                (page) => _buildPageButton(
                  page.toString(),
                  active: page == currentPage,
                  onTap: () => onPageChanged(page),
                ),
              ),

              const SizedBox(width: 8),
              _buildNavButton(
                '下一頁',
                isDisabled: currentPage >= totalPages,
                onTap: () => onPageChanged(currentPage + 1),
              ),
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
  Widget _buildNavButton(
    String text, {
    required bool isDisabled,
    VoidCallback? onTap,
  }) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: textDark,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        side: BorderSide(
          color: isDisabled ? borderColor.withValues(alpha: 0.5) : borderColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: isDisabled ? textMuted.withValues(alpha: 0.5) : textDark,
        ),
      ),
    );
  }

  // 數字頁碼
  Widget _buildPageButton(
    String text, {
    required bool active,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 36,
        height: 36,
        child: TextButton(
          onPressed: onTap,
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
