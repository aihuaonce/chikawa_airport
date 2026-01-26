import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/reference_tables.dart';

part 'reference_dao.g.dart';

@DriftAccessor(
  tables: [
    Sex,
    Nationality,
    Airline,
    TravelStatus,
    Location,
    IncidentPlaceCategory,
    IncidentPlaceCategory2,
    ReportingUnit,
  ],
)
class ReferenceDao extends DatabaseAccessor<AppDatabase>
    with _$ReferenceDaoMixin {
  ReferenceDao(super.db);

  //  性別相關

  // 取得所有性別選項
  Future<List<SexData>> getAllSex() {
    return select(sex).get();
  }

  // 根據 ID 取得性別
  Future<SexData?> getSexById(int id) {
    return (select(sex)..where((s) => s.sexId.equals(id))).getSingleOrNull();
  }

  // 新增性別
  Future<int> addSex(String name) {
    return into(sex).insert(SexCompanion.insert(name: name));
  }

  // 更新性別
  Future<int> updateSex(int id, String name) {
    return (update(
      sex,
    )..where((s) => s.sexId.equals(id))).write(SexCompanion(name: Value(name)));
  }

  // 刪除性別
  Future<int> deleteSex(int id) {
    return (delete(sex)..where((s) => s.sexId.equals(id))).go();
  }

  //  國籍相關

  // 取得所有國籍選項
  Future<List<NationalityData>> getAllNationality() {
    return (select(
      nationality,
    )..orderBy([(n) => OrderingTerm.asc(n.name)])).get();
  }

  // 根據 ID 取得國籍
  Future<NationalityData?> getNationalityById(int id) {
    return (select(
      nationality,
    )..where((n) => n.nationalityId.equals(id))).getSingleOrNull();
  }

  // 根據代碼取得國籍
  Future<NationalityData?> getNationalityByCode(String code) {
    return (select(
      nationality,
    )..where((n) => n.code.equals(code))).getSingleOrNull();
  }

  // 搜尋國籍 (模糊搜尋名稱)
  Future<List<NationalityData>> searchNationality(String keyword) {
    return (select(nationality)
          ..where((n) => n.name.like('%$keyword%'))
          ..orderBy([(n) => OrderingTerm.asc(n.name)]))
        .get();
  }

  // 新增國籍
  Future<int> addNationality({required String name, String? code}) {
    return into(
      nationality,
    ).insert(NationalityCompanion.insert(name: name, code: Value(code)));
  }

  // 批次新增國籍
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

  // 更新國籍
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

  // 刪除國籍
  Future<int> deleteNationality(int id) {
    return (delete(nationality)..where((n) => n.nationalityId.equals(id))).go();
  }

  //  航空公司相關

  // 取得所有航空公司選項
  Future<List<AirlineData>> getAllAirline() {
    return (select(airline)..orderBy([(a) => OrderingTerm.asc(a.code)])).get();
  }

  // 根據 ID 取得航空公司
  Future<AirlineData?> getAirlineById(int id) {
    return (select(
      airline,
    )..where((a) => a.airlineId.equals(id))).getSingleOrNull();
  }

  // 根據代碼取得航空公司
  Future<AirlineData?> getAirlineByCode(String code) {
    return (select(
      airline,
    )..where((a) => a.code.equals(code))).getSingleOrNull();
  }

  // 搜尋航空公司 (模糊搜尋名稱或代碼)
  Future<List<AirlineData>> searchAirline(String keyword) {
    return (select(airline)
          ..where((a) => a.name.like('%$keyword%') | a.code.like('%$keyword%'))
          ..orderBy([(a) => OrderingTerm.asc(a.code)]))
        .get();
  }

  // 新增航空公司
  Future<int> addAirline({required String code, required String name}) {
    return into(
      airline,
    ).insert(AirlineCompanion.insert(code: code, name: name));
  }

  // 批次新增航空公司
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

  // 更新航空公司
  Future<int> updateAirline({required int id, String? code, String? name}) {
    return (update(airline)..where((a) => a.airlineId.equals(id))).write(
      AirlineCompanion(
        code: code != null ? Value(code) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
      ),
    );
  }

  // 刪除航空公司
  Future<int> deleteAirline(int id) {
    return (delete(airline)..where((a) => a.airlineId.equals(id))).go();
  }

  //  旅行狀態相關

  // 取得所有旅行狀態選項
  Future<List<TravelStatusData>> getAllTravelStatus() {
    return select(travelStatus).get();
  }

  // 根據 ID 取得旅行狀態
  Future<TravelStatusData?> getTravelStatusById(int id) {
    return (select(
      travelStatus,
    )..where((t) => t.travelStatusId.equals(id))).getSingleOrNull();
  }

  // 根據代碼取得旅行狀態
  Future<TravelStatusData?> getTravelStatusByCode(String code) {
    return (select(
      travelStatus,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
  }

  // 新增旅行狀態
  Future<int> addTravelStatus({required String code, required String name}) {
    return into(
      travelStatus,
    ).insert(TravelStatusCompanion.insert(code: code, name: name));
  }

  // 批次新增旅行狀態
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

  // 更新旅行狀態
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

  // 刪除旅行狀態
  Future<int> deleteTravelStatus(int id) {
    return (delete(
      travelStatus,
    )..where((t) => t.travelStatusId.equals(id))).go();
  }

  //  地點相關

  // 取得所有地點選項
  Future<List<LocationData>> getAllLocation() {
    return (select(location)..orderBy([(l) => OrderingTerm.asc(l.code)])).get();
  }

  // 根據 ID 取得地點
  Future<LocationData?> getLocationById(int id) {
    return (select(
      location,
    )..where((l) => l.locationId.equals(id))).getSingleOrNull();
  }

  // 根據代碼取得地點
  Future<LocationData?> getLocationByCode(String code) {
    return (select(
      location,
    )..where((l) => l.code.equals(code))).getSingleOrNull();
  }

  // 根據國家代碼取得地點列表
  Future<List<LocationData>> getLocationsByCountryCode(String countryCode) {
    return (select(location)
          ..where((l) => l.countryCode.equals(countryCode))
          ..orderBy([(l) => OrderingTerm.asc(l.code)]))
        .get();
  }

  // 搜尋地點 (模糊搜尋名稱或代碼)
  Future<List<LocationData>> searchLocation(String keyword) {
    return (select(location)
          ..where((l) => l.name.like('%$keyword%') | l.code.like('%$keyword%'))
          ..orderBy([(l) => OrderingTerm.asc(l.code)]))
        .get();
  }

  // 新增地點
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

  // 批次新增地點
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

  // 更新地點
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

  // 刪除地點
  Future<int> deleteLocation(int id) {
    return (delete(location)..where((l) => l.locationId.equals(id))).go();
  }

  //  事故-一級地點分類相關 (IncidentPlaceCategory)

  // 取得所有一級地點分類 (依排序號碼)
  Future<List<IncidentPlaceCategoryData>> getAllIncidentPlaceCategories({
    bool onlyActive = false,
  }) {
    final query = select(incidentPlaceCategory);
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }
    return (query..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  }

  // 根據 ID 取得一級地點分類
  Future<IncidentPlaceCategoryData?> getIncidentPlaceCategoryById(int id) {
    return (select(
      incidentPlaceCategory,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // 新增一級地點
  Future<int> addIncidentPlaceCategory(String name, {int sortOrder = 0}) {
    return into(incidentPlaceCategory).insert(
      IncidentPlaceCategoryCompanion.insert(
        name: name,
        sortOrder: Value(sortOrder),
      ),
    );
  }

  // 更新一級地點
  Future<bool> updateIncidentPlaceCategory(IncidentPlaceCategoryData data) {
    return update(incidentPlaceCategory).replace(data);
  }

  // 刪除一級地點
  Future<int> deleteIncidentPlaceCategory(int id) {
    return (delete(incidentPlaceCategory)..where((t) => t.id.equals(id))).go();
  }

  //  事故-二級地點分類相關 (IncidentPlaceCategory2)

  // 根據一級地點 ID 取得所屬的二級地點
  Future<List<IncidentPlaceCategory2Data>> getIncidentPlaceCategory2ByParent(
    int categoryId, {
    bool onlyActive = false,
  }) {
    final query = select(incidentPlaceCategory2)
      ..where((t) => t.categoryId.equals(categoryId));
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }
    return (query..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  }

  // 根據 ID 取得二級地點分類
  Future<IncidentPlaceCategory2Data?> getIncidentPlaceCategory2ById(int id) {
    return (select(
      incidentPlaceCategory2,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // 新增二級地點
  Future<int> addIncidentPlaceCategory2(
    int categoryId,
    String name, {
    int sortOrder = 0,
  }) {
    return into(incidentPlaceCategory2).insert(
      IncidentPlaceCategory2Companion.insert(
        categoryId: categoryId,
        name: name,
        sortOrder: Value(sortOrder),
      ),
    );
  }

  //  事故通報單位相關 (ReportingUnit)

  // 取得所有通報單位
  Future<List<ReportingUnitData>> getAllReportingUnits({
    bool onlyActive = false,
  }) {
    final query = select(reportingUnit);
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }
    return query.get();
  }

  // 根據 ID 取得通報單位
  Future<ReportingUnitData?> getReportingUnitById(int id) {
    return (select(
      reportingUnit,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // 新增通報單位
  Future<int> addReportingUnit(String name, {String? description}) {
    return into(reportingUnit).insert(
      ReportingUnitCompanion.insert(
        name: name,
        description: Value(description),
      ),
    );
  }

  //  初始化參考資料
  // 初始化所有參考資料
  Future<void> initializeAllReferenceData() async {
    await initializeSex();
    await initializeNationality();
    await initializeAirline();
    await initializeTravelStatus();
    await initializeLocation();
    await initializeIncidentPlaces();
    await initializeReportingUnits();
  }

  // 初始化性別資料
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

  // 初始化國籍資料
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

  // 初始化航空公司資料
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

  // 初始化旅行狀態資料
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

  // 初始化地點資料
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

  Future<void> initializeIncidentPlaces() async {
    // 先检查是否已有资料
    final existingCategories = await select(incidentPlaceCategory).get();

    if (existingCategories.isEmpty) {
      // 定义主分类
      const mainCategories = [
        '第一航廈',
        '第二航廈',
        '遠端機坪',
        '貨運站/機坪其他',
        '諾富特飯店',
        '飛機機艙內',
      ];

      // 批量插入主分类
      final categoryIds = <String, int>{};
      for (var i = 0; i < mainCategories.length; i++) {
        final id = await addIncidentPlaceCategory(
          mainCategories[i],
          sortOrder: i + 1,
        );
        categoryIds[mainCategories[i]] = id;
      }

      // 定义子分类数据
      final subCategories = <Map<String, dynamic>>[
        //  第一航廈
        {'name': '出境查驗台', 'parent': '第一航廈', 'sortOrder': 1},
        {'name': '入境查驗台', 'parent': '第一航廈', 'sortOrder': 2},
        {'name': '貴賓室', 'parent': '第一航廈', 'sortOrder': 3},
        {'name': '出境大廳(管制區外)', 'parent': '第一航廈', 'sortOrder': 4},
        {'name': '出境層(管制區內)', 'parent': '第一航廈', 'sortOrder': 5},
        {'name': '入境大廳(管制區外)', 'parent': '第一航廈', 'sortOrder': 6},
        {'name': '入境層(管制區內)', 'parent': '第一航廈', 'sortOrder': 7},
        {'name': '美食街', 'parent': '第一航廈', 'sortOrder': 8},
        {'name': '航警局', 'parent': '第一航廈', 'sortOrder': 9},
        {'name': '機場捷運', 'parent': '第一航廈', 'sortOrder': 10},
        {'name': '1號停車場', 'parent': '第一航廈', 'sortOrder': 11},
        {'name': '2號停車場', 'parent': '第一航廈', 'sortOrder': 12},
        {'name': '出境巴士下車處', 'parent': '第一航廈', 'sortOrder': 13},
        {'name': '入境巴士上車處', 'parent': '第一航廈', 'sortOrder': 14},
        {'name': '出境安檢', 'parent': '第一航廈', 'sortOrder': 15},
        {'name': '行李轉盤', 'parent': '第一航廈', 'sortOrder': 16},
        {'name': '海關處', 'parent': '第一航廈', 'sortOrder': 17},
        // 登機門 A
        for (var i = 1; i <= 9; i++)
          {'name': '登機門A$i', 'parent': '第一航廈', 'sortOrder': 17 + i},
        // A、B 轉機櫃檯/安檢
        {'name': 'A區轉機櫃檯', 'parent': '第一航廈', 'sortOrder': 27},
        {'name': 'B區轉機櫃檯', 'parent': '第一航廈', 'sortOrder': 28},
        {'name': 'A區轉機安檢', 'parent': '第一航廈', 'sortOrder': 29},
        {'name': 'B區轉機安檢', 'parent': '第一航廈', 'sortOrder': 30},
        {'name': '航廈電車(管制區內)', 'parent': '第一航廈', 'sortOrder': 31},
        {'name': '航廈電車(管制區外)', 'parent': '第一航廈', 'sortOrder': 32},
        {'name': '其他位置', 'parent': '第一航廈', 'sortOrder': 33},
        // 登機門 B
        for (var i = 1; i <= 9; i++)
          {'name': '登機門B$i', 'parent': '第一航廈', 'sortOrder': 33 + i},
        {'name': '登機門B1R', 'parent': '第一航廈', 'sortOrder': 43},

        //  第二航廈
        {'name': '出境查驗台', 'parent': '第二航廈', 'sortOrder': 1},
        {'name': '入境查驗台', 'parent': '第二航廈', 'sortOrder': 2},
        {'name': '貴賓室', 'parent': '第二航廈', 'sortOrder': 3},
        {'name': '出境大廳(管制區外)', 'parent': '第二航廈', 'sortOrder': 4},
        {'name': '出境層(管制區內)', 'parent': '第二航廈', 'sortOrder': 5},
        {'name': '入境大廳(管制區外)', 'parent': '第二航廈', 'sortOrder': 6},
        {'name': '入境層(管制區內)', 'parent': '第二航廈', 'sortOrder': 7},
        {'name': '美食廣場', 'parent': '第二航廈', 'sortOrder': 8},
        {'name': '航警局', 'parent': '第二航廈', 'sortOrder': 9},
        {'name': '機場捷運', 'parent': '第二航廈', 'sortOrder': 10},
        {'name': '3號停車場', 'parent': '第二航廈', 'sortOrder': 11},
        {'name': '4號停車場', 'parent': '第二航廈', 'sortOrder': 12},
        {'name': '北側觀景台', 'parent': '第二航廈', 'sortOrder': 13},
        {'name': '南側觀景台', 'parent': '第二航廈', 'sortOrder': 14},
        {'name': '北揚5樓', 'parent': '第二航廈', 'sortOrder': 15},
        {'name': '南側5樓', 'parent': '第二航廈', 'sortOrder': 16},
        // 登機門 D
        for (var i = 1; i <= 10; i++)
          {'name': '登機門D$i', 'parent': '第二航廈', 'sortOrder': 16 + i},
        // 登機門 C
        for (var i = 1; i <= 9; i++)
          {'name': '登機門C$i', 'parent': '第二航廈', 'sortOrder': 26 + i},
        {'name': 'C區轉機櫃檯', 'parent': '第二航廈', 'sortOrder': 36},
        {'name': 'C區轉機安檢', 'parent': '第二航廈', 'sortOrder': 37},
        {'name': '航廈電車(管制區內)', 'parent': '第二航廈', 'sortOrder': 38},
        {'name': '航廈電車(管制區外)', 'parent': '第二航廈', 'sortOrder': 39},
        {'name': '其他位置', 'parent': '第二航廈', 'sortOrder': 40},
        {'name': '登機門C5R', 'parent': '第二航廈', 'sortOrder': 41},

        //  遠端機坪
        for (var i = 601; i <= 615; i++)
          {'name': '$i', 'parent': '遠端機坪', 'sortOrder': i - 600},

        //  貨運站/機坪其他
        {'name': '滑行道', 'parent': '貨運站/機坪其他', 'sortOrder': 1},
        for (var i = 501; i <= 515; i++)
          {'name': '$i', 'parent': '貨運站/機坪其他', 'sortOrder': i - 500},
        {'name': '台飛棚廠', 'parent': '貨運站/機坪其他', 'sortOrder': 13},
        {'name': '維修停機坪', 'parent': '貨運站/機坪其他', 'sortOrder': 14},
        {'name': '長榮航太', 'parent': '貨運站/機坪其他', 'sortOrder': 15},
        {'name': '機坪其他位置', 'parent': '貨運站/機坪其他', 'sortOrder': 16},

        //  諾富特飯店
        {'name': '諾富特飯店', 'parent': '諾富特飯店', 'sortOrder': 1},

        //  飛機機艙內
        {'name': '飛機機艙內', 'parent': '飛機機艙內', 'sortOrder': 1},
      ];

      // 批量插入子分类
      await batch((batch) {
        batch.insertAll(
          incidentPlaceCategory2,
          subCategories
              .map(
                (c) => IncidentPlaceCategory2Companion.insert(
                  categoryId: categoryIds[c['parent']]!,
                  name: c['name'] as String,
                  sortOrder: Value(c['sortOrder'] as int),
                ),
              )
              .toList(),
        );
      });
    }
  }

  // 初始化通報單位
  Future<void> initializeReportingUnits() async {
    final count = await (select(
      reportingUnit,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(reportingUnit, [
          ReportingUnitCompanion.insert(name: '航空公司機組人員'),
          ReportingUnitCompanion.insert(name: '機場醫務室'),
          ReportingUnitCompanion.insert(name: '檢疫局'),
          ReportingUnitCompanion.insert(name: '航空公司地勤'),
          ReportingUnitCompanion.insert(name: '其他'),
        ]);
      });
    }
  }

  //  統計相關

  // 取得參考表統計資訊
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
    final incidentPlaceCount = await (select(
      incidentPlaceCategory,
    ).get()).then((list) => list.length);
    final reportingUnitCount = await (select(
      reportingUnit,
    ).get()).then((list) => list.length);

    return ReferenceStatistics(
      sexCount: sexCount,
      nationalityCount: nationalityCount,
      airlineCount: airlineCount,
      travelStatusCount: travelStatusCount,
      locationCount: locationCount,
      incidentPlaceCount: incidentPlaceCount,
      reportingUnitCount: reportingUnitCount,
    );
  }

  // 檢查參考資料是否已初始化
  Future<bool> isInitialized() async {
    final stats = await getStatistics();
    return stats.sexCount > 0 &&
        stats.nationalityCount > 0 &&
        stats.airlineCount > 0 &&
        stats.travelStatusCount > 0 &&
        stats.locationCount > 0 &&
        stats.incidentPlaceCount > 0 &&
        stats.reportingUnitCount > 0;
  }
}

//  資料模型

// 參考表統計資訊
class ReferenceStatistics {
  final int sexCount;
  final int nationalityCount;
  final int airlineCount;
  final int travelStatusCount;
  final int locationCount;
  final int incidentPlaceCount;
  final int reportingUnitCount;

  ReferenceStatistics({
    required this.sexCount,
    required this.nationalityCount,
    required this.airlineCount,
    required this.travelStatusCount,
    required this.locationCount,
    required this.incidentPlaceCount,
    required this.reportingUnitCount,
  });

  @override
  String toString() {
    return 'ReferenceStatistics('
        'sex: $sexCount, '
        'nationality: $nationalityCount, '
        'airline: $airlineCount, '
        'travelStatus: $travelStatusCount, '
        'location: $locationCount, '
        'incidentPlace: $incidentPlaceCount, '
        'reportingUnit: $reportingUnitCount'
        ')';
  }
}
