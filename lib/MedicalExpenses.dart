import 'package:flutter/material.dart';
import 'nav2.dart';

class MedicalExpensesPage extends StatefulWidget {
  final int visitId;
  const MedicalExpensesPage({super.key,required this.visitId,});

  @override
  State<MedicalExpensesPage> createState() => _MedicalExpensesPageState();
}

class _MedicalExpensesPageState extends State<MedicalExpensesPage> {
  String? chargeMethod;
  final TextEditingController visitFeeController = TextEditingController();
  final TextEditingController ambulanceFeeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  double totalFee = 0;

  void _calculateTotal() {
    final double visitFee =
        double.tryParse(visitFeeController.text.trim()) ?? 0;
    final double ambulanceFee =
        double.tryParse(ambulanceFeeController.text.trim()) ?? 0;
    setState(() {
      totalFee = visitFee + ambulanceFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      visitId: widget.visitId,
      selectedIndex: 4,
      child: Container(
        color: const Color(0xFFE6F6FB),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 900,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '醫療費用收費表',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF83ACA9),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: 在這裡放跳轉或顯示收費表的功能
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('收費表'),
                            content: const Text('這裡可以顯示詳細收費表內容'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('關閉'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('查看收費表'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('醫療費用收取方式'),
                          Column(
                            children: [
                              RadioListTile<String>(
                                title: const Text('自付'),
                                value: '自付',
                                groupValue: chargeMethod,
                                activeColor: const Color(0xFF83ACA9),
                                onChanged: (v) =>
                                    setState(() => chargeMethod = v),
                              ),
                              RadioListTile<String>(
                                title: const Text('統一請款'),
                                value: '統一請款',
                                groupValue: chargeMethod,
                                activeColor: const Color(0xFF83ACA9),
                                onChanged: (v) =>
                                    setState(() => chargeMethod = v),
                              ),
                              RadioListTile<String>(
                                title: const Text('總院會核代收'),
                                value: '總院會核代收',
                                groupValue: chargeMethod,
                                activeColor: const Color(0xFF83ACA9),
                                onChanged: (v) =>
                                    setState(() => chargeMethod = v),
                              ),
                              RadioListTile<String>(
                                title: const Text('收費異常'),
                                value: '收費異常',
                                groupValue: chargeMethod,
                                activeColor: const Color(0xFF83ACA9),
                                onChanged: (v) =>
                                    setState(() => chargeMethod = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // 拍照區塊
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: 這裡串接拍照或上傳
                        },
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 出診費
                _SectionTitle('出診費'),
                TextField(
                  controller: visitFeeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '輸入金額',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateTotal(),
                ),
                const SizedBox(height: 16),

                // 救護車費用
                _SectionTitle('救護車費用'),
                TextField(
                  controller: ambulanceFeeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '輸入金額',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateTotal(),
                ),
                const SizedBox(height: 16),

                // 總費用
                _SectionTitle('總費用'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFF1F3F6),
                  child: Text(
                    totalFee.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // 收費備註
                _SectionTitle('收費備註'),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    hintText: '請填寫收費備註',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // 同意簽名
                const Text(
                  '瞭解醫護人員說明明瞭醫療收費之後且同意',
                  style: TextStyle(color: Colors.black54),
                ),
                const Text(
                  'Understand the medical charge and agree to it.',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF83ACA9),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: 串接簽名板 or 上傳檔案
                        },
                        child: const Text('同意人簽名/身份'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF83ACA9),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: 串接簽名板 or 上傳檔案
                        },
                        child: const Text('見證人簽名/身份'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 共用的 Section Title
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
