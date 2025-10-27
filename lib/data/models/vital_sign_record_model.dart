// lib/data/models/vital_sign_record_model.dart

class VitalSignRecordModel {
  final DateTime recordTime;
  final bool atHospital;
  final String? triageStation;
  final String? consciousness; // 例如: '清', '聲', '痛', '否'
  final String? temperature;
  final String? pulse;
  final String? respiration;
  final String? bloodPressure;
  final String? spo2;
  final String? gcsE;
  final String? gcsV;
  final String? gcsM;

  VitalSignRecordModel({
    required this.recordTime,
    required this.atHospital,
    this.triageStation,
    this.consciousness,
    this.temperature,
    this.pulse,
    this.respiration,
    this.bloodPressure,
    this.spo2,
    this.gcsE,
    this.gcsV,
    this.gcsM,
  });

  // 輔助功能：自動計算 GCS 總分
  String get gcsTotal {
    final e = int.tryParse(gcsE ?? '') ?? 0;
    final v = int.tryParse(gcsV ?? '') ?? 0;
    final m = int.tryParse(gcsM ?? '') ?? 0;
    if (e == 0 && v == 0 && m == 0) return '-';
    return (e + v + m).toString();
  }

  // 從 JSON 格式轉換為 Model
  factory VitalSignRecordModel.fromJson(Map<String, dynamic> json) {
    return VitalSignRecordModel(
      recordTime: DateTime.parse(json['recordTime']),
      atHospital: json['atHospital'] as bool,
      triageStation: json['triageStation'] as String?,
      consciousness: json['consciousness'] as String?,
      temperature: json['temperature'] as String?,
      pulse: json['pulse'] as String?,
      respiration: json['respiration'] as String?,
      bloodPressure: json['bloodPressure'] as String?,
      spo2: json['spo2'] as String?,
      gcsE: json['gcsE'] as String?,
      gcsV: json['gcsV'] as String?,
      gcsM: json['gcsM'] as String?,
    );
  }

  // 將 Model 轉換為 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'recordTime': recordTime.toIso8601String(),
      'atHospital': atHospital,
      'triageStation': triageStation,
      'consciousness': consciousness,
      'temperature': temperature,
      'pulse': pulse,
      'respiration': respiration,
      'bloodPressure': bloodPressure,
      'spo2': spo2,
      'gcsE': gcsE,
      'gcsV': gcsV,
      'gcsM': gcsM,
    };
  }
}
