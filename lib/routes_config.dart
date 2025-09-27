import 'package:flutter/material.dart';
import 'PersonalInformation.dart';

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
  // 可以加入其他頁面
];
