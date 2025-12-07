// lib/EmergencyPlanPage.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart';

class EmergencyPlanPage extends StatefulWidget {
  final int visitId;
  const EmergencyPlanPage({super.key, required this.visitId});

  @override
  State<EmergencyPlanPage> createState() => _EmergencyPlanPageState();
}

class _EmergencyPlanPageState extends State<EmergencyPlanPage> {
  // Style Colors
  static const Color primarySelectedColor = Color(0xFF274C4A);
  static const Color buttonBackgroundColor = Color(0xFF83ACA9);
  static const Color pageBackground = Color(0xFFE8F4F7);
  static const Color cardBackground = Colors.white;
  static const Color borderColor = Color(0xFFCBD5E1);
  static const Color labelColor = Color(0xFF4A5568);
  static const Color white = Colors.white;

  // Controllers
  final diagnosisController = TextEditingController();
  final situationController = TextEditingController();
  final eController = TextEditingController();
  final vController = TextEditingController();
  final mController = TextEditingController();
  final heartRateController = TextEditingController();
  final respirationRateController = TextEditingController();
  final bpSystolicController = TextEditingController();
  final bpDiastolicController = TextEditingController();
  final leftPupilSizeController = TextEditingController();
  final rightPupilSizeController = TextEditingController();
  final airwayContentController = TextEditingController();
  final insertionRecordController = TextEditingController();
  final ivNeedleSizeController = TextEditingController();
  final ivLineRecordController = TextEditingController();
  final cardiacMassageRecordController = TextEditingController();
  final endRecordController = TextEditingController();
  final nurseSignatureController = TextEditingController();
  final emtSignatureController = TextEditingController();
  final otherHospitalController = TextEditingController();
  final otherEndResultController = TextEditingController();
  final postResuscitationEController = TextEditingController();
  final postResuscitationVController = TextEditingController();
  final postResuscitationMController = TextEditingController();
  final postResuscitationHeartRateController = TextEditingController();
  final postResuscitationBloodPressureController = TextEditingController();
  final postResuscitationLeftPupilSizeController = TextEditingController();
  final postResuscitationRightPupilSizeController = TextEditingController();
  final otherSupplementsController = TextEditingController();

  // Static Data
  final List<String> VisitingStaff = [
    '方詩旋',
    '夏瑿正',
    '江汪財',
    '呂學政',
    '周志勃',
    '金靜歌',
    '徐丕',
    '康曉婭',
  ];
  final List<String> RegisteredNurses = [
    '陳思穎',
    '邱靜鈴',
    '莊漾媛',
    '洪豔',
    '范育婕',
    '陳簡妤',
    '蔡可萱',
    '粘瑞詩',
  ];
  final List<String> EMTs = ['王文義', '游進昌', '胡勇淳', '黃逸斌', '峯承軒', '張致綸', '劉呈軒'];
  final List<String> _helperNames = [
    '方詩婷',
    '夏增正',
    '江旺財',
    '呂學政',
    '海欣茹',
    '洪雲敏',
    '徐氏',
    '康曉朗',
    '黎裕昌',
    '戴逸旻',
    '廖詠怡',
    '許婷涵',
    '陳小山',
    '王悅朗',
    '劉金宇',
    '彭士書',
    '熊得志',
    '顧小',
    '蔡心文',
    '程皓',
    '楊敏庭',
    '羅尹彤',
    '廖哲用',
    '陳國平',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadData();
    });
  }

  void _loadData() {
    final data = context.read<EmergencyData>();
    diagnosisController.text = data.diagnosis ?? '';
    situationController.text = data.situation ?? '';
    eController.text = data.evmE ?? '';
    vController.text = data.evmV ?? '';
    mController.text = data.evmM ?? '';
    heartRateController.text = data.heartRate ?? '';
    respirationRateController.text = data.respirationRate ?? '';
    if (data.bloodPressure != null && data.bloodPressure!.contains('/')) {
      final parts = data.bloodPressure!.split('/');
      if (parts.length == 2) {
        bpSystolicController.text = parts[0];
        bpDiastolicController.text = parts[1];
      }
    }
    leftPupilSizeController.text = data.leftPupilSize ?? '';
    rightPupilSizeController.text = data.rightPupilSize ?? '';
    airwayContentController.text = data.airwayContent ?? '';
    insertionRecordController.text = data.insertionRecord ?? '';
    ivNeedleSizeController.text = data.ivNeedleSize ?? '';
    ivLineRecordController.text = data.ivLineRecord ?? '';
    cardiacMassageRecordController.text = data.cardiacMassageRecord ?? '';
    endRecordController.text = data.endRecord ?? '';
    nurseSignatureController.text = data.nurseSignature ?? '';
    emtSignatureController.text = data.emtSignature ?? '';
    otherHospitalController.text = data.otherHospital ?? '';
    otherEndResultController.text = data.otherEndResult ?? '';
    postResuscitationEController.text = data.postResuscitationEvmE ?? '';
    postResuscitationVController.text = data.postResuscitationEvmV ?? '';
    postResuscitationMController.text = data.postResuscitationEvmM ?? '';
    postResuscitationHeartRateController.text =
        data.postResuscitationHeartRate ?? '';
    postResuscitationBloodPressureController.text =
        data.postResuscitationBloodPressure ?? '';
    postResuscitationLeftPupilSizeController.text =
        data.postResuscitationLeftPupilSize ?? '';
    postResuscitationRightPupilSizeController.text =
        data.postResuscitationRightPupilSize ?? '';
    otherSupplementsController.text = data.otherSupplements ?? '';
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    situationController.dispose();
    eController.dispose();
    vController.dispose();
    mController.dispose();
    heartRateController.dispose();
    respirationRateController.dispose();
    bpSystolicController.dispose();
    bpDiastolicController.dispose();
    leftPupilSizeController.dispose();
    rightPupilSizeController.dispose();
    airwayContentController.dispose();
    insertionRecordController.dispose();
    ivNeedleSizeController.dispose();
    ivLineRecordController.dispose();
    cardiacMassageRecordController.dispose();
    endRecordController.dispose();
    nurseSignatureController.dispose();
    emtSignatureController.dispose();
    otherHospitalController.dispose();
    otherEndResultController.dispose();
    postResuscitationEController.dispose();
    postResuscitationVController.dispose();
    postResuscitationMController.dispose();
    postResuscitationHeartRateController.dispose();
    postResuscitationBloodPressureController.dispose();
    postResuscitationLeftPupilSizeController.dispose();
    postResuscitationRightPupilSizeController.dispose();
    otherSupplementsController.dispose();
    super.dispose();
  }

  void _saveToProvider() {
    final data = context.read<EmergencyData>();
    final systolic = bpSystolicController.text.trim();
    final diastolic = bpDiastolicController.text.trim();
    final bloodPressure = (systolic.isNotEmpty && diastolic.isNotEmpty)
        ? '$systolic/$diastolic'
        : null;

    data.updatePlan(
      diagnosis: diagnosisController.text,
      situation: situationController.text,
      evmE: eController.text,
      evmV: vController.text,
      evmM: mController.text,
      heartRate: heartRateController.text,
      respirationRate: respirationRateController.text,
      bloodPressure: bloodPressure,
      leftPupilSize: leftPupilSizeController.text,
      rightPupilSize: rightPupilSizeController.text,
      airwayContent: airwayContentController.text,
      insertionRecord: insertionRecordController.text,
      ivNeedleSize: ivNeedleSizeController.text,
      ivLineRecord: ivLineRecordController.text,
      cardiacMassageRecord: cardiacMassageRecordController.text,
      endRecord: endRecordController.text,
      nurseSignature: nurseSignatureController.text,
      emtSignature: emtSignatureController.text,
      otherHospital: otherHospitalController.text,
      otherEndResult: otherEndResultController.text,
      postResuscitationEvmE: postResuscitationEController.text,
      postResuscitationEvmV: postResuscitationVController.text,
      postResuscitationEvmM: postResuscitationMController.text,
      postResuscitationHeartRate: postResuscitationHeartRateController.text,
      postResuscitationBloodPressure:
          postResuscitationBloodPressureController.text,
      postResuscitationLeftPupilSize:
          postResuscitationLeftPupilSizeController.text,
      postResuscitationRightPupilSize:
          postResuscitationRightPupilSizeController.text,
      otherSupplements: otherSupplementsController.text,
    );
  }

  // ===========================================================================
  // PDF 列印與生成邏輯
  // ===========================================================================
  Future<void> _printPdf() async {
    _saveToProvider();
    final emData = context.read<EmergencyData>();

    // 獲取關聯資料
    String patientName = "";
    String gender = "";
    DateTime? dob;
    String idNo = "";
    String nationality = "";
    String travelStatus = "";
    String airline = "";
    DateTime? incidentDate;
    String location = "";

    try {
      final visitsDao = context.read<VisitsDao>();
      final profileDao = context.read<PatientProfilesDao>();
      final flightDao = context.read<FlightLogsDao>();
      final accidentDao = context.read<AccidentRecordsDao>();

      final visit = await visitsDao.getVisit(widget.visitId);
      if (visit != null) {
        patientName = visit.patientName ?? "";
        nationality = visit.nationality ?? "";
      }

      final profile = await profileDao.getByVisitId(widget.visitId);
      if (profile != null) {
        dob = profile.birthday;
        gender = profile.gender ?? "";
        idNo = (profile.idNumber != null && profile.idNumber!.isNotEmpty)
            ? profile.idNumber!
            : (profile.passportNumber ?? "");
      }

      final flight = await flightDao.getByVisitId(widget.visitId);
      if (flight != null) {
        travelStatus = flight.travelStatus ?? "";
        airline = flight.airline ?? "";
      }

      final accident = await accidentDao.getByVisitId(widget.visitId);
      if (accident != null) {
        incidentDate = accident.incidentDate;
        location = "${accident.placeGroup ?? ''} ${accident.placeDetail ?? ''}";
      }
    } catch (e) {
      debugPrint("Error fetching data for PDF: $e");
    }

    final font = await PdfGoogleFonts.notoSansTCRegular();
    final fontBold = await PdfGoogleFonts.notoSansTCBold();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final doc = pw.Document();
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(30),
            build: (pw.Context context) {
              return _buildPdfContent(
                font: font,
                fontBold: fontBold,
                emData: emData,
                patientName: patientName,
                gender: gender,
                dob: dob,
                idNo: idNo,
                nationality: nationality,
                travelStatus: travelStatus,
                airline: airline,
                incidentDate: incidentDate,
                location: location,
              );
            },
          ),
        );
        return doc.save();
      },
    );
  }

  pw.Widget _buildPdfContent({
    required pw.Font font,
    required pw.Font fontBold,
    required EmergencyData emData,
    required String patientName,
    required String gender,
    required DateTime? dob,
    required String idNo,
    required String nationality,
    required String travelStatus,
    required String airline,
    required DateTime? incidentDate,
    required String location,
  }) {
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 18);
    // 表格邊框
    final border = pw.TableBorder.all(width: 0.5, color: PdfColors.black);

    // 輔助函式：日期格式化
    String fmtDate(DateTime? dt) =>
        dt == null ? "" : "${dt.year} / ${dt.month} / ${dt.day}";
    String fmtTime(DateTime? dt) => dt == null ? "" : "${dt.hour}:${dt.minute}";

    // Checkbox 輔助
    String check(bool cond) => cond ? "■" : "□";

    return pw.Column(
      children: [
        pw.Text("聯新國際醫院桃園國際機場醫療中心急救紀錄表", style: titleStyle),
        pw.SizedBox(height: 5),

        // ================= HEADER TABLE =================
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(30), // Label
            1: const pw.FlexColumnWidth(1), // Content
            2: const pw.FixedColumnWidth(30), // Label
            3: const pw.FlexColumnWidth(1), // Content
            4: const pw.FixedColumnWidth(50), // Label
            5: const pw.FlexColumnWidth(1), // Content
            6: const pw.FixedColumnWidth(40), // Label
            7: const pw.FixedColumnWidth(25), // Content
          },
          children: [
            // Row 1: Name, ID, Gender/DOB, Passport?
            pw.TableRow(
              children: [
                _pCell("姓名", font, align: pw.Alignment.center),
                _pCell(patientName, font),
                _pCell("ID", font, align: pw.Alignment.center),
                _pCell(idNo, font),
                _pCell(
                  "${check(gender == '男')}男 ${check(gender == '女')}女\n生日",
                  font,
                  align: pw.Alignment.center,
                ),
                _pCell(fmtDate(dob), font),
                _pCell("護照號碼", font, align: pw.Alignment.center), // 假設欄位
                _pCell("", font),
              ],
            ),
          ],
        ),
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(30), // 來源
            1: const pw.FlexColumnWidth(1.2), // Checkboxes
            2: const pw.FixedColumnWidth(40), // 航空公司
            3: const pw.FlexColumnWidth(1), // Airline Value
            4: const pw.FixedColumnWidth(40), // 發生地點
            5: const pw.FlexColumnWidth(1), // Location Value
            6: const pw.FixedColumnWidth(25), // 國籍
            7: const pw.FlexColumnWidth(0.5), // Nationality Value
          },
          children: [
            pw.TableRow(
              children: [
                _pCell("來源", font, align: pw.Alignment.center),
                _pCell(
                  "${check(travelStatus == '出境')}出境 ${check(travelStatus == '入境')}入境\n${check(travelStatus == '過境')}過境 ${check(false)}其他",
                  font,
                ),
                _pCell("航空公司", font, align: pw.Alignment.center),
                _pCell(airline, font),
                _pCell("發生地點", font, align: pw.Alignment.center),
                _pCell(location, font),
                _pCell("國籍", font, align: pw.Alignment.center),
                _pCell(nationality, font),
              ],
            ),
          ],
        ),

        // Diagnosis & Time Block (Layout matches image: Diagnosis on left, Dates on right)
        pw.Row(
          children: [
            // Left: Diagnosis & Situation
            pw.Expanded(
              flex: 6,
              child: pw.Table(
                border: border,
                columnWidths: {0: const pw.FixedColumnWidth(30)},
                children: [
                  pw.TableRow(
                    children: [
                      _pCell(
                        "診\n\n斷",
                        font,
                        align: pw.Alignment.center,
                        height: 60,
                      ),
                      _pCell(
                        emData.diagnosis ?? "",
                        font,
                        align: pw.Alignment.topLeft,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _pCell(
                        "發生\n情境",
                        font,
                        align: pw.Alignment.center,
                        height: 35,
                      ),
                      _pCell(
                        emData.situation ?? "",
                        font,
                        align: pw.Alignment.topLeft,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right: Dates
            pw.Expanded(
              flex: 4,
              child: pw.Table(
                border: border,
                columnWidths: {0: const pw.FixedColumnWidth(60)},
                children: [
                  pw.TableRow(
                    children: [
                      _pCell("發生日期", font),
                      _pCell(fmtDate(incidentDate), font),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _pCell("發生時間", font),
                      _pCell(fmtTime(incidentDate), font),
                    ],
                  ), // 假設使用 incident time
                  pw.TableRow(
                    children: [
                      _pCell("急救開始時間", font, height: 20),
                      _pCell(fmtTime(emData.firstAidStartTime), font),
                    ],
                  ),
                  pw.TableRow(
                    children: [_pCell("", font, height: 31), _pCell("", font)],
                  ), // Filler to match height
                ],
              ),
            ),
          ],
        ),

        // ================= VITALS (Pre-Resuscitation) =================
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(15), // 病況
            1: const pw.FixedColumnWidth(25), // 意識
            2: const pw.FlexColumnWidth(1), // E
            3: const pw.FlexColumnWidth(1), // M
            4: const pw.FlexColumnWidth(1), // V
            5: const pw.FixedColumnWidth(30), // 心跳label
            6: const pw.FixedColumnWidth(40), // 心跳value
            7: const pw.FixedColumnWidth(30), // 瞳孔
            8: const pw.FixedColumnWidth(30), // Size
            9: const pw.FlexColumnWidth(1.5), // L value
            10: const pw.FlexColumnWidth(1.5), // R value
          },
          children: [
            pw.TableRow(
              children: [
                _pCell("病\n況", font, rowSpan: 3, align: pw.Alignment.center),
                _pCell("意識", font, align: pw.Alignment.center),
                _pCell("E:${emData.evmE}", font),
                _pCell("M:${emData.evmM}", font),
                _pCell("V:${emData.evmV}", font),
                _pCell("心跳:", font),
                _pCell(
                  "${emData.heartRate ?? ''} 次/分",
                  font,
                  align: pw.Alignment.center,
                ),
                _pCell("瞳孔", font, rowSpan: 2, align: pw.Alignment.center),
                _pCell("Size", font),
                _pCell("左: ${emData.leftPupilSize} mm", font),
                _pCell("右: ${emData.rightPupilSize} mm", font),
              ],
            ),
            pw.TableRow(
              children: [
                _pCell("呼吸", font, align: pw.Alignment.center),
                _pCell(
                  "${emData.respirationRate ?? ''} 次/分",
                  font,
                  colSpan: 3,
                  align: pw.Alignment.center,
                ),
                _pCell("血壓:", font),
                _pCell(
                  "${emData.bloodPressure ?? ''}\nmmHg",
                  font,
                  align: pw.Alignment.center,
                ),
                // Col 7 spanned
                _pCell("L-R", font),
                _pCell(
                  "左: ${emData.leftPupilReaction}",
                  font,
                ), // Simplifying checkbox to text
                _pCell("右: ${emData.rightPupilReaction}", font),
              ],
            ),
            pw.TableRow(
              children: [
                _pCell("溫度", font, align: pw.Alignment.center),
                _pCell(
                  "${check(emData.temperature == '冰冷')}冰冷  ${check(emData.temperature == '溫暖')}溫暖",
                  font,
                  colSpan: 9,
                ),
              ],
            ),
          ],
        ),

        // ================= TREATMENTS =================
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(60), // Label
            1: const pw.FixedColumnWidth(15), // #
            2: const pw.FlexColumnWidth(1), // Record
            3: const pw.FixedColumnWidth(80), // Label 2
            4: const pw.FlexColumnWidth(1), // Record 2
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _pCell("急救處置", font, align: pw.Alignment.center, colSpan: 2),
                _pCell("時間及紀錄", font, align: pw.Alignment.center),
                _pCell("急救處置", font, align: pw.Alignment.center),
                _pCell("時間及紀錄", font, align: pw.Alignment.center),
              ],
            ),
            pw.TableRow(
              children: [
                _pCell("On E.T", font),
                _pCell("# ${emData.airwayContent}", font),
                _pCell(emData.insertionRecord ?? "", font),
                _pCell("Cardiac Massage", font),
                _pCell(emData.cardiacMassageRecord ?? "", font),
              ],
            ),
            pw.TableRow(
              children: [
                _pCell("On IV Line", font),
                _pCell("# ${emData.ivNeedleSize}", font),
                _pCell(emData.ivLineRecord ?? "", font),
                _pCell("", font), // Blank block
                _pCell("", font),
              ],
            ),
          ],
        ),

        // ================= TIMELINE GRID (Row 9 in image) =================
        // Layout: Left column labels, Right columns are empty grids
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(80), // Labels
            // Automatic flex for rest
          },
          children: [
            _buildGridRow("時間(Time)", font),
            _buildGridRow("心跳 bpm", font),
            _buildGridRow("血壓 mmHg", font),
            _buildGridRow("呼吸 次/分", font),
            _buildGridRow("O2 (L/Min; %)", font),
            _buildGridRow("DC Shock (J)", font),
            _buildGridRow("Epinephrine (mg)", font),
            _buildGridRow("用藥", font, height: 40),
          ],
        ),

        // ================= POST-RESUSCITATION (Row 10) =================
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(15), // 意識
            1: const pw.FixedColumnWidth(15), // E
            2: const pw.FixedColumnWidth(20), // M
            3: const pw.FixedColumnWidth(20), // V
            4: const pw.FixedColumnWidth(30), // 心跳
            5: const pw.FixedColumnWidth(40), // Value
            6: const pw.FixedColumnWidth(30), // Size
            7: const pw.FixedColumnWidth(25), // Label
            8: const pw.FlexColumnWidth(1), // L
            9: const pw.FlexColumnWidth(1), // R
          },
          children: [
            pw.TableRow(
              children: [
                _pCell(
                  "意\n識\n急\n救\n後\n病\n況",
                  font,
                  rowSpan: 3,
                  align: pw.Alignment.center,
                  fontSize: 8,
                ),
                _pCell("E", font, align: pw.Alignment.center),
                _pCell("M", font, align: pw.Alignment.center),
                _pCell("V", font, align: pw.Alignment.center),
                _pCell("心跳:", font),
                _pCell("${emData.postResuscitationHeartRate ?? ''} 次", font),
                _pCell("瞳孔", font, rowSpan: 2, align: pw.Alignment.center),
                _pCell("Size", font),
                _pCell("左:${emData.postResuscitationLeftPupilSize}", font),
                _pCell("右:${emData.postResuscitationRightPupilSize}", font),
              ],
            ),
            pw.TableRow(
              children: [
                // Col 0 spanned
                _pCell(
                  emData.postResuscitationEvmE ?? "",
                  font,
                  align: pw.Alignment.center,
                ),
                _pCell(
                  emData.postResuscitationEvmM ?? "",
                  font,
                  align: pw.Alignment.center,
                ),
                _pCell(
                  emData.postResuscitationEvmV ?? "",
                  font,
                  align: pw.Alignment.center,
                ),
                _pCell("血壓:", font),
                _pCell(
                  "${emData.postResuscitationBloodPressure ?? ''}",
                  font,
                  fontSize: 8,
                ),
                // Col 6 spanned
                _pCell("L-R", font),
                _pCell(
                  "左:${emData.postResuscitationLeftPupilLightReflex}",
                  font,
                  fontSize: 8,
                ),
                _pCell(
                  "右:${emData.postResuscitationRightPupilLightReflex}",
                  font,
                  fontSize: 8,
                ),
              ],
            ),
            pw.TableRow(
              children: [
                // Col 0 spanned
                _pCell("呼吸", font, align: pw.Alignment.center),
                // Merging remaining cells for "Other"
                _pCell(
                  "${check(emData.postResuscitationRespirationMethod == '自發呼吸')}自發呼吸 "
                  "${check(emData.postResuscitationRespirationMethod == '呼吸器')}呼吸器 "
                  "${check(emData.postResuscitationRespirationMethod == 'Ambu')}Ambu   "
                  "其他: ${emData.otherSupplements ?? ''}",
                  font,
                  colSpan: 8,
                ),
              ],
            ),
          ],
        ),

        // ================= FOOTER (Result & Signature) =================
        pw.Table(
          border: border,
          children: [
            pw.TableRow(
              children: [
                _pCell("結束時間", font, width: 50),
                _pCell(fmtTime(emData.firstAidEndTime), font, width: 80),
                _pCell("", font), // Spacer
              ],
            ),
            pw.TableRow(
              children: [
                _pCell("急救結果", font, width: 50),
                _pCell(
                  "${check(emData.endResult == '轉診')}轉診  醫院:${emData.otherHospital ?? '__________'}    時間:____時____分\n"
                  "${check(emData.endResult == '死亡')}死亡    時間:____時____分\n"
                  "${check(emData.endResult == '其他')}其他:${emData.otherEndResult ?? ''}",
                  font,
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _pCell("急救人員", font, align: pw.Alignment.center),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "醫師: ${emData.selectedDoctor ?? ''}",
                        style: pw.TextStyle(font: font, fontSize: 10),
                      ),
                      pw.Text(
                        "護理師: ${emData.selectedNurse ?? ''}  簽名: ${emData.nurseSignature ?? ''}",
                        style: pw.TextStyle(font: font, fontSize: 10),
                      ),
                      pw.Text(
                        "EMT: ${emData.selectedEMT ?? ''}  簽名: ${emData.emtSignature ?? ''}",
                        style: pw.TextStyle(font: font, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 5),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text("1", style: pw.TextStyle(font: font, fontSize: 8)),
        ),
      ],
    );
  }

  // --- PDF Helper Widgets ---

  // Standard Cell
  pw.Widget _pCell(
    String text,
    pw.Font font, {
    pw.Alignment align = pw.Alignment.centerLeft,
    int colSpan = 1,
    int rowSpan = 1,
    double? width,
    double? height,
    double fontSize = 9,
  }) {
    return pw.Container(
      width: width,
      height: height,
      padding: const pw.EdgeInsets.all(2),
      alignment: align,
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: fontSize),
      ),
    );
  }

  // Row for the Timeline Grid (Label + 10 empty boxes)
  pw.TableRow _buildGridRow(String label, pw.Font font, {double? height}) {
    return pw.TableRow(
      children: [
        _pCell(label, font, align: pw.Alignment.center, height: height),
        for (int i = 0; i < 10; i++) _pCell("", font, height: height),
      ],
    );
  }

  // --- Dialog Helpers (Unchanged) ---
  Future<void> _showDoctorDialog(AppTranslations t) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(t.selectDoctorDialogTitle),
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ListView(
              children: VisitingStaff.map(
                (item) => ListTile(
                  title: Text(item),
                  onTap: () => Navigator.pop(context, item),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
    if (result != null && mounted)
      context.read<EmergencyData>().updatePlan(selectedDoctor: result);
  }

  Future<void> _showNurseDialog(AppTranslations t) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(t.selectNurseDialogTitle),
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ListView(
              children: RegisteredNurses.map(
                (item) => ListTile(
                  title: Text(item),
                  onTap: () => Navigator.pop(context, item),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
    if (result != null && mounted)
      context.read<EmergencyData>().updatePlan(selectedNurse: result);
  }

  Future<void> _showEMTDialog(AppTranslations t) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(t.selectEMTDialogTitle),
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ListView(
              children: EMTs.map(
                (item) => ListTile(
                  title: Text(item),
                  onTap: () => Navigator.pop(context, item),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
    if (result != null && mounted)
      context.read<EmergencyData>().updatePlan(selectedEMT: result);
  }

  Future<void> _showHelperSelectionDialog(AppTranslations t) async {
    final data = context.read<EmergencyData>();
    List<String> tempSelected = List.from(data.selectedAssistants);
    List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(t.selectAssistantsDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _helperNames
                  .map(
                    (name) => CheckboxListTile(
                      title: Text(name),
                      value: tempSelected.contains(name),
                      activeColor: primarySelectedColor,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true)
                            tempSelected.add(name);
                          else
                            tempSelected.remove(name);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text(t.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackgroundColor,
                foregroundColor: Colors.white,
              ),
              child: Text(t.confirm),
              onPressed: () => Navigator.of(context).pop(tempSelected),
            ),
          ],
        ),
      ),
    );
    if (result != null && mounted) data.updatePlan(selectedAssistants: result);
  }

  // --- UI Build Helpers (Abbreviated to save space, logic is same as before) ---
  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primarySelectedColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
  Widget _buildSectionContainer({
    required String title,
    required Widget child,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primarySelectedColor,
          ),
        ),
        const Divider(height: 24, thickness: 0.5),
        child,
      ],
    ),
  );
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, color: labelColor)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) => _saveToProvider(),
        decoration: _inputDeco(hint),
      ),
    ],
  );
  Widget _buildLabeledSmallTextField(
    String label,
    TextEditingController controller,
  ) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: labelColor)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          onChanged: (_) => _saveToProvider(),
          decoration: _inputDeco('...').copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildPostResuscitationStatusSection(
    EmergencyData data,
    AppTranslations t,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.consciousness,
          style: const TextStyle(fontSize: 14, color: labelColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildLabeledSmallTextField('E', postResuscitationEController),
            const SizedBox(width: 16),
            _buildLabeledSmallTextField('V', postResuscitationVController),
            const SizedBox(width: 16),
            _buildLabeledSmallTextField('M', postResuscitationMController),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          t.heartRate,
          postResuscitationHeartRateController,
          t.enterValue,
        ),
        const SizedBox(height: 16),
        Text(
          t.respiration,
          style: const TextStyle(fontSize: 14, color: labelColor),
        ),
        Row(
          children: [
            _buildTappableRadioOption(
              title: t.spontaneousRespiration,
              groupValue: data.postResuscitationRespirationMethod,
              onChanged: (v) =>
                  data.updatePlan(postResuscitationRespirationMethod: v),
            ),
            _buildTappableRadioOption(
              title: t.ventilator,
              groupValue: data.postResuscitationRespirationMethod,
              onChanged: (v) =>
                  data.updatePlan(postResuscitationRespirationMethod: v),
            ),
            _buildTappableRadioOption(
              title: "Ambu",
              groupValue: data.postResuscitationRespirationMethod,
              onChanged: (v) =>
                  data.updatePlan(postResuscitationRespirationMethod: v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          t.bloodPressure,
          postResuscitationBloodPressureController,
          t.enterSystolicDiastolic,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildLabeledSmallTextField(
              t.leftPupilSizeLabel,
              postResuscitationLeftPupilSizeController,
            ),
            const SizedBox(width: 16),
            _buildLabeledSmallTextField(
              t.rightPupilSizeLabel,
              postResuscitationRightPupilSizeController,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildPupilLightReflexRow(
          label: t.leftPupilReaction,
          groupValue: data.postResuscitationLeftPupilLightReflex,
          onChanged: (v) =>
              data.updatePlan(postResuscitationLeftPupilLightReflex: v),
        ),
        _buildPupilLightReflexRow(
          label: t.rightPupilReaction,
          groupValue: data.postResuscitationRightPupilLightReflex,
          onChanged: (v) =>
              data.updatePlan(postResuscitationRightPupilLightReflex: v),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          t.otherSupplements,
          otherSupplementsController,
          t.enterSupplementaryNotes,
        ),
      ],
    );
  }

  Widget _buildPupilLightReflexRow({
    required String label,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) => Row(
    children: [
      SizedBox(width: 60, child: Text(label)),
      const SizedBox(width: 8),
      _buildTappableRadioOption(
        title: "+",
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      _buildTappableRadioOption(
        title: "-",
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      _buildTappableRadioOption(
        title: "±",
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    ],
  );
  Widget _buildTimeSection({
    required String title,
    required DateTime timeValue,
    required VoidCallback onUpdateTime,
  }) {
    final t = AppTranslations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: labelColor)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  DateFormat(t.fullDateTimeSecondsFormat).format(timeValue),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onUpdateTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackgroundColor,
                foregroundColor: white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(t.updateTime),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectorField(
    String label,
    String value,
    VoidCallback onTap, {
    bool isRequired = false,
  }) {
    final t = AppTranslations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: labelColor),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isRequired && value.isEmpty ? Colors.red : borderColor,
              ),
            ),
            child: Text(
              value.isEmpty
                  ? (isRequired ? t.tapToSelectRequired : t.tapToSelect)
                  : value,
              style: TextStyle(
                fontSize: 16,
                color: value.isEmpty ? Colors.grey.shade500 : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTappableRadioOption({
    required String title,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) => InkWell(
    onTap: () => onChanged(title),
    borderRadius: BorderRadius.circular(4),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: title,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: primarySelectedColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(title),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Consumer<EmergencyData>(
      builder: (context, data, child) {
        return Container(
          color: pageBackground,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Original UI Sections (Simplified for brevity as they are unchanged) ---
                    _buildSectionContainer(
                      title: t.emergencyBasicInfo,
                      child: Column(
                        children: [
                          _buildTimeSection(
                            title: t.firstAidStartTime,
                            timeValue: data.firstAidStartTime ?? DateTime.now(),
                            onUpdateTime: () => data.updatePlan(
                              firstAidStartTime: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.diagnosis,
                            diagnosisController,
                            t.enterDiagnosis,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.situationDescription,
                            situationController,
                            t.enterSituationDescription,
                          ),
                        ],
                      ),
                    ),
                    _buildSectionContainer(
                      title: t.patientCondition,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.consciousness,
                            style: const TextStyle(
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildLabeledSmallTextField('E', eController),
                              const SizedBox(width: 16),
                              _buildLabeledSmallTextField('V', vController),
                              const SizedBox(width: 16),
                              _buildLabeledSmallTextField('M', mController),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.heartRate,
                            heartRateController,
                            t.enterValue,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.respirationRate,
                            respirationRateController,
                            t.enterValue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.bloodPressure,
                            style: const TextStyle(
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: bpSystolicController,
                                  onChanged: (_) => _saveToProvider(),
                                  decoration: _inputDeco(t.enterValue),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('/'),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: bpDiastolicController,
                                  onChanged: (_) => _saveToProvider(),
                                  decoration: _inputDeco(t.enterValue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.bodyTemperature,
                            style: const TextStyle(
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          Row(
                            children: [
                              _buildTappableRadioOption(
                                title: t.tempCold,
                                groupValue: data.temperature,
                                onChanged: (v) =>
                                    data.updatePlan(temperature: v),
                              ),
                              _buildTappableRadioOption(
                                title: t.tempWarm,
                                groupValue: data.temperature,
                                onChanged: (v) =>
                                    data.updatePlan(temperature: v),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.pupils,
                            style: const TextStyle(
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildLabeledSmallTextField(
                                t.leftPupilSize,
                                leftPupilSizeController,
                              ),
                              const SizedBox(width: 16),
                              _buildLabeledSmallTextField(
                                t.rightPupilSize,
                                rightPupilSizeController,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildPupilLightReflexRow(
                            label: t.leftPupilReaction,
                            groupValue: data.leftPupilReaction,
                            onChanged: (v) =>
                                data.updatePlan(leftPupilReaction: v),
                          ),
                          _buildPupilLightReflexRow(
                            label: t.rightPupilReaction,
                            groupValue: data.rightPupilReaction,
                            onChanged: (v) =>
                                data.updatePlan(rightPupilReaction: v),
                          ),
                        ],
                      ),
                    ),
                    _buildSectionContainer(
                      title: t.emergencyProcedures,
                      child: Column(
                        children: [
                          _buildTimeSection(
                            title: t.intubationStartTime,
                            timeValue:
                                data.intubationStartTime ?? DateTime.now(),
                            onUpdateTime: () => data.updatePlan(
                              intubationStartTime: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                t.intubationMethod,
                                style: const TextStyle(color: labelColor),
                              ),
                              _buildTappableRadioOption(
                                title: 'ET',
                                groupValue: data.insertionMethod,
                                onChanged: (v) =>
                                    data.updatePlan(insertionMethod: v),
                              ),
                              _buildTappableRadioOption(
                                title: 'LMA',
                                groupValue: data.insertionMethod,
                                onChanged: (v) =>
                                    data.updatePlan(insertionMethod: v),
                              ),
                              _buildTappableRadioOption(
                                title: 'Igel',
                                groupValue: data.insertionMethod,
                                onChanged: (v) =>
                                    data.updatePlan(insertionMethod: v),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.airwayContentCode,
                            airwayContentController,
                            t.enterAirwayContentCode,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.intubationRecord,
                            insertionRecordController,
                            t.enterIntubationRecord,
                          ),
                          const Divider(height: 32, thickness: 0.5),
                          _buildTimeSection(
                            title: t.onIvLineStartTime,
                            timeValue: data.onIVLineStartTime ?? DateTime.now(),
                            onUpdateTime: () => data.updatePlan(
                              onIVLineStartTime: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.ivNeedleSize,
                            ivNeedleSizeController,
                            t.enterIvNeedleSize,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.onIvLineRecord,
                            ivLineRecordController,
                            t.enterOnIvLineRecord,
                          ),
                          const Divider(height: 32, thickness: 0.5),
                          _buildTimeSection(
                            title: t.cardiacMassageStartTime,
                            timeValue:
                                data.cardiacMassageStartTime ?? DateTime.now(),
                            onUpdateTime: () => data.updatePlan(
                              cardiacMassageStartTime: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTimeSection(
                            title: t.cardiacMassageEndTime,
                            timeValue:
                                data.cardiacMassageEndTime ?? DateTime.now(),
                            onUpdateTime: () => data.updatePlan(
                              cardiacMassageEndTime: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.cardiacMassageRecord,
                            cardiacMassageRecordController,
                            t.enterCardiacMassageRecord,
                          ),
                        ],
                      ),
                    ),
                    _buildSectionContainer(
                      title: t.postResuscitationStatus,
                      child: _buildPostResuscitationStatusSection(data, t),
                    ),
                    _buildSectionContainer(
                      title: t.emergencyEndAndResult,
                      child: Column(
                        children: [
                          _buildTimeSection(
                            title: t.firstAidEndTime,
                            timeValue: data.firstAidEndTime ?? DateTime.now(),
                            onUpdateTime: () => data.updatePlan(
                              firstAidEndTime: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.firstAidEndRecord,
                            endRecordController,
                            t.enterValue,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                t.emergencyResult,
                                style: const TextStyle(color: labelColor),
                              ),
                              _buildTappableRadioOption(
                                title: t.resultReferral,
                                groupValue: data.endResult,
                                onChanged: (v) => data.updatePlan(endResult: v),
                              ),
                              _buildTappableRadioOption(
                                title: t.resultDeath,
                                groupValue: data.endResult,
                                onChanged: (v) => data.updatePlan(endResult: v),
                              ),
                              _buildTappableRadioOption(
                                title: t.other,
                                groupValue: data.endResult,
                                onChanged: (v) => data.updatePlan(endResult: v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildSectionContainer(
                      title: t.participatingPersonnel,
                      child: Column(
                        children: [
                          _buildSelectorField(
                            t.emergencyDoctor,
                            data.selectedDoctor ?? '',
                            () => _showDoctorDialog(t),
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          _buildSelectorField(
                            t.emergencyNurse,
                            data.selectedNurse ?? '',
                            () => _showNurseDialog(t),
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.nurseSignature,
                            nurseSignatureController,
                            t.signatureStamp,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          _buildSelectorField(
                            t.emergencyEMT,
                            data.selectedEMT ?? '',
                            () => _showEMTDialog(t),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            t.emtSignature,
                            emtSignatureController,
                            t.signatureStamp,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    _buildSectionContainer(
                      title: t.assistantPersonnelList,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 100),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: data.selectedAssistants.isNotEmpty
                                ? Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: data.selectedAssistants
                                        .map((name) => Chip(label: Text(name)))
                                        .toList(),
                                  )
                                : Text(
                                    t.noAssistantsSelected,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _showHelperSelectionDialog(t),
                            child: Text(
                              t.addEditAssistants,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _printPdf,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.print, color: Colors.white),
                        label: const Text(
                          "列印 / Print",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
