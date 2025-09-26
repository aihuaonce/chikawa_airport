// lib/pages/AccidentRecord.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart'; // 引入 DAOs

class AccidentRecordPage extends StatefulWidget {
  final int visitId;
  final VoidCallback? closeNav2; // 回首頁 callback

  const AccidentRecordPage({super.key, required this.visitId, this.closeNav2});

  @override
  State<AccidentRecordPage> createState() => _AccidentRecordPageState();
}

class _AccidentRecordPageState extends State<AccidentRecordPage> {
  // ===== 外觀參數 (保持不變) =====
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1100;
  // static const double _radius = 16; // 註解掉未使用的變數

  // ===== 狀態 (保持不變) =====
  DateTime? incidentDate;
  DateTime? notifyTime;
  DateTime? pickUpTime;
  DateTime? medicArriveTime;
  DateTime? ambulanceDepartTime;
  DateTime? checkTime;

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
  int? reportUnitIdx;
  final TextEditingController otherReportUnitCtrl = TextEditingController();

  final List<String> accidentPlaces = const [
    '第一航廈',
    '第二航廈',
    '遠端機坪',
    '貨運站/機坪其他',
    '諾富特飯店',
    '飛機機艙內',
  ];
  int? placeIdx;

  final TextEditingController notifierCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController placeNoteCtrl = TextEditingController();
  final TextEditingController costCtrl = TextEditingController();

  bool occArrived = false;
  int? within10min; // 0:是, 1:否
  bool reasonLanding = false;
  bool reasonOnline = false;
  bool reasonOther = false;
  final TextEditingController reasonOtherCtrl = TextEditingController();
  DateTime? landingTime;

  @override
  void initState() {
    super.initState();
    // 呼叫載入資料
    _loadData();
  }

  // ★ 載入資料
  Future<void> _loadData() async {
    final dao = context.read<AccidentRecordsDao>();
    final record = await dao.getByVisitId(widget.visitId);

    if (record != null) {
      setState(() {
        incidentDate = record.incidentDate;
        notifyTime = record.notifyTime;
        pickUpTime = record.pickUpTime;
        medicArriveTime = record.medicArriveTime;
        ambulanceDepartTime = record.ambulanceDepartTime;
        checkTime = record.checkTime;
        landingTime = record.landingTime;
        reportUnitIdx = record.reportUnitIdx;
        otherReportUnitCtrl.text = record.otherReportUnit ?? '';
        notifierCtrl.text = record.notifier ?? '';
        phoneCtrl.text = record.phone ?? '';
        placeIdx = record.placeIdx;
        placeNoteCtrl.text = record.placeNote ?? '';
        occArrived = record.occArrived;
        costCtrl.text = record.cost ?? '';
        within10min = record.within10min;
        reasonLanding = record.reasonLanding;
        reasonOnline = record.reasonOnline;
        reasonOther = record.reasonOther;
        reasonOtherCtrl.text = record.reasonOtherText ?? '';
      });
    } else {
      // 如果沒有紀錄，初始化時間為現在
      final now = DateTime.now();
      setState(() {
        incidentDate = notifyTime = pickUpTime = medicArriveTime =
            ambulanceDepartTime = checkTime = landingTime = now;
      });
    }
  }

  // ★ 儲存資料
  Future<void> _saveData() async {
    final dao = context.read<AccidentRecordsDao>();

    // 收集所有資料
    await dao.upsertByVisitId(
      visitId: widget.visitId,
      incidentDate: incidentDate,
      notifyTime: notifyTime,
      pickUpTime: pickUpTime,
      medicArriveTime: medicArriveTime,
      ambulanceDepartTime: ambulanceDepartTime,
      checkTime: checkTime,
      landingTime: landingTime,
      reportUnitIdx: reportUnitIdx,
      otherReportUnit: otherReportUnitCtrl.text.trim().isEmpty
          ? null
          : otherReportUnitCtrl.text.trim(),
      notifier: notifierCtrl.text.trim().isEmpty
          ? null
          : notifierCtrl.text.trim(),
      phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
      placeIdx: placeIdx,
      placeNote: placeNoteCtrl.text.trim().isEmpty
          ? null
          : placeNoteCtrl.text.trim(),
      occArrived: occArrived,
      cost: costCtrl.text.trim().isEmpty ? null : costCtrl.text.trim(),
      within10min: within10min,
      reasonLanding: reasonLanding,
      reasonOnline: reasonOnline,
      reasonOther: reasonOther,
      reasonOtherText: reasonOtherCtrl.text.trim().isEmpty
          ? null
          : reasonOtherCtrl.text.trim(),
    );

    // 儲存完成後，執行回首頁 callback
    widget.closeNav2?.call();
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
    // 移除 Nav2Page 嵌套，只需回傳頁面內容
    final otherIdx = reportUnits.length - 1;

    return Container(
      color: const Color(0xFFE6F6FB),
      padding: const EdgeInsets.symmetric(horizontal: _outerHpad, vertical: 16),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _timeRowDate(
                  '事發日期',
                  incidentDate,
                  // 保持原來的更新邏輯
                  () async {
                    final newDate = await showDatePicker(
                      context: context,
                      initialDate: incidentDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() => incidentDate = newDate);
                    }
                  },
                ),
                const SizedBox(height: 8),
                _timeRowDateTime(
                  '通報時間',
                  notifyTime,
                  // 保持原來的更新邏輯，但改為讓使用者選擇時間
                  () async {
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        notifyTime ?? DateTime.now(),
                      ),
                    );
                    if (newTime != null) {
                      final now = DateTime.now();
                      setState(
                        () => notifyTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          newTime.hour,
                          newTime.minute,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                _boldLabel('通報單位'),
                const SizedBox(height: 6),
                _radioGroup(
                  options: reportUnits,
                  groupIndex: reportUnitIdx,
                  onChanged: (i) => setState(() => reportUnitIdx = i),
                  horizontal: true,
                ),
                if (reportUnitIdx == otherIdx)
                  _inputRowBold('其他通報單位', '請輸入其他通報單位', otherReportUnitCtrl),
                const SizedBox(height: 16),
                _inputRowBold('通報人員', '請填寫通報人員姓名', notifierCtrl),
                const SizedBox(height: 8),
                _inputRowBold('電話', '請填寫接獲通報的聯絡電話', phoneCtrl),
                const SizedBox(height: 12),
                _timeRowDateTime('通報營運控制中心時間', pickUpTime, () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      pickUpTime ?? DateTime.now(),
                    ),
                  );
                  if (newTime != null) {
                    final now = DateTime.now();
                    setState(
                      () => pickUpTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        newTime.hour,
                        newTime.minute,
                      ),
                    );
                  }
                }),
                const SizedBox(height: 8),
                _timeRowDateTime('醫護出發時間', ambulanceDepartTime, () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      ambulanceDepartTime ?? DateTime.now(),
                    ),
                  );
                  if (newTime != null) {
                    final now = DateTime.now();
                    setState(
                      () => ambulanceDepartTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        newTime.hour,
                        newTime.minute,
                      ),
                    );
                  }
                }),
                const SizedBox(height: 16),
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
                _checkboxRowBold(
                  '營運控制中心到達現場',
                  occArrived,
                  (v) => setState(() => occArrived = v ?? false),
                ),
                const SizedBox(height: 8),
                _timeRowDateTime('醫護到達時間', medicArriveTime, () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      medicArriveTime ?? DateTime.now(),
                    ),
                  );
                  if (newTime != null) {
                    final now = DateTime.now();
                    setState(
                      () => medicArriveTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        newTime.hour,
                        newTime.minute,
                      ),
                    );
                  }
                }),
                const SizedBox(height: 12),
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
                        reasonLanding = reasonOnline = reasonOther = false;
                        reasonOtherCtrl.clear();
                      }
                    });
                  },
                  horizontal: true,
                ),
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
                        (v) => setState(() => reasonLanding = v ?? false),
                      ),
                      _checkItem(
                        '線上勤務',
                        reasonOnline,
                        (v) => setState(() => reasonOnline = v ?? false),
                      ),
                      _checkItem(
                        '其他',
                        reasonOther,
                        (v) => setState(() => reasonOther = v ?? false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (reasonLanding)
                    _timeRowDateTime('落地時間', landingTime, () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          landingTime ?? DateTime.now(),
                        ),
                      );
                      if (newTime != null) {
                        final now = DateTime.now();
                        setState(
                          () => landingTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            newTime.hour,
                            newTime.minute,
                          ),
                        );
                      }
                    }),
                  if (reasonOther)
                    _inputRowBold('其他原因', '請填寫其他原因', reasonOtherCtrl),
                ],
                const SizedBox(height: 12),
                _timeRowDateTime('檢查時間', checkTime, () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      checkTime ?? DateTime.now(),
                    ),
                  );
                  if (newTime != null) {
                    final now = DateTime.now();
                    setState(
                      () => checkTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        newTime.hour,
                        newTime.minute,
                      ),
                    );
                  }
                }),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('儲存並返回首頁'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83ACA9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    onPressed: _saveData, // ★ 改為呼叫儲存函式
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI 小積木 (保持不變) =================
  Widget _boldLabel(String s) => Text(
    s,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    ),
  );

  Widget _inputRowBold(String label, String hint, TextEditingController ctrl) {
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
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
          ),
        ],
      ),
    );
  }

  Widget _checkboxRowBold(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Checkbox(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // 修改 _timeRowDate：讓使用者可以挑選日期
  Widget _timeRowDate(String label, DateTime? value, VoidCallback onUpdate) {
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                value == null
                    ? '—'
                    : '${value.year}年${value.month}月${value.day}日',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(width: 10),
              // 原本的更新時間按鈕現在呼叫了 onUpdate，我們將在 build 裡實作挑選日期
              ElevatedButton(onPressed: onUpdate, child: const Text('更新日期')),
            ],
          ),
        ],
      ),
    );
  }

  // 修改 _timeRowDateTime：讓使用者可以挑選時間
  Widget _timeRowDateTime(
    String label,
    DateTime? value,
    VoidCallback onUpdate,
  ) {
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                value == null
                    ? '—'
                    : '${value.year}年${value.month}月${value.day}日 ${value.hour}時${value.minute}分${value.second}秒',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(width: 10),
              // 原本的更新時間按鈕現在呼叫了 onUpdate，我們將在 build 裡實作挑選時間
              ElevatedButton(onPressed: onUpdate, child: const Text('更新時間')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _radioGroup({
    required List<String> options,
    required int? groupIndex,
    required ValueChanged<int> onChanged,
    bool horizontal = false,
  }) {
    if (horizontal) {
      return Wrap(
        spacing: 14,
        runSpacing: 6,
        children: List.generate(options.length, (i) {
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
                Text(options[i], style: const TextStyle(fontSize: 15.5)),
              ],
            ),
          );
        }),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 8),
              Text(options[i], style: const TextStyle(fontSize: 15.5)),
            ],
          ),
        );
      }),
    );
  }

  Widget _checkItem(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: const TextStyle(fontSize: 15.5)),
      ],
    );
  }
}
