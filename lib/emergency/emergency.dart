import 'package:flutter/material.dart';
import 'widgets/emergency_header.dart';
import 'pages/personal_info.dart';
import 'pages/flight_log.dart';
import 'pages/incident_record.dart';
import 'pages/treatment_record.dart';

class EmergencyPage extends StatefulWidget {
  final int emergencyId;

  const EmergencyPage({super.key, required this.emergencyId});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  static const Color bgLight = Color(0xFFF6F8FA);

  int _currentSectionIndex = 0;

  // 定義急救單章節
  final List<Map<String, dynamic>> _sections = [
    {'title': '個人紀錄 (Personal Info)', 'icon': Icons.account_circle_outlined},
    {'title': '飛航記錄 (Flight Records)', 'icon': Icons.flight_takeoff},
    {'title': '事故記錄 (Incident Records)', 'icon': Icons.report_problem_outlined},
    {
      'title': '處置記錄 (Treatment Records)',
      'icon': Icons.medical_services_outlined,
    },
  ];

  // 返回當前選中的頁面
  Widget _getCurrentPage() {
    switch (_currentSectionIndex) {
      case 0:
        return EmergencyPersonalInfo(emergencyId: widget.emergencyId);
      case 1:
        return EmergencyFlightLog(emergencyId: widget.emergencyId);
      case 2:
        return EmergencyIncidentRecord(emergencyId: widget.emergencyId);
      case 3:
        return EmergencyTreatmentRecord(emergencyId: widget.emergencyId);
      default:
        return EmergencyPersonalInfo(emergencyId: widget.emergencyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // 引入外部 Header
            EmergencyHeader(
              sections: _sections,
              currentIndex: _currentSectionIndex,
              caseId:
                  'FA-2023-${widget.emergencyId.toString().padLeft(3, '0')}',
              onSectionChanged: (index) {
                setState(() {
                  _currentSectionIndex = index;
                });
              },
            ),

            // 中間內容滾動區
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    key: ValueKey(_currentSectionIndex),
                    child: _getCurrentPage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 暫時佔位用的 Widget
  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.construction_rounded,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
