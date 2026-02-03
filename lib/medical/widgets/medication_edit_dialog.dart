import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../../data/models/medical/treatment_view.dart';

import 'drug_search_sheet.dart';

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
  final TextEditingController _drugNameController = TextEditingController();

  // Controllers
  late TextEditingController _methodController;
  late TextEditingController _frequencyController;
  late TextEditingController _daysController;
  late TextEditingController _doseController;
  late TextEditingController _unitController;
  late TextEditingController _remarksController;

  // Helper Options with Chinese Explanations
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

  final Map<String, String> _unitMap = {
    'c.c.': '',
    'tab': '',
    'amp': '',
    'bot': '',
    'pack': '',
    'tube': '',
    'vial': '',
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

    // Initialize selection if editing
    if (widget.medication != null) {
      _selectedDrugName = widget.medication!.name;
      _drugNameController.text = _selectedDrugName ?? '';
    }
  }

  @override
  void dispose() {
    _drugNameController.dispose();
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
                            '請填寫詳細用藥資訊',
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
                      // 1. Drug Selection (Combined Search)
                      _buildStepHeader(
                        number: '1',
                        title: '藥物名稱',
                        subtitle: 'Drug Name',
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          final result = await DrugSearchSheet.show(
                            context,
                            title: '搜尋藥物',
                            initialValue: _drugNameController.text,
                            viewModel: widget.viewModel,
                          );
                          if (result != null) {
                            setState(() {
                              _selectedCategory = result.category;
                              _selectedDrugName = result.name;
                              _drugNameController.text = result.name;
                              _methodController.text = result.category;
                            });
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: _drugNameController,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: '點擊搜尋藥物...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.normal,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: bgField,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '請選擇藥物';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 2. Usage Details
                      _buildStepHeader(
                        number: '2',
                        title: '處方細節',
                        subtitle: 'Prescription Details',
                      ),
                      const SizedBox(height: 16),

                      // Method & Frequency
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: '使用方式',
                              subLabel: 'Method',
                              controller: _methodController,
                              icon: Icons.healing,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildDropdownField(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildSimpleField(
                                label: '劑量',
                                subLabel: 'Dose',
                                controller: _doseController,
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: borderColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildDropdownField(
                                label: '單位',
                                subLabel: 'Unit',
                                controller: _unitController,
                                options: _unitMap,
                                isCompact: true,
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: borderColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            Expanded(
                              flex: 2,
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

  Widget _buildDropdownField({
    required String label,
    required String subLabel,
    required TextEditingController controller,
    required Map<String, String> options,
    IconData? icon,
    bool isCompact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null && !isCompact) ...[
              Icon(icon, size: 14, color: const Color(0xFF64748B)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: isCompact ? 12 : 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: isCompact ? 10 : 11,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        if (!isCompact) const SizedBox(height: 8),
        DropdownMenu<String>(
          width: double.infinity,
          initialSelection: controller.text.isNotEmpty ? controller.text : null,
          controller: controller,
          enableFilter: true,
          requestFocusOnTap: true,
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            surfaceTintColor: WidgetStateProperty.all(Colors.white),
            elevation: WidgetStateProperty.all(2),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          dropdownMenuEntries: options.entries.map((entry) {
            return DropdownMenuEntry<String>(
              value: entry.key,
              label: entry.key,
            );
          }).toList(),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            filled: !isCompact,
            fillColor: isCompact ? Colors.transparent : Colors.white,
            contentPadding: isCompact
                ? const EdgeInsets.symmetric(vertical: 8)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: isCompact
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
            enabledBorder: isCompact
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
            focusedBorder: isCompact
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007A8A)),
                  ),
          ),
          onSelected: (value) {
            if (value != null) {
              controller.text = value;
            }
          },
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
