import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ChineseDiagnosisReportData {
  final String name;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final String gender;
  final String idOrPassport;
  final String diagnosis;
  final String doctorNotes;
  final String director;
  final String treatingDoctor;
  final String certYear;
  final String certMonth;
  final String certDay;

  const ChineseDiagnosisReportData({
    required this.name,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.gender,
    required this.idOrPassport,
    required this.diagnosis,
    required this.doctorNotes,
    required this.director,
    required this.treatingDoctor,
    required this.certYear,
    required this.certMonth,
    required this.certDay,
  });
}

Future<Uint8List> buildChineseDiagnosisPdf(ChineseDiagnosisReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  const borderSide = pw.BorderSide(width: 0.6, color: PdfColors.black);
  const cellBorder = pw.TableBorder(
    top: borderSide,
    bottom: borderSide,
    left: borderSide,
    right: borderSide,
    horizontalInside: borderSide,
    verticalInside: borderSide,
  );

  pw.TextStyle ts({double size = 9, bool bold = false, PdfColor? color}) =>
      pw.TextStyle(
        font: bold ? fontB : font,
        fontSize: size,
        color: color ?? PdfColors.black,
      );

  pw.Widget cell(pw.Widget child, {pw.EdgeInsets? padding, PdfColor? bg}) =>
      pw.Container(
        color: bg,
        padding:
            padding ??
            const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: child,
      );

  pw.Widget labelCell(String t, {double size = 9}) => cell(
    pw.Text(
      t,
      style: ts(size: size, bold: true),
      textAlign: pw.TextAlign.center,
    ),
  );

  pw.Widget valueCell(String t, {pw.Alignment? align}) => cell(
    pw.Align(
      alignment: align ?? pw.Alignment.centerLeft,
      child: pw.Text(t, style: ts()),
    ),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.only(
        left: 20 * PdfPageFormat.mm,
        right: 25 * PdfPageFormat.mm,
        top: 20 * PdfPageFormat.mm,
        bottom: 15 * PdfPageFormat.mm,
      ),
      build: (ctx) {
        final pageW = PdfPageFormat.a4.width - (20 + 25) * PdfPageFormat.mm;

        return pw.Stack(
          children: [
            pw.Positioned(
              right: -18 * PdfPageFormat.mm,
              top: 30 * PdfPageFormat.mm,
              child: pw.Transform.rotate(
                angle: -math.pi / 2,
                child: pw.Text(
                  '◎ 本 證 明 書 須 加 蓋 本 院 印 章 否 則 無 效 ◎',
                  style: ts(size: 7),
                ),
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: pageW,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1.0),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(vertical: 10),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(bottom: pw.BorderSide(width: 0.6)),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Text(
                              '聯 新 國 際 醫 院 桃 園 國 際 機 場 醫 療 中 心',
                              style: ts(size: 14, bold: true),
                              textAlign: pw.TextAlign.center,
                            ),
                            pw.SizedBox(height: 6),
                            pw.Text(
                              '診 斷 證 明 書',
                              style: ts(size: 13, bold: true),
                              textAlign: pw.TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      pw.Table(
                        border: cellBorder,
                        columnWidths: const {
                          0: pw.FixedColumnWidth(22),
                          1: pw.FlexColumnWidth(),
                        },
                        children: [
                          pw.TableRow(
                            children: [labelCell('姓  名'), valueCell(d.name)],
                          ),
                        ],
                      ),
                      pw.Table(
                        border: cellBorder,
                        columnWidths: const {
                          0: pw.FixedColumnWidth(22),
                          1: pw.FlexColumnWidth(3),
                          2: pw.FixedColumnWidth(18),
                          3: pw.FixedColumnWidth(28),
                          4: pw.FixedColumnWidth(28),
                          5: pw.FlexColumnWidth(2),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              cell(
                                pw.Center(
                                  child: pw.Text(
                                    '出生\n日期',
                                    style: ts(size: 8, bold: true),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                              ),
                              cell(
                                pw.Text(
                                  '西元 ${d.birthYear} 年 '
                                  '${d.birthMonth} 月 ${d.birthDay} 日',
                                  style: ts(),
                                ),
                              ),
                              cell(
                                pw.Center(
                                  child: pw.Text(
                                    '性\n別',
                                    style: ts(size: 8, bold: true),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                              ),
                              cell(
                                pw.Column(
                                  mainAxisSize: pw.MainAxisSize.min,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    _pdfCheckLabel('男', d.gender == '男', font),
                                    pw.SizedBox(height: 2),
                                    _pdfCheckLabel('女', d.gender == '女', font),
                                  ],
                                ),
                              ),
                              cell(
                                pw.Center(
                                  child: pw.Text(
                                    '身份證號碼\n或\n護照號碼',
                                    style: ts(size: 7, bold: true),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                              ),
                              valueCell(d.idOrPassport),
                            ],
                          ),
                        ],
                      ),
                      pw.Table(
                        border: cellBorder,
                        columnWidths: const {
                          0: pw.FixedColumnWidth(22),
                          1: pw.FlexColumnWidth(),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              labelCell('診\n\n\n\n\n\n斷'),
                              cell(
                                pw.SizedBox(
                                  height: 55 * PdfPageFormat.mm,
                                  child: pw.Align(
                                    alignment: pw.Alignment.topLeft,
                                    child: pw.Text(d.diagnosis, style: ts()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.Table(
                        border: cellBorder,
                        columnWidths: const {
                          0: pw.FixedColumnWidth(22),
                          1: pw.FlexColumnWidth(),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              labelCell('醫\n師\n囑\n言\n或\n備\n註'),
                              cell(
                                pw.SizedBox(
                                  height: 45 * PdfPageFormat.mm,
                                  child: pw.Align(
                                    alignment: pw.Alignment.topLeft,
                                    child: pw.Text(d.doctorNotes, style: ts()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '以 上 病 人 經 本 院 醫 師 診 斷 屬 實 特 予 證 明',
                        style: ts(size: 10),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Row(
                        children: [
                          pw.Text('院長：', style: ts(bold: true)),
                          pw.SizedBox(width: 4),
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
                              child: pw.Text(d.director, style: ts()),
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Text('診治醫師：', style: ts(bold: true)),
                          pw.SizedBox(width: 4),
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
                              child: pw.Text(d.treatingDoctor, style: ts()),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text('開業執照號碼：桃衛醫診字第3432060513號', style: ts()),
                      pw.SizedBox(height: 6),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('西元', style: ts()),
                          pw.SizedBox(width: 8),
                          pw.Container(
                            width: 18 * PdfPageFormat.mm,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  width: 0.5,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ),
                            child: pw.Text(
                              d.certYear,
                              style: ts(),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Text('  年', style: ts()),
                          pw.SizedBox(width: 8),
                          pw.Container(
                            width: 10 * PdfPageFormat.mm,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  width: 0.5,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ),
                            child: pw.Text(
                              d.certMonth,
                              style: ts(),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Text('  月', style: ts()),
                          pw.SizedBox(width: 8),
                          pw.Container(
                            width: 10 * PdfPageFormat.mm,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  width: 0.5,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ),
                            child: pw.Text(
                              d.certDay,
                              style: ts(),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Text('  日', style: ts()),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Expanded(child: pw.SizedBox()),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '51-P-001-007',
                      style: ts(size: 7, color: PdfColors.grey600),
                    ),
                    pw.Text(
                      '聯新(A655)2019/12x1000張',
                      style: ts(size: 7, color: PdfColors.grey600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}

pw.Widget _pdfCheckLabel(String label, bool checked, pw.Font font) {
  return pw.Row(
    children: [
      pw.Container(
        width: 8,
        height: 8,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.7, color: PdfColors.black),
        ),
        child: checked
            ? pw.Center(
                child: pw.Text(
                  '✓',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 6,
                    color: PdfColors.black,
                  ),
                ),
              )
            : null,
      ),
      pw.SizedBox(width: 2),
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 8)),
    ],
  );
}
