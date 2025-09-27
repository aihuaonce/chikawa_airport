import 'package:flutter/material.dart';
import 'nav1.dart'; 

class Home3Page extends StatelessWidget {
  const Home3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Column(
        children: [
          const Nav1Page(), 
          const Expanded(
            child: Center(
              child: Text("救護車紀錄單內容頁面", style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}