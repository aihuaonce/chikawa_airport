import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:drift/drift.dart' show Value;

// 引入 nav5.dart 以獲取 AmbulanceDataProvider
import 'nav5.dart';

class AmbulancePersonalPage extends StatefulWidget {
  final int visitId;
  const AmbulancePersonalPage({super.key, required this.visitId});

  @override
  State<AmbulancePersonalPage> createState() => _AmbulancePersonalPageState();
}

class _AmbulancePersonalPageState extends State<AmbulancePersonalPage> {
  // --- 為這個頁面上的所有文字輸入框建立 TextEditingController ---
  final TextEditingController idCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController belongingsCtrl = TextEditingController();
  final TextEditingController custodianCtrl = TextEditingController();

  // --- 簽名控制器 ---
  // 讓它成為 final，因為我們每次打開 dialog 時都會清空它
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    // --- 在 initState 中，從 Provider 讀取一次資料，設定 Controller 的初始值 ---
    final dataProvider = context.read<AmbulanceDataProvider>();

    final profileData = dataProvider.patientProfileData;
    idCtrl.text = profileData.idNumber.value ?? '';
    ageCtrl.text = profileData.age.value?.toString() ?? '';
    addressCtrl.text = profileData.address.value ?? '';

    final recordData = dataProvider.ambulanceRecordData;
    belongingsCtrl.text = recordData.patientBelongings.value ?? '';
    custodianCtrl.text = recordData.custodianName.value ?? '';
  }

  @override
  void dispose() {
    // --- 釋放所有 Controller ---
    idCtrl.dispose();
    ageCtrl.dispose();
    addressCtrl.dispose();
    belongingsCtrl.dispose();
    custodianCtrl.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        final profileData = dataProvider.patientProfileData;
        final recordData = dataProvider.ambulanceRecordData;

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
                      // --- 性別 (來自 PatientProfiles) ---
                      _buildRadioRow(
                        title: '性別:',
                        groupValue: profileData.gender.value,
                        options: const ['男', '女'],
                        onChanged: (val) {
                          dataProvider.updatePatientProfile(
                            profileData.copyWith(gender: Value(val)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 身分證字號/護照號碼 (來自 PatientProfiles) ---
                      _buildTextFieldRow(
                        title: '身分證字號/護照號碼:',
                        hint: '請填寫證件號碼',
                        controller: idCtrl,
                        onChanged: (val) {
                          dataProvider.updatePatientProfile(
                            profileData.copyWith(idNumber: Value(val)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 年齡 (來自 PatientProfiles) ---
                      _buildTextFieldRow(
                        title: '年齡:',
                        hint: '請填寫整數',
                        controller: ageCtrl,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          dataProvider.updatePatientProfile(
                            profileData.copyWith(age: Value(int.tryParse(val))),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 住址 (來自 PatientProfiles) ---
                      _buildTextFieldRow(
                        title: '住址:',
                        hint: '請填寫住址',
                        controller: addressCtrl,
                        onChanged: (val) {
                          dataProvider.updatePatientProfile(
                            profileData.copyWith(address: Value(val)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 病患財物明細 (來自 AmbulanceRecords) ---
                      _buildTextFieldRow(
                        title: '病患財物明細:',
                        hint: '請填寫病患財物明細',
                        controller: belongingsCtrl,
                        onChanged: (val) {
                          dataProvider.updateAmbulanceRecord(
                            recordData.copyWith(patientBelongings: Value(val)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 是否經手 (來自 AmbulanceRecords) ---
                      _buildRadioRow(
                        title: '是否有經手:',
                        groupValue: recordData.belongingsHandled.value,
                        options: const ['未經手', '是'],
                        onChanged: (val) {
                          dataProvider.updateAmbulanceRecord(
                            recordData.copyWith(belongingsHandled: Value(val)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 保管人姓名 (來自 AmbulanceRecords) ---
                      _buildTextFieldRow(
                        title: '保管人姓名:',
                        hint: '請填寫保管人姓名',
                        controller: custodianCtrl,
                        onChanged: (val) {
                          dataProvider.updateAmbulanceRecord(
                            recordData.copyWith(custodianName: Value(val)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- 保管人簽名 (來自 AmbulanceRecords) ---
                      const Text(
                        '保管人簽名:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            _openSignatureDialog(context, dataProvider),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: recordData.custodianSignature.value == null
                              ? const Text(
                                  '請點擊此處簽名',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Image.memory(
                                  recordData.custodianSignature.value!,
                                ),
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
    required ValueChanged<String> onChanged,
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
        SizedBox(
          width: 300,
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
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // 【修正後的簽名對話框方法】
  Future<void> _openSignatureDialog(
    BuildContext context,
    AmbulanceDataProvider dataProvider,
  ) async {
    // 每次打開對話框時，都清空控制器，確保是一個乾淨的簽名板
    _signatureController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _signatureController.clear(),
                        child: const Text('重寫'),
                      ),
                      // 新增一個 "清除簽名" 按鈕，用來將簽名設為 null
                      TextButton(
                        onPressed: () {
                          dataProvider.updateAmbulanceRecord(
                            dataProvider.ambulanceRecordData.copyWith(
                              custodianSignature: const Value(null),
                            ),
                          );
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text(
                          '清除簽名',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (_signatureController.isNotEmpty) {
                            final data = await _signatureController
                                .toPngBytes();
                            if (data != null) {
                              // 更新 Provider 中的簽名資料
                              dataProvider.updateAmbulanceRecord(
                                dataProvider.ambulanceRecordData.copyWith(
                                  custodianSignature: Value(data),
                                ),
                              );
                              if (context.mounted) Navigator.pop(context);
                            }
                          } else {
                            // 如果簽名是空的，也關閉對話框
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: const Text('儲存'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
