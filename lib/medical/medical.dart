import 'package:chikawa_airport/data/db/database.dart';
import 'package:chikawa_airport/data/models/medical/medical_view.dart';
import 'package:chikawa_airport/data/models/medical/incident_view.dart'; // 🔧 新增
import 'package:chikawa_airport/data/models/reference_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/medical_header.dart';
import 'pages/personal_info.dart';
import 'pages/flight_log.dart';
import 'pages/incident_record.dart';
import 'pages/treatment_record.dart';

class MedicalPage extends StatefulWidget {
  final int medicalId;

  const MedicalPage({super.key, required this.medicalId});

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  static const Color bgLight = Color(0xFFF6F8FA);

  int _currentSectionIndex = 0;

  final List<Map<String, dynamic>> _sections = [
    {'title': '個人資料 (Personal Info)', 'icon': Icons.account_circle_outlined},
    {'title': '飛航記錄 (Flight Log)', 'icon': Icons.airplanemode_active_outlined},
    {'title': '事故記錄 (Incident Records)', 'icon': Icons.report_problem_outlined},
    {
      'title': '處置記錄 (Treatment Records)',
      'icon': Icons.medical_services_outlined,
    },
    {'title': '醫療費用 (Medical Fees)', 'icon': Icons.payments_outlined},
    {'title': '診斷書 (Medical Certificate)', 'icon': Icons.assignment_outlined},
    {'title': '拒絕轉診切結書 (Refusal of Referral)', 'icon': Icons.gavel_outlined},
    {'title': '轉診單 (Referral Form)', 'icon': Icons.shortcut_outlined},
    {'title': '電傳文件 (Telex Documents)', 'icon': Icons.print_outlined},
    {'title': '護理記錄表 (Nursing Records)', 'icon': Icons.history_edu_outlined},
  ];

  Widget _getCurrentPage() {
    switch (_currentSectionIndex) {
      case 0:
        return PersonalInfo(medicalId: widget.medicalId);
      case 1:
        return FlightLog(medicalId: widget.medicalId);
      case 2:
        return IncidentRecord(medicalId: widget.medicalId);
      case 3:
        return TreatmentRecord(medicalId: widget.medicalId);
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      default:
        return PersonalInfo(medicalId: widget.medicalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // MedicalViewModel：管理 Patient + Flight
        ChangeNotifierProvider(
          create: (context) => MedicalViewModel(
            context.read<AppDatabase>(),
            context.read<ReferenceService>(),
            widget.medicalId,
          )..init(),
        ),
        // IncidentViewModel：管理 Incident
        ChangeNotifierProvider(
          create: (context) => IncidentViewModel(
            context.read<AppDatabase>(),
            context.read<ReferenceService>(),
            widget.medicalId,
          )..init(),
        ),
      ],
      child: Scaffold(
        backgroundColor: bgLight,
        body: SafeArea(
          child: Column(
            children: [
              Consumer<MedicalViewModel>(
                builder: (context, vm, child) => MedicalHeader(
                  sections: _sections,
                  currentIndex: _currentSectionIndex,
                  onSectionChanged: (index) =>
                      setState(() => _currentSectionIndex = index),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: _getCurrentPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
