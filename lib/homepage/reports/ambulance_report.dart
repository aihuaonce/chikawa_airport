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
  }) {
    return pw.Container(color: bg, alignment: align, child: child);
  }

  pw.Widget _lbl(
    String text, {
    bool bold = true,
    PdfColor? bg,
    pw.Alignment align = pw.Alignment.center,
  }) {
    return _cell(
      pw.Text(
        text,
        style: ts(bold: bold),
        textAlign: pw.TextAlign.center,
      ),
      bg: bg,
      align: align,
    );
  }

  pw.Widget _timeCell(String hour, String min) {
    return _cell(
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [pw.Text(_formatTimeCell(hour, min), style: ts9())],
        ),
      ),
      align: pw.Alignment.centerRight,
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
  const double leftW = 130;
  const double rightW = 130;
  const double totalW = 260; // 130 + 0(間隙) + 130

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(5 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Transform.rotateBox(
          angle: -math.pi / 2,
          child: pw.Container(
            width: totalW * PdfPageFormat.mm,
            height: 200 * PdfPageFormat.mm,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // ══════════════════════════════════════════════════
                // 1. 標題 - 左右對齊 + 車號
                // ══════════════════════════════════════════════════
                pw.Row(
                  children: [
                    // 左半部：標題靠右
                    pw.Container(
                      width: leftW * PdfPageFormat.mm,
                      alignment: pw.Alignment.centerRight,
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Text(
                        '聯  新  國  際  醫  院 桃  園  國  際',
                        style: ts(sz: 12, bold: true),
                      ),
                    ),
                    // 右半部：標題靠左 + 車號
                    pw.Container(
                      width: rightW * PdfPageFormat.mm,
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            ' 機  場  醫  療  中  心  救  護  紀  錄  表',
                            style: ts(sz: 12, bold: true),
                          ),
                          pw.Text('車牌號碼：${d.licensePlate}', style: ts(sz: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3),

                // ══════════════════════════════════════════════════
                // 2. 主內容 (左右兩半)
                // ══════════════════════════════════════════════════
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ────────────────────────────────────────────
                    // 左半部 143 mm
                    // ────────────────────────────────────────────
                    pw.Container(
                      width: leftW * PdfPageFormat.mm,
                      child: pw.Column(
                        children: [
                          // ── 派遣資料 ──────────────────────────
                          // 列1：派遣資料 | 出勤日期 | 西元年月日 (50% + 20% + 30%)
                          pw.Table(
                            border: tbFirstRowBorder,
                            columnWidths: {
                              0: pw.FixedColumnWidth(65 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(26 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(39 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('派 遣 資 料', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('出勤日期', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text(
                                        d.dispatchDateYear.isEmpty &&
                                                d.dispatchDateMonth.isEmpty &&
                                                d.dispatchDateDay.isEmpty
                                            ? '西元             年             月             日'
                                            : '西元${_pad(d.dispatchDateYear, 4)}年${_pad(d.dispatchDateMonth, 2)}月${_pad(d.dispatchDateDay, 2)}日',
                                        style: ts9(),
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 列2：時間標題 - 六等分 (每個 21.67mm)
                          pw.Table(
                            border: tbTimeBorder,
                            columnWidths: {
                              0: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('出勤時間', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('到達現場', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('離開現場', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('送達時間', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('離開時間', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('返回待命', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 列3：時間資料 - 六等分
                          pw.Table(
                            border: tbRow3Border,
                            columnWidths: {
                              0: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(21.67 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _timeCell(d.departureHour, d.departureMin),
                                  _timeCell(d.arrivalHour, d.arrivalMin),
                                  _timeCell(d.leaveSceneHour, d.leaveSceneMin),
                                  _timeCell(d.deliveryHour, d.deliveryMin),
                                  _timeCell(d.leaveHospHour, d.leaveHospMin),
                                  _timeCell(d.returnBaseHour, d.returnBaseMin),
                                ],
                              ),
                            ],
                          ),

                          // 列4：發生地點 / 送往 (20% + 30% + 20% + 30%)
                          pw.Table(
                            border: tbTimeBorder,
                            columnWidths: {
                              0: pw.FixedColumnWidth(26 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(39 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(26 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(39 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('發生地點', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text(
                                        d.incidentLocation.isEmpty
                                            ? _pad('', 20)
                                            : d.incidentLocation,
                                        style: ts9(),
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('送往醫院或地點', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Row(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.center,
                                        children: [
                                          pw.Text(
                                            d.sendToHospital.isEmpty
                                                ? _pad('', 20)
                                                : d.sendToHospital,
                                            style: ts9(),
                                          ),
                                          pw.SizedBox(width: 4),
                                          pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              _chk(
                                                '病情需要',
                                                d.sendReasonCondition,
                                                fillBlack: true,
                                              ),
                                              _chk(
                                                '病患要求',
                                                d.sendReasonPatientRequest,
                                                fillBlack: true,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ── 病患資料 ──────────────────────────
                          pw.Table(
                            border: tbTimeBorder,
                            columnWidths: {
                              0: pw.FixedColumnWidth(130 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Text('病患資料', style: ts9()),
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 姓名/性別/病患財物明細 (15+33+13+22+30+30=143)
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(15 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(33 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(13 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(22 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(30 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(30 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('姓名', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text(
                                        d.patientName,
                                        style: ts9(),
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('性別', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          _chk(
                                            '男',
                                            d.gender == '男',
                                            fillBlack: true,
                                          ),
                                          _chk(
                                            '女',
                                            d.gender == '女',
                                            fillBlack: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('病患財物明細：', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          _chk(
                                            '未經手',
                                            d.propertyNone,
                                            fillBlack: true,
                                          ),
                                          pw.SizedBox(width: 3),
                                          _chk(
                                            '有',
                                            d.propertyHas,
                                            fillBlack: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                              // 第二行：身分證、年齡、保管人簽章 (6格)
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text(
                                        '身分證字號/\n護照號碼',
                                        style: ts9(),
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text(
                                        d.idOrPassport,
                                        style: ts9(),
                                      ),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('年齡(歲)', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('${d.age}歲', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: pw.Text('保管人(簽章)', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child:
                                          d.guardianSign != null &&
                                              d.guardianSign!.isNotEmpty
                                          ? pw.Image(
                                              pw.MemoryImage(d.guardianSign!),
                                              height: 20,
                                            )
                                          : pw.Text('', style: ts9()),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 住址 (直接代入，不使用粗體)
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(131 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Text('住址', style: ts9(bold: false)),
                                    align: pw.Alignment.center,
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      child: pw.Align(
                                        alignment: pw.Alignment.centerLeft,
                                        child: pw.Text(
                                          d.address,
                                          style: ts9(bold: false),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ── 現場狀況 ──────────────────────────
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(leftW * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl(
                                    '現場狀況 (此欄可複選)',
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 非創傷 / 創傷 (65+65=130)
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(65 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(65 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('□ 非創傷', align: pw.Alignment.center),
                                  _lbl('□ 創傷', align: pw.Alignment.center),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3),
                                      child: pw.Row(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Container(
                                            width: 35 * PdfPageFormat.mm,
                                            child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                _chk(
                                                  '急症',
                                                  d.ntiEmergency,
                                                  bold: true,
                                                ),
                                                _chk(
                                                  '呼吸問題\n(喘/呼吸急促)',
                                                  d.ntiBreathIssue,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '呼吸道問題\n(異物哽塞)',
                                                  d.ntiAirwayIssue,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '昏迷(意識不清)',
                                                  d.ntiFaint,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '胸痛/胸悶',
                                                  d.ntiChestPain,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '腹痛',
                                                  d.ntiAbdomen,
                                                  indent: 3,
                                                ),
                                                pw.SizedBox(height: 2),
                                                _chk(
                                                  '一般疾病',
                                                  d.ntiGeneral,
                                                  bold: true,
                                                ),
                                                _chk(
                                                  '頭痛/頭暈',
                                                  d.ntiHeadache,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '昏倒/昏厥',
                                                  d.ntiFaint,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '發燒',
                                                  d.ntiFever,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '噁心/嘔吐/腹瀉',
                                                  d.ntiNausea,
                                                  indent: 3,
                                                ),
                                                _chk(
                                                  '肢體無力',
                                                  d.ntiWeakness,
                                                  indent: 3,
                                                ),
                                              ],
                                            ),
                                          ),
                                          pw.SizedBox(width: 4),
                                          pw.Container(
                                            width: 24 * PdfPageFormat.mm,
                                            child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                _chk('疑似毒藥物中毒', d.ntiDrug),
                                                _chk('疑似一氧化碳中毒', d.ntiCO),
                                                _chk('癲癇/抽搐', d.ntiSeizure),
                                                _chk('路倒', d.ntiFall),
                                                _chk('精神異常', d.ntiMental),
                                                _chk('孕婦急產', d.ntiPregnancy),
                                                _chk(
                                                  '到院前心肺功能停止',
                                                  d.ntiCardiacArrest,
                                                ),
                                                _chk('其他', d.ntiOtherNT),
                                                if (d.ntiOtherNTText.isNotEmpty)
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.only(
                                                          left: 6,
                                                        ),
                                                    child: pw.Text(
                                                      d.ntiOtherNTText,
                                                      style: ts(),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3),
                                      child: pw.Column(
                                        children: [
                                          pw.Row(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Container(
                                                width: 30 * PdfPageFormat.mm,
                                                child: pw.Column(
                                                  crossAxisAlignment: pw
                                                      .CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    _chk(
                                                      '一般外傷',
                                                      d.trGeneral,
                                                      bold: true,
                                                    ),
                                                    _chk(
                                                      '頭部外傷',
                                                      d.trHead,
                                                      indent: 3,
                                                    ),
                                                    _chk(
                                                      '胸部外傷',
                                                      d.trChest,
                                                      indent: 3,
                                                    ),
                                                    _chk(
                                                      '腹部外傷',
                                                      d.trAbdomen,
                                                      indent: 3,
                                                    ),
                                                    _chk(
                                                      '背部外傷',
                                                      d.trBack,
                                                      indent: 3,
                                                    ),
                                                    _chk(
                                                      '肢體外傷',
                                                      d.trLimb,
                                                      indent: 3,
                                                    ),
                                                    _chk(
                                                      '其他',
                                                      d.trOtherT,
                                                      indent: 3,
                                                    ),
                                                    pw.SizedBox(height: 2),
                                                    _chk(
                                                      '受傷機轉',
                                                      false,
                                                      bold: true,
                                                    ),
                                                    _chk(
                                                      '因交通事故',
                                                      d.trTrafficAcc,
                                                      indent: 3,
                                                    ),
                                                    _chk(
                                                      '非交通事故',
                                                      d.trNonTrafficAcc,
                                                      indent: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              pw.SizedBox(width: 4),
                                              pw.Container(
                                                width: 30 * PdfPageFormat.mm,
                                                child: pw.Column(
                                                  crossAxisAlignment: pw
                                                      .CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    _chk('溺水', d.trDrown),
                                                    _chk('摔跌傷', d.trFall),
                                                    _chk(
                                                      '墜落傷(約${d.trFallHeight.isNotEmpty ? d.trFallHeight : '__'}公尺)',
                                                      d.trCrush,
                                                    ),
                                                    _chk('穿刺傷', d.trPenetrate),
                                                    _chk(
                                                      "燒燙傷 度: ${d.trBurnDegree.isNotEmpty ? d.trBurnDegree : '___'} %: ___",
                                                      d.trBurn,
                                                    ),
                                                    _chk('電擊傷', d.trElectric),
                                                    _chk('生物螫咬', d.trBioStrike),
                                                    _chk(
                                                      '到院前心肺功能停止',
                                                      d.trCardiacArrest,
                                                    ),
                                                    _chk('其他', d.trOtherT2),
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
                                          pw.Table(
                                            columnWidths: {
                                              0: pw.FixedColumnWidth(
                                                65 * PdfPageFormat.mm,
                                              ),
                                            },
                                            children: [
                                              pw.TableRow(
                                                children: [
                                                  _lbl(
                                                    '過敏史',
                                                    align: pw.Alignment.center,
                                                  ),
                                                ],
                                              ),
                                              pw.TableRow(
                                                children: [
                                                  _cell(
                                                    pw.Column(
                                                      crossAxisAlignment: pw
                                                          .CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        pw.Row(
                                                          children: [
                                                            _chk(
                                                              '無',
                                                              d.allergyNone,
                                                            ),
                                                            pw.SizedBox(
                                                              width: 4,
                                                            ),
                                                            _chk(
                                                              '不詳',
                                                              d.allergyUnknown,
                                                            ),
                                                          ],
                                                        ),
                                                        pw.Row(
                                                          children: [
                                                            _chk(
                                                              '食物: ${d.allergyFood}',
                                                              false,
                                                            ),
                                                          ],
                                                        ),
                                                        pw.Row(
                                                          children: [
                                                            _chk(
                                                              '藥物: ${d.allergyMeds}',
                                                              false,
                                                            ),
                                                            if (d
                                                                .allergyOther
                                                                .isNotEmpty)
                                                              pw.SizedBox(
                                                                width: 4,
                                                              ),
                                                            if (d
                                                                .allergyOther
                                                                .isNotEmpty)
                                                              _chk(
                                                                '其他: ${d.allergyOther}',
                                                                false,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ── 病患主訴 / 過去病史（穩定短版 + 標題水平垂直置中 + 上面留白減少） ─────
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(59.5 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(59.5 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  // 病患主訴標題 - 水平垂直置中
                                  _cell(
                                    pw.Container(
                                      height: 48, // 控制高度，建議不要超過50
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                        '病\n患\n主\n訴',
                                        style: ts(bold: true),
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.fromLTRB(
                                        5,
                                        4,
                                        5,
                                        6,
                                      ), // 上方留白少一點
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          _chk('家屬或同事、有人代述', d.chiefByFamily),
                                          pw.SizedBox(height: 4),
                                          pw.Text(
                                            d.chiefComplaint.isNotEmpty
                                                ? d.chiefComplaint
                                                : ' ',
                                            style: ts(sz: 6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // 過去病史標題 - 水平垂直置中
                                  _cell(
                                    pw.Container(
                                      height: 48,
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                        '過\n去\n病\n史',
                                        style: ts(bold: true),
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.fromLTRB(
                                        5,
                                        4,
                                        5,
                                        6,
                                      ),
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Wrap(
                                            spacing: 6,
                                            runSpacing: 3,
                                            children: [
                                              _chk('無', d.histNone),
                                              _chk('不詳', d.histUnknown),
                                              _chk('高血壓', d.histHypertension),
                                              _chk('糖尿病', d.histDiabetes),
                                              _chk('心臟病', d.histHeart),
                                              _chk('腦中風', d.histStroke),
                                              _chk('腎臟病', d.histKidney),
                                              _chk('肺臟病', d.histLung),
                                              _chk('氣喘', d.histAsthma),
                                              _chk(
                                                '其他',
                                                d.histOther.isNotEmpty,
                                              ),
                                            ],
                                          ),
                                          if (d.histOther.isNotEmpty)
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.only(
                                                left: 6,
                                                top: 4,
                                              ),
                                              child: pw.Text(
                                                d.histOther,
                                                style: ts(sz: 6),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 費用
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(leftW * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(
                                        6,
                                      ), // 整體加上 padding
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          // 第1行：費用金額（字放大 + 預留長空位）
                                          pw.Row(
                                            children: [
                                              pw.Text(
                                                '救護車費用(含醫護人員): ',
                                                style: ts(sz: 7.5, bold: true),
                                              ),
                                              pw.Text(
                                                d.ambulanceFee.isNotEmpty
                                                    ? d.ambulanceFee
                                                    : '__________________',
                                                style: ts(sz: 7.5, bold: true),
                                              ),
                                              pw.SizedBox(width: 10),
                                              pw.Text(
                                                '氧氣使用費: ',
                                                style: ts(sz: 7.5, bold: true),
                                              ),
                                              pw.Text(
                                                d.o2Fee.isNotEmpty
                                                    ? d.o2Fee
                                                    : '__________________',
                                                style: ts(sz: 7.5, bold: true),
                                              ),
                                              pw.SizedBox(width: 10),
                                              pw.Text(
                                                '總計: ',
                                                style: ts(sz: 7.5, bold: true),
                                              ),
                                              pw.Text(
                                                d.totalFee.isNotEmpty
                                                    ? d.totalFee
                                                    : '__________________',
                                                style: ts(sz: 7.5, bold: true),
                                              ),
                                            ],
                                          ),

                                          pw.SizedBox(height: 10), // 間距拉開
                                          // 第2行：已收費 + 代收
                                          pw.Row(
                                            children: [
                                              _chk(
                                                '已收費 (現金 / 刷卡)',
                                                d.paidCash || d.paidCard,
                                                sz: 6.5, // 勾選框文字也稍微放大
                                              ),
                                              pw.SizedBox(width: 40), // 間距拉開
                                              _chk(
                                                '聯新國際醫院代收',
                                                d.paidHospital,
                                                sz: 6.5,
                                              ),
                                            ],
                                          ),

                                          pw.SizedBox(height: 8), // 間距拉開
                                          // 第3行：未收費（永遠預留空位）
                                          pw.Row(
                                            children: [
                                              _chk(
                                                '未收費 (欠款 / 匯款 / 統一請款: ',
                                                d.unpaid,
                                                sz: 6.5,
                                              ),
                                              pw.Text(
                                                d.unpaid &&
                                                        d.unpaidNote.isNotEmpty
                                                    ? '${d.unpaidNote}'
                                                    : '__________________',
                                                style: ts(sz: 7, bold: true),
                                              ),
                                              pw.Text(
                                                d.unpaid ? ')' : ' )',
                                                style: ts(sz: 7, bold: true),
                                              ),
                                            ],
                                          ),
                                        ],
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
                    // ────────────────────────────────────────────
                    // 右半部 143 mm
                    // ────────────────────────────────────────────
                    pw.Container(
                      width: rightW * PdfPageFormat.mm,
                      child: pw.Column(
                        children: [
                          // ── 處置項目（標題獨立一整欄 + 急救處置垂直置中加強版） ─────────────────────
                          pw.Column(
                            children: [
                              // 1. 標題獨立一整欄
                              pw.Table(
                                border: tbInner,
                                columnWidths: {
                                  0: pw.FixedColumnWidth(
                                    rightW * PdfPageFormat.mm,
                                  ),
                                },
                                children: [
                                  pw.TableRow(children: [_lbl('處置項目（此欄可複選）')]),
                                ],
                              ),
                              // 2. 內容表格
                              pw.Table(
                                border: tbFull,
                                columnWidths: {
                                  0: pw.FixedColumnWidth(
                                    9 * PdfPageFormat.mm,
                                  ), // 垂直標籤欄位稍加寬
                                  1: pw.FixedColumnWidth(39 * PdfPageFormat.mm),
                                  2: pw.FixedColumnWidth(39 * PdfPageFormat.mm),
                                  3: pw.FixedColumnWidth(
                                    56 * PdfPageFormat.mm,
                                  ), // 人體圖欄位加大
                                },
                                children: [
                                  pw.TableRow(
                                    children: [
                                      // 垂直「急救處置」標籤 - 加強垂直置中
                                      _cell(
                                        pw.Container(
                                          height: 192, // 關鍵調整：加大高度讓文字真正置中
                                          alignment: pw.Alignment.center,
                                          child: pw.Text(
                                            '急\n救\n處\n置',
                                            style: ts(
                                              sz: 8,
                                              bold: true,
                                            ), // 字稍微放大一點
                                            textAlign: pw.TextAlign.center,
                                          ),
                                        ),
                                      ),

                                      // 左欄：呼吸道 + 創傷 + 搬運
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(5),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              _chk('呼吸道處置', false, bold: true),
                                              _chk(
                                                '口咽呼吸道',
                                                d.airOralAirway,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '鼻咽呼吸道',
                                                d.airNasalAirway,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '抽吸',
                                                d.airSuction,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '哈姆立克法',
                                                d.airHeimlick,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '鼻管${d.airNasalLMin.isNotEmpty ? " ${d.airNasalLMin}L/MIN" : ""}',
                                                d.airNasalO2,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '面罩${d.airMaskLMin.isNotEmpty ? " ${d.airMaskLMin}L/MIN" : ""}',
                                                d.airMaskO2,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '非再吸入型面罩',
                                                d.airNonRebreather,
                                                indent: 2,
                                              ),
                                              _chk(
                                                'BVM(正壓輔助呼吸)',
                                                d.airBVM,
                                                indent: 2,
                                              ),
                                              _chk(
                                                'LMA ${d.airLMANo.isNotEmpty ? d.airLMANo : "__"}號',
                                                d.airLMA,
                                                indent: 2,
                                              ),
                                              _chk(
                                                'Igel ${d.airIgelNo.isNotEmpty ? d.airIgelNo : "__"}號',
                                                d.airIgel,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '氣管內管 ${d.airETNo.isNotEmpty ? d.airETNo : "__"}號',
                                                d.airEndotracheal,
                                                indent: 2,
                                              ),
                                              if (d.airOtherText.isNotEmpty)
                                                _chk(
                                                  '其他: ${d.airOtherText}',
                                                  d.airOther,
                                                  indent: 2,
                                                ),

                                              pw.SizedBox(height: 8),
                                              _chk('創傷處置', false, bold: true),
                                              _chk('頸圈', d.trCollar, indent: 2),
                                              _chk(
                                                '清洗傷口',
                                                d.trCleanWound,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '止血、包紮',
                                                d.trHemostasis,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '骨折固定',
                                                d.trImmobilize,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '長背板固定',
                                                d.trBackboard,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '鏟式擔架固定',
                                                d.trSplint,
                                                indent: 2,
                                              ),
                                              if (d.trOtherTText.isNotEmpty)
                                                _chk(
                                                  '其他: ${d.trOtherTText}',
                                                  d.trOtherT,
                                                  indent: 2,
                                                ),

                                              pw.SizedBox(height: 8),
                                              _chk('搬運', false, bold: true),
                                              _chk('自行上車', false, indent: 2),
                                              _chk('以適當方式搬運', true, indent: 2),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 中欄：心肺復甦術 + 藥物處置 + 其他處置
                                      _cell(
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(5),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              _chk('心肺復甦術', false, bold: true),
                                              _chk(
                                                '自動心肺復甦機',
                                                d.cprAuto,
                                                indent: 2,
                                              ),
                                              _chk(
                                                'CPR: ${d.cprAEDMin.isNotEmpty ? d.cprAEDMin : "______"} 分鐘',
                                                d.cprCPR,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '使用 AED',
                                                d.cprAED,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '電擊去顫${d.cprShockTimes.isNotEmpty ? " ${d.cprShockTimes}次" : ""}',
                                                d.cprElectricShock,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '不建議電擊',
                                                d.cprNoElectric,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '手動電擊器',
                                                d.cprHandShock,
                                                indent: 2,
                                              ),

                                              pw.SizedBox(height: 8),
                                              _chk('藥物處置', false, bold: true),
                                              _chk(
                                                '靜脈輸液，部位${d.medIVPart.isNotEmpty ? " ${d.medIVPart}" : "______"}',
                                                d.medIV,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '0.9%N/S${d.medNSml.isNotEmpty ? " ${d.medNSml}ml" : ""}',
                                                d.medNS,
                                                indent: 2,
                                              ),
                                              _chk(
                                                'L/R${d.medLRml.isNotEmpty ? " ${d.medLRml}ml" : ""}',
                                                d.medLR,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '葡萄糖液${d.medGlucoseType.isNotEmpty ? " ${d.medGlucoseType}" : ""}ml',
                                                d.medGlucose,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '口服葡萄糖液/粉',
                                                false,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '協助使用 Aspirin',
                                                d.medAspirin,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '協助使用 NTG${d.medNTGCount.isNotEmpty ? " ${d.medNTGCount}片" : ""}',
                                                d.medNTG,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '協助使用支氣管擴張劑${d.medBronchoTimes.isNotEmpty ? " ${d.medBronchoTimes}次" : ""}',
                                                d.medBroncho,
                                                indent: 2,
                                              ),

                                              pw.SizedBox(height: 8),
                                              _chk('其他處置', false, bold: true),
                                              _chk(
                                                '保暖',
                                                d.otherKeepWarm,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '心理支持',
                                                d.otherPsych,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '約束帶',
                                                d.otherBandage,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '拒絕使用氧氣',
                                                d.otherO2Refuse,
                                                indent: 2,
                                              ),
                                              _chk(
                                                '生命徵象監測',
                                                d.otherVitalMonitor,
                                                indent: 2,
                                              ),
                                              if (d.otherOtherText.isNotEmpty)
                                                _chk(
                                                  '其他: ${d.otherOtherText}',
                                                  d.otherOther,
                                                  indent: 2,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 右欄：人體圖 + 備註（顯示背景 + 所有筆跡）
                                      _cell(
                                        pw.Column(
                                          children: [
                                            pw.Text(
                                              '請在圖上標示說明受傷部位及其尺寸：',
                                              style: ts(bold: true, sz: 7),
                                              textAlign: pw.TextAlign.center,
                                            ),
                                            pw.SizedBox(height: 6),

                                            // 優先使用有筆跡的圖片，否則用原始背景
                                            if (bodyMapWithDrawing != null &&
                                                bodyMapWithDrawing.isNotEmpty)
                                              pw.Image(
                                                pw.MemoryImage(
                                                  bodyMapWithDrawing,
                                                ),
                                                height: 120, // 可調整大小
                                                fit: pw.BoxFit.contain,
                                              )
                                            else
                                              pw.Image(
                                                bodyImage,
                                                height: 120,
                                                fit: pw.BoxFit.contain,
                                              ),

                                            pw.Divider(
                                              height: 0.5,
                                              thickness: 0.5,
                                              color: PdfColors.black,
                                            ),

                                            pw.Container(
                                              height: 24 * PdfPageFormat.mm,
                                              alignment: pw.Alignment.topLeft,
                                              padding: const pw.EdgeInsets.all(
                                                5,
                                              ),
                                              child: pw.Text(
                                                '備註：${d.notes}',
                                                style: ts(sz: 6.5),
                                              ),
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

                          // ── 給藥紀錄（跟急救處置一樣靠左，佔滿整個右半部） ─────────────────
                          pw.Container(
                            width: rightW * PdfPageFormat.mm, // ← 跟急救處置一樣寬度
                            height: 72,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                                color: PdfColors.black,
                              ),
                            ),
                            child: pw.Row(
                              children: [
                                // 1. 第一直行：給藥紀錄 垂直標題
                                pw.Container(
                                  width: 8.5 * PdfPageFormat.mm, // ← 標題欄加長
                                  height: 72,
                                  alignment: pw.Alignment.center,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border(
                                      right: pw.BorderSide(width: 0.5),
                                    ),
                                  ),
                                  child: pw.Text(
                                    '給\n藥\n紀\n錄',
                                    style: ts(sz: 7.5, bold: true),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),

                                // 右側內容
                                pw.Expanded(
                                  child: pw.Column(
                                    children: [
                                      // 標題列（從第二行開始）
                                      pw.Container(
                                        height: 16,
                                        child: pw.Row(
                                          children: [
                                            pw.Container(
                                              width: 20 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border(
                                                  right: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                  bottom: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                '時間',
                                                style: ts(sz: 6, bold: true),
                                              ),
                                            ),
                                            pw.Container(
                                              width: 23 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border(
                                                  right: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                  bottom: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                '藥名',
                                                style: ts(sz: 6, bold: true),
                                              ),
                                            ),
                                            pw.Container(
                                              width: 23 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border(
                                                  right: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                  bottom: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                '途徑/劑量',
                                                style: ts(sz: 6, bold: true),
                                              ),
                                            ),
                                            pw.Container(
                                              width: 15 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border(
                                                  right: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                  bottom: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                '執行者',
                                                style: ts(sz: 6, bold: true),
                                              ),
                                            ),
                                            pw.Container(
                                              width: 23 * PdfPageFormat.mm,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border(
                                                  right: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                  bottom: pw.BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              alignment: pw.Alignment.center,
                                              child: pw.Text(
                                                'ASL處置',
                                                style: ts(sz: 6, bold: true),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                decoration: pw.BoxDecoration(
                                                  border: pw.Border(
                                                    bottom: pw.BorderSide(
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                alignment: pw.Alignment.center,
                                                child: pw.Text(
                                                  '線上指導醫師',
                                                  style: ts(sz: 6, bold: true),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // 資料內容區（4行）
                                      pw.Expanded(
                                        child: pw.Row(
                                          children: [
                                            // 時間
                                            pw.Container(
                                              width:
                                                  20 * PdfPageFormat.mm, // ← +3
                                              child: pw.Column(
                                                children: List.generate(
                                                  4,
                                                  (i) => pw.Expanded(
                                                    child: pw.Container(
                                                      alignment:
                                                          pw.Alignment.center,
                                                      decoration:
                                                          pw.BoxDecoration(
                                                            border: pw.Border(
                                                              right:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                              bottom:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                            ),
                                                          ),
                                                      child: pw.Text(
                                                        d.medTime[i],
                                                        style: ts(sz: 6),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 藥名
                                            pw.Container(
                                              width:
                                                  23 *
                                                  PdfPageFormat.mm, // ← 對齊標題列
                                              child: pw.Column(
                                                children: List.generate(
                                                  4,
                                                  (i) => pw.Expanded(
                                                    child: pw.Container(
                                                      alignment:
                                                          pw.Alignment.center,
                                                      decoration:
                                                          pw.BoxDecoration(
                                                            border: pw.Border(
                                                              right:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                              bottom:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                            ),
                                                          ),
                                                      child: pw.Text(
                                                        d.medName[i],
                                                        style: ts(sz: 6),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 途徑/劑量
                                            pw.Container(
                                              width: 23 * PdfPageFormat.mm,
                                              child: pw.Column(
                                                children: List.generate(
                                                  4,
                                                  (i) => pw.Expanded(
                                                    child: pw.Container(
                                                      alignment:
                                                          pw.Alignment.center,
                                                      decoration:
                                                          pw.BoxDecoration(
                                                            border: pw.Border(
                                                              right:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                              bottom:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                            ),
                                                          ),
                                                      child: pw.Text(
                                                        d.medRoute[i],
                                                        style: ts(sz: 6),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 執行者
                                            pw.Container(
                                              width: 15 * PdfPageFormat.mm,
                                              child: pw.Column(
                                                children: List.generate(
                                                  4,
                                                  (i) => pw.Expanded(
                                                    child: pw.Container(
                                                      alignment:
                                                          pw.Alignment.center,
                                                      decoration:
                                                          pw.BoxDecoration(
                                                            border: pw.Border(
                                                              right:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                              bottom:
                                                                  pw.BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                            ),
                                                          ),
                                                      child: pw.Text(
                                                        d.medExecutor[i],
                                                        style: ts(sz: 6),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // ASL處置
                                            pw.Container(
                                              width: 23 * PdfPageFormat.mm,
                                              child: pw.Column(
                                                children: List.generate(
                                                  4,
                                                  (i) => pw.Expanded(
                                                    child: i == 0
                                                        ? pw.Container(
                                                            padding:
                                                                const pw.EdgeInsets.all(
                                                                  3,
                                                                ),
                                                            alignment: pw
                                                                .Alignment
                                                                .topLeft,
                                                            decoration: pw.BoxDecoration(
                                                              border: pw.Border(
                                                                right:
                                                                    pw.BorderSide(
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                              ),
                                                            ),
                                                            child: pw.Column(
                                                              crossAxisAlignment: pw
                                                                  .CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                _chk(
                                                                  '氣管內管 ${d.etTube.isNotEmpty ? d.etTube : "__"}號 固定 ${d.etTubeFixed.isNotEmpty ? d.etTubeFixed : "__"}cm',
                                                                  false,
                                                                  sz: 5,
                                                                ),
                                                                pw.SizedBox(
                                                                  height: 4,
                                                                ),
                                                                _chk(
                                                                  '手動電擊 ${d.manualShockTimes.isNotEmpty ? d.manualShockTimes : "__"}次',
                                                                  false,
                                                                  sz: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : pw.SizedBox(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 線上指導醫師（有框線 + 置中）
                                            pw.Expanded(
                                              child: pw.Column(
                                                children: List.generate(
                                                  4,
                                                  (i) => pw.Expanded(
                                                    child: i == 0
                                                        ? pw.Container(
                                                            alignment: pw
                                                                .Alignment
                                                                .center,
                                                            decoration: pw.BoxDecoration(
                                                              border: pw.Border(
                                                                left:
                                                                    pw.BorderSide(
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                              ),
                                                            ),
                                                            padding:
                                                                const pw.EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            child: pw.Column(
                                                              mainAxisAlignment: pw
                                                                  .MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                pw.Text(
                                                                  '指導說明：',
                                                                  style: ts(
                                                                    sz: 5,
                                                                    bold: true,
                                                                  ),
                                                                ),
                                                                pw.SizedBox(
                                                                  height: 2,
                                                                ),
                                                                pw.Text(
                                                                  d.onlinePhysicianNote,
                                                                  style: ts(
                                                                    sz: 5,
                                                                  ),
                                                                  textAlign: pw
                                                                      .TextAlign
                                                                      .center,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : pw.Container(
                                                            decoration: pw.BoxDecoration(
                                                              border: pw.Border(
                                                                left:
                                                                    pw.BorderSide(
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── 生命徵象 (修正：4 列) ─────────────
                          // 6+14+14+12+12+12+22+15+36=143
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(6 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(14 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(14 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              6: pw.FixedColumnWidth(22 * PdfPageFormat.mm),
                              7: pw.FixedColumnWidth(15 * PdfPageFormat.mm),
                              8: pw.FixedColumnWidth(36 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('生命\n徵象'),
                                  _lbl('時間'),
                                  _lbl('意識'),
                                  _lbl('體溫'),
                                  _lbl('脈搏'),
                                  _lbl('呼吸'),
                                  _lbl('血壓'),
                                  _lbl('SpO2'),
                                  _lbl('GCS'),
                                ],
                              ),
                              // 修正：3 → 4 列
                              ...List.generate(4, (i) {
                                return pw.TableRow(
                                  children: [
                                    if (i == 0)
                                      _cell(
                                        pw.Center(
                                          child: pw.Transform.rotateBox(
                                            angle: -math.pi / 2,
                                            child: pw.Text(
                                              '生命徵象',
                                              style: ts(bold: true),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      pw.SizedBox(),
                                    _lbl(d.vsTime[i], bold: false),
                                    _lbl(d.vsConsciousness[i], bold: false),
                                    _lbl(d.vsTemp[i], bold: false),
                                    _lbl(d.vsPulse[i], bold: false),
                                    _lbl(d.vsBreathing[i], bold: false),
                                    _lbl(
                                      '${d.vsBPSys[i]} / ${d.vsBPDia[i]}',
                                      bold: false,
                                    ),
                                    _lbl(d.vsSpO2[i], bold: false),
                                    _lbl(
                                      'E${d.vsGcsE[i]} V${d.vsGcsV[i]} M${d.vsGcsM[i]}',
                                      bold: false,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),

                          // ── 到院後狀況 (修正：新增區塊) ─────────
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(130 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Row(
                                      children: [
                                        pw.Text(
                                          '到院後狀況：',
                                          style: ts(bold: true),
                                        ),
                                        _chk('清醒', d.postAlert),
                                        _chk('疼痛', d.postPain),
                                        _chk('心停', d.postArrested),
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

                // ══════════════════════════════════════════════════
                // 3. 底部簽名 (287 mm 全寬)
                // ══════════════════════════════════════════════════
                pw.Table(
                  border: tbFull,
                  columnWidths: {
                    0: pw.FixedColumnWidth(6 * PdfPageFormat.mm),
                    1: pw.FixedColumnWidth(79 * PdfPageFormat.mm),
                    2: pw.FixedColumnWidth(50 * PdfPageFormat.mm),
                    3: pw.FixedColumnWidth(80 * PdfPageFormat.mm),
                    4: pw.FixedColumnWidth(70 * PdfPageFormat.mm),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        _cell(
                          pw.Center(
                            child: pw.Text('簽\n名\n欄', style: ts(bold: true)),
                          ),
                        ),
                        _cell(
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('救護車救護人員簽名', style: ts(bold: true)),
                              pw.SizedBox(height: 10),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceEvenly,
                                children: [
                                  pw.Text('一、 ${d.emt1}', style: ts(sz: 8)),
                                  pw.Text('二、 ${d.emt2}', style: ts(sz: 8)),
                                  pw.Text('三、 ${d.emt3}', style: ts(sz: 8)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _cell(
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('接收單位簽名', style: ts(bold: true)),
                              pw.SizedBox(height: 10),
                              pw.Center(
                                child: pw.Text(d.receiveUnit, style: ts(sz: 8)),
                              ),
                            ],
                          ),
                        ),
                        _cell(
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('拒絕送醫聲明', style: ts(bold: true)),
                              pw.Text(
                                '□ 拒絕送醫聲明：本人(或關係人)聲明，救護人員已將病情與拒絕送醫之可能危險告知，但我仍拒絕接受處置及送醫。',
                                style: ts(),
                              ),
                              pw.SizedBox(height: 4),
                              // 修正：顯示拒絕送醫簽名
                              pw.Text(
                                '簽名：${d.refuseTransferSign}',
                                style: ts(),
                              ),
                            ],
                          ),
                        ),
                        _cell(
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('病患/家屬/關係人簽名', style: ts(bold: true)),
                              pw.SizedBox(height: 4),
                              // 修正：顯示簽名時間
                              pw.Text(
                                '簽名時間：${d.signTimeHour}:${d.signTimeMin}',
                                style: ts(sz: 7),
                              ),
                              pw.Text(
                                '簽名：${d.patientFamilySign}',
                                style: ts(sz: 7),
                              ),
                              pw.Text(
                                '連絡電話：${d.refuseContactPhone}',
                                style: ts(sz: 7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 頁尾
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('聯新(A432)2022/06x500張', style: ts()),
                    pw.Text('第一聯：救護車單位自存(白色)　第二聯：交診察醫院(藍色)', style: ts()),
                    pw.Text('51-S-000-001', style: ts()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
