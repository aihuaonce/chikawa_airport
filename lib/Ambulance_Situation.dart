// Ambulance_Information.dart
import 'package:flutter/material.dart';
import 'nav5.dart';

class AmbulanceSituationPage extends StatelessWidget {
  const AmbulanceSituationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav5Page(
      selectedIndex: 2,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('現場狀況內容...'),
      ),
    );
  }
}
