import 'package:flutter/material.dart';
import 'routes_config.dart';

// 回首頁 callback (現在執行 Navigator.pop)
typedef CloseNav2Callback = void Function();

class Nav2Page extends StatefulWidget {
  final int visitId;
  final int initialIndex;
  final CloseNav2Callback? closeNav2;
  final Widget child; // ★ 修正：新增 child 參數

  const Nav2Page({
    super.key,
    required this.visitId,
    this.initialIndex = 0,
    this.closeNav2,
    required this.child, // 設為 required
  });

  @override
  State<Nav2Page> createState() => _Nav2PageState();
}

class _Nav2PageState extends State<Nav2Page> {
  void _changeTab(int index) {
    // 點擊 Tab 時，導航到新的路由
    final nextRouteItem = routeItems[index];

    // 使用 pushReplacementNamed 替換當前頁面
    // 這樣可以避免 Nav2Page 的選單邏輯複雜化，讓每個 Tab 都是一個新的路由，但保留在 Nav2Page 的外觀下。
    Navigator.pushReplacementNamed(
      context,
      nextRouteItem.path,
      arguments: widget.visitId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 獲取當前的 selectedIndex，它就是由 routes_config 傳入的 initialIndex
    final selectedIndex = widget.initialIndex;

    return Scaffold(
      body: Column(
        children: [
          // 上方橫向選單 (Nav2)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(routeItems.length, (i) {
                final isActive = i == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => _changeTab(i),
                    child: Text(routeItems[i].label),
                  ),
                );
              }),
            ),
          ),
          // 當前分頁內容：顯示傳入的 child
          Expanded(child: widget.child),
        ],
      ),
      // 返回按鈕
      floatingActionButton: widget.closeNav2 != null
          ? FloatingActionButton(
              onPressed: widget.closeNav2, // 執行 Navigator.pop(context)
              child: const Icon(Icons.arrow_back),
            )
          : null,
    );
  }
}
