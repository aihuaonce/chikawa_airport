import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Icon(Icons.medical_services, size: 36),
          const SizedBox(height: 48),
          _item(Icons.assignment, true),
          _item(Icons.emergency, false),
          _item(Icons.settings, false),
        ],
      ),
    );
  }

  Widget _item(IconData icon, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: active ? Colors.teal : Colors.transparent,
        child: Icon(icon, color: active ? Colors.white : Colors.grey),
      ),
    );
  }
}
