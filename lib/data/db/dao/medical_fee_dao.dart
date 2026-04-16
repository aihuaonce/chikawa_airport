import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'medical_fee_dao.g.dart';

@DriftAccessor(tables: [MedicalFees])
class MedicalFeeDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalFeeDaoMixin {
  MedicalFeeDao(super.db);

  // 根據 medicalId 取得醫療費用
  Future<MedicalFeeData?> getFeeByMedicalId(int medicalId) {
    return (select(
      medicalFees,
    )..where((f) => f.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立新的醫療費用記錄
  Future<int> createFee(int medicalId) {
    return into(medicalFees).insert(
      MedicalFeesCompanion.insert(
        medicalId: medicalId,
        consultFee: const Value(0),
        ambulanceFee: const Value(0),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新付款方式
  Future<int> updatePaymentMethod(int feeId, int? paymentMethodId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        paymentMethodId: Value(paymentMethodId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新自付方式
  Future<int> updatePaymentType(int feeId, String? paymentType) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        paymentType: Value(paymentType),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新收費異常原因
  Future<int> updateAbnormalReason(int feeId, String? reason) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        abnormalReason: Value(reason),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 清除特定付款方式的資料 (切換付款方式時使用)
  Future<int> clearPaymentMethodSpecificData(int feeId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        paymentType: const Value(null),
        applicantName: const Value(null),
        applicantUnit: const Value(null),
        applicantPhone: const Value(null),
        receiptIssued: const Value(false),
        abnormalReason: const Value(null),
        counterSignature: const Value(null),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新出診費
  Future<int> updateConsultFee(int feeId, double fee) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        consultFee: Value(fee),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新救護車費
  Future<int> updateAmbulanceFee(int feeId, double fee) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        ambulanceFee: Value(fee),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新貨幣
  Future<int> updateCurrency(int feeId, int? currencyId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        currencyId: Value(currencyId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新收款狀態
  Future<int> updateCollectionStatus(int feeId, int? collectionStatusId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        collectionStatusId: Value(collectionStatusId),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新收據開立狀態
  Future<int> updateReceiptIssued(int feeId, bool issued) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        receiptIssued: Value(issued),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新使用者同意狀態
  Future<int> updateUserAgreed(int feeId, bool agreed) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        userAgreed: Value(agreed),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新申請人資訊（統一請款用）
  Future<int> updateApplicantInfo(
    int feeId, {
    String? name,
    String? unit,
    String? phone,
  }) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        applicantName: Value(name),
        applicantUnit: Value(unit),
        applicantPhone: Value(phone),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新備註
  Future<int> updateRemarks(int feeId, String? remarks) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        remarks: Value(remarks),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新同意人簽名
  Future<int> updateConsenterSignature(int feeId, Uint8List? signature) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        consenterSignature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新見證人簽名
  Future<int> updateWitnessSignature(int feeId, Uint8List? signature) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        witnessSignature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新緊急醫療救護人員簽章
  Future<int> updateCounterSignature(int feeId, Uint8List? signature) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(
        counterSignature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 刪除醫療費用記錄
  Future<int> deleteFee(int feeId) {
    return (delete(medicalFees)..where((f) => f.feeId.equals(feeId))).go();
  }
}
