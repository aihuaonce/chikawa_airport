import 'package:flutter/material.dart';
import 'nav1.dart';

class Home3Page extends StatelessWidget {
  const Home3Page({super.key});

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('新增救護車紀錄單按下了')),
                    );
                  },
                  child: const Text('+新增救護車紀錄'),
                ),
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: '搜尋救護車紀錄...',
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
            // 表格標題列 - 救護車紀錄專用
            Container(
              color: Colors.transparent,
              child: const Row(
                children: [
                  _TableHeader3('出勤日期'),
                  _TableHeader3('姓名'),
                  _TableHeader3('送往醫院或地點'),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 24),
            // TODO: 這裡放救護車紀錄資料列
          ],
        ),
      ),
    );
  }
}

class _TableHeader3 extends StatelessWidget {
  final String title;
  const _TableHeader3(this.title);

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
