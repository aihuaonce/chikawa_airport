// lib/data/models/medical_costs_data.dart
import 'package:flutter/material.dart';

class MedicalCostsData extends ChangeNotifier {
  // 費用收取方式
  String? chargeMethod;

  // 費用（儲存文字輸入框的原始字串）
  String? visitFee;
  String? ambulanceFee;

  // 收費備註
  String? note;

  // 圖片和簽名路徑（預留）
  String? photoPath;
  String? agreementSignaturePath;
  String? witnessSignaturePath;

  // 動態計算總費用
  double get totalFee {
    final double visit = double.tryParse(visitFee ?? '0') ?? 0;
    final double ambulance = double.tryParse(ambulanceFee ?? '0') ?? 0;
    return visit + ambulance;
  }

  // 通知 UI 更新
  void update() {
    notifyListeners();
  }

  // 清除所有資料
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
}
