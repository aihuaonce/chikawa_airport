import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyTreatmentRecord extends StatefulWidget {
  final int emergencyId;

  const EmergencyTreatmentRecord({super.key, required this.emergencyId});

  @override
  State<EmergencyTreatmentRecord> createState() =>
      _EmergencyTreatmentRecordState();
}

class _EmergencyTreatmentRecordState extends State<EmergencyTreatmentRecord> {
  // 樣式顏色
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // 控制器與狀態
  final TextEditingController _startTimeController = TextEditingController();
  String _leftPupilReaction = '+';
  String _rightPupilReaction = '+';
  String? _tempStatus;
  String? _intubationMethod;

  @override
  void initState() {
    super.initState();
    _startTimeController.text = DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 頂部基本資訊 (已移除總標題，直接從第一列開始)
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救開始時間 First Aid Start Time',
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        hint: 'HH:mm',
                        controller: _startTimeController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildNowButton(_startTimeController),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildFieldWrapper(
                '診斷 Diagnosis',
                _buildTextField(hint: '例如: Sudden Cardiac Arrest'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildFieldWrapper(
                '發生情境 Incident Context',
                _buildTextField(hint: '例如: Collapsed near gate'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),

        // 2. 病況 (標題字體加大)
        _buildSubTitle('病況 Patient Condition'),
        const SizedBox(height: 16),

        _buildLabel('GCS 指數評估'),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGcsBox('E'),
            const SizedBox(width: 8),
            _buildGcsBox('V'),
            const SizedBox(width: 8),
            _buildGcsBox('M'),
            const SizedBox(width: 8),
            _buildGcsBox('Total', isTotal: true),
            const Spacer(),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _buildPupilSection(
                '左瞳孔 Left Pupil',
                _leftPupilReaction,
                (v) => setState(() => _leftPupilReaction = v),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildPupilSection(
                '右瞳孔 Right Pupil',
                _rightPupilReaction,
                (v) => setState(() => _rightPupilReaction = v),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '心跳 Heart Rate (次/分)',
                _buildTextField(hint: 'BPM'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '呼吸 Respiration (次/分)',
                _buildTextField(hint: 'RR'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '血壓 Blood Pressure',
                _buildTextField(hint: 'mm/Hg'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '體溫/皮膚 Temp/Skin',
                _buildDropdownField(
                  hint: '選擇狀態',
                  value: _tempStatus,
                  items: ['溫暖 Warm', '冰冷 Cold'],
                  onChanged: (v) => setState(() => _tempStatus = v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 3. 插管 (標題字體加大)
        _buildColoredSection(
          title: '插管 Intubation',
          color: bgField,
          child: Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '開始時間',
                  _buildTextField(hint: 'HH:mm'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '插管方式',
                  _buildDropdownField(
                    hint: '選擇方式',
                    value: _intubationMethod,
                    items: ['ET', 'LMA', 'I-GEL', 'Failure'],
                    onChanged: (v) => setState(() => _intubationMethod = v),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '管號 Size',
                  _buildTextField(hint: 'Size'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '備註 Notes',
                  _buildTextField(hint: 'Remarks'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 4. 靜脈注射 (標題字體加大)
        _buildSubTitle('靜脈注射 IV Line'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper('開始時間', _buildTextField(hint: 'HH:mm')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '針頭尺寸 Needle Size',
                _buildTextField(hint: 'Gauge'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '記錄 Notes',
                _buildTextField(hint: 'Location/Status'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 5. 胸外按壓 (標題字體加大)
        _buildColoredSection(
          title: '胸外按壓 Cardiac Massage',
          icon: Icons.favorite,
          color: const Color(0xFFFEF2F2),
          titleColor: const Color(0xFFDC2626),
          child: Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '開始時間',
                  _buildTextField(hint: 'HH:mm'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '結束時間',
                  _buildTextField(hint: 'HH:mm'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '記錄 Notes',
                  _buildTextField(hint: 'CPR Outcome'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 元件實作 ---

  // 增大後的子章節標題
  Widget _buildSubTitle(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: primaryColor,
        fontSize: 15, // 從 11 增大至 15
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildColoredSection({
    required String title,
    required Widget child,
    required Color color,
    IconData? icon,
    Color titleColor = primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: titleColor, size: 18),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15, // 統一增大
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // 以下輔助元件保持不變
  Widget _buildGcsBox(String label, {bool isTotal = false}) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 50,
          decoration: BoxDecoration(
            color: isTotal
                ? primaryColor.withValues(alpha: 0.05)
                : Colors.white,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isTotal ? primaryColor : textMuted.withValues(alpha: 0.5),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPupilSection(
    String side,
    String currentReact,
    Function(String) onReact,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(side),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: ['+', '-', '±'].map((opt) {
                    bool isSel = currentReact == opt;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onReact(opt),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(hint: 'mm', textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNowButton(TextEditingController controller) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: () => setState(
          () => controller.text = DateFormat('HH:mm').format(DateTime.now()),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: primaryColor.withValues(alpha: 0.05),
          side: const BorderSide(color: primaryColor, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'NOW',
          style: TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
  );
  Widget _buildFieldWrapper(String label, Widget field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildLabel(label), const SizedBox(height: 6), field],
  );

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.start,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 13,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
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

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 13,
            ),
          ),
          items: items
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    s,
                    style: const TextStyle(fontSize: 14, color: textDark),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
