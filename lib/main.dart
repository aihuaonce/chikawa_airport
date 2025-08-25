import 'package:flutter/material.dart';
import 'login.dart'; // 你自己新增的登入頁面

void main() {
  runApp(const MyApp()); // App 的進入點
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(), // 設定第一個畫面 = 登入頁
    );
  }
}
