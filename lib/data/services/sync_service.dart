import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../db/database.dart';
import '../db/dao/sync_dao.dart';
import '../db/tables/sync_tables.dart';
import 'network_service.dart';
import 'api_client.dart';
import '../sync/models/sync_models.dart';

class SyncService extends ChangeNotifier {
  final AppDatabase _db;
  final NetworkService _networkService;
  final ApiClient _apiClient;
  late final SyncDao _syncDao;

  SyncState _state = SyncState.idle;
  DateTime? _lastSyncTime;
  int _pendingCount = 0;
  String? _lastError;

  SyncService({
    required AppDatabase db,
    required NetworkService networkService,
    required ApiClient apiClient,
  })  : _db = db,
        _networkService = networkService,
        _apiClient = apiClient {
    _syncDao = SyncDao(_db);
  }

  SyncState get state => _state;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingCount => _pendingCount;
  String? get lastError => _lastError;
  bool get hasPendingChanges => _pendingCount > 0;
  bool get isOnline => _networkService.isOnline;

  Future<void> initialize() async {
    await _networkService.initialize();
    _lastSyncTime = await _syncDao.getLastSyncTime();
    _pendingCount = await _syncDao.getPendingCount();
    
    _networkService.onConnectivityChanged.listen((isOnline) {
      if (isOnline && hasPendingChanges) {
        syncAll();
      }
    });

    await _ensureDeviceId();
    notifyListeners();
  }

  Future<void> _ensureDeviceId() async {
    var deviceId = await _syncDao.getDeviceId();
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _syncDao.setDeviceId(deviceId);
    }
  }

  Future<SyncResult> syncAll() async {
    if (_state == SyncState.syncing) {
      return SyncResult(success: false, errorMessage: 'Sync already in progress');
    }

    if (!_networkService.isOnline) {
      _state = SyncState.offline;
      _lastError = 'No network connection';
      notifyListeners();
      return SyncResult(success: false, errorMessage: 'No network');
    }

    _state = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      await pullChanges();
      await pushChanges();
      
      _lastSyncTime = DateTime.now().toUtc();
      await _syncDao.setLastSyncTime(_lastSyncTime!);
      _pendingCount = await _syncDao.getPendingCount();
      
      _state = SyncState.idle;
      notifyListeners();
      
      return SyncResult(
        success: true,
        pushedCount: 0,
        pulledCount: 0,
      );
    } catch (e) {
      _state = SyncState.error;
      _lastError = e.toString();
      notifyListeners();
      return SyncResult(success: false, errorMessage: e.toString());
    }
  }

  Future<void> pullChanges() async {
    try {
      final lastSync = await _syncDao.getLastSyncTime();
      final request = PullRequest(since: lastSync);
      final response = await _apiClient.pullChanges(request);

      for (final change in response.changes) {
        await _applyRemoteChange(change);
      }

      for (final deleted in response.deletedRecords) {
        await _applyRemoteDelete(deleted);
      }

      await _syncDao.setLastSyncTime(response.serverTimestamp);
    } catch (e) {
      debugPrint('Pull changes error: $e');
      rethrow;
    }
  }

  Future<void> _applyRemoteChange(RemoteChange change) async {
    debugPrint('Applying remote change: ${change.table} - ${change.operation}');
  }

  Future<void> _applyRemoteDelete(DeletedRecord deleted) async {
    debugPrint('Applying remote delete: ${deleted.table} - ${deleted.remoteId}');
  }

  Future<void> pushChanges() async {
    try {
      final pendingLogs = await _syncDao.getPendingLogs();
      
      if (pendingLogs.isEmpty) {
        return;
      }

      final deviceId = await _syncDao.getDeviceId() ?? 'unknown';
      
      final changes = pendingLogs.map((log) => PushChange(
        table: log.entityName,
        localId: log.recordId,
        operation: log.operation,
        data: jsonDecode(log.payload) as Map<String, dynamic>,
      )).toList();

      final request = PushRequest(
        clientTimestamp: DateTime.now().toUtc(),
        deviceId: deviceId,
        changes: changes,
      );

      final response = await _apiClient.pushChanges(request);

      for (final result in response.results) {
        final log = pendingLogs.firstWhere((l) => l.recordId == result.localId);
        await _syncDao.updateSyncLogStatus(
          log.id,
          status: SyncStatus.synced,
          syncedAt: DateTime.now().toUtc(),
        );
      }

      for (final conflict in response.conflicts) {
        final log = pendingLogs.firstWhere((l) => l.recordId == conflict.localId);
        await _resolveConflict(conflict.toConflict());
      }

      _pendingCount = await _syncDao.getPendingCount();
    } catch (e) {
      debugPrint('Push changes error: $e');
      
      final failedLogs = await _syncDao.getPendingLogs();
      for (final log in failedLogs) {
        await _syncDao.incrementRetryCount(log.id);
        if (log.retryCount >= 3) {
          await _syncDao.updateSyncLogStatus(
            log.id,
            status: SyncStatus.failed,
            errorMessage: 'Max retries exceeded',
          );
        }
      }
      
      rethrow;
    }
  }

  Future<void> _resolveConflict(Conflict conflict) async {
    debugPrint('Resolving conflict with server_wins strategy');
    
    await _syncDao.updateSyncLogStatus(
      0,
      status: SyncStatus.synced,
      syncedAt: DateTime.now().toUtc(),
    );
  }

  Future<void> markAsPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    await _syncDao.insertSyncLog(
      SyncLogTableCompanion(
        entityName: Value(tableName),
        recordId: Value(recordId),
        operation: Value(operation),
        payload: Value(jsonEncode(data)),
        status: const Value(SyncStatus.pending),
        createdAt: Value(DateTime.now().toUtc()),
        retryCount: const Value(0),
      ),
    );

    _pendingCount = await _syncDao.getPendingCount();
    notifyListeners();

    if (_networkService.isOnline) {
      await pushChanges();
    }
  }

  Future<void> retryFailed() async {
    final failedLogs = await _syncDao.getFailedLogs();
    
    for (final log in failedLogs) {
      await _syncDao.updateSyncLogStatus(
        log.id,
        status: SyncStatus.pending,
      );
    }

    if (_networkService.isOnline) {
      await syncAll();
    }
  }

  Future<void> clearSyncedLogs() async {
    await _syncDao.deleteSyncedLogs();
    _pendingCount = await _syncDao.getPendingCount();
    notifyListeners();
  }
}
