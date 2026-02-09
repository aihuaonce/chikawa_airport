import 'package:chikawa_airport/data/db/dao/medical_dao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:chikawa_airport/data/models/reference_service.dart';
import '../../data/db/database.dart';
import '../../data/models/medical/medical_view.dart';
import '../../medical/medical.dart';
import '../../emergency/emergency.dart';
import '../../ambulance/ambulance.dart';
import '../../data/models/dashboard_view_model.dart';
import '../../data/models/record_page.dart';

class RecordRow extends StatelessWidget {
  final MedicalRecordWithPatient data;

  const RecordRow({super.key, required this.data});

  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color primaryColor = Color(0xFF007A8A);

  // 計算年齡
  int _calculateAge(DateTime? birthday) {
    if (birthday == null) return 0;
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final record = data.record;
    final patient = data.patient;

    return InkWell(
      onTap: () {
        // 1. 取得目前的頁面過濾器 (Primary, Ambulance, FirstAid)
        final currentFilter = context.read<DashboardViewModel>().currentFilter;

        // 2. 根據不同頁面跳轉
        if (currentFilter == RecordPage.firstAid) {
          // 急救記錄 -> EmergencyPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmergencyPage(emergencyId: record.medicalId),
            ),
          );
        } else if (currentFilter == RecordPage.ambulance) {
          // 救護車記錄 -> AmbulancePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AmbulancePage(medicalId: record.medicalId),
            ),
          );
        } else {
          // 主診記錄 (Primary) -> MedicalPage
          final database = context.read<AppDatabase>();
          final refService = context.read<ReferenceService>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) =>
                    MedicalViewModel(database, refService, record.medicalId)
                      ..init(),
                child: MedicalPage(medicalId: record.medicalId),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            // 1. 日期與時間
            _cell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(record.createdAt),
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('HH:mm a').format(record.createdAt),
                    style: const TextStyle(color: textMuted, fontSize: 12),
                  ),
                ],
              ),
              2,
            ),

            // 2. 病患名稱 (這裡會呼叫 _buildAvatar)
            _cell(
              Row(
                children: [
                  _buildAvatar(patient.name ?? 'U'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name ?? '未填寫姓名',
                          style: const TextStyle(
                            color: textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${patient.sexId == 1 ? "M" : "F"} / ${_calculateAge(patient.birthday)}y',
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

            // 3. 航班/位置
            _cell(
              const Text(
                'CX 881 / Gate A14',
                style: TextStyle(color: textMuted, fontSize: 13),
              ),
              3,
            ),

            // 4. 主訴症狀
            _cell(
              Text(
                record.isEmergency ? 'Emergency Record' : 'Standard Record',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: textMuted, fontSize: 13),
              ),
              5,
            ),

            // 5. 狀態
            _cell(
              Center(
                child: _buildStatusChip(
                  record.isEmergency ? 'Emergency' : 'Normal',
                  record.isEmergency ? Colors.red : Colors.green,
                ),
              ),
              2,
            ),

            // 6. 操作
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

  Widget _buildAvatar(String name) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

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
        ),
      ),
    );
  }

  Widget _cell(Widget child, int flex) {
    return Expanded(flex: flex, child: child);
  }
} // 這是 RecordRow 的結束大括號
