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

  // 當前病患 ID
  int? _patientId;
  int? get patientId => _patientId;

  // 轉診單資料快取
  ReferralFormData? _formCache;
  ReferralFormData? get form => _formCache;

  // 參考資料 Getters
  List<ReferralPurposeData> get referralPurposes =>
      refService.referralPurposeList;
  List<RelationshipTypeData> get relationshipTypes =>
      refService.relationshipTypeList;

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

    // 自動從資料庫帶入缺少的資料
    await populateMissingData();
    
    // 載入病患 ID
    await _loadPatientId();

    notifyListeners();
  }

  Future<void> _loadPatientId() async {
    try {
      final patient = await db.medicalDao.getPatientByMedicalId(medicalId);
      if (patient != null) {
        _patientId = patient.patientId;
      }
    } catch (e) {
      debugPrint('系統：載入病患 ID 失敗 - $e');
    }
  }

  // 從資料庫帶入預設資料
  Future<bool> populateMissingData() async {
    if (_formCache == null) return false;

    // 準備更新的資料容器
    var companion = _formCache!.toCompanion(true);
    bool needsUpdate = false;

    // 1. 聯絡人資料 (不自動帶入，由使用者自行填寫)
    
    // 2. 診斷與醫院資料 (從 Treatment 表)
    // 3. 醫師資料 (從 StaffAssignment 表)
    // 4. 關係 (從 HealthAssessment 表)

    // 為了效能，一次讀取 Treatment
    final treatment = await db.treatmentDao.getTreatment(medicalId);

    if (treatment != null) {
      // 診斷 (Tentative -> Primary Diagnosis)
      if ((_formCache!.primaryDiagnosis ?? '').isEmpty &&
          (treatment.tentative ?? '').isNotEmpty) {
        companion = companion.copyWith(primaryDiagnosis: Value(treatment.tentative));
        needsUpdate = true;
      }
      if ((_formCache!.secondaryDiagnosis1 ?? '').isEmpty &&
          (treatment.secondaryDiagnosis1 ?? '').isNotEmpty) {
        companion = companion.copyWith(
            secondaryDiagnosis1: Value(treatment.secondaryDiagnosis1));
        needsUpdate = true;
      }
      if ((_formCache!.secondaryDiagnosis2 ?? '').isEmpty &&
          (treatment.secondaryDiagnosis2 ?? '').isNotEmpty) {
        companion = companion.copyWith(
            secondaryDiagnosis2: Value(treatment.secondaryDiagnosis2));
        needsUpdate = true;
      }

      // 醫囑
      if ((_formCache!.notes ?? '').isEmpty &&
          (treatment.doctorOrderCh ?? '').isNotEmpty) {
        companion = companion.copyWith(notes: Value(treatment.doctorOrderCh));
        needsUpdate = true;
      }

      // 檢查及治療摘要 (自動帶入)
      if ((_formCache!.recentMedication ?? '').isEmpty) {
        final medications = await db.treatmentDao.getMedications(medicalId);
        if (medications.isNotEmpty) {
          final medList =
              medications
                  .map((m) => '${m.name} ${m.dose ?? ''}${m.unit ?? ''}')
                  .join(', ');
          companion = companion.copyWith(recentMedication: Value(medList));
          needsUpdate = true;
        }
      }

      if ((_formCache!.recentExamResult ?? '').isEmpty) {
        // 嘗試從生命徵象帶入
        final assessments = await db.treatmentDao.getMedicalAssessments(
          medicalId,
        );
        if (assessments.isNotEmpty) {
          // 找最新的有數值的評估
          final latest = assessments.last; // 假設最新的在最後或依時間排序
          final vitalSigns = [
            if (latest.temperature != null) 'BT:${latest.temperature}',
            if (latest.pulse != null) 'PR:${latest.pulse}',
            if (latest.systolic != null) 'BP:${latest.systolic}/${latest.diastolic}',
            if (latest.spo2 != null) 'SpO2:${latest.spo2}%',
          ].join(' ');
          
          if (vitalSigns.isNotEmpty) {
             companion = companion.copyWith(
                 recentExamResult: Value('生命徵象: $vitalSigns'));
             needsUpdate = true;
          }
        }
      }

      // 醫院資料
      if ((_formCache!.hospitalName ?? '').isEmpty) {
        bool hospitalFound = false;

        // 1. 優先嘗試從 Reference 表查找完整資料 (Name, Phone, Address)
        if (treatment.referralHospitalId != null) {
          try {
            final hospital = refService.referralHospitals.firstWhere(
              (h) => h.id == treatment.referralHospitalId,
            );
            
            // 如果不是 "其他醫院"，則使用其資料
            if (!hospital.isOther) {
              companion = companion.copyWith(hospitalName: Value(hospital.name));
              needsUpdate = true;
              hospitalFound = true;

              // 順便帶入電話地址
              if ((_formCache!.hospitalPhone ?? '').isEmpty &&
                  (hospital.phone ?? '').isNotEmpty) {
                companion = companion.copyWith(
                    hospitalPhone: Value(hospital.phone));
              }
              if ((_formCache!.hospitalAddress ?? '').isEmpty &&
                  (hospital.address ?? '').isNotEmpty) {
                companion = companion.copyWith(
                    hospitalAddress: Value(hospital.address));
              }
            }
          } catch (_) {}
        }

        // 2. 如果沒有找到 (或選擇了 "其他醫院")，且有手動輸入的醫院名稱，則使用該名稱
        if (!hospitalFound && 
            (treatment.referralHospitalFinal ?? '').isNotEmpty) {
          companion = companion.copyWith(
              hospitalName: Value(treatment.referralHospitalFinal));
          needsUpdate = true;
        }
      }
    }

    // 醫師資料
    if ((_formCache!.doctorName ?? '').isEmpty ||
        (_formCache!.doctorDepartment ?? '').isEmpty) {
      // 先嘗試從 Treatment 的 DirectorName
      if ((_formCache!.doctorName ?? '').isEmpty &&
          treatment?.directorName != null &&
          treatment!.directorName!.isNotEmpty) {
        companion = companion.copyWith(
            doctorName: Value(treatment.directorName));
        needsUpdate = true;
      }

      // 若仍為空，或需要科別，查 StaffAssignment
      if ((companion.doctorName.value == null ||
              (companion.doctorName.value ?? '').isEmpty) ||
          (_formCache!.doctorDepartment ?? '').isEmpty) {
        final assignments = await db.treatmentDao.getStaffAssignments(
          medicalId,
        );
        try {
          final primaryDoctor = assignments.firstWhere((a) {
            final roleCode = refService.medicalStaffRoleList
                .firstWhere(
                  (r) => r.id == a.staffRoleId,
                  orElse: () => refService.medicalStaffRoleList.first,
                )
                .code;
            return roleCode == 'DOCTOR' && a.isPrimary;
          });

          if ((companion.doctorName.value == null ||
              (companion.doctorName.value ?? '').isEmpty)) {
            
            String? doctorName = primaryDoctor.staffName;
            
            // 若 assignment 中沒有名字，但有 ID，嘗試從 Reference 查找
            if ((doctorName == null || doctorName.isEmpty) && 
                primaryDoctor.staffId != null) {
              try {
                final staff = refService.medicalStaffList.firstWhere(
                  (s) => s.id == primaryDoctor.staffId,
                );
                doctorName = staff.name;
              } catch (_) {}
            }

            if (doctorName != null && doctorName.isNotEmpty) {
              companion = companion.copyWith(
                  doctorName: Value(doctorName));
              needsUpdate = true;
            }
          }

          if ((_formCache!.doctorDepartment ?? '').isEmpty &&
              primaryDoctor.staffId != null) {
            final staff = refService.medicalStaffList.firstWhere(
              (s) => s.id == primaryDoctor.staffId,
            );
            if ((staff.department ?? '').isNotEmpty) {
              companion = companion.copyWith(
                  doctorDepartment: Value(staff.department));
              needsUpdate = true;
            }
          }
        } catch (_) {}
      }
    }

    // 關係 (從 HealthAssessment)
    if (_formCache!.relationshipId == null &&
        (_formCache!.otherRelationship ?? '').isEmpty) {
      final assessments = await db.treatmentDao.getHealthAssessments(medicalId);
      if (assessments.isNotEmpty) {
        final relation = assessments.first.relation;
        if (relation.isNotEmpty) {
          // 嘗試匹配 RelationshipType
          try {
            final type = refService.relationshipTypeList.firstWhere(
              (t) => t.name == relation,
            );
            companion = companion.copyWith(relationshipId: Value(type.id));
            needsUpdate = true;
          } catch (_) {
            // 找不到匹配，設為其他
            try {
              final otherType = refService.relationshipTypeList.firstWhere(
                (t) => t.name == '其他' || t.nameEn?.toLowerCase() == 'other',
              );
              companion = companion.copyWith(
                  relationshipId: Value(otherType.id),
                  otherRelationship: Value(relation));
              needsUpdate = true;
            } catch (_) {}
          }
        }
      }
    }

    // 如果有更新，寫入資料庫並更新快取
    if (needsUpdate) {
      await db.referralFormDao.updateReferralForm(companion);
      _formCache = await db.referralFormDao.getFormByMedicalId(medicalId);
      debugPrint('系統：轉診單已自動帶入預設資料');
    }
    return needsUpdate;
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
    
    final newName = name ?? _formCache!.contactName;
    final newPhone = phone ?? _formCache!.contactPhone;
    final newAddress = address ?? _formCache!.contactAddress;

    _formCache = _formCache!.copyWith(
      contactName: Value(newName),
      contactPhone: Value(newPhone),
      contactAddress: Value(newAddress),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateContactInfo(
        _formCache!.formId,
        name: newName,
        phone: newPhone,
        address: newAddress,
      ),
    );
  }

  Future<void> updateContactFromList(ContactData contact) async {
    updateContactInfo(
      name: contact.name,
      phone: contact.phone,
      address: contact.address,
    );
  }

  // ========== 診斷 ==========
  void updateDiagnosis({
    String? primary,
    String? secondary1,
    String? secondary2,
  }) {
    if (_formCache == null) return;
    
    final newPrimary = primary ?? _formCache!.primaryDiagnosis;
    final newSecondary1 = secondary1 ?? _formCache!.secondaryDiagnosis1;
    final newSecondary2 = secondary2 ?? _formCache!.secondaryDiagnosis2;

    _formCache = _formCache!.copyWith(
      primaryDiagnosis: Value(newPrimary),
      secondaryDiagnosis1: Value(newSecondary1),
      secondaryDiagnosis2: Value(newSecondary2),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateDiagnosis(
        _formCache!.formId,
        primary: newPrimary,
        secondary1: newSecondary1,
        secondary2: newSecondary2,
      ),
    );
  }

  // ========== 檢查及治療摘要 ==========
  void updateExamSummary({
    String? recentExamResult,
    DateTime? examDate,
    String? recentMedication,
    DateTime? medicationDate,
  }) {
    if (_formCache == null) return;

    final newResult = recentExamResult ?? _formCache!.recentExamResult;
    final newDate = examDate ?? _formCache!.examDate;
    final newMed = recentMedication ?? _formCache!.recentMedication;
    final newMedDate = medicationDate ?? _formCache!.medicationDate;

    _formCache = _formCache!.copyWith(
      recentExamResult: Value(newResult),
      examDate: Value(newDate),
      recentMedication: Value(newMed),
      medicationDate: Value(newMedDate),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateExamSummary(
        _formCache!.formId,
        recentExamResult: newResult,
        examDate: newDate,
        recentMedication: newMed,
        medicationDate: newMedDate,
      ),
    );
  }

  // ========== 轉診目的 ==========
  void updateReferralPurpose(int? purposeId, {String? otherPurpose}) {
    if (_formCache == null) return;
    
    // purposeId is usually explicit, but otherPurpose can be updated independently
    // However, the original code had purposeId as nullable argument to clear selection or set it
    // But updateReferralPurpose is usually called with one or the other or both.
    // Let's check logic: if purposeId is passed, it might be intended to change.
    // If purposeId is null in args, does it mean "clear" or "keep"?
    // The UI calls: updateReferralPurpose(selected ? purpose.id : null) -> this means explicit set/clear.
    // The UI also calls: updateReferralPurpose(viewModel.selectedPurpose?.id, otherPurpose: v) -> keeps ID, updates text.
    // So we need to handle "keep" vs "clear".
    // For simplicity in this specific function, purposeId is usually passed explicitly. 
    // BUT otherPurpose is the main risk.
    
    final newPurposeId = purposeId; // This one is tricky because null means "clear" in toggle logic
    // Actually, looking at UI: `updateReferralPurpose(selected ? purpose.id : null)` 
    // So null IS a valid value for purposeId (to clear it).
    // But when updating otherPurpose text: `updateReferralPurpose(viewModel.selectedPurpose?.id, otherPurpose: v)`
    // It passes the CURRENT ID. So that's safe.
    
    final newOtherPurpose = otherPurpose ?? _formCache!.otherPurpose;

    _formCache = _formCache!.copyWith(
      referralPurposeId: Value(newPurposeId),
      otherPurpose: Value(newOtherPurpose),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateReferralPurpose(
        _formCache!.formId,
        purposeId: newPurposeId,
        otherPurpose: newOtherPurpose,
      ),
    );
  }

  // ========== 醫師交辦與簽署 ==========
  void updateDoctorInfo({
    String? name,
    String? department,
    DateTime? orderDate,
    String? notes,
  }) {
    if (_formCache == null) return;

    final newName = name ?? _formCache!.doctorName;
    final newDept = department ?? _formCache!.doctorDepartment;
    final newDate = orderDate ?? _formCache!.orderDate;
    final newNotes = notes ?? _formCache!.notes;

    _formCache = _formCache!.copyWith(
      doctorName: Value(newName),
      doctorDepartment: Value(newDept),
      orderDate: Value(newDate),
      notes: Value(newNotes),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateDoctorInfo(
        _formCache!.formId,
        name: newName,
        department: newDept,
        orderDate: newDate,
        notes: newNotes,
      ),
    );
  }

  Future<void> updateDoctorFromStaff(MedicalStaffData staff) async {
    updateDoctorInfo(
      name: staff.name,
      department: staff.department,
    );
    
    if (staff.signature != null) {
      await updateDoctorSignature(staff.signature!);
    }
  }

  Future<void> updateDoctorSignature(Uint8List signature) async {
    if (_formCache == null) return;
    try {
      await db.referralFormDao.updateDoctorSignature(
        _formCache!.formId,
        signature,
      );
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

    final newName = name ?? _formCache!.hospitalName;
    final newDept = dept ?? _formCache!.hospitalDept;
    final newDoctor = doctor ?? _formCache!.hospitalDoctor;
    final newPhone = phone ?? _formCache!.hospitalPhone;
    final newAddress = address ?? _formCache!.hospitalAddress;

    _formCache = _formCache!.copyWith(
      hospitalName: Value(newName),
      hospitalDept: Value(newDept),
      hospitalDoctor: Value(newDoctor),
      hospitalPhone: Value(newPhone),
      hospitalAddress: Value(newAddress),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateHospitalInfo(
        _formCache!.formId,
        name: newName,
        dept: newDept,
        doctor: newDoctor,
        phone: newPhone,
        address: newAddress,
      ),
    );
  }

  // ========== 安排就醫 ==========
  void updateScheduledVisit({
    DateTime? date,
    String? dept,
    String? room,
    String? number,
  }) {
    if (_formCache == null) return;

    final newDate = date ?? _formCache!.scheduledDate;
    final newDept = dept ?? _formCache!.scheduledDept;
    final newRoom = room ?? _formCache!.scheduledRoom;
    final newNumber = number ?? _formCache!.scheduledNumber;

    _formCache = _formCache!.copyWith(
      scheduledDate: Value(newDate),
      scheduledDept: Value(newDept),
      scheduledRoom: Value(newRoom),
      scheduledNumber: Value(newNumber),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateScheduledVisit(
        _formCache!.formId,
        date: newDate,
        dept: newDept,
        room: newRoom,
        number: newNumber,
      ),
    );
  }

  // ========== 聲明與同意 ==========
  void updateConsent({
    int? relationshipId,
    String? otherRelationship,
    DateTime? consentDateTime,
  }) {
    if (_formCache == null) return;

    // relationshipId usually explicitly set/changed. 
    // If it's passed as null, check if we intend to clear it?
    // The UI: updateConsent(relationshipId: v.id) -> explicit.
    // The UI date: updateConsent(relationshipId: selectedRelationship?.id, consentDateTime: date) -> preserves ID.
    // So if relationshipId is passed, use it. If null, use existing?
    // Wait, if I want to CLEAR relationshipId, I'd pass null. 
    // But optional params default to null. So we can't distinguish "not provided" vs "explicit null".
    // In Dart, we can't unless we use a wrapper.
    // However, looking at usage:
    // 1. Dropdown change: updateConsent(relationshipId: v.id) -> other fields null.
    // 2. Text change: updateConsent(relationshipId: currentId, otherRelationship: v) -> explicit ID.
    // 3. Date change: updateConsent(relationshipId: currentId, consentDateTime: v) -> explicit ID.
    // So it seems the UI always passes the relationshipId.
    // BUT what if I just want to update date and forget to pass ID?
    // Ideally, we should use existing if null.
    // Let's assume the UI might NOT always pass ID.
    // If I change the logic to: newId = relationshipId ?? _formCache!.relationshipId
    // Then I can never clear it by passing null.
    // But is there a case where we clear it? Usually no. Dropdowns select valid values.
    // So using ?? is safer for preventing accidental clears.
    
    final newRelId = relationshipId ?? _formCache!.relationshipId;
    final newOther = otherRelationship ?? _formCache!.otherRelationship;
    final newDate = consentDateTime ?? _formCache!.consentDateTime;

    _formCache = _formCache!.copyWith(
      relationshipId: Value(newRelId),
      otherRelationship: Value(newOther),
      consentDateTime: Value(newDate),
    );
    notifyListeners();
    _debounceSave(
      () => db.referralFormDao.updateConsent(
        _formCache!.formId,
        relationshipId: newRelId,
        otherRelationship: newOther,
        consentDateTime: newDate,
      ),
    );
  }

  Future<void> updateConsentSignature(Uint8List signature) async {
    if (_formCache == null) return;
    try {
      await db.referralFormDao.updateConsentSignature(
        _formCache!.formId,
        signature,
      );
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
