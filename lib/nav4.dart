// ================================
// 修改後的 nav4.dart - 整合 Provider 導航
// ================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 導入現有的頁面
import 'nav3.dart';
import 'Emergency_Personal.dart';
import 'Emergency_Flight.dart';
import 'Emergency_Accident.dart';
import 'Emergency_Plan.dart';

// Emergency Navigation Provider
class EmergencyNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

// 顏色定義
const _light = Color(0xFF83ACA9);
const _dark = Color(0xFF274C4A);
const _bg = Color(0xFFEFF7F7);

class Nav4Page extends StatelessWidget {
  const Nav4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmergencyNavigationProvider(),
      child: const EmergencyMainLayout(),
    );
  }
}

class EmergencyMainLayout extends StatelessWidget {
  const EmergencyMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyNavigationProvider>(
      builder: (context, emergencyProvider, child) {
        // 根據狀態決定顯示哪個頁面
        Widget currentPage;
        switch (emergencyProvider.selectedIndex) {
          case 0:
            currentPage = const EmergencyPersonalPage();
            break;
          case 1:
            currentPage = const EmergencyFlightPage();
            break;
          case 2:
            currentPage = const EmergencyAccidentPage();
            break;
          case 3:
            currentPage = const EmergencyPlanPage();
            break;
          default:
            currentPage = const EmergencyPersonalPage();
        }

        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: Column(
              children: [
                // 頂部導航欄
                const EmergencyNavBar(),
                const Divider(height: 1),
                // 內容區
                Expanded(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Nav3Section(),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(child: currentPage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmergencyNavBar extends StatelessWidget {
  const EmergencyNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = const ['個人資料', '飛航記錄', '事故紀錄', '處置紀錄'];

    return Consumer<EmergencyNavigationProvider>(
      builder: (context, emergencyProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              // 左側：出診單按鈕
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6ABAD5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // 返回主頁面
                  Navigator.pop(context);
                },
                child: const Text('返回'),
              ),
              const SizedBox(width: 12),

              // 中間：導航按鈕
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(items.length, (i) {
                      final active = i == emergencyProvider.selectedIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _PillButton(
                          label: items[i],
                          active: active,
                          onTap: () => emergencyProvider.setSelectedIndex(i),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 右側：呼叫救護車、頭像
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('呼叫救護車功能')));
                },
                child: const Text('呼叫救護車'),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(radius: 18, backgroundColor: _light),
            ],
          ),
        );
      },
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
