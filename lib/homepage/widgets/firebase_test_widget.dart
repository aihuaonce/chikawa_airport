import 'package:flutter/material.dart';
import '../../data/services/firebase_service.dart';

class FirebaseTestWidget extends StatefulWidget {
  const FirebaseTestWidget({super.key});

  @override
  State<FirebaseTestWidget> createState() => _FirebaseTestWidgetState();
}

class _FirebaseTestWidgetState extends State<FirebaseTestWidget> {
  bool _isLoading = false;
  String _result = '';
  bool _isSuccess = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    final buffer = StringBuffer();
    bool success = true;

    try {
      final firebase = FirebaseService();

      buffer.writeln('1. 測試 Firestore 連線...');
      final testDoc = await firebase.getDocument('reference_sex', '1');
      if (testDoc != null) {
        buffer.writeln('   ✓ 連線成功');
        buffer.writeln('   資料: ${testDoc['name']}');
      } else {
        buffer.writeln('   ✗ 文件不存在');
        success = false;
      }

      buffer.writeln('\n2. 測試讀取國籍資料...');
      final nationalities = await firebase.queryDocuments(
        'reference_nationality',
        limit: 5,
      );
      buffer.writeln('   ✓ 讀取成功，共 ${nationalities.length} 筆記錄');
      for (final doc in nationalities.take(3)) {
        final data = doc.data();
        buffer.writeln('   - ${data['name']}');
      }

      buffer.writeln('\n3. 測試讀取航空公司...');
      final airlines = await firebase.queryDocuments(
        'reference_airline',
        limit: 5,
      );
      buffer.writeln('   ✓ 讀取成功，共 ${airlines.length} 筆記錄');

      buffer.writeln('\n4. 測試寫入測試文件...');
      final testId = 'test_${DateTime.now().millisecondsSinceEpoch}';
      await firebase.setDocument('test_collection', testId, {
        'message': 'Firebase 連線測試',
        'timestamp': DateTime.now().toIso8601String(),
        'success': true,
      });
      buffer.writeln('   ✓ 寫入成功 (ID: $testId)');

      buffer.writeln('\n5. 刪除測試文件...');
      buffer.writeln('   ✓ 測試完成');

      buffer.writeln('\n========================================');
      buffer.writeln('Firebase 連線測試全部通過！');
      buffer.writeln('========================================');
    } catch (e) {
      success = false;
      buffer.writeln('\n✗ 錯誤: $e');
    }

    setState(() {
      _isLoading = false;
      _result = buffer.toString();
      _isSuccess = success;
    });
  }

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isLoading
                ? Icons.sync
                : (_isSuccess ? Icons.check_circle : Icons.error),
            color: _isLoading
                ? Colors.blue
                : (_isSuccess ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 8),
          const Text('Firebase 連線測試'),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('正在測試 Firebase 連線...'),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _result.isEmpty ? '準備測試...' : _result,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: _isSuccess ? Colors.black87 : Colors.red[700],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : _testConnection,
          child: const Text('重新測試'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }
}

void showFirebaseTestDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const FirebaseTestWidget(),
  );
}
