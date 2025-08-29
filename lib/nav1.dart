import 'package:flutter/material.dart';

const _light = Color(0xFF83ACA9);
const _dark = Color(0xFF274C4A);
const _bg = Color(0xFFEFF7F7);

class Nav1Page extends StatefulWidget {
  const Nav1Page({super.key});

  @override
  State<Nav1Page> createState() => _Nav1PageState();
}

class _Nav1PageState extends State<Nav1Page> {
  final List<String> items = <String>['機場出診單', '查看報表', '衛教專區'];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (i) {
                  final bool isActive = i == selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i],
                      active: isActive,
                      onTap: () => setState(() => selected = i),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            child: const Text('呼叫救護車'),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/avatar.jpg'),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = active ? _dark : _light;
    final Color fg = Colors.white;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
