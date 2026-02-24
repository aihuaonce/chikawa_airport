import 'package:flutter/foundation.dart';
import '../db/database.dart';
import '../services/network_service.dart';
import '../services/api_client.dart';
import '../services/sync_service.dart';
import '../sync/models/sync_models.dart';

class SyncServiceProvider extends ChangeNotifier {
  late final SyncService _syncService;
  bool _initialized = false;

  SyncService get service => _syncService;
  bool get isInitialized => _initialized;

  SyncState get state => _syncService.state;
  bool get isOnline => _syncService.isOnline;
  int get pendingCount => _syncService.pendingCount;
  DateTime? get lastSyncTime => _syncService.lastSyncTime;
  String? get lastError => _syncService.lastError;

  String get statusText {
    switch (_syncService.state) {
      case SyncState.idle:
        return '已同步';
      case SyncState.syncing:
        return '同步中...';
      case SyncState.error:
        return '同步失敗';
      case SyncState.offline:
        return '離線模式';
    }
  }

  Future<void> initialize(AppDatabase db) async {
    if (_initialized) return;

    final networkService = NetworkService();
    final apiClient = ApiClient();

    _syncService = SyncService(
      db: db,
      networkService: networkService,
      apiClient: apiClient,
    );

    _syncService.addListener(_onSyncStateChanged);
    await _syncService.initialize();
    _initialized = true;
    notifyListeners();
  }

  void _onSyncStateChanged() {
    notifyListeners();
  }

  Future<void> syncAll() async {
    await _syncService.syncAll();
  }

  Future<void> markAsPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    await _syncService.markAsPending(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      data: data,
    );
  }

  Future<void> retryFailed() async {
    await _syncService.retryFailed();
  }

  Future<void> clearSyncedLogs() async {
    await _syncService.clearSyncedLogs();
  }

  @override
  void dispose() {
    _syncService.removeListener(_onSyncStateChanged);
    _syncService.dispose();
    super.dispose();
  }
}
