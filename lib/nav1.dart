import 'package:flutter/material.dart';

const _light = Color(0xFF83ACA9);
const _dark = Color(0xFF274C4A);

class Nav1Page extends StatefulWidget {
  const Nav1Page({super.key});

  @override
  State<Nav1Page> createState() => _Nav1PageState();
}

class _Nav1PageState extends State<Nav1Page> {
  final List<String> items = ['機場出診單', '查看報表', '衛教專區'];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          // 水平滾動 Tab
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (i) {
                  final isActive = i == selected;
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
          // 呼叫救護車按鈕
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
            // backgroundImage: AssetImage('assets/avatar.jpg'),
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
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? _dark : _light,
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
