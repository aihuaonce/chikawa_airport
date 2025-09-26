import 'package:flutter/material.dart';
import 'PersonalInformation.dart';

class RouteItem {
  final String path;
  final String label;
  final Widget Function(int visitId, Key key) builder;

  RouteItem({required this.path, required this.label, required this.builder});
}

final List<RouteItem> routeItems = [
  RouteItem(
    path: '/personalInformation',
    label: '個人資料',
    builder: (visitId, key) =>
        PersonalInformationPage(key: key, visitId: visitId),
  ),
];
