import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EmergencyReportData {
  final String name;
  final String id;
  final String gender;
  final String birthDate;
  final String passportNo;

  final String source;
  final String airline;
  final String incidentLocation;
  final String nationality;

  final String diagnosis;
  final String incidentDateYear;
  final String incidentDateMonth;
  final String incidentDateDay;
  final String incidentTime;
  final String emergencyStartTime;
  final String incidentSituation;

  final String consciousnessE;
  final String consciousnessM;
  final String consciousnessV;
  final String heartRate;
  final String breathingRate;
  final String temperature;
  final String bpSystolic;
  final String bpDiastolic;

  final String pupilSizeL;
  final String pupilSizeR;
  final String pupilLR;

  final String onET;
  final String onIVLine;

  final List<String> monitorTime;
  final List<String> monitorHR;
  final List<String> monitorBP;
  final List<String> monitorBreathing;
  final List<String> monitorO2;
  final List<String> monitorDCShock;
  final List<String> monitorEpi;
  final List<String> monitorMeds;

  final String postConsciousnessE;
  final String postConsciousnessM;
  final String postConsciousnessV;
  final String postHeartRate;
  final String postBpSystolic;
  final String postBpDiastolic;
  final String postBreathing;
  final String postBreathingRate;
  final String postPupilSizeL;
  final String postPupilSizeR;
  final String postOther;

  final String endTimeHour;
  final String endTimeMin;
  final String outcomeType;
  final String transferHospital;
  final String transferTimeHour;
  final String transferTimeMin;
  final String deathTimeHour;
  final String deathTimeMin;
  final String otherOutcome;

  final String doctor;
  final String nurse;
  final String emt;

  const EmergencyReportData({
    required this.name,
    required this.id,
    required this.gender,
    required this.birthDate,
    required this.passportNo,
    required this.source,
    required this.airline,
    required this.incidentLocation,
    required this.nationality,
    required this.diagnosis,
    required this.incidentDateYear,
    required this.incidentDateMonth,
    required this.incidentDateDay,
    required this.incidentTime,
    required this.emergencyStartTime,
    required this.incidentSituation,
    required this.consciousnessE,
    required this.consciousnessM,
    required this.consciousnessV,
    required this.heartRate,
    required this.breathingRate,
    required this.temperature,
    required this.bpSystolic,
    required this.bpDiastolic,
    required this.pupilSizeL,
    required this.pupilSizeR,
    required this.pupilLR,
    required this.onET,
    required this.onIVLine,
    required this.monitorTime,
    required this.monitorHR,
    required this.monitorBP,
    required this.monitorBreathing,
    required this.monitorO2,
    required this.monitorDCShock,
    required this.monitorEpi,
    required this.monitorMeds,
    required this.postConsciousnessE,
    required this.postConsciousnessM,
    required this.postConsciousnessV,
    required this.postHeartRate,
    required this.postBpSystolic,
    required this.postBpDiastolic,
    required this.postBreathing,
    required this.postBreathingRate,
    required this.postPupilSizeL,
    required this.postPupilSizeR,
    required this.postOther,
    required this.endTimeHour,
    required this.endTimeMin,
    required this.outcomeType,
    required this.transferHospital,
    required this.transferTimeHour,
    required this.transferTimeMin,
    required this.deathTimeHour,
    required this.deathTimeMin,
    required this.otherOutcome,
    required this.doctor,
    required this.nurse,
    required this.emt,
  });
}

Future<Uint8List> buildEmergencyReportPdf(EmergencyReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pw.TextStyle ts({double size = 7.5, bool bold = false, PdfColor? c}) =>
      pw.TextStyle(
        font: bold ? fontB : font,
        fontSize: size,
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

  pw.Widget c(
    String t, {
    bool bold = false,
    pw.Alignment? align,
    pw.EdgeInsets? pad,
    double size = 7.5,
    double? h,
  }) => pw.Container(
    height: h,
    padding: pad ?? const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    alignment: align ?? pw.Alignment.centerLeft,
    child: pw.Text(
      t,
      style: ts(bold: bold, size: size),
    ),
  );

  pw.Widget chkbox(bool checked) => pw.Container(
    width: 8,
    height: 8,
    margin: const pw.EdgeInsets.only(right: 2),
    decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.6)),
    child: checked
        ? pw.Center(
            child: pw.Text('✓', style: pw.TextStyle(font: font, fontSize: 6)),
          )
        : null,
  );

  pw.Widget chkLabel(String label, bool checked) => pw.Row(
    children: [
      chkbox(checked),
      pw.Text(label, style: ts()),
      pw.SizedBox(width: 3),
    ],
  );

  pw.Widget uv(String val, {double w = 20}) => pw.Container(
    width: w * PdfPageFormat.mm,
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey600),
      ),
    ),
    child: pw.Text(val, style: ts()),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 10 * PdfPageFormat.mm,
        vertical: 10 * PdfPageFormat.mm,
      ),
      build: (ctx) {
        pw.FixedColumnWidth colW(double value) => pw.FixedColumnWidth(value);
        pw.FlexColumnWidth flexW([double value = 1]) =>
            pw.FlexColumnWidth(value);

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                '聯新國際醫院桃園國際機場醫療中心急救記錄表',
                style: ts(size: 13, bold: true),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(14),
                1: flexW(2),
                2: colW(10),
                3: flexW(2),
                4: colW(18),
                5: colW(14),
                6: flexW(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    c('姓名', bold: true),
                    c(d.name),
                    c('ID', bold: true),
                    c(d.id),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 2,
                      ),
                      child: pw.Row(
                        children: [
                          chkLabel('男', d.gender == '男'),
                          chkLabel('女', d.gender == '女'),
                        ],
                      ),
                    ),
                    c('生日(西元)', bold: true),
                    c(d.birthDate),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(14),
                1: flexW(1.5),
                2: colW(14),
                3: flexW(1.5),
                4: colW(14),
                5: flexW(1.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    c('護照號碼', bold: true),
                    c(d.passportNo),
                    c('來源', bold: true),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                      child: pw.Wrap(
                        spacing: 2,
                        children: [
                          chkLabel('出境', d.source == '出境'),
                          chkLabel('入境', d.source == '入境'),
                          chkLabel('過境', d.source == '過境'),
                          chkLabel('其他', d.source == '其他'),
                        ],
                      ),
                    ),
                    c('航空公司', bold: true),
                    c(d.airline),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(14),
                1: flexW(2),
                2: colW(14),
                3: flexW(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    c('發生地點', bold: true),
                    c(d.incidentLocation),
                    c('國籍', bold: true),
                    c(d.nationality),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(10),
                1: flexW(2),
                2: colW(18),
                3: flexW(3),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      height: 28 * PdfPageFormat.mm,
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Center(
                        child: pw.Text('診  斷', style: ts(bold: true)),
                      ),
                    ),
                    pw.Container(
                      height: 28 * PdfPageFormat.mm,
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Align(
                        alignment: pw.Alignment.topLeft,
                        child: pw.Text(d.diagnosis, style: ts()),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('發生日期', style: ts(bold: true)),
                          pw.Text('發生時間', style: ts(bold: true)),
                          pw.Text('急救開始時間', style: ts(bold: true)),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text(
                            '${d.incidentDateYear} 年 ${d.incidentDateMonth} 月 '
                            '${d.incidentDateDay} 日',
                            style: ts(),
                          ),
                          pw.Text(d.incidentTime, style: ts()),
                          pw.Text(d.emergencyStartTime, style: ts()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {0: colW(14), 1: flexW(1)},
              children: [
                pw.TableRow(
                  children: [
                    c('發生情境', bold: true),
                    c(d.incidentSituation, h: 14 * PdfPageFormat.mm),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(10),
                1: colW(10),
                2: colW(30),
                3: colW(30),
                4: colW(10),
                5: flexW(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        '病\n況',
                        style: ts(bold: true),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('意識', style: ts(bold: true)),
                          pw.SizedBox(height: 3),
                          pw.Text('呼吸', style: ts(bold: true)),
                          pw.SizedBox(height: 3),
                          pw.Text('溫度', style: ts(bold: true)),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('E ', style: ts(bold: true)),
                              pw.Text(d.consciousnessE, style: ts()),
                              pw.Text('  M ', style: ts(bold: true)),
                              pw.Text(d.consciousnessM, style: ts()),
                              pw.Text('  V ', style: ts(bold: true)),
                              pw.Text(d.consciousnessV, style: ts()),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          pw.Row(
                            children: [
                              pw.Text('${d.breathingRate} 次/分', style: ts()),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          pw.Row(
                            children: [
                              chkLabel('冰冷', d.temperature == '冰冷'),
                              chkLabel('溫暖', d.temperature == '溫暖'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('心跳: ${d.heartRate} 次/分', style: ts()),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '血壓: ${d.bpSystolic}/${d.bpDiastolic} mmHg',
                            style: ts(),
                          ),
                        ],
                      ),
                    ),
                    c('瞳孔', bold: true),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Size  左: ${d.pupilSizeL} mm  右: ${d.pupilSizeR} mm',
                            style: ts(),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text('L-R', style: ts(bold: true)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(20),
                1: flexW(2),
                2: colW(30),
                3: flexW(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    c('急救處置', bold: true),
                    c('時間及記錄', bold: true),
                    c('急救處置', bold: true),
                    c('時間及記錄', bold: true),
                  ],
                ),
                pw.TableRow(
                  children: [
                    c('On E.T  # ${d.onET}'),
                    c(''),
                    c('Cardiac Massage'),
                    c(''),
                  ],
                ),
                pw.TableRow(
                  children: [
                    c('On IV Line  # ${d.onIVLine}'),
                    c(''),
                    c(''),
                    c(''),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(28),
                ...{for (int i = 1; i <= 10; i++) i: flexW(1)},
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    c('項目', bold: true),
                    ...List.generate(
                      10,
                      (i) => pw.Center(
                        child: pw.Text(
                          '${i + 1}',
                          style: ts(bold: true, size: 7),
                        ),
                      ),
                    ),
                  ],
                ),
                _monitorRow('時間(Time)', d.monitorTime, font, fontB),
                _monitorRow('心跳 bpm', d.monitorHR, font, fontB),
                _monitorRow('血壓 mmHg', d.monitorBP, font, fontB),
                _monitorRow('呼吸 次/分', d.monitorBreathing, font, fontB),
                _monitorRow('O2 (L/Min;%)', d.monitorO2, font, fontB),
                _monitorRow('DC Shock (J)', d.monitorDCShock, font, fontB),
                _monitorRow('Epinephrine(mg)', d.monitorEpi, font, fontB),
                _monitorRow('用  藥', d.monitorMeds, font, fontB, rowH: 12),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(10),
                1: colW(10),
                2: flexW(2),
                3: colW(8),
                4: flexW(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        '急\n救\n後\n病\n況',
                        style: ts(bold: true),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('意識', style: ts(bold: true)),
                          pw.SizedBox(height: 4),
                          pw.Text('呼吸', style: ts(bold: true)),
                          pw.SizedBox(height: 4),
                          pw.Text('其他', style: ts(bold: true)),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('E ', style: ts(bold: true)),
                              pw.Text(d.postConsciousnessE, style: ts()),
                              pw.Text('  M ', style: ts(bold: true)),
                              pw.Text(d.postConsciousnessM, style: ts()),
                              pw.Text('  V ', style: ts(bold: true)),
                              pw.Text(d.postConsciousnessV, style: ts()),
                              pw.Text(
                                '   心跳: ${d.postHeartRate} 次',
                                style: ts(),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                          pw.Row(
                            children: [
                              chkLabel('自發性呼吸', d.postBreathing == '自發性呼吸'),
                              chkLabel('呼吸器', d.postBreathing == '呼吸器'),
                              chkLabel('Ambu', d.postBreathing == 'Ambu'),
                              pw.Text(
                                ' ${d.postBreathingRate} 次/分 ',
                                style: ts(),
                              ),
                              pw.Text(
                                '血壓: ${d.postBpSystolic}/${d.postBpDiastolic} mmHg',
                                style: ts(),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(d.postOther, style: ts()),
                        ],
                      ),
                    ),
                    c('瞳孔', bold: true),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Size 左: ${d.postPupilSizeL} mm  右: '
                            '${d.postPupilSizeR} mm',
                            style: ts(),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text('L-R', style: ts(bold: true)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 2),
            pw.Table(
              border: tbl,
              columnWidths: {0: colW(14), 1: flexW(1)},
              children: [
                pw.TableRow(
                  children: [
                    c('結束時間', bold: true),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      child: pw.Row(
                        children: [
                          uv(d.endTimeHour, w: 12),
                          pw.Text(' 時 ', style: ts()),
                          uv(d.endTimeMin, w: 12),
                          pw.Text(' 分', style: ts()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {0: colW(14), 1: flexW(1)},
              children: [
                pw.TableRow(
                  children: [
                    c('急救結果', bold: true),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              chkLabel('轉診', d.outcomeType == '轉診'),
                              pw.Text('醫院 ', style: ts()),
                              uv(d.transferHospital, w: 45),
                              pw.Text('  時間: ', style: ts()),
                              uv(d.transferTimeHour, w: 10),
                              pw.Text(' 時 ', style: ts()),
                              uv(d.transferTimeMin, w: 10),
                              pw.Text(' 分', style: ts()),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          pw.Row(
                            children: [
                              chkLabel('死亡', d.outcomeType == '死亡'),
                              pw.Text('時間: ', style: ts()),
                              uv(d.deathTimeHour, w: 10),
                              pw.Text(' 時 ', style: ts()),
                              uv(d.deathTimeMin, w: 10),
                              pw.Text(' 分', style: ts()),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          pw.Row(
                            children: [
                              chkLabel('其他', d.outcomeType == '其他'),
                              uv(d.otherOutcome, w: 40),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Table(
              border: tbl,
              columnWidths: {
                0: colW(14),
                1: flexW(1),
                2: colW(14),
                3: flexW(1),
                4: colW(14),
                5: flexW(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    c('急救人員', bold: true),
                    c(''),
                    c('醫師: ${d.doctor}'),
                    c('護理師: ${d.nurse}'),
                    c('EMT:', bold: true),
                    c(d.emt),
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

pw.TableRow _monitorRow(
  String label,
  List<String> vals,
  pw.Font font,
  pw.Font fontB, {
  double rowH = 9,
}) {
  pw.TextStyle ts({bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: 7);

  return pw.TableRow(
    children: [
      pw.Container(
        height: rowH * PdfPageFormat.mm,
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: pw.Center(
          child: pw.Text(
            label,
            style: ts(bold: true),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ),
      ...List.generate(
        10,
        (i) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: pw.Center(child: pw.Text(vals[i], style: ts())),
        ),
      ),
    ],
  );
}
