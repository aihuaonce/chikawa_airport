import 'package:chikawa_airport/providers/ambulance_routes_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'nav3.dart';
import 'data/db/daos.dart';
import 'data/models/ambulance_data.dart';

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
        // ✅ 使用 ProxyProvider 確保能取得 DAO
        ChangeNotifierProxyProvider<AmbulanceRecordsDao, AmbulanceData>(
          create: (context) {
            final data = AmbulanceData(visitId);
            // ✅ 在創建後立即載入資料
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
    final ambulanceData = context.watch<AmbulanceData>();

    // 根據索引決定顯示哪個分頁
    Widget currentPage;
    switch (navProvider.selectedIndex) {
      case 0:
        currentPage = ambulanceRouteItems[0].builder(visitId, GlobalKey());
        break;
      case 1:
        currentPage = ambulanceRouteItems[1].builder(visitId, GlobalKey());
        break;
      case 2:
        currentPage = ambulanceRouteItems[2].builder(visitId, GlobalKey());
        break;
      case 3:
        currentPage = ambulanceRouteItems[3].builder(visitId, GlobalKey());
        break;
      case 4:
        currentPage = ambulanceRouteItems[4].builder(visitId, GlobalKey());
        break;
      default:
        currentPage = ambulanceRouteItems[0].builder(visitId, GlobalKey());
    }

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
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final ambulanceData = context.read<AmbulanceData>();
      final dao = context.read<AmbulanceRecordsDao>();
      final profileDao = context.read<PatientProfilesDao>();
      final visitsDao = context.read<VisitsDao>();

      print('🔵 開始儲存 visitId: ${ambulanceData.visitId}');

      // 呼叫 AmbulanceData 的儲存方法
      await ambulanceData.saveToDatabase(dao, profileDao, visitsDao);

      // ✅ 驗證是否真的儲存成功
      final savedRecord = await dao.getByVisitId(ambulanceData.visitId);
      print('✅ 儲存後的 AmbulanceRecord 資料:');
      print('   - chiefComplaint: ${savedRecord?.chiefComplaint}');
      print('   - destinationHospital: ${savedRecord?.destinationHospital}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('救護車記錄已儲存成功!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // ✅ 儲存成功後返回上一頁
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      print('❌ 儲存失敗: $e');
      print('堆疊: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('儲存失敗: $e'), backgroundColor: Colors.red),
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
    final List<String> items = ambulanceRouteItems.map((e) => e.label).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const SizedBox(width: 12),

          // 分頁導航按鈕
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

          // 儲存按鈕
          IconButton(
            tooltip: _isSaving ? '儲存中...' : '儲存所有資料',
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
