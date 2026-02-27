import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_tables.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncLogTable, SyncConfigTable])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  /// Insert or update sync log - keeps only the latest state for each record
  /// This prevents accumulating multiple pending logs for the same record
  Future<int> upsertSyncLog(SyncLogTableCompanion entry) async {
    final existingLogs =
        await (select(syncLogTable)
              ..where((t) => t.syncTableName.equals(entry.syncTableName.value))
              ..where((t) => t.recordId.equals(entry.recordId.value))
              ..where((t) => t.status.equals(SyncStatus.pending))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();

    if (existingLogs.isNotEmpty) {
      final keep = existingLogs.first;

      // Update latest existing log with new payload.
      await (update(syncLogTable)..where((t) => t.id.equals(keep.id))).write(
        SyncLogTableCompanion(
          operation: entry.operation,
          payload: entry.payload,
          createdAt: entry.createdAt,
        ),
      );

      // Remove duplicate pending logs for the same table + record.
      if (existingLogs.length > 1) {
        final duplicateIds = existingLogs.skip(1).map((e) => e.id).toList();
        await (delete(
          syncLogTable,
        )..where((t) => t.id.isIn(duplicateIds))).go();
      }

      return keep.id;
    }

    // Insert new log
    return into(syncLogTable).insert(entry);
  }

  Future<int> insertSyncLog(SyncLogTableCompanion entry) {
    return into(syncLogTable).insert(entry);
  }

  Future<void> updateSyncLogStatus(
    int id, {
    required int status,
    String? errorMessage,
    DateTime? syncedAt,
  }) {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      SyncLogTableCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        syncedAt: Value(syncedAt),
      ),
    );
  }

  Future<List<SyncLogEntry>> getPendingLogs() {
    return (select(syncLogTable)
          ..where((t) => t.status.equals(SyncStatus.pending))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> deduplicatePendingLogs() async {
    final pending =
        await (select(syncLogTable)
              ..where((t) => t.status.equals(SyncStatus.pending))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();

    final seen = <String>{};
    final removeIds = <int>[];

    for (final log in pending) {
      final key = '${log.syncTableName}:${log.recordId}';
      if (seen.contains(key)) {
        removeIds.add(log.id);
        continue;
      }
      seen.add(key);
    }

    if (removeIds.isNotEmpty) {
      await (delete(syncLogTable)..where((t) => t.id.isIn(removeIds))).go();
    }
  }

  Future<List<SyncLogEntry>> getFailedLogs() {
    return (select(syncLogTable)
          ..where((t) => t.status.equals(SyncStatus.failed))
          ..where((t) => t.retryCount.isSmallerThanValue(3))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<int> getPendingCount() async {
    final count = syncLogTable.id.count();
    final query = selectOnly(syncLogTable)
      ..addColumns([count])
      ..where(syncLogTable.status.equals(SyncStatus.pending));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<void> deleteSyncedLogs() {
    return (delete(
      syncLogTable,
    )..where((t) => t.status.equals(SyncStatus.synced))).go();
  }

  Future<String?> getConfig(String key) async {
    final query = select(syncConfigTable)..where((t) => t.key.equals(key));
    final result = await query.getSingleOrNull();
    return result?.value;
  }

  Future<void> setConfig(String key, String value) async {
    await into(syncConfigTable).insert(
      SyncConfigTableCompanion.insert(
        key: key,
        value: value,
        updatedAt: DateTime.now().toUtc(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<DateTime?> getLastSyncTime() async {
    final value = await getConfig('last_sync_time');
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<void> setLastSyncTime(DateTime time) async {
    await setConfig('last_sync_time', time.toUtc().toIso8601String());
  }

  Future<String?> getDeviceId() async {
    return await getConfig('device_id');
  }

  Future<void> setDeviceId(String deviceId) async {
    await setConfig('device_id', deviceId);
  }

  Future<void> markLogAsSyncing(int id) {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      const SyncLogTableCompanion(status: Value(1)),
    );
  }

  Future<void> incrementRetryCount(int id) async {
    final query = select(syncLogTable)..where((t) => t.id.equals(id));
    final log = await query.getSingleOrNull();
    if (log != null) {
      await (update(syncLogTable)..where((t) => t.id.equals(id))).write(
        SyncLogTableCompanion(retryCount: Value(log.retryCount + 1)),
      );
    }
  }
}
