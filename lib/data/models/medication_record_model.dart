// lib/data/models/medication_record.dart

class MedicationRecordModel {
  // 【修改】類別名稱
  final DateTime recordTime;
  final String name;
  final String route;
  final String dose;
  final String executor;

  MedicationRecordModel({
    // 【修改】建構子名稱
    required this.recordTime,
    required this.name,
    required this.route,
    required this.dose,
    required this.executor,
  });

  factory MedicationRecordModel.fromJson(Map<String, dynamic> json) {
    // 【修改】工廠建構子名稱
    return MedicationRecordModel(
      // 【修改】回傳的物件類型
      recordTime: DateTime.parse(json['recordTime']),
      name: json['name'] as String,
      route: json['route'] as String,
      dose: json['dose'] as String,
      executor: json['executor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordTime': recordTime.toIso8601String(),
      'name': name,
      'route': route,
      'dose': dose,
      'executor': executor,
    };
  }
}
