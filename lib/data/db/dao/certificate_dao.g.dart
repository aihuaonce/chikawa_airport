// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_dao.dart';

// ignore_for_file: type=lint
mixin _$CertificateDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalRecordTable get medicalRecord => attachedDatabase.medicalRecord;
  $DiagnosisCategoryTable get diagnosisCategory =>
      attachedDatabase.diagnosisCategory;
  $MedicalCertificatesTable get medicalCertificates =>
      attachedDatabase.medicalCertificates;
  CertificateDaoManager get managers => CertificateDaoManager(this);
}

class CertificateDaoManager {
  final _$CertificateDaoMixin _db;
  CertificateDaoManager(this._db);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db.attachedDatabase, _db.medicalRecord);
  $$DiagnosisCategoryTableTableManager get diagnosisCategory =>
      $$DiagnosisCategoryTableTableManager(
        _db.attachedDatabase,
        _db.diagnosisCategory,
      );
  $$MedicalCertificatesTableTableManager get medicalCertificates =>
      $$MedicalCertificatesTableTableManager(
        _db.attachedDatabase,
        _db.medicalCertificates,
      );
}
