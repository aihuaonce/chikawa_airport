import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical/medical_view.dart';
import '../../data/db/database.dart';
import '../widgets/reference_search_sheet.dart';

class FlightLog extends StatefulWidget {
  final int medicalId;

  const FlightLog({super.key, required this.medicalId});

  @override
  State<FlightLog> createState() => _FlightLogState();
}

class _FlightLogState extends State<FlightLog> {
  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // 控制器
  late TextEditingController _flightNumberController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _flightNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    super.dispose();
  }

  // 當 ViewModel 資料載入後，同步到 Controller
  void _updateControllers(FlightRecordData flight) {
    if (_isInitialized) return;
    _flightNumberController.text = flight.flightNumber;
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicalViewModel>();
    final flight = viewModel.flightRecord;

    if (flight != null) {
      _updateControllers(flight);
    }

    if (flight == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('載入飛航記錄中...'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('航空公司 AIRLINE'),
                  const SizedBox(height: 8),
                  _buildAirlineDropdown(viewModel, flight),
                  const SizedBox(height: 24),
                  _buildLabel('班機代碼 FLIGHT CODE'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _flightNumberController,
                    hint: '請輸入班機代碼',
                    onChanged: (val) => viewModel.updateFlightNumber(val),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('旅行狀態 TRAVEL STATUS'),
                  const SizedBox(height: 8),
                  _buildTravelStatusDropdown(viewModel, flight),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('啟程地 ORIGIN'),
                  const SizedBox(height: 8),
                  _buildLocationDropdown(
                    viewModel: viewModel,
                    selectedId: flight.departureLocationId ?? 0,
                    hint: '請輸入或搜尋啟程機場',
                    prefixIcon: Icons.location_on,
                    onChanged: (id) => viewModel.updateDepartureLocationId(id),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('經過地 LAYOVER / TRANSIT POINTS'),
                  const SizedBox(height: 8),
                  _buildLayoverPoints(viewModel),
                  const SizedBox(height: 24),
                  _buildLabel('目的地 DESTINATION'),
                  const SizedBox(height: 8),
                  _buildLocationDropdown(
                    viewModel: viewModel,
                    selectedId: flight.arrivalLocationId ?? 0,
                    hint: '請輸入或搜尋目的地機場',
                    prefixIcon: Icons.sports_score,
                    onChanged: (id) => viewModel.updateArrivalLocationId(id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 航空公司選單 (改用 SearchSheet)
  Widget _buildAirlineDropdown(
    MedicalViewModel viewModel,
    FlightRecordData flight,
  ) {
    final selectedAirline = viewModel.getAirlineById(flight.airlineId);
    final text = selectedAirline != null
        ? '${selectedAirline.code} - ${selectedAirline.name}'
        : '';

    return _buildSelectionField(
      text: text,
      hint: '請選取航空公司',
      icon: Icons.corporate_fare,
      onTap: () async {
        // 使用迴圈處理導航邏輯
        bool showMainList = true;

        while (true) {
          if (!mounted) break;

          if (showMainList) {
            // ==================== 第一層：常用航空公司 ====================
            final result = await ReferenceSearchSheet.show<AirlineData>(
              context,
              title: '選擇航空公司',
              searchFunction: (query) async {
                if (query.isEmpty) {
                  // 取得常用航空公司
                  final common = await viewModel.searchAirlines('');
                  // 加入 "其他航空公司" 選項
                  return [
                    ...common,
                    const AirlineData(
                      airlineId: -999,
                      code: 'OTHER',
                      name: '其他航空公司 (Other Airlines)',
                      isOther: true,
                    ),
                  ];
                } else {
                  // 有關鍵字時，搜尋全部
                  return viewModel.searchAirlines(query);
                }
              },
              initialSelection: selectedAirline,
              isSelectedComparator: (a, b) => a.airlineId == b?.airlineId,
              itemBuilder: (context, item, isSelected) {
                // 特殊樣式：其他航空公司
                if (item.airlineId == -999) {
                  return ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        // 改回一般樣式，不使用粗體或斜體
                        color: textDark,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: textMuted,
                    ),
                  );
                }

                return ListTile(
                  title: Text(
                    '${item.code} - ${item.name}',
                    style: TextStyle(
                      color: isSelected ? primaryColor : textDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: primaryColor)
                      : null,
                );
              },
            );

            // 使用者關閉視窗
            if (result == null) break;

            if (result.airlineId == -999) {
              // 切換到其他航空公司列表
              showMainList = false;
            } else {
              // 選擇了正常航空公司
              viewModel.updateAirlineId(result.airlineId);
              break;
            }
          } else {
            // ==================== 第二層：其他航空公司 ====================
            final result = await ReferenceSearchSheet.show<AirlineData>(
              context,
              title: '其他航空公司',
              searchFunction: (query) async {
                final List<AirlineData> results;
                if (query.isEmpty) {
                  results = await viewModel.getOtherAirlines();
                } else {
                  results = await viewModel.searchAirlines(query);
                }

                // 加入 "返回" 選項
                return [
                  const AirlineData(
                    airlineId: -998,
                    code: 'BACK',
                    name: '返回 (Return)',
                    isOther: true,
                  ),
                  ...results,
                ];
              },
              itemBuilder: (context, item, isSelected) {
                // 返回按鈕樣式
                if (item.airlineId == -998) {
                  return ListTile(
                    leading: const Icon(Icons.arrow_back, color: primaryColor),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListTile(
                  title: Text(
                    '${item.code} - ${item.name}',
                    style: TextStyle(
                      color: isSelected ? primaryColor : textDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: primaryColor)
                      : null,
                );
              },
            );

            // 使用者關閉視窗
            if (result == null) break;

            if (result.airlineId == -998) {
              // 返回上一頁
              showMainList = true;
            } else {
              // 選擇了正常航空公司
              viewModel.updateAirlineId(result.airlineId);
              break;
            }
          }
        }
      },
    );
  }

  // 旅行狀態選單 (改用 SearchSheet)
  Widget _buildTravelStatusDropdown(
    MedicalViewModel viewModel,
    FlightRecordData flight,
  ) {
    final selectedStatus = viewModel.getTravelStatusById(flight.travelStatusId);
    final text = selectedStatus != null
        ? '${selectedStatus.code} - ${selectedStatus.name}'
        : '';

    return _buildSelectionField(
      text: text,
      hint: '請選取旅行狀態',
      icon: Icons.flight_takeoff,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<TravelStatusData>(
          context,
          title: '選擇旅行狀態',
          searchFunction: viewModel.searchTravelStatus,
          initialSelection: selectedStatus,
          isSelectedComparator: (a, b) => a.travelStatusId == b?.travelStatusId,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                '${item.code} - ${item.name}',
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          viewModel.updateTravelStatusId(result.travelStatusId);
        }
      },
    );
  }

  // 地點選單 (改用 SearchSheet)
  Widget _buildLocationDropdown({
    required MedicalViewModel viewModel,
    required int selectedId,
    required String hint,
    required IconData prefixIcon,
    required Function(int) onChanged,
  }) {
    final selectedLocation = viewModel.getLocationById(selectedId);
    final text = selectedLocation != null
        ? '${selectedLocation.code} - ${selectedLocation.name}'
        : '';

    return _buildSelectionField(
      text: text,
      hint: hint,
      icon: prefixIcon,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<LocationData>(
          context,
          title: '選擇機場',
          searchFunction: viewModel.searchLocations,
          initialSelection: selectedLocation,
          isSelectedComparator: (a, b) => a.locationId == b?.locationId,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                '${item.code} - ${item.name}',
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          onChanged(result.locationId);
        }
      },
    );
  }

  // 通用選擇欄位元件
  Widget _buildSelectionField({
    required String text,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text.isNotEmpty ? text : hint,
                style: TextStyle(
                  color: text.isNotEmpty
                      ? textDark
                      : textMuted.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: textMuted),
          ],
        ),
      ),
    );
  }

  // 經過地清單
  Widget _buildLayoverPoints(MedicalViewModel viewModel) {
    return Column(
      children: [
        ...viewModel.transitLocations.asMap().entries.map((entry) {
          // 【關鍵修正】：entry.value 現在是 TransitLocationWithData 型別
          final transitData = entry.value;
          // 從包裝盒中取出實際的地點詳細資料 (LocationData)
          final location = transitData.location;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      '${location.code} - ${location.name}',
                      style: const TextStyle(fontSize: 14, color: textDark),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () async {
                    // 刪除時使用包裝盒裡的 transitId
                    await viewModel.removeTransitLocation(
                      transitData.transitId,
                    );
                  },
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () => _showAddTransitDialog(viewModel),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Point'),
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 44),
            side: const BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // 顯示新增經過地 (直接開啟搜尋面板)
  Future<void> _showAddTransitDialog(MedicalViewModel viewModel) async {
    final result = await ReferenceSearchSheet.show<LocationData>(
      context,
      title: '選擇機場',
      searchFunction: viewModel.searchLocations,
      itemBuilder: (context, item, isSelected) {
        return ListTile(
          title: Text(
            '${item.code} - ${item.name}',
            style: TextStyle(
              color: isSelected ? primaryColor : textDark,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: primaryColor)
              : null,
        );
      },
    );

    if (result != null) {
      await viewModel.addTransitLocation(result.locationId);
    }
  }

  // 標籤元件
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // 輸入框元件
  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    IconData? prefixIcon,
    bool readOnly = false,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.5),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: primaryColor, size: 20)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
