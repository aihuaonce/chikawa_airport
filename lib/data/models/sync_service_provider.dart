import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database.dart';
import '../services/firestore_sync_service.dart';

enum SyncState { idle, syncing, error, offline }

class SyncServiceProvider extends ChangeNotifier with WidgetsBindingObserver {
  late final FirestoreSyncService _syncService;
  bool _initialized = false;
  DateTime? _pausedTime;
  SyncState _state = SyncState.idle;
  String? _lastError;
  int _pendingCount = 0;

  FirestoreSyncService get service => _syncService;
  bool get isInitialized => _initialized;

  SyncState get state => _state;
  bool get isOnline => true;
  int get pendingCount => _pendingCount;
  int get conflictCount => 0;
  DateTime? get lastSyncTime => null;
  String? get lastError => _lastError;

  String get statusText {
    switch (_state) {
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

    WidgetsBinding.instance.addObserver(this);

    _syncService = FirestoreSyncService(db);

    _initialized = true;
    debugPrint('FirestoreSyncService initialized');
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App resumed from background');
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        debugPrint('App paused to background');
        _pausedTime = DateTime.now();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onAppResumed() {
    if (_initialized) {
      syncAll();
    }
  }

  Future<void> syncAll() async {
    debugPrint('SyncServiceProvider: syncAll() called');
    _state = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      await _syncService.syncAll();
      debugPrint('SyncServiceProvider: sync completed, setting state to idle');
      _state = SyncState.idle;
    } catch (e) {
      debugPrint('SyncServiceProvider: sync failed: $e');
      _state = SyncState.error;
      _lastError = e.toString();
      debugPrint('Sync error: $e');
    }
    notifyListeners();
    debugPrint('SyncServiceProvider: syncAll() done');
  }

  Future<void> syncOnHomeReturn() async {
    await syncAll();
  }

  Future<void> markAsPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    _pendingCount++;
    notifyListeners();
  }

  Future<void> pushPendingChanges() async {
    await syncAll();
  }

  Future<void> retryFailed() async {
    await syncAll();
  }

  Future<void> clearSyncedLogs() async {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
