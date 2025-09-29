// lib/data/models/undertaking_data.dart
import 'dart:typed_data'; // 為了儲存簽名圖片資料
import 'package:flutter/material.dart';

class UndertakingData extends ChangeNotifier {
  // 中文區塊資料
  String? signerName;
  String? signerId;
  bool isSelf = false;
  String? relation;
  String? address;
  String? phone;
  String? doctor = "江旺財"; // 預設醫師

  // 簽名資料 (Uint8List 用於儲存圖片的 byte data)
  Uint8List? signatureBytes;

  // 醫師列表 (靜態資料，放在這裡方便管理)
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

  // 通知 UI 更新
  void update() {
    notifyListeners();
  }

  // 清除所有資料
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
}
