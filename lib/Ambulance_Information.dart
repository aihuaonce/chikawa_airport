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

  // 🔥 從 AccidentRecords 讀取的唯讀資料
  String? _accidentPlaceGroup;
  String? _accidentPlaceDetail;
  String? _accidentPlaceNote;
  bool _isLoadingAccident = true;

  // 🔥 從 Treatments 讀取的轉送醫院資料
  String? _referralHospital;
  String? _referralOtherHospital;
  bool _isLoadingReferral = true;

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
        _loadAccidentData();
        _loadReferralData();
      }
    });
  }

  void _loadInitialData() {
    final data = context.read<AmbulanceData>();
    _plateCtrl.text = data.plateNumber ?? '';
  }

  // 🔥 從 AccidentRecords 讀取事故地點
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

  // 🔥 從 Treatments 讀取轉送醫院資料
  Future<void> _loadReferralData() async {
    try {
      final treatmentsDao = context.read<TreatmentsDao>();
      final record = await treatmentsDao.getByVisitId(widget.visitId);

      if (record != null && mounted) {
        setState(() {
          _referralHospital = record.referralHospital;
          _referralOtherHospital = record.referralOtherHospital;
          _isLoadingReferral = false;
        });
      } else {
        setState(() => _isLoadingReferral = false);
      }
    } catch (e) {
      print('❌ 讀取轉送醫院資料失敗: $e');
      setState(() => _isLoadingReferral = false);
    }
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    super.dispose();
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

    // 🔥 醫院選項 Map（用於顯示）
    final Map<String, String> hospitalOptions = {
      'landseed': t.landseedHospital,
      'linkou_chang_gung': t.linkouChangGung,
      'taoyuan_general': t.taoyuanHospital,
      'taoyuan_psychiatric': t.taoyuanPsychiatricCenter,
      'minsheng': t.taoyuanMinSheng,
      'st_pauls': t.stPaulsHospital,
      'tien_sheng': t.tienShengHospital,
      'taoyuan_veterans': t.taoyuanVeteransHospital,
      'en_chu_kung': t.enChuKungHospital,
      'other': t.other,
    };

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
                          onChanged: (_) => data.updateInformation(
                            plateNumber: _plateCtrl.text,
                          ),
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
                      _stringRadioWrap(
                        options: placeGroupOptions.values.toList(),
                        groupValue: _accidentPlaceGroup,
                        dbValues: placeGroupOptions.keys.toList(),
                        onChanged: null,
                      ),
                      const SizedBox(height: 8),

                      if (_accidentPlaceGroup != null &&
                          placeDetailOptions.containsKey(
                            _accidentPlaceGroup,
                          )) ...[
                        _stringRadioWrap(
                          options: placeDetailOptions[_accidentPlaceGroup]!,
                          groupValue: _accidentPlaceDetail,
                          dbValues: placeDetailOptions[_accidentPlaceGroup]!,
                          onChanged: null,
                        ),
                        const SizedBox(height: 8),
                      ],

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

                    // 🔥 轉送醫院區塊（唯讀）
                    _bold('${t.destinationHospitalOrPlace}'),
                    const SizedBox(height: 6),
                    if (_isLoadingReferral)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      _stringRadioWrap(
                        options: hospitalOptions.values.toList(),
                        groupValue: _referralHospital,
                        dbValues: hospitalOptions.keys.toList(),
                        onChanged: null,
                      ),
                      const SizedBox(height: 8),

                      // 🔥 其他醫院名稱加粗體
                      if (_referralHospital == 'other' &&
                          _referralOtherHospital != null &&
                          _referralOtherHospital!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              _bold('${t.otherHospitalName}: '),
                              Text(
                                _referralOtherHospital!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
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

  // 🔥 唯讀版本的 _stringRadioWrap
  Widget _stringRadioWrap({
    required List<String> options,
    required String? groupValue,
    required List<String> dbValues,
    required ValueChanged<String>? onChanged,
  }) {
    final isEnabled = onChanged != null;
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        if (i >= dbValues.length) return const SizedBox.shrink();

        final selected = groupValue == dbValues[i];
        return InkWell(
          onTap: isEnabled ? () => onChanged!(dbValues[i]) : null,
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
