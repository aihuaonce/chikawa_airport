import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/sync_service_provider.dart';
import '../../data/sync/models/sync_models.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncServiceProvider>(
      builder: (context, provider, _) {
        if (!provider.isInitialized) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showText = constraints.maxWidth > 150;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIcon(provider.state),
                  if (showText) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusText(provider),
                    ),
                    const SizedBox(width: 8),
                  ],
                  _buildSyncButton(context, provider),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(SyncState state) {
    final IconData icon;
    final Color color;

    switch (state) {
      case SyncState.idle:
        icon = Icons.cloud_done;
        color = const Color(0xFF007A8A);
      case SyncState.syncing:
        icon = Icons.sync;
        color = const Color(0xFF007A8A);
      case SyncState.error:
        icon = Icons.sync_problem;
        color = Colors.red;
      case SyncState.offline:
        icon = Icons.cloud_off;
        color = Colors.grey;
    }

    if (state == SyncState.syncing) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Icon(icon, size: 18, color: color);
  }

  Widget _buildStatusText(SyncServiceProvider provider) {
    String text;
    Color textColor;

    switch (provider.state) {
      case SyncState.idle:
        text = '已同步';
        textColor = const Color(0xFF64748B);
      case SyncState.syncing:
        text = '同步中...';
        textColor = const Color(0xFF64748B);
      case SyncState.error:
        text = '同步失败';
        textColor = Colors.red;
      case SyncState.offline:
        text = '离线';
        textColor = Colors.grey;
    }

    if (provider.pendingCount > 0 && provider.state != SyncState.syncing) {
      text = '${provider.pendingCount} 笔待同步';
      textColor = Colors.orange;
    }

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context, SyncServiceProvider provider) {
    if (provider.state == SyncState.syncing) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (provider.pendingCount > 0) ...[
          InkWell(
            onTap: () => _addTestData(context, provider),
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Icon(
                Icons.add,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
        InkWell(
          onTap: () => provider.syncAll(),
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Icon(
              Icons.refresh,
              size: 14,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addTestData(
    BuildContext context,
    SyncServiceProvider provider,
  ) async {
    await provider.markAsPending(
      tableName: 'patients',
      recordId: DateTime.now().millisecondsSinceEpoch % 10000,
      operation: 'insert',
      data: {'name': '测试病患', 'birthday': '1990-01-01', 'sexId': 1},
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已添加测试数据'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
