import 'package:flutter/material.dart';
import 'home.dart';
import 'nav2.dart';
import 'PersonalInformation.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool showNav2 = false;
  int? visitId;
  int selectedPageIndex = 0;

  /// 打開 Nav2Page 並顯示指定 child
  void openNav2(int visitId, int pageIndex) {
    setState(() {
      this.visitId = visitId;
      selectedPageIndex = pageIndex;
      showNav2 = true;
    });
  }

  /// 關閉 Nav2Page 回到首頁
  void closeNav2() {
    setState(() {
      showNav2 = false;
      visitId = null;
      selectedPageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showNav2 && visitId != null) {
      return Nav2Page(
        selectedIndex: selectedPageIndex,
        visitId: visitId!,
        child: PersonalInformationPage(
          visitId: visitId!,
          closeNav2: closeNav2, // 點儲存或返回時回到 Home
        ),
      );
    }

    // 預設顯示首頁 + Nav1
    return HomePage(openNav2: openNav2);
  }
}
