// ==================== 4️⃣ flightlog_data.dart ====================
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class FlightLogData extends ChangeNotifier {
  // ✅ 改為直接存文字
  String? airline; // 航空公司（直接存文字，如 "長榮航空"）
  String? flightNo;
  String? travelStatus; // 旅遊狀態（直接存文字，如 "出境"）

  final TextEditingController flightNoCtrl = TextEditingController();
  final FocusNode flightNoFocus = FocusNode();

  final TextEditingController otherTravelCtrl = TextEditingController();
  final FocusNode otherTravelFocus = FocusNode();

  String? departure;
  String? via;
  String? destination;

  void update() {
    notifyListeners();
  }

  void clear() {
    airline = null;
    flightNo = null;
    travelStatus = null;

    flightNoCtrl.clear();
    otherTravelCtrl.clear();

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

  // ✅ 轉換為 Companion
  FlightLogsCompanion toCompanion(int visitId) {
    return FlightLogsCompanion(
      visitId: Value(visitId),
      airline: Value(airline), // 直接存文字
      flightNo: Value(flightNo),
      travelStatus: Value(travelStatus), // 直接存文字
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
