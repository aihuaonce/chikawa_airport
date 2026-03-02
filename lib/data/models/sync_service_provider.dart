import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database.dart';
import '../services/network_service.dart';
import '../services/api_client.dart';
import '../services/sync_service.dart';
import '../sync/models/sync_models.dart';

// API URL 配置
const String kDefaultApiUrl =
    'https://da90-2001-b400-e2c2-9519-a047-5561-8fc2-3bba.ngrok-free.app';

// Background sync interval in minutes
const int kBackgroundSyncIntervalMinutes = 5;

class SyncServiceProvider extends ChangeNotifier with WidgetsBindingObserver {
  late final SyncService _syncService;
  bool _initialized = false;
  DateTime? _pausedTime;

  SyncService get service => _syncService;
  bool get isInitialized => _initialized;

  SyncState get state => _syncService.state;
  bool get isOnline => _syncService.isOnline;
  int get pendingCount => _syncService.pendingCount;
  int get conflictCount => _syncService.conflictCount;
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

    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    final prefs = await SharedPreferences.getInstance();
    final apiUrl = prefs.getString('sync_api_url') ?? kDefaultApiUrl;
    debugPrint('🔗 Sync API URL: $apiUrl');

    final networkService = NetworkService();
    final apiClient = ApiClient(baseUrl: apiUrl);

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App comes to foreground
        debugPrint('🔄 App resumed from background');
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        // App goes to background
        debugPrint('🔄 App paused to background');
        _pausedTime = DateTime.now();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onAppResumed() {
    // Sync when app comes to foreground
    if (_initialized && _syncService.isOnline) {
      _syncService.syncAll();
    }
  }

  Future<void> setApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sync_api_url', url);
    // Note: 需要重新建立 ApiClient 和 SyncService 才能生效
  }

  Future<String> getApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sync_api_url') ?? kDefaultApiUrl;
  }

  void _onSyncStateChanged() {
    notifyListeners();
  }

  Future<void> syncAll() async {
    await _syncService.syncAll();
  }

  /// Sync triggered when user returns to home screen
  Future<void> syncOnHomeReturn() async {
    await _syncService.syncOnHomeReturn();
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
    WidgetsBinding.instance.removeObserver(this);
    _syncService.removeListener(_onSyncStateChanged);
    _syncService.dispose();
    super.dispose();
  }
}
