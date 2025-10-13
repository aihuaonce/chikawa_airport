import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class EmergencyFlightPage extends StatefulWidget {
  final int visitId;
  const EmergencyFlightPage({super.key, required this.visitId});

  @override
  State<EmergencyFlightPage> createState() => _EmergencyFlightPageState();
}

class _EmergencyFlightPageState extends State<EmergencyFlightPage> {
  // 【修改】移除所有靜態選項列表

  final TextEditingController nationalityCtrl = TextEditingController();
  final GlobalKey otherAirlineKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<EmergencyData>();
    nationalityCtrl.text = data.nationality ?? '';
  }

  @override
  void dispose() {
    nationalityCtrl.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<EmergencyData>();
    data.updateFlight(nationality: nationalityCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context); // 【新增】

    // 【新增】動態建立翻譯後的選項列表
    final List<String> sourceOptions = [
      t.departure,
      t.arrival,
      t.transit,
      t.other,
    ];
    final List<String> purposeOptions = [
      t.airlineCrew,
      t.passenger,
      t.airportStaff,
    ];
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

    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: _bigCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(t.source), // 【修改】
                const SizedBox(height: 6),
                _radioWrap(
                  options: sourceOptions, // 【修改】
                  groupIndex: data.sourceIndex,
                  onChanged: (i) => data.updateFlight(sourceIndex: i),
                ),
                const SizedBox(height: 16),

                _label(t.purposeOfVisit), // 【修改】
                const SizedBox(height: 6),
                _radioWrap(
                  options: purposeOptions, // 【修改】
                  groupIndex: data.purposeIndex,
                  onChanged: (i) => data.updateFlight(purposeIndex: i),
                ),
                const SizedBox(height: 16),

                _label(t.airline), // 【修改】
                const SizedBox(height: 6),
                ...List.generate(mainAirlines.length, (i) {
                  final selected =
                      !data.useOtherAirline && data.airlineIndex == i;
                  return _radioRow(
                    label: mainAirlines[i], // 【修改】
                    selected: selected,
                    onTap: () {
                      data.updateFlight(
                        useOtherAirline: false,
                        airlineIndex: i,
                        selectedOtherAirline: null,
                      );
                    },
                  );
                }),
                _radioRow(
                  key: otherAirlineKey,
                  label: t.otherAirline, // 【修改】
                  selected: data.useOtherAirline,
                  onTap: () async {
                    data.updateFlight(useOtherAirline: true);
                    final picked = await _pickFromMenuAt(
                      anchorKey: otherAirlineKey,
                      options: otherAirlines, // 【修改】
                      allowSearch: true,
                    );
                    if (picked != null) {
                      data.updateFlight(selectedOtherAirline: picked);
                    }
                  },
                  trailing:
                      data.useOtherAirline && data.selectedOtherAirline != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            data.selectedOtherAirline!,
                            style: const TextStyle(
                              fontSize: 16.5,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                _label(t.nationality), // 【修改】
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: TextField(
                    controller: nationalityCtrl,
                    onChanged: (_) => _saveToProvider(),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: t.enterNationalityHint, // 【修改】
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bigCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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

  Widget _label(String s) => Text(
    s,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    ),
  );

  Widget _radioWrap({
    required List<String> options,
    required int? groupIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Wrap(
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
                color: selected ? const Color(0xFF274C4A) : Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(options[i], style: const TextStyle(fontSize: 16.5)),
            ],
          ),
        );
      }),
    );
  }

  Widget _radioRow({
    Key? key,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? const Color(0xFF274C4A) : Colors.black45,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(label, style: const TextStyle(fontSize: 16.5)),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Future<String?> _pickFromMenuAt({
    required GlobalKey anchorKey,
    required List<String> options,
    bool allowSearch = true,
  }) async {
    final t = AppTranslations.of(context); // 【新增】
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      box.size.width,
      box.size.height,
    );

    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: [
        ...options.map((e) => PopupMenuItem<String>(value: e, child: Text(e))),
        if (allowSearch) const PopupMenuDivider(),
        if (allowSearch)
          PopupMenuItem<String>(
            value: '__search_more__',
            child: Text(
              t.searchMore,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ), // 【修改】
          ),
      ],
    );

    if (choice == '__search_more__') {
      return _searchDialog(options: options);
    }
    return choice;
  }

  Future<String?> _searchDialog({required List<String> options}) async {
    final t = AppTranslations.of(context); // 【新增】
    final ctrl = TextEditingController();
    List<String> showing = List.of(options);

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return AlertDialog(
              title: Text(t.searchOrInput), // 【修改】
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        hintText: t.filterWithKeywordHint,
                      ), // 【修改】
                      onChanged: (text) {
                        setS(() {
                          showing = options
                              .where(
                                (e) => e.toLowerCase().contains(
                                  text.toLowerCase(),
                                ),
                              )
                              .toList();
                          if (showing.isEmpty && text.isNotEmpty) {
                            showing = ['${t.addNewPrefix}$text']; // 【修改】
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 320),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: showing.length,
                        itemBuilder: (_, i) {
                          final val = showing[i];
                          return ListTile(
                            dense: true,
                            title: Text(val),
                            onTap: () {
                              final pure =
                                  val.startsWith(t.addNewPrefix) // 【修改】
                                  ? val.substring(t.addNewPrefix.length)
                                  : val;
                              Navigator.of(ctx).pop(pure);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(t.cancel), // 【修改】
                ),
              ],
            );
          },
        );
      },
    );
  }
}
