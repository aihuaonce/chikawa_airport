import 'package:flutter/material.dart';

class PatientData extends ChangeNotifier {
  DateTime? birthday;
  int? age;
  String? gender;
  String? reason;
  String? nationality;
  String? idNumber;
  String? address;
  String? phone;
  String? photoPath;
  String? note;

  void update() {
    notifyListeners();
  }

  void setAll({
    DateTime? birthday,
    int? age,
    String? gender,
    String? reason,
    String? nationality,
    String? idNumber,
    String? address,
    String? phone,
    String? photoPath,
    String? note,
  }) {
    this.birthday = birthday ?? this.birthday;
    this.age = age ?? this.age;
    this.gender = gender ?? this.gender;
    this.reason = reason ?? this.reason;
    this.nationality = nationality ?? this.nationality;
    this.idNumber = idNumber ?? this.idNumber;
    this.address = address ?? this.address;
    this.phone = phone ?? this.phone;
    this.photoPath = photoPath ?? this.photoPath;
    this.note = note ?? this.note;
    notifyListeners();
  }

  void clear() {
    birthday = null;
    age = null;
    gender = null;
    reason = null;
    nationality = null;
    idNumber = null;
    address = null;
    phone = null;
    photoPath = null;
    note = null;
    notifyListeners();
  }
}
