import 'package:flutter/material.dart';
import 'package:signature/signature.dart'; // 引入簽名套件
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
  final List<String> doctorList = [
    "方詩旋", "古璿正", "江旺財", "呂學政", "周志勃", "金霍歌", "徐丕", "康曉妍"
  ];

  // 其他輸入控制器
  final TextEditingController relationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController signerController = TextEditingController();
  final TextEditingController signerIdController = TextEditingController();

  // 簽名控制器
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
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
    _signatureController.dispose(); // 記得釋放簽名控制器
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
                    children: [
                      // 英文固定文字，代入 signerName & doctor
                      Text(
                        "I: $signerName\n"
                        "Date of birth\n"
                        "Here by clarified that I / my family patient had been notified by Dr. $doctor of Landseed Medical Clinic at Taiwan Taoyuan Int'l Airport, I am /my family patient is now in illness/necessary condition which needed to be transported to an advanced hospital facilites for further test and treatment. But under my our personal status/consideration, I/We decided to handle this situation by myself/ourselves, against any further medical advice I am hereby signing this consent clarified that I am /and my family are willing to take all the risks and hold all the responsibilities of any consequences, even hazardous to my/my family member's health or life integrity unexpectedly.",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Signature + 簽名框
                      const Text("Signature:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      // 使用 Signature widget
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Signature(
                          controller: _signatureController,
                          backgroundColor: Colors.white,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _signatureController.clear();
                            },
                            child: const Text("重寫"),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_signatureController.isNotEmpty) {
                                final data =
                                    await _signatureController.toPngBytes();
                                // 這裡你可以把簽名存檔或上傳
                                if (data != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("簽名已儲存")),
                                  );
                                }
                              }
                            },
                            child: const Text("儲存"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Text("Date: $today"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),


            // ===== 右側中文區塊（完全不動） =====
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
                        Text("本人： $signerName"),
                        const SizedBox(height: 8),
                        Text("身分證字號： $signerId"),
                        Text(
                          "$today 於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心醫師",
                        ),

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

                        Row(
                          children: [
                            const Text(
                              "立切結書人姓名：",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Expanded(
                              child: TextField(
                                controller: signerController,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: "請輸入姓名",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text(
                              "立切結書人身分證字號：",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Expanded(
                              child: TextField(
                                controller: signerIdController,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: "請輸入身分證字號",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text(
                              "立切結書人與病患關係：",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Expanded(
                              child: TextField(
                                controller: relationController,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: "例如：本人、父母、配偶",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text(
                              "立切結書人地址：",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Expanded(
                              child: TextField(
                                controller: addressController,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: "請輸入地址",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text(
                              "立切結書人電話：",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: "請輸入聯絡電話",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
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