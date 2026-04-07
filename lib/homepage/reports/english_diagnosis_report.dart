import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class EnglishDiagnosisReportData {
  final String name;
  final String dateOfBirth;
  final String sex;
  final String nationality;
  final String idOrPassportNo;
  final String impression;
  final String commentsAndAdvices;
  final String director;
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
    required this.director,
    required this.attendingPhysician,
    required this.issuedDate,
  });
}

Future<Uint8List> buildEnglishDiagnosisPdf(EnglishDiagnosisReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pw.TextStyle ts({double size = 10, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: size);

  const borderSide = pw.BorderSide(width: 0.8, color: PdfColors.black);

  // 載入標題中要顯示的簽章圖片（放在 assets/images/sign02.png）
  final signImage = pw.MemoryImage(
    (await rootBundle.load('assets/images/sign02.png')).buffer.asUint8List(),
  );

  // 輔助方法：儲存格容器
  pw.Widget _cell(
    pw.Widget child, {
    double? height,
    pw.Alignment? align,
    pw.EdgeInsets? padding,
  }) {
    return pw.Container(
      height: height,
      padding: padding ?? const pw.EdgeInsets.all(6),
      alignment: align ?? pw.Alignment.centerLeft,
      child: child,
    );
  }

  // 輔助方法：純文字儲存格
  pw.Widget _textCell(
    String text, {
    bool isLabel = false,
    double? height,
    pw.Alignment? align,
    double? size,
    pw.EdgeInsets? padding,
  }) {
    return _cell(
      pw.Text(
        text,
        style: ts(bold: isLabel, size: size ?? (isLabel ? 9 : 10)),
        textAlign: pw.TextAlign.center,
      ),
      height: height,
      align: align ?? (isLabel ? pw.Alignment.center : pw.Alignment.centerLeft),
      padding:
          padding ??
          (isLabel
              ? const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2)
              : null),
    );
  }

  bool _isMale(String value) {
    final v = value.trim().toLowerCase();
    return v == 'm' || v == 'male' || value.contains('男');
  }

  bool _isFemale(String value) {
    final v = value.trim().toLowerCase();
    return v == 'f' || v == 'female' || value.contains('女');
  }

  // 勾選框元件
  pw.Widget _pdfCheckBox(String label, bool checked) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
          child: checked ? pw.Container(color: PdfColors.black) : null,
        ),
        pw.SizedBox(width: 4),
        pw.Text(label, style: pw.TextStyle(font: font, fontSize: 9)),
      ],
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16 * PdfPageFormat.mm),
      build: (ctx) {
        const titleBlockHeight = 30 * PdfPageFormat.mm;
        final mainContent = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 標題（使用 Stack 將簽章疊圖蓋在文字上）
            pw.SizedBox(
              height: titleBlockHeight,
              child: pw.Stack(
                alignment: pw.Alignment.center,
                children: [
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Landseed Medical Clinic at Taiwan Taoyuan Int\'l Airport',
                          style: ts(bold: true, size: 13),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Text(
                          'Medical Certificate',
                          style: ts(bold: true, size: 12),
                        ),
                      ],
                    ),
                  ),
                  pw.Positioned(
                    top: 8 * PdfPageFormat.mm,
                    child: pw.Image(
                      signImage,
                      height: 14 * PdfPageFormat.mm,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            // Row 1：Name
            pw.Table(
              border: const pw.TableBorder(
                top: borderSide,
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const pw.FixedColumnWidth(24 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      'Name',
                      isLabel: true,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                    ),
                    _textCell(d.name),
                  ],
                ),
              ],
            ),

            // Row 2：DOB / Sex / ID
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const pw.FixedColumnWidth(24 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(1.3),
                2: const pw.FixedColumnWidth(14 * PdfPageFormat.mm),
                3: const pw.FixedColumnWidth(36 * PdfPageFormat.mm),
                4: const pw.FixedColumnWidth(22 * PdfPageFormat.mm),
                5: const pw.FlexColumnWidth(2.0),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      'Date of Birth',
                      isLabel: true,
                      size: 8.5,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                    ),
                    _textCell(d.dateOfBirth, size: 9),
                    _textCell(
                      'Sex',
                      isLabel: true,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                    ),
                    _cell(
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          _pdfCheckBox('Male', _isMale(d.sex)),
                          _pdfCheckBox('Female', _isFemale(d.sex)),
                        ],
                      ),
                    ),
                    _textCell('ID/Passport\nNo', isLabel: true, size: 8),
                    _textCell(d.idOrPassportNo, size: 9),
                  ],
                ),
              ],
            ),

            // Row 3：Nationality (aligned with DOB row layout)
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const pw.FixedColumnWidth(24 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      'Nationality',
                      isLabel: true,
                      size: 8.5,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                    ),
                    _textCell(d.nationality, size: 9),
                  ],
                ),
              ],
            ),

            // Row 4：Impression
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(24 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      'Impression',
                      isLabel: true,
                      height: 60 * PdfPageFormat.mm,
                    ),
                    _cell(
                      pw.Text(
                        d.impression,
                        style: ts(),
                        textAlign: pw.TextAlign.left,
                      ),
                      height: 60 * PdfPageFormat.mm,
                      align: pw.Alignment.topLeft,
                    ),
                  ],
                ),
              ],
            ),

            // Row 5：Comments and Advices
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(24 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      'Comments\nAnd Advices',
                      isLabel: true,
                      height: 50 * PdfPageFormat.mm,
                      size: 8.5,
                    ),
                    _cell(
                      pw.Text(
                        d.commentsAndAdvices,
                        style: ts(),
                        textAlign: pw.TextAlign.left,
                      ),
                      height: 50 * PdfPageFormat.mm,
                      align: pw.Alignment.topLeft,
                    ),
                  ],
                ),
              ],
            ),

            // Row 6：Bottom Info
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
              ),
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'This is to certify that the above patient was examined.',
                            style: ts(size: 10),
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            children: [
                              pw.Text(
                                'President: ',
                                style: ts(bold: true, size: 9),
                              ),
                              pw.Container(
                                width: 40 * PdfPageFormat.mm,
                                child: pw.Text(d.director, style: ts(size: 9)),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Text(
                                'Attending Physician: ',
                                style: ts(bold: true, size: 9),
                              ),
                              pw.Text(d.attendingPhysician, style: ts(size: 9)),
                            ],
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'Address: No 15, Hangjan S.Rd, Dayuan dist., Taoyuan, Taiwan.',
                            style: ts(size: 8),
                          ),
                          pw.Text('TEL: +886-3-398-3456', style: ts(size: 8)),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                'Issue Date: ',
                                style: ts(bold: true, size: 9),
                              ),
                              pw.Text(d.issuedDate, style: ts(size: 9)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );

        return pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Container(
            width: 166 * PdfPageFormat.mm,
            child: mainContent,
          ),
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
