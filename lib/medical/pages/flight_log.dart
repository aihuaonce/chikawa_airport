import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical_view.dart';
import '../../data/db/database.dart';

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
                    selectedId: flight.departureLocationId,
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
                    selectedId: flight.arrivalLocationId,
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

  // 航空公司下拉選單
  Widget _buildAirlineDropdown(
    MedicalViewModel viewModel,
    FlightRecordData flight,
  ) {
    final selectedAirline = viewModel.getAirlineById(flight.airlineId);

    return DropdownButtonFormField<AirlineData>(
      value: selectedAirline,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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
      hint: Row(
        children: [
          const Icon(Icons.corporate_fare, size: 18, color: textMuted),
          const SizedBox(width: 8),
          Text(
            '請選取航空公司',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: viewModel.airlineOptions.map((airline) {
        return DropdownMenuItem<AirlineData>(
          value: airline,
          child: Text(
            '${airline.code} - ${airline.name}',
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (AirlineData? newValue) {
        if (newValue != null) {
          viewModel.updateAirlineId(newValue.airlineId);
        }
      },
    );
  }

  // 旅行狀態下拉選單
  Widget _buildTravelStatusDropdown(
    MedicalViewModel viewModel,
    FlightRecordData flight,
  ) {
    final selectedStatus = viewModel.getTravelStatusById(flight.travelStatusId);

    return DropdownButtonFormField<TravelStatusData>(
      value: selectedStatus,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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
      hint: Text(
        '請選取旅行狀態',
        style: TextStyle(
          color: textMuted.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: viewModel.travelStatusOptions.map((status) {
        return DropdownMenuItem<TravelStatusData>(
          value: status,
          child: Text(
            '${status.code} - ${status.name}',
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (TravelStatusData? newValue) {
        if (newValue != null) {
          viewModel.updateTravelStatusId(newValue.travelStatusId);
        }
      },
    );
  }

  // 地點下拉選單
  Widget _buildLocationDropdown({
    required MedicalViewModel viewModel,
    required int selectedId,
    required String hint,
    required IconData prefixIcon,
    required Function(int) onChanged,
  }) {
    final selectedLocation = viewModel.getLocationById(selectedId);

    return DropdownButtonFormField<LocationData>(
      value: selectedLocation,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(prefixIcon, color: primaryColor, size: 20),
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
      hint: Text(
        hint,
        style: TextStyle(
          color: textMuted.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: viewModel.locationOptions.map((location) {
        return DropdownMenuItem<LocationData>(
          value: location,
          child: Text(
            '${location.code} - ${location.name}',
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (LocationData? newValue) {
        if (newValue != null) {
          onChanged(newValue.locationId);
        }
      },
    );
  }

  // 經過地清單
  Widget _buildLayoverPoints(MedicalViewModel viewModel) {
    return Column(
      children: [
        ...viewModel.transitLocations.asMap().entries.map(
          (entry) {
            final location = entry.value;
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
                      // 需要透過 transit location 的實際 ID
                      // 這裡暫時用 location.locationId，
                      // 實際應該要從 FlightTransitLocations 取得 id
                      await viewModel.removeTransitLocation(
                        location.locationId,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
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

  // 顯示新增經過地對話框
  void _showAddTransitDialog(MedicalViewModel viewModel) {
    LocationData? selectedLocation;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('新增經過地'),
              content: DropdownButtonFormField<LocationData>(
                decoration: const InputDecoration(
                  labelText: '選擇機場',
                  border: OutlineInputBorder(),
                ),
                items: viewModel.locationOptions.map((location) {
                  return DropdownMenuItem<LocationData>(
                    value: location,
                    child: Text('${location.code} - ${location.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedLocation != null) {
                      await viewModel.addTransitLocation(
                        selectedLocation!.locationId,
                      );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('確定'),
                ),
              ],
            );
          },
        );
      },
    );
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