import 'package:flutter/material.dart';
import 'maintain/maintain_menu_sheet.dart';

// 請確保您的專案中存在這些檔案和類別
// 這裡假設您的 HomePage 類別存在於 home.dart 中
import 'home.dart'; 
import 'home2.dart'; 
import 'home3.dart'; 

// --- 顏色定義 ---
const _light = Color(0xFF83ACA9); // 淺綠色 (未選中)
const _dark = Color(0xFF274C4A); // 深綠色 (選中)
const _navBarBg = Color(0xFFFFFFFF); // 導航列背景色使用白色

class Nav1Page extends StatefulWidget {
  const Nav1Page({super.key});

  @override
  State<Nav1Page> createState() => _Nav1PageState();
}

class _Nav1PageState extends State<Nav1Page> {
  // 導航列選項清單（已新增急救紀錄單和救護車紀錄單）
  final List<String> items = <String>[
    '機場出診單',
    '急救紀錄單',
    '救護車紀錄單',
    '查看報表',
    '各式列表維護',
  ];
  int selected = 0; // 當前選中的索引

  // 處理按鈕點擊和頁面跳轉
  void _navigateToPage(int index) {
    setState(() {
      selected = index;
    });

    Widget page;
    switch (index) {
      case 0:
        // 機場出診單跳轉到 HomePage
        page = const HomePage(); 
        break;
      case 1:
        // 急救紀錄單跳轉到 Home2Page
        page = const Home2Page(); 
        break;
      case 2:
        // 救護車紀錄單跳轉到 Home3Page
        page = const Home3Page(); 
        break;
      case 3:
        // 查看報表：先不跳頁就 return
        return;
      case 4:
        // ★ 打開底部下拉選單
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const MaintainMenuSheet(),
        );
        return; // 不 push 新頁
      default:
        return;
    }

    // 執行頁面跳轉（推入新的頁面）
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  final bool isActive = i == selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i],
                      active: isActive,
                      onTap: () => _navigateToPage(i), // 呼叫跳轉函數
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            child: const Text('呼叫救護車'),
          ),
          const SizedBox(width: 12),
          // 圓形頭像
          const CircleAvatar(
            radius: 18,
            // 由於沒有提供圖片，使用淺綠色背景代替
            // backgroundImage: AssetImage('assets/avatar.jpg'),
            backgroundColor: _light, 
          ),
        ],
      ),
    );
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