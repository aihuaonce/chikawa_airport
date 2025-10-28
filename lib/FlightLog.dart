import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/flightlog_data.dart';
import 'l10n/app_translations.dart';
import 'nav2.dart';

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
  static const double _cardMaxWidth = 1000;
  static const double _radius = 16;

  // 主題色
  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _border = Color(0xFFCBD5E1);

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
        data.airline = record.airline;
        data.flightNoCtrl.text = record.flightNo ?? '';
        data.travelStatus = record.travelStatus;
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
  }

  void _syncControllersToData() {
    final data = context.read<FlightLogData>();
    data.flightNo = data.flightNoCtrl.text.trim().isEmpty
        ? null
        : data.flightNoCtrl.text.trim();
  }

  Future<void> _saveData() async {
    final dao = context.read<FlightLogsDao>();
    final data = context.read<FlightLogData>();
    await data.saveToDatabase(widget.visitId, dao);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    // 定義航空公司選項（key 是資料庫值，value 是顯示文字）
    final mainAirlineOptions = {
      '長榮航空': t.evaAir,
      '中華航空': t.chinaAirlines,
      '國泰航空': t.cathayPacific,
      '聯合航空': t.unitedAirlines,
      '荷蘭皇家航空': t.klm,
      '中國南方航空': t.chinaSouthern,
      '台灣虎航': t.tigerairTaiwan,
      '阿聯酋航空': t.emirates,
      '中國國際航空': t.airChina,
    };

    // 其他航空公司（放在下拉選單中）
    final otherAirlineOptions = {
      '星宇航空': t.starlux,
      '華信航空': t.mandarinAirlines,
      '立榮航空': t.uniAir,
      '中國東方航空': t.chinaEastern,
      '廈門航空': t.xiamenAir,
      '樂桃航空': t.peachAviation,
      '大韓航空': t.koreanAir,
      '韓亞航空': t.asianaAirlines,
    };

    // 定義旅遊狀態選項
    final travelOptions = {
      '出境': t.departure,
      '入境': t.arrival,
      '過境': t.transit,
      '轉機': t.transfer,
      '緊急迫降': t.emergencyLanding,
      '備降': t.diversionLanding,
      '技術性降落': t.technicalLanding,
      '其他': t.other,
    };

    final airportOptions = [
      t.airportTPE,
      t.airportHKG,
      t.airportLAX,
      t.airportSHA,
      t.airportTYO,
      t.airportBKK,
      t.airportSFO,
      t.airportMNL,
    ];

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
                      _boldLabel(t.airline),
                      const SizedBox(height: 6),

                      // ===== 航空公司：主清單（單選）=====
                      _radioWrap(
                        options: mainAirlineOptions.values.toList(),
                        groupValue:
                            otherAirlineOptions.containsKey(data.airline)
                            ? null
                            : data.airline,
                        dbValues: mainAirlineOptions.keys.toList(),
                        onChanged: (v) {
                          data.airline = v;
                          data.update();
                        },
                      ),
                      const SizedBox(height: 8),

                      // ===== 其他航空公司（與上方單選左緣對齊、勾選色深綠）=====
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 微調 Checkbox 視覺左緣（-2px）
                            Transform.translate(
                              offset: const Offset(-2, 0),
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: otherAirlineOptions.containsKey(
                                    data.airline,
                                  ),
                                  onChanged: (v) {
                                    if (v == true) {
                                      // 選中時，設定為第一個其他航空公司
                                      data.airline =
                                          otherAirlineOptions.keys.first;
                                    } else {
                                      // 取消選中時，清空
                                      data.airline = null;
                                    }
                                    data.update();
                                  },
                                  activeColor: const Color(0xFF274C4A), // 深綠
                                  checkColor: Colors.white,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -2,
                                    vertical: -2,
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(t.otherAirline),
                            if (otherAirlineOptions.containsKey(
                              data.airline,
                            )) ...[
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: data.airline,
                                hint: Text(t.pleaseSelect),
                                items: otherAirlineOptions.entries
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.key,
                                        child: Text(e.value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  data.airline = v;
                                  data.update();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== 班機代碼（輸入框縮短、緊貼左側標籤）=====
                      _inputRowBold(
                        t.flightCode,
                        t.enterFlightNumberHint,
                        data.flightNoCtrl,
                      ),
                      const SizedBox(height: 16),

                      _boldLabel(t.travelStatus),
                      const SizedBox(height: 6),
                      _radioWrap(
                        options: travelOptions.values.toList(),
                        groupValue: data.travelStatus,
                        dbValues: travelOptions.keys.toList(),
                        onChanged: (v) {
                          data.travelStatus = v;
                          data.update();
                        },
                      ),
                      const SizedBox(height: 16),

                      _boldLabel(t.departurePlace),
                      _pickField(t.tapToSelectDeparture, data.departure, (v) {
                        data.departure = v;
                        data.update();
                      }, airportOptions),
                      const SizedBox(height: 16),

                      _boldLabel(t.viaPlace),
                      _pickField(t.tapToSelectVia, data.via, (v) {
                        data.via = v;
                        data.update();
                      }, airportOptions),
                      const SizedBox(height: 16),

                      _boldLabel(t.destinationPlace),
                      _pickField(t.tapToSelectDestination, data.destination, (
                        v,
                      ) {
                        data.destination = v;
                        data.update();
                      }, airportOptions),
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
            color: Color(0x1A000000), // 柔和陰影（~10% 黑）
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

  // ★ 輸入列：縮短輸入框 + 緊貼左側標籤
  Widget _inputRowBold(
    String label,
    String hint,
    TextEditingController ctrl, {
    VoidCallback? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(
            width: 168, // ★ 可依需要微調
            child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                hintText: '',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
              onChanged: (_) {
                if (onChanged != null) onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _radioWrap({
    required List<String> options,
    required String? groupValue,
    required List<String> dbValues,
    required ValueChanged<String> onChanged,
  }) {
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        final selected = groupValue == dbValues[i];
        return InkWell(
          onTap: () => onChanged(dbValues[i]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? _deepGreen : Colors.black45, // ★ 深綠色
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
    List<String> airportOptions,
  ) {
    final t = AppTranslations.of(context);
    return InkWell(
      onTap: () async {
        final picked = await showDialog<String>(
          context: context,
          builder: (ctx) {
            return SimpleDialog(
              title: Text(t.selectLocation),
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
