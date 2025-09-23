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

  // 診斷輸入框
  Widget _buildDiagnosisInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Expanded(flex: 3, child: Text("診斷：")),
          Expanded(
            flex: 7,
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "請輸入診斷",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
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
        children: [
          const Expanded(flex: 3, child: Text("中文囑言：")),
          Expanded(
            flex: 7,
            child: TextField(
              controller: _chineseController, // 綁定控制器
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "請輸入中文囑言",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
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
        children: [
          const Expanded(flex: 3, child: Text("英文囑言：")),
          Expanded(
            flex: 7,
            child: TextField(
              controller: _englishController, // 綁定控制器
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Please enter English instructions",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
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
        children: [
          Expanded(flex: 3, child: Text(label)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label)),
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
                ),
                child: Text(
                  _selectedDate != null
                      ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
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
  Widget build(BuildContext context) {
    return Nav2Page(
      child: Container(
        color: const Color(0xFFE6F6FB),
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color(0xFFE0E0E0),
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
                _buildDateRow("國立日期："),
              ],
            ),
          ),
        ),
      ),
      selectedIndex: 5,
    );
  }
}