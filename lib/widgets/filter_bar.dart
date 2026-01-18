import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final labels = ['All', 'Pending', 'Emergency', 'Completed'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: List.generate(labels.length, (i) {
          return ChoiceChip(
            label: Text(labels[i]),
            selected: selected == i,
            onSelected: (_) => setState(() => selected = i),
          );
        }),
      ),
    );
  }
}
