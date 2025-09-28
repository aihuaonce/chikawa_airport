import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/accident_data.dart';
import 'nav2.dart'; // 假設 SavablePage 介面在這裡

// 1. 修正：Widget (AccidentRecordPage) 移除 implements SavablePage
// 讓 GlobalKey 正確指向 State 物件
class AccidentRecordPage extends StatefulWidget {
  final int visitId;

  const AccidentRecordPage({super.key, required this.visitId});

  @override
  State<AccidentRecordPage> createState() => _AccidentRecordPageState();
}

// 2. 修正：State 必須實作 SavablePage 介面，並加入 KeepAlive Mixin
class _AccidentRecordPageState extends State<AccidentRecordPage>
    with AutomaticKeepAliveClientMixin<AccidentRecordPage>
    implements SavablePage {
  // ===============================================
  // 🌟 修正一：實作 SavablePage 的抽象方法 saveData() 🌟
  // 這是 GlobalKey 呼叫的入口點，它會呼叫原本的 _saveData 邏輯
  // ===============================================
  @override
  Future<void> saveData() async {
    print('--- [DEBUG] 🌟 AccidentRecordPage State 成功呼叫 saveData() 🌟');
    await _saveData(); // 呼叫您既有的儲存邏輯
  }

  // ===============================================
  // 修正二：實作 AutomaticKeepAliveClientMixin 的 wantKeepAlive 屬性
  // 確保切換頁籤時這個 State 不會被銷毀
  // ===============================================
  @override
  bool get wantKeepAlive => true;

  // ===============================================
  // 原本的 State 內容 (無變動)
  // ===============================================

  bool _isLoading = true;

  // ===== 外觀參數 =====
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1100;
  static const double _radius = 16;

  // ===== 選項列表 (略，內容與您提供的相同) =====
  final List<String> reportUnits = const [
    'T1-OCC',
    'T2-OCC',
    '華航',
    '長榮',
    '虎航',
    '星宇',
    '采盟',
    '昇恆昌',
    '病人或家屬',
    '其他',
  ];

  final List<String> placeGroups = const [
    '第一航廈',
    '第二航廈',
    '遠端機坪',
    '貨運站/機坪其他',
    '諾富特飯店',
    '飛機機艙內',
  ];

  final List<String> t1Places = const [
    '出境查驗台',
    '入境查驗台',
    '貴賓室',
    '出境大廳(管制區外)',
    '出境層(管制區內)',
    '入境大廳(管制區外)',
    '入境層(管制區內)',
    '美食街',
    '航警局',
    '機場捷運',
    '1號停車場',
    '2號停車場',
    '出境巴士下車處',
    '入境巴士上車處',
    '出境安檢',
    '行李轉盤',
    '海關處',
    '登機門A1',
    '登機門A2',
    '登機門A3',
    '登機門A4',
    '登機門A5',
    '登機門A6',
    '登機門A7',
    '登機門A8',
    '登機門A9',
    'A區轉機櫃檯',
    'B區轉機櫃檯',
    'A區轉機安檢',
    'B區轉機安檢',
    '航廈電車(管制區內)',
    '航廈電車(管制區外)',
    '其他位置',
    '登機門B1',
    '登機門B2',
    '登機門B3',
    '登機門B4',
    '登機門B5',
    '登機門B6',
    '登機門B7',
    '登機門B8',
    '登機門B9',
    '登機門B1R',
  ];

  final List<String> t2Places = const [
    '出境查驗台',
    '入境查驗台',
    '貴賓室',
    '出境大廳(管制區外)',
    '出境層(管制區內)',
    '入境大廳(管制區外)',
    '入境層(管制區內)',
    '美食廣場',
    '航警局',
    '機場捷運',
    '3號停車場',
    '4號停車場',
    '北側觀景台',
    '南側觀景台',
    '北揚5樓',
    '南側5樓',
    '登機門D1',
    '登機門D2',
    '登機門D3',
    '登機門D4',
    '登機門D5',
    '登機門D6',
    '登機門D7',
    '登機門D8',
    '登機門D9',
    '登機門D10',
    '登機門C1',
    '登機門C2',
    '登機門C3',
    '登機門C4',
    '登機門C5',
    '登機門C6',
    '登機門C7',
    '登機門C8',
    '登機門C9',
    'C區轉機櫃檯',
    'C區轉機安檢',
    '航廈電車(管制區內)',
    '航廈電車(管制區外)',
    '其他位置',
    '登機門C5R',
  ];

  final List<String> remotePlaces = const [
    '601',
    '602',
    '603',
    '604',
    '605',
    '606',
    '607',
    '608',
    '609',
    '610',
    '611',
    '612',
    '613',
    '614',
    '615',
  ];

  final List<String> cargoPlaces = const [
    '滑行道',
    '506',
    '507',
    '508',
    '509',
    '510',
    '511',
    '512',
    '513',
    '514',
    '515',
    '台飛棚廠',
    '維修停機坪',
    '長榮航太',
    '機坪其他位置',
  ];

  final List<String> novotelPlaces = const ['諾富特飯店'];
  final List<String> cabinPlaces = const ['飛機機艙內'];

  // 文字欄位控制器
  final TextEditingController notifierCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController placeNoteCtrl = TextEditingController();
  final TextEditingController costCtrl = TextEditingController();
  final TextEditingController otherReasonCtrl = TextEditingController();
  final TextEditingController otherReportUnitCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
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

  Future<void> _loadData() async {
    final dao = context.read<AccidentRecordsDao>();
    final accidentData = context.read<AccidentData>();
    final record = await dao.getByVisitId(widget.visitId);

    if (!mounted) return;

    if (record != null) {
      // 從資料庫載入到 AccidentData (略，邏輯與您提供的相同)
      accidentData.incidentDate = record.incidentDate;
      accidentData.notifyTime = record.notifyTime;
      accidentData.pickUpTime = record.pickUpTime;
      accidentData.medicDepartTime = record.ambulanceDepartTime;
      accidentData.medicArriveTime = record.medicArriveTime;
      accidentData.landingTime = record.landingTime;
      accidentData.checkTime = record.checkTime;
      accidentData.reportUnitIdx = record.reportUnitIdx;
      accidentData.otherReportUnit = record.otherReportUnit;
      accidentData.notifier = record.notifier;
      accidentData.phone = record.phone;
      accidentData.placeGroupIdx = record.placeIdx;
      accidentData.placeNote = record.placeNote;

      accidentData.t1Selected = record.t1PlaceIdx;
      accidentData.t2Selected = record.t2PlaceIdx;
      accidentData.remoteSelected = record.remotePlaceIdx;
      accidentData.cargoSelected = record.cargoPlaceIdx;
      accidentData.novotelSelected = record.novotelPlaceIdx;
      accidentData.cabinSelected = record.cabinPlaceIdx;

      accidentData.occArrived = record.occArrived;
      accidentData.cost = record.cost;
      accidentData.within10min = record.within10min;
      accidentData.reasonPreLanding = record.reasonLanding;
      accidentData.reasonOnDuty = record.reasonOnline;
      accidentData.reasonOther = record.reasonOther;
      accidentData.otherReasonText = record.reasonOtherText;
      accidentData.update();
    } else {
      final now = DateTime.now();
      accidentData.incidentDate = now;
      accidentData.notifyTime = now;
      accidentData.pickUpTime = now;
      accidentData.medicDepartTime = now;
      accidentData.medicArriveTime = now;
      accidentData.checkTime = now;
      accidentData.update();
    }

    _syncControllersFromData(accidentData);

    setState(() {
      _isLoading = false;
    });
  }

  void _syncControllersFromData(AccidentData accidentData) {
    notifierCtrl.text = accidentData.notifier ?? '';
    phoneCtrl.text = accidentData.phone ?? '';
    placeNoteCtrl.text = accidentData.placeNote ?? '';
    costCtrl.text = accidentData.cost ?? '';
    otherReasonCtrl.text = accidentData.otherReasonText ?? '';
    otherReportUnitCtrl.text = accidentData.otherReportUnit ?? '';
  }

  // ⚠️ 注意：這個函式是您原本的儲存邏輯，現在由上面的 saveData() 呼叫。
  Future<void> _saveData() async {
    print('--- [DEBUG] _saveData() 函式已啟動 ---');
    final dao = context.read<AccidentRecordsDao>();
    final accidentData = context.read<AccidentData>();

    // 從控制器同步到 AccidentData (略，邏輯與您提供的相同)
    accidentData.notifier = notifierCtrl.text.trim().isEmpty
        ? null
        : notifierCtrl.text.trim();
    accidentData.phone = phoneCtrl.text.trim().isEmpty
        ? null
        : phoneCtrl.text.trim();
    accidentData.placeNote = placeNoteCtrl.text.trim().isEmpty
        ? null
        : placeNoteCtrl.text.trim();
    accidentData.cost = costCtrl.text.trim().isEmpty
        ? null
        : costCtrl.text.trim();
    accidentData.otherReasonText = otherReasonCtrl.text.trim().isEmpty
        ? null
        : otherReasonCtrl.text.trim();
    accidentData.otherReportUnit = otherReportUnitCtrl.text.trim().isEmpty
        ? null
        : otherReportUnitCtrl.text.trim();

    print('--- [DEBUG] 準備呼叫 DAO 儲存 ---');
    print('visitId: ${widget.visitId}');
    print('incidentDate: ${accidentData.incidentDate}');
    print('notifier: ${accidentData.notifier}');
    print('t1Selected: ${accidentData.t1Selected}');

    await dao.upsertByVisitId(
      visitId: widget.visitId,
      incidentDate: accidentData.incidentDate,
      notifyTime: accidentData.notifyTime,
      pickUpTime: accidentData.pickUpTime,
      medicArriveTime: accidentData.medicArriveTime,
      ambulanceDepartTime: accidentData.medicDepartTime,
      checkTime: accidentData.checkTime,
      landingTime: accidentData.landingTime,
      reportUnitIdx: accidentData.reportUnitIdx,
      otherReportUnit: accidentData.otherReportUnit,
      notifier: accidentData.notifier,
      phone: accidentData.phone,
      placeIdx: accidentData.placeGroupIdx,
      placeNote: accidentData.placeNote,

      t1PlaceIdx: accidentData.t1Selected,
      t2PlaceIdx: accidentData.t2Selected,
      remotePlaceIdx: accidentData.remoteSelected,
      cargoPlaceIdx: accidentData.cargoSelected,
      novotelPlaceIdx: accidentData.novotelSelected,
      cabinPlaceIdx: accidentData.cabinSelected,

      occArrived: accidentData.occArrived,
      cost: accidentData.cost,
      within10min: accidentData.within10min,
      reasonLanding: accidentData.reasonPreLanding,
      reasonOnline: accidentData.reasonOnDuty,
      reasonOther: accidentData.reasonOther,
      reasonOtherText: accidentData.otherReasonText,
    );

    print('--- AccidentRecord 儲存完成 ---');

    if (!mounted) return;
    // 儲存完成後清空 AccidentData，為下一筆新增資料做準備
    // ⚠️ 備註：在多頁籤情況下，如果 App 沒有重新啟動，這裡清空可能會影響資料準確性，請依據您的 App 邏輯確認是否需要清空。
    // accidentData.clear();
  }

  void _calculateTimeDifference(AccidentData accidentData) {
    if (accidentData.notifyTime != null &&
        accidentData.medicArriveTime != null) {
      final difference = accidentData.medicArriveTime!.difference(
        accidentData.notifyTime!,
      );
      final minutes = difference.inMinutes;
      final seconds = difference.inSeconds % 60;

      costCtrl.text = '${minutes}分${seconds}秒';
      accidentData.cost = costCtrl.text;

      if (difference.inMinutes < 10) {
        accidentData.within10min = 0;
      } else {
        accidentData.within10min = 1;
      }
      accidentData.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 修正三：呼叫 super.build(context) 以啟用 AutomaticKeepAliveClientMixin 的功能 🌟
    super.build(context);

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final accidentDataInstance = context.read<AccidentData>();

    return Consumer<AccidentData>(
      builder: (context, accidentData, _) {
        // ... (以下 UI 程式碼保持不變) ...
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(
            horizontal: _outerHpad,
            vertical: 16,
          ),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
                child: _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _datePicker(
                        label: '事發日期？',
                        value: accidentData.incidentDate,
                        onChanged: (dt) {
                          accidentData.incidentDate = dt;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 8),
                      _dateTimePicker(
                        label: '通報時間？',
                        value: accidentData.notifyTime,
                        onChanged: (dt) {
                          accidentData.notifyTime = dt;
                          accidentData.update();
                          _calculateTimeDifference(accidentData);
                        },
                      ),
                      const SizedBox(height: 16),

                      _boldLabel('通報單位？'),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: reportUnits,
                        groupIndex: accidentData.reportUnitIdx,
                        onChanged: (i) {
                          accidentData.reportUnitIdx = i;
                          accidentData.update();
                        },
                      ),
                      if (accidentData.reportUnitIdx ==
                          reportUnits.indexOf('其他')) ...[
                        const SizedBox(height: 8),
                        _inputRowBold(
                          '其他通報單位',
                          '請輸入其他通報單位',
                          otherReportUnitCtrl,
                        ),
                      ],
                      const SizedBox(height: 16),

                      _inputRowBold('通報人員？', '請填寫通報人員姓名', notifierCtrl),
                      const SizedBox(height: 8),
                      _inputRowBold('電話？', '請填寫接獲通報的聯絡電話', phoneCtrl),
                      const SizedBox(height: 12),

                      _dateTimePicker(
                        label: '通報營運控制中心時間',
                        value: accidentData.pickUpTime,
                        onChanged: (dt) {
                          accidentData.pickUpTime = dt;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 8),
                      _dateTimePicker(
                        label: '醫護出發時間',
                        value: accidentData.medicDepartTime,
                        onChanged: (dt) {
                          accidentData.medicDepartTime = dt;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 16),

                      _boldLabel('事故地點'),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: placeGroups,
                        groupIndex: accidentData.placeGroupIdx,
                        onChanged: (i) {
                          accidentData.placeGroupIdx = i;
                          accidentData.t1Selected = accidentData.t2Selected =
                              accidentData.remoteSelected =
                                  accidentData.cargoSelected =
                                      accidentData.novotelSelected =
                                          accidentData.cabinSelected = null;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 8),
                      _placeSubOptions(accidentData),
                      const SizedBox(height: 8),
                      _inputRowBold('地點備註', '請填寫地點備註', placeNoteCtrl),
                      const SizedBox(height: 16),

                      _checkboxRowBold('營運控制中心到達現場', accidentData.occArrived, (
                        v,
                      ) {
                        accidentData.occArrived = v ?? false;
                        if (accidentData.occArrived) {
                          accidentData.medicArriveTime = DateTime.now();
                          _calculateTimeDifference(accidentData);
                        }
                        accidentData.update();
                      }),
                      const SizedBox(height: 8),
                      _dateTimePicker(
                        label: '醫護到達時間',
                        value: accidentData.medicArriveTime,
                        onChanged: (dt) {
                          accidentData.medicArriveTime = dt;
                          accidentData.update();
                          _calculateTimeDifference(accidentData);
                        },
                      ),
                      const SizedBox(height: 12),

                      _inputRowBold('花費時間(分秒)', '例如：10分30秒', costCtrl),
                      const SizedBox(height: 8),
                      _boldLabel('10分鐘內到達'),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: const ['是', '否'],
                        groupIndex: accidentData.within10min,
                        onChanged: (i) {
                          accidentData.within10min = i;
                          if (i == 0) {
                            accidentData.reasonPreLanding = false;
                            accidentData.reasonOnDuty = false;
                            accidentData.reasonOther = false;
                            accidentData.landingTime = null;
                            otherReasonCtrl.clear();
                          }
                          accidentData.update();
                        },
                      ),

                      if (accidentData.within10min == 1) ...[
                        const SizedBox(height: 10),
                        _boldLabel('未在10分鐘內到達的原因（可複選）'),
                        const SizedBox(height: 6),
                        _reasonCheckboxRow(
                          label: '落地前通知',
                          value: accidentData.reasonPreLanding,
                          onChanged: (v) {
                            accidentData.reasonPreLanding = v ?? false;
                            if (accidentData.reasonPreLanding &&
                                accidentData.landingTime == null) {
                              accidentData.landingTime = DateTime.now();
                            }
                            accidentData.update();
                          },
                        ),
                        _reasonCheckboxRow(
                          label: '線上勤務',
                          value: accidentData.reasonOnDuty,
                          onChanged: (v) {
                            accidentData.reasonOnDuty = v ?? false;
                            accidentData.update();
                          },
                        ),
                        _reasonCheckboxRow(
                          label: '其他',
                          value: accidentData.reasonOther,
                          onChanged: (v) {
                            accidentData.reasonOther = v ?? false;
                            accidentData.update();
                          },
                        ),
                        if (accidentData.reasonOther) ...[
                          const SizedBox(height: 6),
                          _inputRowBold('其他原因', '請填寫其他原因', otherReasonCtrl),
                        ],
                        if (accidentData.reasonPreLanding) ...[
                          const SizedBox(height: 6),
                          _dateTimePicker(
                            label: '落地時間',
                            value: accidentData.landingTime,
                            onChanged: (dt) {
                              accidentData.landingTime = dt;
                              accidentData.update();
                            },
                          ),
                        ],
                      ],
                      const SizedBox(height: 12),

                      _dateTimePicker(
                        label: '檢查時間',
                        value: accidentData.checkTime,
                        onChanged: (dt) {
                          accidentData.checkTime = dt;
                          accidentData.update();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= UI 小積木 (略，內容與您提供的相同) =================
  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
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
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
        ],
      ),
    );
  }

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
                  onChanged(
                    DateTime(
                      newDate.year,
                      newDate.month,
                      newDate.day,
                      newTime.hour,
                      newTime.minute,
                    ),
                  );
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
              if (newDate != null) onChanged(newDate);
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkboxRowBold(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
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

  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDate(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 ${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';

  Widget _placeSubOptions(AccidentData accidentData) {
    if (accidentData.placeGroupIdx == null) return const SizedBox.shrink();
    final idx = accidentData.placeGroupIdx!;

    List<String> opts;
    int? groupIndex;
    ValueChanged<int> onChanged;

    switch (idx) {
      case 0:
        opts = t1Places;
        groupIndex = accidentData.t1Selected;
        onChanged = (i) {
          accidentData.t1Selected = i;
          accidentData.update();
        };
        break;
      case 1:
        opts = t2Places;
        groupIndex = accidentData.t2Selected;
        onChanged = (i) {
          accidentData.t2Selected = i;
          accidentData.update();
        };
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = accidentData.remoteSelected;
        onChanged = (i) {
          accidentData.remoteSelected = i;
          accidentData.update();
        };
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = accidentData.cargoSelected;
        onChanged = (i) {
          accidentData.cargoSelected = i;
          accidentData.update();
        };
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = accidentData.novotelSelected;
        onChanged = (i) {
          accidentData.novotelSelected = i;
          accidentData.update();
        };
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = accidentData.cabinSelected;
        onChanged = (i) {
          accidentData.cabinSelected = i;
          accidentData.update();
        };
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
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
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
