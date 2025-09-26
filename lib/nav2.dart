// nav2.dart

import 'package:flutter/material.dart';

// 匯入所有頁面
import 'nav3.dart';
import 'AccidentRecord.dart';
import 'ElectronicDocuments.dart';
import 'FlightLog.dart';
import 'MedicalCertificate.dart';
import 'MedicalExpenses.dart';
import 'NursingRecord.dart';
import 'PersonalInformation.dart';
import 'Plan.dart';
import 'ReferralForm.dart';
import 'Undertaking.dart';


const _light = Color(0xFF83ACA9);
const _dark = Color(0xFF274C4A);
const _bg = Color(0xFFEFF7F7);

class Nav2Page extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

    // ⭐ 新增：整個個案的 key，切頁時要帶給每個子頁
  final int visitId;

  const Nav2Page({super.key, required this.child, required this.selectedIndex,required this.visitId});

  @override
  State<Nav2Page> createState() => _Nav2PageState();
}

class _Nav2PageState extends State<Nav2Page> {
  final List<String> items = <String>[
    '個人資料',
    '飛航記錄',
    '事故紀錄',
    '處置紀錄',
    '醫療費用',
    '診斷書',
    '拒絕轉診切結書',
    '電傳文件',
    '轉診單',
    '護理紀錄表',
  ];

  // 移除 initState，因為我們不再需要內部狀態 `selected`
  // 導航欄的高亮狀態將直接依賴於外部傳入的 widget.selectedIndex

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
                      backgroundColor: const Color(0xFF6ABAD5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                          final bool isActive =
                              i ==
                              widget
                                  .selectedIndex; // 這裡直接使用 widget.selectedIndex
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _PillButton(
                              label: items[i],
                              active: isActive,
                              onTap: () {
                                // 使用 Navigator.push，並確保每次都跳轉到對應頁面
                                if (i == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PersonalInformationPage(
                                            visitId: widget.visitId,
                                          ),
                                    ),
                                  );
                                } else if (i == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FlightLogPage(visitId: widget.visitId,),
                                    ),
                                  );
                                } else if (i == 2) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AccidentRecordPage(visitId: widget.visitId,),
                                    ),
                                  );
                                } else if (i == 3) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlanPage(visitId: widget.visitId),
                                    ),
                                  ); // 原先您的邏輯是醫療費用，這裏是處置紀錄
                                } else if (i == 4) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MedicalExpensesPage(visitId: widget.visitId,),
                                    ),
                                  );
                                } else if (i == 5) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MedicalCertificatePage(visitId: widget.visitId,),
                                    ),
                                  );
                                } else if (i == 6) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UndertakingPage(visitId: widget.visitId),
                                    ),
                                  );
                                } else if (i == 7) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ElectronicDocumentsPage(visitId: widget.visitId,),
                                    ),
                                  );
                                } else if (i == 8) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReferralFormPage(visitId: widget.visitId),
                                    ),
                                  );
                                } else if (i == 9) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NursingRecordPage(
                                        visitId: widget.visitId,
                                      ),
                                    ),
                                  );
                                }
                              },
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
                      backgroundColor: const Color(0xFFE74C3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('呼叫救護車'),
                  ),
                  const SizedBox(width: 12),
                  // 右：頭像（保留）
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),


            // ====== 內容區 ======
        // ====== 內容區 ======
          Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: const Nav3Section(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: widget.child, // 或各頁自己處理滾動就不用再包
                    ),
                  ),
                ],
              ),
            )


                  



          ],
        ),
      ),
    );
  }
}

// _PillButton 維持不變

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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
