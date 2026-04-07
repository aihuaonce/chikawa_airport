import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../data/db/dao/medical_dao.dart';
import '../../data/db/dao/ambulance_treatment_dao.dart';
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';
import '../reports/chinese_diagnosis_report.dart';
import '../reports/ambulance_report.dart';
import '../reports/emergency_report.dart';
import '../reports/english_diagnosis_report.dart';
import '../reports/referral_report.dart';
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
    return <PatientReportType>[
      PatientReportType.diagnosisCertificate,
      PatientReportType.englishDiagnosisCertificate,
      PatientReportType.telex,
      PatientReportType.emergency,
      PatientReportType.ambulance,
      PatientReportType.referral,
    ];
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
      if (type == PatientReportType.emergency) {
        final reportData = await _buildEmergencyReportData(
          db: db,
          refService: refService,
          row: row,
        );
        final pdfBytes = await buildEmergencyReportPdf(reportData);
        await Printing.layoutPdf(
          name: 'patient_${row.record.medicalId}_${type.code}.pdf',
          onLayout: (_) async => pdfBytes,
        );
        return;
      }
      if (type == PatientReportType.ambulance) {
        final reportData = await _buildAmbulanceReportData(
          db: db,
          refService: refService,
          row: row,
        );
        final pdfBytes = await buildAmbulanceReportPdf(reportData);
        await Printing.layoutPdf(
          name: 'patient_${row.record.medicalId}_${type.code}.pdf',
          onLayout: (_) async => pdfBytes,
        );
        return;
      }
      if (type == PatientReportType.referral) {
        final reportData = await _buildReferralReportData(
          db: db,
          refService: refService,
          row: row,
        );
        final pdfBytes = await buildReferralReportPdf(reportData);
        await Printing.layoutPdf(
          name: 'patient_${row.record.medicalId}_${type.code}.pdf',
          onLayout: (_) async => pdfBytes,
        );
        return;
      }
      if (type == PatientReportType.diagnosisCertificate) {
        final reportData = await _buildDiagnosisCertificateReportData(
          db: db,
          refService: refService,
          row: row,
        );
        final pdfBytes = await buildChineseDiagnosisPdf(reportData);
        await Printing.layoutPdf(
          name: 'patient_${row.record.medicalId}_${type.code}.pdf',
          onLayout: (_) async => pdfBytes,
        );
        return;
      }
      if (type == PatientReportType.englishDiagnosisCertificate) {
        final reportData = await _buildEnglishDiagnosisReportData(
          db: db,
          refService: refService,
          row: row,
        );
        final pdfBytes = await buildEnglishDiagnosisPdf(reportData);
        await Printing.layoutPdf(
          name: 'patient_${row.record.medicalId}_${type.code}.pdf',
          onLayout: (_) async => pdfBytes,
        );
        return;
      }
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

  Future<void> _onExport(
    MedicalRecordWithPatient row,
    PatientReportType type,
  ) async {
    final db = context.read<AppDatabase>();
    final refService = context.read<ReferenceService>();

    try {
      final (fileName, pdfBytes) = await _buildPdfBytes(
        db: db,
        refService: refService,
        row: row,
        type: type,
      );

      final filePath = await _resolveExportPath(fileName);
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes, flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已匯出PDF：$filePath')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('匯出PDF失敗：$e')));
    }
  }

  Future<String> _resolveExportPath(String fileName) async {
    if (Platform.isAndroid) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        return p.join(downloadDir.path, fileName);
      }
      final fallback = await getExternalStorageDirectory();
      if (fallback != null) {
        return p.join(fallback.path, fileName);
      }
      final appDir = await getApplicationDocumentsDirectory();
      return p.join(appDir.path, fileName);
    }

    final downloads = await getDownloadsDirectory();
    if (downloads != null) {
      return p.join(downloads.path, fileName);
    }
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, fileName);
  }

  Future<(String, Uint8List)> _buildPdfBytes({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
    required PatientReportType type,
  }) async {
    final fileName = 'patient_${row.record.medicalId}_${type.code}.pdf';

    if (type == PatientReportType.emergency) {
      final reportData = await _buildEmergencyReportData(
        db: db,
        refService: refService,
        row: row,
      );
      final pdfBytes = await buildEmergencyReportPdf(reportData);
      return (fileName, pdfBytes);
    }
    if (type == PatientReportType.ambulance) {
      final reportData = await _buildAmbulanceReportData(
        db: db,
        refService: refService,
        row: row,
      );
      final pdfBytes = await buildAmbulanceReportPdf(reportData);
      return (fileName, pdfBytes);
    }
    if (type == PatientReportType.referral) {
      final reportData = await _buildReferralReportData(
        db: db,
        refService: refService,
        row: row,
      );
      final pdfBytes = await buildReferralReportPdf(reportData);
      return (fileName, pdfBytes);
    }
    if (type == PatientReportType.diagnosisCertificate) {
      final reportData = await _buildDiagnosisCertificateReportData(
        db: db,
        refService: refService,
        row: row,
      );
      final pdfBytes = await buildChineseDiagnosisPdf(reportData);
      return (fileName, pdfBytes);
    }
    if (type == PatientReportType.englishDiagnosisCertificate) {
      final reportData = await _buildEnglishDiagnosisReportData(
        db: db,
        refService: refService,
        row: row,
      );
      final pdfBytes = await buildEnglishDiagnosisPdf(reportData);
      return (fileName, pdfBytes);
    }
    if (type == PatientReportType.telex) {
      final reportData = await _buildTelexReportData(
        db: db,
        refService: refService,
        row: row,
      );
      final pdfBytes = await buildTelexPdf(reportData);
      return (fileName, pdfBytes);
    }

    final patientName = row.patient.name?.trim().isNotEmpty == true
        ? row.patient.name!
        : '未填寫姓名';
    final createdAt = DateFormat(
      'yyyy/MM/dd HH:mm',
    ).format(row.record.createdAt);

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Text(
            'Patient Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Report Type: ${type.labelEn}'),
          pw.Text('Medical ID: ${row.record.medicalId}'),
          pw.Text('Patient Name: $patientName'),
          pw.Text('Created At: $createdAt'),
          pw.SizedBox(height: 16),
          pw.Text('Note: Replace this template with full report content.'),
        ],
      ),
    );

    return (fileName, await doc.save());
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
      db.treatmentDao.getSpecialNotes(medicalId),
    ]);

    final flight = results[0] as FlightRecordData?;
    final incident = results[1] as IncidentRecordData?;
    final treatment = results[2] as TreatmentData?;
    final fee = results[3] as MedicalFeeData?;
    final telex = results[4] as TelexDocumentData?;
    final staffAssignments = results[5] as List<MedicalStaffAssignmentData>;
    final specialNotes = results[6] as SpecialNotesData?;

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

    final diagnosis = await _buildDiagnosisWithIcdNames(db, treatment);

    final result = refService.getTreatmentResultById(treatment?.resultId);
    final resultName = result?.name ?? '';
    final isEmptyRun = await _hasSpecialNoteByName(
      db: db,
      refService: refService,
      medicalId: medicalId,
      name: '空跑',
      specialNotes: specialNotes,
    );
    final (outcome, otherOutcomeDetail) = _mapOutcomeWithDetail(resultName);
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
      gender: _mapSexToChinese(sexName),
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
      otherOutcomeDetail: otherOutcomeDetail,
      isEmptyRun: isEmptyRun,
      transferTo: transferTo,
      chargedYes: chargedYes,
      chargedNo: chargedNo,
      chargedAmount: chargedAmount,
      doctor: staffNames.doctor,
      nurse: staffNames.nurse,
      doctorSignature: staffNames.doctorSignature,
      nurseSignature: staffNames.nurseSignature,
      toTitle: 'TO：桃園國際機場股份有限公司營運安全處',
      fromTitle: 'FROM：聯新國際醫院桃園國際機場醫療中心',
      toLines: toLines,
      fromLines: fromLines,
    );
  }

  Future<ChineseDiagnosisReportData> _buildDiagnosisCertificateReportData({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
  }) async {
    final medicalId = row.record.medicalId;

    final results = await Future.wait([
      db.certificateDao.getCertificateByMedicalId(medicalId),
      db.treatmentDao.getTreatment(medicalId),
      db.treatmentDao.getStaffAssignments(medicalId),
    ]);

    final certificate = results[0] as MedicalCertificateData?;
    final treatment = results[1] as TreatmentData?;
    final staffAssignments = results[2] as List<MedicalStaffAssignmentData>;

    final patient = row.patient;
    final birthday = patient.birthday;
    final birthYear = birthday == null ? '' : birthday.year.toString();
    final birthMonth = birthday == null ? '' : _twoDigits(birthday.month);
    final birthDay = birthday == null ? '' : _twoDigits(birthday.day);

    final sexName = refService.getSexById(patient.sexId)?.name ?? '';
    final diagnosisCategoryId = certificate?.diagnosisCategoryId;
    var diagnosisCategory =
        refService.getDiagnosisCategoryById(diagnosisCategoryId)?.name.trim() ??
        '';
    if (diagnosisCategory.isEmpty && diagnosisCategoryId != null) {
      final categoryRow = await (db.select(
        db.diagnosisCategory,
      )..where((c) => c.id.equals(diagnosisCategoryId))).getSingleOrNull();
      diagnosisCategory = categoryRow?.name.trim() ?? '';
    }
    if (diagnosisCategory.isEmpty && treatment?.tentativeCategoryId != null) {
      final fallbackId = treatment!.tentativeCategoryId;
      diagnosisCategory =
          refService.getDiagnosisCategoryById(fallbackId)?.name.trim() ?? '';
      if (diagnosisCategory.isEmpty) {
        final categoryRow = await (db.select(
          db.diagnosisCategory,
        )..where((c) => c.id.equals(fallbackId!))).getSingleOrNull();
        diagnosisCategory = categoryRow?.name.trim() ?? '';
      }
    }
    final diagnosis = _buildCertificateDiagnosisText(
      certificate: certificate,
      treatment: treatment,
    );
    final diagnosisWithIcd = await _appendIcdChineseNameToLines(db, diagnosis);
    final doctorNotes = certificate?.chineseAdvice?.trim() ?? '';

    final treatingDoctor = _resolvePrimaryDoctorName(
      refService: refService,
      staffAssignments: staffAssignments,
    );
    final directorName = treatment?.directorName?.trim();
    final director = (directorName != null && directorName.isNotEmpty)
        ? directorName
        : treatingDoctor;

    final issuanceDate = certificate?.issuanceDate ?? DateTime.now();

    return ChineseDiagnosisReportData(
      name: patient.name?.trim().isNotEmpty == true
          ? patient.name!.trim()
          : patient.anonymizationName?.trim() ?? '',
      birthYear: birthYear,
      birthMonth: birthMonth,
      birthDay: birthDay,
      gender: _mapSexToChinese(sexName),
      idOrPassport: _resolveIdOrPassport(patient),
      diagnosisCategory: diagnosisCategory,
      diagnosis: diagnosisWithIcd,
      doctorNotes: doctorNotes,
      director: director,
      treatingDoctor: treatingDoctor,
      certYear: issuanceDate.year.toString(),
      certMonth: _twoDigits(issuanceDate.month),
      certDay: _twoDigits(issuanceDate.day),
    );
  }

  Future<EmergencyReportData> _buildEmergencyReportData({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
  }) async {
    final medicalId = row.record.medicalId;

    final results = await Future.wait([
      db.flightDao.getFlightByMedicalId(medicalId),
      db.incidentDao.getByMedicalId(medicalId),
      db.treatmentDao.getTreatment(medicalId),
      db.emergencyDao.getOrCreateEmergencyTreatment(medicalId),
      db.treatmentDao.getStaffAssignments(medicalId),
    ]);

    final flight = results[0] as FlightRecordData?;
    final incident = results[1] as IncidentRecordData?;
    final treatment = results[2] as TreatmentData?;
    final emergency = results[3] as EmergencyTreatmentData;
    final staffAssignments = results[4] as List<MedicalStaffAssignmentData>;

    final initialAssessment = await _getAssessmentById(
      db,
      emergency.initialAssessmentId,
    );
    final postAssessment = await _getAssessmentById(
      db,
      emergency.postAssessmentId,
    );
    final firstAidLogs = await db.emergencyDao.getFirstAidLogs(emergency.id);

    final patient = row.patient;
    final birthday = patient.birthday;
    final birthDate = birthday == null ? '' : _formatDate(birthday);

    final sexName = refService.getSexById(patient.sexId)?.name ?? '';
    final nationality = patient.nationalityId == null
        ? ''
        : refService.getNationalityById(patient.nationalityId)?.name ?? '';

    final airline = flight?.airlineId == null
        ? ''
        : refService.getAirlineById(flight!.airlineId)?.name ?? '';

    final travelStatusName = flight?.travelStatusId == null
        ? ''
        : refService.getTravelStatusById(flight!.travelStatusId)?.name ?? '';
    final source = _resolveEmergencySource(travelStatusName);

    final incidentDate = incident?.incidentDate;
    final incidentDateYear = incidentDate == null
        ? ''
        : incidentDate.year.toString();
    final incidentDateMonth = incidentDate == null
        ? ''
        : _twoDigits(incidentDate.month);
    final incidentDateDay = incidentDate == null
        ? ''
        : _twoDigits(incidentDate.day);
    final incidentTime = _formatTime(incidentDate);

    final emergencyStartTime = _formatTime(emergency.startTime);
    final incidentSituation = emergency.incidentContext ?? '';

    final diagnosisFromTreatment = await _buildDiagnosisWithIcdNames(
      db,
      treatment,
    );
    final emergencyDiagnosisRaw = emergency.diagnosis?.trim() ?? '';
    final diagnosisFromEmergency = emergencyDiagnosisRaw.isEmpty
        ? ''
        : await _appendIcdChineseNameToLines(db, emergencyDiagnosisRaw);
    final diagnosis = diagnosisFromTreatment.isNotEmpty
        ? diagnosisFromTreatment
        : diagnosisFromEmergency;

    final location = await _resolveIncidentLocation(
      db: db,
      refService: refService,
      incident: incident,
    );

    final monitorTime = List.filled(10, '');
    final monitorHR = List.filled(10, '');
    final monitorBP = List.filled(10, '');
    final monitorBreathing = List.filled(10, '');
    final monitorO2 = List.filled(10, '');
    final monitorDCShock = List.filled(10, '');
    final monitorEpi = List.filled(10, '');
    final monitorMeds = List.filled(10, '');
    for (var i = 0; i < firstAidLogs.length && i < 10; i++) {
      final log = firstAidLogs[i];
      monitorTime[i] = log.time ?? '';
      monitorHR[i] = log.heartRate ?? '';
      monitorBP[i] = log.bloodPressure ?? '';
      monitorBreathing[i] = log.respirationRate ?? '';
      monitorO2[i] = log.o2 ?? '';
      monitorDCShock[i] = log.shock ?? '';
      monitorEpi[i] = log.epinephrine ?? '';
      monitorMeds[i] = log.otherMeds ?? '';
    }

    final leftPupilReaction = await _resolvePupilReactionSymbol(
      db,
      initialAssessment?.leftPupilReactionId,
      initialAssessment?.leftPupilReaction,
    );
    final rightPupilReaction = await _resolvePupilReactionSymbol(
      db,
      initialAssessment?.rightPupilReactionId,
      initialAssessment?.rightPupilReaction,
    );
    final postLeftPupilReaction = await _resolvePupilReactionSymbol(
      db,
      postAssessment?.leftPupilReactionId,
      postAssessment?.leftPupilReaction,
    );
    final postRightPupilReaction = await _resolvePupilReactionSymbol(
      db,
      postAssessment?.rightPupilReactionId,
      postAssessment?.rightPupilReaction,
    );

    final initBp = _formatBp(
      initialAssessment?.systolic,
      initialAssessment?.diastolic,
    );
    final postBp = _formatBp(
      postAssessment?.systolic,
      postAssessment?.diastolic,
    );

    final staff = _resolveEmergencyStaffNames(
      refService: refService,
      staffAssignments: staffAssignments,
      treatment: treatment,
    );

    final outcomeType = emergency.result ?? '';
    final endTime = emergency.endTime;
    final endHour = _formatHour(endTime);
    final endMin = _formatMinute(endTime);

    final transferHospital = _resolveTransferHospital(treatment, refService);
    final transferTime = outcomeType == '轉診' ? endTime : null;
    final deathTime = outcomeType == '死亡' ? endTime : null;

    return EmergencyReportData(
      name: patient.name?.trim().isNotEmpty == true
          ? patient.name!.trim()
          : patient.anonymizationName?.trim() ?? '',
      id: patient.idNo?.trim() ?? '',
      gender: _mapSexToChinese(sexName),
      birthDate: birthDate,
      passportNo: patient.passportOrIdNo?.trim() ?? '',
      source: source,
      airline: airline,
      incidentLocation: location,
      nationality: nationality,
      diagnosis: diagnosis,
      incidentDateYear: incidentDateYear,
      incidentDateMonth: incidentDateMonth,
      incidentDateDay: incidentDateDay,
      incidentTime: incidentTime,
      emergencyStartTime: emergencyStartTime,
      incidentSituation: incidentSituation,
      consciousnessE: initialAssessment?.gcsE ?? '',
      consciousnessM: initialAssessment?.gcsM ?? '',
      consciousnessV: initialAssessment?.gcsV ?? '',
      heartRate: initialAssessment?.pulse?.toString() ?? '',
      breathingRate: initialAssessment?.breath?.toString() ?? '',
      temperature: _mapTemperatureStatus(initialAssessment?.temperature),
      bpSystolic: _splitBp(initBp).$1,
      bpDiastolic: _splitBp(initBp).$2,
      pupilSizeL: _formatPupilSize(initialAssessment?.leftPupilSize),
      pupilSizeR: _formatPupilSize(initialAssessment?.rightPupilSize),
      pupilLR: '',
      pupilReactionL: leftPupilReaction,
      pupilReactionR: rightPupilReaction,
      onET: _mergeStrings(emergency.intubationMethod, emergency.intubationSize),
      onIVLine: emergency.ivLineSize ?? '',
      monitorTime: monitorTime,
      monitorHR: monitorHR,
      monitorBP: monitorBP,
      monitorBreathing: monitorBreathing,
      monitorO2: monitorO2,
      monitorDCShock: monitorDCShock,
      monitorEpi: monitorEpi,
      monitorMeds: monitorMeds,
      postConsciousnessE: postAssessment?.gcsE ?? '',
      postConsciousnessM: postAssessment?.gcsM ?? '',
      postConsciousnessV: postAssessment?.gcsV ?? '',
      postHeartRate: postAssessment?.pulse?.toString() ?? '',
      postBpSystolic: _splitBp(postBp).$1,
      postBpDiastolic: _splitBp(postBp).$2,
      postBreathing: emergency.postRespirationMode ?? '',
      postBreathingRate: postAssessment?.breath?.toString() ?? '',
      postPupilSizeL: _formatPupilSize(postAssessment?.leftPupilSize),
      postPupilSizeR: _formatPupilSize(postAssessment?.rightPupilSize),
      postOther: emergency.postRespirationOthers ?? '',
      postPupilReactionL: postLeftPupilReaction,
      postPupilReactionR: postRightPupilReaction,
      endTimeHour: endHour,
      endTimeMin: endMin,
      outcomeType: outcomeType,
      transferHospital: transferHospital,
      transferTimeHour: _formatHour(transferTime),
      transferTimeMin: _formatMinute(transferTime),
      deathTimeHour: _formatHour(deathTime),
      deathTimeMin: _formatMinute(deathTime),
      otherOutcome: emergency.endCareNotes ?? '',
      doctor: staff.doctor,
      nurse: staff.nurse,
      emt: staff.emt,
    );
  }

  Future<AmbulanceReportData> _buildAmbulanceReportData({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
  }) async {
    final medicalId = row.record.medicalId;

    final results = await Future.wait([
      db.ambulanceDao.getAmbulanceRecordByMedicalId(medicalId),
      db.ambulanceDao.getSceneRecord(medicalId),
      db.ambulanceDao.getPersonalProperty(medicalId),
      db.ambulanceDao.getAmbulanceFee(medicalId),
      db.ambulanceTreatmentDao.getRecord(medicalId),
    ]);

    final ambulanceRecord = results[0] as AmbulanceRecord?;
    final sceneRecord = results[1] as AmbulanceSceneRecordData?;
    final personalProperty = results[2] as AmbulancePersonalPropertyData?;
    final fee = results[3] as AmbulanceFeeData?;
    final treatmentRecord = results[4] as AmbulanceTreatmentRecordData?;

    final treatmentRecordId = treatmentRecord?.id;
    final joinedItems = treatmentRecordId == null
        ? <JoinedTreatmentItem>[]
        : await db.ambulanceTreatmentDao.getJoinedRecordItems(
            treatmentRecordId,
          );
    final medicationLogs = treatmentRecordId == null
        ? <AmbulanceMedicationLogData>[]
        : await db.ambulanceTreatmentDao.getMedicationLogs(treatmentRecordId);
    final vitalSigns = treatmentRecordId == null
        ? <AmbulanceVitalSignData>[]
        : await db.ambulanceTreatmentDao.getVitalSigns(treatmentRecordId);
    final escortStaff = treatmentRecordId == null
        ? <AmbulanceEscortStaffData>[]
        : await db.ambulanceTreatmentDao.getEscortStaff(treatmentRecordId);

    List<String> traumaGroup = [];
    List<String> nonTraumaGroup = [];
    List<String> generalTrauma = [];
    List<String> mechanism = [];
    List<String> acute = [];
    List<String> generalDisease = [];
    List<String> allergies = [];
    List<String> histories = [];
    if (sceneRecord != null) {
      final sceneId = sceneRecord.id;
      traumaGroup = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'TraumaGroup',
      );
      nonTraumaGroup = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'NonTraumaGroup',
      );
      generalTrauma = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'GeneralTrauma',
      );
      mechanism = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'Mechanism',
      );
      acute = await db.ambulanceDao.getSelectedLinkNames(sceneId, 'Acute');
      generalDisease = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'GeneralDisease',
      );
      allergies = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'Allergy',
      );
      histories = await db.ambulanceDao.getSelectedLinkNames(
        sceneId,
        'History',
      );
    }

    bool containsAny(List<String> values, List<String> keys) {
      return values.any((value) {
        final text = value.trim();
        return keys.any((key) => text.contains(key));
      });
    }

    bool containsKey(List<String> values, String key) {
      return values.any((value) => value.trim().contains(key));
    }

    final patient = row.patient;
    final patientName = patient.name?.trim().isNotEmpty == true
        ? patient.name!.trim()
        : patient.anonymizationName?.trim() ?? '';
    final sexName = refService.getSexById(patient.sexId)?.name ?? '';
    final age = _formatAge(patient.birthday);

    final dispatchTime = ambulanceRecord?.dispatchTime;
    final dispatchYear = dispatchTime == null
        ? ''
        : dispatchTime.year.toString();
    final dispatchMonth = dispatchTime == null
        ? ''
        : _twoDigits(dispatchTime.month);
    final dispatchDay = dispatchTime == null
        ? ''
        : _twoDigits(dispatchTime.day);

    final incidentLocation = await _resolveAmbulanceIncidentLocation(
      db: db,
      refService: refService,
      record: ambulanceRecord,
    );

    final hospitalName = ambulanceRecord?.hospitalId == null
        ? ''
        : refService
                  .getReferralHospitalById(ambulanceRecord!.hospitalId!)
                  ?.name ??
              '';
    final receivingUnit = treatmentRecord?.receivingHospital?.trim() ?? '';
    final sendToHospital = receivingUnit.isNotEmpty
        ? receivingUnit
        : hospitalName;

    final transportReason = ambulanceRecord?.transportReason ?? '';
    final sendReasonCondition =
        transportReason.contains('病情') || transportReason.contains('需要');
    final sendReasonPatientRequest =
        transportReason.contains('病人') ||
        transportReason.contains('家屬') ||
        transportReason.contains('家人');

    final propertyHandled = personalProperty?.isHandled ?? false;
    final guardian = personalProperty?.custodianName?.trim() ?? '';

    final allergyStatus = sceneRecord?.allergyStatus ?? '';
    final historyStatus = sceneRecord?.historyStatus ?? '';
    final allergyNote = sceneRecord?.allergyNote?.trim() ?? '';
    final historyNote = sceneRecord?.historyNote?.trim() ?? '';

    final hasAcute = containsKey(nonTraumaGroup, '急');
    final hasGeneralDisease = containsKey(nonTraumaGroup, '一般');

    final hasNonTraumaOther = containsKey(acute, '其他');
    final hasTraumaOther = containsKey(traumaGroup, '其他');
    final hasGeneralTraumaOther = containsKey(generalTrauma, '其他');

    final airwayItems = joinedItems
        .where((item) => item.category.code == 'AIRWAY')
        .toList();
    final cprItems = joinedItems
        .where((item) => item.category.code == 'CPR')
        .toList();
    final traumaItems = joinedItems
        .where((item) => item.category.code == 'TRAUMA')
        .toList();
    final drugItems = joinedItems
        .where((item) => item.category.code == 'DRUG')
        .toList();
    final otherItems = joinedItems
        .where((item) => item.category.code == 'OTHER')
        .toList();

    final airwayNames = airwayItems.map((item) => item.item.name).toList();
    final cprNames = cprItems.map((item) => item.item.name).toList();
    final traumaNames = traumaItems.map((item) => item.item.name).toList();
    final drugNames = drugItems.map((item) => item.item.name).toList();
    final otherNames = otherItems.map((item) => item.item.name).toList();

    JoinedTreatmentItem? findItem(List<JoinedTreatmentItem> items, String key) {
      for (final item in items) {
        if (item.item.name.contains(key)) return item;
      }
      return null;
    }

    JoinedTreatmentItem? findOther(List<JoinedTreatmentItem> items) {
      for (final item in items) {
        if (item.item.isOther || item.item.name.contains('其他')) {
          return item;
        }
      }
      return null;
    }

    String detailText(JoinedTreatmentItem? item, String? value) {
      if (item == null) return '';
      return value?.trim() ?? '';
    }

    final airwayNasal = findItem(airwayItems, '鼻管');
    final airwayMask = findItem(airwayItems, '面罩');
    final airwayLma = findItem(airwayItems, 'LMA');
    final airwayIgel = findItem(airwayItems, 'I-Gel');
    final airwayEt = findItem(airwayItems, '氣管');
    final airwayOther = findOther(airwayItems);

    final cprShockItem = findItem(cprItems, '電擊');
    final otherOtherItem = findOther(otherItems);

    final medicationTime = List.filled(4, '');
    final medicationName = List.filled(4, '');
    final medicationRoute = List.filled(4, '');
    final medicationExecutor = List.filled(4, '');
    for (var i = 0; i < medicationLogs.length && i < 4; i++) {
      final log = medicationLogs[i];
      medicationTime[i] = log.time ?? '';
      medicationName[i] = log.drugName ?? '';
      medicationRoute[i] = _mergeStrings(log.route, log.dose);
      medicationExecutor[i] = log.emtName ?? '';
    }

    final vsTime = List.filled(4, '');
    final vsConsciousness = List.filled(4, '');
    final vsTemp = List.filled(4, '');
    final vsPulse = List.filled(4, '');
    final vsBreathing = List.filled(4, '');
    final vsBPSys = List.filled(4, '');
    final vsBPDia = List.filled(4, '');
    final vsSpO2 = List.filled(4, '');
    final vsGcsE = List.filled(4, '');
    final vsGcsV = List.filled(4, '');
    final vsGcsM = List.filled(4, '');

    for (var i = 0; i < vitalSigns.length && i < 4; i++) {
      final vs = vitalSigns[i];
      final bp = vs.bloodPressure ?? '';
      final split = _splitBp(bp);
      vsTime[i] = vs.time ?? '';
      vsConsciousness[i] = vs.avpu ?? '';
      vsTemp[i] = vs.temperature ?? '';
      vsPulse[i] = vs.pulse ?? '';
      vsBreathing[i] = vs.respirationRate ?? '';
      vsBPSys[i] = split.$1;
      vsBPDia[i] = split.$2;
      vsSpO2[i] = vs.spo2 ?? '';
      vsGcsE[i] = vs.gcsE ?? '';
      vsGcsV[i] = vs.gcsV ?? '';
      vsGcsM[i] = vs.gcsM ?? '';
    }

    final atHospital = vitalSigns.reversed.firstWhere(
      (vs) => vs.atHospital,
      orElse: () =>
          AmbulanceVitalSignData(id: -1, recordId: -1, atHospital: false),
    );
    final avpu = atHospital.avpu ?? '';
    final postAlert = avpu.contains('清') || avpu.toUpperCase() == 'A';
    final postPain = avpu.contains('痛') || avpu.toUpperCase() == 'P';
    final postArrested = avpu.contains('無') || avpu.toUpperCase() == 'U';

    final emtNames = escortStaff
        .map((staff) => staff.name?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    final ambulanceFee = fee?.ambulanceFee ?? 0;
    final oxygenFee = fee?.oxygenFee ?? 0;
    final totalFee = ambulanceFee + oxygenFee;
    final ambulanceFeeText = ambulanceFee == 0
        ? ''
        : _formatFeeAmount(ambulanceFee);
    final oxygenFeeText = oxygenFee == 0 ? '' : _formatFeeAmount(oxygenFee);
    final totalFeeText = totalFee == 0 ? '' : _formatFeeAmount(totalFee);

    final paymentStatus = fee?.paymentStatus ?? '';
    final paymentMethod = fee?.paymentMethod ?? '';
    final unpaidType = fee?.unpaidType ?? '';
    final paidCash = paymentStatus.contains('已收');
    final paidCard =
        paymentStatus.contains('已收') && paymentMethod.contains('刷卡');
    final paidHospital = paymentStatus.contains('代收');
    final unpaid = paymentStatus.contains('未收');

    final familySign = treatmentRecord?.relativeName?.trim().isNotEmpty == true
        ? treatmentRecord!.relativeName!.trim()
        : patientName;

    final data = AmbulanceReportData()
      ..licensePlate = ambulanceRecord?.licensePlate?.trim() ?? ''
      ..dispatchDateYear = dispatchYear
      ..dispatchDateMonth = dispatchMonth
      ..dispatchDateDay = dispatchDay
      ..departureHour = _formatHour(ambulanceRecord?.dispatchTime)
      ..departureMin = _formatMinute(ambulanceRecord?.dispatchTime)
      ..arrivalHour = _formatHour(ambulanceRecord?.arrivalTime)
      ..arrivalMin = _formatMinute(ambulanceRecord?.arrivalTime)
      ..leaveSceneHour = _formatHour(ambulanceRecord?.leavingSceneTime)
      ..leaveSceneMin = _formatMinute(ambulanceRecord?.leavingSceneTime)
      ..deliveryHour = _formatHour(ambulanceRecord?.arrivalHospitalTime)
      ..deliveryMin = _formatMinute(ambulanceRecord?.arrivalHospitalTime)
      ..leaveHospHour = _formatHour(ambulanceRecord?.leavingHospitalTime)
      ..leaveHospMin = _formatMinute(ambulanceRecord?.leavingHospitalTime)
      ..returnBaseHour = _formatHour(ambulanceRecord?.returnStandbyTime)
      ..returnBaseMin = _formatMinute(ambulanceRecord?.returnStandbyTime)
      ..incidentLocation = incidentLocation
      ..sendToHospital = sendToHospital
      ..sendReasonCondition = sendReasonCondition
      ..sendReasonPatientRequest = sendReasonPatientRequest
      ..patientName = patientName
      ..gender = _mapSexToChinese(sexName)
      ..idOrPassport = _resolveIdOrPassport(patient)
      ..age = age
      ..guardian = guardian
      ..address = patient.address?.trim() ?? ''
      ..propertyNone = personalProperty != null && !propertyHandled
      ..propertyHas = propertyHandled
      ..ntiEmergency = hasAcute || containsKey(acute, '昏迷')
      ..ntiBreathIssue = containsAny(acute, ['呼吸不順', '喘'])
      ..ntiAirwayIssue = containsAny(acute, ['呼吸道', '梗阻', '阻塞'])
      ..ntiChestPain = containsAny(acute, ['胸痛', '胸悶'])
      ..ntiAbdomen = containsKey(acute, '腹痛')
      ..ntiGeneral = hasGeneralDisease
      ..ntiHeadache = containsAny(generalDisease, ['頭痛', '頭暈'])
      ..ntiFaint = containsAny(generalDisease, ['昏厥', '昏倒'])
      ..ntiFever = containsAny(generalDisease, ['發燒', '發熱'])
      ..ntiNausea = containsAny(generalDisease, ['噁心', '嘔吐'])
      ..ntiWeakness = containsAny(generalDisease, ['無力', '倦怠'])
      ..ntiDrug = containsKey(acute, '中毒')
      ..ntiCO = containsAny(acute, ['一氧化碳', 'CO'])
      ..ntiSeizure = containsAny(acute, ['癲癇', '抽搐'])
      ..ntiMental = containsKey(acute, '精神')
      ..ntiFall = containsAny(acute, ['跌倒'])
      ..ntiPregnancy = containsKey(acute, '孕')
      ..ntiCardiacArrest = containsAny(acute, ['OHCA', '心肺'])
      ..ntiOtherNT = hasNonTraumaOther
      ..ntiOtherNTText = ''
      ..trGeneral = containsKey(traumaGroup, '一般') || generalTrauma.isNotEmpty
      ..trHead = containsKey(generalTrauma, '頭')
      ..trChest = containsKey(generalTrauma, '胸')
      ..trAbdomen = containsKey(generalTrauma, '腹')
      ..trBack = containsKey(generalTrauma, '背')
      ..trLimb = containsAny(generalTrauma, ['肢', '四肢'])
      ..trOtherT = hasGeneralTraumaOther
      ..trDrown = containsKey(traumaGroup, '溺')
      ..trFall = containsAny(traumaGroup, ['墜', '跌'])
      ..trCrush = containsAny(traumaGroup, ['撞', '碾', '擠'])
      ..trFracture = containsKey(traumaNames, '骨折')
      ..trPenetrate = containsAny(traumaGroup, ['穿刺', '刺'])
      ..trBurn = containsAny(traumaGroup, ['燒', '燙'])
      ..trElectric = containsAny(traumaGroup, ['電'])
      ..trBioStrike = containsAny(traumaGroup, ['咬', '生物'])
      ..trCardiacArrest = containsAny(traumaGroup, ['心肺'])
      ..trOtherT2 = hasTraumaOther
      ..trBurnDegree = sceneRecord?.burnDegree ?? ''
      ..trFallHeight = sceneRecord?.fallHeight ?? ''
      ..trTrafficAcc = containsKey(mechanism, '交通')
      ..trNonTrafficAcc = containsKey(mechanism, '非交通')
      ..trOtherTText = hasGeneralTraumaOther
          ? (sceneRecord?.otherTraumaNote ?? '')
          : ''
      ..trOtherT2Text = hasTraumaOther
          ? (sceneRecord?.otherTraumaNote ?? '')
          : ''
      ..allergyNone = allergyStatus.contains('無')
      ..allergyUnknown = allergyStatus.contains('不詳')
      ..allergyFood = containsKey(allergies, '食物') ? allergyNote : ''
      ..allergyMeds = containsKey(allergies, '藥') ? allergyNote : ''
      ..allergyOther = containsKey(allergies, '其他') ? allergyNote : ''
      ..histNone = historyStatus.contains('無')
      ..histUnknown = historyStatus.contains('不詳')
      ..histHypertension = containsKey(histories, '高血壓')
      ..histDiabetes = containsKey(histories, '糖尿病')
      ..histHeart = containsKey(histories, '心')
      ..histAsthma = containsKey(histories, '氣喘')
      ..histOther = containsKey(histories, '其他') ? historyNote : ''
      ..chiefByFamily = sceneRecord?.isProxyComplaint ?? false
      ..chiefComplaint = sceneRecord?.patientComplaint ?? ''
      ..airOralAirway = containsKey(airwayNames, '口咽')
      ..airNasalAirway = containsKey(airwayNames, '鼻咽')
      ..airSuction = containsKey(airwayNames, '抽吸')
      ..airHeimlick = containsKey(airwayNames, '哈姆')
      ..airNasalO2 = airwayNasal != null
      ..airMaskO2 = airwayMask != null
      ..airNonRebreather = containsKey(airwayNames, '非再呼吸')
      ..airBVM = containsKey(airwayNames, 'BVM')
      ..airLMA = airwayLma != null
      ..airIgel = airwayIgel != null
      ..airEndotracheal = airwayEt != null
      ..airOther = airwayOther != null
      ..airLMANo = detailText(airwayLma, airwayLma?.link.tubeSize)
      ..airIgelNo = detailText(airwayIgel, airwayIgel?.link.tubeSize)
      ..airETNo = detailText(airwayEt, airwayEt?.link.tubeSize)
      ..airOtherText = detailText(
        airwayOther,
        airwayOther?.link.otherDescription,
      )
      ..cprAuto = containsKey(cprNames, '自發')
      ..cprCPR = containsKey(cprNames, 'CPR')
      ..cprAED = containsKey(cprNames, 'AED')
      ..cprElectricShock = cprShockItem != null
      ..cprHandShock = cprShockItem != null
      ..cprShockTimes = detailText(cprShockItem, cprShockItem?.link.shockCount)
      ..trCleanWound = containsKey(traumaNames, '清洗傷口')
      ..trHemostasis = containsAny(traumaNames, ['止血', '包紮'])
      ..trBackboard = containsKey(traumaNames, '長背板')
      ..trSplint = containsAny(traumaNames, ['擔架', '鏟式'])
      ..otherKeepWarm = containsKey(otherNames, '保暖')
      ..otherPsych = containsKey(otherNames, '心理')
      ..otherBandage = containsKey(otherNames, '束帶')
      ..otherO2Refuse = containsKey(otherNames, '拒絕')
      ..otherVitalMonitor = containsKey(otherNames, '監測')
      ..otherOther = otherOtherItem != null
      ..otherOtherText = detailText(
        otherOtherItem,
        otherOtherItem?.link.otherDescription,
      )
      ..medIV = containsKey(drugNames, '靜脈')
      ..medGlucose = containsKey(drugNames, '葡萄糖')
      ..medAspirin = containsKey(drugNames, 'Aspirin')
      ..medNTG = containsKey(drugNames, 'NTG')
      ..medBroncho = containsAny(drugNames, ['支氣管', '擴張'])
      ..medTime = medicationTime
      ..medName = medicationName
      ..medRoute = medicationRoute
      ..medExecutor = medicationExecutor
      ..vsTime = vsTime
      ..vsConsciousness = vsConsciousness
      ..vsTemp = vsTemp
      ..vsPulse = vsPulse
      ..vsBreathing = vsBreathing
      ..vsBPSys = vsBPSys
      ..vsBPDia = vsBPDia
      ..vsSpO2 = vsSpO2
      ..vsGcsE = vsGcsE
      ..vsGcsV = vsGcsV
      ..vsGcsM = vsGcsM
      ..postAlert = postAlert
      ..postPain = postPain
      ..postArrested = postArrested
      ..emt1 = emtNames.isNotEmpty ? emtNames[0] : ''
      ..emt2 = emtNames.length > 1 ? emtNames[1] : ''
      ..emt3 = emtNames.length > 2 ? emtNames[2] : ''
      ..receiveUnit = receivingUnit.isNotEmpty ? receivingUnit : hospitalName
      ..patientFamilySign = familySign
      ..ambulanceFee = ambulanceFeeText
      ..o2Fee = oxygenFeeText
      ..totalFee = totalFeeText
      ..paidCash = paidCash
      ..paidCard = paidCard
      ..paidHospital = paidHospital
      ..unpaid = unpaid
      ..unpaidNote = unpaid ? unpaidType : ''
      ..notes = treatmentRecord?.doctorInstructions?.trim() ?? '';

    return data;
  }

  Future<ReferralReportData> _buildReferralReportData({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
  }) async {
    final medicalId = row.record.medicalId;

    final results = await Future.wait([
      db.referralFormDao.getFormByMedicalId(medicalId),
      db.treatmentDao.getTreatment(medicalId),
      db.treatmentDao.getStaffAssignments(medicalId),
      db.treatmentDao.getChiefComplaint(medicalId),
      db.treatmentDao.getMedicalHistory(medicalId),
    ]);

    final form = results[0] as ReferralFormData?;
    final treatment = results[1] as TreatmentData?;
    final staffAssignments = results[2] as List<MedicalStaffAssignmentData>;
    final chiefComplaint = results[3] as ChiefComplaintData?;
    final medicalHistory = results[4] as MedicalHistoryData?;

    final patient = row.patient;
    final birthday = patient.birthday;
    final birthYear = birthday == null ? '' : birthday.year.toString();
    final birthMonth = birthday == null ? '' : _twoDigits(birthday.month);
    final birthDay = birthday == null ? '' : _twoDigits(birthday.day);

    final sexName = refService.getSexById(patient.sexId)?.name ?? '';
    final staffNames = _resolveStaffNames(
      refService: refService,
      staffAssignments: staffAssignments,
      treatment: treatment,
    );

    String findRelationshipName(int? id) {
      if (id == null) return '';
      for (final relation in refService.relationshipTypeList) {
        if (relation.id == id) return relation.name;
      }
      return '';
    }

    HistoryStatusRefData? findHistoryStatus(int? id) {
      if (id == null) return null;
      for (final status in refService.historyStatusList) {
        if (status.id == id) return status;
      }
      return null;
    }

    ReferralPurposeData? findReferralPurpose(int? id) {
      if (id == null) return null;
      for (final purpose in refService.referralPurposeList) {
        if (purpose.id == id) return purpose;
      }
      return null;
    }

    String hospitalName = form?.hospitalName?.trim() ?? '';
    String hospitalPhone = form?.hospitalPhone?.trim() ?? '';
    String hospitalAddress = form?.hospitalAddress?.trim() ?? '';
    if (hospitalName.isEmpty && treatment?.referralHospitalId != null) {
      final hospital = refService.getReferralHospitalById(
        treatment!.referralHospitalId,
      );
      hospitalName = hospital?.name ?? '';
      if (hospitalPhone.isEmpty) hospitalPhone = hospital?.phone ?? '';
      if (hospitalAddress.isEmpty) hospitalAddress = hospital?.address ?? '';
    }
    if (hospitalName.isEmpty) {
      hospitalName = treatment?.referralHospitalFinal?.trim() ?? '';
    }

    final relationshipName = findRelationshipName(form?.relationshipId);
    final consentRelationship = relationshipName.isNotEmpty
        ? relationshipName
        : form?.otherRelationship?.trim() ?? '';

    final consentDateTime = form?.consentDateTime ?? form?.orderDate;
    final consentYear = consentDateTime == null
        ? ''
        : consentDateTime.year.toString();
    final consentMonth = consentDateTime == null
        ? ''
        : _twoDigits(consentDateTime.month);
    final consentDay = consentDateTime == null
        ? ''
        : _twoDigits(consentDateTime.day);
    final consentHour = consentDateTime == null
        ? ''
        : _twoDigits(consentDateTime.hour);
    final consentMin = consentDateTime == null
        ? ''
        : _twoDigits(consentDateTime.minute);

    final issueDate = form?.orderDate;
    final issueDateYear = issueDate == null ? '' : issueDate.year.toString();
    final issueDateMonth = issueDate == null ? '' : _twoDigits(issueDate.month);
    final issueDateDay = issueDate == null ? '' : _twoDigits(issueDate.day);

    final appointDate = form?.scheduledDate;
    final appointDateYear = appointDate == null
        ? ''
        : appointDate.year.toString();
    final appointDateMonth = appointDate == null
        ? ''
        : _twoDigits(appointDate.month);
    final appointDateDay = appointDate == null
        ? ''
        : _twoDigits(appointDate.day);

    var appointDept = form?.scheduledDept?.trim() ?? '';
    final scheduledRoom = form?.scheduledRoom?.trim() ?? '';
    if (scheduledRoom.isNotEmpty) {
      appointDept = appointDept.isEmpty
          ? scheduledRoom
          : '$appointDept $scheduledRoom';
    }

    final referralPurpose = findReferralPurpose(form?.referralPurposeId);
    final purposeCode = referralPurpose?.code ?? '';
    final otherPurpose = form?.otherPurpose?.trim() ?? '';

    final allergyStatus = findHistoryStatus(medicalHistory?.allergyStatusId);
    final allergyCode = allergyStatus?.code ?? '';
    final allergyNone = allergyCode == 'none';
    final allergyHas = allergyCode == 'yes';

    final contactName = form?.contactName?.trim().isNotEmpty == true
        ? form!.contactName!.trim()
        : patient.name?.trim().isNotEmpty == true
        ? patient.name!.trim()
        : patient.anonymizationName?.trim() ?? '';

    final contactPhone = form?.contactPhone?.trim().isNotEmpty == true
        ? form!.contactPhone!.trim()
        : patient.telephone?.trim() ?? '';

    final contactAddress = form?.contactAddress?.trim().isNotEmpty == true
        ? form!.contactAddress!.trim()
        : patient.address?.trim() ?? '';

    final diagnosisPrimary = form?.primaryDiagnosis?.trim().isNotEmpty == true
        ? form!.primaryDiagnosis!.trim()
        : treatment?.tentative?.trim() ?? '';
    final diagnosisSecondary1 =
        form?.secondaryDiagnosis1?.trim().isNotEmpty == true
        ? form!.secondaryDiagnosis1!.trim()
        : treatment?.secondaryDiagnosis1?.trim() ?? '';
    final diagnosisSecondary2 =
        form?.secondaryDiagnosis2?.trim().isNotEmpty == true
        ? form!.secondaryDiagnosis2!.trim()
        : treatment?.secondaryDiagnosis2?.trim() ?? '';

    final examDate = form?.examDate;
    final medDate = form?.medicationDate;

    final doctorName = form?.doctorName?.trim().isNotEmpty == true
        ? form!.doctorName!.trim()
        : staffNames.doctor;
    final doctorDept = form?.doctorDepartment?.trim() ?? '';
    final doctorHandoverNote = form?.notes?.trim().isNotEmpty == true
        ? form!.notes!.trim()
        : treatment?.doctorOrderCh?.trim() ?? '';

    final summaryParts = <String>[];
    final complaint = chiefComplaint?.chiefComplaintFinal?.trim();
    if (complaint != null && complaint.isNotEmpty) {
      summaryParts.add(complaint);
    }
    final supplementary = chiefComplaint?.supplementaryNotes?.trim();
    if (supplementary != null && supplementary.isNotEmpty) {
      summaryParts.add(supplementary);
    }
    final historyDetail = medicalHistory?.pastHistoryDetail?.trim();
    if (historyDetail != null && historyDetail.isNotEmpty) {
      summaryParts.add(historyDetail);
    }

    final diagnosisPrimaryWithIcd = await _appendIcdChineseName(
      db,
      diagnosisPrimary,
    );
    final diagnosisSecondary1WithIcd = await _appendIcdChineseName(
      db,
      diagnosisSecondary1,
    );
    final diagnosisSecondary2WithIcd = await _appendIcdChineseName(
      db,
      diagnosisSecondary2,
    );

    final data = ReferralReportData()
      ..referToHospital = hospitalName
      ..name = patient.name?.trim().isNotEmpty == true
          ? patient.name!.trim()
          : patient.anonymizationName?.trim() ?? ''
      ..gender = _mapSexToChinese(sexName)
      ..birthYear = birthYear
      ..birthMonth = birthMonth
      ..birthDay = birthDay
      ..idNo = _resolveIdOrPassport(patient)
      ..contact = contactName
      ..contactPhone = contactPhone
      ..contactAddress = contactAddress
      ..chiefComplaintHistory = summaryParts.join('\n')
      ..diagnosisICD = diagnosisPrimaryWithIcd
      ..diagnosisName1 = diagnosisPrimaryWithIcd
      ..diagnosisName2 = diagnosisSecondary1WithIcd
      ..diagnosisName3 = diagnosisSecondary2WithIcd
      ..lastExamResult = form?.recentExamResult?.trim() ?? ''
      ..lastExamDate = examDate == null ? '' : _formatDate(examDate)
      ..lastExamReport = form?.recentExamResult?.trim() ?? ''
      ..lastMedOrSurgery = form?.recentMedication?.trim() ?? ''
      ..lastMedDate = medDate == null ? '' : _formatDate(medDate)
      ..allergyNone = allergyNone
      ..allergyHas = allergyHas
      ..allergyDetail = medicalHistory?.allergyDetail?.trim() ?? ''
      ..doctorHandoverNote = doctorHandoverNote
      ..purposeEmergency = purposeCode == 'emergency'
      ..purposeHospital = purposeCode == 'inpatient'
      ..purposeClinic = purposeCode == 'outpatient'
      ..purposeFurtherExam = purposeCode == 'further_exam'
      ..furtherExamItems = purposeCode == 'further_exam' ? otherPurpose : ''
      ..purposeFollowUp = purposeCode == 'followup'
      ..purposeOther = purposeCode == 'other'
      ..purposeOtherText = purposeCode == 'other' ? otherPurpose : ''
      ..consentSignName = contactName
      ..consentSignature = form?.consentSignature
      ..consentRelationship = consentRelationship
      ..consentYear = consentYear
      ..consentMonth = consentMonth
      ..consentDay = consentDay
      ..consentHour = consentHour
      ..consentMin = consentMin
      ..doctorName = doctorName
      ..doctorDept = doctorDept
      ..issueDateYear = issueDateYear
      ..issueDateMonth = issueDateMonth
      ..issueDateDay = issueDateDay
      ..appointDateYear = appointDateYear
      ..appointDateMonth = appointDateMonth
      ..appointDateDay = appointDateDay
      ..appointDept = appointDept
      ..appointNo = form?.scheduledNumber?.trim() ?? ''
      ..referHospital = hospitalName
      ..referDept = form?.hospitalDept?.trim() ?? ''
      ..referDoctor = form?.hospitalDoctor?.trim() ?? ''
      ..referHospAddress = hospitalAddress
      ..referHospPhone = hospitalPhone;

    return data;
  }

  Future<EnglishDiagnosisReportData> _buildEnglishDiagnosisReportData({
    required AppDatabase db,
    required ReferenceService refService,
    required MedicalRecordWithPatient row,
  }) async {
    final medicalId = row.record.medicalId;

    final results = await Future.wait([
      db.certificateDao.getCertificateByMedicalId(medicalId),
      db.treatmentDao.getTreatment(medicalId),
      db.treatmentDao.getStaffAssignments(medicalId),
    ]);

    final certificate = results[0] as MedicalCertificateData?;
    final treatment = results[1] as TreatmentData?;
    final staffAssignments = results[2] as List<MedicalStaffAssignmentData>;

    final patient = row.patient;
    final birthday = patient.birthday;
    final dateOfBirth = birthday == null ? '' : _formatDate(birthday);

    final sexName = refService.getSexById(patient.sexId)?.name ?? '';
    final sex = _mapSexToEnglish(sexName);
    final nationality = patient.nationalityId == null
        ? ''
        : refService.getNationalityById(patient.nationalityId)?.nameEn ??
              refService.getNationalityById(patient.nationalityId)?.name ??
              '';

    final impression = _buildCertificateDiagnosis(
      refService: refService,
      certificate: certificate,
      treatment: treatment,
    );
    final commentsAndAdvices = certificate?.englishAdvice?.trim() ?? '';

    final directorName = treatment?.directorName?.trim();
    final director = (directorName != null && directorName.isNotEmpty)
        ? directorName
        : _resolvePrimaryDoctorName(
            refService: refService,
            staffAssignments: staffAssignments,
          );

    final issuanceDate = certificate?.issuanceDate ?? DateTime.now();
    final attendingPhysician = _resolvePrimaryDoctorName(
      refService: refService,
      staffAssignments: staffAssignments,
    );

    return EnglishDiagnosisReportData(
      name: patient.name?.trim().isNotEmpty == true
          ? patient.name!.trim()
          : patient.anonymizationName?.trim() ?? '',
      dateOfBirth: dateOfBirth,
      sex: sex,
      nationality: nationality,
      idOrPassportNo: _resolveIdOrPassport(patient),
      impression: impression,
      commentsAndAdvices: commentsAndAdvices,
      director: director,
      attendingPhysician: attendingPhysician,
      issuedDate: _formatDate(issuanceDate),
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

  Future<String> _buildDiagnosisWithIcdNames(
    AppDatabase db,
    TreatmentData? treatment,
  ) async {
    final parts = [
      treatment?.tentative,
      treatment?.secondaryDiagnosis1,
      treatment?.secondaryDiagnosis2,
    ].where((value) => value?.trim().isNotEmpty == true);

    final lines = <String>[];
    for (final value in parts) {
      final line = await _appendIcdChineseName(db, value!.trim());
      if (line.isNotEmpty) {
        lines.add(line);
      }
    }
    return lines.join('\n');
  }

  String _extractIcdCode(String value) {
    final match = RegExp(r'[A-Za-z]\d{2}(?:\.\d{1,4})?').firstMatch(value);
    return match?.group(0) ?? '';
  }

  Future<String> _appendIcdChineseName(AppDatabase db, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    final code = _extractIcdCode(trimmed).toUpperCase();
    if (code.isEmpty) return trimmed;

    final row = await (db.select(
      db.icd10Code,
    )..where((c) => c.code.equals(code))).getSingleOrNull();
    if (row == null) return trimmed;

    final nameCh = row.nameCh.trim();
    if (nameCh.isEmpty) return trimmed;
    if (trimmed.contains(nameCh)) return trimmed;

    final rest = trimmed.substring(code.length).trim();
    if (rest.isEmpty) return '$code $nameCh';
    return '$code $nameCh $rest';
  }

  Future<String> _appendIcdChineseNameToLines(
    AppDatabase db,
    String text,
  ) async {
    final raw = text.trim();
    if (raw.isEmpty) return '';
    final lines = raw.split('\n');
    final output = <String>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final withName = await _appendIcdChineseName(db, trimmed);
      output.add(withName);
    }
    return output.join('\n');
  }

  String _buildCertificateDiagnosis({
    required ReferenceService refService,
    required MedicalCertificateData? certificate,
    required TreatmentData? treatment,
  }) {
    final parts = <String>[];
    final category = refService.getDiagnosisCategoryById(
      certificate?.diagnosisCategoryId,
    );
    if (category?.name.trim().isNotEmpty == true) {
      parts.add(category!.name.trim());
    }
    final result = certificate?.diagnosisResult?.trim();
    if (result != null && result.isNotEmpty) {
      parts.add(result);
    }
    if (parts.isEmpty && treatment?.tentative?.trim().isNotEmpty == true) {
      parts.add(treatment!.tentative!.trim());
    }
    return parts.join('\n');
  }

  String _resolveIdOrPassport(PatientData patient) {
    final idNo = patient.idNo?.trim();
    if (idNo != null && idNo.isNotEmpty) {
      return idNo;
    }
    return patient.passportOrIdNo?.trim() ?? '';
  }

  String _resolveDirection(String value) {
    switch (value) {
      case '出境':
      case '入境':
      case '過境':
      case '轉機':
      case '迫降':
      case '轉降':
      case '備降':
      case '技術性降落':
      case '其他':
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

  Future<String> _resolveAmbulanceIncidentLocation({
    required AppDatabase db,
    required ReferenceService refService,
    required AmbulanceRecord? record,
  }) async {
    if (record == null) return '';
    final category = refService.getIncidentPlaceCategoryById(
      record.incidentLocationId,
    );
    final category2 = record.incidentLocation2Id == null
        ? null
        : await db.referenceDao.getIncidentPlaceCategory2ById(
            record.incidentLocation2Id!,
          );
    final parts = <String>[
      if (category?.name.trim().isNotEmpty == true) category!.name.trim(),
      if (category2?.name.trim().isNotEmpty == true) category2!.name.trim(),
      if (record.locationRemarks?.trim().isNotEmpty == true)
        record.locationRemarks!.trim(),
    ];
    return parts.join(' / ');
  }

  (String, String) _mapOutcomeWithDetail(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return ('', '');
    if (trimmed.contains('自行')) {
      return ('自行返家', '');
    }
    if (trimmed.contains('繼續搭機') || trimmed.contains('搭機')) {
      return ('繼續搭機', '');
    }
    if (trimmed.contains('轉送') ||
        (trimmed.contains('轉') && trimmed.contains('醫院'))) {
      return ('轉送醫院', '');
    }
    if (trimmed.contains('觀察')) {
      return ('醫療中心觀察', '');
    }
    if (trimmed.contains('空跑')) {
      return ('空跑', '');
    }
    return ('其他', trimmed);
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

  Future<bool> _hasSpecialNoteByName({
    required AppDatabase db,
    required ReferenceService refService,
    required int medicalId,
    required String name,
    SpecialNotesData? specialNotes,
  }) async {
    final note =
        specialNotes ?? await db.treatmentDao.getSpecialNotes(medicalId);
    if (note == null) return false;

    SpecialNoteRefData? ref;
    try {
      ref = refService.specialNoteRefs.firstWhere((r) => r.name == name);
    } catch (_) {
      ref = null;
    }
    if (ref == null) return false;

    final ids = await db.treatmentDao.getSpecialNoteIds(note.noteId);
    return ids.contains(ref.id);
  }

  String _formatFeeAmount(double amount) {
    final rounded = amount % 1 == 0;
    return rounded ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  }

  String _formatAge(DateTime? birthday) {
    if (birthday == null) return '';
    final now = DateTime.now();
    var age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age -= 1;
    }
    return age < 0 ? '' : age.toString();
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm').format(time);
  }

  String _formatHour(DateTime? time) {
    return time == null ? '' : _twoDigits(time.hour);
  }

  String _formatMinute(DateTime? time) {
    return time == null ? '' : _twoDigits(time.minute);
  }

  String _resolveEmergencySource(String travelStatusName) {
    final trimmed = travelStatusName.trim();
    return trimmed.isEmpty ? '' : trimmed;
  }

  Future<String> _resolvePupilReactionSymbol(
    AppDatabase db,
    int? reactionId,
    String? reactionText,
  ) async {
    final text = reactionText?.trim();
    if (text != null && text.isNotEmpty) return text;
    if (reactionId == null) return '';
    final ref = await (db.select(
      db.pupilReactionRef,
    )..where((t) => t.id.equals(reactionId))).getSingleOrNull();
    return ref?.symbol ?? '';
  }

  String _mapTemperatureStatus(double? temp) {
    if (temp == null) return '';
    return temp < 36 ? '冰冷' : '溫暖';
  }

  String _formatPupilSize(double? size) {
    if (size == null) return '';
    if (size % 1 == 0) return size.toInt().toString();
    return size.toStringAsFixed(1);
  }

  String _formatBp(int? systolic, int? diastolic) {
    if (systolic == null && diastolic == null) return '';
    if (systolic != null && diastolic != null) {
      return '$systolic/$diastolic';
    }
    return systolic?.toString() ?? '';
  }

  (String, String) _splitBp(String bp) {
    if (bp.contains('/')) {
      final parts = bp.split('/');
      if (parts.length == 2) {
        return (parts[0], parts[1]);
      }
    }
    return (bp, '');
  }

  String _mergeStrings(String? first, String? second) {
    final a = first?.trim();
    final b = second?.trim();
    if (a != null && a.isNotEmpty && b != null && b.isNotEmpty) {
      return '$a $b';
    }
    if (a != null && a.isNotEmpty) return a;
    return b ?? '';
  }

  String _resolveTransferHospital(
    TreatmentData? treatment,
    ReferenceService refService,
  ) {
    if (treatment?.referralHospitalId != null) {
      return refService
              .getReferralHospitalById(treatment!.referralHospitalId)
              ?.name ??
          '';
    }
    return treatment?.referralHospitalFinal?.trim() ?? '';
  }

  String _mapSexToChinese(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    final lower = trimmed.toLowerCase();
    if (lower == 'm' || lower == 'male') return '男';
    if (lower == 'f' || lower == 'female') return '女';
    if (trimmed.contains('男')) return '男';
    if (trimmed.contains('女')) return '女';
    return trimmed;
  }

  String _buildCertificateDiagnosisText({
    required MedicalCertificateData? certificate,
    required TreatmentData? treatment,
  }) {
    final result = certificate?.diagnosisResult?.trim();
    if (result != null && result.isNotEmpty) {
      return result;
    }
    if (treatment?.tentative?.trim().isNotEmpty == true) {
      return treatment!.tentative!.trim();
    }
    return '';
  }

  String _mapSexToEnglish(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    final lower = trimmed.toLowerCase();
    if (lower == 'm' || lower == 'male') return 'M';
    if (lower == 'f' || lower == 'female') return 'F';
    if (trimmed.contains('男')) {
      return 'M';
    }
    if (trimmed.contains('女')) {
      return 'F';
    }
    return '';
  }

  _StaffNames _resolveStaffNames({
    required ReferenceService refService,
    required List<MedicalStaffAssignmentData> staffAssignments,
    required TreatmentData? treatment,
  }) {
    String doctor = '';
    String nurse = '';
    Uint8List? doctorSignature;
    Uint8List? nurseSignature;

    Uint8List? resolveSignature(MedicalStaffAssignmentData assignment) {
      final signature = assignment.signature;
      if (signature != null && signature.isNotEmpty) return signature;
      if (assignment.staffId == null) return null;
      return refService.getMedicalStaffById(assignment.staffId)?.signature;
    }

    for (final assignment in staffAssignments) {
      final role = _findStaffRole(refService, assignment.staffRoleId);
      final roleCode = role?.code;
      final name = assignment.staffName?.trim().isNotEmpty == true
          ? assignment.staffName!.trim()
          : refService.getMedicalStaffById(assignment.staffId)?.name ?? '';
      if (roleCode == 'DOCTOR') {
        if (doctor.isEmpty && name.isNotEmpty) {
          doctor = name;
        }
        doctorSignature ??= resolveSignature(assignment);
      }
      if (roleCode == 'NURSE') {
        if (nurse.isEmpty && name.isNotEmpty) {
          nurse = name;
        }
        nurseSignature ??= resolveSignature(assignment);
      }
    }

    if (doctor.isEmpty) {
      doctor = treatment?.directorName?.trim() ?? '';
    }

    return _StaffNames(
      doctor: doctor,
      nurse: nurse,
      doctorSignature: doctorSignature,
      nurseSignature: nurseSignature,
    );
  }

  String _resolvePrimaryDoctorName({
    required ReferenceService refService,
    required List<MedicalStaffAssignmentData> staffAssignments,
  }) {
    String resolveName(MedicalStaffAssignmentData assignment) {
      final name = assignment.staffName?.trim();
      if (name != null && name.isNotEmpty) return name;
      if (assignment.staffId != null) {
        return refService.getMedicalStaffById(assignment.staffId)?.name ?? '';
      }
      return '';
    }

    final doctorAssignments = staffAssignments.where((assignment) {
      final role = _findStaffRole(refService, assignment.staffRoleId);
      return role?.code == 'DOCTOR';
    }).toList();

    for (final assignment in doctorAssignments) {
      if (!assignment.isPrimary) continue;
      final name = resolveName(assignment);
      if (name.isNotEmpty) return name;
    }

    return '';
  }

  _EmergencyStaffNames _resolveEmergencyStaffNames({
    required ReferenceService refService,
    required List<MedicalStaffAssignmentData> staffAssignments,
    required TreatmentData? treatment,
  }) {
    String doctor = '';
    String nurse = '';
    String emt = '';

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
      if (roleCode == 'EMT' && emt.isEmpty) {
        emt = name;
      }
    }

    if (doctor.isEmpty) {
      doctor = treatment?.directorName?.trim() ?? '';
    }

    return _EmergencyStaffNames(doctor: doctor, nurse: nurse, emt: emt);
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

  Future<MedicalAssessmentData?> _getAssessmentById(AppDatabase db, int? id) {
    if (id == null) return Future.value(null);
    return (db.select(
      db.medicalAssessment,
    )..where((t) => t.assessmentId.equals(id))).getSingleOrNull();
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
                                value: effectiveType,
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
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: const BorderSide(color: primaryColor),
                              ),
                              onPressed: () {
                                _onExport(row, effectiveType);
                              },
                              icon: const Icon(Icons.download, size: 18),
                              label: const Text('匯出'),
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

enum PatientReportType {
  emergency,
  ambulance,
  referral,
  diagnosisCertificate,
  englishDiagnosisCertificate,
  telex,
}

extension PatientReportTypeLabel on PatientReportType {
  String get label {
    switch (this) {
      case PatientReportType.emergency:
        return '急救紀錄報表';
      case PatientReportType.ambulance:
        return '救護車紀錄報表';
      case PatientReportType.referral:
        return '轉診單';
      case PatientReportType.diagnosisCertificate:
        return '中文診斷書';
      case PatientReportType.englishDiagnosisCertificate:
        return '英文診斷書';
      case PatientReportType.telex:
        return '出診診療服務電傳文件';
    }
  }

  String get labelEn {
    switch (this) {
      case PatientReportType.emergency:
        return 'Emergency Record';
      case PatientReportType.ambulance:
        return 'Ambulance Record';
      case PatientReportType.referral:
        return 'Referral Form';
      case PatientReportType.diagnosisCertificate:
        return 'Chinese Diagnosis Certificate';
      case PatientReportType.englishDiagnosisCertificate:
        return 'English Diagnosis Certificate';
      case PatientReportType.telex:
        return 'Telex Document';
    }
  }

  String get code {
    switch (this) {
      case PatientReportType.emergency:
        return 'emergency';
      case PatientReportType.ambulance:
        return 'ambulance';
      case PatientReportType.referral:
        return 'referral';
      case PatientReportType.diagnosisCertificate:
        return 'diagnosis_cn';
      case PatientReportType.englishDiagnosisCertificate:
        return 'diagnosis_en';
      case PatientReportType.telex:
        return 'telex';
    }
  }
}

class _StaffNames {
  final String doctor;
  final String nurse;
  final Uint8List? doctorSignature;
  final Uint8List? nurseSignature;

  const _StaffNames({
    required this.doctor,
    required this.nurse,
    this.doctorSignature,
    this.nurseSignature,
  });
}

class _EmergencyStaffNames {
  final String doctor;
  final String nurse;
  final String emt;

  const _EmergencyStaffNames({
    required this.doctor,
    required this.nurse,
    required this.emt,
  });
}
