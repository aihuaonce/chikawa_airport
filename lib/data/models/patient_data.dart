import 'package:flutter/material.dart';

class PatientData extends ChangeNotifier {
  String? gender;
  String? reason;
  String? nationality;
  DateTime? birthday;
  int? age;
  String? idNumber;
  String? address;
  String? phone;

  void update() => notifyListeners();

  void clear() {
    gender = null;
    reason = null;
    nationality = null;
    birthday = null;
    age = null;
    idNumber = null;
    address = null;
    phone = null;
    update();
  }
}
