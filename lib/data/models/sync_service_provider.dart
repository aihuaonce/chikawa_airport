import 'package:flutter/widgets.dart';
import '../db/database.dart';
import '../services/firestore_sync_service.dart';

enum SyncState { idle, syncing, error, offline }

class SyncServiceProvider extends ChangeNotifier with WidgetsBindingObserver {
  late final FirestoreSyncService _syncService;
  late final AppDatabase _db;
  bool _initialized = false;
  DateTime? _pausedTime;
  SyncState _state = SyncState.idle;
  String? _lastError;
  int _pendingCount = 0;
  DateTime? _lastSyncTime;

  FirestoreSyncService get service => _syncService;
  bool get isInitialized => _initialized;

  SyncState get state => _state;
  bool get isOnline => true;
  int get pendingCount => _pendingCount;
  int get conflictCount => 0;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get lastError => _lastError;

  String get statusText {
    switch (_state) {
      case SyncState.idle:
        return '待同步';
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
    _db = db;
    _syncService = FirestoreSyncService(db);

    // 啟動定期自動同步（15 分鐘一次）
    _syncService.startPeriodicSync();

    // 初始化待同步數量
    await _updatePendingCount();

    _initialized = true;
    debugPrint('FirestoreSyncService initialized');
    notifyListeners();
  }

  /// 更新待同步數量
  Future<void> _updatePendingCount() async {
    if (!_initialized) return;

    int count = 0;
    try {
      // 計算所有 syncStatus = 1 的記錄
      final patients = await (_db.select(
        _db.patient,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += patients.length;

      final treatments = await (_db.select(
        _db.treatment,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += treatments.length;

      final fees = await (_db.select(
        _db.medicalFees,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += fees.length;

      final nursingRecords = await (_db.select(
        _db.nursingRecords,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += nursingRecords.length;

      final referralForms = await (_db.select(
        _db.referralForms,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += referralForms.length;

      final flightRecords = await (_db.select(
        _db.flightRecord,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += flightRecords.length;

      final certificates = await (_db.select(
        _db.medicalCertificates,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += certificates.length;

      final incidents = await (_db.select(
        _db.incidentRecord,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += incidents.length;

      final telexes = await (_db.select(
        _db.telexDocuments,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += telexes.length;

      final ambulanceRecords = await (_db.select(
        _db.ambulanceRecords,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += ambulanceRecords.length;

      final ambulancePersonalProperty = await (_db.select(
        _db.ambulancePersonalProperty,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += ambulancePersonalProperty.length;

      final ambulanceFees = await (_db.select(
        _db.ambulanceFees,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += ambulanceFees.length;

      final contacts = await (_db.select(
        _db.contact,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += contacts.length;

      final medicalMedia = await (_db.select(
        _db.medicalMedia,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += medicalMedia.length;

      final medicalAssessments = await (_db.select(
        _db.medicalAssessment,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += medicalAssessments.length;

      final healthAssessments = await (_db.select(
        _db.healthAssessmentForm,
      )..where((t) => t.syncStatus.equals(1))).get();
      count += healthAssessments.length;

      _pendingCount = count;
    } catch (e) {
      debugPrint('Error counting pending syncs: $e');
    }
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
      syncBidirectional();
    }
  }

  /// 雙向同步：上傳本地變更 + 下載遠端變更
  Future<void> syncBidirectional() async {
    debugPrint('SyncServiceProvider: syncBidirectional() called');
    _state = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      await _syncService.syncBidirectional();
      debugPrint('SyncServiceProvider: sync completed, setting state to idle');
      _lastSyncTime = DateTime.now();
      _state = SyncState.idle;
      // 同步完成後更新待同步數量
      await _updatePendingCount();
    } catch (e) {
      debugPrint('SyncServiceProvider: sync failed: $e');
      _state = SyncState.error;
      _lastError = e.toString();
      debugPrint('Sync error: $e');
    }
    notifyListeners();
    debugPrint('SyncServiceProvider: syncBidirectional() done');
  }

  /// 僅上傳本地變更到遠端
  Future<void> syncToRemote() async {
    debugPrint('SyncServiceProvider: syncToRemote() called');
    _state = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      await _syncService.syncToRemote();
      debugPrint('SyncServiceProvider: upload completed');
      _lastSyncTime = DateTime.now();
      _state = SyncState.idle;
      // 上傳完成後更新待同步數量
      await _updatePendingCount();
    } catch (e) {
      debugPrint('SyncServiceProvider: upload failed: $e');
      _state = SyncState.error;
      _lastError = e.toString();
    }
    notifyListeners();
  }

  /// 僅從遠端下載資料到本地
  Future<void> syncFromRemote() async {
    debugPrint('SyncServiceProvider: syncFromRemote() called');
    _state = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      await _syncService.syncFromRemote();
      debugPrint('SyncServiceProvider: download completed');
      _lastSyncTime = DateTime.now();
      _state = SyncState.idle;
    } catch (e) {
      debugPrint('SyncServiceProvider: download failed: $e');
      _state = SyncState.error;
      _lastError = e.toString();
    }
    notifyListeners();
  }

  @Deprecated('Use syncBidirectional() instead')
  Future<void> syncAll() async {
    await syncBidirectional();
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
    // 更新待同步數量
    await _updatePendingCount();
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
    _syncService.stopPeriodicSync();
    super.dispose();
  }
}
