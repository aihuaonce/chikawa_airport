import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'nav3.dart';
import 'data/models/emergency_data.dart';
import 'data/db/daos.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
import 'providers/emergency_navigation_provider.dart';

import 'Emergency_Personal.dart';
import 'Emergency_Flight.dart';
import 'Emergency_Accident.dart';
import 'Emergency_Plan.dart';

// 顏色定義
const _light = Color(0xFF83ACA9);
const _dark = Color(0xFF274C4A);
const _bg = Color(0xFFEFF7F7);

class Nav4Page extends StatelessWidget {
  final int visitId;
  const Nav4Page({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmergencyNavigationProvider()),
        ChangeNotifierProxyProvider<EmergencyRecordsDao, EmergencyData>(
          create: (context) {
            final data = EmergencyData(visitId);
            final dao = context.read<EmergencyRecordsDao>();
            data.loadFromDatabase(dao);
            return data;
          },
          update: (context, dao, previous) =>
              previous ?? EmergencyData(visitId),
        ),
      ],
      child: const EmergencyMainLayout(),
    );
  }
}

class EmergencyMainLayout extends StatelessWidget {
  const EmergencyMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<EmergencyNavigationProvider>();
    final emergencyData = context.watch<EmergencyData>();

    // 根據索引決定顯示哪個分頁
    Widget currentPage;
    switch (navProvider.selectedIndex) {
      case 0:
        currentPage = EmergencyPersonalPage(visitId: emergencyData.visitId);
        break;
      case 1:
        currentPage = EmergencyFlightPage(visitId: emergencyData.visitId);
        break;
      case 2:
        currentPage = EmergencyAccidentPage(visitId: emergencyData.visitId);
        break;
      case 3:
        currentPage = EmergencyPlanPage(visitId: emergencyData.visitId);
        break;
      default:
        currentPage = EmergencyPersonalPage(visitId: emergencyData.visitId);
    }

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const EmergencyNavBar(),
            const Divider(height: 1),
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Nav3Section(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: SingleChildScrollView(child: currentPage)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyNavBar extends StatefulWidget {
  const EmergencyNavBar({super.key});

  @override
  State<EmergencyNavBar> createState() => _EmergencyNavBarState();
}

class _EmergencyNavBarState extends State<EmergencyNavBar> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (_isSaving || !mounted) return;
    final t = AppTranslations.of(context); // 【新增】

    setState(() => _isSaving = true);

    try {
      final emergencyData = context.read<EmergencyData>();
      final dao = context.read<EmergencyRecordsDao>();
      final visitsDao = context.read<VisitsDao>();

      await emergencyData.saveToDatabase(dao, visitsDao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.emergencySaved), // 【修改】
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      print('❌ 儲存失敗: $e');
      print('堆疊: $stackTrace');

      if (mounted) {
        // 【修改】使用已有的翻譯鍵
        final errorMessage = '${t.saveFailed}: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<EmergencyNavigationProvider>();
    final t = AppTranslations.of(context); // 【新增】

    // 【修改】動態建立翻譯後的導航項目列表
    final List<String> items = [
      t.personalInfo,
      t.flightRecord,
      t.accidentRecord,
      t.treatmentRecord,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i], // 【修改】使用翻譯後的列表
                      active: i == navProvider.selectedIndex,
                      onTap: () => navProvider.setSelectedIndex(i),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: _isSaving ? t.saving : t.saveAllPages, // 【修改】
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Color(0xFF27AE60)),
                    ),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _handleSave,
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? _dark : _light;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
