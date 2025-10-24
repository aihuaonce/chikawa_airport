import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/flightlog_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
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

  // ===== 外觀參數（只動樣式）=====
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1000; // ★ 白卡 maxWidth 規格：800
  static const double _radius = 16;

  // ★ 主題色（不動邏輯）
  static const Color _deepGreen = Color(0xFF274C4A); // 單/複選選中
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

    // ✅ 正確做法：呼叫您在 FlightLogData 中定義好的新方法
    await data.saveToDatabase(widget.visitId, dao);
  }

  // ================= build =================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context); // 【新增】

    // 【新增】動態建立翻譯後的選項列表
    final List<String> mainAirlines = [
      t.evaAir,
      t.chinaAirlines,
      t.cathayPacific,
      t.unitedAirlines,
      t.klm,
      t.chinaSouthern,
      t.tigerairTaiwan,
      t.emirates,
      t.airChina,
    ];
    final List<String> otherAirlines = [
      t.starlux,
      t.mandarinAirlines,
      t.uniAir,
      t.chinaEastern,
      t.xiamenAir,
      t.peachAviation,
      t.koreanAir,
      t.asianaAirlines,
    ];
    final List<String> travelOptions = [
      t.departure,
      t.arrival,
      t.transit,
      t.transfer,
      t.emergencyLanding,
      t.diversionLanding,
      t.technicalLanding,
      t.other,
    ];
    final List<String> airportOptions = [
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
                        options: mainAirlines,
                        groupIndex:
                            data.useOtherAirline ? null : data.airlineIndex,
                        onChanged: (i) {
                          data.useOtherAirline = false;
                          data.airlineIndex = i;
                          data.selectedOtherAirline = null;
                          data.update();
                        },
                      ),
                      const SizedBox(height: 8),

                      // ===== 其他航空公司（與上方單選左緣對齊、勾選色深綠）=====
                    Padding(
  // 保持與上方單選同一條左緣
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
            value: data.useOtherAirline,
            onChanged: (v) {
              data.useOtherAirline = v ?? false;
              data.update();
            },
            activeColor: const Color(0xFF274C4A), // 深綠
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(t.otherAirline),
      if (data.useOtherAirline) ...[
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: data.selectedOtherAirline,
          hint: Text(t.pleaseSelect),
          items: otherAirlines
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            data.selectedOtherAirline = v;
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
                          t.otherTravelStatus,
                          t.enterTravelStatusHint,
                          data.otherTravelCtrl,
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

  // ================= 小積木（只動樣式）=================
  
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
          // 原本是 Expanded，改為固定寬度讓輸入框縮短並與左側標籤齊頭
          SizedBox(
            width: 168, // ★ 可依需要微調
            child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                hintText: '',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              onChanged: (_) {
                if (onChanged != null) onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          // 如果要顯示 hint（但不佔 TextField 寬度），可加上這行：
          // Expanded(child: Text(hint, style: TextStyle(color: Colors.black54, fontSize: 13))),
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
      runSpacing: 10,
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
