import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// 資料模型：預留給資料庫對接
class MedicalServiceApplicationData {
  const MedicalServiceApplicationData();
}

Future<Uint8List> buildMedicalServiceApplicationPdf(MedicalServiceApplicationData d) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  final tealColor = PdfColor.fromInt(0xFF007A7A);
  final black = PdfColors.black;

  // 1. 統一字體樣式
  pw.TextStyle ts({double sz = 10, bool bold = false, PdfColor? color}) =>
      pw.TextStyle(
        font: bold ? fontB : font,
        fontSize: sz,
        color: color ?? black,
        lineSpacing: 4, // 加大行距
      );

  // 2. 輔助元件：勾選框
  pw.Widget buildCheckBox(String label, bool checked, {double sz = 10}) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 11,
          height: 11,
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
          child: checked ? pw.Center(child: pw.Text('v', style: pw.TextStyle(font: font, fontSize: 8))) : null,
        ),
        if (label.isNotEmpty) pw.SizedBox(width: 4),
        if (label.isNotEmpty) pw.Text(label, style: ts(sz: sz)),
        pw.SizedBox(width: 8),
      ],
    );
  }

  // 3. 輔助元件：嵌入文字中的短底線
  pw.Widget buildInlineUnderline(double width) {
    return pw.Container(
      width: width * PdfPageFormat.mm,
      margin: const pw.EdgeInsets.symmetric(horizontal: 2),
      decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.6))),
      child: pw.SizedBox(height: 1),
    );
  }

  // 4. 輔助元件：一般填寫底線
  pw.Widget buildUnderline(String text, double width) {
    return pw.Container(
      width: width,
      decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.6))),
      padding: const pw.EdgeInsets.only(bottom: 1),
      child: pw.Text(text, style: ts(), textAlign: pw.TextAlign.center),
    );
  }

  // 5. 輔助元件：區塊標題
  pw.Widget buildSectionTitle(String title, String english) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 15, bottom: 8),
      child: pw.Row(
        children: [
          pw.Text(title, style: ts(sz: 12, bold: true, color: tealColor)),
          pw.SizedBox(width: 5),
          pw.Text('($english)', style: ts(sz: 10, bold: true, color: tealColor)),
        ],
      ),
    );
  }

    pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(12 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // --- 標題 ---
            pw.Center(
              child: pw.Column(children: [
                pw.Text('聯新國際醫院桃園國際機場醫療中心─緊急醫療救護申請單', 
                  style: ts(sz: 14, bold: true, color: tealColor)),
                pw.Text('Landseed Medical Clinic at Taiwan Taoyuan Int\'l Airport Passenger Medical Service Application Form', 
                  style: ts(sz: 9, bold: true, color: tealColor)),
              ]),
            ),
            pw.SizedBox(height: 6),

            // --- 基本資料 (Personal Data) ---
            buildSectionTitle('基本資料', 'Personal Data'),
            pw.Row(children: [
              buildCheckBox('組員(Crew)', false), buildCheckBox('旅客', false),
              buildCheckBox('員工', false), buildCheckBox('其他', false), buildUnderline('', 60),
            ]),
            pw.SizedBox(height: 4),
            pw.Row(children: [
              pw.Text('病人姓名(Name)', style: ts()), buildUnderline('', 120),
              pw.SizedBox(width: 10),
              pw.Text('生日(Date of Birth)', style: ts()), 
              buildUnderline('', 25), pw.Text('(Y)/', style: ts()),
              buildUnderline('', 15), pw.Text('(M)/', style: ts()),
              buildUnderline('', 15), pw.Text('(D)', style: ts()),
              pw.Spacer(),
              pw.Column(children: [buildCheckBox('男(Male)', false), buildCheckBox('女(Female)', false)]),
            ]),
            pw.Row(children: [
              pw.Text('I.D. No(Passport No.)', style: ts()), buildUnderline('', 130),
              pw.SizedBox(width: 10),
              pw.Text('國籍(Nationality)', style: ts()), buildUnderline('', 100),
            ]),
            pw.SizedBox(height: 4),
            pw.Row(children: [
              pw.Text('航空公司(Airline)', style: ts()), buildUnderline('', 70),
              pw.Text('班機(Flight No)', style: ts()), buildUnderline('', 70),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Row(children: [buildCheckBox('入境(Arrival)', false), buildCheckBox('過境(Transfer)', false)]),
                pw.Row(children: [buildCheckBox('出境(Departure)', false), buildCheckBox('其他(others)', false)]),
              ]),
              pw.Spacer(),
              pw.Text('日期(Date)      /      /\n西元 年(Y)月(M)日(D)', style: ts(sz: 7)),
            ]),
            pw.Row(children: [pw.Text('地址(Address)：', style: ts()), buildUnderline('', 450)]),
            pw.Row(children: [pw.Text('聯絡電話(Telephone)：', style: ts()), buildUnderline('', 150)]),
            
            // 出發地、經過地、目的地 (修正為 TPE 或 填寫欄位 兩選項)
            pw.SizedBox(height: 4),
            ...['出發地', '經過地', '目的地'].map((label) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Row(children: [
                pw.Container(width: 40, child: pw.Text('$label：', style: ts())),
                buildCheckBox('台灣 TPE', false),
                buildCheckBox('', false), buildUnderline('', 120),
              ]),
            )).toList(),

            // --- 通報作業 (Notification) ---
            buildSectionTitle('通報作業', 'Notification'),
            pw.Row(children: [
              buildCheckBox('落地前通知，落地時間：', false), buildUnderline('', 80),
            ]),
            pw.Row(children: [
              pw.Text('通報時間：', style: ts()), buildUnderline('', 60),
              pw.SizedBox(width: 8),
              pw.Text('通報單位/人員：', style: ts()), buildUnderline('', 80),
              pw.SizedBox(width: 8),
              pw.Text('電話：', style: ts()), buildUnderline('', 80),
            ]),
            pw.Row(children: [
              pw.Text('通知營安處時間：', style: ts()), buildUnderline('', 100),
              pw.Text('，到達現場：', style: ts()), buildCheckBox('有', false), buildCheckBox('無', false),
            ]),
            pw.Row(children: [
              pw.Text('通報事故地點：', style: ts()), 
              buildCheckBox('T1', false), buildUnderline('', 30), 
              buildCheckBox('T2', false), buildUnderline('', 30),
              pw.Text('其他', style: ts()), buildUnderline('', 100),
            ]),
            pw.Row(children: [
              pw.Text('醫護抵達時間：', style: ts()), buildUnderline('', 60),
              pw.Text(' 10分鐘內到達：', style: ts()), buildCheckBox('是', false), buildCheckBox('否', false),
              pw.Text('，原因：', style: ts()), buildUnderline('', 80),
              pw.Text('檢查時間：', style: ts()), buildUnderline('', 60),
            ]),

            // --- 醫療收費 (Medical Charge) ---
            buildSectionTitle('醫療收費', 'Medical Charge'),
            pw.Text('■ 疾病管制署篩檢', style: ts(bold: true)),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.SizedBox(width: 15),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                buildCheckBox('協助採檢', false),
                pw.Row(children: [pw.SizedBox(width: 15), buildCheckBox('喉頭採檢', false), buildCheckBox('抽血檢驗', false)]),
                // 修正：其他與喉頭採檢貼齊
                pw.Row(children: [pw.SizedBox(width: 15), buildCheckBox('其他', false), buildUnderline('', 60)]),
              ]),
              pw.SizedBox(width: 25),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                buildCheckBox('健康評估', false),
                pw.Text('1.姓名：_________ /關係：_______ /體溫：_______℃', style: ts()),
                pw.Text('2.姓名：_________ /關係：_______ /體溫：_______℃', style: ts()),
              ]),
            ]),
            pw.SizedBox(height: 4),
            pw.Text('■ 轉診後送', style: ts(bold: true)),
            pw.Padding(padding: const pw.EdgeInsets.only(left: 15), child: pw.Column(children: [
              pw.Row(children: [
                buildCheckBox('一般通關', false), 
                buildCheckBox('緊急通關 (', false), buildCheckBox('公務門', false), buildCheckBox('機坪)', false),
              ]),
              pw.Row(children: [
                pw.Text('救護車：', style: ts()), buildCheckBox('醫療中心', false), buildUnderline('', 40),
                buildCheckBox('民間', false), buildUnderline('', 40),
                buildCheckBox('消防隊：', false), buildUnderline('', 40),
              ]),
              pw.Row(children: [
                pw.Text('轉送醫院：', style: ts()), buildUnderline('', 130),
                pw.SizedBox(width: 15),
                pw.Text('隨車人員：', style: ts()), buildUnderline('', 130),
              ]),
            ])),
            pw.SizedBox(height: 4),
            pw.Text('■ 醫療費用', style: ts(bold: true)),
            pw.Padding(padding: const pw.EdgeInsets.only(left: 15), child: pw.Column(children: [
              pw.Row(children: [
                pw.Text('出診費(Outreach)', style: ts()), buildUnderline('', 120),
                pw.SizedBox(width: 10),
                pw.Text('救護車費用(Ambulance)', style: ts()), buildUnderline('', 120),
              ]),
              // 修正：自付與請款費用後方留填寫空間
              pw.Row(children: [
                buildCheckBox('自付(Total)', false), buildUnderline('', 80),
                pw.SizedBox(width: 20),
                buildCheckBox('請款費用', false), buildUnderline('', 80),
              ]),
            ])),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('■ 自付', style: ts(bold: true)),
                // 修正：現金台幣/其他幣別勾選
                pw.Row(children: [
                  buildCheckBox('現金', false),
                  buildCheckBox('台幣', false),
                  buildCheckBox('其他幣別', false), buildUnderline('', 40),
                ]),
                pw.Text('   ( 兌換後=台幣_______________ )', style: ts(sz: 6.5)),
                pw.Row(children: [buildCheckBox('刷卡', false), buildCheckBox('收費異常，原因：', false), buildUnderline('', 80)]),
              ])),
              pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('■ 統一請款', style: ts(bold: true)),
                pw.Row(children: [pw.Text('申請人(Applicant)', style: ts()), buildUnderline('', 100)]),
                pw.Row(children: [pw.Text('申請單位(Department)', style: ts()), buildUnderline('', 100)]),
                pw.Row(children: [pw.Text('聯絡電話(Telephone)', style: ts()), buildUnderline('', 100)]),
              ])),
            ]),

            pw.SizedBox(height: 8),

            // --- 表格 (內容、同意人、見證人) ---
            pw.Table(
              border: pw.TableBorder.all(color: tealColor, width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('內容', style: ts(bold: true, color: tealColor), textAlign: pw.TextAlign.center)),
                    pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('同意人簽名/身分', style: ts(bold: true, color: tealColor), textAlign: pw.TextAlign.center)),
                    pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('見證人簽名/身分', style: ts(bold: true, color: tealColor), textAlign: pw.TextAlign.center)),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('瞭解醫護人員說明當醫療收費之原由且同意\nUnderstand the medical charge and agree to it', style: ts())),
                  pw.SizedBox(height: 35), pw.SizedBox(height: 35),
                ]),
                pw.TableRow(children: [
                  pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('我同意轉診至___________醫院接受診療，且同意醫療中心安排之救護車前往並付費\nI agree to be referred to the hospital for diagnosis and treatment, and I agree to the ambulance arranged by the clinic to go and pay.', style: ts())),
                  pw.SizedBox(height: 45), pw.SizedBox(height: 45),
                ]),
              ],
            ),

            pw.SizedBox(height: 10),

            // --- 底部簽名 ---
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('醫師：____________________', style: ts()),
                pw.Text('護理師：____________________', style: ts()),
                pw.Text('EMT：____________________', style: ts()),
              ],
            ),

            pw.Spacer(),
            pw.Center(child: pw.Text('第 1 頁', style: ts(sz: 8))),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('51-P-002-001', style: ts(sz: 7)),
                pw.Text('聯新[A431]2021/11x500 張', style: ts(sz: 7)),
              ],
            ),
          ],
        );
      },
    ),
  );

  // ==========================================
  // 第二頁：醫療紀錄與切結書
  // ==========================================
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(12 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('醫療紀錄(Medical Record)', style: ts(sz: 13, bold: true, color: tealColor)),
            pw.SizedBox(height: 15),

            pw.Text('■ 病情摘要(Summary)', style: ts(bold: true, sz: 11)),
            pw.SizedBox(height: 10),
            pw.Row(children: [
              pw.SizedBox(width: 45 * PdfPageFormat.mm, child: pw.Text('  1. 主訴(Chief Complaints)：', style: ts())),
              buildUnderline('', 120 * PdfPageFormat.mm),
            ]),
            pw.SizedBox(height: 15),

            pw.Text('  2. 生命徵象(Vital Signs)', style: ts(bold: true)),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10 * PdfPageFormat.mm, top: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.SizedBox(width: 35 * PdfPageFormat.mm, child: pw.Text('體溫(Temp)：', style: ts())), buildUnderline('', 30 * PdfPageFormat.mm), pw.Text(' ℃', style: ts()),
                    pw.SizedBox(width: 20 * PdfPageFormat.mm),
                    pw.SizedBox(width: 25 * PdfPageFormat.mm, child: pw.Text('脈搏(Pulse)：', style: ts())), buildUnderline('', 30 * PdfPageFormat.mm), pw.Text(' 次/min', style: ts()),
                  ]),
                  pw.SizedBox(height: 12),
                  pw.Row(children: [
                    pw.SizedBox(width: 35 * PdfPageFormat.mm, child: pw.Text('呼吸(Breath)：', style: ts())), buildUnderline('', 30 * PdfPageFormat.mm), pw.Text(' 次/min', style: ts()),
                    pw.SizedBox(width: 20 * PdfPageFormat.mm),
                    pw.SizedBox(width: 25 * PdfPageFormat.mm, child: pw.Text('血壓(BP)：', style: ts())), buildUnderline('', 45 * PdfPageFormat.mm), pw.Text(' mmHg', style: ts()),
                  ]),
                  pw.SizedBox(height: 12),
                  pw.Row(children: [
                    pw.SizedBox(width: 35 * PdfPageFormat.mm, child: pw.Text('意識(Cons)：', style: ts())),
                    buildCheckBox('Clear', false), buildCheckBox('GCS：', false),
                    pw.Text('(E', style: ts()), buildUnderline('', 12 * PdfPageFormat.mm),
                    pw.Text('V', style: ts()), buildUnderline('', 12 * PdfPageFormat.mm),
                    pw.Text('M', style: ts()), buildUnderline('', 12 * PdfPageFormat.mm), pw.Text(')', style: ts()),
                  ]),
                  pw.SizedBox(height: 12),
                  pw.Row(children: [
                    pw.SizedBox(width: 35 * PdfPageFormat.mm, child: pw.Text('瞳孔(Pupil)：', style: ts())),
                    pw.Text('R ', style: ts()), buildUnderline('', 25 * PdfPageFormat.mm),
                    pw.SizedBox(width: 15),
                    pw.Text('L ', style: ts()), buildUnderline('', 25 * PdfPageFormat.mm), pw.Text(' )', style: ts()),
                  ]),
                ],
              ),
            ),

            pw.SizedBox(height: 20),
            pw.Row(children: [
              pw.SizedBox(width: 45 * PdfPageFormat.mm, child: pw.Text('  3. 過去病史(History)：', style: ts())),
              buildUnderline('', 120 * PdfPageFormat.mm),
            ]),
            pw.SizedBox(height: 10),
            pw.Row(children: [
              pw.SizedBox(width: 45 * PdfPageFormat.mm, child: pw.Text('  藥物過敏(Allergy)：', style: ts())),
              buildCheckBox('無', false), buildCheckBox('有', false), buildUnderline('', 80 * PdfPageFormat.mm),
            ]),

            pw.SizedBox(height: 20),
            pw.Text('  4. 身體檢查(Physical Exam.)', style: ts(bold: true)),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10 * PdfPageFormat.mm, top: 10),
              child: pw.Column(children: [
                pw.Row(children: [
                  pw.Expanded(child: pw.Row(children: [pw.Text('頭頸(HEENT)：', style: ts()), buildUnderline('', 50 * PdfPageFormat.mm)])),
                  pw.Expanded(child: pw.Row(children: [pw.Text('胸部(Chest)：', style: ts()), buildUnderline('', 50 * PdfPageFormat.mm)])),
                ]),
                pw.SizedBox(height: 12),
                pw.Row(children: [
                  pw.Expanded(child: pw.Row(children: [pw.Text('腹部(Abdomen)：', style: ts()), buildUnderline('', 50 * PdfPageFormat.mm)])),
                  pw.Expanded(child: pw.Row(children: [pw.Text('四肢(Extremity)：', style: ts()), buildUnderline('', 50 * PdfPageFormat.mm)])),
                ]),
              ]),
            ),

            pw.SizedBox(height: 25),
            pw.Row(children: [
              pw.Text('■ 初步診斷(Tentative)：', style: ts(bold: true, sz: 11)),
              buildUnderline('', 130 * PdfPageFormat.mm),
            ]),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              pw.Text('■ 處理摘要(Summary)：', style: ts(bold: true, sz: 11)),
              buildCheckBox('簽四聯單', false), buildCheckBox('建議轉診', false),
            ]),

            pw.SizedBox(height: 20),
            pw.Align(alignment: pw.Alignment.centerRight, child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [pw.Text('醫師：', style: ts(bold: true, sz: 11)), buildUnderline('', 50 * PdfPageFormat.mm)]
            )),
            
            pw.SizedBox(height: 15),

            // ==========================================
            // 底部切結書區塊
            // ==========================================
            pw.Table(
              border: pw.TableBorder.all(color: tealColor, width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.8),
                1: const pw.FlexColumnWidth(1.2),
              },
              children: [
                pw.TableRow(
                  children: [
                    // 左半部：英文
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Statement/Consent of Test/Treatment/Hospital Referral Refusal', style: ts(bold: true, sz: 7)),
                          pw.SizedBox(height: 4),
                          pw.RichText(text: pw.TextSpan(style: ts(sz: 6), children: [
                            const pw.TextSpan(text: 'I (Name:'),
                            pw.WidgetSpan(child: buildInlineUnderline(35)),
                            const pw.TextSpan(text: ', Date of Birth: '),
                            pw.WidgetSpan(child: buildInlineUnderline(8)), const pw.TextSpan(text: '/'),
                            pw.WidgetSpan(child: buildInlineUnderline(8)), const pw.TextSpan(text: '/'),
                            pw.WidgetSpan(child: buildInlineUnderline(8)),
                            const pw.TextSpan(text: ', Passport /I.D. No: '),
                            pw.WidgetSpan(child: buildInlineUnderline(40)),
                            const pw.TextSpan(text: ') here by clarified that I / my family patient had been notified by Dr. '),
                            pw.WidgetSpan(child: buildInlineUnderline(30)),
                            const pw.TextSpan(text: ' of Landseed Medical Clinic at Taiwan Taoyuan Int\'l Airport, I am/my family patient is now in illness/necessary condition which needed to be transported to an advanced hospital facilities for further test & treatment. But under my/our personal status/consideration. I/we decided to handle this situation by myself/ourselves against any further medical advice I hereby signing this consent clarified that I am /& my family are willing to take all the risks &hold all the responsibilities of any consequences, even hazardous to my/my family member\'s health or life integrity unexpectedly.'),
                          ])),
                          pw.SizedBox(height: 10),
                          pw.Text('Signature: ____________________', style: ts(sz: 7)),
                          pw.Text('Date: ____________________', style: ts(sz: 7)),
                        ],
                      ),
                    ),
                    // 右半部：中文
pw.Container(
  padding: const pw.EdgeInsets.all(5),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(child: pw.Text('拒絕轉診治療切結書', style: ts(bold: true, sz: 8.5))),
      pw.SizedBox(height: 4),
      pw.RichText(
        text: pw.TextSpan(
          style: ts(sz: 6.8),
          children: [
            const pw.TextSpan(text: '本人'),
            pw.WidgetSpan(child: buildInlineUnderline(25)), // 縮短填寫名子空間
            const pw.TextSpan(text: '身分證字號'),
            pw.WidgetSpan(child: buildInlineUnderline(35)), // 縮短填寫證號空間
            const pw.TextSpan(text: '，\n'), // 加入逗號並強制換行
            pw.WidgetSpan(child: buildInlineUnderline(12)),
            const pw.TextSpan(text: '年'),
            pw.WidgetSpan(child: buildInlineUnderline(10)),
            const pw.TextSpan(text: '月'),
            pw.WidgetSpan(child: buildInlineUnderline(10)),
            const pw.TextSpan(text: '日於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心醫師'),
            pw.WidgetSpan(child: buildInlineUnderline(35)),
            const pw.TextSpan(
              text: '診視，醫師建議轉診至醫院繼續治療，但本人因個人因素拒絕醫師「繼續治療」之建議，致生一切後果願自行負責，與聯新國際醫院桃園國際機場醫療中心無涉。',
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text('立切結書人: ________________', style: ts(sz: 7)),
      pw.Text('身分證字號: ________________', style: ts(sz: 7)),
      pw.Text('與病患關係: ________________', style: ts(sz: 7)),
      pw.SizedBox(height: 4),
      pw.Text('住址: ________________________', style: ts(sz: 6.5)),
      pw.Text('電話: ________________', style: ts(sz: 7)),
    ],
  ),
),
                  ],
                ),
              ],
            ),

            pw.Spacer(),
            pw.Center(child: pw.Text('第 2 頁', style: ts(sz: 8))),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('51-P-002-001', style: ts(sz: 7)),
              pw.Text('聯新[A431]2021/11x500 張', style: ts(sz: 7)),
            ]),
          ],
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}