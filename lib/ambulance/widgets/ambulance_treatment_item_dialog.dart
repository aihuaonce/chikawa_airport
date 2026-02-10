import 'package:flutter/material.dart';

class AmbulanceTreatmentItemDialog extends StatefulWidget {
  final String itemName;
  final bool isOther;
  final Map<String, dynamic> initialDetails;

  const AmbulanceTreatmentItemDialog({
    super.key,
    required this.itemName,
    required this.isOther,
    required this.initialDetails,
  });

  @override
  State<AmbulanceTreatmentItemDialog> createState() =>
      _AmbulanceTreatmentItemDialogState();
}

class _AmbulanceTreatmentItemDialogState
    extends State<AmbulanceTreatmentItemDialog> {
  final _formKey = GlobalKey<FormState>();

  // Airway -> Endotracheal Tube
  late TextEditingController _tubeSizeController;
  late TextEditingController _fixationDepthController;

  // CPR -> Defibrillator
  late TextEditingController _shockCountController;
  late TextEditingController _shockJoulesController;

  // Other
  late TextEditingController _otherDescriptionController;

  @override
  void initState() {
    super.initState();
    _tubeSizeController = TextEditingController(
      text: widget.initialDetails['tubeSize'] ?? '',
    );
    _fixationDepthController = TextEditingController(
      text: widget.initialDetails['fixationDepth'] ?? '',
    );
    _shockCountController = TextEditingController(
      text: widget.initialDetails['shockCount'] ?? '',
    );
    _shockJoulesController = TextEditingController(
      text: widget.initialDetails['shockJoules'] ?? '',
    );
    _otherDescriptionController = TextEditingController(
      text: widget.initialDetails['otherDescription'] ?? '',
    );
  }

  @override
  void dispose() {
    _tubeSizeController.dispose();
    _fixationDepthController.dispose();
    _shockCountController.dispose();
    _shockJoulesController.dispose();
    _otherDescriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final result = <String, dynamic>{};

      if (widget.itemName == '氣管內管') {
        result['tubeSize'] = _tubeSizeController.text;
        result['fixationDepth'] = _fixationDepthController.text;
      } else if (widget.itemName == '手動電擊器') {
        result['shockCount'] = _shockCountController.text;
        result['shockJoules'] = _shockJoulesController.text;
      } else if (widget.isOther) {
        result['otherDescription'] = _otherDescriptionController.text;
      }

      Navigator.of(context).pop(result);
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
                        child: const Icon(
                          Icons.edit_note_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '編輯處置細節',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            widget.itemName,
                            style: const TextStyle(
                              fontSize: 13,
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
                      if (widget.itemName == '氣管內管') ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: '氣管內管號碼',
                                subLabel: 'SIZE',
                                controller: _tubeSizeController,
                                icon: Icons.medical_services,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                label: '固定公分數',
                                subLabel: 'DEPTH (cm)',
                                controller: _fixationDepthController,
                                icon: Icons.straighten,
                              ),
                            ),
                          ],
                        ),
                      ] else if (widget.itemName == '手動電擊器') ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: '電擊次數',
                                subLabel: 'COUNT',
                                controller: _shockCountController,
                                icon: Icons.bolt,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                label: '電擊焦耳數',
                                subLabel: 'JOULES',
                                controller: _shockJoulesController,
                                icon: Icons.electric_bolt,
                              ),
                            ),
                          ],
                        ),
                      ] else if (widget.isOther) ...[
                        _buildTextField(
                          label: '其它處置細節',
                          subLabel: 'DESCRIPTION',
                          controller: _otherDescriptionController,
                          icon: Icons.notes,
                          maxLines: 3,
                        ),
                      ] else ...[
                        const Text('此項目無額外詳細資訊需填寫。'),
                      ],
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
                      '確認 Save',
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
    int maxLines = 1,
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
