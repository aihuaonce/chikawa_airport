// ==================== 7️⃣ electronic_document_data.dart ====================
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class ElectronicDocumentData extends ChangeNotifier {
  int? toSelectedIndex;
  int? fromSelectedIndex;

  void update() {
    notifyListeners();
  }

  void clear() {
    toSelectedIndex = null;
    fromSelectedIndex = null;
    notifyListeners();
  }

  // ✅ 新增：轉換為 Companion
  ElectronicDocumentsCompanion toCompanion(int visitId) {
    return ElectronicDocumentsCompanion(
      visitId: Value(visitId),
      toSelectedIndex: Value(toSelectedIndex),
      fromSelectedIndex: Value(fromSelectedIndex),
    );
  }

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, ElectronicDocumentsDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      print('✅ 電子文件已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
