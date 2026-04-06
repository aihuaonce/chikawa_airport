import 'dart:math' as math;
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
  final String pupilReactionL;
  final String pupilReactionR;

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
  final String postPupilReactionL;
  final String postPupilReactionR;
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
    required this.pupilReactionL,
    required this.pupilReactionR,
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
    required this.postPupilReactionL,
    required this.postPupilReactionR,
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

  // 安全總寬度維持182mm
  final double totalW = 182.0;
  final borderSide = pw.BorderSide(width: 0.6, color: PdfColors.black);

  pw.TextStyle ts({double size = 8, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: size);

  // --- 核心儲存格方法：處理邊框與高度---
  pw.Widget _cell(
    pw.Widget child, {
    required double width,
    double minHeight = 10.0,
    pw.Alignment? align,
    bool isFirstColumn = false, // 是否為該行最左格 (畫左線)
    bool isFirstRow = false, // 是否為整表最頂行 (畫頂線)
  }) {
    return pw.Container(
      width: width * PdfPageFormat.mm,
      constraints: pw.BoxConstraints(minHeight: minHeight * PdfPageFormat.mm),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: isFirstRow ? borderSide : pw.BorderSide.none,
          left: isFirstColumn ? borderSide : pw.BorderSide.none,
          right: borderSide,
          bottom: borderSide,
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      alignment: align ?? pw.Alignment.centerLeft,
      child: child,
    );
  }

  // --- 標籤格方法：統一參數命名 ---
  pw.Widget _lb(
    String t, {
    required double width,
    double minHeight = 10.0,
    bool isFirstColumn = false,
    bool isFirstRow = false,
  }) => _cell(
    pw.Text(t, style: ts(bold: true), textAlign: pw.TextAlign.center),
    width: width,
    minHeight: minHeight,
    align: pw.Alignment.center,
    isFirstColumn: isFirstColumn,
    isFirstRow: isFirstRow,
  );

  pw.Widget _chk(String label, bool checked) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 8.5,
          height: 8.5,
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.6)),
          child: checked ? pw.Container(color: PdfColors.black) : null,
        ),
        pw.SizedBox(width: 2.5),
        pw.Text(label, style: ts(size: 8)),
        pw.SizedBox(width: 3.5),
      ],
    );
  }

  bool _hasOutcomeData(String outcomeType, EmergencyReportData d) {
    switch (outcomeType) {
      case '轉診':
        return d.transferHospital.trim().isNotEmpty ||
            d.transferTimeHour.trim().isNotEmpty ||
            d.transferTimeMin.trim().isNotEmpty;
      case '死亡':
        return d.deathTimeHour.trim().isNotEmpty ||
            d.deathTimeMin.trim().isNotEmpty;
      case '其他':
        return d.otherOutcome.trim().isNotEmpty;
      default:
        return false;
    }
  }

  pw.Widget _lineBox(String text, double width) {
    return pw.Container(
      width: width * PdfPageFormat.mm,
      padding: const pw.EdgeInsets.only(bottom: 1),
      child: pw.Text(text, style: ts()),
    );
  }

  pw.Widget _chkSmall(String label, bool checked) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 8.5,
          height: 8.5,
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.6)),
          child: checked ? pw.Container(color: PdfColors.black) : null,
        ),
        pw.SizedBox(width: 2.5),
        pw.Text(label, style: ts(size: 7)),
        pw.SizedBox(width: 3.5),
      ],
    );
  }

  bool _hasBreathingMode(String value, String keyword) {
    return value.contains(keyword);
  }

  bool _hasAmbu(String value) {
    return value.toLowerCase().contains('ambu');
  }

  pw.Widget _emptyBox({double size = 8, bool filled = false}) {
    return pw.Container(
      width: size,
      height: size,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.6),
        color: filled ? PdfColors.black : PdfColors.white,
      ),
    );
  }

  pw.Widget _pupilSizeSide(String label, String value) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$label:', style: ts()),
        pw.SizedBox(width: 1.5),
        pw.Text(value, style: ts()),
        pw.SizedBox(width: 1.5),
        pw.Text('mm', style: ts()),
      ],
    );
  }

  String _normalizeReaction(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.contains('±')) return '±';
    if (trimmed.contains('+/-')) return '±';
    if (trimmed.contains('+') || trimmed.contains('＋')) return '+';
    if (trimmed.contains('-') || trimmed.contains('－')) return '-';
    return trimmed;
  }

  pw.Widget _pupilLrSide(String label, String reaction) {
    final normalized = _normalizeReaction(reaction);
    final isPlus = normalized == '+';
    final isMinus = normalized == '-';
    final isPlusMinus = normalized == '±';
    final signStyle = ts(size: 9, bold: true);
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$label:', style: ts()),
        pw.SizedBox(width: 1.5),
        _emptyBox(filled: isPlus),
        pw.SizedBox(width: 1.5),
        pw.Text('+', style: signStyle),
        pw.SizedBox(width: 1.5),
        _emptyBox(filled: isMinus),
        pw.SizedBox(width: 1.5),
        pw.Text('-', style: signStyle),
        pw.SizedBox(width: 1.5),
        _emptyBox(filled: isPlusMinus),
        pw.SizedBox(width: 1.5),
        pw.Text('±', style: signStyle),
      ],
    );
  }

  bool _isStandardSource(String value) {
    switch (value.trim()) {
      case '出境':
      case '入境':
      case '過境':
        return true;
      default:
        return false;
    }
  }

  bool _isSpecialSource(String value) {
    const special = {'轉機', '迫降', '轉降', '備降', '技術性降落'};
    return special.contains(value.trim());
  }

  String _otherSourceLabel(String source) {
    final trimmed = source.trim();
    if (_isSpecialSource(trimmed)) {
      return '其他：$trimmed';
    }
    return '其他';
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(12 * PdfPageFormat.mm),
      build: (ctx) {
        final otherSourceLabel = _otherSourceLabel(d.source);
        final isOtherSource =
            d.source.trim().isNotEmpty && !_isStandardSource(d.source);
        return [
          pw.Center(
            child: pw.Text(
              '聯新國際醫院桃園國際機場醫療中心急救記錄表',
              style: ts(size: 13, bold: true),
            ),
          ),
          pw.SizedBox(height: 6),

          pw.Column(
            children: [
              // Row 1: 姓名/ID/性別/生日/護照 (整表最頂行 isFirstRow: true)
              pw.Row(
                children: [
                  _lb('姓名', width: 12, isFirstColumn: true, isFirstRow: true),
                  _cell(
                    pw.Text(d.name, style: ts()),
                    width: 24,
                    isFirstRow: true,
                  ),
                  _lb('ID', width: 10, isFirstRow: true),
                  _cell(
                    pw.Text(d.id, style: ts()),
                    width: 25,
                    isFirstRow: true,
                  ),
                  _cell(
                    pw.Row(
                      children: [
                        _chk('男性', d.gender == '男'),
                        _chk('女性', d.gender == '女'),
                      ],
                    ),
                    width: 24,
                    isFirstRow: true,
                  ),
                  _lb('生日', width: 15, isFirstRow: true),
                  _cell(
                    pw.Text(d.birthDate, style: ts()),
                    width: 25,
                    isFirstRow: true,
                  ),
                  _lb('護照號碼', width: 15, isFirstRow: true),
                  _cell(
                    pw.Text(d.passportNo, style: ts()),
                    width: 32,
                    isFirstRow: true,
                  ),
                ],
              ),

              // Row 2: 來源/航空公司/地點/國籍 (加高至 14mm)
              pw.Row(
                children: [
                  _lb('來源', width: 12, minHeight: 14, isFirstColumn: true),
                  _cell(
                    pw.Wrap(
                      runSpacing: 2,
                      children: [
                        _chk('出境', d.source == '出境'),
                        _chk('入境', d.source == '入境'),
                        _chk('過境', d.source == '過境'),
                        _chk(otherSourceLabel, isOtherSource),
                      ],
                    ),
                    width: 45,
                    minHeight: 14,
                  ),
                  _lb('航空公司', width: 18, minHeight: 14),
                  _cell(
                    pw.Text(d.airline, style: ts()),
                    width: 22,
                    minHeight: 14,
                  ),
                  _lb('發生地點', width: 18, minHeight: 14),
                  _cell(
                    pw.Text(d.incidentLocation, style: ts()),
                    width: 35,
                    minHeight: 14,
                  ),
                  _lb('國籍', width: 10, minHeight: 14),
                  _cell(
                    pw.Text(d.nationality, style: ts()),
                    width: 22,
                    minHeight: 14,
                  ),
                ],
              ),

              // Row 3 & 4: 診斷區
              pw.Row(
                children: [
                  _lb('診\n斷', width: 12, minHeight: 22, isFirstColumn: true),
                  _cell(
                    pw.Text(d.diagnosis, style: ts()),
                    width: 110,
                    minHeight: 22,
                  ),
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          _lb('發生日期', width: 20, minHeight: 11),
                          _cell(
                            pw.Text(
                              '${d.incidentDateYear}/${d.incidentDateMonth}/${d.incidentDateDay}',
                              style: ts(),
                            ),
                            width: 40,
                            minHeight: 11,
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          _lb('發生時間', width: 20, minHeight: 11),
                          _cell(
                            pw.Text(d.incidentTime, style: ts()),
                            width: 40,
                            minHeight: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Row 5: 發生情境
              pw.Row(
                children: [
                  _lb('發生情境', width: 12, minHeight: 12, isFirstColumn: true),
                  _cell(
                    pw.Text(d.incidentSituation, style: ts()),
                    width: 110,
                    minHeight: 12,
                  ),
                  _lb('急救開始', width: 20, minHeight: 12),
                  _cell(
                    pw.Text(d.emergencyStartTime, style: ts()),
                    width: 40,
                    minHeight: 12,
                  ),
                ],
              ),

              // Row 6: 病況
              pw.Row(
                children: [
                  _lb('病\n況', width: 12, minHeight: 24, isFirstColumn: true),
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('意識', style: ts()),
                            width: 12,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Row(
                              children: [
                                pw.Text('E', style: ts(bold: true)),
                                pw.Text(': ${d.consciousnessE}', style: ts()),
                                pw.SizedBox(width: 6),
                                pw.Text('M', style: ts(bold: true)),
                                pw.Text(': ${d.consciousnessM}', style: ts()),
                                pw.SizedBox(width: 6),
                                pw.Text('V', style: ts(bold: true)),
                                pw.Text(': ${d.consciousnessV}', style: ts()),
                              ],
                            ),
                            width: 40,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Text('心跳: ${d.heartRate} 次/分', style: ts()),
                            width: 38,
                            minHeight: 8,
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('呼吸', style: ts()),
                            width: 12,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Text('${d.breathingRate} 次/分', style: ts()),
                            width: 40,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Text(
                              '血壓: ${d.bpSystolic}/${d.bpDiastolic} mmHg',
                              style: ts(),
                            ),
                            width: 38,
                            minHeight: 8,
                          ),
                        ],
                      ),
                      _cell(
                        pw.Row(
                          children: [
                            pw.Text('溫度: ', style: ts()),
                            _chk('冰冷', d.temperature == '冰冷'),
                            _chk('溫暖', d.temperature == '溫暖'),
                          ],
                        ),
                        width: 90,
                        minHeight: 8,
                      ),
                    ],
                  ),
                  _lb('瞳孔', width: 10, minHeight: 24),
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('Size', style: ts()),
                            width: 12,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilSizeSide('左', d.pupilSizeL),
                            width: 29,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilSizeSide('右', d.pupilSizeR),
                            width: 29,
                            minHeight: 12,
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('L-R', style: ts()),
                            width: 12,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilLrSide('左', d.pupilReactionL),
                            width: 29,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilLrSide('右', d.pupilReactionR),
                            width: 29,
                            minHeight: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Row 7, 8, 9: 處置
              pw.Row(
                children: [
                  _lb('急救處置', width: 45.5, isFirstColumn: true),
                  _lb('時間及記錄', width: 45.5),
                  _lb('急救處置', width: 45.5),
                  _lb('時間及記錄', width: 45.5),
                ],
              ),
              pw.Row(
                children: [
                  _cell(
                    pw.Text('On E.T # ${d.onET}', style: ts()),
                    width: 45.5,
                    isFirstColumn: true,
                  ),
                  _cell(pw.Text('', style: ts()), width: 45.5),
                  _cell(pw.Text('Cardiac Massage', style: ts()), width: 45.5),
                  _cell(pw.Text('', style: ts()), width: 45.5),
                ],
              ),
              pw.Row(
                children: [
                  _cell(
                    pw.Text('On IV Line # ${d.onIVLine}', style: ts()),
                    width: 45.5,
                    isFirstColumn: true,
                  ),
                  _cell(pw.Text('', style: ts()), width: 45.5),
                  _cell(pw.Text('', style: ts()), width: 45.5),
                  _cell(pw.Text('', style: ts()), width: 45.5),
                ],
              ),

              // Row 10: 監測網格
              pw.Row(
                children: [
                  _lb(
                    '急\n救\n處\n置\n及\n用\n藥',
                    width: 12,
                    minHeight: 70,
                    isFirstColumn: true,
                  ),
                  pw.Column(
                    children: [
                      _monitorRow(
                        '項目 \\ 次數',
                        List.generate(10, (i) => (i + 1).toString()),
                        fontB,
                        fontB,
                        10,
                      ),
                      _monitorRow('時間(Time)', d.monitorTime, font, fontB, 10),
                      _monitorRow('心跳 bpm', d.monitorHR, font, fontB, 10),
                      _monitorRow('血壓 mmHg', d.monitorBP, font, fontB, 10),
                      _monitorRow(
                        '呼吸 次/分',
                        d.monitorBreathing,
                        font,
                        fontB,
                        10,
                      ),
                      _monitorRow('O2 (L/Min)', d.monitorO2, font, fontB, 10),
                      _monitorRow(
                        'Shock(J)',
                        d.monitorDCShock,
                        font,
                        fontB,
                        10,
                      ),
                      _monitorRow('Epi (mg)', d.monitorEpi, font, fontB, 10),
                      _monitorRow(
                        '用藥',
                        d.monitorMeds,
                        font,
                        fontB,
                        10,
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),

              // Row 11: 急救後病況
              pw.Row(
                children: [
                  _lb(
                    '急\n救\n後\n病\n況',
                    width: 12,
                    minHeight: 24,
                    isFirstColumn: true,
                  ),
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('意識', style: ts()),
                            width: 10,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Row(
                              children: [
                                pw.Text('E', style: ts(bold: true)),
                                pw.Text(
                                  ': ${d.postConsciousnessE}',
                                  style: ts(),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Text('M', style: ts(bold: true)),
                                pw.Text(
                                  ': ${d.postConsciousnessM}',
                                  style: ts(),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Text('V', style: ts(bold: true)),
                                pw.Text(
                                  ': ${d.postConsciousnessV}',
                                  style: ts(),
                                ),
                              ],
                            ),
                            width: 57,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Text('心跳: ${d.postHeartRate} 次/分', style: ts()),
                            width: 29,
                            minHeight: 8,
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('呼吸', style: ts()),
                            width: 10,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Wrap(
                              spacing: 2,
                              runSpacing: 1,
                              children: [
                                _chkSmall(
                                  '自發性呼吸',
                                  _hasBreathingMode(d.postBreathing, '自發'),
                                ),
                                _chkSmall(
                                  '呼吸器',
                                  _hasBreathingMode(d.postBreathing, '呼吸器'),
                                ),
                                _chkSmall('Ambu', _hasAmbu(d.postBreathing)),
                                pw.Text(
                                  '${d.postBreathingRate} 次/分',
                                  style: ts(size: 7),
                                ),
                              ],
                            ),
                            width: 57,
                            minHeight: 8,
                          ),
                          _cell(
                            pw.Text(
                              '血壓: ${d.postBpSystolic}/${d.postBpDiastolic} mmHg',
                              style: ts(),
                            ),
                            width: 29,
                            minHeight: 8,
                          ),
                        ],
                      ),
                      _cell(
                        pw.Text('其他: ${d.postOther}', style: ts()),
                        width: 96,
                        minHeight: 8,
                      ),
                    ],
                  ),
                  _lb('瞳孔', width: 10, minHeight: 24),
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('Size', style: ts()),
                            width: 8,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilSizeSide('左', d.postPupilSizeL),
                            width: 28,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilSizeSide('右', d.postPupilSizeR),
                            width: 28,
                            minHeight: 12,
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          _cell(
                            pw.Text('L-R', style: ts()),
                            width: 8,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilLrSide('左', d.postPupilReactionL),
                            width: 28,
                            minHeight: 12,
                          ),
                          _cell(
                            _pupilLrSide('右', d.postPupilReactionR),
                            width: 28,
                            minHeight: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Row 12, 13, 14: 底部
              pw.Row(
                children: [
                  _lb('結束時間', width: 30, isFirstColumn: true),
                  _cell(
                    pw.Text(
                      '${d.endTimeHour} 時 ${d.endTimeMin} 分',
                      style: ts(),
                    ),
                    width: 152,
                  ),
                ],
              ),
              pw.Row(
                children: [
                  _lb('急救結果', width: 30, minHeight: 16, isFirstColumn: true),
                  _cell(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            _chk(
                              '轉診：',
                              d.outcomeType == '轉診' ||
                                  _hasOutcomeData('轉診', d),
                            ),
                            pw.SizedBox(width: 3),
                            _lineBox(d.transferHospital, 40),
                            pw.SizedBox(width: 6),
                            pw.Text('時間：', style: ts()),
                            _lineBox(d.transferTimeHour, 10),
                            pw.Text('時', style: ts()),
                            _lineBox(d.transferTimeMin, 10),
                            pw.Text('分', style: ts()),
                          ],
                        ),
                        pw.Row(
                          children: [
                            _chk(
                              '死亡',
                              d.outcomeType == '死亡' ||
                                  _hasOutcomeData('死亡', d),
                            ),
                            pw.Text('時間：', style: ts()),
                            _lineBox(d.deathTimeHour, 10),
                            pw.Text('時', style: ts()),
                            _lineBox(d.deathTimeMin, 10),
                            pw.Text('分', style: ts()),
                          ],
                        ),
                        pw.Row(
                          children: [
                            _chk(
                              '其他：',
                              d.outcomeType == '其他' ||
                                  _hasOutcomeData('其他', d),
                            ),
                            _lineBox(d.otherOutcome, 60),
                          ],
                        ),
                      ],
                    ),
                    width: 152,
                    minHeight: 16,
                  ),
                ],
              ),
              pw.Row(
                children: [
                  _lb('急救人員', width: 30, isFirstColumn: true),
                  _cell(pw.Text('醫師: ${d.doctor}', style: ts()), width: 50),
                  _cell(pw.Text('護理師: ${d.nurse}', style: ts()), width: 51),
                  _cell(pw.Text('EMT: ${d.emt}', style: ts()), width: 51),
                ],
              ),
            ],
          ),
        ];
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}

// 監測數據網格：同樣套用新邊框邏輯
pw.Widget _monitorRow(
  String label,
  List<String> data,
  pw.Font font,
  pw.Font fontB,
  int count, {
  double? height,
  PdfColor? bg,
}) {
  final double labelW = 25.0;
  final double totalGridW = 170.0;
  final double itemW = (totalGridW - labelW) / count;
  final borderSide = pw.BorderSide(width: 0.6, color: PdfColors.black);

  return pw.Row(
    children: [
      pw.Container(
        width: labelW * PdfPageFormat.mm,
        height: height != null
            ? height * PdfPageFormat.mm
            : 7.5 * PdfPageFormat.mm,
        decoration: pw.BoxDecoration(
          color: bg,
          border: pw.Border(right: borderSide, bottom: borderSide),
        ),
        alignment: pw.Alignment.center,
        child: pw.Text(label, style: pw.TextStyle(font: fontB, fontSize: 7)),
      ),
      ...List.generate(count, (index) {
        String val = index < data.length ? data[index] : "";
        return pw.Container(
          width: itemW * PdfPageFormat.mm,
          height: height != null
              ? height * PdfPageFormat.mm
              : 7.5 * PdfPageFormat.mm,
          decoration: pw.BoxDecoration(
            border: pw.Border(right: borderSide, bottom: borderSide),
          ),
          alignment: pw.Alignment.center,
          child: pw.Text(val, style: pw.TextStyle(font: font, fontSize: 7)),
        );
      }),
    ],
  );
}
