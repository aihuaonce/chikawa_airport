import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';

class AmbulancePlanPage extends StatefulWidget {
  const AmbulancePlanPage({super.key});

  @override
  State<AmbulancePlanPage> createState() => _AmbulancePlanPageState();
}

class _AmbulancePlanPageState extends State<AmbulancePlanPage> {
  // 顏色定義
  static const Color primaryLight = Color(0xFF83ACA9);
  static const Color primaryDark = Color(0xFF274C4A);
  static const Color white = Color(0xFFFFFFFF);

  // 表單控制器
  final TextEditingController guideController = TextEditingController();
  final TextEditingController receivingUnitController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();

  // 時間狀態
  DateTime receivingTime = DateTime.now();

  // 加入資料行
  List<Map<String, String>> medicationRecords = [];
  List<Map<String, dynamic>> paramedicRecords = [];

  // 選擇狀態
  Map<String, bool> emergencyTreatments = {
    '呼吸道處置': false,
    '創傷處置': false,
    '搬運': false,
    '心肺復甦術': false,
    '藥物處置': false,
    '其他處置': false,
  };

  String? aslType;
  String? isRejection;
  String? relationshipType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 急救處置
            const Text(
              '急救處置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: emergencyTreatments.keys.map((treatment) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: emergencyTreatments[treatment],
                      onChanged: (value) {
                        setState(() {
                          emergencyTreatments[treatment] = value ?? false;
                        });
                      },
                      activeColor: primaryDark,
                    ),
                    Text(treatment),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 人形圖預設圖片
            const Text(
              '人形圖',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryLight),
                ),
                child: Image.asset(
                  'assets/images/body_diagram_placeholder.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // 如果圖片載入失敗，顯示相機圖示
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.add_circle_outline,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 點擊按鈕開始編輯人形圖
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('開啟人形圖編輯功能')));
                  // TODO: 啟動繪圖套件
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('點擊按鈕開始編輯人形圖'),
              ),
            ),
            const SizedBox(height: 12),

            // 人形圖備註
            _buildTextField('人形圖備註', receivingUnitController, '請填寫備註內容'),
            const SizedBox(height: 12),

            // 給藥紀錄表
            _buildSectionHeader('給藥紀錄表'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryLight),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text('時間', textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('藥名', textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('途徑', textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('劑量', textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('執行者', textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  ...medicationRecords.map(
                    (row) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            row['time'] ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row['name'] ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row['route'] ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row['dose'] ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row['executor'] ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _showMedicationDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border(top: BorderSide(color: primaryLight)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: primaryDark, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '加入資料行',
                            style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ASL處理
            Row(
              children: [
                const Text(
                  'ASL處理',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                Checkbox(
                  value: aslType == '氣管內管',
                  onChanged: (value) {
                    setState(() {
                      aslType = value == true ? '氣管內管' : null;
                    });
                  },
                  activeColor: primaryDark,
                ),
                const Text('氣管內管'),
                const SizedBox(width: 16),
                Checkbox(
                  value: aslType == '手動電擊',
                  onChanged: (value) {
                    setState(() {
                      aslType = value == true ? '手動電擊' : null;
                    });
                  },
                  activeColor: primaryDark,
                ),
                const Text('手動電擊'),
              ],
            ),
            const SizedBox(height: 12),

            // 線上指導醫師指導說明
            _buildTextField('線上指導醫師指導說明', guideController, '請填寫指導說明'),
            const SizedBox(height: 20),

            // 生命徵象紀錄表
            _buildSectionHeader('生命徵象紀錄表'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryLight),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            '時間',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '意識情況',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '體溫',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '脈搏',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '呼吸',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '血壓',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '血氧',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'GCS',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _showVitalSignsDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border(top: BorderSide(color: primaryLight)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: primaryDark, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '加入資料行',
                            style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 隨車救護人員紀錄表
            _buildSectionHeader('隨車救護人員紀錄表'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryLight),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text('姓名', textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('簽名', textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  ...paramedicRecords.map(
                    (row) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            row['name'] ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: row['signature'] == null
                                ? const Center(
                                    child: Text(
                                      '簽章',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : Image.memory(
                                    row['signature'],
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              paramedicRecords.remove(row);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _showParamedicDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border(top: BorderSide(color: primaryLight)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: primaryDark, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '加入資料行',
                            style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 接收單位
            _buildTextField('接收單位', receivingUnitController, '請填寫接收單位'),
            const SizedBox(height: 12),

            // 接收時間
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 120,
                    child: Text(
                      '接收時間',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    DateFormat('yyyy年MM月dd日 HH時mm分ss秒').format(receivingTime),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        receivingTime = DateTime.now();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('更新時間'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 是否拒絕送醫
            Row(
              children: [
                const SizedBox(
                  width: 120,
                  child: Text(
                    '是否拒絕送醫',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Radio<String>(
                  value: '否',
                  groupValue: isRejection,
                  onChanged: (value) => setState(() => isRejection = value),
                  activeColor: primaryDark,
                ),
                const Text('否'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: '是',
                  groupValue: isRejection,
                  onChanged: (value) => setState(() => isRejection = value),
                  activeColor: primaryDark,
                ),
                const Text('是'),
              ],
            ),
            const SizedBox(height: 12),

            // 關係人身分
            Row(
              children: [
                const SizedBox(
                  width: 120,
                  child: Text(
                    '關係人身分',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Radio<String>(
                  value: '病患',
                  groupValue: relationshipType,
                  onChanged: (value) =>
                      setState(() => relationshipType = value),
                  activeColor: primaryDark,
                ),
                const Text('病患'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: '家屬',
                  groupValue: relationshipType,
                  onChanged: (value) =>
                      setState(() => relationshipType = value),
                  activeColor: primaryDark,
                ),
                const Text('家屬'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: '關係人',
                  groupValue: relationshipType,
                  onChanged: (value) =>
                      setState(() => relationshipType = value),
                  activeColor: primaryDark,
                ),
                const Text('關係人'),
              ],
            ),
            const SizedBox(height: 12),

            // 關係人姓名
            _buildTextField('關係人姓名', contactNameController, '請填寫關係人的姓名'),
            const SizedBox(height: 12),

            // 關係人連絡電話
            _buildTextField('關係人連絡電話', contactPhoneController, '請填寫關係人的連絡電話'),
            const SizedBox(height: 24),

            // 儲存按鈕
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('處置項目已儲存'),
                      backgroundColor: primaryDark,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('儲存處置項目', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // 格式化日期時間
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日 HH時mm分ss秒', 'zh_TW').format(dateTime);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF83ACA9)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF83ACA9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF274C4A),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 給藥紀錄彈窗
  Future<void> _showMedicationDialog(BuildContext context) async {
    DateTime recordTime = DateTime.now();
    final nameController = TextEditingController();
    final routeController = TextEditingController();
    final doseController = TextEditingController();
    final executorController = TextEditingController();

    Map<String, String>? result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('創建 藥物紀錄'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '時間',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          DateFormat(
                            'yyyy年MM月dd日 HH時mm分ss秒',
                          ).format(recordTime),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              recordTime = DateTime.now();
                            });
                          },
                          child: const Text('更新時間'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DialogInput('藥名', nameController, '請輸入藥名'),
                    const SizedBox(height: 8),
                    _DialogInput('途徑', routeController, '請輸入途徑'),
                    const SizedBox(height: 8),
                    _DialogInput('劑量', doseController, '請輸入劑量'),
                    const SizedBox(height: 8),
                    _DialogInput('執行者', executorController, '請輸入執行者'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('捨棄'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'time': DateFormat(
                        'yyyy年MM月dd日 HH時mm分ss秒',
                      ).format(recordTime),
                      'name': nameController.text,
                      'route': routeController.text,
                      'dose': doseController.text,
                      'executor': executorController.text,
                    });
                  },
                  child: const Text('儲存並關閉'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        medicationRecords.add(result);
      });
    }
  }

  // Dialog 輸入欄位元件
  Widget _DialogInput(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 生命徵象彈窗
  void _showVitalSignsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新增生命徵象紀錄'),
        content: const Text('生命徵象表單內容'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }

  // 隨車救護人員彈窗
  Future<void> _showParamedicDialog(BuildContext context) async {
    final nameController = TextEditingController();
    Uint8List? signatureBytes;

    Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('創建 隨車救護人員記錄'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Text(
                            '姓名',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: '請輸入姓名',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Text(
                            '簽名',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final bytes = await _showSignatureDialog(
                                context,
                                signatureBytes,
                              );
                              if (bytes != null) {
                                setState(() {
                                  signatureBytes = bytes;
                                });
                              }
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                              child: signatureBytes == null
                                  ? const Center(
                                      child: Text(
                                        '簽章',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : Image.memory(
                                      signatureBytes!,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('捨棄'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'name': nameController.text,
                      'signature': signatureBytes,
                    });
                  },
                  child: const Text('儲存並關閉'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'name': nameController.text,
                      'signature': signatureBytes,
                      'addMore': true,
                    });
                  },
                  child: const Text('儲存，新增另項'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        paramedicRecords.add(result);
      });
      if (result['addMore'] == true) {
        _showParamedicDialog(context);
      }
    }
  }

  Future<Uint8List?> _showSignatureDialog(
    BuildContext context,
    Uint8List? initial,
  ) async {
    SignatureController controller = SignatureController();
    Uint8List? result = await showDialog<Uint8List>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('發出您的簽章'),
          content: SizedBox(
            width: 500,
            height: 200,
            child: Signature(
              controller: controller,
              backgroundColor: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.clear();
              },
              child: const Text('清除'),
            ),
            ElevatedButton(
              onPressed: () async {
                final bytes = await controller.toPngBytes();
                Navigator.pop(context, bytes);
              },
              child: const Text('採納並簽署'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  @override
  void dispose() {
    guideController.dispose();
    receivingUnitController.dispose();
    contactNameController.dispose();
    contactPhoneController.dispose();
    super.dispose();
  }
}
