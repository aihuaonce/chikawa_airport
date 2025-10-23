import 'dart:convert';
import 'dart:typed_data';
import 'package:chikawa_airport/data/models/AmbulanceView_Data.dart';
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

// 說明：移除了未被使用的 `BaseUpsertMixin`，因為我們將在每個 DAO 中使用更明確的 onConflict 策略。

@DriftAccessor(tables: [Visits])
class VisitsDao extends DatabaseAccessor<AppDatabase> with _$VisitsDaoMixin {
  VisitsDao(AppDatabase db) : super(db);

  Future<int> createVisit({String? patientName}) async {
    final id = await into(visits).insert(
      VisitsCompanion.insert(
        patientName: Value(patientName),
        hasEmergencyRecord: const Value(true),
      ),
    );

    return id;
  }

  Stream<List<Visit>> watchAll({String? keyword}) {
    final q = select(visits)..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)]);
    if (keyword != null && keyword.trim().isNotEmpty) {
      final like = '%${keyword.trim()}%';
      q.where(
        (t) =>
            t.patientName.like(like) |
            t.nationality.like(like) |
            t.dept.like(like),
      );
    }
    return q.watch();
  }

  // ✅ 簡化：使用 Companion 更新
  Future<int> updateVisit(int visitId, VisitsCompanion companion) {
    return (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      companion.copyWith(updatedAt: Value(DateTime.now())),
    );
  }

  Future<int> deleteVisit(int visitId) async {
    await (delete(
      db.patientProfiles,
    )..where((t) => t.visitId.equals(visitId))).go();
    return (delete(visits)..where((t) => t.visitId.equals(visitId))).go();
  }

  Future<Visit?> getById(int visitId) => (select(
    visits,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();
}

@DriftAccessor(tables: [PatientProfiles, Visits])
class PatientProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$PatientProfilesDaoMixin {
  PatientProfilesDao(AppDatabase db) : super(db);

  Future<PatientProfile?> getByVisitId(int visitId) => (select(
    patientProfiles,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 您的這個 `upsert` 寫法已經是最佳實踐，無需修改。它高效地利用了 onConflict 機制。
  Future<int> upsert(PatientProfilesCompanion companion) {
    final companionWithTimestamp = companion.copyWith(
      updatedAt: Value(DateTime.now()),
    );

    return into(patientProfiles).insert(
      companionWithTimestamp,
      // 當 visit_id 衝突時，執行更新
      onConflict: DoUpdate(
        (old) => companionWithTimestamp, // 使用新的資料來更新
        target: [patientProfiles.visitId], // 告訴 Drift 監聽 visitId 欄位的衝突
      ),
    );
  }

  // 保留專門的 BodyMap 更新方法（因為邏輯特殊）
  Future<void> upsertBodyMap(int visitId, String? bodyMapJson) async {
    final companion = PatientProfilesCompanion(
      visitId: Value(visitId),
      bodyMapJson: Value(bodyMapJson),
    );
    // 這裡的呼叫也會自動使用上面修改過的新 upsert 邏輯，無需改動
    await upsert(companion);
  }
}

// 範本：以下所有 DAO 的 upsert 方法都將遵循此優化模式
abstract class _BaseDaoWithVisitId<Tbl extends Table, D>
    extends DatabaseAccessor<AppDatabase> {
  _BaseDaoWithVisitId(AppDatabase db) : super(db);

  TableInfo<Tbl, D> get table;
  Column<int> get visitIdColumn;

  Future<D?> getByVisitId(int visitId) => (select(
    table,
  )..where((t) => visitIdColumn.equals(visitId))).getSingleOrNull();
}

@DriftAccessor(tables: [AccidentRecords])
class AccidentRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$AccidentRecordsDaoMixin {
  AccidentRecordsDao(AppDatabase db) : super(db);

  Future<AccidentRecord?> getByVisitId(int visitId) => (select(
    accidentRecords,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate` 將查詢和寫入合併為一個原子操作。
  // 前提：`accidentRecords.visitId` 欄位在資料庫中有 UNIQUE 約束。
  Future<int> upsert(AccidentRecordsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(accidentRecords).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [accidentRecords.visitId]),
    );
  }
}

@DriftAccessor(tables: [FlightLogs])
class FlightLogsDao extends DatabaseAccessor<AppDatabase>
    with _$FlightLogsDaoMixin {
  FlightLogsDao(AppDatabase db) : super(db);

  Future<FlightLog?> getByVisitId(int visitId) => (select(
    flightLogs,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(FlightLogsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(flightLogs).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [flightLogs.visitId]),
    );
  }
}

@DriftAccessor(tables: [Treatments])
class TreatmentsDao extends DatabaseAccessor<AppDatabase>
    with _$TreatmentsDaoMixin {
  TreatmentsDao(AppDatabase db) : super(db);

  Future<Treatment?> getByVisitId(int visitId) => (select(
    treatments,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(TreatmentsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(treatments).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [treatments.visitId]),
    );
  }
}

@DriftAccessor(tables: [MedicalCosts])
class MedicalCostsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalCostsDaoMixin {
  MedicalCostsDao(AppDatabase db) : super(db);

  Future<MedicalCost?> getByVisitId(int visitId) => (select(
    medicalCosts,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(MedicalCostsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(medicalCosts).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [medicalCosts.visitId]),
    );
  }
}

@DriftAccessor(tables: [MedicalCertificates])
class MedicalCertificatesDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalCertificatesDaoMixin {
  MedicalCertificatesDao(AppDatabase db) : super(db);

  Future<MedicalCertificate?> getByVisitId(int visitId) => (select(
    medicalCertificates,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(MedicalCertificatesCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(medicalCertificates).insert(
      updated,
      onConflict: DoUpdate(
        (old) => updated,
        target: [medicalCertificates.visitId],
      ),
    );
  }
}

@DriftAccessor(tables: [Undertakings])
class UndertakingsDao extends DatabaseAccessor<AppDatabase>
    with _$UndertakingsDaoMixin {
  UndertakingsDao(AppDatabase db) : super(db);

  Future<Undertaking?> getByVisitId(int visitId) => (select(
    undertakings,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(UndertakingsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(undertakings).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [undertakings.visitId]),
    );
  }
}

@DriftAccessor(tables: [ElectronicDocuments])
class ElectronicDocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$ElectronicDocumentsDaoMixin {
  ElectronicDocumentsDao(AppDatabase db) : super(db);

  Future<ElectronicDocument?> getByVisitId(int visitId) => (select(
    electronicDocuments,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(ElectronicDocumentsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(electronicDocuments).insert(
      updated,
      onConflict: DoUpdate(
        (old) => updated,
        target: [electronicDocuments.visitId],
      ),
    );
  }
}

@DriftAccessor(tables: [NursingRecords])
class NursingRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$NursingRecordsDaoMixin {
  NursingRecordsDao(AppDatabase db) : super(db);

  Future<NursingRecord?> getByVisitId(int visitId) => (select(
    nursingRecords,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(NursingRecordsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(nursingRecords).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [nursingRecords.visitId]),
    );
  }
}

@DriftAccessor(tables: [ReferralForms])
class ReferralFormsDao extends DatabaseAccessor<AppDatabase>
    with _$ReferralFormsDaoMixin {
  ReferralFormsDao(AppDatabase db) : super(db);

  Future<ReferralForm?> getByVisitId(int visitId) => (select(
    referralForms,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  Future<int> createFormForVisit(int visitId) {
    return into(
      referralForms,
    ).insert(ReferralFormsCompanion.insert(visitId: visitId));
  }

  Future<bool> formExistsForVisit(int visitId) async {
    final existing = await getByVisitId(visitId);
    return existing != null;
  }

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(ReferralFormsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(referralForms).insert(
      updated,
      onConflict: DoUpdate((old) => updated, target: [referralForms.visitId]),
    );
  }
}

@DriftAccessor(tables: [AmbulanceRecords, Visits, Treatments])
class AmbulanceRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$AmbulanceRecordsDaoMixin {
  AmbulanceRecordsDao(AppDatabase db) : super(db);

  Stream<List<DetailedAmbulanceViewData>> watchAllDetailedRecords({
    String keyword = '',
  }) {
    final query = select(ambulanceRecords).join([
      innerJoin(visits, visits.visitId.equalsExp(ambulanceRecords.visitId)),
      leftOuterJoin(treatments, treatments.visitId.equalsExp(visits.visitId)),
    ]);

    if (keyword.isNotEmpty) {
      query.where(
        visits.patientName.like('%$keyword%') |
            ambulanceRecords.chiefComplaint.like('%$keyword%') |
            ambulanceRecords.destinationHospital.like('%$keyword%'),
      );
    }

    query.orderBy([OrderingTerm.desc(ambulanceRecords.dutyTime)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return DetailedAmbulanceViewData(
          record: row.readTable(ambulanceRecords),
          visit: row.readTable(visits),
          treatment: row.readTableOrNull(treatments),
        );
      }).toList();
    });
  }

  Future<AmbulanceRecord?> getByVisitId(int visitId) => (select(
    ambulanceRecords,
  )..where((tbl) => tbl.visitId.equals(visitId))).getSingleOrNull();

  Future<int> createRecordForVisit(int visitId) {
    return into(ambulanceRecords).insert(
      AmbulanceRecordsCompanion.insert(
        visitId: visitId,
        dutyTime: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> recordExistsForVisit(int visitId) async {
    final existing = await getByVisitId(visitId);
    return existing != null;
  }

  // 🔥 優化：使用 `insertOnConflictUpdate` 簡化邏輯。
  // 此方法會自動處理新增（如果 visitId 不存在）或更新（如果 visitId 已存在）的情況。
  Future<int> upsert(AmbulanceRecordsCompanion companion) {
    return into(ambulanceRecords).insert(
      companion,
      onConflict: DoUpdate(
        (old) => companion,
        target: [ambulanceRecords.visitId],
      ),
    );
  }
}

// 以下處理一對多關係的 DAO (如 MedicationRecords, VitalSignsRecords) 不需要 upsert 邏輯，
// 其原有的 add/delete/watch 設計是正確的，因此保持不變。

@DriftAccessor(tables: [MedicationRecords])
class MedicationRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationRecordsDaoMixin {
  MedicationRecordsDao(AppDatabase db) : super(db);

  Stream<List<MedicationRecord>> watchRecordsForVisit(int visitId) => (select(
    medicationRecords,
  )..where((tbl) => tbl.visitId.equals(visitId))).watch();

  Future<int> addRecord(MedicationRecordsCompanion entry) =>
      into(medicationRecords).insert(entry);

  Future<void> deleteRecord(int id) =>
      (delete(medicationRecords)..where((tbl) => tbl.id.equals(id))).go();
}

@DriftAccessor(tables: [VitalSignsRecords])
class VitalSignsRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$VitalSignsRecordsDaoMixin {
  VitalSignsRecordsDao(AppDatabase db) : super(db);

  Stream<List<VitalSignsRecord>> watchRecordsForVisit(int visitId) => (select(
    vitalSignsRecords,
  )..where((tbl) => tbl.visitId.equals(visitId))).watch();

  Future<int> addRecord(VitalSignsRecordsCompanion entry) =>
      into(vitalSignsRecords).insert(entry);

  Future<void> deleteRecord(int id) =>
      (delete(vitalSignsRecords)..where((tbl) => tbl.id.equals(id))).go();
}

@DriftAccessor(tables: [ParamedicRecords])
class ParamedicRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$ParamedicRecordsDaoMixin {
  ParamedicRecordsDao(AppDatabase db) : super(db);

  Stream<List<ParamedicRecord>> watchRecordsForVisit(int visitId) => (select(
    paramedicRecords,
  )..where((tbl) => tbl.visitId.equals(visitId))).watch();

  Future<int> addRecord(ParamedicRecordsCompanion entry) =>
      into(paramedicRecords).insert(entry);

  Future<void> deleteRecord(int id) =>
      (delete(paramedicRecords)..where((tbl) => tbl.id.equals(id))).go();
}

@DriftAccessor(tables: [EmergencyRecords, Visits])
class EmergencyRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$EmergencyRecordsDaoMixin {
  EmergencyRecordsDao(AppDatabase db) : super(db);

  Future<EmergencyRecord?> getByVisitId(int visitId) => (select(
    emergencyRecords,
  )..where((tbl) => tbl.visitId.equals(visitId))).getSingleOrNull();

  Future<int> createRecordForVisit(int visitId) {
    return into(emergencyRecords).insert(
      EmergencyRecordsCompanion.insert(
        visitId: visitId,
        firstAidStartTime: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> recordExistsForVisit(int visitId) async {
    final existing = await getByVisitId(visitId);
    return existing != null;
  }

  // 🔥 優化：使用 `insertOnConflictUpdate`
  Future<int> upsert(EmergencyRecordsCompanion companion) {
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));
    return into(emergencyRecords).insert(
      updated,
      onConflict: DoUpdate(
        (old) => updated,
        target: [emergencyRecords.visitId],
      ),
    );
  }

  Stream<List<EmergencyRecord>> watchAll({String keyword = ''}) {
    final query = select(emergencyRecords)
      ..orderBy([(t) => OrderingTerm.desc(t.incidentDateTime)]);

    if (keyword.isNotEmpty) {
      query.where(
        (t) =>
            t.patientName.like('%$keyword%') |
            t.diagnosis.like('%$keyword%') |
            t.selectedHospital.like('%$keyword%') |
            t.nationality.like('%$keyword%'),
      );
    }

    return query.watch();
  }
}
