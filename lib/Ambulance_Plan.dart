// Ambulance_Information.dart
import 'package:flutter/material.dart';
import 'nav5.dart';

class AmbulancePlanPage extends StatelessWidget {
  const AmbulancePlanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav5Page(
      selectedIndex: 3,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('處置內容...'),
      ),
    );
  }
}
