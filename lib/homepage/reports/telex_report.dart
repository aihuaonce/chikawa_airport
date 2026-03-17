import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TelexFaxLine {
  final String text;
  final bool checked;

  const TelexFaxLine({required this.text, required this.checked});
}

class TelexReportData {
  final String patientName;
  final String nationality;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final String gender;

  final bool isAirline;
  final String airline;
  final String flightNo;
  final bool isOther;
  final String otherDetail;

  final String incidentYear;
  final String incidentMonth;
  final String incidentDay;
  final String location;

  final String reporter;
  final String direction;

  final String reportHour;
  final String reportMin;
  final String treatHour;
  final String treatMin;

  final String diagnosis;

  final String outcome;
  final String transferTo;

  final bool chargedYes;
  final bool chargedNo;
  final String chargedAmount;

  final String doctor;
  final String nurse;

  final String toTitle;
  final String fromTitle;
  final List<TelexFaxLine> toLines;
  final List<TelexFaxLine> fromLines;

  const TelexReportData({
    required this.patientName,
    required this.nationality,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.gender,
    required this.isAirline,
    required this.airline,
    required this.flightNo,
    required this.isOther,
    required this.otherDetail,
    required this.incidentYear,
    required this.incidentMonth,
    required this.incidentDay,
    required this.location,
    required this.reporter,
    required this.direction,
    required this.reportHour,
    required this.reportMin,
    required this.treatHour,
    required this.treatMin,
    required this.diagnosis,
    required this.outcome,
    required this.transferTo,
    required this.chargedYes,
    required this.chargedNo,
    required this.chargedAmount,
    required this.doctor,
    required this.nurse,
    required this.toTitle,
    required this.fromTitle,
    required this.toLines,
    required this.fromLines,
  });
}

Future<Uint8List> buildTelexPdf(TelexReportData d) async {
  final pdf = pw.Document();

  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 25 * PdfPageFormat.mm,
        vertical: 18 * PdfPageFormat.mm,
      ),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                width: 10 * PdfPageFormat.mm,
                height: 10 * PdfPageFormat.mm,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.teal700),
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    '❖',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 12,
                      color: PdfColors.teal700,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 4),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '聯新國際醫院 桃園國際機場醫療中心',
                    style: pw.TextStyle(font: fontB, fontSize: 14),
                  ),
                  pw.Text(
                    'LANDSEED MEDICAL CLINIC AT TAIWAN TAOYUAN '
                    'INTERNATIONAL AIRPORT',
                    style: pw.TextStyle(font: font, fontSize: 6),
                  ),
                ],
              ),
            ],
          ),
          pw.Divider(thickness: 0.5),
          pw.Center(
            child: pw.Text(
              '出 診 診 療 服 務 電 傳 文 件',
              style: pw.TextStyle(font: fontB, fontSize: 15),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(d.toTitle, style: pw.TextStyle(font: fontB, fontSize: 9)),
          _faxRow(d.toLines, font),
          pw.SizedBox(height: 4),
          pw.Text(d.fromTitle, style: pw.TextStyle(font: fontB, fontSize: 9)),
          _faxRow(d.fromLines, font),
          pw.Divider(thickness: 0.3),
          _row2('病患姓名：', d.patientName, '國籍：', d.nationality, font, fontB),
          _row2(
            '生日：西元 ${d.birthYear} 年 ${d.birthMonth} 月 ${d.birthDay} 日',
            '',
            '性別：',
            d.gender,
            font,
            fontB,
            leftFlex: 3,
          ),
          pw.Row(
            children: [
              _checkbox(d.isAirline, font),
              pw.Text('航空公司：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.airline, font, width: 35 * PdfPageFormat.mm),
              pw.SizedBox(width: 6),
              pw.Text('班機：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.flightNo, font, width: 28 * PdfPageFormat.mm),
              pw.SizedBox(width: 6),
              _checkbox(d.isOther, font),
              pw.Text('其他：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.otherDetail, font),
            ],
          ),
          _row2(
            '醫生日期：西元 ${d.incidentYear} 年 ${d.incidentMonth} 月 '
                '${d.incidentDay} 日',
            '',
            '地點：',
            d.location,
            font,
            fontB,
            leftFlex: 3,
          ),
          pw.Row(
            children: [
              pw.Text('通報人員：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.reporter, font, width: 50 * PdfPageFormat.mm),
              pw.SizedBox(width: 8),
              _checkLabel('出境', d.direction == '出境', font),
              pw.SizedBox(width: 4),
              _checkLabel('入境', d.direction == '入境', font),
              pw.SizedBox(width: 4),
              _checkLabel('過境', d.direction == '過境', font),
            ],
          ),
          pw.Row(
            children: [
              pw.Text('通報時間：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.reportHour, font, width: 12 * PdfPageFormat.mm),
              pw.Text(' 時 ', style: pw.TextStyle(font: font, fontSize: 9)),
              _fillField(d.reportMin, font, width: 12 * PdfPageFormat.mm),
              pw.Text(' 分     ', style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Text('診療時間：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.treatHour, font, width: 12 * PdfPageFormat.mm),
              pw.Text(' 時 ', style: pw.TextStyle(font: font, fontSize: 9)),
              _fillField(d.treatMin, font, width: 12 * PdfPageFormat.mm),
              pw.Text(' 分', style: pw.TextStyle(font: font, fontSize: 9)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text('初步診斷（中文）：', style: pw.TextStyle(font: fontB, fontSize: 9)),
          pw.Container(
            width: double.infinity,
            height: 24 * PdfPageFormat.mm,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey600),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                d.diagnosis,
                style: pw.TextStyle(font: font, fontSize: 10),
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                '後續結果（中文）：',
                style: pw.TextStyle(font: fontB, fontSize: 9),
              ),
              _checkLabel('自行返家', d.outcome == '自行返家', font),
              pw.SizedBox(width: 4),
              _checkLabel('繼續搭機', d.outcome == '繼續搭機', font),
              pw.SizedBox(width: 4),
              _checkLabel('轉送至', d.outcome == '轉送醫院', font),
              pw.SizedBox(width: 2),
              pw.Text('（', style: pw.TextStyle(font: font, fontSize: 9)),
              _fillField(d.transferTo, font, width: 20 * PdfPageFormat.mm),
              pw.Text('）醫院', style: pw.TextStyle(font: font, fontSize: 9)),
            ],
          ),
          pw.Row(
            children: [
              pw.SizedBox(width: 8 * PdfPageFormat.mm),
              _checkLabel('醫療中心觀察', d.outcome == '醫療中心觀察', font),
              pw.SizedBox(width: 4),
              _checkLabel('空跑', d.outcome == '空跑', font),
              pw.SizedBox(width: 4),
              _checkLabel('其他', d.outcome == '其他', font),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: [
              pw.Text(
                '其他事宜：醫療費用收費',
                style: pw.TextStyle(font: fontB, fontSize: 9),
              ),
              _checkbox(d.chargedYes, font),
              pw.Text('是 ', style: pw.TextStyle(font: font, fontSize: 9)),
              _checkbox(d.chargedNo, font),
              pw.Text('否，金額', style: pw.TextStyle(font: font, fontSize: 9)),
              _fillField(d.chargedAmount, font, width: 30 * PdfPageFormat.mm),
            ],
          ),
          pw.Expanded(child: pw.SizedBox()),
          pw.Divider(thickness: 0.5),
          pw.Row(
            children: [
              pw.Text('醫師：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.doctor, font, width: 45 * PdfPageFormat.mm),
              pw.SizedBox(width: 16),
              pw.Text('護理師：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _fillField(d.nurse, font, width: 45 * PdfPageFormat.mm),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '51-P-002-002',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 7,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                '聯新(A364)2021/11x500張',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 7,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  return Uint8List.fromList(await pdf.save());
}

pw.Widget _faxRow(List<TelexFaxLine> lines, pw.Font font) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(left: 16, bottom: 2),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lines.map((line) {
        return pw.Row(
          children: [
            _checkbox(line.checked, font),
            pw.Text(
              '  ${line.text}',
              style: pw.TextStyle(font: font, fontSize: 9),
            ),
          ],
        );
      }).toList(),
    ),
  );
}

pw.Widget _row2(
  String lLabel,
  String lVal,
  String rLabel,
  String rVal,
  pw.Font font,
  pw.Font fontB, {
  int leftFlex = 1,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(
          flex: leftFlex,
          child: pw.Row(
            children: [
              pw.Text(lLabel, style: pw.TextStyle(font: fontB, fontSize: 9)),
              if (lVal.isNotEmpty)
                pw.Expanded(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          width: 0.5,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ),
                    child: pw.Text(
                      lVal,
                      style: pw.TextStyle(font: font, fontSize: 9),
                    ),
                  ),
                ),
            ],
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Text(rLabel, style: pw.TextStyle(font: fontB, fontSize: 9)),
              pw.Expanded(
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        width: 0.5,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                  child: pw.Text(
                    rVal,
                    style: pw.TextStyle(font: font, fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _fillField(String value, pw.Font font, {double? width}) {
  final inner = pw.Container(
    width: width,
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey600),
      ),
    ),
    padding: const pw.EdgeInsets.only(bottom: 1),
    child: pw.Text(value, style: pw.TextStyle(font: font, fontSize: 9)),
  );
  return width == null ? pw.Expanded(child: inner) : inner;
}

pw.Widget _checkbox(bool checked, pw.Font font) {
  return pw.Container(
    width: 9,
    height: 9,
    margin: const pw.EdgeInsets.only(right: 2),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 0.8, color: PdfColors.black),
    ),
    child: checked
        ? pw.Center(
            child: pw.Text(
              '✓',
              style: pw.TextStyle(
                font: font,
                fontSize: 7,
                color: PdfColors.black,
              ),
            ),
          )
        : null,
  );
}

pw.Widget _checkLabel(String label, bool checked, pw.Font font) {
  return pw.Row(
    children: [
      _checkbox(checked, font),
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 9)),
    ],
  );
}
