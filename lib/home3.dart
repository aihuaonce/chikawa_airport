import 'package:chikawa_airport/data/models/AmbulanceView_Data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'nav5.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

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
    final t = AppTranslations.of(context); // 【新增】取得翻譯

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
                      SnackBar(
                        // 【修改】使用翻譯
                        content: Text(t.ambulanceRecordHint),
                        backgroundColor: const Color(0xFF274C4A),
                      ),
                    );
                  },
                  // 【修改】使用翻譯
                  child: Text(t.addAmbulanceRecord),
                ),
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      // 【修改】使用翻譯
                      hintText: t.searchAmbulance,
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
                // 【備註】此處為開發中功能，暫不修改提示文字
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
              // 【修改】使用翻譯
              child: Row(
                children: [
                  _TableHeader(t.patientName),
                  _TableHeader(t.dutyTime),
                  _TableHeader(t.chiefComplaint),
                  _TableHeader(t.destination),
                  _TableHeader(t.totalFee),
                  _TableHeader(t.mainDoctor),
                  _TableHeader(t.isRejection),
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
                    // 【修改】使用翻譯
                    return Center(child: Text(t.noAmbulanceRecords));
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
                          // 【修改】所有表格內容都使用翻譯或替代文字
                          child: Row(
                            children: [
                              _TableCell(
                                item.visit.patientName ?? t.valueNotAvailable,
                              ),
                              _TableCell(
                                item.record.dutyTime != null
                                    ? _formatDateTime(item.record.dutyTime!)
                                    : t.valueNotAvailable,
                              ),
                              _TableCell(
                                item.record.chiefComplaint ??
                                    t.valueNotAvailable,
                              ),
                              _TableCell(
                                item.record.destinationHospital ??
                                    t.valueNotAvailable,
                              ),
                              _TableCell(
                                item.record.totalFee?.toString() ??
                                    t.valueNotAvailable,
                              ),
                              _TableCell(
                                item.treatment?.selectedMainDoctor ??
                                    t.valueNotAvailable,
                              ),
                              _TableCell(
                                item.record.isRejection ? t.yes : t.no,
                              ),
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

// 【維持不變】_TableHeader 和 _TableCell 元件不需要修改
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
