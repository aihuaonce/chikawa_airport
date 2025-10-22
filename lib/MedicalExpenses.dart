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

  // 【修改】為新欄位新增文字輸入框控制器
  final _visitFeeController = TextEditingController();
  final _ambulanceFeeController = TextEditingController();
  final _noteController = TextEditingController();
  final _foreignCurrencyController = TextEditingController();
  final _convertedTwdController = TextEditingController();
  final _applicantNameController = TextEditingController();
  final _applicantUnitController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _billingErrorReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    // 【修改】釋放所有控制器
    _visitFeeController.dispose();
    _ambulanceFeeController.dispose();
    _noteController.dispose();
    _foreignCurrencyController.dispose();
    _convertedTwdController.dispose();
    _applicantNameController.dispose();
    _applicantUnitController.dispose();
    _contactPhoneController.dispose();
    _billingErrorReasonController.dispose();
    super.dispose();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${t.saveMedicalFeeFailed}$e')));
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
        // 【修改】載入所有欄位的資料
        // 注意：您需要在 MedicalCostsRecord (來自 aoo) 和 MedicalCostsData (您的 Provider Model)
        // 中都加入對應的屬性才能成功讀取和寫入
        dataModel.chargeMethod = record.chargeMethod;
        dataModel.visitFee = record.visitFee;
        dataModel.ambulanceFee = record.ambulanceFee;
        dataModel.note = record.note;

        // --- 新增欄位 ---
        dataModel.paymentMethod = record.paymentMethod;
        dataModel.paymentStatus = record.paymentStatus;
        dataModel.selectedCurrency = record.selectedCurrency;
        dataModel.foreignCurrencyAmount = record.foreignCurrencyAmount;
        dataModel.convertedTwdAmount = record.convertedTwdAmount;
        dataModel.applicantName = record.applicantName;
        dataModel.applicantUnit = record.applicantUnit;
        dataModel.contactPhone = record.contactPhone;
        dataModel.receiptIssuedAndTransferred =
            record.receiptIssuedAndTransferred;
        dataModel.billingErrorReason = record.billingErrorReason;
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
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  void _syncDataToControllers(MedicalCostsData dataModel) {
    // 【修改】同步所有資料到控制器
    _visitFeeController.text = dataModel.visitFee ?? '';
    _ambulanceFeeController.text = dataModel.ambulanceFee ?? '';
    _noteController.text = dataModel.note ?? '';
    _foreignCurrencyController.text = dataModel.foreignCurrencyAmount ?? '';
    _convertedTwdController.text = dataModel.convertedTwdAmount ?? '';
    _applicantNameController.text = dataModel.applicantName ?? '';
    _applicantUnitController.text = dataModel.applicantUnit ?? '';
    _contactPhoneController.text = dataModel.contactPhone ?? '';
    _billingErrorReasonController.text = dataModel.billingErrorReason ?? '';
  }

  void _syncControllersToData() {
    // 【修改】同步所有控制器資料回 dataModel
    final dataModel = context.read<MedicalCostsData>();
    dataModel.visitFee = _visitFeeController.text.trim();
    dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
    dataModel.note = _noteController.text.trim();
    dataModel.foreignCurrencyAmount = _foreignCurrencyController.text.trim();
    dataModel.convertedTwdAmount = _convertedTwdController.text.trim();
    dataModel.applicantName = _applicantNameController.text.trim();
    dataModel.applicantUnit = _applicantUnitController.text.trim();
    dataModel.contactPhone = _contactPhoneController.text.trim();
    dataModel.billingErrorReason = _billingErrorReasonController.text.trim();
    dataModel.update();
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

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
                  // ... (Header and Fee Schedule Button - no changes)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.medicalFeeForm,
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
                            title: Text(t.feeScheduleTitle),
                            content: Text(t.feeScheduleContentPlaceholder),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(t.close),
                              ),
                            ],
                          ),
                        ),
                        child: Text(t.viewFeeSchedule),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildChargeMethodSelector(t, dataModel),
                      ),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildPhotoTaker(dataModel)),
                    ],
                  ),

                  // 【新增】顯示對應欄位的輔助方法
                  _buildConditionalFields(t, dataModel),

                  const SizedBox(height: 16),
                  _SectionTitle(t.consultationFee),
                  TextField(
                    controller: _visitFeeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: t.enterAmountHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(t.ambulanceFee),
                  TextField(
                    controller: _ambulanceFeeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: t.enterAmountHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(t.totalFee),
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

                  // 【修改】將備註移到條件欄位的下方，使其成為共用欄位
                  _SectionTitle(t.billingNotes),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: t.enterBillingNotesHint,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (_) => _syncControllersToData(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.agreementStatementZh,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    t.agreementStatementEn,
                    style: const TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _buildSignatureButtons(t, dataModel),
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
    // ... (no changes)
    final methods = {
      '自付': t.selfPay,
      '統一請款': t.unifiedBilling,
      '總院會核代收': t.hospitalCollection,
      '收費異常': t.billingError,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.chargeMethod),
        Column(
          children: methods.entries
              .map(
                (entry) => RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key,
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

  // 【新增】主要的條件渲染方法
  Widget _buildConditionalFields(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    // 根據 dataModel 中的 chargeMethod 決定要顯示哪個 Widget
    switch (dataModel.chargeMethod) {
      case '自付':
        return _buildSelfPayFields(t, dataModel);
      case '統一請款':
        return _buildUnifiedBillingFields(t, dataModel);
      case '總院會核代收':
        return _buildHospitalCollectionFields(t, dataModel);
      case '收費異常':
        return _buildBillingErrorFields(t, dataModel);
      default:
        // 預設情況下不顯示任何額外欄位
        return const SizedBox.shrink();
    }
  }

  // 【新增】建立「自付」對應的欄位
  Widget _buildSelfPayFields(AppTranslations t, MedicalCostsData dataModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SectionTitle(t.paymentMethod), // t.paymentMethod = "自付方式"
        Row(
          children: [
            Radio(
              value: '現金',
              groupValue: dataModel.paymentMethod,
              onChanged: (v) {
                dataModel.paymentMethod = v;
                dataModel.update();
              },
            ),
            Text(t.cash), // t.cash = "現金"
            const SizedBox(width: 24),
            Radio(
              value: '刷卡',
              groupValue: dataModel.paymentMethod,
              onChanged: (v) {
                dataModel.paymentMethod = v;
                dataModel.update();
              },
            ),
            Text(t.creditCard), // t.creditCard = "刷卡"
          ],
        ),
        // 如果選擇了刷卡，才顯示貨幣相關欄位
        if (dataModel.paymentMethod == '刷卡') _buildCurrencyFields(t, dataModel),
      ],
    );
  }

  // 【新增】建立「統一請款」對應的欄位
  Widget _buildUnifiedBillingFields(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildPaymentStatusSelector(t, dataModel),
        _buildCurrencyFields(t, dataModel),
        const SizedBox(height: 16),
        _SectionTitle(t.applicantName), // t.applicantName = "申請人"
        TextField(
          controller: _applicantNameController,
          decoration: InputDecoration(
            hintText: t
                .enterApplicantNameHint, // t.enterApplicantNameHint = "請填寫申請人的姓名"
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _syncControllersToData(),
        ),
        const SizedBox(height: 16),
        _SectionTitle(t.applicantUnit), // t.applicantUnit = "申請單位"
        TextField(
          controller: _applicantUnitController,
          decoration: InputDecoration(
            hintText: t
                .enterApplicantUnitHint, // t.enterApplicantUnitHint = "請填寫申請單位"
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _syncControllersToData(),
        ),
        const SizedBox(height: 16),
        _SectionTitle(t.contactNumber),
        TextField(
          controller: _contactPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: t.enterContactNumber,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _syncControllersToData(),
        ),
      ],
    );
  }

  // 【新增】建立「總院急診代收」對應的欄位
  Widget _buildHospitalCollectionFields(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildPaymentStatusSelector(
          t,
          dataModel,
          showNotNeeded: false,
        ), // 此情境不顯示"不需要"選項
        _buildCurrencyFields(t, dataModel),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: Text(
            t.receiptIssuedAndTransferred,
          ), // t.receiptIssuedAndTransferred = "已開立收據並轉交"
          value: dataModel.receiptIssuedAndTransferred ?? false,
          onChanged: (bool? value) {
            dataModel.receiptIssuedAndTransferred = value;
            dataModel.update();
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 16),
        _SectionTitle(t.erCounterSignature), // t.erCounterSignature = "急診櫃台簽收名"
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(t.signature)), // t.signature = "簽章"
        ),
      ],
    );
  }

  // 【新增】建立「收費異常」對應的欄位
  Widget _buildBillingErrorFields(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildPaymentStatusSelector(t, dataModel),
        _buildCurrencyFields(t, dataModel),
        const SizedBox(height: 16),
        _SectionTitle(t.billingErrorReason), // t.billingErrorReason = "收費異常原因"
        TextField(
          controller: _billingErrorReasonController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: t
                .enterBillingErrorReasonHint, // t.enterBillingErrorReasonHint = "請填寫收費異常的原因"
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _syncControllersToData(),
        ),
      ],
    );
  }

  // 【新增】可重複使用的「收款狀態」選擇器
  Widget _buildPaymentStatusSelector(
    AppTranslations t,
    MedicalCostsData dataModel, {
    bool showNotNeeded = true,
  }) {
    // 建立選項 Map
    final Map<String, String> statusOptions = {
      '尚未收款': t.paymentPending, // t.paymentPending = "尚未收款"
      '已收款': t.paymentReceived, // t.paymentReceived = "已收款"
      if (showNotNeeded) '不需要': t.notNeeded, // t.notNeeded = "不需要"
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.paymentStatus), // t.paymentStatus = "收款狀態"
        Row(
          children: statusOptions.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: entry.key,
                  groupValue: dataModel.paymentStatus,
                  onChanged: (v) {
                    dataModel.paymentStatus = v;
                    dataModel.update();
                  },
                ),
                Text(entry.value),
                const SizedBox(width: 16),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // 【新增】可重複使用的「貨幣」相關欄位
  Widget _buildCurrencyFields(AppTranslations t, MedicalCostsData dataModel) {
    final Map<String, String> currencies = {
      '台幣': t.twd,
      '美金': t.usd,
      '人民幣': t.cny,
      '日幣': t.jpy,
      '加幣': t.cad,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SectionTitle(t.selectCurrency), // t.selectCurrency = "選擇貨幣"
        Row(
          children: currencies.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: entry.key,
                  groupValue: dataModel.selectedCurrency,
                  onChanged: (v) {
                    dataModel.selectedCurrency = v;
                    dataModel.update();
                  },
                ),
                Text(entry.value),
                const SizedBox(width: 16),
              ],
            );
          }).toList(),
        ),
        // 如果選擇的不是台幣，才顯示外幣和兌換金額
        if (dataModel.selectedCurrency != '台幣') ...[
          const SizedBox(height: 16),
          _SectionTitle(t.foreignCurrency), // t.foreignCurrency = "外幣"
          TextField(
            controller: _foreignCurrencyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText:
                  t.enterNumericValueHint, // t.enterNumericValueHint = "輸入數字"
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _syncControllersToData(),
          ),
          const SizedBox(height: 16),
          _SectionTitle(
            t.convertedTwdAmount,
          ), // t.convertedTwdAmount = "兌換後的台幣"
          TextField(
            controller: _convertedTwdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: t.enterIntegerHint, // t.enterIntegerHint = "輸入整數"
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _syncControllersToData(),
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoTaker(MedicalCostsData dataModel) {
    // ... (no changes)
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
    // ... (no changes)
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
            child: Text(t.agreedBySignature),
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
            child: Text(t.witnessSignature),
          ),
        ),
      ],
    );
  }
}

// ... (_SectionTitle - no changes)
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
