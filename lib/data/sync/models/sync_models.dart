String _stringOrEmpty(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? _stringOrNull(dynamic value) {
  if (value == null) return null;
  final parsed = value.toString();
  return parsed.isEmpty ? null : parsed;
}

int _intOrZero(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

DateTime _dateTimeOrNowUtc(dynamic value) {
  if (value is DateTime) return value.toUtc();
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.toUtc();
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
  }
  return DateTime.now().toUtc();
}

Map<String, dynamic> _mapOrEmpty(dynamic value) {
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

Map<String, dynamic>? _mapOrNull(dynamic value) {
  if (value == null) return null;
  return _mapOrEmpty(value);
}

List<dynamic> _listOrEmpty(dynamic value) {
  if (value is List) return value;
  return const <dynamic>[];
}

class SyncChange {
  final int? id;
  final String tableName;
  final int recordId;
  final String operation;
  final Map<String, dynamic> data;
  final int status;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final int retryCount;
  final String? errorMessage;

  SyncChange({
    this.id,
    required this.tableName,
    required this.recordId,
    required this.operation,
    required this.data,
    this.status = 0,
    required this.createdAt,
    this.syncedAt,
    this.retryCount = 0,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
    'tableName': tableName,
    'recordId': recordId,
    'operation': operation,
    'data': data,
  };

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
    tableName: _stringOrEmpty(json['tableName']),
    recordId: _intOrZero(json['recordId']),
    operation: _stringOrEmpty(json['operation']),
    data: _mapOrEmpty(json['data']),
    createdAt: DateTime.now(),
  );
}

class SyncResult {
  final bool success;
  final int pushedCount;
  final int pulledCount;
  final int conflictCount;
  final String? errorMessage;

  SyncResult({
    required this.success,
    this.pushedCount = 0,
    this.pulledCount = 0,
    this.conflictCount = 0,
    this.errorMessage,
  });
}

class Conflict {
  final String tableName;
  final int localId;
  final String? remoteId;
  final Map<String, dynamic>? clientVersion;
  final Map<String, dynamic>? serverVersion;

  Conflict({
    required this.tableName,
    required this.localId,
    this.remoteId,
    this.clientVersion,
    this.serverVersion,
  });
}

class PullRequest {
  final DateTime? since;
  final List<String>? tables;
  final String? deviceId;

  PullRequest({this.since, this.tables, this.deviceId});

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (since != null) {
      params['since'] = since!.toUtc().toIso8601String();
    }
    if (tables != null && tables!.isNotEmpty) {
      params['tables'] = tables!.join(',');
    }
    return params;
  }
}

class PullResponse {
  final DateTime serverTimestamp;
  final List<RemoteChange> changes;
  final List<DeletedRecord> deletedRecords;

  PullResponse({
    required this.serverTimestamp,
    required this.changes,
    required this.deletedRecords,
  });

  factory PullResponse.fromJson(Map<String, dynamic> json) => PullResponse(
    serverTimestamp: _dateTimeOrNowUtc(json['serverTimestamp']),
    changes: _listOrEmpty(
      json['changes'],
    ).map((e) => RemoteChange.fromJson(e as Map<String, dynamic>)).toList(),
    deletedRecords: _listOrEmpty(
      json['deletedRecords'],
    ).map((e) => DeletedRecord.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

class RemoteChange {
  final String table;
  final String operation;
  final Map<String, dynamic> data;
  final String remoteId;
  final DateTime modifiedAt;

  RemoteChange({
    required this.table,
    required this.operation,
    required this.data,
    required this.remoteId,
    required this.modifiedAt,
  });

  factory RemoteChange.fromJson(Map<String, dynamic> json) => RemoteChange(
    table: _stringOrEmpty(json['table']),
    operation: _stringOrEmpty(json['operation']),
    data: _mapOrEmpty(json['data']),
    remoteId: _stringOrEmpty(json['remoteId']),
    modifiedAt: _dateTimeOrNowUtc(json['modifiedAt']),
  );
}

class DeletedRecord {
  final String table;
  final String remoteId;

  DeletedRecord({required this.table, required this.remoteId});

  factory DeletedRecord.fromJson(Map<String, dynamic> json) => DeletedRecord(
    table: _stringOrEmpty(json['table']),
    remoteId: _stringOrEmpty(json['remoteId']),
  );
}

class PushRequest {
  final DateTime clientTimestamp;
  final String deviceId;
  final List<PushChange> changes;

  PushRequest({
    required this.clientTimestamp,
    required this.deviceId,
    required this.changes,
  });

  Map<String, dynamic> toJson() => {
    'clientTimestamp': clientTimestamp.toUtc().toIso8601String(),
    'deviceId': deviceId,
    'changes': changes.map((e) => e.toJson()).toList(),
  };
}

class PushChange {
  final String table;
  final int localId;
  final String operation;
  final Map<String, dynamic> data;
  final String? remoteId;

  PushChange({
    required this.table,
    required this.localId,
    required this.operation,
    required this.data,
    this.remoteId,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'localId': localId,
    'operation': operation,
    'data': data,
    if (remoteId != null) 'remoteId': remoteId,
  };
}

class PushResponse {
  final DateTime serverTimestamp;
  final List<PushResult> results;
  final List<PushConflict> conflicts;

  PushResponse({
    required this.serverTimestamp,
    required this.results,
    required this.conflicts,
  });

  factory PushResponse.fromJson(Map<String, dynamic> json) => PushResponse(
    serverTimestamp: _dateTimeOrNowUtc(json['serverTimestamp']),
    results: _listOrEmpty(
      json['results'],
    ).map((e) => PushResult.fromJson(e as Map<String, dynamic>)).toList(),
    conflicts: _listOrEmpty(
      json['conflicts'],
    ).map((e) => PushConflict.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

class PushResult {
  final String table;
  final int localId;
  final String? remoteId;
  final String status;

  PushResult({
    required this.table,
    required this.localId,
    this.remoteId,
    required this.status,
  });

  factory PushResult.fromJson(Map<String, dynamic> json) => PushResult(
    table: _stringOrEmpty(json['table']),
    localId: _intOrZero(json['localId']),
    remoteId: _stringOrNull(json['remoteId']),
    status: _stringOrNull(json['status']) ?? 'unknown',
  );
}

class PushConflict {
  final String table;
  final int localId;
  final String? remoteId;
  final Map<String, dynamic>? serverVersion;
  final Map<String, dynamic>? clientVersion;

  PushConflict({
    required this.table,
    required this.localId,
    this.remoteId,
    this.serverVersion,
    this.clientVersion,
  });

  factory PushConflict.fromJson(Map<String, dynamic> json) => PushConflict(
    table: _stringOrEmpty(json['table']),
    localId: _intOrZero(json['localId']),
    remoteId: _stringOrNull(json['remoteId']),
    serverVersion: _mapOrNull(json['serverVersion']),
    clientVersion: _mapOrNull(json['clientVersion']),
  );

  Conflict toConflict() => Conflict(
    tableName: table,
    localId: localId,
    remoteId: remoteId,
    clientVersion: clientVersion,
    serverVersion: serverVersion,
  );
}

// ============ Compare-first sync models ============

/// Request to compare local snapshot with server
class CompareRequest {
  final String deviceId;
  final List<LocalSnapshot> snapshot;

  CompareRequest({required this.deviceId, required this.snapshot});

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'snapshot': snapshot.map((s) => s.toJson()).toList(),
  };
}

/// Local snapshot entry for a single record
class LocalSnapshot {
  final String table;
  final int id;
  final int lastModified; // Unix milliseconds

  LocalSnapshot({
    required this.table,
    required this.id,
    required this.lastModified,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'id': id,
    'lastModified': lastModified,
  };
}

/// Response from compare endpoint
class CompareResponse {
  final DateTime serverTimestamp;
  final List<RemoteRecord> toDownload;
  final List<UploadItem> toUpload;
  final List<CompareConflict> conflicts;

  CompareResponse({
    required this.serverTimestamp,
    required this.toDownload,
    required this.toUpload,
    required this.conflicts,
  });

  factory CompareResponse.fromJson(Map<String, dynamic> json) =>
      CompareResponse(
        serverTimestamp: _dateTimeOrNowUtc(json['serverTimestamp']),
        toDownload: _listOrEmpty(
          json['toDownload'],
        ).map((e) => RemoteRecord.fromJson(e as Map<String, dynamic>)).toList(),
        toUpload: _listOrEmpty(
          json['toUpload'],
        ).map((e) => UploadItem.fromJson(e as Map<String, dynamic>)).toList(),
        conflicts: _listOrEmpty(json['conflicts'])
            .map((e) => CompareConflict.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// Record to download from server
class RemoteRecord {
  final String table;
  final String remoteId;
  final Map<String, dynamic> data;

  RemoteRecord({
    required this.table,
    required this.remoteId,
    required this.data,
  });

  factory RemoteRecord.fromJson(Map<String, dynamic> json) => RemoteRecord(
    table: _stringOrEmpty(json['table']),
    remoteId: _stringOrEmpty(json['remoteId']),
    data: _mapOrEmpty(json['data']),
  );
}

/// Item that needs to be uploaded to server
class UploadItem {
  final String table;
  final int id;

  UploadItem({required this.table, required this.id});

  factory UploadItem.fromJson(Map<String, dynamic> json) => UploadItem(
    table: _stringOrEmpty(json['table']),
    id: _intOrZero(json['id']),
  );
}

/// Conflict detected during compare
class CompareConflict {
  final String table;
  final int id;
  final int localModified;
  final int serverModified;
  final Map<String, dynamic> serverData;

  CompareConflict({
    required this.table,
    required this.id,
    required this.localModified,
    required this.serverModified,
    required this.serverData,
  });

  factory CompareConflict.fromJson(Map<String, dynamic> json) =>
      CompareConflict(
        table: _stringOrEmpty(json['table']),
        id: _intOrZero(json['id']),
        localModified: _intOrZero(json['localModified']),
        serverModified: _intOrZero(json['serverModified']),
        serverData: _mapOrEmpty(json['serverData']),
      );
}

/// Push request with full record data (used for toUpload items)
class FullPushChange {
  final String table;
  final int localId;
  final String operation;
  final Map<String, dynamic> data;
  final String? remoteId;

  FullPushChange({
    required this.table,
    required this.localId,
    required this.operation,
    required this.data,
    this.remoteId,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'localId': localId,
    'operation': operation,
    'data': data,
    if (remoteId != null) 'remoteId': remoteId,
  };
}

enum SyncState { idle, syncing, error, offline }
