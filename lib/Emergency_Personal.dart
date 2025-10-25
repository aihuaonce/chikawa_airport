import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart';

class EmergencyPersonalPage extends StatefulWidget {
  final int visitId;
  const EmergencyPersonalPage({super.key, required this.visitId});

  @override
  State<EmergencyPersonalPage> createState() => _EmergencyPersonalPageState();
}

class _EmergencyPersonalPageState extends State<EmergencyPersonalPage> {
  final _idCtrl = TextEditingController();
  final _passportCtrl = TextEditingController();

  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _lightGreen = Color(0xFF83ACA9);
  static const Color _border = Color(0xFFCBD5E1);

  static const double _labelMinW = 84;
  static const double _labelMaxW = 108;
  static const double _labelGap = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<EmergencyData>();
    _idCtrl.text = data.idNumber ?? '';
    _passportCtrl.text = data.passportNumber ?? '';
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _passportCtrl.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<EmergencyData>();
    data.updatePersonal(
      idNumber: _idCtrl.text,
      passportNumber: _passportCtrl.text,
      gender: data.gender,
      birthDate: data.birthDate,
    );
  }

  // 【修改】移除本地的日期格式化方法，將使用 AppTranslations 中的版本
  // String _two(int n) => n.toString().padLeft(2, '0');
  // String _fmtDate(DateTime dt) => ...

  Future<void> _tapPickBirthDate() async {
    final data = context.read<EmergencyData>();
    final picked = await showDatePicker(
      context: context,
      initialDate: data.birthDate ?? DateTime(1983, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      data.updatePersonal(birthDate: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ), // ✅ 卡片寬度固定 800
                child: _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _rowTop(
                        label: t.idNumber,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                          ), // ✅ 輸入框變短
                          child: TextField(
                            controller: _idCtrl,
                            onChanged: (_) => _saveToProvider(),
                            decoration: InputDecoration(
                              hintText: t.enterIdNumber,
                              isDense: true,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _rowTop(
                        label: t.gender,
                        child: Wrap(
                          spacing: 18,
                          children: [
                            _genderRadio(t.male, data),
                            _genderRadio(t.female, data),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      _rowTop(
                        label: t.birthDate,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: _tapPickBirthDate,
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                                child: Text(
                                  data.birthDate == null
                                      ? t.selectDate
                                      : t.formatDate(data.birthDate!),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () => data.updatePersonal(
                                  birthDate: DateTime.now(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _lightGreen, // ✅ 淺綠色
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  t.today,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      _rowTop(
                        label: t.passportNumber,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: TextField(
                            controller: _passportCtrl,
                            onChanged: (_) => _saveToProvider(),
                            decoration: InputDecoration(
                              hintText: t.enterPassportNumber,
                              isDense: true,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rowTop({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: _labelMinW,
            maxWidth: _labelMaxW,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: _labelGap),
        Expanded(
          child: Align(alignment: Alignment.topLeft, child: child),
        ),
      ],
    );
  }

  Widget _genderRadio(String value, EmergencyData data) {
    final selected = data.gender == value;
    return InkWell(
      onTap: () => data.updatePersonal(gender: value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 20,
            color: selected ? _deepGreen : Colors.black45,
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 15.5)),
        ],
      ),
    );
  }
}
