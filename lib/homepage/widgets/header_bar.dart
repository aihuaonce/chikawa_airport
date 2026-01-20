import 'package:flutter/material.dart';
import '../../data/models/record_page.dart';
import '../../medical/medical.dart';

class HeaderBar extends StatefulWidget {
  final RecordPage currentPage;

  const HeaderBar({super.key, required this.currentPage});

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  String _selectedLang = 'EN';

  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color borderColor = Color(0xFFE2E8F0);

  // 根據頁面返回標題
  String _getPageTitle() {
    switch (widget.currentPage) {
      case RecordPage.primary:
        return '主診記錄';
      case RecordPage.ambulance:
        return '救護車記錄';
      case RecordPage.firstAid:
        return '急救記錄';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            _getPageTitle(),
            style: const TextStyle(
              color: textDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          const Spacer(),

          // 搜尋欄
          SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: textMuted, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: textMuted,
                ),
                filled: true,
                fillColor: bgLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 24),

          // 中英切換
          _buildSlidingLangSelector(),

          const SizedBox(width: 16),

          // 報表按鈕
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bar_chart, size: 20, color: primaryColor),
            label: const Text('報表'),
            style: OutlinedButton.styleFrom(
              foregroundColor: textDark,
              fixedSize: const Size(140, 48),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              side: const BorderSide(color: borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 新增病患按鈕
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MedicalPage()),
                );
              },
              icon: const Icon(Icons.person_add, size: 20, color: Colors.white),
              label: const Text('新增病患'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                fixedSize: const Size(140, 48),
                elevation: 0,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 中英切換動畫
  Widget _buildSlidingLangSelector() {
    return Container(
      width: 100,
      height: 36,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _selectedLang == 'EN'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 44,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: _buildLangText('EN')),
              Expanded(child: _buildLangText('CH')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLangText(String lang) {
    final bool isActive = _selectedLang == lang;
    return GestureDetector(
      onTap: () => setState(() => _selectedLang = lang),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Text(
          lang,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? textDark : textMuted,
          ),
        ),
      ),
    );
  }
}
