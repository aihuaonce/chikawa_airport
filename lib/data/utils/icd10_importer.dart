import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../db/database.dart';

class Icd10Importer {
  static Future<void> importFromCsv(AppDatabase db) async {
    try {
      final count = await db.icd10Dao.getCount();
      if (count > 0) {
        debugPrint('ICD-10 数据已存在，跳过导入');
        return;
      }

      debugPrint('开始导入 ICD-10 数据...');

      // 读取 CSV 文件
      final csvData = await rootBundle.loadString(
        'assets/csv/airport.medical.icd10.csv',
      );

      debugPrint('CSV 数据长度: ${csvData.length} 字符');
      debugPrint(
        'CSV 前100字符: ${csvData.substring(0, csvData.length > 100 ? 100 : csvData.length)}',
      );

      // 解析 CSV
      final rows = const CsvToListConverter().convert(csvData);
      debugPrint('CSV 行数: ${rows.length}');

      if (rows.isEmpty) {
        debugPrint('警告: CSV 没有解析出任何行');
        return;
      }

      // 转换为 Companion 对象（跳过表头）
      final companions = <Icd10CodeCompanion>[];
      int skipped = 0;

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
        } else {
          skipped++;
          if (skipped <= 5) {
            debugPrint('跳过行 $i: 长度=${row.length}, 内容=${row.toString()}');
          }
        }
      }

      debugPrint('处理完成: ${companions.length} 条数据, 跳过 $skipped 行');

      if (companions.isEmpty) {
        debugPrint('警告: 没有生成任何 ICD-10 数据');
        return;
      }

      // 批量插入
      await db.icd10Dao.insertBatch(companions);
      debugPrint('ICD-10 数据导入完成: ${companions.length} 条');
    } catch (e, stackTrace) {
      debugPrint('ICD-10 数据导入失败: $e');
      debugPrint('堆栈: $stackTrace');
    }
  }
}
