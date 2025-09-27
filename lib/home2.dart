import 'package:flutter/material.dart';
// 這裡可以加入 Nav1Page 讓新頁面也有導航列
import 'nav1.dart'; 

class Home2Page extends StatelessWidget {
  const Home2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Column(
        children: [
          // 在這裡顯示 Nav1Page 讓導航列持續顯示
          const Nav1Page(), 
          const Expanded(
            child: Center(
              child: Text("急救紀錄單內容頁面", style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}