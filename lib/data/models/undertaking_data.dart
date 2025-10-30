// lib/data/models/undertaking_data.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class UndertakingData extends ChangeNotifier {
  String? patientName;
  String? patientIdNumber;

  String? signerName;
  String? signerId;
  bool isSelf = false;
  String? relation;
  String? address;
  String? phone;
  String? doctor = "江旺財";
  Uint8List? signatureBytes;

  final List<String> doctorList = const [
    "方詩旋",
    "古璿正",
    "江旺財",
    "呂學政",
    "周志勃",
    "金霍歌",
    "徐丕",
    "康曉妍",
  ];

  TextEditingController? _signerController;
  TextEditingController? _signerIdController;
  TextEditingController? _relationController;
  TextEditingController? _addressController;
  TextEditingController? _phoneController;

  void update() => notifyListeners();

  void initControllers({
    required TextEditingController signerController,
    required TextEditingController signerIdController,
    required TextEditingController relationController,
    required TextEditingController addressController,
    required TextEditingController phoneController,
  }) {
    _signerController = signerController;
    _signerIdController = signerIdController;
    _relationController = relationController;
    _addressController = addressController;
    _phoneController = phoneController;

    _signerController?.addListener(() {
      if (signerName != _signerController?.text) {
        signerName = _signerController?.text;
        notifyListeners(); // 更新 UI 上的預覽文字
      }
    });
    _signerIdController?.addListener(() {
      if (signerId != _signerIdController?.text) {
        signerId = _signerIdController?.text;
        notifyListeners(); // 更新 UI 上的預覽文字
      }
    });
  }

  void clear() {
    patientName = null;
    patientIdNumber = null;
    signerName = null;
    signerId = null;
    isSelf = false;
    relation = null;
    address = null;
    phone = null;
    doctor = "江旺財";
    signatureBytes = null;
    notifyListeners();
  }


  void toggleIsSelf(bool newValue) {
    isSelf = newValue;

    if (isSelf) {
      signerName = patientName;
      signerId = patientIdNumber;
      relation = '本人';

      _signerController?.text = patientName ?? '';
      _signerIdController?.text = patientIdNumber ?? '';
      _relationController?.text = '本人';
    } else {
      relation = '';
      _relationController?.clear();
    }
    notifyListeners(); 
  }

  void _syncDataFromControllers() {
    signerName = _signerController?.text.trim();
    signerId = _signerIdController?.text.trim();
    relation = _relationController?.text.trim();
    address = _addressController?.text.trim();
    phone = _phoneController?.text.trim();
  }

  Future<void> loadDataForVisit(
    int visitId, {
    required UndertakingsDao undertakingDao,
    required VisitsDao visitsDao,
    required PatientProfilesDao profileDao,
  }) async {
    final results = await Future.wait([
      undertakingDao.getByVisitId(visitId),
      visitsDao.getById(visitId),
      profileDao.getByVisitId(visitId),
    ]);

    final record = results[0] as Undertaking?;
    final visit = results[1] as Visit?;
    final profile = results[2] as PatientProfile?;

    patientName = visit?.patientName;
    patientIdNumber = profile?.idNumber;

    if (record != null) {
      signerName = record.signerName;
      signerId = record.signerId;
      isSelf = record.isSelf;
      relation = record.relation;
      address = record.address;
      phone = record.phone;
      doctor = record.doctor ?? "江旺財";
      signatureBytes = record.signatureBytes;
    } else {
      isSelf = false;
      doctor = "江旺財";
    }

    _signerController?.text = signerName ?? '';
    _signerIdController?.text = signerId ?? '';
    _relationController?.text = relation ?? '';
    _addressController?.text = address ?? '';
    _phoneController?.text = phone ?? '';

    notifyListeners(); 
  }

  Future<void> saveToDatabase(
    int visitId,
    UndertakingsDao undertakingDao,
    VisitsDao visitsDao,
  ) async {
    _syncDataFromControllers();

    try {
      await undertakingDao.upsert(_toCompanion(visitId));
      await visitsDao.updateVisit(visitId, _toVisitsCompanion());
      print('切結書與 Visits 摘要已更新');
    } catch (e) {
      print('儲存切結書資料失敗: $e');
      rethrow;
    }
  }

  UndertakingsCompanion _toCompanion(int visitId) {
    return UndertakingsCompanion(
      visitId: Value(visitId),
      signerName: Value(signerName),
      signerId: Value(signerId),
      isSelf: Value(isSelf),
      relation: Value(relation),
      address: Value(address),
      phone: Value(phone),
      doctor: Value(doctor),
      signatureBytes: Value(signatureBytes),
    );
  }

  VisitsCompanion _toVisitsCompanion() {
    return VisitsCompanion(
      note: Value('切結書人: ${signerName ?? ""} / 醫師: ${doctor ?? ""}'),
    );
  }
}
