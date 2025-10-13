import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'nav2.dart';
import 'data/models/accident_data.dart';
import 'data/models/flightlog_data.dart';
import 'data/models/patient_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String keyword = "";
  final TextEditingController _searchController = TextEditingController();

  // 【修改】定義所有可用的欄位（順序固定）- 使用 key 來對應翻譯
  List<String> get availableColumnKeys => [
    'patientName',
    'gender',
    'nationality',
    'uploadedAt',
    'dept',
    'note',
    'filledBy',
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

  // 【新增】根據 key 取得翻譯後的欄位名稱
  String _getColumnLabel(BuildContext context, String columnKey) {
    final t = AppTranslations.of(context);
    switch (columnKey) {
      case 'patientName':
        return t.patientName;
      case 'gender':
        return t.gender;
      case 'nationality':
        return t.nationality;
      case 'uploadedAt':
        return t.updateTimeShort;
      case 'dept':
        return t.department;
      case 'note':
        return t.note;
      case 'filledBy':
        return t.filledBy;
      default:
        return columnKey;
    }
  }

  void _showColumnSelector() {
    final t = AppTranslations.of(context); // 【新增】取得翻譯

    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempVisibleColumns = List.from(visibleColumns);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.selectColumns), // 【修改】使用翻譯
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availableColumnKeys.map((columnKey) {
                    bool isSelected = tempVisibleColumns.contains(columnKey);
                    bool canSelect =
                        tempVisibleColumns.length < 7 || isSelected;

                    return CheckboxListTile(
                      title: Text(
                        _getColumnLabel(context, columnKey), // 【修改】使用翻譯
                        style: TextStyle(color: canSelect ? null : Colors.grey),
                      ),
                      value: isSelected,
                      onChanged: canSelect
                          ? (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  if (!tempVisibleColumns.contains(columnKey) &&
                                      tempVisibleColumns.length < 7) {
                                    tempVisibleColumns.add(columnKey);
                                  }
                                } else {
                                  tempVisibleColumns.remove(columnKey);
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
                  '${t.selectedCount}: ${tempVisibleColumns.length}/7', // 【修改】使用翻譯
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
                      tempVisibleColumns = availableColumnKeys.take(7).toList();
                    });
                  },
                  child: Text(t.defaultSeven), // 【修改】使用翻譯
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempVisibleColumns.clear();
                    });
                  },
                  child: Text(t.clearAll), // 【修改】使用翻譯
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(t.cancel), // 【修改】使用翻譯
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visibleColumns = tempVisibleColumns;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(t.confirm), // 【修改】使用翻譯
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
                  },
                  child: Text(t.addPatient), // 【修改】使用翻譯
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
                  label: Text(
                    '${t.columnSettings} (${visibleColumns.length}/7)',
                  ), // 【修改】使用翻譯
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: t.searchPlaceholder, // 【修改】使用翻譯
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
                children: availableColumnKeys
                    .where((columnKey) => visibleColumns.contains(columnKey))
                    .map(
                      (columnKey) =>
                          _TableHeader(_getColumnLabel(context, columnKey)),
                    ) // 【修改】使用翻譯
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
                    return Center(child: Text(t.noPatientRecords)); // 【修改】使用翻譯
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
                            children: availableColumnKeys
                                .where(
                                  (columnKey) =>
                                      visibleColumns.contains(columnKey),
                                )
                                .map((columnKey) {
                                  final cellValue = _getCellValue(v, columnKey);
                                  return _TableCell(
                                    cellValue ?? t.valueNotAvailable,
                                  );
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
