import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_database.dart'; // 你的主資料庫定義
import 'package:drift/drift.dart';

class SyncService {
  final AppDatabase db;
  Timer? _timer;
  bool _isSyncing = false;

  SyncService(this.db);

  /// 啟動排程（每 30 秒）
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _syncIfNotRunning());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// 防止重複執行
  Future<void> _syncIfNotRunning() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await syncAllTables();
    } catch (e) {
      print("⚠️ 同步流程發生錯誤: $e");
    } finally {
      _isSyncing = false;
    }
  }

  /// 所有資料表名稱清單（snake_case）
  final List<String> tableNames = [
    "visits",
    "patient_profiles",
    "accident_records",
    "flight_logs",
    "treatments",
    "medical_costs",
    "medical_certificates",
    "undertakings",
    "electronic_documents",
    "nursing_records",
    "referral_forms",
    "ambulance_records",
    "medication_records",
    "vital_signs_records",
    "paramedic_records",
    "emergency_records",
  ];

  /// 主同步流程
  Future<void> syncAllTables() async {
    for (final originalName in tableNames) {
      // 取得發送到 API 的 PascalCase tableName
      final apiTableName = originalName.split('_')
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join();

      try {
        final table = db.getTableByName(originalName); // 查本地 SQLite 用 snake_case
        if (table == null) continue;

        // 查詢 synced = 0 的資料
        final unsyncedRows = await db.customSelect(
          'SELECT * FROM $originalName WHERE synced = 0',
        ).get();

        for (final row in unsyncedRows) {
          final id = row.data.values.first;

          // 將所有欄位值轉成字串，如果是 null 或空字串就用 "null"
          final values = row.data.entries.map((e) {
            final v = e.value;
            if (v == null) return "null";
            if (v is String && v.isEmpty) return "null";
            return v.toString();
          }).toList();

          // 在第一個欄位前加上 tableName
          final bodyMap = {"values": [apiTableName, ...values]};
          final body = jsonEncode(bodyMap);

          try {
            final response = await http.post(
              Uri.parse('https://a63d8baf4050.ngrok-free.app/todos/save/'),
              headers: {"Content-Type": "application/json"},
              body: body,
            );

            if (response.statusCode == 200) {
              final result = jsonDecode(response.body);
              if (result['status'] == 'ok') {
                // 更新 synced = 1，本地用 snake_case 表名
                await db.customUpdate(
                  'UPDATE $originalName SET synced = 1 WHERE ${row.data.keys.first} = ?',
                  variables: [Variable<Object>(id)],
                );
                print("⚠️ [$apiTableName] ID=$id 同步完成，HTTP ${response.statusCode}");
              }
            } else {
              print("⚠️ [$apiTableName] ID=$id 同步失敗，HTTP ${response.statusCode}");
            }
          } catch (e) {
            print("⚠️ [$apiTableName] ID=$id 同步失敗: $e");
          }
        }
      } catch (e) {
        print("❌ 處理 $apiTableName 發生錯誤: $e");
      }
    }
  }
}

extension on AppDatabase {
  /// 用名字取得 table 實體
  TableInfo<Table, dynamic>? getTableByName(String name) {
    final tables = <String, TableInfo<Table, dynamic>>{
      'visits': visits,
      'patient_profiles': patientProfiles,
      'accident_records': accidentRecords,
      'flight_logs': flightLogs,
      'treatments': treatments,
      'medical_costs': medicalCosts,
      'medical_certificates': medicalCertificates,
      'undertakings': undertakings,
      'electronic_documents': electronicDocuments,
      'nursing_records': nursingRecords,
      'referral_forms': referralForms,
      'ambulance_records': ambulanceRecords,
      'medication_records': medicationRecords,
      'vital_signs_records': vitalSignsRecords,
      'paramedic_records': paramedicRecords,
      'emergency_records': emergencyRecords,
    };
    return tables[name];
  }
}
