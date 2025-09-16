import 'package:flutter/material.dart';
import 'nav2.dart';

class NursingRecordPage extends StatefulWidget {
  const NursingRecordPage({super.key});

  @override
  State<NursingRecordPage> createState() => _NursingRecordPageState();
}

class _NursingRecordPageState extends State<NursingRecordPage> {
  // 護理記錄的資料
  List<Map<String, String>> nursingRecords = [];

  // 新增紀錄 Dialog
  Future<void> _showNursingDialog() async {
    String time = '';
    String record = '';
    String nurseName = '';
    String nurseSign = '';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新增護理記錄'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: '紀錄時間'),
                  onChanged: (v) => time = v,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: '紀錄內容'),
                  onChanged: (v) => record = v,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: '護理師姓名'),
                  onChanged: (v) => nurseName = v,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: '護理師簽名'),
                  onChanged: (v) => nurseSign = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF83ACA9),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'time': time,
                  'record': record,
                  'nurseName': nurseName,
                  'nurseSign': nurseSign,
                });
              },
              child: const Text('儲存'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        nursingRecords.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      selectedIndex: 9,
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
                const Text(
                  '護理記錄表',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // 表頭
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF1F3F6),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '紀錄時間',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '紀錄',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '護理師姓名',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '護理師簽名',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 40), // 空間給刪除按鈕
                    ],
                  ),
                ),

                // 已新增的資料行
                ...nursingRecords.map((row) {
                  return Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(row['time'] ?? '')),
                        Expanded(flex: 3, child: Text(row['record'] ?? '')),
                        Expanded(flex: 2, child: Text(row['nurseName'] ?? '')),
                        Expanded(flex: 2, child: Text(row['nurseSign'] ?? '')),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              nursingRecords.remove(row);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),

                // 加入資料行（永遠在最下面）
                InkWell(
                  onTap: _showNursingDialog,
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: const Text(
                      '加入資料行',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
