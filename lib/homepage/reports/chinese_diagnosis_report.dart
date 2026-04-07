import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' as math;

class ChineseDiagnosisReportData {
  final String name;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final String gender;
  final String idOrPassport;
  final String diagnosisCategory;
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
    required this.diagnosisCategory,
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

  const borderSide = pw.BorderSide(width: 0.8, color: PdfColors.black);

  pw.TextStyle ts({double size = 10, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: size);

  // 載入標題簽章圖片
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

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16 * PdfPageFormat.mm),
      build: (ctx) {
        // 先忽略右側警語區，將主表格與標題置中
        const titleBlockHeight = 30 * PdfPageFormat.mm;
        const warningTopOffset = titleBlockHeight + 8 * PdfPageFormat.mm;

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
                          '聯新國際醫院桃園國際機場醫療中心',
                          style: ts(bold: true, size: 16),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Text('診 斷 證 明 書', style: ts(bold: true, size: 15)),
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

            // Row 1：姓名
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
                0: const pw.FixedColumnWidth(20 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      '姓  名',
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

            // Row 2：出生、性別、證件 (6欄)
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const pw.FixedColumnWidth(20 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(2.3),
                2: const pw.FixedColumnWidth(15 * PdfPageFormat.mm),
                3: const pw.FixedColumnWidth(32 * PdfPageFormat.mm),
                4: const pw.FixedColumnWidth(24 * PdfPageFormat.mm),
                5: const pw.FlexColumnWidth(1.2),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      '出生日期',
                      isLabel: true,
                      size: 9,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                    ),
                    _textCell(
                      '西元 ${d.birthYear} 年 ${d.birthMonth} 月 ${d.birthDay} 日',
                      size: 9,
                    ),
                    _textCell(
                      '性別',
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
                          _pdfCheckBox('男性', d.gender == '男', font),
                          _pdfCheckBox('女性', d.gender == '女', font),
                        ],
                      ),
                    ),
                    _textCell('身份證號碼\n或護照號碼', isLabel: true, size: 8),
                    _textCell(d.idOrPassport, size: 9),
                  ],
                ),
              ],
            ),

            // Row 3：診斷
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(20 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      '診\n斷',
                      isLabel: true,
                      height: 60 * PdfPageFormat.mm,
                    ),
                    _cell(
                      pw.Text(
                        d.diagnosisCategory.isNotEmpty
                            ? '${d.diagnosisCategory}\n\n'
                                  '${d.diagnosis}'
                            : d.diagnosis,
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

            // Row 4：醫師囑言
            pw.Table(
              border: const pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                verticalInside: borderSide,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(20 * PdfPageFormat.mm),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    _textCell(
                      '醫\n師\n囑\n言\n或\n備\n註',
                      isLabel: true,
                      height: 50 * PdfPageFormat.mm,
                    ),
                    _cell(
                      pw.Text(
                        d.doctorNotes,
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

            // Row 5：底部證明資訊 (包含在表格內)
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
                          pw.Text('以上病人經本院醫師診斷屬實特予證明', style: ts(size: 11)),
                          pw.SizedBox(height: 15),
                          // 院長與醫師姓名 (無底線)
                          pw.Row(
                            children: [
                              pw.Text('院長：', style: ts(bold: true)),
                              pw.Container(
                                width: 40 * PdfPageFormat.mm,
                                child: pw.Text(d.director, style: ts()),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Text('診治醫師：', style: ts(bold: true)),
                              pw.Text(d.treatingDoctor, style: ts()),
                            ],
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text('開業執照號碼：桃衛醫診字第3432060513號', style: ts()),
                          pw.SizedBox(height: 20),
                          // 簽發日期 (無底線)
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text('西元 ', style: ts()),
                              pw.Text(d.certYear, style: ts()),
                              pw.Text(' 年 ', style: ts()),
                              pw.Text(d.certMonth, style: ts()),
                              pw.Text(' 月 ', style: ts()),
                              pw.Text(d.certDay, style: ts()),
                              pw.Text(' 日', style: ts()),
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

        return pw.Stack(
          children: [
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                width: 166 * PdfPageFormat.mm,
                child: mainContent,
              ),
            ),
            pw.Positioned(
              right: 0,
              top: warningTopOffset,
              child: pw.Container(
                width: 8 * PdfPageFormat.mm,
                child: pw.Text(
                  '◎\n本\n證\n明\n書\n須\n加\n蓋\n本\n院\n印\n章\n否\n則\n無\n效\n◎',
                  style: ts(size: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}

// 勾選框元件
pw.Widget _pdfCheckBox(String label, bool checked, pw.Font font) {
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
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10)),
    ],
  );
}
