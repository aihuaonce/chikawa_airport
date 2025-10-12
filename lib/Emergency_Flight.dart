import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';

class EmergencyFlightPage extends StatefulWidget {
  final int visitId;
  const EmergencyFlightPage({super.key, required this.visitId});

  @override
  State<EmergencyFlightPage> createState() => _EmergencyFlightPageState();
}

class _EmergencyFlightPageState extends State<EmergencyFlightPage> {
  final List<String> sourceOptions = const ['出境', '入境', '過境', '其他'];
  final List<String> purposeOptions = const ['航空公司機組員', '旅客/民眾', '機場內部員工'];

  final List<String> mainAirlines = const [
    'BR長榮航空',
    'CI中華航空',
    'CX國泰航空',
    'UA聯合航空',
    'KL荷蘭航空',
    'CZ中國南方航空',
    'IT台灣虎航',
    'EK阿聯酋航空',
    'CA中國國際航空',
  ];

  final List<String> otherAirlines = const [
    'JX星宇航空',
    'AE華信航空',
    'B7立榮航空',
    'MU中國東方航空',
    'MF廈門航空',
    'MM樂桃航空',
    'KE大韓航空',
    'OZ韓亞航空',
  ];

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
    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: _bigCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 來源
                _label('來源'),
                const SizedBox(height: 6),
                _radioWrap(
                  options: sourceOptions,
                  groupIndex: data.sourceIndex,
                  onChanged: (i) => data.updateFlight(sourceIndex: i),
                ),
                const SizedBox(height: 16),

                // 為何至機場
                _label('為何至機場'),
                const SizedBox(height: 6),
                _radioWrap(
                  options: purposeOptions,
                  groupIndex: data.purposeIndex,
                  onChanged: (i) => data.updateFlight(purposeIndex: i),
                ),
                const SizedBox(height: 16),

                // 航空公司
                _label('航空公司'),
                const SizedBox(height: 6),
                ...List.generate(mainAirlines.length, (i) {
                  final selected = !data.useOtherAirline && data.airlineIndex == i;
                  return _radioRow(
                    label: mainAirlines[i],
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
                  label: '其他航空公司',
                  selected: data.useOtherAirline,
                  onTap: () async {
                    data.updateFlight(useOtherAirline: true);
                    final picked = await _pickFromMenuAt(
                      anchorKey: otherAirlineKey,
                      options: otherAirlines,
                      allowSearch: true,
                    );
                    if (picked != null) {
                      data.updateFlight(selectedOtherAirline: picked);
                    }
                  },
                  trailing: data.useOtherAirline && data.selectedOtherAirline != null
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

                // 國籍
                _label('國籍'),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: TextField(
                    controller: nationalityCtrl,
                    onChanged: (_) => _saveToProvider(),
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: '請輸入國籍',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
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
            Flexible(child: Text(label, style: const TextStyle(fontSize: 16.5))),
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
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);

    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: [
        ...options.map((e) => PopupMenuItem<String>(value: e, child: Text(e))),
        if (allowSearch) const PopupMenuDivider(),
        if (allowSearch)
          const PopupMenuItem<String>(
            value: '__search_more__',
            child: Text('搜尋更多…', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
      ],
    );

    if (choice == '__search_more__') {
      return _searchDialog(options: options);
    }
    return choice;
  }

  Future<String?> _searchDialog({required List<String> options}) async {
    final ctrl = TextEditingController();
    List<String> showing = List.of(options);

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setS) {
          return AlertDialog(
            title: const Text('搜尋 / 輸入'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(hintText: '輸入關鍵字過濾…'),
                    onChanged: (t) {
                      setS(() {
                        showing = options
                            .where((e) => e.toLowerCase().contains(t.toLowerCase()))
                            .toList();
                        if (showing.isEmpty && t.isNotEmpty) {
                          showing = ['新增：$t'];
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
                            final pure = val.startsWith('新增：') ? val.substring(3) : val;
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
                child: const Text('取消'),
              ),
            ],
          );
        });
      },
    );
  }
}