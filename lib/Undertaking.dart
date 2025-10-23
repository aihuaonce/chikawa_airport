// lib/UndertakingPage.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'data/db/daos.dart';
import 'data/models/undertaking_data.dart';
import 'nav2.dart';

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

  // Controllers 仍然存在於 Page 中，因為它們是 UI 元件的狀態
  final _signerController = TextEditingController();
  final _signerIdController = TextEditingController();
  final _relationController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // ✅ 簡化：在 initState 中註冊 controllers 並觸發載入
    // 使用 context.read 是因為在 initState 中我們只需要獲取一次 Provider 實例，不需要監聽
    final dataModel = context.read<UndertakingData>();
    dataModel.initControllers(
      signerController: _signerController,
      signerIdController: _signerIdController,
      relationController: _relationController,
      addressController: _addressController,
      phoneController: _phoneController,
    );
    _loadData();
  }

  @override
  void dispose() {
    _signerController.dispose();
    _signerIdController.dispose();
    _relationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    try {
      // ✅ 簡化：直接呼叫 Data Model 的儲存方法
      await context.read<UndertakingData>().saveToDatabase(
        widget.visitId,
        context.read<UndertakingsDao>(),
        context.read<VisitsDao>(),
      );
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
    // UI 層只關心 loading 狀態
    setState(() => _isLoading = true);
    try {
      // ✅ 簡化：所有複雜的載入邏輯都已移至 Data Model
      await context.read<UndertakingData>().loadDataForVisit(
        widget.visitId,
        undertakingDao: context.read<UndertakingsDao>(),
        visitsDao: context.read<VisitsDao>(),
        profileDao: context.read<PatientProfilesDao>(),
      );
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ===============================================
  // UI Build Method (幾乎不變，但邏輯更清晰)
  // ===============================================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final today = _formatDate(_selectedDate);

    return Consumer<UndertakingData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildEnglishSide(dataModel, today),
                        const SizedBox(width: 16),
                        _buildChineseSide(dataModel, today),
                      ],
                    ),
                  );
                } else {
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
          ),
        );
      },
    );
  }

  Widget _buildChineseSide(UndertakingData dataModel, String today) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 這些預覽文字現在會因為 Controller 的 listener 而即時更新
                Text("本人： ${dataModel.signerName ?? ""}"),
                const SizedBox(height: 8),
                Text("身分證字號： ${dataModel.signerId ?? ""}"),
                Text("$today 於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心醫師"),
                SizedBox(
                  width: 100,
                  child: DropdownButton<String>(
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
                      // ✅ 簡化：直接呼叫 Data Model 的方法
                      onChanged: (val) => dataModel.toggleIsSelf(val ?? false),
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

  // ... 其他 UI Helper Widgets (_buildEnglishSide, _buildSignatureArea, etc.) 保持不變 ...
  // (此處省略未變動的 UI 程式碼以節省篇幅)
  Widget _buildEnglishSide(UndertakingData dataModel, String today) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 8, // 陰影
        shadowColor: Colors.black26, // 陰影顏色
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Row(
                  children: [
                    const Text("Date: "),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(today, style: const TextStyle(fontSize: 14)),
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

  Widget _buildSignatureArea(UndertakingData dataModel) {
    if (dataModel.signatureBytes != null &&
        dataModel.signatureBytes!.isNotEmpty) {
      // 為了避免每次重建都重設簽名板，這裡直接使用已儲存的圖片
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

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}年${two(date.month)}月${two(date.day)}日';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('zh', 'TW'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
