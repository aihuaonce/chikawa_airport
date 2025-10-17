// data/models/referral_data.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class ReferralData extends ChangeNotifier {
  // 聯絡人資料
  String? contactName;
  String? contactPhone;
  String? contactAddress;

  // 診斷 ICD-10-CM/PCS 病名
  String? mainDiagnosis;
  String? subDiagnosis1;
  String? subDiagnosis2;

  // 檢查及治療摘要
  DateTime? lastExamDate;
  DateTime? lastMedicationDate;

  // 轉診目的
  int? referralPurposeIdx; // 0:急診, 1:住院, 2:門診, 3:進一步檢查, 4:轉回, 5:其他
  String? furtherExamDetail;
  String? otherPurposeDetail;

  // 診治醫生資訊
  int? doctorIdx;
  String? otherDoctorName;
  int? deptIdx;
  String? otherDeptName;
  Uint8List? doctorSignature;

  // 轉診院所資訊
  DateTime? issueDate;
  DateTime? appointmentDate;
  String? appointmentDept;
  String? appointmentRoom;
  String? appointmentNumber;
  String? referralHospitalName;
  int? referralDeptIdx;
  String? otherReferralDept;
  String? referralDoctorName;
  String? referralAddress;
  String? referralPhone;

  // 同意人資訊
  Uint8List? consentSignature;
  String? relationToPatient;
  DateTime? consentDateTime;

  void update() => notifyListeners();

  void clear() {
    contactName = null;
    contactPhone = null;
    contactAddress = null;
    mainDiagnosis = null;
    subDiagnosis1 = null;
    subDiagnosis2 = null;
    lastExamDate = null;
    lastMedicationDate = null;
    referralPurposeIdx = null;
    furtherExamDetail = null;
    otherPurposeDetail = null;
    doctorIdx = null;
    otherDoctorName = null;
    deptIdx = null;
    otherDeptName = null;
    doctorSignature = null;
    issueDate = null;
    appointmentDate = null;
    appointmentDept = null;
    appointmentRoom = null;
    appointmentNumber = null;
    referralHospitalName = null;
    referralDeptIdx = null;
    otherReferralDept = null;
    referralDoctorName = null;
    referralAddress = null;
    referralPhone = null;
    consentSignature = null;
    relationToPatient = null;
    consentDateTime = null;
    notifyListeners();
  }

  // ✅ Companion 轉換
  ReferralFormsCompanion toCompanion(int visitId) {
    return ReferralFormsCompanion(
      visitId: Value(visitId),
      contactName: Value(contactName),
      contactPhone: Value(contactPhone),
      contactAddress: Value(contactAddress),
      mainDiagnosis: Value(mainDiagnosis),
      subDiagnosis1: Value(subDiagnosis1),
      subDiagnosis2: Value(subDiagnosis2),
      lastExamDate: Value(lastExamDate),
      lastMedicationDate: Value(lastMedicationDate),
      referralPurposeIdx: Value(referralPurposeIdx),
      furtherExamDetail: Value(furtherExamDetail),
      otherPurposeDetail: Value(otherPurposeDetail),
      doctorIdx: Value(doctorIdx),
      otherDoctorName: Value(otherDoctorName),
      deptIdx: Value(deptIdx),
      otherDeptName: Value(otherDeptName),
      doctorSignature: Value(doctorSignature),
      issueDate: Value(issueDate),
      appointmentDate: Value(appointmentDate),
      appointmentDept: Value(appointmentDept),
      appointmentRoom: Value(appointmentRoom),
      appointmentNumber: Value(appointmentNumber),
      referralHospitalName: Value(referralHospitalName),
      referralDeptIdx: Value(referralDeptIdx),
      otherReferralDept: Value(otherReferralDept),
      referralDoctorName: Value(referralDoctorName),
      referralAddress: Value(referralAddress),
      referralPhone: Value(referralPhone),
      consentSignature: Value(consentSignature),
      relationToPatient: Value(relationToPatient),
      consentDateTime: Value(consentDateTime),
    );
  }

  // ✅ 同步更新 Visits 摘要
  VisitsCompanion toVisitsCompanion() {
    return VisitsCompanion(
      dept: Value(otherDeptName),
      note: Value(mainDiagnosis),
      emergencyResult: Value(referralHospitalName),
      uploadedAt: Value(DateTime.now()),
    );
  }

  // ✅ 資料庫保存
  Future<void> saveToDatabase(
    int visitId,
    ReferralFormsDao referralDao,
    VisitsDao visitsDao,
  ) async {
    try {
      await referralDao.upsert(toCompanion(visitId));
      await visitsDao.updateVisit(visitId, toVisitsCompanion());
      print('✅ 轉診資料與 Visits 摘要已更新');
    } catch (e) {
      print('❌ 儲存轉診資料失敗: $e');
      rethrow;
    }
  }
}
