import 'package:flutter/material.dart';

class AmbulancePersonalInfo extends StatefulWidget {
  final int medicalId;

  const AmbulancePersonalInfo({super.key, required this.medicalId});

  @override
  State<AmbulancePersonalInfo> createState() => _AmbulancePersonalInfoState();
}

class _AmbulancePersonalInfoState extends State<AmbulancePersonalInfo> {
  // 樣式顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Colors.white;

  // 狀態變數
  String? _selectedGender;
  bool _isHandled = false; // 控制是否經手的開關

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一排：性別 與 身分證字號
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '性別 GENDER',
                _buildDropdownField(
                  hint: '請選擇性別',
                  value: _selectedGender,
                  items: ['男 Male', '女 Female', '其他 Other'],
                  onChanged: (v) => setState(() => _selectedGender = v),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '身分證字號/護照號碼 ID/PASSPORT NO.',
                _buildTextField(hint: '輸入號碼'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：年齡 與 地址
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '年齡 AGE',
                _buildTextField(hint: '輸入年齡', isNumber: true),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '地址 ADDRESS',
                _buildTextField(hint: '輸入詳細居住地址'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第三排：病患財務明細
        _buildFieldWrapper(
          '病患財務明細 PATIENT\'S FINANCIAL DETAILS',
          _buildTextField(hint: '請列出經手的現金、貴重物品或其他物品...', maxLines: 4),
        ),

        const SizedBox(height: 24),

        // 第四排：是否有經手開關
        _buildFieldWrapper('是否有經手財務/隨身物品? HANDLED?', _buildToggleRow('開啟經手記錄')),

        // ===== 動態顯示區域：只有 _isHandled 為 true 時才出現 =====
        if (_isHandled) ...[
          // 保管人簽名
          if (_isHandled) ...[
            const SizedBox(height: 24),
            _buildFieldWrapper(
              '保管人姓名 CUSTODIAN NAME',
              _buildTextField(hint: '請輸入負責保管之人員姓名'),
            ),
            const SizedBox(height: 24),

            // 呼叫簽名元件
            _buildSignatureArea('保管人簽名 CUSTODIAN SIGNATURE', '請於此區域內進行數位簽署'),
          ],
        ],

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件實作 ---

  Widget _buildToggleRow(String label) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _isHandled ? primaryColor.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _isHandled ? primaryColor : borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: _isHandled ? primaryColor : textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: _isHandled,
            onChanged: (v) => setState(() => _isHandled = v),
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureArea(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 將標籤與清除按鈕放在同一行
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel(label), // 這裡呼叫原本的 Label 樣式
            TextButton.icon(
              onPressed: () {
                // TODO: 清除簽名邏輯
              },
              icon: const Icon(Icons.refresh, size: 14),
              label: const Text(
                '清除簽名 CLEAR',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 簽名板主體
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note,
                  color: textMuted.withValues(alpha: 0.3),
                  size: 40,
                ),
                const SizedBox(height: 4),
                Text(
                  placeholder,
                  style: TextStyle(
                    color: textMuted.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 基礎元件 ---

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 8), field],
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 14, color: textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
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
          hint: Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 20, color: textMuted),
          items: items
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
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
