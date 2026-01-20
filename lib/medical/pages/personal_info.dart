import 'package:flutter/material.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),

        const SizedBox(height: 32),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('拍照或選取護照照片 PASSPORT/ID PHOTO'),
                  const SizedBox(height: 10),
                  _buildPhotoUploadSection(),

                  const SizedBox(height: 24),
                  _buildLabel('患者姓名 PATIENT NAME'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: '請輸入患者姓名'),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('生日 DATE OF BIRTH'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              hint: 'YYYY/MM/DD',
                              suffixIcon: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('年齡 AGE'),
                            const SizedBox(height: 8),
                            _buildTextField(hint: '0'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildLabel('性別 GENDER'),
                  const SizedBox(height: 8),
                  const SlidingGenderToggle(),
                ],
              ),
            ),

            const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('護照/身分證字號 ID/PASSPORT NO.'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: '請輸入證件號碼',
                    suffixIcon: Icons.check_circle_outline,
                    suffixColor: Colors.green,
                  ),

                  const SizedBox(height: 24),
                  _buildLabel('國籍 NATIONALITY'),
                  const SizedBox(height: 8),
                  _buildDropdownField('請選取國籍'),

                  const SizedBox(height: 24),
                  _buildLabel('聯絡電話 CONTACT PHONE'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: '例如: +852 1234 5678'),

                  const SizedBox(height: 24),
                  _buildLabel('地址 ADDRESS'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: '請輸入詳細居住地址', maxLines: 4),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '個人資料 Personal Info',
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Please ensure patient details match their travel documents.',
              style: TextStyle(color: textMuted, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: bgField,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, color: textMuted, size: 28),
                Text(
                  'Preview',
                  style: TextStyle(color: textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _buildSmallButton(
                  Icons.camera_alt_outlined,
                  'Camera / 拍照',
                  true,
                ),
                const SizedBox(height: 8),
                _buildSmallButton(
                  Icons.folder_open_outlined,
                  'Gallery / 選取照片',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, String label, bool isPrimary) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isPrimary ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isPrimary ? primaryColor : borderColor),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: isPrimary ? Colors.white : textDark),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : textDark,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? suffixIcon,
    Color? suffixColor,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: suffixColor ?? textMuted, size: 20)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: textMuted),
          const SizedBox(width: 8),
          Text(
            hint,
            style: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 14),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
        ],
      ),
    );
  }
}

class SlidingGenderToggle extends StatefulWidget {
  const SlidingGenderToggle({super.key});

  @override
  State<SlidingGenderToggle> createState() => _SlidingGenderToggleState();
}

class _SlidingGenderToggleState extends State<SlidingGenderToggle> {
  int _selectedIndex = 0;
  final List<String> _options = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _getAlignment(),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(_options.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      _options[index],
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? const Color(0xFF007A8A)
                            : const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: _selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Alignment _getAlignment() {
    if (_selectedIndex == 0) return Alignment.centerLeft;
    if (_selectedIndex == 1) return Alignment.center;
    return Alignment.centerRight;
  }
}
