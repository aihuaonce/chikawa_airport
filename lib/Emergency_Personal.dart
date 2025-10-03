import 'package:flutter/material.dart';

class EmergencyPersonalPage extends StatefulWidget {
  const EmergencyPersonalPage({super.key});

  @override
  State<EmergencyPersonalPage> createState() => _EmergencyPersonalPageState();
}

class _EmergencyPersonalPageState extends State<EmergencyPersonalPage> {
  final _idCtrl = TextEditingController();
  final _passportCtrl = TextEditingController();

  String? _gender;
  DateTime? _birthDate = DateTime(1983, 1, 1);

  @override
  void dispose() {
    _idCtrl.dispose();
    _passportCtrl.dispose();
    super.dispose();
  }

  // ===== 工具：日期 =====
  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDate(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';

  Future<void> _tapPickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1983, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ 不要 Scaffold / 不要 Nav4 外殼，這裡只做內容
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
                  _genderRadio('男'),
                  _genderRadio('女'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 出生日期（點文字可挑日期 + 今天）
            _rowTop(
              label: '出生日期',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _tapPickBirthDate,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Text(
                        _birthDate == null ? '請選擇日期' : _fmtDate(_birthDate!),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () =>
                          setState(() => _birthDate = DateTime.now()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        elevation: 0,
                      ),
                      child: const Text('今天', style: TextStyle(fontSize: 12.5)),
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
  }

  // ===== UI 小積木 =====

  // 白色卡片容器（和你其它頁一致的感覺）
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  // 標籤頂端對齊的 Row
  Widget _rowTop({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // 文字與輸入框頂端對齊
      children: [
        SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.only(top: 8), // 微調到跟輸入框上緣齊
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

  Widget _genderRadio(String value) {
    final selected = _gender == value;
    return InkWell(
      onTap: () => setState(() => _gender = value),
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
