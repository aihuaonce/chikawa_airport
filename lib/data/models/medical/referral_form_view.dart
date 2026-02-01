import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../db/database.dart';
import '../reference_service.dart';

enum SaveStatus { idle, saving, success }

class ReferralFormViewModel extends ChangeNotifier {
  final AppDatabase db;
  final ReferenceService refService;
  final int medicalId;

  // 轉診單資料快取
  ReferralFormData? _formCache;
  ReferralFormData? get form => _formCache;

  // 參考資料 Getters
  List<ReferralPurposeData> get referralPurposes => refService.referralPurposeList;
  List<RelationshipTypeData> get relationshipTypes => refService.relationshipTypeList;

  // 選中的參考資料
  ReferralPurposeData? get selectedPurpose {
    if (_formCache?.referralPurposeId == null) return null;
    return referralPurposes.firstWhere(
      (p) => p.id == _formCache!.referralPurposeId,
      orElse: () => referralPurposes.first,
    );
  }

  RelationshipTypeData? get selectedRelationship {
    if (_formCache?.relationshipId == null) return null;
    return relationshipTypes.firstWhere(
      (r) => r.id == _formCache!.relationshipId,
      orElse: () => relationshipTypes.first,
    );
  }

  // 延遲存檔與狀態
  Timer? _debounceTimer;
  SaveStatus _saveStatus = SaveStatus.idle;
  SaveStatus get saveStatus => _saveStatus;

  ReferralFormViewModel(this.db, this.refService, this.medicalId);

  // 初始化
  Future<void> init() async {
    _formCache = await db.referralFormDao.getFormByMedicalId(medicalId);

    if (_formCache == null) {
      debugPrint('系統：轉診單不存在，建立預設記錄');
      await _createDefaultForm();
      _formCache = await db.referralFormDao.getFormByMedicalId(medicalId);
    }

    notifyListeners();
  }

  // 建立預設轉診單
  Future<void> _createDefaultForm() async {
    try {
      await db.referralFormDao.createForm(medicalId);
      debugPrint('系統：已建立預設轉診單');
    } catch (e) {
      debugPrint('系統：建立預設轉診單失敗 - $e');
    }
  }

  // ========== 聯絡人資料 ==========
  void updateContactInfo({String? name, String? phone, String? address}) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      contactName: Value(name),
      contactPhone: Value(phone),
      contactAddress: Value(address),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateContactInfo(
          _formCache!.formId,
          name: name,
          phone: phone,
          address: address,
        ));
  }

  // ========== 診斷 ==========
  void updateDiagnosis({String? primary, String? secondary1, String? secondary2}) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      primaryDiagnosis: Value(primary),
      secondaryDiagnosis1: Value(secondary1),
      secondaryDiagnosis2: Value(secondary2),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateDiagnosis(
          _formCache!.formId,
          primary: primary,
          secondary1: secondary1,
          secondary2: secondary2,
        ));
  }

  // ========== 檢查及治療摘要 ==========
  void updateExamSummary({
    String? recentExamResult,
    DateTime? examDate,
    String? recentMedication,
    DateTime? medicationDate,
  }) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      recentExamResult: Value(recentExamResult),
      examDate: Value(examDate),
      recentMedication: Value(recentMedication),
      medicationDate: Value(medicationDate),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateExamSummary(
          _formCache!.formId,
          recentExamResult: recentExamResult,
          examDate: examDate,
          recentMedication: recentMedication,
          medicationDate: medicationDate,
        ));
  }

  // ========== 轉診目的 ==========
  void updateReferralPurpose(int? purposeId, {String? otherPurpose}) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      referralPurposeId: Value(purposeId),
      otherPurpose: Value(otherPurpose),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateReferralPurpose(
          _formCache!.formId,
          purposeId: purposeId,
          otherPurpose: otherPurpose,
        ));
  }

  // ========== 醫師交辦與簽署 ==========
  void updateDoctorInfo({
    String? name,
    String? department,
    DateTime? orderDate,
    String? notes,
  }) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      doctorName: Value(name),
      doctorDepartment: Value(department),
      orderDate: Value(orderDate),
      notes: Value(notes),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateDoctorInfo(
          _formCache!.formId,
          name: name,
          department: department,
          orderDate: orderDate,
          notes: notes,
        ));
  }

  Future<void> updateDoctorSignature(Uint8List signature) async {
    if (_formCache == null) return;
    try {
      await db.referralFormDao.updateDoctorSignature(_formCache!.formId, signature);
      _formCache = _formCache!.copyWith(doctorSignature: Value(signature));
      notifyListeners();
      debugPrint('系統：已儲存醫師簽名');
    } catch (e) {
      debugPrint('系統：醫師簽名儲存失敗 - $e');
    }
  }

  // ========== 建議轉診院所 ==========
  void updateHospitalInfo({
    String? name,
    String? dept,
    String? doctor,
    String? phone,
    String? address,
  }) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      hospitalName: Value(name),
      hospitalDept: Value(dept),
      hospitalDoctor: Value(doctor),
      hospitalPhone: Value(phone),
      hospitalAddress: Value(address),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateHospitalInfo(
          _formCache!.formId,
          name: name,
          dept: dept,
          doctor: doctor,
          phone: phone,
          address: address,
        ));
  }

  // ========== 安排就醫 ==========
  void updateScheduledVisit({
    DateTime? date,
    String? dept,
    String? room,
    String? number,
  }) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      scheduledDate: Value(date),
      scheduledDept: Value(dept),
      scheduledRoom: Value(room),
      scheduledNumber: Value(number),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateScheduledVisit(
          _formCache!.formId,
          date: date,
          dept: dept,
          room: room,
          number: number,
        ));
  }

  // ========== 聲明與同意 ==========
  void updateConsent({
    int? relationshipId,
    String? otherRelationship,
    DateTime? consentDateTime,
  }) {
    if (_formCache == null) return;
    _formCache = _formCache!.copyWith(
      relationshipId: Value(relationshipId),
      otherRelationship: Value(otherRelationship),
      consentDateTime: Value(consentDateTime),
    );
    notifyListeners();
    _debounceSave(() => db.referralFormDao.updateConsent(
          _formCache!.formId,
          relationshipId: relationshipId,
          otherRelationship: otherRelationship,
          consentDateTime: consentDateTime,
        ));
  }

  Future<void> updateConsentSignature(Uint8List signature) async {
    if (_formCache == null) return;
    try {
      await db.referralFormDao.updateConsentSignature(_formCache!.formId, signature);
      _formCache = _formCache!.copyWith(consentSignature: Value(signature));
      notifyListeners();
      debugPrint('系統：已儲存同意人簽名');
    } catch (e) {
      debugPrint('系統：同意人簽名儲存失敗 - $e');
    }
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
        debugPrint('系統：轉診單已自動儲存');
      } catch (e) {
        debugPrint('系統：轉診單儲存失敗 - $e');
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
