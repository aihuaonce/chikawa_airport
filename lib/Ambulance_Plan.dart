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
  final TextEditingController bodyDiagramNoteController =
      TextEditingController();

  final TextEditingController airwayOtherController = TextEditingController();
  final TextEditingController traumaOtherController = TextEditingController();
  final TextEditingController otherEmergencyOtherController =
      TextEditingController();

  final TextEditingController ettSizeController = TextEditingController();
  final TextEditingController ettDepthController = TextEditingController();
  final TextEditingController manualDefibCountController =
      TextEditingController();
  final TextEditingController manualDefibJoulesController =
      TextEditingController();

  // >>> 新增：拒絕送醫姓名控制器 <<<
  final TextEditingController rejectionNameController = TextEditingController();

  // 時間狀態
  DateTime receivingTime = DateTime.now();

  // 加入資料行
  List<Map<String, String>> medicationRecords = [];
  List<Map<String, dynamic>> paramedicRecords = [];
  List<Map<String, String>> vitalSignsRecords = [];

  // 選擇狀態
  Map<String, bool> emergencyTreatments = {
    '呼吸道處置': false,
    '創傷處置': false,
    '搬運': false,
    '心肺復甦術': false,
    '藥物處置': false,
    '其他處置': false,
  };

  Map<String, bool> airwayTreatments = {
    '口咽呼吸道': false,
    '鼻咽呼吸道': false,
    '抽吸': false,
    '哈姆立克法': false,
    '鼻管': false,
    '面罩': false,
    '非再呼吸型面罩': false,
    'BVM(正壓輔助呼吸)': false,
    'LMA': false,
    'Igel': false,
    '氣管內管': false,
    '其他': false,
  };

  Map<String, bool> traumaTreatments = {
    '頸圈': false,
    '清洗傷口': false,
    '止血、包紮': false,
    '骨折固定': false,
    '長背板固定': false,
    '鏟式擔架固定': false,
    '其他': false,
  };

  Map<String, bool> transportMethods = {'自行上車': false, '以適當方式搬運': false};

  Map<String, bool> cprMethods = {
    '自動心肺復甦機': false,
    'CPR': false,
    '使用AED': false,
    '手動電擊器': false,
  };

  Map<String, bool> medicationProcedures = {
    '靜脈輸液': false,
    '口服葡萄糖液/粉': false,
    '協助使用Aspirin': false,
    '協助使用NTG': false,
    '協助使用支氣管擴張劑': false,
  };

  Map<String, bool> otherEmergencyProcedures = {
    '保暖': false,
    '心理支持': false,
    '約束帶': false,
    '拒絕使用氧氣': false,
    '生命徵象監測': false,
    '其他': false,
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

            if (emergencyTreatments['呼吸道處置']!) _buildAirwayOptions(),
            if (emergencyTreatments['創傷處置']!) _buildTraumaOptions(),
            if (emergencyTreatments['搬運']!) _buildTransportOptions(),
            if (emergencyTreatments['心肺復甦術']!) _buildCprOptions(),
            if (emergencyTreatments['藥物處置']!) _buildMedicationOptions(),
            if (emergencyTreatments['其他處置']!) _buildOtherEmergencyOptions(),

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

            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('開啟人形圖編輯功能')));
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

            _buildTextField('人形圖備註', bodyDiagramNoteController, '請填寫備註內容'),
            const SizedBox(height: 12),

            // 給藥紀錄表
            _buildSectionHeader('給藥紀錄表'),
            const SizedBox(height: 8),
            Container(
              clipBehavior: Clip.antiAlias,
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
                      border: Border(bottom: BorderSide(color: primaryLight)),
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
                    (row) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
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
                  ),
                  InkWell(
                    onTap: () => _showMedicationDialog(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF5F5F5),
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'ASL處理',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                if (aslType == '氣管內管')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          '氣管內管號碼',
                          ettSizeController,
                          '請填寫氣管內管號碼',
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          '氣管內管固定公分數(cm)',
                          ettDepthController,
                          '請填寫固定公分數(cm)',
                        ),
                      ],
                    ),
                  ),
                if (aslType == '手動電擊')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        _buildTextField(
                          '手動電擊次數',
                          manualDefibCountController,
                          '請填寫手動電擊次數',
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          '手動電擊焦耳數',
                          manualDefibJoulesController,
                          '請填寫手動電擊焦耳數',
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            _buildTextField('線上指導醫師指導說明', guideController, '請填寫指導說明'),
            const SizedBox(height: 20),

            // 生命徵象紀錄表
            _buildSectionHeader('生命徵象紀錄表'),
            const SizedBox(height: 8),
            Container(
              clipBehavior: Clip.antiAlias,
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
                      border: Border(bottom: BorderSide(color: primaryLight)),
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
                            '意識',
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
                  ...vitalSignsRecords.map(
                    (row) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              row['time'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['consciousness'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['temperature'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['pulse'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['respiration'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['bloodPressure'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['spo2'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['gcs'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _showVitalSignsDialog(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF5F5F5),
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
              clipBehavior: Clip.antiAlias,
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
                      border: Border(bottom: BorderSide(color: primaryLight)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('姓名', textAlign: TextAlign.center),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('簽名', textAlign: TextAlign.center),
                        ),
                        SizedBox(width: 48),
                      ],
                    ),
                  ),
                  ...paramedicRecords.map(
                    (row) => Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              row['name'] ?? '',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 80,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade100,
                              ),
                              child: row['signature'] == null
                                  ? const Center(
                                      child: Text(
                                        '無簽名',
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
                  ),
                  InkWell(
                    onTap: () => _showParamedicDialog(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF5F5F5),
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

            _buildTextField('接收單位', receivingUnitController, '請填寫接收單位'),
            const SizedBox(height: 12),

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
                    DateFormat('yyyy年MM月dd日 HH時mm分').format(receivingTime),
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

            // >>> 修改：拒絕送醫 <<<
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
            if (isRejection == '是')
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAEFE3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '拒絕醫療聲明：',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('本人聲明，救護人員以解釋病情與送醫之需要，但我拒絕救護與送醫。'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('姓名：'),
                        Expanded(
                          child: TextField(
                            controller: rejectionNameController,
                            decoration: const InputDecoration(
                              hintText: '請填寫姓名',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

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

            _buildTextField('關係人姓名', contactNameController, '請填寫關係人的姓名'),
            const SizedBox(height: 12),

            _buildTextField('關係人連絡電話', contactPhoneController, '請填寫關係人的連絡電話'),
            const SizedBox(height: 24),

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

  Widget _buildAirwayOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '呼吸道處置',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: airwayTreatments.keys.map((key) {
            return _buildSubCheckbox(key, airwayTreatments);
          }).toList(),
        ),
        if (airwayTreatments['其他']!)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildTextField('其他', airwayOtherController, '請填寫其他的處置'),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTraumaOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '創傷處置',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: traumaTreatments.keys.map((key) {
            return _buildSubCheckbox(key, traumaTreatments);
          }).toList(),
        ),
        if (traumaTreatments['其他']!)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildTextField('其他', traumaOtherController, '請填寫其他的處置'),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTransportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '搬運',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: transportMethods.keys.map((key) {
            return _buildSubCheckbox(key, transportMethods);
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCprOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '心肺復甦術',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: cprMethods.keys.map((key) {
            return _buildSubCheckbox(key, cprMethods);
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMedicationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '藥物處置',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: medicationProcedures.keys.map((key) {
            return _buildSubCheckbox(key, medicationProcedures);
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOtherEmergencyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '急救-其他處置',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: otherEmergencyProcedures.keys.map((key) {
            return _buildSubCheckbox(key, otherEmergencyProcedures);
          }).toList(),
        ),
        if (otherEmergencyProcedures['其他']!)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildTextField(
              '其他處置',
              otherEmergencyOtherController,
              '請填寫其他的處置',
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubCheckbox(String key, Map<String, bool> stateMap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: stateMap[key],
          onChanged: (value) {
            setState(() {
              stateMap[key] = value ?? false;
            });
          },
          activeColor: primaryDark,
        ),
        Text(key),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
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
                    _buildDialogRow(
                      '紀錄時間',
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              'yyyy年MM月dd日 HH時mm分ss秒',
                            ).format(recordTime),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => recordTime = DateTime.now()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('更新時間'),
                          ),
                        ],
                      ),
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
                      'time': DateFormat('HH:mm').format(recordTime),
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

    if (result != null && result.values.any((element) => element.isNotEmpty)) {
      setState(() {
        medicationRecords.add(result);
      });
    }
  }

  // Add this method to fix the error
  Widget _buildDialogRow(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }

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

  // >>> 修改：生命徵象彈窗 <<<
  Future<void> _showVitalSignsDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const VitalSignsDialog(),
    );

    if (result != null) {
      setState(() {
        vitalSignsRecords.add(result);
      });
      if (result['addMore'] == 'true') {
        // 使用一個微小的延遲來確保前一個對話框完全關閉
        Future.delayed(const Duration(milliseconds: 100), () {
          _showVitalSignsDialog(context);
        });
      }
    }
  }

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
                                        '點此簽章',
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
                    if (nameController.text.isNotEmpty) {
                      Navigator.pop(context, {
                        'name': nameController.text,
                        'signature': signatureBytes,
                      });
                    }
                  },
                  child: const Text('儲存並關閉'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Navigator.pop(context, {
                        'name': nameController.text,
                        'signature': signatureBytes,
                        'addMore': true,
                      });
                    }
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
    SignatureController controller = SignatureController(
      penStrokeWidth: 3.0,
      penColor: Colors.black,
    );
    Uint8List? result = await showDialog<Uint8List>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('請在下方簽名'),
          content: SizedBox(
            width: 300,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Signature(
                controller: controller,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.clear();
              },
              child: const Text('清除'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.isNotEmpty) {
                  final bytes = await controller.toPngBytes();
                  Navigator.pop(context, bytes);
                }
              },
              child: const Text('採納並簽署'),
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
    bodyDiagramNoteController.dispose();

    airwayOtherController.dispose();
    traumaOtherController.dispose();
    otherEmergencyOtherController.dispose();

    ettSizeController.dispose();
    ettDepthController.dispose();
    manualDefibCountController.dispose();
    manualDefibJoulesController.dispose();

    rejectionNameController.dispose();

    super.dispose();
  }
}

// >>> 新增：生命徵象對話框 Widget <<<
class VitalSignsDialog extends StatefulWidget {
  const VitalSignsDialog({super.key});

  @override
  State<VitalSignsDialog> createState() => _VitalSignsDialogState();
}

class _VitalSignsDialogState extends State<VitalSignsDialog> {
  DateTime recordTime = DateTime.now();
  String? atHospital = '否';
  String? consciousness = '清';

  final triageController = TextEditingController();
  final tempController = TextEditingController();
  final pulseController = TextEditingController();
  final respController = TextEditingController();
  final bpController = TextEditingController();
  final spo2Controller = TextEditingController();
  final gcsEController = TextEditingController();
  final gcsVController = TextEditingController();
  final gcsMController = TextEditingController();

  void _saveAndPop({bool addMore = false}) {
    final gcsE = int.tryParse(gcsEController.text) ?? 0;
    final gcsV = int.tryParse(gcsVController.text) ?? 0;
    final gcsM = int.tryParse(gcsMController.text) ?? 0;
    final gcsTotal = gcsE + gcsV + gcsM;

    final data = {
      'time': DateFormat('HH:mm').format(recordTime),
      'consciousness': consciousness ?? '',
      'temperature': tempController.text,
      'pulse': pulseController.text,
      'respiration': respController.text,
      'bloodPressure': bpController.text,
      'spo2': spo2Controller.text,
      'gcs': gcsTotal > 0 ? '$gcsTotal (E${gcsE}V${gcsV}M${gcsM})' : '',
      if (addMore) 'addMore': 'true',
    };
    Navigator.of(context).pop(data);
  }

  @override
  void dispose() {
    triageController.dispose();
    tempController.dispose();
    pulseController.dispose();
    respController.dispose();
    bpController.dispose();
    spo2Controller.dispose();
    gcsEController.dispose();
    gcsVController.dispose();
    gcsMController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('創建 生命徵象紀錄'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow(
              '紀錄時間',
              Row(
                children: [
                  Text(DateFormat('yyyy年MM月dd日 HH時mm分ss秒').format(recordTime)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        setState(() => recordTime = DateTime.now()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('更新時間'),
                  ),
                ],
              ),
            ),
            _buildDialogRow(
              '是否抵達醫院後',
              Row(
                children: [
                  Radio<String>(
                    value: '是',
                    groupValue: atHospital,
                    onChanged: (v) => setState(() => atHospital = v),
                  ),
                  const Text('是'),
                  Radio<String>(
                    value: '否',
                    groupValue: atHospital,
                    onChanged: (v) => setState(() => atHospital = v),
                  ),
                  const Text('否'),
                ],
              ),
            ),
            _buildDialogRow(
              '檢傷站',
              Expanded(child: _buildDialogTextField(triageController, '請填寫')),
            ),
            _buildDialogRow(
              '意識情況',
              Row(
                children: [
                  Radio<String>(
                    value: '清',
                    groupValue: consciousness,
                    onChanged: (v) => setState(() => consciousness = v),
                  ),
                  const Text('清'),
                  Radio<String>(
                    value: '聲',
                    groupValue: consciousness,
                    onChanged: (v) => setState(() => consciousness = v),
                  ),
                  const Text('聲'),
                  Radio<String>(
                    value: '痛',
                    groupValue: consciousness,
                    onChanged: (v) => setState(() => consciousness = v),
                  ),
                  const Text('痛'),
                  Radio<String>(
                    value: '否',
                    groupValue: consciousness,
                    onChanged: (v) => setState(() => consciousness = v),
                  ),
                  const Text('否'),
                ],
              ),
            ),
            _buildDialogRow(
              '體溫(°C)',
              Expanded(child: _buildDialogTextField(tempController, '請填寫體溫度數')),
            ),
            _buildDialogRow(
              '脈搏(次/min)',
              Expanded(
                child: _buildDialogTextField(pulseController, '請填寫脈搏次數'),
              ),
            ),
            _buildDialogRow(
              '呼吸(次/min)',
              Expanded(child: _buildDialogTextField(respController, '請填寫呼吸次數')),
            ),
            _buildDialogRow(
              '血壓(mmHg)',
              Expanded(child: _buildDialogTextField(bpController, '請填寫血壓數值')),
            ),
            _buildDialogRow(
              '血氧(%)',
              Expanded(child: _buildDialogTextField(spo2Controller, '請填寫血氧濃度')),
            ),
            _buildDialogRow(
              'GCS-E',
              Expanded(child: _buildDialogTextField(gcsEController, '請填寫')),
            ),
            _buildDialogRow(
              'GCS-V',
              Expanded(child: _buildDialogTextField(gcsVController, '請填寫')),
            ),
            _buildDialogRow(
              'GCS-M',
              Expanded(child: _buildDialogTextField(gcsMController, '請填寫')),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('捨棄'),
        ),
        ElevatedButton(
          onPressed: () => _saveAndPop(addMore: true),
          child: const Text('儲存，新增另項'),
        ),
        ElevatedButton(
          onPressed: () => _saveAndPop(),
          child: const Text('儲存並關閉'),
        ),
      ],
    );
  }

  Widget _buildDialogRow(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildDialogTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }
}
