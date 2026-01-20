import 'package:flutter/material.dart';

import 'widgets/sidebar.dart';
import 'widgets/header_bar.dart';
import 'widgets/filter_bar.dart';
import 'widgets/records_table.dart';
import '../data/models/record_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  RecordPage _currentPage = RecordPage.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Row(
          children: [
            // ===== 左側欄 =====
            Sidebar(
              currentPage: _currentPage,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),

            // ===== 右側內容 =====
            Expanded(
              child: Column(
                children: [
                  HeaderBar(currentPage: _currentPage),
                  const FilterBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildContent(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentPage) {
      case RecordPage.primary:
        return const RecordsTable();
      case RecordPage.ambulance:
        return const RecordsTable();
      case RecordPage.firstAid:
        return const RecordsTable();
    }
  }
}
