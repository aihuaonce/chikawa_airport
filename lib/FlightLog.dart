import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/flightlog_data.dart';
import 'nav2.dart'; // SavablePage 介面

class FlightLogPage extends StatefulWidget {
  final int visitId;

  const FlightLogPage({super.key, required this.visitId});

  @override
  State<FlightLogPage> createState() => _FlightLogPageState();
}

class _FlightLogPageState extends State<FlightLogPage>
    with
        AutomaticKeepAliveClientMixin<FlightLogPage>,
        SavableStateMixin<FlightLogPage> {
  bool _isLoading = true;

  // 外觀參數
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1100;
  static const double _radius = 16;

  // 選項列表
  final List<String> mainAirlines = const [
    'BR長榮航空',
    'CI中華航空',
    'CX國泰航空',
    'UA聯合航空',
    'KL荷蘭航空',
    'CZ中國南方航空',
    'IT台灣虎航',
    'EK阿聯酋航空',
    'CA中國國際航空',
  ];

  final List<String> otherAirlines = const [
    'JX星宇航空',
    'AE華信航空',
    'B7立榮航空',
    'MU中國東方航空',
    'MF廈門航空',
    'MM樂桃航空',
    'KE大韓航空',
    'OZ韓亞航空',
  ];

  final List<String> travelOptions = const [
    '出境',
    '入境',
    '過境',
    '轉機',
    '迫降',
    '轉降',
    '備降',
    '其他',
  ];

  final List<String> airportOptions = const [
    'TPE台北 / 台灣',
    'HKG香港 / 香港',
    'LAX洛杉磯 / 美國',
    'SHA上海 / 中國',
    'TYO東京 / 日本',
    'BKK曼谷 / 泰國',
    'SFO舊金山 / 美國',
    'MNL馬尼拉 / 菲律賓',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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

  Future<void> _loadData() async {
    try {
      final dao = context.read<FlightLogsDao>();
      final data = context.read<FlightLogData>();
      final record = await dao.getByVisitId(widget.visitId);

      if (!mounted) return;

      if (record != null) {
        // 從資料庫載入到 model
        data.airlineIndex = record.airlineIndex;
        data.useOtherAirline = record.useOtherAirline;
        data.selectedOtherAirline = record.otherAirline;
        data.flightNoCtrl.text = record.flightNo ?? '';
        data.travelStatusIndex = record.travelStatusIndex;
        data.otherTravelCtrl.text = record.otherTravelStatus ?? '';
        data.departure = record.departure;
        data.via = record.via;
        data.destination = record.destination;
        data.update();
      }
      _syncControllersFromData(data);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _syncControllersFromData(FlightLogData data) {
    if (data.flightNo != null) data.flightNoCtrl.text = data.flightNo!;
    if (data.otherTravelStatus != null) {
      data.otherTravelCtrl.text = data.otherTravelStatus!;
    }
  }

  void _syncControllersToData() {
    final data = context.read<FlightLogData>();
    data.flightNo = data.flightNoCtrl.text.trim().isEmpty
        ? null
        : data.flightNoCtrl.text.trim();
    data.otherTravelStatus = data.otherTravelCtrl.text.trim().isEmpty
        ? null
        : data.otherTravelCtrl.text.trim();
  }

  Future<void> _saveData() async {
    final dao = context.read<FlightLogsDao>();
    final data = context.read<FlightLogData>();

    await dao.upsertByVisitId(
      visitId: widget.visitId,
      airlineIndex: data.airlineIndex,
      useOtherAirline: data.useOtherAirline,
      otherAirline: data.selectedOtherAirline,
      flightNo: data.flightNo,
      travelStatusIndex: data.travelStatusIndex,
      otherTravelStatus: data.otherTravelStatus,
      departure: data.departure,
      via: data.via,
      destination: data.destination,
    );
  }

  // ================= build =================
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Consumer<FlightLogData>(
      builder: (context, data, _) {
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
                      _boldLabel('航空公司'),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: mainAirlines,
                        groupIndex: data.useOtherAirline
                            ? null
                            : data.airlineIndex,
                        onChanged: (i) {
                          data.useOtherAirline = false;
                          data.airlineIndex = i;
                          data.selectedOtherAirline = null;
                          data.update();
                        },
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Checkbox(
                            value: data.useOtherAirline,
                            onChanged: (v) {
                              data.useOtherAirline = v ?? false;
                              data.update();
                            },
                          ),
                          const Text('其他航空公司'),
                          if (data.useOtherAirline)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: DropdownButton<String>(
                                value: data.selectedOtherAirline,
                                hint: const Text('請選擇'),
                                items: otherAirlines
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  data.selectedOtherAirline = v;
                                  data.update();
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _inputRowBold('班機代碼', '請輸入班機號碼', data.flightNoCtrl),
                      const SizedBox(height: 16),

                      _boldLabel('旅行狀態'),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: travelOptions,
                        groupIndex: data.travelStatusIndex,
                        onChanged: (i) {
                          data.travelStatusIndex = i;
                          if (i != travelOptions.length - 1) {
                            data.otherTravelCtrl.clear();
                          }
                          data.update();
                        },
                      ),
                      if (data.travelStatusIndex == travelOptions.length - 1)
                        _inputRowBold(
                          '其他旅行狀態',
                          '請輸入旅行狀態',
                          data.otherTravelCtrl,
                        ),
                      const SizedBox(height: 16),

                      _boldLabel('啟程地'),
                      _pickField('點擊選擇啟程地', data.departure, (v) {
                        data.departure = v;
                        data.update();
                      }),
                      const SizedBox(height: 16),

                      _boldLabel('經過地'),
                      _pickField('點擊選擇經過地', data.via, (v) {
                        data.via = v;
                        data.update();
                      }),
                      const SizedBox(height: 16),

                      _boldLabel('目的地'),
                      _pickField('點擊選擇目的地', data.destination, (v) {
                        data.destination = v;
                        data.update();
                      }),
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

  // ================= 小積木 =================
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

  Widget _inputRowBold(
    String label,
    String hint,
    TextEditingController ctrl, {
    VoidCallback? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
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
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) {
                if (onChanged != null) onChanged();
              },
            ),
          ),
        ],
      ),
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
              Text(options[i]),
            ],
          ),
        );
      }),
    );
  }

  Widget _pickField(
    String placeholder,
    String? value,
    ValueChanged<String?> onPick,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDialog<String>(
          context: context,
          builder: (ctx) {
            return SimpleDialog(
              title: const Text('選擇地點'),
              children: airportOptions
                  .map(
                    (e) => SimpleDialogOption(
                      child: Text(e),
                      onPressed: () => Navigator.of(ctx).pop(e),
                    ),
                  )
                  .toList(),
            );
          },
        );
        if (picked != null) onPick(picked);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          value ?? placeholder,
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: value == null ? FontWeight.w500 : FontWeight.w700,
            color: value == null ? Colors.black54 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
