import 'package:flutter/material.dart';

/// 急救紀錄單的分頁導航 Provider
/// 只負責管理當前選中的分頁索引
class EmergencyNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}