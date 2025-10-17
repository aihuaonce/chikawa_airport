// ==================== 9️⃣ body_map_data.dart ====================
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

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

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, PatientProfilesDao dao) async {
    try {
      await dao.upsertBodyMap(visitId, bodyMapJson);
      print('✅ BodyMap 已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
