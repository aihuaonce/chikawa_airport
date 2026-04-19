import 'dart:typed_data';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/signature_field.dart';
import '../widgets/reference_search_sheet.dart';
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';

class MedicalFees extends StatefulWidget {
  final int medicalId;

  const MedicalFees({super.key, required this.medicalId});

  @override
  State<MedicalFees> createState() => _MedicalFeesState();
}

class _MedicalFeesState extends State<MedicalFees> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  AppDatabase? _db;
  ReferenceService? _refService;
  MedicalFeeData? _fee;
  bool _isLoading = true;

  // 備註控制器
  final TextEditingController _remarksController = TextEditingController();
  // 申請人資訊控制器
  final TextEditingController _applicantNameController =
      TextEditingController();
  final TextEditingController _applicantUnitController =
      TextEditingController();
  final TextEditingController _applicantPhoneController =
      TextEditingController();
  // 異常原因控制器
  final TextEditingController _abnormalReasonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final db = context.read<AppDatabase>();
      final refService = context.read<ReferenceService>();

      var fee = await db.medicalFeeDao.getFeeByMedicalId(widget.medicalId);

      if (fee == null) {
        debugPrint('系統：醫療費用記錄不存在，建立預設記錄');
        await db.medicalFeeDao.createFee(widget.medicalId);
        fee = await db.medicalFeeDao.getFeeByMedicalId(widget.medicalId);
      }

      if (mounted) {
        setState(() {
          _db = db;
          _refService = refService;
          _fee = fee;
          _remarksController.text = fee?.remarks ?? '';
          _applicantNameController.text = fee?.applicantName ?? '';
          _applicantUnitController.text = fee?.applicantUnit ?? '';
          _applicantPhoneController.text = fee?.applicantPhone ?? '';
          _abnormalReasonController.text = fee?.abnormalReason ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading medical fees data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 更新費用並重新載入（用於非文字輸入的更新）
  void _updateFeeWithReload(Future<void> Function(int feeId) updateFn) async {
    if (_fee == null || _db == null) return;
    await updateFn(_fee!.feeId);
    await _loadData();
  }

  // 直接更新費用（用於文字輸入，不重新載入）
  void _updateFeeNoReload(Future<void> Function(int feeId) updateFn) async {
    if (_fee == null || _db == null) return;
    await updateFn(_fee!.feeId);
  }

  // 更新費用（通用方法，等同於 _updateFeeNoReload）
  void _updateFee(Future<void> Function(int feeId) updateFn) async {
    if (_fee == null || _db == null) return;
    await updateFn(_fee!.feeId);
  }

  // 防火牆更新（不等待資料庫，適用於點擊交互）
  void _updateFeeFireAndForget(Future<void> Function(int feeId) updateFn) {
    if (_fee == null || _db == null) return;
    updateFn(_fee!.feeId);
    // 延後重新載入，確保 UI 立即回應
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _loadData();
    });
  }

  // 立即更新本地狀態（用於簽名等需要立即顯示的欄位）
  void _updateLocalState({
    double? consultFee,
    double? ambulanceFee,
    int? paymentMethodId,
    String? paymentType,
    int? currencyId,
    int? collectionStatusId,
    bool? receiptIssued,
    bool? userAgreed,
    String? applicantName,
    String? applicantUnit,
    String? applicantPhone,
    String? remarks,
    Uint8List? consenterSignature,
    Uint8List? witnessSignature,
    Uint8List? counterSignature,
    String? abnormalReason,
  }) {
    if (_fee == null) return;

    debugPrint(
      '_updateLocalState called: consenterSignature=${consenterSignature?.length}, witnessSignature=${witnessSignature?.length}, userAgreed=$userAgreed',
    );

    // 直接更新 _fee 並觸發 setState
    setState(() {
      _fee = MedicalFeeData(
        feeId: _fee!.feeId,
        medicalId: _fee!.medicalId,
        paymentMethodId: paymentMethodId ?? _fee!.paymentMethodId,
        paymentType: paymentType ?? _fee!.paymentType,
        consultFee: consultFee ?? _fee!.consultFee,
        ambulanceFee: ambulanceFee ?? _fee!.ambulanceFee,
        currencyId: currencyId ?? _fee!.currencyId,
        collectionStatusId: collectionStatusId ?? _fee!.collectionStatusId,
        receiptIssued: receiptIssued ?? _fee!.receiptIssued,
        userAgreed: userAgreed ?? _fee!.userAgreed,
        applicantName: applicantName ?? _fee!.applicantName,
        applicantUnit: applicantUnit ?? _fee!.applicantUnit,
        applicantPhone: applicantPhone ?? _fee!.applicantPhone,
        abnormalReason: abnormalReason ?? _fee!.abnormalReason,
        remarks: remarks ?? _fee!.remarks,
        consenterSignature: consenterSignature ?? _fee!.consenterSignature,
        witnessSignature: witnessSignature ?? _fee!.witnessSignature,
        counterSignature: counterSignature ?? _fee!.counterSignature,
        createdAt: _fee!.createdAt,
        syncStatus: _fee!.syncStatus,
        remoteId: _fee!.remoteId,
        lastModified: _fee!.lastModified,
      );
    });
    debugPrint(
      'setState done, _fee.consenterSignature=${_fee!.consenterSignature?.length}',
    );

    // 異步更新資料庫
    if (_db == null) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _fee != null) _loadData();
    });
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _applicantNameController.dispose();
    _applicantUnitController.dispose();
    _applicantPhoneController.dispose();
    _abnormalReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_fee == null) {
      return const Center(child: Text('No fee data'));
    }

    final fee = _fee!;
    final totalAmount = (fee.consultFee ?? 0) + (fee.ambulanceFee ?? 0);

    // 取得參考資料
    final paymentMethods = _refService?.paymentMethodList ?? [];
    final collectionStatuses = _refService?.collectionStatusList ?? [];
    final currencies = _refService?.currencyList ?? [];

    // 解析選中的付款方式
    final selectedPaymentMethod = fee.paymentMethodId != null
        ? paymentMethods.firstWhere(
            (m) => m.id == fee.paymentMethodId,
            orElse: () => paymentMethods.first,
          )
        : paymentMethods.first;

    // 解析收款狀態
    final selectedCollectionStatus = fee.collectionStatusId != null
        ? collectionStatuses.firstWhere(
            (s) => s.id == fee.collectionStatusId,
            orElse: () => collectionStatuses.first,
          )
        : collectionStatuses.first;

    // 解析貨幣
    final selectedCurrency = fee.currencyId != null
        ? currencies.firstWhere(
            (c) => c.id == fee.currencyId,
            orElse: () => currencies.firstWhere(
              (c) => c.code == 'TWD',
              orElse: () => currencies.first,
            ),
          )
        : currencies.firstWhere(
            (c) => c.code == 'TWD',
            orElse: () => currencies.first,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('付款方式 Payment Method'),
        const SizedBox(height: 8),
        _buildMainPaymentMethodSelector(paymentMethods, selectedPaymentMethod),
        const SizedBox(height: 16),

        // 狀態/類型切換
        _buildDynamicConditionSection(
          selectedPaymentMethod,
          fee.paymentType ?? '現金',
          selectedCollectionStatus,
          collectionStatuses,
        ),

        // 根據付款方式出現的額外資訊
        _buildExtraInfoFields(
          selectedPaymentMethod,
          fee,
          currencies,
          selectedCurrency,
        ),

        const SizedBox(height: 24),

        // 費用輸入
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '出診費 Consultation Fee',
                _buildNumberField(
                  initialValue: fee.consultFee ?? 0,
                  onChanged: (v) {
                    _updateLocalState(consultFee: v);
                    _updateFeeFireAndForget(
                      (feeId) => _db!.medicalFeeDao.updateConsultFee(feeId, v),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '救護車費用 Ambulance Fee',
                _buildNumberField(
                  initialValue: fee.ambulanceFee ?? 0,
                  onChanged: (v) {
                    _updateLocalState(ambulanceFee: v);
                    _updateFeeFireAndForget(
                      (feeId) =>
                          _db!.medicalFeeDao.updateAmbulanceFee(feeId, v),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        _buildLabel('總費用 Total Amount'),
        const SizedBox(height: 8),
        _buildTotalAmountBadge(totalAmount, selectedCurrency),
        const SizedBox(height: 24),

        _buildFieldWrapper(
          '收費備註 Fee Remarks',
          _buildTextField(
            hint: '請輸入收費相關備註...',
            maxLines: 3,
            controller: _remarksController,
            onChanged: (v) => _updateFee(
              (feeId) => _db!.medicalFeeDao.updateRemarks(feeId, v),
            ),
          ),
        ),
        const SizedBox(height: 24),

        _buildConsentBox(fee.userAgreed ?? false),
        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: _buildSignatureSection(
                '同意人簽名 Consenter Signature',
                fee.consenterSignature,
                (data) {
                  debugPrint('同意人簽名 callback: data=${data.length}');
                  _updateLocalState(consenterSignature: data);
                  _updateFeeFireAndForget(
                    (feeId) => _db!.medicalFeeDao.updateConsenterSignature(
                      feeId,
                      data,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSignatureSection(
                '見證人簽名 Witness Signature',
                fee.witnessSignature,
                (data) {
                  debugPrint('見證人簽名 callback: data=${data.length}');
                  _updateLocalState(witnessSignature: data);
                  _updateFeeFireAndForget(
                    (feeId) =>
                        _db!.medicalFeeDao.updateWitnessSignature(feeId, data),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildDynamicConditionSection(
    PaymentMethodData selectedPaymentMethod,
    String selfPayType,
    CollectionStatusData selectedCollectionStatus,
    List<CollectionStatusData> collectionStatuses,
  ) {
    final paymentMethodName = selectedPaymentMethod.name;

    switch (paymentMethodName) {
      case '自付':
        return _buildFieldWrapper(
          '自付方式 Payment Type',
          _buildSegmentedControl(['現金', '刷卡'], selfPayType, (v) {
            _updateLocalState(paymentType: v);
            _updateFeeFireAndForget(
              (feeId) => _db!.medicalFeeDao.updatePaymentType(feeId, v),
            );
          }),
        );
      case '統一請款':
      case '收費異常':
        final statuses = collectionStatuses
            .where(
              (s) => s.name == '尚未收款' || s.name == '已收款' || s.name == '不需要',
            )
            .toList();
        final currentStatusId = selectedCollectionStatus.id;

        return _buildFieldWrapper(
          '收款狀態 Status',
          _buildIdSegmentedControl(statuses, currentStatusId, (id) {
            _updateLocalState(collectionStatusId: id);
            _updateFeeFireAndForget(
              (feeId) => _db!.medicalFeeDao.updateCollectionStatus(feeId, id),
            );
          }),
        );
      case '總院會核代收':
        final statuses = collectionStatuses
            .where((s) => s.name == '尚未收款' || s.name == '已收款')
            .toList();
        final currentStatusId = selectedCollectionStatus.id;

        return _buildFieldWrapper(
          '收款狀態 Status',
          _buildIdSegmentedControl(statuses, currentStatusId, (id) {
            _updateLocalState(collectionStatusId: id);
            _updateFeeFireAndForget(
              (feeId) => _db!.medicalFeeDao.updateCollectionStatus(feeId, id),
            );
          }),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildExtraInfoFields(
    PaymentMethodData selectedPaymentMethod,
    MedicalFeeData fee,
    List<CurrencyRefData> currencies,
    CurrencyRefData selectedCurrency,
  ) {
    final paymentMethodName = selectedPaymentMethod.name;
    final selfPayType = fee.paymentType ?? '現金';

    bool showCurrency =
        (paymentMethodName == '自付' && selfPayType == '現金') ||
        (paymentMethodName != '自付');

    // 如果沒有任何額外資訊要顯示，直接回傳空元件
    if (!showCurrency && paymentMethodName == '自付') return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showCurrency)
                Expanded(
                  child: _buildFieldWrapper(
                    '選擇貨幣 Currency',
                    _buildCurrencyDropdown(currencies, selectedCurrency),
                  ),
                ),
              if (showCurrency &&
                  (paymentMethodName == '統一請款' ||
                      paymentMethodName == '總院會核代收'))
                const SizedBox(width: 16),

              if (paymentMethodName == '統一請款')
                Expanded(
                  child: _buildFieldWrapper(
                    '申請人 Applicant',
                    _buildTextField(
                      hint: '輸入姓名',
                      controller: _applicantNameController,
                      onChanged: (v) => _updateFee(
                        (feeId) => _db!.medicalFeeDao.updateApplicantInfo(
                          feeId,
                          name: v,
                          unit: _applicantUnitController.text,
                          phone: _applicantPhoneController.text,
                        ),
                      ),
                    ),
                  ),
                )
              else if (paymentMethodName == '總院會核代收')
                Expanded(
                  child: _buildReceiptIssuedToggle(fee.receiptIssued ?? false),
                )
              else if (showCurrency && paymentMethodName != '自付')
                Expanded(child: const SizedBox()),
            ],
          ),
          if (paymentMethodName == '統一請款') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFieldWrapper(
                    '申請單位 Unit',
                    _buildTextField(
                      hint: '輸入單位名稱',
                      controller: _applicantUnitController,
                      onChanged: (v) => _updateFee(
                        (feeId) => _db!.medicalFeeDao.updateApplicantInfo(
                          feeId,
                          name: _applicantNameController.text,
                          unit: v,
                          phone: _applicantPhoneController.text,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '聯絡電話 Phone',
                    _buildTextField(
                      hint: '輸入聯絡電話',
                      controller: _applicantPhoneController,
                      onChanged: (v) => _updateFee(
                        (feeId) => _db!.medicalFeeDao.updateApplicantInfo(
                          feeId,
                          name: _applicantNameController.text,
                          unit: _applicantUnitController.text,
                          phone: v,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (paymentMethodName == '總院會核代收') ...[
            const SizedBox(height: 24),
            _buildLabel('緊急醫療救護人員簽章 Emergency Counter Signature Area'),
            const SizedBox(height: 8),
            SignatureField(
              key: ValueKey(
                'signature_counter_${fee.counterSignature?.length ?? 0}',
              ),
              placeholder: '點擊簽名',
              value: fee.counterSignature,
              onChanged: (data) {
                _updateLocalState(counterSignature: data);
                _updateFeeFireAndForget(
                  (feeId) =>
                      _db!.medicalFeeDao.updateCounterSignature(feeId, data),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
          if (paymentMethodName == '收費異常') ...[
            const SizedBox(height: 16),
            _buildFieldWrapper(
              '收費異常原因 Reason',
              _buildTextField(
                hint: '請說明收費異常原因...',
                maxLines: 2,
                controller: _abnormalReasonController,
                onChanged: (v) => _updateFee(
                  (feeId) => _db!.medicalFeeDao.updateAbnormalReason(feeId, v),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 貨幣下拉選單
  Widget _buildCurrencyDropdown(
    List<CurrencyRefData> currencies,
    CurrencyRefData currentCurrency,
  ) {
    final text = '${currentCurrency.code} - ${currentCurrency.name}';

    return _buildSelectionField(
      text: text,
      hint: '選擇貨幣',
      icon: Icons.monetization_on_outlined,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<CurrencyRefData>(
          context,
          title: '選擇貨幣',
          searchFunction: (q) async => currencies
              .where((c) => c.name.contains(q) || c.code.contains(q))
              .toList(),
          initialSelection: currentCurrency,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                '${item.code} - ${item.name}',
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          _updateFeeWithReload(
            (feeId) => _db!.medicalFeeDao.updateCurrency(feeId, result.id),
          );
        }
      },
    );
  }

  Widget _buildSelectionField({
    required String text,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text.isNotEmpty ? text : hint,
                style: TextStyle(
                  color: text.isNotEmpty
                      ? textDark
                      : textMuted.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: textMuted),
          ],
        ),
      ),
    );
  }

  // 修正對齊問題的收據勾選組件
  Widget _buildReceiptIssuedToggle(bool isIssued) {
    return InkWell(
      onTap: () {
        _updateLocalState(receiptIssued: !isIssued);
        _updateFeeFireAndForget(
          (feeId) => _db!.medicalFeeDao.updateReceiptIssued(feeId, !isIssued),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isIssued ? primaryColor.withValues(alpha: 0.05) : Colors.white,
          border: Border.all(color: isIssued ? primaryColor : borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isIssued ? Icons.check_box : Icons.check_box_outline_blank,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '已開立收據並轉交',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmountBadge(double amount, CurrencyRefData currency) {
    return Container(
      height: 54,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            currency.symbol ?? 'NT\$',
            style: const TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount.toStringAsFixed(0),
            style: const TextStyle(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  // 付款方式選擇器
  Widget _buildMainPaymentMethodSelector(
    List<PaymentMethodData> methods,
    PaymentMethodData currentMethod,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: methods.map((m) {
          bool isSel = currentMethod.id == m.id;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _updateLocalState(paymentMethodId: m.id);
                _updateFeeFireAndForget((feeId) async {
                  await _db!.medicalFeeDao.clearPaymentMethodSpecificData(
                    feeId,
                  );
                  await _db!.medicalFeeDao.updatePaymentMethod(feeId, m.id);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSel
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  m.name,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNumberField({
    required Function(double) onChanged,
    double initialValue = 0,
  }) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        initialValue: initialValue % 1 == 0
            ? initialValue.toInt().toString()
            : initialValue.toString(),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        onChanged: (v) {
          double value = double.tryParse(v) ?? 0;
          onChanged(value);
        },
        decoration: InputDecoration(
          prefixText: r'$ ',
          prefixStyle: const TextStyle(
            color: textMuted,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSel = current == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ID 版本的 SegmentedControl - 用於收款狀態
  Widget _buildIdSegmentedControl(
    List<CollectionStatusData> options,
    int? currentId,
    Function(int?) onSelect,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSel = currentId == opt.id;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt.id),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt.name,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConsentBox(bool isAgreed) {
    Color activeCol = isAgreed ? primaryColor : Colors.grey;

    return InkWell(
      onTap: () {
        _updateLocalState(userAgreed: !isAgreed);
        _updateFeeFireAndForget(
          (feeId) => _db!.medicalFeeDao.updateUserAgreed(feeId, !isAgreed),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: activeCol.withValues(alpha: 0.05),
          border: Border.all(color: activeCol.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isAgreed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: activeCol,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '了解醫護人員說明需醫療收費之緣由且同意',
                    style: TextStyle(
                      color: activeCol,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'I understand the explanation of the medical charges and agree to them.',
                    style: TextStyle(
                      color: activeCol.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureSection(
    String label,
    Uint8List? value,
    Function(Uint8List) onChanged,
  ) {
    final isConsenter = label.contains('同意人');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        // 使用 key 強制在 value 改變時重建
        SignatureField(
          key: ValueKey('signature_${label}_${value?.length ?? 0}'),
          placeholder: '點擊簽名',
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 6), field],
    );
  }
}
