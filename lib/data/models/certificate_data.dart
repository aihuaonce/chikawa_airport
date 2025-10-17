// ==================== 5️⃣ certificate_data.dart ====================
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class CertificateData extends ChangeNotifier {
  String? diagnosis;
  int? instructionOption;
  String? chineseInstruction;
  String? englishInstruction;
  DateTime? issueDate;

  void update() {
    notifyListeners();
  }

  void clear() {
    diagnosis = null;
    instructionOption = null;
    chineseInstruction = null;
    englishInstruction = null;
    issueDate = null;
    notifyListeners();
  }

  // ✅ 新增：轉換為 Companion
  MedicalCertificatesCompanion toCompanion(int visitId) {
    return MedicalCertificatesCompanion(
      visitId: Value(visitId),
      diagnosis: Value(diagnosis),
      instructionOption: Value(instructionOption),
      chineseInstruction: Value(chineseInstruction),
      englishInstruction: Value(englishInstruction),
      issueDate: Value(issueDate),
    );
  }

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, MedicalCertificatesDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      print('✅ 診斷書已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
