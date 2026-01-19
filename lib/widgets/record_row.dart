import 'package:flutter/material.dart';
import '../models/medical_record.dart';

class RecordRow extends StatelessWidget {
  final MedicalRecord record;
  const RecordRow({super.key, required this.record});

  // 顏色定義
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color primaryColor = Color(0xFF007A8A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // 點擊查看詳情
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            // 日期與時間
            _cell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.date,
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.time,
                    style: const TextStyle(color: textMuted, fontSize: 12),
                  ),
                ],
              ),
              2,
            ),

            // 病患名稱
            _cell(
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: record.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      record.avatar,
                      style: TextStyle(
                        color: record.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.patient,
                          style: const TextStyle(
                            color: textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          record.meta,
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              3,
            ),

            // 航班/位置
            _cell(
              Row(
                children: [
                  const Icon(
                    Icons.flight_takeoff,
                    size: 16,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.flight,
                        style: const TextStyle(
                          color: textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        record.location,
                        style: const TextStyle(color: textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              3,
            ),

            // 主訴症狀
            _cell(
              Text(
                record.complaint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: textMuted, fontSize: 13),
              ),
              5,
            ),

            // 狀態
            _cell(
              Center(
                child: _buildStatusChip(record.status, record.statusColor),
              ),
              2,
            ),

            // 操作
            _cell(
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFFCBD5E1),
                ),
              ),
              1,
            ),
          ],
        ),
      ),
    );
  }

  // 自定義狀態標籤樣式
  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _cell(Widget child, int flex) => Expanded(flex: flex, child: child);
}
