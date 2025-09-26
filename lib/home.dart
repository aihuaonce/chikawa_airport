// lib/pages/home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';              // ✅ VisitsDao, Visit
import '../data/db/app_database.dart';
import 'nav1.dart';
import 'PersonalInformation.dart';         // ✅ PersonalInformationPage(visitId: ...)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    final visitsDao = context.watch<VisitsDao>(); // 監看以便 rebuild

    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Nav1Page(),
            const SizedBox(height: 24),
            Row(
              children: [
                // + 新增病患資料
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  onPressed: () async {
                    // 1) 先建立一筆 visit，取得 visitId
                    final visitId = await visitsDao.createVisit();

                    // 2) 導到個人資料頁，帶入 visitId
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonalInformationPage(visitId: visitId),
                      ),
                    );

                    // 3) 回來後刷新（通常 StreamBuilder 已自動更新，但保險起見）
                    if (mounted) setState(() {});
                  },
                  child: const Text('+新增病患資料'),
                ),

                const Spacer(),

                // 搜尋框
                SizedBox(
                  width: 320,
                  child: TextField(
                    onChanged: (v) => setState(() => keyword = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search patients...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
            Row(
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
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 24),

            // 資料列表（即時）
            Expanded(
              child: StreamBuilder<List<Visit>>(
                stream: visitsDao.watchAll(keyword: keyword),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('發生錯誤：${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return const Center(child: Text('目前沒有病患資料'));
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 16, color: Colors.transparent),
                    itemBuilder: (_, i) {
                      final v = items[i];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TableCell(v.patientName ?? '—'),
                          _TableCell(v.gender ?? '—'),
                          _TableCell(v.nationality ?? '—'),
                          _TableCell(v.uploadedAt == null ? '—' : _fmtDateTime(v.uploadedAt!)),
                          _TableCell(v.dept ?? '—'),
                          _TableCell(v.note ?? '—'),
                          _TableCell(v.filledBy ?? '—'),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';
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

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
