import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Variable;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:chikawa_airport/ambulance/ambulance.dart';
import 'package:chikawa_airport/data/db/dao/medical_dao.dart';
import 'package:chikawa_airport/data/db/database.dart';
import 'package:chikawa_airport/data/models/dashboard_view_model.dart';
import 'package:chikawa_airport/data/models/medical/medical_view.dart';
import 'package:chikawa_airport/data/models/record_page.dart';
import 'package:chikawa_airport/data/models/reference_service.dart';
import 'package:chikawa_airport/emergency/emergency.dart';
import 'package:chikawa_airport/medical/medical.dart';

class RecordRow extends StatefulWidget {
  final MedicalRecordWithPatient data;

  const RecordRow({super.key, required this.data});

  @override
  State<RecordRow> createState() => _RecordRowState();
}

class _RecordRowState extends State<RecordRow> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);

  late Future<_RecordExtraInfo> _extraInfoFuture;

  @override
  void initState() {
    super.initState();
    _extraInfoFuture = _loadExtraInfo();
  }

  @override
  void didUpdateWidget(covariant RecordRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.record.medicalId != widget.data.record.medicalId) {
      _extraInfoFuture = _loadExtraInfo();
    }
  }

  Future<_RecordExtraInfo> _loadExtraInfo() async {
    final db = context.read<AppDatabase>();
    final refService = context.read<ReferenceService>();
    final medicalId = widget.data.record.medicalId;

    String incidentPlace = '未填寫';
    final incident = await db.incidentDao.getByMedicalId(medicalId);
    if (incident != null) {
      final finalPlace = incident.incidentPlaceFinal?.trim();
      if (finalPlace != null && finalPlace.isNotEmpty) {
        incidentPlace = finalPlace;
      } else {
        final category = refService.getIncidentPlaceCategoryById(
          incident.incidentPlaceCategoryId,
        );
        incidentPlace = category?.name ?? '未填寫';
      }
    }

    String nurseName = '未指派';
    final nurseRows = await db
        .customSelect(
          'SELECT nurse_id FROM nursing_records '
          'WHERE medical_id = ? '
          'ORDER BY record_time DESC LIMIT 1',
          variables: [Variable.withInt(medicalId)],
        )
        .get();
    if (nurseRows.isNotEmpty) {
      final nurseId = nurseRows.first.readNullable<int>('nurse_id');
      final nurse = refService.getMedicalStaffById(nurseId);
      nurseName = nurse?.name ?? '未指派';
    }

    return _RecordExtraInfo(incidentPlace: incidentPlace, nurseName: nurseName);
  }

  void _openRecordDetail(BuildContext context, int medicalId) {
    final currentFilter = context.read<DashboardViewModel>().currentFilter;

    if (currentFilter == RecordPage.firstAid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyPage(emergencyId: medicalId),
        ),
      );
      return;
    }

    if (currentFilter == RecordPage.ambulance) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmbulancePage(medicalId: medicalId),
        ),
      );
      return;
    }

    final database = context.read<AppDatabase>();
    final refService = context.read<ReferenceService>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) =>
              MedicalViewModel(database, refService, medicalId)..init(),
          child: MedicalPage(medicalId: medicalId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.data.record;
    final patient = widget.data.patient;
    final refService = context.read<ReferenceService>();

    final nationality =
        refService.getNationalityById(patient.nationalityId)?.name ?? '未填寫';
    final patientName = patient.name?.trim().isNotEmpty == true
        ? patient.name!
        : '未填寫';

    return FutureBuilder<_RecordExtraInfo>(
      future: _extraInfoFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final extra = snapshot.data;
        final incidentPlace = isLoading
            ? '載入中...'
            : (extra?.incidentPlace ?? '未填寫');
        final nurseName = isLoading ? '載入中...' : (extra?.nurseName ?? '未指派');

        return InkWell(
          onTap: () => _openRecordDetail(context, record.medicalId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                _cell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('yyyy/MM/dd').format(record.createdAt),
                        style: const TextStyle(
                          color: textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('HH:mm').format(record.createdAt),
                        style: const TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                  2,
                ),
                _cell(
                  Text(
                    patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  2,
                ),
                _cell(
                  Text(
                    nationality,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMuted, fontSize: 13),
                  ),
                  2,
                ),
                _cell(
                  Text(
                    incidentPlace,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMuted, fontSize: 13),
                  ),
                  3,
                ),
                _cell(
                  Text(
                    nurseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMuted, fontSize: 13),
                  ),
                  2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cell(Widget child, int flex) {
    return Expanded(flex: flex, child: child);
  }
}

class _RecordExtraInfo {
  final String incidentPlace;
  final String nurseName;

  const _RecordExtraInfo({
    required this.incidentPlace,
    required this.nurseName,
  });
}
