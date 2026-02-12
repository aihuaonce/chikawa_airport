import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../db/database.dart';
import '../utils/icd10_importer.dart';
import '../utils/csv_reference_importer.dart';

class ReferenceService extends ChangeNotifier {
  final AppDatabase db;

  // === 病患相關參考資料 ===
  List<SexData> _sexList = [];
  List<NationalityData> _nationalityList = [];

  // === 飛航相關參考資料 ===
  List<AirlineData> _airlineList = [];
  List<TravelStatusData> _travelStatusList = [];
  List<LocationData> _locationList = [];

  // === 事故相關參考資料 ===
  List<IncidentPlaceCategoryData> _incidentPlaceCategories = [];
  List<ReportingUnitData> _reportingUnits = [];

  // === 處置相關參考資料 ===
  List<ChiefComplaintTypeData> _chiefComplaintTypes = [];
  List<ChiefComplaintDetailData> _chiefComplaintDetails = [];
  List<DiagnosisCategoryData> _diagnosisCategories = [];
  List<TriageLevelData> _triageLevels = [];
  List<TreatmentOnSiteData> _treatmentOnSites = [];
  List<TreatmentResultData> _treatmentResults = [];
  List<ReferralHospitalData> _referralHospitals = [];
  List<ActionItemData> _actionItems = [];
  List<MedicalStaffData> _medicalStaffList = [];
  List<SpecialNoteRefData> _specialNoteRefs = [];
  List<NursingPhraseData> _nursingPhraseList = [];
  List<DrugRefData> _drugList = [];

  List<PaymentMethodData> _paymentMethodList = [];
  List<CollectionStatusData> _collectionStatusList = [];
  List<CurrencyRefData> _currencyList = [];
  List<ReferralPurposeData> _referralPurposeList = [];
  List<StationRefData> _stationList = [];
  List<RelationshipTypeData> _relationshipTypeList = [];
  List<VisitReasonData> _visitReasonList = [];

  List<HistoryStatusRefData> _historyStatusList = [];
  List<MedicalStaffRoleData> _medicalStaffRoleList = [];
  List<PupilReactionRefData> _pupilReactionList = [];
  List<ConsciousnessLevelRefData> _consciousnessLevelList = [];

  // === Getters ===
  List<SexData> get sexList => _sexList;
  List<NationalityData> get nationalityList => _nationalityList;
  List<AirlineData> get airlineList => _airlineList;
  List<TravelStatusData> get travelStatusList => _travelStatusList;
  List<LocationData> get locationList => _locationList;
  List<IncidentPlaceCategoryData> get incidentPlaceCategories =>
      _incidentPlaceCategories;
  List<ReportingUnitData> get reportingUnits => _reportingUnits;
  List<ChiefComplaintTypeData> get chiefComplaintTypes => _chiefComplaintTypes;
  List<ChiefComplaintDetailData> get chiefComplaintDetails =>
      _chiefComplaintDetails;
  List<DiagnosisCategoryData> get diagnosisCategories => _diagnosisCategories;
  List<TriageLevelData> get triageLevels => _triageLevels;
  List<TreatmentOnSiteData> get treatmentOnSites => _treatmentOnSites;
  List<TreatmentResultData> get treatmentResults => _treatmentResults;
  List<ReferralHospitalData> get referralHospitals => _referralHospitals;
  List<ActionItemData> get actionItems => _actionItems;
  List<MedicalStaffData> get medicalStaffList => _medicalStaffList;
  List<SpecialNoteRefData> get specialNoteRefs => _specialNoteRefs;
  List<NursingPhraseData> get nursingPhraseList => _nursingPhraseList;
  List<DrugRefData> get drugList => _drugList;

  List<PaymentMethodData> get paymentMethodList => _paymentMethodList;
  List<CollectionStatusData> get collectionStatusList => _collectionStatusList;
  List<CurrencyRefData> get currencyList => _currencyList;
  List<ReferralPurposeData> get referralPurposeList => _referralPurposeList;
  List<StationRefData> get stationList => _stationList;
  List<RelationshipTypeData> get relationshipTypeList => _relationshipTypeList;
  List<VisitReasonData> get visitReasonList => _visitReasonList;

  List<HistoryStatusRefData> get historyStatusList => _historyStatusList;
  List<MedicalStaffRoleData> get medicalStaffRoleList => _medicalStaffRoleList;
  List<PupilReactionRefData> get pupilReactionList => _pupilReactionList;
  List<ConsciousnessLevelRefData> get consciousnessLevelList =>
      _consciousnessLevelList;

  ReferenceService(this.db);

  List<MedicalStaffRoleData> get staffRoles => _medicalStaffRoleList;

  List<MedicalStaffData> getStaffByRole(String roleCode) {
    final roleRef = _medicalStaffRoleList
        .where((r) => r.code == roleCode)
        .firstOrNull;
    
    if (roleRef == null) return [];

    // Based on seed data, MedicalStaff.role matches MedicalStaffRole.nameEn
    final searchKey = roleRef.nameEn ?? roleRef.code;
    
    return _medicalStaffList.where((s) => s.role == searchKey).toList();
  }

  /// 初始化所有參考資料
  Future<void> initialize() async {
    await init();
  }

  Future<void> init() async {
    await _importReferenceData();
    await _loadBasicReferences();
    await _loadTreatmentReferences();
    await _importIcd10Data();
    notifyListeners();
  }

  /// 匯入參考資料（CSV）
  Future<void> _importReferenceData() async {
    try {
      await CsvReferenceImporter.importAll(db);
    } catch (e) {
      debugPrint('系統:參考資料匯入失敗 - $e');
    }
  }

  /// 匯入 ICD-10 資料（首次啟動）
  Future<void> _importIcd10Data() async {
    try {
      await Icd10Importer.importFromCsv(db);
    } catch (e) {
      debugPrint('系統:ICD-10 資料匯入失敗 - $e');
    }
  }

  /// 載入基本參考資料（病患、飛航、事故）
  Future<void> _loadBasicReferences() async {
    try {
      // 病患相關
      await _seedVisitReasons();
      _sexList = await db.referenceDao.getAllSex();
      _nationalityList = await db.referenceDao.getAllNationality();
      _visitReasonList = await (db.select(
        db.visitReason,
      )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();

      // 飛航相關
      _airlineList = await db.referenceDao.getAllAirline();
      _travelStatusList = await db.referenceDao.getAllTravelStatus();
      _locationList = await db.referenceDao.getAllLocation();

      // 事故相關
      _incidentPlaceCategories = await db.referenceDao
          .getAllIncidentPlaceCategories();
      _reportingUnits = await db.referenceDao.getAllReportingUnits();

      debugPrint('系統:基本參考資料載入完成');
    } catch (e) {
      debugPrint('系統:載入基本參考資料失敗 - $e');
    }
  }

  Future<void> _seedVisitReasons() async {
    try {
      final count = await (db.select(db.visitReason)..limit(1)).get();
      if (count.isEmpty) {
        await db.batch((batch) {
          batch.insertAll(db.visitReason, [
            VisitReasonCompanion.insert(
              code: 'crew',
              name: '航空公司機組員',
              sortOrder: const Value(1),
            ),
            VisitReasonCompanion.insert(
              code: 'passenger',
              name: '旅客/民眾',
              sortOrder: const Value(2),
            ),
            VisitReasonCompanion.insert(
              code: 'staff',
              name: '機場內部員工',
              sortOrder: const Value(3),
            ),
          ]);
        });
        debugPrint('系統:已初始化為何至機場選項');
      }
    } catch (e) {
      debugPrint('系統:初始化為何至機場選項失敗 - $e');
    }
  }

  /// 載入處置相關參考資料
  Future<void> _loadTreatmentReferences() async {
    try {
      _chiefComplaintTypes = await db.referenceDao.getAllChiefComplaintTypes();
      _chiefComplaintDetails = await db.referenceDao
          .getAllChiefComplaintDetails();
      _diagnosisCategories = await db.referenceDao.getAllDiagnosisCategories();
      _triageLevels = await db.referenceDao.getAllTriageLevels();
      _treatmentOnSites = await db.referenceDao.getAllTreatmentOnSite();
      _treatmentResults = await db.referenceDao.getAllTreatmentResults();
      _referralHospitals = await db.referenceDao.getAllReferralHospitals();
      _actionItems = await db.referenceDao.getAllActionItems();
      _medicalStaffList = await db.referenceDao.getAllMedicalStaff();
      _specialNoteRefs = await db.referenceDao.getAllSpecialNoteRefs();
      _nursingPhraseList = await db.referenceDao.getAllNursingPhrases();
      if (_nursingPhraseList.isEmpty) {
        // Fallback: 如果列表為空 (例如 CSV 匯入失敗或未觸發)，則嘗試寫入預設資料並重新讀取
        debugPrint('系統:護理常用語列表為空，嘗試初始化預設資料...');
        await db.referenceDao.initializeNursingPhrases();
        _nursingPhraseList = await db.referenceDao.getAllNursingPhrases();
      }
      _drugList = await db.referenceDao.getAllDrugs();

      _paymentMethodList = await (db.select(
        db.paymentMethod,
      )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
      _collectionStatusList = await (db.select(
        db.collectionStatus,
      )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
      _currencyList = await db.select(db.currencyRef).get();
      _referralPurposeList = await (db.select(
        db.referralPurpose,
      )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
      _stationList = await db.select(db.stationRef).get();
      _relationshipTypeList = await db.select(db.relationshipType).get();

      debugPrint('系統:處置參考資料載入完成');
      debugPrint('  - 主訴類型: ${_chiefComplaintTypes.length}');
      debugPrint('  - 主訴細項: ${_chiefComplaintDetails.length}');
      debugPrint('  - 診斷分類: ${_diagnosisCategories.length}');
      debugPrint('  - 檢傷級別: ${_triageLevels.length}');
      debugPrint('  - 現場處置: ${_treatmentOnSites.length}');
      debugPrint('  - 處置結果: ${_treatmentResults.length}');
      debugPrint('  - 轉診醫院: ${_referralHospitals.length}');
      debugPrint('  - 處置項目: ${_actionItems.length}');
      debugPrint('  - 醫療人員: ${_medicalStaffList.length}');
      debugPrint('  - 特別註記: ${_specialNoteRefs.length}');
      debugPrint('  - 護理用語: ${_nursingPhraseList.length}');
      debugPrint('  - 藥物資料: ${_drugList.length}');
      debugPrint('  - 付款方式: ${_paymentMethodList.length}');
      debugPrint('  - 收款狀態: ${_collectionStatusList.length}');
      debugPrint('  - 貨幣種類: ${_currencyList.length}');
      debugPrint('  - 轉診目的: ${_referralPurposeList.length}');
      debugPrint('  - 站點資料: ${_stationList.length}');
      debugPrint('  - 關係類型: ${_relationshipTypeList.length}');

      _historyStatusList = await db
          .customSelect('SELECT * FROM history_status_ref ORDER BY sort_order')
          .map(
            (row) => HistoryStatusRefData(
              id: row.read<int>('id'),
              code: row.read<String>('code'),
              name: row.read<String>('name'),
              nameEn: row.readNullable<String>('name_en'),
              sortOrder: row.read<int>('sort_order'),
            ),
          )
          .get();

      _medicalStaffRoleList = await db
          .customSelect('SELECT * FROM medical_staff_role ORDER BY sort_order')
          .map(
            (row) => MedicalStaffRoleData(
              id: row.read<int>('id'),
              code: row.read<String>('code'),
              name: row.read<String>('name'),
              nameEn: row.readNullable<String>('name_en'),
              sortOrder: row.read<int>('sort_order'),
            ),
          )
          .get();

      _pupilReactionList = await db
          .customSelect('SELECT * FROM pupil_reaction_ref')
          .map(
            (row) => PupilReactionRefData(
              id: row.read<int>('id'),
              code: row.read<String>('code'),
              symbol: row.read<String>('symbol'),
              name: row.read<String>('name'),
            ),
          )
          .get();

      _consciousnessLevelList = await db
          .customSelect('SELECT * FROM consciousness_level_ref')
          .map(
            (row) => ConsciousnessLevelRefData(
              id: row.read<int>('id'),
              code: row.read<String>('code'),
              name: row.read<String>('name'),
              nameEn: row.readNullable<String>('name_en'),
            ),
          )
          .get();

      debugPrint('  - 病史狀態: ${_historyStatusList.length}');
      debugPrint('  - 醫護角色: ${_medicalStaffRoleList.length}');
      debugPrint('  - 瞳孔反應: ${_pupilReactionList.length}');
      debugPrint('  - 意識狀態: ${_consciousnessLevelList.length}');
    } catch (e) {
      debugPrint('系統:載入處置參考資料失敗 - $e');
    }
  }

  /// 根據父類別 ID 取得二級地點選項
  Future<List<IncidentPlaceCategory2Data>> getCategory2ByParent(
    int categoryId,
  ) async {
    try {
      return await db.referenceDao.getIncidentPlaceCategory2ByParent(
        categoryId,
      );
    } catch (e) {
      debugPrint('系統:載入二級地點失敗 - $e');
      return [];
    }
  }

  /// 重新載入所有參考資料
  Future<void> reload() async {
    await init();
  }

  /// 重新載入特定類型的參考資料
  Future<void> reloadBasicReferences() async {
    await _loadBasicReferences();
    notifyListeners();
  }

  Future<void> reloadTreatmentReferences() async {
    await _loadTreatmentReferences();
    notifyListeners();
  }

  /// 查詢輔助方法
  SexData? getSexById(int? id) {
    if (id == null) return null;
    try {
      return _sexList.firstWhere((s) => s.sexId == id);
    } catch (e) {
      return null;
    }
  }

  NationalityData? getNationalityById(int? id) {
    if (id == null) return null;
    try {
      return _nationalityList.firstWhere((n) => n.nationalityId == id);
    } catch (e) {
      return null;
    }
  }

  AirlineData? getAirlineById(int? id) {
    if (id == null) return null;
    try {
      return _airlineList.firstWhere((a) => a.airlineId == id);
    } catch (e) {
      return null;
    }
  }

  TravelStatusData? getTravelStatusById(int? id) {
    if (id == null) return null;
    try {
      return _travelStatusList.firstWhere((t) => t.travelStatusId == id);
    } catch (e) {
      return null;
    }
  }

  LocationData? getLocationById(int? id) {
    if (id == null) return null;
    try {
      return _locationList.firstWhere((l) => l.locationId == id);
    } catch (e) {
      return null;
    }
  }

  IncidentPlaceCategoryData? getIncidentPlaceCategoryById(int? id) {
    if (id == null) return null;
    try {
      return _incidentPlaceCategories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  ReportingUnitData? getReportingUnitById(int? id) {
    if (id == null) return null;
    try {
      return _reportingUnits.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  ChiefComplaintTypeData? getChiefComplaintTypeById(int? id) {
    if (id == null) return null;
    try {
      return _chiefComplaintTypes.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // 根據類型取得細項
  List<ChiefComplaintDetailData> getChiefComplaintDetailsByType(int typeId) {
    return _chiefComplaintDetails
        .where((d) => d.chiefComplaintTypeId == typeId)
        .toList();
  }

  DiagnosisCategoryData? getDiagnosisCategoryById(int? id) {
    if (id == null) return null;
    try {
      return _diagnosisCategories.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  TriageLevelData? getTriageLevelById(int? id) {
    if (id == null) return null;
    try {
      return _triageLevels.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  TreatmentOnSiteData? getTreatmentOnSiteById(int? id) {
    if (id == null) return null;
    try {
      return _treatmentOnSites.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  TreatmentResultData? getTreatmentResultById(int? id) {
    if (id == null) return null;
    try {
      return _treatmentResults.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  ReferralHospitalData? getReferralHospitalById(int? id) {
    if (id == null) return null;
    try {
      return _referralHospitals.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  ActionItemData? getActionItemById(int? id) {
    if (id == null) return null;
    try {
      return _actionItems.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  MedicalStaffData? getMedicalStaffById(int? id) {
    if (id == null) return null;
    try {
      return _medicalStaffList.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
