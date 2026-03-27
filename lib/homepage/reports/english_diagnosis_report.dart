import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EnglishDiagnosisReportData {
  final String name;
  final String dateOfBirth;
  final String sex;
  final String nationality;
  final String idOrPassportNo;
  final String impression;
  final String commentsAndAdvices;
  final String attendingPhysician;
  final String issuedDate;

  const EnglishDiagnosisReportData({
    required this.name,
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    required this.idOrPassportNo,
    required this.impression,
    required this.commentsAndAdvices,
    required this.attendingPhysician,
    required this.issuedDate,
  });
}

Future<Uint8List> buildEnglishDiagnosisPdf(EnglishDiagnosisReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansRegular();
  final fontB = await PdfGoogleFonts.notoSansBold();

  pw.TextStyle ts({double size = 10, bool bold = false, PdfColor? color}) =>
      pw.TextStyle(
        font: bold ? fontB : font,
        fontSize: size,
        color: color ?? PdfColors.black,
      );

  const border = pw.BorderSide(width: 0.7, color: PdfColors.black);

  pw.Widget splitRow({
    required String lLabel,
    required String lValue,
    required String rLabel,
    required String rValue,
    double lLabelW = 28,
    double rLabelW = 22,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          width: lLabelW * PdfPageFormat.mm,
          padding: const pw.EdgeInsets.all(6),
          decoration: const pw.BoxDecoration(border: pw.Border(right: border)),
          child: pw.Center(
            child: pw.Text(
              lLabel,
              style: pw.TextStyle(font: fontB, fontSize: 10),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const pw.BoxDecoration(
              border: pw.Border(right: border),
            ),
            child: pw.Text(lValue, style: ts()),
          ),
        ),
        pw.Container(
          width: rLabelW * PdfPageFormat.mm,
          padding: const pw.EdgeInsets.all(6),
          decoration: const pw.BoxDecoration(border: pw.Border(right: border)),
          child: pw.Center(
            child: pw.Text(
              rLabel,
              style: pw.TextStyle(font: fontB, fontSize: 10),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: pw.Text(rValue, style: ts()),
          ),
        ),
      ],
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 22 * PdfPageFormat.mm,
        vertical: 20 * PdfPageFormat.mm,
      ),
      build: (ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1.0, color: PdfColors.black),
              ),
              child: pw.Column(
                children: [
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(vertical: 12),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: border),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Landseed Medical Clinic at Taiwan Taoyuan Int\'l '
                          'Airport',
                          style: pw.TextStyle(font: fontB, fontSize: 13),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Medical Certificate',
                          style: pw.TextStyle(font: fontB, fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: border),
                    ),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Container(
                          width: 28 * PdfPageFormat.mm,
                          padding: const pw.EdgeInsets.all(8),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(right: border),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'Name',
                              style: pw.TextStyle(font: fontB, fontSize: 10),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            child: pw.Text(d.name, style: ts()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: border),
                    ),
                    child: splitRow(
                      lLabel: 'Date of\nBirth',
                      lValue: d.dateOfBirth,
                      rLabel: 'Sex',
                      rValue: d.sex,
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: border),
                    ),
                    child: splitRow(
                      lLabel: 'Nationality',
                      lValue: d.nationality,
                      rLabel: 'ID No or\nPassport No',
                      rValue: d.idOrPassportNo,
                      rLabelW: 25,
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: border),
                    ),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Container(
                          width: 28 * PdfPageFormat.mm,
                          padding: const pw.EdgeInsets.all(8),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(right: border),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'Impression',
                              style: pw.TextStyle(font: fontB, fontSize: 10),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 38 * PdfPageFormat.mm,
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Text(d.impression, style: ts()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: border),
                    ),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Container(
                          width: 28 * PdfPageFormat.mm,
                          padding: const pw.EdgeInsets.all(8),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(right: border),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'Comments\nAnd\nAdvices',
                              style: pw.TextStyle(font: fontB, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 38 * PdfPageFormat.mm,
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Text(d.commentsAndAdvices, style: ts()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'President : CHIN-YU LIU',
                                    style: pw.TextStyle(
                                      font: fontB,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.SizedBox(height: 3),
                                  pw.Text(
                                    'Address: No 15, Hangjan S.Rd, Dayuan '
                                    'dist., Taoyuan, Taiwan.',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 8,
                                    ),
                                  ),
                                  pw.SizedBox(height: 3),
                                  pw.Text(
                                    'TEL: +886-3-398-3456',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                    children: [
                                      pw.Text(
                                        'Attending physician: ',
                                        style: pw.TextStyle(
                                          font: fontB,
                                          fontSize: 9,
                                        ),
                                      ),
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
                                            d.attendingPhysician,
                                            style: pw.TextStyle(
                                              font: font,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        'Issued Date: ',
                                        style: pw.TextStyle(
                                          font: fontB,
                                          fontSize: 9,
                                        ),
                                      ),
                                      pw.Container(
                                        width: 35 * PdfPageFormat.mm,
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            bottom: pw.BorderSide(
                                              width: 0.5,
                                              color: PdfColors.grey600,
                                            ),
                                          ),
                                        ),
                                        child: pw.Text(
                                          d.issuedDate,
                                          style: pw.TextStyle(
                                            font: font,
                                            fontSize: 9,
                                          ),
                                        ),
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
            ),
          ],
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
