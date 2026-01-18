import 'package:flutter/material.dart';
import '../models/medical_record.dart';
import 'record_row.dart';
import 'pagination_bar.dart';

class RecordsTable extends StatelessWidget {
  const RecordsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TableHeader(),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: demoRecords.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return RecordRow(record: demoRecords[index]);
            },
          ),
        ),
        const PaginationBar(),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: Colors.grey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF9FAFB),
      child: Row(
        children: [
          _cell('DATE & TIME', 2, style),
          _cell('PATIENT NAME', 3, style),
          _cell('FLIGHT / LOCATION', 3, style),
          _cell('CHIEF COMPLAINT', 5, style),
          _cell('STATUS', 2, style),
          _cell('ACTION', 1, style),
        ],
      ),
    );
  }

  Widget _cell(String text, int flex, TextStyle? style) {
    return Expanded(
      flex: flex,
      child: Text(text, style: style),
    );
  }
}
