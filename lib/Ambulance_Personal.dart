import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/models/ambulance_data.dart';

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
                        title: '性別:',
                        groupValue: data.gender,
                        options: const ['男', '女'],
                        onChanged: (val) => data.updatePersonal(gender: val),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: '身分證字號/護照號碼:',
                        hint: '請填寫證件號碼',
                        controller: _idCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: '年齡:',
                        hint: '請填寫整數',
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: '住址:',
                        hint: '請填寫住址',
                        controller: _addressCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: '病患財物明細:',
                        hint: '請填寫病患財物明細',
                        controller: _belongingsCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      _buildRadioRow(
                        title: '是否有經手:',
                        groupValue: data.belongingsHandled,
                        options: const ['未經手', '是'],
                        onChanged: (val) =>
                            data.updatePersonal(belongingsHandled: val),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFieldRow(
                        title: '保管人姓名:',
                        hint: '請填寫保管人姓名',
                        controller: _custodianCtrl,
                        onChanged: _saveToProvider,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        '保管人簽名:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _handleSignatureTap(data),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: data.custodianSignature == null
                              ? const Text(
                                  '請點擊此處簽名',
                                  style: TextStyle(color: Colors.grey),
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

  Future<void> _handleSignatureTap(AmbulanceData data) async {
    final result = await _openSignatureDialog();
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

  Future<Uint8List?> _openSignatureDialog() async {
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
                const Text(
                  '簽名區',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      child: const Text('重寫'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text(
                        '清除簽名',
                        style: TextStyle(color: Colors.red),
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
                      child: const Text('完成'),
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
