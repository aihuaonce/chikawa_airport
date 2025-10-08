import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 【重要】取消註解
import 'maintain/maintain_menu_sheet.dart';
import 'providers/app_navigation_provider.dart'; // 【重要】取消註解

// --- 顏色定義 ---
const lightColor = Color(0xFF83ACA9);
const darkColor = Color(0xFF274C4A);
const navBarBg = Color(0xFFFFFFFF);

// 【修改】Nav1Page 現在可以是 StatelessWidget，因為狀態由 Provider 管理
class Nav1Page extends StatelessWidget {
  const Nav1Page({super.key});

  @override
  Widget build(BuildContext context) {
    // 【修改】從 Provider 中讀取當前選中的索引
    final appNavProvider = context.watch<AppNavigationProvider>();
    final selectedIndex = appNavProvider.selectedIndex;

    final List<String> items = <String>[
      '機場出診單', // index 0
      '急救紀錄單', // index 1
      '救護車紀錄單', // index 2
      '查看報表', // index 3
      '各式列表維護', // index 4
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: navBarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i],
                      // 【修改】按鈕是否 active，由 Provider 的狀態決定
                      active: i == selectedIndex,
                      onTap: () => _handleNavigation(context, i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // 【修改】使用 context.read 來呼叫 Provider 的方法
    final appNavProvider = context.read<AppNavigationProvider>();

    switch (index) {
      case 0: // 機場出診單 (對應 HomePage)
      case 1: // 急救紀錄單 (對應 Home2Page)
      case 2: // 救護車紀錄單 (對應 Home3Page)
      case 3: // 查看報表 (對應 Home4Page, 假設)
        // 【重要】更新 Provider 中的選中索引，這會觸發 MainPage 重建
        appNavProvider.setSelectedIndex(index);
        break;
      case 4:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const MaintainMenuSheet(),
        );
        break;
      default:
        break;
    }
  }
}

// --- _PillButton 維持不變 ---
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
    final Color bg = active ? darkColor : lightColor;
    const Color fg = Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
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
          style: const TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
