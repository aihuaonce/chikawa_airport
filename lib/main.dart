import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phoho Show', style: TextStyle(color: Color(0xFFFFF600))),
      ),
      body: Column(
        children: [
          Image.network(
            'https://cdn.pixabay.com/photo/2016/12/11/12/02/bled-1899264_960_720.jpg',
          ),
          Image.network(
            'https://cdn.pixabay.com/photo/2017/01/19/23/46/panorama-1993645_960_720.jpg',
          ),
          Image.network(
            'https://cdn.pixabay.com/photo/2017/12/15/13/51/polynesia-3021072_960_720.jpg',
          ),
        ],
      ),
    );
  }
}
