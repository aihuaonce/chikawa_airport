import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReferralReportData {
  // 轉診至
  String referToHospital = '';

  // 基本資料
  String name = '';
  String gender = '';            // 男/女
  String birthYear = '';
  String birthMonth = '';
  String birthDay = '';
  String idNo = '';
  String contact = '';
  String contactPhone = '';
  String contactAddress = '';

  // 診病歷摘要
  String chiefComplaintHistory = '';   // A. 病情摘要
  String diagnosisICD = '';            // B. ICD-10-CM/PCS
  String diagnosisName1 = '';          // 主診斷
  String diagnosisName2 = '';
  String diagnosisName3 = '';
  String lastExamResult = '';          // C. 最近一次檢查
  String lastExamDate = '';
  String lastExamReport = '';
  String lastMedOrSurgery = '';        // 最近一次用藥或手術
  String lastMedDate = '';
  bool allergyNone = false;            // D. 藥物過敏史
  bool allergyHas = false;
  String allergyDetail = '';
  String doctorHandoverNote = '';      // E. 醫師交班注意事項

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
  final pdf   = pw.Document();
  final font  = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pw.TextStyle ts({double sz = 7.5, bool bold = false, PdfColor? c}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz,
          color: c ?? PdfColors.black);

  const bdr = pw.BorderSide(width: 0.5, color: PdfColors.black);
  const tbl = pw.TableBorder(top: bdr, bottom: bdr, left: bdr, right: bdr,
      horizontalInside: bdr, verticalInside: bdr);

  pw.Widget cell(String t,
      {bool bold = false, pw.Alignment? align, double sz = 7.5,
       double? h, PdfColor? bg, pw.EdgeInsets? pad}) =>
      pw.Container(
        height: h, color: bg,
        padding: pad ?? const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        alignment: align ?? pw.Alignment.centerLeft,
        child: pw.Text(t, style: ts(bold: bold, sz: sz)),
      );

  pw.Widget chk(bool checked, String label) => pw.Row(children: [
        pw.Container(
          width: 8, height: 8,
          margin: const pw.EdgeInsets.only(right: 2),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
          child: checked ? pw.Container(color: PdfColors.black) : null,
        ),
        pw.Text(label, style: ts()),
        pw.SizedBox(width: 3),
      ]);

  pw.Widget uv(String val, {double w = 20}) => pw.Container(
        width: w * PdfPageFormat.mm,
        decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(
                width: 0.4, color: PdfColors.grey600))),
        child: pw.Text(val, style: ts()),
      );

  pw.FixedColumnWidth colW(double value) => pw.FixedColumnWidth(value);
  pw.FlexColumnWidth flexW([double value = 1]) => pw.FlexColumnWidth(value);

  pdf.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.symmetric(
        horizontal: 10 * PdfPageFormat.mm, vertical: 10 * PdfPageFormat.mm),
    build: (ctx) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ── Title ────────────────────────────────────────────────────────
        pw.Center(child: pw.Text(
            '全民健康保險聯新國際醫院桃園國際機場醫療中心轉診單',
            style: ts(sz: 13, bold: true))),
        pw.SizedBox(height: 2),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          pw.Text('（轉診至', style: ts(sz: 10, bold: true)),
          pw.SizedBox(width: 4),
          uv(d.referToHospital, w: 40),
          pw.Text('院所）', style: ts(sz: 10, bold: true)),
        ]),
        pw.SizedBox(height: 2),
        pw.Text('保險醫事服務機構代碼：3432060513',
            style: ts(sz: 9, bold: true)),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 1),
        pw.SizedBox(height: 2),

        // ── 基本資料 ─────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(8), 1: colW(8), 2: flexW(2),
          3: colW(12), 4: colW(20), 5: colW(24), 6: colW(20),
        }, children: [
          pw.TableRow(children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Center(child: pw.Text('原\n診\n所\n資\n料',
                  style: ts(bold: true), textAlign: pw.TextAlign.center)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Center(child: pw.Text('基\n本\n資\n料',
                  style: ts(bold: true), textAlign: pw.TextAlign.center)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(d.name, style: ts()),
                pw.SizedBox(height: 2),
                pw.Text(d.contact.isEmpty ? ' ' : '聯絡人: ${d.contact}', style: ts()),
                pw.SizedBox(height: 2),
                pw.Text(d.contactAddress.isEmpty ? ' ' : d.contactAddress, style: ts()),
              ]),
            ),
            cell('性別', bold: true),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Column(children: [
                pw.Row(children: [chk(d.gender == '男', '男性'), chk(d.gender == '女', '女性')]),
                pw.SizedBox(height: 4),
                pw.Text(d.contactPhone, style: ts()),
              ]),
            ),
            cell('出生日期\n西元 ${d.birthYear} 年 ${d.birthMonth} 月 ${d.birthDay} 日',
                bold: false),
            cell('身份證字號\n${d.idNo}'),
          ]),
        ]),

        pw.SizedBox(height: 1),

        // ── 診治摘要 ─────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(8), 1: colW(8), 2: flexW(1),
        }, children: [
          pw.TableRow(children: [
            cell('診\n病\n歷\n摘\n要',
                bold: true, align: pw.Alignment.center),
            cell('病\n歷\n摘\n要', bold: true),
            pw.Container(
              height: 35 * PdfPageFormat.mm,
              padding: const pw.EdgeInsets.all(4),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('A. 病情摘要（主訴、簡短病史）', style: ts(bold: true)),
                pw.SizedBox(height: 2),
                pw.Text(d.chiefComplaintHistory, style: ts()),
                pw.SizedBox(height: 4),
                pw.Row(children: [
                  pw.Expanded(child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('B. 診斷 ICD-10-CM/PCS 病名', style: ts(bold: true)),
                      pw.Text('1.(主診斷) ${d.diagnosisName1}', style: ts()),
                      if (d.diagnosisName2.isNotEmpty)
                        pw.Text('2. ${d.diagnosisName2}', style: ts()),
                      if (d.diagnosisName3.isNotEmpty)
                        pw.Text('3. ${d.diagnosisName3}', style: ts()),
                    ],
                  )),
                  pw.SizedBox(width: 8),
                  pw.Expanded(child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('D. 藥物過敏史', style: ts(bold: true)),
                      pw.Row(children: [
                        chk(d.allergyNone, '無'),
                        chk(d.allergyHas, '有（請詳述）'),
                      ]),
                      if (d.allergyDetail.isNotEmpty)
                        pw.Text(d.allergyDetail, style: ts()),
                      pw.SizedBox(height: 4),
                      pw.Text('E. 醫師交班注意事項', style: ts(bold: true)),
                      pw.Text(d.doctorHandoverNote, style: ts()),
                    ],
                  )),
                ]),
              ]),
            ),
          ]),
          pw.TableRow(children: [
            cell(''),
            cell('診\n治\n摘\n要', bold: true),
            pw.Container(
              height: 28 * PdfPageFormat.mm,
              padding: const pw.EdgeInsets.all(4),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('C. 檢查及治療摘要', style: ts(bold: true)),
                pw.Row(children: [
                  pw.Text('1. 最近一次檢查結果  日期: ${d.lastExamDate}', style: ts()),
                  pw.SizedBox(width: 12),
                  pw.Text('2. 最近一次用藥或手術名稱  日期: ${d.lastMedDate}', style: ts()),
                ]),
                pw.Text('報告: ${d.lastExamReport}', style: ts()),
                pw.Text('用藥/手術: ${d.lastMedOrSurgery}', style: ts()),
              ]),
            ),
          ]),
          pw.TableRow(children: [
            cell(''),
            cell('轉\n診\n目\n的', bold: true),
            pw.Container(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Wrap(spacing: 4, runSpacing: 2, children: [
                chk(d.purposeEmergency, '1. 急診治療'),
                chk(d.purposeHospital, '2. 住院治療'),
                chk(d.purposeClinic, '3. 門診治療'),
                pw.Row(children: [
                  chk(d.purposeFurtherExam, '4. 進一步檢查，檢查項目'),
                  uv(d.furtherExamItems, w: 30),
                ]),
                chk(d.purposeFollowUp, '5. 轉回轉出或適當之院所繼續追蹤'),
                pw.Row(children: [
                  chk(d.purposeOther, '6. 其他'),
                  uv(d.purposeOtherText, w: 25),
                ]),
              ]),
            ),
          ]),
        ]),

        // ── 知情同意 ─────────────────────────────────────────────────────
        pw.Container(
          color: const PdfColor.fromInt(0xFFFDEDEC),
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('經醫師解釋病情及轉診目的後同意轉院。',
                style: ts(sz: 8, bold: true, c: const PdfColor.fromInt(0xFFC0392B))),
            pw.Row(children: [
              pw.Text('同意人簽名：', style: ts(bold: true)),
              uv(d.consentSignName, w: 25),
              pw.SizedBox(width: 4),
              pw.Text('與病人關係：', style: ts(bold: true)),
              uv(d.consentRelationship, w: 15),
              pw.SizedBox(width: 4),
              pw.Text('日期：', style: ts(bold: true)),
              uv(d.consentYear, w: 10),
              pw.Text('年', style: ts()),
              uv(d.consentMonth, w: 8),
              pw.Text('月', style: ts()),
              uv(d.consentDay, w: 8),
              pw.Text('日', style: ts()),
              uv(d.consentHour, w: 8),
              pw.Text('時', style: ts()),
              uv(d.consentMin, w: 8),
              pw.Text('分', style: ts()),
            ]),
          ]),
        ),

        // ── 診治醫師 ─────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(8), 1: colW(12), 2: flexW(1), 3: colW(16), 4: flexW(1),
        }, children: [
          pw.TableRow(children: [
            cell('所', bold: true),
            cell('院所住址', bold: true),
            cell('337桃園市大園區航站南路9號及15號  TEL：03-3983456  FAX：03-3834225'),
            cell(''),
            cell(''),
          ]),
          pw.TableRow(children: [
            cell('診\n治\n醫\n師', bold: true),
            cell('姓名', bold: true),
            cell(d.doctorName),
            cell('科別', bold: true),
            cell(d.doctorDept),
          ]),
          pw.TableRow(children: [
            cell(''),
            cell('開單日期', bold: true),
            cell('西元 ${d.issueDateYear} 年 ${d.issueDateMonth} 月 ${d.issueDateDay} 日（90天內有效）'),
            cell('安排就醫日期', bold: true),
            cell('西元 ${d.appointDateYear} 年 ${d.appointDateMonth} 月 ${d.appointDateDay} 日  ${d.appointDept}科 診${d.appointNo}號'),
          ]),
          pw.TableRow(children: [
            cell(''),
            cell('建議轉診\n院所科別', bold: true),
            cell('${d.referHospital}  ${d.referDept}科  ${d.referDoctor}醫師'),
            cell('轉診院所\n地址及電話', bold: true),
            pw.Container(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('地址: ${d.referHospAddress}', style: ts()),
                pw.Text('電話: ${d.referHospPhone}', style: ts()),
              ]),
            ),
          ]),
        ]),

        pw.SizedBox(height: 4),
        pw.Divider(thickness: 1.5),
        pw.SizedBox(height: 2),

        // ── 接受轉診醫院 ─────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(8), 1: colW(8), 2: flexW(1),
        }, children: [
          pw.TableRow(children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Center(child: pw.Text('接\n受\n轉\n診\n醫\n院\n診\n所',
                  style: ts(bold: true), textAlign: pw.TextAlign.center)),
            ),
            cell('處\n理\n情\n形', bold: true),
            pw.Container(
              height: 30 * PdfPageFormat.mm,
              padding: const pw.EdgeInsets.all(3),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Row(children: [
                  chk(d.recvEmergencyTransfer, '1. 已予急診處置並轉診至'),
                  uv(d.recvEmergencyHospital, w: 30),
                  pw.Text('醫院', style: ts()),
                ]),
                pw.Row(children: [
                  chk(d.recvEmergencyAdmit, '2. 已予急診處置，並住本院'),
                  uv(d.recvEmergencyAdmitWard, w: 20),
                  pw.Text('病房治療中', style: ts()),
                ]),
                pw.Row(children: [
                  chk(d.recvAdmit, '3. 已安排住本院'),
                  uv(d.recvAdmitWard, w: 20),
                  pw.Text('病房治療中', style: ts()),
                ]),
                pw.Row(children: [
                  chk(d.recvClinicArranged, '4. 已安排本院'),
                  uv(d.recvClinicDept, w: 15),
                  pw.Text('科門診治療中', style: ts()),
                ]),
                pw.Row(children: [
                  chk(d.recvSendBack, '5. 已予適當處理並轉回原院所'),
                  pw.SizedBox(width: 6),
                  chk(d.recvOther, '6. 其他'),
                  uv(d.recvOtherText, w: 20),
                ]),
              ]),
            ),
          ]),
          pw.TableRow(children: [
            cell(''),
            cell('治\n療\n摘\n要', bold: true),
            pw.Container(
              height: 25 * PdfPageFormat.mm,
              padding: const pw.EdgeInsets.all(3),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Row(children: [
                  pw.Text('1. 主診斷 ICD-10-CM/PCS：${d.recvMainDiagICD}', style: ts(bold: true)),
                  pw.SizedBox(width: 4),
                  pw.Text('病名：${d.recvMainDiagName}', style: ts()),
                ]),
                pw.SizedBox(height: 2),
                pw.Text('2. 治療藥物或手術名稱：${d.recvTreatmentMed}', style: ts()),
                pw.SizedBox(height: 2),
                pw.Text('3. 輔助診斷之檢查結果：${d.recvAuxExamResult}', style: ts()),
              ]),
            ),
          ]),
          pw.TableRow(children: [
            cell(''),
            cell('院\n所\n資\n訊', bold: true),
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Row(children: [
                  pw.Text('院所名稱：', style: ts(bold: true)),
                  uv(d.recvHospName, w: 40),
                  pw.SizedBox(width: 6),
                  pw.Text('電話或傳真：', style: ts(bold: true)),
                  uv(d.recvHospPhone, w: 25),
                ]),
                pw.SizedBox(height: 2),
                pw.Text('電子信箱：${d.recvHospEmail}', style: ts()),
                pw.SizedBox(height: 2),
                pw.Row(children: [
                  pw.Text('診治醫師：', style: ts(bold: true)),
                  uv(d.recvDoctorName, w: 25),
                  pw.SizedBox(width: 4),
                  pw.Text('科別：', style: ts(bold: true)),
                  uv(d.recvDept, w: 15),
                  pw.SizedBox(width: 4),
                  pw.Text('回覆日期：', style: ts(bold: true)),
                  uv(d.recvReturnYear, w: 10),
                  pw.Text('年', style: ts()),
                  uv(d.recvReturnMonth, w: 8),
                  pw.Text('月', style: ts()),
                  uv(d.recvReturnDay, w: 8),
                  pw.Text('日', style: ts()),
                ]),
              ]),
            ),
          ]),
        ]),

        pw.Expanded(child: pw.SizedBox()),

        // ── Footer ────────────────────────────────────────────────────────
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('62-P-004-R15',
              style: ts(sz: 6, c: PdfColors.grey600)),
          pw.Text('聯新(R905)2020/09x500張',
              style: ts(sz: 6, c: PdfColors.grey600)),
        ]),
      ],
    ),
  ));

  return pdf.save();
}
