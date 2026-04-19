import 'dart:async';
import 'package:drift/drift.dart';
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

  // 從遠端刷新資料
  Future<void> refreshFromRemote() async {
    debugPrint('MedicalFeeViewModel: refreshFromRemote() called');
    _feeCache = await db.medicalFeeDao.getFeeByMedicalId(medicalId);
    notifyListeners();
    debugPrint(
      'MedicalFeeViewModel: refreshFromRemote() done, fee: $_feeCache',
    );
  }

  // 更新付款方式
  void updatePaymentMethod(int? methodId) {
    if (_feeCache == null) return;

    // 如果付款方式改變，清除特定欄位
    if (_feeCache!.paymentMethodId != methodId) {
      _feeCache = _feeCache!.copyWith(
        paymentMethodId: Value(methodId),
        paymentType: const Value(null),
        applicantName: const Value(null),
        applicantUnit: const Value(null),
        applicantPhone: const Value(null),
        receiptIssued: false,
        abnormalReason: const Value(null),
        counterSignature: const Value(null),
      );

      notifyListeners();

      _debounceSave(() async {
        // 先清除舊資料
        await db.medicalFeeDao.clearPaymentMethodSpecificData(_feeCache!.feeId);
        // 再更新付款方式
        return db.medicalFeeDao.updatePaymentMethod(_feeCache!.feeId, methodId);
      });
    }
  }

  // 更新自付方式
  void updatePaymentType(String? type) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(paymentType: Value(type));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updatePaymentType(_feeCache!.feeId, type),
    );
  }

  // 更新收費異常原因
  void updateAbnormalReason(String? reason) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(abnormalReason: Value(reason));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateAbnormalReason(_feeCache!.feeId, reason),
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

  // 更新使用者同意狀態
  void updateUserAgreed(bool agreed) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(userAgreed: agreed);
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateUserAgreed(_feeCache!.feeId, agreed),
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

  // 搜尋貨幣
  Future<List<CurrencyRefData>> searchCurrencies(String keyword) async {
    if (keyword.isEmpty) return refService.currencyList;
    final lower = keyword.toLowerCase();
    return refService.currencyList
        .where(
          (c) =>
              c.code.toLowerCase().contains(lower) ||
              c.name.toLowerCase().contains(lower),
        )
        .toList();
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

  // 更新同意人簽名
  void updateConsenterSignature(Uint8List? signature) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(consenterSignature: Value(signature));
    notifyListeners();
    _debounceSave(
      () => db.medicalFeeDao.updateConsenterSignature(
        _feeCache!.feeId,
        signature,
      ),
    );
  }

  // 更新見證人簽名
  void updateWitnessSignature(Uint8List? signature) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(witnessSignature: Value(signature));
    notifyListeners();
    _debounceSave(
      () =>
          db.medicalFeeDao.updateWitnessSignature(_feeCache!.feeId, signature),
    );
  }

  // 更新緊急醫療救護人員簽章
  void updateCounterSignature(Uint8List? signature) {
    if (_feeCache == null) return;
    _feeCache = _feeCache!.copyWith(counterSignature: Value(signature));
    notifyListeners();
    _debounceSave(
      () =>
          db.medicalFeeDao.updateCounterSignature(_feeCache!.feeId, signature),
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
