import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'nav2.dart';
import 'nav1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String keyword = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        keyword = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  onPressed: () async {
                    final visitId = await visitsDao.createVisit();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Nav2Page(visitId: visitId, initialIndex: 0),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                  child: const Text('+新增病患資料'),
                ),
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: '搜尋姓名/國籍/科別...',
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
                      suffixIcon: keyword.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              color: Colors.transparent,
              child: Row(
                children: const [
                  _TableHeader('病患'),
                  _TableHeader('性別'),
                  _TableHeader('國籍'),
                  _TableHeader('更新時間'),
                  _TableHeader('科別'),
                  _TableHeader('備註'),
                  _TableHeader('填寫人'),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 12),
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
                    padding: EdgeInsets.zero,
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      final v = visits[index];
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Nav2Page(visitId: v.visitId, initialIndex: 0),
                            ),
                          );
                          if (mounted) setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            children: [
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
                          ),
                        ),
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
