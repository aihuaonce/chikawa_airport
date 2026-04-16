import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_tables.dart';

part 'certificate_dao.g.dart';

@DriftAccessor(tables: [MedicalCertificates])
class CertificateDao extends DatabaseAccessor<AppDatabase>
    with _$CertificateDaoMixin {
  CertificateDao(super.db);

  // 根據 medicalId 取得診斷證明書
  Future<MedicalCertificateData?> getCertificateByMedicalId(int medicalId) {
    return (select(
      medicalCertificates,
    )..where((c) => c.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 建立新的診斷證明書
  Future<int> createCertificate(int medicalId) {
    return into(medicalCertificates).insert(
      MedicalCertificatesCompanion.insert(
        medicalId: medicalId,
        issuanceDate: Value(DateTime.now()),
        syncStatus: const Value(1), // 待同步
      ),
    );
  }

  // 更新診斷結果
  Future<int> updateDiagnosisResult(
    int certificateId,
    String? diagnosisResult,
  ) {
    return (update(
      medicalCertificates,
    )..where((c) => c.certificateId.equals(certificateId))).write(
      MedicalCertificatesCompanion(diagnosisResult: Value(diagnosisResult)),
    );
  }

  // 更新診斷分類
  Future<int> updateDiagnosisCategory(
    int certificateId,
    int? diagnosisCategoryId,
  ) {
    return (update(
      medicalCertificates,
    )..where((c) => c.certificateId.equals(certificateId))).write(
      MedicalCertificatesCompanion(
        diagnosisCategoryId: Value(diagnosisCategoryId),
      ),
    );
  }

  // 更新中文囑言
  Future<int> updateChineseAdvice(int certificateId, String? chineseAdvice) {
    return (update(
      medicalCertificates,
    )..where((c) => c.certificateId.equals(certificateId))).write(
      MedicalCertificatesCompanion(chineseAdvice: Value(chineseAdvice)),
    );
  }

  // 更新英文囑言
  Future<int> updateEnglishAdvice(int certificateId, String? englishAdvice) {
    return (update(
      medicalCertificates,
    )..where((c) => c.certificateId.equals(certificateId))).write(
      MedicalCertificatesCompanion(englishAdvice: Value(englishAdvice)),
    );
  }

  // 更新開立日期
  Future<int> updateIssuanceDate(int certificateId, DateTime? issuanceDate) {
    return (update(medicalCertificates)
          ..where((c) => c.certificateId.equals(certificateId)))
        .write(MedicalCertificatesCompanion(issuanceDate: Value(issuanceDate)));
  }

  // 更新完整診斷證明書
  Future<bool> updateCertificate(MedicalCertificateData data) {
    return update(medicalCertificates).replace(data);
  }

  // 刪除診斷證明書
  Future<int> deleteCertificate(int certificateId) {
    return (delete(
      medicalCertificates,
    )..where((c) => c.certificateId.equals(certificateId))).go();
  }
}
