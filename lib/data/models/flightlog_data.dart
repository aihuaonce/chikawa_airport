// data/models/flightlog_data.dart
import 'package:flutter/material.dart';

class FlightLogData extends ChangeNotifier {
  // ----------------- 航空公司 -----------------
  int? airlineIndex; // 主要航空公司 index
  bool useOtherAirline = false; // 是否選擇「其他航空公司」
  String? selectedOtherAirline; // 其他航空公司名稱

  String? flightNo;
  String? otherTravelStatus;

  // ----------------- 班機號碼 -----------------
  final TextEditingController flightNoCtrl = TextEditingController();
  final FocusNode flightNoFocus = FocusNode();

  // ----------------- 旅行狀態 -----------------
  int? travelStatusIndex; // 出境 / 入境 / ... / 其他
  final TextEditingController otherTravelCtrl = TextEditingController();
  final FocusNode otherTravelFocus = FocusNode();

  // ----------------- 地點 -----------------
  String? departure; // 啟程地
  String? via; // 經過地
  String? destination; // 目的地

  // ----------------- 方法 -----------------
  void update() {
    notifyListeners();
  }

  void clear() {
    airlineIndex = null;
    useOtherAirline = false;
    selectedOtherAirline = null;
    flightNo = null;

    flightNoCtrl.clear();
    otherTravelCtrl.clear();

    travelStatusIndex = null;
    departure = null;
    via = null;
    destination = null;

    notifyListeners();
  }

  @override
  void dispose() {
    flightNoCtrl.dispose();
    flightNoFocus.dispose();
    otherTravelCtrl.dispose();
    otherTravelFocus.dispose();
    super.dispose();
  }
}
