//body_map_data.dart
import 'package:flutter/material.dart';

class BodyMapData extends ChangeNotifier {
  String? _bodyMapJson;
  int? _currentVisitId;

  String? get bodyMapJson => _bodyMapJson;
  int? get currentVisitId => _currentVisitId;

  void setBodyMap(String? json, {int? visitId}) {
    _bodyMapJson = json;
    if (visitId != null) {
      _currentVisitId = visitId;
    }
    notifyListeners();
  }

  void clear() {
    _bodyMapJson = null;
    _currentVisitId = null;
    notifyListeners();
  }

  bool isForVisit(int visitId) {
    return _currentVisitId == visitId;
  }
}
