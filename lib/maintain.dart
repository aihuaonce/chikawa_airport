import 'package:flutter/material.dart';

class MaintainPage extends StatefulWidget {
  static const routeName = '/maintain';

  const MaintainPage({super.key});

  @override
  State<MaintainPage> createState() => _MaintainPageState();
}

class _MaintainPageState extends State<MaintainPage> {
  static const double _cardRadius = 14;

  // ===== 色號（你之前給的）=====
  static const _light = Color(0xFF83ACA9); // 淺綠色
  static const _dark = Color(0xFF274C4A);  // 深綠色

  // ===== 搜尋欄控制器 =====
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  // ===== 測試資料 =====
  final Map<String, List<String>> _lists = {
    'gender': ['男', '女'],
    'arrive_reason': ['航空公司機組員', '旅客/民眾', '機場內部員工'],
    'nationality': ['臺灣', '美國', '日本', '越南', '印尼'],
    'other_nationality': [],
    'airline': ['BR長榮航空', 'CI中華航空', 'CX國泰航空'],
    'travel_status': ['出境', '入境', '過境'],
  };

  // ===== 彈窗 =====
  Future<void> _openMaintainDialog({
    required String key,
    required String title,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final items = _lists[key] ?? [];

            Future<void> addItem() async {
              final text = await _showAddDialog(context: ctx, title: '新增 $title');
              if (text == null || text.trim().isEmpty) return;

              setState(() {
                _lists[key] = [...items, text.trim()];
              });
              setLocal(() {});
            }

            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: _light,
                          foregroundColor: Colors.white,
                        ).copyWith(
                          backgroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.pressed)) return _dark;
                            return _light;
                          }),
                        ),
                        onPressed: addItem,
                        icon: const Icon(Icons.add),
                        label: const Text('新增'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    items.isEmpty
                        ? const Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('目前沒有資料'),
                        ))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final val = items[i];
                              return ListTile(
                                dense: true,
                                title: Text(val),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    setState(() {
                                      _lists[key] = List.of(items)..removeAt(i);
                                    });
                                    setLocal(() {});
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('關閉'),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showAddDialog({
    required BuildContext context,
    required String title,
  }) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '請輸入內容',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => Navigator.of(ctx).pop(ctrl.text.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _light,
                foregroundColor: Colors.white,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) return _dark;
                  return _light;
                }),
              ),
              onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
              child: const Text('新增'),
            ),
          ],
        );
      },
    );
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: const Text('各式單據內列表'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 搜尋欄 =====
              TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  hintText: '搜尋項目…',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val.trim());
                },
              ),
              const SizedBox(height: 16),

              // ===== 個人資料 =====
              _sectionCard(
                title: '個人資料頁面',
                children: [
                  _maintainTile('性別', 'gender'),
                  _maintainTile('為何至機場', 'arrive_reason'),
                  _maintainTile('國籍', 'nationality'),
                  _maintainTile('其他國籍', 'other_nationality'),
                ],
              ),
              const SizedBox(height: 16),

              // ===== 飛航紀錄 =====
              _sectionCard(
                title: '飛航記錄頁面',
                children: [
                  _maintainTile('航空公司', 'airline'),
                  _maintainTile('旅行狀態', 'travel_status'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_cardRadius),
                topRight: Radius.circular(_cardRadius),
              ),
            ),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _maintainTile(String label, String key) {
    // 套用搜尋篩選
    if (_searchQuery.isNotEmpty &&
        !label.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _openMaintainDialog(key: key, title: label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0x11000000)),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
