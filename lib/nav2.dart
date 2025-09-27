import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/patient_data.dart';
import 'data/db/daos.dart';
import 'routes_config.dart';
import 'widgets/nav_common.dart';

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

  Future<void> _saveAllPages() async {
    final patientData = context.read<PatientData>();
    final patientDao = context.read<PatientProfilesDao>();
    final visitsDao = context.read<VisitsDao>();

    // 遍歷所有頁面 key 並儲存每個 SavablePage 的資料
    for (int i = 0; i < routeItems.length; i++) {
      final key = _pageKeys[i]!;
      if (key.currentState is SavablePage) {
        await (key.currentState as SavablePage).saveData();
      }
    }

    // 儲存 PersonalInformationPage 的 base64 照片
    final String? base64Photo = patientData.photoBase64;

    // 寫入 PatientProfiles
    await patientDao.upsertByVisitId(
      visitId: widget.visitId,
      birthday: patientData.birthday,
      gender: patientData.gender,
      reason: patientData.reason,
      nationality: patientData.nationality,
      idNumber: patientData.idNumber,
      address: patientData.address,
      phone: patientData.phone,
      photoPath: base64Photo,
    );

    // 同步回 Visits 主檔
    await visitsDao.updateVisitSummary(
      widget.visitId,
      gender: patientData.gender,
      nationality: patientData.nationality,
      note: patientData.note,
    );

    // 儲存完畢後清空 PatientData，為下一筆新增資料做準備
    patientData.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = routeItems[currentIndex].builder(
      widget.visitId,
      _pageKeys[currentIndex]!,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // 導航列
            Row(
              children: [
                // 左側導航按鈕
                Row(
                  children: routeItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: NavPillButton(
                        label: item.label,
                        active: currentIndex == index,
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                // 右側儲存按鈕
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    await _saveAllPages();
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('所有頁面資料已儲存')));
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 頁面內容
            Expanded(child: currentPage),
          ],
        ),
      ),
    );
  }
}
