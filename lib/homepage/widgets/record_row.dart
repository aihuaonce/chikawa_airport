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
  static const Color primaryColor = Color(0xFF007A8A);

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
    DateTime? incidentDate;
    DateTime? notificationTime;
    final incident = await db.incidentDao.getByMedicalId(medicalId);
    if (incident != null) {
      incidentDate = incident.incidentDate;
      notificationTime = incident.notificationTime;

      final category1Name = refService
          .getIncidentPlaceCategoryById(incident.incidentPlaceCategoryId)
          ?.name
          .trim();

      final category2Id = incident.incidentPlaceCategory2Id;
      final category2Name = category2Id == null
          ? null
          : (await db.referenceDao.getIncidentPlaceCategory2ById(
              category2Id,
            ))?.name.trim();

      if (category1Name != null &&
          category1Name.isNotEmpty &&
          category2Name != null &&
          category2Name.isNotEmpty) {
        incidentPlace = '$category1Name / $category2Name';
      } else if (category1Name != null && category1Name.isNotEmpty) {
        incidentPlace = category1Name;
      } else if (category2Name != null && category2Name.isNotEmpty) {
        incidentPlace = category2Name;
      } else {
        final finalPlace = incident.incidentPlaceFinal?.trim();
        if (finalPlace != null && finalPlace.isNotEmpty) {
          incidentPlace = finalPlace;
        }
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

    return _RecordExtraInfo(
      incidentPlace: incidentPlace,
      nurseName: nurseName,
      incidentDate: incidentDate,
      notificationTime: notificationTime,
    );
  }

  int? _calculateAge(DateTime? birthday) {
    if (birthday == null) return null;
    final now = DateTime.now();
    var age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
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

    final sexText = patient.sexId == 1 ? 'M' : (patient.sexId == 2 ? 'F' : '?');
    final age = _calculateAge(patient.birthday);
    final ageText = age == null ? '--' : '${age}y';

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                _cell(
                  Builder(
                    builder: (context) {
                      final incidentDate = extra?.incidentDate;
                      final notificationTime = extra?.notificationTime;
                      final hasIncidentData =
                          incidentDate != null || notificationTime != null;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasIncidentData && incidentDate != null
                                ? DateFormat('yyyy/MM/dd').format(incidentDate)
                                : DateFormat('yyyy/MM/dd')
                                    .format(record.createdAt),
                            style: const TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasIncidentData && notificationTime != null
                                ? DateFormat('HH:mm')
                                    .format(notificationTime)
                                : (hasIncidentData
                                    ? '--:--'
                                    : DateFormat('HH:mm')
                                        .format(record.createdAt)),
                            style: const TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  2,
                ),
                _cell(
                  Row(
                    children: [
                      _buildAvatar(patientName),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$sexText / $ageText',
                              style: const TextStyle(
                                color: textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  2,
                ),
                _cell(
                  Text(
                    nationality,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  2,
                ),
                _cell(
                  Text(
                    incidentPlace,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  3,
                ),
                _cell(
                  Text(
                    nurseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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

  Widget _buildAvatar(String name) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _RecordExtraInfo {
  final String incidentPlace;
  final String nurseName;
  final DateTime? incidentDate;
  final DateTime? notificationTime;

  const _RecordExtraInfo({
    required this.incidentPlace,
    required this.nurseName,
    this.incidentDate,
    this.notificationTime,
  });
}
