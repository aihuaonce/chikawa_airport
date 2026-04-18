import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MedicalServiceHealthAssessmentEntry {
  final String name;
  final String relation;
  final String temperature;

  const MedicalServiceHealthAssessmentEntry({
    this.name = '',
    this.relation = '',
    this.temperature = '',
  });
}

class MedicalServiceApplicationData {
  final bool isCrew;
  final bool isPassenger;
  final bool isStaff;
  final bool isOtherVisitReason;
  final String otherVisitReason;
  final String patientName;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final bool isMale;
  final bool isFemale;
  final String idOrPassportNo;
  final String nationality;
  final String airline;
  final String flightNo;
  final bool isArrival;
  final bool isTransfer;
  final bool isDeparture;
  final bool isOtherTravelStatus;
  final String otherTravelStatus;
  final String dateYear;
  final String dateMonth;
  final String dateDay;
  final String address;
  final String telephone;
  final bool departureIsTpe;
  final String departureLocation;
  final bool transitIsTpe;
  final String transitLocation;
  final bool destinationIsTpe;
  final String destinationLocation;
  final bool beforeLanding;
  final String landingTime;
  final String notificationTime;
  final String notificationReporter;
  final String notificationPhone;
  final String notificationToOccTime;
  final bool occArrived;
  final bool occNotArrived;
  final bool incidentAtT1;
  final String incidentT1Detail;
  final bool incidentAtT2;
  final String incidentT2Detail;
  final String incidentOtherLocation;
  final String medicalArrivalTime;
  final bool arrivedWithin10Minutes;
  final bool notArrivedWithin10Minutes;
  final String delayedReason;
  final String examinationTime;
  final bool cdcScreening;
  final bool assistSampling;
  final bool throatSampling;
  final bool bloodSampling;
  final bool otherSampling;
  final String otherSamplingDetail;
  final bool healthAssessment;
  final List<MedicalServiceHealthAssessmentEntry> healthAssessments;
  final bool generalClearance;
  final bool emergencyClearance;
  final bool emergencyPublicGate;
  final bool emergencyApron;
  final bool ambulanceClinic;
  final String ambulanceClinicDetail;
  final bool ambulancePrivate;
  final String ambulancePrivateDetail;
  final bool ambulanceFireDepartment;
  final String ambulanceFireDepartmentDetail;
  final String transferHospital;
  final String escortStaff;
  final String outreachFee;
  final String ambulanceFee;
  final bool selfPay;
  final String selfPayAmount;
  final bool unifiedBilling;
  final String unifiedBillingAmount;
  final bool payByCash;
  final bool payInTwd;
  final bool payInOtherCurrency;
  final String otherCurrency;
  final bool payByCard;
  final bool abnormalCharge;
  final String abnormalReason;
  final String applicantName;
  final String applicantUnit;
  final String applicantPhone;
  final String chiefComplaint;
  final String temperature;
  final String pulse;
  final String breath;
  final String bloodPressure;
  final String spo2;
  final bool consciousnessClear;
  final bool consciousnessGcs;
  final String gcsE;
  final String gcsV;
  final String gcsM;
  final String pupilRight;
  final String pupilLeft;
  final String history;
  final bool allergyNone;
  final bool allergyHas;
  final String allergyDetail;
  final String heent;
  final String chest;
  final String abdomen;
  final String extremity;
  final String tentativeDiagnosis;
  final bool signedFourCopy;
  final bool advisedReferral;
  final String doctorName;
  final String nurseName;
  final String emtName;
  final String refusalSignatoryName;
  final String refusalSignatoryIdNo;
  final String refusalRelationship;
  final String refusalAddress;
  final String refusalPhone;
  final String refusalDateYear;
  final String refusalDateMonth;
  final String refusalDateDay;
  final Uint8List? chargeConsentSignature;
  final Uint8List? chargeWitnessSignature;
  final Uint8List? referralConsentSignature;
  final Uint8List? referralWitnessSignature;
  final bool hasRefusal; // 是否有拒絕轉診

  const MedicalServiceApplicationData({
    this.isCrew = false,
    this.isPassenger = false,
    this.isStaff = false,
    this.isOtherVisitReason = false,
    this.otherVisitReason = '',
    this.patientName = '',
    this.birthYear = '',
    this.birthMonth = '',
    this.birthDay = '',
    this.isMale = false,
    this.isFemale = false,
    this.idOrPassportNo = '',
    this.nationality = '',
    this.airline = '',
    this.flightNo = '',
    this.isArrival = false,
    this.isTransfer = false,
    this.isDeparture = false,
    this.isOtherTravelStatus = false,
    this.otherTravelStatus = '',
    this.dateYear = '',
    this.dateMonth = '',
    this.dateDay = '',
    this.address = '',
    this.telephone = '',
    this.departureIsTpe = false,
    this.departureLocation = '',
    this.transitIsTpe = false,
    this.transitLocation = '',
    this.destinationIsTpe = false,
    this.destinationLocation = '',
    this.beforeLanding = false,
    this.landingTime = '',
    this.notificationTime = '',
    this.notificationReporter = '',
    this.notificationPhone = '',
    this.notificationToOccTime = '',
    this.occArrived = false,
    this.occNotArrived = false,
    this.incidentAtT1 = false,
    this.incidentT1Detail = '',
    this.incidentAtT2 = false,
    this.incidentT2Detail = '',
    this.incidentOtherLocation = '',
    this.medicalArrivalTime = '',
    this.arrivedWithin10Minutes = false,
    this.notArrivedWithin10Minutes = false,
    this.delayedReason = '',
    this.examinationTime = '',
    this.cdcScreening = false,
    this.assistSampling = false,
    this.throatSampling = false,
    this.bloodSampling = false,
    this.otherSampling = false,
    this.otherSamplingDetail = '',
    this.healthAssessment = false,
    this.healthAssessments = const [],
    this.generalClearance = false,
    this.emergencyClearance = false,
    this.emergencyPublicGate = false,
    this.emergencyApron = false,
    this.ambulanceClinic = false,
    this.ambulanceClinicDetail = '',
    this.ambulancePrivate = false,
    this.ambulancePrivateDetail = '',
    this.ambulanceFireDepartment = false,
    this.ambulanceFireDepartmentDetail = '',
    this.transferHospital = '',
    this.escortStaff = '',
    this.outreachFee = '',
    this.ambulanceFee = '',
    this.selfPay = false,
    this.selfPayAmount = '',
    this.unifiedBilling = false,
    this.unifiedBillingAmount = '',
    this.payByCash = false,
    this.payInTwd = false,
    this.payInOtherCurrency = false,
    this.otherCurrency = '',
    this.payByCard = false,
    this.abnormalCharge = false,
    this.abnormalReason = '',
    this.applicantName = '',
    this.applicantUnit = '',
    this.applicantPhone = '',
    this.chiefComplaint = '',
    this.temperature = '',
    this.pulse = '',
    this.breath = '',
    this.bloodPressure = '',
    this.spo2 = '',
    this.consciousnessClear = false,
    this.consciousnessGcs = false,
    this.gcsE = '',
    this.gcsV = '',
    this.gcsM = '',
    this.pupilRight = '',
    this.pupilLeft = '',
    this.history = '',
    this.allergyNone = false,
    this.allergyHas = false,
    this.allergyDetail = '',
    this.heent = '',
    this.chest = '',
    this.abdomen = '',
    this.extremity = '',
    this.tentativeDiagnosis = '',
    this.signedFourCopy = false,
    this.advisedReferral = false,
    this.doctorName = '',
    this.nurseName = '',
    this.emtName = '',
    this.refusalSignatoryName = '',
    this.refusalSignatoryIdNo = '',
    this.refusalRelationship = '',
    this.refusalAddress = '',
    this.refusalPhone = '',
    this.refusalDateYear = '',
    this.refusalDateMonth = '',
    this.refusalDateDay = '',
    this.chargeConsentSignature,
    this.chargeWitnessSignature,
    this.referralConsentSignature,
    this.referralWitnessSignature,
    this.hasRefusal = false,
  });
}

Future<Uint8List> buildMedicalServiceApplicationPdf(
  MedicalServiceApplicationData d,
) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.notoSansTCRegular();
  final fontB = await PdfGoogleFonts.notoSansTCBold();

  final tealColor = PdfColor.fromInt(0xFF007A7A);
  final black = PdfColors.black;

  pw.TextStyle ts({double sz = 9, bool bold = false, PdfColor? color}) =>
      pw.TextStyle(
        font: bold ? fontB : font,
        fontSize: sz,
        color: color ?? black,
        lineSpacing: 3.5,
      );

  pw.Widget buildCheckBox(String label, bool checked, {double sz = 8.5}) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 8.5,
          height: 8.5,
          decoration: checked
              ? pw.BoxDecoration(color: PdfColors.black)
              : pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
        ),
        if (label.isNotEmpty) pw.SizedBox(width: 4),
        if (label.isNotEmpty) pw.Text(label, style: ts(sz: sz)),
        pw.SizedBox(width: 8),
      ],
    );
  }

  pw.Widget buildUnderline(String text, double width, {double sz = 7.5}) {
    return pw.Container(
      width: width,
      height: sz + 4,
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
        ),
      ),
      padding: const pw.EdgeInsets.only(left: 2, bottom: 0.5),
      alignment: pw.Alignment.bottomLeft,
      child: pw.Text(
        text,
        style: ts(sz: sz),
        textAlign: pw.TextAlign.left,
      ),
    );
  }

  pw.Widget buildSectionTitle(String title, String english) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 6, bottom: 3),
      child: pw.Row(
        children: [
          pw.Text(title, style: ts(sz: 10.5, bold: true, color: tealColor)),
          pw.SizedBox(width: 5),
          pw.Text(
            '($english)',
            style: ts(sz: 10, bold: true, color: tealColor),
          ),
        ],
      ),
    );
  }

  // 簽名框 helper
  pw.Widget buildSignatureBox(Uint8List? data, {double height = 45}) {
    return pw.Container(
      height: height,
      alignment: pw.Alignment.center,
      child: data != null && data.isNotEmpty
          ? pw.Image(pw.MemoryImage(data), fit: pw.BoxFit.contain)
          : pw.SizedBox(),
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(8 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    '聯新國際醫院桃園國際機場醫療中心─緊急醫療救護申請單',
                    style: ts(sz: 14, bold: true, color: tealColor),
                  ),
                  pw.Text(
                    'Landseed Medical Clinic at Taiwan Taoyuan Int\'l Airport Passenger Medical Service Application Form',
                    style: ts(sz: 9, bold: true, color: tealColor),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 4),

            buildSectionTitle('基本資料', 'Personal Data'),
            pw.Row(
              children: [
                buildCheckBox('組員(Crew)', d.isCrew),
                buildCheckBox('旅客', d.isPassenger),
                buildCheckBox('員工', d.isStaff),
                buildCheckBox('其他：', d.isOtherVisitReason),
                buildUnderline(d.otherVisitReason, 60),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('病人姓名(Name)：', style: ts()),
                buildUnderline(d.patientName, 80),
                pw.SizedBox(width: 15),
                pw.Text('生日(Date of Birth)：', style: ts()),
                buildUnderline(d.birthYear, 25),
                pw.Text('(Y)/', style: ts()),
                buildUnderline(d.birthMonth, 15),
                pw.Text('(M)/', style: ts()),
                buildUnderline(d.birthDay, 15),
                pw.Text('(D)', style: ts()),

                pw.SizedBox(width: 25),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    buildCheckBox('男(Male)', d.isMale, sz: 9),
                    pw.SizedBox(height: 2),
                    buildCheckBox('女(Female)', d.isFemale, sz: 9),
                  ],
                ),

                pw.SizedBox(width: 25),
                pw.Text(
                  '日期(Date)：${d.dateYear} / ${d.dateMonth} / ${d.dateDay}\n西元 年(Y)月(M)日(D)',
                  style: ts(sz: 7),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('I.D. No(Passport No.)：', style: ts()),
                buildUnderline(d.idOrPassportNo, 60),
                pw.SizedBox(width: 10),
                pw.Text('國籍(Nationality)：', style: ts()),
                buildUnderline(d.nationality, 100),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('航空公司(Airline)：', style: ts()),
                buildUnderline(d.airline, 70),
                pw.SizedBox(width: 10),
                pw.Text('班機(Flight No)：', style: ts()),
                buildUnderline(d.flightNo, 60),
                pw.SizedBox(width: 15),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        buildCheckBox('入境(Arrival)', d.isArrival, sz: 8),
                        buildCheckBox('過境(Transfer)', d.isTransfer, sz: 8),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        buildCheckBox('出境(Departure)', d.isDeparture, sz: 8),
                        buildCheckBox(
                          '其他(others)：',
                          d.isOtherTravelStatus,
                          sz: 8,
                        ),
                        buildUnderline(d.otherTravelStatus, 40),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('地址(Address)：', style: ts()),
                buildUnderline(d.address, 200),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('聯絡電話(Telephone)：', style: ts()),
                buildUnderline(d.telephone, 80),
              ],
            ),

            pw.SizedBox(height: 4),
            ...['出發地', '經過地', '目的地']
                .map(
                  (label) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Row(
                      children: [
                        pw.Container(
                          width: 40,
                          child: pw.Text('$label：', style: ts()),
                        ),
                        buildCheckBox(
                          '台灣 TPE',
                          label == '出發地'
                              ? d.departureIsTpe
                              : label == '經過地'
                              ? d.transitIsTpe
                              : d.destinationIsTpe,
                        ),
                        buildCheckBox(
                          '',
                          label == '出發地'
                              ? !d.departureIsTpe &&
                                    d.departureLocation.isNotEmpty
                              : label == '經過地'
                              ? !d.transitIsTpe && d.transitLocation.isNotEmpty
                              : !d.destinationIsTpe &&
                                    d.destinationLocation.isNotEmpty,
                        ),
                        buildUnderline(
                          label == '出發地'
                              ? d.departureLocation
                              : label == '經過地'
                              ? d.transitLocation
                              : d.destinationLocation,
                          120,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),

            buildSectionTitle('通報作業', 'Notification'),
            pw.Row(
              children: [
                buildCheckBox('落地前通知，落地時間：', d.beforeLanding),
                buildUnderline(d.landingTime, 40),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('通報時間：', style: ts()),
                buildUnderline(d.notificationTime, 40),
                pw.SizedBox(width: 8),
                pw.Text('通報單位/人員：', style: ts()),
                buildUnderline(d.notificationReporter, 90),
                pw.SizedBox(width: 8),
                pw.Text('電話：', style: ts()),
                buildUnderline(d.notificationPhone, 70),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('通知營安處時間：', style: ts()),
                buildUnderline(d.notificationToOccTime, 40),
                pw.Text('，到達現場：', style: ts()),
                buildCheckBox('有', d.occArrived),
                buildCheckBox('無', d.occNotArrived),
              ],
            ),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('通報事故地點：', style: ts()),
                pw.SizedBox(width: 4),
                buildCheckBox('T1', d.incidentAtT1),
                pw.SizedBox(width: 2),
                buildUnderline(d.incidentT1Detail, 70),
                pw.SizedBox(width: 8),
                buildCheckBox('T2', d.incidentAtT2),
                pw.SizedBox(width: 2),
                buildUnderline(d.incidentT2Detail, 70),
              ],
            ),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(width: 72),
                pw.Text('其他：', style: ts()),
                pw.SizedBox(width: 2),
                buildUnderline(d.incidentOtherLocation, 100),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              children: [
                pw.Text('醫護抵達時間：', style: ts()),
                buildUnderline(d.medicalArrivalTime, 40),
                pw.Text(' 10分鐘內到達：', style: ts()),
                buildCheckBox('是', d.arrivedWithin10Minutes),
                buildCheckBox('否', d.notArrivedWithin10Minutes),
                pw.Text('，原因：', style: ts()),
                buildUnderline(d.delayedReason, 80),
                pw.Text('檢查時間：', style: ts()),
                buildUnderline(d.examinationTime, 40),
              ],
            ),

            buildSectionTitle('醫療收費', 'Medical Charge'),
            pw.Text('■ 疾病管制署篩檢', style: ts(sz: 9.5, bold: true)),
            pw.SizedBox(height: 3),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      buildCheckBox('協助採檢', d.assistSampling),
                      pw.Row(
                        children: [
                          pw.SizedBox(width: 15),
                          buildCheckBox('喉頭採檢', d.throatSampling),
                          buildCheckBox('抽血檢驗', d.bloodSampling),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.SizedBox(width: 15),
                          buildCheckBox('其他：', d.otherSampling),
                          buildUnderline(d.otherSamplingDetail, 60),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 25),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    buildCheckBox('健康評估', d.healthAssessment),
                    pw.Text(
                      '  1.姓名：${d.healthAssessments.isNotEmpty ? d.healthAssessments[0].name : ''} /關係：${d.healthAssessments.isNotEmpty ? d.healthAssessments[0].relation : ''} /體溫：${d.healthAssessments.isNotEmpty ? d.healthAssessments[0].temperature : ''}℃',
                      style: ts(),
                    ),
                    pw.Text(
                      '  2.姓名：${d.healthAssessments.length > 1 ? d.healthAssessments[1].name : ''} /關係：${d.healthAssessments.length > 1 ? d.healthAssessments[1].relation : ''} /體溫：${d.healthAssessments.length > 1 ? d.healthAssessments[1].temperature : ''}℃',
                      style: ts(),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 3),
            pw.Text('■ 轉診後送', style: ts(sz: 9.5, bold: true)),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 15),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      buildCheckBox('一般通關', d.generalClearance),
                      buildCheckBox('緊急通關 (', d.emergencyClearance),
                      buildCheckBox('公務門', d.emergencyPublicGate),
                      buildCheckBox('機坪)', d.emergencyApron),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('救護車：', style: ts()),
                      buildCheckBox('醫療中心：', d.ambulanceClinic),
                      buildUnderline(d.ambulanceClinicDetail, 40),
                      buildCheckBox('民間：', d.ambulancePrivate),
                      buildUnderline(d.ambulancePrivateDetail, 40),
                      buildCheckBox('消防隊：', d.ambulanceFireDepartment),
                      buildUnderline(d.ambulanceFireDepartmentDetail, 40),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('轉送醫院：', style: ts()),
                      buildUnderline(d.transferHospital, 130),
                      pw.SizedBox(width: 15),
                      pw.Text('隨車人員：', style: ts()),
                      buildUnderline(d.escortStaff, 80),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 3),
            pw.Text('■ 醫療費用', style: ts(sz: 9.5, bold: true)),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 15),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Text('出診費(Outreach)：', style: ts()),
                      buildUnderline(d.outreachFee, 80),
                      pw.SizedBox(width: 10),
                      pw.Text('救護車費用(Ambulance)：', style: ts()),
                      buildUnderline(d.ambulanceFee, 120),
                    ],
                  ),
                  pw.Row(
                    children: [
                      buildCheckBox('自付(Total)：', d.selfPay),
                      buildUnderline(d.selfPayAmount, 80),
                      pw.SizedBox(width: 20),
                      buildCheckBox('請款費用：', d.unifiedBilling),
                      buildUnderline(d.unifiedBillingAmount, 80),
                    ],
                  ),
                ],
              ),
            ),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // --- 左側：自付 ---
                pw.Expanded(
                  flex: 52,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('■ 自付', style: ts(sz: 9.5, bold: true)),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 12),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            buildCheckBox('現金', d.payByCash),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 12),
                              child: pw.Row(
                                children: [
                                  buildCheckBox('台幣', d.payInTwd, sz: 7.5),
                                  buildCheckBox(
                                    '其他：',
                                    d.payInOtherCurrency,
                                    sz: 7.5,
                                  ),
                                  buildUnderline(d.otherCurrency, 22),
                                  pw.SizedBox(width: 4),
                                  pw.Text(
                                    '(兌換後=台幣：__________)',
                                    style: ts(sz: 6),
                                  ),
                                ],
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Row(
                              children: [
                                buildCheckBox('刷卡', d.payByCard, sz: 7.5),
                                buildCheckBox(
                                  '收費異常，原因：',
                                  d.abnormalCharge,
                                  sz: 7.5,
                                ),
                                buildUnderline(d.abnormalReason, 50),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(width: 10),
                // --- 右側：統一請款 ---
                pw.Expanded(
                  flex: 48,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('■ 統一請款', style: ts(sz: 9.5, bold: true)),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, top: 2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // 第一列
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.SizedBox(
                                  width: 32 * PdfPageFormat.mm,
                                  child: pw.Text(
                                    '申請人(Applicant)：',
                                    style: ts(sz: 7.5),
                                  ),
                                ),
                                buildUnderline(d.applicantName, 45),
                              ],
                            ),
                            pw.SizedBox(height: 1),
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.SizedBox(
                                  width: 32 * PdfPageFormat.mm,
                                  child: pw.Text(
                                    '申請單位(Department)：',
                                    style: ts(sz: 7.5),
                                  ),
                                ),
                                buildUnderline(d.applicantUnit, 45),
                              ],
                            ),
                            pw.SizedBox(height: 1),
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.SizedBox(
                                  width: 32 * PdfPageFormat.mm,
                                  child: pw.Text(
                                    '聯絡電話(Telephone)：',
                                    style: ts(sz: 7.5),
                                  ),
                                ),
                                buildUnderline(d.applicantPhone, 45),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: tealColor, width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '內容',
                        style: ts(bold: true, color: tealColor),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '同意人簽名/身分',
                        style: ts(bold: true, color: tealColor),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '見證人簽名/身分',
                        style: ts(bold: true, color: tealColor),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '瞭解醫護人員說明當醫療收費之原由且同意\nUnderstand the medical charge and agree to it',
                        style: ts(),
                      ),
                    ),
                    buildSignatureBox(d.chargeConsentSignature),
                    buildSignatureBox(d.chargeWitnessSignature),
                  ],
                ),
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '我同意轉診至：___________醫院接受診療，且同意醫療中心安排之救護車前往並付費\nI agree to be referred to the hospital for diagnosis and treatment, and I agree to the ambulance arranged by the clinic to go and pay.',
                        style: ts(),
                      ),
                    ),
                    buildSignatureBox(d.referralConsentSignature, height: 45),
                    buildSignatureBox(d.referralWitnessSignature, height: 45),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  '醫師：${d.doctorName.isEmpty ? "____________________" : d.doctorName}',
                  style: ts(),
                ),
                pw.Text(
                  '護理師：${d.nurseName.isEmpty ? "____________________" : d.nurseName}',
                  style: ts(),
                ),
                pw.Text(
                  'EMT：${d.emtName.isEmpty ? "____________________" : d.emtName}',
                  style: ts(),
                ),
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

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(8 * PdfPageFormat.mm),
      build: (ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '醫療紀錄(Medical Record)',
              style: ts(sz: 13, bold: true, color: tealColor),
            ),
            pw.SizedBox(height: 15),

            pw.Text('■ 病情摘要(Summary)：', style: ts(bold: true, sz: 11)),
            pw.SizedBox(height: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('  1. 主訴(Chief Complaints)：', style: ts(bold: true)),

                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.only(left: 15, top: 5),
                  constraints: const pw.BoxConstraints(minHeight: 30),
                  child: pw.Text(d.chiefComplaint, style: ts()),
                ),
              ],
            ),
            pw.SizedBox(height: 10),

            pw.Text('  2. 生命徵象(Vital Signs)：', style: ts(bold: true)),
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                left: 10 * PdfPageFormat.mm,
                top: 6,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 75 * PdfPageFormat.mm,
                        child: pw.Row(
                          children: [
                            pw.SizedBox(
                              width: 36 * PdfPageFormat.mm,
                              child: pw.Text('體溫(Temperature)：', style: ts()),
                            ),
                            buildUnderline(
                              d.temperature,
                              20 * PdfPageFormat.mm,
                            ),
                            pw.Text(' ℃', style: ts()),
                          ],
                        ),
                      ),
                      pw.SizedBox(
                        width: 45 * PdfPageFormat.mm,
                        child: pw.Text('脈搏(Pulse)：', style: ts()),
                      ),
                      buildUnderline(d.pulse, 25 * PdfPageFormat.mm),
                      pw.Text(' 次/min', style: ts()),
                    ],
                  ),
                  pw.SizedBox(height: 8),

                  pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 75 * PdfPageFormat.mm,
                        child: pw.Row(
                          children: [
                            pw.SizedBox(
                              width: 36 * PdfPageFormat.mm,
                              child: pw.Text('呼吸(Breath)：', style: ts()),
                            ),
                            buildUnderline(d.breath, 20 * PdfPageFormat.mm),
                            pw.Text(' 次/min', style: ts()),
                          ],
                        ),
                      ),
                      pw.SizedBox(
                        width: 45 * PdfPageFormat.mm,
                        child: pw.Text('血壓(Blood Pressure)：', style: ts()),
                      ),
                      buildUnderline(d.bloodPressure, 25 * PdfPageFormat.mm),
                      pw.Text(' mmHg', style: ts()),
                    ],
                  ),
                  pw.SizedBox(height: 8),

                  pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 75 * PdfPageFormat.mm,
                        child: pw.Row(
                          children: [
                            pw.SizedBox(
                              width: 36 * PdfPageFormat.mm,
                              child: pw.Text('血氧(SpO2)：', style: ts()),
                            ),
                            buildUnderline(d.spo2, 20 * PdfPageFormat.mm),
                            pw.Text(' %', style: ts()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),

                  pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 42 * PdfPageFormat.mm,
                        child: pw.Text('意識(Consciousness)：', style: ts()),
                      ),
                      buildCheckBox('Clear', d.consciousnessClear),
                      buildCheckBox('GCS：', d.consciousnessGcs),
                      pw.Text('(E：', style: ts()),
                      buildUnderline(d.gcsE, 8 * PdfPageFormat.mm),
                      pw.Text('V：', style: ts()),
                      buildUnderline(d.gcsV, 8 * PdfPageFormat.mm),
                      pw.Text('M：', style: ts()),
                      buildUnderline(d.gcsM, 8 * PdfPageFormat.mm),
                      pw.Text(') ', style: ts()),

                      pw.SizedBox(width: 5 * PdfPageFormat.mm),

                      pw.Text('Pupil Reaction (R：', style: ts()),
                      buildUnderline(d.pupilRight, 10 * PdfPageFormat.mm),
                      pw.Text(' L：', style: ts()),
                      buildUnderline(d.pupilLeft, 10 * PdfPageFormat.mm),
                      pw.Text(')', style: ts()),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),
            pw.Row(
              children: [
                pw.SizedBox(
                  width: 45 * PdfPageFormat.mm,
                  child: pw.Text('  3. 過去病史(History)：', style: ts(bold: true)),
                ),
                buildUnderline(d.history, 120 * PdfPageFormat.mm),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10 * PdfPageFormat.mm),
              child: pw.Row(
                children: [
                  pw.SizedBox(
                    width: 35 * PdfPageFormat.mm,
                    child: pw.Text('藥物過敏(Allergy)：', style: ts()),
                  ),
                  buildCheckBox('無', d.allergyNone),
                  buildCheckBox('有：', d.allergyHas),
                  buildUnderline(d.allergyDetail, 80 * PdfPageFormat.mm),
                ],
              ),
            ),

            pw.SizedBox(height: 20),
            pw.Text('  4. 身體檢查(Physical Exam.)：', style: ts(bold: true)),
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                left: 10 * PdfPageFormat.mm,
                top: 10,
              ),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Text('頭頸(HEENT)：', style: ts()),
                            buildUnderline(d.heent, 50 * PdfPageFormat.mm),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Text('胸部(Chest)：', style: ts()),
                            buildUnderline(d.chest, 50 * PdfPageFormat.mm),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Text('腹部(Abdomen)：', style: ts()),
                            buildUnderline(d.abdomen, 50 * PdfPageFormat.mm),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Text('四肢(Extremity)：', style: ts()),
                            buildUnderline(d.extremity, 50 * PdfPageFormat.mm),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 25),
            pw.Row(
              children: [
                pw.Text('■ 初步診斷(Tentative)：', style: ts(bold: true, sz: 11)),
                buildUnderline(
                  d.tentativeDiagnosis,
                  120 * PdfPageFormat.mm,
                  sz: 11,
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            pw.Row(
              children: [
                pw.Text('■ 處理摘要(Summary)：', style: ts(bold: true, sz: 11)),
                buildCheckBox('簽四聯單', d.signedFourCopy, sz: 11),
                buildCheckBox('建議轉診', d.advisedReferral, sz: 11),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('醫師：', style: ts(bold: true, sz: 11)),
                  buildUnderline(d.doctorName, 50 * PdfPageFormat.mm, sz: 11),
                ],
              ),
            ),
            pw.SizedBox(height: 15),

            // --- 底部切結書區塊 (僅在拒絕轉診時顯示) ---
            if (d.hasRefusal) ...[
              pw.Table(
                border: pw.TableBorder.all(color: tealColor, width: 0.8),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.1),
                  1: const pw.FlexColumnWidth(0.9),
                },
                children: [
                  pw.TableRow(
                    children: [
                      // ================= 左半部：英文  =================
                      pw.Container(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Statement/Consent of Test/Treatment/Hospital Referral Refusal',
                              style: ts(bold: true, sz: 8),
                            ),
                            pw.SizedBox(height: 5),
                            pw.RichText(
                              textAlign: pw.TextAlign.justify,
                              text: pw.TextSpan(
                                style: ts(sz: 7.5),
                                children: [
                                  const pw.TextSpan(text: 'I (Name: '),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.patientName,
                                      30 * PdfPageFormat.mm,
                                      sz: 7.5,
                                    ),
                                  ),
                                  const pw.TextSpan(text: ', Date of Birth: '),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.birthYear,
                                      8 * PdfPageFormat.mm,
                                      sz: 7.5,
                                    ),
                                  ),
                                  const pw.TextSpan(text: '/'),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.birthMonth,
                                      6 * PdfPageFormat.mm,
                                      sz: 7.5,
                                    ),
                                  ),
                                  const pw.TextSpan(text: '/'),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.birthDay,
                                      6 * PdfPageFormat.mm,
                                      sz: 7.5,
                                    ),
                                  ),
                                  const pw.TextSpan(
                                    text: ', Passport /I.D. No: ',
                                  ),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.idOrPassportNo,
                                      30 * PdfPageFormat.mm,
                                      sz: 7.5,
                                    ),
                                  ),
                                  const pw.TextSpan(
                                    text:
                                        ') here by clarified that I/my family patient had been notified by Dr. ',
                                  ),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.doctorName,
                                      25 * PdfPageFormat.mm,
                                      sz: 7.5,
                                    ),
                                  ),
                                  const pw.TextSpan(
                                    text:
                                        ' of Landseed Medical Clinic at Taiwan Taoyuan Int\'l Airport, I am/my family patient is now in illness/necessary condition which needed to be transported to an advanced hospital facilities for further test & treatment. But under my/our personal status/consideration. I/we decided to handle this situation by myself/ourselves against any further medical advice I hereby signing this consent clarified that I am /& my family are willing to take all the risks &hold all the responsibilities of any consequences, even hazardous to my/my family member\'s health or life integrity unexpectedly.',
                                  ),
                                ],
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Row(
                              children: [
                                pw.Text('Signature：', style: ts(sz: 8)),
                                buildUnderline(
                                  d.refusalSignatoryName,
                                  45 * PdfPageFormat.mm,
                                  sz: 8,
                                ),
                              ],
                            ),
                            pw.Text(
                              'Date：${d.refusalDateYear}/${d.refusalDateMonth}/${d.refusalDateDay}',
                              style: ts(sz: 8),
                            ),
                          ],
                        ),
                      ),

                      // ================= 右半部：中文  =================
                      pw.Container(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Center(
                              child: pw.Text(
                                '拒絕轉診治療切結書',
                                style: ts(bold: true, sz: 10),
                              ),
                            ),
                            pw.SizedBox(height: 8),

                            pw.Row(
                              children: [
                                pw.Text('本人 ', style: ts(sz: 8)),
                                buildUnderline(
                                  d.patientName,
                                  25 * PdfPageFormat.mm,
                                  sz: 8,
                                ),
                                pw.Text(' 身分證字號 ', style: ts(sz: 8)),
                                buildUnderline(
                                  d.idOrPassportNo,
                                  30 * PdfPageFormat.mm,
                                  sz: 8,
                                ),
                                pw.Text('，', style: ts(sz: 8)),
                              ],
                            ),

                            pw.SizedBox(height: 4),
                            pw.RichText(
                              text: pw.TextSpan(
                                style: ts(sz: 8),
                                children: [
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.refusalDateYear,
                                      10 * PdfPageFormat.mm,
                                      sz: 8,
                                    ),
                                  ),
                                  const pw.TextSpan(text: ' 年 '),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.refusalDateMonth,
                                      7 * PdfPageFormat.mm,
                                      sz: 8,
                                    ),
                                  ),
                                  const pw.TextSpan(text: ' 月 '),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.refusalDateDay,
                                      7 * PdfPageFormat.mm,
                                      sz: 8,
                                    ),
                                  ),
                                  const pw.TextSpan(
                                    text: ' 日於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心 ',
                                  ),
                                  pw.WidgetSpan(
                                    child: buildUnderline(
                                      d.doctorName,
                                      20 * PdfPageFormat.mm,
                                      sz: 8,
                                    ),
                                  ),
                                  const pw.TextSpan(
                                    text:
                                        ' 醫師 診視，醫師建議轉診至醫院繼續治療，但本人因個人因素拒絕醫師「繼續治療」之建議，致生一切後果願自行負責，與聯新國際醫院桃園國際機場醫療中心無涉。',
                                  ),
                                ],
                              ),
                            ),

                            pw.SizedBox(height: 12),

                            pw.Row(
                              children: [
                                pw.Text('立切結書人：', style: ts(sz: 7.5)),
                                buildUnderline(
                                  d.refusalSignatoryName,
                                  35 * PdfPageFormat.mm,
                                  sz: 7.5,
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text('身分證字號：', style: ts(sz: 7.5)),
                                buildUnderline(
                                  d.refusalSignatoryIdNo,
                                  35 * PdfPageFormat.mm,
                                  sz: 7.5,
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text('與病患關係：', style: ts(sz: 7.5)),
                                buildUnderline(
                                  d.refusalRelationship,
                                  35 * PdfPageFormat.mm,
                                  sz: 7.5,
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text('住址：', style: ts(sz: 7.5)),
                                buildUnderline(
                                  d.refusalAddress,
                                  55 * PdfPageFormat.mm,
                                  sz: 7.5,
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text('電話：', style: ts(sz: 7.5)),
                                buildUnderline(
                                  d.refusalPhone,
                                  35 * PdfPageFormat.mm,
                                  sz: 7.5,
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

              pw.Spacer(),
              pw.Center(child: pw.Text('第 2 頁', style: ts(sz: 8))),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('51-P-002-001', style: ts(sz: 7)),
                  pw.Text('聯新[A431]2021/11x500 張', style: ts(sz: 7)),
                ],
              ),
            ],
          ],
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
