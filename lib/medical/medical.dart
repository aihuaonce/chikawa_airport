import 'package:flutter/material.dart';
import 'widgets/medical_header.dart';
import 'pages/personal_info.dart';

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
  ];

  Widget _getCurrentPage() {
    switch (_currentSectionIndex) {
      case 0:
        return PersonalInfo(medicalId: widget.medicalId);
      case 1:
        return const Center(child: Text('飛航記錄頁面'));
      default:
        return PersonalInfo(medicalId: widget.medicalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            MedicalHeader(
              sections: _sections,
              currentIndex: _currentSectionIndex,
              onSectionChanged: (index) {
                setState(() {
                  _currentSectionIndex = index;
                });
              },
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
    );
  }
}
