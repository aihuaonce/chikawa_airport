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

  // ===== 狀態：時間 =====
  DateTime? incidentDate;          // 事發日期（只顯示年月日）
  DateTime? notifyTime;            // 通報時間（年月日 時分秒）
  DateTime? pickUpTime;            // 通報營運控制中心時間
  DateTime? medicDepartTime;       // 醫護出發時間
  DateTime? medicArriveTime;       // 醫護到達時間
  DateTime? landingTime;           // 落地時間（原因：落地前通知）
  DateTime? checkTime;             // 檢查時間（頁尾）

  // ===== 通報單位（不預設選中）=====
  final List<String> reportUnits = const [
    'T1-OCC', 'T2-OCC', '華航', '長榮', '虎航', '星宇', '采盟', '昇恆昌', '病人或家屬', '其他',
  ];
  int? reportUnitIdx; // <= 不預設

  // ===== 事故地點（大類：不預設選中）=====
  final List<String> placeGroups = const [
    '第一航廈', '第二航廈', '遠端機坪', '貨運站/機坪其他', '諾富特飯店', '飛機機艙內',
  ];
  int? placeGroupIdx; // <= 不預設

  // 各大類細項（單選）
  int? t1Selected, t2Selected, remoteSelected, cargoSelected, novotelSelected, cabinSelected;

  // 第一航廈
  final List<String> t1Places = const [
    '出境查驗台','入境查驗台','貴賓室',
    '出境大廳(管制區外)','出境層(管制區內)',
    '入境大廳(管制區外)','入境層(管制區內)',
    '美食街','航警局','機場捷運','1號停車場','2號停車場',
    '出境巴士下車處','入境巴士上車處','出境安檢','行李轉盤','海關處',
    // A、B登機門 & 轉機櫃檯/安檢
    '登機門A1','登機門A2','登機門A3','登機門A4','登機門A5','登機門A6','登機門A7','登機門A8','登機門A9',
    'A區轉機櫃檯','B區轉機櫃檯','A區轉機安檢','B區轉機安檢',
    '航廈電車(管制區內)','航廈電車(管制區外)','其他位置',
    '登機門B1','登機門B2','登機門B3','登機門B4','登機門B5','登機門B6','登機門B7','登機門B8','登機門B9','登機門B1R',
  ];

  // 第二航廈
  final List<String> t2Places = const [
    '出境查驗台','入境查驗台','貴賓室',
    '出境大廳(管制區外)','出境層(管制區內)',
    '入境大廳(管制區外)','入境層(管制區內)',
    '美食廣場','航警局','機場捷運','3號停車場','4號停車場',
    '北側觀景台','南側觀景台','北揚5樓','南側5樓',
    // D、C登機門 & 轉機櫃檯/安檢
    '登機門D1','登機門D2','登機門D3','登機門D4','登機門D5','登機門D6','登機門D7','登機門D8','登機門D9','登機門D10',
    '登機門C1','登機門C2','登機門C3','登機門C4','登機門C5','登機門C6','登機門C7','登機門C8','登機門C9',
    'C區轉機櫃檯','C區轉機安檢','航廈電車(管制區內)','航廈電車(管制區外)','其他位置','登機門C5R',
  ];

  // 遠端機坪
  final List<String> remotePlaces = const [
    '601','602','603','604','605','606','607','608','609','610','611','612','613','614','615',
  ];

  // 貨運站/機坪其他
  final List<String> cargoPlaces = const [
    '滑行道',
    '506','507','508','509','510','511','512','513','514','515',
    '台飛棚廠','維修停機坪','長榮航太','機坪其他位置',
  ];

  // 諾富特、機艙
  final List<String> novotelPlaces = const ['諾富特飯店'];
  final List<String> cabinPlaces   = const ['飛機機艙內'];

  // 文字欄位
  final TextEditingController notifierCtrl   = TextEditingController(); // 通報人員
  final TextEditingController phoneCtrl      = TextEditingController(); // 電話
  final TextEditingController placeNoteCtrl  = TextEditingController(); // 地點備註
  final TextEditingController costCtrl       = TextEditingController(); // 花費時間(分秒)
  final TextEditingController otherReasonCtrl= TextEditingController(); // 其他原因
  final TextEditingController otherReportUnitCtrl = TextEditingController(); // 其他通報單位

  bool occArrived = false; // 營運控制中心到達現場？
  int? within10min;        // 10分鐘內到達？ 0=是, 1=否

  // 未在10分鐘內到達的原因（可複選）
  bool reasonPreLanding = false; // 落地前通知 → 顯示落地時間
  bool reasonOnDuty     = false; // 線上勤務
  bool reasonOther      = false; // 其他 → 顯示文字框

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    incidentDate   = now;
    notifyTime     = now;
    pickUpTime     = now;
    medicDepartTime= now;
    medicArriveTime= now;
    checkTime      = now;
    // placeGroupIdx、reportUnitIdx 皆為 null → 不預設選中
  }

  @override
  void dispose() {
    notifierCtrl.dispose();
    phoneCtrl.dispose();
    placeNoteCtrl.dispose();
    costCtrl.dispose();
    otherReasonCtrl.dispose();
    otherReportUnitCtrl.dispose();
    super.dispose();
  }

  // ===== 醫護到達時間計算邏輯 =====
  void _calculateTimeDifference() {
    if (notifyTime != null && medicArriveTime != null) {
      final difference = medicArriveTime!.difference(notifyTime!);
      final minutes = difference.inMinutes;
      final seconds = difference.inSeconds % 60;

      // 更新花費時間輸入框
      costCtrl.text = '${minutes}分${seconds}秒';

      // 判斷是否小於10分鐘
      if (difference.inMinutes < 10) {
        setState(() => within10min = 0); // 是
      } else {
        setState(() => within10min = 1); // 否
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _datePicker(
                      label: '事發日期？',
                      value: incidentDate,
                      onChanged: (dt) => setState(() => incidentDate = dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimePicker(
                      label: '通報時間？',
                      value: notifyTime,
                      onChanged: (dt) {
                        setState(() {
                          notifyTime = dt;
                          _calculateTimeDifference();
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // === 通報單位（不預設） ===
                    _boldLabel('通報單位？'),
                    const SizedBox(height: 6),
                    _radioWrap(
                      options: reportUnits,
                      groupIndex: reportUnitIdx,
                      onChanged: (i) => setState(() => reportUnitIdx = i),
                    ),
                    if (reportUnitIdx == reportUnits.indexOf('其他')) ...[
                      const SizedBox(height: 8),
                      _inputRowBold('其他通報單位', '請輸入其他通報單位', otherReportUnitCtrl),
                    ],
                    const SizedBox(height: 16),
                    
                    // === 通報人員 / 電話 ===
                    _inputRowBold('通報人員？', '請填寫通報人員姓名', notifierCtrl),
                    const SizedBox(height: 8),
                    _inputRowBold('電話？', '請填寫接獲通報的聯絡電話', phoneCtrl),
                    const SizedBox(height: 12),

                    // === 接聽時間 / 醫護出發時間 ===
                    _dateTimePicker(
                      label: '通報營運控制中心時間',
                      value: pickUpTime,
                      onChanged: (dt) => setState(() => pickUpTime = dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimePicker(
                      label: '醫護出發時間',
                      value: medicDepartTime,
                      onChanged: (dt) => setState(() => medicDepartTime = dt),
                    ),
                    const SizedBox(height: 16),

                    // === 事故地點（大類） ===
                    _boldLabel('事故地點'),
                    const SizedBox(height: 6),
                    _radioWrap(
                      options: placeGroups,
                      groupIndex: placeGroupIdx,
                      onChanged: (i) => setState(() {
                        placeGroupIdx = i;
                        t1Selected = t2Selected = remoteSelected =
                          cargoSelected = novotelSelected = cabinSelected = null;
                      }),
                    ),
                    const SizedBox(height: 8),
                    _placeSubOptions(),
                    const SizedBox(height: 8),
                    _inputRowBold('地點備註', '請填寫地點備註', placeNoteCtrl),
                    const SizedBox(height: 16),

                    // === OCC到場 / 醫護到達時間 ===
                    _checkboxRowBold(
                      '營運控制中心到達現場',
                      occArrived,
                      (v) {
                        setState(() {
                          occArrived = v ?? false;
                          if (occArrived) {
                            medicArriveTime = DateTime.now();
                            _calculateTimeDifference();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _dateTimePicker(
                      label: '醫護到達時間',
                      value: medicArriveTime,
                      onChanged: (dt) {
                        setState(() {
                          medicArriveTime = dt;
                          _calculateTimeDifference();
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // === 花費時間 / 10分鐘內到達 ===
                    _inputRowBold('花費時間(分秒)', '例如：10分30秒', costCtrl),
                    const SizedBox(height: 8),
                    _boldLabel('10分鐘內到達'),
                    const SizedBox(height: 6),
                    _radioWrap(
                      options: const ['是', '否'],
                      groupIndex: within10min,
                      onChanged: (i) => setState(() {
                        within10min = i;
                        if (i == 0) {
                          reasonPreLanding = false;
                          reasonOnDuty = false;
                          reasonOther = false;
                          landingTime = null;
                          otherReasonCtrl.clear();
                        }
                      }),
                    ),

                    if (within10min == 1) ...[
                      const SizedBox(height: 10),
                      _boldLabel('未在10分鐘內到達的原因（可複選）'),
                      const SizedBox(height: 6),
                      _reasonCheckboxRow(
                        label: '落地前通知',
                        value: reasonPreLanding,
                        onChanged: (v) => setState(() {
                          reasonPreLanding = v ?? false;
                          if (reasonPreLanding && landingTime == null) {
                            landingTime = DateTime.now();
                          }
                        }),
                      ),
                      _reasonCheckboxRow(
                        label: '線上勤務',
                        value: reasonOnDuty,
                        onChanged: (v) => setState(() => reasonOnDuty = v ?? false),
                      ),
                      _reasonCheckboxRow(
                        label: '其他',
                        value: reasonOther,
                        onChanged: (v) => setState(() => reasonOther = v ?? false),
                      ),
                      if (reasonOther) ...[
                        const SizedBox(height: 6),
                        _inputRowBold('其他原因', '請填寫其他原因', otherReasonCtrl),
                      ],
                      if (reasonPreLanding) ...[
                        const SizedBox(height: 6),
                        _dateTimePicker(
                          label: '落地時間',
                          value: landingTime,
                          onChanged: (dt) => setState(() => landingTime = dt),
                        ),
                      ],
                    ],
                    const SizedBox(height: 12),

                    // === 檢查時間（底部，預設自動填入） ===
                    _dateTimePicker(
                      label: '檢查時間',
                      value: checkTime,
                      onChanged: (dt) => setState(() => checkTime = dt),
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

  Widget _boldLabel(String s) => Text(
        s,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      );

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
  
  // 適用於時分秒的選擇器
  Widget _dateTimePicker({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return _labeledRowBold(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (newDate != null) {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
                );
                if (newTime != null) {
                  final result = DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                    newTime.hour,
                    newTime.minute,
                  );
                  onChanged(result);
                }
              }
            },
            child: Text(
              value == null ? '請選擇時間' : _fmtDateTime(value),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          _smallButton('更新時間', () => onChanged(DateTime.now())),
        ],
      ),
    );
  }
  
  // 適用於只選日期（年月日）的選擇器
  Widget _datePicker({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return _labeledRowBold(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (newDate != null) {
                onChanged(newDate);
              }
            },
            child: Text(
              value == null ? '請選擇日期' : _fmtDate(value),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          _smallButton('更新時間', () => onChanged(DateTime.now())),
        ],
      ),
    );
  }

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

  Widget _checkboxRowBold(String label, bool value, ValueChanged<bool?> onChanged) {
    return _labeledRowBold(
      label: label,
      child: Checkbox(value: value, onChanged: onChanged),
    );
  }

  Widget _radioWrap({
    required List<String> options,
    required int? groupIndex,
    required ValueChanged<int> onChanged,
  }) {
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
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? const Color(0xFF274C4A) : Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(options[i], style: const TextStyle(fontSize: 15.5)),
            ],
          ),
        );
      }),
    );
  }

  Widget _reasonCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 15.5)),
      ],
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

  String _fmtDate(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';

  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 '
      '${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';

  // ===== 事故地點細項 =====
  Widget _placeSubOptions() {
    if (placeGroupIdx == null) {
      return const SizedBox.shrink();
    }
    final idx = placeGroupIdx!;

    List<String> opts;
    int? groupIndex;
    ValueChanged<int> onChanged;

    switch (idx) {
      case 0:
        opts = t1Places;
        groupIndex = t1Selected;
        onChanged = (i) => setState(() => t1Selected = i);
        break;
      case 1:
        opts = t2Places;
        groupIndex = t2Selected;
        onChanged = (i) => setState(() => t2Selected = i);
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = remoteSelected;
        onChanged = (i) => setState(() => remoteSelected = i);
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = cargoSelected;
        onChanged = (i) => setState(() => cargoSelected = i);
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = novotelSelected;
        onChanged = (i) => setState(() => novotelSelected = i);
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = cabinSelected;
        onChanged = (i) => setState(() => cabinSelected = i);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Wrap(
        spacing: 18,
        runSpacing: 6,
        children: List.generate(opts.length, (i) {
          final selected = groupIndex == i;
          return InkWell(
            onTap: () => onChanged(i),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: selected ? const Color(0xFF274C4A) : Colors.black45,
                ),
                const SizedBox(width: 6),
                Text(opts[i], style: const TextStyle(fontSize: 15.5)),
              ],
            ),
          );
        }),
      ),
    );
  }
}