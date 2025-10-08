// data/models/referral_data.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

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

  void update() {
    notifyListeners();
  }

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
}