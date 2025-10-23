// routes_config.dart
import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';
import '../PersonalInformation.dart';
import '../AccidentRecord.dart';
import '../FlightLog.dart';
import '../Plan.dart';
import '../MedicalExpenses.dart';
import '../MedicalCertificate.dart';
import '../Undertaking.dart';
import '../ElectronicDocuments.dart';
import '../NursingRecord.dart';
import '../ReferralForm.dart';

class RouteItem {
  final String label;
  final Widget Function(int visitId, GlobalKey key) builder;

  RouteItem({required this.label, required this.builder});
}

// 將靜態列表轉換為一個接收 AppTranslations 的函式
List<RouteItem> getRouteItems(AppTranslations t) {
  return [
    RouteItem(
      label: t.personalInformation,
      builder: (visitId, key) =>
          PersonalInformationPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.flightRecord,
      builder: (visitId, key) => FlightLogPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.accidentRecord,
      builder: (visitId, key) => AccidentRecordPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.treatmentRecord,
      builder: (visitId, key) => PlanPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.medicalExpenses,
      builder: (visitId, key) =>
          MedicalExpensesPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.medicalCertificateNav,
      builder: (visitId, key) =>
          MedicalCertificatePage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.refusedReferralNav,
      builder: (visitId, key) => UndertakingPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.electronicDocuments,
      builder: (visitId, key) =>
          ElectronicDocumentsPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.referralFormNav,
      builder: (visitId, key) => ReferralFormPage(key: key, visitId: visitId),
    ),
    RouteItem(
      label: t.nursingRecordFormNav,
      builder: (visitId, key) => NursingRecordPage(key: key, visitId: visitId),
    ),
    // 未來其他頁面...
  ];
}
