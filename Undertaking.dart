// lib/UndertakingPage.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/db/daos.dart';
import 'data/models/undertaking_data.dart';
import 'l10n/app_translations.dart';
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
        final t = AppTranslations.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${t.saveUndertakingFailed}$e')));
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
    // 1. 取得所有需要的 DAO 和 Data Model
    final undertakingDao = context.read<UndertakingsDao>();
    final visitsDao = context.read<VisitsDao>();
    final dataModel = context.read<UndertakingData>();

    // 2. ✅ 正確做法：一行程式碼，呼叫您在 UndertakingData 中完美封裝好的方法
    await dataModel.saveToDatabase(widget.visitId, undertakingDao, visitsDao);
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

    final t = AppTranslations.of(context);
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
                    _buildEnglishSide(dataModel, today, t),
                    const SizedBox(width: 16),
                    _buildChineseSide(dataModel, today, t),
                  ],
                );
              }
              // 如果寬度不足，使用上下佈局並允許滾動
              else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEnglishSide(dataModel, today, t),
                      const SizedBox(height: 16),
                      _buildChineseSide(dataModel, today, t),
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

  Widget _buildEnglishSide(UndertakingData dataModel, String today, AppTranslations t) {
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
                  t.undertakingEnglishText(
                    dataModel.signerName ?? "",
                    dataModel.doctor ?? "",
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                Text(
                  t.signatureLabel,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildSignatureArea(dataModel, t),
                const SizedBox(height: 12),
                Text("${t.dateLabel} $today"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureArea(UndertakingData dataModel, AppTranslations t) {
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
              child: Text(t.resignButton),
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
                child: Text(t.rewriteButton),
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
                      ).showSnackBar(SnackBar(content: Text(t.signatureSaved)));
                  }
                },
                child: Text(t.confirmSignature),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildChineseSide(UndertakingData dataModel, String today, AppTranslations t) {
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
                Text("${t.undertakingPersonLabel} ${dataModel.signerName ?? ""}"),
                const SizedBox(height: 8),
                Text("${t.idNumberLabel} ${dataModel.signerId ?? ""}"),
                Text(t.undertakingChineseIntro(today, dataModel.doctor ?? "")),
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
                Text(t.undertakingChineseContent),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(t.isSelfQuestion),
                    Checkbox(
                      value: dataModel.isSelf,
                      onChanged: (val) {
                        dataModel.isSelf = val ?? false;
                        if (dataModel.isSelf) {
                          _relationController.text = t.selfRelation;
                        }
                        dataModel.update();
                      },
                    ),
                  ],
                ),
                _buildInfoRow(t.undertakingSignerName, _signerController, t.enterSignerName),
                _buildInfoRow(t.undertakingSignerId, _signerIdController, t.enterSignerIdNumber),
                _buildInfoRow(
                  t.undertakingSignerRelation,
                  _relationController,
                  t.enterRelationExample,
                ),
                _buildInfoRow(t.undertakingSignerAddress, _addressController, t.enterSignerAddress),
                _buildInfoRow(t.undertakingSignerPhone, _phoneController, t.enterSignerPhone),
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