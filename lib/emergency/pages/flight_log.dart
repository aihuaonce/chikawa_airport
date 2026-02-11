import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';

class EmergencyFlightLog extends StatefulWidget {
  final int emergencyId;

  const EmergencyFlightLog({super.key, required this.emergencyId});

  @override
  State<EmergencyFlightLog> createState() => _EmergencyFlightLogState();
}

class _EmergencyFlightLogState extends State<EmergencyFlightLog> {
  // 顏色與樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgReadOnly = Color(0xFFF8FAFC);

  PatientData? _patient;
  FlightRecordData? _flightRecord;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final db = context.read<AppDatabase>();
      final patient = await db.medicalDao.getPatientByMedicalId(
        widget.emergencyId,
      );
      final flight = await db.flightDao.getFlightByMedicalId(
        widget.emergencyId,
      );

      if (mounted) {
        setState(() {
          _patient = patient;
          _flightRecord = flight;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading flight log data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final refService = context.read<ReferenceService>();

    // Resolve values
    final sourceName =
        refService.getTravelStatusById(_flightRecord?.travelStatusId)?.name ??
        '';

    String visitReasonName = '';
    if (_patient?.visitReasonId != null) {
      try {
        visitReasonName = refService.visitReasonList
            .firstWhere((e) => e.id == _patient!.visitReasonId)
            .name;
      } catch (_) {}
    }

    final airlineName =
        refService.getAirlineById(_flightRecord?.airlineId)?.name ?? '';
    final nationalityName =
        refService.getNationalityById(_patient?.nationalityId)?.name ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一排：來源 與 為何至機場
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 來源
            Expanded(
              child: _buildFieldWrapper(
                '旅行狀態 TRAVEL STATUS',
                _buildReadOnlyField(
                  value: sourceName,
                  suffixIcon: Icons.expand_more,
                ),
              ),
            ),

            const SizedBox(width: 32),

            // 為何至機場
            Expanded(
              child: _buildFieldWrapper(
                '為何至機場 REASON FOR VISIT',
                _buildReadOnlyField(
                  value: visitReasonName,
                  suffixIcon: Icons.expand_more,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：航空公司 與 國籍
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 航空公司
            Expanded(
              child: _buildFieldWrapper(
                '航空公司 AIRLINE',
                _buildReadOnlyField(
                  value: airlineName,
                  suffixIcon: Icons.corporate_fare,
                ),
              ),
            ),

            const SizedBox(width: 32),

            // 國籍
            Expanded(
              child: _buildFieldWrapper(
                '國籍 NATIONALITY',
                _buildReadOnlyField(
                  value: nationalityName,
                  suffixIcon: Icons.public,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- UI 共用元件方法 ---

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildReadOnlyField({required String value, IconData? suffixIcon}) {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgReadOnly,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: textMuted.withValues(alpha: 0.5), size: 18),
        ],
      ),
    );
  }
}
