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
    tableName: json['tableName'] as String,
    recordId: json['recordId'] as int,
    operation: json['operation'] as String,
    data: json['data'] as Map<String, dynamic>,
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
  final String remoteId;
  final Map<String, dynamic> clientVersion;
  final Map<String, dynamic> serverVersion;

  Conflict({
    required this.tableName,
    required this.localId,
    required this.remoteId,
    required this.clientVersion,
    required this.serverVersion,
  });
}

class PullRequest {
  final DateTime? since;
  final List<String>? tables;

  PullRequest({this.since, this.tables});

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
    serverTimestamp: DateTime.parse(json['serverTimestamp'] as String),
    changes: (json['changes'] as List<dynamic>)
        .map((e) => RemoteChange.fromJson(e as Map<String, dynamic>))
        .toList(),
    deletedRecords: (json['deletedRecords'] as List<dynamic>?)
        ?.map((e) => DeletedRecord.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
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
    table: json['table'] as String,
    operation: json['operation'] as String,
    data: json['data'] as Map<String, dynamic>,
    remoteId: json['remoteId'] as String,
    modifiedAt: DateTime.parse(json['modifiedAt'] as String),
  );
}

class DeletedRecord {
  final String table;
  final String remoteId;

  DeletedRecord({required this.table, required this.remoteId});

  factory DeletedRecord.fromJson(Map<String, dynamic> json) => DeletedRecord(
    table: json['table'] as String,
    remoteId: json['remoteId'] as String,
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

  PushChange({
    required this.table,
    required this.localId,
    required this.operation,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'table': table,
    'localId': localId,
    'operation': operation,
    'data': data,
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
    serverTimestamp: DateTime.parse(json['serverTimestamp'] as String),
    results: (json['results'] as List<dynamic>)
        .map((e) => PushResult.fromJson(e as Map<String, dynamic>))
        .toList(),
    conflicts: (json['conflicts'] as List<dynamic>?)
        ?.map((e) => PushConflict.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
  );
}

class PushResult {
  final int localId;
  final String remoteId;
  final String status;

  PushResult({
    required this.localId,
    required this.remoteId,
    required this.status,
  });

  factory PushResult.fromJson(Map<String, dynamic> json) => PushResult(
    localId: json['localId'] as int,
    remoteId: json['remoteId'] as String,
    status: json['status'] as String,
  );
}

class PushConflict {
  final String table;
  final int localId;
  final String remoteId;
  final Map<String, dynamic> serverVersion;
  final Map<String, dynamic> clientVersion;

  PushConflict({
    required this.table,
    required this.localId,
    required this.remoteId,
    required this.serverVersion,
    required this.clientVersion,
  });

  factory PushConflict.fromJson(Map<String, dynamic> json) => PushConflict(
    table: json['table'] as String,
    localId: json['localId'] as int,
    remoteId: json['remoteId'] as String,
    serverVersion: json['serverVersion'] as Map<String, dynamic>,
    clientVersion: json['clientVersion'] as Map<String, dynamic>,
  );

  Conflict toConflict() => Conflict(
    tableName: table,
    localId: localId,
    remoteId: remoteId,
    clientVersion: clientVersion,
    serverVersion: serverVersion,
  );
}

enum SyncState {
  idle,
  syncing,
  error,
  offline,
}
