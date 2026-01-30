import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NursingRecord extends StatefulWidget {
  final int medicalId;
  const NursingRecord({super.key, required this.medicalId});

  @override
  State<NursingRecord> createState() => _NursingRecordState();
}

class _NursingRecordState extends State<NursingRecord> {
  // 樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // 資料列表
  final List<Map<String, dynamic>> _records = [];
  final List<String> _nurseOptions = ['N1', 'N2', 'N3', 'N4'];

  // 預設片語
  final Map<String, String> _phraseTemplates = {
    '接獲通知': '接獲[通報單位][通報人員]通報位於[事故地點]有旅客[主訴]身體不適，需要醫護出診協助。',
    '通知1': '通知T1-OCC。',
    '通知2': '通知T2-OCC。',
    '抵達現場': '抵達現場，病人意識清楚...自述撕裂傷，醫師診療評估中。',
    '測血糖': '依醫囑執行測血糖,血糖值：[]。',
    '診斷給藥': '醫師診視後，診斷為[初步診斷]，向病人解釋後開立[藥物]使用並衛教。',
    '轉診': '醫師診視後，建議轉診至醫院進一步檢查及治療，表示同意，通知航空公司協助退關。',
    '收費': '向病人及家屬解釋費用[]元，採[方式]支付，開立收據一份。',
    '返回待命': '返回醫療中心待命。',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 頂部：新增按鈕 (右對齊)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _showAddRecordModal(),
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: const Text(
              '新增護理記錄',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              backgroundColor: primaryColor.withValues(alpha: 0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 內嵌式編輯表格
        _buildInlineTable(),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- 1. 內嵌式表格 (參考健康評估表樣式) ---
  Widget _buildInlineTable() {
    if (_records.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: const Center(
          child: Text('尚無護理記錄，請點擊新增', style: TextStyle(color: textMuted)),
        ),
      );
    }

    return Column(
      children: [
        // 表頭
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildTableLabel('記錄時間')),
              const SizedBox(width: 12),
              Expanded(flex: 5, child: _buildTableLabel('記錄內容')),
              const SizedBox(width: 12),
              SizedBox(width: 100, child: _buildTableLabel('護理師')),
              const SizedBox(width: 12),
              SizedBox(width: 40, child: _buildTableLabel('簽名')),
              const SizedBox(width: 40),
            ],
          ),
        ),
        // 資料行
        ..._records.asMap().entries.map((entry) {
          int idx = entry.key;
          var data = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 記錄時間編輯
                Expanded(
                  flex: 2,
                  child: _buildInlineTextField(
                    initialValue: data['time'],
                    onChanged: (val) => data['time'] = val,
                  ),
                ),
                const SizedBox(width: 12),
                // 內容編輯
                Expanded(
                  flex: 5,
                  child: _buildInlineTextField(
                    initialValue: data['content'],
                    maxLines: null,
                    onChanged: (val) => data['content'] = val,
                  ),
                ),
                const SizedBox(width: 12),
                // 護理師代號
                SizedBox(
                  width: 100,
                  child: _buildInlineDropdown(
                    value: data['nurse'],
                    onChanged: (val) => setState(() => data['nurse'] = val),
                  ),
                ),
                const SizedBox(width: 12),
                // 簽名狀態圖示
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.verified_user_rounded,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                // 刪除按鈕
                IconButton(
                  onPressed: () => setState(() => _records.removeAt(idx)),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.red.withValues(alpha: 0.5),
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // --- 2. 新增記錄彈窗 ---
  void _showAddRecordModal() {
    String? tempSelectedPhrase;
    String? tempNurse;
    final TextEditingController timeCtrl = TextEditingController(
      text: DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
    );
    final TextEditingController contentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '新增護理記錄',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 片語選擇 (單選)
                    _buildLabel('快捷片語 (單選帶入內容)'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _phraseTemplates.keys.map((key) {
                        bool isSel = tempSelectedPhrase == key;
                        return ChoiceChip(
                          label: Text(key),
                          selected: isSel,
                          onSelected: (selected) {
                            setModalState(() {
                              tempSelectedPhrase = selected ? key : null;
                              if (selected)
                                contentCtrl.text = _phraseTemplates[key]!;
                            });
                          },
                          selectedColor: primaryColor.withValues(alpha: 0.1),
                          checkmarkColor: primaryColor,
                          labelStyle: TextStyle(
                            color: isSel ? primaryColor : textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildFieldWrapper(
                            '記錄時間',
                            _buildTextField(hint: '', controller: timeCtrl),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFieldWrapper(
                            '護理師',
                            _buildInlineDropdown(
                              value: tempNurse,
                              onChanged: (v) =>
                                  setModalState(() => tempNurse = v),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _buildFieldWrapper(
                      '記錄內容',
                      _buildTextField(
                        hint: '請輸入或修改內容...',
                        controller: contentCtrl,
                        maxLines: 5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildLabel('護理師簽名'),
                    const SizedBox(height: 8),
                    _buildSignaturePlaceholder(),

                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (contentCtrl.text.isNotEmpty) {
                                setState(() {
                                  _records.add({
                                    'time': timeCtrl.text,
                                    'content': contentCtrl.text,
                                    'nurse': tempNurse,
                                  });
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('確認新增'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 工具元件 ---

  Widget _buildInlineTextField({
    required String initialValue,
    int? maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13, color: textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
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

  Widget _buildInlineDropdown({
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: const Text('代號', style: TextStyle(fontSize: 12)),
          items: _nurseOptions
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: bgField,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildSignaturePlaceholder() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgField,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, style: BorderStyle.solid),
      ),
      child: const Center(
        child: Text(
          'Digital Signature Pad Area',
          style: TextStyle(
            color: textMuted,
            fontSize: 11,
            fontStyle: FontStyle.italic,
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
      letterSpacing: 0.5,
    ),
  );

  Widget _buildTableLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 6), field],
    );
  }
}
