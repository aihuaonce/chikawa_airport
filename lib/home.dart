import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav1.dart';
import 'PersonalInformation.dart';
import 'home2.dart';
import 'home3.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        // 根據 Provider 的狀態決定顯示哪個頁面
        switch (navigationProvider.selectedIndex) {
          case 0:
            return const HomePageContent(); // 機場出診單（原本的 home.dart 內容）
          case 1:
            return const Home2Page(); // 急救紀錄單
          case 2:
            return const Home3Page(); // 救護車紀錄單
          case 3:
            return const ReportPage(); // 查看報表
          default:
            return const HomePageContent();
        }
      },
    );
  }
}

// 原本 HomePage 的內容，現在變成 HomePageContent
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB), // 淡藍色背景
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const Nav1Page(),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInformationPage(),
                      ),
                    );
                  },
                  child: const Text('+新增病患資料'),
                ),
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: '搜尋病患紀錄...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: '篩選',
                  onPressed: () {
                    // TODO: 實作篩選功能
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('篩選功能開發中')));
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            // 表格標題列
            Container(
              color: Colors.transparent,
              child: const Row(
                children: [
                  _TableHeader('病患'),
                  _TableHeader('性別'),
                  _TableHeader('國籍'),
                  _TableHeader('上傳時間'),
                  _TableHeader('科別'),
                  _TableHeader('備註'),
                  _TableHeader('填寫人'),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 24),
            // 資料
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String title;
  const _TableHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.left,
      ),
    );
  }
}

// 查看報表頁面（新增）
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const Nav1Page(),
            const SizedBox(height: 24),
            const Expanded(
              child: Center(
                child: Text(
                  "查看報表頁面",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
