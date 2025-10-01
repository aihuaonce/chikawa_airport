import 'package:flutter/material.dart';

class MaintainPage extends StatefulWidget {
  static const routeName = '/maintain';

  const MaintainPage({super.key});

  @override
  State<MaintainPage> createState() => _MaintainPageState();
}

class _MaintainPageState extends State<MaintainPage> {
  // ------ 外觀 ------
  static const double _cardRadius = 14;

  // ------ 資料（可在此先放預設值；之後可接後端改寫）------
  // 用 key 區分各個維護清單
  final Map<String, List<String>> _lists = {
    // 個人資料頁面
    'gender': ['男', '女'],
    'arrive_reason': ['航空公司機組員', '旅客/民眾', '機場內部員工'],
    'nationality': ['臺灣', '美國', '日本', '越南', '印尼'],
    'other_nationality': [],

    // 飛航記錄頁面
    'airline': [
      'BR長榮航空',
      'CI中華航空',
      'CX國泰航空',
      'UA聯合航空',
      'KL荷蘭航空',
      'CZ中國南方航空',
      'IT台灣虎航',
      'EK阿聯酋航空',
      'CA中國國際航空',
    ],
    'airline_other': [
      'JX星宇航空',
      'AE華信航空',
      'B7立榮航空',
      'MU中國東方航空',
      'MF廈門航空',
      'MM樂桃航空',
      'KE大韓航空',
      'OZ韓亞航空',
    ],
    'origin': [
      'TPE台北 / 台灣',
      'HKG香港 / 香港',
      'LAX洛杉磯 / 美國',
      'TYO東京 / 日本',
      'BKK曼谷 / 泰國',
      'SHA上海 / 中國',
    ],
    'via': [
      'MNL馬尼拉 / 菲律賓',
      'SFO舊金山 / 美國',
      'SIN新加坡 / 新加坡',
    ],
    'destination': [
      'TPE台北 / 台灣',
      'HKG香港 / 香港',
      'LAX洛杉磯 / 美國',
      'TYO東京 / 日本',
      'BKK曼谷 / 泰國',
      'SHA上海 / 中國',
    ],
    'travel_status': ['出境', '入境', '過境', '轉機', '迫降', '轉降', '備降', '其他'],
  };

  // ------ 彈窗：通用維護對話框 ------
  Future<void> _openMaintainDialog({
    required String key,
    required String title,
  }) async {
    // 這裡用 StatefulBuilder 讓彈窗內能即時刷新
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final items = _lists[key] ?? [];

            Future<void> addItem() async {
              final text = await _showAddDialog(context: ctx, title: '新增 $title');
              if (text == null || text.trim().isEmpty) return;

              // 更新資料：外層 setState 讓頁面狀態也保留；setLocal 刷新彈窗內容
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
                        onPressed: addItem,
                        icon: const Icon(Icons.add),
                        label: const Text('新增'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 360),
                      child: items.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text('目前沒有資料'),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final val = items[i];
                                return ListTile(
                                  dense: true,
                                  title: Text(val),
                                  onTap: () {
                                    // 這裡先單純關閉彈窗；需要的話可在這裡做選擇回傳
                                    Navigator.of(ctx).pop();
                                  },
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

  // ------ 小輸入彈窗（供「新增」使用）------
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
              onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
              child: const Text('新增'),
            ),
          ],
        );
      },
    );
  }

  // ------ UI ------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
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
              _sectionCard(
                title: '個人資料頁面',
                children: [
                  _maintainTile(
                    label: '性別',
                    onTap: () => _openMaintainDialog(
                      key: 'gender',
                      title: '性別',
                    ),
                  ),
                  _maintainTile(
                    label: '為何至機場',
                    onTap: () => _openMaintainDialog(
                      key: 'arrive_reason',
                      title: '為何至機場',
                    ),
                  ),
                  _maintainTile(
                    label: '國籍',
                    onTap: () => _openMaintainDialog(
                      key: 'nationality',
                      title: '國籍',
                    ),
                  ),
                  _maintainTile(
                    label: '其他國籍',
                    onTap: () => _openMaintainDialog(
                      key: 'other_nationality',
                      title: '其他國籍',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: '飛航記錄頁面',
                children: [
                  _maintainTile(
                    label: '航空公司',
                    onTap: () =>
                        _openMaintainDialog(key: 'airline', title: '航空公司'),
                  ),
                  _maintainTile(
                    label: '其他航空公司',
                    onTap: () => _openMaintainDialog(
                        key: 'airline_other', title: '其他航空公司'),
                  ),
                  _maintainTile(
                    label: '啟程地',
                    onTap: () =>
                        _openMaintainDialog(key: 'origin', title: '啟程地'),
                  ),
                  _maintainTile(
                    label: '經過地',
                    onTap: () => _openMaintainDialog(key: 'via', title: '經過地'),
                  ),
                  _maintainTile(
                    label: '目的地',
                    onTap: () => _openMaintainDialog(
                        key: 'destination', title: '目的地'),
                  ),
                  _maintainTile(
                    label: '旅行狀態',
                    onTap: () => _openMaintainDialog(
                        key: 'travel_status', title: '旅行狀態'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 區塊卡片
  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // 單一維護項目列
  Widget _maintainTile({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0x11000000)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
