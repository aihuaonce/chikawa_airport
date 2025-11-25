import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';


import 'tables.dart';
import 'daos.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Visits,
    PatientProfiles,
    AccidentRecords,
    FlightLogs,
    Treatments,
    MedicalCosts,
    MedicalCertificates,
    Undertakings,
    ElectronicDocuments,
    NursingRecords,
    ReferralForms,
    AmbulanceRecords,
    MedicationRecords,
    VitalSignsRecords,
    ParamedicRecords,
    EmergencyRecords,
    // 之後還有 Treatments, MedicalCosts, Diagnoses... 全部加在這裡
  ],
  daos: [
    VisitsDao,
    PatientProfilesDao,
    AccidentRecordsDao,
    FlightLogsDao,
    TreatmentsDao,
    MedicalCostsDao,
    MedicalCertificatesDao,
    UndertakingsDao,
    ElectronicDocumentsDao,
    NursingRecordsDao,
    ReferralFormsDao,
    AmbulanceRecordsDao,
    MedicationRecordsDao,
    VitalSignsRecordsDao,
    ParamedicRecordsDao,
    EmergencyRecordsDao,
    // 之後還有 TreatmentsDao, MedicalCostsDao, DiagnosesDao... 全部加在這裡
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // 每次資料庫 schema 有變更（加表/加欄位），這裡要 +1
  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll(); // 第一次創建時
    },
    onUpgrade: (m, from, to) async {
      print('資料庫升級：從 $from → $to');

      // ⚠️開發用：刪除所有舊表重建（會清空資料）
      final tables = allTables;
      for (final table in tables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
    },
  );

  /// 重置所有資料表 synced 欄位為 0
  Future<void> resetAllSynced() async {
    await transaction(() async {
      for (final table in allTables) {
        final columns = table.$columns.map((c) => c.$name).toList();
        if (!columns.contains('synced')) continue;

        // ⚡ 直接用 SQL 更新
        await customStatement('UPDATE ${table.actualTableName} SET synced = 0;');
      }
    });

    debugPrint("🔄 所有表的 synced 已重置為 0");
  }

      
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_v1.db'));
    return NativeDatabase.createInBackground(file);
  });
}


