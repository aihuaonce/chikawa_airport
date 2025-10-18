import 'dart:convert';
import 'dart:typed_data';
import 'package:chikawa_airport/data/models/AmbulanceView_Data.dart';
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

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

  // ✅ 正確的修改：明確指定基於 visit_id 來判斷衝突
  Future<void> upsert(PatientProfilesCompanion companion) async {
    final companionWithTimestamp = companion.copyWith(
      updatedAt: Value(DateTime.now()),
    );

    await into(patientProfiles).insert(
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

@DriftAccessor(tables: [AccidentRecords])
class AccidentRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$AccidentRecordsDaoMixin {
  AccidentRecordsDao(AppDatabase db) : super(db);

  Future<AccidentRecord?> getByVisitId(int visitId) => (select(
    accidentRecords,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(AccidentRecordsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(accidentRecords).insert(updated);
    } else {
      await (update(accidentRecords)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [FlightLogs])
class FlightLogsDao extends DatabaseAccessor<AppDatabase>
    with _$FlightLogsDaoMixin {
  FlightLogsDao(AppDatabase db) : super(db);

  Future<FlightLog?> getByVisitId(int visitId) => (select(
    flightLogs,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(FlightLogsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(flightLogs).insert(updated);
    } else {
      await (update(flightLogs)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [Treatments])
class TreatmentsDao extends DatabaseAccessor<AppDatabase>
    with _$TreatmentsDaoMixin {
  TreatmentsDao(AppDatabase db) : super(db);

  Future<Treatment?> getByVisitId(int visitId) => (select(
    treatments,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(TreatmentsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(treatments).insert(updated);
    } else {
      await (update(treatments)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [MedicalCosts])
class MedicalCostsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalCostsDaoMixin {
  MedicalCostsDao(AppDatabase db) : super(db);

  Future<MedicalCost?> getByVisitId(int visitId) => (select(
    medicalCosts,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(MedicalCostsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(medicalCosts).insert(updated);
    } else {
      await (update(medicalCosts)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [MedicalCertificates])
class MedicalCertificatesDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalCertificatesDaoMixin {
  MedicalCertificatesDao(AppDatabase db) : super(db);

  Future<MedicalCertificate?> getByVisitId(int visitId) => (select(
    medicalCertificates,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(MedicalCertificatesCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(medicalCertificates).insert(updated);
    } else {
      await (update(medicalCertificates)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [Undertakings])
class UndertakingsDao extends DatabaseAccessor<AppDatabase>
    with _$UndertakingsDaoMixin {
  UndertakingsDao(AppDatabase db) : super(db);

  Future<Undertaking?> getByVisitId(int visitId) => (select(
    undertakings,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(UndertakingsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(undertakings).insert(updated);
    } else {
      await (update(undertakings)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [ElectronicDocuments])
class ElectronicDocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$ElectronicDocumentsDaoMixin {
  ElectronicDocumentsDao(AppDatabase db) : super(db);

  Future<ElectronicDocument?> getByVisitId(int visitId) => (select(
    electronicDocuments,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(ElectronicDocumentsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(electronicDocuments).insert(updated);
    } else {
      await (update(electronicDocuments)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
  }
}

@DriftAccessor(tables: [NursingRecords])
class NursingRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$NursingRecordsDaoMixin {
  NursingRecordsDao(AppDatabase db) : super(db);

  Future<NursingRecord?> getByVisitId(int visitId) => (select(
    nursingRecords,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(NursingRecordsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(nursingRecords).insert(updated);
    } else {
      await (update(nursingRecords)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
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

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(ReferralFormsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      await into(referralForms).insert(updated);
    } else {
      await (update(referralForms)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
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

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(AmbulanceRecordsCompanion companion) async {
    final existing = await getByVisitId(companion.visitId.value);

    if (existing == null) {
      await createRecordForVisit(companion.visitId.value);
    }

    await (update(ambulanceRecords)
          ..where((t) => t.visitId.equals(companion.visitId.value)))
        .write(companion);
  }
}

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

  // ✅ 簡化：統一的 upsert 方法
  Future<void> upsert(EmergencyRecordsCompanion companion) async {
    // 檢查紀錄是否存在
    final existing = await getByVisitId(companion.visitId.value);
    final updated = companion.copyWith(updatedAt: Value(DateTime.now()));

    if (existing == null) {
      // 如果不存在，執行插入 (Insert)
      await into(emergencyRecords).insert(updated);
    } else {
      // 如果存在，執行更新 (Update)
      await (update(emergencyRecords)
            ..where((t) => t.visitId.equals(companion.visitId.value)))
          .write(updated);
    }
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
