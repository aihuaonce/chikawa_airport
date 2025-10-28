// lib/pages/AccidentRecord.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/accident_data.dart';
import 'nav2.dart'; // SavablePage 介面
import '../l10n/app_translations.dart'; // 多語支援

class AccidentRecordPage extends StatefulWidget {
  final int visitId;

  const AccidentRecordPage({super.key, required this.visitId});

  @override
  State<AccidentRecordPage> createState() => _AccidentRecordPageState();
}

class _AccidentRecordPageState extends State<AccidentRecordPage>
    with
        AutomaticKeepAliveClientMixin<AccidentRecordPage>,
        SavableStateMixin<AccidentRecordPage> {
  // ===============================================
  // 狀態與控制器
  // ===============================================
  bool _isLoading = true;

  // ===== 外觀參數（只動樣式）=====
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1000; // ★ 白卡 maxWidth 規格：800
  static const double _radius = 16;

  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _lightGreen = Color(0xFF83ACA9);
  static const Color _border = Color(0xFFCBD5E1);

  // ✅ 修改:地點選項改為 Map,key 是儲存到 DB 的值
  final Map<String, String> placeGroupOptions = const {
    '第一航廈': '第一航廈',
    '第二航廈': '第二航廈',
    '遠端機坪': '遠端機坪',
    '貨運站/機坪其他': '貨運站/機坪其他',
    '諾富特飯店': '諾富特飯店',
    '飛機機艙內': '飛機機艙內',
  };

  final Map<String, List<String>> placeDetailOptions = const {
    '第一航廈': [
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
    ],
    '第二航廈': [
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
      '北暑5樓',
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
    ],
    '遠端機坪': [
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
    ],
    '貨運站/機坪其他': [
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
      '小飛棚廠',
      '維修停機坪',
      '長榮航太',
      '機坪其他位置',
    ],
    '諾富特飯店': ['諾富特飯店'],
    '飛機機艙內': ['飛機機艙內'],
  };

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

  // ===============================================
  // SavableStateMixin 實作
  // ===============================================
  @override
  Future<void> saveData() async {
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool get wantKeepAlive => true;

  // ===============================================
  // 資料載入 / 儲存
  // ===============================================
  Future<void> _loadData() async {
    try {
      final dao = context.read<AccidentRecordsDao>();
      final accidentData = context.read<AccidentData>();
      final record = await dao.getByVisitId(widget.visitId);

      if (!mounted) return;

      if (record != null) {
        // 從資料庫載入到 AccidentData
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
        accidentData.placeGroup = record.placeGroup; // 文字
        accidentData.placeDetail = record.placeDetail; // 文字
        accidentData.placeNote = record.placeNote;
        accidentData.occArrived = record.occArrived;
        accidentData.cost = record.cost;
        accidentData.within10min = record.within10min;
        accidentData.reasonPreLanding = record.reasonLanding;
        accidentData.reasonOnDuty = record.reasonOnline;
        accidentData.reasonOther = record.reasonOther;
        accidentData.otherReasonText = record.reasonOtherText;
        accidentData.otherReportUnit = record.otherReportUnit;
        accidentData.update();
      } else {
        // 新記錄的預設值
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
    } catch (e) {
      // 錯誤處理
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _syncControllersFromData(AccidentData accidentData) {
    notifierCtrl.text = accidentData.notifier ?? '';
    phoneCtrl.text = accidentData.phone ?? '';
    placeNoteCtrl.text = accidentData.placeNote ?? '';
    costCtrl.text = accidentData.cost ?? '';
    otherReasonCtrl.text = accidentData.otherReasonText ?? '';
    otherReportUnitCtrl.text = accidentData.otherReportUnit ?? '';
  }

  void _syncControllersToData() {
    final accidentData = context.read<AccidentData>();
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
  }

  Future<void> _saveData() async {
    try {
      final dao = context.read<AccidentRecordsDao>();
      final accidentData = context.read<AccidentData>();
      await accidentData.saveToDatabase(widget.visitId, dao);
    } catch (e) {
      print('❌ 在 AccidentRecordPage 儲存失敗: $e');
      rethrow;
    }
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

  void _onTextFieldChanged() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _syncControllersToData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Consumer<AccidentData>(
      builder: (context, accidentData, _) {
        // 同步 AccidentData 回控制器，避免循環更新
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            if (notifierCtrl.text != (accidentData.notifier ?? '')) {
              notifierCtrl.text = accidentData.notifier ?? '';
            }
            if (phoneCtrl.text != (accidentData.phone ?? '')) {
              phoneCtrl.text = accidentData.phone ?? '';
            }
            if (placeNoteCtrl.text != (accidentData.placeNote ?? '')) {
              placeNoteCtrl.text = accidentData.placeNote ?? '';
            }
            if (costCtrl.text != (accidentData.cost ?? '')) {
              costCtrl.text = accidentData.cost ?? '';
            }
            if (otherReasonCtrl.text != (accidentData.otherReasonText ?? '')) {
              otherReasonCtrl.text = accidentData.otherReasonText ?? '';
            }
            if (otherReportUnitCtrl.text !=
                (accidentData.otherReportUnit ?? '')) {
              otherReportUnitCtrl.text = accidentData.otherReportUnit ?? '';
            }
          }
        });

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
                        label: t.incidentDate,
                        value: accidentData.incidentDate,
                        onChanged: (dt) {
                          accidentData.incidentDate = dt;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 8),
                      _dateTimePicker(
                        label: t.notifyTime,
                        value: accidentData.notifyTime,
                        onChanged: (dt) {
                          accidentData.notifyTime = dt;
                          accidentData.update();
                          _calculateTimeDifference(accidentData);
                        },
                      ),
                      const SizedBox(height: 16),

                      _boldLabel(t.reportUnit),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: reportUnits,
                        selectedValue: accidentData.reportUnitIdx != null
                            ? reportUnits[accidentData.reportUnitIdx!]
                            : null,
                        onChanged: (value) {
                          accidentData.reportUnitIdx = reportUnits.indexOf(
                            value,
                          );
                          accidentData.update();
                        },
                      ),
                      if (accidentData.reportUnitIdx ==
                          reportUnits.indexOf('其他')) ...[
                        const SizedBox(height: 8),
                        _inputRowBold(
                          t.otherReportUnit,
                          t.enterOtherReportUnit,
                          otherReportUnitCtrl,
                          onChanged: _onTextFieldChanged,
                        ),
                      ],
                      const SizedBox(height: 16),

                      _inputRowBold(
                        t.reporterName,
                        t.enterReporterName,
                        notifierCtrl,
                        onChanged: _onTextFieldChanged,
                      ),
                      const SizedBox(height: 8),
                      _inputRowBold(
                        t.phone,
                        t.enterContactNumber,
                        phoneCtrl,
                        onChanged: _onTextFieldChanged,
                      ),
                      const SizedBox(height: 12),

                      _dateTimePicker(
                        label: t.oocPickUpTime,
                        value: accidentData.pickUpTime,
                        onChanged: (dt) {
                          accidentData.pickUpTime = dt;
                          accidentData.update();
                        },
                        labelWidth: 160,
                      ),
                      const SizedBox(height: 8),
                      _dateTimePicker(
                        label: t.medicDepartTime,
                        value: accidentData.medicDepartTime,
                        onChanged: (dt) {
                          accidentData.medicDepartTime = dt;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 16),

                      // ✅ 修改:地點群組選擇
                      _boldLabel(t.accidentLocation),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: placeGroupOptions.values.toList(),
                        selectedValue: accidentData.placeGroup,
                        onChanged: (value) {
                          accidentData.placeGroup = value;
                          accidentData.placeDetail = null; // 清除詳細地點
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 8),

                      // ✅ 修改:詳細地點選擇
                      if (accidentData.placeGroup != null) ...[
                        _boldLabel('詳細地點'),
                        const SizedBox(height: 6),
                        _radioWrap(
                          options:
                              placeDetailOptions[accidentData.placeGroup] ?? [],
                          selectedValue: accidentData.placeDetail,
                          onChanged: (value) {
                            accidentData.placeDetail = value;
                            accidentData.update();
                          },
                        ),
                        const SizedBox(height: 8),
                      ],

                      _inputRowBold(
                        t.locationNotes,
                        t.enterLocationNotes,
                        placeNoteCtrl,
                        onChanged: _onTextFieldChanged,
                      ),
                      const SizedBox(height: 16),

                      _checkboxRowBold(t.occArrived, accidentData.occArrived, (
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
                        label: t.medicArriveTime,
                        value: accidentData.medicArriveTime,
                        onChanged: (dt) {
                          accidentData.medicArriveTime = dt;
                          accidentData.update();
                          _calculateTimeDifference(accidentData);
                        },
                      ),
                      const SizedBox(height: 12),

                      _inputRowBold(
                        t.elapsedTime,
                        t.exampleElapsedTimeHint,
                        costCtrl,
                        onChanged: _onTextFieldChanged,
                      ),
                      const SizedBox(height: 8),
                      _boldLabel(t.arrivalWithin10min),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: [t.yes, t.no],
                        selectedValue: accidentData.within10min == 0
                            ? t.yes
                            : (accidentData.within10min == 1 ? t.no : null),
                        onChanged: (value) {
                          accidentData.within10min = value == t.yes ? 0 : 1;
                          if (accidentData.within10min == 0) {
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
                        _boldLabel(t.reasonLateTitle),
                        const SizedBox(height: 6),
                        _reasonCheckboxRow(
                          label: t.reasonPreLanding,
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
                          label: t.reasonOnDuty,
                          value: accidentData.reasonOnDuty,
                          onChanged: (v) {
                            accidentData.reasonOnDuty = v ?? false;
                            accidentData.update();
                          },
                        ),
                        _reasonCheckboxRow(
                          label: t.reasonOther,
                          value: accidentData.reasonOther,
                          onChanged: (v) {
                            accidentData.reasonOther = v ?? false;
                            accidentData.update();
                          },
                        ),
                        if (accidentData.reasonOther) ...[
                          const SizedBox(height: 6),
                          _inputRowBold(
                            t.otherReason,
                            t.enterOtherReason,
                            otherReasonCtrl,
                            onChanged: _onTextFieldChanged,
                          ),
                        ],
                        if (accidentData.reasonPreLanding) ...[
                          const SizedBox(height: 6),
                          _dateTimePicker(
                            label: t.landingTime,
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
                        label: t.checkTime,
                        value: accidentData.checkTime,
                        onChanged: (dt) {
                          accidentData.checkTime = dt;
                          accidentData.update();
                        },
                      ),
                      const SizedBox(height: 8),
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

  // ================= UI 小積木 =================
  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
        border: const Border(
          top: BorderSide(color: _border),
          right: BorderSide(color: _border),
          bottom: BorderSide(color: _border),
          left: BorderSide(color: _border),
        ),
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
      height: 1.25,
    ),
  );

  Widget _labeledRowBold({
    required String label,
    required Widget child,
    double labelWidth = 108,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: labelWidth,
              maxWidth: labelWidth,
            ),
            child: Text(
              label,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 6),
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
    double labelWidth = 95,
  }) {
    final t = AppTranslations.of(context);
    return _labeledRowBold(
      label: label,
      labelWidth: labelWidth,
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
              value == null ? t.selectTime : _fmtDateTime(value),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          _smallButton(t.updateTime, () => onChanged(DateTime.now())),
        ],
      ),
    );
  }

  Widget _datePicker({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
    double labelWidth = 95,
  }) {
    final t = AppTranslations.of(context);
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
              value == null ? t.selectDate : _fmtDate(value),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          _smallButton(t.updateTime, () => onChanged(DateTime.now())),
        ],
      ),
    );
  }

  Widget _inputRowBold(
    String label,
    String hint,
    TextEditingController ctrl, {
    VoidCallback? onChanged,
  }) {
    return _labeledRowBold(
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
          onChanged: (value) {
            if (onChanged != null) onChanged();
          },
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
      labelWidth: 160,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: _deepGreen,
        checkColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
        side: const BorderSide(color: _border, width: 1.2),
      ),
    );
  }

  Widget _radioWrap({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        final selected = selectedValue == options[i];
        return InkWell(
          onTap: () => onChanged(options[i]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? _deepGreen : Colors.black45,
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
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: _deepGreen,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
          side: const BorderSide(color: _border, width: 1.2),
        ),
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
          backgroundColor: _lightGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDate(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 ${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';
}
