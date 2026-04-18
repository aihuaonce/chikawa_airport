import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/medical/medical_view.dart';

class MedicalHeader extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final int currentIndex;
  final Function(int) onSectionChanged;
  final VoidCallback? onSaveAndExit;

  const MedicalHeader({
    super.key,
    required this.sections,
    required this.currentIndex,
    required this.onSectionChanged,
    this.onSaveAndExit,
  });

  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicalViewModel>();
    final status = viewModel.saveStatus;

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

              const SizedBox(width: 8),
              _buildHeaderActions(status),
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

          _buildSectionSelector(context),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(SaveStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: _buildSaveStatusIndicator(status)),

        const SizedBox(width: 12),

        _buildNextButton(),
      ],
    );
  }

  Widget _buildSaveStatusIndicator(SaveStatus status) {
    Widget icon;
    String text;
    Color color;

    switch (status) {
      case SaveStatus.saving:
        icon = const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF007A8A),
          ),
        );
        text = '正在儲存...';
        color = textMuted;
        break;
      case SaveStatus.success:
        icon = const Icon(
          Icons.check_circle_rounded,
          size: 16,
          color: Color(0xFF007A8A),
        );
        text = '欄位已儲存';
        color = textMuted;
        break;
      case SaveStatus.idle:
        icon = const Icon(
          Icons.cloud_done_rounded,
          size: 16,
          color: Color(0xFF007A8A),
        );
        text = '已儲存';
        color = textMuted;
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Row(
        key: ValueKey(status),
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    const Size buttonSize = Size(125, 40);
    final isLastPage = currentIndex == sections.length - 1;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            // Last page: call save and exit callback
            onSaveAndExit?.call();
            return;
          }
          onSectionChanged(currentIndex + 1);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          fixedSize: buttonSize,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? '儲存' : '下一步',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            if (!isLastPage) ...[
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 14),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSectionMenu(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              sections[currentIndex]['icon'] as IconData,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                sections[currentIndex]['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  void _showSectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SELECT SECTION',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final isSelected = index == currentIndex;
                  return InkWell(
                    onTap: () {
                      onSectionChanged(index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.05)
                          : Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            sections[index]['icon'] as IconData,
                            color: isSelected ? primaryColor : textMuted,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              sections[index]['title'] as String,
                              style: TextStyle(
                                color: isSelected ? primaryColor : textDark,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
