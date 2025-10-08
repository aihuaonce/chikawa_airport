// ambulance_routes_config.dart
import 'package:flutter/material.dart';

// 引入您的救護車分頁檔案
import '../Ambulance_Information.dart';
import '../Ambulance_Personal.dart';
import '../Ambulance_Situation.dart';
import '../Ambulance_Plan.dart';
import '../Ambulance_Expenses.dart';

class AmbulanceRouteItem {
  final String label;
  // 由於 Nav5Page 沒有使用 GlobalKey 或 Mixin 進行狀態儲存，
  // 只需要 visitId 即可建立頁面。
  final Widget Function(int visitId, Key key) builder;

  AmbulanceRouteItem({required this.label, required this.builder});
}

// 救護車頁面配置列表
final List<AmbulanceRouteItem> ambulanceRouteItems = [
  AmbulanceRouteItem(
    label: '派遣資料',
    builder: (visitId, key) =>
        AmbulanceInformationPage(key: key, visitId: visitId),
  ),
  AmbulanceRouteItem(
    label: '病患資料',
    builder: (visitId, key) =>
        AmbulancePersonalPage(key: key, visitId: visitId),
  ),
  AmbulanceRouteItem(
    label: '現場狀況',
    builder: (visitId, key) =>
        AmbulanceSituationPage(key: key, visitId: visitId),
  ),
  AmbulanceRouteItem(
    label: '處置項目',
    builder: (visitId, key) => AmbulancePlanPage(key: key, visitId: visitId),
  ),
  AmbulanceRouteItem(
    label: '收取費用',
    builder: (visitId, key) =>
        AmbulanceExpensesPage(key: key, visitId: visitId),
  ),
];
