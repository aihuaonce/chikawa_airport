import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: () {}, child: const Text('Previous')),
          _page('1', true),
          _page('2'),
          _page('3'),
          TextButton(onPressed: () {}, child: const Text('Next')),
        ],
      ),
    );
  }

  Widget _page(String text, [bool active = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(36, 36),
          backgroundColor: active ? Colors.teal : Colors.white,
          foregroundColor: active ? Colors.white : Colors.black,
        ),
        child: Text(text),
      ),
    );
  }
}
