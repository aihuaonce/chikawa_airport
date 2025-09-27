import 'package:flutter/material.dart';
import 'nav4.dart';
// Emergency_Accident.dart
class EmergencyAccidentPage extends StatelessWidget {
  const EmergencyAccidentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav4Page(
      selectedIndex: 2, // 事故紀錄
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('事故紀錄內容...'),
      ),
    );
  }
}
