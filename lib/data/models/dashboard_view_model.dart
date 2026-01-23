import 'package:flutter/foundation.dart';

class DashboardViewModel extends ChangeNotifier {
  int _currentPage = 1;
  final int _pageSize = 5;

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get offset => (_currentPage - 1) * _pageSize;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}
