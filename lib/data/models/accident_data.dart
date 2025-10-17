// ==================== 1️⃣ accident_data.dart ====================
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class AccidentData extends ChangeNotifier {
  DateTime? incidentDate;
  DateTime? notifyTime;
  DateTime? pickUpTime;
  DateTime? medicDepartTime;
  DateTime? medicArriveTime;
  DateTime? landingTime;
  DateTime? checkTime;

  int? reportUnitIdx;
  String? otherReportUnit;
  String? notifier;
  String? phone;
  int? placeGroupIdx;
  String? placeNote;
  bool occArrived = false;
  String? cost;
  int? within10min;

  int? t1Selected;
  int? t2Selected;
  int? remoteSelected;
  int? cargoSelected;
  int? novotelSelected;
  int? cabinSelected;

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

  // ✅ 新增：轉換為 Companion
  AccidentRecordsCompanion toCompanion(int visitId) {
    return AccidentRecordsCompanion(
      visitId: Value(visitId),
      incidentDate: Value(incidentDate),
      notifyTime: Value(notifyTime),
      pickUpTime: Value(pickUpTime),
      medicArriveTime: Value(medicArriveTime),
      ambulanceDepartTime: Value(medicDepartTime),
      checkTime: Value(checkTime),
      landingTime: Value(landingTime),
      reportUnitIdx: Value(reportUnitIdx),
      otherReportUnit: Value(otherReportUnit),
      notifier: Value(notifier),
      phone: Value(phone),
      placeIdx: Value(placeGroupIdx),
      placeNote: Value(placeNote),
      t1PlaceIdx: Value(t1Selected),
      t2PlaceIdx: Value(t2Selected),
      remotePlaceIdx: Value(remoteSelected),
      cargoPlaceIdx: Value(cargoSelected),
      novotelPlaceIdx: Value(novotelSelected),
      cabinPlaceIdx: Value(cabinSelected),
      occArrived: Value(occArrived),
      cost: Value(cost),
      within10min: Value(within10min),
      reasonLanding: Value(reasonPreLanding),
      reasonOnline: Value(reasonOnDuty),
      reasonOther: Value(reasonOther),
      reasonOtherText: Value(otherReasonText),
    );
  }

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, AccidentRecordsDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      print('✅ 事故記錄已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
