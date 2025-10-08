import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:drift/drift.dart' show Value;

import 'nav5.dart'; // 為了獲取 AmbulanceDataProvider

class AmbulancePersonalPage extends StatefulWidget {
  final int visitId;
  const AmbulancePersonalPage({super.key, required this.visitId});

  @override
  State<AmbulancePersonalPage> createState() => _AmbulancePersonalPageState();
}

class _AmbulancePersonalPageState extends State<AmbulancePersonalPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  // --- 本地 UI 狀態 ---
  final _idCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _belongingsCtrl = TextEditingController();
  final _custodianCtrl = TextEditingController();

  String? _gender;
  String? _belongingsHandled;
  Uint8List? _custodianSignature;

  // --- 簽名控制器 ---
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final dataProvider = context.read<AmbulanceDataProvider>();

    final profileData = dataProvider.patientProfileData;
    _idCtrl.text = profileData.idNumber.value ?? '';
    _ageCtrl.text = profileData.age.value?.toString() ?? '';
    _addressCtrl.text = profileData.address.value ?? '';
    _gender = profileData.gender.value;

    final recordData = dataProvider.ambulanceRecordData;
    _belongingsCtrl.text = recordData.patientBelongings.value ?? '';
    _custodianCtrl.text = recordData.custodianName.value ?? '';
    _belongingsHandled = recordData.belongingsHandled.value;
    _custodianSignature = recordData.custodianSignature.value;
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

  @override
  Future<void> saveData() async {
    try {
      final dataProvider = context.read<AmbulanceDataProvider>();

      dataProvider.updatePatientProfile(
        dataProvider.patientProfileData.copyWith(
          gender: Value(_gender),
          idNumber: Value(_idCtrl.text),
          age: Value(int.tryParse(_ageCtrl.text)),
          address: Value(_addressCtrl.text),
        ),
      );

      dataProvider.updateAmbulanceRecord(
        dataProvider.ambulanceRecordData.copyWith(
          patientBelongings: Value(_belongingsCtrl.text),
          belongingsHandled: Value(_belongingsHandled),
          custodianName: Value(_custodianCtrl.text),
          custodianSignature: Value(_custodianSignature),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                    groupValue: _gender,
                    options: const ['男', '女'],
                    onChanged: (val) => setState(() => _gender = val),
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldRow(
                    title: '身分證字號/護照號碼:',
                    hint: '請填寫證件號碼',
                    controller: _idCtrl,
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldRow(
                    title: '年齡:',
                    hint: '請填寫整數',
                    controller: _ageCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldRow(
                    title: '住址:',
                    hint: '請填寫住址',
                    controller: _addressCtrl,
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldRow(
                    title: '病患財物明細:',
                    hint: '請填寫病患財物明細',
                    controller: _belongingsCtrl,
                  ),
                  const SizedBox(height: 16),

                  _buildRadioRow(
                    title: '是否有經手:',
                    groupValue: _belongingsHandled,
                    options: const ['未經手', '是'],
                    onChanged: (val) =>
                        setState(() => _belongingsHandled = val),
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldRow(
                    title: '保管人姓名:',
                    hint: '請填寫保管人姓名',
                    controller: _custodianCtrl,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    '保管人簽名:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _handleSignatureTap,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: _custodianSignature == null
                          ? const Text(
                              '請點擊此處簽名',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Image.memory(_custodianSignature!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignatureTap() async {
    final result = await _openSignatureDialog();

    // ✅ 修正 2: 移除不必要的型別檢查
    // `result` 的型別已經是 Uint8List?，直接使用即可
    setState(() {
      _custodianSignature = result;
    });
  }

  // --- 小積木 (Helper Widgets) ---
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
                onChanged: onChanged, // ✅ 修正 1: 這個 onChanged 是正確的，因為它是來自函數參數
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
          // 使用 Expanded 避免超寬問題
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
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
            // ✅ 修正 1: TextField 不需要 onChanged，因為 Controller 已處理狀態
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
                          Navigator.pop(context); // 空簽名不回傳資料
                          return;
                        }

                        final data = await _signatureController.toPngBytes();

                        // ✅ 修正 3: 在 await 之後使用 context 之前，加上 mounted 檢查
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
