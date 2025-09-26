import 'package:flutter/material.dart';
import 'nav2.dart';

class FlightLogPage extends StatefulWidget {
  final int visitId;
  const FlightLogPage({super.key,required this.visitId,});

  @override
  State<FlightLogPage> createState() => _FlightLogPageState();
}

class _FlightLogPageState extends State<FlightLogPage> {
  // ----------------- 資料 -----------------
  final List<String> mainAirlines = [
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

  final List<String> otherAirlines = [
    'JX星宇航空',
    'AE華信航空',
    'B7立榮航空',
    'MU中國東方航空',
    'MF廈門航空',
    'MM樂桃航空',
    'KE大韓航空',
    'OZ韓亞航空',
  ];

  final List<String> airportOptions = const [
    'TPE台北 / 台灣',
    'HKG香港 / 香港',
    'LAX洛杉磯 / 美國',
    'SHA上海 / 中國',
    'TYO東京 / 日本',
    'BKK曼谷 / 泰國',
    'SFO舊金山 / 美國',
    'MNL馬尼拉 / 菲律賓',
  ];

  final List<String> travelOptions = const [
    '出境', '入境', '過境', '轉機', '迫降', '轉降', '備降', '其他'
  ];

  // ----------------- 狀態 -----------------
  int airlineIndex = 0;
  bool useOtherAirline = false;
  String? selectedOtherAirline;

  final TextEditingController flightNoCtrl = TextEditingController();
  final FocusNode flightNoFocus = FocusNode();

  final TextEditingController otherTravelCtrl = TextEditingController();
  final FocusNode otherTravelFocus = FocusNode();

  int? travelStatusIndex;

  String? dep;  // 啟程地
  String? via;  // 經過地
  String? dest; // 目的地

  // 錨點（讓選單貼在被點元件旁邊）
  final GlobalKey otherAirlineKey = GlobalKey();
  final GlobalKey depKey = GlobalKey();
  final GlobalKey viaKey = GlobalKey();
  final GlobalKey destKey = GlobalKey();

  @override
  void dispose() {
    flightNoCtrl.dispose();
    flightNoFocus.dispose();
    otherTravelCtrl.dispose();
    otherTravelFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      visitId: widget.visitId,
      selectedIndex: 1,
      child: Container(
        color: const Color(0xFFE6F6FB),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 980;

              // 左側內容
              final leftColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('航空公司'),
                  const SizedBox(height: 6),
                  ...List.generate(mainAirlines.length, (i) {
                    return _radioRow(
                      label: mainAirlines[i],
                      selected: !useOtherAirline && airlineIndex == i,
                      onTap: () {
                        setState(() {
                          useOtherAirline = false;
                          airlineIndex = i;
                          selectedOtherAirline = null;
                        });
                      },
                    );
                  }),
                  // 其他航空公司 + 下拉
                  _radioRow(
                    key: otherAirlineKey,
                    label: '其他航空公司',
                    selected: useOtherAirline,
                    onTap: () async {
                      setState(() => useOtherAirline = true);
                      final picked = await _pickFromMenuAt(
                        anchorKey: otherAirlineKey,
                        options: otherAirlines,
                        allowSearch: true,
                      );
                      if (picked != null) {
                        setState(() => selectedOtherAirline = picked);
                      }
                    },
                    trailing: useOtherAirline && selectedOtherAirline != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              selectedOtherAirline!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              );

              // 右側內容
              final rightColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('班機'),
                  const SizedBox(height: 6),
                  _UnderlineHintInput(
                    controller: flightNoCtrl,
                    focusNode: flightNoFocus,
                    hint: '請填寫班機代碼',
                    width: 360,
                    hintStyle: const TextStyle(
                      color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w400),
                    textStyle: const TextStyle(
                      color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 22),

                  _sectionTitle('旅行狀態'),
                  const SizedBox(height: 6),
                  Column(
                    children: List.generate(travelOptions.length, (i) {
                      return _radioRow(
                        label: travelOptions[i],
                        selected: travelStatusIndex == i,
                        onTap: () {
                          setState(() {
                            travelStatusIndex = i;
                            if (i != travelOptions.length - 1) {
                              otherTravelCtrl.clear();
                            }
                          });
                        },
                      );
                    }),
                  ),
                  if (travelStatusIndex == travelOptions.length - 1) ...[
                    const SizedBox(height: 10),
                    _UnderlineHintInput(
                      controller: otherTravelCtrl,
                      focusNode: otherTravelFocus,
                      hint: '請填寫其他旅行狀態',
                      width: 360,
                      hintStyle: const TextStyle(
                        color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w400),
                      textStyle: const TextStyle(
                        color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                  const SizedBox(height: 28),

                  _sectionTitle('啟程地'),
                  const SizedBox(height: 6),
                  _PickField(
                    key: depKey,
                    placeholder: '點擊選擇啟程地',
                    value: dep,
                    onPick: () async {
                      final picked = await _pickFromMenuAt(
                        anchorKey: depKey,
                        options: airportOptions,
                        allowSearch: true,
                      );
                      if (picked != null) setState(() => dep = picked);
                    },
                  ),
                  const SizedBox(height: 18),

                  _sectionTitle('經過地'),
                  const SizedBox(height: 6),
                  _PickField(
                    key: viaKey,
                    placeholder: '視情況點擊選擇經過地',
                    value: via,
                    onPick: () async {
                      final picked = await _pickFromMenuAt(
                        anchorKey: viaKey,
                        options: airportOptions,
                        allowSearch: true,
                      );
                      if (picked != null) setState(() => via = picked);
                    },
                  ),
                  const SizedBox(height: 18),

                  _sectionTitle('目的地'),
                  const SizedBox(height: 6),
                  _PickField(
                    key: destKey,
                    placeholder: '點擊選擇目的地',
                    value: dest,
                    onPick: () async {
                      final picked = await _pickFromMenuAt(
                        anchorKey: destKey,
                        options: airportOptions,
                        allowSearch: true,
                      );
                      if (picked != null) setState(() => dest = picked);
                    },
                  ),
                ],
              );

              // ======= 一張大卡片（與小卡片一樣的圓角/陰影） =======
              if (wide) {
                return _bigCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: leftColumn),
                      // 中間細分隔（可要可不要）
                      const SizedBox(width: 24),
                      Expanded(child: rightColumn),
                    ],
                  ),
                );
              } else {
                return _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftColumn,
                      const SizedBox(height: 16),
                      rightColumn,
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // ----------------- UI 小組件 -----------------

  /// 一張「大卡片」：與原本小卡片相同的圓角與陰影
  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14), // ← 圓角
        boxShadow: const [
          BoxShadow( // ← 陰影
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String s) => Text(
        s,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      );

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
            Flexible(child: Text(label, style: const TextStyle(fontSize: 18))),
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
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final box = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);

    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: [
        ...options.map(
          (e) => PopupMenuItem<String>(
            value: e,
            child: Text(e),
          ),
        ),
        if (allowSearch) const PopupMenuDivider(),
        if (allowSearch)
          const PopupMenuItem<String>(
            value: '__search_more__',
            child: Text('搜尋更多…', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        if (allowSearch)
          const PopupMenuItem<String>(
            value: '__start_input__',
            child: Text('開始輸入…', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
      ],
    );

    if (choice == '__search_more__' || choice == '__start_input__') {
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
                    decoration: const InputDecoration(
                      hintText: '輸入關鍵字過濾…',
                    ),
                    onChanged: (t) {
                      setS(() {
                        showing = options
                            .where((e) =>
                                e.toLowerCase().contains(t.toLowerCase()))
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
                            final pure = val.startsWith('新增：')
                                ? val.substring(3)
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
                child: const Text('取消'),
              ),
            ],
          );
        });
      },
    );
  }
}

// ===== 帶「提示+底線」→（空白顯示提示，有字顯示輸入；字體黑色、不粗） =====
class _UnderlineHintInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final double width;
  final TextStyle hintStyle;
  final TextStyle textStyle;

  const _UnderlineHintInput({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.width,
    required this.hintStyle,
    required this.textStyle,
  });

  @override
  State<_UnderlineHintInput> createState() => _UnderlineHintInputState();
}

class _UnderlineHintInputState extends State<_UnderlineHintInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final empty = widget.controller.text.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.width,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (empty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(widget.hint, style: widget.hintStyle),
                ),
              TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '',
                ),
                style: widget.textStyle,
              ),
            ],
          ),
        ),
        Container(width: widget.width, height: 2, color: Colors.black87),
      ],
    );
  }
}

// ===== 可點擊的選擇欄位 =====
class _PickField extends StatelessWidget {
  final String placeholder;
  final String? value;
  final VoidCallback onPick;

  const _PickField({
    Key? key,
    required this.placeholder,
    required this.value,
    required this.onPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final show = value ?? placeholder;
    final isPlaceholder = value == null;

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Text(
          show,
          style: TextStyle(
            fontSize: 18,
            color: isPlaceholder ? Colors.black54 : Colors.black87,
            fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
