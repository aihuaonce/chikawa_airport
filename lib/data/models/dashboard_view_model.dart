import 'package:flutter/foundation.dart';
import 'record_page.dart';

class DashboardViewModel extends ChangeNotifier {
  int _currentPage = 1;
  final int _pageSize = 5;
  RecordPage _currentFilter = RecordPage.primary;

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get offset => (_currentPage - 1) * _pageSize;
  RecordPage get currentFilter => _currentFilter;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setFilter(RecordPage filter) {
    _currentFilter = filter;
    _currentPage = 1; // Reset to first page
    notifyListeners();
  }
}
