// ambulance_routes_config.dart
import 'package:flutter/material.dart';

// 【新增】引入翻譯檔案
import '../l10n/app_translations.dart';

// 【註】請確保所有頁面的 import 路徑都是正確的
import '../Ambulance_Information.dart';
import '../Ambulance_Personal.dart';
import '../Ambulance_Situation.dart';
import '../Ambulance_Plan.dart';
import '../Ambulance_Expenses.dart';
import '../BodyMap.dart';

class AmbulanceRouteItem {
  final String label;
  // 【修改】builder 的 key 型別改回 GlobalKey，以保持與另一份路由設定檔的一致性
  final Widget Function(int visitId, GlobalKey key) builder;

  AmbulanceRouteItem({required this.label, required this.builder});
}

// 【修改】將靜態列表轉換為一個接收 AppTranslations 的函式
List<AmbulanceRouteItem> getAmbulanceRouteItems(AppTranslations t) {
  return [
    AmbulanceRouteItem(
      label: t.ambulanceInformation, // 使用翻譯
      builder: (visitId, key) =>
          AmbulanceInformationPage(key: key, visitId: visitId),
    ),
    AmbulanceRouteItem(
      label: t.personalInfo, // 使用翻譯 (通用)
      builder: (visitId, key) =>
          AmbulancePersonalPage(key: key, visitId: visitId),
    ),
    AmbulanceRouteItem(
      label: t.ambulanceSituation, // 使用翻譯
      builder: (visitId, key) =>
          AmbulanceSituationPage(key: key, visitId: visitId),
    ),
    AmbulanceRouteItem(
      label: t.ambulancePlan, // 使用翻譯
      builder: (visitId, key) => AmbulancePlanPage(key: key, visitId: visitId),
    ),
    AmbulanceRouteItem(
      label: t.ambulanceExpenses, // 使用翻譯
      builder: (visitId, key) =>
          AmbulanceExpensesPage(key: key, visitId: visitId),
    ),
    AmbulanceRouteItem(
      label: t.bodyDiagram, // 使用翻譯
      builder: (visitId, key) => BodyMapPage(key: key, visitId: visitId),
    ),
  ];
}
