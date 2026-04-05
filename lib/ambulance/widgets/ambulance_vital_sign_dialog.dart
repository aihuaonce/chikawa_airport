import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';

class AmbulanceVitalSignDialog extends StatefulWidget {
  final int recordId;
  final AmbulanceVitalSignData? initialData;

  const AmbulanceVitalSignDialog({
    super.key,
    required this.recordId,
    this.initialData,
  });

  @override
  State<AmbulanceVitalSignDialog> createState() =>
      _AmbulanceVitalSignDialogState();
}

class _AmbulanceVitalSignDialogState extends State<AmbulanceVitalSignDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _timeController;
  late TextEditingController _gcsEController;
  late TextEditingController _gcsVController;
  late TextEditingController _gcsMController;
  late TextEditingController _tempController;
  late TextEditingController _pulseController;
  late TextEditingController _rrController;
  late TextEditingController _bpController;
  late TextEditingController _spo2Controller;

  bool _atHospital = false;
  String? _avpu;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(
      text:
          widget.initialData?.time ??
          DateFormat('HH:mm:ss').format(DateTime.now()),
    );
    _gcsEController = TextEditingController(
      text: widget.initialData?.gcsE ?? '',
    );
    _gcsVController = TextEditingController(
      text: widget.initialData?.gcsV ?? '',
    );
    _gcsMController = TextEditingController(
      text: widget.initialData?.gcsM ?? '',
    );
    _tempController = TextEditingController(
      text: widget.initialData?.temperature ?? '',
    );
    _pulseController = TextEditingController(
      text: widget.initialData?.pulse ?? '',
    );
    _rrController = TextEditingController(
      text: widget.initialData?.respirationRate ?? '',
    );
    _bpController = TextEditingController(
      text: widget.initialData?.bloodPressure ?? '',
    );
    _spo2Controller = TextEditingController(
      text: widget.initialData?.spo2 ?? '',
    );

    _atHospital = widget.initialData?.atHospital ?? false;
    _avpu = widget.initialData?.avpu;
  }

  @override
  void dispose() {
    _timeController.dispose();
    _gcsEController.dispose();
    _gcsVController.dispose();
    _gcsMController.dispose();
    _tempController.dispose();
    _pulseController.dispose();
    _rrController.dispose();
    _bpController.dispose();
    _spo2Controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final dao = context.read<AppDatabase>().ambulanceTreatmentDao;
      final companion = AmbulanceVitalSignsCompanion(
        recordId: drift.Value(widget.recordId),
        time: drift.Value(_timeController.text),
        atHospital: drift.Value(_atHospital),
        avpu: drift.Value(_avpu),
        gcsE: drift.Value(_gcsEController.text),
        gcsV: drift.Value(_gcsVController.text),
        gcsM: drift.Value(_gcsMController.text),
        temperature: drift.Value(_tempController.text),
        pulse: drift.Value(_pulseController.text),
        respirationRate: drift.Value(_rrController.text),
        bloodPressure: drift.Value(_bpController.text),
        spo2: drift.Value(_spo2Controller.text),
      );

      if (widget.initialData == null) {
        await dao.addVitalSign(companion);
      } else {
        await (dao.update(
          dao.ambulanceVitalSigns,
        )..where((t) => t.id.equals(widget.initialData!.id))).write(companion);
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
        width: 700,
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
                        widget.initialData == null ? '新增生命徵象紀錄' : '編輯生命徵象紀錄',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: '時間',
                              subLabel: 'TIME',
                              controller: _timeController,
                              icon: Icons.access_time,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '狀態',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CheckboxListTile(
                                  value: _atHospital,
                                  onChanged: (v) =>
                                      setState(() => _atHospital = v!),
                                  title: const Text('已到達醫院 At Hospital'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '意識評估 CONSCIOUSNESS',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'AVPU',
                              value: _avpu,
                              items: ['清', '聲', '痛', '否'],
                              onChanged: (v) => setState(() => _avpu = v),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'GCS E',
                              subLabel: 'EYE',
                              controller: _gcsEController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'GCS V',
                              subLabel: 'VERBAL',
                              controller: _gcsVController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'GCS M',
                              subLabel: 'MOTOR',
                              controller: _gcsMController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '生理數值 VITAL SIGNS',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: '體溫',
                              subLabel: 'TEMP (°C)',
                              controller: _tempController,
                              keyboardType: TextInputType.number,
                              icon: Icons.thermostat,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              label: '脈搏',
                              subLabel: 'PULSE (bpm)',
                              controller: _pulseController,
                              keyboardType: TextInputType.number,
                              icon: Icons.favorite,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              label: '呼吸',
                              subLabel: 'RR (/min)',
                              controller: _rrController,
                              keyboardType: TextInputType.number,
                              icon: Icons.air,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: '血壓',
                              subLabel: 'BP (mmHg)',
                              controller: _bpController,
                              icon: Icons.compress,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              label: '血氧',
                              subLabel: 'SpO2 (%)',
                              controller: _spo2Controller,
                              keyboardType: TextInputType.number,
                              icon: Icons.water_drop,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
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
    TextInputType? keyboardType,
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
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
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
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
