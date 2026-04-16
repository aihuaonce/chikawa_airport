import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'incident_dao.g.dart';

// 完整事故紀錄（含參考表資料）
class IncidentRecordWithDetails {
  final IncidentRecordData incident;
  final IncidentPlaceCategoryData? category;
  final IncidentPlaceCategory2Data? category2;
  final ReportingUnitData? reportingUnit;

  IncidentRecordWithDetails({
    required this.incident,
    this.category,
    this.category2,
    this.reportingUnit,
  });
}

//  DAO

@DriftAccessor(tables: [IncidentRecord])
class IncidentDao extends DatabaseAccessor<AppDatabase>
    with _$IncidentDaoMixin {
  IncidentDao(super.db);

  // 依 medicalId 取得事故紀錄
  Future<IncidentRecordData?> getByMedicalId(int medicalId) {
    return (select(
      incidentRecord,
    )..where((i) => i.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立一筆預設事故紀錄
  Future<int> createIncidentRecord({
    required int medicalId,
    required DateTime incidentDate,

    required int incidentPlaceCategoryId,
    int? incidentPlaceCategory2Id,
    String? incidentPlaceFinal,

    DateTime? notificationTime,
    String? notificationPerson,
    required int reportingUnitId,

    required bool beforeLanding,
    required bool occArrived,
    DateTime? landingTime,
  }) {
    return into(incidentRecord).insert(
      IncidentRecordCompanion.insert(
        medicalId: medicalId,
        incidentDate: incidentDate,
        incidentPlaceCategoryId: incidentPlaceCategoryId,
        incidentPlaceCategory2Id: Value(incidentPlaceCategory2Id),
        incidentPlaceFinal: Value(incidentPlaceFinal),
        notificationTime: Value(notificationTime),
        notificationPerson: Value(notificationPerson),
        reportingUnitId: reportingUnitId,
        beforeLanding: Value(beforeLanding),
        landingTime: Value(landingTime),
        occArrived: Value(occArrived),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新整筆事故紀錄（完整表單送出）
  Future<bool> updateIncident(IncidentRecordData data) {
    return update(incidentRecord).replace(data);
  }

  // 只更新事故地點
  Future<int> updateIncidentPlace({
    required int medicalId,
    required int categoryId,
    int? category2Id,
    String? finalPlace,
  }) {
    return (update(
      incidentRecord,
    )..where((i) => i.medicalId.equals(medicalId))).write(
      IncidentRecordCompanion(
        incidentPlaceCategoryId: Value(categoryId),
        incidentPlaceCategory2Id: Value(category2Id),
        incidentPlaceFinal: Value(finalPlace),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 只更新通報資訊
  Future<int> updateNotificationInfo({
    required int medicalId,
    DateTime? notificationTime,
    String? notificationPerson,
    required int reportingUnitId,
  }) {
    return (update(
      incidentRecord,
    )..where((i) => i.medicalId.equals(medicalId))).write(
      IncidentRecordCompanion(
        notificationTime: Value(notificationTime),
        notificationPerson: Value(notificationPerson),
        reportingUnitId: Value(reportingUnitId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 只更新落地資訊
  Future<int> updateLandingInfo({
    required int medicalId,
    required bool beforeLanding,
    DateTime? landingTime,
  }) {
    return (update(
      incidentRecord,
    )..where((i) => i.medicalId.equals(medicalId))).write(
      IncidentRecordCompanion(
        beforeLanding: Value(beforeLanding),
        landingTime: Value(landingTime),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  //依 medicalId 刪除事故紀錄
  Future<int> deleteByMedicalId(int medicalId) {
    return (delete(
      incidentRecord,
    )..where((i) => i.medicalId.equals(medicalId))).go();
  }

  //查詢
  Future<IncidentRecordWithDetails?> getIncidentWithDetails(
    int medicalId,
  ) async {
    final incident = await getByMedicalId(medicalId);
    if (incident == null) return null;

    final category = await db.referenceDao.getIncidentPlaceCategoryById(
      incident.incidentPlaceCategoryId,
    );

    final category2 = incident.incidentPlaceCategory2Id == null
        ? null
        : await db.referenceDao.getIncidentPlaceCategory2ById(
            incident.incidentPlaceCategory2Id!,
          );

    final reportingUnit = await db.referenceDao.getReportingUnitById(
      incident.reportingUnitId,
    );

    return IncidentRecordWithDetails(
      incident: incident,
      category: category,
      category2: category2,
      reportingUnit: reportingUnit,
    );
  }
}
