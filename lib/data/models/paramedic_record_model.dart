// lib/data/models/paramedic_record_model.dart

import 'dart:typed_data';

class ParamedicRecordModel {
  final String name;
  final Uint8List? signature; // 簽名是 Uint8List

  ParamedicRecordModel({required this.name, this.signature});

  factory ParamedicRecordModel.fromJson(Map<String, dynamic> json) {
    return ParamedicRecordModel(
      name: json['name'] as String,
      signature: json['signature'] != null
          ? Uint8List.fromList(List<int>.from(json['signature']))
          : null,
    );
  }

  // 將模型轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // 儲存時將簽名轉為 List<int>
      'signature': signature?.toList(),
    };
  }
}
