import 'package:flutter/material.dart';

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
  static const Color bgField = Color(0xFFF9FBFC);

  int _travelStatusIndex = 0; // 0: Arriving, 1: Departing, 2: Transit

  final List<String> _layoverPoints = ['請輸入轉機機場代碼'];

  @override
  Widget build(BuildContext context) {
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
                  _buildAirlineDropdown('請選取航空公司'),

                  const SizedBox(height: 24),
                  _buildLabel('班機代碼 FLIGHT CODE'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: '請輸入班機代碼'),

                  const SizedBox(height: 24),
                  _buildLabel('旅行狀態 TRAVEL STATUS'),
                  const SizedBox(height: 8),
                  SlidingTravelStatusToggle(
                    selectedIndex: _travelStatusIndex,
                    onChanged: (index) {
                      setState(() => _travelStatusIndex = index);
                    },
                  ),
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
                  _buildTextField(
                    hint: '請輸入或搜尋啟程機場',
                    prefixIcon: Icons.location_on,
                  ),

                  const SizedBox(height: 24),
                  _buildLabel('經過地 LAYOVER / TRANSIT POINTS'),
                  const SizedBox(height: 8),
                  _buildLayoverPoints(),

                  const SizedBox(height: 24),
                  _buildLabel('目的地 DESTINATION'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: '請輸入或搜尋目的地機場',
                    prefixIcon: Icons.sports_score,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 下拉選單元件 (航空公司)
  Widget _buildAirlineDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.corporate_fare, size: 18, color: textMuted),
          const SizedBox(width: 8),
          Text(
            hint,
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
        ],
      ),
    );
  }

  // 經過地清單
  Widget _buildLayoverPoints() {
    return Column(
      children: [
        ..._layoverPoints.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(child: _buildTextField(hint: point, readOnly: true)),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _layoverPoints.remove(point));
                  },
                ),
              ],
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _layoverPoints.add('請輸入轉機機場代碼'));
          },
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
    IconData? prefixIcon,
    bool readOnly = false,
  }) {
    return TextFormField(
      readOnly: readOnly,
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

// 滑動切換器
class SlidingTravelStatusToggle extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const SlidingTravelStatusToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> _options = const ['Arriving', 'Departing', 'Transit'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _getAlignment(selectedIndex),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(_options.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      _options[index],
                      style: TextStyle(
                        color: selectedIndex == index
                            ? const Color(0xFF007A8A)
                            : const Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Alignment _getAlignment(int index) {
    if (index == 0) return Alignment.centerLeft;
    if (index == 1) return Alignment.center;
    return Alignment.centerRight;
  }
}
