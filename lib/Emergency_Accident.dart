import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class EmergencyAccidentPage extends StatefulWidget {
  final int visitId;
  const EmergencyAccidentPage({super.key, required this.visitId});

  @override
  State<EmergencyAccidentPage> createState() => _EmergencyAccidentPageState();
}

class _EmergencyAccidentPageState extends State<EmergencyAccidentPage> {
  // 統一外觀
  static const double _cardMaxWidth = 1000; // ★ 固定 1000
  static const double _radius = 16;
  static const Color _deepGreen = Color(0xFF274C4A); // 單/複選選中顏色
  static const Color _lightGreen = Color(0xFF83ACA9); // 更新時間按鈕
  static const Color _bg = Color(0xFFE6F6FB);

  // 只保留不需翻譯的列表
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

  final TextEditingController placeNoteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<EmergencyData>();
    placeNoteCtrl.text = data.placeNote ?? '';
  }

  @override
  void dispose() {
    placeNoteCtrl.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<EmergencyData>();
    data.updateAccident(placeNote: placeNoteCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    // 動態建立翻譯後的選項列表
    final List<String> placeGroups = [
      t.terminal1,
      t.terminal2,
      t.remoteApron,
      t.cargoOther,
      t.novotelHotel,
      t.insideAircraft,
    ];

    final List<String> t1Places = [
      t.departureCounter,
      t.arrivalCounter,
      t.vipLounge,
      t.departureHallPublic,
      t.departureLevelRestricted,
      t.arrivalHallPublic,
      t.arrivalLevelRestricted,
      t.foodCourt,
      t.aviationPolice,
      t.airportMRT,
      t.carPark1,
      t.carPark2,
      t.departureBusDropOff,
      t.arrivalBusPickUp,
      t.departureSecurityCheck,
      t.baggageClaim,
      t.customs,
      t.gateLabel('A1'),
      t.gateLabel('A2'),
      t.gateLabel('A3'),
      t.gateLabel('A4'),
      t.gateLabel('A5'),
      t.gateLabel('A6'),
      t.gateLabel('A7'),
      t.gateLabel('A8'),
      t.gateLabel('A9'),
      t.transferCounterA,
      t.transferCounterB,
      t.transferSecurityA,
      t.transferSecurityB,
      t.skytrainAirside,
      t.skytrainLandside,
      t.otherLocation,
      t.gateLabel('B1'),
      t.gateLabel('B2'),
      t.gateLabel('B3'),
      t.gateLabel('B4'),
      t.gateLabel('B5'),
      t.gateLabel('B6'),
      t.gateLabel('B7'),
      t.gateLabel('B8'),
      t.gateLabel('B9'),
      t.gateLabel('B1R'),
    ];

    final List<String> t2Places = [
      t.departureCounter,
      t.arrivalCounter,
      t.vipLounge,
      t.departureHallPublic,
      t.departureLevelRestricted,
      t.arrivalHallPublic,
      t.arrivalLevelRestricted,
      t.foodCourt,
      t.aviationPolice,
      t.airportMRT,
      t.carPark3,
      t.carPark4,
      t.northObservationDeck,
      t.southObservationDeck,
      t.northWing5F,
      t.southWing5F,
      t.gateLabel('D1'),
      t.gateLabel('D2'),
      t.gateLabel('D3'),
      t.gateLabel('D4'),
      t.gateLabel('D5'),
      t.gateLabel('D6'),
      t.gateLabel('D7'),
      t.gateLabel('D8'),
      t.gateLabel('D9'),
      t.gateLabel('D10'),
      t.gateLabel('C1'),
      t.gateLabel('C2'),
      t.gateLabel('C3'),
      t.gateLabel('C4'),
      t.gateLabel('C5'),
      t.gateLabel('C6'),
      t.gateLabel('C7'),
      t.gateLabel('C8'),
      t.gateLabel('C9'),
      t.transferCounterC,
      t.transferSecurityC,
      t.skytrainAirside,
      t.skytrainLandside,
      t.otherLocation,
      t.gateLabel('C5R'),
    ];

    final List<String> cargoPlaces = [
      t.taxiway,
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
      t.tacHangar,
      t.maintenanceApron,
      t.evergreenAerospace,
      t.otherApronLocation,
    ];

    final List<String> novotelPlaces = [t.novotelHotel];
    final List<String> cabinPlaces = [t.insideAircraft];

    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Container(
          color: _bg,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
                child: _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dateTimeRow(
                        label: t.incidentDateTime, // 【修改】
                        value: data.incidentDateTime,
                        onPick: (dt) =>
                            data.updateAccident(incidentDateTime: dt),
                        onNow: () => data.updateAccident(
                          incidentDateTime: DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _bold(t.incidentLocation),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 8, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _radioWrap(
                              options: placeGroups,
                              groupIndex: data.placeGroupIdx,
                              onChanged: (i) {
                                data.updateAccident(
                                  placeGroupIdx: i,
                                  t1Selected: null,
                                  t2Selected: null,
                                  remoteSelected: null,
                                  cargoSelected: null,
                                  novotelSelected: null,
                                  cabinSelected: null,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _placeSubOptions(
                              data,
                              t1Places,
                              t2Places,
                              cargoPlaces,
                              novotelPlaces,
                              cabinPlaces,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      _inputRowTight(
                        label: t.locationNotes,
                        hint: t.enterLocationNotes,
                        ctrl: placeNoteCtrl,
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

  // ====== 視覺小積木 ======

  Widget _bigCard({required Widget child}) => Container(
    margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000), // 柔和陰影
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );

  Widget _bold(String s) => Text(
    s,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
      height: 1.25,
    ),
  );

  // 標題縮短 + 按鈕換淺綠
  Widget _dateTimeRow({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onPick,
    required VoidCallback onNow,
  }) {
    final t = AppTranslations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120, // ★ 原 160 -> 120，減少標題後空白
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15.5,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final newDate = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (newDate != null && mounted) {
              final newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
              );
              if (newTime != null) {
                onPick(
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
            value == null
                ? t.pleaseSelectTime
                : t.formatFullDateTime(value), // 【修改】
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: onNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: _lightGreen, // ★ 淺綠
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              t.updateTime,
              style: const TextStyle(fontSize: 12.5),
            ), // 【修改】
          ),
        ),
      ],
    );
  }

  // 輸入框縮短（保留 hint 與內容）
  Widget _inputRowTight({
    required String label,
    required String hint,
    required TextEditingController ctrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 84, // ★ 標題縮短
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 200, // ★ 固定輸入框寬度 300
            child: TextField(
              controller: ctrl,
              onChanged: (_) => _saveToProvider(),
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
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
      alignment: WrapAlignment.start,
      spacing: 18,
      runSpacing: 6,
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

  // 【修改】更新方法簽名以接收動態列表
  Widget _placeSubOptions(
    EmergencyData data,
    List<String> t1Places,
    List<String> t2Places,
    List<String> cargoPlaces,
    List<String> novotelPlaces,
    List<String> cabinPlaces,
  ) {
    if (data.placeGroupIdx == null) return const SizedBox.shrink();

    List<String> opts;
    int? groupIndex;
    ValueChanged<int> onChanged;

    switch (data.placeGroupIdx!) {
      case 0:
        opts = t1Places;
        groupIndex = data.t1Selected;
        onChanged = (i) => data.updateAccident(t1Selected: i);
        break;
      case 1:
        opts = t2Places;
        groupIndex = data.t2Selected;
        onChanged = (i) => data.updateAccident(t2Selected: i);
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = data.remoteSelected;
        onChanged = (i) => data.updateAccident(remoteSelected: i);
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = data.cargoSelected;
        onChanged = (i) => data.updateAccident(cargoSelected: i);
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = data.novotelSelected;
        onChanged = (i) => data.updateAccident(novotelSelected: i);
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = data.cabinSelected;
        onChanged = (i) => data.updateAccident(cabinSelected: i);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
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
                  color: selected ? _deepGreen : Colors.black45,
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
