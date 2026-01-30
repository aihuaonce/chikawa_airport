import 'package:flutter/foundation.dart';
import '../db/database.dart';
import '../utils/icd10_importer.dart';

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

  ReferenceService(this.db);

  /// 初始化所有參考資料
  Future<void> initialize() async {
    await init();
  }

  Future<void> init() async {
    await _loadBasicReferences();
    await _loadTreatmentReferences();
    await _importIcd10Data();
    notifyListeners();
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
      _sexList = await db.referenceDao.getAllSex();
      _nationalityList = await db.referenceDao.getAllNationality();

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
