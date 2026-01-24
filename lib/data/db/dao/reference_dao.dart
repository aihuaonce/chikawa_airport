import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/reference_tables.dart';

part 'reference_dao.g.dart';

@DriftAccessor(tables: [Sex, Nationality, Airline, TravelStatus, Location])
class ReferenceDao extends DatabaseAccessor<AppDatabase>
    with _$ReferenceDaoMixin {
  ReferenceDao(super.db);

  // ========== 性別相關 ==========

  /// 取得所有性別選項
  Future<List<SexData>> getAllSex() {
    return select(sex).get();
  }

  /// 根據 ID 取得性別
  Future<SexData?> getSexById(int id) {
    return (select(sex)..where((s) => s.sexId.equals(id))).getSingleOrNull();
  }

  /// 新增性別
  Future<int> addSex(String name) {
    return into(sex).insert(SexCompanion.insert(name: name));
  }

  /// 更新性別
  Future<int> updateSex(int id, String name) {
    return (update(
      sex,
    )..where((s) => s.sexId.equals(id))).write(SexCompanion(name: Value(name)));
  }

  /// 刪除性別
  Future<int> deleteSex(int id) {
    return (delete(sex)..where((s) => s.sexId.equals(id))).go();
  }

  // ========== 國籍相關 ==========

  /// 取得所有國籍選項
  Future<List<NationalityData>> getAllNationality() {
    return (select(
      nationality,
    )..orderBy([(n) => OrderingTerm.asc(n.name)])).get();
  }

  /// 根據 ID 取得國籍
  Future<NationalityData?> getNationalityById(int id) {
    return (select(
      nationality,
    )..where((n) => n.nationalityId.equals(id))).getSingleOrNull();
  }

  /// 根據代碼取得國籍
  Future<NationalityData?> getNationalityByCode(String code) {
    return (select(
      nationality,
    )..where((n) => n.code.equals(code))).getSingleOrNull();
  }

  /// 搜尋國籍 (模糊搜尋名稱)
  Future<List<NationalityData>> searchNationality(String keyword) {
    return (select(nationality)
          ..where((n) => n.name.like('%$keyword%'))
          ..orderBy([(n) => OrderingTerm.asc(n.name)]))
        .get();
  }

  /// 新增國籍
  Future<int> addNationality({required String name, String? code}) {
    return into(
      nationality,
    ).insert(NationalityCompanion.insert(name: name, code: Value(code)));
  }

  /// 批次新增國籍
  Future<void> addNationalityBatch(List<Map<String, String>> nationalityList) {
    return batch((batch) {
      batch.insertAll(
        nationality,
        nationalityList.map(
          (item) => NationalityCompanion.insert(
            name: item['name']!,
            code: Value(item['code']),
          ),
        ),
      );
    });
  }

  /// 更新國籍
  Future<int> updateNationality({required int id, String? name, String? code}) {
    return (update(
      nationality,
    )..where((n) => n.nationalityId.equals(id))).write(
      NationalityCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        code: code != null ? Value(code) : const Value.absent(),
      ),
    );
  }

  /// 刪除國籍
  Future<int> deleteNationality(int id) {
    return (delete(nationality)..where((n) => n.nationalityId.equals(id))).go();
  }

  // ========== 航空公司相關 ==========

  /// 取得所有航空公司選項
  Future<List<AirlineData>> getAllAirline() {
    return (select(airline)..orderBy([(a) => OrderingTerm.asc(a.code)])).get();
  }

  /// 根據 ID 取得航空公司
  Future<AirlineData?> getAirlineById(int id) {
    return (select(
      airline,
    )..where((a) => a.airlineId.equals(id))).getSingleOrNull();
  }

  /// 根據代碼取得航空公司
  Future<AirlineData?> getAirlineByCode(String code) {
    return (select(
      airline,
    )..where((a) => a.code.equals(code))).getSingleOrNull();
  }

  /// 搜尋航空公司 (模糊搜尋名稱或代碼)
  Future<List<AirlineData>> searchAirline(String keyword) {
    return (select(airline)
          ..where((a) => a.name.like('%$keyword%') | a.code.like('%$keyword%'))
          ..orderBy([(a) => OrderingTerm.asc(a.code)]))
        .get();
  }

  /// 新增航空公司
  Future<int> addAirline({required String code, required String name}) {
    return into(
      airline,
    ).insert(AirlineCompanion.insert(code: code, name: name));
  }

  /// 批次新增航空公司
  Future<void> addAirlineBatch(List<Map<String, String>> airlineList) {
    return batch((batch) {
      batch.insertAll(
        airline,
        airlineList.map(
          (item) =>
              AirlineCompanion.insert(code: item['code']!, name: item['name']!),
        ),
      );
    });
  }

  /// 更新航空公司
  Future<int> updateAirline({required int id, String? code, String? name}) {
    return (update(airline)..where((a) => a.airlineId.equals(id))).write(
      AirlineCompanion(
        code: code != null ? Value(code) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
      ),
    );
  }

  /// 刪除航空公司
  Future<int> deleteAirline(int id) {
    return (delete(airline)..where((a) => a.airlineId.equals(id))).go();
  }

  // ========== 旅行狀態相關 ==========

  /// 取得所有旅行狀態選項
  Future<List<TravelStatusData>> getAllTravelStatus() {
    return select(travelStatus).get();
  }

  /// 根據 ID 取得旅行狀態
  Future<TravelStatusData?> getTravelStatusById(int id) {
    return (select(
      travelStatus,
    )..where((t) => t.travelStatusId.equals(id))).getSingleOrNull();
  }

  /// 根據代碼取得旅行狀態
  Future<TravelStatusData?> getTravelStatusByCode(String code) {
    return (select(
      travelStatus,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
  }

  /// 新增旅行狀態
  Future<int> addTravelStatus({required String code, required String name}) {
    return into(
      travelStatus,
    ).insert(TravelStatusCompanion.insert(code: code, name: name));
  }

  /// 批次新增旅行狀態
  Future<void> addTravelStatusBatch(List<Map<String, String>> statusList) {
    return batch((batch) {
      batch.insertAll(
        travelStatus,
        statusList.map(
          (item) => TravelStatusCompanion.insert(
            code: item['code']!,
            name: item['name']!,
          ),
        ),
      );
    });
  }

  /// 更新旅行狀態
  Future<int> updateTravelStatus({
    required int id,
    String? code,
    String? name,
  }) {
    return (update(
      travelStatus,
    )..where((t) => t.travelStatusId.equals(id))).write(
      TravelStatusCompanion(
        code: code != null ? Value(code) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
      ),
    );
  }

  /// 刪除旅行狀態
  Future<int> deleteTravelStatus(int id) {
    return (delete(
      travelStatus,
    )..where((t) => t.travelStatusId.equals(id))).go();
  }

  // ========== 地點相關 ==========

  /// 取得所有地點選項
  Future<List<LocationData>> getAllLocation() {
    return (select(location)..orderBy([(l) => OrderingTerm.asc(l.code)])).get();
  }

  /// 根據 ID 取得地點
  Future<LocationData?> getLocationById(int id) {
    return (select(
      location,
    )..where((l) => l.locationId.equals(id))).getSingleOrNull();
  }

  /// 根據代碼取得地點
  Future<LocationData?> getLocationByCode(String code) {
    return (select(
      location,
    )..where((l) => l.code.equals(code))).getSingleOrNull();
  }

  /// 根據國家代碼取得地點列表
  Future<List<LocationData>> getLocationsByCountryCode(String countryCode) {
    return (select(location)
          ..where((l) => l.countryCode.equals(countryCode))
          ..orderBy([(l) => OrderingTerm.asc(l.code)]))
        .get();
  }

  /// 搜尋地點 (模糊搜尋名稱或代碼)
  Future<List<LocationData>> searchLocation(String keyword) {
    return (select(location)
          ..where((l) => l.name.like('%$keyword%') | l.code.like('%$keyword%'))
          ..orderBy([(l) => OrderingTerm.asc(l.code)]))
        .get();
  }

  /// 新增地點
  Future<int> addLocation({
    required String code,
    required String name,
    required String countryCode,
  }) {
    return into(location).insert(
      LocationCompanion.insert(
        code: code,
        name: name,
        countryCode: countryCode,
      ),
    );
  }

  /// 批次新增地點
  Future<void> addLocationBatch(List<Map<String, String>> locationList) {
    return batch((batch) {
      batch.insertAll(
        location,
        locationList.map(
          (item) => LocationCompanion.insert(
            code: item['code']!,
            name: item['name']!,
            countryCode: item['countryCode']!,
          ),
        ),
      );
    });
  }

  /// 更新地點
  Future<int> updateLocation({
    required int id,
    String? code,
    String? name,
    String? countryCode,
  }) {
    return (update(location)..where((l) => l.locationId.equals(id))).write(
      LocationCompanion(
        code: code != null ? Value(code) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
        countryCode: countryCode != null
            ? Value(countryCode)
            : const Value.absent(),
      ),
    );
  }

  /// 刪除地點
  Future<int> deleteLocation(int id) {
    return (delete(location)..where((l) => l.locationId.equals(id))).go();
  }

  // ========== 初始化參考資料 ==========

  /// 初始化所有參考資料
  Future<void> initializeAllReferenceData() async {
    await initializeSex();
    await initializeNationality();
    await initializeAirline();
    await initializeTravelStatus();
    await initializeLocation();
  }

  /// 初始化性別資料
  Future<void> initializeSex() async {
    final count = await (select(sex).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(sex, [
          SexCompanion.insert(name: 'Male'),
          SexCompanion.insert(name: 'Female'),
          SexCompanion.insert(name: 'Other'),
        ]);
      });
    }
  }

  /// 初始化國籍資料
  Future<void> initializeNationality() async {
    final count = await (select(nationality).get()).then((list) => list.length);
    if (count == 0) {
      await addNationalityBatch([
        {'name': 'Taiwan', 'code': 'TW'},
        {'name': 'China', 'code': 'CN'},
        {'name': 'Hong Kong', 'code': 'HK'},
        {'name': 'Macau', 'code': 'MO'},
        {'name': 'Japan', 'code': 'JP'},
        {'name': 'South Korea', 'code': 'KR'},
        {'name': 'United States', 'code': 'US'},
        {'name': 'United Kingdom', 'code': 'GB'},
        {'name': 'Canada', 'code': 'CA'},
        {'name': 'Australia', 'code': 'AU'},
        {'name': 'Singapore', 'code': 'SG'},
        {'name': 'Malaysia', 'code': 'MY'},
        {'name': 'Thailand', 'code': 'TH'},
        {'name': 'Vietnam', 'code': 'VN'},
        {'name': 'Philippines', 'code': 'PH'},
        {'name': 'Indonesia', 'code': 'ID'},
        {'name': 'India', 'code': 'IN'},
        {'name': 'France', 'code': 'FR'},
        {'name': 'Germany', 'code': 'DE'},
        {'name': 'Italy', 'code': 'IT'},
        {'name': 'Spain', 'code': 'ES'},
        {'name': 'Netherlands', 'code': 'NL'},
        {'name': 'Switzerland', 'code': 'CH'},
        {'name': 'New Zealand', 'code': 'NZ'},
        {'name': 'Brazil', 'code': 'BR'},
      ]);
    }
  }

  /// 初始化航空公司資料
  Future<void> initializeAirline() async {
    final count = await (select(airline).get()).then((list) => list.length);
    if (count == 0) {
      await addAirlineBatch([
        {'code': 'BR', 'name': 'BR長榮航空'},
        {'code': 'CI', 'name': 'CI中華航空'},
        {'code': 'CX', 'name': 'CX國泰航空'},
        {'code': 'UA', 'name': 'UA聯合航空'},
        {'code': 'KL', 'name': 'KL荷蘭皇家航空'},
        {'code': 'CZ', 'name': 'CZ中國南方航空'},
        {'code': 'IT', 'name': 'IT台灣虎航'},
        {'code': 'EK', 'name': 'EK阿聯酋航空'},
        {'code': 'CA', 'name': 'CA中國國際航空'},
      ]);
    }
  }

  /// 初始化旅行狀態資料
  Future<void> initializeTravelStatus() async {
    final count = await (select(
      travelStatus,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await addTravelStatusBatch([
        {'code': 'DEPARTURE', 'name': '出境'},
        {'code': 'ARRIVAL', 'name': '入境'},
        {'code': 'TRANSIT', 'name': '過境'},
        {'code': 'TRANSFER', 'name': '轉機'},
        {'code': 'FORCED_LANDING', 'name': '迫降'},
        {'code': 'DIVERSION', 'name': '轉降'},
        {'code': 'STANDBY', 'name': '備降'},
        {'code': 'TECHNICAL_LANDING', 'name': '技術性降落'},
        {'code': 'OTHER', 'name': '其他'},
      ]);
    }
  }

  /// 初始化地點資料
  Future<void> initializeLocation() async {
    final count = await (select(location).get()).then((list) => list.length);
    if (count == 0) {
      await addLocationBatch([
        {'code': 'TPE', 'name': '台北桃園', 'countryCode': 'TW'},
        {'code': 'TSA', 'name': '台北松山', 'countryCode': 'TW'},
        {'code': 'KHH', 'name': '高雄小港', 'countryCode': 'TW'},
        {'code': 'RMQ', 'name': '台中清泉崗', 'countryCode': 'TW'},
        {'code': 'NRT', 'name': '東京成田', 'countryCode': 'JP'},
        {'code': 'HND', 'name': '東京羽田', 'countryCode': 'JP'},
        {'code': 'KIX', 'name': '大阪關西', 'countryCode': 'JP'},
        {'code': 'ICN', 'name': '首爾仁川', 'countryCode': 'KR'},
        {'code': 'HKG', 'name': '香港', 'countryCode': 'HK'},
        {'code': 'SIN', 'name': '新加坡', 'countryCode': 'SG'},
        {'code': 'BKK', 'name': '曼谷', 'countryCode': 'TH'},
        {'code': 'SFO', 'name': '舊金山', 'countryCode': 'US'},
        {'code': 'LAX', 'name': '洛杉磯', 'countryCode': 'US'},
        {'code': 'LHR', 'name': '倫敦希斯洛', 'countryCode': 'GB'},
        {'code': 'CDG', 'name': '巴黎戴高樂', 'countryCode': 'FR'},
      ]);
    }
  }

  // ========== 統計相關 ==========

  /// 取得參考表統計資訊
  Future<ReferenceStatistics> getStatistics() async {
    final sexCount = await (select(sex).get()).then((list) => list.length);
    final nationalityCount = await (select(
      nationality,
    ).get()).then((list) => list.length);
    final airlineCount = await (select(
      airline,
    ).get()).then((list) => list.length);
    final travelStatusCount = await (select(
      travelStatus,
    ).get()).then((list) => list.length);
    final locationCount = await (select(
      location,
    ).get()).then((list) => list.length);

    return ReferenceStatistics(
      sexCount: sexCount,
      nationalityCount: nationalityCount,
      airlineCount: airlineCount,
      travelStatusCount: travelStatusCount,
      locationCount: locationCount,
    );
  }

  /// 檢查參考資料是否已初始化
  Future<bool> isInitialized() async {
    final stats = await getStatistics();
    return stats.sexCount > 0 &&
        stats.nationalityCount > 0 &&
        stats.airlineCount > 0 &&
        stats.travelStatusCount > 0 &&
        stats.locationCount > 0;
  }
}

// ========== 資料模型 ==========

/// 參考表統計資訊
class ReferenceStatistics {
  final int sexCount;
  final int nationalityCount;
  final int airlineCount;
  final int travelStatusCount;
  final int locationCount;

  ReferenceStatistics({
    required this.sexCount,
    required this.nationalityCount,
    required this.airlineCount,
    required this.travelStatusCount,
    required this.locationCount,
  });

  @override
  String toString() {
    return 'ReferenceStatistics('
        'sex: $sexCount, '
        'nationality: $nationalityCount, '
        'airline: $airlineCount, '
        'travelStatus: $travelStatusCount, '
        'location: $locationCount'
        ')';
  }
}
