import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../data/db/dao/medical_dao.dart';
import '../../data/db/database.dart';

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
    final patientName = row.patient.name?.trim().isNotEmpty == true
        ? row.patient.name!
        : '未填寫姓名';
    final createdAt = DateFormat(
      'yyyy/MM/dd HH:mm',
    ).format(row.record.createdAt);

    try {
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

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return Scaffold(
      backgroundColor: pageBg,
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
                    final records = _applySearch(allRecords);
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
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
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

enum PatientReportType { medical, emergency, ambulance, nursing }

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
    }
  }
}
