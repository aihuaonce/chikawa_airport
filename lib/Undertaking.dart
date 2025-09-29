// lib/UndertakingPage.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/db/daos.dart';
import 'data/models/undertaking_data.dart';
import 'nav2.dart'; // 為了使用 SavableStateMixin

class UndertakingPage extends StatefulWidget {
  final int visitId;
  const UndertakingPage({super.key, required this.visitId});

  @override
  State<UndertakingPage> createState() => _UndertakingPageState();
}

class _UndertakingPageState extends State<UndertakingPage>
    with
        AutomaticKeepAliveClientMixin<UndertakingPage>,
        SavableStateMixin<UndertakingPage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // 文字及簽名控制器
  final _relationController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _signerController = TextEditingController();
  final _signerIdController = TextEditingController();
  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _relationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _signerController.dispose();
    _signerIdController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('儲存切結書失敗: $e')));
      }
      rethrow;
    }
  }

  // ===============================================
  // 資料處理邏輯
  // ===============================================

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<UndertakingsDao>();
      final dataModel = context.read<UndertakingData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null) {
        dataModel.signerName = record.signerName;
        dataModel.signerId = record.signerId;
        dataModel.isSelf = record.isSelf;
        dataModel.relation = record.relation;
        dataModel.address = record.address;
        dataModel.phone = record.phone;
        dataModel.doctor = record.doctor ?? dataModel.doctor;
        dataModel.signatureBytes = record.signatureBytes;
      }

      _syncDataToControllers(dataModel);
      dataModel.update();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<UndertakingsDao>();
    final dataModel = context.read<UndertakingData>();
    await dao.upsertByVisitId(
      visitId: widget.visitId,
      signerName: dataModel.signerName,
      signerId: dataModel.signerId,
      isSelf: dataModel.isSelf,
      relation: dataModel.relation,
      address: dataModel.address,
      phone: dataModel.phone,
      doctor: dataModel.doctor,
      signatureBytes: dataModel.signatureBytes,
    );
  }

  void _syncDataToControllers(UndertakingData dataModel) {
    _signerController.text = dataModel.signerName ?? '';
    _signerIdController.text = dataModel.signerId ?? '';
    _relationController.text = dataModel.relation ?? '';
    _addressController.text = dataModel.address ?? '';
    _phoneController.text = dataModel.phone ?? '';
  }

  void _syncControllersToData() {
    final dataModel = context.read<UndertakingData>();
    dataModel.signerName = _signerController.text.trim();
    dataModel.signerId = _signerIdController.text.trim();
    dataModel.relation = _relationController.text.trim();
    dataModel.address = _addressController.text.trim();
    dataModel.phone = _phoneController.text.trim();
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final today = _todayTw();

    return Consumer<UndertakingData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.all(16.0),
          // ** 錯誤修正 **：將 Row 替換為 LayoutBuilder，以便在不同寬度下有不同佈局
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 如果寬度足夠，使用左右佈局
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEnglishSide(dataModel, today),
                    const SizedBox(width: 16),
                    _buildChineseSide(dataModel, today),
                  ],
                );
              }
              // 如果寬度不足，使用上下佈局並允許滾動
              else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEnglishSide(dataModel, today),
                      const SizedBox(height: 16),
                      _buildChineseSide(dataModel, today),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  // ===============================================
  // Helper Widgets
  // ===============================================

  Widget _buildEnglishSide(UndertakingData dataModel, String today) {
    return Expanded(
      child: Card(
        color: const Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // ** 錯誤修正 **：將 Column 替換為 SingleChildScrollView，使其內容可滾動
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "I: ${dataModel.signerName ?? ""}\n"
                  "Date of birth\n"
                  "Here by clarified that I / my family patient had been notified by Dr. ${dataModel.doctor} of Landseed Medical Clinic at Taiwan Taoyuan Int'l Airport, I am /my family patient is now in illness/necessary condition which needed to be transported to an advanced hospital facilites for further test and treatment. But under my our personal status/consideration, I/We decided to handle this situation by myself/ourselves, against any further medical advice I am hereby signing this consent clarified that I am /and my family are willing to take all the risks and hold all the responsibilities of any consequences, even hazardous to my/my family member's health or life integrity unexpectedly.",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Signature:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildSignatureArea(dataModel),
                const SizedBox(height: 12),
                Text("Date: $today"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureArea(UndertakingData dataModel) {
    if (dataModel.signatureBytes != null &&
        dataModel.signatureBytes!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(dataModel.signatureBytes!),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                dataModel.signatureBytes = null;
                _signatureController.clear();
                dataModel.update();
              },
              child: const Text("重簽"),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Signature(
              controller: _signatureController,
              backgroundColor: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _signatureController.clear(),
                child: const Text("重寫"),
              ),
              TextButton(
                onPressed: () async {
                  if (_signatureController.isNotEmpty) {
                    dataModel.signatureBytes = await _signatureController
                        .toPngBytes();
                    dataModel.update();
                    if (mounted)
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("簽名已暫存")));
                  }
                },
                child: const Text("確認簽名"),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildChineseSide(UndertakingData dataModel, String today) {
    _signerController.removeListener(() {});
    _signerController.addListener(() {
      dataModel.signerName = _signerController.text;
      dataModel.update();
    });

    _signerIdController.removeListener(() {});
    _signerIdController.addListener(() {
      dataModel.signerId = _signerIdController.text;
      dataModel.update();
    });

    return Expanded(
      child: Card(
        color: const Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("本人： ${dataModel.signerName ?? ""}"),
                const SizedBox(height: 8),
                Text("身分證字號： ${dataModel.signerId ?? ""}"),
                Text("$today 於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心醫師"),
                DropdownButton<String>(
                  value: dataModel.doctor,
                  isExpanded: true,
                  items: dataModel.doctorList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      dataModel.doctor = val;
                      dataModel.update();
                    }
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  "診視，醫師建議轉診至醫院繼續治療，但本人因個人因素拒絕醫師「繼續治療」之建議，致生一切後果願自行負責，與聯新國際醫院桃園國際機場醫療中心無涉。",
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("是否為本人？"),
                    Checkbox(
                      value: dataModel.isSelf,
                      onChanged: (val) {
                        dataModel.isSelf = val ?? false;
                        if (dataModel.isSelf) {
                          _relationController.text = "本人";
                        }
                        dataModel.update();
                      },
                    ),
                  ],
                ),
                _buildInfoRow("立切結書人姓名：", _signerController, "請輸入姓名"),
                _buildInfoRow("立切結書人身分證字號：", _signerIdController, "請輸入身分證字號"),
                _buildInfoRow(
                  "立切結書人與病患關係：",
                  _relationController,
                  "例如：本人、父母、配偶",
                ),
                _buildInfoRow("立切結書人地址：", _addressController, "請輸入地址"),
                _buildInfoRow("立切結書人電話：", _phoneController, "請輸入聯絡電話"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _todayTw() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}年${two(d.month)}月${two(d.day)}日';
  }
}
