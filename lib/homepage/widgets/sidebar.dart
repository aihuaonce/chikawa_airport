import 'package:flutter/material.dart';
import '../../data/models/record_page.dart';

class Sidebar extends StatefulWidget {
  final RecordPage currentPage;
  final ValueChanged<RecordPage> onPageChanged;

  const Sidebar({
    super.key,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isExpanded = true;

  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isExpanded ? 280 : 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: borderColor, width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showText = constraints.maxWidth > 150;

          return Column(
            children: [
              _buildHeader(showText),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _SidebarItem(
                        icon: Icons.assignment,
                        label: '主診記錄',
                        isActive: widget.currentPage == RecordPage.primary,
                        showText: showText,
                        onTap: () => widget.onPageChanged(RecordPage.primary),
                      ),
                      _SidebarItem(
                        icon: Icons.local_hospital,
                        label: '救護車記錄',
                        isActive: widget.currentPage == RecordPage.ambulance,
                        showText: showText,
                        onTap: () => widget.onPageChanged(RecordPage.ambulance),
                      ),
                      _SidebarItem(
                        icon: Icons.emergency,
                        label: '急救記錄',
                        isActive: widget.currentPage == RecordPage.firstAid,
                        showText: showText,
                        onTap: () => widget.onPageChanged(RecordPage.firstAid),
                      ),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          );
        },
      ),
    );
  }

  // 頂部 Logo
  Widget _buildHeader(bool showText) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        mainAxisAlignment: showText
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const Icon(Icons.medical_services, color: primaryColor, size: 32),
          if (showText) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '聯新機場醫療中心',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: IconButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            icon: Icon(
              _isExpanded ? Icons.chevron_left : Icons.chevron_right,
              color: textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

// 側邊欄選單項目
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool showText;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.showText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF007A8A) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF007A8A).withValues(alpha: .2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: showText
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF64748B),
                size: 22,
              ),
              if (showText) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF64748B),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
