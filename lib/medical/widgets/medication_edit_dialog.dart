import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../../data/models/medical/treatment_view.dart';

class MedicationEditDialog extends StatefulWidget {
  final MedicationData? medication;
  final TreatmentViewModel viewModel;

  const MedicationEditDialog({
    super.key,
    this.medication,
    required this.viewModel,
  });

  @override
  State<MedicationEditDialog> createState() => _MedicationEditDialogState();
}

class _MedicationEditDialogState extends State<MedicationEditDialog> {
  final _formKey = GlobalKey<FormState>();

  // Selections
  String? _selectedCategory;
  String? _selectedDrugName;

  // Controllers
  late TextEditingController _methodController;
  late TextEditingController _frequencyController;
  late TextEditingController _daysController;
  late TextEditingController _doseController;
  late TextEditingController _unitController;
  late TextEditingController _remarksController;

  // Data Sources
  List<String> _categories = [];
  List<DrugRefData> _filteredDrugs = [];

  // Helper Options with Chinese Explanations
  final Map<String, String> _methodMap = {
    'PO': '口服',
    'IV': '靜脈注射',
    'IM': '肌肉注射',
    'EXT': '外用',
    'SC': '皮下注射',
    'INH': '吸入',
  };

  final Map<String, String> _frequencyMap = {
    'ST': '',
    'QD': '',
    'BID': '',
    'TID': '',
    'QID': '',
    'HS': '',
    'Q6H': '',
    'Q12H': '',
    'Q8H': '',
    'PRN': '',
  };

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _methodController = TextEditingController(
      text: widget.medication?.method ?? '',
    );
    _frequencyController = TextEditingController(
      text: widget.medication?.frequency ?? '',
    );
    _daysController = TextEditingController(
      text: widget.medication?.days ?? '1',
    );
    _doseController = TextEditingController(
      text: widget.medication?.dose ?? '',
    );
    _unitController = TextEditingController(
      text: widget.medication?.unit ?? '',
    );
    _remarksController = TextEditingController(
      text: widget.medication?.remarks ?? '',
    );

    // Extract unique categories from DrugRef
    final allDrugs = widget.viewModel.refService.drugList;
    _categories = allDrugs.map((e) => e.category).toSet().toList();

    // Initialize selection if editing
    if (widget.medication != null) {
      _selectedDrugName = widget.medication!.name;
      // Try to find category from drug name
      try {
        final drug = allDrugs.firstWhere((d) => d.name == _selectedDrugName);
        _selectedCategory = drug.category;
      } catch (e) {
        // If drug name not found in ref list
      }
    } else {
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    }

    _updateFilteredDrugs();
  }

  void _updateFilteredDrugs() {
    if (_selectedCategory == null) {
      _filteredDrugs = [];
    } else {
      _filteredDrugs = widget.viewModel.refService.drugList
          .where((d) => d.category == _selectedCategory)
          .toList();
    }
  }

  @override
  void dispose() {
    _methodController.dispose();
    _frequencyController.dispose();
    _daysController.dispose();
    _doseController.dispose();
    _unitController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF007A8A);
    const borderColor = Color(0xFFE2E8F0);
    const bgField = Color(0xFFF8FAFC);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Container(
        width: 750, // Slightly wider for better desktop feel
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
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
                          widget.medication == null
                              ? Icons.medication_liquid_outlined
                              : Icons.edit_note_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.medication == null ? '新增處方藥物' : '編輯藥物資訊',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Text(
                            '請依序選擇分類並填寫詳細用藥資訊',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xFF94A3B8),
                    tooltip: '關閉',
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Category Selection
                      _buildStepHeader(
                        number: '1',
                        title: '選擇藥物類別',
                        subtitle: 'Drug Category',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgField,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                    _selectedDrugName = null;
                                    _updateFilteredDrugs();
                                  });
                                }
                              },
                              selectedColor: primaryColor,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF475569),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 2. Drug Selection
                      _buildStepHeader(
                        number: '2',
                        title: '選擇藥物名稱',
                        subtitle: 'Drug Name',
                      ),
                      const SizedBox(height: 12),
                      if (_filteredDrugs.isEmpty)
                        _buildEmptyState(
                          icon: Icons.category_outlined,
                          text: '請先選擇上方的藥物大類',
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgField,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _filteredDrugs.map((drug) {
                              final isSelected = _selectedDrugName == drug.name;
                              return FilterChip(
                                label: Text(drug.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedDrugName = selected
                                        ? drug.name
                                        : null;
                                  });
                                },
                                selectedColor: primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                                checkmarkColor: primaryColor,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? primaryColor
                                      : const Color(0xFF334155),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected
                                        ? primaryColor
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      if (_selectedDrugName == null &&
                          _selectedCategory != null) ...[
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 14,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '請選擇一種藥物',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 32),

                      // 3. Usage Details
                      _buildStepHeader(
                        number: '3',
                        title: '處方細節',
                        subtitle: 'Prescription Details',
                      ),
                      const SizedBox(height: 16),

                      // Method & Frequency
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInputWithQuickSelect(
                              label: '使用方式',
                              subLabel: 'Method',
                              controller: _methodController,
                              options: _methodMap,
                              icon: Icons.healing,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildInputWithQuickSelect(
                              label: '使用頻率',
                              subLabel: 'Frequency',
                              controller: _frequencyController,
                              options: _frequencyMap,
                              icon: Icons.access_time,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Dose, Unit, Days
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildSimpleField(
                                label: '劑量',
                                subLabel: 'Dose',
                                controller: _doseController,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: borderColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildSimpleField(
                                label: '單位',
                                subLabel: 'Unit',
                                controller: _unitController,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: borderColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildSimpleField(
                                label: '天數',
                                subLabel: 'Days',
                                controller: _daysController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Remarks
                      _buildTextField(
                        label: '備註說明',
                        subLabel: 'Remarks',
                        controller: _remarksController,
                        maxLines: 2,
                        icon: Icons.note_alt_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Actions
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

  // --- UI Components ---

  Widget _buildStepHeader({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF007A8A),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required IconData icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFCBD5E1), size: 32),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleField({
    required String label,
    required String subLabel,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              subLabel,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            border: InputBorder.none,
            hintText: '---',
            hintStyle: TextStyle(color: Color(0xFFCBD5E1)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String subLabel,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
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
          maxLines: maxLines,
          keyboardType: keyboardType,
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

  Widget _buildInputWithQuickSelect({
    required String label,
    required String subLabel,
    required TextEditingController controller,
    required Map<String, String> options,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: label,
          subLabel: subLabel,
          controller: controller,
          icon: icon,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: options.entries.map((entry) {
            final code = entry.key;
            final desc = entry.value;
            return InkWell(
              onTap: () {
                controller.text = code;
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: code,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF007A8A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (desc.isNotEmpty) ...[
                        const WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: desc,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _save() async {
    if (_selectedDrugName == null || _selectedDrugName!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('請選擇藥物名稱')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      final companion = MedicationsCompanion(
        medicalId: drift.Value(widget.viewModel.medicalId),
        name: drift.Value(_selectedDrugName),
        method: drift.Value(_methodController.text),
        frequency: drift.Value(_frequencyController.text),
        days: drift.Value(_daysController.text),
        dose: drift.Value(_doseController.text),
        unit: drift.Value(_unitController.text),
        remarks: drift.Value(_remarksController.text),
      );

      if (widget.medication == null) {
        await widget.viewModel.saveMedication(companion);
      } else {
        await widget.viewModel.saveMedication(
          companion.copyWith(
            medicationId: drift.Value(widget.medication!.medicationId),
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
