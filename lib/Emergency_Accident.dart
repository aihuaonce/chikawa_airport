import 'package:flutter/material.dart';

class EmergencyAccidentPage extends StatefulWidget {
  const EmergencyAccidentPage({super.key});

  @override
  State<EmergencyAccidentPage> createState() => _EmergencyAccidentPageState();
}

class _EmergencyAccidentPageState extends State<EmergencyAccidentPage> {
  // 版面
  static const double _cardMaxWidth = 1100;
  static const double _radius = 16;

  // ===== 狀態 =====
  DateTime? incidentDateTime = DateTime.now(); // 事發日期與時間
  int? placeGroupIdx;                          // 發生地點（大類）

  // 各大類細項選中 index
  int? t1Selected, t2Selected, remoteSelected, cargoSelected, novotelSelected, cabinSelected;

  final TextEditingController placeNoteCtrl = TextEditingController(); // 地點備註

  // ===== 發生地點：大類（6個）=====
  final List<String> placeGroups = const [
    '第一航廈',
    '第二航廈',
    '遠端機坪',
    '貨運站/機坪其他',
    '諾富特飯店',
    '飛機機艙內',
  ];

  // ===== 各大類「細項」清單 =====
  final List<String> t1Places = const [
    '出境查驗台','入境查驗台','貴賓室',
    '出境大廳(管制區外)','出境層(管制區內)',
    '入境大廳(管制區外)','入境層(管制區內)',
    '美食街','航警局','機場捷運','1號停車場','2號停車場',
    '出境巴士下車處','入境巴士上車處','出境安檢','行李轉盤','海關處',
    '登機門A1','登機門A2','登機門A3','登機門A4','登機門A5','登機門A6','登機門A7','登機門A8','登機門A9',
    'A區轉機櫃檯','B區轉機櫃檯','A區轉機安檢','B區轉機安檢',
    '航廈電車(管制區內)','航廈電車(管制區外)','其他位置',
    '登機門B1','登機門B2','登機門B3','登機門B4','登機門B5','登機門B6','登機門B7','登機門B8','登機門B9','登機門B1R',
  ];

  final List<String> t2Places = const [
    '出境查驗台','入境查驗台','貴賓室',
    '出境大廳(管制區外)','出境層(管制區內)',
    '入境大廳(管制區外)','入境層(管制區內)',
    '美食廣場','航警局','機場捷運','3號停車場','4號停車場',
    '北側觀景台','南側觀景台','北揚5樓','南側5樓',
    '登機門D1','登機門D2','登機門D3','登機門D4','登機門D5','登機門D6','登機門D7','登機門D8','登機門D9','登機門D10',
    '登機門C1','登機門C2','登機門C3','登機門C4','登機門C5','登機門C6','登機門C7','登機門C8','登機門C9',
    'C區轉機櫃檯','C區轉機安檢','航廈電車(管制區內)','航廈電車(管制區外)','其他位置','登機門C5R',
  ];

  final List<String> remotePlaces = const [
    '601','602','603','604','605','606','607','608','609','610','611','612','613','614','615',
  ];

  final List<String> cargoPlaces = const [
    '滑行道',
    '506','507','508','509','510','511','512','513','514','515',
    '台飛棚廠','維修停機坪','長榮航太','機坪其他位置',
  ];

  final List<String> novotelPlaces = const ['諾富特飯店'];
  final List<String> cabinPlaces   = const ['飛機機艙內'];

  @override
  void dispose() {
    placeNoteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 由 Nav4 外殼包起，這裡不要 Scaffold
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
          child: _bigCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1) 事發日期與時間（水平置中對齊）
                _dateTimeRow(
                  label: '事發日期與時間',
                  value: incidentDateTime,
                  onPick: (dt) => setState(() => incidentDateTime = dt),
                  onNow: () => setState(() => incidentDateTime = DateTime.now()),
                ),
                const SizedBox(height: 16),

                // 2) 發生地點（大類 + 子項）
                _bold('發生地點'),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE7CC), // 淡橘底
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _radioWrap(
                        options: placeGroups,
                        groupIndex: placeGroupIdx,
                        onChanged: (i) => setState(() {
                          placeGroupIdx = i;
                          // 切換大類時，清除其它大類的選取
                          t1Selected = t2Selected = remoteSelected =
                              cargoSelected = novotelSelected = cabinSelected = null;
                        }),
                      ),
                      const SizedBox(height: 8),
                      _placeSubOptions(), // ← 根據大類顯示細項
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3) 地點備註（更靠近）
                _inputRowTight(
                  label: '地點備註',
                  hint: '請填寫地點備註',
                  ctrl: placeNoteCtrl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== UI 小積木 =====
  Widget _bigCard({required Widget child}) => Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: child,
      );

  Widget _bold(String s) => Text(
        s,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
      );

  // —— 新版：事發日期與時間（同一水平線）——
  Widget _dateTimeRow({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onPick,
    required VoidCallback onNow,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15.5, color: Colors.black87, fontWeight: FontWeight.w700),
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
            if (newDate != null) {
              final newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
              );
              if (newTime != null) {
                onPick(DateTime(
                  newDate.year, newDate.month, newDate.day,
                  newTime.hour, newTime.minute,
                ));
              }
            }
          },
          child: Text(
            value == null ? '請選擇時間' : _fmtDateTime(value),
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: onNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              elevation: 0,
            ),
            child: const Text('更新時間', style: TextStyle(fontSize: 12.5)),
          ),
        ),
      ],
    );
  }

  // 地點備註：標籤與輸入框更靠近（水平置中對齊）
  Widget _inputRowTight({
    required String label,
    required String hint,
    required TextEditingController ctrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15.5, color: Colors.black87, fontWeight: FontWeight.w700),
          ),
        ),
         Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520), // 想多寬自己改
          child: SizedBox(
            width: double.infinity, // 讓它吃滿「自己的上限」(maxWidth)，而不是整排
            child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ).copyWith(hintText: hint),
            ),
          ),
        ),
      ),
    ],
  );
}

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
              Text(options[i], style: const TextStyle(fontSize: 15.5)),
            ],
          ),
        );
      }),
    );
  }

  // 根據所選「大類」顯示對應細項（單選）
  Widget _placeSubOptions() {
    if (placeGroupIdx == null) return const SizedBox.shrink();

    List<String> opts;
    int? groupIndex;
    ValueChanged<int> onChanged;

    switch (placeGroupIdx!) {
      case 0:
        opts = t1Places;
        groupIndex = t1Selected;
        onChanged = (i) => setState(() => t1Selected = i);
        break;
      case 1:
        opts = t2Places;
        groupIndex = t2Selected;
        onChanged = (i) => setState(() => t2Selected = i);
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = remoteSelected;
        onChanged = (i) => setState(() => remoteSelected = i);
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = cargoSelected;
        onChanged = (i) => setState(() => cargoSelected = i);
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = novotelSelected;
        onChanged = (i) => setState(() => novotelSelected = i);
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = cabinSelected;
        onChanged = (i) => setState(() => cabinSelected = i);
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
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: selected ? const Color(0xFF274C4A) : Colors.black45,
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

  // ===== 時間格式 =====
  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 '
      '${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';
}
