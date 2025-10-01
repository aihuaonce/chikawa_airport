import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ⭐ 改這裡：不要再用 bottom sheet 了，改成導到 MaintainPage
import 'maintain.dart';

// 先創建一個簡單的 Provider 類別來管理導航狀態
class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

// --- 顏色定義 ---
const _light = Color(0xFF83ACA9); // 淺綠色 (未選中)
const _dark = Color(0xFF274C4A);  // 深綠色 (選中)
const _navBarBg = Color(0xFFFFFFFF); // 導航列背景色使用白色

class Nav1Page extends StatelessWidget {
  const Nav1Page({super.key});

  @override
  Widget build(BuildContext context) {
    // 導航列選項清單
    final List<String> items = <String>[
      '機場出診單',
      '急救紀錄單',
      '救護車紀錄單',
      '查看報表',
      '各式列表維護',
    ];

    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // 滿版背景色調整：白色背景 + 陰影
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
                      final bool isActive = i == navigationProvider.selectedIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _PillButton(
                          label: items[i],
                          active: isActive,
                          onTap: () => _handleNavigation(context, i),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 呼叫救護車按鈕
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
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('呼叫救護車功能')));
                },
                child: const Text('呼叫救護車'),
              ),
              const SizedBox(width: 12),
              // 圓形頭像
              const CircleAvatar(
                radius: 18,
                // backgroundImage: AssetImage('assets/avatar.jpg'),
                backgroundColor: _light,
              ),
            ],
          ),
        );
      },
    );
  }

  // 處理導航邏輯
  void _handleNavigation(BuildContext context, int index) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    switch (index) {
      case 0:
      case 1:
      case 2:
      case 3:
        navigationProvider.setSelectedIndex(index);
        break;
      case 4:
        // ⭐ 改這裡：改成 push 到 MaintainPage（和你開 Nav4Page 的寫法一樣）
        navigationProvider.setSelectedIndex(index); // 可選：讓 pill 高亮
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MaintainPage()),
        );
        break;
      default:
        break;
    }
  }
}

// --- 導航列選項按鈕元件 ---
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
    final Color fg = Colors.white;

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
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
