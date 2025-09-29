import 'package:flutter/material.dart';

// 定義單筆護理記錄的資料結構
class NursingRecordEntry {
  // 使用 UUID 或其他唯一 ID 來識別每一筆記錄，方便刪除
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

  // 從 Map 轉換 (用於從資料庫讀取)
  factory NursingRecordEntry.fromMap(Map<String, dynamic> map) {
    return NursingRecordEntry(
      id: map['id'] ?? UniqueKey().toString(),
      time: map['time'] ?? '',
      record: map['record'] ?? '',
      nurseName: map['nurseName'] ?? '',
      nurseSign: map['nurseSign'] ?? '',
    );
  }

  // 轉換為 Map (用於存入資料庫)
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
  // 護理記錄的資料列表
  List<NursingRecordEntry> nursingRecords = [];

  // 新增一筆空的記錄
  void addRecord() {
    nursingRecords.add(NursingRecordEntry(id: UniqueKey().toString()));
    notifyListeners();
  }

  // 根據 ID 刪除一筆記錄
  void removeRecord(String id) {
    nursingRecords.removeWhere((record) => record.id == id);
    notifyListeners();
  }

  // 通知 UI 更新
  void update() {
    notifyListeners();
  }

  // 清除所有資料
  void clear() {
    nursingRecords = [];
    notifyListeners();
  }
}
