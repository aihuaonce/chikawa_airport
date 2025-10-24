// ambulance_expenses_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart';

class AmbulanceExpensesPage extends StatefulWidget {
  final int visitId;
  const AmbulanceExpensesPage({super.key, required this.visitId});

  @override
  State<AmbulanceExpensesPage> createState() => _AmbulanceExpensesPageState();
}

class _AmbulanceExpensesPageState extends State<AmbulanceExpensesPage> {
  final _staffFeeController = TextEditingController();
  final _oxygenFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<AmbulanceData>();
    _staffFeeController.text = data.staffFee?.toString() ?? '';
    _oxygenFeeController.text = data.oxygenFee?.toString() ?? '';
  }

  @override
  void dispose() {
    _staffFeeController.dispose();
    _oxygenFeeController.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<AmbulanceData>();
    final staffFee = int.tryParse(_staffFeeController.text);
    final oxygenFee = int.tryParse(_oxygenFeeController.text);
    final totalFee = (staffFee ?? 0) + (oxygenFee ?? 0);

    data.updateExpenses(
      staffFee: staffFee,
      oxygenFee: oxygenFee,
      totalFee: totalFee,
    );
  }

  // 標題 + 方框輸入
  Widget _labeledInputRow({
    required String label,
    required TextEditingController controller,
    required String hint,
    double labelWidth = 130,
    double fieldWidth = 150,
    TextInputType keyboardType = TextInputType.number,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
          SizedBox(
            width: fieldWidth,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ).copyWith(hintText: hint),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // 標題 + 唯讀方框
  Widget _labeledReadOnlyBox({
    required String label,
    required String valueText,
    double labelWidth = 140,
    double fieldWidth = 160,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
          SizedBox(
            width: fieldWidth,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: valueText),
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String text,
    String? groupValue,
    Function(String?) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: text,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF274C4A),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        // keep controllers in sync
        final s = data.staffFee?.toString() ?? '';
        if (_staffFeeController.text != s) _staffFeeController.text = s;
        final o = data.oxygenFee?.toString() ?? '';
        if (_oxygenFeeController.text != o) _oxygenFeeController.text = o;

        final totalFee =
            (int.tryParse(_staffFeeController.text) ?? 0) +
            (int.tryParse(_oxygenFeeController.text) ?? 0);

        final chargeStatusOptions = [t.paid, t.collectedByLandseed, t.unpaid];
        final paidTypeOptions = [t.cash, t.creditCard];
        final unpaidTypeOptions = [t.accountsReceivable, t.remittance, t.unifiedBilling];

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Center(
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labeledInputRow(
                        label: t.ambulanceFeeWithStaff,
                        controller: _staffFeeController,
                        hint: t.enterIntegerHint,
                        labelWidth: 180,
                        onChanged: (_) {
                          setState(() {});
                          _saveToProvider();
                        },
                      ),
                      _labeledInputRow(
                        label: t.oxygenUsageFee,
                        controller: _oxygenFeeController,
                        hint: t.enterIntegerHint,
                        labelWidth: 120,
                        onChanged: (_) {
                          setState(() {});
                          _saveToProvider();
                        },
                      ),
                      _labeledReadOnlyBox(label: t.totalFee, valueText: '$totalFee',labelWidth: 70,fieldWidth: 120,),
                      const SizedBox(height: 8),

                      Text(t.chargeStatus,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        children: chargeStatusOptions
                            .map((opt) => _buildRadioOption(opt, data.chargeStatus, (val) {
                                  data.updateExpenses(
                                    chargeStatus: val,
                                    paidType: null,
                                    unpaidType: null,
                                  );
                                }))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      if (data.chargeStatus == t.paid) ...[
                        Text(t.paidMethod,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          children: paidTypeOptions
                              .map((opt) => _buildRadioOption(
                                    opt,
                                    data.paidType,
                                    (val) => data.updateExpenses(paidType: val),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                      ],

                      if (data.chargeStatus == t.unpaid) ...[
                        Text(t.unpaidReason,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          children: unpaidTypeOptions
                              .map((opt) => _buildRadioOption(
                                    opt,
                                    data.unpaidType,
                                    (val) => data.updateExpenses(unpaidType: val),
                                  ))
                              .toList(),
                        ),
                      ],
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
}
