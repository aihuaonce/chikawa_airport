import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'nav2.dart';
import 'nav1.dart';
import 'data/models/accident_data.dart';
import 'data/models/flightlog_data.dart';
import 'data/models/patient_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String keyword = "";
  final TextEditingController _searchController = TextEditingController();

  // 定義所有可用的欄位（順序固定）
  final List<MapEntry<String, String>> availableColumns = [
    const MapEntry('patientName', '病患'),
    const MapEntry('gender', '性別'),
    const MapEntry('nationality', '國籍'),
    const MapEntry('uploadedAt', '更新時間'),
    const MapEntry('dept', '科別'),
    const MapEntry('note', '備註'),
    const MapEntry('filledBy', '填寫人'),
  ];

  // 預設顯示的欄位
  List<String> visibleColumns = [
    'patientName',
    'gender',
    'nationality',
    'uploadedAt',
    'dept',
    'note',
    'filledBy',
  ];

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

  void _showColumnSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempVisibleColumns = List.from(visibleColumns);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('選擇要顯示的欄位 (最多7個)'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availableColumns.map((entry) {
                    bool isSelected = tempVisibleColumns.contains(entry.key);
                    bool canSelect =
                        tempVisibleColumns.length < 7 || isSelected;

                    return CheckboxListTile(
                      title: Text(
                        entry.value,
                        style: TextStyle(color: canSelect ? null : Colors.grey),
                      ),
                      value: isSelected,
                      onChanged: canSelect
                          ? (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  if (!tempVisibleColumns.contains(entry.key) &&
                                      tempVisibleColumns.length < 7) {
                                    tempVisibleColumns.add(entry.key);
                                  }
                                } else {
                                  tempVisibleColumns.remove(entry.key);
                                }
                              });
                            }
                          : null,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                Text(
                  '已選擇: ${tempVisibleColumns.length}/7',
                  style: TextStyle(
                    color: tempVisibleColumns.length == 7
                        ? Colors.orange
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempVisibleColumns = availableColumns
                          .take(7)
                          .map((e) => e.key)
                          .toList();
                    });
                  },
                  child: const Text('預設7個'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempVisibleColumns.clear();
                    });
                  },
                  child: const Text('全部清除'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visibleColumns = tempVisibleColumns;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('確定'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _getCellValue(Visit visit, String columnKey) {
    switch (columnKey) {
      case 'patientName':
        return visit.patientName;
      case 'gender':
        return visit.gender;
      case 'nationality':
        return visit.nationality;
      case 'uploadedAt':
        return visit.uploadedAt == null
            ? null
            : _fmtDateTime(visit.uploadedAt!);
      case 'dept':
        return visit.dept;
      case 'note':
        return visit.note;
      case 'filledBy':
        return visit.filledBy;
      default:
        return null;
    }
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

                    context.read<PatientData>().clear();
                    context.read<AccidentData>().clear();
                    context.read<FlightLogData>().clear();

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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: _showColumnSelector,
                  icon: const Icon(Icons.view_column, size: 18),
                  label: Text('欄位設定 (${visibleColumns.length}/7)'),
                ),
                const SizedBox(width: 8),
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
                children: availableColumns
                    .where((column) => visibleColumns.contains(column.key))
                    .map((column) => _TableHeader(column.value))
                    .toList(),
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
                            children: availableColumns
                                .where(
                                  (column) =>
                                      visibleColumns.contains(column.key),
                                )
                                .map((column) {
                                  final cellValue = _getCellValue(
                                    v,
                                    column.key,
                                  );
                                  return _TableCell(cellValue ?? '—');
                                })
                                .toList(),
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
