import 'package:chikawa_airport/data/models/AmbulanceView_Data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart'; // 假設您的 DAO 都在這個檔案裡
import 'nav1.dart';
import 'nav5.dart';

class Home3Page extends StatefulWidget {
  const Home3Page({super.key});

  @override
  State<Home3Page> createState() => _Home3PageState();
}

class _Home3PageState extends State<Home3Page> {
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
    final ambulanceRecordsDao = context.watch<AmbulanceRecordsDao>();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('請在病患的「處置」頁面勾選「建議轉診」以自動建立紀錄。'),
                        backgroundColor: Color(0xFF274C4A),
                      ),
                    );
                  },
                  child: const Text('新增紀錄(由病患建立)'),
                ),
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: '搜尋姓名/主訴/送往地點...',
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
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: '篩選',
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('篩選功能開發中')));
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              color: Colors.transparent,
              child: const Row(
                children: [
                  _TableHeader('病患姓名'),
                  _TableHeader('出勤時間'),
                  _TableHeader('病患主訴'),
                  _TableHeader('送往地點'),
                  _TableHeader('總費用'),
                  _TableHeader('主責醫師'),
                  _TableHeader('是否拒絕'),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 12),
            Expanded(
              child: StreamBuilder<List<DetailedAmbulanceViewData>>(
                stream: ambulanceRecordsDao.watchAllDetailedRecords(
                  keyword: keyword,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('目前沒有任何救護車出勤紀錄。'));
                  }

                  final records = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final item = records[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Nav5Page(visitId: item.visit.visitId),
                            ),
                          );
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
                              _TableCell(item.visit.patientName ?? '(無姓名)'),
                              _TableCell(
                                item.record.dutyTime != null
                                    ? _formatDateTime(item.record.dutyTime!)
                                    : '—',
                              ),
                              _TableCell(item.record.chiefComplaint ?? '—'),
                              _TableCell(
                                item.record.destinationHospital ?? '—',
                              ),
                              _TableCell(
                                item.record.totalFee?.toString() ?? '—',
                              ),
                              _TableCell(
                                item.treatment?.selectedMainDoctor ?? '—',
                              ),
                              _TableCell(item.record.isRejection ? '是' : '否'),
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
  String _formatDateTime(DateTime dt) =>
      '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';
}

class _TableHeader extends StatelessWidget {
  final String title;
  const _TableHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.left,
        ),
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
