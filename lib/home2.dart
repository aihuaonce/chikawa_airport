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
              child: StreamBuilder<List<EmergencyRecordView>>(
                stream: emergencyRecordsDao.watchAllDetails(keyword: keyword),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(t.noEmergencyRecords));
                  }

                  final records = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      // 【修改 3/3】從組合後的 recordView 中取得各個資料表的資料
                      final recordView = records[index];
                      final visit = recordView.visit;
                      final emergencyRecord = recordView.emergencyRecord;
                      final accidentRecord = recordView.accidentRecord;

                      return InkWell(
                        onTap: () async {
                          // 導航時使用 visit.visitId
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Nav4Page(visitId: visit.visitId),
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
                              // 2. incidentDate 連 AccidentRecords 的 incidentDate
                              _TableCell(
                                accidentRecord?.incidentDate != null
                                    ? _fmtDateTime(accidentRecord!.incidentDate!)
                                    : t.valueNotAvailable,
                              ),
                              // 1. patientName 連 Visits 的 patientName
                              _TableCell(
                                visit.patientName ?? t.valueNotAvailable,
                              ),
                              // 3. nationality 連 Visits 的 nationality
                              _TableCell(
                                visit.nationality ?? t.valueNotAvailable,
                              ),
                              // 4. emergencyResult 連 EmergencyRecords 的 endResult
                              _TableCell(
                                emergencyRecord.endResult ?? t.valueNotAvailable,
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
