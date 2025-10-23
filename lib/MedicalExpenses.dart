// lib/MedicalExpensesPage.dart (已根據您的美編規範進行修改)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/medical_costs_data.dart';
import 'l10n/app_translations.dart';
import 'nav2.dart';

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

  // 控制器維持不變
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

  // SavableStateMixin and Data Logic (saveData, _loadData, etc.) are unchanged
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

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<MedicalCostsDao>();
      final dataModel = context.read<MedicalCostsData>();
      final record = await dao.getByVisitId(widget.visitId);

      // 1. 先執行 clear() 來設定好所有欄位的預設值
      dataModel.clear();

      // 2. 如果資料庫有紀錄，才用紀錄中的值去覆蓋預設值
      if (record != null) {
        // 【關鍵修改】如果資料庫的值是 null，就使用 clear() 設定的預設值 '自付'
        dataModel.chargeMethod = record.chargeMethod ?? '自付';

        // 其他欄位的預設值本來就是 null，所以可以直接賦值
        dataModel.visitFee = record.visitFee;
        dataModel.ambulanceFee = record.ambulanceFee;
        dataModel.note = record.note;
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

  void _syncDataToControllers(MedicalCostsData dataModel) {
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

  Future<void> _saveData() async {
    final dao = context.read<MedicalCostsDao>();
    final dataModel = context.read<MedicalCostsData>();
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  void _syncControllersToData() {
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

  // Main Build method is unchanged
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
            child: ConstrainedBox(
              // Use ConstrainedBox to enforce maxWidth
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white, // As requested: 白色卡片
                  borderRadius: BorderRadius.circular(16), // As requested: 圓角16
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(
                        0,
                        0,
                        0,
                        0.08,
                      ), // As requested: 陰影柔和
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.medicalFeeForm,
                          style: const TextStyle(
                            fontSize: 20, // Slightly larger title
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF83ACA9,
                            ), // As requested
                            foregroundColor: Colors.white, // As requested
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
                      onChanged: (_) {
                        final dataModel = context.read<MedicalCostsData>();
                        dataModel.visitFee = _visitFeeController.text.trim();
                        dataModel.ambulanceFee = _ambulanceFeeController.text
                            .trim();
                        // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
                      },
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
                      onChanged: (_) {
                        final dataModel = context.read<MedicalCostsData>();
                        dataModel.visitFee = _visitFeeController.text.trim();
                        dataModel.ambulanceFee = _ambulanceFeeController.text
                            .trim();
                        // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
                      },
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
                    _SectionTitle(t.billingNotes),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: t.enterBillingNotesHint,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (_) {
                        final dataModel = context.read<MedicalCostsData>();
                        dataModel.visitFee = _visitFeeController.text.trim();
                        dataModel.ambulanceFee = _ambulanceFeeController.text
                            .trim();
                        // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.agreementStatementZh,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      t.agreementStatementEn,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSignatureButtons(t, dataModel),
                  ],
                ),
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
                  activeColor: const Color(0xFF274C4A), // As requested: 選中顏色
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

  Widget _buildConditionalFields(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    if (dataModel.chargeMethod == null) {
      return const SizedBox.shrink();
    }
    switch (dataModel.chargeMethod!) {
      case '自付':
        return _buildSelfPayFields(t, dataModel);
      case '統一請款':
        return _buildUnifiedBillingFields(t, dataModel);
      case '總院會核代收':
        return _buildHospitalCollectionFields(t, dataModel);
      case '收費異常':
        return _buildBillingErrorFields(t, dataModel);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSelfPayFields(AppTranslations t, MedicalCostsData dataModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SectionTitle(t.paymentMethod),
        Row(
          children: [
            Radio(
              value: '現金',
              groupValue: dataModel.paymentMethod,
              activeColor: const Color(0xFF274C4A), // As requested: 選中顏色
              onChanged: (v) {
                dataModel.paymentMethod = v;
                dataModel.update();
              },
            ),
            Text(t.cash),
            const SizedBox(width: 24),
            Radio(
              value: '刷卡',
              groupValue: dataModel.paymentMethod,
              activeColor: const Color(0xFF274C4A), // As requested: 選中顏色
              onChanged: (v) {
                dataModel.paymentMethod = v;
                dataModel.update();
              },
            ),
            Text(t.creditCard),
          ],
        ),
        if (dataModel.paymentMethod == '現金') _buildCurrencyFields(t, dataModel),
      ],
    );
  }

  // Other helper widgets are unchanged
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
        _SectionTitle(t.applicantName),
        TextField(
          controller: _applicantNameController,
          decoration: InputDecoration(
            hintText: t.enterApplicantNameHint,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) {
            final dataModel = context.read<MedicalCostsData>();
            dataModel.visitFee = _visitFeeController.text.trim();
            dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
            // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
          },
        ),
        const SizedBox(height: 16),
        _SectionTitle(t.applicantUnit),
        TextField(
          controller: _applicantUnitController,
          decoration: InputDecoration(
            hintText: t.enterApplicantUnitHint,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) {
            final dataModel = context.read<MedicalCostsData>();
            dataModel.visitFee = _visitFeeController.text.trim();
            dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
            // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
          },
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
          onChanged: (_) {
            final dataModel = context.read<MedicalCostsData>();
            dataModel.visitFee = _visitFeeController.text.trim();
            dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
            // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
          },
        ),
      ],
    );
  }

  Widget _buildHospitalCollectionFields(
    AppTranslations t,
    MedicalCostsData dataModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildPaymentStatusSelector(t, dataModel, showNotNeeded: false),
        _buildCurrencyFields(t, dataModel),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: Text(t.receiptIssuedAndTransferred),
          value: dataModel.receiptIssuedAndTransferred ?? false,
          activeColor: const Color(0xFF274C4A), // As requested: 選中顏色
          onChanged: (bool? value) {
            dataModel.receiptIssuedAndTransferred = value;
            dataModel.update();
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 16),
        _SectionTitle(t.erCounterSignature),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(t.signature)),
        ),
      ],
    );
  }

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
        _SectionTitle(t.billingErrorReason),
        TextField(
          controller: _billingErrorReasonController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: t.enterBillingErrorReasonHint,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) {
            final dataModel = context.read<MedicalCostsData>();
            dataModel.visitFee = _visitFeeController.text.trim();
            dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
            // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
          },
        ),
      ],
    );
  }

  Widget _buildPaymentStatusSelector(
    AppTranslations t,
    MedicalCostsData dataModel, {
    bool showNotNeeded = true,
  }) {
    final Map<String, String> statusOptions = {
      '尚未收款': t.paymentPending,
      '已收款': t.paymentReceived,
      if (showNotNeeded) '不需要': t.notNeeded,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.paymentStatus),
        Row(
          children: statusOptions.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: entry.key,
                  groupValue: dataModel.paymentStatus,
                  activeColor: const Color(0xFF274C4A), // As requested: 選中顏色
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
        _SectionTitle(t.selectCurrency),
        Row(
          children: currencies.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: entry.key,
                  groupValue: dataModel.selectedCurrency,
                  activeColor: const Color(0xFF274C4A), // As requested: 選中顏色
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
        if (dataModel.selectedCurrency != null &&
            dataModel.selectedCurrency != '台幣') ...[
          const SizedBox(height: 16),
          _SectionTitle(t.foreignCurrency),
          TextField(
            controller: _foreignCurrencyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: t.enterNumericValueHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              final dataModel = context.read<MedicalCostsData>();
              dataModel.visitFee = _visitFeeController.text.trim();
              dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
              // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
            },
          ),
          const SizedBox(height: 16),
          _SectionTitle(t.convertedTwdAmount),
          TextField(
            controller: _convertedTwdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: t.enterIntegerHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              final dataModel = context.read<MedicalCostsData>();
              dataModel.visitFee = _visitFeeController.text.trim();
              dataModel.ambulanceFee = _ambulanceFeeController.text.trim();
              // ❌ 不立即 notify，改在儲存前呼叫 dataModel.update()
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoTaker(MedicalCostsData dataModel) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picking
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
              backgroundColor: const Color(0xFF83ACA9), // As requested
              foregroundColor: Colors.white, // As requested
            ),
            onPressed: () {
              // TODO: Implement signature pad
            },
            child: Text(t.agreedBySignature),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF83ACA9), // As requested
              foregroundColor: Colors.white, // As requested
            ),
            onPressed: () {
              // TODO: Implement signature pad
            },
            child: Text(t.witnessSignature),
          ),
        ),
      ],
    );
  }
}

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
