import 'package:flutter/material.dart';
import 'nav2.dart';

// 自行格式化「yyyy年MM月dd日」
String todayTw() {
  final d = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.year}年${two(d.month)}月${two(d.day)}日';
}

class UndertakingPage extends StatefulWidget {
  const UndertakingPage({super.key});

  @override
  State<UndertakingPage> createState() => _UndertakingPageState();
}

class _UndertakingPageState extends State<UndertakingPage> {
  // 狀態變數
  String signerName = "";
  String signerId = "";
  bool isSelf = false;
  String relation = "";
  String doctor = "江旺財"; // 預設醫師
  final List<String> doctorList = ["方詩旋", "古璿正", "江旺財", "呂學政", "周志勃", "金霍歌", "徐丕", "康曉妍"]; // 先用數字代替

  // 其他輸入控制器
  final TextEditingController relationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController signerController = TextEditingController();
  final TextEditingController signerIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 綁定控制器
    signerController.addListener(() {
      setState(() {
        signerName = signerController.text;
      });
    });
    signerIdController.addListener(() {
      setState(() {
        signerId = signerIdController.text;
      });
    });
    relationController.addListener(() {
      setState(() {
        relation = relationController.text;
      });
    });
  }

  @override
  void dispose() {
    relationController.dispose();
    addressController.dispose();
    phoneController.dispose();
    signerController.dispose();
    signerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = todayTw();

    return Nav2Page(
      child: Container(
        color: const Color(0xFFE6F6FB),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 左側英文區塊 =====
            Expanded(
              child: Card(
                color: const Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "I hereby clarified ... (固定英文內容)",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 24),
                      Text("Signature:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 60),
                      Text("Date: (Today)"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // ===== 右側中文區塊 =====
            Expanded(
              child: Card(
                color: const Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 不能直接編輯，會自動帶入
                        Text("本人： $signerName"),
                        const SizedBox(height: 8),
                        Text("身分證字號： $signerId"),
                        Text(
                          "$today 於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心醫師",
                        ),

                        // 醫師下拉選單
                        DropdownButton<String>(
                          value: doctor,
                          items: doctorList
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              doctor = val!;
                            });
                          },
                        ),

                        const SizedBox(height: 12),
                        const Text(
                            "診視，醫師建議轉診至醫院繼續治療，但本人因個人因素拒絕醫師「繼續治療」之建議，致生一切後果願自行負責，與聯新國際醫院桃園國際機場醫療中心無涉。"),

                        const SizedBox(height: 16),

                        // 是否為本人 checkbox
                        Row(
                          children: [
                            const Text("是否為本人？"),
                            Checkbox(
                              value: isSelf,
                              onChanged: (val) {
                                setState(() {
                                  isSelf = val ?? false;
                                  if (isSelf) {
                                    relation = "本人";
                                    relationController.text = "本人";
                                  } else {
                                    relation = "";
                                    relationController.clear();
                                  }
                                });
                              },
                            ),
                          ],
                        ),

                        // 立切結書人姓名
                        TextField(
                          controller: signerController,
                          decoration: const InputDecoration(
                            hintText: "立切結書人姓名",
                            border: InputBorder.none,
                          ),
                        ),
                        // 身分證字號
                        TextField(
                          controller: signerIdController,
                          decoration: const InputDecoration(
                            hintText: "立切結書人身分證字號",
                            border: InputBorder.none,
                          ),
                        ),
                        // 與病患關係
                        TextField(
                          controller: relationController,
                          decoration: const InputDecoration(
                            hintText: "立切結書人與病患關係",
                            border: InputBorder.none,
                          ),
                        ),
                        // 住址
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            hintText: "立切結書人地址",
                            border: InputBorder.none,
                          ),
                        ),
                        // 電話
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: "立切結書人電話",
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      selectedIndex: 6,
    );
  }
}