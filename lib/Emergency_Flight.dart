import 'package:chikawa_airport/data/db/daos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart';

class EmergencyFlightPage extends StatefulWidget {
  final int visitId;
  const EmergencyFlightPage({super.key, required this.visitId});

  @override
  State<EmergencyFlightPage> createState() => _EmergencyFlightPageState();
}

class _EmergencyFlightPageState extends State<EmergencyFlightPage> {
  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _border = Color(0xFFCBD5E1);

  String? _patientNationality;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadVisitData();
    });
  }

  Future<void> _loadVisitData() async {
    final visitsDao = context.read<VisitsDao>();
    final visit = await visitsDao.getById(widget.visitId);
    if (visit != null && mounted) {
      setState(() {
        _patientNationality = visit.nationality;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    final List<String> purposeOptions = [
      t.airlineCrew,
      t.passenger,
      t.airportStaff,
    ];

    // 【新增】複製 FlightLogPage 的航空公司選項，用於建構唯讀 UI
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

    final nationalityOptions = {
      '台灣': t.taiwanNationality,
      '美國': t.nationalityUSA,
      '越南': t.nationalityVietnam,
      '泰國': t.nationalityThailand,
      '印尼': t.nationalityIndonesia,
      '菲律賓': t.nationalityPhilippines,
      '香港': t.nationalityHongKong,
      '澳門': t.nationalityMacau,
      '加拿大': t.nationalityCanada,
      '中國大陸': t.nationalityChina,
      '日本': t.nationalityJapan,
      '其他': t.nationalityOther,
    };

    // ==================【以下為修改部分 (1/2)】==================
    // 【新增】複製 FlightLogPage 的旅遊狀態選項
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
    // ==================【以上為修改部分 (1/2)】==================

    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        // 這行 'hasTravelStatus' 在修改後不再需要，但保留也沒關係
        // final bool hasTravelStatus =
        //     data.travelStatus != null && data.travelStatus!.isNotEmpty;

        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================【以下為修改部分 (2/2)】==================
                      _label(t.source),
                      const SizedBox(height: 6),
                      // 【修改】改用 _airlineRadioWrap 顯示唯讀的旅遊狀態
                      _airlineRadioWrap(
                        options: travelOptions.values.toList(),
                        groupValue: data.travelStatus,
                        dbValues: travelOptions.keys.toList(),
                        onChanged: null, // 唯讀
                      ),
                      const SizedBox(height: 16),

                      // ==================【以上為修改部分 (2/2)】==================
                      _label(t.purposeOfVisit),
                      const SizedBox(height: 6),
                      _purposeRadioWrap(
                        options: purposeOptions,
                        groupIndex: data.purposeIndex,
                        onChanged: null, // 禁用
                      ),
                      const SizedBox(height: 16),

                      _label(t.airline),
                      const SizedBox(height: 6),

                      // ===== 航空公司：主清單（唯讀）=====
                      _airlineRadioWrap(
                        options: mainAirlineOptions.values.toList(),
                        groupValue:
                            otherAirlineOptions.containsKey(data.airline)
                            ? null
                            : data.airline,
                        dbValues: mainAirlineOptions.keys.toList(),
                        onChanged: null, // 【鎖定】傳入 null 來禁用互動
                      ),
                      const SizedBox(height: 8),

                      // ===== 其他航空公司（唯讀）=====
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(-2, 0),
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: otherAirlineOptions.containsKey(
                                    data.airline,
                                  ),
                                  onChanged: null, // 【鎖定】禁用 Checkbox
                                  activeColor: _deepGreen,
                                  checkColor: Colors.white,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -2,
                                    vertical: -2,
                                  ),
                                  side: const BorderSide(
                                    color: _border,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.otherAirline,
                              style: TextStyle(
                                color: Colors.black54,
                              ), // 灰色文字表示禁用
                            ),
                            if (otherAirlineOptions.containsKey(
                              data.airline,
                            )) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: data.airline,
                                  items: otherAirlineOptions.entries
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: null, // 禁用 Dropdown
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none, // 隱藏邊框
                                  ),
                                  disabledHint: Text(
                                    otherAirlineOptions[data.airline] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      _label(t.nationality),
                      const SizedBox(height: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: DropdownButtonFormField<String>(
                          value: _patientNationality,
                          items: nationalityOptions.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: null, // 禁用
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                          disabledHint: Text(
                            (_patientNationality != null &&
                                    nationalityOptions.containsKey(
                                      _patientNationality,
                                    ))
                                ? nationalityOptions[_patientNationality]!
                                : t.dataNotAvailable,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
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

  // ============== 小積木 ===============
  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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

  Widget _label(String s) => Text(
    s,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
      height: 1.25,
    ),
  );

  Widget _purposeRadioWrap({
    required List<String> options,
    required int? groupIndex,
    required ValueChanged<int>? onChanged,
  }) {
    return Wrap(
      spacing: 18,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        final selected = groupIndex == i;
        return InkWell(
          onTap: onChanged != null ? () => onChanged(i) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? _deepGreen : Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(
                options[i],
                style: TextStyle(
                  fontSize: 16.5,
                  color: onChanged != null ? Colors.black87 : Colors.black54,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // 【修改】此函式現在可以處理禁用狀態 (onChanged: null)
  Widget _airlineRadioWrap({
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
        final selected = groupValue == dbValues[i];
        return InkWell(
          onTap: isEnabled ? () => onChanged(dbValues[i]) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                // 禁用時顯示灰色
                color: selected
                    ? _deepGreen
                    : (isEnabled ? Colors.black45 : Colors.grey.shade400),
              ),
              const SizedBox(width: 6),
              Text(
                options[i],
                // 禁用時顯示灰色文字
                style: TextStyle(
                  color: isEnabled ? Colors.black87 : Colors.black54,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _radioRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final bool isEditable = onTap != () {};

    return InkWell(
      onTap: isEditable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? _deepGreen : Colors.black45,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.5,
                  color: isEditable ? Colors.black87 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
