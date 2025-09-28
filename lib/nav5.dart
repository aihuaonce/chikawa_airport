// lib/nav5.dart
import 'package:flutter/material.dart';
import 'nav3.dart';

// 這裡匯入你建立好的頁面
import 'Ambulance_Information.dart';
import 'Ambulance_Personal.dart';
import 'Ambulance_Situation.dart';
import 'Ambulance_Plan.dart';
import 'Ambulance_Expenses.dart';

const _light = Color(0xFF83ACA9);
const _dark  = Color(0xFF274C4A);
const _bg    = Color(0xFFEFF7F7);

class Nav5Page extends StatefulWidget {
  final Widget child;         // 內頁內容
  final int selectedIndex;    // 0~4 指示當前亮起的 pill

  const Nav5Page({super.key, required this.child, required this.selectedIndex});

  @override
  State<Nav5Page> createState() => _Nav5PageState();
}

class _Nav5PageState extends State<Nav5Page> {
  final List<String> items = const [
    '派遣資料',
    '病患資料',
    '現場狀況',
    '處置項目',
    '收取費用',
  ];

  void _go(int i) {
    switch (i) {
      case 0:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AmbulanceInformationPage()));
        break;
      case 1:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AmbulancePersonalPage()));
        break;
      case 2:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AmbulanceSituationPage()));
        break;
      case 3:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AmbulancePlanPage()));
        break;
      case 4:
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AmbulanceExpensesPage()));
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
            // ===== 頂部工具列 =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6ABAD5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('出診單'),
                  ),
                  const SizedBox(width: 12),

                  // 中：五個綠色 pill
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

                  // 右：呼叫救護車
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

                  // 右：頭像
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
                    child: Nav3Section(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: widget.child,
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

// 共用 pill 按鈕
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
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
