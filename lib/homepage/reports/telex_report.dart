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
  final String otherOutcomeDetail;
  final bool isEmptyRun;
  final String transferTo;

  final bool chargedYes;
  final bool chargedNo;
  final String chargedAmount;

  final String doctor;
  final String nurse;
  final Uint8List? doctorSignature;
  final Uint8List? nurseSignature;

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
    required this.otherOutcomeDetail,
    required this.isEmptyRun,
    required this.transferTo,
    required this.chargedYes,
    required this.chargedNo,
    required this.chargedAmount,
    required this.doctor,
    required this.nurse,
    required this.doctorSignature,
    required this.nurseSignature,
    required this.toTitle,
    required this.fromTitle,
    required this.toLines,
    required this.fromLines,
  });
}

// ============================================================================
// Constants & Theme
// ============================================================================

// PdfColor.fromHex is not const, so we use static colors
final _primaryColor = PdfColor.fromHex('#0D6E6E'); // Teal 700
final _sectionBgColor = PdfColor.fromHex('#F5F5F5');
final _borderColor = PdfColor.fromHex('#BDBDBD');
final _textDark = PdfColor.fromHex('#212121');
final _textMuted = PdfColor.fromHex('#757575');

const _spacerXs = 2.0;
const _spacerSm = 4.0;
const _spacerMd = 6.0;
const _spacerLg = 10.0;

// ============================================================================
// Main Build Function
// ============================================================================

Future<Uint8List> buildTelexPdf(TelexReportData d) async {
  final pdf = pw.Document();

  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 22 * PdfPageFormat.mm,
        vertical: 15 * PdfPageFormat.mm,
      ),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _buildHeader(font, fontB),
          pw.SizedBox(height: _spacerMd),
          pw.Divider(thickness: 0.8, color: _primaryColor),
          pw.SizedBox(height: _spacerMd),

          // ── Title ───────────────────────────────────────────────────────
          pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _primaryColor,
                borderRadius: pw.BorderRadius.circular(2),
              ),
              child: pw.Text(
                '出 診 診 療 服 務 電 傳 文 件',
                style: pw.TextStyle(
                  font: fontB,
                  fontSize: 14,
                  color: PdfColors.white,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: _spacerLg),

          // ── Fax Info Section ─────────────────────────────────────────────
          _buildFaxSection(
            d.toTitle,
            d.toLines,
            d.fromTitle,
            d.fromLines,
            font,
            fontB,
          ),
          pw.SizedBox(height: _spacerLg),

          // ── Patient Info Section ─────────────────────────────────────────
          _buildPatientSection(d, font, fontB),
          pw.SizedBox(height: _spacerMd),

          // ── Travel Info Section ──────────────────────────────────────────
          _buildTravelSection(d, font, fontB),
          pw.SizedBox(height: _spacerMd),

          // ── Incident Info Section ────────────────────────────────────────
          _buildIncidentSection(d, font, fontB),
          pw.SizedBox(height: _spacerMd),

          // ── Diagnosis Section ────────────────────────────────────────────
          _buildDiagnosisSection(d, font, fontB),
          pw.SizedBox(height: _spacerMd),

          // ── Outcome Section ───────────────────────────────────────────────
          _buildOutcomeSection(d, font, fontB),
          pw.SizedBox(height: _spacerMd),

          // ── Charges Section ─────────────────────────────────────────────
          _buildChargesSection(d, font, fontB),

          pw.Expanded(child: pw.SizedBox()),

          // ── Signature Section ────────────────────────────────────────────
          pw.SizedBox(height: _spacerLg),
          pw.Divider(thickness: 0.5, color: _borderColor),
          pw.SizedBox(height: _spacerMd),
          _buildSignatureSection(d, font, fontB),
          pw.SizedBox(height: _spacerMd),

          // ── Footer ───────────────────────────────────────────────────────
          _buildFooter(font),
        ],
      ),
    ),
  );

  return Uint8List.fromList(await pdf.save());
}

// ============================================================================
// Section Builders
// ============================================================================

pw.Widget _buildHeader(pw.Font font, pw.Font fontB) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      // Logo circle
      pw.Container(
        width: 12 * PdfPageFormat.mm,
        height: 12 * PdfPageFormat.mm,
        decoration: pw.BoxDecoration(
          color: _primaryColor,
          shape: pw.BoxShape.circle,
        ),
        child: pw.Center(
          child: pw.Text(
            '❖',
            style: pw.TextStyle(
              font: font,
              fontSize: 14,
              color: PdfColors.white,
            ),
          ),
        ),
      ),
      pw.SizedBox(width: 8),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '聯新國際醫院  桃園國際機場醫療中心',
            style: pw.TextStyle(font: fontB, fontSize: 13, color: _textDark),
          ),
          pw.SizedBox(height: 1),
          pw.Text(
            'LANDSEED MEDICAL CLINIC AT TAIWAN TAOYUAN INTERNATIONAL AIRPORT',
            style: pw.TextStyle(font: font, fontSize: 6, color: _textMuted),
          ),
        ],
      ),
    ],
  );
}

pw.Widget _buildFaxSection(
  String toTitle,
  List<TelexFaxLine> toLines,
  String fromTitle,
  List<TelexFaxLine> fromLines,
  pw.Font font,
  pw.Font fontB,
) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      color: _sectionBgColor,
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // TO section
        pw.Row(
          children: [
            pw.Text(toTitle, style: pw.TextStyle(font: fontB, fontSize: 9)),
          ],
        ),
        pw.SizedBox(height: _spacerXs),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 18),
          child: pw.Wrap(
            spacing: _spacerLg,
            runSpacing: _spacerXs,
            children: toLines
                .map((line) => _inlineCheckLabel(line.text, line.checked, font))
                .toList(),
          ),
        ),
        pw.SizedBox(height: _spacerMd),
        // FROM section
        pw.Row(
          children: [
            pw.Text(fromTitle, style: pw.TextStyle(font: fontB, fontSize: 9)),
          ],
        ),
        pw.SizedBox(height: _spacerXs),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 18),
          child: pw.Wrap(
            spacing: _spacerLg,
            runSpacing: _spacerXs,
            children: fromLines
                .map((line) => _inlineCheckLabel(line.text, line.checked, font))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildPatientSection(TelexReportData d, pw.Font font, pw.Font fontB) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('病患資料', font, fontB),
        pw.SizedBox(height: _spacerSm),
        // Row 1: Name + Nationality
        pw.Row(
          children: [
            pw.Text('姓名：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.patientName, font, minWidth: 40),
            pw.SizedBox(width: 12),
            pw.Text('國籍：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.nationality, font, minWidth: 35),
            pw.SizedBox(width: 12),
            pw.Text('性別：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _checkbox(d.gender.isNotEmpty, font),
            pw.SizedBox(width: 2),
            pw.Text(
              _displayGender(d.gender),
              style: pw.TextStyle(font: font, fontSize: 9),
            ),
          ],
        ),
        pw.SizedBox(height: _spacerSm),
        // Row 2: Birthdate
        pw.Row(
          children: [
            pw.Text('出生日期：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            pw.Text('西元 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.birthYear, font, minWidth: 18, center: true),
            pw.Text(' 年 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.birthMonth, font, minWidth: 14, center: true),
            pw.Text(' 月 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.birthDay, font, minWidth: 14, center: true),
            pw.Text(' 日', style: pw.TextStyle(font: font, fontSize: 9)),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildTravelSection(TelexReportData d, pw.Font font, pw.Font fontB) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('航班 / 交通資訊', font, fontB),
        pw.SizedBox(height: _spacerSm),
        pw.Row(
          children: [
            _checkbox(d.isAirline, font),
            pw.SizedBox(width: 2),
            pw.Text('航空公司：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.airline, font, minWidth: 35),
            pw.SizedBox(width: 10),
            pw.Text('班機號碼：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.flightNo, font, minWidth: 30),
            pw.SizedBox(width: 10),
            _checkbox(d.isOther, font),
            pw.SizedBox(width: 2),
            pw.Text('其他：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.otherDetail, font),
          ],
        ),
        pw.SizedBox(height: _spacerSm),
        pw.Wrap(
          spacing: 10,
          runSpacing: _spacerXs,
          children: [
            _checkLabel('出境', d.direction == '出境', font),
            _checkLabel('入境', d.direction == '入境', font),
            _checkLabel('過境', d.direction == '過境', font),
            _checkLabel('轉機', d.direction == '轉機', font),
            _checkLabel('迫降', d.direction == '迫降', font),
            _checkLabel('轉降', d.direction == '轉降', font),
            _checkLabel('備降', d.direction == '備降', font),
            _checkLabel('技術性降落', d.direction == '技術性降落', font),
            _checkLabel('其他', d.direction == '其他', font),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildIncidentSection(
  TelexReportData d,
  pw.Font font,
  pw.Font fontB,
) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('事件資料', font, fontB),
        pw.SizedBox(height: _spacerSm),
        // Date and Location row
        pw.Row(
          children: [
            pw.Text('就醫日期：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            pw.Text('西元 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.incidentYear, font, minWidth: 18, center: true),
            pw.Text(' 年 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.incidentMonth, font, minWidth: 14, center: true),
            pw.Text(' 月 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.incidentDay, font, minWidth: 14, center: true),
            pw.Text(' 日', style: pw.TextStyle(font: font, fontSize: 9)),
            pw.SizedBox(width: 12),
            pw.Text('地點：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.location, font, minWidth: 50),
          ],
        ),
        pw.SizedBox(height: _spacerSm),
        // Reporter and times row
        pw.Row(
          children: [
            pw.Text('通報人員：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.reporter, font, minWidth: 45),
            pw.SizedBox(width: 14),
            pw.Text('通報時間：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.reportHour, font, minWidth: 14, center: true),
            pw.Text(' 時 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.reportMin, font, minWidth: 14, center: true),
            pw.Text(' 分', style: pw.TextStyle(font: font, fontSize: 9)),
            pw.SizedBox(width: 14),
            pw.Text('診療時間：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _underlineBox(d.treatHour, font, minWidth: 14, center: true),
            pw.Text(' 時 ', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.treatMin, font, minWidth: 14, center: true),
            pw.Text(' 分', style: pw.TextStyle(font: font, fontSize: 9)),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildDiagnosisSection(
  TelexReportData d,
  pw.Font font,
  pw.Font fontB,
) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('初步診斷（中文）', font, fontB),
        pw.SizedBox(height: _spacerSm),
        pw.Container(
          width: double.infinity,
          height: 28 * PdfPageFormat.mm,
          padding: const pw.EdgeInsets.all(_spacerSm),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(color: _borderColor, width: 0.5),
            borderRadius: pw.BorderRadius.circular(2),
          ),
          child: pw.Text(
            d.diagnosis,
            style: pw.TextStyle(font: font, fontSize: 10),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildOutcomeSection(TelexReportData d, pw.Font font, pw.Font fontB) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('後續處置結果', font, fontB),
        pw.SizedBox(height: _spacerSm),
        pw.Row(
          children: [
            _checkLabel('自行返家', d.outcome == '自行返家', font),
            pw.SizedBox(width: 14),
            _checkLabel('繼續搭機', d.outcome == '繼續搭機', font),
            pw.SizedBox(width: 14),
            _checkLabel('醫療中心觀察', d.outcome == '醫療中心觀察', font),
            pw.SizedBox(width: 14),
            _checkLabel('空跑', d.isEmptyRun, font),
            pw.SizedBox(width: 14),
            _checkLabel('其他', d.outcome == '其他', font),
            if (d.outcome == '其他' &&
                d.otherOutcomeDetail.trim().isNotEmpty) ...[
              pw.Text('：', style: pw.TextStyle(font: fontB, fontSize: 9)),
              _underlineBox(d.otherOutcomeDetail, font, minWidth: 30),
            ],
          ],
        ),
        pw.SizedBox(height: _spacerSm),
        pw.Row(
          children: [
            _checkLabel('轉送至', d.outcome == '轉送醫院', font),
            pw.SizedBox(width: _spacerSm),
            pw.Text('（', style: pw.TextStyle(font: font, fontSize: 9)),
            _underlineBox(d.transferTo, font, minWidth: 40),
            pw.Text('）醫院', style: pw.TextStyle(font: font, fontSize: 9)),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildChargesSection(TelexReportData d, pw.Font font, pw.Font fontB) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(_spacerMd),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _borderColor, width: 0.5),
      borderRadius: pw.BorderRadius.circular(3),
    ),
    child: pw.Row(
      children: [
        pw.Text('醫療費用收費：', style: pw.TextStyle(font: fontB, fontSize: 9)),
        pw.SizedBox(width: _spacerMd),
        _checkLabel('是', d.chargedYes, font),
        pw.SizedBox(width: 16),
        _checkLabel('否', d.chargedNo, font),
        pw.SizedBox(width: 14),
        pw.Text('實收金額：', style: pw.TextStyle(font: fontB, fontSize: 9)),
        _underlineBox(d.chargedAmount, font, minWidth: 35),
        pw.Text(' 元', style: pw.TextStyle(font: font, fontSize: 9)),
      ],
    ),
  );
}

pw.Widget _buildSignatureSection(
  TelexReportData d,
  pw.Font font,
  pw.Font fontB,
) {
  return pw.Row(
    children: [
      pw.Expanded(
        child: pw.Row(
          children: [
            pw.Text('醫師簽章：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _signatureBox(d.doctorSignature),
          ],
        ),
      ),
      pw.SizedBox(width: 20),
      pw.Expanded(
        child: pw.Row(
          children: [
            pw.Text('護理師簽章：', style: pw.TextStyle(font: fontB, fontSize: 9)),
            _signatureBox(d.nurseSignature),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildFooter(pw.Font font) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        '51-P-002-002',
        style: pw.TextStyle(font: font, fontSize: 7, color: _textMuted),
      ),
      pw.Text(
        '聯新(A364)2021/11 × 500張',
        style: pw.TextStyle(font: font, fontSize: 7, color: _textMuted),
      ),
    ],
  );
}

// ============================================================================
// Helper Widgets
// ============================================================================

String _displayGender(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '';
  final lower = trimmed.toLowerCase();
  if (lower == 'm' || lower == 'male' || trimmed.contains('男')) {
    return '男性';
  }
  if (lower == 'f' || lower == 'female' || trimmed.contains('女')) {
    return '女性';
  }
  return trimmed;
}

pw.Widget _sectionLabel(String text, pw.Font font, pw.Font fontB) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(bottom: _spacerXs),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: _primaryColor, width: 1.5),
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(font: fontB, fontSize: 10, color: _primaryColor),
    ),
  );
}

pw.Widget _underlineBox(
  String value,
  pw.Font font, {
  double? minWidth,
  bool center = false,
}) {
  return pw.Container(
    constraints: minWidth != null
        ? pw.BoxConstraints(minWidth: minWidth)
        : null,
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 1),
    child: pw.Text(
      value,
      style: pw.TextStyle(font: font, fontSize: 9),
      textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
    ),
  );
}

pw.Widget _signatureBox(
  Uint8List? data, {
  double width = 50,
  double height = 12,
}) {
  final hasData = data != null && data.isNotEmpty;
  return pw.Container(
    width: width,
    height: height,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: _textDark, width: 0.8),
      ),
    ),
    alignment: pw.Alignment.centerLeft,
    child: hasData
        ? pw.Image(
            pw.MemoryImage(data!),
            fit: pw.BoxFit.contain,
          )
        : pw.SizedBox(),
  );
}

pw.Widget _checkbox(bool checked, pw.Font font) {
  return pw.Container(
    width: 10,
    height: 10,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 0.8, color: _textDark),
    ),
    child: checked ? pw.Container(color: PdfColors.black) : pw.SizedBox(),
  );
}

pw.Widget _checkLabel(String label, bool checked, pw.Font font) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      _checkbox(checked, font),
      pw.SizedBox(width: 3),
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 9)),
    ],
  );
}

pw.Widget _inlineCheckLabel(String text, bool checked, pw.Font font) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      _checkbox(checked, font),
      pw.SizedBox(width: 3),
      pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9)),
    ],
  );
}
