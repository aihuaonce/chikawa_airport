import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/reference_tables.dart';
import '../tables/normalization_tables.dart';

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
    ChiefComplaintType,
    ChiefComplaintDetail,
    DiagnosisCategory,
    TriageLevel,
    TreatmentOnSite,
    TreatmentResult,
    ReferralHospital,
    ActionItem,
    MedicalStaff,
    SpecialNoteRef,
    NursingPhrase,
    PaymentMethod,
    CollectionStatus,
    CurrencyRef,
    ReferralPurpose,
    StationRef,
    RelationshipType,
    HistoryStatusRef,
    MedicalStaffRole,
    PupilReactionRef,
    ConsciousnessLevelRef,
    DrugRef,
  ],
)
class ReferenceDao extends DatabaseAccessor<AppDatabase>
    with _$ReferenceDaoMixin {
  ReferenceDao(super.db);

  //  藥物相關
  Future<List<DrugRefData>> getAllDrugs({bool onlyActive = true}) {
    final query = select(drugRef);
    if (onlyActive) {
      query.where((d) => d.isActive.equals(true));
    }
    return (query..orderBy([(d) => OrderingTerm.asc(d.sortOrder)])).get();
  }

  Future<List<DrugRefData>> searchDrugs(String keyword) {
    return (select(drugRef)
          ..where((d) => d.name.like('%$keyword%'))
          ..where((d) => d.isActive.equals(true))
          ..orderBy([(d) => OrderingTerm.asc(d.sortOrder)]))
        .get();
  }

  Future<int> addDrug({
    required String category,
    required String name,
    int sortOrder = 0,
  }) {
    return into(drugRef).insert(
      DrugRefCompanion.insert(
        category: category,
        name: name,
        sortOrder: Value(sortOrder),
      ),
    );
  }

  //  護理常用語相關
  Future<List<NursingPhraseData>> getAllNursingPhrases({
    bool onlyActive = true,
  }) {
    final query = select(nursingPhrase);
    if (onlyActive) {
      query.where((n) => n.isActive.equals(true));
    }
    return (query..orderBy([(n) => OrderingTerm.asc(n.sortOrder)])).get();
  }

  Future<void> addNursingPhraseBatch(
    List<Map<String, dynamic>> phraseList,
  ) async {
    await batch((batch) {
      batch.insertAll(
        nursingPhrase,
        phraseList.map(
          (item) => NursingPhraseCompanion.insert(
            title: item['title'] as String,
            content: item['content'] as String,
            sortOrder: Value(item['sortOrder'] as int),
          ),
        ),
      );
    });
  }

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

  // 搜尋國籍 (模糊搜尋名稱)
  Future<List<NationalityData>> searchNationality(String keyword) {
    return (select(nationality)
          ..where(
            (n) => n.name.like('%$keyword%') | n.nameEn.like('%$keyword%'),
          )
          ..orderBy([(n) => OrderingTerm.asc(n.name)]))
        .get();
  }

  // 新增國籍
  Future<int> addNationality({required String name, String? nameEn}) {
    return into(
      nationality,
    ).insert(NationalityCompanion.insert(name: name, nameEn: Value(nameEn)));
  }

  // 批次新增國籍
  Future<void> addNationalityBatch(List<Map<String, String>> nationalityList) {
    return batch((batch) {
      batch.insertAll(
        nationality,
        nationalityList.map(
          (item) => NationalityCompanion.insert(
            name: item['name']!,
            nameEn: Value(item['nameEn']),
          ),
        ),
      );
    });
  }

  // 更新國籍
  Future<int> updateNationality({
    required int id,
    String? name,
    String? nameEn,
  }) {
    return (update(
      nationality,
    )..where((n) => n.nationalityId.equals(id))).write(
      NationalityCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        nameEn: nameEn != null ? Value(nameEn) : const Value.absent(),
      ),
    );
  }

  // 刪除國籍
  Future<int> deleteNationality(int id) {
    return (delete(nationality)..where((n) => n.nationalityId.equals(id))).go();
  }

  //  航空公司相關

  // 取得所有航空公司選項
  Future<List<AirlineData>> getAllAirline({bool? isOther}) {
    final query = select(airline);
    if (isOther != null) {
      query.where((a) => a.isOther.equals(isOther));
    }
    return (query..orderBy([(a) => OrderingTerm.asc(a.code)])).get();
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
  Future<List<AirlineData>> searchAirline(String keyword, {bool? isOther}) {
    final query = select(airline)
      ..where((a) => a.name.like('%$keyword%') | a.code.like('%$keyword%'));

    if (isOther != null) {
      query.where((a) => a.isOther.equals(isOther));
    }

    return (query..orderBy([(a) => OrderingTerm.asc(a.code)])).get();
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

  // 搜尋地點 (模糊搜尋名稱或代碼)
  Future<List<LocationData>> searchLocation(String keyword) {
    return (select(location)
          ..where((l) => l.name.like('%$keyword%') | l.code.like('%$keyword%'))
          ..orderBy([(l) => OrderingTerm.asc(l.code)]))
        .get();
  }

  // 新增地點
  Future<int> addLocation({required String code, required String name}) {
    return into(
      location,
    ).insert(LocationCompanion.insert(code: code, name: name));
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
          ),
        ),
      );
    });
  }

  // 更新地點
  Future<int> updateLocation({required int id, String? code, String? name}) {
    return (update(location)..where((l) => l.locationId.equals(id))).write(
      LocationCompanion(
        code: code != null ? Value(code) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
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

  // 主訴類型
  Future<List<ChiefComplaintTypeData>> getAllChiefComplaintTypes({
    bool onlyActive = true,
  }) {
    final query = select(chiefComplaintType);
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }
    return query.get();
  }

  // 主訴細項 (根據類型ID)
  Future<List<ChiefComplaintDetailData>> getChiefComplaintDetailsByType(
    int typeId,
  ) {
    return (select(chiefComplaintDetail)
          ..where((d) => d.chiefComplaintTypeId.equals(typeId))
          ..where((d) => d.isActive.equals(true))
          ..orderBy([(d) => OrderingTerm.asc(d.sortOrder)]))
        .get();
  }

  // 取得所有主訴細項
  Future<List<ChiefComplaintDetailData>> getAllChiefComplaintDetails() {
    return (select(chiefComplaintDetail)
          ..where((d) => d.isActive.equals(true))
          ..orderBy([(d) => OrderingTerm.asc(d.sortOrder)]))
        .get();
  }

  Future<int> addChiefComplaintType({
    required String code,
    required String name,
  }) {
    return into(
      chiefComplaintType,
    ).insert(ChiefComplaintTypeCompanion.insert(code: code, name: name));
  }

  Future<int> disableChiefComplaintType(int id) {
    return (update(chiefComplaintType)..where((t) => t.id.equals(id))).write(
      const ChiefComplaintTypeCompanion(isActive: Value(false)),
    );
  }

  //診斷分類
  Future<List<DiagnosisCategoryData>> getAllDiagnosisCategories({
    bool onlyActive = true,
  }) {
    final query = select(diagnosisCategory);
    if (onlyActive) {
      query.where((d) => d.isActive.equals(true));
    }
    return (query..orderBy([(d) => OrderingTerm.asc(d.sortOrder)])).get();
  }

  Future<int> addDiagnosisCategory({
    required String name,
    String? description,
    int sortOrder = 0,
  }) {
    return into(diagnosisCategory).insert(
      DiagnosisCategoryCompanion.insert(
        name: name,
        description: Value(description),
        sortOrder: Value(sortOrder),
      ),
    );
  }

  Future<int> disableDiagnosisCategory(int id) {
    return (update(diagnosisCategory)..where((d) => d.id.equals(id))).write(
      const DiagnosisCategoryCompanion(isActive: Value(false)),
    );
  }

  //分級
  Future<List<TriageLevelData>> getAllTriageLevels() {
    return (select(
      triageLevel,
    )..orderBy([(t) => OrderingTerm.asc(t.level)])).get();
  }

  Future<TriageLevelData?> getTriageLevelByLevel(int level) {
    return (select(
      triageLevel,
    )..where((t) => t.level.equals(level))).getSingleOrNull();
  }

  //現場處置
  Future<List<TreatmentOnSiteData>> getAllTreatmentOnSite({
    bool onlyActive = true,
  }) {
    final query = select(treatmentOnSite);
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }
    return (query..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  }

  Future<int> addTreatmentOnSite({
    required String name,
    String? description,
    int sortOrder = 0,
  }) {
    return into(treatmentOnSite).insert(
      TreatmentOnSiteCompanion.insert(
        name: name,
        description: Value(description),
        sortOrder: Value(sortOrder),
      ),
    );
  }

  Future<int> disableTreatmentOnSite(int id) {
    return (update(treatmentOnSite)..where((t) => t.id.equals(id))).write(
      const TreatmentOnSiteCompanion(isActive: Value(false)),
    );
  }

  //治療結果
  Future<List<TreatmentResultData>> getAllTreatmentResults({
    bool onlyActive = true,
  }) {
    final query = select(treatmentResult);
    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }
    return (query..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  }

  Future<int> addTreatmentResult({
    required String name,
    String? description,
    int sortOrder = 0,
  }) {
    return into(treatmentResult).insert(
      TreatmentResultCompanion.insert(
        name: name,
        description: Value(description),
        sortOrder: Value(sortOrder),
      ),
    );
  }

  Future<int> disableTreatmentResult(int id) {
    return (update(treatmentResult)..where((t) => t.id.equals(id))).write(
      const TreatmentResultCompanion(isActive: Value(false)),
    );
  }

  //轉診醫院
  Future<List<ReferralHospitalData>> getAllReferralHospitals({
    bool onlyActive = true,
  }) {
    final query = select(referralHospital);
    if (onlyActive) {
      query.where((h) => h.isActive.equals(true));
    }
    return (query..orderBy([(h) => OrderingTerm.asc(h.sortOrder)])).get();
  }

  Future<int> addReferralHospital({
    required String name,
    String? address,
    String? phone,
    int sortOrder = 0,
  }) {
    return into(referralHospital).insert(
      ReferralHospitalCompanion.insert(
        name: name,
        address: Value(address),
        phone: Value(phone),
        sortOrder: Value(sortOrder),
      ),
    );
  }

  Future<int> disableReferralHospital(int id) {
    return (update(referralHospital)..where((h) => h.id.equals(id))).write(
      const ReferralHospitalCompanion(isActive: Value(false)),
    );
  }

  //處置項目
  Future<List<ActionItemData>> getAllActionItems({bool onlyActive = true}) {
    final query = select(actionItem);
    if (onlyActive) {
      query.where((a) => a.isActive.equals(true));
    }
    return (query..orderBy([(a) => OrderingTerm.asc(a.sortOrder)])).get();
  }

  Future<List<ActionItemData>> getActionItemsByCategory(String category) {
    return (select(actionItem)
          ..where((a) => a.isActive.equals(true))
          ..orderBy([(a) => OrderingTerm.asc(a.sortOrder)]))
        .get();
  }

  Future<int> addActionItem({
    required String name,
    String? category,
    int sortOrder = 0,
  }) {
    return into(actionItem).insert(
      ActionItemCompanion.insert(name: name, sortOrder: Value(sortOrder)),
    );
  }

  //醫療人員
  Future<List<MedicalStaffData>> getAllMedicalStaff({bool onlyActive = true}) {
    final query = select(medicalStaff);
    if (onlyActive) {
      query.where((s) => s.isActive.equals(true));
    }
    return query.get();
  }

  Future<List<MedicalStaffData>> getMedicalStaffByRole(String role) {
    return (select(medicalStaff)
          ..where((s) => s.role.equals(role))
          ..where((s) => s.isActive.equals(true)))
        .get();
  }

  Future<int> addMedicalStaff({
    required String name,
    required String role,
    String? employeeId,
    String? department,
    String? phone,
  }) {
    return into(medicalStaff).insert(
      MedicalStaffCompanion.insert(
        name: name,
        role: role,
        employeeId: Value(employeeId),
        department: Value(department),
        phone: Value(phone),
      ),
    );
  }

  Future<int> disableMedicalStaff(int id) {
    return (update(medicalStaff)..where((s) => s.id.equals(id))).write(
      const MedicalStaffCompanion(isActive: Value(false)),
    );
  }

  // 更新醫療人員簽名
  Future<int> updateMedicalStaffSignature(int id, Uint8List signature) {
    return (update(medicalStaff)..where((s) => s.id.equals(id))).write(
      MedicalStaffCompanion(signature: Value(signature)),
    );
  }

  //  初始化參考資料
  Future<void> initializeAllReferenceData() async {
    await initializeSex();
    await initializeTravelStatus();
    await initializeIncidentPlaces();
    await initializeReportingUnits();
    await initializeChiefComplaintTypes();
    await initializeChiefComplaintDetails();
    await initializeDiagnosisCategories();
    await initializeTriageLevels();
    await initializeTreatmentOnSiteData();
    await initializeTreatmentResults();
    await initializeReferralHospitals();
    await initializeActionItems();
    await initializeMedicalStaff();
    await initializeSpecialNoteRefs();
    await initializePaymentMethods();
    await initializeCollectionStatus();
    await initializeCurrencies();
    await initializeReferralPurposes();
    await initializeStations();
    await initializeRelationshipTypes();
    await initializeHistoryStatus();
    await initializeMedicalStaffRoles();
    await initializePupilReactions();
    await initializeConsciousnessLevels();
    await initializeDrugs();
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

  Future<void> initializeIncidentPlaces() async {
    final existingCategories = await select(incidentPlaceCategory).get();

    if (existingCategories.isEmpty) {
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
          ReportingUnitCompanion.insert(name: 'T1-OCC'),
          ReportingUnitCompanion.insert(name: 'T2-OCC'),
          ReportingUnitCompanion.insert(name: '華航'),
          ReportingUnitCompanion.insert(name: '長榮'),
          ReportingUnitCompanion.insert(name: '虎航'),
          ReportingUnitCompanion.insert(name: '星宇'),
          ReportingUnitCompanion.insert(name: '采盟'),
          ReportingUnitCompanion.insert(name: '昇恆昌'),
          ReportingUnitCompanion.insert(name: '病人或家屬'),
          ReportingUnitCompanion.insert(name: '其他'),
        ]);
      });
    }
  }

  // 初始化主訴類別
  Future<void> initializeChiefComplaintTypes() async {
    final count = await (select(
      chiefComplaintType,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(chiefComplaintType, [
          ChiefComplaintTypeCompanion.insert(code: 'TRAUMA', name: '外傷'),
          ChiefComplaintTypeCompanion.insert(code: 'NON_TRAUMA', name: '非外傷'),
        ]);
      });
    }
  }

  // 初始化主訴細項
  Future<void> initializeChiefComplaintDetails() async {
    final count = await (select(
      chiefComplaintDetail,
    ).get()).then((list) => list.length);
    if (count == 0) {
      // 取得類型 ID
      final types = await select(chiefComplaintType).get();
      ChiefComplaintTypeData? traumaType;
      ChiefComplaintTypeData? nonTraumaType;

      try {
        traumaType = types.firstWhere((t) => t.code == 'TRAUMA');
        nonTraumaType = types.firstWhere((t) => t.code == 'NON_TRAUMA');
      } catch (e) {
        return;
      }

      await batch((batch) {
        // 外傷細項
        final traumaItems = ['鈍挫傷', '扭傷', '撕裂傷', '擦傷', '肢體變形', '其它'];
        for (var i = 0; i < traumaItems.length; i++) {
          batch.insert(
            chiefComplaintDetail,
            ChiefComplaintDetailCompanion.insert(
              chiefComplaintTypeId: traumaType!.id,
              name: traumaItems[i],
              sortOrder: Value(i + 1),
            ),
          );
        }

        // 非外傷細項
        final nonTraumaItems = ['頭頸部', '胸部', '腹部', '四肢', '其它'];
        for (var i = 0; i < nonTraumaItems.length; i++) {
          batch.insert(
            chiefComplaintDetail,
            ChiefComplaintDetailCompanion.insert(
              chiefComplaintTypeId: nonTraumaType!.id,
              name: nonTraumaItems[i],
              sortOrder: Value(i + 1),
            ),
          );
        }
      });
    }
  }

  // 初始化診斷分類
  Future<void> initializeDiagnosisCategories() async {
    final count = await (select(
      diagnosisCategory,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(diagnosisCategory, [
          DiagnosisCategoryCompanion.insert(
            name: 'Mild Neurologic(headache、dizziness、vertigo)',
            sortOrder: const Value(1),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Severe Neurologic(syncope、seizure、CVA)',
            sortOrder: const Value(2),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Gl non-OP (AGE Epigas mild bleeding)',
            sortOrder: const Value(3),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Gl surgical (app cholecystitis PPU)',
            sortOrder: const Value(4),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Mild Trauma(含head injury、non-surgical intervention)',
            sortOrder: const Value(5),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Severe Trauma (surgical intervention)',
            sortOrder: const Value(6),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Mild CV (Palpitation Chest pain H/T hypo)',
            sortOrder: const Value(7),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Severe CV (AMl Arrythmia Shock Others)',
            sortOrder: const Value(8),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'RESP(Asthma、CoPD)',
            sortOrder: const Value(9),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Fever (cause undetermined)',
            sortOrder: const Value(10),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Musculoskeletal',
            sortOrder: const Value(11),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'DM (hypoglycemia or hyperglycemia)',
            sortOrder: const Value(12),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'GU (APN Stone or others)',
            sortOrder: const Value(13),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'OHCA',
            sortOrder: const Value(14),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Derma',
            sortOrder: const Value(15),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'GYN',
            sortOrder: const Value(16),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'OPH/ENT',
            sortOrder: const Value(17),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Psychiatric (nervous、anxious、Alcohols/drug)',
            sortOrder: const Value(18),
          ),
          DiagnosisCategoryCompanion.insert(
            name: 'Others',
            sortOrder: const Value(99),
          ),
        ]);
      });
    }
  }

  // 初始化分級資料
  Future<void> initializeTriageLevels() async {
    // 定義較為舒適的顏色 (Tailwind 500 series)
    final levels = [
      (1, '復甦急救', '#EF4444'), // Red
      (2, '危急', '#F97316'), // Orange
      (3, '急迫', '#EAB308'), // Yellow
      (4, '次急迫', '#22C55E'), // Green
      (5, '非急迫', '#3B82F6'), // Blue
    ];

    for (final item in levels) {
      final lvl = item.$1;
      final name = item.$2;
      final color = item.$3;

      final exists = await (select(
        triageLevel,
      )..where((t) => t.level.equals(lvl))).getSingleOrNull();

      if (exists != null) {
        // 更新顏色
        await (update(triageLevel)..where((t) => t.level.equals(lvl))).write(
          TriageLevelCompanion(colorCode: Value(color)),
        );
      } else {
        // 新增
        await into(triageLevel).insert(
          TriageLevelCompanion.insert(level: lvl, name: name, colorCode: color),
        );
      }
    }
  }

  // 初始化現場處置
  Future<void> initializeTreatmentOnSiteData() async {
    final count = await (select(
      treatmentOnSite,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(treatmentOnSite, [
          TreatmentOnSiteCompanion.insert(
            name: '諮詢衛教',
            sortOrder: const Value(1),
          ),
          TreatmentOnSiteCompanion.insert(
            name: '內科處置',
            sortOrder: const Value(2),
          ),
          TreatmentOnSiteCompanion.insert(
            name: '外科處置',
            sortOrder: const Value(3),
          ),
          TreatmentOnSiteCompanion.insert(
            name: '拒絕處置',
            sortOrder: const Value(4),
          ),
          TreatmentOnSiteCompanion.insert(
            name: '疑似傳染病診療',
            sortOrder: const Value(5),
          ),
        ]);
      });
    }
  }

  // 初始化治療結果
  Future<void> initializeTreatmentResults() async {
    final count = await (select(
      treatmentResult,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(treatmentResult, [
          TreatmentResultCompanion.insert(
            name: '繼續搭機飛行',
            sortOrder: const Value(1),
          ),
          TreatmentResultCompanion.insert(
            name: '休息觀察與自行回家',
            sortOrder: const Value(2),
          ),
          TreatmentResultCompanion.insert(
            name: '轉聯新國際醫院',
            sortOrder: const Value(3),
          ),
          TreatmentResultCompanion.insert(
            name: '轉林口長庚醫院',
            sortOrder: const Value(4),
          ),
          TreatmentResultCompanion.insert(
            name: '轉其它醫院',
            sortOrder: const Value(5),
          ),
          TreatmentResultCompanion.insert(
            name: '建議轉診門診追蹤',
            sortOrder: const Value(6),
          ),
          TreatmentResultCompanion.insert(
            name: '死亡',
            sortOrder: const Value(7),
          ),
          TreatmentResultCompanion.insert(
            name: '拒絕轉診',
            sortOrder: const Value(8),
          ),
        ]);
      });
    }
  }

  // 初始化轉診醫院
  Future<void> initializeReferralHospitals() async {
    final count = await (select(
      referralHospital,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(referralHospital, [
          ReferralHospitalCompanion.insert(
            name: '聯新國際醫院',
            address: const Value('桃園市平鎮區廣泰路77號'),
            phone: const Value('03-494-1234'),
            sortOrder: const Value(1),
            isOther: const Value(false),
          ),
          ReferralHospitalCompanion.insert(
            name: '林口長庚醫院',
            address: const Value('桃園市龜山區復興街5號'),
            phone: const Value('03-328-1200'),
            sortOrder: const Value(2),
            isOther: const Value(false),
          ),
          ReferralHospitalCompanion.insert(
            name: '桃園經國敏盛醫院',
            address: const Value('桃園市桃園區經國路168號'),
            phone: const Value('03-317-9599'),
            sortOrder: const Value(3),
            isOther: const Value(true),
          ),
          ReferralHospitalCompanion.insert(
            name: '聖保祿醫院',
            address: const Value('桃園市桃園區建新街123號'),
            phone: const Value('03-361-3141'),
            sortOrder: const Value(4),
            isOther: const Value(true),
          ),
          ReferralHospitalCompanion.insert(
            name: '衛生福利部桃園醫院',
            address: const Value('桃園市桃園區中山路1492號'),
            phone: const Value('03-369-9721'),
            sortOrder: const Value(5),
            isOther: const Value(true),
          ),
          ReferralHospitalCompanion.insert(
            name: '衛生福利部桃園療養院',
            address: const Value('桃園市桃園區龍壽街71號'),
            phone: const Value('03-369-8553'),
            sortOrder: const Value(6),
            isOther: const Value(true),
          ),
          ReferralHospitalCompanion.insert(
            name: '桃園榮民總醫院',
            address: const Value('桃園市桃園區成功路三段100號'),
            phone: const Value('03-286-8001'),
            sortOrder: const Value(7),
            isOther: const Value(true),
          ),
          ReferralHospitalCompanion.insert(
            name: '三峽恩主公醫院',
            address: const Value('新北市三峽區復興路399號'),
            phone: const Value('02-2672-3456'),
            sortOrder: const Value(8),
            isOther: const Value(true),
          ),
          ReferralHospitalCompanion.insert(
            name: '其他醫院',
            sortOrder: const Value(99),
            isOther: const Value(true),
          ),
        ]);
      });
    }
  }

  // 初始化處置項目
  Future<void> initializeActionItems() async {
    final count = await (select(actionItem).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(actionItem, [
          ActionItemCompanion.insert(name: '冰敷', sortOrder: const Value(1)),
          ActionItemCompanion.insert(name: 'EKG心電圖', sortOrder: const Value(2)),
          ActionItemCompanion.insert(name: '血糖', sortOrder: const Value(3)),
          ActionItemCompanion.insert(name: '傷口處置', sortOrder: const Value(4)),
          ActionItemCompanion.insert(name: '簽四聯單', sortOrder: const Value(5)),
          ActionItemCompanion.insert(name: '建議轉診', sortOrder: const Value(6)),
          ActionItemCompanion.insert(name: '插管', sortOrder: const Value(7)),
          ActionItemCompanion.insert(name: 'CPR', sortOrder: const Value(8)),
          ActionItemCompanion.insert(name: '其他', sortOrder: const Value(9)),
          ActionItemCompanion.insert(name: '氧氣使用', sortOrder: const Value(10)),
          ActionItemCompanion.insert(name: '診斷書', sortOrder: const Value(11)),
          ActionItemCompanion.insert(name: '抽痰', sortOrder: const Value(12)),
          ActionItemCompanion.insert(name: '藥物使用', sortOrder: const Value(13)),
        ]);
      });
    }
  }

  // 初始化醫療人員資料
  Future<void> initializeMedicalStaff() async {
    final count = await (select(
      medicalStaff,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(medicalStaff, [
          MedicalStaffCompanion.insert(
            name: '管理員',
            role: 'System',
            employeeId: const Value('ADMIN001'),
          ),
          MedicalStaffCompanion.insert(
            name: '王小明',
            role: 'Doctor',
            employeeId: const Value('DOC001'),
            department: const Value('急診科'),
          ),
          MedicalStaffCompanion.insert(
            name: '陳大文',
            role: 'Doctor',
            employeeId: const Value('DOC002'),
            department: const Value('急診科'),
          ),
          MedicalStaffCompanion.insert(
            name: '李小美',
            role: 'Nurse',
            employeeId: const Value('NUR001'),
            department: const Value('急診科'),
          ),
          MedicalStaffCompanion.insert(
            name: '張雅婷',
            role: 'Nurse',
            employeeId: const Value('NUR002'),
            department: const Value('急診科'),
          ),
          MedicalStaffCompanion.insert(
            name: '林志豪',
            role: 'Nurse',
            employeeId: const Value('NUR003'),
            department: const Value('急診科'),
          ),
          MedicalStaffCompanion.insert(
            name: '陳志明',
            role: 'EMT',
            employeeId: const Value('EMT001'),
            department: const Value('急診科'),
          ),
          MedicalStaffCompanion.insert(
            name: '林美華',
            role: 'EMT',
            employeeId: const Value('EMT002'),
            department: const Value('急診科'),
          ),
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
    final complaintTypeCount = await (select(
      chiefComplaintType,
    ).get()).then((list) => list.length);
    final triageCount = await (select(
      triageLevel,
    ).get()).then((list) => list.length);

    return ReferenceStatistics(
      sexCount: sexCount,
      nationalityCount: nationalityCount,
      airlineCount: airlineCount,
      travelStatusCount: travelStatusCount,
      locationCount: locationCount,
      incidentPlaceCount: incidentPlaceCount,
      reportingUnitCount: reportingUnitCount,
      complaintTypeCount: complaintTypeCount,
      triageCount: triageCount,
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

  // 特別註記
  Future<List<SpecialNoteRefData>> getAllSpecialNoteRefs({
    bool onlyActive = true,
  }) {
    final query = select(specialNoteRef);
    if (onlyActive) {
      query.where((s) => s.isActive.equals(true));
    }
    return (query..orderBy([(s) => OrderingTerm.asc(s.sortOrder)])).get();
  }

  // 初始化特別註記
  Future<void> initializeSpecialNoteRefs() async {
    final count = await (select(
      specialNoteRef,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(specialNoteRef, [
          SpecialNoteRefCompanion.insert(
            name: 'OHCA醫護到達前有CPR',
            sortOrder: const Value(1),
          ),
          SpecialNoteRefCompanion.insert(
            name: 'OHCA醫護到達前有使用AED但無電擊',
            sortOrder: const Value(2),
          ),
          SpecialNoteRefCompanion.insert(
            name: 'OHCA醫護到達前有使用AED有電擊',
            sortOrder: const Value(3),
          ),
          SpecialNoteRefCompanion.insert(
            name: '現場恢復脈搏',
            sortOrder: const Value(4),
          ),
          SpecialNoteRefCompanion.insert(
            name: '使用自動心肺復甦機',
            sortOrder: const Value(5),
          ),
          SpecialNoteRefCompanion.insert(name: '空跑', sortOrder: const Value(6)),
        ]);
      });
    }
  }

  // 初始化付款方式
  Future<void> initializePaymentMethods() async {
    final count = await (select(
      paymentMethod,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(paymentMethod, [
          PaymentMethodCompanion.insert(
            code: 'self_pay',
            name: '自付',
            sortOrder: const Value(1),
          ),
          PaymentMethodCompanion.insert(
            code: 'unified_billing',
            name: '統一請款',
            sortOrder: const Value(2),
          ),
          PaymentMethodCompanion.insert(
            code: 'hospital_collect',
            name: '總院會核代收',
            sortOrder: const Value(3),
          ),
          PaymentMethodCompanion.insert(
            code: 'abnormal',
            name: '收費異常',
            sortOrder: const Value(4),
          ),
        ]);
      });
    }
  }

  // 初始化收款狀態
  Future<void> initializeCollectionStatus() async {
    final count = await (select(
      collectionStatus,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(collectionStatus, [
          CollectionStatusCompanion.insert(
            code: 'not_collected',
            name: '尚未收款',
            sortOrder: const Value(1),
          ),
          CollectionStatusCompanion.insert(
            code: 'collected',
            name: '已收款',
            sortOrder: const Value(2),
          ),
          CollectionStatusCompanion.insert(
            code: 'not_required',
            name: '不需要',
            sortOrder: const Value(3),
          ),
        ]);
      });
    }
  }

  // 初始化貨幣
  Future<void> initializeCurrencies() async {
    final count = await (select(currencyRef).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(currencyRef, [
          CurrencyRefCompanion.insert(
            code: 'TWD',
            name: '台幣',
            symbol: const Value('NT\$'),
          ),
          CurrencyRefCompanion.insert(
            code: 'USD',
            name: '美金',
            symbol: const Value('\$'),
          ),
          CurrencyRefCompanion.insert(
            code: 'CNY',
            name: '人民幣',
            symbol: const Value('¥'),
          ),
          CurrencyRefCompanion.insert(
            code: 'JPY',
            name: '日幣',
            symbol: const Value('¥'),
          ),
          CurrencyRefCompanion.insert(
            code: 'CAD',
            name: '加幣',
            symbol: const Value('C\$'),
          ),
        ]);
      });
    }
  }

  // 初始化轉診目的
  Future<void> initializeReferralPurposes() async {
    final count = await (select(
      referralPurpose,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(referralPurpose, [
          ReferralPurposeCompanion.insert(
            code: 'emergency',
            name: '急診治療',
            sortOrder: const Value(1),
          ),
          ReferralPurposeCompanion.insert(
            code: 'inpatient',
            name: '住院治療',
            sortOrder: const Value(2),
          ),
          ReferralPurposeCompanion.insert(
            code: 'outpatient',
            name: '門診治療',
            sortOrder: const Value(3),
          ),
          ReferralPurposeCompanion.insert(
            code: 'further_exam',
            name: '進一步檢查',
            sortOrder: const Value(4),
          ),
          ReferralPurposeCompanion.insert(
            code: 'followup',
            name: '轉回轉出或適當之院所繼續追蹤',
            sortOrder: const Value(5),
          ),
          ReferralPurposeCompanion.insert(
            code: 'other',
            name: '其它',
            sortOrder: const Value(6),
          ),
        ]);
      });
    }
  }

  // 初始化站點
  Future<void> initializeStations() async {
    final count = await (select(stationRef).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(stationRef, [
          StationRefCompanion.insert(
            code: 'T1_OCC',
            name: 'T1 03-3063578',
            description: const Value('桃園國際機場股份有限公司營運控制中心 T1'),
          ),
          StationRefCompanion.insert(
            code: 'T2_OCC',
            name: 'T2 03-3063367',
            description: const Value('桃園國際機場股份有限公司營運控制中心 T2'),
          ),
          StationRefCompanion.insert(
            code: 'T1_MED',
            name: 'T1 03-3834225',
            description: const Value('聯新國際醫院桃園國際機場醫療中心 T1'),
          ),
          StationRefCompanion.insert(
            code: 'T2_MED',
            name: 'T2 03-3983485',
            description: const Value('聯新國際醫院桃園國際機場醫療中心 T2'),
          ),
        ]);
      });
    }
  }

  // 初始化關係類型
  Future<void> initializeRelationshipTypes() async {
    final count = await (select(
      relationshipType,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(relationshipType, [
          RelationshipTypeCompanion.insert(
            code: 'self',
            name: '本人 (Self)',
            nameEn: const Value('Self'),
          ),
          RelationshipTypeCompanion.insert(
            code: 'spouse',
            name: '配偶 (Spouse)',
            nameEn: const Value('Spouse'),
          ),
          RelationshipTypeCompanion.insert(
            code: 'parent',
            name: '父母 (Parent)',
            nameEn: const Value('Parent'),
          ),
          RelationshipTypeCompanion.insert(
            code: 'child',
            name: '子女 (Child)',
            nameEn: const Value('Child'),
          ),
          RelationshipTypeCompanion.insert(
            code: 'other',
            name: '其他 (Other)',
            nameEn: const Value('Other'),
          ),
        ]);
      });
    }
  }

  // 初始化病史狀態
  Future<void> initializeHistoryStatus() async {
    final count = await (select(
      historyStatusRef,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(historyStatusRef, [
          HistoryStatusRefCompanion.insert(
            code: 'none',
            name: '無',
            nameEn: const Value('None'),
            sortOrder: const Value(1),
          ),
          HistoryStatusRefCompanion.insert(
            code: 'unknown',
            name: '不詳',
            nameEn: const Value('Unknown'),
            sortOrder: const Value(2),
          ),
          HistoryStatusRefCompanion.insert(
            code: 'yes',
            name: '有',
            nameEn: const Value('Yes'),
            sortOrder: const Value(3),
          ),
        ]);
      });
    }
  }

  // 初始化醫護人員角色
  Future<void> initializeMedicalStaffRoles() async {
    final count = await (select(
      medicalStaffRole,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(medicalStaffRole, [
          MedicalStaffRoleCompanion.insert(
            code: 'DOCTOR',
            name: '醫師',
            nameEn: const Value('Doctor'),
            sortOrder: const Value(1),
          ),
          MedicalStaffRoleCompanion.insert(
            code: 'NURSE',
            name: '護理師',
            nameEn: const Value('Nurse'),
            sortOrder: const Value(2),
          ),
          MedicalStaffRoleCompanion.insert(
            code: 'EMT',
            name: 'EMT',
            nameEn: const Value('EMT'),
            sortOrder: const Value(3),
          ),
          MedicalStaffRoleCompanion.insert(
            code: 'ASSIST',
            name: '協助人員',
            nameEn: const Value('Assistant'),
            sortOrder: const Value(4),
          ),
        ]);
      });
    }
  }

  // 初始化瞳孔反應
  Future<void> initializePupilReactions() async {
    final count = await (select(
      pupilReactionRef,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(pupilReactionRef, [
          PupilReactionRefCompanion.insert(
            code: 'positive',
            symbol: '+',
            name: '有反應',
          ),
          PupilReactionRefCompanion.insert(
            code: 'negative',
            symbol: '-',
            name: '無反應',
          ),
          PupilReactionRefCompanion.insert(
            code: 'equivocal',
            symbol: '±',
            name: '疑似',
          ),
        ]);
      });
    }
  }

  // 初始化意識狀態
  Future<void> initializeConsciousnessLevels() async {
    final count = await (select(
      consciousnessLevelRef,
    ).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(consciousnessLevelRef, [
          ConsciousnessLevelRefCompanion.insert(
            code: 'alert',
            name: '清醒',
            nameEn: const Value('Alert'),
          ),
          ConsciousnessLevelRefCompanion.insert(
            code: 'drowsy',
            name: '嗜睡',
            nameEn: const Value('Drowsy'),
          ),
          ConsciousnessLevelRefCompanion.insert(
            code: 'unconscious',
            name: '昏迷',
            nameEn: const Value('Unconscious'),
          ),
        ]);
      });
    }
  }

  // 初始化藥物資料
  Future<void> initializeDrugs() async {
    final count = await (select(drugRef).get()).then((list) => list.length);
    if (count == 0) {
      final drugs = [
        // Sprays/Inhalers
        {'category': '噴劑/吸入劑', 'name': 'Berodual N'},
        {'category': '噴劑/吸入劑', 'name': 'Combivent'},
        // Syrups/Liquids
        {'category': '水劑', 'name': 'Augmentin syrup'},
        {'category': '水劑', 'name': 'Peace (鼻福)'},
        {'category': '水劑', 'name': 'Wempty (胃利空)'},
        {'category': '水劑', 'name': 'Secorine (息咳寧)'},
        {'category': '水劑', 'name': 'Ibuprofen (依普芬)'},
        {'category': '水劑', 'name': 'cypromin (希普利敏)'},
        {'category': '水劑', 'name': 'D/W 20ml'},
        {'category': '水劑', 'name': 'N/S 20ml'},
        {'category': '水劑', 'name': '50% G/W 20ml'},
        // IV Fluids
        {'category': '點滴注射', 'name': 'N/S 500ml'},
        {'category': '點滴注射', 'name': 'D5S 500ml'},
        {'category': '點滴注射', 'name': "Lactated Ringer's (乳酸林格氏) 500ml"},
        {'category': '點滴注射', 'name': 'Taita No.2 (台大2號) 500ml'},
        {'category': '點滴注射', 'name': 'Taita No.5 (台大5號) 400ml'},
        // Ointments
        {'category': '藥膏', 'name': 'Kenalog'},
        {'category': '藥膏', 'name': '眼藥膏 (Tetracycline Oint)'},
        {'category': '藥膏', 'name': 'Neomycin Oint'},
        {'category': '藥膏', 'name': 'Silivadene Cream 20mg'},
        {'category': '藥膏', 'name': 'FOCUS JEL'},
        {'category': '藥膏', 'name': 'Scheree Cream'},
        // Eye Drops
        {'category': '眼藥水', 'name': 'Sinomin'},
        {'category': '眼藥水', 'name': 'Emadine'},
        // Ear Drops
        {'category': '耳滴劑', 'name': 'Tarivid'},
        // Suppositories
        {'category': '肛門塞劑', 'name': 'Motilium (supp)'},
        {'category': '肛門塞劑', 'name': 'Voltaren-12.5 supp'},
        // Injections
        {'category': '注射藥物', 'name': 'Atropine'},
        {'category': '注射藥物', 'name': 'Aminophyllin'},
        {'category': '注射藥物', 'name': 'Xylocaine'},
        {'category': '注射藥物', 'name': 'Bosmin'},
        {'category': '注射藥物', 'name': 'Dopamin'},
        {'category': '注射藥物', 'name': 'Solu-medrol 40mg'},
        {'category': '注射藥物', 'name': 'Primperan'},
        {'category': '注射藥物', 'name': 'Vena'},
        {'category': '注射藥物', 'name': 'Decadrone'},
        {'category': '注射藥物', 'name': 'Lasix'},
        {'category': '注射藥物', 'name': 'Buscopan'},
        {'category': '注射藥物', 'name': 'Haldol'},
        {'category': '注射藥物', 'name': 'Novamin'},
        {'category': '注射藥物', 'name': 'Solucortef'},
        {'category': '注射藥物', 'name': 'Voren'},
        {'category': '注射藥物', 'name': 'Valium'},
        {'category': '注射藥物', 'name': 'Morphine'},
        {'category': '注射藥物', 'name': 'Dormicum'},
        // Oral Medications
        {'category': '口服藥物', 'name': 'Augmentin 1g'},
        {'category': '口服藥物', 'name': 'Actifed(peace)'},
        {'category': '口服藥物', 'name': 'Adalat-5'},
        {'category': '口服藥物', 'name': 'Adalat-10'},
        {'category': '口服藥物', 'name': 'Allegra'},
        {'category': '口服藥物', 'name': 'Amoxicillin-500'},
        {'category': '口服藥物', 'name': 'Bensau'},
        {'category': '口服藥物', 'name': 'Berotec'},
        {'category': '口服藥物', 'name': 'Bokey'},
        {'category': '口服藥物', 'name': 'Bonamin'},
        {'category': '口服藥物', 'name': 'Buscopan'},
        {'category': '口服藥物', 'name': 'Cafergot'},
        {'category': '口服藥物', 'name': 'Cataflam'},
        {'category': '口服藥物', 'name': 'Cephadol'},
        {'category': '口服藥物', 'name': 'Clarinase'},
        {'category': '口服藥物', 'name': 'Cety'},
        {'category': '口服藥物', 'name': 'Capoten'},
        {'category': '口服藥物', 'name': 'Colchicine'},
        {'category': '口服藥物', 'name': 'Duspatalin'},
        {'category': '口服藥物', 'name': 'Flatin'},
        {'category': '口服藥物', 'name': 'Gascon'},
        {'category': '口服藥物', 'name': 'Imodium'},
        {'category': '口服藥物', 'name': 'Incidal'},
        {'category': '口服藥物', 'name': 'Inderal-10'},
        {'category': '口服藥物', 'name': 'KBT'},
        {'category': '口服藥物', 'name': 'Medicon-A'},
        {'category': '口服藥物', 'name': 'MgO'},
        {'category': '口服藥物', 'name': 'Mucaine(Strocain)'},
        {'category': '口服藥物', 'name': 'Motilium'},
        {'category': '口服藥物', 'name': 'Novamin'},
        {'category': '口服藥物', 'name': 'Norvasc'},
        {'category': '口服藥物', 'name': 'NTG'},
        {'category': '口服藥物', 'name': 'Panadol'},
        {'category': '口服藥物', 'name': 'Predonine'},
        {'category': '口服藥物', 'name': 'Periactin'},
        {'category': '口服藥物', 'name': 'Ponstan'},
        {'category': '口服藥物', 'name': 'Primperan'},
        {'category': '口服藥物', 'name': 'Pyridium'},
        {'category': '口服藥物', 'name': 'Solaxin'},
        {'category': '口服藥物', 'name': 'Trandate'},
        {'category': '口服藥物', 'name': 'Transamin'},
        {'category': '口服藥物', 'name': 'U-save-500'},
        {'category': '口服藥物', 'name': 'Xanthium'},
        {'category': '口服藥物', 'name': 'Ativan'},
        {'category': '口服藥物', 'name': 'Valium-2(管)'},
        {'category': '口服藥物', 'name': 'Xanax(管)'},
      ];

      await batch((batch) {
        for (var i = 0; i < drugs.length; i++) {
          batch.insert(
            drugRef,
            DrugRefCompanion.insert(
              category: drugs[i]['category']!,
              name: drugs[i]['name']!,
              sortOrder: Value(i + 1),
            ),
          );
        }
      });
    }
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
  final int complaintTypeCount;
  final int triageCount;

  ReferenceStatistics({
    required this.sexCount,
    required this.nationalityCount,
    required this.airlineCount,
    required this.travelStatusCount,
    required this.locationCount,
    required this.incidentPlaceCount,
    required this.reportingUnitCount,
    required this.complaintTypeCount,
    required this.triageCount,
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
        ', complaintType: $complaintTypeCount, '
        'triage: $triageCount'
        ')';
  }
}
