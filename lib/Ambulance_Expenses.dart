// Ambulance_Information.dart
import 'package:flutter/material.dart';
import 'nav5.dart';

class AmbulanceExpensesPage extends StatelessWidget {
  const AmbulanceExpensesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav5Page(
      selectedIndex: 4,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('收取費用內容...'),
      ),
    );
  }
}
