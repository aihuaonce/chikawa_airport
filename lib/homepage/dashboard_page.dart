import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/dashboard_view_model.dart';
import 'widgets/header_bar.dart';
import 'widgets/records_table.dart';
import 'widgets/sidebar.dart';

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
      body: Row(
        children: [
          Sidebar(
            currentPage: viewModel.currentFilter,
            onPageChanged: (page) {
              viewModel.setFilter(page);
            },
          ),
          Expanded(
            child: Column(
              children: [
                HeaderBar(currentPage: viewModel.currentFilter),
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
    );
  }
}
