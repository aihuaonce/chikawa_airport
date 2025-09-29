// lib/data/models/certificate_data.dart
import 'package:flutter/material.dart';

class CertificateData extends ChangeNotifier {
  // 診斷內容
  String? diagnosis;

  // 預設囑言片語選項 (1: 適宜飛行, 2: 轉診後送)
  int? instructionOption;

  // 中、英文囑言
  String? chineseInstruction;
  String? englishInstruction;

  // 開立日期
  DateTime? issueDate;

  // 通知 UI 更新
  void update() {
    notifyListeners();
  }

  // 清除所有資料
  void clear() {
    diagnosis = null;
    instructionOption = null;
    chineseInstruction = null;
    englishInstruction = null;
    issueDate = null;
    notifyListeners();
  }
}
