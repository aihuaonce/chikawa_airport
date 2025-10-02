// lib/data/models/body_map_data.dart
import 'package:flutter/material.dart';

class BodyMapData extends ChangeNotifier {
  String? bodyMapJson;

  void setBodyMap(String? json) {
    bodyMapJson = json;
    notifyListeners();
  }

  void clear() {
    bodyMapJson = null;
    notifyListeners();
  }
}
