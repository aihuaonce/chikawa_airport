import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class AmbulancePersonalPage extends StatefulWidget {
  const AmbulancePersonalPage({super.key});

  @override
  State<AmbulancePersonalPage> createState() => _AmbulancePersonalPageState();
}

class _AmbulancePersonalPageState extends State<AmbulancePersonalPage> {
  String? gender; // <<< 性別選擇
  String? handled; // <<< 是否經手
  Uint8List? signatureImage; // <<< 儲存簽名圖像
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

   @override
  void dispose() {
    _signatureController.dispose(); // 釋放簽名控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  // 性別
                  _buildRadioRow(
                    title: '性別:',
                    groupValue: gender,
                    options: const ['男', '女'],
                    onChanged: (val) => setState(() => gender = val),
                  ),
                  const SizedBox(height: 16),

                  // 身分證字號/護照號碼
                  _buildTextFieldRow(
                    title: '身分證字號/護照號碼:',
                    hint: '請填寫證件號碼',
                  ),
                  const SizedBox(height: 16),

                  // 年齡
                  _buildTextFieldRow(
                    title: '年齡:',
                    hint: '請填寫整數',
                  ),
                  const SizedBox(height: 16),

                  // 住址
                  _buildTextFieldRow(
                    title: '住址:',
                    hint: '請填寫住址',
                  ),
                  const SizedBox(height: 16),

                  // 病患財物明細
                  _buildTextFieldRow(
                    title: '病患財物明細:',
                    hint: '請填寫病患財物明細',
                  ),
                  const SizedBox(height: 16),

                  // 是否經手
                  _buildRadioRow(
                    title: '是否有經手:',
                    groupValue: handled,
                    options: const ['未經手', '是'],
                    onChanged: (val) => setState(() => handled = val),
                  ),
                  const SizedBox(height: 16),

                  // 保管人姓名
                  _buildTextFieldRow(
                    title: '保管人姓名:',
                    hint: '請填寫保管人姓名',
                  ),
                  const SizedBox(height: 16),

                  // 保管人簽名
                  const Text('保管人簽名:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _openSignatureDialog(context),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: signatureImage == null
                          ? const Text(
                              '請點擊此處簽名',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Image.memory(signatureImage!),
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

  // 建立 radio 列
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
                onChanged: onChanged, // <<< 可選取
              ),
              Text(option),
              const SizedBox(width: 16),
            ],
          ),
      ],
    );
  }

  // 建立輸入列
  Widget _buildTextFieldRow({required String title, required String hint}) {
    return Row(
      children: [
        SizedBox(
          width: 150, // <<< 標題固定寬
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          width: 300, // <<< 輸入框固定寬
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey), // <<< hintText 樣式
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

  // 開啟簽名 Dialog
  Future<void> _openSignatureDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: FractionallySizedBox(
            widthFactor: 0.7, // <<< 70% 寬度
            heightFactor: 0.7, // <<< 70% 高度
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('簽名區', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                      TextButton(
                        onPressed: () async {
                          if (_signatureController.isNotEmpty) {
                            final data = await _signatureController.toPngBytes();
                            if (data != null) {
                              setState(() => signatureImage = data);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("簽名已儲存")),
                              );
                            }
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