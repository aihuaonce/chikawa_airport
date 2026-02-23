// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncLogTableTable get syncLogTable => attachedDatabase.syncLogTable;
  $SyncConfigTableTable get syncConfigTable => attachedDatabase.syncConfigTable;
  SyncDaoManager get managers => SyncDaoManager(this);
}

class SyncDaoManager {
  final _$SyncDaoMixin _db;
  SyncDaoManager(this._db);
  $$SyncLogTableTableTableManager get syncLogTable =>
      $$SyncLogTableTableTableManager(_db.attachedDatabase, _db.syncLogTable);
  $$SyncConfigTableTableTableManager get syncConfigTable =>
      $$SyncConfigTableTableTableManager(
        _db.attachedDatabase,
        _db.syncConfigTable,
      );
}
