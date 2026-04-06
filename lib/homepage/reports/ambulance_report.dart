import 'dart:typed_data';
import 'dart:math' as math;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AmbulanceReportData {
  // 車牌
  String licensePlate = '';

  // 派遣資料
  String dispatchDateYear = '', dispatchDateMonth = '', dispatchDateDay = '';
  String departureHour = '', departureMin = '';
  String arrivalHour = '', arrivalMin = '';
  String leaveSceneHour = '', leaveSceneMin = '';
  String deliveryHour = '', deliveryMin = '';
  String leaveHospHour = '', leaveHospMin = '';
  String returnBaseHour = '', returnBaseMin = '';

  // 發生地點 / 送往
  String incidentLocation = '';
  String sendToHospital = '';
  bool sendReasonCondition = false;
  bool sendReasonPatientRequest = false;

  // 病患資料
  String patientName = '';
  String gender = ''; // 男/女
  String idOrPassport = '';
  String age = '';
  String guardian = '';
  String address = '';
  String propertyNote = ''; // 病患財物明細
  bool propertyNone = false;
  bool propertyHas = false;

  // 現場狀況 - 非創傷
  bool ntiEmergency = false,
      ntiBreathIssue = false,
      ntiAirwayIssue = false,
      ntiChestPain = false,
      ntiAbdomen = false,
      ntiGeneral = false,
      ntiHeadache = false,
      ntiFaint = false,
      ntiFever = false,
      ntiNausea = false,
      ntiWeakness = false,
      ntiDrug = false,
      ntiCO = false,
      ntiSeizure = false,
      ntiMental = false,
      ntiFall = false,
      ntiPregnancy = false,
      ntiCardiacArrest = false,
      ntiOtherNT = false;
  String ntiOtherNTText = '';

  // 現場狀況 - 創傷
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
      trBurn = false,
      trElectric = false,
      trBioStrike = false,
      trCardiacArrest = false,
      trOtherT2 = false;
  String trBurnDegree = '', trFallHeight = '';
  bool trMVC = false, trTrafficAcc = false, trNonTrafficAcc = false;
  bool trInjuredTransfer = false;
  String trOtherTText = '', trOtherT2Text = '';

  // 過敏史
  bool allergyNone = false, allergyUnknown = false;
  String allergyFood = '', allergyMeds = '', allergyOther = '';

  // 過去病史
  bool histNone = false, histUnknown = false;
  bool histHypertension = false,
      histDiabetes = false,
      histHeart = false,
      histStroke = false,
      histKidney = false,
      histLung = false,
      histAsthma = false;
  String histOther = '';

  // 病患主訴
  bool chiefByFamily = false;
  String chiefComplaint = '';

  // 處置項目 - 呼吸道
  bool airOralAirway = false,
      airNasalAirway = false,
      airSuction = false,
      airHeimlick = false,
      airNasalO2 = false,
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

  // 處置項目 - 心肺復甦術
  bool cprAED = false,
      cprAuto = false,
      cprCPR = false,
      cprElectricShock = false,
      cprNoElectric = false,
      cprHandShock = false;
  String cprAEDMin = '', cprShockTimes = '';

  // 處置項目 - 創傷處置
  bool trWound = false,
      trCleanWound = false,
      trHemostasis = false,
      trImmobilize = false,
      trSplint = false,
      trBackboard = false,
      trCollar = false;

  // 處置項目 - 其他處置
  bool otherKeepWarm = false,
      otherPsych = false,
      otherBandage = false,
      otherO2Refuse = false,
      otherVitalMonitor = false,
      otherOther = false;
  String otherOtherText = '';

  // 藥物處置
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

  // 給藥紀錄 (最多4筆)
  List<String> medTime = List.filled(4, '');
  List<String> medName = List.filled(4, '');
  List<String> medRoute = List.filled(4, '');
  List<String> medExecutor = List.filled(4, '');
  String aslInfo = '';
  String onlinePhysicianNote = '';
  String etTube = '', etTubeFixed = '';
  String manualShockTimes = '', manualShockJoule = '';

  // 生命徵象 (最多4筆)
  List<String> vsTime = List.filled(4, '');
  List<String> vsConsciousness = List.filled(4, '');
  List<bool> vsConsAlert = List.filled(4, false);
  List<bool> vsConsPain = List.filled(4, false);
  List<String> vsTemp = List.filled(4, '');
  List<String> vsPulse = List.filled(4, '');
  List<String> vsBreathing = List.filled(4, '');
  List<String> vsBPSys = List.filled(4, '');
  List<String> vsBPDia = List.filled(4, '');
  List<String> vsSpO2 = List.filled(4, '');
  List<String> vsGcsE = List.filled(4, '');
  List<String> vsGcsV = List.filled(4, '');
  List<String> vsGcsM = List.filled(4, '');

  // 到院後檢站
  bool postAlert = false, postPain = false, postArrested = false;

  // 簽名
  String emt1 = '', emt2 = '', emt3 = '';
  String receiveUnit = '';
  String refuseTransferSign = '';
  String patientFamilySign = '';
  String refuseContactPhone = '';
  String signTimeHour = '', signTimeMin = '';

  // 費用
  String ambulanceFee = '', o2Fee = '', totalFee = '';
  bool paidCash = false, paidCard = false, paidHospital = false, unpaid = false;
  String unpaidNote = '';

  // 備註
  String notes = '';
}

Future<Uint8List> buildAmbulanceReportPdf(AmbulanceReportData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  final borderSide = pw.BorderSide(width: 0.5, color: PdfColors.black);

  // 統一字體樣式
  pw.TextStyle ts({double sz = 6.5, bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz);

  // --- 核心儲存格方法 ---
  pw.Widget buildCell(
    pw.Widget child, {
    required double width,
    double minHeight = 8.0,
    pw.Alignment? align,
    bool isFirstColumn = false,
    bool isFirstRow = false,
    PdfColor? bg,
  }) {
    return pw.Container(
      width: width * PdfPageFormat.mm,
      constraints: pw.BoxConstraints(minHeight: minHeight * PdfPageFormat.mm),
      decoration: pw.BoxDecoration(
        color: bg,
        border: pw.Border(
          top: isFirstRow ? borderSide : pw.BorderSide.none,
          left: isFirstColumn ? borderSide : pw.BorderSide.none,
          right: borderSide,
          bottom: borderSide,
        ),
      ),
      padding: const pw.EdgeInsets.all(2),
      alignment: align ?? pw.Alignment.centerLeft,
      child: child,
    );
  }

  pw.Widget buildLabel(
    String t, {
    required double width,
    double minHeight = 8.0,
    bool isFirstColumn = false,
    bool isFirstRow = false,
    PdfColor? bg,
  }) => buildCell(
    pw.Text(t, style: ts(bold: true), textAlign: pw.TextAlign.center),
    width: width,
    minHeight: minHeight,
    align: pw.Alignment.center,
    isFirstColumn: isFirstColumn,
    isFirstRow: isFirstRow,
    bg: bg,
  );

  // --- 修正後的勾選框函式：補上 bold 參數 ---
  pw.Widget buildCheckBox(
    String label,
    bool checked, {
    double sz = 5.8,
    double indent = 0,
    bool bold = false,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent * PdfPageFormat.mm),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: 5.5,
            height: 5.5,
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.45)),
            child: checked
                ? pw.Center(
                    child: pw.Text(
                      'v',
                      style: pw.TextStyle(font: font, fontSize: 4.5),
                    ),
                  )
                : null,
          ),
          pw.SizedBox(width: 1.5),
          pw.Text(
            label,
            style: ts(sz: sz, bold: bold),
          ),
          pw.SizedBox(width: 1),
        ],
      ),
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) {
        return pw.Transform.rotateBox(
          angle: -math.pi / 2,
          child: pw.Container(
            width: PdfPageFormat.a4.height, // 297mm (橫向寬度)
            height: PdfPageFormat.a4.width, // 210mm (橫向高度)
            padding: const pw.EdgeInsets.all(8 * PdfPageFormat.mm),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // 標題與車牌
                pw.Container(
                  width: 280 * PdfPageFormat.mm,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        '聯新國際醫院桃園國際機場醫療中心救護紀錄表',
                        style: ts(sz: 11, bold: true),
                      ),
                      pw.Text(
                        '車牌：${d.licensePlate}',
                        style: ts(sz: 9, bold: true),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 5),

                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ================== 左半部 (140mm) ==================
                    pw.Column(
                      children: [
                        // Row 1-4: 派遣、時間、地點
                        pw.Row(
                          children: [
                            buildLabel(
                              '派遣資料',
                              width: 20,
                              isFirstColumn: true,
                              isFirstRow: true,
                              bg: PdfColors.grey200,
                            ),
                            buildCell(
                              pw.Text(
                                '日期: 西元 ${d.dispatchDateYear} 年 ${d.dispatchDateMonth} 月 ${d.dispatchDateDay} 日',
                                style: ts(),
                              ),
                              width: 120,
                              isFirstRow: true,
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            buildLabel(
                              '時間',
                              width: 20,
                              minHeight: 12,
                              isFirstColumn: true,
                            ),
                            ...['出勤', '現場', '離開', '送達', '醫院', '待命']
                                .map(
                                  (lab) => pw.Container(
                                    width: 20 * PdfPageFormat.mm,
                                    height: 12 * PdfPageFormat.mm,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border(
                                        right: borderSide,
                                        bottom: borderSide,
                                      ),
                                    ),
                                    child: pw.Column(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Center(
                                            child: pw.Text(
                                              lab,
                                              style: ts(sz: 5.5),
                                            ),
                                          ),
                                        ),
                                        pw.Divider(
                                          height: 0,
                                          thickness: 0.4,
                                          color: PdfColors.black,
                                        ),
                                        pw.Expanded(
                                          child: pw.Center(
                                            child: pw.Text(
                                              ' 時 分',
                                              style: ts(sz: 5.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                        pw.Row(
                          children: [
                            buildLabel(
                              '發生地點',
                              width: 20,
                              minHeight: 9,
                              isFirstColumn: true,
                            ),
                            buildCell(
                              pw.Text(d.incidentLocation, style: ts()),
                              width: 45,
                              minHeight: 9,
                            ),
                            buildLabel('送往', width: 15, minHeight: 9),
                            buildCell(
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(d.sendToHospital, style: ts()),
                                  pw.Row(
                                    children: [
                                      buildCheckBox(
                                        '病需',
                                        d.sendReasonCondition,
                                      ),
                                      buildCheckBox(
                                        '家屬',
                                        d.sendReasonPatientRequest,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              width: 60,
                              minHeight: 9,
                            ),
                          ],
                        ),

                        // Row 5-8: 病患資料
                        buildLabel(
                          '病患資料',
                          width: 140,
                          minHeight: 6,
                          isFirstColumn: true,
                          bg: PdfColors.grey200,
                        ),
                        pw.Row(
                          children: [
                            buildLabel('姓名', width: 12, isFirstColumn: true),
                            buildCell(
                              pw.Text(d.patientName, style: ts()),
                              width: 38,
                            ),
                            buildLabel('性別', width: 10),
                            buildCell(
                              pw.Row(
                                children: [
                                  buildCheckBox('男', d.gender == '男'),
                                  buildCheckBox('女', d.gender == '女'),
                                ],
                              ),
                              width: 25,
                            ),
                            buildLabel('財物', width: 12),
                            buildCell(
                              pw.Row(
                                children: [
                                  buildCheckBox('無', d.propertyNone),
                                  buildCheckBox('有', d.propertyHas),
                                ],
                              ),
                              width: 43,
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            buildLabel('ID/護照', width: 20, isFirstColumn: true),
                            buildCell(
                              pw.Text(d.idOrPassport, style: ts()),
                              width: 50,
                            ),
                            buildLabel('年齡', width: 12),
                            buildCell(pw.Text(d.age, style: ts()), width: 15),
                            buildLabel('簽章', width: 12),
                            buildCell(pw.SizedBox(), width: 31),
                          ],
                        ),
                        pw.Row(
                          children: [
                            buildLabel('住址', width: 12, isFirstColumn: true),
                            buildCell(
                              pw.Text(d.address, style: ts()),
                              width: 128,
                            ),
                          ],
                        ),

                        // Row 9: 現場狀況標題
                        buildLabel(
                          '現場狀況 (此欄可複選)',
                          width: 140,
                          minHeight: 6,
                          isFirstColumn: true,
                          bg: PdfColors.grey200,
                        ),

                        // Row 11: 非創傷/創傷 子標題列
                        pw.Row(
                          children: [
                            buildLabel(
                              '□ 非創傷',
                              width: 70,
                              minHeight: 6,
                              isFirstColumn: true,
                            ),
                            buildLabel('□ 創傷', width: 70, minHeight: 6),
                          ],
                        ),

                        // Row 12: 大型勾選內容區 (已修正參數傳遞)
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Column 1: 非創傷細項
                            buildCell(
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    width: 38 * PdfPageFormat.mm,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        buildCheckBox(
                                          '【急症】',
                                          false,
                                          sz: 6,
                                          bold: true,
                                        ), // 修正：現在支援 bold
                                        buildCheckBox(
                                          '呼吸問題(喘/速)',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox(
                                          '呼吸道(異物)',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox(
                                          '昏迷(不清)',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox(
                                          '胸痛/胸悶',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox('腹痛', false, indent: 3),
                                        pw.SizedBox(height: 2),
                                        buildCheckBox(
                                          '【一般疾病】',
                                          false,
                                          sz: 6,
                                          bold: true,
                                        ),
                                        buildCheckBox(
                                          '頭痛/頭暈',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox(
                                          '昏倒/昏厥',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox('發燒', false, indent: 3),
                                        buildCheckBox(
                                          '噁心/嘔吐/腹瀉',
                                          false,
                                          indent: 3,
                                        ),
                                        buildCheckBox('肢體無力', false, indent: 3),
                                      ],
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        buildCheckBox('疑似毒藥物中毒', false),
                                        buildCheckBox('疑似CO中毒', false),
                                        buildCheckBox('癫痫/抽搐', false),
                                        buildCheckBox('路倒', false),
                                        buildCheckBox('精神異常', false),
                                        buildCheckBox('孕婦急產', false),
                                        buildCheckBox('到院前心肺停止', false),
                                        buildCheckBox('其他', false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              width: 70,
                              minHeight: 62,
                              isFirstColumn: true,
                            ),

                            // Column 2: 創傷 + 過敏史
                            pw.Container(
                              width: 70 * PdfPageFormat.mm,
                              decoration: pw.BoxDecoration(
                                border: pw.Border(
                                  right: borderSide,
                                  bottom: borderSide,
                                ),
                              ),
                              child: pw.Column(
                                children: [
                                  pw.Container(
                                    height: 42 * PdfPageFormat.mm,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border(bottom: borderSide),
                                    ),
                                    padding: const pw.EdgeInsets.all(2),
                                    child: pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Container(
                                          width: 33 * PdfPageFormat.mm,
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              buildCheckBox(
                                                '【一般外傷】',
                                                false,
                                                sz: 6,
                                                bold: true,
                                              ),
                                              pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                      left:
                                                          3 * PdfPageFormat.mm,
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
                                                            '其它',
                                                          ]
                                                          .map(
                                                            (e) =>
                                                                buildCheckBox(
                                                                  e,
                                                                  false,
                                                                  sz: 5,
                                                                ),
                                                          )
                                                          .toList(),
                                                ),
                                              ),
                                              pw.SizedBox(height: 3),
                                              buildCheckBox(
                                                '【受傷機轉】',
                                                false,
                                                sz: 6,
                                                bold: true,
                                              ),
                                              buildCheckBox(
                                                '因交通事故',
                                                false,
                                                indent: 3,
                                              ),
                                              buildCheckBox(
                                                '非交通事故',
                                                false,
                                                indent: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              buildCheckBox('溺水', false),
                                              buildCheckBox('摔跌傷', false),
                                              buildCheckBox('墜落(約 公尺)', false),
                                              buildCheckBox('穿刺傷', false),
                                              buildCheckBox('燒燙傷 度 %', false),
                                              buildCheckBox('電擊傷', false),
                                              buildCheckBox('生物螫咬', false),
                                              buildCheckBox('到院前停止', false),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 過敏史標題
                                  pw.Container(
                                    width: double.infinity,
                                    height: 6 * PdfPageFormat.mm,
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.grey200,
                                      border: pw.Border(bottom: borderSide),
                                    ),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      '過敏史',
                                      style: ts(bold: true),
                                    ),
                                  ),
                                  // 過敏史勾選
                                  pw.Container(
                                    width: double.infinity,
                                    height: 14 * PdfPageFormat.mm,
                                    padding: const pw.EdgeInsets.all(2),
                                    child: pw.Wrap(
                                      spacing: 3,
                                      children: [
                                        buildCheckBox('無', d.allergyNone),
                                        buildCheckBox('不詳', d.allergyUnknown),
                                        buildCheckBox('食物:', false),
                                        buildCheckBox('藥物:', false),
                                        buildCheckBox('其他:', false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Block 4: 主訴與病史
                        pw.Row(
                          children: [
                            buildLabel(
                              '病患\n主訴',
                              width: 12,
                              minHeight: 18,
                              isFirstColumn: true,
                            ),
                            buildCell(
                              pw.Text(d.chiefComplaint, style: ts(sz: 6)),
                              width: 63,
                              minHeight: 18,
                            ),
                            buildLabel('過去\n病史', width: 12, minHeight: 18),
                            buildCell(
                              pw.Wrap(
                                children: [
                                  buildCheckBox('無', d.histNone),
                                  buildCheckBox('不詳', d.histUnknown),
                                  buildCheckBox('血壓', d.histHypertension),
                                  buildCheckBox('糖尿', d.histDiabetes),
                                ],
                              ),
                              width: 53,
                              minHeight: 18,
                            ),
                          ],
                        ),

                        // Block 5: 費用結算
                        buildCell(
                          pw.Column(
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text(
                                    '費用：救護車 ${d.ambulanceFee}',
                                    style: ts(bold: true),
                                  ),
                                  pw.Spacer(),
                                  pw.Text(
                                    '總計: ${d.totalFee}',
                                    style: ts(bold: true, sz: 8),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 2),
                              pw.Row(
                                children: [
                                  pw.Text('付款: ', style: ts(bold: true)),
                                  buildCheckBox('已收費', false),
                                  buildCheckBox('代收', false),
                                  buildCheckBox('未收', false),
                                ],
                              ),
                            ],
                          ),
                          width: 140,
                          minHeight: 14,
                          isFirstColumn: true,
                        ),
                      ],
                    ),

                    pw.SizedBox(width: 4),

                    // ================== 右半部 (140mm) ==================
                    pw.Container(
                      width: 140 * PdfPageFormat.mm,
                      height: 168 * PdfPageFormat.mm,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // ================== Block 1：處置項目 ==================
                          buildLabel(
                            '處置項目（可複選）',
                            width: 140,
                            minHeight: 6,
                            bg: PdfColors.grey200,
                          ),

                          // Block 1 主要內容 Row
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // 垂直標題：急救處置
                              pw.Container(
                                width: 8 * PdfPageFormat.mm,
                                height: 78 * PdfPageFormat.mm,
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.grey200,
                                  border: pw.Border(
                                    left: borderSide,
                                    right: borderSide,
                                    bottom: borderSide,
                                  ),
                                ),
                                alignment: pw.Alignment.center,
                                child: pw.Transform.rotateBox(
                                  angle: -math.pi / 2,
                                  child: pw.Text('急救處置', style: ts(bold: true)),
                                ),
                              ),

                              // 左欄：呼吸道 + 創傷 + 搬運
                              buildCell(
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    buildCheckBox(
                                      '【呼吸道處置】',
                                      false,
                                      sz: 6,
                                      bold: true,
                                    ),
                                    buildCheckBox(
                                      '口咽呼吸道',
                                      d.airOralAirway,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '鼻咽呼吸道',
                                      d.airNasalAirway,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '抽吸',
                                      d.airSuction,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '哈姆立克法',
                                      d.airHeimlick,
                                      indent: 2,
                                    ),
                                    pw.Row(
                                      children: [
                                        buildCheckBox('鼻管', d.airNasalO2),
                                        pw.Text(
                                          ' ${d.airNasalLMin} L/MIN',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        buildCheckBox('面罩', d.airMaskO2),
                                        pw.Text(
                                          ' ${d.airMaskLMin} L/MIN',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    buildCheckBox(
                                      '非再呼吸型面罩',
                                      d.airNonRebreather,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      'BVM(正壓輔助呼吸)',
                                      d.airBVM,
                                      indent: 2,
                                    ),
                                    pw.Row(
                                      children: [
                                        buildCheckBox('LMA', d.airLMA),
                                        pw.Text(
                                          ' ${d.airLMANo} 號',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        buildCheckBox('Igel', d.airIgel),
                                        pw.Text(
                                          ' ${d.airIgelNo} 號',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        buildCheckBox(
                                          '氣管內管',
                                          d.airEndotracheal,
                                        ),
                                        pw.Text(
                                          ' ${d.airETNo} 號',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    buildCheckBox('其他', d.airOther, indent: 2),
                                    pw.SizedBox(height: 4),
                                    buildCheckBox(
                                      '【創傷處置】',
                                      false,
                                      sz: 6,
                                      bold: true,
                                    ),
                                    buildCheckBox('頸圈', d.trCollar, indent: 2),
                                    buildCheckBox(
                                      '清洗傷口',
                                      d.trCleanWound,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '止血、包紮',
                                      d.trHemostasis,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '骨折固定',
                                      d.trImmobilize,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '長背板固定',
                                      d.trBackboard,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '鏟式擔架固定',
                                      d.trSplint,
                                      indent: 2,
                                    ),
                                    buildCheckBox('其他', false, indent: 2),
                                    pw.SizedBox(height: 4),
                                    buildCheckBox(
                                      '【搬運】',
                                      false,
                                      sz: 6,
                                      bold: true,
                                    ),
                                    buildCheckBox('自行上車', false, indent: 2),
                                    buildCheckBox('以適當方式搬運', false, indent: 2),
                                  ],
                                ),
                                width: 44,
                                minHeight: 82,
                              ),

                              // 中欄：心肺復甦術 + 藥物 + 其他處置
                              buildCell(
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    buildCheckBox(
                                      '【心肺復甦術】',
                                      false,
                                      sz: 6,
                                      bold: true,
                                    ),
                                    buildCheckBox(
                                      '自動心肺復甦機',
                                      d.cprAuto,
                                      indent: 2,
                                    ),
                                    pw.Row(
                                      children: [
                                        buildCheckBox('CPR:', d.cprCPR),
                                        pw.Text(
                                          ' ${d.cprAEDMin} 分鐘',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        buildCheckBox('使用AED', d.cprAED),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(
                                            left: 3 * PdfPageFormat.mm,
                                          ),
                                          child: pw.Row(
                                            children: [
                                              buildCheckBox(
                                                '電擊去顫',
                                                d.cprElectricShock,
                                              ),
                                              pw.Text(
                                                ' ${d.cprShockTimes} 次',
                                                style: ts(sz: 5.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(
                                            left: 3 * PdfPageFormat.mm,
                                          ),
                                          child: buildCheckBox(
                                            '不建議電擊',
                                            d.cprNoElectric,
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildCheckBox(
                                      '手動電擊器',
                                      d.cprHandShock,
                                      indent: 2,
                                    ),
                                    pw.SizedBox(height: 4),
                                    buildCheckBox(
                                      '【藥物處置】',
                                      false,
                                      sz: 6,
                                      bold: true,
                                    ),
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Row(
                                          children: [
                                            buildCheckBox('靜脈輸液,部位', d.medIV),
                                            pw.Text(
                                              d.medIVPart,
                                              style: ts(sz: 5.5),
                                            ),
                                          ],
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(
                                            left: 3 * PdfPageFormat.mm,
                                          ),
                                          child: pw.Row(
                                            children: [
                                              buildCheckBox('0.9%N/S', d.medNS),
                                              pw.Text(
                                                ' ${d.medNSml} ml',
                                                style: ts(sz: 5.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(
                                            left: 3 * PdfPageFormat.mm,
                                          ),
                                          child: pw.Row(
                                            children: [
                                              buildCheckBox('L/R', d.medLR),
                                              pw.Text(
                                                ' ${d.medLRml} ml',
                                                style: ts(sz: 5.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.Padding(
                                          padding: pw.EdgeInsets.only(
                                            left: 3 * PdfPageFormat.mm,
                                          ),
                                          child: pw.Row(
                                            children: [
                                              buildCheckBox(
                                                '葡萄糖液',
                                                d.medGlucose,
                                              ),
                                              pw.Text(
                                                ' ${d.medGlucoseType} ml',
                                                style: ts(sz: 5.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        buildCheckBox('口服葡萄糖液/粉', false),
                                        buildCheckBox(
                                          '協助使用Aspirin',
                                          d.medAspirin,
                                        ),
                                        pw.Row(
                                          children: [
                                            buildCheckBox('協助使用NTG', d.medNTG),
                                            pw.Text(
                                              ' ${d.medNTGCount} 片',
                                              style: ts(sz: 5.5),
                                            ),
                                          ],
                                        ),
                                        pw.Row(
                                          children: [
                                            buildCheckBox(
                                              '協助使用支氣管擴張劑',
                                              d.medBroncho,
                                            ),
                                            pw.Text(
                                              ' ${d.medBronchoTimes} 次',
                                              style: ts(sz: 5.5),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    buildCheckBox(
                                      '【其他處置】',
                                      false,
                                      sz: 6,
                                      bold: true,
                                    ),
                                    buildCheckBox(
                                      '保暖',
                                      d.otherKeepWarm,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '心理支持',
                                      d.otherPsych,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '約束帶',
                                      d.otherBandage,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '拒絕使用氧氣',
                                      d.otherO2Refuse,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '生命徵象監測',
                                      d.otherVitalMonitor,
                                      indent: 2,
                                    ),
                                    buildCheckBox(
                                      '其他',
                                      d.otherOther,
                                      indent: 2,
                                    ),
                                  ],
                                ),
                                width: 44,
                                minHeight: 82,
                              ),

                              // 右欄：人形圖 + 備註
                              pw.Container(
                                width: 52 * PdfPageFormat.mm,
                                height: 82 * PdfPageFormat.mm,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    right: borderSide,
                                    bottom: borderSide,
                                  ),
                                ),
                                child: pw.Column(
                                  children: [
                                    // 人形圖區（留空）
                                    pw.Container(
                                      height: 48 * PdfPageFormat.mm,
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(bottom: borderSide),
                                      ),
                                      child: pw.Center(
                                        child: pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceEvenly,
                                          children: [
                                            pw.Text(
                                              '前',
                                              style: ts(sz: 6, bold: true),
                                            ),
                                            pw.Text(
                                              '後',
                                              style: ts(sz: 6, bold: true),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // 備註區
                                    pw.Expanded(
                                      child: pw.Row(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.stretch,
                                        children: [
                                          pw.Container(
                                            width: 10 * PdfPageFormat.mm,
                                            color: PdfColors.grey200,
                                            alignment: pw.Alignment.center,
                                            child: pw.Transform.rotateBox(
                                              angle: -math.pi / 2,
                                              child: pw.Text(
                                                '備　註',
                                                style: ts(bold: true, sz: 6.5),
                                              ),
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Container(
                                              padding: const pw.EdgeInsets.all(
                                                4,
                                              ),
                                              child: pw.Text(
                                                d.notes,
                                                style: ts(sz: 6),
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

                          // ====================== Block 2：給藥紀錄 ======================
                          pw.Row(
                            children: [
                              buildLabel(
                                '給藥\n紀錄',
                                width: 8,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '時間',
                                width: 12,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '藥名',
                                width: 22,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '途徑/劑量',
                                width: 26,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '執行者',
                                width: 14,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                'ASL 處置',
                                width: 28,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '線上指導醫師',
                                width: 30,
                                minHeight: 8,
                                bg: PdfColors.grey200,
                              ),
                            ],
                          ),

                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // 給藥標題垂直
                              pw.Container(
                                width: 8 * PdfPageFormat.mm,
                                height: 40 * PdfPageFormat.mm, // 固定高度
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.grey200,
                                  border: pw.Border(
                                    left: borderSide,
                                    right: borderSide,
                                    bottom: borderSide,
                                  ),
                                ),
                                alignment: pw.Alignment.center,
                                child: pw.Transform.rotateBox(
                                  angle: -math.pi / 2,
                                  child: pw.Text('給藥紀錄', style: ts(bold: true)),
                                ),
                              ),

                              // 給藥 4 行
                              pw.Column(
                                children: List.generate(
                                  4,
                                  (i) => pw.Row(
                                    children: [
                                      buildCell(
                                        pw.Text(d.medTime[i], style: ts(sz: 6)),
                                        width: 12,
                                        minHeight: 10.5,
                                      ),
                                      buildCell(
                                        pw.Text(d.medName[i], style: ts(sz: 6)),
                                        width: 22,
                                        minHeight: 10.5,
                                      ),
                                      buildCell(
                                        pw.Text(
                                          d.medRoute[i],
                                          style: ts(sz: 6),
                                        ),
                                        width: 26,
                                        minHeight: 10.5,
                                      ),
                                      buildCell(
                                        pw.Text(
                                          d.medExecutor[i],
                                          style: ts(sz: 6),
                                        ),
                                        width: 14,
                                        minHeight: 10.5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // ASL 處置
                              pw.Container(
                                width: 28 * PdfPageFormat.mm,
                                height: 42 * PdfPageFormat.mm,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    right: borderSide,
                                    bottom: borderSide,
                                  ),
                                ),
                                padding: const pw.EdgeInsets.all(3),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        buildCheckBox('氣管內管', false),
                                        pw.Text(
                                          ' ${d.etTube} 號 固定 ${d.etTubeFixed} 公分 cm',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 6),
                                    pw.Row(
                                      children: [
                                        buildCheckBox('手動電擊', false),
                                        pw.Text(
                                          ' ${d.manualShockTimes} 次 ${d.manualShockJoule} Joule',
                                          style: ts(sz: 5.5),
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 6),
                                    pw.Text(d.aslInfo, style: ts(sz: 5.5)),
                                  ],
                                ),
                              ),

                              // 線上指導醫師
                              pw.Container(
                                width: 30 * PdfPageFormat.mm,
                                height: 42 * PdfPageFormat.mm,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    right: borderSide,
                                    bottom: borderSide,
                                  ),
                                ),
                                padding: const pw.EdgeInsets.all(3),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      '指導說明：',
                                      style: ts(sz: 5.5, bold: true),
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(
                                        d.onlinePhysicianNote,
                                        style: ts(sz: 5.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // ====================== Block 3：生命徵象（壓縮版）======================
                          pw.Row(
                            children: [
                              buildLabel(
                                '生命\n徵象',
                                width: 8,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '時間',
                                width: 13,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '意識狀況',
                                width: 15,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '體溫℃',
                                width: 13,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '脈搏',
                                width: 13,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '呼吸',
                                width: 13,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                '血壓',
                                width: 19,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                'SpO2%',
                                width: 13,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                              buildLabel(
                                'GCS',
                                width: 24,
                                minHeight: 9,
                                bg: PdfColors.grey200,
                              ),
                            ],
                          ),

                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // 垂直標題
                              pw.Column(
                                children: [
                                  pw.Container(
                                    width: 8 * PdfPageFormat.mm,
                                    height: 28 * PdfPageFormat.mm, // 壓縮高度
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.grey200,
                                      border: pw.Border(
                                        left: borderSide,
                                        right: borderSide,
                                        bottom: borderSide,
                                      ),
                                    ),
                                    alignment: pw.Alignment.center,
                                    child: pw.Transform.rotateBox(
                                      angle: -math.pi / 2,
                                      child: pw.Text(
                                        '生命徵象',
                                        style: ts(bold: true, sz: 6.5),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 8 * PdfPageFormat.mm,
                                    height: 9 * PdfPageFormat.mm,
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.grey200,
                                      border: pw.Border(
                                        left: borderSide,
                                        right: borderSide,
                                        bottom: borderSide,
                                      ),
                                    ),
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                      '到院後\n檢傷站',
                                      style: ts(sz: 5, bold: true),
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),

                              // 資料區
                              pw.Column(
                                children: [
                                  // 3 行生命徵象
                                  ...List.generate(
                                    3,
                                    (i) => pw.Row(
                                      children: [
                                        buildCell(
                                          pw.Text(
                                            d.vsTime[i],
                                            style: ts(sz: 6),
                                          ),
                                          width: 13,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Column(
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Row(
                                                children: [
                                                  buildCheckBox(
                                                    '清',
                                                    d.vsConsAlert[i],
                                                    sz: 4.5,
                                                  ),
                                                  buildCheckBox(
                                                    '暈',
                                                    !d.vsConsAlert[i] &&
                                                        d.vsConsciousness[i] ==
                                                            '暈',
                                                    sz: 4.5,
                                                  ),
                                                ],
                                              ),
                                              pw.Row(
                                                children: [
                                                  buildCheckBox(
                                                    '痛',
                                                    d.vsConsPain[i],
                                                    sz: 4.5,
                                                  ),
                                                  buildCheckBox(
                                                    '否',
                                                    !d.vsConsPain[i] &&
                                                        d.vsConsciousness[i] ==
                                                            '否',
                                                    sz: 4.5,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          width: 15,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Text(
                                            d.vsTemp[i],
                                            style: ts(sz: 6),
                                          ),
                                          width: 13,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Text(
                                            d.vsPulse[i],
                                            style: ts(sz: 6),
                                          ),
                                          width: 13,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Text(
                                            d.vsBreathing[i],
                                            style: ts(sz: 6),
                                          ),
                                          width: 13,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Text(
                                            '${d.vsBPSys[i]}/${d.vsBPDia[i]}',
                                            style: ts(sz: 6),
                                          ),
                                          width: 19,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Text(
                                            d.vsSpO2[i],
                                            style: ts(sz: 6),
                                          ),
                                          width: 13,
                                          minHeight: 9,
                                        ),
                                        buildCell(
                                          pw.Text(
                                            'E${d.vsGcsE[i]} V${d.vsGcsV[i]} M${d.vsGcsM[i]}',
                                            style: ts(sz: 5.5),
                                          ),
                                          width: 24,
                                          minHeight: 9,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 到院後檢傷站
                                  pw.Row(
                                    children: [
                                      buildCell(
                                        pw.Text(d.vsTime[3], style: ts(sz: 6)),
                                        width: 13,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.Column(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Row(
                                              children: [
                                                buildCheckBox(
                                                  '清',
                                                  d.postAlert,
                                                  sz: 4.5,
                                                ),
                                                buildCheckBox(
                                                  '暈',
                                                  false,
                                                  sz: 4.5,
                                                ),
                                              ],
                                            ),
                                            pw.Row(
                                              children: [
                                                buildCheckBox(
                                                  '痛',
                                                  d.postPain,
                                                  sz: 4.5,
                                                ),
                                                buildCheckBox(
                                                  '否',
                                                  false,
                                                  sz: 4.5,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        width: 15,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.SizedBox(),
                                        width: 13,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.SizedBox(),
                                        width: 13,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.SizedBox(),
                                        width: 13,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.SizedBox(),
                                        width: 19,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.SizedBox(),
                                        width: 13,
                                        minHeight: 9,
                                      ),
                                      buildCell(
                                        pw.SizedBox(),
                                        width: 24,
                                        minHeight: 9,
                                      ),
                                    ],
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

                pw.Spacer(),

                // 底部說明
                pw.Container(
                  width: 280 * PdfPageFormat.mm,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('51-S-000-001', style: ts(sz: 5)),
                      pw.Text('聯新國際醫院救護紀錄表', style: ts(sz: 5)),
                    ],
                  ),
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
