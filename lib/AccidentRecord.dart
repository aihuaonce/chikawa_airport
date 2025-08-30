import 'package:flutter/material.dart';
import 'nav2.dart';

class AccidentRecordPage extends StatelessWidget {
  const AccidentRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      child: Container(
        color: const Color(0xFFE6F6FB),
        child: const Center(
          child: Text('事故記錄內容', style: TextStyle(color: Colors.grey)),
        ),
      ),
      selectedIndex: 2, // 確保這裡有這個參數
    );
  }
}
