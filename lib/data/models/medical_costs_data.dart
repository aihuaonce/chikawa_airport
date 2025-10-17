// ==================== 6️⃣ medical_costs_data.dart ====================
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class MedicalCostsData extends ChangeNotifier {
  String? chargeMethod;
  String? visitFee;
  String? ambulanceFee;
  String? note;
  String? photoPath;
  String? agreementSignaturePath;
  String? witnessSignaturePath;

  double get totalFee {
    final double visit = double.tryParse(visitFee ?? '0') ?? 0;
    final double ambulance = double.tryParse(ambulanceFee ?? '0') ?? 0;
    return visit + ambulance;
  }

  void update() {
    notifyListeners();
  }

  void clear() {
    chargeMethod = null;
    visitFee = null;
    ambulanceFee = null;
    note = null;
    photoPath = null;
    agreementSignaturePath = null;
    witnessSignaturePath = null;
    notifyListeners();
  }

  // ✅ 新增：轉換為 Companion
  MedicalCostsCompanion toCompanion(int visitId) {
    return MedicalCostsCompanion(
      visitId: Value(visitId),
      chargeMethod: Value(chargeMethod),
      visitFee: Value(visitFee),
      ambulanceFee: Value(ambulanceFee),
      note: Value(note),
      photoPath: Value(photoPath),
      agreementSignaturePath: Value(agreementSignaturePath),
      witnessSignaturePath: Value(witnessSignaturePath),
    );
  }

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, MedicalCostsDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      print('✅ 費用記錄已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
