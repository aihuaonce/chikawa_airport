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
    final t = AppTranslations.of(context); // 【新增】取得翻譯物件
    final genderOptions = [t.male, t.female]; // 【新增】性別選項
    final handledOptions = [t.notHandled, t.yes]; // 【新增】經手選項

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
                        title: t.gender, // 【修改】
                        groupValue: data.gender,
                        options: genderOptions, // 【修改】
                        onChanged: (val) => data.updatePersonal(gender: val),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.idOrPassportNumber, // 【修改】
                        hint: t.enterIdOrPassportHint, // 【修改】
                        controller: _idCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.age, // 【修改】
                        hint: t.enterIntegerHint, // 【修改】
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.address, // 【修改】
                        hint: t.enterAddressHint, // 【修改】
                        controller: _addressCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.patientBelongings, // 【修改】
                        hint: t.enterBelongingsHint, // 【修改】
                        controller: _belongingsCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildRadioRow(
                        title: t.belongingsHandled, // 【修改】
                        groupValue: data.belongingsHandled,
                        options: handledOptions, // 【修改】
                        onChanged: (val) =>
                            data.updatePersonal(belongingsHandled: val),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: t.custodianName, // 【修改】
                        hint: t.enterCustodianNameHint, // 【修改】
                        controller: _custodianCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        t.custodianSignature, // 【修改】
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _handleSignatureTap(data, t), // 【修改】
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: data.custodianSignature == null
                              ? Text(
                                  t.tapToSign, // 【修改】
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
    // 【修改】
    final result = await _openSignatureDialog(t); // 【修改】
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
    TextInputType? keyboardType,
    VoidCallback? onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged != null ? (_) => onChanged() : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Uint8List?> _openSignatureDialog(AppTranslations t) async {
    // 【修改】
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
                  t.signatureArea, // 【修改】
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
                      child: Text(t.redraw), // 【修改】
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text(
                        t.clearSignature, // 【修改】
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController.isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                        final data = await _signatureController.toPngBytes();
                        if (!context.mounted) return;
                        Navigator.pop(context, data);
                      },
                      child: Text(t.done), // 【修改】
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
