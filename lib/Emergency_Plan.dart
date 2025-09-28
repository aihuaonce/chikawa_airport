import 'package:flutter/material.dart';
import 'nav4.dart';
// Emergency_Plan.dart
class EmergencyPlanPage extends StatelessWidget {
  const EmergencyPlanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav4Page(
      selectedIndex: 3, // 處置紀錄
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('處置紀錄內容...'),
      ),
    );
  }
}
