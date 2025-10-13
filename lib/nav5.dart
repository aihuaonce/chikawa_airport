// nav5.dart
import 'package:chikawa_airport/providers/ambulance_routes_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'nav3.dart';
import 'data/db/daos.dart';
import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

// ===================================================================
// 1. 頁面主體 (Nav5Page Widget)
// ===================================================================
class Nav5Page extends StatelessWidget {
  final int visitId;
  const Nav5Page({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AmbulanceNavigationProvider(),
        ),
        ChangeNotifierProxyProvider<AmbulanceRecordsDao, AmbulanceData>(
          create: (context) {
            final data = AmbulanceData(visitId);
            final dao = context.read<AmbulanceRecordsDao>();
            data.loadFromDatabase(dao);
            return data;
          },
          update: (context, dao, previous) =>
              previous ?? AmbulanceData(visitId),
        ),
      ],
      child: AmbulanceMainLayout(visitId: visitId),
    );
  }
}

// ===================================================================
// 2. UI 狀態管理器 (AmbulanceNavigationProvider)
// ===================================================================
class AmbulanceNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
}

// ===================================================================
// 3. 頁面佈局 (AmbulanceMainLayout)
// ===================================================================
class AmbulanceMainLayout extends StatelessWidget {
  final int visitId;
  const AmbulanceMainLayout({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AmbulanceNavigationProvider>();
    final t = AppTranslations.of(context); // 【新增】
    final ambulanceRouteItems = getAmbulanceRouteItems(t); // 【修改】

    // 【修改】簡化 Widget 創建邏輯
    Widget currentPage = ambulanceRouteItems[navProvider.selectedIndex].builder(
      visitId,
      GlobalKey(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
      body: SafeArea(
        child: Column(
          children: [
            const AmbulanceNavBar(),
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

// ===================================================================
// 4. 頂部導航欄 (AmbulanceNavBar)
// ===================================================================
class AmbulanceNavBar extends StatefulWidget {
  const AmbulanceNavBar({super.key});

  @override
  State<AmbulanceNavBar> createState() => _AmbulanceNavBarState();
}

class _AmbulanceNavBarState extends State<AmbulanceNavBar> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (_isSaving || !mounted) return;
    final t = AppTranslations.of(context); // 【新增】

    setState(() => _isSaving = true);

    try {
      final ambulanceData = context.read<AmbulanceData>();
      final dao = context.read<AmbulanceRecordsDao>();
      final profileDao = context.read<PatientProfilesDao>();
      final visitsDao = context.read<VisitsDao>();

      await ambulanceData.saveToDatabase(dao, profileDao, visitsDao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.ambulanceSaved), // 【修改】
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
    final navProvider = context.watch<AmbulanceNavigationProvider>();
    final t = AppTranslations.of(context); // 【新增】
    // 【修改】動態獲取翻譯後的路由項目
    final items = getAmbulanceRouteItems(t).map((e) => e.label).toList();

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
                      label: items[i],
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

// ===================================================================
// 5. 輔助 Widget (_PillButton)
// ===================================================================
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
    const lightColor = Color(0xFF83ACA9);
    const darkColor = Color(0xFF274C4A);
    final bg = active ? darkColor : lightColor;
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
