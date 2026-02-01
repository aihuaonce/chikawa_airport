import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class MedicalFeeViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // 費用資料快取
  MedicalFeeData? _feeCache;
  MedicalFeeData? get fee => _feeCache;

  // 計算總費用
  double get totalAmount =>
      (_feeCache?.consultFee ?? 0) + (_feeCache?.ambulanceFee ?? 0);

  // 參考資料 Getters
  List<PaymentMethodData> get paymentMethods => refService.paymentMethodList;
  List<CollectionStatusData> get collectionStatuses =>
      refService.collectionStatusList;
  List<CurrencyRefData> get currencies => refService.currencyList;

  // 選中的參考資料
  PaymentMethodData? get selectedPaymentMethod {
    if (_feeCache?.paymentMethodId == null) return null;
    return paymentMethods.firstWhere(
      (m) => m.id == _feeCache!.paymentMethodId,
      orElse: () => paymentMethods.first,
    );
  }

  CollectionStatusData? get selectedCollectionStatus {
    if (_feeCache?.collectionStatusId == null) return null;
    return collectionStatuses.firstWhere(
      (s) => s.id == _feeCache!.collectionStatusId,
      orElse: () => collectionStatuses.first,
    );
  }

  CurrencyRefData? get selectedCurrency {
    if (_feeCache?.currencyId == null) return null;
    return currencies.firstWhere(
      (c) => c.id == _feeCache!.currencyId,
      orElse: () => currencies.firstWhere(
        (c) => c.code == 'TWD',
        orElse: () => currencies.first,
      ),
    );
  }

  // 延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  MedicalFeeViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    _feeCache = await db.medicalFeeDao.getFeeByMedicalId(medicalId);

    if (_feeCache == null) {
      debugPrint('系統：醫療費用記錄不存在，建立預設記錄');
      await _createDefaultFee();
      _feeCache = await db.medicalFeeDao.getFeeByMedicalId(medicalId);
    }

    notifyListeners();
  }

  // 建立預設費用記錄
  Future<void> _createDefaultFee() async {
    try {
      await db.medicalFeeDao.createFee(medicalId);
      debugPrint('系統：已建立預設醫療費用記錄');
    } catch (e) {
      debugPrint('系統：建立預設醫療費用記錄失敗 - $e');
    }
  }

  // 更新付款方式
  void updatePaymentMethod(int? methodId) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(paymentMethodId: Value(methodId));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updatePaymentMethod(_feeCache!.feeId, methodId),
    );
  }

  // 更新出診費
  void updateConsultFee(double fee) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(consultFee: fee);
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateConsultFee(_feeCache!.feeId, fee),
    );
  }

  // 更新救護車費
  void updateAmbulanceFee(double fee) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(ambulanceFee: fee);
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateAmbulanceFee(_feeCache!.feeId, fee),
    );
  }

  // 更新貨幣
  void updateCurrency(int? currencyId) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(currencyId: Value(currencyId));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateCurrency(_feeCache!.feeId, currencyId),
    );
  }

  // 更新收款狀態
  void updateCollectionStatus(int? statusId) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(collectionStatusId: Value(statusId));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateCollectionStatus(_feeCache!.feeId, statusId),
    );
  }

  // 更新收據開立狀態
  void updateReceiptIssued(bool issued) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(receiptIssued: issued);
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateReceiptIssued(_feeCache!.feeId, issued),
    );
  }

  // 更新申請人資訊
  void updateApplicantInfo({String? name, String? unit, String? phone}) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(
      applicantName: Value(name),
      applicantUnit: Value(unit),
      applicantPhone: Value(phone),
    );
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateApplicantInfo(
        _feeCache!.feeId,
        name: name,
        unit: unit,
        phone: phone,
      ),
    );
  }

  // 更新備註
  void updateRemarks(String? remarks) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(remarks: Value(remarks));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateRemarks(_feeCache!.feeId, remarks),
    );
  }

  // 延遲存檔
  void _debounceSave(Future<int> Function() saveFunc) {
    _debounceTimer?.cancel();
    _saveStatus = SaveStatus.saving;
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      try {
        await saveFunc();
        _saveStatus = SaveStatus.success;
        debugPrint('系統：醫療費用已自動儲存');
      } catch (e) {
        debugPrint('系統：醫療費用儲存失敗 - $e');
        _saveStatus = SaveStatus.idle;
      }
      notifyListeners();

      Future.delayed(const Duration(seconds: 2), () {
        _saveStatus = SaveStatus.idle;
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
