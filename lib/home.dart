import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/db/app_database.dart';
import 'nav1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String keyword = "";

  // 搜尋控制器
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // 當搜尋框內容改變時，更新狀態以觸發 StreamBuilder 重新查詢
    setState(() {
      keyword = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitsDao = context.watch<VisitsDao>();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // Nav1Page 常駐在首頁
            const Nav1Page(), // Nav1Page 移除了 visitId 參數 (因在首頁不需要)

            const SizedBox(height: 24),
            Row(
              children: [
                // + 新增病患資料
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () async {
                    // 1) 先建立一筆 visit，取得 visitId
                    final visitId = await visitsDao.createVisit();

                    // 2) ★ 導向個人資料頁，使用命名路由
                    await Navigator.pushNamed(
                      context,
                      '/personalInformation', // 對應 routes_config.txt 中的路徑
                      arguments: visitId, // 傳遞 visitId
                    );

                    // 3) 回來後刷新列表
                    if (mounted) setState(() {});
                  },
                  child: const Text('+新增病患資料'),
                ),

                const Spacer(),

                // 搜尋框
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜尋姓名/國籍/科別...',
                      border: const OutlineInputBorder(),
                      suffixIcon: keyword.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 資料列表
            Expanded(
              child: StreamBuilder<List<Visit>>(
                stream: visitsDao.watchAll(keyword: keyword),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('目前沒有任何病患紀錄。'));
                  }
                  final visits = snapshot.data!;

                  return ListView.builder(
                    itemCount: visits.length + 1, // +1 for header
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Header
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              _TableHeader('ID'),
                              _TableHeader('姓名'),
                              _TableHeader('性別'),
                              _TableHeader('國籍'),
                              _TableHeader('更新時間'),
                              _TableHeader('科別'),
                              _TableHeader('備註'),
                              _TableHeader('填表人'),
                            ],
                          ),
                        );
                      }
                      final v = visits[index - 1];

                      // Data Row
                      return _DataRow(
                        onTap: () async {
                          // 點擊列表，導航到個人資料頁
                          await Navigator.pushNamed(
                            context,
                            '/personalInformation',
                            arguments: v.visitId,
                          );
                          if (mounted) setState(() {}); // 返回後刷新
                        },
                        children: [
                          _TableCell(v.visitId.toString()),
                          _TableCell(v.patientName ?? '—'),
                          _TableCell(v.gender ?? '—'),
                          _TableCell(v.nationality ?? '—'),
                          _TableCell(
                            v.uploadedAt == null
                                ? '—'
                                : _fmtDateTime(v.uploadedAt!),
                          ),
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
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(text, textAlign: TextAlign.left),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback onTap;

  const _DataRow({required this.children, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(children: children),
      ),
    );
  }
}
