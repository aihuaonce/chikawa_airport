// 建立新檔案: main_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_navigation_provider.dart';
import 'nav1.dart';
import 'home.dart';
import 'home3.dart';
// import 'home4.dart'; // 如果有的話

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 監聽 AppNavigationProvider 的狀態變化
    final appNavProvider = context.watch<AppNavigationProvider>();

    // 根據索引決定要顯示哪個頁面
    final List<Widget> pages = [
      const HomePage(), // Index 0: 機場出診單
      const Center(child: Text("急救頁面，開發中...")), // Index 1: 急救紀錄單 (您需要建立這個檔案)
      const Home3Page(), // Index 2: 救護車紀錄單
      const Center(child: Text("報表頁面，開發中...")), // Index 3: 查看報表
    ];

    return Scaffold(
      body: Column(
        children: [
          // 頂部永遠是導航欄
          const Nav1Page(),

          // 下方內容區域根據 Provider 的狀態動態切換
          Expanded(
            child: IndexedStack(
              index: appNavProvider.selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
