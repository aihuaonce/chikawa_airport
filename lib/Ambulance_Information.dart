// Ambulance_Information.dart
import 'package:flutter/material.dart';
import 'nav5.dart';

class AmbulanceInformationPage extends StatelessWidget {
  const AmbulanceInformationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Nav5Page(
      selectedIndex: 0,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('派遣資料內容...'),
      ),
    );
  }
}
