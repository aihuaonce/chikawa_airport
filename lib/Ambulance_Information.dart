import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import 'nav5.dart'; // 為了獲取 AmbulanceDataProvider

class AmbulanceInformationPage extends StatefulWidget {
  final int visitId;
  const AmbulanceInformationPage({super.key, required this.visitId});

  @override
  State<AmbulanceInformationPage> createState() =>
      _AmbulanceInformationPageState();
}

class _AmbulanceInformationPageState extends State<AmbulanceInformationPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  // ===== 版面外觀 (靜態常量) =====
  static const double _cardRadius = 16;
  static const double _labelWidth = 160;

  // ===== 本地 UI 狀態 =====
  // 文字輸入控制器
  final _plateCtrl = TextEditingController();
  final _placeNoteCtrl = TextEditingController();
  final _otherDestCtrl = TextEditingController();

  // 選項和日期狀態變數
  int? _placeGroupIdx;
  int? _t1PlaceIdx;
  int? _t2PlaceIdx;
  int? _remotePlaceIdx;
  int? _cargoPlaceIdx;
  int? _novotelPlaceIdx;
  int? _cabinPlaceIdx;
  int? _destinationHospitalIdx;
  DateTime? _dutyTime;
  DateTime? _arriveSceneTime;
  DateTime? _leaveSceneTime;
  DateTime? _arriveHospitalTime;
  DateTime? _leaveHospitalTime;
  DateTime? _backStandbyTime;

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 延遲一幀執行，確保 Provider 已經準備好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
        setState(() {}); // 確保初始資料被渲染
      }
    });
  }

  void _loadInitialData() {
    final dataProvider = context.read<AmbulanceDataProvider>();
    final recordData = dataProvider.ambulanceRecordData;

    // 從 Provider 初始化所有本地狀態
    _plateCtrl.text = recordData.plateNumber.value ?? '';
    _placeNoteCtrl.text = recordData.placeNote.value ?? '';
    _otherDestCtrl.text = recordData.otherDestinationHospital.value ?? '';
    _placeGroupIdx = recordData.placeGroupIdx.value;
    _t1PlaceIdx = recordData.t1PlaceIdx.value;
    _t2PlaceIdx = recordData.t2PlaceIdx.value;
    _remotePlaceIdx = recordData.remotePlaceIdx.value;
    _cargoPlaceIdx = recordData.cargoPlaceIdx.value;
    _novotelPlaceIdx = recordData.novotelPlaceIdx.value;
    _cabinPlaceIdx = recordData.cabinPlaceIdx.value;
    _destinationHospitalIdx = recordData.destinationHospitalIdx.value;
    _dutyTime = recordData.dutyTime.value;
    _arriveSceneTime = recordData.arriveSceneTime.value;
    _leaveSceneTime = recordData.leaveSceneTime.value;
    _arriveHospitalTime = recordData.arriveHospitalTime.value;
    _leaveHospitalTime = recordData.leaveHospitalTime.value;
    _backStandbyTime = recordData.backStandbyTime.value;
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    _placeNoteCtrl.dispose();
    _otherDestCtrl.dispose();
    super.dispose();
  }

  @override
  Future<void> saveData() async {
    try {
      final dataProvider = context.read<AmbulanceDataProvider>();
      final recordData = dataProvider.ambulanceRecordData;

      String? destinationHospitalName;
      if (_destinationHospitalIdx != null) {
        if (_destinationHospitalIdx == hospitals.length - 1) {
          // 如果是「其他」
          destinationHospitalName = _otherDestCtrl.text;
        } else {
          destinationHospitalName = hospitals[_destinationHospitalIdx!];
        }
      }

      dataProvider.updateAmbulanceRecord(
        recordData.copyWith(
          plateNumber: Value(_plateCtrl.text),
          placeNote: Value(_placeNoteCtrl.text),
          otherDestinationHospital: Value(_otherDestCtrl.text),
          placeGroupIdx: Value(_placeGroupIdx),
          t1PlaceIdx: Value(_t1PlaceIdx),
          t2PlaceIdx: Value(_t2PlaceIdx),
          remotePlaceIdx: Value(_remotePlaceIdx),
          cargoPlaceIdx: Value(_cargoPlaceIdx),
          novotelPlaceIdx: Value(_novotelPlaceIdx),
          cabinPlaceIdx: Value(_cabinPlaceIdx),
          destinationHospitalIdx: Value(_destinationHospitalIdx),
          destinationHospital: Value(destinationHospitalName),
          dutyTime: Value(_dutyTime),
          arriveSceneTime: Value(_arriveSceneTime),
          leaveSceneTime: Value(_leaveSceneTime),
          arriveHospitalTime: Value(_arriveHospitalTime),
          leaveHospitalTime: Value(_leaveHospitalTime),
          backStandbyTime: Value(_backStandbyTime),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== 工具函式 =====
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
    super.build(context);

    // 我們直接在 Consumer 中使用 provider 資料，不再需要額外的同步邏輯，
    // 因為本地狀態的初始值已經在 initState 設定好，並且 UI 事件只更新本地狀態。
    // Consumer 會確保在 Provider 資料變化時重建 UI，屆時本地狀態也會被 build 邏輯重新賦值。
    return Consumer<AmbulanceDataProvider>(
      builder: (context, dataProvider, child) {
        // 在 build 方法中，我們的 UI 元件直接使用本地狀態變數
        return SingleChildScrollView(
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
                          controller: _plateCtrl,
                          decoration: const InputDecoration(
                            hintText: '請填寫車牌號碼',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _bold('發生地點'),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _radioWrap(
                            options: placeGroups,
                            groupIndex: _placeGroupIdx,
                            onChanged: (i) {
                              setState(() {
                                _placeGroupIdx = i;
                                _t1PlaceIdx = null;
                                _t2PlaceIdx = null;
                                _remotePlaceIdx = null;
                                _cargoPlaceIdx = null;
                                _novotelPlaceIdx = null;
                                _cabinPlaceIdx = null;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          _placeSubOptions(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _rowTop(
                      label: '地點備註',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: TextField(controller: _placeNoteCtrl),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _dateTimeRow(
                      label: '出勤日期與時間',
                      value: _dutyTime,
                      onChanged: (dt) => setState(() => _dutyTime = dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '到達現場時間',
                      value: _arriveSceneTime,
                      onChanged: (dt) => setState(() => _arriveSceneTime = dt),
                    ),
                    const SizedBox(height: 16),

                    _rowTop(
                      label: '送往醫院或地點',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(hospitals.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: _radioOption(
                              label: hospitals[i],
                              isSelected: _destinationHospitalIdx == i,
                              onTap: () =>
                                  setState(() => _destinationHospitalIdx = i),
                            ),
                          );
                        }),
                      ),
                    ),

                    if (_destinationHospitalIdx == hospitals.length - 1) ...[
                      const SizedBox(height: 10),
                      _rowTop(
                        label: '其他醫院名稱',
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: TextField(controller: _otherDestCtrl),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    _dateTimeRow(
                      label: '離開現場時間',
                      value: _leaveSceneTime,
                      onChanged: (dt) => setState(() => _leaveSceneTime = dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '到達醫院時間',
                      value: _arriveHospitalTime,
                      onChanged: (dt) =>
                          setState(() => _arriveHospitalTime = dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '離開醫院時間',
                      value: _leaveHospitalTime,
                      onChanged: (dt) =>
                          setState(() => _leaveHospitalTime = dt),
                    ),
                    const SizedBox(height: 8),
                    _dateTimeRow(
                      label: '返回待命時間',
                      value: _backStandbyTime,
                      onChanged: (dt) => setState(() => _backStandbyTime = dt),
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
    // 針對 TextField 做優化，讓 hintText 等能正常顯示
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
                value == null ? '請選擇時間' : _fmtDateTime(value),
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
              child: const Text('帶入現在時間', style: TextStyle(fontSize: 12.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 20,
            color: isSelected ? const Color(0xFF274C4A) : Colors.black45,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 15.5)),
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
        return _radioOption(
          label: options[i],
          isSelected: groupIndex == i,
          onTap: () => onChanged(i),
        );
      }),
    );
  }

  Widget _placeSubOptions() {
    final List<String> opts;
    final int? groupIndex;
    final ValueChanged<int> onChanged;

    switch (_placeGroupIdx) {
      case 0:
        opts = t1Places;
        groupIndex = _t1PlaceIdx;
        onChanged = (i) => setState(() => _t1PlaceIdx = i);
        break;
      case 1:
        opts = t2Places;
        groupIndex = _t2PlaceIdx;
        onChanged = (i) => setState(() => _t2PlaceIdx = i);
        break;
      case 2:
        opts = remotePlaces;
        groupIndex = _remotePlaceIdx;
        onChanged = (i) => setState(() => _remotePlaceIdx = i);
        break;
      case 3:
        opts = cargoPlaces;
        groupIndex = _cargoPlaceIdx;
        onChanged = (i) => setState(() => _cargoPlaceIdx = i);
        break;
      case 4:
        opts = novotelPlaces;
        groupIndex = _novotelPlaceIdx;
        onChanged = (i) => setState(() => _novotelPlaceIdx = i);
        break;
      case 5:
        opts = cabinPlaces;
        groupIndex = _cabinPlaceIdx;
        onChanged = (i) => setState(() => _cabinPlaceIdx = i);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: _radioWrap(
        options: opts,
        groupIndex: groupIndex,
        onChanged: onChanged,
      ),
    );
  }
}
