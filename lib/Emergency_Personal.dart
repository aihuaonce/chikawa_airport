// Emergency_Personal.dart
import 'package:flutter/material.dart';
import 'nav4.dart';

class EmergencyPersonalPage extends StatelessWidget {
  const EmergencyPersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav4Page(
      selectedIndex: 0, // 個人資料
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('個人資料內容...'),
      ),
    );
  }
}
