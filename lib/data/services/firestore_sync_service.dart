import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../db/database.dart';
import 'firebase_service.dart';

class FirestoreSyncService {
  final AppDatabase _db;
  final FirebaseService _firebase;

  static const int syncStatusSynced = 0;
  static const int syncStatusPending = 1;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  Timer? _periodicSyncTimer;

  // 自動同步間隔（預設 15 分鐘）
  static const Duration _syncInterval = Duration(minutes: 15);

  FirestoreSyncService(this._db) : _firebase = FirebaseService();

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;

  /// 雙向同步：上傳本地變更 + 下載遠端變更
  Future<void> syncBidirectional() async {
    if (_isSyncing) {
      debugPrint('FirestoreSyncService: Already syncing, skipping...');
      return;
    }
    _isSyncing = true;

    try {
      // 1. 上傳本地變更到 Firestore
      await syncToRemote();

      // 2. 從 Firestore 下載新資料到本地
      await syncFromRemote();

      // 3. 更新最後同步時間
      _lastSyncTime = DateTime.now();
      await _db.syncDao.setLastSyncTime(_lastSyncTime!);

      debugPrint('FirestoreSyncService: Bidirectional sync completed');
    } catch (e) {
      debugPrint('FirestoreSyncService: Bidirectional sync error: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// 僅上傳：將本地 syncStatus=1 的記錄同步到 Firestore
  Future<void> syncToRemote() async {
    await Future.wait([
      _uploadMedicalRecords(),
      _uploadPatients(),
      _uploadTreatments(),
      _uploadAmbulanceRecords(),
      _uploadFees(),
      _uploadNursingRecords(),
      _uploadReferralForms(),
      _uploadFlightRecords(),
      _uploadMedications(),
      _uploadEmergencyTreatments(),
      _syncReferenceTables(),
    ]);
    debugPrint('FirestoreSyncService: Upload to remote completed');
  }

  /// 僅下載：從 Firestore 下載新資料到本地
  Future<void> syncFromRemote() async {
    await Future.wait([
      _downloadMedicalRecords(),
      _downloadPatients(),
      _downloadTreatments(),
      _downloadFees(),
      _downloadNursingRecords(),
      _downloadReferralForms(),
      _downloadFlightRecords(),
    ]);
    debugPrint('FirestoreSyncService: Download from remote completed');
  }

  // ============================================================
  // 定期自動同步
  // ============================================================

  /// 啟動定期自動同步（預設 15 分鐘一次）
  void startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(_syncInterval, (_) {
      debugPrint('FirestoreSyncService: Periodic sync triggered');
      syncBidirectional();
    });
    debugPrint(
      'FirestoreSyncService: Periodic sync started (interval: ${_syncInterval.inMinutes} minutes)',
    );
  }

  /// 停止定期自動同步
  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    debugPrint('FirestoreSyncService: Periodic sync stopped');
  }

  /// 設定是否啟用定期同步
  void setPeriodicSyncEnabled(bool enabled) {
    if (enabled) {
      startPeriodicSync();
    } else {
      stopPeriodicSync();
    }
  }

  /// 釋放資源
  void dispose() {
    stopPeriodicSync();
  }

  // ============================================================
  // 上傳方法 (Upload to Remote)
  // ============================================================

  /// 同步參考表（僅上傳，本地參考表為主）
  Future<void> _syncReferenceTables() async {
    try {
      // 性別
      final sexList = await _db.referenceDao.getAllSex();
      for (final item in sexList) {
        await _firebase.setDocument('reference_sex', item.sexId.toString(), {
          'sexId': item.sexId,
          'name': item.name,
        });
      }
      debugPrint('Synced ${sexList.length} sex records');

      // 國籍
      final nationalityList = await _db.referenceDao.getAllNationality();
      for (final item in nationalityList) {
        await _firebase.setDocument(
          'reference_nationality',
          item.nationalityId.toString(),
          {'nationalityId': item.nationalityId, 'name': item.name},
        );
      }
      debugPrint('Synced ${nationalityList.length} nationality records');

      // 航空公司
      final airlineList = await _db.referenceDao.getAllAirline();
      for (final item in airlineList) {
        await _firebase
            .setDocument('reference_airline', item.airlineId.toString(), {
              'airlineId': item.airlineId,
              'code': item.code,
              'name': item.name,
              'isOther': item.isOther,
            });
      }
      debugPrint('Synced ${airlineList.length} airline records');

      // 旅行狀態
      final travelStatusList = await _db.referenceDao.getAllTravelStatus();
      for (final item in travelStatusList) {
        await _firebase.setDocument(
          'reference_travel_status',
          item.travelStatusId.toString(),
          {
            'travelStatusId': item.travelStatusId,
            'code': item.code,
            'name': item.name,
          },
        );
      }
      debugPrint('Synced ${travelStatusList.length} travel status records');

      // 地點
      final locationList = await _db.referenceDao.getAllLocation();
      for (final item in locationList) {
        await _firebase.setDocument(
          'reference_location',
          item.locationId.toString(),
          {'locationId': item.locationId, 'code': item.code, 'name': item.name},
        );
      }
      debugPrint('Synced ${locationList.length} location records');

      // 檢傷分級
      final triageList = await _db.referenceDao.getAllTriageLevels();
      for (final item in triageList) {
        await _firebase
            .setDocument('reference_triage_level', item.id.toString(), {
              'id': item.id,
              'level': item.level,
              'name': item.name,
              'colorCode': item.colorCode,
              'description': item.description,
            });
      }
      debugPrint('Synced ${triageList.length} triage level records');

      // 轉診醫院
      final hospitalList = await _db.referenceDao.getAllReferralHospitals();
      for (final item in hospitalList) {
        await _firebase.setDocument(
          'reference_referral_hospital',
          item.id.toString(),
          {
            'id': item.id,
            'name': item.name,
            'address': item.address,
            'phone': item.phone,
          },
        );
      }
      debugPrint('Synced ${hospitalList.length} hospital records');

      debugPrint('Synced all reference tables');
    } catch (e) {
      debugPrint('Error syncing reference tables: $e');
    }
  }

  /// 上傳醫療主表
  Future<void> _uploadMedicalRecords() async {
    final records = await (_db.select(
      _db.medicalRecord,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('medical_records', record.medicalId.toString(), {
              'medicalId': record.medicalId,
              'isEmergency': record.isEmergency,
              'hasAmbulance': record.hasAmbulance,
              'cdcPassed': record.cdcPassed,
              'screeningMethod': record.screeningMethod,
              'createdAt': record.createdAt.toIso8601String(),
              'updatedAt': record.updatedAt.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.medicalRecord)
              ..where((t) => t.medicalId.equals(record.medicalId)))
            .write(MedicalRecordCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded medical_record ${record.medicalId}');
      } catch (e) {
        debugPrint('Error uploading medical_record ${record.medicalId}: $e');
      }
    }
  }

  /// 上傳病患資料
  Future<void> _uploadPatients() async {
    final patients = await (_db.select(
      _db.patient,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final patient in patients) {
      try {
        await _firebase.setDocument('patients', patient.patientId.toString(), {
          'patientId': patient.patientId,
          'medicalId': patient.medicalId,
          'name': patient.name,
          'anonymizationName': patient.anonymizationName,
          'birthday': patient.birthday?.toIso8601String(),
          'sexId': patient.sexId,
          'passportOrIdNo': patient.passportOrIdNo,
          'idNo': patient.idNo,
          'visitReasonId': patient.visitReasonId,
          'nationalityId': patient.nationalityId,
          'telephone': patient.telephone,
          'address': patient.address,
          'lastModified': FieldValue.serverTimestamp(),
        });

        await (_db.update(_db.patient)
              ..where((t) => t.patientId.equals(patient.patientId)))
            .write(PatientCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading patient ${patient.patientId}: $e');
      }
    }
  }

  /// 上傳處置記錄
  Future<void> _uploadTreatments() async {
    final treatments = await (_db.select(
      _db.treatment,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final treatment in treatments) {
      try {
        await _firebase
            .setDocument('treatments', treatment.treatmentId.toString(), {
              'treatmentId': treatment.treatmentId,
              'medicalId': treatment.medicalId,
              'tentativeCategoryId': treatment.tentativeCategoryId,
              'tentative': treatment.tentative,
              'secondaryDiagnosis1': treatment.secondaryDiagnosis1,
              'secondaryDiagnosis2': treatment.secondaryDiagnosis2,
              'triageId': treatment.triageId,
              'treatmentOnSiteId': treatment.treatmentOnSiteId,
              'actionSummary': treatment.actionSummary,
              'actionSummaryOther': treatment.actionSummaryOther,
              'resultId': treatment.resultId,
              'transportRequired': treatment.transportRequired,
              'referralHospitalId': treatment.referralHospitalId,
              'treatmentTime': treatment.treatmentTime.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.treatment)
              ..where((t) => t.treatmentId.equals(treatment.treatmentId)))
            .write(TreatmentCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading treatment ${treatment.treatmentId}: $e');
      }
    }
  }

  /// 上傳救護車記錄
  Future<void> _uploadAmbulanceRecords() async {
    final records = await (_db.select(
      _db.ambulanceRecords,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('ambulance_records', record.ambulanceId.toString(), {
              'ambulanceId': record.ambulanceId,
              'medicalId': record.medicalId,
              'licensePlate': record.licensePlate,
              'incidentLocationId': record.incidentLocationId,
              'incidentLocation2Id': record.incidentLocation2Id,
              'locationRemarks': record.locationRemarks,
              'dispatchTime': record.dispatchTime?.toIso8601String(),
              'arrivalTime': record.arrivalTime?.toIso8601String(),
              'hospitalId': record.hospitalId,
              'transportReason': record.transportReason,
              'leavingSceneTime': record.leavingSceneTime?.toIso8601String(),
              'arrivalHospitalTime': record.arrivalHospitalTime
                  ?.toIso8601String(),
              'bodyMapJson': record.bodyMapJson,
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.ambulanceRecords)
              ..where((t) => t.ambulanceId.equals(record.ambulanceId)))
            .write(AmbulanceRecordsCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint(
          'Error uploading ambulance_record ${record.ambulanceId}: $e',
        );
      }
    }
  }

  /// 上傳醫療費用
  Future<void> _uploadFees() async {
    final fees = await (_db.select(
      _db.medicalFees,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final fee in fees) {
      try {
        await _firebase.setDocument('medical_fees', fee.feeId.toString(), {
          'feeId': fee.feeId,
          'medicalId': fee.medicalId,
          'paymentMethodId': fee.paymentMethodId,
          'paymentType': fee.paymentType,
          'consultFee': fee.consultFee,
          'ambulanceFee': fee.ambulanceFee,
          'currencyId': fee.currencyId,
          'collectionStatusId': fee.collectionStatusId,
          'receiptIssued': fee.receiptIssued,
          'userAgreed': fee.userAgreed,
          'applicantName': fee.applicantName,
          'applicantUnit': fee.applicantUnit,
          'applicantPhone': fee.applicantPhone,
          'remarks': fee.remarks,
          'lastModified': FieldValue.serverTimestamp(),
        });

        await (_db.update(_db.medicalFees)
              ..where((t) => t.feeId.equals(fee.feeId)))
            .write(MedicalFeesCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading fee ${fee.feeId}: $e');
      }
    }
  }

  /// 上傳護理記錄
  Future<void> _uploadNursingRecords() async {
    final records = await (_db.select(
      _db.nursingRecords,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('nursing_records', record.recordId.toString(), {
              'recordId': record.recordId,
              'medicalId': record.medicalId,
              'recordTime': record.recordTime.toIso8601String(),
              'content': record.content,
              'nurseId': record.nurseId,
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.nursingRecords)
              ..where((t) => t.recordId.equals(record.recordId)))
            .write(NursingRecordsCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading nursing_record ${record.recordId}: $e');
      }
    }
  }

  /// 上傳轉診單
  Future<void> _uploadReferralForms() async {
    final forms = await (_db.select(
      _db.referralForms,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final form in forms) {
      try {
        await _firebase.setDocument('referral_forms', form.formId.toString(), {
          'formId': form.formId,
          'medicalId': form.medicalId,
          'contactName': form.contactName,
          'contactIdNo': form.contactIdNo,
          'contactPhone': form.contactPhone,
          'contactAddress': form.contactAddress,
          'primaryDiagnosis': form.primaryDiagnosis,
          'referralPurposeId': form.referralPurposeId,
          'doctorName': form.doctorName,
          'doctorDepartment': form.doctorDepartment,
          'hospitalName': form.hospitalName,
          'hospitalDept': form.hospitalDept,
          'hospitalDoctor': form.hospitalDoctor,
          'hospitalPhone': form.hospitalPhone,
          'hospitalAddress': form.hospitalAddress,
          'lastModified': FieldValue.serverTimestamp(),
        });

        await (_db.update(_db.referralForms)
              ..where((t) => t.formId.equals(form.formId)))
            .write(ReferralFormsCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading referral_form ${form.formId}: $e');
      }
    }
  }

  /// 上傳飛航記錄
  Future<void> _uploadFlightRecords() async {
    final records = await (_db.select(
      _db.flightRecord,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('flight_records', record.flightRecordId.toString(), {
              'flightRecordId': record.flightRecordId,
              'medicalId': record.medicalId,
              'flightNumber': record.flightNumber,
              'airlineId': record.airlineId,
              'travelStatusId': record.travelStatusId,
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.flightRecord)
              ..where((t) => t.flightRecordId.equals(record.flightRecordId)))
            .write(FlightRecordCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint(
          'Error uploading flight_record ${record.flightRecordId}: $e',
        );
      }
    }
  }

  /// 上傳藥物記錄
  Future<void> _uploadMedications() async {
    final records = await _db.select(_db.medications).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('medications', record.medicationId.toString(), {
              'medicationId': record.medicationId,
              'medicalId': record.medicalId,
              'name': record.name,
              'method': record.method,
              'frequency': record.frequency,
              'days': record.days,
              'dose': record.dose,
              'unit': record.unit,
              'remarks': record.remarks,
              'createdAt': record.createdAt.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });
      } catch (e) {
        debugPrint('Error uploading medication ${record.medicationId}: $e');
      }
    }
    debugPrint('Uploaded ${records.length} medications');
  }

  /// 上傳急救處置
  Future<void> _uploadEmergencyTreatments() async {
    final records = await _db.select(_db.emergencyTreatment).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('emergency_treatments', record.id.toString(), {
              'id': record.id,
              'medicalId': record.medicalId,
              'startTime': record.startTime?.toIso8601String(),
              'diagnosis': record.diagnosis,
              'incidentContext': record.incidentContext,
              'intubationMethod': record.intubationMethod,
              'intubationSize': record.intubationSize,
              'ivLineSize': record.ivLineSize,
              'lastModified': FieldValue.serverTimestamp(),
            });
      } catch (e) {
        debugPrint('Error uploading emergency_treatment ${record.id}: $e');
      }
    }
    debugPrint('Uploaded ${records.length} emergency treatments');
  }

  // ============================================================
  // 下載方法 (Download from Remote)
  // ============================================================

  /// 從 Firestore 下載醫療主表（僅下載本地不存在的記錄）
  Future<void> _downloadMedicalRecords() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('medical_records');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final medicalId = data['medicalId'];
        if (medicalId == null) continue;

        // 檢查本地是否已存在
        final existing =
            await (_db.select(_db.medicalRecord)
                  ..where((t) => t.medicalId.equals(medicalId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        // 新增到本地
        await _db
            .into(_db.medicalRecord)
            .insert(
              MedicalRecordCompanion.insert(
                isEmergency: Value(data['isEmergency'] as bool? ?? false),
                hasAmbulance: Value(data['hasAmbulance'] as bool? ?? false),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded medical_record $medicalId');
      }
    } catch (e) {
      debugPrint('Error downloading medical_records: $e');
    }
  }

  /// 從 Firestore 下載病患資料
  Future<void> _downloadPatients() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('patients');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final patientId = data['patientId'];
        if (patientId == null) continue;

        final existing =
            await (_db.select(_db.patient)
                  ..where((t) => t.patientId.equals(patientId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        final birthdayStr = data['birthday'] as String?;
        DateTime? birthday;
        if (birthdayStr != null) {
          birthday = DateTime.tryParse(birthdayStr);
        }

        await _db
            .into(_db.patient)
            .insert(
              PatientCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                name: Value(data['name'] as String?),
                anonymizationName: Value(data['anonymizationName'] as String?),
                birthday: birthday != null
                    ? Value(birthday)
                    : const Value.absent(),
                sexId: Value((data['sexId'] as int?) ?? 1),
                passportOrIdNo: Value(data['passportOrIdNo'] as String?),
                idNo: Value(data['idNo'] as String?),
                visitReasonId: Value((data['visitReasonId'] as int?) ?? 1),
                nationalityId: Value(data['nationalityId'] as int?),
                telephone: Value(data['telephone'] as String?),
                address: Value(data['address'] as String?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded patient $patientId');
      }
    } catch (e) {
      debugPrint('Error downloading patients: $e');
    }
  }

  /// 從 Firestore 下載處置記錄
  Future<void> _downloadTreatments() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('treatments');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final treatmentId = data['treatmentId'];
        if (treatmentId == null) continue;

        final existing =
            await (_db.select(_db.treatment)
                  ..where((t) => t.treatmentId.equals(treatmentId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        await _db
            .into(_db.treatment)
            .insert(
              TreatmentCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                tentative: Value(data['tentative'] as String?),
                secondaryDiagnosis1: Value(
                  data['secondaryDiagnosis1'] as String?,
                ),
                secondaryDiagnosis2: Value(
                  data['secondaryDiagnosis2'] as String?,
                ),
                triageId: Value(data['triageId'] as int?),
                actionSummary: Value(data['actionSummary'] as String?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded treatment $treatmentId');
      }
    } catch (e) {
      debugPrint('Error downloading treatments: $e');
    }
  }

  /// 從 Firestore 下載醫療費用
  Future<void> _downloadFees() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('medical_fees');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final feeId = data['feeId'];
        if (feeId == null) continue;

        final existing = await (_db.select(
          _db.medicalFees,
        )..where((t) => t.feeId.equals(feeId as int))).getSingleOrNull();

        if (existing != null) continue;

        await _db
            .into(_db.medicalFees)
            .insert(
              MedicalFeesCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                consultFee: Value(
                  (data['consultFee'] as num?)?.toDouble() ?? 0.0,
                ),
                ambulanceFee: Value(
                  (data['ambulanceFee'] as num?)?.toDouble() ?? 0.0,
                ),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded medical_fee $feeId');
      }
    } catch (e) {
      debugPrint('Error downloading medical_fees: $e');
    }
  }

  /// 從 Firestore 下載護理記錄
  Future<void> _downloadNursingRecords() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('nursing_records');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final recordId = data['recordId'];
        if (recordId == null) continue;

        final existing = await (_db.select(
          _db.nursingRecords,
        )..where((t) => t.recordId.equals(recordId as int))).getSingleOrNull();

        if (existing != null) continue;

        final recordTimeStr = data['recordTime'] as String?;
        final recordTime = recordTimeStr != null
            ? DateTime.tryParse(recordTimeStr) ?? DateTime.now()
            : DateTime.now();

        await _db
            .into(_db.nursingRecords)
            .insert(
              NursingRecordsCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                recordTime: recordTime,
                content: Value(data['content'] as String?),
                nurseId: Value(data['nurseId'] as int?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded nursing_record $recordId');
      }
    } catch (e) {
      debugPrint('Error downloading nursing_records: $e');
    }
  }

  /// 從 Firestore 下載轉診單
  Future<void> _downloadReferralForms() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('referral_forms');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final formId = data['formId'];
        if (formId == null) continue;

        final existing = await (_db.select(
          _db.referralForms,
        )..where((t) => t.formId.equals(formId as int))).getSingleOrNull();

        if (existing != null) continue;

        await _db
            .into(_db.referralForms)
            .insert(
              ReferralFormsCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                contactName: Value(data['contactName'] as String?),
                contactPhone: Value(data['contactPhone'] as String?),
                contactAddress: Value(data['contactAddress'] as String?),
                primaryDiagnosis: Value(data['primaryDiagnosis'] as String?),
                referralPurposeId: Value(data['referralPurposeId'] as int?),
                doctorName: Value(data['doctorName'] as String?),
                hospitalName: Value(data['hospitalName'] as String?),
                hospitalPhone: Value(data['hospitalPhone'] as String?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded referral_form $formId');
      }
    } catch (e) {
      debugPrint('Error downloading referral_forms: $e');
    }
  }

  /// 從 Firestore 下載飛航記錄
  Future<void> _downloadFlightRecords() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('flight_records');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final flightRecordId = data['flightRecordId'];
        if (flightRecordId == null) continue;

        final existing =
            await (_db.select(
                  _db.flightRecord,
                )..where((t) => t.flightRecordId.equals(flightRecordId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        await _db
            .into(_db.flightRecord)
            .insert(
              FlightRecordCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                flightNumber: (data['flightNumber'] as String?) ?? '',
                airlineId: Value(data['airlineId'] as int?),
                travelStatusId: Value(data['travelStatusId'] as int?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded flight_record $flightRecordId');
      }
    } catch (e) {
      debugPrint('Error downloading flight_records: $e');
    }
  }

  // ============================================================
  // 兼容性：保留舊的 syncAll 方法
  // ============================================================

  /// 兼容性方法：等同於 syncBidirectional
  @Deprecated('Use syncBidirectional() instead')
  Future<void> syncAll() async {
    await syncBidirectional();
  }
}
