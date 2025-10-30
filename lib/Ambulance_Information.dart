import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/ambulance_data.dart';
import 'data/db/daos.dart';
import 'l10n/app_translations.dart';

class AmbulanceInformationPage extends StatefulWidget {
  final int visitId;
  const AmbulanceInformationPage({super.key, required this.visitId});

  @override
  State<AmbulanceInformationPage> createState() =>
      _AmbulanceInformationPageState();
}

class _AmbulanceInformationPageState extends State<AmbulanceInformationPage> {
  // ===== 版面外觀 (靜態常量) =====
  static const double _cardRadius = 16;
  static const double _labelWidth = 120;
  static const double _cardMaxWidth = 1000;
  static const Color _deepGreen = Color(0xFF274C4A);

  // ===== 文字輸入控制器 =====
  final _plateCtrl = TextEditingController();
  final _otherDestCtrl = TextEditingController();

  // 🔥 新增：從 AccidentRecords 讀取的唯讀資料
  String? _accidentPlaceGroup;
  String? _accidentPlaceDetail;
  String? _accidentPlaceNote;
  bool _isLoadingAccident = true;

  // ===== 選項列表 (靜態常量,無需翻譯) =====
  static const List<String> remotePlaces = [
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
        _loadAccidentData(); // 🔥 載入事故地點資料
      }
    });
  }

  void _loadInitialData() {
    final data = context.read<AmbulanceData>();
    _plateCtrl.text = data.plateNumber ?? '';
    _otherDestCtrl.text = data.otherDestinationHospital ?? '';
  }

  // 🔥 新增：從 AccidentRecords 讀取事故地點
  Future<void> _loadAccidentData() async {
    try {
      final accidentDao = context.read<AccidentRecordsDao>();
      final record = await accidentDao.getByVisitId(widget.visitId);

      if (record != null && mounted) {
        setState(() {
          _accidentPlaceGroup = record.placeGroup;
          _accidentPlaceDetail = record.placeDetail;
          _accidentPlaceNote = record.placeNote;
          _isLoadingAccident = false;
        });
      } else {
        setState(() => _isLoadingAccident = false);
      }
    } catch (e) {
      print('❌ 讀取事故地點失敗: $e');
      setState(() => _isLoadingAccident = false);
    }
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
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
    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    // 🔥 地點選項 Map（用於顯示）
    final Map<String, String> placeGroupOptions = {
      '第一航廈': t.terminal1,
      '第二航廈': t.terminal2,
      '遠端機坪': t.remoteApron,
      '貨運站/機坪其他': t.cargoOther,
      '諾富特飯店': t.novotelHotel,
      '飛機機艙內': t.insideAircraft,
    };

    final Map<String, List<String>> placeDetailOptions = {
      '第一航廈': [
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
      ],
      '第二航廈': [
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
      ],
      '遠端機坪': remotePlaces,
      '貨運站/機坪其他': [
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
      ],
      '諾富特飯店': [t.novotelHotel],
      '飛機機艙內': [t.insideAircraft],
    };

    final List<String> hospitals = [
      t.landseedHospital,
      t.linkouChangGung,
      t.taoyuanHospital,
      t.taoyuanPsychiatricCenter,
      t.taoyuanMinSheng,
      t.stPaulsHospital,
      t.tienShengHospital,
      t.taoyuanVeteransHospital,
      t.enChuKungHospital,
      t.other,
    ];

    final List<String> transportReasons = [
      t.patientConditionRequired,
      t.patientOrFamilyRequest,
    ];
    int? transportReasonIdx;

    return Consumer<AmbulanceData>(
      builder: (context, data, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
              child: _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rowTop(
                      label: t.plateNumber,
                      labelWidth: 84,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: TextField(
                          controller: _plateCtrl,
                          onChanged: (_) => _saveToProvider(hospitals),
                          decoration: InputDecoration(
                            hintText: t.enterPlateNumberHint,
                            border: const OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🔥 事故地點區塊（唯讀）
                    _bold('${t.incidentLocation}'),
                    const SizedBox(height: 6),
                    if (_isLoadingAccident)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      // 顯示 placeGroup（唯讀）
                      _stringRadioWrap(
                        options: placeGroupOptions.values.toList(),
                        groupValue: _accidentPlaceGroup,
                        dbValues: placeGroupOptions.keys.toList(),
                        onChanged: null, // 🔥 禁用
                      ),
                      const SizedBox(height: 8),

                      // 顯示 placeDetail（唯讀）
                      if (_accidentPlaceGroup != null &&
                          placeDetailOptions.containsKey(
                            _accidentPlaceGroup,
                          )) ...[
                        _stringRadioWrap(
                          options: placeDetailOptions[_accidentPlaceGroup]!,
                          groupValue: _accidentPlaceDetail,
                          dbValues: placeDetailOptions[_accidentPlaceGroup]!,
                          onChanged: null, // 🔥 禁用
                        ),
                        const SizedBox(height: 8),
                      ],

                      // 顯示 placeNote（唯讀）
                      if (_accidentPlaceNote != null &&
                          _accidentPlaceNote!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${t.locationNotes}: $_accidentPlaceNote',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
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
                      onChanged: (dt) =>
                          data.updateInformation(arriveSceneTime: dt),
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
                                data.updateInformation(
                                  destinationHospitalIdx: i,
                                );
                                _saveToProvider(hospitals);
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                    if (data.destinationHospitalIdx ==
                        hospitals.length - 1) ...[
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
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
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
                        onChanged: (i) =>
                            setState(() => transportReasonIdx = i),
                      ),
                    ),

                    const SizedBox(height: 16),
                    _dateTimeRow(
                      label: t.leaveSceneTime,
                      value: data.leaveSceneTime,
                      onChanged: (dt) =>
                          data.updateInformation(leaveSceneTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.arriveHospitalTime,
                      value: data.arriveHospitalTime,
                      onChanged: (dt) =>
                          data.updateInformation(arriveHospitalTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.leaveHospitalTime,
                      value: data.leaveHospitalTime,
                      onChanged: (dt) =>
                          data.updateInformation(leaveHospitalTime: dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: t.backToStandbyTime,
                      value: data.backStandbyTime,
                      onChanged: (dt) =>
                          data.updateInformation(backStandbyTime: dt),
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

  // ====== 小積木 (Helper Widgets) ======
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
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

  Widget _bold(String s) => Text(
    s,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
      height: 1.25,
    ),
  );

  Widget _rowTop({
    required String label,
    required Widget child,
    double? labelWidth,
  }) {
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
          width: labelWidth ?? _labelWidth,
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
        Expanded(
          child: Align(alignment: Alignment.topLeft, child: effectiveChild),
        ),
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
                value == null
                    ? t.pleaseSelectTime
                    : t.formatFullDateTime(value),
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
                backgroundColor: const Color(0xFF83ACA9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                elevation: 1,
              ),
              child: Text(
                t.useCurrentTime,
                style: const TextStyle(fontSize: 12.5),
              ),
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
            color: isSelected ? _deepGreen : Colors.black45,
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
      runSpacing: 6,
      children: List.generate(options.length, (i) {
        return _radioOption(
          label: options[i],
          isSelected: groupIndex == i,
          onTap: () => onChanged(i),
        );
      }),
    );
  }

  // 🔥 唯讀版本的 _stringRadioWrap
  Widget _stringRadioWrap({
    required List<String> options,
    required String? groupValue,
    required List<String> dbValues,
    required ValueChanged<String>? onChanged, // 🔥 可為 null
  }) {
    final isEnabled = onChanged != null;
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        if (i >= dbValues.length) return const SizedBox.shrink();

        final selected = groupValue == dbValues[i];
        return InkWell(
          onTap: isEnabled ? () => onChanged(dbValues[i]) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected
                    ? _deepGreen
                    : (isEnabled ? Colors.black45 : Colors.grey.shade400),
              ),
              const SizedBox(width: 6),
              Text(
                options[i],
                style: TextStyle(
                  color: isEnabled ? Colors.black87 : Colors.black54,
                  fontSize: 15.5,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
