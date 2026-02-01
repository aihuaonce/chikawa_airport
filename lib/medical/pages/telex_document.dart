import 'package:chikawa_airport/data/db/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical/telex_view.dart';
import '../../data/models/reference_service.dart';

class TelexDocument extends StatefulWidget {
  final int medicalId;

  const TelexDocument({super.key, required this.medicalId});

  @override
  State<TelexDocument> createState() => _TelexDocumentState();
}

class _TelexDocumentState extends State<TelexDocument> {
  // 顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  @override
  Widget build(BuildContext context) {
    // 監聽 ViewModel 和 ReferenceService
    final viewModel = context.watch<TelexDocumentViewModel>();
    final refService = context.watch<ReferenceService>();

    final toStation = viewModel.selectedToStation;
    final fromStation = viewModel.selectedFromStation;
    final stations = refService.stationList;

    // 分類站點
    final occStations = stations
        .where((s) => s.code.startsWith('T') && s.code.endsWith('_OCC'))
        .toList();
    final medStations = stations
        .where((s) => s.code.startsWith('T') && s.code.endsWith('_MED'))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildStationCard(
                title: 'TO: 桃園國際機場股份有限公司營運控制中心',
                stations: occStations,
                selectedStation: toStation,
                onChanged: (StationRefData? station) =>
                    viewModel.updateToStation(station?.id),
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              child: _buildStationCard(
                title: 'FROM: 聯新國際醫院桃園國際機場醫療中心',
                stations: medStations,
                selectedStation: fromStation,
                onChanged: (station) =>
                    viewModel.updateFromStation(station?.id),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStationCard({
    required String title,
    required List<StationRefData> stations,
    required StationRefData? selectedStation,
    required ValueChanged<StationRefData?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgField.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: stations.map((station) {
              final bool isSelected = selectedStation?.id == station.id;
              return InkWell(
                onTap: () => onChanged(station),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Radio<int>(
                          value: station.id,
                          groupValue: selectedStation?.id,
                          onChanged: (_) => onChanged(station),
                          activeColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        station.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected ? primaryColor : textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
