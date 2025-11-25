import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_database.dart';
import 'package:drift/drift.dart';

class SyncService {
  final AppDatabase db;
  Timer? _timer;
  bool _isSyncing = false;

  SyncService(this.db);

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _syncIfNotRunning(),
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _syncIfNotRunning() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await syncAllTables();
    } catch (e) {
      print("⚠️ 同步錯誤: $e");
    } finally {
      _isSyncing = false;
    }
  }

  // 所有日期欄位
  final List<String> dateFields = [
    "birthday",
    "visit_date",
    "created_at",
    "updated_at",
    // 可依你的資料表增加其他日期欄位
  ];

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

  /// 將 snake_case 轉成 camelCase
  String _camelCase(String name) {
    if (!name.contains('_')) return name;
    final parts = name.split('_');
    return parts[0] +
        parts
            .skip(1)
            .map((p) => p.isNotEmpty ? p[0].toUpperCase() + p.substring(1) : '')
            .join();
  }

  Future<void> syncAllTables() async {
    for (final originalName in tableNames) {
      final apiTableName = originalName
          .split('_')
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join();

      final table = db.getTableByName(originalName);
      if (table == null) continue;

      try {
        final unsyncedRows = await db.customSelect(
          'SELECT * FROM $originalName WHERE synced = 0',
        ).get();

        for (final row in unsyncedRows) {
          final Map<String, dynamic> data = {};

          for (final c in table.$columns) {
            final columnName = c.$name;

            // 排除 synced
            if (columnName == "synced") continue;

            var value = row.data[columnName];

            // id 對應 visitId
            if (columnName == "id") {
              data["visitId"] = value?.toString() ?? "null";
              continue;
            }

            // 日期欄位轉 ISO 8601
            if (dateFields.contains(columnName) && value != null) {
              if (value is int) {
                value =
                    DateTime.fromMillisecondsSinceEpoch(value * 1000).toIso8601String();
              } else if (value is String && int.tryParse(value) != null) {
                value = DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000)
                    .toIso8601String();
              }
            }

            // 空值補 "null"
            if (value == null || (value is String && value.isEmpty)) {
              value = "null";
            }

            // 將 snake_case 轉 camelCase
            data[_camelCase(columnName)] = value;
          }

          final bodyMap = {"table": apiTableName, "data": data};
          final body = jsonEncode(bodyMap);

          try {
            final response = await http.post(
              Uri.parse(
                  'https://noncatastrophic-marketwise-jame.ngrok-free.dev/todos/save/'),
              headers: {"Content-Type": "application/json"},
              body: body,
            );

            if (response.statusCode == 200) {
              final result = jsonDecode(response.body);
              if (result["status"] == "ok") {
                final pkColumn = table.$columns.first.$name;
                final pkValue = row.data[pkColumn];

                await db.customUpdate(
                  'UPDATE $originalName SET synced = 1 WHERE $pkColumn = ?',
                  variables: [Variable.withString(pkValue.toString())],
                );

                final prettyJson =
                    const JsonEncoder.withIndent('  ').convert(bodyMap);
                print("✅ [$apiTableName] ID=$pkValue 同步完成\n📤 JSON:\n$prettyJson");
              }
            } else {
              print("❌ [$apiTableName] HTTP 錯誤: ${response.statusCode}");
            }
          } catch (e) {
            print("❌ [$apiTableName] 同步失敗: $e");
          }
        }
      } catch (e) {
        print("❌ [$apiTableName] 處理錯誤: $e");
      }
    }
  }
}

extension on AppDatabase {
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
