import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class PatientData extends ChangeNotifier {
  String? patientName;
  DateTime? birthday;
  int? age;
  String? gender;
  String? reason;
  String? nationality;
  String? idNumber;
  String? address;
  String? phone;
  String? photoBase64;
  String? note;

  void update() => notifyListeners();

  void clear() {
    patientName = null;
    birthday = null;
    age = null;
    gender = null;
    reason = null;
    nationality = null;
    idNumber = null;
    address = null;
    phone = null;
    photoBase64 = null;
    note = null;
    notifyListeners();
  }

  // ✅ patient_records Companion
  PatientProfilesCompanion toCompanion(int visitId) {
    return PatientProfilesCompanion(
      visitId: Value(visitId),
      birthday: Value(birthday),
      age: Value(age),
      gender: Value(gender),
      reason: Value(reason),
      nationality: Value(nationality),
      idNumber: Value(idNumber),
      address: Value(address),
      phone: Value(phone),
      photoPath: Value(photoBase64),
    );
  }

  // ✅ 更新 visits 摘要表
  VisitsCompanion toVisitsCompanion() {
    return VisitsCompanion(
      patientName: Value(patientName),
      gender: Value(gender),
      nationality: Value(nationality),
      note: Value(note),
    );
  }

  // ✅ 資料庫保存
  Future<void> saveToDatabase(
    int visitId,
    PatientProfilesDao patientDao,
    VisitsDao visitsDao,
  ) async {
    try {
      await patientDao.upsert(toCompanion(visitId));
      await visitsDao.updateVisit(visitId, toVisitsCompanion());
      print('✅ 病患資料與 Visits 摘要已更新');
    } catch (e) {
      print('❌ 儲存病患資料失敗: $e');
      rethrow;
    }
  }
}
