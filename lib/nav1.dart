// lib/nav1.dart
import 'package:flutter/material.dart';

const _light = Color(0xFF83ACA9); // 淺綠
const _dark  = Color(0xFF274C4A); // 深綠
const _bg    = Color(0xFFEFF7F7); // 背景淡色，可自行調整

/// 你要看的頁面：上方有綠色橫條的導航
class Nav1Page extends StatefulWidget {
  const Nav1Page({super.key});

  @override
  State<Nav1Page> createState() => _Nav1PageState();
}

class _Nav1PageState extends State<Nav1Page> {
  // >>> 這裡的清單就是橫條上的選項（可自行改順序/內容）
  // 如果你要用「圖二」那組，就把下面這組改成圖二的文字即可。
  final List<String> items = <String>[
    '機場出診單', '查看報表', '衛教專區',
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ====== 頂部工具列 ======
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                

                  // 左：可橫向捲動的綠色分頁 Pills
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(items.length, (i) {
                          final bool isActive = i == selected;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _PillButton(
                              label: items[i],
                              active: isActive,
                              onTap: () => setState(() => selected = i),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 右：呼叫救護車（保留）
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE74C3C), // 紅色
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {},
                    child: const Text('呼叫救護車'),
                  ),
                  const SizedBox(width: 12),

                  // 右：頭像（保留）
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/avatar.jpg'), // 你可以換成 NetworkImage
                    // 如果暫時沒有圖片，改用 backgroundColor 即可：
                    // backgroundColor: Colors.grey,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ====== 內容區（先放占位，顯示目前選中的頁籤） ======
            Expanded(
              child: Center(
                child: Text(
                  '目前選擇：${items[selected]}',
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 綠色圓角 pill 按鈕（淺綠 / 深綠 切換）
class _PillButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = active ? _dark : _light;
    final Color fg = Colors.white;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Text(
          label,
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}