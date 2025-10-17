// ==================== 8️⃣ nursing_record_data.dart ====================
import 'dart:convert';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class NursingRecordEntry {
  final String id;
  String time;
  String record;
  String nurseName;
  String nurseSign;

  NursingRecordEntry({
    required this.id,
    this.time = '',
    this.record = '',
    this.nurseName = '',
    this.nurseSign = '',
  });

  factory NursingRecordEntry.fromMap(Map<String, dynamic> map) {
    return NursingRecordEntry(
      id: map['id'] ?? UniqueKey().toString(),
      time: map['time'] ?? '',
      record: map['record'] ?? '',
      nurseName: map['nurseName'] ?? '',
      nurseSign: map['nurseSign'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'record': record,
      'nurseName': nurseName,
      'nurseSign': nurseSign,
    };
  }
}

class NursingRecordData extends ChangeNotifier {
  List<NursingRecordEntry> nursingRecords = [];

  void addRecord() {
    nursingRecords.add(NursingRecordEntry(id: UniqueKey().toString()));
    notifyListeners();
  }

  void removeRecord(String id) {
    nursingRecords.removeWhere((record) => record.id == id);
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void clear() {
    nursingRecords = [];
    notifyListeners();
  }

  // ✅ 新增：轉換為 Companion
  NursingRecordsCompanion toCompanion(int visitId) {
    return NursingRecordsCompanion(
      visitId: Value(visitId),
      recordsJson: Value(
        jsonEncode(nursingRecords.map((r) => r.toMap()).toList()),
      ),
    );
  }

  // ✅ 簡化後的保存方法
  Future<void> saveToDatabase(int visitId, NursingRecordsDao dao) async {
    try {
      await dao.upsert(toCompanion(visitId));
      print('✅ 護理記錄已儲存');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
