import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../data/db/dao/medical_dao.dart';
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';
import '../reports/telex_report.dart';

class ReportCenterPage extends StatefulWidget {
  const ReportCenterPage({super.key});

  @override
  State<ReportCenterPage> createState() => _ReportCenterPageState();
}

class _ReportCenterPageState extends State<ReportCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  final Map<int, PatientReportType> _selectedTypes = {};

  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color pageBg = Color(0xFFF6F8FA);

  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchKeyword = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicalRecordWithPatient> _applySearch(
    List<MedicalRecordWithPatient> records,
  ) {
    if (_searchKeyword.isEmpty) return records;
    final keyword = _searchKeyword.toLowerCase();
    return records.where((row) {
      final record = row.record;
      final patient = row.patient;
      final name = patient.name?.toLowerCase() ?? '';
      final idNo = patient.idNo?.toLowerCase() ?? '';
      final passport = patient.passportOrIdNo?.toLowerCase() ?? '';
      final medicalId = record.medicalId.toString();
      return name.contains(keyword) ||
          idNo.contains(keyword) ||
          passport.contains(keyword) ||
          medicalId.contains(keyword);
    }).toList();
  }

  List<PatientReportType> _availableTypes(MedicalRecordData record) {
    final result = <PatientReportType>[
      PatientReportType.medical,
      PatientReportType.nursing,
      PatientReportType.telex,
    ];
    if (record.isEmergency) {
      result.add(PatientReportType.emergency);
    }
    if (record.hasAmbulance) {
      result.add(PatientReportType.ambulance);
    }
    return result;
  }

  Future<void> _onPrint(
    MedicalRecordWithPatient row,
    PatientReportType type,
  ) async {
    final db = context.read<AppDatabase>();
    final refService = context.read<ReferenceService>();
    final patientName = row.patient.name?.trim().isNotEmpty == true
        ? row.patient.name!
        : '未填寫姓名';
    final createdAt = DateFormat(
      'yyyy/MM/dd HH:mm',
    ).format(row.record.createdAt);

    try {
      if (type == PatientReportType.telex) {
        final reportData = await _buildTelexReportData(
          db: db,
          refService: refService,
          row: row,
        );
        final pdfBytes = await buildTelexPdf(reportData);
        await Printing.layoutPdf(
          name: 'patient_${row.record.medicalId}_${type.code}.pdf',
          onLayout: (_) async => pdfBytes,
        );
        return;
      }
      await Printing.layoutPdf(
        name: 'patient_${row.record.medicalId}_${type.code}.pdf',
        onLayout: (format) async {
          final doc = pw.Document();
          doc.addPage(
            pw.MultiPage(
              pageFormat: format,
              build: (_) => [
                pw.Text(
                  'Patient Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Report Type: ${type.labelEn}'),
                pw.Text('Medical ID: ${row.record.medicalId}'),
                pw.Text('Patient Name: $patientName'),
                pw.Text('Created At: $createdAt'),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Note: Replace this template with full report content.',
                ),
              ],
            ),
          );
          return doc.save();
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('列印失敗：$e')));
    }
  }

  Future<TelexReportData> _buildTelexReportData({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
  }) async {
    final medicalId = row.record.medicalId;

    final results = await Future.wait([
      db.flightDao.getFlightByMedicalId(medicalId),
      db.incidentDao.getByMedicalId(medicalId),
      db.treatmentDao.getTreatment(medicalId),
      db.medicalFeeDao.getFeeByMedicalId(medicalId),
      db.telexDao.getTelexByMedicalId(medicalId),
      db.treatmentDao.getStaffAssignments(medicalId),
    ]);

    final flight = results[0] as FlightRecordData?;
    final incident = results[1] as IncidentRecordData?;
    final treatment = results[2] as TreatmentData?;
    final fee = results[3] as MedicalFeeData?;
    final telex = results[4] as TelexDocumentData?;
    final staffAssignments = results[5] as List<MedicalStaffAssignmentData>;

    final patient = row.patient;
    final birthday = patient.birthday;
    final birthYear = birthday == null ? '' : birthday.year.toString();
    final birthMonth = birthday == null ? '' : _twoDigits(birthday.month);
    final birthDay = birthday == null ? '' : _twoDigits(birthday.day);

    final sexName = refService.getSexById(patient.sexId)?.name ?? '';
    final nationalityName = patient.nationalityId == null
        ? ''
        : refService.getNationalityById(patient.nationalityId)?.name ?? '';

    final airlineName = flight?.airlineId == null
        ? ''
        : refService.getAirlineById(flight!.airlineId)?.name ?? '';
    final flightNo = flight?.flightNumber.trim() ?? '';
    final isAirline = airlineName.isNotEmpty || flightNo.isNotEmpty;

    final travelStatusName = flight?.travelStatusId == null
        ? ''
        : refService.getTravelStatusById(flight!.travelStatusId)?.name ?? '';
    final direction = _resolveDirection(travelStatusName);

    final incidentDate = incident?.incidentDate;
    final incidentYear = incidentDate == null
        ? ''
        : incidentDate.year.toString();
    final incidentMonth = incidentDate == null
        ? ''
        : _twoDigits(incidentDate.month);
    final incidentDay = incidentDate == null
        ? ''
        : _twoDigits(incidentDate.day);

    final location = await _resolveIncidentLocation(
      db: db,
      refService: refService,
      incident: incident,
    );

    final reportTime = incident?.notificationTime;
    final treatTime = incident?.examinationTime ?? treatment?.treatmentTime;

    final diagnosis = _buildDiagnosis(treatment);

    final result = refService.getTreatmentResultById(treatment?.resultId);
    final outcome = _mapOutcome(result?.name ?? '');
    final transferTo = outcome == '轉送醫院'
        ? _resolveTransferTo(refService, treatment, result)
        : '';

    final totalFee = (fee?.consultFee ?? 0) + (fee?.ambulanceFee ?? 0);
    final chargedYes = totalFee > 0;
    final chargedNo = !chargedYes;
    final chargedAmount = chargedYes ? _formatFeeAmount(totalFee) : '';

    final staffNames = _resolveStaffNames(
      refService: refService,
      staffAssignments: staffAssignments,
      treatment: treatment,
    );

    final toStations =
        refService.stationList.where((s) => s.code.endsWith('_OCC')).toList()
          ..sort((a, b) => a.code.compareTo(b.code));
    final fromStations =
        refService.stationList.where((s) => s.code.endsWith('_MED')).toList()
          ..sort((a, b) => a.code.compareTo(b.code));

    final toLines = toStations
        .map(
          (station) => TelexFaxLine(
            text: station.name,
            checked: telex?.toStationId == station.id,
          ),
        )
        .toList();
    final fromLines = fromStations
        .map(
          (station) => TelexFaxLine(
            text: station.name,
            checked: telex?.fromStationId == station.id,
          ),
        )
        .toList();

    return TelexReportData(
      patientName: patient.name?.trim().isNotEmpty == true
          ? patient.name!.trim()
          : patient.anonymizationName?.trim() ?? '',
      nationality: nationalityName,
      birthYear: birthYear,
      birthMonth: birthMonth,
      birthDay: birthDay,
      gender: sexName,
      isAirline: isAirline,
      airline: airlineName,
      flightNo: flightNo,
      isOther: false,
      otherDetail: '',
      incidentYear: incidentYear,
      incidentMonth: incidentMonth,
      incidentDay: incidentDay,
      location: location,
      reporter: incident?.notificationPerson?.trim() ?? '',
      direction: direction,
      reportHour: _formatHour(reportTime),
      reportMin: _formatMinute(reportTime),
      treatHour: _formatHour(treatTime),
      treatMin: _formatMinute(treatTime),
      diagnosis: diagnosis,
      outcome: outcome,
      transferTo: transferTo,
      chargedYes: chargedYes,
      chargedNo: chargedNo,
      chargedAmount: chargedAmount,
      doctor: staffNames.doctor,
      nurse: staffNames.nurse,
      toTitle: 'TO：桃園國際機場股份有限公司營運安全處',
      fromTitle: 'FROM：聯新國際醫院桃園國際機場醫療中心',
      toLines: toLines,
      fromLines: fromLines,
    );
  }

  String _buildDiagnosis(TreatmentData? treatment) {
    final parts = [
      treatment?.tentative,
      treatment?.secondaryDiagnosis1,
      treatment?.secondaryDiagnosis2,
    ].where((value) => value?.trim().isNotEmpty == true);
    return parts.map((value) => value!.trim()).join('\n');
  }

  String _resolveDirection(String value) {
    switch (value) {
      case '出境':
      case '入境':
      case '過境':
        return value;
      default:
        return '';
    }
  }

  Future<String> _resolveIncidentLocation({
    required AppDatabase db,
    required ReferenceService refService,
    required IncidentRecordData? incident,
  }) async {
    if (incident == null) return '';
    final category = refService.getIncidentPlaceCategoryById(
      incident.incidentPlaceCategoryId,
    );
    final category2 = incident.incidentPlaceCategory2Id == null
        ? null
        : await db.referenceDao.getIncidentPlaceCategory2ById(
            incident.incidentPlaceCategory2Id!,
          );
    final parts = <String>[
      if (category?.name.trim().isNotEmpty == true) category!.name.trim(),
      if (category2?.name.trim().isNotEmpty == true) category2!.name.trim(),
      if (incident.incidentPlaceFinal?.trim().isNotEmpty == true)
        incident.incidentPlaceFinal!.trim(),
    ];
    return parts.join(' / ');
  }

  String _mapOutcome(String name) {
    if (name.contains('自行')) {
      return '自行返家';
    }
    if (name.contains('繼續搭機')) {
      return '繼續搭機';
    }
    if (name.contains('轉送') || (name.contains('轉') && name.contains('醫院'))) {
      return '轉送醫院';
    }
    if (name.contains('觀察')) {
      return '醫療中心觀察';
    }
    if (name.contains('空跑')) {
      return '空跑';
    }
    return name.isEmpty ? '' : '其他';
  }

  String _resolveTransferTo(
    ReferenceService refService,
    TreatmentData? treatment,
    TreatmentResultData? result,
  ) {
    if (treatment?.referralHospitalId != null) {
      return refService
              .getReferralHospitalById(treatment!.referralHospitalId)
              ?.name ??
          '';
    }
    final fallback = treatment?.referralHospitalFinal?.trim();
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }
    final resultName = result?.name ?? '';
    if (resultName.contains('醫院')) {
      return resultName.replaceFirst('轉送', '').replaceFirst('轉', '').trim();
    }
    return '';
  }

  String _formatFeeAmount(double amount) {
    final rounded = amount % 1 == 0;
    return rounded ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatHour(DateTime? time) {
    return time == null ? '' : _twoDigits(time.hour);
  }

  String _formatMinute(DateTime? time) {
    return time == null ? '' : _twoDigits(time.minute);
  }

  _StaffNames _resolveStaffNames({
    required ReferenceService refService,
    required List<MedicalStaffAssignmentData> staffAssignments,
    required TreatmentData? treatment,
  }) {
    String doctor = '';
    String nurse = '';

    for (final assignment in staffAssignments) {
      final role = _findStaffRole(refService, assignment.staffRoleId);
      final roleCode = role?.code;
      final name = assignment.staffName?.trim().isNotEmpty == true
          ? assignment.staffName!.trim()
          : refService.getMedicalStaffById(assignment.staffId)?.name ?? '';
      if (name.isEmpty) continue;
      if (roleCode == 'DOCTOR' && doctor.isEmpty) {
        doctor = name;
      }
      if (roleCode == 'NURSE' && nurse.isEmpty) {
        nurse = name;
      }
    }

    if (doctor.isEmpty) {
      doctor = treatment?.directorName?.trim() ?? '';
    }

    return _StaffNames(doctor: doctor, nurse: nurse);
  }

  MedicalStaffRoleData? _findStaffRole(
    ReferenceService refService,
    int? roleId,
  ) {
    if (roleId == null) return null;
    for (final role in refService.medicalStaffRoleList) {
      if (role.id == roleId) return role;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return Scaffold(
      backgroundColor: pageBg,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        title: const Text(
          '患者報表列印',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '搜尋病患姓名 / 病歷ID / 證件號',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchKeyword.isEmpty
                            ? null
                            : IconButton(
                                onPressed: _searchController.clear,
                                icon: const Icon(Icons.close),
                              ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: StreamBuilder<List<MedicalRecordWithPatient>>(
                  stream: db.medicalDao.watchAllRecords(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final allRecords = snapshot.data ?? [];
                    final records = [..._applySearch(allRecords)]
                      ..sort((a, b) {
                        final createdAtCompare = b.record.createdAt.compareTo(
                          a.record.createdAt,
                        );
                        if (createdAtCompare != 0) return createdAtCompare;
                        return b.record.medicalId.compareTo(a.record.medicalId);
                      });
                    if (records.isEmpty) {
                      return const Center(
                        child: Text(
                          '沒有可列印的患者資料',
                          style: TextStyle(color: textMuted),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final row = records[index];
                        final record = row.record;
                        final patient = row.patient;
                        final patientName =
                            patient.name?.trim().isNotEmpty == true
                            ? patient.name!
                            : '未填寫姓名';
                        final availableTypes = _availableTypes(record);
                        final selectedType = _selectedTypes[record.medicalId];
                        final effectiveType =
                            availableTypes.contains(selectedType)
                            ? selectedType!
                            : availableTypes.first;
                        _selectedTypes[record.medicalId] = effectiveType;

                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                patientName.isEmpty
                                    ? '?'
                                    : patientName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientName,
                                    style: const TextStyle(
                                      color: textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '病歷ID: ${record.medicalId}  |  建檔時間: '
                                    '${DateFormat('yyyy/MM/dd HH:mm').format(record.createdAt)}',
                                    style: const TextStyle(
                                      color: textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 220,
                              child: DropdownButtonFormField<PatientReportType>(
                                initialValue: effectiveType,
                                icon: const Icon(
                                  Icons.expand_more_rounded,
                                  color: textMuted,
                                ),
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: primaryColor,
                                      width: 1.4,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: borderColor,
                                    ),
                                  ),
                                ),
                                items: availableTypes.map((type) {
                                  return DropdownMenuItem<PatientReportType>(
                                    value: type,
                                    child: Text(type.label),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _selectedTypes[record.medicalId] = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _onPrint(row, effectiveType);
                              },
                              icon: const Icon(Icons.print, size: 18),
                              label: const Text('列印'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum PatientReportType { medical, emergency, ambulance, nursing, telex }

extension PatientReportTypeLabel on PatientReportType {
  String get label {
    switch (this) {
      case PatientReportType.medical:
        return '主診紀錄報表';
      case PatientReportType.emergency:
        return '急救紀錄報表';
      case PatientReportType.ambulance:
        return '救護車紀錄報表';
      case PatientReportType.nursing:
        return '護理紀錄報表';
      case PatientReportType.telex:
        return '出診診療服務電傳文件';
    }
  }

  String get labelEn {
    switch (this) {
      case PatientReportType.medical:
        return 'Medical Record';
      case PatientReportType.emergency:
        return 'Emergency Record';
      case PatientReportType.ambulance:
        return 'Ambulance Record';
      case PatientReportType.nursing:
        return 'Nursing Record';
      case PatientReportType.telex:
        return 'Telex Document';
    }
  }

  String get code {
    switch (this) {
      case PatientReportType.medical:
        return 'medical';
      case PatientReportType.emergency:
        return 'emergency';
      case PatientReportType.ambulance:
        return 'ambulance';
      case PatientReportType.nursing:
        return 'nursing';
      case PatientReportType.telex:
        return 'telex';
    }
  }
}

class _StaffNames {
  final String doctor;
  final String nurse;

  const _StaffNames({required this.doctor, required this.nurse});
}
