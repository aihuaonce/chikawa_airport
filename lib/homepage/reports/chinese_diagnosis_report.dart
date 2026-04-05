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

  const borderSide = pw.BorderSide(width: 0.8, color: PdfColors.black);

  pw.TextStyle ts({double size = 10, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: size);

  // 輔助方法：儲存格容器
  pw.Widget _cell(pw.Widget child, {double? height, pw.Alignment? align}) {
    return pw.Container(
      height: height,
      padding: const pw.EdgeInsets.all(6),
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
  }) {
    return _cell(
      pw.Text(
        text,
        style: ts(bold: isLabel, size: size ?? (isLabel ? 10 : 10)),
        textAlign: pw.TextAlign.center,
      ),
      height: height,
      align: align ?? (isLabel ? pw.Alignment.center : pw.Alignment.centerLeft),
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20 * PdfPageFormat.mm),
      build: (ctx) {
        // 使用 Row 將主表格與側邊標語分開
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // 左側：診斷書主體
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // 標題
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          '聯新國際醫院桃園國際機場醫療中心',
                          style: ts(bold: true, size: 16),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text('診 斷 證 明 書', style: ts(bold: true, size: 15)),
                        pw.SizedBox(height: 15),
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
                    columnWidths: {
                      0: const pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                      1: const pw.FlexColumnWidth(),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          _textCell('姓  名', isLabel: true),
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
                    columnWidths: {
                      0: const pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                      1: const pw.FlexColumnWidth(1.8),
                      2: const pw.FixedColumnWidth(15 * PdfPageFormat.mm),
                      3: const pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                      4: const pw.FixedColumnWidth(30 * PdfPageFormat.mm),
                      5: const pw.FlexColumnWidth(1.5),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          _textCell('出生日期', isLabel: true, size: 9),
                          _textCell(
                            '西元 ${d.birthYear} 年 ${d.birthMonth} 月 ${d.birthDay} 日',
                            size: 9,
                          ),
                          _textCell('性別', isLabel: true),
                          _cell(
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceAround,
                              children: [
                                _pdfCheckBox('男', d.gender == '男', font),
                                _pdfCheckBox('女', d.gender == '女', font),
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
                      0: const pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                      1: const pw.FlexColumnWidth(),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          _textCell(
                            '\n診\n\n斷\n',
                            isLabel: true,
                            height: 60 * PdfPageFormat.mm,
                          ),
                          _textCell(
                            d.diagnosis,
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
                      0: const pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                      1: const pw.FlexColumnWidth(),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          _textCell(
                            '\n醫\n師\n囑\n言\n或\n備\n註\n',
                            isLabel: true,
                            height: 50 * PdfPageFormat.mm,
                          ),
                          _textCell(
                            d.doctorNotes,
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
                                pw.Text(
                                  '以上病人經本院醫師診斷屬實特予證明',
                                  style: ts(size: 11),
                                ),
                                pw.SizedBox(height: 15),
                                // 院長與醫師姓名 (無底線)
                                pw.Row(
                                  children: [
                                    pw.Text('院長：', style: ts(bold: true)),
                                    pw.Text(d.director, style: ts()),
                                    pw.SizedBox(width: 25),
                                    pw.Text('診治醫師：', style: ts(bold: true)),
                                    pw.Text(d.treatingDoctor, style: ts()),
                                  ],
                                ),
                                pw.SizedBox(height: 10),
                                pw.Text(
                                  '開業執照號碼：桃衛醫診字第3432060513號',
                                  style: ts(),
                                ),
                                pw.SizedBox(height: 20),
                                // 簽發日期 (無底線)
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
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
              ),
            ),

            // 右側：警告標語 (表格外，獨立佈局)
            pw.SizedBox(width: 8 * PdfPageFormat.mm),
            pw.Container(
              width: 10 * PdfPageFormat.mm,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Transform.rotate(
                    angle: -math.pi / 2,
                    child: pw.Text(
                      '◎ 本 證 明 書 須 加 蓋 本 院 印 章 否 則 無 效 ◎',
                      style: ts(size: 8),
                      softWrap: false,
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

// 勾選框元件
pw.Widget _pdfCheckBox(String label, bool checked, pw.Font font) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Container(
        width: 10,
        height: 10,
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
        child: checked
            ? pw.Center(
                child: pw.Text(
                  'v',
                  style: pw.TextStyle(font: font, fontSize: 8),
                ),
              )
            : null,
      ),
      pw.SizedBox(width: 4),
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10)),
    ],
  );
}
