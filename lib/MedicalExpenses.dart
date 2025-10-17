// lib/MedicalExpensesPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/medical_costs_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
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
    if (!mounted) return;
    final t = AppTranslations.of(context); // 【新增】
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveMedicalFeeFailed}$e')),
        ); // 【修改】
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

    // ✅ 正確做法：直接呼叫您在 dataModel 中定義好的新方法
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  void _syncDataToControllers(MedicalCostsData dataModel) {
    _visitFeeController.text = dataModel.visitFee ?? '';
    _ambulanceFeeController.text = dataModel.ambulanceFee ?? '';
    _noteController.text = dataModel.note ?? '';
  }

  void _syncControllersToData() {
    final dataModel = context.read<MedicalCostsData>();
    dataModel.visitFee = _visitFeeController.text.trim();
    dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
    dataModel.note = _noteController.text.trim();
    dataModel.update();
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context); // 【新增】

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
                      Text(
                        t.medicalFeeForm, // 【修改】
                        style: const TextStyle(
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
                            title: Text(t.feeScheduleTitle), // 【修改】
                            content: Text(
                              t.feeScheduleContentPlaceholder,
                            ), // 【修改】
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(t.close), // 【修改】
                              ),
                            ],
                          ),
                        ),
                        child: Text(t.viewFeeSchedule), // 【修改】
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildChargeMethodSelector(t, dataModel), // 【修改】
                      ),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildPhotoTaker(dataModel)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(t.consultationFee), // 【修改】
                  TextField(
                    controller: _visitFeeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: t.enterAmountHint, // 【修改】
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(t.ambulanceFee), // 【修改】
                  TextField(
                    controller: _ambulanceFeeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: t.enterAmountHint, // 【修改】
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(t.totalFee), // 【修改】
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
                  _SectionTitle(t.billingNotes), // 【修改】
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: t.enterBillingNotesHint, // 【修改】
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.agreementStatementZh, // 【修改】
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    t.agreementStatementEn, // 【修改】
                    style: const TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _buildSignatureButtons(t, dataModel), // 【修改】
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

  Widget _buildChargeMethodSelector(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    // 【修改】動態建立翻譯後的選項列表
    final methods = {
      '自付': t.selfPay,
      '統一請款': t.unifiedBilling,
      '總院會核代收': t.hospitalCollection,
      '收費異常': t.billingError,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.chargeMethod), // 【修改】
        Column(
          children: methods.entries
              .map(
                (entry) => RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key, // Use original Chinese as key
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
    // ... (no changes needed here)
    return GestureDetector(
      onTap: () {
        // TODO: 串接拍照或上傳
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

  Widget _buildSignatureButtons(AppTranslations t, MedicalCostsData dataModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF83ACA9),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // TODO: 串接簽名板
            },
            child: Text(t.agreedBySignature), // 【修改】
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
              // TODO: 串接簽名板
            },
            child: Text(t.witnessSignature), // 【修改】
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
