import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../widgets/ambulance_medication_dialog.dart';
import '../widgets/ambulance_vital_sign_dialog.dart';
import '../widgets/ambulance_staff_dialog.dart';
import '../widgets/ambulance_treatment_item_dialog.dart';

class AmbulanceTreatmentItems extends StatefulWidget {
  final int medicalId;
  const AmbulanceTreatmentItems({super.key, required this.medicalId});

  @override
  State<AmbulanceTreatmentItems> createState() =>
      _AmbulanceTreatmentItemsState();
}

class _AmbulanceTreatmentItemsState extends State<AmbulanceTreatmentItems> {
  // --- 1. 顏色與樣式定義 ---
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);
  static const Color headerBg = Color(0xFFF8FAFC);

  // --- 2. 狀態變數 ---
  bool _isInitialized = false;
  int? _recordId;

  // Reference Data
  List<AmbulanceTreatmentCategoryData> _categories = [];
  final Map<int, List<AmbulanceTreatmentItemData>> _itemsByCategory = {};

  // Selections
  final List<int> _selectedCategoryIds = [];
  final List<int> _selectedItemIds = [];

  // Dynamic Item Details (keyed by Item ID)
  // Stores tubeSize, fixationDepth, shockCount, shockJoules, otherDescription
  final Map<int, Map<String, dynamic>> _itemDetails = {};

  // Form Fields
  final TextEditingController _doctorInstructionsController =
      TextEditingController();
  final TextEditingController _receivingHospitalController =
      TextEditingController();
  final TextEditingController _receivingTimeController = TextEditingController(
    text: '-- : -- : --',
  );
  bool _isRefused = false;
  String _relationship = '病患 Patient';
  final TextEditingController _relativeNameController = TextEditingController();
  final TextEditingController _relativePhoneController =
      TextEditingController();

  // Lists (Synced with DB)
  List<AmbulanceMedicationLogData> _medicationList = [];
  List<AmbulanceVitalSignData> _vitalSignsList = [];
  List<AmbulanceEscortStaffData> _escortStaffList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _doctorInstructionsController.dispose();
    _receivingHospitalController.dispose();
    _receivingTimeController.dispose();
    _relativeNameController.dispose();
    _relativePhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;

    // 1. Initialize & Fetch References
    await dao.initializeTreatmentData();
    _categories = await dao.getCategories();
    for (var cat in _categories) {
      _itemsByCategory[cat.id] = await dao.getItemsByCategory(cat.id);
    }

    // 2. Fetch Record
    var record = await dao.getRecord(widget.medicalId);
    if (record == null) {
      // Create default record if not exists
      await dao.updateRecord(
        AmbulanceTreatmentRecordsCompanion(
          medicalId: drift.Value(widget.medicalId),
        ),
      );
      record = await dao.getRecord(widget.medicalId);
    }

    if (record != null) {
      _recordId = record.id;
      _doctorInstructionsController.text = record.doctorInstructions ?? '';
      _receivingHospitalController.text = record.receivingHospital ?? '';
      _receivingTimeController.text = record.receivingTime ?? '-- : -- : --';
      _isRefused = record.isRefusedHospital;
      _relationship = record.relationship;
      _relativeNameController.text = record.relativeName ?? '';
      _relativePhoneController.text = record.relativePhone ?? '';

      // 3. Fetch Items & Details
      final joinedItems = await dao.getJoinedRecordItems(record.id);
      _selectedItemIds.clear();
      _selectedCategoryIds.clear();
      _itemDetails.clear();

      for (var joined in joinedItems) {
        _selectedItemIds.add(joined.item.id);
        if (!_selectedCategoryIds.contains(joined.item.categoryId)) {
          _selectedCategoryIds.add(joined.item.categoryId);
        }

        // Populate details
        _itemDetails[joined.item.id] = {
          'tubeSize': joined.link.tubeSize,
          'fixationDepth': joined.link.fixationDepth,
          'shockCount': joined.link.shockCount,
          'shockJoules': joined.link.shockJoules,
          'otherDescription': joined.link.otherDescription,
        };
      }

      // 4. Fetch Sub-tables
      _medicationList = await dao.getMedicationLogs(record.id);
      _vitalSignsList = await dao.getVitalSigns(record.id);
      _escortStaffList = await dao.getEscortStaff(record.id);
    }

    setState(() {
      _isInitialized = true;
    });
  }

  // --- Auto-Save Methods ---

  Future<void> _updateRecord({
    drift.Value<String?>? doctorInstructions,
    drift.Value<String?>? receivingHospital,
    drift.Value<String?>? receivingTime,
    drift.Value<bool>? isRefusedHospital,
    drift.Value<String>? relationship,
    drift.Value<String?>? relativeName,
    drift.Value<String?>? relativePhone,
  }) async {
    if (_recordId == null) return;
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;

    await dao.updateRecord(
      AmbulanceTreatmentRecordsCompanion(
        medicalId: drift.Value(widget.medicalId),
        doctorInstructions: doctorInstructions ?? const drift.Value.absent(),
        receivingHospital: receivingHospital ?? const drift.Value.absent(),
        receivingTime: receivingTime ?? const drift.Value.absent(),
        isRefusedHospital: isRefusedHospital ?? const drift.Value.absent(),
        relationship: relationship ?? const drift.Value.absent(),
        relativeName: relativeName ?? const drift.Value.absent(),
        relativePhone: relativePhone ?? const drift.Value.absent(),
      ),
    );
  }

  bool _hasDetails(AmbulanceTreatmentItemData item) {
    return item.name == '氣管內管' || item.name == '手動電擊器' || item.isOther;
  }

  Future<void> _editItemDetails(
    int itemId,
    AmbulanceTreatmentItemData item,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => AmbulanceTreatmentItemDialog(
            itemName: item.name,
            isOther: item.isOther,
            initialDetails: _itemDetails[itemId] ?? {},
          ),
    );

    if (result != null) {
      await _updateItemDetails(
        itemId,
        tubeSize: result['tubeSize'],
        fixationDepth: result['fixationDepth'],
        shockCount: result['shockCount'],
        shockJoules: result['shockJoules'],
        otherDescription: result['otherDescription'],
      );
      setState(() {}); // Refresh UI to show new details in list
    }
  }

  Future<void> _toggleItem(int catId, int itemId, bool selected) async {
    if (_recordId == null) return;
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;

    // Find the item data
    final item = _itemsByCategory[catId]?.firstWhere((i) => i.id == itemId);
    if (item == null) return;

    if (selected) {
      // Check if details required
      if (_hasDetails(item)) {
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder:
              (context) => AmbulanceTreatmentItemDialog(
                itemName: item.name,
                isOther: item.isOther,
                initialDetails: _itemDetails[itemId] ?? {},
              ),
        );

        if (result == null) return; // Cancelled

        setState(() {
          _selectedItemIds.add(itemId);
        });

        await _updateItemDetails(
          itemId,
          tubeSize: result['tubeSize'],
          fixationDepth: result['fixationDepth'],
          shockCount: result['shockCount'],
          shockJoules: result['shockJoules'],
          otherDescription: result['otherDescription'],
        );
        return;
      }

      setState(() {
        _selectedItemIds.add(itemId);
      });

      await dao.addOrUpdateItemLink(
        AmbulanceTreatmentRecordItemsCompanion(
          recordId: drift.Value(_recordId!),
          itemId: drift.Value(itemId),
        ),
      );
    } else {
      setState(() {
        _selectedItemIds.remove(itemId);
      });
      await dao.removeItemLink(_recordId!, itemId);
      _itemDetails.remove(itemId); // Clear local details
    }
  }

  Future<void> _updateItemDetails(
    int itemId, {
    String? tubeSize,
    String? fixationDepth,
    String? shockCount,
    String? shockJoules,
    String? otherDescription,
  }) async {
    if (_recordId == null) return;
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;

    // Update local state
    if (!_itemDetails.containsKey(itemId)) _itemDetails[itemId] = {};
    if (tubeSize != null) _itemDetails[itemId]!['tubeSize'] = tubeSize;
    if (fixationDepth != null) {
      _itemDetails[itemId]!['fixationDepth'] = fixationDepth;
    }
    if (shockCount != null) _itemDetails[itemId]!['shockCount'] = shockCount;
    if (shockJoules != null) _itemDetails[itemId]!['shockJoules'] = shockJoules;
    if (otherDescription != null) {
      _itemDetails[itemId]!['otherDescription'] = otherDescription;
    }

    // Save to DB
    await dao.addOrUpdateItemLink(
      AmbulanceTreatmentRecordItemsCompanion(
        recordId: drift.Value(_recordId!),
        itemId: drift.Value(itemId),
        tubeSize: tubeSize != null
            ? drift.Value(tubeSize)
            : const drift.Value.absent(),
        fixationDepth: fixationDepth != null
            ? drift.Value(fixationDepth)
            : const drift.Value.absent(),
        shockCount: shockCount != null
            ? drift.Value(shockCount)
            : const drift.Value.absent(),
        shockJoules: shockJoules != null
            ? drift.Value(shockJoules)
            : const drift.Value.absent(),
        otherDescription: otherDescription != null
            ? drift.Value(otherDescription)
            : const drift.Value.absent(),
      ),
    );
  }

  // --- Sub-table Methods ---

  Future<void> _addMedicationLog() async {
    if (_recordId == null) return;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AmbulanceMedicationDialog(recordId: _recordId!),
    );
    if (result == true) {
      _loadData();
    }
  }

  Future<void> _removeMedicationLog(int id) async {
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;
    await dao.deleteMedicationLog(id);
    if (_recordId != null) {
      _medicationList = await dao.getMedicationLogs(_recordId!);
      setState(() {});
    }
  }

  Future<void> _addVitalSign() async {
    if (_recordId == null) return;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AmbulanceVitalSignDialog(recordId: _recordId!),
    );
    if (result == true) {
      _loadData();
    }
  }

  Future<void> _removeVitalSign(int id) async {
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;
    await dao.deleteVitalSign(id);
    if (_recordId != null) {
      _vitalSignsList = await dao.getVitalSigns(_recordId!);
      setState(() {});
    }
  }

  Future<void> _addEscortStaff() async {
    if (_recordId == null) return;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AmbulanceStaffDialog(recordId: _recordId!),
    );
    if (result == true) {
      _loadData();
    }
  }

  Future<void> _removeEscortStaff(int id) async {
    final dao = context.read<AppDatabase>().ambulanceTreatmentDao;
    await dao.deleteEscortStaff(id);
    if (_recordId != null) {
      _escortStaffList = await dao.getEscortStaff(_recordId!);
      setState(() {});
    }
  }

  // 計算單一列的 GCS 總分
  String _calculateGcsTotal(AmbulanceVitalSignData data) {
    int e = int.tryParse(data.gcsE ?? '0') ?? 0;
    int v = int.tryParse(data.gcsV ?? '0') ?? 0;
    int m = int.tryParse(data.gcsM ?? '0') ?? 0;
    if (e == 0 && v == 0 && m == 0) return '--';
    return (e + v + m).toString();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('急救處置大類 EMERGENCY CATEGORIES'),
        const SizedBox(height: 10),
        _buildMainCategoryGrid(),
        if (_selectedCategoryIds.isNotEmpty) _buildDynamicSubActionSections(),
        const SizedBox(height: 24),
        _buildFieldWrapper(
          '線上指導醫師指導說明 DOCTOR\'S INSTRUCTIONS',
          _buildTextField(
            controller: _doctorInstructionsController,
            hint: '請輸入醫師指示內容...',
            maxLines: 2,
            onChanged: (v) => _updateRecord(doctorInstructions: drift.Value(v)),
          ),
        ),
        const SizedBox(height: 32),

        // 4. 藥物記錄表
        _buildTableContainer(
          title: '藥物記錄表 MEDICATION LOG',
          buttonLabel: '新增藥物 Add',
          onAdd: _addMedicationLog,
          child: _buildMedicationTable(),
        ),
        const SizedBox(height: 32),

        // 5. 生命徵象記錄表 (含 EVM 自動計算)
        _buildTableContainer(
          title: '生命徵象記錄表 VITAL SIGNS LOG',
          buttonLabel: '新增記錄 Add',
          onAdd: _addVitalSign,
          child: _buildVitalSignsTable(),
        ),
        const SizedBox(height: 32),

        // 6. 隨車人員表
        _buildTableContainer(
          title: '隨車人員表 ESCORT STAFF',
          buttonLabel: '新增人員 Add',
          onAdd: _addEscortStaff,
          child: _buildEscortStaffTable(),
        ),
        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),
        _buildBottomInfoSection(),
        const SizedBox(height: 80),
      ],
    );
  }

  // 4. 表格實作

  Widget _buildVitalSignsTable() {
    // 欄位比例分配 (總計 23)
    final flexes = [3, 1, 2, 1, 1, 1, 2, 2, 2, 2, 3, 2, 1];
    final labels = [
      '時間',
      '到院',
      'AVPU',
      'E',
      'V',
      'M',
      'GCS',
      '體溫(°C)',
      '脈搏(次/min)',
      '呼吸(次/min)',
      '血壓(mmHg)',
      '血氧(%)',
      '',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SizedBox(
              width: 1100,
              child: Column(
                children: [
                  _buildTableHeaderRow(labels, flexes),
                  if (_vitalSignsList.isEmpty) _buildEmptyRow(),
                  ..._vitalSignsList.asMap().entries.map((entry) {
                    final data = entry.value;
                    return _buildDataRow(
                      flexes,
                      [
                        _buildCompactTimeField(data.time ?? ''),
                        Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: data.atHospital,
                              onChanged: (v) async {
                                final dao = context
                                    .read<AppDatabase>()
                                    .ambulanceTreatmentDao;
                                await dao.updateVitalSign(
                                  AmbulanceVitalSignsCompanion(
                                    id: drift.Value(data.id),
                                    atHospital: drift.Value(v ?? false),
                                  ),
                                );
                                setState(() {
                                  // Optimistic update or reload
                                  _loadData();
                                });
                              },
                              activeColor: primaryColor,
                            ),
                          ),
                        ),
                        Center(
                            child: Text(data.avpu ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.gcsE ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.gcsV ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.gcsM ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            _calculateGcsTotal(data),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Center(
                            child: Text(data.temperature ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.pulse ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.respirationRate ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.bloodPressure ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        Center(
                            child: Text(data.spo2 ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: textDark))),
                        _buildDeleteBtn(() => _removeVitalSign(data.id)),
                      ],
                      onTap: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AmbulanceVitalSignDialog(
                            recordId: _recordId!,
                            initialData: data,
                          ),
                        );
                        if (result == true) {
                          _loadData();
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicationTable() {
    final flexes = [2, 3, 3, 2, 2, 1];
    final labels = [
      '時間 TIME',
      '藥品名稱 DRUG NAME',
      '使用方式 ROUTE',
      '劑量單位 DOSE',
      'EMT姓名 EMT NAME',
      '',
    ];
    return Column(
      children: [
        _buildTableHeaderRow(labels, flexes),
        if (_medicationList.isEmpty) _buildEmptyRow(),
        ..._medicationList.asMap().entries.map((e) {
          final data = e.value;
          return _buildDataRow(
            flexes,
            [
              _buildCompactTimeField(data.time ?? '--:--'),
              Center(
                  child: Text(data.drugName ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: textDark))),
              Center(
                  child: Text(data.route ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: textDark))),
              Center(
                  child: Text(data.dose ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: textDark))),
              Center(
                  child: Text(data.emtName ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: textDark))),
              _buildDeleteBtn(() => _removeMedicationLog(data.id)),
            ],
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AmbulanceMedicationDialog(
                  recordId: _recordId!,
                  initialData: data,
                ),
              );
              if (result == true) {
                _loadData();
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildEscortStaffTable() {
    final flexes = [5, 5, 1];
    final labels = ['隨車人員姓名 NAME', '簽名 SIGNATURE', ''];
    return Column(
      children: [
        _buildTableHeaderRow(labels, flexes),
        if (_escortStaffList.isEmpty) _buildEmptyRow(),
        ..._escortStaffList.asMap().entries.map((e) {
          final data = e.value;
          return _buildDataRow(
            flexes,
            [
              Center(
                  child: Text(data.name ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: textDark))),
              const Center(
                child: Text(
                  'Sign here',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              _buildDeleteBtn(() => _removeEscortStaff(data.id)),
            ],
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AmbulanceStaffDialog(
                  recordId: _recordId!,
                  initialData: data,
                ),
              );
              if (result == true) {
                _loadData();
              }
            },
          );
        }),
      ],
    );
  }

  // 5. 表格對齊工具方法

  Widget _buildTableHeaderRow(List<String> labels, List<int> flexes) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: labels
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                flex: flexes[e.key],
                child: Text(
                  e.value,
                  style: const TextStyle(
                    color: Color(0xFF5E878D),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDataRow(List<int> flexes, List<Widget> children,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children
              .asMap()
              .entries
              .map(
                (e) => Expanded(
                  flex: flexes[e.key],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: e.value,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // 6. 基礎輸入與 UI 元件

  Widget _buildCompactTimeField(String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: textDark,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.access_time, size: 12, color: textMuted),
      ],
    );
  }

  Widget _buildDeleteBtn(VoidCallback onTap) => IconButton(
    icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 18),
    onPressed: onTap,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
  );

  Widget _buildEmptyRow() => Container(
    padding: const EdgeInsets.all(16),
    alignment: Alignment.center,
    child: const Text(
      '無資料，請點擊 Add Row 新增',
      style: TextStyle(color: textMuted, fontSize: 12),
    ),
  );

  // 其他佈局元件

  Widget _buildMainCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map((cat) {
        bool isSel = _selectedCategoryIds.contains(cat.id);
        return InkWell(
          onTap: () => setState(
            () => isSel
                ? _selectedCategoryIds.remove(cat.id)
                : _selectedCategoryIds.add(cat.id),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSel ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSel ? primaryColor : borderColor,
                width: 1.5,
              ),
            ),
            child: Text(
              cat.name,
              style: TextStyle(
                color: isSel ? Colors.white : textDark,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDynamicSubActionSections() {
    return Column(
      children: _selectedCategoryIds.map((catId) {
        final cat = _categories.firstWhere(
          (c) => c.id == catId,
          orElse: () => AmbulanceTreatmentCategoryData(
            id: -1,
            code: '',
            name: 'Unknown',
            sortOrder: 0,
          ),
        );
        if (cat.id == -1) return const SizedBox.shrink();

        final items = _itemsByCategory[catId] ?? [];

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat.name,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 1. 選項按鈕區
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((item) {
                  bool isSelected = _selectedItemIds.contains(item.id);
                  return FilterChip(
                    label: Text(
                      item.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    selected: isSelected,
                    onSelected: (val) => _toggleItem(cat.id, item.id, val),
                    selectedColor: primaryColor.withValues(alpha: 0.1),
                    checkmarkColor: primaryColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? primaryColor : borderColor,
                      ),
                    ),
                  );
                }).toList(),
              ),

              // 2. Selected Items List (Table)
              if (_selectedItemIds.any((id) => items.any((i) => i.id == id))) ...[
                const SizedBox(height: 16),
                _buildSelectedItemsList(items),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedItemsList(
    List<AmbulanceTreatmentItemData> categoryItems,
  ) {
    // Filter items that are selected AND belong to this category
    final selectedItems =
        categoryItems
            .where((i) => _selectedItemIds.contains(i.id))
            .toList();

    if (selectedItems.isEmpty) return const SizedBox.shrink();

    final flexes = [3, 4, 1];
    final labels = ['項目 ITEM', '詳細資料 DETAILS', ''];

    return Column(
      children: [
        _buildTableHeaderRow(labels, flexes),
        ...selectedItems.asMap().entries.map((e) {
          final item = e.value;
          final details = _formatItemDetails(item);

          return _buildDataRow(
            flexes,
            [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  details,
                  style: const TextStyle(fontSize: 13, color: textMuted),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_hasDetails(item))
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: primaryColor,
                      ),
                      onPressed: () => _editItemDetails(item.id, item),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      tooltip: '編輯 Edit',
                    ),
                  const SizedBox(width: 8),
                  _buildDeleteBtn(
                    () => _toggleItem(item.categoryId, item.id, false),
                  ),
                ],
              ),
            ],
            onTap:
                _hasDetails(item)
                    ? () => _editItemDetails(item.id, item)
                    : null,
          );
        }),
      ],
    );
  }

  String _formatItemDetails(AmbulanceTreatmentItemData item) {
    final d = _itemDetails[item.id];
    if (d == null) return '--';

    if (item.name == '氣管內管') {
      final size = d['tubeSize'];
      final depth = d['fixationDepth'];
      if ((size == null || size.isEmpty) && (depth == null || depth.isEmpty)) return '--';
      return 'Size: ${size ?? '-'}, Depth: ${depth ?? '-'} cm';
    } else if (item.name == '手動電擊器') {
      final count = d['shockCount'];
      final joules = d['shockJoules'];
      if ((count == null || count.isEmpty) && (joules == null || joules.isEmpty)) return '--';
      return 'Count: ${count ?? '-'}, Joules: ${joules ?? '-'} J';
    } else if (item.isOther) {
      return d['otherDescription'] ?? '--';
    }
    return '--';
  }

  Widget _buildTableContainer({
    required String title,
    required VoidCallback onAdd,
    required Widget child,
    String buttonLabel = 'Add Row',
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5E878D),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: Text(buttonLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                elevation: 0,
                side: const BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildBottomInfoSection() {
    const double horizontalGap = 16.0;

    return Column(
      children: [
        // 第一排：接收單位、接收時間、送醫意願
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '接收單位 RECEIVING UNIT',
                _buildTextField(
                  controller: _receivingHospitalController,
                  hint: 'Enter Hospital/Unit Name',
                  onChanged: (v) =>
                      _updateRecord(receivingHospital: drift.Value(v)),
                ),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '接收時間 RECEIVING TIME',
                _buildReceivingTimeField(),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '送醫意願 ADMISSION STATUS',
                _buildRefusalBox(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // 第二排：關係人身份、姓名、聯絡電話
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '關係人身份 RELATIONSHIP',
                _buildDropdownField2(
                  hint: '',
                  value: _relationship,
                  items: ['病患 Patient', '家屬 Family', '關係人 Associate'],
                  onChanged: (v) {
                    setState(() => _relationship = v!);
                    _updateRecord(relationship: drift.Value(v!));
                  },
                ),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '姓名 NAME',
                _buildTextField(
                  controller: _relativeNameController,
                  hint: 'Enter Full Name',
                  onChanged: (v) => _updateRecord(relativeName: drift.Value(v)),
                ),
              ),
            ),
            const SizedBox(width: horizontalGap),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '聯絡電話 PHONE',
                _buildTextField(
                  controller: _relativePhoneController,
                  hint: 'Enter Contact Number',
                  onChanged: (v) =>
                      _updateRecord(relativePhone: drift.Value(v)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefusalBox() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: _isRefused,
              onChanged: (v) {
                setState(() => _isRefused = v!);
                _updateRecord(isRefusedHospital: drift.Value(v!));
              },
              activeColor: Colors.redAccent,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '是否拒絕送醫 Refusal',
              style: TextStyle(
                color: Color(0xFFB91C1C),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivingTimeField() {
    return InkWell(
      onTap: () {
        // 點擊整塊區域直接更新為現在時間（含秒）
        final now = DateFormat('HH:mm:ss').format(DateTime.now());
        setState(() {
          _receivingTimeController.text = now;
        });
        _updateRecord(receivingTime: drift.Value(now));
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _receivingTimeController.text,
                style: TextStyle(
                  color: _receivingTimeController.text == '-- : -- : --'
                      ? textMuted.withValues(alpha: 0.4)
                      : textDark,
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Icon(
              Icons.access_time,
              size: 18,
              color: textMuted.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF5E878D),
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );
  Widget _buildFieldWrapper(String label, Widget field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildLabel(label), const SizedBox(height: 6), field],
  );
  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextEditingController? controller,
    Function(String)? onChanged,
    String? value,
  }) => TextField(
    controller:
        controller ??
        (value != null ? TextEditingController(text: value) : null),
    maxLines: maxLines,
    onChanged: onChanged,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.4)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
  Widget _buildDropdownField2({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) => Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: borderColor),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
        items: items
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Text(
                  s,
                  style: const TextStyle(fontSize: 14, color: textDark),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
