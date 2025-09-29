// lib/MedicalExpensesPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/medical_costs_data.dart';
import 'nav2.dart'; // 為了使用 SavableStateMixin

class MedicalExpensesPage extends StatefulWidget {
  final int visitId;
  const MedicalExpensesPage({super.key, required this.visitId});

  @override
  State<MedicalExpensesPage> createState() => _MedicalExpensesPageState();
}

class _MedicalExpensesPageState extends State<MedicalExpensesPage>
    with
        AutomaticKeepAliveClientMixin<MedicalExpensesPage>,
        SavableStateMixin<MedicalExpensesPage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // 文字輸入框控制器
  final _visitFeeController = TextEditingController();
  final _ambulanceFeeController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _visitFeeController.dispose();
    _ambulanceFeeController.dispose();
    _noteController.dispose();
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
        ).showSnackBar(SnackBar(content: Text('儲存醫療費用失敗: $e')));
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
      final dao = context.read<MedicalCostsDao>();
      final dataModel = context.read<MedicalCostsData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null) {
        dataModel.chargeMethod = record.chargeMethod;
        dataModel.visitFee = record.visitFee;
        dataModel.ambulanceFee = record.ambulanceFee;
        dataModel.note = record.note;
        dataModel.photoPath = record.photoPath;
        dataModel.agreementSignaturePath = record.agreementSignaturePath;
        dataModel.witnessSignaturePath = record.witnessSignaturePath;
      }
      _syncDataToControllers(dataModel);
      dataModel.update();
    } catch (e) {
      // 錯誤處理
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<MedicalCostsDao>();
    final dataModel = context.read<MedicalCostsData>();
    await dao.upsertByVisitId(
      visitId: widget.visitId,
      chargeMethod: dataModel.chargeMethod,
      visitFee: dataModel.visitFee,
      ambulanceFee: dataModel.ambulanceFee,
      note: dataModel.note,
      photoPath: dataModel.photoPath,
      agreementSignaturePath: dataModel.agreementSignaturePath,
      witnessSignaturePath: dataModel.witnessSignaturePath,
    );
  }

  // 將 Model 資料同步到輸入框
  void _syncDataToControllers(MedicalCostsData dataModel) {
    _visitFeeController.text = dataModel.visitFee ?? '';
    _ambulanceFeeController.text = dataModel.ambulanceFee ?? '';
    _noteController.text = dataModel.note ?? '';
  }

  // 將輸入框的資料同步回 Model
  void _syncControllersToData() {
    final dataModel = context.read<MedicalCostsData>();
    dataModel.visitFee = _visitFeeController.text.trim();
    dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
    dataModel.note = _noteController.text.trim();
    // 當同步資料時，也順便通知 UI 更新總金額
    dataModel.update();
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<MedicalCostsData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 900,
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '醫療費用收費表',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF83ACA9),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('收費表'),
                            content: const Text('這裡可以顯示詳細收費表內容'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('關閉'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text('查看收費表'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildChargeMethodSelector(dataModel),
                      ),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildPhotoTaker(dataModel)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('出診費'),
                  TextField(
                    controller: _visitFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '輸入金額',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('救護車費用'),
                  TextField(
                    controller: _ambulanceFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '輸入金額',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('總費用'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFF1F3F6),
                    child: Text(
                      dataModel.totalFee.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('收費備註'),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: '請填寫收費備註',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '瞭解醫護人員說明明瞭醫療收費之後且同意',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const Text(
                    'Understand the medical charge and agree to it.',
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _buildSignatureButtons(dataModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===============================================
  // Helper Widgets
  // ===============================================

  Widget _buildChargeMethodSelector(MedicalCostsData dataModel) {
    final methods = ['自付', '統一請款', '總院會核代收', '收費異常'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('醫療費用收取方式'),
        Column(
          children: methods
              .map(
                (method) => RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: dataModel.chargeMethod,
                  activeColor: const Color(0xFF83ACA9),
                  onChanged: (v) {
                    dataModel.chargeMethod = v;
                    dataModel.update();
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPhotoTaker(MedicalCostsData dataModel) {
    // TODO: 這裡可以根據 dataModel.photoPath 顯示圖片
    return GestureDetector(
      onTap: () {
        // TODO: 串接拍照或上傳，然後更新 dataModel.photoPath
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(
          child: Icon(Icons.camera_alt, size: 48, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSignatureButtons(MedicalCostsData dataModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF83ACA9),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // TODO: 串接簽名板，然後更新 dataModel.agreementSignaturePath
            },
            child: const Text('同意人簽名/身份'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF83ACA9),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // TODO: 串接簽名板，然後更新 dataModel.witnessSignaturePath
            },
            child: const Text('見證人簽名/身份'),
          ),
        ),
      ],
    );
  }
}

// 共用的 Section Title
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
