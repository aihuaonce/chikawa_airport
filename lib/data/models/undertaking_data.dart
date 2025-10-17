import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class UndertakingData extends ChangeNotifier {
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

  void update() => notifyListeners();

  void clear() {
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

  // ✅ undertaking_records Companion
  UndertakingsCompanion toCompanion(int visitId) {
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

  // ✅ 這裡可以選擇性回寫 doctor、phone 到 visits 表
  VisitsCompanion toVisitsCompanion() {
    return VisitsCompanion(
      note: Value('切結人: ${signerName ?? ""} / 醫師: ${doctor ?? ""}'),
    );
  }

  // ✅ 資料庫保存
  Future<void> saveToDatabase(
    int visitId,
    UndertakingsDao undertakingDao,
    VisitsDao visitsDao,
  ) async {
    try {
      await undertakingDao.upsert(toCompanion(visitId));
      await visitsDao.updateVisit(visitId, toVisitsCompanion());
      print('✅ 切結書與 Visits 摘要已更新');
    } catch (e) {
      print('❌ 儲存切結書資料失敗: $e');
      rethrow;
    }
  }
}
