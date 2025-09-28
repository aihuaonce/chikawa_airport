// Ambulance_Information.dart
import 'package:flutter/material.dart';
import 'nav5.dart';

class AmbulancePersonalPage extends StatelessWidget {
  const AmbulancePersonalPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav5Page(
      selectedIndex: 1,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('病患資料內容...'),
      ),
    );
  }
}
