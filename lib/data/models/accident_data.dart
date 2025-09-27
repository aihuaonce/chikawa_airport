// data/models/accident_data.dart
import 'package:flutter/material.dart';

class AccidentData extends ChangeNotifier {
  // 時間相關
  DateTime? incidentDate;
  DateTime? notifyTime;
  DateTime? pickUpTime;
  DateTime? medicDepartTime;
  DateTime? medicArriveTime;
  DateTime? landingTime;
  DateTime? checkTime;

  // 基本資訊
  int? reportUnitIdx;
  String? otherReportUnit;
  String? notifier;
  String? phone;
  int? placeGroupIdx;
  String? placeNote;
  bool occArrived = false;
  String? cost;
  int? within10min;

  // 地點細項選擇
  int? t1Selected;
  int? t2Selected;
  int? remoteSelected;
  int? cargoSelected;
  int? novotelSelected;
  int? cabinSelected;

  // 原因選項
  bool reasonPreLanding = false;
  bool reasonOnDuty = false;
  bool reasonOther = false;
  String? otherReasonText;

  void update() {
    notifyListeners();
  }

  void clear() {
    incidentDate = null;
    notifyTime = null;
    pickUpTime = null;
    medicDepartTime = null;
    medicArriveTime = null;
    landingTime = null;
    checkTime = null;
    reportUnitIdx = null;
    otherReportUnit = null;
    notifier = null;
    phone = null;
    placeGroupIdx = null;
    placeNote = null;
    occArrived = false;
    cost = null;
    within10min = null;
    t1Selected = t2Selected = remoteSelected = cargoSelected = novotelSelected =
        cabinSelected = null;
    reasonPreLanding = false;
    reasonOnDuty = false;
    reasonOther = false;
    otherReasonText = null;
    notifyListeners();
  }
}
