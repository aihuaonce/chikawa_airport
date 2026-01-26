import 'package:flutter/foundation.dart';
import '../db/database.dart';

class ReferenceService extends ChangeNotifier {
  final AppDatabase db;

  List<NationalityData> nationalities = [];
  List<SexData> sexOptions = [];
  List<AirlineData> airlines = [];
  List<TravelStatusData> travelStatuses = [];
  List<LocationData> locations = [];
  List<IncidentPlaceCategoryData> incidentPlaceCategories = [];
  List<ReportingUnitData> reportingUnits = [];

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  ReferenceService(this.db);

  // 只在 App 啟動或第一次需要時呼叫一次
  Future<void> ensureLoaded() async {
    if (_isLoaded) return; // 如果已經載入了，就直接返回

    try {
      debugPrint('系統：開始初始化全域參考資料...');

      // 使用 Future.wait 同時並行載入，速度更快
      final results = await Future.wait([
        db.referenceDao.getAllSex(),
        db.referenceDao.getAllNationality(),
        db.referenceDao.getAllAirline(),
        db.referenceDao.getAllTravelStatus(),
        db.referenceDao.getAllLocation(),
        db.referenceDao.getAllIncidentPlaceCategories(),
        db.referenceDao.getAllReportingUnits(),
      ]);

      sexOptions = results[0] as List<SexData>;
      nationalities = results[1] as List<NationalityData>;
      airlines = results[2] as List<AirlineData>;
      travelStatuses = results[3] as List<TravelStatusData>;
      locations = results[4] as List<LocationData>;
      incidentPlaceCategories = results[5] as List<IncidentPlaceCategoryData>;
      reportingUnits = results[6] as List<ReportingUnitData>;

      _isLoaded = true;
      notifyListeners();
      debugPrint('系統：全域參考資料載入完成');
    } catch (e) {
      debugPrint('系統：全域參考資料載入失敗 - $e');
    }
  }

  // 根據父類別 ID 取得次類別
  Future<List<IncidentPlaceCategory2Data>> getCategory2ByParent(
    int parentId,
  ) async {
    return await db.referenceDao.getIncidentPlaceCategory2ByParent(parentId);
  }
}
