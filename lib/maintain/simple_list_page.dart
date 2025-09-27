import 'package:flutter/material.dart';
import 'package:chikawa_airport/nav1.dart';

/// 通用清單維護頁（不連資料庫的可跑版）
/// - AppBar 顯示標題
/// - 左上「新增」按鈕：跳出底部輸入框，新增一筆到清單
/// - 標題列有「全選」checkbox
/// - 每筆皆可勾選（之後你要做刪除/匯出都好處理）
///
/// 之後要接資料庫時，把 _items 換成你的後端資料來源即可。
class SimpleListPage extends StatefulWidget {
  final String title;
  final List<String> initialItems;

  const SimpleListPage({
    super.key,
    required this.title,
    this.initialItems = const [],
  });

  @override
  State<SimpleListPage> createState() => _SimpleListPageState();
}

class _SimpleListPageState extends State<SimpleListPage> {
  late List<String> _items;
  final Set<int> _checked = {};

  @override
  void initState() {
    super.initState();
    _items = [...widget.initialItems];
  }

  bool get _allChecked => _items.isNotEmpty && _checked.length == _items.length;

  void _toggleAll(bool? v) {
    setState(() {
      if (v == true) {
        _checked.addAll(List.generate(_items.length, (i) => i));
      } else {
        _checked.clear();
      }
    });
  }

  Future<void> _showAddSheet() async {
    final ctrl = TextEditingController();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (c) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16,
            bottom: 16 + MediaQuery.of(c).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('新增 ${widget.title} 項目',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: '請輸入名稱',
                ),
                autofocus: true,
                onSubmitted: (_) => Navigator.pop(c, true),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('確認新增'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (ok == true && ctrl.text.trim().isNotEmpty) {
      setState(() => _items.add(ctrl.text.trim()));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已新增（暫存，不連資料庫）')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ★ 這裡把 Nav1 放在 AppBar 的 bottom，進任何清單頁都能看到 Nav1
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56), // Nav1 高度
          child: const Nav1Page(),                  // 直接塞你的 Nav1
        ),
      ),
      body: Column(
        children: [
          // 上方工具列：新增
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                FilledButton.icon(
                  onPressed: _showAddSheet,
                  icon: const Icon(Icons.add),
                  label: const Text('新增'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 標題列（含全選）
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                  value: _allChecked,
                  onChanged: _items.isEmpty ? null : _toggleAll,
                ),
                const SizedBox(width: 8),
                Text('${widget.title}名稱',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),

          // 清單
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('尚無資料，請點「新增」建立第一筆'))
                : ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final checked = _checked.contains(i);
                      return ListTile(
                        leading: Checkbox(
                          value: checked,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _checked.add(i);
                              } else {
                                _checked.remove(i);
                              }
                            });
                          },
                        ),
                        title: Text(_items[i]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}