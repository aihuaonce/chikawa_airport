import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../db/database.dart';

class Icd10Importer {
  static Future<void> importFromCsv(AppDatabase db) async {
    try {
      // 1. 检查是否已导入
      final count = await db.icd10Dao.getCount();
      if (count > 0) {
        debugPrint('ICD-10 数据已存在，跳过导入');
        return;
      }

      // 2. 读取 CSV 文件
      debugPrint('开始导入 ICD-10 数据...');
      final csvData = await rootBundle.loadString(
        'assets/airport.medical.icd10.csv',
      );

      // 3. 解析 CSV
      final rows = const CsvToListConverter().convert(csvData);
      debugPrint('CSV 行数: ${rows.length}');

      // 4. 转换为 Companion 对象（跳过表头）
      final companions = <Icd10CodeCompanion>[];
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length >= 4) {
          companions.add(
            Icd10CodeCompanion.insert(
              code: row[0].toString(),
              nameEn: row[2].toString(),
              nameCh: row[3].toString(),
              isLeaf: row[1].toString() == '1',
            ),
          );
        }
      }

      // 5. 批量插入
      await db.icd10Dao.insertBatch(companions);
      debugPrint('ICD-10 数据导入完成: ${companions.length} 条');
    } catch (e) {
      debugPrint('ICD-10 数据导入失败: $e');
    }
  }
}
