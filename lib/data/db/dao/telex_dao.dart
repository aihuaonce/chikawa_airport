import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'telex_dao.g.dart';

@DriftAccessor(tables: [TelexDocuments])
class TelexDao extends DatabaseAccessor<AppDatabase> with _$TelexDaoMixin {
  TelexDao(super.db);

  // 根據 medicalId 取得 TELEX 文件
  Future<TelexDocumentData?> getTelexByMedicalId(int medicalId) {
    return (select(
      telexDocuments,
    )..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立新的 TELEX 文件
  Future<int> createTelex(
    int medicalId, {
    int? toStationId,
    int? fromStationId,
  }) {
    return into(telexDocuments).insert(
      TelexDocumentsCompanion.insert(
        medicalId: medicalId,
        toStationId: Value(toStationId),
        fromStationId: Value(fromStationId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新收件站點
  Future<int> updateToStation(int documentId, int? toStationId) {
    return (update(
      telexDocuments,
    )..where((t) => t.documentId.equals(documentId))).write(
      TelexDocumentsCompanion(
        toStationId: Value(toStationId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新寄件站點
  Future<int> updateFromStation(int documentId, int? fromStationId) {
    return (update(
      telexDocuments,
    )..where((t) => t.documentId.equals(documentId))).write(
      TelexDocumentsCompanion(
        fromStationId: Value(fromStationId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 刪除 TELEX 文件
  Future<int> deleteTelex(int documentId) {
    return (delete(
      telexDocuments,
    )..where((t) => t.documentId.equals(documentId))).go();
  }
}
