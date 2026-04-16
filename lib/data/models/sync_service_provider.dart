import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database.dart';
import '../services/firestore_sync_service.dart';

class SyncServiceProvider extends ChangeNotifier with WidgetsBindingObserver {
  late final FirestoreSyncService _syncService;
  bool _initialized = false;
  DateTime? _pausedTime;

  FirestoreSyncService get service => _syncService;
  bool get isInitialized => _initialized;

  bool get isSyncing => _syncService.isSyncing;

  String get statusText {
    return isSyncing ? '同步中...' : '已同步';
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
    try {
      await _syncService.syncAll();
      notifyListeners();
    } catch (e) {
      debugPrint('Sync error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
