// lib/Emergency_Accident.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart'; // 保持這個引入，或許還需要 EmergencyData 的其他屬性
import 'data/models/accident_data.dart'; // 【新增/假設】 導入 AccidentData model
import 'l10n/app_translations.dart';

class EmergencyAccidentPage extends StatefulWidget {
  final int visitId;
  const EmergencyAccidentPage({super.key, required this.visitId});

  @override
  State<EmergencyAccidentPage> createState() => _EmergencyAccidentPageState();
}

class _EmergencyAccidentPageState extends State<EmergencyAccidentPage> {
  // 統一外觀
  static const double _cardMaxWidth = 1000;
  static const double _radius = 16;
  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _lightGreen = Color(0xFF83ACA9);
  static const Color _bg = Color(0xFFE6F6FB);

  final TextEditingController placeNoteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    // 【修正】現在從 AccidentData 讀取資料
    try {
      final data = context.read<AccidentData>();
      // 假設 AccidentData 中有 placeNote 屬性
      placeNoteCtrl.text = data.placeNote ?? '';
    } catch (e) {
      // 如果 AccidentData 尚未提供，則靜默處理
    }
  }

  @override
  void dispose() {
    placeNoteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    // 複製 AccidentRecord.dart 的選項
    final Map<String, String> placeGroupOptions = {
      '第一航廈': t.terminal1,
      '第二航廈': t.terminal2,
      '遠端機坪': t.remoteApron,
      '貨運站/機坪其他': t.cargoOther,
      '諾富特飯店': t.novotelHotel,
      '飛機機艙內': t.insideAircraft,
    };

    // 複製 AccidentRecord.dart 的詳細選項
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
      '遠端機坪': const [
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

    // 【修正】使用 Consumer<AccidentData>
    return Consumer<AccidentData>(
      builder: (context, data, child) {
        // 【假設】data 具有 placeGroup 和 placeDetail 屬性
        final String? placeGroup = data.placeGroup;
        final String? placeDetail = data.placeDetail;

        final detailOptionsList = placeDetailOptions[placeGroup] ?? [];

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
                        label: t.incidentDateTime,
                        // 【假設】AccidentData 中有 incidentDateTime 屬性
                        value: data.incidentDate,
                        onPick: null,
                        onNow: null,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 16),
                      _bold(t.accidentLocation),
                      const SizedBox(height: 6),

                      // 顯示 placeGroup (唯讀)
                      _stringRadioWrap(
                        options: placeGroupOptions.values.toList(),
                        groupValue: placeGroup,
                        dbValues: placeGroupOptions.keys.toList(),
                        onChanged: null, // 禁用
                      ),
                      const SizedBox(height: 8),

                      // 顯示 placeDetail (唯讀)
                      if (placeGroup != null &&
                          detailOptionsList.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _stringRadioWrap(
                          options: detailOptionsList,
                          groupValue: placeDetail,
                          dbValues: detailOptionsList, // 假設 DB 值和顯示值相同
                          onChanged: null, // 禁用
                        ),
                      ],
                      const SizedBox(height: 16),

                      _inputRowTight(
                        label: t.locationNotes,
                        hint: t.enterLocationNotes,
                        ctrl: placeNoteCtrl,
                        isEnabled: false, // 禁用
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
          color: Color(0x1A000000),
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

  Widget _dateTimeRow({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?>? onPick,
    required VoidCallback? onNow,
    bool isEnabled = true,
  }) {
    final t = AppTranslations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
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
          onTap: isEnabled
              ? () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (newDate != null && mounted) {
                    final newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        value ?? DateTime.now(),
                      ),
                    );
                    if (newTime != null && onPick != null) {
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
                }
              : null,
          child: Text(
            value == null ? t.pleaseSelectTime : t.formatFullDateTime(value),
            style: TextStyle(
              fontSize: 15,
              color: isEnabled ? Colors.black87 : Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: isEnabled ? onNow : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _lightGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade500,
            ),
            child: Text(t.updateTime, style: const TextStyle(fontSize: 12.5)),
          ),
        ),
      ],
    );
  }

  Widget _inputRowTight({
    required String label,
    required String hint,
    required TextEditingController ctrl,
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 84,
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
            width: 200,
            child: TextField(
              controller: ctrl,
              onChanged: null, // 唯讀
              enabled: isEnabled,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                filled: !isEnabled,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 複製自 Emergency_Flight.dart 的 _airlineRadioWrap，並改名
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
