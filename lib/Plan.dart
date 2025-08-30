import 'package:flutter/material.dart';
import 'nav2.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      initialIndex: 3,
      child: Container(
        color: const Color(0xFFE6F6FB),
        child: const Center(
          child: Text('處置記錄內容', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
