import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

// 引入 nav5.dart 以獲取 AmbulanceDataProvider
import 'nav5.dart';

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
  static const double _labelWidth = 160;

  // ===== 文字輸入控制器 =====
  final TextEditingController plateCtrl = TextEditingController();
  final TextEditingController placeNoteCtrl = TextEditingController();
  final TextEditingController otherDestCtrl = TextEditingController();

  // ===== 選項列表 (靜態常量) =====
  static const List<String> placeGroups = [
    '第一航廈',
    '第二航廈',
    '遠端機坪',
    '貨運站/機坪其他',
    '諾富特飯店',
    '飛機機艙內',
  ];
  static const List<String> t1Places = [
    '出境查驗台',
    '入境查驗台',
    '貴賓室',
    '出境大廳(管制區外)',
    '出境層(管制區內)',
    '入境大廳(管制區外)',
    '入境層(管制區內)',
    '美食街',
    '航警局',
    '機場捷運',
    '1號停車場',
    '2號停車場',
    '出境巴士下車處',
    '入境巴士上車處',
    '出境安檢',
    '行李轉盤',
    '海關處',
    '登機門A1',
    '登機門A2',
    '登機門A3',
    '登機門A4',
    '登機門A5',
    '登機門A6',
    '登機門A7',
    '登機門A8',
    '登機門A9',
    'A區轉機櫃檯',
    'B區轉機櫃檯',
    'A區轉機安檢',
    'B區轉機安檢',
    '航廈電車(管制區內)',
    '航廈電車(管制區外)',
    '其他位置',
    '登機門B1',
    '登機門B2',
    '登機門B3',
    '登機門B4',
    '登機門B5',
    '登機門B6',
    '登機門B7',
    '登機門B8',
    '登機門B9',
    '登機門B1R',
  ];
  static const List<String> t2Places = [
    '出境查驗台',
    '入境查驗台',
    '貴賓室',
    '出境大廳(管制區外)',
    '出境層(管制區內)',
    '入境大廳(管制區外)',
    '入境層(管制區內)',
    '美食廣場',
    '航警局',
    '機場捷運',
    '3號停車場',
    '4號停車場',
    '北側觀景台',
    '南側觀景台',
    '北揚5樓',
    '南側5樓',
    '登機門D1',
    '登機門D2',
    '登機門D3',
    '登機門D4',
    '登機門D5',
    '登機門D6',
    '登機門D7',
    '登機門D8',
    '登機門D9',
    '登機門D10',
    '登機門C1',
    '登機門C2',
    '登機門C3',
    '登機門C4',
    '登機門C5',
    '登機門C6',
    '登機門C7',
    '登機門C8',
    '登機門C9',
    'C區轉機櫃檯',
    'C區轉機安檢',
    '航廈電車(管制區內)',
    '航廈電車(管制區外)',
    '其他位置',
    '登機門C5R',
  ];
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
  static const List<String> cargoPlaces = [
    '滑行道',
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
    '台飛棚廠',
    '維修停機坪',
    '長榮航太',
    '機坪其他位置',
  ];
  static const List<String> novotelPlaces = ['諾富特飯店'];
  static const List<String> cabinPlaces = ['飛機機艙內'];
  static const List<String> hospitals = [
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

  @override
  void initState() {
    super.initState();
    // 在 initState 中，從 Provider 讀取一次資料，來設定 Controller 的初始值
    final dataProvider = context.read<AmbulanceDataProvider>();
    final recordData = dataProvider.ambulanceRecordData;

    plateCtrl.text = recordData.plateNumber.value ?? '';
    placeNoteCtrl.text = recordData.placeNote.value ?? '';
    otherDestCtrl.text = recordData.otherDestinationHospital.value ?? '';
  }

  @override
  void dispose() {
    // 釋放所有 Controller 以避免記憶體洩漏
    plateCtrl.dispose();
    placeNoteCtrl.dispose();
    otherDestCtrl.dispose();
    super.dispose();
  }

  // ===== 工具函式 =====
  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmtDateTime(DateTime dt) =>
      '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 '
      '${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';

  Future<void> _pickDateTime({
    required BuildContext context,
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
    if (!context.mounted) return; // 檢查 context 是否仍然有效
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
    // 使用 Consumer 來監聽 DataProvider 的變化並建構 UI
    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        final recordData = dataProvider.ambulanceRecordData;

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
                          onChanged: (newValue) {
                            dataProvider.updateAmbulanceRecord(
                              recordData.copyWith(plateNumber: Value(newValue)),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

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
                            groupIndex: recordData.placeGroupIdx.value,
                            onChanged: (i) {
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(
                                  placeGroupIdx: Value(i),
                                  t1PlaceIdx: const Value(null),
                                  t2PlaceIdx: const Value(null),
                                  remotePlaceIdx: const Value(null),
                                  cargoPlaceIdx: const Value(null),
                                  novotelPlaceIdx: const Value(null),
                                  cabinPlaceIdx: const Value(null),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _placeSubOptions(dataProvider),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

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
                          onChanged: (newValue) {
                            dataProvider.updateAmbulanceRecord(
                              recordData.copyWith(placeNote: Value(newValue)),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _dateTimeRow(
                      label: '出勤日期與時間',
                      value: recordData.dutyTime.value,
                      onChanged: (dt) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(dutyTime: Value(dt)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    _dateTimeRow(
                      label: '出到達現場時間',
                      value: recordData.arriveSceneTime.value,
                      onChanged: (dt) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(arriveSceneTime: Value(dt)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _rowTop(
                      label: '送往醫院或地點',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(hospitals.length, (i) {
                          // 'i' 在這裡被定義
                          final selected =
                              recordData.destinationHospitalIdx.value == i;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: InkWell(
                              onTap: () {
                                // 【修正】在 onTap 的作用域內，正確地從列表中獲取醫院名稱
                                final String selectedHospitalName =
                                    hospitals[i];

                                // 判斷要顯示的名稱：如果選的是"其他"，顯示文字框的內容；否則，顯示列表中的名稱
                                final String nameForDisplay =
                                    (selectedHospitalName == '其他')
                                    ? otherDestCtrl.text
                                    : selectedHospitalName;

                                dataProvider.updateAmbulanceRecord(
                                  recordData.copyWith(
                                    destinationHospitalIdx: Value(i),
                                    // 更新用於 Home3 列表顯示的通用欄位
                                    destinationHospital: Value(nameForDisplay),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    size: 20,
                                    color: selected
                                        ? const Color(0xFF274C4A)
                                        : Colors.black45,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    hospitals[i],
                                    style: const TextStyle(fontSize: 15.5),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    if (recordData.destinationHospitalIdx.value ==
                        hospitals.length - 1) ...[
                      const SizedBox(height: 10),
                      _rowTop(
                        label: '其他醫院名稱',
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: TextField(
                            controller: otherDestCtrl,
                            decoration: const InputDecoration(
                              hintText: '請填寫送往其他的醫院或地點',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (newValue) {
                              // 【修正】當在 "其他" 輸入框中打字時，需要同時更新兩個欄位
                              dataProvider.updateAmbulanceRecord(
                                recordData.copyWith(
                                  // 1. 更新專門存放 "其他" 名稱的欄位
                                  otherDestinationHospital: Value(newValue),
                                  // 2. 同時更新用於 Home3 列表顯示的通用欄位
                                  destinationHospital: Value(newValue),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    _dateTimeRow(
                      label: '離開現場時間',
                      value: recordData.leaveSceneTime.value,
                      onChanged: (dt) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(leaveSceneTime: Value(dt)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '到達醫院時間',
                      value: recordData.arriveHospitalTime.value,
                      onChanged: (dt) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(arriveHospitalTime: Value(dt)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '離開醫院時間',
                      value: recordData.leaveHospitalTime.value,
                      onChanged: (dt) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(leaveHospitalTime: Value(dt)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '返回待命時間',
                      value: recordData.backStandbyTime.value,
                      onChanged: (dt) => dataProvider.updateAmbulanceRecord(
                        recordData.copyWith(backStandbyTime: Value(dt)),
                      ),
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
    ),
  );

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
        Expanded(
          child: Align(alignment: Alignment.topLeft, child: child),
        ),
      ],
    );
  }

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
            onTap: () => _pickDateTime(
              context: context,
              current: value,
              onChanged: onChanged,
            ),
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

  Widget _placeSubOptions(AmbulanceDataProvider dataProvider) {
    final recordData = dataProvider.ambulanceRecordData;
    final placeGroupIdx = recordData.placeGroupIdx.value;
    if (placeGroupIdx == null) return const SizedBox.shrink();

    final List<String> opts;
    final int? groupIndex;
    final ValueChanged<int> onChanged;

    switch (placeGroupIdx) {
      case 0:
        opts = t1Places;
        groupIndex = recordData.t1PlaceIdx.value;
        onChanged = (i) => dataProvider.updateAmbulanceRecord(
          recordData.copyWith(t1PlaceIdx: Value(i)),
        );
        break;
      case 1:
        opts = t2Places;
        groupIndex = recordData.t2PlaceIdx.value;
        onChanged = (i) => dataProvider.updateAmbulanceRecord(
          recordData.copyWith(t2PlaceIdx: Value(i)),
        );
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = recordData.remotePlaceIdx.value;
        onChanged = (i) => dataProvider.updateAmbulanceRecord(
          recordData.copyWith(remotePlaceIdx: Value(i)),
        );
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = recordData.cargoPlaceIdx.value;
        onChanged = (i) => dataProvider.updateAmbulanceRecord(
          recordData.copyWith(cargoPlaceIdx: Value(i)),
        );
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = recordData.novotelPlaceIdx.value;
        onChanged = (i) => dataProvider.updateAmbulanceRecord(
          recordData.copyWith(novotelPlaceIdx: Value(i)),
        );
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = recordData.cabinPlaceIdx.value;
        onChanged = (i) => dataProvider.updateAmbulanceRecord(
          recordData.copyWith(cabinPlaceIdx: Value(i)),
        );
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
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
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
