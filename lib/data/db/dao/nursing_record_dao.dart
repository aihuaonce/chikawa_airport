import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'nursing_record_dao.g.dart';

@DriftAccessor(tables: [NursingRecords])
class NursingRecordDao extends DatabaseAccessor<AppDatabase>
    with _$NursingRecordDaoMixin {
  NursingRecordDao(super.db);

  // 根據 medicalId 取得所有護理記錄（按時間排序）
  Future<List<NursingRecordData>> getRecordsByMedicalId(int medicalId) {
    return (select(nursingRecords)
          ..where((r) => r.medicalId.equals(medicalId))
          ..orderBy([(r) => OrderingTerm.asc(r.recordTime)]))
        .get();
  }

  // 新增護理記錄
  Future<int> insertRecord({
    required int medicalId,
    required DateTime recordTime,
    required String content,
    int? nurseId,
    Uint8List? signature,
  }) {
    return into(nursingRecords).insert(
      NursingRecordsCompanion.insert(
        medicalId: medicalId,
        recordTime: recordTime,
        content: Value(content),
        nurseId: Value(nurseId),
        signature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新護理記錄內容
  Future<int> updateRecord(
    int recordId, {
    DateTime? recordTime,
    String? content,
    int? nurseId,
  }) {
    return (update(
      nursingRecords,
    )..where((r) => r.recordId.equals(recordId))).write(
      NursingRecordsCompanion(
        recordTime: recordTime != null
            ? Value(recordTime)
            : const Value.absent(),
        content: content != null ? Value(content) : const Value.absent(),
        nurseId: nurseId != null ? Value(nurseId) : const Value.absent(),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新護理師簽名
  Future<int> updateSignature(int recordId, Uint8List signature) {
    return (update(
      nursingRecords,
    )..where((r) => r.recordId.equals(recordId))).write(
      NursingRecordsCompanion(
        signature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 刪除護理記錄
  Future<int> deleteRecord(int recordId) {
    return (delete(
      nursingRecords,
    )..where((r) => r.recordId.equals(recordId))).go();
  }

  // 根據 ID 取得單筆記錄
  Future<NursingRecordData?> getRecordById(int recordId) {
    return (select(
      nursingRecords,
    )..where((r) => r.recordId.equals(recordId))).getSingleOrNull();
  }
}
