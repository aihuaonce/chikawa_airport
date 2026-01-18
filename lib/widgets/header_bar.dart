import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Primary Consultation Records',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('EN')),
          TextButton(onPressed: () {}, child: const Text('CH')),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add),
            label: const Text('New Patient'),
          ),
        ],
      ),
    );
  }
}
