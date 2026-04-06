import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReferralReportData {
  // 轉診至
  String referToHospital = '';

  // 基本資料
  String name = '';
  String gender = ''; // 男/女
  String birthYear = '';
  String birthMonth = '';
  String birthDay = '';
  String idNo = '';
  String contact = '';
  String contactPhone = '';
  String contactAddress = '';

  // 診病歷摘要
  String chiefComplaintHistory = ''; // A. 病情摘要
  String diagnosisICD = ''; // B. ICD-10-CM/PCS
  String diagnosisName1 = ''; // 主診斷
  String diagnosisName2 = '';
  String diagnosisName3 = '';
  String lastExamResult = ''; // C. 最近一次檢查
  String lastExamDate = '';
  String lastExamReport = '';
  String lastMedOrSurgery = ''; // 最近一次用藥或手術
  String lastMedDate = '';
  bool allergyNone = false; // D. 藥物過敏史
  bool allergyHas = false;
  String allergyDetail = '';
  String doctorHandoverNote = ''; // E. 醫師交班注意事項

  // 轉診目的
  bool purposeEmergency = false;
  bool purposeHospital = false;
  bool purposeClinic = false;
  bool purposeFurtherExam = false;
  String furtherExamItems = '';
  bool purposeFollowUp = false;
  bool purposeOther = false;
  String purposeOtherText = '';

  // 知情同意
  String consentSignName = '';
  String consentRelationship = '';
  String consentYear = '';
  String consentMonth = '';
  String consentDay = '';
  String consentHour = '';
  String consentMin = '';

  // 診治醫師（原診所）
  String doctorName = '';
  String doctorDept = '';
  String doctorPhone = '03-3983456';
  String issueDateYear = '';
  String issueDateMonth = '';
  String issueDateDay = '';
  String appointDateYear = '';
  String appointDateMonth = '';
  String appointDateDay = '';
  String appointDept = '';
  String appointNo = '';

  // 建議轉診院所
  String referHospital = '';
  String referDept = '';
  String referDoctor = '';
  String referHospAddress = '';
  String referHospPhone = '';

  // 接受轉診醫院（下半部）
  // 處理情形
  bool recvEmergencyTransfer = false;
  String recvEmergencyHospital = '';
  bool recvEmergencyAdmit = false;
  String recvEmergencyAdmitWard = '';
  bool recvAdmit = false;
  String recvAdmitWard = '';
  bool recvClinicArranged = false;
  String recvClinicDept = '';
  bool recvSendBack = false;
  String recvSendBackNote = '';
  bool recvOther = false;
  String recvOtherText = '';

  // 治療摘要
  String recvMainDiagICD = '';
  String recvMainDiagName = '';
  String recvTreatmentMed = '';
  String recvAuxExamResult = '';

  // 接受轉診醫院資訊
  String recvHospName = '';
  String recvHospPhone = '';
  String recvHospEmail = '';
  String recvDoctorName = '';
  String recvDept = '';
  String recvReturnYear = '';
  String recvReturnMonth = '';
  String recvReturnDay = '';
}

Future<Uint8List> buildReferralReportPdf(ReferralReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pw.TextStyle ts({double sz = 7.5, bool bold = false, PdfColor? c}) =>
      pw.TextStyle(
        font: bold ? fontB : font,
        fontSize: sz,
        color: c ?? PdfColors.black,
      );

  const bdr = pw.BorderSide(width: 0.5, color: PdfColors.black);
  const tbl = pw.TableBorder(
    top: bdr,
    bottom: bdr,
    left: bdr,
    right: bdr,
    horizontalInside: bdr,
    verticalInside: bdr,
  );
  const tblNoLeft = pw.TableBorder(
    top: bdr,
    bottom: bdr,
    left: pw.BorderSide.none,
    right: bdr,
    horizontalInside: bdr,
    verticalInside: bdr,
  );
  const innerTbl = pw.TableBorder(horizontalInside: bdr, verticalInside: bdr);

  pw.Widget cell(
    String t, {
    bool bold = false,
    pw.Alignment? align,
    double sz = 7.5,
    double? h,
    PdfColor? bg,
    pw.EdgeInsets? pad,
  }) => pw.Container(
    height: h,
    color: bg,
    padding: pad ?? const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    alignment: align ?? pw.Alignment.centerLeft,
    child: pw.Text(
      t,
      style: ts(bold: bold, sz: sz),
    ),
  );

  pw.Widget chk(bool checked, String label) => pw.Row(
    children: [
      pw.Container(
        width: 8,
        height: 8,
        margin: const pw.EdgeInsets.only(right: 2),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
        child: checked ? pw.Container(color: PdfColors.black) : null,
      ),
      pw.Text(label, style: ts()),
      pw.SizedBox(width: 3),
    ],
  );

  pw.Widget uv(
    String val, {
    double w = 20,
    bool center = false,
    double sz = 7.5,
  }) => pw.Container(
    width: w * PdfPageFormat.mm,
    alignment: center ? pw.Alignment.center : pw.Alignment.centerLeft,
    child: pw.Text(val, style: ts(sz: sz)),
  );
  pw.Widget uvLine(String val, double width) => pw.Container(
    width: width,
    child: pw.Text(val, style: ts()),
  );

  pw.Widget gridCellWidgetW(
    pw.Widget child,
    double width, {
    bool left = false,
    bool right = true,
    bool top = false,
    bool bottom = true,
    pw.EdgeInsets? pad,
    pw.Alignment? align,
  }) => pw.Container(
    width: width,
    padding: pad ?? const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    alignment: align ?? pw.Alignment.centerLeft,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        left: left ? bdr : pw.BorderSide.none,
        right: right ? bdr : pw.BorderSide.none,
        top: top ? bdr : pw.BorderSide.none,
        bottom: bottom ? bdr : pw.BorderSide.none,
      ),
    ),
    child: child,
  );

  pw.Widget gridCellTextW(
    String text,
    double width, {
    bool bold = false,
    bool left = false,
    bool right = true,
    bool top = false,
    bool bottom = true,
    pw.EdgeInsets? pad,
    pw.Alignment? align,
  }) => gridCellWidgetW(
    pw.Text(text, style: ts(bold: bold)),
    width,
    left: left,
    right: right,
    top: top,
    bottom: bottom,
    pad: pad,
    align: align,
  );

  pw.Widget box(
    pw.Widget child, {
    required double width,
    required double height,
    bool left = false,
    bool right = true,
    bool top = false,
    bool bottom = true,
    pw.EdgeInsets? pad,
    pw.Alignment? align,
  }) => pw.Container(
    width: width,
    height: height,
    padding: pad ?? const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    alignment: align ?? pw.Alignment.centerLeft,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        left: left ? bdr : pw.BorderSide.none,
        right: right ? bdr : pw.BorderSide.none,
        top: top ? bdr : pw.BorderSide.none,
        bottom: bottom ? bdr : pw.BorderSide.none,
      ),
    ),
    child: child,
  );

  pw.FixedColumnWidth colW(double value) => pw.FixedColumnWidth(value);
  pw.FlexColumnWidth flexW([double value = 1]) => pw.FlexColumnWidth(value);
  final contentWidth =
      PdfPageFormat.a4.width - 20 * PdfPageFormat.mm; // page minus margins
  final leftColW = 8 * PdfPageFormat.mm;
  final midColW = 8 * PdfPageFormat.mm;
  final rightColW = contentWidth - leftColW - midColW;
  final mainRightWidth = rightColW;
  final halfRightWidth = (mainRightWidth - 8) / 2;
  final lineShort = halfRightWidth * 0.5;
  final lineLong = mainRightWidth * 0.6;
  final linePurpose = halfRightWidth * 0.55;
  final lineHospital = mainRightWidth * 0.55;
  final lineOther = mainRightWidth * 0.35;

  final basicUnit = mainRightWidth / 72;
  final basicNameW = basicUnit * 20;
  final basicGenderW = basicUnit * 12;
  final basicBirthW = basicUnit * 20;
  final basicIdW = basicUnit * 20;
  final basicAddrW = basicBirthW + basicIdW;

  final docUnit = mainRightWidth / 97;
  final w10 = docUnit * 10;
  final w12 = docUnit * 12;
  final w14 = docUnit * 14;
  final w9 = docUnit * 9;

  final hBasic = 24 * PdfPageFormat.mm;
  final hHistory = 35 * PdfPageFormat.mm;
  final hSummary = 28 * PdfPageFormat.mm;
  final hPurpose = 22 * PdfPageFormat.mm;
  final hConsent = 12 * PdfPageFormat.mm;
  final hDoctor = 34 * PdfPageFormat.mm;
  final hRecvProcess = 36 * PdfPageFormat.mm;
  final hRecvSummary = 25 * PdfPageFormat.mm;
  final hRecvInfo = 22 * PdfPageFormat.mm;
  final topSectionH =
      hBasic + hHistory + hSummary + hPurpose + hConsent + hDoctor;
  final recvSectionH = hRecvProcess + hRecvSummary + hRecvInfo;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 10 * PdfPageFormat.mm,
        vertical: 10 * PdfPageFormat.mm,
      ),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ── Title ────────────────────────────────────────────────────────
          pw.Center(
            child: pw.Text(
              '全民健康保險聯新國際醫院桃園國際機場醫療中心轉診單',
              style: ts(sz: 13, bold: true),
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('（轉診至', style: ts(sz: 10, bold: true)),
              pw.SizedBox(width: 4),
              uv(d.referToHospital, w: 60, center: true, sz: 11),
              pw.Text('院所）', style: ts(sz: 10, bold: true)),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text('保險醫事服務機構代碼：3432060513', style: ts(sz: 9, bold: true)),
          pw.SizedBox(height: 4),
          pw.SizedBox(height: 2),
          // ── 原診治醫院診所（含基本資料/摘要/目的/同意/醫師） ────────────────
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: leftColW,
                height: topSectionH,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: bdr,
                    top: bdr,
                    right: bdr,
                    bottom: bdr,
                  ),
                ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '原\n診\n治\n醫\n院\n診\n所',
                  style: ts(bold: true, sz: 6),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Expanded(
                child: pw.Table(
                  border: tblNoLeft,
                  columnWidths: {0: colW(midColW), 1: flexW(1)},
                  children: [
                    pw.TableRow(
                      children: [
                        cell(
                          '基\n本\n資\n料',
                          bold: true,
                          align: pw.Alignment.center,
                          h: hBasic,
                        ),
                        pw.Container(
                          height: hBasic,
                          padding: pw.EdgeInsets.zero,
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Row(
                                children: [
                                  gridCellTextW(
                                    '姓名',
                                    basicNameW,
                                    bold: true,
                                    left: true,
                                    top: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '性別',
                                    basicGenderW,
                                    bold: true,
                                    top: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '出生日期',
                                    basicBirthW,
                                    bold: true,
                                    top: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '身分證字號',
                                    basicIdW,
                                    bold: true,
                                    top: true,
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  gridCellTextW(d.name, basicNameW, left: true),
                                  gridCellWidgetW(
                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        chk(d.gender == '男', '男'),
                                        chk(d.gender == '女', '女'),
                                      ],
                                    ),
                                    basicGenderW,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellWidgetW(
                                    pw.Row(
                                      children: [
                                        pw.Text('西元', style: ts()),
                                        pw.SizedBox(width: 2),
                                        uv(d.birthYear, w: 10, center: true),
                                        pw.Text('年', style: ts()),
                                        pw.SizedBox(width: 2),
                                        uv(d.birthMonth, w: 8, center: true),
                                        pw.Text('月', style: ts()),
                                        pw.SizedBox(width: 2),
                                        uv(d.birthDay, w: 8, center: true),
                                        pw.Text('日', style: ts()),
                                      ],
                                    ),
                                    basicBirthW,
                                  ),
                                  gridCellTextW(d.idNo, basicIdW),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  gridCellTextW(
                                    '聯絡人',
                                    basicNameW,
                                    bold: true,
                                    left: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '聯絡電話',
                                    basicGenderW,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '聯絡地址',
                                    basicAddrW,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  gridCellTextW(d.contact, basicNameW, left: true),
                                  gridCellTextW(d.contactPhone, basicGenderW),
                                  gridCellTextW(d.contactAddress, basicAddrW),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        cell(
                          '病\n歷\n摘\n要',
                          bold: true,
                          align: pw.Alignment.center,
                          h: hHistory,
                        ),
                        pw.Container(
                          height: hHistory,
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('A. 病情摘要（主訴、簡短病史）', style: ts(bold: true)),
                              pw.SizedBox(height: 2),
                              pw.Text(d.chiefComplaintHistory, style: ts()),
                              pw.SizedBox(height: 4),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: halfRightWidth,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'B. 診斷 ICD-10-CM/PCS 病名',
                                          style: ts(bold: true),
                                        ),
                                        pw.Text(
                                          '1.(主診斷) ${d.diagnosisName1}',
                                          style: ts(),
                                        ),
                                        pw.Text(
                                          '2. ${d.diagnosisName2}',
                                          style: ts(),
                                        ),
                                        pw.Text(
                                          '3. ${d.diagnosisName3}',
                                          style: ts(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(width: 8),
                                  pw.Container(
                                    width: halfRightWidth,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text('D. 藥物過敏史', style: ts(bold: true)),
                                        pw.Row(
                                          children: [
                                            chk(d.allergyNone, '無'),
                                            chk(d.allergyHas, '有（請詳述）'),
                                            uvLine(d.allergyDetail, lineShort),
                                          ],
                                        ),
                                        pw.SizedBox(height: 4),
                                        pw.Text('E. 醫師交班注意事項', style: ts(bold: true)),
                                        pw.Text(d.doctorHandoverNote, style: ts()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        cell(
                          '診\n治\n摘\n要',
                          bold: true,
                          align: pw.Alignment.center,
                          h: hSummary,
                        ),
                        pw.Container(
                          height: hSummary,
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('C. 檢查及治療摘要', style: ts(bold: true)),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: halfRightWidth,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text('1. 最近一次檢查結果', style: ts()),
                                        pw.Row(
                                          children: [
                                            pw.Text('日期：', style: ts()),
                                            uv(d.lastExamDate, w: 20),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(width: 8),
                                  pw.Container(
                                    width: halfRightWidth,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text('2. 最近一次用藥或手術名稱', style: ts()),
                                        pw.Row(
                                          children: [
                                            pw.Text('日期：', style: ts()),
                                            uv(d.lastMedDate, w: 20),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 2),
                              pw.Row(
                                children: [
                                  pw.Text('報告：', style: ts()),
                                  uvLine(d.lastExamReport, lineLong),
                                ],
                              ),
                              pw.SizedBox(height: 2),
                              pw.Row(
                                children: [
                                  pw.Text('用藥/手術：', style: ts()),
                                  uvLine(d.lastMedOrSurgery, lineLong),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        cell(
                          '轉\n診\n目\n的',
                          bold: true,
                          align: pw.Alignment.center,
                          h: hPurpose,
                        ),
                        pw.Container(
                          height: hPurpose,
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                width: halfRightWidth,
                                child: pw.Column(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        chk(d.purposeEmergency, '1. 急診治療'),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        chk(d.purposeHospital, '2. 住院治療'),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        chk(d.purposeClinic, '3. 門診治療'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              pw.SizedBox(width: 8),
                              pw.Container(
                                width: halfRightWidth,
                                child: pw.Column(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        chk(
                                          d.purposeFurtherExam,
                                          '4. 進一步檢查，檢查項目',
                                        ),
                                        uvLine(d.furtherExamItems, linePurpose),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        chk(
                                          d.purposeFollowUp,
                                          '5. 轉回轉出或適當之院所繼續追蹤',
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        chk(d.purposeOther, '6. 其他'),
                                        uvLine(d.purposeOtherText, linePurpose),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        cell('', h: hConsent),
                        pw.Container(
                          height: hConsent,
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 3,
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '經醫師解釋病情及轉診目的後同意轉院。',
                                style: ts(
                                  sz: 8,
                                  bold: true,
                                  c: const PdfColor.fromInt(0xFFC0392B),
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    '同意人簽名：',
                                    style: ts(
                                      bold: true,
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentSignName, w: 25),
                                  pw.SizedBox(width: 4),
                                  pw.Text(
                                    '與病人關係：',
                                    style: ts(
                                      bold: true,
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentRelationship, w: 15),
                                  pw.SizedBox(width: 4),
                                  pw.Text(
                                    '日期：',
                                    style: ts(
                                      bold: true,
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentYear, w: 8, center: true),
                                  pw.Text(
                                    '年',
                                    style: ts(
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentMonth, w: 6, center: true),
                                  pw.Text(
                                    '月',
                                    style: ts(
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentDay, w: 6, center: true),
                                  pw.Text(
                                    '日',
                                    style: ts(
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentHour, w: 6, center: true),
                                  pw.Text(
                                    '時',
                                    style: ts(
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                  uv(d.consentMin, w: 6, center: true),
                                  pw.Text(
                                    '分',
                                    style: ts(
                                      c: const PdfColor.fromInt(0xFFC0392B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        cell(
                          '診\n治\n醫\n師',
                          bold: true,
                          align: pw.Alignment.center,
                          h: hDoctor,
                        ),
                        pw.Container(
                          height: hDoctor,
                          padding: pw.EdgeInsets.zero,
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Row(
                                children: [
                                  gridCellTextW(
                                    '院所住址',
                                    w10,
                                    bold: true,
                                    left: true,
                                    top: true,
                                  ),
                                  gridCellTextW(
                                    '337桃園市大園區航站南路9號及15號  TEL：03-3983456  FAX：03-3834225',
                                    mainRightWidth - w10,
                                    top: true,
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  gridCellTextW(
                                    '診治\n醫師',
                                    w10,
                                    bold: true,
                                    left: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '姓\n名',
                                    w10,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(d.doctorName, w14),
                                  gridCellTextW(
                                    '科\n別',
                                    w10,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(d.doctorDept, w10),
                                  gridCellTextW(
                                    '聯絡\n電話',
                                    w12,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(d.doctorPhone, w10),
                                  gridCellTextW(
                                    '醫師\n簽章',
                                    w12,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW('', w9),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  gridCellTextW(
                                    '開單\n日期',
                                    w10,
                                    bold: true,
                                    left: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '西元 ${d.issueDateYear} 年 ${d.issueDateMonth} 月 ${d.issueDateDay} 日\n（90天內有效）',
                                    w10 + w14 + w10 + w10,
                                  ),
                                  gridCellTextW(
                                    '安排就醫日期',
                                    w12,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '西元 ${d.appointDateYear} 年 ${d.appointDateMonth} 月 ${d.appointDateDay} 日\n${d.appointDept}科 診${d.appointNo}號',
                                    w10 + w12 + w9,
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  gridCellTextW(
                                    '建議轉診\n院所科別',
                                    w10,
                                    bold: true,
                                    left: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellTextW(
                                    '${d.referHospital}  ${d.referDept}科  ${d.referDoctor}醫師',
                                    w10 + w14 + w10 + w10,
                                  ),
                                  gridCellTextW(
                                    '轉診院所地址\n及專線電話',
                                    w12,
                                    bold: true,
                                    align: pw.Alignment.center,
                                  ),
                                  gridCellWidgetW(
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          '地址: ${d.referHospAddress}',
                                          style: ts(),
                                        ),
                                        pw.Text(
                                          '電話: ${d.referHospPhone}',
                                          style: ts(),
                                        ),
                                      ],
                                    ),
                                    w10 + w12 + w9,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── 接受轉診醫院 ─────────────────────────────────────────────────
          pw.Table(
            border: tbl,
            columnWidths: {0: colW(leftColW), 1: colW(midColW), 2: flexW(1)},
            children: [
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Center(
                      child: pw.Text(
                        '接\n受\n轉\n診\n醫\n院',
                        style: ts(bold: true),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
                  cell('處\n理\n情\n形', bold: true),
                  pw.Container(
                    height: 36 * PdfPageFormat.mm,
                    width: contentWidth - 16,
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            chk(d.recvEmergencyTransfer, '1. 已予急診處置並轉診至'),
                            pw.SizedBox(width: 4),
                            uvLine(d.recvEmergencyHospital, lineHospital),
                            pw.SizedBox(width: 4),
                            pw.Text('醫院', style: ts()),
                          ],
                        ),
                        pw.Row(
                          children: [
                            chk(d.recvEmergencyAdmit, '2. 已予急診處置，並住本院'),
                            pw.SizedBox(width: 4),
                            uvLine(d.recvEmergencyAdmitWard, lineHospital),
                            pw.SizedBox(width: 4),
                            pw.Text('病房治療中', style: ts()),
                          ],
                        ),
                        pw.Row(
                          children: [
                            chk(d.recvAdmit, '3. 已安排住本院'),
                            pw.SizedBox(width: 4),
                            uvLine(d.recvAdmitWard, lineHospital),
                            pw.SizedBox(width: 4),
                            pw.Text('病房治療中', style: ts()),
                          ],
                        ),
                        pw.Row(
                          children: [
                            chk(d.recvClinicArranged, '4. 已安排本院'),
                            pw.SizedBox(width: 4),
                            uvLine(d.recvClinicDept, lineHospital),
                            pw.SizedBox(width: 4),
                            pw.Text('科門診治療中', style: ts()),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Row(
                              children: [
                                chk(d.recvSendBack, '5. 已予適當處理並轉回原院所，建議事項如下'),
                              ],
                            ),
                            pw.SizedBox(width: 8),
                            pw.Row(
                              children: [
                                chk(d.recvOther, '6. 其他'),
                                uvLine(d.recvOtherText, lineOther),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  cell(''),
                  cell('治\n療\n摘\n要', bold: true),
                  pw.Container(
                    height: 25 * PdfPageFormat.mm,
                    width: contentWidth - 16,
                    padding: pw.EdgeInsets.zero,
                    child: pw.Table(
                      border: innerTbl,
                      columnWidths: {
                        0: flexW(1.2),
                        1: flexW(1.1),
                        2: flexW(1.1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            cell('1. 主診斷', bold: true),
                            cell('2. 治療藥物或手術名稱', bold: true),
                            cell('3. 輔助診斷之檢查結果', bold: true),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'ICD-10-CM/PCS：${d.recvMainDiagICD}',
                                    style: ts(),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    '病名：${d.recvMainDiagName}',
                                    style: ts(),
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(d.recvTreatmentMed, style: ts()),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(d.recvAuxExamResult, style: ts()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  cell(''),
                  cell('院\n所\n資\n訊', bold: true),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(3),
                    width: contentWidth - 16,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text('院所名稱：', style: ts(bold: true)),
                            uv(d.recvHospName, w: 40),
                            pw.SizedBox(width: 6),
                            pw.Text('電話或傳真：', style: ts(bold: true)),
                            uv(d.recvHospPhone, w: 25),
                          ],
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text('電子信箱：${d.recvHospEmail}', style: ts()),
                        pw.SizedBox(height: 2),
                        pw.Row(
                          children: [
                            pw.Text('診治醫師：', style: ts(bold: true)),
                            uv(d.recvDoctorName, w: 25),
                            pw.SizedBox(width: 4),
                            pw.Text('科別：', style: ts(bold: true)),
                            uv(d.recvDept, w: 15),
                            pw.SizedBox(width: 4),
                            pw.Text('回覆日期：', style: ts(bold: true)),
                            uv(d.recvReturnYear, w: 10, center: true),
                            pw.Text('年', style: ts()),
                            uv(d.recvReturnMonth, w: 8, center: true),
                            pw.Text('月', style: ts()),
                            uv(d.recvReturnDay, w: 8, center: true),
                            pw.Text('日', style: ts()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          pw.Expanded(child: pw.SizedBox()),

          // ── Footer ────────────────────────────────────────────────────────
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('62-P-004-R15', style: ts(sz: 6, c: PdfColors.grey600)),
              pw.Text(
                '聯新(R905)2020/09x500張',
                style: ts(sz: 6, c: PdfColors.grey600),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  return pdf.save();
}
