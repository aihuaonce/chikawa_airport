import 'package:flutter/material.dart';
import 'nav1.dart';

class Home2Page extends StatelessWidget {
  const Home2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB), // 淡藍色背景
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Nav1Page(),
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
                    // TODO: 這裡換成你的「新增急救紀錄單」頁面
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('新增急救紀錄單按下了')));
                  },
                  child: const Text('+新增急救紀錄'),
                ),
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: '搜尋急救紀錄...',
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
                IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 32),
            // 表格標題列
            Container(
              color: Colors.transparent,
              child: Row(
                children: const [
                  _TableHeader('出勤日期'),
                  _TableHeader('姓名'),
                  _TableHeader('送往醫院或地點'),
                  _TableHeader('狀況說明'),
                  _TableHeader('救護人員'),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 24),
            // TODO: 這裡放資料列
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
