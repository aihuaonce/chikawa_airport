import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'referral_form_dao.g.dart';

@DriftAccessor(tables: [ReferralForms])
class ReferralFormDao extends DatabaseAccessor<AppDatabase>
    with _$ReferralFormDaoMixin {
  ReferralFormDao(super.db);

  // 根據 medicalId 取得轉診單
  Future<ReferralFormData?> getFormByMedicalId(int medicalId) {
    return (select(
      referralForms,
    )..where((f) => f.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立新的轉診單
  Future<int> createForm(int medicalId) {
    return into(referralForms).insert(
      ReferralFormsCompanion.insert(
        medicalId: medicalId,
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 聯絡人資料 ==========
  Future<int> updateContactInfo(
    int formId, {
    String? name,
    String? phone,
    String? address,
    String? idNo,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        contactName: Value(name),
        contactPhone: Value(phone),
        contactAddress: Value(address),
        contactIdNo: Value(idNo),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 診斷 ==========
  Future<int> updateDiagnosis(
    int formId, {
    String? primary,
    String? secondary1,
    String? secondary2,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        primaryDiagnosis: Value(primary),
        secondaryDiagnosis1: Value(secondary1),
        secondaryDiagnosis2: Value(secondary2),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 檢查及治療摘要 ==========
  Future<int> updateExamSummary(
    int formId, {
    String? recentExamResult,
    DateTime? examDate,
    String? recentMedication,
    DateTime? medicationDate,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        recentExamResult: Value(recentExamResult),
        examDate: Value(examDate),
        recentMedication: Value(recentMedication),
        medicationDate: Value(medicationDate),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 轉診目的 ==========
  Future<int> updateReferralPurpose(
    int formId, {
    int? purposeId,
    String? otherPurpose,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        referralPurposeId: Value(purposeId),
        otherPurpose: Value(otherPurpose),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 醫師交辦與簽署 ==========
  Future<int> updateDoctorInfo(
    int formId, {
    String? name,
    String? department,
    DateTime? orderDate,
    String? notes,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        doctorName: Value(name),
        doctorDepartment: Value(department),
        orderDate: Value(orderDate),
        notes: Value(notes),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  Future<int> updateDoctorSignature(int formId, Uint8List signature) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        doctorSignature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 建議轉診院所 ==========
  Future<int> updateHospitalInfo(
    int formId, {
    String? name,
    String? dept,
    String? doctor,
    String? phone,
    String? address,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        hospitalName: Value(name),
        hospitalDept: Value(dept),
        hospitalDoctor: Value(doctor),
        hospitalPhone: Value(phone),
        hospitalAddress: Value(address),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 安排就醫 ==========
  Future<int> updateScheduledVisit(
    int formId, {
    DateTime? date,
    String? dept,
    String? room,
    String? number,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        scheduledDate: Value(date),
        scheduledDept: Value(dept),
        scheduledRoom: Value(room),
        scheduledNumber: Value(number),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // ========== 聲明與同意 ==========
  Future<int> updateConsent(
    int formId, {
    int? relationshipId,
    String? otherRelationship,
    DateTime? consentDateTime,
  }) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        relationshipId: Value(relationshipId),
        otherRelationship: Value(otherRelationship),
        consentDateTime: Value(consentDateTime),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  Future<int> updateConsentSignature(int formId, Uint8List signature) {
    return (update(referralForms)..where((f) => f.formId.equals(formId))).write(
      ReferralFormsCompanion(
        consentSignature: Value(signature),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 刪除轉診單
  Future<int> deleteForm(int formId) {
    return (delete(referralForms)..where((f) => f.formId.equals(formId))).go();
  }

  // 更新轉診單 (通用)
  Future<int> updateReferralForm(ReferralFormsCompanion form) {
    if (!form.formId.present) {
      throw ArgumentError('formId must be present for update');
    }
    return (update(
      referralForms,
    )..where((f) => f.formId.equals(form.formId.value))).write(
      ReferralFormsCompanion(
        // 保留原有資料，只更新 syncStatus
        contactName: form.contactName,
        contactPhone: form.contactPhone,
        contactAddress: form.contactAddress,
        contactIdNo: form.contactIdNo,
        primaryDiagnosis: form.primaryDiagnosis,
        secondaryDiagnosis1: form.secondaryDiagnosis1,
        secondaryDiagnosis2: form.secondaryDiagnosis2,
        recentExamResult: form.recentExamResult,
        examDate: form.examDate,
        recentMedication: form.recentMedication,
        medicationDate: form.medicationDate,
        referralPurposeId: form.referralPurposeId,
        otherPurpose: form.otherPurpose,
        doctorName: form.doctorName,
        doctorDepartment: form.doctorDepartment,
        orderDate: form.orderDate,
        notes: form.notes,
        hospitalName: form.hospitalName,
        hospitalDept: form.hospitalDept,
        hospitalDoctor: form.hospitalDoctor,
        hospitalPhone: form.hospitalPhone,
        hospitalAddress: form.hospitalAddress,
        scheduledDate: form.scheduledDate,
        scheduledDept: form.scheduledDept,
        scheduledRoom: form.scheduledRoom,
        scheduledNumber: form.scheduledNumber,
        relationshipId: form.relationshipId,
        otherRelationship: form.otherRelationship,
        consentDateTime: form.consentDateTime,
        syncStatus: const Value(1), // 待同步
      ),
    );
  }
}
