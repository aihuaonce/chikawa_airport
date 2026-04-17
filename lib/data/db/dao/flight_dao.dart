import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';
import '../tables/reference_tables.dart';

part 'flight_dao.g.dart';

//資料模型

// 經過點與其詳細資料的包裝類別
class TransitLocationWithData {
  final int transitId;
  final LocationData location;

  TransitLocationWithData({required this.transitId, required this.location});
}

// 完整飛航記錄（含關聯資料）
class FlightRecordWithDetails {
  final FlightRecordData flightRecord;
  final AirlineData? airline;
  final TravelStatusData? travelStatus;
  final LocationData? departureLocation;
  final LocationData? arrivalLocation;
  final List<TransitLocationWithData> transitLocations;

  FlightRecordWithDetails({
    required this.flightRecord,
    this.airline,
    this.travelStatus,
    this.departureLocation,
    this.arrivalLocation,
    required this.transitLocations,
  });
}

// DAO

@DriftAccessor(tables: [FlightRecord, FlightTransitLocations, Location])
class FlightDao extends DatabaseAccessor<AppDatabase> with _$FlightDaoMixin {
  FlightDao(super.db);

  //  飛航記錄相關

  // 根據 medicalId 取得飛航記錄
  Future<FlightRecordData?> getFlightByMedicalId(int medicalId) {
    return (select(
      flightRecord,
    )..where((f) => f.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立新的飛航記錄
  Future<int> createFlightRecord({
    required int medicalId,
    int? airlineId,
    required String flightNumber,
    int? travelStatusId,
    int? departureLocationId,
    int? arrivalLocationId,
  }) {
    return into(flightRecord).insert(
      FlightRecordCompanion.insert(
        medicalId: medicalId,
        airlineId: Value(airlineId),
        flightNumber: flightNumber,
        travelStatusId: Value(travelStatusId),
        departureLocationId: Value(departureLocationId),
        arrivalLocationId: Value(arrivalLocationId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新飛航記錄
  Future<bool> updateFlight(FlightRecordData data) async {
    // 先取得舊資料
    final oldData =
        await (select(flightRecord)
              ..where((f) => f.flightRecordId.equals(data.flightRecordId)))
            .getSingleOrNull();

    // 檢查是否有變更，有變更才設 syncStatus = 1
    final hasChanges =
        oldData == null ||
        oldData.flightNumber != data.flightNumber ||
        oldData.airlineId != data.airlineId ||
        oldData.travelStatusId != data.travelStatusId ||
        oldData.departureLocationId != data.departureLocationId ||
        oldData.arrivalLocationId != data.arrivalLocationId;

    if (hasChanges) {
      await (update(
        flightRecord,
      )..where((f) => f.flightRecordId.equals(data.flightRecordId))).write(
        FlightRecordCompanion(
          flightNumber: Value(data.flightNumber),
          airlineId: Value(data.airlineId),
          travelStatusId: Value(data.travelStatusId),
          departureLocationId: Value(data.departureLocationId),
          arrivalLocationId: Value(data.arrivalLocationId),
          syncStatus: const Value(1), // 設為待同步
          lastModified: Value(DateTime.now()),
        ),
      );
      return true;
    }
    return false;
  }

  // 刪除飛航記錄（軟刪除）
  Future<bool> deleteFlight(int flightRecordId) async {
    final result =
        await (update(
          flightRecord,
        )..where((f) => f.flightRecordId.equals(flightRecordId))).write(
          FlightRecordCompanion(
            deletedAt: Value(DateTime.now()),
            syncStatus: const Value(1), // 設為待同步
          ),
        );
    return result > 0;
  }

  // 取得飛航記錄的所有經過點（含地點資料與中間表 ID）- 排除已刪除
  Future<List<TransitLocationWithData>> getTransitLocations(
    int flightRecordId,
  ) async {
    final query =
        select(flightTransitLocations).join([
            innerJoin(
              location,
              location.locationId.equalsExp(flightTransitLocations.locationId),
            ),
          ])
          ..where(
            flightTransitLocations.flightRecordId.equals(flightRecordId) &
                flightTransitLocations.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(flightTransitLocations.stopOrder)]);

    final results = await query.get();

    return results.map((row) {
      return TransitLocationWithData(
        transitId: row.readTable(flightTransitLocations).id,
        location: row.readTable(location),
      );
    }).toList();
  }

  // 新增經過點
  Future<int> addTransitLocation(
    int flightRecordId,
    int locationId,
    int stopOrder,
  ) {
    return into(flightTransitLocations).insert(
      FlightTransitLocationsCompanion.insert(
        flightRecordId: flightRecordId,
        locationId: locationId,
        stopOrder: Value(stopOrder),
      ),
    );
  }

  // 刪除經過點 (軟刪除)
  Future<bool> deleteTransitLocation(int transitId) async {
    final result =
        await (update(
          flightTransitLocations,
        )..where((t) => t.id.equals(transitId))).write(
          FlightTransitLocationsCompanion(deletedAt: Value(DateTime.now())),
        );
    return result > 0;
  }

  // 刪除飛航記錄的所有經過點 (軟刪除)
  Future<int> deleteAllTransitLocations(int flightRecordId) async {
    return (update(
      flightTransitLocations,
    )..where((t) => t.flightRecordId.equals(flightRecordId))).write(
      FlightTransitLocationsCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  // 更新經過點順序
  Future<void> updateTransitOrder(int transitId, int newOrder) async {
    await (update(flightTransitLocations)..where((t) => t.id.equals(transitId)))
        .write(FlightTransitLocationsCompanion(stopOrder: Value(newOrder)));
  }

  //  查詢相關

  // 取得完整的飛航記錄（含關聯資料）
  Future<FlightRecordWithDetails?> getFlightWithDetails(
    int flightRecordId,
  ) async {
    final flightData = await (select(
      flightRecord,
    )..where((f) => f.flightRecordId.equals(flightRecordId))).getSingleOrNull();

    if (flightData == null) return null;

    // 透過 db 呼叫 referenceDao (db 是 DatabaseAccessor 提供的屬性)
    final airline = flightData.airlineId != null
        ? await db.referenceDao.getAirlineById(flightData.airlineId!)
        : null;
    final travelStatus = flightData.travelStatusId != null
        ? await db.referenceDao.getTravelStatusById(flightData.travelStatusId!)
        : null;
    final departureLocation = flightData.departureLocationId != null
        ? await db.referenceDao.getLocationById(flightData.departureLocationId!)
        : null;
    final arrivalLocation = flightData.arrivalLocationId != null
        ? await db.referenceDao.getLocationById(flightData.arrivalLocationId!)
        : null;

    // 取得經過點 (使用剛才修正過的 method)
    final transitLocations = await getTransitLocations(flightRecordId);

    return FlightRecordWithDetails(
      flightRecord: flightData,
      airline: airline,
      travelStatus: travelStatus,
      departureLocation: departureLocation,
      arrivalLocation: arrivalLocation,
      transitLocations: transitLocations,
    );
  }
}
