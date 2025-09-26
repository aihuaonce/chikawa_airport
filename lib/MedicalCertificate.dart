import 'package:flutter/material.dart';
import 'nav2.dart';

class MedicalCertificatePage extends StatefulWidget {
  const MedicalCertificatePage({super.key});

  @override
  State<MedicalCertificatePage> createState() => _MedicalCertificatePageState();
}

class _MedicalCertificatePageState extends State<MedicalCertificatePage> {
  int? _selectedOption; // 預設囑言片語選項
  DateTime? _selectedDate; // 日期

  // 新增文字控制器
  final TextEditingController _diagnosisController = TextEditingController(); // 診斷控制器
  final TextEditingController _chineseController = TextEditingController();
  final TextEditingController _englishController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 輔助方法：創建帶有邊框的 TextField 樣式
  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  // >>> 關鍵修改：將標籤 Text 提取出來，並套用粗體和字體放大 <<<
  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold, // 設為粗體
        fontSize: 16, // 字體稍微放大
      ),
    );
  }

  // 診斷輸入框
  Widget _buildDiagnosisInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        // >>> 關鍵修改：使用 crossAxisAlignment: CrossAxisAlignment.start 讓行內元件對齊頂部 <<<
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildLabel("診斷：")), // 使用自訂的粗體標籤
          Expanded(
            flex: 7,
            child: TextField(
              controller: _diagnosisController,
              maxLines: 3,
              decoration: _getInputDecoration("請輸入診斷"),
            ),
          ),
        ],
      ),
    );
  }

  // 中文囑言輸入框
  Widget _buildChineseInstructionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 確保頂部對齊
        children: [
          Expanded(flex: 3, child: _buildLabel("中文囑言：")), // 使用自訂的粗體標籤
          Expanded(
            flex: 7,
            child: TextField(
              controller: _chineseController,
              maxLines: 3,
              decoration: _getInputDecoration("請輸入中文囑言"),
            ),
          ),
        ],
      ),
    );
  }

  // 英文囑言輸入框
  Widget _buildEnglishInstructionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 確保頂部對齊
        children: [
          Expanded(flex: 3, child: _buildLabel("英文囑言：")), // 使用自訂的粗體標籤
          Expanded(
            flex: 7,
            child: TextField(
              controller: _englishController,
              maxLines: 3,
              decoration: _getInputDecoration("Please enter English instructions"),
            ),
          ),
        ],
      ),
    );
  }

  // 預設囑言片語 (RadioButton)
  Widget _buildRadioRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Radio 按鈕通常保持居中
        children: [
          Expanded(flex: 3, child: _buildLabel(label)), // 使用自訂的粗體標籤
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      _chineseController.text = "病人於今日因上述False原因，接受本機場醫療中心緊急醫療出診，目前生命徵象穩定適宜飛行。(以下空白)";
                      _englishController.text = "Due to above reasons, the patient received an outreach emergency medical. He/She is fit to fly.(Blank Below)";
                    });
                  },
                ),
                const Text("適宜飛行"),
                const SizedBox(width: 20),
                Radio<int>(
                  value: 2,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      _chineseController.text = "病人於今日因上述False原因，接受本醫療中心緊急醫療出診，建議轉診至醫院進行進一步檢查及治療。(以下空白)";
                      _englishController.text = "Due to above reasons, the patient received an outreach emergency medical. He/She is fit to fly.(Blank Below)";
                    });
                  },
                ),
                const Text("轉診後送"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 日期欄位
  Widget _buildDateRow(String label) {
    // 雖然這裡的輸入框是單行，但為了保持整體風格和對齊，仍使用 CrossAxisAlignment.start
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildLabel(label)), // 使用自訂的粗體標籤
          Expanded(
            flex: 7,
            child: InkWell(
              onTap: () => _pickDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Text(
                  _selectedDate != null
                      ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
                      : "選擇日期",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _chineseController.dispose();
    _englishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      child: Container(
        color: const Color(0xFFE6F6FB),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Card(
                  color: Colors.white,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDiagnosisInput(),
                        _buildRadioRow("預設囑言片語："),
                        _buildChineseInstructionInput(),
                        _buildEnglishInstructionInput(),
                        _buildDateRow("開立日期："), // 修正為開立日期
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      selectedIndex: 5,
    );
  }
}