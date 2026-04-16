import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/sync_service_provider.dart';
import '../../data/sync/models/sync_models.dart' hide SyncState;

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

  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgLight = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    final pageNumbers = List<int>.generate(totalPages, (index) => index + 1);

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
          _buildCloudSyncSection(),
        ],
      ),
    );
  }

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

  Widget _buildCloudSyncSection() {
    return Consumer<SyncServiceProvider>(
      builder: (context, provider, _) {
        if (!provider.isInitialized) {
          return const SizedBox.shrink();
        }

        final isSyncing = provider.state == SyncState.syncing;
        final hasPending = provider.pendingCount > 0 && !isSyncing;
        final statusText = hasPending
            ? '${provider.pendingCount} 筆待同步'
            : provider.statusText;
        final statusColor = _statusColor(provider.state);

        return Row(
          children: [
            if (isSyncing)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
            else
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 8),
            Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!isSyncing) ...[
              const SizedBox(width: 10),
              InkWell(
                onTap: provider.syncOnHomeReturn,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 14, color: textMuted),
                      SizedBox(width: 4),
                      Text(
                        '同步',
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Color _statusColor(SyncState state) {
    switch (state) {
      case SyncState.idle:
        return const Color(0xFF22C55E);
      case SyncState.syncing:
        return primaryColor;
      case SyncState.error:
        return Colors.red;
      case SyncState.offline:
        return textMuted;
    }
  }
}
