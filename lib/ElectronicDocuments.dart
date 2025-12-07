// lib/ElectronicDocumentsPage.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'data/models/electronic_document_data.dart';
import 'l10n/app_translations.dart';
import 'nav2.dart';

class ElectronicDocumentsPage extends StatefulWidget {
  final int visitId;
  const ElectronicDocumentsPage({super.key, required this.visitId});

  @override
  State<ElectronicDocumentsPage> createState() =>
      _ElectronicDocumentsPageState();
}

class _ElectronicDocumentsPageState extends State<ElectronicDocumentsPage>
    with
        AutomaticKeepAliveClientMixin<ElectronicDocumentsPage>,
        SavableStateMixin<ElectronicDocumentsPage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // =================== 統一外觀樣式 ===================
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1000;
  static const double _radius = 16;
  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _border = Color(0xFFCBD5E1);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveElectronicDocFailed}$e')),
        );
      }
      rethrow;
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<ElectronicDocumentsDao>();
      final dataModel = context.read<ElectronicDocumentData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null) {
        dataModel.toSelectedIndex = record.toSelectedIndex;
        dataModel.fromSelectedIndex = record.fromSelectedIndex;
      }
      dataModel.update();
    } catch (e) {
      // 錯誤處理
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<ElectronicDocumentsDao>();
    final dataModel = context.read<ElectronicDocumentData>();
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  // ===============================================
  // PDF 列印功能
  // ===============================================
  Future<void> _printPdf() async {
    // 1. 先儲存當前頁面資料
    await _saveData();
    final docData = context.read<ElectronicDocumentData>();

    // 2. 獲取所有需要的關聯資料
    String patientName = "";
    String nationality = "";
    String gender = "";
    DateTime? dob;

    // 航班資訊
    String airline = "";
    String flightNo = "";

    // 意外/事件資訊
    DateTime? incidentDate;
    String location = "";
    String reporter = "";
    DateTime? reportTime;

    // 醫療資訊
    DateTime? diagnosisTime;
    String diagnosis = "";
    Set<String> followUpResults = {};
    String referralHospital = "";
    bool feeCollected = false;
    String feeAmount = "";
    String physicianName = "";
    String nurseName = "";

    try {
      final visitsDao = context.read<VisitsDao>();
      final profileDao = context.read<PatientProfilesDao>();
      final accidentDao = context.read<AccidentRecordsDao>();
      final treatmentDao = context.read<TreatmentsDao>();
      final flightDao = context.read<FlightLogsDao>();
      final costDao = context.read<MedicalCostsDao>();

      // Fetch Visit & Profile
      final visit = await visitsDao.getVisit(widget.visitId);
      if (visit != null) {
        patientName = visit.patientName ?? "";
        nationality = visit.nationality ?? "";
      }
      final profile = await profileDao.getByVisitId(widget.visitId);
      if (profile != null) {
        dob = profile.birthday;
        gender = profile.gender ?? "";
      }

      // Fetch Accident (地點、時間、通報人)
      final accident = await accidentDao.getByVisitId(widget.visitId);
      if (accident != null) {
        incidentDate = accident.incidentDate;
        location = "${accident.placeGroup ?? ''} ${accident.placeDetail ?? ''}";
        reporter = accident.notifier ?? "";
        reportTime = accident.notifyTime;
      }

      // Fetch Flight (航班)
      final flight = await flightDao.getByVisitId(widget.visitId);
      if (flight != null) {
        airline = flight.airline ?? "";
        // ★★★ 修正1：flightNumber -> flightNo (Drift 生成的名稱)
        flightNo = flight.flightNo ?? "";
      }

      // Fetch Treatment (診斷、處置結果、簽名)
      final treatment = await treatmentDao.getByVisitId(widget.visitId);
      if (treatment != null) {
        diagnosis = treatment.initialDiagnosis ?? "";
        diagnosisTime = treatment.createdAt;

        if (treatment.followUpResultsJson != null) {
          try {
            final List<dynamic> list = jsonDecode(
              treatment.followUpResultsJson!,
            );
            followUpResults = Set<String>.from(list);
          } catch (e) {
            // ignore error
          }
        }
        referralHospital =
            treatment.referralHospital ?? treatment.referralOtherHospital ?? "";
        physicianName = treatment.selectedMainDoctor ?? "";
        nurseName =
            treatment.nurseSignature ?? treatment.selectedMainNurse ?? "";
      }

      // Fetch Medical Cost (費用)
      final cost = await costDao.getByVisitId(widget.visitId);
      if (cost != null) {
        // ★★★ 修正2：手動計算 Total Fee，因為 Drift 的 MedicalCost 物件沒有 totalFee getter
        double vFee = double.tryParse(cost.visitFee ?? '0') ?? 0;
        double aFee = double.tryParse(cost.ambulanceFee ?? '0') ?? 0;
        double total = vFee + aFee;

        if (total > 0) {
          feeCollected = true;
          feeAmount = total.toStringAsFixed(0);
        }
      }
    } catch (e) {
      debugPrint("Error fetching data for PDF: $e");
    }

    // 3. 準備字型
    final font = await PdfGoogleFonts.notoSansTCRegular();
    final fontBold = await PdfGoogleFonts.notoSansTCBold();

    // 4. 生成 PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final doc = pw.Document();

        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            build: (pw.Context context) {
              return _buildPdfContent(
                font: font,
                fontBold: fontBold,
                docData: docData,
                patientName: patientName,
                nationality: nationality,
                dob: dob,
                gender: gender,
                airline: airline,
                flightNo: flightNo,
                incidentDate: incidentDate,
                location: location,
                reporter: reporter,
                reportTime: reportTime,
                diagnosisTime: diagnosisTime,
                diagnosis: diagnosis,
                followUpResults: followUpResults,
                referralHospital: referralHospital,
                feeCollected: feeCollected,
                feeAmount: feeAmount,
                physicianName: physicianName,
                nurseName: nurseName,
              );
            },
          ),
        );

        return doc.save();
      },
    );
  }

  // 建構 PDF 內容
  pw.Widget _buildPdfContent({
    required pw.Font font,
    required pw.Font fontBold,
    required ElectronicDocumentData docData,
    required String patientName,
    required String nationality,
    required DateTime? dob,
    required String gender,
    required String airline,
    required String flightNo,
    required DateTime? incidentDate,
    required String location,
    required String reporter,
    required DateTime? reportTime,
    required DateTime? diagnosisTime,
    required String diagnosis,
    required Set<String> followUpResults,
    required String referralHospital,
    required bool feeCollected,
    required String feeAmount,
    required String physicianName,
    required String nurseName,
  }) {
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 18);
    final subTitleStyle = pw.TextStyle(font: fontBold, fontSize: 10);
    final headerStyle = pw.TextStyle(font: fontBold, fontSize: 22);
    final bodyStyle = pw.TextStyle(font: font, fontSize: 12);
    final labelStyle = pw.TextStyle(font: fontBold, fontSize: 12);

    String fmtDate(DateTime? dt) {
      if (dt == null) return "    年    月    日";
      return "${dt.year} 年 ${dt.month} 月 ${dt.day} 日";
    }

    String fmtTime(DateTime? dt) {
      if (dt == null) return "    時    分";
      return "${dt.hour} 時 ${dt.minute} 分";
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // --- Header ---
        pw.Center(child: pw.Text("聯新國際醫院 桃園國際機場醫療中心", style: titleStyle)),
        pw.Center(
          child: pw.Text(
            "LANDSEED MEDICAL CLINIC AT TAIWAN TAOYUAN INTERNATIONAL AIRPORT",
            style: subTitleStyle,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Center(child: pw.Text("出診診療服務電傳文件", style: headerStyle)),
        pw.SizedBox(height: 20),

        // --- TO Section ---
        pw.Row(
          children: [
            pw.Text("TO : ", style: labelStyle),
            pw.Text("桃園國際機場股份有限公司營運安全處", style: bodyStyle),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 100),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _pdfCheckbox(
                label: "T1 03-2733578",
                checked: docData.toSelectedIndex == 0,
                font: font,
              ),
              _pdfCheckbox(
                label: "T2 03-2733367",
                checked: docData.toSelectedIndex == 1,
                font: font,
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 15),

        // --- FROM Section ---
        pw.Row(
          children: [
            pw.Text("FROM : ", style: labelStyle),
            pw.Text("聯新國際醫院桃園國際機場醫療中心", style: bodyStyle),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 100),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _pdfCheckbox(
                label: "T1 03-3834225",
                checked: docData.fromSelectedIndex == 0,
                font: font,
              ),
              _pdfCheckbox(
                label: "T2 03-3983485",
                checked: docData.fromSelectedIndex == 1,
                font: font,
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 25),

        // --- Patient Info ---
        pw.Row(
          children: [
            _pdfFieldLabel("病患姓名：", fontBold),
            pw.Expanded(child: pw.Text(patientName, style: bodyStyle)),
            _pdfFieldLabel("國籍：", fontBold),
            pw.Expanded(child: pw.Text(nationality, style: bodyStyle)),
          ],
        ),
        pw.SizedBox(height: 15),

        pw.Row(
          children: [
            _pdfFieldLabel("生日：西元", fontBold),
            pw.Expanded(child: pw.Text(fmtDate(dob), style: bodyStyle)),
            _pdfFieldLabel("性別：", fontBold),
            pw.Expanded(child: pw.Text(gender, style: bodyStyle)),
          ],
        ),
        pw.SizedBox(height: 15),

        pw.Row(
          children: [
            _pdfCheckbox(
              label: "航空公司：",
              checked: airline.isNotEmpty,
              font: fontBold,
            ),
            pw.Expanded(child: pw.Text(airline, style: bodyStyle)),
            _pdfFieldLabel("班機：", fontBold),
            pw.Expanded(child: pw.Text(flightNo, style: bodyStyle)),
            _pdfCheckbox(label: "其他：", checked: false, font: fontBold),
            pw.Expanded(child: pw.Text("", style: bodyStyle)),
          ],
        ),
        pw.SizedBox(height: 15),

        pw.Row(
          children: [
            _pdfFieldLabel("發生日期：西元", fontBold),
            pw.Expanded(
              child: pw.Text(fmtDate(incidentDate), style: bodyStyle),
            ),
            _pdfFieldLabel("地點：", fontBold),
            pw.Expanded(child: pw.Text(location, style: bodyStyle)),
          ],
        ),
        pw.SizedBox(height: 15),

        pw.Row(
          children: [
            _pdfFieldLabel("通報人員：", fontBold),
            pw.Expanded(child: pw.Text(reporter, style: bodyStyle)),
            _pdfCheckbox(label: "出境", checked: false, font: font),
            pw.SizedBox(width: 10),
            _pdfCheckbox(label: "入境", checked: false, font: font),
            pw.SizedBox(width: 10),
            _pdfCheckbox(label: "過境", checked: false, font: font),
          ],
        ),
        pw.SizedBox(height: 15),

        pw.Row(
          children: [
            _pdfFieldLabel("通報時間：", fontBold),
            pw.Text(fmtTime(reportTime), style: bodyStyle),
            pw.SizedBox(width: 40),
            _pdfFieldLabel("診療時間：", fontBold),
            pw.Text(fmtTime(diagnosisTime), style: bodyStyle),
          ],
        ),
        pw.SizedBox(height: 15),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _pdfFieldLabel("初步診斷(中文)：", fontBold),
            pw.Expanded(child: pw.Text(diagnosis, style: bodyStyle)),
          ],
        ),
        pw.SizedBox(height: 30),

        // --- Follow up ---
        pw.Row(
          children: [
            _pdfFieldLabel("後續結果(中文)：", fontBold),
            _pdfCheckbox(
              label: "自行返家",
              checked: followUpResults.contains('rest_observe_go_home'),
              font: font,
            ),
            pw.SizedBox(width: 10),
            _pdfCheckbox(
              label: "繼續搭機",
              checked: followUpResults.contains('continue_flight'),
              font: font,
            ),
            pw.SizedBox(width: 10),
            _pdfCheckbox(
              label: "轉送至 (   $referralHospital   ) 醫院",
              checked:
                  followUpResults.contains('transfer_linkou') ||
                  followUpResults.contains('transfer_landseed') ||
                  followUpResults.contains('transfer_other_hospital'),
              font: font,
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 100),
          child: pw.Row(
            children: [
              _pdfCheckbox(label: "醫療中心觀察", checked: false, font: font),
              pw.SizedBox(width: 10),
              _pdfCheckbox(label: "空跑", checked: false, font: font),
              pw.SizedBox(width: 10),
              _pdfCheckbox(label: "其他", checked: false, font: font),
            ],
          ),
        ),
        pw.SizedBox(height: 25),

        // --- Other Matters ---
        pw.Row(
          children: [
            _pdfFieldLabel("其他事宜：", fontBold),
            // ★★★ 修正3：style 參數不能傳入 Font 物件，改用 TextStyle
            pw.Text("醫療費用收費 ", style: labelStyle),
            _pdfCheckbox(label: "是", checked: feeCollected, font: font),
            pw.SizedBox(width: 10),
            _pdfCheckbox(label: "否", checked: !feeCollected, font: font),
            pw.Text("，金額  $feeAmount", style: bodyStyle),
          ],
        ),
        pw.SizedBox(height: 50),

        // --- Signatures ---
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                _pdfFieldLabel("醫師：", fontBold),
                pw.Text(physicianName, style: bodyStyle),
              ],
            ),
            pw.Row(
              children: [
                _pdfFieldLabel("護理師：", fontBold),
                pw.Text(nurseName, style: bodyStyle),
              ],
            ),
            pw.SizedBox(width: 50),
          ],
        ),

        pw.Spacer(),

        // --- Footer ---
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "51-P-002-002",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
            pw.Text(
              "聯新(A364)2021/11x500 張",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  // PDF Helper: 帶標籤的欄位
  pw.Widget _pdfFieldLabel(String text, pw.Font font) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  // PDF Helper: 模擬 Checkbox
  pw.Widget _pdfCheckbox({
    required String label,
    required bool checked,
    required pw.Font font,
  }) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
          child: checked
              ? pw.Center(child: pw.Text("v", style: pw.TextStyle(fontSize: 8)))
              : null,
        ),
        pw.SizedBox(width: 5),
        pw.Text(label, style: pw.TextStyle(font: font, fontSize: 12)),
      ],
    );
  }

  // ===============================================
  // UI Build Method
  // ===============================================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    final List<String> toOptions = [t.toOption1, t.toOption2];
    final List<String> fromOptions = [t.fromOption1, t.fromOption2];

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<ElectronicDocumentData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(
            horizontal: _outerHpad,
            vertical: 16,
          ),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
                child: _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _SectionTitle(t.toOOC),
                      const SizedBox(height: 10),
                      _RadioList(
                        options: toOptions,
                        groupValue: dataModel.toSelectedIndex,
                        onChanged: (int v) {
                          dataModel.toSelectedIndex = v;
                          dataModel.update();
                        },
                      ),
                      const SizedBox(height: 28),
                      _SectionTitle(t.fromMedicalCenter),
                      const SizedBox(height: 10),
                      _RadioList(
                        options: fromOptions,
                        groupValue: dataModel.fromSelectedIndex,
                        onChanged: (int v) {
                          dataModel.fromSelectedIndex = v;
                          dataModel.update();
                        },
                      ),
                      const SizedBox(height: 40),

                      // --- 底部列印按鈕 ---
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _printPdf,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF83ACA9),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.print, color: Colors.white),
                          label: const Text(
                            "列印 / Print",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===============================================
  // 美編樣式 (統一白卡外觀)
  // ===============================================
  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // 柔和陰影
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
        border: const Border(
          top: BorderSide(color: _border),
          right: BorderSide(color: _border),
          bottom: BorderSide(color: _border),
          left: BorderSide(color: _border),
        ),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        height: 1.25,
      ),
    );
  }
}

class _RadioList extends StatelessWidget {
  const _RadioList({
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  final List<String> options;
  final int? groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(options.length, (int i) {
        final bool selected = groupValue == i;
        return InkWell(
          onTap: () => onChanged(i),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 20,
                  color: selected ? const Color(0xFF274C4A) : Colors.black45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    options[i],
                    style: const TextStyle(
                      fontSize: 15.5,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
