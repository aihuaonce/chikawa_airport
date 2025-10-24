import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/ambulance_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class AmbulanceInformationPage extends StatefulWidget {
  final int visitId;
  const AmbulanceInformationPage({super.key, required this.visitId});

  @override
  State<AmbulanceInformationPage> createState() =>
      _AmbulanceInformationPageState();
}

class _AmbulanceInformationPageState extends State<AmbulanceInformationPage> {
  // ===== 版面外觀 (只動樣式) =====
  static const double _cardRadius = 16;
  static const double _labelWidth = 120; // ★ 縮短標題欄寬，減少標題與輸入框的空隙
  static const double _cardMaxWidth = 1000; // ★ 卡片最大寬度統一為1000

  // ===== 文字輸入控制器 =====
  final _plateCtrl = TextEditingController();
  final _placeNoteCtrl = TextEditingController();
  final _otherDestCtrl = TextEditingController();

  // ===== 選項列表 (靜態常量，無需翻譯) =====
  static const List<String> remotePlaces = [
    '601','602','603','604','605','606','607','608','609','610','611','612','613','614','615',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadInitialData();
    });
  }

  void _loadInitialData() {
    final data = context.read<AmbulanceData>();
    _plateCtrl.text = data.plateNumber ?? '';
    _placeNoteCtrl.text = data.placeNote ?? '';
    _otherDestCtrl.text = data.otherDestinationHospital ?? '';
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    _placeNoteCtrl.dispose();
    _otherDestCtrl.dispose();
    super.dispose();
  }

  void _saveToProvider(List<String> hospitals) {
    final data = context.read<AmbulanceData>();

    String? destinationHospitalName;
    if (data.destinationHospitalIdx != null) {
      if (data.destinationHospitalIdx == hospitals.length - 1) {
        destinationHospitalName = _otherDestCtrl.text;
      } else {
        destinationHospitalName = hospitals[data.destinationHospitalIdx!];
      }
    }

    data.updateInformation(
      plateNumber: _plateCtrl.text,
      placeNote: _placeNoteCtrl.text,
      otherDestinationHospital: _otherDestCtrl.text,
      destinationHospital: destinationHospitalName,
    );
  }

  // ===== 工具函式 =====
  Future<void> _pickDateTime({
    required DateTime? current,
    required ValueChanged<DateTime?> onChanged,
  }) async {
    final base = current ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (time == null) return;
    onChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    // 動態翻譯列表（不動邏輯/選項，只是用現有 t.*）
    final List<String> placeGroups = [
      t.terminal1, t.terminal2, t.remoteApron, t.cargoOther, t.novotelHotel, t.insideAircraft,
    ];
    final List<String> t1Places = [
      t.departureCounter, t.arrivalCounter, t.vipLounge, t.departureHallPublic,
      t.departureLevelRestricted, t.arrivalHallPublic, t.arrivalLevelRestricted,
      t.foodCourt, t.aviationPolice, t.airportMRT, t.carPark1, t.carPark2,
      t.departureBusDropOff, t.arrivalBusPickUp, t.departureSecurityCheck,
      t.baggageClaim, t.customs,
      t.gateLabel('A1'), t.gateLabel('A2'), t.gateLabel('A3'), t.gateLabel('A4'), t.gateLabel('A5'),
      t.gateLabel('A6'), t.gateLabel('A7'), t.gateLabel('A8'), t.gateLabel('A9'),
      t.transferCounterA, t.transferCounterB, t.transferSecurityA, t.transferSecurityB,
      t.skytrainAirside, t.skytrainLandside, t.otherLocation,
      t.gateLabel('B1'), t.gateLabel('B2'), t.gateLabel('B3'), t.gateLabel('B4'), t.gateLabel('B5'),
      t.gateLabel('B6'), t.gateLabel('B7'), t.gateLabel('B8'), t.gateLabel('B9'), t.gateLabel('B1R'),
    ];
    final List<String> t2Places = [
      t.departureCounter, t.arrivalCounter, t.vipLounge, t.departureHallPublic,
      t.departureLevelRestricted, t.arrivalHallPublic, t.arrivalLevelRestricted,
      t.foodCourt, t.aviationPolice, t.airportMRT, t.carPark3, t.carPark4,
      t.northObservationDeck, t.southObservationDeck, t.northWing5F, t.southWing5F,
      t.gateLabel('D1'), t.gateLabel('D2'), t.gateLabel('D3'), t.gateLabel('D4'), t.gateLabel('D5'),
      t.gateLabel('D6'), t.gateLabel('D7'), t.gateLabel('D8'), t.gateLabel('D9'), t.gateLabel('D10'),
      t.gateLabel('C1'), t.gateLabel('C2'), t.gateLabel('C3'), t.gateLabel('C4'), t.gateLabel('C5'),
      t.gateLabel('C6'), t.gateLabel('C7'), t.gateLabel('C8'), t.gateLabel('C9'),
      t.transferCounterC, t.transferSecurityC, t.skytrainAirside, t.skytrainLandside,
      t.otherLocation, t.gateLabel('C5R'),
    ];
    final List<String> cargoPlaces = [
      t.taxiway, '506','507','508','509','510','511','512','513','514','515',
      t.tacHangar, t.maintenanceApron, t.evergreenAerospace, t.otherApronLocation,
    ];
    final List<String> novotelPlaces = [t.novotelHotel];
    final List<String> cabinPlaces = [t.insideAircraft];

    final List<String> hospitals = [
      t.landseedHospital, t.linkouChangGung, t.taoyuanHospital, t.taoyuanPsychiatricCenter,
      t.taoyuanMinSheng, t.stPaulsHospital, t.tienShengHospital,
      t.taoyuanVeteransHospital, t.enChuKungHospital, t.other,
    ];

    // 運送原因（保留你原本的新增欄位，文字用既有 t.*）
    final List<String> transportReasons = [
      t.patientConditionRequired, t.patientOrFamilyRequest,
    ];
    int? transportReasonIdx;

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardMaxWidth), // ★ 800
              child: _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rowTop(
                      label: t.plateNumber,
                      labelWidth: 84,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 250), // ★ 輸入框略短
                        child: TextField(
                          controller: _plateCtrl,
                          onChanged: (_) => _saveToProvider(hospitals),
                          decoration: InputDecoration(
                            hintText: t.enterPlateNumberHint,
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _bold(t.incidentLocation),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _radioWrap(
                            options: placeGroups,
                            groupIndex: data.placeGroupIdx,
                            onChanged: (i) {
                              data.updateInformation(
                                placeGroupIdx: i,
                                t1PlaceIdx: null,
                                t2PlaceIdx: null,
                                remotePlaceIdx: null,
                                cargoPlaceIdx: null,
                                novotelPlaceIdx: null,
                                cabinPlaceIdx: null,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _placeSubOptions(
                            data, t1Places, t2Places, cargoPlaces, novotelPlaces, cabinPlaces,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _rowTop(
                      label: t.locationNotes,
                      labelWidth: 84,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300), // ★ 略縮短
                        child: TextField(
                          controller: _placeNoteCtrl,
                          onChanged: (_) => _saveToProvider(hospitals),
                          decoration: InputDecoration(
                            hintText: t.enterLocationNotes, // 若沒有此 key 也不會影響既有內容
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _dateTimeRow(
                      label: t.dutyDateTime,
                      value: data.dutyTime,
                      onChanged: (dt) => data.updateInformation(dutyTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.arriveSceneTime,
                      value: data.arriveSceneTime,
                      onChanged: (dt) => data.updateInformation(arriveSceneTime: dt),
                    ),
                    const SizedBox(height: 16),

                    _rowTop(
                      label: t.destinationHospitalOrPlace,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(hospitals.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: _radioOption(
                              label: hospitals[i],
                              isSelected: data.destinationHospitalIdx == i,
                              onTap: () {
                                data.updateInformation(destinationHospitalIdx: i);
                                _saveToProvider(hospitals);
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                    if (data.destinationHospitalIdx == hospitals.length - 1) ...[
                      const SizedBox(height: 10),
                      _rowTop(
                        label: t.otherHospitalName,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: TextField(
                            controller: _otherDestCtrl,
                            onChanged: (_) => _saveToProvider(hospitals),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    _rowTop(
                      label: '運送原因', 
                      labelWidth: 84,
                      child: _radioWrap(
                        options: transportReasons,
                        groupIndex: transportReasonIdx,
                        onChanged: (i) => setState(() => transportReasonIdx = i),
                      ),
                    ),

                    const SizedBox(height: 16),
                    _dateTimeRow(
                      label: t.leaveSceneTime,
                      value: data.leaveSceneTime,
                      onChanged: (dt) => data.updateInformation(leaveSceneTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.arriveHospitalTime,
                      value: data.arriveHospitalTime,
                      onChanged: (dt) => data.updateInformation(arriveHospitalTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.leaveHospitalTime,
                      value: data.leaveHospitalTime,
                      onChanged: (dt) => data.updateInformation(leaveHospitalTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.backToStandbyTime,
                      value: data.backStandbyTime,
                      onChanged: (dt) => data.updateInformation(backStandbyTime: dt),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ====== 小積木 (樣式微調版) ======
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius), // 圓角 16
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // 柔和陰影
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _bold(String s) => Text(
        s,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          height: 1.25,
        ),
      );

  Widget _rowTop({required String label, required Widget child,double? labelWidth,}) {
    final Widget effectiveChild = child is TextField
        ? Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isDense: true,
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            child: child,
          )
        : child;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth ?? _labelWidth, // ★ 縮短後，右側空白變小
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
        ),
        Expanded(child: Align(alignment: Alignment.topLeft, child: effectiveChild)),
      ],
    );
  }

  Widget _dateTimeRow({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    final t = AppTranslations.of(context);
    return _rowTop(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _pickDateTime(current: value, onChanged: onChanged),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: Text(
                value == null ? t.pleaseSelectTime : t.formatFullDateTime(value),
                style: TextStyle(
                  fontSize: 15,
                  color: value == null ? Colors.blue.shade700 : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () => onChanged(DateTime.now()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF83ACA9), // ★ 規格色
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                elevation: 1,
              ),
              child: Text(t.useCurrentTime, style: const TextStyle(fontSize: 12.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 20,
            color: isSelected ? const Color(0xFF274C4A) : Colors.black45, // ★ 深綠
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 15.5)),
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
      runSpacing: 6, // ★ 行距拉開一點
      children: List.generate(options.length, (i) {
        return _radioOption(
          label: options[i],
          isSelected: groupIndex == i,
          onTap: () => onChanged(i),
        );
      }),
    );
  }

  Widget _placeSubOptions(
    AmbulanceData data,
    List<String> t1Places,
    List<String> t2Places,
    List<String> cargoPlaces,
    List<String> novotelPlaces,
    List<String> cabinPlaces,
  ) {
    final List<String> opts;
    final int? groupIndex;
    final ValueChanged<int> onChanged;

    switch (data.placeGroupIdx) {
      case 0:
        opts = t1Places;
        groupIndex = data.t1PlaceIdx;
        onChanged = (i) => data.updateInformation(t1PlaceIdx: i);
        break;
      case 1:
        opts = t2Places;
        groupIndex = data.t2PlaceIdx;
        onChanged = (i) => data.updateInformation(t2PlaceIdx: i);
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = data.remotePlaceIdx;
        onChanged = (i) => data.updateInformation(remotePlaceIdx: i);
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = data.cargoPlaceIdx;
        onChanged = (i) => data.updateInformation(cargoPlaceIdx: i);
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = data.novotelPlaceIdx;
        onChanged = (i) => data.updateInformation(novotelPlaceIdx: i);
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = data.cabinPlaceIdx;
        onChanged = (i) => data.updateInformation(cabinPlaceIdx: i);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: _radioWrap(
        options: opts,
        groupIndex: groupIndex,
        onChanged: onChanged,
      ),
    );
  }
}
