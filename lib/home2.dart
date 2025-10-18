import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'nav4.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class Home2Page extends StatefulWidget {
  const Home2Page({super.key});

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
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

  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';

  @override
  Widget build(BuildContext context) {
    final emergencyRecordsDao = context.watch<EmergencyRecordsDao>();
    final t = AppTranslations.of(context); // 【新增】取得翻譯

    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      // 【修改】使用翻譯
                      hintText: t.searchEmergencyRecord,
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
              // 【修改】使用翻譯
              child: Row(
                children: [
                  _TableHeader(t.incidentDate),
                  _TableHeader(t.patientName),
                  _TableHeader(t.nationality),
                  _TableHeader(t.emergencyResult),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFB7E1E6), height: 12),
            Expanded(
              child: StreamBuilder<List<EmergencyRecord>>(
                stream: emergencyRecordsDao.watchAll(keyword: keyword),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(t.noEmergencyRecords));
                  }

                  final records = snapshot.data!;

                  if (records.isEmpty) {
                    // 【修改】使用翻譯
                    return Center(child: Text(t.noEmergencyRecords));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];

                      return InkWell(
                        onTap: () async {
                          // 【維持不變】仍然導航到 Nav4Page，但傳入 EmergencyRecord 的 visitId
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Nav4Page(visitId: record.visitId),
                            ),
                          );
                          // StreamBuilder 會自動處理更新，不需要手動 setState
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
                              // 【修改】從 EmergencyRecord 實例中取得資料
                              _TableCell(
                                record.incidentDateTime != null
                                    ? _fmtDateTime(record.incidentDateTime!)
                                    : t.valueNotAvailable,
                              ),
                              _TableCell(
                                record.patientName ?? t.valueNotAvailable,
                              ),
                              _TableCell(
                                record.nationality ?? t.valueNotAvailable,
                              ),
                              _TableCell(
                                record.endResult ??
                                    t.valueNotAvailable, // 使用 EmergencyRecord 的 endResult
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
}

// 【維持不變】_TableHeader 和 _TableCell 元件不需要修改
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
