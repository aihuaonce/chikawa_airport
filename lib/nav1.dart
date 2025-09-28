import 'package:flutter/material.dart';
import 'maintain/maintain_menu_sheet.dart'; // 保持第一個程式碼的引入

// --- 顏色定義 ---
const _light = Color(0xFF83ACA9); // 淺綠色 (未選中)
const _dark = Color(0xFF274C4A); // 深綠色 (選中)
const _navBarBg = Color(0xFFFFFFFF); // 導航列背景色使用白色

// 遵循新架構：使用 StatefulWidget 來管理選取狀態
class Nav1Page extends StatefulWidget {
  const Nav1Page({super.key});

  @override
  State<Nav1Page> createState() => _Nav1PageState();
}

class _Nav1PageState extends State<Nav1Page> {
  // 使用第一個程式碼的完整項目列表
  final List<String> items = <String>[
    '機場出診單',
    '急救紀錄單',
    '救護車紀錄單',
    '查看報表',
    '各式列表維護',
  ];
  // 狀態管理從 Provider 移到 StatefulWidget 內部
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      // 保持第一個程式碼的導航列樣式：白色背景 + 陰影
      decoration: BoxDecoration(
        color: _navBarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2), // 底部陰影
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
                  final bool isActive = i == _selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i],
                      active: isActive,
                      // 使用內部狀態管理方法
                      onTap: () => _handleNavigation(context, i),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 呼叫救護車按鈕 (樣式和功能保留)
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          // 圓形頭像 (樣式保留)
          const CircleAvatar(radius: 18, backgroundColor: _light),
        ],
      ),
    );
  }

  // 處理導航邏輯 (從第一個程式碼移植過來，並將 Provider 呼叫移除)
  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
      case 1:
      case 2:
      case 3:
        // 設定新的選取狀態，觸發 UI 更新
        setState(() {
          _selectedIndex = index;
        });
        break;
      case 4:
        // 各式列表維護 - 打開底部下拉選單 (不切換選取狀態，保持第一個程式碼的邏輯)
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

// --- 導航列選項按鈕元件 ---
// 保持第一個程式碼的邏輯和樣式
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
    // 顏色邏輯：選中用深綠色(_dark)，未選中用淺綠色(_light)
    final Color bg = active ? _dark : _light;
    const Color fg = Colors.white; // 前景色固定白色

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
