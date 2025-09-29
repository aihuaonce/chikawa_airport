import 'package:flutter/material.dart';

class ElectronicDocumentData extends ChangeNotifier {
  // TO 選項的索引
  int? toSelectedIndex;

  // FROM 選項的索引
  int? fromSelectedIndex;

  // 靜態選項資料，方便管理
  static const List<String> toOptions = <String>[
    'T1 03-3063578',
    'T2 03-3063367',
  ];

  static const List<String> fromOptions = <String>[
    'T1 03-3834225',
    'T2 03-3983485',
  ];

  // 通知 UI 更新
  void update() {
    notifyListeners();
  }

  // 清除所有資料
  void clear() {
    toSelectedIndex = null;
    fromSelectedIndex = null;
    notifyListeners();
  }
}
