// lib/ReferralFormPage.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:signature/signature.dart'; // 暫時不需要簽名板功能
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/db/daos.dart';
import '../data/models/referral_data.dart';
import 'nav2.dart';
import '../l10n/app_translations.dart';

class ReferralFormPage extends StatefulWidget {
  final int visitId;

  const ReferralFormPage({super.key, required this.visitId});

  @override
  State<ReferralFormPage> createState() => _ReferralFormPageState();
}

class _ReferralFormPageState extends State<ReferralFormPage>
    with
        AutomaticKeepAliveClientMixin<ReferralFormPage>,
        SavableStateMixin<ReferralFormPage> {
  @override
  Future<void> saveData() async {
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool get wantKeepAlive => true;

  bool _isLoading = true;

  // 選項列表
  final List<String> doctorList = const [
    "方詩旋",
    "古璿正",
    "江旺財",
    "呂學政",
    "周志勇",
    "金霈歌",
    "徐丕",
    "康曉妤",
    "其他",
  ];
  final List<String> deptList = const [
    "急診醫學科",
    "不分科",
    "家醫科",
    "內科",
    "外科",
    "小兒科",
    "婦產科",
    "骨科",
    "眼科",
    "其他",
  ];
  final List<String> referralPurposes = const [
    "急診治療",
    "住院治療",
    "門診治療",
    "進一步檢查",
    "轉回轉出或適當之院所繼續追蹤",
    "其他",
  ];

  // 文字欄位控制器
  final TextEditingController contactNameCtrl = TextEditingController();
  final TextEditingController contactPhoneCtrl = TextEditingController();
  final TextEditingController contactAddressCtrl = TextEditingController();
  final TextEditingController mainDiagnosisCtrl = TextEditingController();
  final TextEditingController subDiagnosis1Ctrl = TextEditingController();
  final TextEditingController subDiagnosis2Ctrl = TextEditingController();
  final TextEditingController furtherExamCtrl = TextEditingController();
  final TextEditingController otherPurposeCtrl = TextEditingController();
  final TextEditingController handoverNotesCtrl = TextEditingController();
  final TextEditingController otherDoctorCtrl = TextEditingController();
  final TextEditingController otherDeptCtrl = TextEditingController();
  final TextEditingController appointmentDeptCtrl = TextEditingController();
  final TextEditingController appointmentRoomCtrl = TextEditingController();
  final TextEditingController appointmentNumberCtrl = TextEditingController();
  final TextEditingController referralHospitalCtrl = TextEditingController();
  final TextEditingController otherReferralDeptCtrl = TextEditingController();
  final TextEditingController referralDoctorCtrl = TextEditingController();
  final TextEditingController referralAddressCtrl = TextEditingController();
  final TextEditingController referralPhoneCtrl = TextEditingController();
  final TextEditingController relationCtrl = TextEditingController();

  final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    textStyle: const TextStyle(fontSize: 14),
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    contactNameCtrl.dispose();
    contactPhoneCtrl.dispose();
    contactAddressCtrl.dispose();
    mainDiagnosisCtrl.dispose();
    subDiagnosis1Ctrl.dispose();
    subDiagnosis2Ctrl.dispose();
    furtherExamCtrl.dispose();
    otherPurposeCtrl.dispose();
    handoverNotesCtrl.dispose();
    otherDoctorCtrl.dispose();
    otherDeptCtrl.dispose();
    appointmentDeptCtrl.dispose();
    appointmentRoomCtrl.dispose();
    appointmentNumberCtrl.dispose();
    referralHospitalCtrl.dispose();
    otherReferralDeptCtrl.dispose();
    referralDoctorCtrl.dispose();
    referralAddressCtrl.dispose();
    referralPhoneCtrl.dispose();
    relationCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final dao = context.read<ReferralFormsDao>();
      final referralData = context.read<ReferralData>();
      final record = await dao.getByVisitId(widget.visitId);

      if (!mounted) return;

      if (record != null) {
        referralData.contactName = record.contactName;
        referralData.contactPhone = record.contactPhone;
        referralData.contactAddress = record.contactAddress;
        referralData.mainDiagnosis = record.mainDiagnosis;
        referralData.subDiagnosis1 = record.subDiagnosis1;
        referralData.subDiagnosis2 = record.subDiagnosis2;
        referralData.lastExamDate = record.lastExamDate;
        referralData.lastMedicationDate = record.lastMedicationDate;
        referralData.referralPurposeIdx = record.referralPurposeIdx;
        referralData.furtherExamDetail = record.furtherExamDetail;
        referralData.otherPurposeDetail = record.otherPurposeDetail;
        referralData.handoverNotes = record.handoverNotes;
        referralData.doctorIdx = record.doctorIdx;
        referralData.otherDoctorName = record.otherDoctorName;
        referralData.deptIdx = record.deptIdx;
        referralData.otherDeptName = record.otherDeptName;
        referralData.doctorSignature = record.doctorSignature;
        referralData.issueDate = record.issueDate;
        referralData.appointmentDate = record.appointmentDate;
        referralData.appointmentDept = record.appointmentDept;
        referralData.appointmentRoom = record.appointmentRoom;
        referralData.appointmentNumber = record.appointmentNumber;
        referralData.referralHospitalName = record.referralHospitalName;
        referralData.referralDeptIdx = record.referralDeptIdx;
        referralData.otherReferralDept = record.otherReferralDept;
        referralData.referralDoctorName = record.referralDoctorName;
        referralData.referralAddress = record.referralAddress;
        referralData.referralPhone = record.referralPhone;
        referralData.consentSignature = record.consentSignature;
        referralData.relationToPatient = record.relationToPatient;
        referralData.consentDateTime = record.consentDateTime;

        // [修正] 移除從資料庫讀取 selectedICD10 的部分，避免 getter 錯誤
        // 這些資料如果資料庫還沒開欄位，就暫時不從 DB 讀取
        // referralData.selectedICD10Main = record.selectedICD10Main;
        // referralData.selectedICD10Sub1 = record.selectedICD10Sub1;
        // referralData.selectedICD10Sub2 = record.selectedICD10Sub2;

        referralData.update();
      } else {
        final now = DateTime.now();
        referralData.issueDate = now;
        referralData.appointmentDate = now;
        referralData.lastExamDate = now;
        referralData.lastMedicationDate = now;
        referralData.consentDateTime = now;
        referralData.update();
      }
      _syncControllersFromData(referralData);
    } catch (e) {
      debugPrint('Error loading: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _syncControllersFromData(ReferralData data) {
    contactNameCtrl.text = data.contactName ?? '';
    contactPhoneCtrl.text = data.contactPhone ?? '';
    contactAddressCtrl.text = data.contactAddress ?? '';
    mainDiagnosisCtrl.text = data.mainDiagnosis ?? '';
    subDiagnosis1Ctrl.text = data.subDiagnosis1 ?? '';
    subDiagnosis2Ctrl.text = data.subDiagnosis2 ?? '';
    furtherExamCtrl.text = data.furtherExamDetail ?? '';
    otherPurposeCtrl.text = data.otherPurposeDetail ?? '';
    handoverNotesCtrl.text = data.handoverNotes ?? '';
    otherDoctorCtrl.text = data.otherDoctorName ?? '';
    otherDeptCtrl.text = data.otherDeptName ?? '';
    appointmentDeptCtrl.text = data.appointmentDept ?? '';
    appointmentRoomCtrl.text = data.appointmentRoom ?? '';
    appointmentNumberCtrl.text = data.appointmentNumber ?? '';
    referralHospitalCtrl.text = data.referralHospitalName ?? '';
    otherReferralDeptCtrl.text = data.otherReferralDept ?? '';
    referralDoctorCtrl.text = data.referralDoctorName ?? '';
    referralAddressCtrl.text = data.referralAddress ?? '';
    referralPhoneCtrl.text = data.referralPhone ?? '';
    relationCtrl.text = data.relationToPatient ?? '';
  }

  void _syncControllersToData() {
    final data = context.read<ReferralData>();
    data.contactName = contactNameCtrl.text;
    data.contactPhone = contactPhoneCtrl.text;
    data.contactAddress = contactAddressCtrl.text;
    data.mainDiagnosis = mainDiagnosisCtrl.text;
    data.subDiagnosis1 = subDiagnosis1Ctrl.text;
    data.subDiagnosis2 = subDiagnosis2Ctrl.text;
    data.furtherExamDetail = furtherExamCtrl.text;
    data.otherPurposeDetail = otherPurposeCtrl.text;
    data.handoverNotes = handoverNotesCtrl.text;
    data.otherDoctorName = otherDoctorCtrl.text;
    data.otherDeptName = otherDeptCtrl.text;
    data.appointmentDept = appointmentDeptCtrl.text;
    data.appointmentRoom = appointmentRoomCtrl.text;
    data.appointmentNumber = appointmentNumberCtrl.text;
    data.referralHospitalName = referralHospitalCtrl.text;
    data.otherReferralDept = otherReferralDeptCtrl.text;
    data.referralDoctorName = referralDoctorCtrl.text;
    data.referralAddress = referralAddressCtrl.text;
    data.referralPhone = referralPhoneCtrl.text;
    data.relationToPatient = relationCtrl.text;
  }

  Future<void> _saveData() async {
    final referralDao = context.read<ReferralFormsDao>();
    final visitsDao = context.read<VisitsDao>();
    final referralData = context.read<ReferralData>();
    await referralData.saveToDatabase(widget.visitId, referralDao, visitsDao);
  }

  // ===========================================================================
  // PDF 列印與生成邏輯
  // ===========================================================================
  Future<void> _printPdf() async {
    _syncControllersToData();
    await _saveData();

    final refData = context.read<ReferralData>();

    String patientName = "";
    String gender = "";
    DateTime? dob;
    String idNo = "";

    try {
      final visitsDao = context.read<VisitsDao>();
      final profileDao = context.read<PatientProfilesDao>();
      final visit = await visitsDao.getVisit(widget.visitId);
      if (visit != null) patientName = visit.patientName ?? "";
      final profile = await profileDao.getByVisitId(widget.visitId);
      if (profile != null) {
        dob = profile.birthday;
        gender = profile.gender ?? "";
        idNo = (profile.idNumber != null && profile.idNumber!.isNotEmpty)
            ? profile.idNumber!
            : (profile.passportNumber ?? "");
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
                refData: refData,
                patientName: patientName,
                gender: gender,
                dob: dob,
                idNo: idNo,
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
    required ReferralData refData,
    required String patientName,
    required String gender,
    required DateTime? dob,
    required String idNo,
  }) {
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 18);
    final subTitleStyle = pw.TextStyle(font: fontBold, fontSize: 14);
    final bodyStyle = pw.TextStyle(font: font, fontSize: 10);
    final smallStyle = pw.TextStyle(font: font, fontSize: 8);
    final border = pw.TableBorder.all(width: 0.5, color: PdfColors.black);

    // Helpers
    String fmtDate(DateTime? dt) =>
        dt == null ? "" : "${dt.year}年${dt.month}月${dt.day}日";
    String fmtDateShort(DateTime? dt) =>
        dt == null ? "" : "${dt.year}/${dt.month}/${dt.day}";
    String check(bool cond) => cond ? "■" : "□";

    String physicianName =
        (refData.doctorIdx != null && refData.doctorIdx! < doctorList.length)
        ? (doctorList[refData.doctorIdx!] == "其他"
              ? (refData.otherDoctorName ?? "")
              : doctorList[refData.doctorIdx!])
        : "";
    String deptName =
        (refData.deptIdx != null && refData.deptIdx! < deptList.length)
        ? (deptList[refData.deptIdx!] == "其他"
              ? (refData.otherDeptName ?? "")
              : deptList[refData.deptIdx!])
        : "";
    String refDeptName =
        (refData.referralDeptIdx != null &&
            refData.referralDeptIdx! < deptList.length)
        ? (deptList[refData.referralDeptIdx!] == "其他"
              ? (refData.otherReferralDept ?? "")
              : deptList[refData.referralDeptIdx!])
        : "";

    return pw.Column(
      children: [
        pw.Text("全民健康保險聯新國際醫院桃園國際機場醫療中心轉診單", style: titleStyle),
        pw.SizedBox(height: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text("(轉診至", style: subTitleStyle),
            pw.SizedBox(width: 150),
            pw.Text("院所)", style: subTitleStyle),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            "保險醫事服務機構代碼：3432060513",
            style: pw.TextStyle(font: fontBold, fontSize: 12),
          ),
        ),
        pw.SizedBox(height: 5),

        // ================== MAIN TABLE ==================
        pw.Table(
          border: border,
          columnWidths: {
            0: const pw.FixedColumnWidth(25),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            // Row 1: Basic Info
            pw.TableRow(
              children: [
                _verticalTextCell("基本資料", font, height: 60),
                pw.Column(
                  children: [
                    pw.Table(
                      border: border,
                      columnWidths: {
                        0: const pw.FixedColumnWidth(60),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FixedColumnWidth(40),
                        3: const pw.FixedColumnWidth(60),
                        4: const pw.FixedColumnWidth(60),
                        5: const pw.FlexColumnWidth(1),
                        6: const pw.FixedColumnWidth(70),
                        7: const pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            _labelCell("姓名", font),
                            _textCell(patientName, font),
                            _labelCell("性別", font),
                            _textCell(
                              "${check(gender == '男')}男 ${check(gender == '女')}女",
                              font,
                            ),
                            _labelCell("出生日期", font),
                            _textCell(fmtDate(dob), font),
                            _labelCell("身分證字號", font),
                            _textCell(idNo, font),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            _labelCell("聯絡人", font),
                            _textCell(refData.contactName ?? "", font),
                            _labelCell("聯絡電話", font, colSpan: 2),
                            _textCell(refData.contactPhone ?? "", font),
                            _labelCell("聯絡地址", font),
                            _textCell(
                              refData.contactAddress ?? "",
                              font,
                              colSpan: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Row 2: Origin Hospital
            pw.TableRow(
              children: [
                _verticalTextCell("原\n診\n治\n醫\n院", font, height: 350),
                pw.Column(
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 5,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(4),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(width: 0.5),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "A.病情摘要(主訴、簡短病史)",
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 10,
                                  ),
                                ),
                                pw.Text(
                                  refData.handoverNotes ?? "",
                                  style: bodyStyle,
                                  maxLines: 4,
                                ),
                                pw.SizedBox(height: 10),
                                pw.Text(
                                  "B.診斷 ICD-10-CM/PCS 病名",
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 10,
                                  ),
                                ),
                                pw.Text(
                                  "1.(主診斷): ${refData.mainDiagnosis ?? ''} ${refData.selectedICD10Main ?? ''}",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "2. ${refData.subDiagnosis1 ?? ''} ${refData.selectedICD10Sub1 ?? ''}",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "3. ${refData.subDiagnosis2 ?? ''} ${refData.selectedICD10Sub2 ?? ''}",
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 5,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "D.藥物過敏史",
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 10,
                                  ),
                                ),
                                pw.Text(
                                  "□無, □有(請詳述)_______________",
                                  style: bodyStyle,
                                ),
                                pw.SizedBox(height: 20),
                                pw.Text(
                                  "E.醫師交班注意事項",
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: 10,
                                  ),
                                ),
                                pw.Text(
                                  refData.handoverNotes ?? "",
                                  style: bodyStyle,
                                  maxLines: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(height: 1, thickness: 0.5),

                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "C. 檢查及治療摘要",
                            style: pw.TextStyle(font: fontBold, fontSize: 10),
                          ),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  "1.最近一次檢查結果  日期: ${fmtDateShort(refData.lastExamDate)}",
                                  style: bodyStyle,
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  "2.最近一次用藥或手術名稱  日期: ${fmtDateShort(refData.lastMedicationDate)}",
                                  style: bodyStyle,
                                ),
                              ),
                            ],
                          ),
                          pw.Text(
                            "報告：${refData.furtherExamDetail ?? ''}",
                            style: bodyStyle,
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(height: 1, thickness: 0.5),

                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("轉\n診\n目\n的", style: smallStyle),
                          pw.SizedBox(width: 8),
                          pw.Expanded(
                            child: pw.Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                pw.Text(
                                  "${check(refData.referralPurposeIdx == 0)}1.急診治療",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "${check(refData.referralPurposeIdx == 1)}2.住院治療",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "${check(refData.referralPurposeIdx == 2)}3.門診治療",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "${check(refData.referralPurposeIdx == 3)}4.進一步檢查",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "${check(refData.referralPurposeIdx == 4)}5.轉回轉出或適當之院所繼續追蹤",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "${check(refData.referralPurposeIdx == 5)}6.其他 ${refData.otherPurposeDetail ?? ''}",
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(height: 1, thickness: 0.5),

                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            "經醫師解釋病情及轉診目的後同意轉院。",
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 10,
                              color: PdfColors.red,
                            ),
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text(
                                    "同意人簽名: ",
                                    style: pw.TextStyle(
                                      font: fontBold,
                                      fontSize: 10,
                                      color: PdfColors.red,
                                    ),
                                  ),
                                  if (refData.consentSignature != null)
                                    pw.Image(
                                      pw.MemoryImage(refData.consentSignature!),
                                      height: 20,
                                    ),
                                ],
                              ),
                              pw.Text(
                                "與病人關係: ${refData.relationToPatient ?? ''}",
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: 10,
                                  color: PdfColors.red,
                                ),
                              ),
                              pw.Text(
                                "日期: ${fmtDate(refData.consentDateTime)}",
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: 10,
                                  color: PdfColors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(height: 1, thickness: 0.5),

                    pw.Table(
                      border: border,
                      columnWidths: {
                        0: const pw.FixedColumnWidth(40),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FixedColumnWidth(40),
                        3: const pw.FixedColumnWidth(80),
                        4: const pw.FixedColumnWidth(40),
                        5: const pw.FixedColumnWidth(100),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            _labelCell("院所地址", font),
                            _textCell("337桃園市大園區航站南路9號及15號", font),
                            _labelCell("聯絡\n電話", font),
                            _textCell(
                              "03-3983456",
                              font,
                              align: pw.Alignment.center,
                            ),
                            _labelCell("醫師簽章", font),
                            pw.Container(
                              height: 30,
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(2),
                              child: refData.doctorSignature != null
                                  ? pw.Image(
                                      pw.MemoryImage(refData.doctorSignature!),
                                      height: 25,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.Table(
                      border: border,
                      columnWidths: {
                        0: const pw.FixedColumnWidth(30),
                        1: const pw.FixedColumnWidth(30),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FixedColumnWidth(30),
                        4: const pw.FlexColumnWidth(1),
                        5: const pw.FixedColumnWidth(30),
                        6: const pw.FixedColumnWidth(80),
                        7: const pw.FixedColumnWidth(30),
                        8: const pw.FlexColumnWidth(1),
                        9: const pw.FixedColumnWidth(40),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            _labelCell("診治", font, rowSpan: 2),
                            _labelCell("醫師", font),
                            _textCell(physicianName, font),
                            _labelCell("科別", font),
                            _textCell(deptName, font),
                            _labelCell("聯絡\n電話", font),
                            _textCell("03-3983456", font),
                            _labelCell("西元", font),
                            _textCell(fmtDate(refData.appointmentDate), font),
                            _labelCell("科\n診\n號", font, rowSpan: 2),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            _labelCell("開單\n日期", font),
                            _textCell(
                              fmtDate(refData.issueDate),
                              font,
                              colSpan: 2,
                            ),
                            _labelCell("安排就醫日期", font, colSpan: 2),
                            _textCell(
                              fmtDate(refData.appointmentDate),
                              font,
                              colSpan: 3,
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.Table(
                      border: border,
                      columnWidths: {
                        0: const pw.FixedColumnWidth(60),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FixedColumnWidth(40),
                        3: const pw.FlexColumnWidth(0.5),
                        4: const pw.FixedColumnWidth(40),
                        5: const pw.FlexColumnWidth(0.5),
                        6: const pw.FixedColumnWidth(70),
                        7: const pw.FlexColumnWidth(1),
                        8: const pw.FixedColumnWidth(30),
                        9: const pw.FlexColumnWidth(0.8),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            _labelCell("建議轉診\n院所科別", font, rowSpan: 1),
                            _labelCell("醫院", font),
                            _textCell(refData.referralHospitalName ?? "", font),
                            _labelCell("科", font),
                            _textCell(refDeptName, font),
                            _labelCell("醫師", font),
                            _textCell(refData.referralDoctorName ?? "", font),
                            _labelCell("轉診所地址\n及專線電話", font),
                            _labelCell("地址:\n電話:", font, fontSize: 8),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  refData.referralAddress ?? "",
                                  style: smallStyle,
                                ),
                                pw.Text(
                                  refData.referralPhone ?? "",
                                  style: smallStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Row 3: Receiving Hospital
            pw.TableRow(
              children: [
                _verticalTextCell("接\n受\n轉\n診\n醫\n院", font, height: 150),
                pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        _pCell(
                          "處\n理\n情\n形",
                          font,
                          width: 25,
                          align: pw.Alignment.center,
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(4),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                left: pw.BorderSide(width: 0.5),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "1.□已予急診處置並轉診至__________醫院",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "2.□已予急診處置，並住本院________病房治療中",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "3.□已安排住本院______________病房治療中",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "4.□已安排本院________________科門診治療中",
                                  style: bodyStyle,
                                ),
                                pw.Text(
                                  "5.□已予適當處置並轉回原院所，建議事項如下  6.□其他",
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(height: 1, thickness: 0.5),

                    pw.Row(
                      children: [
                        _pCell(
                          "診\n斷\n醫\n療\n摘\n要",
                          font,
                          width: 25,
                          align: pw.Alignment.center,
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 60,
                            padding: const pw.EdgeInsets.all(4),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                left: pw.BorderSide(width: 0.5),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text("1.主診斷", style: bodyStyle),
                                    pw.Text("2.治療藥物或手術名稱", style: bodyStyle),
                                    pw.Text("3.輔助診斷之檢查結果", style: bodyStyle),
                                  ],
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  "ICD-10-CM/PCS: ______________   病名: ______________",
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(height: 1, thickness: 0.5),

                    pw.Table(
                      border: border,
                      columnWidths: {
                        0: const pw.FixedColumnWidth(25),
                        1: const pw.FlexColumnWidth(1),
                        2: const pw.FlexColumnWidth(1.5),
                        3: const pw.FixedColumnWidth(30),
                        4: const pw.FixedColumnWidth(40),
                        5: const pw.FixedColumnWidth(30),
                        6: const pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            _labelCell("院所\n名稱", font),
                            _textCell("", font),
                            _pCell("電話或傳真:\n電子信箱:", font),
                            _labelCell("科\n別", font),
                            _textCell("", font),
                            _labelCell("回覆\n日期", font),
                            _pCell(
                              "    年    月    日",
                              font,
                              align: pw.Alignment.center,
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            _labelCell("診治\n醫師", font),
                            _textCell("", font),
                            _pCell("", font),
                            _labelCell("醫師\n簽章", font),
                            _textCell("", font, colSpan: 3),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("62-P-004-R15", style: smallStyle),
            pw.Text("聯新(R905)2020/09x500 張", style: smallStyle),
          ],
        ),
      ],
    );
  }

  // --- PDF Helper Widgets ---
  pw.Widget _labelCell(
    String text,
    pw.Font font, {
    int colSpan = 1,
    int rowSpan = 1,
    double? fontSize,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: fontSize ?? 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _textCell(
    String text,
    pw.Font font, {
    int colSpan = 1,
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      alignment: align,
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 10)),
    );
  }

  pw.Widget _verticalTextCell(String text, pw.Font font, {double? height}) {
    return pw.Container(
      height: height,
      padding: const pw.EdgeInsets.symmetric(horizontal: 2),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _pCell(
    String text,
    pw.Font font, {
    pw.Alignment align = pw.Alignment.centerLeft,
    int colSpan = 1,
    int rowSpan = 1,
    double? width,
    double? height,
    double fontSize = 10,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Consumer<ReferralData>(
      builder: (context, data, _) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(158, 158, 158, 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 第一部分：聯絡人 ---
                  Text(
                    t.contactPersonInfo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow(
                    t,
                    t.contactName,
                    t.enterContactName,
                    contactNameCtrl,
                    style: "outline",
                    width: 450,
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow(
                    t,
                    t.contactPhoneNumber,
                    t.enterContactPhone,
                    contactPhoneCtrl,
                    style: "outline",
                    width: 450,
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow(
                    t,
                    t.contactAddressLabel,
                    t.enterContactAddress,
                    contactAddressCtrl,
                    style: "outline",
                    width: 450,
                  ),
                  const Divider(thickness: 1, height: 32),

                  // --- 第二部分：診斷 ---
                  Text(
                    t.diagnosisIcd10,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('主診斷的ICD-10'),
                  _buildICD10Selector("主診斷", data.selectedICD10Main, (v) {
                    data.selectedICD10Main = v;
                    data.update();
                  }, actionButtonStyle),
                  const SizedBox(height: 24),
                  _SectionTitle('副診斷1的ICD-10'),
                  _buildICD10Selector("副診斷1", data.selectedICD10Sub1, (v) {
                    data.selectedICD10Sub1 = v;
                    data.update();
                  }, actionButtonStyle),
                  const SizedBox(height: 24),
                  _SectionTitle('副診斷2的ICD-10'),
                  _buildICD10Selector("副診斷2", data.selectedICD10Sub2, (v) {
                    data.selectedICD10Sub2 = v;
                    data.update();
                  }, actionButtonStyle),
                  const SizedBox(height: 16),

                  // 左卡：摘要日期 / 右卡：轉診目的
                  Row(
                    children: [
                      Expanded(child: _buildLeftCard(t, data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightCard(t, data)),
                    ],
                  ),

                  // 醫師交班
                  const SizedBox(height: 16),
                  _buildHandoverNotesCard(t, data),
                  const Divider(thickness: 1, height: 32),

                  // --- 第三部分：醫師資訊 ---
                  Text(
                    t.treatingPhysicianName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    t,
                    t.physicianName,
                    doctorList,
                    data.doctorIdx,
                    (idx) {
                      data.doctorIdx = idx;
                      data.update();
                    },
                  ),
                  if (data.doctorIdx == doctorList.indexOf("其他"))
                    _buildInputRow(
                      t,
                      "${t.other}：",
                      t.enterName,
                      otherDoctorCtrl,
                      style: "outline",
                    ),
                  const SizedBox(height: 12),
                  Text(
                    t.treatingPhysicianDept,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildDropdown(t, t.physicianDept, deptList, data.deptIdx, (
                    idx,
                  ) {
                    data.deptIdx = idx;
                    data.update();
                  }),
                  if (data.deptIdx == deptList.indexOf("其他"))
                    _buildInputRow(
                      t,
                      "${t.other}：",
                      t.enterDeptName,
                      otherDeptCtrl,
                    ),
                  const SizedBox(height: 12),
                  Text(
                    t.treatingPhysicianSignature,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // 簽名板 (已改為純顯示框，無 onTap)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: data.doctorSignature == null
                        ? Text(
                            t.tapToSign + " (停用)",
                            style: const TextStyle(color: Colors.grey),
                          )
                        : Image.memory(data.doctorSignature!),
                  ),
                  const Divider(thickness: 1, height: 32),

                  // --- 第四部分：轉診院所 ---
                  Row(
                    children: [
                      Expanded(child: _buildLeftCard4(t, data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightCard4(t, data)),
                    ],
                  ),
                  const Divider(thickness: 1, height: 32),

                  // --- 同意書 ---
                  Text(
                    t.consentStatement,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.consentPersonSignature,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // 簽名板 (已改為純顯示框，無 onTap)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: data.consentSignature == null
                        ? Text(
                            t.tapToSign + " (停用)",
                            style: const TextStyle(color: Colors.grey),
                          )
                        : Image.memory(data.consentSignature!),
                  ),
                  const SizedBox(height: 12),
                  _buildInputRow(
                    t,
                    t.relationToPatientLabel,
                    t.enterRelation,
                    relationCtrl,
                    style: "underline",
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${t.signatureDateTime}${_formatDateTime(t, data.consentDateTime ?? DateTime.now())}",
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          data.consentDateTime = DateTime.now();
                          data.update();
                        },
                        child: Text(t.updateTimeButton),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF83ACA9),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  // --- 列印按鈕 ---
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _printPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF83ACA9),
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
        );
      },
    );
  }

  // ================= UI 小積木 =================

  Widget _buildInputRow(
    AppTranslations t,
    String label,
    String hint,
    TextEditingController ctrl, {
    String style = "underline",
    double? width,
  }) {
    InputBorder getBorder() => style == "outline"
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          )
        : style == "none"
        ? InputBorder.none
        : const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          );
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: width ?? (hint.length * 15.0 + 100),
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              enabledBorder: getBorder(),
              focusedBorder: getBorder(),
            ),
            onChanged: (_) => _syncControllersToData(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    AppTranslations t,
    String label,
    List<String> items,
    int? selectedIdx,
    Function(int) onChanged,
  ) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<int>(
            value: selectedIdx,
            items: List.generate(
              items.length,
              (i) => DropdownMenuItem(value: i, child: Text(items[i])),
            ),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftCard(AppTranslations t, ReferralData data) => Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.examTreatmentSummary,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(t.lastExamResultDate),
        TextButton(
          onPressed: () => _pickDate(context, (d) {
            data.lastExamDate = d;
            data.update();
          }),
          child: Text(_formatDate(t, data.lastExamDate ?? DateTime.now())),
        ),
        const SizedBox(height: 8),
        Text(t.lastMedicationSurgeryDate),
        TextButton(
          onPressed: () => _pickDate(context, (d) {
            data.lastMedicationDate = d;
            data.update();
          }),
          child: Text(
            _formatDate(t, data.lastMedicationDate ?? DateTime.now()),
          ),
        ),
      ],
    ),
  );

  Widget _buildRightCard(AppTranslations t, ReferralData data) => Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.referralPurpose,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            referralPurposes.length,
            (index) => RadioListTile<int>(
              title: Text(referralPurposes[index]),
              value: index,
              groupValue: data.referralPurposeIdx,
              onChanged: (val) {
                if (val != null) {
                  data.referralPurposeIdx = val;
                  data.update();
                }
              },
              activeColor: const Color(0xFF83ACA9),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        ),
        if (data.referralPurposeIdx == referralPurposes.indexOf("其他"))
          _buildInputRow(
            t,
            "${t.other}：",
            t.enterOtherPurpose,
            otherPurposeCtrl,
          ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.furtherExamination,
          t.enterExamItem,
          furtherExamCtrl,
        ),
      ],
    ),
  );

  Widget _buildHandoverNotesCard(AppTranslations t, ReferralData data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.isZh ? "醫師交班注意事項\n(生命徵象會自動帶入轉診單)" : "Physician Handover Notes",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: handoverNotesCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: t.isZh ? "請填寫交班注意事項..." : "Enter notes...",
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
              onChanged: (_) => _syncControllersToData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftCard4(AppTranslations t, ReferralData data) => Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.issueDate, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => _pickDate(context, (d) {
            data.issueDate = d;
            data.update();
          }),
          child: Text(
            "${t.dateLabel}${_formatDate(t, data.issueDate ?? DateTime.now())}",
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.appointmentDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => _pickDate(context, (d) {
            data.appointmentDate = d;
            data.update();
          }),
          child: Text(
            "${t.dateLabel}${_formatDate(t, data.appointmentDate ?? DateTime.now())}",
          ),
        ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.appointmentDepartment,
          t.enterAppointmentDept,
          appointmentDeptCtrl,
          style: "none",
        ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.appointmentRoom,
          t.enterAppointmentRoom,
          appointmentRoomCtrl,
          style: "none",
        ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.appointmentNumberLabel,
          t.enterAppointmentNumber,
          appointmentNumberCtrl,
          style: "none",
        ),
      ],
    ),
  );

  Widget _buildRightCard4(AppTranslations t, ReferralData data) => Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputRow(
          t,
          t.recommendedReferralHospital,
          t.enterPrimaryDiagnosis,
          referralHospitalCtrl,
          style: "none",
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          t,
          t.recommendedHospitalDept,
          deptList,
          data.referralDeptIdx,
          (idx) {
            data.referralDeptIdx = idx;
            data.update();
          },
        ),
        if (data.referralDeptIdx == deptList.indexOf("其他"))
          _buildInputRow(
            t,
            "${t.other}：",
            t.enterDeptName,
            otherReferralDeptCtrl,
          ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.recommendedHospitalPhysician,
          t.enterHospitalPhysician,
          referralDoctorCtrl,
          style: "none",
        ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.recommendedHospitalAddress,
          t.enterHospitalAddress,
          referralAddressCtrl,
          style: "none",
        ),
        const SizedBox(height: 8),
        _buildInputRow(
          t,
          t.recommendedHospitalPhone,
          t.enterHospitalPhone,
          referralPhoneCtrl,
          style: "none",
        ),
      ],
    ),
  );

  Future<void> _pickDate(
    BuildContext context,
    ValueChanged<DateTime> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onPicked(picked);
  }

  String _formatDate(AppTranslations t, DateTime dt) => t.formatDate(dt);
  String _formatDateTime(AppTranslations t, DateTime dt) => t.formatDate(dt);

  Widget _buildICD10Selector(
    String label,
    String? selectedCode,
    ValueChanged<String?> onSelected, [
    ButtonStyle? actionButtonStyle,
  ]) {
    final t = AppTranslations.of(context);
    Future<String?> _openDialog(String initial) async {
      final controller = TextEditingController(text: initial);
      return showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t.selectIcd10),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: t.isZh ? '輸入代碼或名稱' : 'Enter code/name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                controller.text.trim().isEmpty ? null : controller.text.trim(),
              ),
              child: Text(t.confirm),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () async {
              final code = await _openDialog(selectedCode ?? '');
              if (code != null) {
                onSelected(code);
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(selectedCode ?? (t.isZh ? '尚未選擇' : 'Not selected')),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final code = await _openDialog(selectedCode ?? '');
            if (code != null) {
              onSelected(code);
              setState(() {});
            }
          },
          child: Text(t.isZh ? '選擇' : 'Select'),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF83ACA9),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );
}
