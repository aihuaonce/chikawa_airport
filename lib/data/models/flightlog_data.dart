// ==================== 4️⃣ flightlog_data.dart ====================
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class FlightLogData extends ChangeNotifier {
  int? airlineIndex;
  bool useOtherAirline = false;
  String? selectedOtherAirline;
  String? flightNo;
  String? otherTravelStatus;

  final TextEditingController flightNoCtrl = TextEditingController();
  final FocusNode flightNoFocus = FocusNode();

  int? travelStatusIndex;
  final TextEditingController otherTravelCtrl = TextEditingController();
  final FocusNode otherTravelFocus = FocusNode();

  String? departure;
  String? via;
  String? destination;

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

  // ✅ 新增：轉換為 Companion
  FlightLogsCompanion toCompanion(int visitId) {
    return FlightLogsCompanion(
      visitId: Value(visitId),
      airlineIndex: Value(airlineIndex),
      useOtherAirline: Value(useOtherAirline),
      otherAirline: Value(selectedOtherAirline),
      flightNo: Value(flightNo),
      travelStatusIndex: Value(travelStatusIndex),
      otherTravelStatus: Value(otherTravelStatus),
      departure: Value(departure),
      via: Value(via),
      destination: Value(destination),
    );
  }

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, FlightLogsDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      print('✅ 航班記錄已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
