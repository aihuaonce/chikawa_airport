import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'nav2.dart';

class ReferralFormPage extends StatefulWidget {
  const ReferralFormPage({super.key});

  @override
  State<ReferralFormPage> createState() => _ReferralFormPageState();
}

class _ReferralFormPageState extends State<ReferralFormPage> {
  DateTime today = DateTime.now();

  // 第三部分 - 醫師姓名 & 科別
  String? selectedDoctor;
  String? selectedDept;
  bool isOtherDoctor = false;
  bool isOtherDept = false;

  // 第四部分 - 轉診院所科別
  String? selectedHospitalDept;
  bool isOtherHospitalDept = false;

  // 簽名控制器
  final SignatureController _doctorSignController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _consentSignController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? doctorSignature;
  Uint8List? consentSignature;

  String? selectedPurpose;
  DateTime? consentDateTime;

  // 日期選擇器
  Future<void> _pickDate(BuildContext context, ValueChanged<DateTime> onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  // 簽名 Dialog
  void _openSignaturePad(SignatureController controller, Function(Uint8List) onSaved) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Expanded(
                child: Signature(
                  controller: controller,
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: controller.clear,
                    child: const Text("重寫"),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (controller.isNotEmpty) {
                        final data = await controller.toPngBytes();
                        if (data != null) {
                          onSaved(data);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("儲存"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      selectedIndex: 8,
      child: Container(
        color: const Color(0xFFE6F6FB),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 950,
            margin: const EdgeInsets.symmetric(vertical: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------------- 第一部分 ----------------
                const Text("聯絡人資料", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildInputRow("姓名：", "請填寫聯絡人姓名"),
                const SizedBox(height: 8),
                _buildInputRow("電話：", "請填寫聯絡人電話"),
                const SizedBox(height: 8),
                _buildInputRow("地址：", "請填寫聯絡人地址"),

                const Divider(thickness: 1, height: 32),

                // ---------------- 第二部分 ----------------
                const Text("診斷ICD-10-CM/PCS病名", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildInputRow("主診斷：", "請輸入..."),
                const SizedBox(height: 8),
                _buildInputRow("副診斷1：", "請輸入..."),
                const SizedBox(height: 8),
                _buildInputRow("副診斷2：", "請輸入..."),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildLeftCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRightCard(),
                    ),
                  ],
                ),

                const Divider(thickness: 1, height: 32),

                // ---------------- 第三部分 ----------------
                const Text("診治醫生姓名", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildDropdownWithOther("醫師姓名：", ["方詩旋", "古璿正", "江旺財", "呂學政", "周志勃", "金霍歌", "徐丕", "康曉妍", "其他"],
                    (val) => setState(() {
                      selectedDoctor = val;
                      isOtherDoctor = val == "其他";
                    })),
                if (isOtherDoctor) _buildInputRow("其他：", "請輸入姓名"),

                const SizedBox(height: 12),
                const Text("診治醫生科別", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDropdownWithOther("醫師科別：", ["急診醫學科", "不分科", "家醫科", "內科", "外科", "小兒科", "婦產科", "骨科", "眼科", "其他"],
                    (val) => setState(() {
                      selectedDept = val;
                      isOtherDept = val == "其他";
                    })),
                if (isOtherDept) _buildInputRow("其他：", "請輸入科別"),

                const SizedBox(height: 12),
                const Text("診治醫師簽名", style: TextStyle(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => _openSignaturePad(_doctorSignController, (data) {
                    setState(() => doctorSignature = data);
                  }),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: doctorSignature == null
                        ? const Text("點擊簽名", style: TextStyle(color: Colors.grey))
                        : Image.memory(doctorSignature!),
                  ),
                ),

                const Divider(thickness: 1, height: 32),

                // ---------------- 第四部分 ----------------
                Row(
                  children: [
                    Expanded(child: _buildLeftCard4(context)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildRightCard4()),
                  ],
                ),

                const Divider(thickness: 1, height: 32),

                const Text("經醫師解釋病情及轉診目的後同意轉院。", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text("同意人簽名", style: TextStyle(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => _openSignaturePad(_consentSignController, (data) {
                    setState(() => consentSignature = data);
                  }),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: consentSignature == null
                        ? const Text("點擊簽名", style: TextStyle(color: Colors.grey))
                        : Image.memory(consentSignature!),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInputRow("與病人關係：", "請填寫同意人與病人關係"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("簽名日期：${(consentDateTime ?? DateTime.now()).toString().split('.')[0]}"),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => consentDateTime = DateTime.now());
                      },
                      child: const Text("更新時間"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 左側卡片（第二部分）
  Widget _buildLeftCard() => Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("檢查及治療摘要", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("1. 最近一次檢查結果"),
              TextButton(
                onPressed: () => _pickDate(context, (d) => setState(() => today = d)),
                child: Text("日期：${today.toLocal()}".split(' ')[0]),
              ),
              const SizedBox(height: 8),
              Text("2. 最近一次用藥或手術名稱"),
              TextButton(
                onPressed: () => _pickDate(context, (d) => setState(() => today = d)),
                child: Text("日期：${today.toLocal()}".split(' ')[0]),
              ),
            ],
          ),
        ),
      );

  // 右側卡片（第二部分）
  Widget _buildRightCard() => Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("轉診目的", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildRadio("急診治療"),
              _buildRadio("住院治療"),
              _buildRadio("門診治療"),
              _buildRadioWithInput("進一步檢查", "檢查項目：", "請填寫檢查項目"),
              _buildRadio("轉回轉出或適當之院所繼續追蹤"),
              _buildRadioWithInput("其他", "其他轉診目的：", "請填寫其他轉診目的"),
            ],
          ),
        ),
      );

  // 左側卡片（第四部分）
  Widget _buildLeftCard4(BuildContext context) => Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("開單日期", style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _pickDate(context, (d) => setState(() => today = d)),
                child: Text("日期：${today.toLocal()}".split(' ')[0]),
              ),
              const SizedBox(height: 8),
              const Text("安排就醫日期", style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _pickDate(context, (d) => setState(() => today = d)),
                child: Text("日期：${today.toLocal()}".split(' ')[0]),
              ),
              const SizedBox(height: 8),
              _buildInputRow("安排就醫科別：", "選填就醫科別"),
              const SizedBox(height: 8),
              _buildInputRow("安排就醫診間：", "選填就醫診間"),
              const SizedBox(height: 8),
              _buildInputRow("安排就醫號碼：", "選填就醫號碼"),
            ],
          ),
        ),
      );

  // 右側卡片（第四部分）
  Widget _buildRightCard4() => Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputRow("建議轉診院所名稱：", "聯新國際醫院"),
              const SizedBox(height: 8),
              _buildDropdownWithOther("建議院所科別：", ["急診醫學科", "不分科", "家醫科", "內科", "外科", "小兒科", "婦產科", "骨科", "其他"],
                  (val) => setState(() {
                        selectedHospitalDept = val;
                        isOtherHospitalDept = val == "其他";
                      })),
              if (isOtherHospitalDept) _buildInputRow("其他：", "請輸入科別"),
              const SizedBox(height: 8),
              _buildInputRow("建議院所醫師姓名：", "視情況填寫轉診院所醫師"),
              const SizedBox(height: 8),
              _buildInputRow("建議院所地址：", "請填寫院所地址"),
              const SizedBox(height: 8),
              _buildInputRow("建議院所電話：", "請填寫院所電話"),
            ],
          ),
        ),
      );

  // 輔助小元件
  Widget _buildInputRow(String label, String hint) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: hint.length * 15.0 + 30,
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWithOther(String label, List<String> items, Function(String) onChanged) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<String>(
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadio(String text) {
    return Row(
      children: [
        Radio<String>(
          value: text,
          groupValue: selectedPurpose,
          onChanged: (val) => setState(() => selectedPurpose = val),
        ),
        Text(text),
      ],
    );
  }

  Widget _buildRadioWithInput(String text, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: text,
              groupValue: selectedPurpose,
              onChanged: (val) => setState(() => selectedPurpose = val),
            ),
            Text(text),
          ],
        ),
        if (selectedPurpose == text)
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: _buildInputRow(label, hint),
          ),
      ],
    );
  }
}