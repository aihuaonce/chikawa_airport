import 'package:flutter/foundation.dart';
import 'record_page.dart';

class DashboardViewModel extends ChangeNotifier {
  int _currentPage = 1;
  final int _pageSize = 5;
  RecordPage _currentFilter = RecordPage.primary;
  String _searchKeyword = '';

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get offset => (_currentPage - 1) * _pageSize;
  RecordPage get currentFilter => _currentFilter;
  String get searchKeyword => _searchKeyword;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setFilter(RecordPage filter) {
    _currentFilter = filter;
    _currentPage = 1; // Reset to first page
    notifyListeners();
  }

  void setSearchKeyword(String keyword) {
    final normalized = keyword.trim();
    if (_searchKeyword == normalized) return;
    _searchKeyword = normalized;
    _currentPage = 1;
    notifyListeners();
  }
}
