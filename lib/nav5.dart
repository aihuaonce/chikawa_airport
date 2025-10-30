// nav5.dart
import 'package:chikawa_airport/data/models/body_map_data.dart';
import 'package:chikawa_airport/providers/ambulance_routes_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'nav3.dart'; // 【移除】
import 'data/db/daos.dart';
import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart';

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
        ChangeNotifierProxyProvider<PatientProfilesDao, BodyMapData>(
          // 【修改】使用 PatientProfilesDao
          create: (context) {
            final data = BodyMapData();
            final profileDao = context.read<PatientProfilesDao>();
            _loadBodyMapData(data, profileDao, visitId);
            return data;
          },
          update: (context, profileDao, previous) => previous ?? BodyMapData(),
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

  // 【修改】載入 BodyMap 資料的方法
  static Future<void> _loadBodyMapData(
    BodyMapData bodyMapData,
    PatientProfilesDao profileDao,
    int visitId,
  ) async {
    try {
      final profile = await profileDao.getByVisitId(visitId);
      final jsonData = profile?.bodyMapJson;

      // 簡化檢查
      if (jsonData != null &&
          jsonData.trim().isNotEmpty &&
          jsonData != "null" &&
          jsonData != "[]") {
        bodyMapData.setBodyMap(jsonData, visitId: visitId);
      } else {
        bodyMapData.setBodyMap(null, visitId: visitId);
      }
    } catch (e) {
      debugPrint("載入 BodyMap 失敗: $e");
      bodyMapData.setBodyMap(null, visitId: visitId);
    }
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
// ===================================================================
// 3. 頁面佈局 (AmbulanceMainLayout)
// ===================================================================
class AmbulanceMainLayout extends StatelessWidget {
  final int visitId;
  const AmbulanceMainLayout({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AmbulanceNavigationProvider>();
    final t = AppTranslations.of(context);
    final ambulanceRouteItems = getAmbulanceRouteItems(t);

    // 簡化 Widget 創建邏輯
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
                  const SizedBox(height: 20),
                  // 【修改】根據頁面索引決定佈局方式
                  _buildPageContent(
                    context,
                    currentPage,
                    navProvider.selectedIndex,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 【修改】根據頁面類型決定佈局方式
  Widget _buildPageContent(
    BuildContext context,
    Widget page,
    int selectedIndex,
  ) {
    if (selectedIndex == 5) {
      // BodyMap 页面：使用 ConstrainedBox 确保有最大约束
      return Expanded(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: page,
        ),
      );
    } else {
      // 其他页面：使用滚动
      return Expanded(child: SingleChildScrollView(child: page));
    }
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
    final t = AppTranslations.of(context);

    setState(() => _isSaving = true);

    try {
      // 【新增】首先儲存 BodyMap 資料
      await _saveBodyMapData();

      final ambulanceData = context.read<AmbulanceData>();
      final dao = context.read<AmbulanceRecordsDao>();
      final profileDao = context.read<PatientProfilesDao>();
      final visitsDao = context.read<VisitsDao>();

      await ambulanceData.saveToDatabase(dao, profileDao, visitsDao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.ambulanceSaved),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      print('救護車儲存失敗: $e');
      print('堆疊: $stackTrace');

      if (mounted) {
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

  Future<void> _saveBodyMapData() async {
    final bodyMapData = context.read<BodyMapData>();
    final profileDao = context.read<PatientProfilesDao>();

    // 只在有資料時才儲存
    if (bodyMapData.bodyMapJson != null && bodyMapData.currentVisitId != null) {
      await profileDao.upsertBodyMap(
        bodyMapData.currentVisitId!,
        bodyMapData.bodyMapJson,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AmbulanceNavigationProvider>();
    final t = AppTranslations.of(context);
    // 動態獲取翻譯後的路由項目
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
            tooltip: _isSaving ? t.saving : t.saveAllPages,
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
