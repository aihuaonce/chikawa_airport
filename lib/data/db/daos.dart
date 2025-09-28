import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Visits])
class VisitsDao extends DatabaseAccessor<AppDatabase> with _$VisitsDaoMixin {
  VisitsDao(AppDatabase db) : super(db);

  // 建立一筆主檔（回 visitId）
  Future<int> createVisit({String? patientName}) async {
    final id = await into(
      visits,
    ).insert(VisitsCompanion.insert(patientName: Value(patientName)));
    return id;
  }

  // HomePage 列表（可加 keyword 搜尋姓名/國籍/科別）
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

  // 回寫摘要（各分頁存檔時呼叫）
  Future<int> updateVisitSummary(
    int visitId, {
    String? patientName,
    String? gender,
    String? nationality,
    String? dept,
    String? note,
    String? filledBy,
    DateTime? uploadedAt, // 若要更新上傳時間
  }) {
    return (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      VisitsCompanion(
        patientName: patientName == null
            ? const Value.absent()
            : Value(patientName),
        gender: gender == null ? const Value.absent() : Value(gender),
        nationality: nationality == null
            ? const Value.absent()
            : Value(nationality),
        dept: dept == null ? const Value.absent() : Value(dept),
        note: note == null ? const Value.absent() : Value(note),
        filledBy: filledBy == null ? const Value.absent() : Value(filledBy),
        uploadedAt: uploadedAt == null
            ? const Value.absent()
            : Value(uploadedAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteVisit(int visitId) async {
    // 初期用手動刪子表（之後可改成 FK 級聯）
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

  // 抓本頁資料
  Future<PatientProfile?> getByVisitId(int visitId) => (select(
    patientProfiles,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存（沒有就 insert，有就 update），並順便回寫 Visits 摘要
  Future<void> upsertByVisitId({
    required int visitId,
    DateTime? birthday,
    String? gender,
    String? reason,
    String? nationality,
    String? idNumber,
    String? address,
    String? phone,
    String? photoPath,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(patientProfiles).insert(
        PatientProfilesCompanion.insert(
          visitId: visitId,
          birthday: Value(birthday),
          gender: Value(gender),
          reason: Value(reason),
          nationality: Value(nationality),
          idNumber: Value(idNumber),
          address: Value(address),
          phone: Value(phone),
          photoPath: Value(photoPath),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(
        patientProfiles,
      )..where((t) => t.visitId.equals(visitId))).write(
        PatientProfilesCompanion(
          birthday: Value(birthday),
          gender: Value(gender),
          reason: Value(reason),
          nationality: Value(nationality),
          idNumber: Value(idNumber),
          address: Value(address),
          phone: Value(phone),
          photoPath: Value(photoPath),
          updatedAt: Value(now),
        ),
      );
    }

    // 回寫 HomePage 列表所需摘要
    await (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      VisitsCompanion(
        gender: gender == null ? const Value.absent() : Value(gender),
        nationality: nationality == null
            ? const Value.absent()
            : Value(nationality),
        uploadedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}

@DriftAccessor(tables: [AccidentRecords])
class AccidentRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$AccidentRecordsDaoMixin {
  AccidentRecordsDao(AppDatabase db) : super(db);

  // 抓本頁資料
  Future<AccidentRecord?> getByVisitId(int visitId) => (select(
    accidentRecords,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存資料 - 更新版本，包含子地點參數
  Future<void> upsertByVisitId({
    required int visitId,
    DateTime? incidentDate,
    DateTime? notifyTime,
    DateTime? pickUpTime,
    DateTime? medicArriveTime,
    DateTime? ambulanceDepartTime,
    DateTime? checkTime,
    DateTime? landingTime,
    int? reportUnitIdx,
    String? otherReportUnit,
    String? notifier,
    String? phone,
    int? placeIdx,
    String? placeNote,

    // 新增子地點參數
    int? t1PlaceIdx,
    int? t2PlaceIdx,
    int? remotePlaceIdx,
    int? cargoPlaceIdx,
    int? novotelPlaceIdx,
    int? cabinPlaceIdx,

    bool occArrived = false,
    String? cost,
    int? within10min,
    bool reasonLanding = false,
    bool reasonOnline = false,
    bool reasonOther = false,
    String? reasonOtherText,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(accidentRecords).insert(
        AccidentRecordsCompanion.insert(
          visitId: visitId,
          incidentDate: Value(incidentDate),
          notifyTime: Value(notifyTime),
          pickUpTime: Value(pickUpTime),
          medicArriveTime: Value(medicArriveTime),
          ambulanceDepartTime: Value(ambulanceDepartTime),
          checkTime: Value(checkTime),
          landingTime: Value(landingTime),
          reportUnitIdx: Value(reportUnitIdx),
          otherReportUnit: Value(otherReportUnit),
          notifier: Value(notifier),
          phone: Value(phone),
          placeIdx: Value(placeIdx),
          placeNote: Value(placeNote),

          // 新增子地點字段
          t1PlaceIdx: Value(t1PlaceIdx),
          t2PlaceIdx: Value(t2PlaceIdx),
          remotePlaceIdx: Value(remotePlaceIdx),
          cargoPlaceIdx: Value(cargoPlaceIdx),
          novotelPlaceIdx: Value(novotelPlaceIdx),
          cabinPlaceIdx: Value(cabinPlaceIdx),

          occArrived: Value(occArrived),
          cost: Value(cost),
          within10min: Value(within10min),
          reasonLanding: Value(reasonLanding),
          reasonOnline: Value(reasonOnline),
          reasonOther: Value(reasonOther),
          reasonOtherText: Value(reasonOtherText),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(
        accidentRecords,
      )..where((t) => t.visitId.equals(visitId))).write(
        AccidentRecordsCompanion(
          incidentDate: Value(incidentDate),
          notifyTime: Value(notifyTime),
          pickUpTime: Value(pickUpTime),
          medicArriveTime: Value(medicArriveTime),
          ambulanceDepartTime: Value(ambulanceDepartTime),
          checkTime: Value(checkTime),
          landingTime: Value(landingTime),
          reportUnitIdx: Value(reportUnitIdx),
          otherReportUnit: Value(otherReportUnit),
          notifier: Value(notifier),
          phone: Value(phone),
          placeIdx: Value(placeIdx),
          placeNote: Value(placeNote),

          // 新增子地點字段
          t1PlaceIdx: Value(t1PlaceIdx),
          t2PlaceIdx: Value(t2PlaceIdx),
          remotePlaceIdx: Value(remotePlaceIdx),
          cargoPlaceIdx: Value(cargoPlaceIdx),
          novotelPlaceIdx: Value(novotelPlaceIdx),
          cabinPlaceIdx: Value(cabinPlaceIdx),

          occArrived: Value(occArrived),
          cost: Value(cost),
          within10min: Value(within10min),
          reasonLanding: Value(reasonLanding),
          reasonOnline: Value(reasonOnline),
          reasonOther: Value(reasonOther),
          reasonOtherText: Value(reasonOtherText),
          updatedAt: Value(now),
        ),
      );
    }
  }
}

@DriftAccessor(tables: [FlightLogs])
class FlightLogsDao extends DatabaseAccessor<AppDatabase>
    with _$FlightLogsDaoMixin {
  FlightLogsDao(AppDatabase db) : super(db);

  // 抓本頁資料
  Future<FlightLog?> getByVisitId(int visitId) => (select(
    flightLogs,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存（沒有就 insert，有就 update）
  Future<void> upsertByVisitId({
    required int visitId,
    int? airlineIndex,
    bool useOtherAirline = false,
    String? otherAirline,
    String? flightNo,
    int? travelStatusIndex,
    String? otherTravelStatus,
    String? departure,
    String? via,
    String? destination,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(flightLogs).insert(
        FlightLogsCompanion.insert(
          visitId: visitId,
          airlineIndex: Value(airlineIndex),
          useOtherAirline: Value(useOtherAirline),
          otherAirline: Value(otherAirline),
          flightNo: Value(flightNo),
          travelStatusIndex: Value(travelStatusIndex),
          otherTravelStatus: Value(otherTravelStatus),
          departure: Value(departure),
          via: Value(via),
          destination: Value(destination),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(flightLogs)..where((t) => t.visitId.equals(visitId))).write(
        FlightLogsCompanion(
          airlineIndex: Value(airlineIndex),
          useOtherAirline: Value(useOtherAirline),
          otherAirline: Value(otherAirline),
          flightNo: Value(flightNo),
          travelStatusIndex: Value(travelStatusIndex),
          otherTravelStatus: Value(otherTravelStatus),
          departure: Value(departure),
          via: Value(via),
          destination: Value(destination),
          updatedAt: Value(now),
        ),
      );
    }
  }
}
