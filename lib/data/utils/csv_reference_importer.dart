import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import '../db/database.dart';

class CsvReferenceImporter {
  static const _csvConverter = CsvToListConverter();

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
    if (count > 0) return;

    debugPrint('正在匯入地點資料...');
    final files = ['assets/csv/airport.medical.arrival.csv'];

    final Map<String, Map<String, String>> uniqueLocations = {};

    for (final file in files) {
      try {
        final data = await rootBundle.loadString(file);
        final rows = _csvConverter.convert(data);

        // 跳過標題行 (name,country)
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length < 2) continue;

          final rawName = row[0].toString().trim();
          final country = row[1].toString().trim();

          // 解析 "TPE台北" -> Code: TPE, Name: 台北
          if (rawName.length > 3) {
            final code = rawName.substring(0, 3).toUpperCase();
            // 簡單驗證前3碼是否為英數
            if (RegExp(r'^[A-Z0-9]{3}$').hasMatch(code)) {
              final name = rawName.substring(3).trim();

              // 使用 code 作為 key 去除重複
              if (!uniqueLocations.containsKey(code)) {
                uniqueLocations[code] = {
                  'code': code,
                  'name': name,
                  'countryCode': _mapCountryToCode(country),
                };
              }
            }
          }
        }
      } catch (e) {
        debugPrint('匯入地點 CSV 失敗 ($file): $e');
      }
    }

    if (uniqueLocations.isNotEmpty) {
      await db.referenceDao.addLocationBatch(uniqueLocations.values.toList());
      debugPrint('已匯入 ${uniqueLocations.length} 筆地點資料');
    }
  }

  /// 2. 匯入航空公司 (Airline)
  static Future<void> importAirlines(AppDatabase db) async {
    final count = await (db.select(db.airline).get()).then((l) => l.length);
    if (count > 0) return;

    debugPrint('正在匯入航空公司資料...');
    try {
      final data = await rootBundle.loadString(
        'assets/csv/airport.medical.company.other.csv',
      );
      final rows = _csvConverter.convert(data);
      final List<Map<String, String>> airlines = [];

      // 跳過標題行 (name)
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty) continue;

        final rawName = row[0].toString().trim();
        // 解析 "JX星宇航空" -> Code: JX, Name: 星宇航空
        if (rawName.length > 2) {
          final code = rawName.substring(0, 2).toUpperCase();
          if (RegExp(r'^[A-Z0-9]{2}$').hasMatch(code)) {
            final name = rawName.substring(2).trim();
            airlines.add({'code': code, 'name': name});
          }
        }
      }

      if (airlines.isNotEmpty) {
        await db.referenceDao.addAirlineBatch(airlines);
        debugPrint('已匯入 ${airlines.length} 筆航空公司資料');
      }
    } catch (e) {
      debugPrint('匯入航空公司 CSV 失敗: $e');
    }
  }

  /// 3. 匯入國籍 (Nationality)
  static Future<void> importNationalities(AppDatabase db) async {
    final count = await (db.select(db.nationality).get()).then((l) => l.length);
    if (count > 0) return;

    debugPrint('正在匯入國籍資料...');
    final files = [
      'assets/csv/airport.medical.nationality.csv',
      'assets/csv/airport.medical.nationality.other.csv',
    ];

    final Set<String> uniqueNames = {};
    final List<Map<String, String>> nationalities = [];

    // 用來辨識第一個英文字母開始位置的 RegExp (排除括號內的英文)
    // 策略：從後往前找，直到找到非英文/空格/符號的字元
    // 或者：找到第一個連續的英文大寫字串
    final englishPattern = RegExp(r'([A-Z][A-Z\s\.\(\)\-\u2019]+)$');

    for (final file in files) {
      try {
        final data = await rootBundle.loadString(file);
        final rows = _csvConverter.convert(data);

        // 跳過標題行 (name)
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.isEmpty) continue;

          final raw = row[0].toString().trim();
          if (raw.isEmpty || uniqueNames.contains(raw)) continue;
          uniqueNames.add(raw);

          String nameCh = raw;
          String nameEn = '';
          String code = '';

          // 嘗試分割中文與英文
          // 例如: "台灣(中華民國)TAIWAN" -> Ch: 台灣(中華民國), En: TAIWAN
          final match = englishPattern.firstMatch(raw);
          if (match != null) {
            nameEn = match.group(1)!.trim();
            nameCh = raw.substring(0, match.start).trim();
          }

          // 簡單的 Code 映射 (如果有的話)
          code = _mapCountryToCode(nameCh);

          nationalities.add({
            'name': nameCh,
            'nameEn': nameEn,
            'code': code,
          });
        }
      } catch (e) {
        debugPrint('匯入國籍 CSV 失敗 ($file): $e');
      }
    }

    if (nationalities.isNotEmpty) {
      await db.referenceDao.addNationalityBatch(nationalities);
      debugPrint('已匯入 ${nationalities.length} 筆國籍資料');
    }
  }

  /// 4. 匯入護理常用語 (NursingPhrase)
  static Future<void> importNursingPhrases(AppDatabase db) async {
    final count = await (db.select(db.nursingPhrase).get()).then(
      (l) => l.length,
    );
    if (count > 0) return;

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
          phrases.add({'title': title, 'content': content, 'sortOrder': i});
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

  /// 簡易國家代碼對應
  static String _mapCountryToCode(String countryName) {
    if (countryName.contains('台灣')) return 'TW';
    if (countryName.contains('香港')) return 'HK';
    if (countryName.contains('中國')) return 'CN';
    if (countryName.contains('美國')) return 'US';
    if (countryName.contains('日本')) return 'JP';
    if (countryName.contains('韓國')) return 'KR';
    if (countryName.contains('泰國')) return 'TH';
    if (countryName.contains('越南')) return 'VN';
    if (countryName.contains('新加坡')) return 'SG';
    if (countryName.contains('馬來西亞')) return 'MY';
    if (countryName.contains('菲律賓')) return 'PH';
    if (countryName.contains('印尼')) return 'ID';
    return '';
  }
}
