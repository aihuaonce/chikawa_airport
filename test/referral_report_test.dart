import 'package:chikawa_airport/homepage/reports/referral_report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('buildReferralReportPdf returns a non-empty PDF', () async {
    final data = ReferralReportData()
      ..name = '王小明'
      ..gender = '男'
      ..birthYear = '1990'
      ..birthMonth = '07'
      ..birthDay = '15'
      ..idNo = 'A123456789'
      ..contact = '王大明'
      ..contactPhone = '0912345678'
      ..contactAddress = '桃園市大園區航站南路9號機場醫護中心轉診室';

    final pdfBytes = await buildReferralReportPdf(data);

    expect(pdfBytes, isNotEmpty);
    expect(String.fromCharCodes(pdfBytes.take(4)), equals('%PDF'));
  });
}
