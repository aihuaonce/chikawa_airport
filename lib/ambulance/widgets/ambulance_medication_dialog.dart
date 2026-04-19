import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';

class AmbulanceMedicationDialog extends StatefulWidget {
  final int recordId;
  final AmbulanceMedicationLogData? initialData;

  const AmbulanceMedicationDialog({
    super.key,
    required this.recordId,
    this.initialData,
  });

  @override
  State<AmbulanceMedicationDialog> createState() =>
      _AmbulanceMedicationDialogState();
}

class _AmbulanceMedicationDialogState extends State<AmbulanceMedicationDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _timeController;
  late TextEditingController _drugNameController;
  late TextEditingController _routeController;
  late TextEditingController _doseController;
  late TextEditingController _emtNameController;

  // Drug search
  final TextEditingController _searchController = TextEditingController();
  List<DrugRefData> _drugResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(
      text: widget.initialData?.time ??
          DateFormat('HH:mm:ss').format(DateTime.now()),
    );
    _drugNameController = TextEditingController(
      text: widget.initialData?.drugName ?? '',
    );
    _routeController = TextEditingController(
      text: widget.initialData?.route ?? '',
    );
    _doseController = TextEditingController(
      text: widget.initialData?.dose ?? '',
    );
    _emtNameController = TextEditingController(
      text: widget.initialData?.emtName ?? '',
    );

    // Initialize drug search (empty initially - no results shown)
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performDrugSearch(_searchController.text);
    });
  }

  Future<void> _performDrugSearch(String query) async {
    setState(() => _isSearching = true);

    try {
      final refService = context.read<ReferenceService>();
      final drugs = refService.drugList;

      if (query.isEmpty) {
        setState(() {
          _drugResults = drugs;
          _isSearching = false;
        });
        return;
      }

      final lowerQuery = query.toLowerCase();
      final results = drugs
          .where((d) =>
              d.name.toLowerCase().contains(lowerQuery) ||
              d.category.toLowerCase().contains(lowerQuery))
          .toList();

      setState(() {
        _drugResults = results;
        _isSearching = false;
      });
    } catch (e) {
      debugPrint('Drug search error: $e');
      setState(() {
        _drugResults = [];
        _isSearching = false;
      });
    }
  }

  void _selectDrug(DrugRefData drug) {
    setState(() {
      _drugNameController.text = drug.name;
      _searchController.clear();
      _drugResults.clear();
    });
  }

  @override
  void dispose() {
    _timeController.dispose();
    _drugNameController.dispose();
    _routeController.dispose();
    _doseController.dispose();
    _emtNameController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final dao = context.read<AppDatabase>().ambulanceTreatmentDao;
      final companion = AmbulanceMedicationLogsCompanion(
        recordId: drift.Value(widget.recordId),
        time: drift.Value(_timeController.text),
        drugName: drift.Value(_drugNameController.text),
        route: drift.Value(_routeController.text),
        dose: drift.Value(_doseController.text),
        emtName: drift.Value(_emtNameController.text),
      );

      if (widget.initialData == null) {
        await dao.addMedicationLog(companion);
      } else {
        await (dao.update(dao.ambulanceMedicationLogs)
              ..where((t) => t.id.equals(widget.initialData!.id)))
            .write(companion);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF007A8A);
    const borderColor = Color(0xFFE2E8F0);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.initialData == null
                              ? Icons.add_circle_outline
                              : Icons.edit_note_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.initialData == null ? '新增藥物紀錄' : '編輯藥物紀錄',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        label: '時間',
                        subLabel: 'TIME',
                        controller: _timeController,
                        icon: Icons.access_time,
                      ),
                      const SizedBox(height: 16),
                      // Drug Search Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medication, size: 14, color: Color(0xFF64748B)),
                              SizedBox(width: 6),
                              Text(
                                '藥品名稱',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'DRUG NAME',
                                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Search input with dropdown
                          StatefulBuilder(
                            builder: (context, setDropdownState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _drugNameController,
                                    style: TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: '點擊搜尋藥物...',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: primaryColor,
                                      ),
                                      suffixIcon: _drugNameController.text.isNotEmpty
                                          ? IconButton(
                                              icon: Icon(Icons.clear, color: Color(0xFF94A3B8)),
                                              onPressed: () {
                                                _drugNameController.clear();
                                                setDropdownState(() {
                                                  _drugResults.clear();
                                                });
                                              },
                                            )
                                          : null,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: borderColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: borderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: primaryColor),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    onTap: () {
                                      // Show all drugs when focusing on the field
                                      if (_drugResults.isEmpty) {
                                        _performDrugSearch('');
                                      }
                                    },
                                    onChanged: (val) {
                                      setDropdownState(() {});
                                      if (val.isNotEmpty) {
                                        _performDrugSearch(val);
                                      } else {
                                        setDropdownState(() {
                                          _drugResults.clear();
                                        });
                                      }
                                    },
                                  ),
                                  // Dropdown results (only show when user typed something)
                                  if (_drugNameController.text.isNotEmpty && _drugResults.isNotEmpty) ...[
                                    SizedBox(height: 4),
                                    Container(
                                      constraints: BoxConstraints(maxHeight: 200),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: primaryColor),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: _drugResults.length,
                                        itemBuilder: (context, index) {
                                          final drug = _drugResults[index];
                                          return InkWell(
                                            onTap: () {
                                              _selectDrug(drug);
                                              setDropdownState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: borderColor.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF1F5F9),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      drug.category,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      drug.name,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Color(0xFF1E293B),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: '使用方式',
                              subLabel: 'ROUTE',
                              controller: _routeController,
                              icon: Icons.healing,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              label: '劑量單位',
                              subLabel: 'DOSE',
                              controller: _doseController,
                              icon: Icons.science,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'EMT姓名',
                        subLabel: 'EMT NAME',
                        controller: _emtNameController,
                        icon: Icons.person,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: Color(0xFFF8FAFC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('取消 Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text(
                      '儲存 Save',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildTextField({
    required String label,
    required String subLabel,
    required TextEditingController controller,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: const Color(0xFF64748B)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              subLabel,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007A8A)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
