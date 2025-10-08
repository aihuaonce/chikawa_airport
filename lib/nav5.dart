import 'package:chikawa_airport/providers/ambulance_routes_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import 'dart:convert';

// 引入您的檔案
import 'nav3.dart';

import 'data/db/daos.dart';
import 'data/db/app_database.dart';

mixin SavableStateMixin<T extends StatefulWidget> on State<T> {
  Future<void> saveData();
}

// ===================================================================
// 1. 資料狀態管理器 (AmbulanceDataProvider) - (此部分不變)
// ===================================================================
class AmbulanceDataProvider extends ChangeNotifier {
  // ... (保持原有的 AmbulanceDataProvider 內容) ...
  final AmbulanceRecordsDao _ambulanceRecordsDao;
  final PatientProfilesDao _patientProfilesDao;
  final MedicationRecordsDao _medicationRecordsDao;
  final VitalSignsRecordsDao _vitalSignsRecordsDao;
  final ParamedicRecordsDao _paramedicRecordsDao;

  final int visitId;

  late AmbulanceRecordsCompanion _ambulanceRecordData;
  late PatientProfilesCompanion _patientProfileData;
  List<MedicationRecord> _medicationRecords = [];
  List<VitalSignsRecord> _vitalSignsRecords = [];
  List<ParamedicRecord> _paramedicRecords = [];

  bool _isLoading = true;

  AmbulanceRecordsCompanion get ambulanceRecordData => _ambulanceRecordData;
  PatientProfilesCompanion get patientProfileData => _patientProfileData;
  List<MedicationRecord> get medicationRecords => _medicationRecords;
  List<VitalSignsRecord> get vitalSignsRecords => _vitalSignsRecords;
  List<ParamedicRecord> get paramedicRecords => _paramedicRecords;
  bool get isLoading => _isLoading;

  AmbulanceDataProvider({
    required this.visitId,
    required AmbulanceRecordsDao ambulanceRecordsDao,
    required PatientProfilesDao patientProfilesDao,
    required MedicationRecordsDao medicationRecordsDao,
    required VitalSignsRecordsDao vitalSignsRecordsDao,
    required ParamedicRecordsDao paramedicRecordsDao,
  }) : _ambulanceRecordsDao = ambulanceRecordsDao,
       _patientProfilesDao = patientProfilesDao,
       _medicationRecordsDao = medicationRecordsDao,
       _vitalSignsRecordsDao = vitalSignsRecordsDao,
       _paramedicRecordsDao = paramedicRecordsDao {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    await Future.wait([
      _ambulanceRecordsDao
          .getByVisitId(visitId)
          .then(
            (record) => _ambulanceRecordData =
                record?.toCompanion(true) ??
                AmbulanceRecordsCompanion(visitId: Value(visitId)),
          ),
      _patientProfilesDao
          .getByVisitId(visitId)
          .then(
            (profile) => _patientProfileData =
                profile?.toCompanion(true) ??
                PatientProfilesCompanion(visitId: Value(visitId)),
          ),
      _medicationRecordsDao
          .watchRecordsForVisit(visitId)
          .first
          .then((records) => _medicationRecords = records),
      _vitalSignsRecordsDao
          .watchRecordsForVisit(visitId)
          .first
          .then((records) => _vitalSignsRecords = records),
      _paramedicRecordsDao
          .watchRecordsForVisit(visitId)
          .first
          .then((records) => _paramedicRecords = records),
    ]);
    _isLoading = false;
    notifyListeners();
  }

  void updateAmbulanceRecord(AmbulanceRecordsCompanion newData) {
    _ambulanceRecordData = newData;
    notifyListeners();
  }

  void updatePatientProfile(PatientProfilesCompanion newData) {
    _patientProfileData = newData;
    notifyListeners();
  }

  void updateJsonSet(String fieldName, String key, bool isChecked) {
    String? jsonString;
    switch (fieldName) {
      case 'traumaClassJson':
        jsonString = _ambulanceRecordData.traumaClassJson.value;
        break;
      // ... 其他 case ...
    }

    final currentSet = jsonString != null
        ? List<String>.from(jsonDecode(jsonString)).toSet()
        : <String>{};
    if (isChecked) {
      currentSet.add(key);
    } else {
      currentSet.remove(key);
    }
    final newJsonString = jsonEncode(currentSet.toList());

    var updated = _ambulanceRecordData;
    switch (fieldName) {
      case 'traumaClassJson':
        updated = updated.copyWith(traumaClassJson: Value(newJsonString));
        break;
      // ... 其他 case ...
    }
    _ambulanceRecordData = updated;
    notifyListeners();
  }

  Future<void> addMedicationRecord(MedicationRecordsCompanion entry) async {
    await _medicationRecordsDao.addRecord(entry);
    _medicationRecords = await _medicationRecordsDao
        .watchRecordsForVisit(visitId)
        .first;
    notifyListeners();
  }

  Future<void> deleteMedicationRecord(int id) async {
    await _medicationRecordsDao.deleteRecord(id);
    _medicationRecords = await _medicationRecordsDao
        .watchRecordsForVisit(visitId)
        .first;
    notifyListeners();
  }

  Future<void> addVitalSignsRecord(VitalSignsRecordsCompanion entry) async {
    await _vitalSignsRecordsDao.addRecord(entry);
    _vitalSignsRecords = await _vitalSignsRecordsDao
        .watchRecordsForVisit(visitId)
        .first;
    notifyListeners();
  }

  Future<void> deleteVitalSignsRecord(int id) async {
    await _vitalSignsRecordsDao.deleteRecord(id);
    _vitalSignsRecords = await _vitalSignsRecordsDao
        .watchRecordsForVisit(visitId)
        .first;
    notifyListeners();
  }

  Future<void> addParamedicRecord(ParamedicRecordsCompanion entry) async {
    await _paramedicRecordsDao.addRecord(entry);
    _paramedicRecords = await _paramedicRecordsDao
        .watchRecordsForVisit(visitId)
        .first;
    notifyListeners();
  }

  Future<void> deleteParamedicRecord(int id) async {
    await _paramedicRecordsDao.deleteRecord(id);
    _paramedicRecords = await _paramedicRecordsDao
        .watchRecordsForVisit(visitId)
        .first;
    notifyListeners();
  }

  Future<void> saveChanges() async {
    await Future.wait([
      _ambulanceRecordsDao.updateAmbulanceRecord(_ambulanceRecordData),
      _patientProfilesDao.updatePatientProfile(_patientProfileData),
    ]);
  }
}

// ===================================================================
// 2. UI 狀態管理器 (AmbulanceNavigationProvider) - (不變)
// ===================================================================
class AmbulanceNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
}

// ===================================================================
// 3. 頁面主體 (Nav5Page Widget) - (不變)
// ===================================================================
class Nav5Page extends StatelessWidget {
  final int visitId;
  const Nav5Page({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AmbulanceNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AmbulanceDataProvider(
            visitId: visitId,
            ambulanceRecordsDao: context.read<AmbulanceRecordsDao>(),
            patientProfilesDao: context.read<PatientProfilesDao>(),
            medicationRecordsDao: context.read<MedicationRecordsDao>(),
            vitalSignsRecordsDao: context.read<VitalSignsRecordsDao>(),
            paramedicRecordsDao: context.read<ParamedicRecordsDao>(),
          ),
        ),
      ],
      child: AmbulanceMainLayout(visitId: visitId),
    );
  }
}

// ===================================================================
// 4. 頁面佈局 (AmbulanceMainLayout) - ✅ **使用配置檔案**
// ===================================================================
// 4. 頁面佈局 (AmbulanceMainLayout) - ✅ **修正**
// ===================================================================
class AmbulanceMainLayout extends StatefulWidget {
  final int visitId;
  const AmbulanceMainLayout({super.key, required this.visitId});

  @override
  State<AmbulanceMainLayout> createState() => _AmbulanceMainLayoutState();
}

class _AmbulanceMainLayoutState extends State<AmbulanceMainLayout> {
  late final List<Widget> _pages;
  late final List<GlobalKey<SavableStateMixin>> _pageKeys;

  @override
  void initState() {
    super.initState();

    // ✅ 修正點 1: 必須在使用 _pageKeys 之前先初始化它
    _pageKeys = ambulanceRouteItems
        .map((_) => GlobalKey<SavableStateMixin>())
        .toList();

    // ✅ 修正點 2: 現在可以安全地使用 _pageKeys 來建立頁面
    _pages = List.generate(ambulanceRouteItems.length, (index) {
      return ambulanceRouteItems[index].builder(
        widget.visitId,
        _pageKeys[index], // 將對應的 key 傳給 builder
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AmbulanceNavigationProvider>();
    final dataProvider = context.watch<AmbulanceDataProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
      body: SafeArea(
        child: Column(
          children: [
            // 將 keys 列表傳遞給 NavBar
            AmbulanceNavBar(pageKeys: _pageKeys), // 這行是正確的
            const Divider(height: 1),
            Expanded(
              child: dataProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Nav3Section(),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: IndexedStack(
                            index: navProvider.selectedIndex,
                            children: _pages,
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

// ===================================================================
// 5. 頂部導航欄 (AmbulanceNavBar) - ✅ **修正**
// ===================================================================
class AmbulanceNavBar extends StatefulWidget {
  // ✅ 修正點 3: 將 pageKeys 宣告為一個 final 成員變數
  final List<GlobalKey<SavableStateMixin>> pageKeys;

  const AmbulanceNavBar({
    super.key,
    required this.pageKeys, // 使用 this.pageKeys 將傳入的參數賦值給成員變數
  });

  @override
  State<AmbulanceNavBar> createState() => _AmbulanceNavBarState();
}

class _AmbulanceNavBarState extends State<AmbulanceNavBar> {
  bool _isSaving = false;

  // ✅ 修正點 4: **【核心】** 完全替換成新的儲存邏輯
  Future<void> _saveAllData() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      // 獲取 Provider 和當前分頁的索引
      final navProvider = context.read<AmbulanceNavigationProvider>();
      final dataProvider = context.read<AmbulanceDataProvider>();
      final currentIndex = navProvider.selectedIndex;

      // 1. 透過 widget.pageKeys 獲取當前分頁的 GlobalKey
      final currentKey = widget.pageKeys[currentIndex];

      // 2. 【關鍵步驟】呼叫當前分頁的 saveData 方法，將 UI 上的資料同步到 Provider
      await currentKey.currentState?.saveData();

      // 3. 呼叫 Provider 的方法，將所有資料（現在已是最新）寫入資料庫
      await dataProvider.saveChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('所有分頁的資料已儲存成功！'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // 4. 【新增】儲存成功後，返回上一頁
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('儲存失敗: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // build 方法的內容完全正確，無需修改
    final List<String> items = ambulanceRouteItems.map((e) => e.label).toList();
    final navProvider = context.watch<AmbulanceNavigationProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  items.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i],
                      active: i == navProvider.selectedIndex,
                      onTap: () => context
                          .read<AmbulanceNavigationProvider>()
                          .setSelectedIndex(i),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: _isSaving ? '儲存中...' : '儲存所有資料',
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Color(0xFF27AE60)),
                    ),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveAllData,
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// 6. 輔助 Widget (_PillButton) - (不變)
// ===================================================================
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
    const lightColor = Color(0xFF83ACA9);
    const darkColor = Color(0xFF274C4A);
    final bg = active ? darkColor : lightColor;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
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
