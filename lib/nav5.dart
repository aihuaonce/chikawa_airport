import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import 'dart:convert';

// 引入您的檔案
import 'nav3.dart';
import 'Ambulance_Information.dart';
import 'Ambulance_Personal.dart';
import 'Ambulance_Situation.dart';
import 'Ambulance_Plan.dart';
import 'Ambulance_Expenses.dart';
import 'data/db/daos.dart';
import 'data/db/app_database.dart';

// ===================================================================
// 1. 資料狀態管理器 (Data Provider) - 擴充後
// ===================================================================
class AmbulanceDataProvider extends ChangeNotifier {
  // --- 所有需要的 DAO ---
  final AmbulanceRecordsDao _ambulanceRecordsDao;
  final PatientProfilesDao _patientProfilesDao;
  final MedicationRecordsDao _medicationRecordsDao;
  final VitalSignsRecordsDao _vitalSignsRecordsDao;
  final ParamedicRecordsDao _paramedicRecordsDao;

  final int visitId;

  // --- 用於在記憶體中暫存正在編輯的資料 ---
  late AmbulanceRecordsCompanion _ambulanceRecordData;
  late PatientProfilesCompanion _patientProfileData;

  // 處理一對多關係的列表
  List<MedicationRecord> _medicationRecords = [];
  List<VitalSignsRecord> _vitalSignsRecords = [];
  List<ParamedicRecord> _paramedicRecords = [];

  bool _isLoading = true;

  // --- Public Getters: 讓 UI 可以安全地讀取資料 ---
  AmbulanceRecordsCompanion get ambulanceRecordData => _ambulanceRecordData;
  PatientProfilesCompanion get patientProfileData => _patientProfileData;
  List<MedicationRecord> get medicationRecords => _medicationRecords;
  List<VitalSignsRecord> get vitalSignsRecords => _vitalSignsRecords;
  List<ParamedicRecord> get paramedicRecords => _paramedicRecords;
  bool get isLoading => _isLoading;

  // --- 建構子: 接收 visitId 和所有需要的 DAO ---
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

  // --- 從資料庫非同步載入所有相關資料 ---
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      _ambulanceRecordsDao.getByVisitId(visitId).then((record) {
        _ambulanceRecordData =
            record?.toCompanion(true) ??
            AmbulanceRecordsCompanion(visitId: Value(visitId));
      }),
      _patientProfilesDao.getByVisitId(visitId).then((profile) {
        _patientProfileData =
            profile?.toCompanion(true) ??
            PatientProfilesCompanion(visitId: Value(visitId));
      }),
      // 使用 .first 來從 Stream 中獲取一次性的 List<Data>
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

  // --- 更新方法 ---
  void updateAmbulanceRecord(AmbulanceRecordsCompanion newData) {
    _ambulanceRecordData = newData;
    notifyListeners();
  }

  void updatePatientProfile(PatientProfilesCompanion newData) {
    _patientProfileData = newData;
    notifyListeners();
  }

  // --- 輔助方法: 更新儲存在 JSON 中的 Map<String, bool> ---
  // --- 改良版：自動判斷 JSON 結構（List<String> 或 Map<String,bool>）---
  void updateJsonSet(String fieldName, String key, bool isChecked) {
    // 1) 根據欄位名稱，取出目前的 JSON 字串
    String? jsonString;
    switch (fieldName) {
      case 'traumaClassJson':
        jsonString = ambulanceRecordData.traumaClassJson.value;
        break;
      case 'nonTraumaTypeJson':
        jsonString = ambulanceRecordData.nonTraumaTypeJson.value;
        break;
      case 'emergencyTreatmentsJson':
        jsonString = ambulanceRecordData.emergencyTreatmentsJson.value;
        break;
      case 'airwayTreatmentsJson':
        jsonString = ambulanceRecordData.airwayTreatmentsJson.value;
        break;
      case 'traumaTreatmentsJson':
        jsonString = ambulanceRecordData.traumaTreatmentsJson.value;
        break;
      case 'transportMethodsJson':
        jsonString = ambulanceRecordData.transportMethodsJson.value;
        break;
      case 'cprMethodsJson':
        jsonString = ambulanceRecordData.cprMethodsJson.value;
        break;
      case 'medicationProceduresJson':
        jsonString = ambulanceRecordData.medicationProceduresJson.value;
        break;
      case 'otherEmergencyProceduresJson':
        jsonString = ambulanceRecordData.otherEmergencyProceduresJson.value;
        break;
      default:
        return;
    }

    // 2) 嘗試解析成 List 或 Map
    dynamic decoded;
    try {
      decoded = jsonString != null && jsonString.isNotEmpty
          ? jsonDecode(jsonString)
          : null;
    } catch (_) {
      decoded = null;
    }

    String newJsonString;

    if (decoded is List) {
      // --- ✅ List<String> 結構 ---
      final currentSet = decoded.map((e) => e.toString()).toSet();
      if (isChecked) {
        currentSet.add(key);
      } else {
        currentSet.remove(key);
      }
      newJsonString = jsonEncode(currentSet.toList());
    } else {
      // --- ✅ Map<String,bool> 結構 ---
      final currentMap = decoded is Map<String, dynamic>
          ? decoded.map((k, v) => MapEntry(k, v == true))
          : <String, bool>{};
      currentMap[key] = isChecked;
      newJsonString = jsonEncode(currentMap);
    }

    // 3) 更新對應的 companion 欄位
    var updated = _ambulanceRecordData;
    switch (fieldName) {
      case 'traumaClassJson':
        updated = updated.copyWith(traumaClassJson: Value(newJsonString));
        break;
      case 'nonTraumaTypeJson':
        updated = updated.copyWith(nonTraumaTypeJson: Value(newJsonString));
        break;
      case 'emergencyTreatmentsJson':
        updated = updated.copyWith(
          emergencyTreatmentsJson: Value(newJsonString),
        );
        break;
      case 'airwayTreatmentsJson':
        updated = updated.copyWith(airwayTreatmentsJson: Value(newJsonString));
        break;
      case 'traumaTreatmentsJson':
        updated = updated.copyWith(traumaTreatmentsJson: Value(newJsonString));
        break;
      case 'transportMethodsJson':
        updated = updated.copyWith(transportMethodsJson: Value(newJsonString));
        break;
      case 'cprMethodsJson':
        updated = updated.copyWith(cprMethodsJson: Value(newJsonString));
        break;
      case 'medicationProceduresJson':
        updated = updated.copyWith(
          medicationProceduresJson: Value(newJsonString),
        );
        break;
      case 'otherEmergencyProceduresJson':
        updated = updated.copyWith(
          otherEmergencyProceduresJson: Value(newJsonString),
        );
        break;
    }

    // 4) 回寫並通知 UI
    _ambulanceRecordData = updated;
    notifyListeners();
  }

  // --- 管理多筆紀錄的方法 ---
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

  // 在 AmbulanceDataProvider 類別中新增：
  Future<void> addVitalSignsRecord(VitalSignsRecordsCompanion entry) async {
    await _vitalSignsRecordsDao.addRecord(entry);
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

  // TODO: 為 VitalSigns 和 Paramedic 加入 add/delete 方法

  // --- 統一儲存 ---
  Future<void> saveChanges() async {
    await Future.wait([
      _ambulanceRecordsDao.updateAmbulanceRecord(_ambulanceRecordData),
      _patientProfilesDao.updatePatientProfile(_patientProfileData),
      // 注意：一對多關係的列表通常在 add/delete 時就已即時儲存，
      // 但保留這個位置以防未來有需要批次更新的邏輯。
    ]);
  }
}

// ===================================================================
// 2. UI 狀態管理器 (Navigation Provider) - 維持不變
// ===================================================================
class AmbulanceNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

// ===================================================================
// 3. 頁面主體 (Nav5Page Widget) - 修改後
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
// 4. 頁面佈局 (AmbulanceMainLayout) - 維持不變
// ===================================================================
class AmbulanceMainLayout extends StatelessWidget {
  final int visitId;
  const AmbulanceMainLayout({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AmbulanceNavigationProvider>();
    final dataProvider = context.watch<AmbulanceDataProvider>();

    Widget currentPage;
    switch (navProvider.selectedIndex) {
      case 0:
        currentPage = AmbulanceInformationPage(visitId: visitId);
        break;
      case 1:
        currentPage = AmbulancePersonalPage(visitId: visitId);
        break;
      case 2:
        currentPage = AmbulanceSituationPage(visitId: visitId);
        break;
      case 3:
        currentPage = AmbulancePlanPage(visitId: visitId);
        break;
      case 4:
        currentPage = AmbulanceExpensesPage(visitId: visitId);
        break;
      default:
        currentPage = AmbulanceInformationPage(visitId: visitId);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
      body: SafeArea(
        child: Column(
          children: [
            const AmbulanceNavBar(),
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
                          child: SingleChildScrollView(child: currentPage),
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
// 5. 頂部導航欄 (AmbulanceNavBar) - 維持不變
// ===================================================================
class AmbulanceNavBar extends StatelessWidget {
  const AmbulanceNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = const ['派遣資料', '病患資料', '現場狀況', '處置項目', '收取費用'];

    return Consumer<AmbulanceNavigationProvider>(
      builder: (context, ambulanceProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6ABAD5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('返回'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(items.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _PillButton(
                          label: items[i],
                          active: i == ambulanceProvider.selectedIndex,
                          onTap: () => ambulanceProvider.setSelectedIndex(i),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, size: 18),
                label: const Text('儲存'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  try {
                    await context.read<AmbulanceDataProvider>().saveChanges();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('所有分頁的資料已儲存成功！'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('儲存失敗: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('呼叫救護車功能')));
                },
                child: const Text('呼叫救護車'),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF83ACA9),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===================================================================
// 6. 輔助 Widget (_PillButton) - 已修正
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
    const _light = Color(0xFF83ACA9);
    const _dark = Color(0xFF274C4A);
    final bg = active ? _dark : _light;
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
          // 【修正】讓按鈕可以顯示文字
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
