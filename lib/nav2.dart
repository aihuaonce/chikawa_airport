// lib/nav2.dart
import 'package:flutter/material.dart';
import 'nav3.dart';

const _light = Color(0xFF83ACA9); // 淺綠
const _dark  = Color(0xFF274C4A); // 深綠
const _bg    = Color(0xFFEFF7F7); // 背景淡色，可自行調整

/// 你要看的頁面：上方有綠色橫條的導航
class Nav2Page extends StatefulWidget {
  const Nav2Page({super.key});

  @override
  State<Nav2Page> createState() => _Nav2PageState();
}

class _Nav2PageState extends State<Nav2Page> {
  // >>> 這裡的清單就是橫條上的選項（可自行改順序/內容）
  // 如果你要用「圖二」那組，就把下面這組改成圖二的文字即可。
  final List<String> items = <String>[
    '個人資料', '飛航記錄', '事故紀錄', '處置紀錄', '醫療費用', '診斷書', '拒絕轉診切結書', '電傳文件','轉診單','護理紀錄表',
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
                  // 左：出診單（保留）
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor:Color(0xFF6ABAD5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text('出診單'),
                  ),
                  const SizedBox(width: 12),

                  // 中：可橫向捲動的綠色分頁 Pills
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
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 28), // 想靠上/靠下自己調
                  child: const Nav3Section(),
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
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
