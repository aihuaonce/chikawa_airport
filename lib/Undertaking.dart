import 'package:flutter/material.dart';
import 'nav2.dart';

class UndertakingPage extends StatelessWidget {
  const UndertakingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      initialIndex: 6,
      child: Container(
        color: const Color(0xFFE6F6FB),
        child: const Center(
          child: Text('拒絕轉診切結書內容', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
