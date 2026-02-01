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
    return (select(medicalFees)
          ..where((f) => f.medicalId.equals(medicalId)))
        .getSingleOrNull();
  }

  // 建立新的醫療費用記錄
  Future<int> createFee(int medicalId) {
    return into(medicalFees).insert(
      MedicalFeesCompanion.insert(
        medicalId: medicalId,
        consultFee: const Value(0),
        ambulanceFee: const Value(0),
      ),
    );
  }

  // 更新付款方式
  Future<int> updatePaymentMethod(int feeId, int? paymentMethodId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(paymentMethodId: Value(paymentMethodId)),
    );
  }

  // 更新出診費
  Future<int> updateConsultFee(int feeId, double fee) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(consultFee: Value(fee)),
    );
  }

  // 更新救護車費
  Future<int> updateAmbulanceFee(int feeId, double fee) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(ambulanceFee: Value(fee)),
    );
  }

  // 更新貨幣
  Future<int> updateCurrency(int feeId, int? currencyId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(currencyId: Value(currencyId)),
    );
  }

  // 更新收款狀態
  Future<int> updateCollectionStatus(int feeId, int? collectionStatusId) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(collectionStatusId: Value(collectionStatusId)),
    );
  }

  // 更新收據開立狀態
  Future<int> updateReceiptIssued(int feeId, bool issued) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(receiptIssued: Value(issued)),
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
      ),
    );
  }

  // 更新備註
  Future<int> updateRemarks(int feeId, String? remarks) {
    return (update(medicalFees)..where((f) => f.feeId.equals(feeId))).write(
      MedicalFeesCompanion(remarks: Value(remarks)),
    );
  }

  // 刪除醫療費用記錄
  Future<int> deleteFee(int feeId) {
    return (delete(medicalFees)..where((f) => f.feeId.equals(feeId))).go();
  }
}
