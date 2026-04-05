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

  pw.TextStyle ts({double size = 10, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: size);

  // 輔助方法：建立單一 Cell
  pw.Widget _cell(
    String text, {
    bool isLabel = false,
    double? height,
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      height: height,
      padding: const pw.EdgeInsets.all(6),
      alignment: align,
      child: pw.Text(text, style: ts(bold: isLabel)),
    );
  }

  // 定義邊框樣式，避免重複線條
  const borderSide = pw.BorderSide(width: 0.8, color: PdfColors.black);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Column(
          children: [
            // --- 標題 ---
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Landseed Medical Clinic at TaiwanTaoyuan Int\'l Airport',
                    style: ts(bold: true, size: 13),
                  ),
                  pw.Text(
                    'Medical Certificate',
                    style: ts(bold: true, size: 12),
                  ),
                  pw.SizedBox(height: 15),
                ],
              ),
            ),

            // --- Row 1: Name (獨立 2 欄表格) ---
            pw.Table(
              border: const pw.TableBorder(
                top: borderSide,
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(35 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [_cell('Name', isLabel: true), _cell(d.name)],
                ),
              ],
            ),

            // --- Row 2 & 3: 4 欄位內容 (獨立 4 欄表格) ---
            // 注意：頂部不畫線，避免跟上面的表格重疊變粗
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
                horizontalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(35 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
                2: const pw.FixedColumnWidth(30 * PdfPageFormat.mm),
                3: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _cell('Date of Birth', isLabel: true),
                    _cell(d.dateOfBirth),
                    _cell('Sex', isLabel: true),
                    _cell(d.sex),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _cell('Nationality', isLabel: true),
                    _cell(d.nationality),
                    _cell('ID No or\nPassport No', isLabel: true),
                    _cell(d.idOrPassportNo),
                  ],
                ),
              ],
            ),

            // --- Row 4 & 5: 大空間內容 (獨立 2 欄表格) ---
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
                horizontalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(35 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _cell('Impression', isLabel: true, height: 100),
                    _cell(
                      d.impression,
                      height: 100,
                      align: pw.Alignment.topLeft,
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _cell('Comments\nAnd Advices', isLabel: true, height: 160),
                    _cell(
                      d.commentsAndAdvices,
                      height: 160,
                      align: pw.Alignment.topLeft,
                    ),
                  ],
                ),
              ],
            ),

            // --- Row 6: 底部資訊 ---
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  left: borderSide,
                  right: borderSide,
                  bottom: borderSide,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'President: CHIN-YU LIU',
                        style: ts(bold: true, size: 9),
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Attending physician: ',
                            style: ts(bold: true, size: 9),
                          ),
                          pw.Container(
                            width: 40 * PdfPageFormat.mm,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(width: 0.5),
                              ),
                            ),
                            child: pw.Text(
                              d.attendingPhysician,
                              style: ts(size: 9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Address: No 15, Hangjan S.Rd, Dayuan dist., Taoyuan, Taiwan.',
                    style: ts(size: 8),
                  ),
                  pw.Text('TEL: +886-3-398-3456', style: ts(size: 8)),
                  pw.SizedBox(height: 5),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('Issue Date: ', style: ts(bold: true, size: 9)),
                        pw.Container(
                          width: 35 * PdfPageFormat.mm,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(width: 0.5),
                            ),
                          ),
                          child: pw.Text(d.issuedDate, style: ts(size: 9)),
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

  return await pdf.save();
}
