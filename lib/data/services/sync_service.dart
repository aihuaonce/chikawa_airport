import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../db/database.dart';
import '../db/dao/sync_dao.dart';
import '../db/dao/medical_dao.dart';
import '../db/dao/treatment_dao.dart';
import '../db/dao/certificate_dao.dart';
import '../db/dao/medical_fee_dao.dart';
import '../db/dao/nursing_record_dao.dart';
import '../db/dao/referral_form_dao.dart';
import '../db/dao/telex_dao.dart';
import '../db/dao/flight_dao.dart';
import '../db/dao/incident_dao.dart';
import '../db/dao/ambulance_dao.dart';
import '../db/tables/sync_tables.dart';
import 'network_service.dart';
import 'api_client.dart';
import '../sync/models/sync_models.dart';

/// Compare-first sync service implementation
///
/// This service replaces the old push/pull mechanism with a compare-first approach:
/// 1. Build local snapshot { table, id, lastModified }
/// 2. POST /api/sync/compare - get toDownload/toUpload/conflicts
/// 3. Upload missing records -> POST /api/sync/push
/// 4. Download missing records from compare response
/// 5. Handle conflicts (manual for triage_id, server wins for others)
class SyncService extends ChangeNotifier {
  final AppDatabase _db;
  final NetworkService _networkService;
  final ApiClient _apiClient;
  late final SyncDao _syncDao;
  late final MedicalDao _medicalDao;
  late final TreatmentDao _treatmentDao;
  late final CertificateDao _certificateDao;
  late final MedicalFeeDao _medicalFeeDao;
  late final NursingRecordDao _nursingRecordDao;
  late final ReferralFormDao _referralFormDao;
  late final TelexDao _telexDao;
  late final FlightDao _flightDao;
  late final IncidentDao _incidentDao;
  late final AmbulanceDao _ambulanceDao;

  SyncState _state = SyncState.idle;
  DateTime? _lastSyncTime;
  int _pendingCount = 0;
  String? _lastError;
  String? _deviceId;
  Timer? _periodicSyncTimer;
  int _conflictCount = 0;
  bool _isPushingPending = false;

  // Background sync interval (default: 5 minutes)
  static const Duration _syncInterval = Duration(minutes: 5);

  // Tables to include in snapshot (in FK order for proper resolution)
  static const List<String> snapshotTables = [
    'medical_records',
    'patients',
    'treatments',
    'medical_certificates',
    'medical_fees',
    'nursing_records',
    'referral_forms',
    'telex_documents',
    'flight_records',
    'incident_records',
    'ambulance_records',
    'ambulance_personal_property',
    'ambulance_fees',
    'ambulance_treatment_records',
    'ambulance_scene_records',
  ];

  SyncService({
    required AppDatabase db,
    required NetworkService networkService,
    required ApiClient apiClient,
  }) : _db = db,
       _networkService = networkService,
       _apiClient = apiClient {
    _syncDao = SyncDao(_db);
    _medicalDao = MedicalDao(_db);
    _treatmentDao = TreatmentDao(_db);
    _certificateDao = CertificateDao(_db);
    _medicalFeeDao = MedicalFeeDao(_db);
    _nursingRecordDao = NursingRecordDao(_db);
    _referralFormDao = ReferralFormDao(_db);
    _telexDao = TelexDao(_db);
    _flightDao = FlightDao(_db);
    _incidentDao = IncidentDao(_db);
    _ambulanceDao = AmbulanceDao(_db);
  }

  SyncState get state => _state;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingCount => _pendingCount;
  int get conflictCount => _conflictCount;
  String? get lastError => _lastError;
  bool get hasPendingChanges => _pendingCount > 0;
  bool get hasConflicts => _conflictCount > 0;
  bool get isOnline => _networkService.isOnline;
  String? get deviceId => _deviceId;

  Future<void> initialize() async {
    await _networkService.initialize();
    await _syncDao.deduplicatePendingLogs();
    _lastSyncTime = await _syncDao.getLastSyncTime();
    _pendingCount = await _syncDao.getPendingCount();

    _networkService.onConnectivityChanged.listen((isOnline) {
      if (isOnline && hasPendingChanges) {
        syncAll();
      }
    });

    // Start periodic background sync
    _startPeriodicSync();

    await _ensureDeviceId();
    notifyListeners();
  }

  Future<void> _ensureDeviceId() async {
    var deviceId = await _syncDao.getDeviceId();
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _syncDao.setDeviceId(deviceId);
    }
    _deviceId = deviceId;
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(_syncInterval, (_) {
      if (_networkService.isOnline) {
        debugPrint('⏰ Periodic background sync triggered');
        syncAll();
      }
    });
    debugPrint(
      '✅ Periodic background sync started (interval: ${_syncInterval.inMinutes} minutes)',
    );
  }

  void _stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  void setPeriodicSyncEnabled(bool enabled) {
    if (enabled) {
      _startPeriodicSync();
    } else {
      _stopPeriodicSync();
    }
  }

  /// Sync triggered when user returns to home screen
  /// This is the main entry point for compare-first sync
  Future<SyncResult> syncOnHomeReturn() async {
    return syncAll();
  }

  /// Main sync method - compare-first approach
  Future<SyncResult> syncAll() async {
    if (_state == SyncState.syncing) {
      return SyncResult(
        success: false,
        errorMessage: 'Sync already in progress',
      );
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
      // Step 1: Build local snapshot
      debugPrint('🔍 Building local snapshot...');
      final snapshot = await buildLocalSnapshot();
      debugPrint('📸 Snapshot: ${snapshot.length} records');

      // Step 2: Compare with server
      debugPrint('🔍 Comparing with server...');
      final compareResponse = await _apiClient.compareSnapshot(
        CompareRequest(deviceId: _deviceId!, snapshot: snapshot),
      );

      // Step 3: Handle uploads (Flutter has newer data)
      if (compareResponse.toUpload.isNotEmpty) {
        debugPrint(
          '📤 Uploading ${compareResponse.toUpload.length} records...',
        );
        await _handleUploads(compareResponse.toUpload);
      }

      // Step 4: Handle downloads (Server has newer data)
      if (compareResponse.toDownload.isNotEmpty) {
        debugPrint(
          '📥 Downloading ${compareResponse.toDownload.length} records...',
        );
        await _handleDownloads(compareResponse.toDownload);
      }

      // Step 5: Handle conflicts
      if (compareResponse.conflicts.isNotEmpty) {
        debugPrint(
          '⚠️  Handling ${compareResponse.conflicts.length} conflicts...',
        );
        await _handleConflicts(compareResponse.conflicts);
        _conflictCount = compareResponse.conflicts.length;
      }

      // Step 6: Update last sync time
      _lastSyncTime = compareResponse.serverTimestamp.toLocal();
      await _syncDao.setLastSyncTime(_lastSyncTime!);
      _pendingCount = await _syncDao.getPendingCount();

      _state = SyncState.idle;
      notifyListeners();

      return SyncResult(
        success: true,
        pushedCount: compareResponse.toUpload.length,
        pulledCount: compareResponse.toDownload.length,
        conflictCount: compareResponse.conflicts.length,
      );
    } catch (e) {
      _state = SyncState.error;
      _lastError = e.toString();
      notifyListeners();
      return SyncResult(success: false, errorMessage: e.toString());
    }
  }

  /// Build local snapshot from all tables
  /// Returns list of { table, id, lastModified }
  Future<List<LocalSnapshot>> buildLocalSnapshot() async {
    final snapshot = <LocalSnapshot>[];

    for (final tableName in snapshotTables) {
      try {
        final tableSnapshot = await _buildTableSnapshot(tableName);
        snapshot.addAll(tableSnapshot);
      } catch (e) {
        debugPrint('⚠️ Error building snapshot for $tableName: $e');
      }
    }

    return snapshot;
  }

  Future<List<LocalSnapshot>> _buildTableSnapshot(String tableName) async {
    final snapshot = <LocalSnapshot>[];

    switch (tableName) {
      case 'medical_records':
        final records = await _db.select(_db.medicalRecord).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'medical_records',
              id: record.medicalId,
              lastModified: record.updatedAt.millisecondsSinceEpoch,
            ),
          );
        }
        break;
      case 'patients':
        final records = await _db.select(_db.patient).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'patients',
              id: record.patientId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'treatments':
        final records = await _db.select(_db.treatment).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'treatments',
              id: record.treatmentId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'medical_certificates':
        final records = await _db.select(_db.medicalCertificates).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'medical_certificates',
              id: record.certificateId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'medical_fees':
        final records = await _db.select(_db.medicalFees).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'medical_fees',
              id: record.feeId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'nursing_records':
        final records = await _db.select(_db.nursingRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'nursing_records',
              id: record.recordId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'referral_forms':
        final records = await _db.select(_db.referralForms).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'referral_forms',
              id: record.formId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'telex_documents':
        final records = await _db.select(_db.telexDocuments).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'telex_documents',
              id: record.documentId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'flight_records':
        final records = await _db.select(_db.flightRecord).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'flight_records',
              id: record.flightRecordId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'incident_records':
        final records = await _db.select(_db.incidentRecord).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'incident_records',
              id: record.incidentId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_records':
        final records = await _db.select(_db.ambulanceRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_records',
              id: record.ambulanceId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_personal_property':
        final records = await _db.select(_db.ambulancePersonalProperty).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_personal_property',
              id: record.id,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_fees':
        final records = await _db.select(_db.ambulanceFees).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_fees',
              id: record.feeId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_treatment_records':
        final records = await _db.select(_db.ambulanceTreatmentRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_treatment_records',
              id: record.id,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_scene_records':
        final records = await _db.select(_db.ambulanceSceneRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_scene_records',
              id: record.id,
              lastModified: record.updatedAt.millisecondsSinceEpoch,
            ),
          );
        }
        break;
    }

    return snapshot;
  }

  /// Handle uploads - push records that Flutter has but server doesn't
  Future<void> _handleUploads(List<UploadItem> toUpload) async {
    // Resolve full record data for each upload item
    final pushChanges = <PushChange>[];

    for (final item in toUpload) {
      final fullData = await _resolveFullRecordData(item.table, item.id);
      if (fullData != null) {
        pushChanges.add(
          PushChange(
            table: item.table,
            localId: item.id,
            operation: 'upsert',
            data: fullData,
          ),
        );
      }
    }

    if (pushChanges.isEmpty) return;

    // Push to server
    final request = PushRequest(
      clientTimestamp: DateTime.now().toUtc(),
      deviceId: _deviceId!,
      changes: pushChanges,
    );

    try {
      final response = await _apiClient.pushChanges(request);

      // Mark successfully synced records
      for (final result in response.results) {
        if (result.status == 'success') {
          // Update local sync status
          await _markAsSynced(result.localId, result.remoteId ?? '');
        }
      }

      // Handle conflicts
      for (final conflict in response.conflicts) {
        await _resolvePushConflict(conflict);
      }
    } catch (e) {
      debugPrint('Push error: $e');
      rethrow;
    }
  }

  /// Resolve full record data from local DB for upload
  Future<Map<String, dynamic>?> _resolveFullRecordData(
    String table,
    int id,
  ) async {
    switch (table) {
      case 'medical_records':
        final record = await (_db.select(
          _db.medicalRecord,
        )..where((t) => t.medicalId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'medicalId': record.medicalId,
          'isEmergency': record.isEmergency,
          'hasAmbulance': record.hasAmbulance,
          'cdcPassed': record.cdcPassed,
          'screeningMethod': record.screeningMethod,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'patients':
        final record = await (_db.select(
          _db.patient,
        )..where((t) => t.patientId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'patientId': record.patientId,
          'medicalId': record.medicalId,
          'name': record.name,
          'anonymizationName': record.anonymizationName,
          'birthday': record.birthday?.millisecondsSinceEpoch,
          'sexId': record.sexId,
          'passportOrIdNo': record.passportOrIdNo,
          'idNo': record.idNo,
          'visitReasonId': record.visitReasonId,
          'nationalityId': record.nationalityId,
          'telephone': record.telephone,
          'address': record.address,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'treatments':
        final record = await (_db.select(
          _db.treatment,
        )..where((t) => t.treatmentId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'treatmentId': record.treatmentId,
          'medicalId': record.medicalId,
          'tentativeCategoryId': record.tentativeCategoryId,
          'tentative': record.tentative,
          'secondaryDiagnosis1': record.secondaryDiagnosis1,
          'secondaryDiagnosis2': record.secondaryDiagnosis2,
          'triageId': record.triageId,
          'treatmentOnSiteId': record.treatmentOnSiteId,
          'actionSummary': record.actionSummary,
          'actionSummaryOther': record.actionSummaryOther,
          'ekgInterpretation': record.ekgInterpretation,
          'glucose': record.glucose,
          'intubationMethod': record.intubationMethod,
          'oxygenMethod': record.oxygenMethod,
          'oxygenFlow': record.oxygenFlow,
          'certificateLogs': record.certificateLogs,
          'resultId': record.resultId,
          'transportRequired': record.transportRequired,
          'transportMethod': record.transportMethod,
          'referralHospitalId': record.referralHospitalId,
          'referralHospitalFinal': record.referralHospitalFinal,
          'ambulanceStaffId': record.ambulanceStaffId,
          'arrivalTime': record.arrivalTime?.millisecondsSinceEpoch,
          'clearanceId': record.clearanceId,
          'expeditedClearanceId': record.expeditedClearanceId,
          'doctorOrderCh': record.doctorOrderCh,
          'doctorOrderEn': record.doctorOrderEn,
          'directorName': record.directorName,
          'assistStaff': record.assistStaff,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      // Add other tables as needed...

      default:
        debugPrint('⚠️ Unknown table for upload: $table');
        return null;
    }
  }

  /// Handle downloads - apply records from server
  Future<void> _handleDownloads(List<RemoteRecord> toDownload) async {
    for (final record in toDownload) {
      try {
        await _applyRemoteChange(record.table, record.remoteId, record.data);
      } catch (e) {
        debugPrint('Error applying download ${record.table}: $e');
      }
    }
  }

  /// Apply a remote change to local DB
  Future<void> _applyRemoteChange(
    String table,
    String remoteId,
    Map<String, dynamic> data,
  ) async {
    final modifiedAt = DateTime.now().toUtc();

    switch (table) {
      case 'medical_records':
        final medicalId = data['medicalId'] as int?;
        if (medicalId == null) return;
        await (_db.update(
          _db.medicalRecord,
        )..where((t) => t.medicalId.equals(medicalId))).write(
          MedicalRecordCompanion(
            isEmergency: Value(data['isEmergency'] as bool? ?? false),
            hasAmbulance: Value(data['hasAmbulance'] as bool? ?? false),
            cdcPassed: Value(data['cdcPassed'] as bool?),
            screeningMethod: Value(data['screeningMethod'] as String?),
            syncStatus: const Value(0),
            remoteId: Value(remoteId),
            lastModified: Value(modifiedAt),
          ),
        );
        break;

      // Add other tables as needed...

      default:
        debugPrint('⚠️ Unknown table for download: $table');
    }
  }

  /// Handle conflicts from compare response
  Future<void> _handleConflicts(List<CompareConflict> conflicts) async {
    for (final conflict in conflicts) {
      // For triage_id conflicts: show manual resolution UI
      // For all others: accept server version (server wins)
      if (conflict.table == 'treatments') {
        // TODO: Mark for manual resolution
        debugPrint('⚠️ Triage conflict for treatment ${conflict.id}');
      } else {
        // Server wins - apply server data
        await _applyServerWinsConflict(conflict);
      }
    }
  }

  /// Apply server-wins conflict resolution
  Future<void> _applyServerWinsConflict(CompareConflict conflict) async {
    // TODO: Implement server-wins resolution
    debugPrint('Applying server-wins for ${conflict.table} ${conflict.id}');
  }

  /// Resolve conflict from push response
  Future<void> _resolvePushConflict(PushConflict conflict) async {
    final serverData = conflict.serverVersion;
    if (serverData == null) return;

    // Apply server data to local
    await _applyRemoteChange(
      conflict.table,
      conflict.remoteId ?? '',
      serverData,
    );
  }

  /// Mark record as synced
  Future<void> _markAsSynced(int localId, String remoteId) async {
    // TODO: Update sync status in local DB
  }

  /// Legacy pull method (kept for backward compatibility)
  Future<void> pullChanges() async {
    try {
      final lastSync = await _syncDao.getLastSyncTime();
      final request = PullRequest(since: lastSync, deviceId: _deviceId);
      final response = await _apiClient.pullChanges(request);

      for (final change in response.changes) {
        await _applyRemoteChange(change.table, change.remoteId, change.data);
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

  Future<void> _applyRemoteDelete(DeletedRecord deleted) async {
    debugPrint(
      'Applying remote delete: ${deleted.table} - ${deleted.remoteId}',
    );
    // TODO: Implement delete
  }

  /// Legacy push method (kept for backward compatibility)
  Future<void> pushChanges() async {
    if (_isPushingPending) return;
    _isPushingPending = true;

    try {
      final pendingLogs = await _syncDao.getPendingLogs();

      if (pendingLogs.isEmpty) {
        return;
      }

      final deviceId = await _syncDao.getDeviceId() ?? 'unknown';

      final tableOrder = <String, int>{
        for (var i = 0; i < snapshotTables.length; i++) snapshotTables[i]: i,
      };
      final sortedPendingLogs = [...pendingLogs]
        ..sort((a, b) {
          final ai = tableOrder[a.syncTableName] ?? 999;
          final bi = tableOrder[b.syncTableName] ?? 999;
          if (ai != bi) return ai.compareTo(bi);
          return a.createdAt.compareTo(b.createdAt);
        });

      // De-duplicate by table + record, keeping latest payload.
      final dedupByKey = <String, SyncLogEntry>{};
      for (final log in sortedPendingLogs) {
        final key = '${log.syncTableName}:${log.recordId}';
        dedupByKey[key] = log;
      }
      final uniquePendingLogs = dedupByKey.values.toList()
        ..sort((a, b) {
          final ai = tableOrder[a.syncTableName] ?? 999;
          final bi = tableOrder[b.syncTableName] ?? 999;
          if (ai != bi) return ai.compareTo(bi);
          return a.createdAt.compareTo(b.createdAt);
        });

      final changes = uniquePendingLogs
          .map(
            (log) => PushChange(
              table: log.syncTableName,
              localId: log.recordId,
              operation: log.operation,
              data: jsonDecode(log.payload) as Map<String, dynamic>,
            ),
          )
          .toList();

      final request = PushRequest(
        clientTimestamp: DateTime.now().toUtc(),
        deviceId: deviceId,
        changes: changes,
      );

      final response = await _apiClient.pushChanges(request);

      for (final result in response.results) {
        if (result.status != 'success') continue;

        final matchedByTable = sortedPendingLogs.where(
          (l) =>
              l.recordId == result.localId &&
              (result.table.isEmpty || l.syncTableName == result.table),
        );

        final fallback = sortedPendingLogs.where(
          (l) => l.recordId == result.localId,
        );
        final log = matchedByTable.isNotEmpty
            ? matchedByTable.first
            : (fallback.isNotEmpty ? fallback.first : null);
        if (log == null) continue;

        // Mark all duplicate pending logs (same table + record) as synced.
        final logsToSync = sortedPendingLogs.where(
          (l) =>
              l.syncTableName == log.syncTableName &&
              l.recordId == log.recordId,
        );
        for (final item in logsToSync) {
          await _syncDao.updateSyncLogStatus(
            item.id,
            status: SyncStatus.synced,
            syncedAt: DateTime.now().toUtc(),
          );
        }
      }

      for (final conflict in response.conflicts) {
        await _resolvePushConflict(conflict);
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
    } finally {
      _isPushingPending = false;
    }
  }

  Future<void> markAsPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    await _ensureParentMedicalRecordPending(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      data: data,
    );

    await _syncDao.upsertSyncLog(
      SyncLogTableCompanion(
        syncTableName: Value(tableName),
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

  Future<void> _ensureParentMedicalRecordPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    if (operation == 'delete' || tableName == 'medical_records') return;

    final medicalId = _extractMedicalId(
      tableName: tableName,
      recordId: recordId,
      data: data,
    );
    if (medicalId == null || medicalId <= 0) return;

    final medicalData = await _resolveFullRecordData(
      'medical_records',
      medicalId,
    );
    if (medicalData == null) return;

    await _syncDao.upsertSyncLog(
      SyncLogTableCompanion(
        syncTableName: const Value('medical_records'),
        recordId: Value(medicalId),
        operation: const Value('update'),
        payload: Value(jsonEncode(medicalData)),
        status: const Value(SyncStatus.pending),
        createdAt: Value(DateTime.now().toUtc()),
        retryCount: const Value(0),
      ),
    );
  }

  int? _extractMedicalId({
    required String tableName,
    required int recordId,
    required Map<String, dynamic> data,
  }) {
    if (tableName == 'medical_records') return recordId > 0 ? recordId : null;

    final medicalIdRaw = data['medicalId'];
    if (medicalIdRaw is int) return medicalIdRaw;
    if (medicalIdRaw is num) return medicalIdRaw.toInt();
    if (medicalIdRaw is String) return int.tryParse(medicalIdRaw);

    return null;
  }

  Future<void> retryFailed() async {
    final failedLogs = await _syncDao.getFailedLogs();

    for (final log in failedLogs) {
      await _syncDao.updateSyncLogStatus(log.id, status: SyncStatus.pending);
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

  @override
  void dispose() {
    _stopPeriodicSync();
    super.dispose();
  }
}
