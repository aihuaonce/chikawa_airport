import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class AmbulanceReportData {
  String licensePlate = '';
  String dispatchDateYear = '', dispatchDateMonth = '', dispatchDateDay = '';
  String departureHour = '', departureMin = '';
  String arrivalHour = '', arrivalMin = '';
  String leaveSceneHour = '', leaveSceneMin = '';
  String deliveryHour = '', deliveryMin = '';
  String leaveHospHour = '', leaveHospMin = '';
  String returnBaseHour = '', returnBaseMin = '';
  String incidentLocation = '', sendToHospital = '';
  bool sendReasonCondition = false, sendReasonPatientRequest = false;
  String patientName = '',
      gender = '',
      idOrPassport = '',
      age = '',
      guardian = '',
      address = '',
      propertyNote = '';
  Uint8List? guardianSign;
  bool propertyNone = false, propertyHas = false;
  bool ntiEmergency = false,
      ntiBreathIssue = false,
      ntiAirwayIssue = false,
      ntiChestPain = false;
  bool ntiAbdomen = false,
      ntiGeneral = false,
      ntiHeadache = false,
      ntiFaint = false,
      ntiFever = false;
  bool ntiNausea = false,
      ntiWeakness = false,
      ntiDrug = false,
      ntiCO = false,
      ntiSeizure = false;
  bool ntiMental = false,
      ntiFall = false,
      ntiPregnancy = false,
      ntiCardiacArrest = false,
      ntiOtherNT = false;
  String ntiOtherNTText = '';
  bool trGeneral = false,
      trHead = false,
      trChest = false,
      trAbdomen = false,
      trBack = false,
      trLimb = false,
      trOtherT = false;
  bool trDrown = false,
      trFall = false,
      trCrush = false,
      trFracture = false,
      trPenetrate = false,
      trBurn = false;
  bool trElectric = false,
      trBioStrike = false,
      trCardiacArrest = false,
      trOtherT2 = false;
  String trBurnDegree = '', trFallHeight = '';
  bool trMVC = false,
      trTrafficAcc = false,
      trNonTrafficAcc = false,
      trInjuredTransfer = false;
  String trOtherTText = '', trOtherT2Text = '';
  bool allergyNone = false, allergyUnknown = false;
  String allergyFood = '', allergyMeds = '', allergyOther = '';
  bool histNone = false,
      histUnknown = false,
      histHypertension = false,
      histDiabetes = false,
      histHeart = false,
      histStroke = false;
  bool histKidney = false, histLung = false, histAsthma = false;
  String histOther = '';
  bool chiefByFamily = false;
  String chiefComplaint = '';
  bool airOralAirway = false,
      airNasalAirway = false,
      airSuction = false,
      airHeimlick = false;
  bool airNasalO2 = false,
      airMaskO2 = false,
      airNonRebreather = false,
      airBVM = false,
      airLMA = false,
      airIgel = false,
      airEndotracheal = false,
      airOther = false;
  String airNasalLMin = '',
      airMaskLMin = '',
      airLMANo = '',
      airIgelNo = '',
      airETNo = '',
      airOtherText = '';
  bool cprAED = false,
      cprAuto = false,
      cprCPR = false,
      cprElectricShock = false,
      cprNoElectric = false,
      cprHandShock = false;
  String cprAEDMin = '', cprShockTimes = '';
  bool trWound = false,
      trCleanWound = false,
      trHemostasis = false,
      trImmobilize = false,
      trSplint = false,
      trBackboard = false,
      trCollar = false;
  bool otherKeepWarm = false,
      otherPsych = false,
      otherBandage = false,
      otherO2Refuse = false,
      otherVitalMonitor = false,
      otherOther = false;
  String otherOtherText = '';
  bool medIV = false,
      medNS = false,
      medLR = false,
      medGlucose = false,
      medAspirin = false,
      medNTG = false,
      medBroncho = false;
  String medIVPart = '',
      medNSml = '',
      medLRml = '',
      medGlucoseType = '',
      medNTGCount = '',
      medBronchoTimes = '';
  List<String> medTime = List.filled(4, ''),
      medName = List.filled(4, ''),
      medRoute = List.filled(4, ''),
      medExecutor = List.filled(4, '');
  String aslInfo = '',
      onlinePhysicianNote = '',
      etTube = '',
      etTubeFixed = '',
      manualShockTimes = '',
      manualShockJoule = '';
  List<String> vsTime = List.filled(4, ''),
      vsConsciousness = List.filled(4, '');
  List<bool> vsConsAlert = List.filled(4, false),
      vsConsPain = List.filled(4, false);
  List<String> vsTemp = List.filled(4, ''),
      vsPulse = List.filled(4, ''),
      vsBreathing = List.filled(4, '');
  List<String> vsBPSys = List.filled(4, ''),
      vsBPDia = List.filled(4, ''),
      vsSpO2 = List.filled(4, '');
  List<String> vsGcsE = List.filled(4, ''),
      vsGcsV = List.filled(4, ''),
      vsGcsM = List.filled(4, '');
  bool postAlert = false, postPain = false, postArrested = false;
  String emt1 = '',
      emt2 = '',
      emt3 = '',
      receiveUnit = '',
      refuseTransferSign = '',
      patientFamilySign = '',
      refuseContactPhone = '',
      signTimeHour = '',
      signTimeMin = '';
  String ambulanceFee = '', o2Fee = '', totalFee = '';
  bool paidCash = false, paidCard = false, paidHospital = false, unpaid = false;
  String unpaidNote = '', notes = '';
  Uint8List? bodyMapWithDrawing;
}

Future<Uint8List> buildAmbulanceReportPdf(
  AmbulanceReportData d, {
  Uint8List? bodyMapWithDrawing, // ← 新增參數
}) async {
  final pdf = pw.Document();
  // 載入人體圖（前/後）
  final ByteData bodyData = await rootBundle.load(
    'assets/images/body_diagram_placeholder.jpg',
  );
  final Uint8List bodyBytes = bodyData.buffer.asUint8List();
  final pw.MemoryImage bodyImage = pw.MemoryImage(bodyBytes);
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  // ── 字體與邊框設定 ──────────────────────────────────────────────
  pw.TextStyle ts({double sz = 6.0, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz);
  pw.TextStyle ts8({double sz = 6.0, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz);
  pw.TextStyle ts9({double sz = 6.0, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz);

  // 固定寬度填充函數
  String _pad(String value, int length) {
    if (value.isEmpty) return ' ' * length;
    if (value.length >= length) return value.substring(0, length);
    return value + (' ' * (length - value.length));
  }

  String _formatTimeCell(String hour, String min) {
    return '${_pad(hour, 2)}時 ${_pad(min, 2)}分';
  }

  final tb = pw.TableBorder.all(width: 0.5, color: PdfColors.black);
  final tbFull = pw.TableBorder.all(width: 0.5, color: PdfColors.black);
  final tbFirstRowBorder = pw.TableBorder.all(
    width: 0.5,
    color: PdfColors.black,
  );
  // 第二三四列外框細線，內部細線
  final tbTimeBorder = pw.TableBorder.all(width: 0.5, color: PdfColors.black);
  // 第三列外框細線
  final tbRow3Border = pw.TableBorder.all(width: 0.5, color: PdfColors.black);
  final bSide = pw.BorderSide(width: 0.5, color: PdfColors.black);

  // 修正：加入 top 與 horizontalInside，讓各列都有完整邊框
  final tbInner = pw.TableBorder(
    top: bSide,
    left: bSide,
    right: bSide,
    bottom: bSide,
    verticalInside: bSide,
    horizontalInside: bSide,
  );

  // ── 輔助 Widget ──────────────────────────────────────────────────
  pw.Widget _cell(
    pw.Widget child, {
    PdfColor? bg,
    pw.Alignment align = pw.Alignment.centerLeft,
    double? h,
  }) {
    return pw.Container(color: bg, alignment: align, height: h, child: child);
  }

  pw.Widget _lbl(
    String text, {
    bool bold = true,
    PdfColor? bg,
    pw.Alignment align = pw.Alignment.center,
    double? h,
  }) {
    return _cell(
      pw.Text(
        text,
        style: ts(bold: bold),
        textAlign: pw.TextAlign.center,
      ),
      bg: bg,
      align: align,
      h: h,
    );
  }

  pw.Widget _timeCell(String hour, String min, {double? h}) {
    return _cell(
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [pw.Text(_formatTimeCell(hour, min), style: ts9())],
        ),
      ),
      align: pw.Alignment.centerRight,
      h: h,
    );
  }

  pw.Widget _chk(
    String label,
    bool checked, {
    double sz = 5.5,
    bool bold = false,
    double indent = 0,
    bool fillBlack = true,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent, right: 2, bottom: 1, top: 0.5),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: 4.5,
            height: 4.5,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 0.5),
              color: fillBlack && checked ? PdfColors.black : null,
            ),
          ),
          pw.SizedBox(width: 1),
          pw.Text(
            label,
            style: ts(sz: sz, bold: bold),
          ),
        ],
      ),
    );
  }

  // ── 尺寸定義 (mm) ────────────────────────────────────────────────
  const double leftW = 135;
  const double rightW = 135;
  const double totalW = 270;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) {
        final double pageWidth = PdfPageFormat.a4.width;
        final double pageHeight = PdfPageFormat.a4.height;
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(
            vertical: 13 * PdfPageFormat.mm,
            horizontal: 9 * PdfPageFormat.mm,
          ),
          child: pw.Transform.rotateBox(
            angle: -math.pi / 2,
            child: pw.Container(
              width: 270 * PdfPageFormat.mm,
              height: 190 * PdfPageFormat.mm,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // ─── [A] 標題列 + 車牌 (高度 10mm, 寬度 270mm) ───
                  pw.Container(
                    height: 10 * PdfPageFormat.mm,
                    child: pw.Row(
                      children: [
                        pw.Container(
                          width: leftW * PdfPageFormat.mm, // 135mm
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            '聯  新  國  際  醫  院 桃  園  國  際  ',
                            style: ts(sz: 12, bold: true),
                          ),
                        ),
                        pw.Container(
                          width: rightW * PdfPageFormat.mm, // 135mm
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                '機  場  醫  療  中  心  救  護  紀  錄  表',
                                style: ts(sz: 12, bold: true),
                              ),
                              pw.Text(
                                '車牌號碼：${d.licensePlate}      ',
                                style: ts(sz: 9.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ─── [B] 主內容區 (高度 175mm, 寬度 270mm) ───
                  pw.Container(
                    width: totalW * PdfPageFormat.mm,
                    height: 175 * PdfPageFormat.mm,
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // 左半部 (高度175mm, 寬度135mm)
                        pw.Container(
                          width: leftW * PdfPageFormat.mm,
                          height: 175 * PdfPageFormat.mm,
                          child: pw.Column(
                            children: [
                              // Column 1: 派遣資料 (高度 4)
                              pw.Table(
                                border: tb,
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(67.5),
                                  1: const pw.FixedColumnWidth(30),
                                  2: const pw.FixedColumnWidth(37.5),
                                },
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _cell(
                                        _lbl('派遣資料', bold: true),
                                        h: 4 * PdfPageFormat.mm,
                                      ),
                                      _cell(
                                        _lbl('出勤日期', bold: false),
                                        h: 4 * PdfPageFormat.mm,
                                      ),
                                      _cell(
                                        pw.Text(
                                          '西元${d.dispatchDateYear}年${d.dispatchDateMonth}月${d.dispatchDateDay}日',
                                          style: ts(),
                                        ),
                                        align: pw.Alignment.center,
                                        h: 4 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 2 & 3 (高度5 + 5 = 10mm)
                              pw.Table(
                                border: tb,
                                columnWidths: List.generate(
                                  6,
                                  (i) => const pw.FixedColumnWidth(22.5),
                                ).asMap(),
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl(
                                        '出勤時間',
                                        bold: false,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _lbl(
                                        '到達現場',
                                        bold: false,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _lbl(
                                        '離開現場',
                                        bold: false,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _lbl(
                                        '送達時間',
                                        bold: false,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _lbl(
                                        '離開時間',
                                        bold: false,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _lbl(
                                        '返回待命',
                                        bold: false,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      _timeCell(
                                        d.departureHour,
                                        d.departureMin,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _timeCell(
                                        d.arrivalHour,
                                        d.arrivalMin,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _timeCell(
                                        d.leaveSceneHour,
                                        d.leaveSceneMin,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _timeCell(
                                        d.deliveryHour,
                                        d.deliveryMin,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _timeCell(
                                        d.leaveHospHour,
                                        d.leaveHospMin,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                      _timeCell(
                                        d.returnBaseHour,
                                        d.returnBaseMin,
                                        h: 5 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 4 (高度9mm)
                              pw.Table(
                                border: tb,
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(30),
                                  1: const pw.FixedColumnWidth(37.5),
                                  2: const pw.FixedColumnWidth(30),
                                  3: const pw.FixedColumnWidth(37.5),
                                },
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl('發生地點', h: 9 * PdfPageFormat.mm),
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.only(
                                            left: 2,
                                          ),
                                          child: pw.Text(
                                            d.incidentLocation,
                                            style: ts(),
                                          ),
                                        ),
                                        h: 9 * PdfPageFormat.mm,
                                      ),
                                      _lbl('送往醫院', h: 9 * PdfPageFormat.mm),
                                      _cell(
                                        pw.Row(
                                          children: [
                                            pw.Text(
                                              ' ${d.sendToHospital}',
                                              style: ts(),
                                            ),
                                            pw.Spacer(),
                                            _chk(
                                              '病情',
                                              d.sendReasonCondition,
                                              sz: 4.5,
                                            ),
                                            _chk(
                                              '要求',
                                              d.sendReasonPatientRequest,
                                              sz: 4.5,
                                            ),
                                          ],
                                        ),
                                        h: 9 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 5 (高度4)
                              pw.Table(
                                border: tb,
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl(
                                        '病 患 資 料',
                                        bold: true,
                                        h: 4 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // --- Column 6 & 7 (高度9 + 11 = 20mm) ---
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  // 1. 左側資料區 (20+25+15+20 = 80mm)
                                  pw.Container(
                                    width: 80 * PdfPageFormat.mm,
                                    child: pw.Table(
                                      border: tb,
                                      columnWidths: {
                                        0: const pw.FixedColumnWidth(20),
                                        1: const pw.FixedColumnWidth(25),
                                        2: const pw.FixedColumnWidth(15),
                                        3: const pw.FixedColumnWidth(20),
                                      },
                                      children: [
                                        // 第一行：姓名、性別 (高度 6)
                                        pw.TableRow(
                                          children: [
                                            _lbl(
                                              '姓名',
                                              bold: false,
                                              h: 9 * PdfPageFormat.mm,
                                            ),
                                            _lbl(
                                              d.patientName,
                                              h: 9 * PdfPageFormat.mm,
                                            ),
                                            _lbl(
                                              '性別',
                                              bold: false,
                                              h: 9 * PdfPageFormat.mm,
                                            ),
                                            _cell(
                                              pw.Row(
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.center,
                                                children: [
                                                  _chk(
                                                    '男',
                                                    d.gender == '男',
                                                    sz: 5,
                                                  ),
                                                  _chk(
                                                    '女',
                                                    d.gender == '女',
                                                    sz: 5,
                                                  ),
                                                ],
                                              ),
                                              h: 9 * PdfPageFormat.mm,
                                            ),
                                          ],
                                        ),
                                        // 第二行：證號、年齡 (高度 8)
                                        pw.TableRow(
                                          children: [
                                            _lbl(
                                              '證號/護照',
                                              bold: false,
                                              h: 11 * PdfPageFormat.mm,
                                            ),
                                            _lbl(
                                              d.idOrPassport,
                                              h: 11 * PdfPageFormat.mm,
                                            ),
                                            _lbl(
                                              '年齡',
                                              bold: false,
                                              h: 11 * PdfPageFormat.mm,
                                            ),
                                            _lbl(
                                              '${d.age} 歲',
                                              h: 11 * PdfPageFormat.mm,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 2. 右側財務明細區
                                  pw.Container(
                                    width: 55 * PdfPageFormat.mm,
                                    height: 20 * PdfPageFormat.mm,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border(
                                        top: const pw.BorderSide(width: 0.5),
                                        right: const pw.BorderSide(width: 0.5),
                                        bottom: const pw.BorderSide(width: 0.5),
                                        left: const pw.BorderSide(width: 0.5),
                                      ),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(1.5),
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          // 上半部內容
                                          pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                '病患財務明細：',
                                                style: ts(sz: 5, bold: true),
                                              ),
                                              pw.Row(
                                                children: [
                                                  _chk(
                                                    '未經手',
                                                    d.propertyNone,
                                                    sz: 5,
                                                  ),
                                                  _chk(
                                                    '有',
                                                    d.propertyHas,
                                                    sz: 5,
                                                  ),
                                                ],
                                              ),
                                              if (d.propertyNote.isNotEmpty)
                                                pw.Text(
                                                  d.propertyNote,
                                                  style: ts(sz: 4.5),
                                                ),
                                            ],
                                          ),
                                          // 下半部內容
                                          pw.Row(
                                            mainAxisAlignment: pw
                                                .MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.end,
                                            children: [
                                              pw.Text(
                                                '保管人(簽章)',
                                                style: ts(sz: 5),
                                              ),
                                              if (d.guardianSign != null)
                                                pw.Image(
                                                  pw.MemoryImage(
                                                    d.guardianSign!,
                                                  ),
                                                  height: 11,
                                                )
                                              else
                                                pw.SizedBox(width: 20),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Column 8 (高度10mm)
                              pw.Table(
                                border: tb,
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(20),
                                  1: const pw.FixedColumnWidth(115),
                                },
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl(
                                        '住址',
                                        bold: false,
                                        h: 10 * PdfPageFormat.mm,
                                      ),
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(2),
                                          child: pw.Text(
                                            d.address,
                                            style: ts(),
                                          ),
                                        ),
                                        h: 10 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 9 (高度4mm)
                              pw.Table(
                                border: tb,
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl(
                                        '現 場 狀 況 (此欄可複選)',
                                        bold: true,
                                        h: 4 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 10 & 11 (高度4 + 48 = 52mm)
                              pw.Table(
                                border: tb,
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(67.5),
                                  1: const pw.FixedColumnWidth(67.5),
                                },
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl('□ 非創傷', h: 4 * PdfPageFormat.mm),
                                      _lbl('□ 創傷', h: 4 * PdfPageFormat.mm),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      // 非創傷內容
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(2),
                                          child: pw.Row(
                                            children: [
                                              pw.Container(
                                                width: 33.75 * PdfPageFormat.mm,
                                                height: 48 * PdfPageFormat.mm,
                                                child: pw.Column(
                                                  crossAxisAlignment: pw
                                                      .CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    _chk(
                                                      '急症',
                                                      d.ntiEmergency,
                                                      bold: true,
                                                      sz: 7,
                                                    ),
                                                    _chk(
                                                      '呼吸問題\n(喘/呼吸急促)',
                                                      d.ntiBreathIssue,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '呼吸道問題\n(異物哽塞)',
                                                      d.ntiAirwayIssue,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '昏迷(意識不清)',
                                                      d.ntiFaint,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '胸痛/胸悶',
                                                      d.ntiChestPain,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '腹痛',
                                                      d.ntiAbdomen,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '一般疾病',
                                                      d.ntiGeneral,
                                                      bold: true,
                                                      sz: 7,
                                                    ),
                                                    _chk(
                                                      '頭痛/頭暈',
                                                      d.ntiHeadache,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '昏倒/昏厥',
                                                      d.ntiFaint,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '發燒',
                                                      d.ntiFever,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '噁心/嘔吐/腹瀉',
                                                      d.ntiNausea,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '肢體無力',
                                                      d.ntiWeakness,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              pw.Container(
                                                width: 33.75 * PdfPageFormat.mm,
                                                height: 48 * PdfPageFormat.mm,
                                                child: pw.Column(
                                                  crossAxisAlignment: pw
                                                      .CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    _chk(
                                                      '疑似毒藥物中毒',
                                                      d.ntiDrug,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '疑似一氧化碳中毒',
                                                      d.ntiCO,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '癲癇/抽搐',
                                                      d.ntiSeizure,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '路倒',
                                                      d.ntiFall,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '精神異常',
                                                      d.ntiMental,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '孕婦急產',
                                                      d.ntiPregnancy,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '到院前心肺功能停止',
                                                      d.ntiCardiacArrest,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                    _chk(
                                                      '其他',
                                                      d.ntiOtherNT,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // 創傷內容 (35mm) + 過敏史標題 (4mm) + 過敏史內容 (11mm)
                                      _cell(
                                        pw.Column(
                                          children: [
                                            pw.Container(
                                              height: 33 * PdfPageFormat.mm,
                                              padding: const pw.EdgeInsets.all(
                                                2,
                                              ),
                                              child: pw.Row(
                                                children: [
                                                  pw.Container(
                                                    width:
                                                        33.75 *
                                                        PdfPageFormat.mm,
                                                    height:
                                                        33 * PdfPageFormat.mm,
                                                    child: pw.Column(
                                                      crossAxisAlignment: pw
                                                          .CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        _chk(
                                                          '一般外傷',
                                                          d.trGeneral,
                                                          bold: true,
                                                          sz: 6,
                                                        ),
                                                        _chk(
                                                          '頭部外傷',
                                                          d.trHead,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '胸部外傷',
                                                          d.trChest,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '腹部外傷',
                                                          d.trAbdomen,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '背部外傷',
                                                          d.trBack,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '肢體外傷',
                                                          d.trLimb,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '其他',
                                                          d.trOtherT,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        pw.SizedBox(height: 1),
                                                        _chk(
                                                          '受傷機轉',
                                                          false,
                                                          bold: true,
                                                          sz: 6,
                                                        ),
                                                        _chk(
                                                          '因交通事故',
                                                          d.trTrafficAcc,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '非交通事故',
                                                          d.trNonTrafficAcc,
                                                          indent: 3,
                                                          sz: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  pw.Container(
                                                    width:
                                                        33.75 *
                                                        PdfPageFormat.mm,
                                                    height:
                                                        33 * PdfPageFormat.mm,
                                                    child: pw.Column(
                                                      crossAxisAlignment: pw
                                                          .CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        _chk(
                                                          '溺水',
                                                          d.trDrown,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '摔跌傷',
                                                          d.trFall,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '墜落傷(約${d.trFallHeight.isNotEmpty ? d.trFallHeight : '__'}公尺)',
                                                          d.trCrush,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '穿刺傷',
                                                          d.trPenetrate,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          "燒燙傷 度: ${d.trBurnDegree.isNotEmpty ? d.trBurnDegree : '___'} %: ___",
                                                          d.trBurn,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '電擊傷',
                                                          d.trElectric,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '生物螫咬',
                                                          d.trBioStrike,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '到院前心肺功能停止',
                                                          d.trCardiacArrest,
                                                          sz: 5,
                                                        ),
                                                        _chk(
                                                          '其他',
                                                          d.trOtherT2,
                                                          sz: 5,
                                                        ),
                                                        if (d
                                                            .trOtherT2Text
                                                            .isNotEmpty)
                                                          pw.Padding(
                                                            padding:
                                                                const pw.EdgeInsets.only(
                                                                  left: 3,
                                                                ),
                                                            child: pw.Text(
                                                              d.trOtherT2Text,
                                                              style: ts(),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            pw.Table(
                                              border: pw.TableBorder(
                                                top: pw.BorderSide(width: 0.5),
                                                bottom: pw.BorderSide(
                                                  width: 0.5,
                                                ),
                                              ),
                                              children: [
                                                pw.TableRow(
                                                  children: [
                                                    _lbl(
                                                      '過 敏 史',
                                                      bold: true,
                                                      h: 4 * PdfPageFormat.mm,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            pw.Container(
                                              height: 9 * PdfPageFormat.mm,
                                              padding: const pw.EdgeInsets.all(
                                                2,
                                              ),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Row(
                                                    children: [
                                                      _chk(
                                                        '無',
                                                        d.allergyNone,
                                                        sz: 6,
                                                      ),
                                                      pw.SizedBox(width: 4),
                                                      _chk(
                                                        '不詳',
                                                        d.allergyUnknown,
                                                        sz: 6,
                                                      ),
                                                      pw.SizedBox(width: 4),
                                                      _chk(
                                                        '食物: ${d.allergyFood}',
                                                        false,
                                                        sz: 6,
                                                      ),
                                                    ],
                                                  ),

                                                  pw.Row(
                                                    children: [
                                                      _chk(
                                                        '藥物: ${d.allergyMeds}',
                                                        false,
                                                        sz: 6,
                                                      ),
                                                      if (d.allergyOther
                                                          .trim()
                                                          .isNotEmpty) ...[
                                                        pw.SizedBox(width: 4),
                                                        _chk(
                                                          '其他: ${d.allergyOther}',
                                                          false,
                                                          sz: 6,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        h: 50 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 12 (高度29mm)
                              pw.Table(
                                border: tb,
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(10),
                                  1: const pw.FixedColumnWidth(57.5),
                                  2: const pw.FixedColumnWidth(10),
                                  3: const pw.FixedColumnWidth(57.5),
                                },
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _lbl(
                                        '病\n患\n主\n訴',
                                        h: 29 * PdfPageFormat.mm,
                                      ),
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(2),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              _chk(
                                                '家屬或同事、有人代述',
                                                d.chiefByFamily,
                                                sz: 5,
                                              ),

                                              pw.SizedBox(height: 2),
                                              pw.Text(
                                                d.chiefComplaint,
                                                style: ts(sz: 5.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        h: 29 * PdfPageFormat.mm,
                                      ),
                                      _lbl(
                                        '過\n去\n病\n史',
                                        h: 29 * PdfPageFormat.mm,
                                      ),
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(2),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Wrap(
                                                spacing: 3,
                                                children: [
                                                  _chk('無', d.histNone, sz: 6),
                                                  _chk(
                                                    '不詳',
                                                    d.histUnknown,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '高血壓',
                                                    d.histHypertension,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '糖尿病',
                                                    d.histDiabetes,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '心臟病',
                                                    d.histHeart,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '腦中風',
                                                    d.histStroke,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '腎臟病',
                                                    d.histKidney,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '肺臟病',
                                                    d.histLung,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '氣喘',
                                                    d.histAsthma,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '其他',
                                                    d.histOther.isNotEmpty,
                                                    sz: 6,
                                                  ),
                                                ],
                                              ),
                                              pw.Text(
                                                '其他: ${d.histOther}',
                                                style: ts(sz: 6),
                                              ),
                                            ],
                                          ),
                                        ),
                                        h: 29 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Column 13 (高度30mm)
                              pw.Table(
                                border: tb,
                                children: [
                                  pw.TableRow(
                                    children: [
                                      _cell(
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 2,
                                              ),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Row(
                                                mainAxisAlignment: pw
                                                    .MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  pw.Text(
                                                    '救護車費用(含醫護人員): ${d.ambulanceFee}',
                                                    style: ts(
                                                      sz: 7,
                                                      bold: true,
                                                    ),
                                                  ),
                                                  pw.Text(
                                                    '氧氣使用費: ${d.o2Fee}',
                                                    style: ts(
                                                      sz: 7,
                                                      bold: true,
                                                    ),
                                                  ),
                                                  pw.Text(
                                                    '總計: ${d.totalFee}',
                                                    style: ts(
                                                      sz: 8,
                                                      bold: true,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              pw.SizedBox(height: 4),
                                              pw.Row(
                                                children: [
                                                  _chk(
                                                    '已收費 (現金 / 刷卡)',
                                                    d.paidCash || d.paidCard,
                                                    sz: 6.5,
                                                  ),
                                                  pw.SizedBox(
                                                    width:
                                                        30 * PdfPageFormat.mm,
                                                  ),
                                                  _chk(
                                                    '聯新國際醫院代收',
                                                    d.paidHospital,
                                                    sz: 6.5,
                                                  ),
                                                ],
                                              ),

                                              pw.SizedBox(height: 6),
                                              pw.Row(
                                                children: [
                                                  _chk(
                                                    '未收費 (欠款 / 匯款 / 統一請款: ',
                                                    d.unpaid,
                                                    sz: 6.5,
                                                  ),
                                                  pw.Container(
                                                    child: pw.Container(
                                                      decoration:
                                                          const pw.BoxDecoration(
                                                            border: pw.Border(
                                                              bottom: pw.BorderSide(
                                                                width: 0.5,
                                                                color: PdfColors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                      child: pw.Text(
                                                        (d.unpaid &&
                                                                d
                                                                    .unpaidNote
                                                                    .isNotEmpty)
                                                            ? d.unpaidNote
                                                            : '                              ',
                                                        style: ts(
                                                          sz: 7,
                                                          bold: true,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  pw.Text(
                                                    ')',
                                                    style: ts(
                                                      sz: 7,
                                                      bold: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        h: 30 * PdfPageFormat.mm,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // ────────────────────────────────────────────
                        // 右半部 (高度175mm, 寬度135mm)
                        // ────────────────────────────────────────────
                        pw.Container(
                          width: rightW * PdfPageFormat.mm,
                          height: 175 * PdfPageFormat.mm,
                          child: pw.Column(
                            children: [
                              pw.Column(
                                children: [
                                  // === Column 1: 處置項目標題 (4mm) ===
                                  pw.Table(
                                    border: tb,
                                    children: [
                                      pw.TableRow(
                                        children: [
                                          _lbl(
                                            '處 置 項 目 (此 欄 可 複 選)',
                                            bold: true,
                                            h: 4 * PdfPageFormat.mm,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // === Column 2: 急救處置區塊 (總高 99mm) ===
                                  pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                        width: 10 * PdfPageFormat.mm,
                                        height: 99 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          '急\n救\n處\n置',
                                          style: ts(bold: true, sz: 8),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 65 * PdfPageFormat.mm,
                                        height: 99 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        padding: const pw.EdgeInsets.all(2),
                                        child: pw.Row(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            // --- 左半邊清單 ---
                                            pw.Container(
                                              width: 32.5 * PdfPageFormat.mm,
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  _chk(
                                                    '呼吸道處置',
                                                    false,
                                                    bold: true,
                                                    sz: 7,
                                                  ),
                                                  _chk(
                                                    '口咽呼吸道',
                                                    d.airOralAirway,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '鼻咽呼吸道',
                                                    d.airNasalAirway,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '抽吸',
                                                    d.airSuction,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '哈姆立克',
                                                    d.airHeimlick,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '鼻管 ${d.airNasalLMin}L',
                                                    d.airNasalO2,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '面罩 ${d.airMaskLMin}L',
                                                    d.airMaskO2,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '非再吸入型面罩',
                                                    d.airNonRebreather,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    'BVM(正壓輔助呼吸)',
                                                    d.airBVM,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    'LMA ${d.airLMANo}號',
                                                    d.airLMA,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    'Igel ${d.airIgelNo}號',
                                                    d.airIgel,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '氣管內管 ${d.airETNo}號',
                                                    d.airEndotracheal,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '其他:${d.airOtherText}',
                                                    d.airOther,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),

                                                  pw.SizedBox(height: 3),

                                                  _chk(
                                                    '創傷處置',
                                                    false,
                                                    bold: true,
                                                    sz: 7,
                                                  ),
                                                  _chk(
                                                    '頸圈',
                                                    d.trCollar,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '清洗傷口',
                                                    d.trCleanWound,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '止血、包紮',
                                                    d.trHemostasis,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '骨折固定',
                                                    d.trImmobilize,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '長背板',
                                                    d.trBackboard,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '鏟式擔架固定',
                                                    d.trSplint,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  if (d.trOtherTText.isNotEmpty)
                                                    _chk(
                                                      '其他: ${d.trOtherTText}',
                                                      d.trOtherT,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),

                                                  pw.SizedBox(height: 3),
                                                  _chk(
                                                    '搬運',
                                                    false,
                                                    bold: true,
                                                    sz: 7,
                                                  ),
                                                  _chk(
                                                    '自行上車',
                                                    false,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '以適當方式搬運',
                                                    true,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // --- 右半邊清單 ---
                                            pw.Container(
                                              width: 32.5 * PdfPageFormat.mm,
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  _chk(
                                                    '心肺復甦術',
                                                    false,
                                                    bold: true,
                                                    sz: 7,
                                                  ),
                                                  _chk(
                                                    '自動心肺復甦機',
                                                    d.cprAuto,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    'CPR:${d.cprAEDMin}分鐘',
                                                    d.cprCPR,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '使用 AED',
                                                    d.cprAED,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '電擊去顫${d.cprShockTimes.isNotEmpty ? " ${d.cprShockTimes}次" : ""}',
                                                    d.cprElectricShock,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '不建議電擊',
                                                    d.cprNoElectric,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '手動電擊器',
                                                    d.cprHandShock,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),

                                                  pw.SizedBox(height: 3),
                                                  _chk(
                                                    '藥物處置',
                                                    false,
                                                    bold: true,
                                                    sz: 7,
                                                  ),
                                                  _chk(
                                                    '靜脈輸液，部位${d.medIVPart.isNotEmpty ? " ${d.medIVPart}" : "______"}',
                                                    d.medIV,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '0.9%N/S${d.medNSml.isNotEmpty ? " ${d.medNSml}ml" : ""}',
                                                    d.medNS,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    'L/R${d.medLRml.isNotEmpty ? " ${d.medLRml}ml" : ""}',
                                                    d.medLR,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '葡萄糖液${d.medGlucoseType.isNotEmpty ? " ${d.medGlucoseType}" : ""}ml',
                                                    d.medGlucose,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '口服葡萄糖液/粉',
                                                    false,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '協助使用 Aspirin',
                                                    d.medAspirin,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '協助使用 NTG${d.medNTGCount.isNotEmpty ? " ${d.medNTGCount}片" : ""}',
                                                    d.medNTG,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '協助使用支氣管擴張劑${d.medBronchoTimes.isNotEmpty ? " ${d.medBronchoTimes}次" : ""}',
                                                    d.medBroncho,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),

                                                  pw.SizedBox(height: 3),
                                                  _chk(
                                                    '其他處置',
                                                    false,
                                                    bold: true,
                                                    sz: 7,
                                                  ),
                                                  _chk(
                                                    '保暖',
                                                    d.otherKeepWarm,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '心理支持',
                                                    d.otherPsych,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '約束帶',
                                                    d.otherBandage,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '拒絕使用氧氣',
                                                    d.otherO2Refuse,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  _chk(
                                                    '生命徵象監測',
                                                    d.otherVitalMonitor,
                                                    indent: 2,
                                                    sz: 6,
                                                  ),
                                                  if (d
                                                      .otherOtherText
                                                      .isNotEmpty)
                                                    _chk(
                                                      '其他: ${d.otherOtherText}',
                                                      d.otherOther,
                                                      indent: 2,
                                                      sz: 6,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // 右側：人形圖與備註 (60 x 99mm)
                                      pw.Container(
                                        width: 60 * PdfPageFormat.mm,
                                        child: pw.Column(
                                          children: [
                                            // 人形圖 (60 x 60mm)
                                            pw.Container(
                                              width: 60 * PdfPageFormat.mm,
                                              height: 60 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: tb,
                                              ),
                                              padding: const pw.EdgeInsets.all(
                                                3 * PdfPageFormat.mm,
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: bodyMapWithDrawing != null
                                                  ? pw.Image(
                                                      pw.MemoryImage(
                                                        bodyMapWithDrawing,
                                                      ),
                                                      fit: pw.BoxFit.contain,
                                                    )
                                                  : pw.Image(
                                                      bodyImage,
                                                      fit: pw.BoxFit.contain,
                                                    ),
                                            ),
                                            // 備註欄 (60 x 39mm)
                                            pw.Container(
                                              width: 60 * PdfPageFormat.mm,
                                              height: 39 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: tb,
                                              ),
                                              padding: const pw.EdgeInsets.all(
                                                2,
                                              ),
                                              child: pw.Text(
                                                '備註：${d.notes}',
                                                style: ts(sz: 8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // === Column 3: 給藥記錄 (總高 21mm) ===
                                  pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 10 * PdfPageFormat.mm,
                                        height: 21 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          '給藥\n記錄',
                                          style: ts(bold: true, sz: 7),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 70 * PdfPageFormat.mm,
                                        height: 21 * PdfPageFormat.mm,
                                        child: pw.Table(
                                          border: tb,
                                          columnWidths: {
                                            0: const pw.FixedColumnWidth(15),
                                            1: const pw.FixedColumnWidth(20),
                                            2: const pw.FixedColumnWidth(15),
                                            3: const pw.FixedColumnWidth(20),
                                          },
                                          children: [
                                            pw.TableRow(
                                              children: [
                                                _lbl(
                                                  '時間',
                                                  h: 3 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '藥名',
                                                  h: 3 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '途徑',
                                                  h: 3 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '執行',
                                                  h: 3 * PdfPageFormat.mm,
                                                ),
                                              ],
                                            ),
                                            ...List.generate(
                                              3,
                                              (i) => pw.TableRow(
                                                children: [
                                                  _cell(
                                                    pw.Text(
                                                      d.medTime[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 6 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.medName[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 6 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.medRoute[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 6 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.medExecutor[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 6 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // --- ASL處置區塊 (寬 27.5mm, 高 21mm) ---
                                      pw.Container(
                                        width: 27.5 * PdfPageFormat.mm,
                                        height: 21 * PdfPageFormat.mm,
                                        child: pw.Column(
                                          children: [
                                            pw.Container(
                                              height: 3 * PdfPageFormat.mm,
                                              width: 27.5 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: tb,
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                'ASL處置',
                                                style: ts(bold: true, sz: 6),
                                              ),
                                            ),
                                            pw.Container(
                                              height: 18 * PdfPageFormat.mm,
                                              width: 27.5 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: tb,
                                              ),
                                              padding: const pw.EdgeInsets.all(
                                                1.5,
                                              ),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.start,
                                                children: [
                                                  _chk(
                                                    '氣管內管 ${d.etTube.isNotEmpty ? d.etTube : "_____"}號\n      固定 ${d.etTubeFixed.isNotEmpty ? d.etTubeFixed : "_____"}cm',
                                                    false,
                                                    sz: 5,
                                                  ),
                                                  pw.SizedBox(height: 2),
                                                  _chk(
                                                    '手動電擊 ${d.manualShockTimes.isNotEmpty ? d.manualShockTimes : "_____"}次\n      ${d.manualShockJoule.isNotEmpty ? d.manualShockJoule : "_____"}Joule',
                                                    false,
                                                    sz: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // --- 線上指導醫師區塊 (寬 27.5mm, 高 21mm) ---
                                      pw.Container(
                                        width: 27.5 * PdfPageFormat.mm,
                                        height: 21 * PdfPageFormat.mm,
                                        child: pw.Column(
                                          children: [
                                            pw.Container(
                                              height: 3 * PdfPageFormat.mm,
                                              width: 27.5 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: tb,
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                '指導醫師',
                                                style: ts(bold: true, sz: 6),
                                              ),
                                            ),
                                            pw.Container(
                                              height: 18 * PdfPageFormat.mm,
                                              width: 27.5 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: tb,
                                              ),
                                              padding: const pw.EdgeInsets.all(
                                                1.5,
                                              ),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  _chk(
                                                    '指導說明：${d.onlinePhysicianNote}',
                                                    false,
                                                    sz: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // === Column 4: 生命徵象 (總高 20mm) ===
                                  pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 10 * PdfPageFormat.mm,
                                        height: 20 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          '生命\n徵象',
                                          style: ts(bold: true, sz: 6),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 125 * PdfPageFormat.mm,
                                        height: 20 * PdfPageFormat.mm,
                                        child: pw.Table(
                                          border: tb,
                                          columnWidths: {
                                            0: const pw.FixedColumnWidth(15),
                                            1: const pw.FixedColumnWidth(17),
                                            2: const pw.FixedColumnWidth(12),
                                            3: const pw.FixedColumnWidth(12),
                                            4: const pw.FixedColumnWidth(12),
                                            5: const pw.FixedColumnWidth(22.5),
                                            6: const pw.FixedColumnWidth(12),
                                            7: const pw.FixedColumnWidth(22.5),
                                          },
                                          children: [
                                            pw.TableRow(
                                              children: [
                                                _lbl(
                                                  '時間',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '意識',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '體溫',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '脈搏',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '呼吸',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  '血壓',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  'SpO2',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                                _lbl(
                                                  'EVM',
                                                  h: 5 * PdfPageFormat.mm,
                                                ),
                                              ],
                                            ),
                                            ...List.generate(
                                              3,
                                              (i) => pw.TableRow(
                                                children: [
                                                  _cell(
                                                    pw.Text(
                                                      d.vsTime[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.vsConsciousness[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.vsTemp[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.vsPulse[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      d.vsBreathing[i],
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      '${d.vsBPSys[i]}/${d.vsBPDia[i]}',
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      '${d.vsSpO2[i]}%',
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                  _cell(
                                                    pw.Text(
                                                      'E${d.vsGcsE[i]}V${d.vsGcsV[i]}M${d.vsGcsM[i]}',
                                                      style: ts(sz: 5),
                                                    ),
                                                    h: 5 * PdfPageFormat.mm,
                                                    align: pw.Alignment.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // === Row 5: 簽名欄 (高度 30mm) ===
                                  pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 10 * PdfPageFormat.mm,
                                        height: 30 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          '簽\n名\n欄',
                                          style: ts(bold: true, sz: 7),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 30 * PdfPageFormat.mm,
                                        height: 30 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        padding: const pw.EdgeInsets.all(2),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text(
                                              '救護人員簽名',
                                              style: ts(sz: 5, bold: true),
                                            ),
                                            pw.Text(
                                              '1.${d.emt1}',
                                              style: ts(sz: 6),
                                            ),
                                            pw.Text(
                                              '2.${d.emt2}',
                                              style: ts(sz: 6),
                                            ),
                                            pw.Text(
                                              '3.${d.emt3}',
                                              style: ts(sz: 6),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Container(
                                        width: 30 * PdfPageFormat.mm,
                                        height: 30 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        padding: const pw.EdgeInsets.all(2),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text(
                                              '接收單位簽名',
                                              style: ts(sz: 5, bold: true),
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Text(
                                              d.receiveUnit,
                                              style: ts(sz: 7),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Container(
                                        width: 30 * PdfPageFormat.mm,
                                        height: 30 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        padding: const pw.EdgeInsets.all(2),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text(
                                              '□ 拒絕送醫聲明：\n本人(或關係人)聲明，救護人員已將病情與拒絕送醫織可能危險告知，但我仍拒絕接受處置及送醫。',
                                              style: ts(sz: 4.5),
                                            ),
                                            pw.Text(
                                              '簽名：${d.refuseTransferSign}',
                                              style: ts(sz: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Container(
                                        width: 35 * PdfPageFormat.mm,
                                        height: 30 * PdfPageFormat.mm,
                                        decoration: pw.BoxDecoration(
                                          border: tb,
                                        ),
                                        padding: const pw.EdgeInsets.all(2),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text(
                                              '病患/家屬/關係人簽名',
                                              style: ts(sz: 5, bold: true),
                                            ),
                                            pw.Text(
                                              '簽名：${d.patientFamilySign}',
                                              style: ts(sz: 6),
                                            ),
                                            pw.Text(
                                              '電話:${d.refuseContactPhone}',
                                              style: ts(sz: 5),
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
                      ],
                    ),
                  ),
                  // ─── [C] 底部頁尾 (高度 5mm) ───
                  pw.Container(
                    width: 270 * PdfPageFormat.mm,
                    height: 5 * PdfPageFormat.mm,
                    alignment: pw.Alignment.bottomCenter,
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('聯新(A432)2022/06x500張', style: ts(sz: 5)),
                        pw.Text(
                          '第一聯：救護車單位自存(白色)　第二聯：交診察醫院(藍色)',
                          style: ts(sz: 5),
                        ),
                        pw.Text('51-S-000-001 ', style: ts(sz: 5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
