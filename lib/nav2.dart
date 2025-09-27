import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes_config.dart';
import 'data/models/patient_data.dart';
import 'data/db/daos.dart';

abstract class SavablePage {
  Future<void> saveData();
}

class Nav2Page extends StatefulWidget {
  final int visitId;
  final int initialIndex;

  const Nav2Page({super.key, required this.visitId, this.initialIndex = 0});

  @override
  State<Nav2Page> createState() => _Nav2PageState();
}

class _Nav2PageState extends State<Nav2Page> {
  late int currentIndex;
  final Map<int, GlobalKey> _pageKeys = {};

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    for (int i = 0; i < routeItems.length; i++) {
      _pageKeys[i] = GlobalKey();
    }
  }

  SavablePage? get _currentSavablePage {
    final currentWidget = routeItems[currentIndex].builder(
      widget.visitId,
      _pageKeys[currentIndex]!,
    );
    return currentWidget is SavablePage ? currentWidget as SavablePage : null;
  }

  Future<void> _saveAllPages() async {
    final patientData = context.read<PatientData>();
    final patientDao = context.read<PatientProfilesDao>();
    final visitsDao = context.read<VisitsDao>();

    // 遍歷所有頁面 key
    for (int i = 0; i < routeItems.length; i++) {
      final key = _pageKeys[i]!;
      if (key.currentState is SavablePage) {
        await (key.currentState as SavablePage).saveData();
      }
    }

    // 同步回 Visits 主檔（主要是 note）
    await visitsDao.updateVisitSummary(
      widget.visitId,
      gender: patientData.gender,
      nationality: patientData.nationality,
      note: patientData.note,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = routeItems[currentIndex].builder(
      widget.visitId,
      _pageKeys[currentIndex]!,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(routeItems[currentIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _saveAllPages();
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('所有頁面資料已儲存')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: routeItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      routeItems[index].label,
                      style: TextStyle(
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: currentPage),
        ],
      ),
    );
  }
}
