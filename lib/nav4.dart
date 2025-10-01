// lib/nav4.dart
import 'package:flutter/material.dart';

// 你原本就有的 Nav3（維持一致）
import 'nav3.dart';

// 跳轉目標頁（你已經建好檔案了）
import 'Emergency_Personal.dart';
import 'Emergency_Flight.dart';
import 'Emergency_Accident.dart';
import 'Emergency_Plan.dart';

// 顏色沿用 nav2
const _light = Color(0xFF83ACA9);
const _dark  = Color(0xFF274C4A);
const _bg    = Color(0xFFEFF7F7);

class Nav4Page extends StatefulWidget {
  final Widget child;         // 真正內容
  final int selectedIndex;    // 0~3：目前亮起哪一個

  const Nav4Page({super.key, required this.child, required this.selectedIndex});

  @override
  State<Nav4Page> createState() => _Nav4PageState();
}

class _Nav4PageState extends State<Nav4Page> {
  final List<String> items = const [
    '個人資料',
    '飛航記錄',
    '事故紀錄',
    '處置紀錄',
  ];

  void _go(int i) {
    // 依索引推頁
    switch (i) {
      case 0:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const EmergencyPersonalPage()));
        break;
      case 1:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const EmergencyFlightPage()));
        break;
      case 2:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const EmergencyAccidentPage()));
        break;
      case 3:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const EmergencyPlanPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ===== 頂部工具列（與 nav2 同樣風格）=====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  // 左側：出診單（保留樣式，按鈕可視需要更改動作）
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6ABAD5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text('出診單'),
                  ),
                  const SizedBox(width: 12),

                  // 中間：綠色 Pills（僅 4 顆）
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(items.length, (i) {
                          final active = i == widget.selectedIndex;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _PillButton(
                              label: items[i],
                              active: active,
                              onTap: () => _go(i),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 右側：呼叫救護車、頭像（風格一致）
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE74C3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {},
                    child: const Text('呼叫救護車'),
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(radius: 18, backgroundColor: _light),
                ],
              ),
            ),
            const Divider(height: 1),

            // ===== 內容區 =====
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Nav3Section(), // ✅ 跟 nav2 一樣保留 Nav3
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: widget.child, // 各頁把實際內容丟進來
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 共用：Pill 按鈕（沿用 nav2 的樣式）=====
class _PillButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = active ? _dark : _light;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: const Text(
          '',
          // 這裡會被外面的 Text 取代，所以留空避免重覆；也可以直接把 Text 放進來：
        ),
      ),
    );
  }
}