import 'dart:typed_data';

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
  bool ntiEmergency = false, ntiBreathIssue = false, ntiAirwayIssue = false,
       ntiChestPain = false, ntiAbdomen = false,
       ntiGeneral = false, ntiHeadache = false, ntiFaint = false,
       ntiFever = false, ntiNausea = false, ntiWeakness = false,
       ntiDrug = false, ntiCO = false, ntiSeizure = false,
       ntiMental = false, ntiFall = false, ntiPregnancy = false,
       ntiCardiacArrest = false, ntiOtherNT = false;
  String ntiOtherNTText = '';

  // 現場狀況 - 創傷
  bool trGeneral = false, trHead = false, trChest = false, trAbdomen = false,
       trBack = false, trLimb = false, trOtherT = false;
  bool trDrown = false, trFall = false, trCrush = false, trFracture = false,
       trPenetrate = false, trBurn = false, trElectric = false,
       trBioStrike = false, trCardiacArrest = false, trOtherT2 = false;
  String trBurnDegree = '', trFallHeight = '';
  bool trMVC = false, trTrafficAcc = false, trNonTrafficAcc = false;
  bool trInjuredTransfer = false;
  String trOtherTText = '', trOtherT2Text = '';

  // 過敏史
  bool allergyNone = false, allergyUnknown = false;
  String allergyFood = '', allergyMeds = '', allergyOther = '';

  // 過去病史
  bool histNone = false, histUnknown = false;
  bool histHypertension = false, histDiabetes = false, histHeart = false,
       histStroke = false, histKidney = false, histLung = false,
       histAsthma = false;
  String histOther = '';

  // 病患主訴
  bool chiefByFamily = false;
  String chiefComplaint = '';

  // 處置項目 - 呼吸道
  bool airOralAirway = false, airNasalAirway = false, airSuction = false,
       airHeimlick = false, airNasalO2 = false, airMaskO2 = false,
       airNonRebreather = false, airBVM = false, airLMA = false,
       airIgel = false, airEndotracheal = false, airOther = false;
  String airNasalLMin = '', airMaskLMin = '', airLMANo = '',
         airIgelNo = '', airETNo = '', airOtherText = '';

  // 處置項目 - 心肺復甦術
  bool cprAED = false, cprAuto = false, cprCPR = false,
       cprElectricShock = false, cprNoElectric = false, cprHandShock = false;
  String cprAEDMin = '', cprShockTimes = '';

  // 處置項目 - 創傷處置
  bool trWound = false, trCleanWound = false, trHemostasis = false,
       trImmobilize = false, trSplint = false, trBackboard = false,
       trCollar = false;

  // 處置項目 - 其他處置
  bool otherKeepWarm = false, otherPsych = false, otherBandage = false,
       otherO2Refuse = false, otherVitalMonitor = false, otherOther = false;
  String otherOtherText = '';

  // 藥物處置
  bool medIV = false, medNS = false, medLR = false, medGlucose = false,
       medAspirin = false, medNTG = false, medBroncho = false;
  String medIVPart = '', medNSml = '', medLRml = '', medGlucoseType = '',
         medNTGCount = '', medBronchoTimes = '';

  // 給藥紀錄 (最多4筆)
  List<String> medTime    = List.filled(4, '');
  List<String> medName    = List.filled(4, '');
  List<String> medRoute   = List.filled(4, '');
  List<String> medExecutor= List.filled(4, '');
  String aslInfo = '';
  String onlinePhysicianNote = '';
  String etTube = '', etTubeFixed = '';
  String manualShockTimes = '', manualShockJoule = '';

  // 生命徵象 (最多4筆)
  List<String> vsTime       = List.filled(4, '');
  List<String> vsConsciousness = List.filled(4, '');
  List<bool>   vsConsAlert  = List.filled(4, false);
  List<bool>   vsConsPain   = List.filled(4, false);
  List<String> vsTemp       = List.filled(4, '');
  List<String> vsPulse      = List.filled(4, '');
  List<String> vsBreathing  = List.filled(4, '');
  List<String> vsBPSys      = List.filled(4, '');
  List<String> vsBPDia      = List.filled(4, '');
  List<String> vsSpO2       = List.filled(4, '');
  List<String> vsGcsE      = List.filled(4, '');
  List<String> vsGcsV      = List.filled(4, '');
  List<String> vsGcsM      = List.filled(4, '');

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
  final pdf   = pw.Document();
  final font  = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  pw.TextStyle ts({double sz = 7, bool bold = false, PdfColor? c}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: sz, color: c ?? PdfColors.black);

  const bdr  = pw.BorderSide(width: 0.5, color: PdfColors.black);
  const tbl  = pw.TableBorder(top: bdr, bottom: bdr, left: bdr, right: bdr,
                               horizontalInside: bdr, verticalInside: bdr);

  pw.Widget cell(String t, {bool bold = false, pw.Alignment? align,
      pw.EdgeInsets? pad, double sz = 7, double? h, PdfColor? bg}) =>
      pw.Container(
        height: h, color: bg,
        padding: pad ?? const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        alignment: align ?? pw.Alignment.centerLeft,
        child: pw.Text(t, style: ts(sz: sz, bold: bold)),
      );

  pw.Widget chkbox(bool checked) => pw.Container(
        width: 7, height: 7,
        margin: const pw.EdgeInsets.only(right: 1, top: 1),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
        child: checked ? pw.Container(color: PdfColors.black) : null,
      );

  pw.Widget ck(String label, bool checked) => pw.Row(children: [
        chkbox(checked),
        pw.Text(label, style: ts()),
        pw.SizedBox(width: 3),
      ]);

  pw.Widget uv(String val, {double w = 15}) => pw.Container(
        width: w * PdfPageFormat.mm,
        decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 0.4, color: PdfColors.grey600))),
        child: pw.Text(val, style: ts()),
      );
  pw.FixedColumnWidth colW(double value) => pw.FixedColumnWidth(value);
  pw.FlexColumnWidth flexW([double value = 1]) => pw.FlexColumnWidth(value);

  pdf.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.symmetric(
        horizontal: 9 * PdfPageFormat.mm, vertical: 8 * PdfPageFormat.mm),
    build: (ctx) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ── Title ────────────────────────────────────────────────────────
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('聯新國際醫院桃園國際機場醫療中心救護紀錄表',
                style: ts(sz: 12, bold: true)),
            pw.Row(children: [
              pw.Text('車牌號碼：', style: ts(sz: 8, bold: true)),
              uv(d.licensePlate, w: 20),
            ]),
          ],
        ),
        pw.SizedBox(height: 3),

        // ── 派遣資料 ─────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(22), 1: flexW(3),
          2: colW(18), 3: flexW(3),
        }, children: [
          pw.TableRow(children: [
            cell('派遣資料', bold: true, bg: PdfColors.grey200),
            pw.Container(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Row(children: [
                  pw.Text('出勤日期 西元 ', style: ts(bold: true)),
                  uv(d.dispatchDateYear, w: 12),
                  pw.Text(' 年 ', style: ts()),
                  uv(d.dispatchDateMonth, w: 8),
                  pw.Text(' 月 ', style: ts()),
                  uv(d.dispatchDateDay, w: 8),
                  pw.Text(' 日', style: ts()),
                ]),
                pw.SizedBox(height: 2),
                pw.Wrap(spacing: 6, children: [
                  _timeEntry('出勤', d.departureHour, d.departureMin, font, fontB),
                  _timeEntry('到達現場', d.arrivalHour, d.arrivalMin, font, fontB),
                  _timeEntry('離開現場', d.leaveSceneHour, d.leaveSceneMin, font, fontB),
                  _timeEntry('送達', d.deliveryHour, d.deliveryMin, font, fontB),
                  _timeEntry('離開', d.leaveHospHour, d.leaveHospMin, font, fontB),
                  _timeEntry('返回待命', d.returnBaseHour, d.returnBaseMin, font, fontB),
                ]),
              ]),
            ),
            cell('處置項目\n(此欄可複選)', bold: true, bg: PdfColors.grey200),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('呼吸道處置', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  ck('口咽呼吸道', d.airOralAirway),
                  ck('鼻咽呼吸道', d.airNasalAirway),
                  ck('抽吸', d.airSuction),
                  ck('哈姆立克法', d.airHeimlick),
                  pw.Row(children: [ck('鼻管', d.airNasalAirway), uv(d.airNasalLMin, w: 6), pw.Text('L/MIN', style: ts(sz: 6))]),
                  pw.Row(children: [ck('面罩', d.airMaskO2), uv(d.airMaskLMin, w: 6), pw.Text('L/MIN', style: ts(sz: 6))]),
                  ck('非再呼吸型面罩', d.airNonRebreather),
                  ck('BVM(正壓輔助呼吸)', d.airBVM),
                  pw.Row(children: [ck('LMA', d.airLMA), uv(d.airLMANo, w: 6), pw.Text('號', style: ts(sz: 6))]),
                  pw.Row(children: [ck('Igel', d.airIgel), uv(d.airIgelNo, w: 6), pw.Text('號', style: ts(sz: 6))]),
                  pw.Row(children: [ck('氣管內管', d.airEndotracheal), uv(d.airETNo, w: 6), pw.Text('號', style: ts(sz: 6))]),
                ]),
                pw.SizedBox(height: 2),
                pw.Text('心肺復甦術', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  ck('自動心肺復甦機', d.cprAuto),
                  pw.Row(children: [ck('CPR', d.cprCPR), uv(d.cprAEDMin, w: 8), pw.Text('分鐘', style: ts(sz: 6))]),
                  ck('使用AED', d.cprAED),
                  pw.Row(children: [ck('電擊去顫', d.cprElectricShock), uv(d.cprShockTimes, w: 6), pw.Text('次', style: ts(sz: 6))]),
                  ck('不建議電擊', d.cprNoElectric),
                  ck('手動電擊器', d.cprHandShock),
                ]),
                pw.SizedBox(height: 2),
                pw.Text('創傷處置', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  ck('頭頸固定', d.trFracture),
                  ck('清洗傷口', d.trCleanWound),
                  ck('止血、包紮', d.trHemostasis),
                  ck('長背板固定', d.trBackboard),
                  ck('鏟式擔架固定', d.trSplint),
                ]),
                pw.SizedBox(height: 2),
                pw.Text('藥物處置', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  pw.Row(children: [ck('靜脈輸液', d.medIV), pw.Text('部位', style: ts(sz: 6)), uv(d.medIVPart, w: 8)]),
                  pw.Row(children: [ck('0.9%N/S', d.medNS), uv(d.medNSml, w: 8), pw.Text('ml', style: ts(sz: 6))]),
                  pw.Row(children: [ck('L/R', d.medLR), uv(d.medLRml, w: 8), pw.Text('ml', style: ts(sz: 6))]),
                  ck('口服葡萄糖液/粉', d.medGlucose),
                  ck('協助使用Aspirin', d.medAspirin),
                  pw.Row(children: [ck('協助使用NTG', d.medNTG), uv(d.medNTGCount, w: 6), pw.Text('片', style: ts(sz: 6))]),
                  pw.Row(children: [ck('協助使用支氣管擴張劑', d.medBroncho), uv(d.medBronchoTimes, w: 6), pw.Text('次', style: ts(sz: 6))]),
                ]),
                pw.SizedBox(height: 2),
                pw.Text('其他處置', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  ck('保暖', d.otherKeepWarm),
                  ck('心理支持', d.otherPsych),
                  ck('約束帶', d.otherBandage),
                  ck('拒絕使用氧氣', d.otherO2Refuse),
                  ck('生命徵象監測', d.otherVitalMonitor),
                ]),
              ],
            )),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 發生地點 / 送往 ──────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(18), 1: flexW(2), 2: colW(22), 3: flexW(2),
        }, children: [
          pw.TableRow(children: [
            cell('發生地點', bold: true),
            cell(d.incidentLocation),
            cell('送往醫院或地點', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(d.sendToHospital, style: ts()),
                pw.Row(children: [
                  ck('病情需要', d.sendReasonCondition),
                  ck('病人或家屬要求', d.sendReasonPatientRequest),
                ]),
              ],
            )),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 病患資料 ─────────────────────────────────────────────────────
        pw.Text('病患資料', style: ts(sz: 8, bold: true)),
        pw.Table(border: tbl, columnWidths: {
          0: colW(14), 1: flexW(2), 2: colW(12), 3: colW(16),
          4: colW(28), 5: flexW(2),
        }, children: [
          pw.TableRow(children: [
            cell('姓名', bold: true),
            cell(d.patientName),
            cell('性別', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2),
              child: pw.Row(children: [ck('男性', d.gender == '男'), ck('女性', d.gender == '女')])),
            cell('病患財物明細：', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2),
              child: pw.Row(children: [ck('未經手', d.propertyNone), ck('有', d.propertyHas)])),
          ]),
          pw.TableRow(children: [
            cell('身份證/護照', bold: true),
            cell(d.idOrPassport),
            cell('年齡', bold: true),
            cell('${d.age} 歲'),
            cell('保管人', bold: true),
            cell(d.guardian),
          ]),
          pw.TableRow(children: [
            cell('住址', bold: true),
            cell(d.address),
            cell(''),
            cell(''),
            cell(''),
            cell(''),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 現場狀況 ─────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(14), 1: flexW(1), 2: colW(14), 3: flexW(1),
        }, children: [
          pw.TableRow(children: [
            cell('現場狀況\n(此欄可複選)', bold: true, bg: PdfColors.grey200),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('□非創傷', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  ck('急症', d.ntiEmergency), ck('呼吸問題', d.ntiBreathIssue),
                  ck('呼吸道問題', d.ntiAirwayIssue), ck('昏迷', d.ntiEmergency),
                  ck('胸痛/胸悶', d.ntiChestPain), ck('腹痛', d.ntiAbdomen),
                  ck('一般疾病', d.ntiGeneral), ck('頭痛/頭暈', d.ntiHeadache),
                  ck('昏倒', d.ntiFaint), ck('發燒', d.ntiFever),
                  ck('噁心/嘔吐', d.ntiNausea), ck('肢體無力', d.ntiWeakness),
                  ck('疑似藥物中毒', d.ntiDrug), ck('一氧化碳中毒', d.ntiCO),
                  ck('癲癇/抽搐', d.ntiSeizure), ck('精神異常', d.ntiMental),
                  ck('路倒', d.ntiFall), ck('孕婦急產', d.ntiPregnancy),
                  ck('到院前心肺功能停止', d.ntiCardiacArrest),
                ]),
              ],
            )),
            cell('', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('□創傷', style: ts(sz: 7, bold: true)),
                pw.Wrap(spacing: 2, runSpacing: 1, children: [
                  ck('一般外傷', d.trGeneral), ck('頭部外傷', d.trHead),
                  ck('胸部外傷', d.trChest), ck('腹部外傷', d.trAbdomen),
                  ck('背部外傷', d.trBack), ck('肢體外傷', d.trLimb),
                  ck('溺水', d.trDrown), ck('摔跌傷', d.trFall),
                  ck('壓榨傷', d.trCrush), ck('骨折固定', d.trFracture),
                  ck('穿刺傷', d.trPenetrate), ck('燒燙傷', d.trBurn),
                  ck('電擊傷', d.trElectric), ck('生物咬螫傷', d.trBioStrike),
                  ck('到院前心肺功能停止', d.trCardiacArrest),
                  ck('因交通事故', d.trTrafficAcc),
                  ck('非交通事故', d.trNonTrafficAcc),
                ]),
              ],
            )),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 過敏史 / 過去病史 ─────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(14), 1: flexW(1), 2: colW(14), 3: flexW(1),
        }, children: [
          pw.TableRow(children: [
            cell('過敏史', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Wrap(spacing: 2, runSpacing: 1, children: [
              ck('無', d.allergyNone), ck('不詳', d.allergyUnknown),
              pw.Row(children: [pw.Text('食物', style: ts()), uv(d.allergyFood, w: 15)]),
              pw.Row(children: [pw.Text('藥物', style: ts()), uv(d.allergyMeds, w: 15)]),
              pw.Row(children: [pw.Text('其他', style: ts()), uv(d.allergyOther, w: 15)]),
            ])),
            cell('過去病史', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Wrap(spacing: 2, runSpacing: 1, children: [
              ck('無', d.histNone), ck('不詳', d.histUnknown),
              ck('高血壓', d.histHypertension), ck('糖尿病', d.histDiabetes),
              ck('心臟疾病', d.histHeart), ck('腦血管疾病', d.histStroke),
              ck('腎臟疾病', d.histKidney), ck('慢性肺部疾病', d.histLung),
              ck('氣喘', d.histAsthma),
              if (d.histOther.isNotEmpty) pw.Text('其他: ${d.histOther}', style: ts()),
            ])),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 病患主訴 ─────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {0: colW(14), 1: flexW(1)}, children: [
          pw.TableRow(children: [
            cell('病患主訴', bold: true),
            pw.Container(
              height: 16 * PdfPageFormat.mm,
              padding: const pw.EdgeInsets.all(3),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Row(children: [
                  ck('家居或同事、友人代訴', d.chiefByFamily),
                ]),
                pw.Text(d.chiefComplaint, style: ts()),
              ]),
            ),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 給藥 ─────────────────────────────────────────────────────────
        pw.Text('給藥紀錄', style: ts(sz: 7, bold: true)),
        pw.Table(border: tbl, columnWidths: {
          0: colW(14), 1: flexW(2), 2: colW(18), 3: colW(14),
        }, children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: [
              cell('時間', bold: true), cell('藥名', bold: true),
              cell('途徑/劑量', bold: true), cell('執行者', bold: true),
            ],
          ),
          ...List.generate(4, (i) => pw.TableRow(children: [
            cell(d.medTime[i], h: 7 * PdfPageFormat.mm),
            cell(d.medName[i]),
            cell(d.medRoute[i]),
            cell(d.medExecutor[i]),
          ])),
        ]),

        pw.SizedBox(height: 2),

        // ── 生命徵象 ─────────────────────────────────────────────────────
        pw.Text('生命徵象', style: ts(sz: 7, bold: true)),
        pw.Table(border: tbl, columnWidths: {
          0: colW(12), 1: colW(12), 2: colW(10), 3: colW(12),
          4: colW(12), 5: colW(16), 6: colW(10), 7: colW(20),
        }, children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: [
              cell('時間', bold: true), cell('意識狀況', bold: true),
              cell('體溫℃', bold: true), cell('脈搏次/分', bold: true),
              cell('呼吸次/分', bold: true), cell('血壓mmHg', bold: true),
              cell('SpO₂%', bold: true), cell('GCS E__V__M__', bold: true),
            ],
          ),
          ...List.generate(4, (i) => pw.TableRow(children: [
            cell(d.vsTime[i], h: 7 * PdfPageFormat.mm),
            cell(d.vsConsciousness[i]),
            cell(d.vsTemp[i]),
            cell(d.vsPulse[i]),
            cell(d.vsBreathing[i]),
            cell('${d.vsBPSys[i]}/${d.vsBPDia[i]}'),
            cell(d.vsSpO2[i]),
            cell('E${d.vsGcsE[i]} V${d.vsGcsV[i]} M${d.vsGcsM[i]}'),
          ])),
        ]),

        pw.SizedBox(height: 2),

        // ── 到院後 / 備註 ─────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {0: colW(20), 1: flexW(1), 2: colW(12), 3: flexW(1)}, children: [
          pw.TableRow(children: [
            cell('到院後檢站', bold: true),
            pw.Container(padding: const pw.EdgeInsets.all(2), child: pw.Row(children: [
              ck('清醒', d.postAlert), ck('痛覺', d.postPain), ck('無心跳呼吸', d.postArrested),
            ])),
            cell('備註', bold: true),
            cell(d.notes),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 簽名 & 費用 ───────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {
          0: colW(14), 1: flexW(1), 2: colW(14), 3: flexW(1),
          4: colW(14), 5: flexW(1),
        }, children: [
          pw.TableRow(children: [
            cell('隨車救護員', bold: true),
            cell('一: ${d.emt1}  二: ${d.emt2}  三: ${d.emt3}'),
            cell('接收單位', bold: true),
            cell(d.receiveUnit),
            cell('病患/家屬簽名', bold: true),
            cell(d.patientFamilySign),
          ]),
        ]),

        pw.SizedBox(height: 2),

        // ── 費用 ─────────────────────────────────────────────────────────
        pw.Table(border: tbl, columnWidths: {0: flexW(1)}, children: [
          pw.TableRow(children: [
            pw.Container(padding: const pw.EdgeInsets.all(3), child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(children: [
                  pw.Text('救護車費用(含醫護人員)：', style: ts(bold: true)),
                  uv(d.ambulanceFee, w: 20),
                  pw.Text('  氧氣使用費：', style: ts(bold: true)),
                  uv(d.o2Fee, w: 15),
                  pw.Text('  總計：', style: ts(bold: true)),
                  uv(d.totalFee, w: 20),
                ]),
                pw.SizedBox(height: 2),
                pw.Row(children: [
                  ck('已收費（現金/刷卡）', d.paidCash),
                  ck('聯新國際醫院代收', d.paidHospital),
                  ck('未收費', d.unpaid),
                  if (d.unpaidNote.isNotEmpty)
                    pw.Text('（${d.unpaidNote}）', style: ts()),
                ]),
              ],
            )),
          ]),
        ]),

        pw.Expanded(child: pw.SizedBox()),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('51-S-000-001', style: ts(sz: 6, c: PdfColors.grey600)),
            pw.Text('聯新(A432)2022/06x500張', style: ts(sz: 6, c: PdfColors.grey600)),
          ],
        ),
      ],
    ),
  ));

  return Uint8List.fromList(await pdf.save());
}

pw.Widget _timeEntry(String label, String h, String m,
    pw.Font font, pw.Font fontB) {
  pw.TextStyle ts({bool bold = false}) =>
      pw.TextStyle(font: bold ? fontB : font, fontSize: 6.5);
  return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
    pw.Text(label, style: ts(bold: true)),
    pw.Row(children: [
      pw.Container(
        width: 10 * PdfPageFormat.mm,
        decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 0.4, color: PdfColors.grey600))),
        child: pw.Text(h.isEmpty ? '  ' : h, style: ts(), textAlign: pw.TextAlign.center),
      ),
      pw.Text(':', style: ts()),
      pw.Container(
        width: 10 * PdfPageFormat.mm,
        decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 0.4, color: PdfColors.grey600))),
        child: pw.Text(m.isEmpty ? '  ' : m, style: ts(), textAlign: pw.TextAlign.center),
      ),
    ]),
  ]);
}
