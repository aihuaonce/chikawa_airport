import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/sidebar.dart';
import 'widgets/header_bar.dart';
import 'widgets/filter_bar.dart';
import 'widgets/records_table.dart';
import '../data/models/dashboard_view_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardViewModel(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Row(
          children: [
            //  左側欄
            Sidebar(
              currentPage: viewModel.currentFilter,
              onPageChanged: (page) {
                viewModel.setFilter(page);
              },
            ),

            //  右側內容
            Expanded(
              child: Column(
                children: [
                  HeaderBar(currentPage: viewModel.currentFilter),
                  const FilterBar(),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: RecordsTable(),
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
}
