import 'package:flutter/material.dart';
import 'nav2.dart';

class ElectronicDocumentsPage extends StatelessWidget {
  const ElectronicDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      initialIndex: 7,
      child: Container(
        color: const Color(0xFFE6F6FB),
        child: const Center(
          child: Text('電傳文件內容', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
