import 'package:flutter/material.dart';
import 'nav4.dart';

// Emergency_Flight.dart
class EmergencyFlightPage extends StatelessWidget {
  const EmergencyFlightPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav4Page(
      selectedIndex: 1, // 飛航記錄
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('飛航記錄內容...'),
      ),
    );
  }
}
