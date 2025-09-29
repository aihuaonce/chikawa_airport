// routes_config.dart
import 'package:flutter/material.dart';
import 'PersonalInformation.dart';
import 'AccidentRecord.dart';
import 'FlightLog.dart';
import 'Plan.dart';
import 'MedicalExpenses.dart';

class RouteItem {
  final String label;
  final Widget Function(int visitId, GlobalKey key) builder;
  RouteItem({required this.label, required this.builder});
}

final List<RouteItem> routeItems = [
  RouteItem(
    label: '個人資料',
    builder: (visitId, key) =>
        PersonalInformationPage(key: key, visitId: visitId),
  ),
  RouteItem(
    label: '飛航紀錄',
    builder: (visitId, key) => FlightLogPage(key: key, visitId: visitId),
  ),
  RouteItem(
    label: '事故紀錄',
    builder: (visitId, key) => AccidentRecordPage(key: key, visitId: visitId),
  ),
  RouteItem(
    label: '處置紀錄',
    builder: (visitId, key) => PlanPage(key: key, visitId: visitId),
  ),
  RouteItem(
    label: '醫療費用',
    builder: (visitId, key) => MedicalExpensesPage(key: key, visitId: visitId),
  ),
  // 未來其他頁面...
];
