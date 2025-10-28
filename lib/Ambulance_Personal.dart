import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class AmbulancePersonalPage extends StatefulWidget {
  final int visitId;
  const AmbulancePersonalPage({super.key, required this.visitId});

  @override
  State<AmbulancePersonalPage> createState() => _AmbulancePersonalPageState();
}

class _AmbulancePersonalPageState extends State<AmbulancePersonalPage> {
  final _idCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _belongingsCtrl = TextEditingController();
  final _custodianCtrl = TextEditingController();

  // ✅【新增】統一主色
  static const Color _deepGreen = Color(0xFF274C4A);

  static const Color _border = Color.fromARGB(255, 105, 105, 105);
  static const Color _lightGreen = Color(0xFF83ACA9);
  static const double _fieldFontSize = 14;

  InputDecoration _outlineDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: _fieldFontSize),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _deepGreen),
      ),
    );
  }

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<AmbulanceData>();
    _idCtrl.text = data.idNumber ?? '';
    _ageCtrl.text = data.age?.toString() ?? '';
    _addressCtrl.text = data.address ?? '';
    _belongingsCtrl.text = data.patientBelongings ?? '';
    _custodianCtrl.text = data.custodianName ?? '';
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _ageCtrl.dispose();
    _addressCtrl.dispose();
    _belongingsCtrl.dispose();
    _custodianCtrl.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<AmbulanceData>();
    data.updatePersonal(
      idNumber: _idCtrl.text,
      age: int.tryParse(_ageCtrl.text),
      address: _addressCtrl.text,
      patientBelongings: _belongingsCtrl.text,
      custodianName: _custodianCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final genderOptions = [t.male, t.female];
    final handledOptions = [t.notHandled, t.yes];

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRadioRow(
                        title: t.gender,
                        groupValue: data.gender,
                        options: genderOptions,
                        onChanged: (val) => data.updatePersonal(gender: val),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.idOrPassportNumber,
                        hint: t.enterIdOrPassportHint,
                        controller: _idCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.age,
                        hint: t.enterIntegerHint,
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.address,
                        hint: t.enterAddressHint,
                        controller: _addressCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.patientBelongings,
                        hint: t.enterBelongingsHint,
                        controller: _belongingsCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildRadioRow(
                        title: t.belongingsHandled,
                        groupValue: data.belongingsHandled,
                        options: handledOptions,
                        onChanged: (val) =>
                            data.updatePersonal(belongingsHandled: val),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.custodianName,
                        hint: t.enterCustodianNameHint,
                        controller: _custodianCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        t.custodianSignature,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _handleSignatureTap(data, t),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: data.custodianSignature == null
                              ? Text(
                                  t.tapToSign,
                                  style: const TextStyle(color: Colors.grey),
                                )
                              : Image.memory(data.custodianSignature!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSignatureTap(
    AmbulanceData data,
    AppTranslations t,
  ) async {
    final result = await _openSignatureDialog(t);
    if (result != null) {
      data.updatePersonal(custodianSignature: result);
    }
  }

  Widget _buildRadioRow({
    required String title,
    required String? groupValue,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        for (var option in options)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: _deepGreen,
              ),
              Text(option),
              const SizedBox(width: 16),
            ],
          ),
      ],
    );
  }

  Widget _buildTextFieldRow({
    required String title,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required VoidCallback onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fieldFontSize,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: _outlineDecoration(hint),
            onChanged: (_) => onChanged(),
          ),
        ),
      ],
    );
  }

  Future<Uint8List?> _openSignatureDialog(AppTranslations t) async {
    _signatureController.clear();

    return showDialog<Uint8List?>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: FractionallySizedBox(
          widthFactor: 0.7,
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  t.signatureArea,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Signature(
                      controller: _signatureController,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _signatureController.clear(),
                      child: Text(t.redraw, style: const TextStyle(color: _deepGreen)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text(
                        t.clearSignature,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _deepGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (_signatureController.isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                        final data = await _signatureController.toPngBytes();
                        if (!context.mounted) return;
                        Navigator.pop(context, data);
                      },
                      child: Text(t.done),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}