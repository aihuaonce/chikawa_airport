import 'package:flutter/material.dart';

class AppNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners(); // 通知所有正在監聽的 Widget 更新！
    }
  }
}
