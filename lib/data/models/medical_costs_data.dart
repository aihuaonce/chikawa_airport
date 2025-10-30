//medical_costs_data.dart
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

  String? paymentMethod; // '現金' or '刷卡'

  String? paymentStatus; // '尚未收款', '已收款', '不需要'
  String? selectedCurrency; // '台幣', '美金', '人民幣', '日幣', '加幣'
  String? foreignCurrencyAmount; // 外幣金額
  String? convertedTwdAmount; // 兌換後的台幣金額

  String? applicantName; // 申請人
  String? applicantUnit; // 申請單位
  String? contactPhone; // 聯絡電話

  bool? receiptIssuedAndTransferred; // 已開立收據並轉交

  String? billingErrorReason; // 收費異常原因

  // ========== 計算總費用 ==========
  double get totalFee {
    final double visit = double.tryParse(visitFee ?? '0') ?? 0;
    final double ambulance = double.tryParse(ambulanceFee ?? '0') ?? 0;
    return visit + ambulance;
  }

  // ========== 通知更新 ==========
  void update() => notifyListeners();

  // ========== 清空所有資料 ==========
  void clear() {
    chargeMethod = null;
    visitFee = null;
    ambulanceFee = null;
    note = null;
    photoPath = null;
    agreementSignaturePath = null;
    witnessSignaturePath = null;

    paymentMethod = null;
    paymentStatus = null;
    selectedCurrency = null;
    foreignCurrencyAmount = null;
    convertedTwdAmount = null;
    applicantName = null;
    applicantUnit = null;
    contactPhone = null;
    receiptIssuedAndTransferred = null;
    billingErrorReason = null;

    notifyListeners();
  }

  Value<T> _safeValue<T>(T? value) =>
      value != null ? Value(value) : const Value.absent();

  MedicalCostsCompanion toCompanion(int visitId) {
    return MedicalCostsCompanion(
      visitId: Value(visitId),
      chargeMethod: _safeValue(chargeMethod),
      visitFee: _safeValue(visitFee),
      ambulanceFee: _safeValue(ambulanceFee),
      note: _safeValue(note),
      photoPath: _safeValue(photoPath),
      agreementSignaturePath: _safeValue(agreementSignaturePath),
      witnessSignaturePath: _safeValue(witnessSignaturePath),
      paymentMethod: _safeValue(paymentMethod),
      paymentStatus: _safeValue(paymentStatus),
      selectedCurrency: _safeValue(selectedCurrency),
      foreignCurrencyAmount: _safeValue(foreignCurrencyAmount),
      convertedTwdAmount: _safeValue(convertedTwdAmount),
      applicantName: _safeValue(applicantName),
      applicantUnit: _safeValue(applicantUnit),
      contactPhone: _safeValue(contactPhone),
      receiptIssuedAndTransferred: _safeValue(receiptIssuedAndTransferred),
      billingErrorReason: _safeValue(billingErrorReason),
    );
  }

  Future<bool> saveToDatabase(int visitId, MedicalCostsDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      debugPrint('費用記錄已成功儲存 (visitId=$visitId)');
      return true;
    } catch (e, stack) {
      debugPrint('儲存失敗: $e\n$stack');
      return false;
    }
  }
}
