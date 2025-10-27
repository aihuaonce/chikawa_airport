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

    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        // 【修改】判斷是否有值，用於決定 RadioButton 狀態
        final bool hasTravelStatus =
            data.travelStatus != null && data.travelStatus!.isNotEmpty;
        final bool hasAirline =
            data.airline != null && data.airline!.isNotEmpty;

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
                      _label(t.source),
                      const SizedBox(height: 6),
                      // 【修改】顯示單一的、不可點擊的 radioRow
                      _radioRow(
                        label: hasTravelStatus
                            ? data.travelStatus!
                            : t.valueNotAvailable, // "N/A"
                        selected: hasTravelStatus,
                        onTap: () {}, // 空回調，使其不可點擊
                      ),
                      const SizedBox(height: 16),

                      _label(t.purposeOfVisit),
                      const SizedBox(height: 6),
                      // 【修改】傳入 onChanged: null 來禁用整個 Wrap
                      _radioWrap(
                        options: purposeOptions,
                        groupIndex: data.purposeIndex,
                        onChanged: null, // 傳入 null 來禁用
                      ),
                      const SizedBox(height: 16),

                      _label(t.airline),
                      const SizedBox(height: 6),
                      // 【修改】顯示單一的、不可點擊的 radioRow
                      _radioRow(
                        label: hasAirline ? data.airline! : t.valueNotAvailable,
                        selected: hasAirline,
                        onTap: () {}, // 空回調，使其不可點擊
                      ),
                      const SizedBox(height: 16),

                      _label(t.nationality),
                      const SizedBox(height: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            (_patientNationality != null &&
                                    _patientNationality!.isNotEmpty)
                                ? _patientNationality!
                                : t.dataNotAvailable,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  (_patientNationality != null &&
                                      _patientNationality!.isNotEmpty)
                                  ? Colors.black87
                                  : Colors.grey[600],
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

  Widget _radioWrap({
    required List<String> options,
    required int? groupIndex,
    // 【修改】將 onChanged 改為可選 (nullable)
    required ValueChanged<int>? onChanged,
  }) {
    return Wrap(
      spacing: 18,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        final selected = groupIndex == i;
        return InkWell(
          // 【修改】只有當 onChanged 不是 null 時才啟用 onTap
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
                  // 【修改】如果禁用，文字顏色變灰
                  color: onChanged != null ? Colors.black87 : Colors.black54,
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
    Widget? trailing,
  }) {
    // 【修改】判斷是否可編輯
    final bool isEditable = onTap != () {};

    return InkWell(
      onTap: isEditable ? onTap : null, // 如果 onTap 是空函數，則禁用
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
