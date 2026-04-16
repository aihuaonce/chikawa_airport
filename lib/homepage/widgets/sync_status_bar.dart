import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/sync_service_provider.dart';
import '../../data/sync/models/sync_models.dart' hide SyncState;

class SyncStatusIndicator extends StatefulWidget {
  const SyncStatusIndicator({super.key});

  @override
  State<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends State<SyncStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _showSuccessNotification = false;
  Timer? _notificationTimer;
  SyncState? _lastState;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }

  void _checkStateChange(SyncState newState) {
    debugPrint('SyncStatus: _lastState=$_lastState, newState=$newState');
    if (_lastState == SyncState.syncing && newState == SyncState.idle) {
      // Sync completed
      debugPrint('SyncStatus: Sync completed! Showing notification');
      setState(() => _showSuccessNotification = true);
      _notificationTimer?.cancel();
      _notificationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showSuccessNotification = false);
        }
      });
    }
    _lastState = newState;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncServiceProvider>(
      builder: (context, provider, _) {
        // 監聽狀態變化
        _checkStateChange(provider.state);

        // 同步時播放動畫
        if (provider.state == SyncState.syncing) {
          if (!_rotationController.isAnimating) {
            _rotationController.repeat();
          }
        } else {
          _rotationController.stop();
          _rotationController.reset();
        }

        if (!provider.isInitialized) {
          return const SizedBox.shrink();
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 主體
            Container(
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
                      _buildStatusIcon(context, provider, provider.state),
                      if (showText) ...[
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatusText(provider)),
                        const SizedBox(width: 8),
                      ],
                      _buildSyncButton(context, provider),
                    ],
                  );
                },
              ),
            ),

            // 右上角成功通知
            if (_showSuccessNotification)
              Positioned(
                bottom: 56,
                right: 16,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '同步完成',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatusIcon(
    BuildContext context,
    SyncServiceProvider provider,
    SyncState state,
  ) {
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
      return RotationTransition(
        turns: _rotationController,
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        debugPrint('Sync button tapped');
        provider.syncAll();
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: color),
      ),
    );
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
        textColor = const Color(0xFF007A8A);
      case SyncState.error:
        text = '同步失敗';
        textColor = Colors.red;
      case SyncState.offline:
        text = '離線';
        textColor = Colors.grey;
    }

    if (provider.pendingCount > 0 && provider.state != SyncState.syncing) {
      text = '${provider.pendingCount} 筆待同步';
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
              child: Icon(Icons.add, size: 14, color: Color(0xFF94A3B8)),
            ),
          ),
        ],
        InkWell(
          onTap: () {
            provider.syncAll();
          },
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Icon(Icons.refresh, size: 14, color: Color(0xFF94A3B8)),
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
