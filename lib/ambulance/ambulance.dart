import 'package:flutter/material.dart';
import 'widgets/ambulance_header.dart';
import 'pages/dispatch_info.dart';
import 'pages/personal_info.dart';
import 'pages/scene_status.dart';
import 'pages/treatment_items.dart';
import 'pages/fees.dart';
import 'pages/body_map.dart';

class AmbulancePage extends StatefulWidget {
  final int medicalId;

  const AmbulancePage({super.key, required this.medicalId});

  @override
  State<AmbulancePage> createState() => _AmbulancePageState();
}

class _AmbulancePageState extends State<AmbulancePage> {
  static const Color bgLight = Color(0xFFF6F8FA);

  int _currentSectionIndex = 0;

  // 定義救護車紀錄單 6 大章節
  final List<Map<String, dynamic>> _sections = [
    {
      'title': '派遣資料 (Dispatch Info)',
      'icon': Icons.assignment_turned_in_outlined,
    },
    {'title': '個人資料 (Personal Info)', 'icon': Icons.person_outline},
    {'title': '現場狀況 (Scene Status)', 'icon': Icons.location_on_outlined},
    {
      'title': '處置項目 (Treatment Items)',
      'icon': Icons.medical_services_outlined,
    },
    {'title': '收取費用 (Fees)', 'icon': Icons.payments_outlined},
    {'title': '人形圖 (Body Map)', 'icon': Icons.accessibility_new_outlined},
  ];

  // 根據索引返回子頁面內容
  Widget _getCurrentPage() {
    switch (_currentSectionIndex) {
      case 0:
        return DispatchInfo(medicalId: widget.medicalId);
      case 1:
        return AmbulancePersonalInfo(medicalId: widget.medicalId);
      case 2:
        return AmbulanceSceneStatus(medicalId: widget.medicalId);
      case 3:
        return AmbulanceTreatmentItems(medicalId: widget.medicalId);
      case 4:
        return AmbulanceFees(medicalId: widget.medicalId);
      case 5:
        return AmbulanceBodyMap(medicalId: widget.medicalId);
      default:
        return DispatchInfo(medicalId: widget.medicalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. 頂部 Header
            AmbulanceHeader(
              sections: _sections,
              currentIndex: _currentSectionIndex,
              onSectionChanged: (index) {
                setState(() {
                  _currentSectionIndex = index;
                });
              },
            ),

            // 2. 中間內容區域
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
