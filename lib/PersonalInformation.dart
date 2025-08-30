import 'package:flutter/material.dart';
import 'nav2.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      child: Container(
        color: const Color(0xFFE6F6FB),
        child: const Center(
          child: Text('個人資料內容', style: TextStyle(color: Colors.grey)),
        ),
      ),
      selectedIndex: 0,
    );
  }
}
