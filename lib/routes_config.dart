import 'package:flutter/material.dart';
import 'nav2.dart';

// 子頁面 (假設這些檔案已存在且定義了對應的 Page)
import 'PersonalInformation.dart';
import 'FlightLog.dart';
import 'AccidentRecord.dart';
import 'Plan.dart';
import 'MedicalExpenses.dart';
import 'MedicalCertificate.dart';
import 'Undertaking.dart';
import 'ElectronicDocuments.dart';
import 'ReferralForm.dart';
import 'NursingRecord.dart';

/// 路由配置表：同時包含 routePath、label、對應 Widget
class RouteItem {
  final String path; // 路由名稱
  final String label; // 中文標籤
  final Widget Function(int visitId) builder; // 對應 Widget

  RouteItem({required this.path, required this.label, required this.builder});
}

/// 所有頁面清單 (用於 Nav2Page 選單)
final List<RouteItem> routeItems = [
  RouteItem(
    path: '/personalInformation',
    label: '個人資料',
    builder: (visitId) => PersonalInformationPage(visitId: visitId),
  ),
  RouteItem(
    path: '/flightLog',
    label: '飛航記錄',
    builder: (visitId) => FlightLogPage(visitId: visitId),
  ),
  RouteItem(
    path: '/accidentRecord',
    label: '事故紀錄',
    builder: (visitId) => AccidentRecordPage(visitId: visitId),
  ),
  RouteItem(
    path: '/plan',
    label: '處置紀錄',
    builder: (visitId) => PlanPage(visitId: visitId),
  ),
  RouteItem(
    path: '/medicalExpenses',
    label: '醫療費用',
    builder: (visitId) => MedicalExpensesPage(visitId: visitId),
  ),
  RouteItem(
    path: '/medicalCertificate',
    label: '診斷書',
    builder: (visitId) => MedicalCertificatePage(visitId: visitId),
  ),
  RouteItem(
    path: '/undertaking',
    label: '拒絕轉診切結書',
    builder: (visitId) => UndertakingPage(visitId: visitId),
  ),
  RouteItem(
    path: '/electronicDocuments',
    label: '電傳文件',
    builder: (visitId) => ElectronicDocumentsPage(visitId: visitId),
  ),
  RouteItem(
    path: '/referralForm',
    label: '轉診單',
    builder: (visitId) => ReferralFormPage(visitId: visitId),
  ),
  RouteItem(
    path: '/nursingRecord',
    label: '護理紀錄表',
    builder: (visitId) => NursingRecordPage(visitId: visitId),
  ),
];

/// 依照 routeItems 產生 routes
Map<String, WidgetBuilder> generateRoutes() {
  return {
    for (int i = 0; i < routeItems.length; i++)
      routeItems[i].path: (context) {
        // 從路由參數中獲取 visitId
        // 使用 ! 確保 arguments 不是 null，因為我們知道 HomePage 會傳遞它
        final visitId = ModalRoute.of(context)!.settings.arguments as int;

        // 返回函式：使用 Navigator.pop(context) 返回上一頁 (即 HomePage)
        final closeNav2 = () => Navigator.pop(context);

        return Nav2Page(
          initialIndex: i, // 讓 Nav2Page 知道當前應該哪個 Tab 被選中
          visitId: visitId,
          closeNav2: closeNav2,
          // 內容：使用 builder 產生的 Widget (例如 PersonalInformationPage)
          child: routeItems[i].builder(visitId),
        );
      },
  };
}
