import 'package:flutter/material.dart';

class GenericListPage extends StatelessWidget {
  final String title;
  const GenericListPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('這是 $title 的頁面骨架，之後再補內容')),
    );
  }
}
