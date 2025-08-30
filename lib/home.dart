import 'package:flutter/material.dart';
import 'nav1.dart';
import 'PersonalInformation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                      hintText: 'Search tickets...',
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
