import 'package:flutter/material.dart';
import '../models/medical_record.dart';

class RecordRow extends StatelessWidget {
  final MedicalRecord record;
  const RecordRow({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // 之後接詳細頁
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cell(_date(), 2),
            _cell(_patient(), 3),
            _cell(_flight(), 3),
            _cell(Text(record.complaint), 5),
            _cell(_status(), 2),
            _cell(
              const Icon(Icons.chevron_right, color: Colors.grey),
              1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _date() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(record.date,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(record.time,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      );

  Widget _patient() => Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: record.avatarColor,
            child: Text(record.avatar),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(record.patient,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(record.meta,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      );

  Widget _flight() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(record.flight,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(record.location,
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      );

  Widget _status() => Chip(
        label: Text(record.status),
        backgroundColor: record.statusColor.withOpacity(0.15),
        labelStyle: TextStyle(color: record.statusColor),
      );

  Widget _cell(Widget child, int flex) =>
      Expanded(flex: flex, child: child);
}
