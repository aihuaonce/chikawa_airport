import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import '../db/database.dart';

class CsvReferenceImporter {
  // 使用正確的設定：明確指定 eol 為 LF (Unix 換行符號)
  static const _csvConverter = CsvToListConverter(
    eol: '\n',
    shouldParseNumbers: false,
  );

  /// 手動解析 CSV（備用方案）
  static List<List<dynamic>> _parseCsvManual(String data) {
    final List<List<dynamic>> result = [];
    final lines = data.split('\n');

    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      // 簡單解析：按逗號分割
      final parts = line.split(',');
      result.add(parts.map((p) => p.trim()).toList());
    }

    return result;
  }

  /// 匯入所有參考資料 CSV
  static Future<void> importAll(AppDatabase db) async {
    await importLocations(db);
    await importAirlines(db);
    await importNationalities(db);
    await importNursingPhrases(db);
  }

  /// 1. 匯入地點 (Location)
  static Future<void> importLocations(AppDatabase db) async {
    // 檢查是否已存在資料
    final count = await (db.select(db.location).get()).then((l) => l.length);
    debugPrint('地點資料庫現有筆數: $count');
    if (count > 0) {
      debugPrint('地點資料已存在，跳過匯入');
      return;
    }

    debugPrint('正在匯入地點資料...');
    final files = ['assets/csv/airport.medical.arrival.csv'];

    final Map<String, Map<String, String>> uniqueLocations = {};

    for (final file in files) {
      try {
        final data = await rootBundle.loadString(file);
        debugPrint('地點 CSV 載入成功，長度: ${data.length}');

        // 除錯：顯示前 200 字元
        debugPrint(
          'CSV 前200字元: ${data.substring(0, data.length > 200 ? 200 : data.length).replaceAll('\n', '\\n').replaceAll('\r', '\\r')}',
        );

        final rows = _csvConverter.convert(data);
        debugPrint('地點 CSV 解析後行數: ${rows.length}');

        // 如果 csv 套件解析失敗（只有1行），使用手動解析
        if (rows.length <= 1 && data.length > 10) {
          debugPrint('CSV 套件解析失敗，嘗試手動解析...');
          final manualRows = _parseCsvManual(data);
          debugPrint('手動解析後行數: ${manualRows.length}');
          if (manualRows.length > rows.length) {
            debugPrint('使用手動解析結果');
            rows.clear();
            rows.addAll(manualRows);
          }
        }

        // 除錯：顯示前3行
        if (rows.length > 0) {
          debugPrint('第一行: ${rows[0]}');
          if (rows.length > 1) {
            debugPrint('第二行: ${rows[1]}');
          }
        }

        // 跳過標題行 (name,country)
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length < 2) continue;

          final rawName = row[0].toString().trim();
          row[1].toString().trim();

          // 解析 "TPE台北" -> Code: TPE, Name: 台北
          if (rawName.length > 3) {
            final code = rawName.substring(0, 3).toUpperCase();
            // 簡單驗證前3碼是否為英數
            if (RegExp(r'^[A-Z0-9]{3}$').hasMatch(code)) {
              final name = rawName.substring(3).trim();

              // 使用 code 作為 key 去除重複
              if (!uniqueLocations.containsKey(code)) {
                uniqueLocations[code] = {'code': code, 'name': name};
              }
            }
          }
        }
        debugPrint('地點解析完成，待匯入筆數: ${uniqueLocations.length}');
      } catch (e) {
        debugPrint('匯入地點 CSV 失敗 ($file): $e');
      }
    }

    if (uniqueLocations.isNotEmpty) {
      try {
        await db.referenceDao.addLocationBatch(uniqueLocations.values.toList());
        debugPrint('已匯入 ${uniqueLocations.length} 筆地點資料');
      } catch (e) {
        debugPrint('寫入地點資料庫失敗: $e');
      }
    } else {
      debugPrint('警告: 地點資料為空，未匯入任何資料');
    }
  }

  /// 2. 匯入航空公司 (Airline)
  static Future<void> importAirlines(AppDatabase db) async {
    final count = await (db.select(db.airline).get()).then((l) => l.length);
    debugPrint('航空公司資料庫現有筆數: $count');
    if (count > 0) {
      debugPrint('航空公司資料已存在，跳過匯入');
      return;
    }

    debugPrint('正在匯入航空公司資料...');
    final List<Map<String, dynamic>> airlines = [];

    // 1. 匯入常用航空公司
    try {
      final data = await rootBundle.loadString(
        'assets/csv/airport.medical.company.csv',
      );
      debugPrint('常用航空公司 CSV 載入成功，長度: ${data.length}');
      var rows = _csvConverter.convert(data);
      debugPrint('常用航空公司 CSV 解析後行數: ${rows.length}');

      // 如果 csv 套件解析失敗，使用手動解析
      if (rows.length <= 1 && data.length > 10) {
        debugPrint('常用航空公司 CSV 套件解析失敗，嘗試手動解析...');
        rows = _parseCsvManual(data);
        debugPrint('常用航空公司手動解析後行數: ${rows.length}');
      }

      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty) continue;

        final rawName = row[0].toString().trim();
        // 略過 "其他航空公司"
        if (rawName.contains('其他航空公司')) continue;

        if (rawName.length > 2) {
          final code = rawName.substring(0, 2).toUpperCase();
          if (RegExp(r'^[A-Z0-9]{2}$').hasMatch(code)) {
            final name = rawName.substring(2).trim();
            airlines.add({'code': code, 'name': name, 'isOther': false});
          }
        }
      }
      debugPrint('常用航空公司解析完成: ${airlines.length} 筆');
    } catch (e) {
      debugPrint('匯入常用航空公司 CSV 失敗: $e');
    }

    // 2. 匯入其他航空公司
    try {
      final data = await rootBundle.loadString(
        'assets/csv/airport.medical.company.other.csv',
      );
      debugPrint('其他航空公司 CSV 載入成功，長度: ${data.length}');
      var rows = _csvConverter.convert(data);
      debugPrint('其他航空公司 CSV 解析後行數: ${rows.length}');

      // 如果 csv 套件解析失敗，使用手動解析
      if (rows.length <= 1 && data.length > 10) {
        debugPrint('其他航空公司 CSV 套件解析失敗，嘗試手動解析...');
        rows = _parseCsvManual(data);
        debugPrint('其他航空公司手動解析後行數: ${rows.length}');
      }

      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty) continue;

        final rawName = row[0].toString().trim();
        if (rawName.length > 2) {
          final code = rawName.substring(0, 2).toUpperCase();
          if (RegExp(r'^[A-Z0-9]{2}$').hasMatch(code)) {
            final name = rawName.substring(2).trim();
            airlines.add({'code': code, 'name': name, 'isOther': true});
          } else if (rawName.length > 3) {
            // 部分航空公司代碼可能是3碼或特殊格式，嘗試解析
            // 這裡假設前2碼為代碼，若不符合規則則視為例外
            // 根據 CSV 內容，其他航空公司也多為 2碼 + 名稱 (e.g., JX星宇航空)
            // 3K, 3U 等也是 2碼
            // 若有特殊狀況可在此擴充
          }
        }
      }
      debugPrint('其他航空公司解析完成: ${airlines.length} 筆');
    } catch (e) {
      debugPrint('匯入其他航空公司 CSV 失敗: $e');
    }

    if (airlines.isNotEmpty) {
      try {
        // 批次寫入
        await db.batch((batch) {
          batch.insertAll(
            db.airline,
            airlines.map(
              (a) => AirlineCompanion.insert(
                code: a['code'] as String,
                name: a['name'] as String,
                isOther: Value(a['isOther'] as bool),
              ),
            ),
          );
        });
        debugPrint('已匯入 ${airlines.length} 筆航空公司資料');
      } catch (e) {
        debugPrint('寫入航空公司資料庫失敗: $e');
      }
    } else {
      debugPrint('警告: 航空公司資料為空，未匯入任何資料');
    }
  }

  /// 3. 匯入國籍 (Nationality)
  static Future<void> importNationalities(AppDatabase db) async {
    final count = await (db.select(db.nationality).get()).then((l) => l.length);
    debugPrint('國籍資料庫現有筆數: $count');
    if (count > 0) {
      debugPrint('國籍資料已存在，跳過匯入');
      return;
    }

    debugPrint('正在匯入國籍資料...');
    final files = [
      'assets/csv/airport.medical.nationality.csv',
      'assets/csv/airport.medical.nationality.other.csv',
    ];

    final Set<String> uniqueNames = {};
    final List<Map<String, String>> nationalities = [];

    final englishPattern = RegExp(r'([A-Z][A-Z\s\.\(\)\-\u2019]+)$');

    for (final file in files) {
      try {
        final data = await rootBundle.loadString(file);
        debugPrint('國籍 CSV ($file) 載入成功，長度: ${data.length}');
        var rows = _csvConverter.convert(data);
        debugPrint('國籍 CSV 解析後行數: ${rows.length}');

        // 如果 csv 套件解析失敗，使用手動解析
        if (rows.length <= 1 && data.length > 10) {
          debugPrint('國籍 CSV ($file) 套件解析失敗，嘗試手動解析...');
          rows = _parseCsvManual(data);
          debugPrint('國籍 CSV ($file) 手動解析後行數: ${rows.length}');
        }

        // 跳過標題行 (name)
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.isEmpty) continue;

          final raw = row[0].toString().trim();
          if (raw.isEmpty || uniqueNames.contains(raw)) continue;
          uniqueNames.add(raw);

          String nameCh = raw;
          String nameEn = '';

          final match = englishPattern.firstMatch(raw);
          if (match != null) {
            nameEn = match.group(1)!.trim();
            nameCh = raw.substring(0, match.start).trim();
          }

          nationalities.add({'name': nameCh, 'nameEn': nameEn});
        }
        debugPrint('國籍 CSV ($file) 解析完成');
      } catch (e) {
        debugPrint('匯入國籍 CSV 失敗 ($file): $e');
      }
    }
    debugPrint('國籍解析完成，待匯入筆數: ${nationalities.length}');

    if (nationalities.isNotEmpty) {
      try {
        await db.referenceDao.addNationalityBatch(nationalities);
        debugPrint('已匯入 ${nationalities.length} 筆國籍資料');
      } catch (e) {
        debugPrint('寫入國籍資料庫失敗: $e');
      }
    } else {
      debugPrint('警告: 國籍資料為空，未匯入任何資料');
    }
  }

  /// 4. 匯入護理常用語 (NursingPhrase)
  static Future<void> importNursingPhrases(AppDatabase db) async {
    // 強制重新匯入：先刪除所有舊資料
    await db.delete(db.nursingPhrase).go();

    debugPrint('正在匯入護理常用語...');
    try {
      final data = await rootBundle.loadString(
        'assets/csv/airport.medical.nursing.phrase.csv',
      );
      final rows = _csvConverter.convert(data);
      final List<Map<String, dynamic>> phrases = [];

      // 跳過標題行 (name, content)
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length < 2) continue;

        final title = row[0].toString().trim();
        final content = row[1].toString().trim();

        if (title.isNotEmpty && content.isNotEmpty) {
          phrases.add({
            'title': title,
            'content': content,
            'sortOrder': i,
            'isActive': true, // Explicitly set active
          });
        }
      }

      if (phrases.isNotEmpty) {
        await db.referenceDao.addNursingPhraseBatch(phrases);
        debugPrint('已匯入 ${phrases.length} 筆護理常用語');
      }
    } catch (e) {
      debugPrint('匯入護理常用語 CSV 失敗: $e');
    }
  }
}
