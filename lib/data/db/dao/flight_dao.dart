import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';
import '../tables/reference_tables.dart';

part 'flight_dao.g.dart';

@DriftAccessor(tables: [FlightRecord, FlightTransitLocations, Location])
class FlightDao extends DatabaseAccessor<AppDatabase> with _$FlightDaoMixin {
  FlightDao(super.db);

  // ========== 飛航記錄相關 ==========

  /// 根據 medicalId 取得飛航記錄
  Future<FlightRecordData?> getFlightByMedicalId(int medicalId) {
    return (select(flightRecord)
          ..where((f) => f.medicalId.equals(medicalId)))
        .getSingleOrNull();
  }

  /// 建立新的飛航記錄
  Future<int> createFlightRecord({
    required int medicalId,
    required int airlineId,
    required String flightNumber,
    required int travelStatusId,
    required int departureLocationId,
    required int arrivalLocationId,
  }) {
    return into(flightRecord).insert(
      FlightRecordCompanion.insert(
        medicalId: medicalId,
        airlineId: airlineId,
        flightNumber: flightNumber,
        travelStatusId: travelStatusId,
        departureLocationId: departureLocationId,
        arrivalLocationId: arrivalLocationId,
      ),
    );
  }

  /// 更新飛航記錄
  Future<bool> updateFlight(FlightRecordData data) {
    return update(flightRecord).replace(data);
  }

  /// 刪除飛航記錄
  Future<int> deleteFlight(int flightRecordId) {
    return (delete(flightRecord)
          ..where((f) => f.flightRecordId.equals(flightRecordId)))
        .go();
  }

  // ========== 經過點相關 ==========

  /// 取得飛航記錄的所有經過點（含地點資料）
  Future<List<LocationData>> getTransitLocations(int flightRecordId) async {
    final query = select(flightTransitLocations).join([
      innerJoin(
        location,
        location.locationId.equalsExp(flightTransitLocations.locationId),
      ),
    ])
      ..where(flightTransitLocations.flightRecordId.equals(flightRecordId))
      ..orderBy([OrderingTerm.asc(flightTransitLocations.stopOrder)]);

    final results = await query.get();
    return results.map((row) => row.readTable(location)).toList();
  }

  /// 新增經過點
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

  /// 刪除經過點
  Future<int> deleteTransitLocation(int transitId) {
    return (delete(flightTransitLocations)
          ..where((t) => t.id.equals(transitId)))
        .go();
  }

  /// 刪除飛航記錄的所有經過點
  Future<int> deleteAllTransitLocations(int flightRecordId) {
    return (delete(flightTransitLocations)
          ..where((t) => t.flightRecordId.equals(flightRecordId)))
        .go();
  }

  /// 更新經過點順序
  Future<void> updateTransitOrder(int transitId, int newOrder) async {
    await (update(flightTransitLocations)
          ..where((t) => t.id.equals(transitId)))
        .write(FlightTransitLocationsCompanion(stopOrder: Value(newOrder)));
  }

  // ========== 查詢相關 ==========

  /// 取得完整的飛航記錄（含關聯資料）
  Future<FlightRecordWithDetails?> getFlightWithDetails(
    int flightRecordId,
  ) async {
    final flightData = await (select(flightRecord)
          ..where((f) => f.flightRecordId.equals(flightRecordId)))
        .getSingleOrNull();

    if (flightData == null) return null;

    // 取得航空公司
    final airline = await db.referenceDao.getAirlineById(flightData.airlineId);

    // 取得旅行狀態
    final travelStatus = await db.referenceDao.getTravelStatusById(
      flightData.travelStatusId,
    );

    // 取得啟程地
    final departureLocation = await db.referenceDao.getLocationById(
      flightData.departureLocationId,
    );

    // 取得目的地
    final arrivalLocation = await db.referenceDao.getLocationById(
      flightData.arrivalLocationId,
    );

    // 取得經過點
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

// ========== 資料模型 ==========

/// 完整飛航記錄（含關聯資料）
class FlightRecordWithDetails {
  final FlightRecordData flightRecord;
  final AirlineData? airline;
  final TravelStatusData? travelStatus;
  final LocationData? departureLocation;
  final LocationData? arrivalLocation;
  final List<LocationData> transitLocations;

  FlightRecordWithDetails({
    required this.flightRecord,
    this.airline,
    this.travelStatus,
    this.departureLocation,
    this.arrivalLocation,
    required this.transitLocations,
  });
}