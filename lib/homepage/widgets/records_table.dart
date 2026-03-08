import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chikawa_airport/data/db/dao/medical_dao.dart';
import 'package:chikawa_airport/data/db/database.dart';
import 'package:chikawa_airport/data/models/dashboard_view_model.dart';
import 'package:chikawa_airport/data/models/record_page.dart';

import 'pagination_bar.dart';
import 'record_row.dart';

class RecordsTable extends StatelessWidget {
  const RecordsTable({super.key});

  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color headerBg = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final database = context.read<AppDatabase>();
    final viewModel = context.watch<DashboardViewModel>();

    bool? hasAmbulance;
    bool? isEmergency;

    switch (viewModel.currentFilter) {
      case RecordPage.ambulance:
        hasAmbulance = true;
        break;
      case RecordPage.firstAid:
        isEmergency = true;
        break;
      case RecordPage.primary:
        break;
    }

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
              const Divider(height: 1),
              Expanded(
                child: StreamBuilder<List<MedicalRecordWithPatient>>(
                  stream: database.medicalDao.watchRecordsPaginated(
                    viewModel.pageSize,
                    viewModel.offset,
                    hasAmbulance: hasAmbulance,
                    isEmergency: isEmergency,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final records = snapshot.data ?? [];
                    if (records.isEmpty) {
                      return const Center(child: Text('目前尚無資料'));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          RecordRow(data: records[index]),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              StreamBuilder<int>(
                stream: database.medicalDao.watchTotalCount(
                  hasAmbulance: hasAmbulance,
                  isEmergency: isEmergency,
                ),
                builder: (context, snapshot) {
                  final totalCount = snapshot.data ?? 0;
                  final totalPages = (totalCount / viewModel.pageSize).ceil();

                  return PaginationBar(
                    currentPage: viewModel.currentPage,
                    totalPages: totalPages == 0 ? 1 : totalPages,
                    onPageChanged: (newPage) => viewModel.setPage(newPage),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          _cell('病患名稱', 2, headerStyle),
          _cell('國籍', 2, headerStyle),
          _cell('事發地點', 3, headerStyle),
          _cell('負責護理師', 2, headerStyle),
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
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}
