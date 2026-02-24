import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/sync_service_provider.dart';
import '../../data/sync/models/sync_models.dart';

class SyncStatusBar extends StatelessWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncServiceProvider>(
      builder: (context, provider, _) {
        if (!provider.isInitialized) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: _getBackgroundColor(provider.state),
          child: Row(
            children: [
              Icon(
                _getStatusIcon(provider.state),
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                provider.statusText,
                style: const TextStyle(color: Colors.white),
              ),
              if (provider.pendingCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${provider.pendingCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
              const Spacer(),
              if (provider.lastSyncTime != null)
                Text(
                  _formatTime(provider.lastSyncTime!),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              const SizedBox(width: 16),
              if (provider.state == SyncState.error && provider.lastError != null)
                Tooltip(
                  message: provider.lastError!,
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.white, size: 18),
                onPressed: provider.state == SyncState.syncing
                    ? null
                    : () => provider.syncAll(),
                tooltip: '手動同步',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(SyncState state) {
    switch (state) {
      case SyncState.idle:
        return Colors.green;
      case SyncState.syncing:
        return Colors.blue;
      case SyncState.error:
        return Colors.red;
      case SyncState.offline:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(SyncState state) {
    switch (state) {
      case SyncState.idle:
        return Icons.cloud_done;
      case SyncState.syncing:
        return Icons.sync;
      case SyncState.error:
        return Icons.sync_problem;
      case SyncState.offline:
        return Icons.cloud_off;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else {
      return '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
