import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header_bar.dart';
import '../widgets/filter_bar.dart';
import '../widgets/records_table.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Row(
          children: const [
            SideBar(),
            Expanded(
              child: Column(
                children: [
                  HeaderBar(),
                  FilterBar(),
                  Expanded(child: RecordsTable()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
