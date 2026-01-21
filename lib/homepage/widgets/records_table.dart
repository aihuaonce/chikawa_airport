import 'package:chikawa_airport/data/db/dao/medical_dao.dart';
import 'package:chikawa_airport/data/db/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'record_row.dart';
import 'pagination_bar.dart';

class RecordsTable extends StatelessWidget {
  const RecordsTable({super.key});
  // 顏色定義
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color headerBg = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final database = context.read<AppDatabase>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              const _TableHeader(),

              const Divider(height: 1, color: borderColor),

              Expanded(
                child: StreamBuilder<List<MedicalRecordWithPatient>>(
                  stream: database.medicalDao.watchAllRecords(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final records = snapshot.data ?? [];

                    if (records.isEmpty) {
                      return const Center(child: Text('目前尚無記錄'));
                    }

                    return ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        // 傳入資料庫抓到的資料
                        return RecordRow(data: records[index]);
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: borderColor),
              const PaginationBar(),
            ],
          ),
        ),
      ),
    );
  }
}

// 表格標題
class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      color: RecordsTable.textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: RecordsTable.headerBg,
      child: Row(
        children: [
          _cell('日期與時間', 2, headerStyle),
          _cell('病患名稱', 3, headerStyle),
          _cell('航班 / 位置', 3, headerStyle),
          _cell('主訴症狀', 5, headerStyle),
          _cell('狀態', 2, headerStyle, textAlign: TextAlign.center),
          _cell('操作', 1, headerStyle, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _cell(
    String text,
    int flex,
    TextStyle style, {
    TextAlign textAlign = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(text.toUpperCase(), style: style, textAlign: textAlign),
    );
  }
}
