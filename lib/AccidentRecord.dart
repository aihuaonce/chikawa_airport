import 'package:flutter/material.dart';
import 'nav2.dart';

class AccidentRecordPage extends StatefulWidget {
  const AccidentRecordPage({super.key});

  @override
  State<AccidentRecordPage> createState() => _AccidentRecordPageState();
}

class _AccidentRecordPageState extends State<AccidentRecordPage> {
  // ===== 外觀參數 =====
  static const double _outerHpad = 48; // 左右留白
  static const double _cardMaxWidth = 1100; // 卡片最大寬
  static const double _radius = 16;

  // ===== 狀態 =====
  DateTime? incidentDate;          // 事發日期（只顯示年月日）
  DateTime? notifyTime;            // 通報時間（年月日 時分秒）
  DateTime? pickUpTime;            // 通報營運控制中心時間
  DateTime? medicArriveTime;       // 醫護到達時間
  DateTime? ambulanceDepartTime;   // 醫護出發時間
  DateTime? checkTime;             // 檢查時間（頁尾）

  // 通報單位
  final List<String> reportUnits = const [
    'T1-OCC', 'T2-OCC', '華航', '長榮', '虎航', '星宇', '采盟', '昇恆昌', '病人或家屬', '其他',
  ];
  int? reportUnitIdx; // ← 不預設勾選
  final TextEditingController otherReportUnitCtrl = TextEditingController(); // 其他通報單位

  // 事故地點
  final List<String> accidentPlaces = const [
    '第一航廈', '第二航廈', '遠端機坪', '貨運站/機坪其他', '諾富特飯店', '飛機機艙內',
  ];
  int? placeIdx; // ← 不預設勾選

  // 文字欄位
  final TextEditingController notifierCtrl = TextEditingController();  // 通報人員
  final TextEditingController phoneCtrl = TextEditingController();     // 電話
  final TextEditingController placeNoteCtrl = TextEditingController(); // 地點備註
  final TextEditingController costCtrl = TextEditingController();      // 花費時間(分秒)

  bool occArrived = false; // 營運控制中心到達現場？（勾選）

  // 「10分鐘內到達」是/否
  int? within10min; // 0=是, 1=否
  // 否的原因（可多選）
  bool reasonLanding = false; // 落地前通知
  bool reasonOnline = false;  // 線上勤務
  bool reasonOther = false;   // 其他
  final TextEditingController reasonOtherCtrl = TextEditingController();
  DateTime? landingTime; // 勾選「落地前通知」時顯示落地時間（可更新）

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    incidentDate = now;
    notifyTime = now;
    pickUpTime = now;
    medicArriveTime = now;
    ambulanceDepartTime = now;
    checkTime = now;
    landingTime = now;
  }

  @override
  void dispose() {
    notifierCtrl.dispose();
    phoneCtrl.dispose();
    placeNoteCtrl.dispose();
    costCtrl.dispose();
    otherReportUnitCtrl.dispose();
    reasonOtherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherIdx = reportUnits.length - 1; // 「其他」的索引

    return Nav2Page(
      selectedIndex: 2,
      child: Container(
        color: const Color(0xFFE6F6FB),
        padding: const EdgeInsets.symmetric(horizontal: _outerHpad, vertical: 16),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
              child: _bigCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === 事發日期（只顯示年月日） / 通報時間 ===
                    _timeRowDate(
                      '事發日期？',
                      incidentDate,
                      () => setState(() => incidentDate = DateTime.now()),
                    ),
                    const SizedBox(height: 8),
                    _timeRowDateTime(
                      '通報時間？',
                      notifyTime,
                      () => setState(() => notifyTime = DateTime.now()),
                    ),
                    const SizedBox(height: 16),

                    // === 通報單位 ===
                    _boldLabel('通報單位？'),
                    const SizedBox(height: 6),
                    _radioGroup(
                      options: reportUnits,
                      groupIndex: reportUnitIdx,
                      onChanged: (i) => setState(() => reportUnitIdx = i),
                      horizontal: true,
                    ),

                    // >> 選到「其他」時出現可輸入的欄位
                    if (reportUnitIdx == otherIdx) ...[
                      const SizedBox(height: 10),
                      _inputRowBold('其他通報單位？', '請輸入其他通報單位', otherReportUnitCtrl),
                    ],

                    const SizedBox(height: 16),

                    // === 通報人員 / 電話 ===
                    _inputRowBold('通報人員？', '請填寫通報人員姓名', notifierCtrl),
                    const SizedBox(height: 8),
                    _inputRowBold('電話？', '請填寫接獲通報的聯絡電話', phoneCtrl),
                    const SizedBox(height: 12),

                    // === 接聽時間 / 醫護出發時間 ===
                    _timeRowDateTime(
                      '通報營運控制中心時間',
                      pickUpTime,
                      () => setState(() => pickUpTime = DateTime.now()),
                    ),
                    const SizedBox(height: 8),
                    _timeRowDateTime(
                      '醫護出發時間',
                      ambulanceDepartTime,
                      () => setState(() => ambulanceDepartTime = DateTime.now()),
                    ),
                    const SizedBox(height: 16),

                    // === 事故地點（橫向） ===
                    _boldLabel('事故地點'),
                    const SizedBox(height: 6),
                    _radioGroup(
                      options: accidentPlaces,
                      groupIndex: placeIdx,
                      onChanged: (i) => setState(() => placeIdx = i),
                      horizontal: true,
                    ),
                    const SizedBox(height: 8),
                    _inputRowBold('地點備註', '請填寫地點備註', placeNoteCtrl),
                    const SizedBox(height: 16),

                    // === OCC到場 / 醫護到達時間 ===
                    _checkboxRowBold(
                      '營運控制中心到達現場',
                      occArrived,
                      (v) => setState(() => occArrived = v ?? false),
                    ),
                    const SizedBox(height: 8),
                    _timeRowDateTime(
                      '醫護到達時間',
                      medicArriveTime,
                      () => setState(() => medicArriveTime = DateTime.now()),
                    ),
                    const SizedBox(height: 12),

                    // === 花費時間 / 10分鐘內到達 ===
                    _inputRowBold('花費時間(分秒)', '例如：10分30秒', costCtrl),
                    const SizedBox(height: 8),

                    _boldLabel('10分鐘內到達'),
                    const SizedBox(height: 6),
                    _radioGroup(
                      options: const ['是', '否'],
                      groupIndex: within10min,
                      onChanged: (i) {
                        setState(() {
                          within10min = i;
                          if (i == 0) {
                            reasonLanding = false;
                            reasonOnline  = false;
                            reasonOther   = false;
                            reasonOtherCtrl.clear();
                          }
                        });
                      },
                      horizontal: true,
                    ),

                    // 否 → 顯示可複選原因
                    if (within10min == 1) ...[
                      const SizedBox(height: 10),
                      _boldLabel('未在10分鐘內到達的原因？（可複選）'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        children: [
                          _checkItem(
                            '落地前通知',
                            reasonLanding,
                            (v) => setState(() => reasonLanding = v),
                          ),
                          _checkItem(
                            '線上勤務',
                            reasonOnline,
                            (v) => setState(() => reasonOnline = v),
                          ),
                          _checkItem(
                            '其他',
                            reasonOther,
                            (v) => setState(() => reasonOther = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 勾「落地前通知」→ 顯示落地時間
                      if (reasonLanding)
                        _timeRowDateTime(
                          '落地時間？',
                          landingTime,
                          () => setState(() => landingTime = DateTime.now()),
                        ),

                      // 勾「其他」→ 顯示輸入框
                      if (reasonOther) ...[
                        const SizedBox(height: 10),
                        _inputRowBold('其他原因？', '請填寫其他原因', reasonOtherCtrl),
                      ],
                    ],

                    const SizedBox(height: 12),

                    // === 檢查時間（底部，預設自動填入） ===
                    _timeRowDateTime(
                      '檢查時間',
                      checkTime,
                      () => setState(() => checkTime = DateTime.now()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI 小積木 =================

  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  // —— 粗體標題（左欄） ——
  Widget _boldLabel(String s) => Text(
        s,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      );

  // —— 粗體標題 + 內容（時間：年月日） ——
  Widget _timeRowDate(String label, DateTime? value, VoidCallback onUpdate) {
    return _labeledRowBold(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value == null ? '—' : _fmtDate(value),
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
          const SizedBox(width: 10),
          _smallButton('更新時間', onUpdate),
        ],
      ),
    );
  }

  // —— 粗體標題 + 內容（時間：年月日 時分秒） ——
  Widget _timeRowDateTime(String label, DateTime? value, VoidCallback onUpdate) {
    return _labeledRowBold(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value == null ? '—' : _fmtDateTime(value),
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
          const SizedBox(width: 10),
          _smallButton('更新時間', onUpdate),
        ],
      ),
    );
  }

  // —— 粗體標題 + 輸入框 ——
  Widget _inputRowBold(String label, String hint, TextEditingController ctrl) {
    return _labeledRowBold(
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        ),
      ),
    );
  }

  // —— 粗體標題 + 勾選 ——
  Widget _checkboxRowBold(String label, bool value, ValueChanged<bool?> onChanged) {
    return _labeledRowBold(
      label: label,
      child: Checkbox(value: value, onChanged: onChanged),
    );
  }

  // —— 單選（可橫向換行） ——
  Widget _radioGroup({
    required List<String> options,
    required int? groupIndex,
    required ValueChanged<int> onChanged,
    bool horizontal = false,
  }) {
    if (horizontal) {
      return Wrap(
        spacing: 14,
        runSpacing: 4,
        children: List.generate(options.length, (i) {
          final selected = groupIndex == i;
          return InkWell(
            onTap: () => onChanged(i),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                    size: 20, color: selected ? const Color(0xFF274C4A) : Colors.black45),
                const SizedBox(width: 6),
                Text(options[i], style: const TextStyle(fontSize: 15.5)),
              ],
            ),
          );
        }),
      );
    }
    // 垂直
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(options.length, (i) {
          final selected = groupIndex == i;
          return InkWell(
            onTap: () => onChanged(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                      size: 20, color: selected ? const Color(0xFF274C4A) : Colors.black45),
                  const SizedBox(width: 8),
                  Text(options[i], style: const TextStyle(fontSize: 15.5)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // —— 左欄粗體 右欄內容 —— 
  Widget _labeledRowBold({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Align(alignment: Alignment.centerLeft, child: child)),
        ],
      ),
    );
  }

  Widget _smallButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 12.5)),
      ),
    );
  }

  // ======= 時間格式（本地時間）=======
  String _two(int n) => n.toString().padLeft(2, '0');

  // 年月日
  String _fmtDate(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';

  // 年月日 時分秒
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 '
      '${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';

  // —— 一個小的 checkbox item —— 
  Widget _checkItem(String label, bool value, ValueChanged<bool> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            visualDensity: VisualDensity.compact,
          ),
          Text(label, style: const TextStyle(fontSize: 15.5)),
        ],
      ),
    );
  }
}
