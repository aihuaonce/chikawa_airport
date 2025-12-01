// MedicalCertificatePage.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'data/models/certificate_data.dart';
import 'l10n/app_translations.dart';
import 'nav2.dart';

class MedicalCertificatePage extends StatefulWidget {
  final int visitId;
  const MedicalCertificatePage({super.key, required this.visitId});

  @override
  State<MedicalCertificatePage> createState() => _MedicalCertificatePageState();
}

class _MedicalCertificatePageState extends State<MedicalCertificatePage>
    with
        AutomaticKeepAliveClientMixin<MedicalCertificatePage>,
        SavableStateMixin<MedicalCertificatePage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // 文字輸入框控制器
  final _diagnosisController = TextEditingController();
  final _chineseController = TextEditingController();
  final _englishController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _chineseController.dispose();
    _englishController.dispose();
    super.dispose();
  }

  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${t.saveCertificateFailed}$e')));
      }
      rethrow;
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<MedicalCertificatesDao>();
      final dataModel = context.read<CertificateData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null) {
        dataModel.diagnosis = record.diagnosis;
        dataModel.instructionOption = record.instructionOption;
        dataModel.chineseInstruction = record.chineseInstruction;
        dataModel.englishInstruction = record.englishInstruction;
        dataModel.issueDate = record.issueDate;
      }
      _syncDataToControllers(dataModel);
      dataModel.update();
    } catch (e) {
      debugPrint('Load Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<MedicalCertificatesDao>();
    final dataModel = context.read<CertificateData>();
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  void _syncDataToControllers(CertificateData dataModel) {
    _diagnosisController.text = dataModel.diagnosis ?? '';
    _chineseController.text = dataModel.chineseInstruction ?? '';
    _englishController.text = dataModel.englishInstruction ?? '';
  }

  void _syncControllersToData() {
    final dataModel = context.read<CertificateData>();
    dataModel.diagnosis = _diagnosisController.text.trim();
    dataModel.chineseInstruction = _chineseController.text.trim();
    dataModel.englishInstruction = _englishController.text.trim();
  }

  // ===========================================================================
  // PDF 列印與生成邏輯
  // ===========================================================================
  Future<void> _printCertificate({required bool isEnglish}) async {
    // 1. 儲存當前資料
    _syncControllersToData();
    await _saveData();

    final certData = context.read<CertificateData>();

    // 2. 獲取病人詳細資料
    String patientName = "";
    DateTime? dob;
    String gender = "";
    String idNo = "";
    String nationality = "";

    try {
      final visitsDao = context.read<VisitsDao>();
      final profilesDao = context.read<PatientProfilesDao>();

      final visit = await visitsDao.getVisit(widget.visitId);
      if (visit != null) {
        patientName = visit.patientName ?? "";
        nationality = visit.nationality ?? "";
      }

      final profile = await profilesDao.getByVisitId(widget.visitId);
      if (profile != null) {
        dob = profile.birthday;
        gender = profile.gender ?? "";
        idNo = (profile.idNumber != null && profile.idNumber!.isNotEmpty)
            ? profile.idNumber!
            : (profile.passportNumber ?? "");
      }
    } catch (e) {
      debugPrint("Error fetching patient data: $e");
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
            margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            build: (pw.Context context) {
              if (isEnglish) {
                // 英文版面
                return _buildEnglishPdfContent(
                  font: font,
                  fontBold: fontBold,
                  patientName: patientName,
                  dob: dob,
                  gender: gender,
                  idNo: idNo,
                  nationality: nationality,
                  certData: certData,
                );
              } else {
                // 中文版面
                return _buildChinesePdfContent(
                  font: font,
                  fontBold: fontBold,
                  patientName: patientName,
                  dob: dob,
                  gender: gender,
                  idNo: idNo,
                  certData: certData,
                );
              }
            },
          ),
        );

        return doc.save();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 中文版 PDF (參考 Page 3)
  // ---------------------------------------------------------------------------
  pw.Widget _buildChinesePdfContent({
    required pw.Font font,
    required pw.Font fontBold,
    required String patientName,
    required DateTime? dob,
    required String gender,
    required String idNo,
    required CertificateData certData,
  }) {
    final baseStyle = pw.TextStyle(font: font, fontSize: 11);
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 22);
    final subTitleStyle = pw.TextStyle(font: fontBold, fontSize: 18);

    String formatDate(DateTime? date) {
      if (date == null) return "";
      return "${date.year} 年 ${date.month} 月 ${date.day} 日";
    }

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text("聯新國際醫院桃園國際機場醫療中心", style: titleStyle),
              pw.SizedBox(height: 8),
              pw.Text("診斷證明書", style: subTitleStyle),
              pw.SizedBox(height: 15),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 0.8, color: PdfColors.black),
                ),
                child: pw.Column(
                  children: [
                    // 第一行：姓名
                    pw.Row(
                      children: [
                        _pdfCell(text: "姓名", width: 60, font: font, height: 30),
                        _pdfCell(
                          text: patientName,
                          font: font,
                          isValue: true,
                          height: 30,
                        ),
                      ],
                    ),
                    pw.Divider(height: 0, thickness: 0.8),

                    // 第二行：出生日期 | 性別 | 身分證號
                    // 修正：將高度由 45 增加為 60，避免文字擁擠
                    pw.Row(
                      children: [
                        _pdfCell(
                          text: "出生\n日期",
                          width: 60,
                          font: font,
                          height: 60,
                        ),
                        _pdfCell(
                          text: formatDate(dob),
                          font: font,
                          isValue: true,
                          height: 60,
                        ),
                        pw.Container(
                          width: 0.8,
                          height: 60,
                          color: PdfColors.black,
                        ),
                        _pdfCell(text: "性別", width: 40, font: font, height: 60),
                        _pdfCell(
                          text: gender,
                          width: 40,
                          font: font,
                          isValue: true,
                          height: 60,
                        ),
                        pw.Container(
                          width: 0.8,
                          height: 60,
                          color: PdfColors.black,
                        ),
                        _pdfCell(
                          text: "身分證號碼\n或\n護照號碼",
                          width: 80,
                          font: font,
                          height: 60,
                        ),
                        _pdfCell(
                          text: idNo,
                          font: font,
                          isValue: true,
                          height: 60,
                        ),
                      ],
                    ),
                    pw.Divider(height: 0, thickness: 0.8),

                    // 第三行：診斷
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _pdfCell(
                          text: "\n診\n\n斷",
                          width: 60,
                          font: font,
                          height: 180,
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 180,
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              certData.diagnosis ?? "",
                              style: baseStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(height: 0, thickness: 0.8),

                    // 第四行：醫囑
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _pdfCell(
                          text: "\n醫\n師\n囑\n言\n或\n備\n註",
                          width: 60,
                          font: font,
                          height: 180,
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 180,
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  certData.chineseInstruction ?? "",
                                  style: baseStyle,
                                ),
                                pw.SizedBox(height: 8),
                                pw.Text(
                                  certData.englishInstruction ?? "",
                                  style: baseStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "以上病人經本院醫師診斷屬實特予證明",
                  style: pw.TextStyle(font: font, fontSize: 14),
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("院長：", style: baseStyle),
                  pw.Text("診治醫師：", style: baseStyle),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text("開業執照號碼：桃衛醫診字第 3432060513 號", style: baseStyle),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "西元   ${certData.issueDate?.year ?? '    '}   年   ${certData.issueDate?.month ?? '  '}   月   ${certData.issueDate?.day ?? '  '}   日",
                  style: pw.TextStyle(font: font, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          width: 30,
          margin: const pw.EdgeInsets.only(left: 10, top: 120),
          child: pw.Column(
            children: "本證明書須加蓋本院印章否則無效"
                .split('')
                .map(
                  (char) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Text(char, style: baseStyle),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 英文版 PDF (參考 Page 2)
  // ---------------------------------------------------------------------------
  pw.Widget _buildEnglishPdfContent({
    required pw.Font font,
    required pw.Font fontBold,
    required String patientName,
    required DateTime? dob,
    required String gender,
    required String idNo,
    required String nationality,
    required CertificateData certData,
  }) {
    final baseStyle = pw.TextStyle(font: font, fontSize: 12);
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 18);
    final subTitleStyle = pw.TextStyle(font: fontBold, fontSize: 24);

    String formatDate(DateTime? date) {
      if (date == null) return "";
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }

    String enGender = gender;
    if (gender == "男") enGender = "Male";
    if (gender == "女") enGender = "Female";

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          "Landseed Medical Clinic at Taiwan Taoyuan Int'l Airport",
          style: titleStyle,
        ),
        pw.SizedBox(height: 10),
        pw.Text("Medical Certificate", style: subTitleStyle),
        pw.SizedBox(height: 30),

        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1, color: PdfColors.black),
          ),
          child: pw.Column(
            children: [
              pw.Row(
                children: [
                  _pdfCell(
                    text: "Name",
                    width: 100,
                    font: font,
                    height: 40,
                    align: pw.Alignment.centerLeft,
                  ),
                  _pdfCell(
                    text: patientName,
                    font: font,
                    isValue: true,
                    height: 40,
                    align: pw.Alignment.centerLeft,
                  ),
                ],
              ),
              pw.Divider(height: 0, thickness: 1),

              pw.Row(
                children: [
                  _pdfCell(
                    text: "Date of Birth",
                    width: 100,
                    font: font,
                    height: 40,
                    align: pw.Alignment.centerLeft,
                  ),
                  _pdfCell(
                    text: formatDate(dob),
                    font: font,
                    isValue: true,
                    height: 40,
                    align: pw.Alignment.centerLeft,
                  ),
                  pw.Container(width: 1, height: 40, color: PdfColors.black),
                  _pdfCell(
                    text: "Sex",
                    width: 60,
                    font: font,
                    height: 40,
                    align: pw.Alignment.center,
                  ),
                  _pdfCell(
                    text: enGender,
                    font: font,
                    isValue: true,
                    height: 40,
                    align: pw.Alignment.center,
                  ),
                ],
              ),
              pw.Divider(height: 0, thickness: 1),

              pw.Row(
                children: [
                  _pdfCell(
                    text: "Nationality",
                    width: 100,
                    font: font,
                    height: 40,
                    align: pw.Alignment.centerLeft,
                  ),
                  _pdfCell(
                    text: nationality,
                    font: font,
                    isValue: true,
                    height: 40,
                    align: pw.Alignment.centerLeft,
                  ),
                  pw.Container(width: 1, height: 40, color: PdfColors.black),
                  _pdfCell(
                    text: "ID No or\nPassport No",
                    width: 100,
                    font: font,
                    height: 40,
                    align: pw.Alignment.center,
                  ),
                  _pdfCell(
                    text: idNo,
                    font: font,
                    isValue: true,
                    height: 40,
                    align: pw.Alignment.center,
                  ),
                ],
              ),
              pw.Divider(height: 0, thickness: 1),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _pdfCell(
                    text: "\nImpression",
                    width: 100,
                    font: font,
                    height: 150,
                    align: pw.Alignment.topCenter,
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 150,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        certData.diagnosis ?? "",
                        style: baseStyle,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Divider(height: 0, thickness: 1),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _pdfCell(
                    text: "\nComments\nAnd\nAdvices",
                    width: 100,
                    font: font,
                    height: 150,
                    align: pw.Alignment.center,
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: 150,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        certData.englishInstruction ??
                            certData.chineseInstruction ??
                            "",
                        style: baseStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        pw.Spacer(),

        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("President : CHIN-YU LIU", style: baseStyle),
              pw.SizedBox(height: 5),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Attending physician:                   ",
                  style: baseStyle,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "Address: No 15, Hangjan S.Rd, Dayuan dist., Taoyuan, Taiwan.",
                style: baseStyle,
              ),
              pw.Text("TEL: +886-3-398-3456", style: baseStyle),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Issued Date: ${formatDate(certData.issueDate)}     ",
                  style: baseStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _pdfCell({
    required String text,
    required pw.Font font,
    double? width,
    double? height,
    bool isValue = false,
    pw.Alignment align = pw.Alignment.center,
  }) {
    final style = pw.TextStyle(font: font, fontSize: 11);
    final container = pw.Container(
      width: width,
      height: height,
      padding: const pw.EdgeInsets.all(5),
      decoration: isValue
          ? null
          : const pw.BoxDecoration(
              border: pw.Border(right: pw.BorderSide(width: 0.8)),
            ),
      child: pw.Align(
        alignment: align,
        child: pw.Text(text, style: style, textAlign: pw.TextAlign.center),
      ),
    );
    if (isValue && width == null) return pw.Expanded(child: container);
    return container;
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      // 移除 Scaffold 的 floatingActionButton
      body: Consumer<CertificateData>(
        builder: (context, dataModel, child) {
          return Container(
            color: const Color(0xFFE6F6FB),
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDiagnosisInput(t, dataModel),
                          const SizedBox(height: 16),
                          _buildRadioRow(t, dataModel),
                          const SizedBox(height: 16),
                          _buildChineseInstructionInput(t, dataModel),
                          const SizedBox(height: 16),
                          _buildEnglishInstructionInput(t, dataModel),
                          const SizedBox(height: 16),
                          _buildDateRow(t, dataModel),

                          // --- 底部列印按鈕 ---
                          const SizedBox(height: 40),
                          Center(
                            child: PopupMenuButton<String>(
                              tooltip: '列印選項',
                              offset: const Offset(
                                0,
                                -110,
                              ), // 讓選單向上彈出 (因為按鈕在底部)
                              onSelected: (value) {
                                if (value == 'cn') {
                                  _printCertificate(isEnglish: false);
                                } else {
                                  _printCertificate(isEnglish: true);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'cn',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.description,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Text('中文診斷書 (Chinese)'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'en',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.language,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Text('英文診斷書 (English)'),
                                        ],
                                      ),
                                    ),
                                  ],
                              // 自定義按鈕外觀 (Child)
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF83ACA9),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.print, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      '列印 / Print',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Widget Builders ---
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF83ACA9), width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildDiagnosisInput(AppTranslations t, CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.diagnosisLabel)),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _diagnosisController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterDiagnosisHint),
          ),
        ),
      ],
    );
  }

  Widget _buildChineseInstructionInput(
    AppTranslations t,
    CertificateData dataModel,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.chineseInstructionLabel)),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _chineseController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterChineseInstructionHint),
          ),
        ),
      ],
    );
  }

  Widget _buildEnglishInstructionInput(
    AppTranslations t,
    CertificateData dataModel,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.englishInstructionLabel)),
        Expanded(
          flex: 8,
          child: TextField(
            controller: _englishController,
            maxLines: 3,
            decoration: _getInputDecoration(t.enterEnglishInstructionHint),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioRow(AppTranslations t, CertificateData dataModel) {
    void updateInstructions({
      required int option,
      required String chineseTemplate,
      required String englishTemplate,
    }) {
      dataModel.instructionOption = option;

      String diagnosis = _diagnosisController.text.trim();
      if (diagnosis.isEmpty) {
        diagnosis = t.diagnosisPlaceholder;
      }

      final newChineseText = chineseTemplate.replaceAll(
        '{diagnosis}',
        diagnosis,
      );
      final newEnglishText = englishTemplate.replaceAll(
        '{diagnosis}',
        diagnosis,
      );

      _chineseController.text = newChineseText;
      _englishController.text = newEnglishText;

      dataModel.update();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.defaultInstructionPhrase)),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  updateInstructions(
                    option: value!,
                    chineseTemplate: t.fitToFlyInstructionChinese,
                    englishTemplate: t.fitToFlyInstructionEnglish,
                  );
                },
              ),
              Text(t.fitToFly),
              const SizedBox(width: 20),
              Radio<int>(
                value: 2,
                groupValue: dataModel.instructionOption,
                activeColor: const Color(0xFF83ACA9),
                onChanged: (value) {
                  updateInstructions(
                    option: value!,
                    chineseTemplate: t.referralInstructionChinese,
                    englishTemplate: t.referralInstructionEnglish,
                  );
                },
              ),
              Text(t.referral),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(AppTranslations t, CertificateData dataModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildLabel(t.issueDateLabel)),
        Expanded(
          flex: 8,
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: dataModel.issueDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                dataModel.issueDate = picked;
                dataModel.update();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dataModel.issueDate != null
                        ? "${dataModel.issueDate!.year}-${dataModel.issueDate!.month.toString().padLeft(2, '0')}-${dataModel.issueDate!.day.toString().padLeft(2, '0')}"
                        : t.selectDate,
                    style: TextStyle(
                      color: dataModel.issueDate != null
                          ? Colors.black
                          : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
