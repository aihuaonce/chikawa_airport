import 'dart:typed_data';
import 'dart:math' as math;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
}

Future<Uint8List> buildAmbulanceReportPdf(AmbulanceReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  // 字體與邊框設定
  pw.TextStyle ts({double sz = 6.0, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz);
  final tbFull = pw.TableBorder.all(width: 0.5, color: PdfColors.black);
  final bSide = pw.BorderSide(width: 0.5, color: PdfColors.black);
  final tbInner = pw.TableBorder(
    left: bSide,
    right: bSide,
    bottom: bSide,
    verticalInside: bSide,
  );

  // 輔助格 UI
  pw.Widget _cell(
    pw.Widget child, {
    PdfColor? bg,
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      color: bg,
      padding: const pw.EdgeInsets.all(1.5),
      alignment: align,
      child: child,
    );
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

  pw.Widget _chk(
    String label,
    bool checked, {
    double sz = 5.5,
    bool bold = false,
    double indent = 0,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent, right: 2, bottom: 1, top: 0.5),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: 4.5,
            height: 4.5,
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
            child: checked
                ? pw.Center(
                    child: pw.Text(
                      'v',
                      style: pw.TextStyle(font: font, fontSize: 4),
                    ),
                  )
                : null,
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

  // ============== 絕對尺寸定義 (公釐 mm) ==============
  final double leftW = 143;
  final double rightW = 143;
  final double totalW = 287; // 左 143 + 間距 1 + 右 143

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(5 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Transform.rotateBox(
          angle: -math.pi / 2, // 轉為橫式
          child: pw.Container(
            width: totalW * PdfPageFormat.mm,
            height: 200 * PdfPageFormat.mm,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // ==================== 1. 標題列 ====================
                pw.Container(
                  height: 12 * PdfPageFormat.mm,
                  width: totalW * PdfPageFormat.mm,
                  child: pw.Stack(
                    alignment: pw.Alignment.center, // Stack 預設內容在中央
                    children: [
                      // 大標題：自動置於 Stack 的中央
                      pw.Text(
                        '聯 新 國 際 醫 院 桃 園 國 際 機 場 醫 療 中 心 救 護 紀 錄 表',
                        style: ts(sz: 12, bold: true),
                      ),
                      // 車牌號碼：定位在 Stack 的最右邊
                      pw.Positioned(
                        right: 0,
                        child: pw.Center(
                          // 垂直置中
                          child: pw.Text(
                            '車牌號碼：${d.licensePlate}',
                            style: ts(sz: 9, bold: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 3), // 原本的間距保留
                // ==================== 2. 主內容 (左右兩半) ====================
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ---------------- 左半部 (嚴格鎖死 143mm) ----------------
                    pw.Container(
                      width: leftW * PdfPageFormat.mm,
                      child: pw.Column(
                        children: [
                          // --- 派遣資料 ---
                          // 1. 第一列：派遣資料、出勤日期、西元年月日
                          pw.Table(
                            border: tbFull,
                            columnWidths: {
                              0: pw.FixedColumnWidth(
                                74.45 * PdfPageFormat.mm,
                              ), // 派遣資料 (來自398px比例)
                              1: pw.FixedColumnWidth(
                                22.09 * PdfPageFormat.mm,
                              ), // 出勤日期 (來自118px比例)
                              2: pw.FixedColumnWidth(
                                46.46 * PdfPageFormat.mm,
                              ), // 西元年月日 (來自248px比例，微調0.04mm補足總和)
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('派遣資料', bg: PdfColors.grey200),
                                  _lbl('出勤日期', bold: true),
                                  _cell(
                                    pw.Text(
                                      '西元 ${d.dispatchDateYear} 年 ${d.dispatchDateMonth} 月 ${d.dispatchDateDay} 日',
                                      style: ts(),
                                    ),
                                    align: pw.Alignment.center,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 2. 第二列：時間 (第一格對齊 22.1，後面6格均分剩下的 120.9)
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(22.1 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(20.15 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(20.15 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(20.15 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(20.15 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(20.15 * PdfPageFormat.mm),
                              6: pw.FixedColumnWidth(20.15 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('時間'),
                                  _lbl(
                                    '出勤\n${d.departureHour}:${d.departureMin}',
                                    bold: false,
                                  ),
                                  _lbl(
                                    '到達現場\n${d.arrivalHour}:${d.arrivalMin}',
                                    bold: false,
                                  ),
                                  _lbl(
                                    '離開現場\n${d.leaveSceneHour}:${d.leaveSceneMin}',
                                    bold: false,
                                  ),
                                  _lbl(
                                    '送達醫院\n${d.deliveryHour}:${d.deliveryMin}',
                                    bold: false,
                                  ),
                                  _lbl(
                                    '離開醫院\n${d.leaveHospHour}:${d.leaveHospMin}',
                                    bold: false,
                                  ),
                                  _lbl(
                                    '返回待命\n${d.returnBaseHour}:${d.returnBaseMin}',
                                    bold: false,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 3. 第三列：發生地點、送往 (第一格對齊 22.1)
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(22.1 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(
                                46.4 * PdfPageFormat.mm,
                              ), // 這裡也對齊上面的 46.4
                              2: pw.FixedColumnWidth(15 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(59.5 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('發生地點'),
                                  _cell(
                                    pw.Text(d.incidentLocation, style: ts()),
                                  ),
                                  _lbl('送往'),
                                  _cell(
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(d.sendToHospital, style: ts()),
                                        pw.Row(
                                          children: [
                                            _chk('病情需要', d.sendReasonCondition),
                                            _chk(
                                              '病患要求',
                                              d.sendReasonPatientRequest,
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

                          // 病患資料
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(leftW * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl(
                                    '病患資料',
                                    bg: PdfColors.grey200,
                                    align: pw.Alignment.centerLeft,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(35 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(10 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(49 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('姓名'),
                                  _cell(pw.Text(d.patientName, style: ts())),
                                  _lbl('性別'),
                                  _cell(
                                    pw.Row(
                                      children: [
                                        _chk('男', d.gender == '男'),
                                        _chk('女', d.gender == '女'),
                                      ],
                                    ),
                                  ),
                                  _lbl('財物'),
                                  _cell(
                                    pw.Row(
                                      children: [
                                        _chk('無', d.propertyNone),
                                        _chk('有', d.propertyHas),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _lbl('身分證'),
                                  _cell(pw.Text(d.idOrPassport, style: ts())),
                                  _lbl('年齡'),
                                  _cell(pw.Text(d.age, style: ts())),
                                  _lbl('保管人'),
                                  _cell(pw.Text(d.guardian, style: ts())),
                                ],
                              ),
                            ],
                          ),
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(131 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('住址'),
                                  _cell(pw.Text(d.address, style: ts())),
                                ],
                              ),
                            ],
                          ),

                          // 現場狀況
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
                                    bg: PdfColors.grey200,
                                    align: pw.Alignment.centerLeft,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(71.5 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(71.5 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('□ 非創傷', align: pw.Alignment.centerLeft),
                                  _lbl('□ 創傷', align: pw.Alignment.centerLeft),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  // 左半非創傷
                                  _cell(
                                    pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Container(
                                          width: 35 * PdfPageFormat.mm,
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              _chk('【急症】', false, bold: true),
                                              _chk(
                                                '呼吸問題(喘)',
                                                d.ntiBreathIssue,
                                                indent: 3,
                                              ),
                                              _chk(
                                                '呼吸道(異物)',
                                                d.ntiAirwayIssue,
                                                indent: 3,
                                              ),
                                              _chk(
                                                '昏迷(不清)',
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
                                              _chk('【一般疾病】', false, bold: true),
                                              _chk(
                                                '頭痛/頭暈',
                                                d.ntiHeadache,
                                                indent: 3,
                                              ),
                                              _chk(
                                                '昏厥/昏倒',
                                                d.ntiFaint,
                                                indent: 3,
                                              ),
                                              _chk('發燒', d.ntiFever, indent: 3),
                                              _chk(
                                                '噁心/嘔吐',
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
                                        pw.Container(
                                          width: 33 * PdfPageFormat.mm,
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              _chk('疑似毒藥物中毒', d.ntiDrug),
                                              _chk('疑似CO中毒', d.ntiCO),
                                              _chk('癲癇/抽搐', d.ntiSeizure),
                                              _chk('路倒', d.ntiFall),
                                              _chk('精神異常', d.ntiMental),
                                              _chk('孕婦急產', d.ntiPregnancy),
                                              _chk('到院前心停', d.ntiCardiacArrest),
                                              _chk('其他', d.ntiOtherNT),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 右半創傷
                                  _cell(
                                    pw.Column(
                                      children: [
                                        pw.Row(
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
                                                    '【一般外傷】',
                                                    false,
                                                    bold: true,
                                                  ),
                                                  pw.Padding(
                                                    padding: pw.EdgeInsets.only(
                                                      left: 3,
                                                    ),
                                                    child: pw.Wrap(
                                                      children:
                                                          [
                                                                '頭',
                                                                '頸',
                                                                '胸',
                                                                '腹',
                                                                '背',
                                                                '肢',
                                                                '其他',
                                                              ]
                                                              .map(
                                                                (e) => _chk(
                                                                  e,
                                                                  false,
                                                                  sz: 5,
                                                                ),
                                                              )
                                                              .toList(),
                                                    ),
                                                  ),
                                                  pw.SizedBox(height: 2),
                                                  _chk(
                                                    '【受傷機轉】',
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
                                            pw.Container(
                                              width: 33 * PdfPageFormat.mm,
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  _chk('溺水', d.trDrown),
                                                  _chk('摔跌傷', d.trFall),
                                                  _chk('墜落(約公尺)', false),
                                                  _chk('穿刺傷', d.trPenetrate),
                                                  _chk('燒燙傷', d.trBurn),
                                                  _chk('電擊傷', d.trElectric),
                                                  _chk('生物螫咬', d.trBioStrike),
                                                  _chk('到院前心停', false),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        pw.Container(
                                          width: double.infinity,
                                          margin: const pw.EdgeInsets.only(
                                            top: 2,
                                          ),
                                          padding: const pw.EdgeInsets.all(1),
                                          color: PdfColors.grey200,
                                          child: pw.Text(
                                            '過敏史',
                                            style: ts(bold: true),
                                            textAlign: pw.TextAlign.center,
                                          ),
                                        ),
                                        pw.Wrap(
                                          spacing: 2,
                                          children: [
                                            _chk('無', d.allergyNone),
                                            _chk('不詳', d.allergyUnknown),
                                            _chk('食物:', false),
                                            _chk('藥物:', false),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 主訴與病史
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
                                  _lbl('病患\n主訴'),
                                  _cell(
                                    pw.Text(d.chiefComplaint, style: ts(sz: 6)),
                                  ),
                                  _lbl('過去\n病史'),
                                  _cell(
                                    pw.Wrap(
                                      children: [
                                        _chk('無', d.histNone),
                                        _chk('不詳', d.histUnknown),
                                        _chk('高血壓', d.histHypertension),
                                        _chk('糖尿病', d.histDiabetes),
                                        _chk('心臟病', d.histHeart),
                                        _chk('腦中風', d.histStroke),
                                        _chk('氣喘', d.histAsthma),
                                      ],
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
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text(
                                              '費用：救護車 ${d.ambulanceFee}',
                                              style: ts(bold: true),
                                            ),
                                            pw.Text(
                                              '總計: ${d.totalFee}',
                                              style: ts(bold: true),
                                            ),
                                          ],
                                        ),
                                        pw.SizedBox(height: 2),
                                        pw.Row(
                                          children: [
                                            pw.Text(
                                              '付款: ',
                                              style: ts(bold: true),
                                            ),
                                            _chk('已收', d.paidCash),
                                            _chk('代收', d.paidHospital),
                                            _chk('未收', d.unpaid),
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

                    pw.SizedBox(width: 1 * PdfPageFormat.mm), // 中間安全間隙
                    // ---------------- 右半部 (嚴格鎖死 143mm) ----------------
                    pw.Container(
                      width: rightW * PdfPageFormat.mm,
                      child: pw.Column(
                        children: [
                          // 處置項目
                          pw.Table(
                            border: tbFull,
                            columnWidths: {
                              0: pw.FixedColumnWidth(rightW * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('處置項目（此欄可複選）', bg: PdfColors.grey200),
                                ],
                              ),
                            ],
                          ),
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(6 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(45 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(46 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(46 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Center(
                                      child: pw.Transform.rotateBox(
                                        angle: -math.pi / 2,
                                        child: pw.Text(
                                          '急救處置',
                                          style: ts(bold: true),
                                        ),
                                      ),
                                    ),
                                    bg: PdfColors.grey200,
                                  ),
                                  _cell(
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        _chk('【呼吸道】', false, bold: true),
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
                                        _chk('抽吸', d.airSuction, indent: 2),
                                        _chk('哈姆立克法', d.airHeimlick, indent: 2),
                                        _chk('鼻管O2', d.airNasalO2, indent: 2),
                                        _chk('面罩O2', d.airMaskO2, indent: 2),
                                        _chk('BVM(正壓)', d.airBVM, indent: 2),
                                        _chk(
                                          '氣管內管',
                                          d.airEndotracheal,
                                          indent: 2,
                                        ),
                                        pw.SizedBox(height: 3),
                                        _chk('【創傷處置】', false, bold: true),
                                        _chk('頸圈', d.trCollar, indent: 2),
                                        _chk('清洗傷口', d.trCleanWound, indent: 2),
                                        _chk('止血包紮', d.trHemostasis, indent: 2),
                                        _chk('骨折固定', d.trImmobilize, indent: 2),
                                        _chk('長背板', d.trBackboard, indent: 2),
                                        pw.SizedBox(height: 3),
                                        _chk('【搬運】', false, bold: true),
                                        _chk('擔架搬運', true, indent: 2),
                                      ],
                                    ),
                                  ),
                                  _cell(
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        _chk('【心肺復甦】', false, bold: true),
                                        _chk('自動CPR機', d.cprAuto, indent: 2),
                                        _chk('AED', d.cprAED, indent: 2),
                                        _chk(
                                          '電擊去顫',
                                          d.cprElectricShock,
                                          indent: 2,
                                        ),
                                        pw.SizedBox(height: 3),
                                        _chk('【藥物處置】', false, bold: true),
                                        _chk('靜脈輸液', d.medIV, indent: 2),
                                        _chk('0.9% N/S', d.medNS, indent: 2),
                                        _chk('L/R', d.medLR, indent: 2),
                                        _chk('葡萄糖液', d.medGlucose, indent: 2),
                                        _chk(
                                          'Aspirin',
                                          d.medAspirin,
                                          indent: 2,
                                        ),
                                        _chk('NTG', d.medNTG, indent: 2),
                                        _chk('支氣管擴張劑', d.medBroncho, indent: 2),
                                        pw.SizedBox(height: 3),
                                        _chk('【其他】', false, bold: true),
                                        _chk('保暖', d.otherKeepWarm, indent: 2),
                                        _chk('心理支持', d.otherPsych, indent: 2),
                                        _chk(
                                          '生命徵象監測',
                                          d.otherVitalMonitor,
                                          indent: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  _cell(
                                    pw.Column(
                                      children: [
                                        pw.Container(
                                          height: 48 * PdfPageFormat.mm,
                                          child: pw.Center(
                                            child: pw.Text(
                                              '人體圖\n(前/後)',
                                              style: ts(sz: 8),
                                            ),
                                          ),
                                        ),
                                        pw.Divider(
                                          height: 0.5,
                                          thickness: 0.5,
                                          color: PdfColors.black,
                                        ),
                                        pw.Container(
                                          height: 20 * PdfPageFormat.mm,
                                          alignment: pw.Alignment.topLeft,
                                          child: pw.Text(
                                            '備註：${d.notes}',
                                            style: ts(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    align: pw.Alignment.topCenter,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 給藥紀錄
                          pw.Table(
                            border: tbInner,
                            columnWidths: {
                              0: pw.FixedColumnWidth(6 * PdfPageFormat.mm),
                              1: pw.FixedColumnWidth(12 * PdfPageFormat.mm),
                              2: pw.FixedColumnWidth(20 * PdfPageFormat.mm),
                              3: pw.FixedColumnWidth(25 * PdfPageFormat.mm),
                              4: pw.FixedColumnWidth(15 * PdfPageFormat.mm),
                              5: pw.FixedColumnWidth(35 * PdfPageFormat.mm),
                              6: pw.FixedColumnWidth(30 * PdfPageFormat.mm),
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _lbl('給藥\n紀錄', bg: PdfColors.grey200),
                                  _lbl('時間', bg: PdfColors.grey200),
                                  _lbl('藥名', bg: PdfColors.grey200),
                                  _lbl('途徑/劑量', bg: PdfColors.grey200),
                                  _lbl('執行者', bg: PdfColors.grey200),
                                  _lbl('ALS處置', bg: PdfColors.grey200),
                                  _lbl('線上指導醫師', bg: PdfColors.grey200),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _cell(
                                    pw.Center(
                                      child: pw.Transform.rotateBox(
                                        angle: -math.pi / 2,
                                        child: pw.Text(
                                          '給藥紀錄',
                                          style: ts(bold: true),
                                        ),
                                      ),
                                    ),
                                    bg: PdfColors.grey200,
                                  ),
                                  _cell(
                                    pw.Column(
                                      children: List.generate(
                                        4,
                                        (i) => pw.Container(
                                          height: 7 * PdfPageFormat.mm,
                                          child: pw.Text(
                                            d.medTime[i],
                                            style: ts(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Column(
                                      children: List.generate(
                                        4,
                                        (i) => pw.Container(
                                          height: 7 * PdfPageFormat.mm,
                                          child: pw.Text(
                                            d.medName[i],
                                            style: ts(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Column(
                                      children: List.generate(
                                        4,
                                        (i) => pw.Container(
                                          height: 7 * PdfPageFormat.mm,
                                          child: pw.Text(
                                            d.medRoute[i],
                                            style: ts(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Column(
                                      children: List.generate(
                                        4,
                                        (i) => pw.Container(
                                          height: 7 * PdfPageFormat.mm,
                                          child: pw.Text(
                                            d.medExecutor[i],
                                            style: ts(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _cell(
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        _chk('氣管內管: ${d.etTube}', false),
                                        pw.SizedBox(height: 5),
                                        _chk(
                                          '手動電擊: ${d.manualShockTimes}次',
                                          false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  _cell(
                                    pw.Text(d.onlinePhysicianNote, style: ts()),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 生命徵象
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
                                  _lbl('生命\n徵象', bg: PdfColors.grey200),
                                  _lbl('時間', bg: PdfColors.grey200),
                                  _lbl('意識', bg: PdfColors.grey200),
                                  _lbl('體溫', bg: PdfColors.grey200),
                                  _lbl('脈搏', bg: PdfColors.grey200),
                                  _lbl('呼吸', bg: PdfColors.grey200),
                                  _lbl('血壓', bg: PdfColors.grey200),
                                  _lbl('SpO2', bg: PdfColors.grey200),
                                  _lbl('GCS', bg: PdfColors.grey200),
                                ],
                              ),
                              ...List.generate(
                                3,
                                (i) => pw.TableRow(
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
                                        bg: PdfColors.grey200,
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
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ==================== 3. 底部簽名 (橫跨全頁 287mm) ====================
                // 把原本擠在左右的簽名欄獨立出來，拉成全螢幕寬度！
                pw.SizedBox(height: 2),
                pw.Table(
                  border: tbFull,
                  columnWidths: {
                    0: pw.FixedColumnWidth(8 * PdfPageFormat.mm),
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
                          bg: PdfColors.grey200,
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
                            ],
                          ),
                        ),
                        _cell(
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('病患/家屬/關係人簽名', style: ts(bold: true)),
                              pw.SizedBox(height: 10),
                              pw.Text(
                                '簽名： ${d.patientFamilySign}   連絡電話： ${d.refuseContactPhone}',
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
