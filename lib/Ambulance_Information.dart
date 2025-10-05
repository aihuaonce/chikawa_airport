import 'package:flutter/material.dart';

class AmbulanceInformationPage extends StatefulWidget {
  const AmbulanceInformationPage({super.key});

  @override
  State<AmbulanceInformationPage> createState() => _AmbulanceInformationPageState();
}

class _AmbulanceInformationPageState extends State<AmbulanceInformationPage> {
  // ===== 版面外觀 =====
  static const double _cardRadius = 16;
  static const double _labelWidth = 160;

  // ===== 文字輸入 =====
  final TextEditingController plateCtrl = TextEditingController();      // 車牌號碼
  final TextEditingController placeNoteCtrl = TextEditingController();  // 地點備註
  final TextEditingController otherDestCtrl = TextEditingController();  // 送往「其他」

  // ===== 日期時間 =====
  DateTime? dutyTime = DateTime.now();         // 出勤日期與時間
  DateTime? arriveSceneTime = DateTime.now();  // 出到達現場時間
  DateTime? leaveSceneTime = DateTime.now();   // 離開現場時間
  DateTime? arriveHospitalTime = DateTime.now(); // 到達醫院時間
  DateTime? leaveHospitalTime = DateTime.now();  // 離開醫院時間
  DateTime? backStandbyTime = DateTime.now();    // 返回待命時間

  // ===== 發生地點（大類）=====
  final List<String> placeGroups = const [
    '第一航廈', '第二航廈', '遠端機坪', '貨運站/機坪其他', '諾富特飯店', '飛機機艙內',
  ];
  int? placeGroupIdx;

  // 各大類細項（單選）
  int? t1Selected, t2Selected, remoteSelected, cargoSelected, novotelSelected, cabinSelected;

  // 第一航廈細項
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

  // 第二航廈細項
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

  // 遠端機坪
  final List<String> remotePlaces = const [
    '601','602','603','604','605','606','607','608','609','610','611','612','613','614','615',
  ];

  // 貨運站/機坪其他
  final List<String> cargoPlaces = const [
    '滑行道',
    '506','507','508','509','510','511','512','513','514','515',
    '台飛棚廠','維修停機坪','長榮航太','機坪其他位置',
  ];

  // 諾富特、機艙
  final List<String> novotelPlaces = const ['諾富特飯店'];
  final List<String> cabinPlaces   = const ['飛機機艙內'];

  // ===== 送往醫院或地點 =====
  final List<String> hospitals = const [
    '聯新國際醫院',
    '林口長庚醫院',
    '衛生福利部桃園醫院',
    '衛生福利部桃園療養院',
    '桃園經國敏盛醫院',
    '聖保祿醫院',
    '中壢天晟醫院',
    '桃園榮民總醫院',
    '三峽恩主公醫院',
    '其他',
  ];
  int? hospitalIdx; // 選中的醫院 index（最後一個為「其他」）

  @override
  void dispose() {
    plateCtrl.dispose();
    placeNoteCtrl.dispose();
    otherDestCtrl.dispose();
    super.dispose();
  }

  // ===== 工具：時間格式 / 選擇器 =====
  String _two(int n) => n.toString().padLeft(2, '0');

  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 '
      '${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';

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
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (time == null) return;
    onChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    // ⚠️ 不要 Scaffold；由外殼 Nav 管理。這裡只回傳內容 + 白卡片
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 車牌號碼
                _rowTop(
                  label: '車牌號碼',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: TextField(
                      controller: plateCtrl,
                      decoration: const InputDecoration(
                        hintText: '請填寫車牌號碼',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 發生地點 + 細項
                _bold('發生地點'),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE7CC),
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
                          // 切換大類時清空其他細項
                          t1Selected = t2Selected = remoteSelected =
                            cargoSelected = novotelSelected = cabinSelected = null;
                        }),
                      ),
                      const SizedBox(height: 8),
                      _placeSubOptions(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 地點備註
                _rowTop(
                  label: '地點備註',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: TextField(
                      controller: placeNoteCtrl,
                      decoration: const InputDecoration(
                        hintText: '請填寫地點備註',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 出勤日期與時間
                _dateTimeRow(
                  label: '出勤日期與時間',
                  value: dutyTime,
                  onChanged: (dt) => setState(() => dutyTime = dt),
                ),
                const SizedBox(height: 8),

                // 出到達現場時間
                _dateTimeRow(
                  label: '出到達現場時間',
                  value: arriveSceneTime,
                  onChanged: (dt) => setState(() => arriveSceneTime = dt),
                ),
                const SizedBox(height: 16),

                // 送往醫院或地點？
                _rowTop(
                  label: '送往醫院或地點',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(hospitals.length, (i) {
                      final selected = hospitalIdx == i;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: () => setState(() => hospitalIdx = i),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 20,
                                color: selected ? const Color(0xFF274C4A) : Colors.black45,
                              ),
                              const SizedBox(width: 8),
                              Text(hospitals[i], style: const TextStyle(fontSize: 15.5)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),


                // 若選「其他」 → 顯示輸入框
                if (hospitalIdx == hospitals.length - 1) ...[
                  const SizedBox(height: 10),
                  _rowTop(
                    label: '送往醫院或地點',
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: TextField(
                        controller: otherDestCtrl,
                        decoration: const InputDecoration(
                          hintText: '請填寫送往其他的醫院或地點',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // 其它時間（四個）
                _dateTimeRow(
                  label: '離開現場時間',
                  value: leaveSceneTime,
                  onChanged: (dt) => setState(() => leaveSceneTime = dt),
                ),
                const SizedBox(height: 8),
                _dateTimeRow(
                  label: '到達醫院時間',
                  value: arriveHospitalTime,
                  onChanged: (dt) => setState(() => arriveHospitalTime = dt),
                ),
                const SizedBox(height: 8),
                _dateTimeRow(
                  label: '離開醫院時間',
                  value: leaveHospitalTime,
                  onChanged: (dt) => setState(() => leaveHospitalTime = dt),
                ),
                const SizedBox(height: 8),
                _dateTimeRow(
                  label: '返回待命時間',
                  value: backStandbyTime,
                  onChanged: (dt) => setState(() => backStandbyTime = dt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====== 小積木 ======
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _bold(String s) => Text(
    s,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
  );

  // 標籤頂對齊的列
  Widget _rowTop({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _labelWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(child: Align(alignment: Alignment.topLeft, child: child)),
      ],
    );
  }

  // 日期＋時間一列（點文字選擇；旁邊「更新時間」）
  Widget _dateTimeRow({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return _rowTop(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _pickDateTime(current: value, onChanged: onChanged),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: Text(
                value == null ? '請選擇時間' : _fmtDateTime(value),
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () => onChanged(DateTime.now()),
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
      ),
    );
  }

  // 一排可點選的圓點（單選）
  Widget _radioWrap({
    required List<String> options,
    required int? groupIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Wrap(
      spacing: 14,
      runSpacing: 4,
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

  // 顯示對應「發生地點細項」
  Widget _placeSubOptions() {
    if (placeGroupIdx == null) return const SizedBox.shrink();

    List<String> opts;
    int? groupIndex;
    ValueChanged<int> onChanged;

    switch (placeGroupIdx!) {
      case 0:
        opts = t1Places; groupIndex = t1Selected; onChanged = (i) => setState(() => t1Selected = i); break;
      case 1:
        opts = t2Places; groupIndex = t2Selected; onChanged = (i) => setState(() => t2Selected = i); break;
      case 2:
        opts = remotePlaces; groupIndex = remoteSelected; onChanged = (i) => setState(() => remoteSelected = i); break;
      case 3:
        opts = cargoPlaces; groupIndex = cargoSelected; onChanged = (i) => setState(() => cargoSelected = i); break;
      case 4:
        opts = novotelPlaces; groupIndex = novotelSelected; onChanged = (i) => setState(() => novotelSelected = i); break;
      case 5:
        opts = cabinPlaces; groupIndex = cabinSelected; onChanged = (i) => setState(() => cabinSelected = i); break;
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
}
