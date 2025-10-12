import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';

class EmergencyPersonalPage extends StatefulWidget {
  final int visitId;
  const EmergencyPersonalPage({super.key, required this.visitId});

  @override
  State<EmergencyPersonalPage> createState() => _EmergencyPersonalPageState();
}

class _EmergencyPersonalPageState extends State<EmergencyPersonalPage> {
  final _idCtrl = TextEditingController();
  final _passportCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 延遲載入初始資料
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

  // 儲存當前分頁的資料到 Provider
  void _saveToProvider() {
    final data = context.read<EmergencyData>();
    data.updatePersonal(
      idNumber: _idCtrl.text,
      passportNumber: _passportCtrl.text,
      gender: data.gender,
      birthDate: data.birthDate,
    );
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDate(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';

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
    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 身分證字號
                _rowTop(
                  label: '身分證字號',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: TextField(
                      controller: _idCtrl,
                      onChanged: (_) => _saveToProvider(),
                      decoration: const InputDecoration(
                        hintText: '請輸入身分證字號',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 性別
                _rowTop(
                  label: '性別',
                  child: Wrap(
                    spacing: 18,
                    children: [
                      _genderRadio('男', data),
                      _genderRadio('女', data),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 出生日期
                _rowTop(
                  label: '出生日期',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: _tapPickBirthDate,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 6),
                          child: Text(
                            data.birthDate == null
                                ? '請選擇日期'
                                : _fmtDate(data.birthDate!),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () =>
                              data.updatePersonal(birthDate: DateTime.now()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 0,
                          ),
                          child: const Text('今天',
                              style: TextStyle(fontSize: 12.5)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 護照號碼
                _rowTop(
                  label: '護照號碼',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: TextField(
                      controller: _passportCtrl,
                      onChanged: (_) => _saveToProvider(),
                      decoration: const InputDecoration(
                        hintText: '請輸入護照號碼',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _rowTop({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(child: Align(alignment: Alignment.topLeft, child: child)),
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
            color: selected ? const Color(0xFF274C4A) : Colors.black45,
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 15.5)),
        ],
      ),
    );
  }
}