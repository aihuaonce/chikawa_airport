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
      _uploadChiefComplaints(),
      _uploadMedicalHistories(),
      _uploadSpecialNotes(),
      _uploadMedications(),
      _uploadAmbulanceRecords(),
      _uploadFees(),
      _uploadNursingRecords(),
      _uploadReferralForms(),
      _uploadFlightRecords(),
      _uploadEmergencyTreatments(),
      _uploadIncidentRecords(),
      _uploadCertificates(),
      _uploadTelexDocuments(),
      _uploadAmbulancePersonalProperty(),
      _uploadAmbulanceFees(),
      _uploadContacts(),
      // 新增上傳
      _uploadMedicalMedia(),
      _uploadMedicalAssessments(),
      _uploadHealthAssessments(),
      _uploadChiefComplaintSymptomLinks(),
      _syncReferenceTables(),
    ]);
    debugPrint('FirestoreSyncService: Upload to remote completed');
  }

  /// 僅下載：從 Firestore 下載新資料到本地
  Future<void> syncFromRemote() async {
    debugPrint('=== STARTING SYNC FROM REMOTE ===');
    await Future.wait([
      _downloadMedicalRecords(),
      _downloadPatients(),
      _downloadTreatments(),
      _downloadFees(),
      _downloadNursingRecords(),
      _downloadReferralForms(),
      _downloadFlightRecords(),
      _downloadIncidentRecords(),
      _downloadCertificates(),
      _downloadTelexDocuments(),
      _downloadContacts(),
      _downloadEmergencyTreatments(),
      // 新增下載
      _downloadChiefComplaints(),
      _downloadMedicalHistories(),
      _downloadSpecialNotes(),
      _downloadMedicalMedia(),
      _downloadMedicalAssessments(),
      _downloadHealthAssessments(),
      _downloadChiefComplaintSymptomLinks(),
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
  /// 先下載遠端 ID 清單，只上傳本地有但遠端沒有的資料
  Future<void> _syncReferenceTables() async {
    try {
      // 1. 先批量下載所有遠端參考表的 ID 清單
      final remoteIds = await _getAllRemoteReferenceIds();

      // 2. 上傳本地參考表（只上傳遠端沒有的）
      int totalUploaded = 0;

      // 性別
      final sexList = await _db.referenceDao.getAllSex();
      int sexUploaded = 0;
      for (final item in sexList) {
        final key = 'reference_sex_${item.sexId}';
        if (!remoteIds.contains(key)) {
          await _firebase.setDocument('reference_sex', item.sexId.toString(), {
            'sexId': item.sexId,
            'name': item.name,
          });
          sexUploaded++;
        }
      }
      totalUploaded += sexUploaded;

      // 國籍
      final nationalityList = await _db.referenceDao.getAllNationality();
      int nationalityUploaded = 0;
      for (final item in nationalityList) {
        final key = 'reference_nationality_${item.nationalityId}';
        if (!remoteIds.contains(key)) {
          await _firebase.setDocument(
            'reference_nationality',
            item.nationalityId.toString(),
            {'nationalityId': item.nationalityId, 'name': item.name},
          );
          nationalityUploaded++;
        }
      }
      totalUploaded += nationalityUploaded;

      // 航空公司
      final airlineList = await _db.referenceDao.getAllAirline();
      int airlineUploaded = 0;
      for (final item in airlineList) {
        final key = 'reference_airline_${item.airlineId}';
        if (!remoteIds.contains(key)) {
          await _firebase
              .setDocument('reference_airline', item.airlineId.toString(), {
                'airlineId': item.airlineId,
                'code': item.code,
                'name': item.name,
                'isOther': item.isOther,
              });
          airlineUploaded++;
        }
      }
      totalUploaded += airlineUploaded;

      // 旅行狀態
      final travelStatusList = await _db.referenceDao.getAllTravelStatus();
      int travelStatusUploaded = 0;
      for (final item in travelStatusList) {
        final key = 'reference_travel_status_${item.travelStatusId}';
        if (!remoteIds.contains(key)) {
          await _firebase.setDocument(
            'reference_travel_status',
            item.travelStatusId.toString(),
            {
              'travelStatusId': item.travelStatusId,
              'code': item.code,
              'name': item.name,
            },
          );
          travelStatusUploaded++;
        }
      }
      totalUploaded += travelStatusUploaded;

      // 地點
      final locationList = await _db.referenceDao.getAllLocation();
      int locationUploaded = 0;
      for (final item in locationList) {
        final key = 'reference_location_${item.locationId}';
        if (!remoteIds.contains(key)) {
          await _firebase.setDocument(
            'reference_location',
            item.locationId.toString(),
            {
              'locationId': item.locationId,
              'code': item.code,
              'name': item.name,
            },
          );
          locationUploaded++;
        }
      }
      totalUploaded += locationUploaded;

      // 檢傷分級
      final triageList = await _db.referenceDao.getAllTriageLevels();
      int triageUploaded = 0;
      for (final item in triageList) {
        final key = 'reference_triage_level_${item.id}';
        if (!remoteIds.contains(key)) {
          await _firebase
              .setDocument('reference_triage_level', item.id.toString(), {
                'id': item.id,
                'level': item.level,
                'name': item.name,
                'colorCode': item.colorCode,
                'description': item.description,
              });
          triageUploaded++;
        }
      }
      totalUploaded += triageUploaded;

      // 轉診醫院
      final hospitalList = await _db.referenceDao.getAllReferralHospitals();
      int hospitalUploaded = 0;
      for (final item in hospitalList) {
        final key = 'reference_referral_hospital_${item.id}';
        if (!remoteIds.contains(key)) {
          await _firebase
              .setDocument('reference_referral_hospital', item.id.toString(), {
                'id': item.id,
                'name': item.name,
                'address': item.address,
                'phone': item.phone,
              });
          hospitalUploaded++;
        }
      }
      totalUploaded += hospitalUploaded;

      debugPrint('參考表同步完成，共上傳 $totalUploaded 筆');
    } catch (e) {
      debugPrint('Error syncing reference tables: $e');
    }
  }

  /// 批量下載所有遠端參考表的 ID 清單
  Future<Set<String>> _getAllRemoteReferenceIds() async {
    final Set<String> remoteIds = {};

    try {
      final collections = [
        'reference_sex',
        'reference_nationality',
        'reference_airline',
        'reference_travel_status',
        'reference_location',
        'reference_triage_level',
        'reference_referral_hospital',
      ];

      for (final coll in collections) {
        try {
          final snapshot = await _firebase.getCollectionSnapshot(coll);
          for (final doc in snapshot.docs) {
            remoteIds.add('${coll}_${doc.id}');
          }
        } catch (e) {
          // 某個 collection 可能不存在，繼續處理下一個
        }
      }
    } catch (e) {
      debugPrint('Error getting remote reference IDs: $e');
    }

    return remoteIds;
  }

  /// 上傳醫療主表
  Future<void> _uploadMedicalRecords() async {
    final records = await (_db.select(
      _db.medicalRecord,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: medical_records - found ${records.length} records with syncStatus=1',
    );

    for (final record in records) {
      try {
        debugPrint(
          'UPLOAD: uploading medical_record ${record.medicalId}, cdcPassed=${record.cdcPassed}',
        );
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
    // 上傳所有 syncStatus=1 或沒有 remoteId 的治療記錄
    final treatments = await (_db.select(
      _db.treatment,
    )..where((t) => t.syncStatus.equals(1) | t.remoteId.isNull())).get();

    debugPrint('上傳治療記錄: 待上傳 ${treatments.length} 筆');

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
              'transportMethod': treatment.transportMethod,
              'referralHospitalFinal': treatment.referralHospitalFinal,
              'ambulanceStaffId': treatment.ambulanceStaffId,
              'arrivalTime': treatment.arrivalTime?.toIso8601String(),
              'clearanceId': treatment.clearanceId,
              'expeditedClearanceId': treatment.expeditedClearanceId,
              'doctorOrderCh': treatment.doctorOrderCh,
              'doctorOrderEn': treatment.doctorOrderEn,
              'otherPhotoDescription': treatment.otherPhotoDescription,
              'directorName': treatment.directorName,
              'assistStaff': treatment.assistStaff,
              'ekgInterpretation': treatment.ekgInterpretation,
              'glucose': treatment.glucose,
              'intubationMethod': treatment.intubationMethod,
              'oxygenMethod': treatment.oxygenMethod,
              'oxygenFlow': treatment.oxygenFlow,
              'certificateLogs': treatment.certificateLogs,
              'treatmentTime': treatment.treatmentTime.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(
          _db.treatment,
        )..where((t) => t.treatmentId.equals(treatment.treatmentId))).write(
          TreatmentCompanion(
            syncStatus: const Value(0),
            remoteId: Value(treatment.treatmentId.toString()),
          ),
        );
        debugPrint('上傳治療記錄成功: ${treatment.treatmentId}');
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
    // 只上傳 syncStatus=1 且未刪除的記錄
    final records = await (_db.select(
      _db.flightRecord,
    )..where((t) => t.syncStatus.equals(1) & t.deletedAt.isNull())).get();

    debugPrint('上傳飛航記錄: 待上傳 ${records.length} 筆');

    for (final record in records) {
      try {
        await _firebase
            .setDocument('flight_records', record.flightRecordId.toString(), {
              'flightRecordId': record.flightRecordId,
              'medicalId': record.medicalId,
              'flightNumber': record.flightNumber,
              'airlineId': record.airlineId,
              'travelStatusId': record.travelStatusId,
              'departureLocationId': record.departureLocationId,
              'arrivalLocationId': record.arrivalLocationId,
              'lastModified': FieldValue.serverTimestamp(),
              'deletedAt': record.deletedAt?.toIso8601String(),
            });

        await (_db.update(_db.flightRecord)
              ..where((t) => t.flightRecordId.equals(record.flightRecordId)))
            .write(FlightRecordCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded flight_record ${record.flightRecordId}');
      } catch (e) {
        debugPrint(
          'Error uploading flight_record ${record.flightRecordId}: $e',
        );
      }
    }

    // 上傳已刪除的飛航記錄
    await _uploadDeletedFlightRecords();

    // 上傳經過點
    await _uploadFlightTransitLocations();
  }

  /// 上傳已刪除的飛航記錄（真正從 Firestore 刪除）
  Future<void> _uploadDeletedFlightRecords() async {
    final deletedRecords = await (_db.select(
      _db.flightRecord,
    )..where((t) => t.syncStatus.equals(1) & t.deletedAt.isNotNull())).get();

    for (final record in deletedRecords) {
      try {
        // 真正刪除 Firestore 文件
        await _firebase.deleteDocument(
          'flight_records',
          record.flightRecordId.toString(),
        );

        // 同步刪除該飛航記錄的所有經過點
        final transitLocations = await (_db.select(
          _db.flightTransitLocations,
        )..where((t) => t.flightRecordId.equals(record.flightRecordId))).get();

        for (final transit in transitLocations) {
          await _firebase.deleteDocument(
            'flight_transit_locations',
            transit.id.toString(),
          );
        }

        // 更新本地 syncStatus = 0
        await (_db.update(_db.flightRecord)
              ..where((t) => t.flightRecordId.equals(record.flightRecordId)))
            .write(const FlightRecordCompanion(syncStatus: Value(0)));

        debugPrint('已從遠端刪除 flight_record ${record.flightRecordId}');
      } catch (e) {
        debugPrint(
          'Error deleting flight_record from remote ${record.flightRecordId}: $e',
        );
      }
    }
  }

  /// 上傳飛航經過點
  Future<void> _uploadFlightTransitLocations() async {
    // 只上傳未刪除且 syncStatus=1 的經過點
    final transitRecords = await (_db.select(
      _db.flightTransitLocations,
    )..where((t) => t.syncStatus.equals(1) & t.deletedAt.isNull())).get();

    debugPrint('上傳飛航經過點: ${transitRecords.length} 筆');

    for (final record in transitRecords) {
      try {
        await _firebase
            .setDocument('flight_transit_locations', record.id.toString(), {
              'id': record.id,
              'flightRecordId': record.flightRecordId,
              'locationId': record.locationId,
              'stopOrder': record.stopOrder,
            });

        // 上傳成功後設 syncStatus=0
        await (_db.update(_db.flightTransitLocations)
              ..where((t) => t.id.equals(record.id)))
            .write(FlightTransitLocationsCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading flight_transit_location ${record.id}: $e');
      }
    }

    // 上傳已刪除的經過點（真正從 Firestore 刪除）
    await _uploadDeletedTransitLocations();
  }

  /// 上傳已刪除的經過點（真正從 Firestore 刪除）
  Future<void> _uploadDeletedTransitLocations() async {
    final deletedRecords = await (_db.select(
      _db.flightTransitLocations,
    )..where((t) => t.deletedAt.isNotNull())).get();

    for (final record in deletedRecords) {
      try {
        // 真正刪除 Firestore 文件
        await _firebase.deleteDocument(
          'flight_transit_locations',
          record.id.toString(),
        );
        debugPrint('已從遠端刪除 transit_location ${record.id}');
      } catch (e) {
        debugPrint(
          'Error deleting transit_location from remote ${record.id}: $e',
        );
      }
    }
  }

  /// 上傳藥物記錄
  Future<void> _uploadMedications() async {
    final records = await (_db.select(
      _db.medications,
    )..where((t) => t.syncStatus.equals(1))).get();

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

        await (_db.update(_db.medications)
              ..where((t) => t.medicationId.equals(record.medicationId)))
            .write(MedicationsCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading medication ${record.medicationId}: $e');
      }
    }
    debugPrint('Uploaded ${records.length} medications');
  }

  /// 上傳主訴記錄
  Future<void> _uploadChiefComplaints() async {
    final records = await (_db.select(
      _db.chiefComplaint,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: chief_complaints - found ${records.length} records with syncStatus=1',
    );
    for (final r in records) {
      debugPrint(
        '  - complaintId=${r.complaintId}, syncStatus=${r.syncStatus}',
      );
    }

    for (final record in records) {
      try {
        debugPrint('UPLOAD: uploading chief_complaint ${record.complaintId}');
        await _firebase
            .setDocument('chief_complaints', record.complaintId.toString(), {
              'complaintId': record.complaintId,
              'medicalId': record.medicalId,
              'chiefComplaintTypeId': record.chiefComplaintTypeId,
              'selectedSymptoms': record.selectedSymptoms,
              'otherSymptomDetail': record.otherSymptomDetail,
              'chiefComplaintFinal': record.chiefComplaintFinal,
              'supplementaryNotes': record.supplementaryNotes,
              'onsetTime': record.onsetTime?.toIso8601String(),
              'reportedBy': record.reportedBy,
              'isConfirmed': record.isConfirmed,
              'createdAt': record.createdAt.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.chiefComplaint)
              ..where((t) => t.complaintId.equals(record.complaintId)))
            .write(ChiefComplaintCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading chief_complaint ${record.complaintId}: $e');
      }
    }
    debugPrint('Uploaded ${records.length} chief_complaints');
  }

  /// 上傳主訴症狀關聯
  Future<void> _uploadChiefComplaintSymptomLinks() async {
    // 找出所有有主訴記錄且 syncStatus=1 的 medicalId
    final complaints = await (_db.select(
      _db.chiefComplaint,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final complaint in complaints) {
      try {
        // 取得該主訴的所有症狀關聯
        final symptomLinks = await (_db.select(
          _db.chiefComplaintSymptomLinks,
        )..where((l) => l.complaintId.equals(complaint.complaintId))).get();

        if (symptomLinks.isEmpty) continue;

        // 將每個症狀關聯上傳到 Firestore
        for (final link in symptomLinks) {
          final docId = '${complaint.complaintId}_${link.symptomId}';
          await _firebase.setDocument('chief_complaint_symptom_links', docId, {
            'complaintId': complaint.complaintId,
            'symptomId': link.symptomId,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
        debugPrint(
          'Uploaded ${symptomLinks.length} symptom links for complaint ${complaint.complaintId}',
        );
      } catch (e) {
        debugPrint(
          'Error uploading symptom links for complaint ${complaint.complaintId}: $e',
        );
      }
    }
  }

  /// 從 Firestore 下載主訴症狀關聯
  Future<void> _downloadChiefComplaintSymptomLinks() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'chief_complaint_symptom_links',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final complaintId = data['complaintId'] as int?;
        final symptomId = data['symptomId'] as int?;

        if (complaintId == null || symptomId == null) continue;

        // 檢查本地是否已有這個關聯
        final existing =
            await (_db.select(_db.chiefComplaintSymptomLinks)..where(
                  (l) =>
                      l.complaintId.equals(complaintId) &
                      l.symptomId.equals(symptomId),
                ))
                .getSingleOrNull();

        if (existing != null) continue;

        // 插入新的關聯
        await _db
            .into(_db.chiefComplaintSymptomLinks)
            .insert(
              ChiefComplaintSymptomLinksCompanion.insert(
                complaintId: complaintId,
                symptomId: symptomId,
              ),
            );
        debugPrint(
          'Downloaded symptom link: complaint=$complaintId, symptom=$symptomId',
        );
      }
    } catch (e) {
      debugPrint('Error downloading chief_complaint_symptom_links: $e');
    }
  }

  /// 上傳病史記錄
  Future<void> _uploadMedicalHistories() async {
    final records = await (_db.select(
      _db.medicalHistory,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: medical_histories - found ${records.length} records with syncStatus=1',
    );

    for (final record in records) {
      try {
        debugPrint('UPLOAD: uploading medical_history ${record.historyId}');
        await _firebase
            .setDocument('medical_histories', record.historyId.toString(), {
              'historyId': record.historyId,
              'medicalId': record.medicalId,
              'pastHistoryStatusId': record.pastHistoryStatusId,
              'pastHistoryDetail': record.pastHistoryDetail,
              'allergyStatusId': record.allergyStatusId,
              'allergyDetail': record.allergyDetail,
              'createdAt': record.createdAt.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.medicalHistory)
              ..where((t) => t.historyId.equals(record.historyId)))
            .write(MedicalHistoryCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading medical_history ${record.historyId}: $e');
      }
    }
    debugPrint('Uploaded ${records.length} medical_histories');
  }

  /// 上傳特別註記
  Future<void> _uploadSpecialNotes() async {
    final records = await (_db.select(
      _db.specialNotes,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: special_notes - found ${records.length} records with syncStatus=1',
    );

    for (final record in records) {
      try {
        debugPrint('UPLOAD: uploading special_note ${record.noteId}');
        await _firebase.setDocument('special_notes', record.noteId.toString(), {
          'noteId': record.noteId,
          'medicalId': record.medicalId,
          'selectedNotes': record.selectedNotes,
          'otherNotes': record.otherNotes,
          'createdAt': record.createdAt.toIso8601String(),
          'lastModified': FieldValue.serverTimestamp(),
        });

        await (_db.update(_db.specialNotes)
              ..where((t) => t.noteId.equals(record.noteId)))
            .write(SpecialNotesCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint('Error uploading special_note ${record.noteId}: $e');
      }
    }
    debugPrint('Uploaded ${records.length} special_notes');
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

  /// 上傳事故記錄
  Future<void> _uploadIncidentRecords() async {
    final records = await (_db.select(
      _db.incidentRecord,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint('上傳事故記錄: 待上傳 ${records.length} 筆');

    for (final record in records) {
      try {
        await _firebase.setDocument(
          'incident_records',
          record.incidentId.toString(),
          {
            'incidentId': record.incidentId,
            'medicalId': record.medicalId,
            'incidentDate': record.incidentDate.toIso8601String(),
            'incidentPlaceCategoryId': record.incidentPlaceCategoryId,
            'incidentPlaceCategory2Id': record.incidentPlaceCategory2Id,
            'incidentPlaceFinal': record.incidentPlaceFinal,
            'notificationTime': record.notificationTime?.toIso8601String(),
            'notificationPerson': record.notificationPerson,
            'reportingUnitId': record.reportingUnitId,
            'incomingPhone': record.incomingPhone,
            'notificationToOccTime': record.notificationToOccTime
                ?.toIso8601String(),
            'teamDepartureTime': record.teamDepartureTime?.toIso8601String(),
            'occArrived': record.occArrived,
            'beforeLanding': record.beforeLanding,
            'landingTime': record.landingTime?.toIso8601String(),
            'medicalArrivalTime': record.medicalArrivalTime?.toIso8601String(),
            'examinationTime': record.examinationTime?.toIso8601String(),
            'lastModified': FieldValue.serverTimestamp(),
          },
        );

        await (_db.update(_db.incidentRecord)
              ..where((t) => t.incidentId.equals(record.incidentId)))
            .write(IncidentRecordCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded incident_record ${record.incidentId}');
      } catch (e) {
        debugPrint('Error uploading incident_record ${record.incidentId}: $e');
      }
    }
  }

  /// 上傳診斷證明書
  Future<void> _uploadCertificates() async {
    final records = await (_db.select(
      _db.medicalCertificates,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase.setDocument(
          'medical_certificates',
          record.certificateId.toString(),
          {
            'certificateId': record.certificateId,
            'medicalId': record.medicalId,
            'diagnosisCategoryId': record.diagnosisCategoryId,
            'diagnosisResult': record.diagnosisResult,
            'chineseAdvice': record.chineseAdvice,
            'englishAdvice': record.englishAdvice,
            'issuanceDate': record.issuanceDate?.toIso8601String(),
            'createdAt': record.createdAt.toIso8601String(),
            'lastModified': FieldValue.serverTimestamp(),
          },
        );

        await (_db.update(_db.medicalCertificates)
              ..where((t) => t.certificateId.equals(record.certificateId)))
            .write(MedicalCertificatesCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded medical_certificate ${record.certificateId}');
      } catch (e) {
        debugPrint(
          'Error uploading medical_certificate ${record.certificateId}: $e',
        );
      }
    }
  }

  /// 上傳 TELEX 文件
  Future<void> _uploadTelexDocuments() async {
    final records = await (_db.select(
      _db.telexDocuments,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('telex_documents', record.documentId.toString(), {
              'documentId': record.documentId,
              'medicalId': record.medicalId,
              'toStationId': record.toStationId,
              'fromStationId': record.fromStationId,
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(_db.telexDocuments)
              ..where((t) => t.documentId.equals(record.documentId)))
            .write(TelexDocumentsCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded telex_document ${record.documentId}');
      } catch (e) {
        debugPrint('Error uploading telex_document ${record.documentId}: $e');
      }
    }
  }

  /// 上傳救護車個人財物
  Future<void> _uploadAmbulancePersonalProperty() async {
    final records = await (_db.select(
      _db.ambulancePersonalProperty,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase
            .setDocument('ambulance_personal_property', record.id.toString(), {
              'id': record.id,
              'medicalId': record.medicalId,
              'financialDetails': record.financialDetails,
              'isHandled': record.isHandled,
              'custodianName': record.custodianName,
              'createdAt': record.createdAt.toIso8601String(),
              'updatedAt': record.updatedAt.toIso8601String(),
              'lastModified': FieldValue.serverTimestamp(),
            });

        await (_db.update(
          _db.ambulancePersonalProperty,
        )..where((t) => t.id.equals(record.id))).write(
          AmbulancePersonalPropertyCompanion(syncStatus: const Value(0)),
        );

        debugPrint('Uploaded ambulance_personal_property ${record.id}');
      } catch (e) {
        debugPrint(
          'Error uploading ambulance_personal_property ${record.id}: $e',
        );
      }
    }
  }

  /// 上傳救護車收費
  Future<void> _uploadAmbulanceFees() async {
    final records = await (_db.select(
      _db.ambulanceFees,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase.setDocument('ambulance_fees', record.feeId.toString(), {
          'feeId': record.feeId,
          'medicalId': record.medicalId,
          'ambulanceFee': record.ambulanceFee,
          'oxygenFee': record.oxygenFee,
          'paymentStatus': record.paymentStatus,
          'paymentMethod': record.paymentMethod,
          'unpaidType': record.unpaidType,
          'createdAt': record.createdAt.toIso8601String(),
          'updatedAt': record.updatedAt.toIso8601String(),
          'lastModified': FieldValue.serverTimestamp(),
        });

        await (_db.update(_db.ambulanceFees)
              ..where((t) => t.feeId.equals(record.feeId)))
            .write(AmbulanceFeesCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded ambulance_fee ${record.feeId}');
      } catch (e) {
        debugPrint('Error uploading ambulance_fee ${record.feeId}: $e');
      }
    }
  }

  /// 上傳聯絡人
  Future<void> _uploadContacts() async {
    final records = await (_db.select(
      _db.contact,
    )..where((t) => t.syncStatus.equals(1))).get();

    for (final record in records) {
      try {
        await _firebase.setDocument('contacts', record.id.toString(), {
          'id': record.id,
          'name': record.name,
          'phone': record.phone,
          'mobile': record.mobile,
          'address': record.address,
          'note': record.note,
          'patientId': record.patientId,
          'createdAt': record.createdAt.toIso8601String(),
          'updatedAt': record.updatedAt.toIso8601String(),
          'lastModified': FieldValue.serverTimestamp(),
        });

        await (_db.update(_db.contact)..where((t) => t.id.equals(record.id)))
            .write(ContactCompanion(syncStatus: const Value(0)));

        debugPrint('Uploaded contact ${record.id}');
      } catch (e) {
        debugPrint('Error uploading contact ${record.id}: $e');
      }
    }
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

        if (existing != null) {
          // 如果已存在，更新 syncStatus 為 0（已同步）
          await (_db.update(
            _db.medicalRecord,
          )..where((t) => t.medicalId.equals(medicalId as int))).write(
            MedicalRecordCompanion(
              syncStatus: const Value(0),
              remoteId: Value(doc.id),
              lastModified: Value(DateTime.now()),
            ),
          );
          debugPrint('Updated medical_record $medicalId sync status');
          continue;
        }

        // 新增到本地
        await _db
            .into(_db.medicalRecord)
            .insert(
              MedicalRecordCompanion.insert(
                isEmergency: Value(data['isEmergency'] as bool? ?? false),
                hasAmbulance: Value(data['hasAmbulance'] as bool? ?? false),
                cdcPassed: Value(data['cdcPassed'] as bool?),
                screeningMethod: Value(data['screeningMethod'] as String?),
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

      debugPrint('下載處置記錄: 遠端有 ${snapshot.docs.length} 筆');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final treatmentId = data['treatmentId'];
        final medicalId = data['medicalId'] as int?;

        debugPrint('嘗試下載 treatment: id=$treatmentId, medicalId=$medicalId');

        if (treatmentId == null) continue;
        if (medicalId == null || medicalId == 0) {
          debugPrint('跳過 treatment $treatmentId: medicalId 無效 ($medicalId)');
          continue;
        }

        final existing =
            await (_db.select(_db.treatment)
                  ..where((t) => t.treatmentId.equals(treatmentId as int)))
                .getSingleOrNull();

        if (existing != null) {
          debugPrint('treatment $treatmentId 已存在本地，跳過');
          continue;
        }

        await _db
            .into(_db.treatment)
            .insert(
              TreatmentCompanion.insert(
                medicalId: medicalId,
                tentativeCategoryId: Value(data['tentativeCategoryId'] as int?),
                tentative: Value(data['tentative'] as String?),
                secondaryDiagnosis1: Value(
                  data['secondaryDiagnosis1'] as String?,
                ),
                secondaryDiagnosis2: Value(
                  data['secondaryDiagnosis2'] as String?,
                ),
                triageId: Value(data['triageId'] as int?),
                treatmentOnSiteId: Value(data['treatmentOnSiteId'] as int?),
                actionSummary: Value(data['actionSummary'] as String?),
                actionSummaryOther: Value(
                  data['actionSummaryOther'] as String?,
                ),
                resultId: Value(data['resultId'] as int?),
                transportRequired: Value(data['transportRequired'] as bool?),
                referralHospitalId: Value(data['referralHospitalId'] as int?),
                treatmentTime: Value(
                  data['treatmentTime'] != null
                      ? DateTime.parse(data['treatmentTime'] as String)
                      : DateTime.now(),
                ),
                otherPhotoDescription: Value(
                  data['otherPhotoDescription'] as String?,
                ),
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

      debugPrint('下載飛航記錄: 遠端有 ${snapshot.docs.length} 筆');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final flightRecordId = data['flightRecordId'];
        if (flightRecordId == null) continue;

        final existing =
            await (_db.select(_db.flightRecord)..where(
                  (t) =>
                      t.flightRecordId.equals(flightRecordId as int) &
                      t.deletedAt.isNull(),
                ))
                .getSingleOrNull();

        if (existing != null) {
          debugPrint('飛航記錄 $flightRecordId 已存在本地，跳過下載');
          continue;
        }

        await _db
            .into(_db.flightRecord)
            .insert(
              FlightRecordCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                flightNumber: (data['flightNumber'] as String?) ?? '',
                airlineId: Value(data['airlineId'] as int?),
                travelStatusId: Value(data['travelStatusId'] as int?),
                departureLocationId: Value(data['departureLocationId'] as int?),
                arrivalLocationId: Value(data['arrivalLocationId'] as int?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded flight_record $flightRecordId');
      }

      // 下載經過點
      await _downloadFlightTransitLocations();
    } catch (e) {
      debugPrint('Error downloading flight_records: $e');
    }
  }

  /// 從 Firestore 下載飛航經過點
  Future<void> _downloadFlightTransitLocations() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'flight_transit_locations',
      );

      debugPrint('下載飛航經過點: 遠端有 ${snapshot.docs.length} 筆');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final id = data['id'];
        if (id == null) continue;

        final flightRecordId = data['flightRecordId'] as int?;
        final stopOrder = data['stopOrder'] as int? ?? 0;

        if (flightRecordId == null) continue;

        // 用 flightRecordId + stopOrder 判斷是否已存在（不用 id，因為本地 id 是 auto-increment）
        // 只查詢未刪除的記錄
        final existing =
            await (_db.select(_db.flightTransitLocations)..where(
                  (t) =>
                      t.flightRecordId.equals(flightRecordId) &
                      t.stopOrder.equals(stopOrder) &
                      t.deletedAt.isNull(),
                ))
                .getSingleOrNull();

        if (existing != null) {
          // 已存在且未刪除，跳過
          continue;
        }

        // 不存在，新增
        await _db
            .into(_db.flightTransitLocations)
            .insert(
              FlightTransitLocationsCompanion.insert(
                flightRecordId: flightRecordId,
                locationId: (data['locationId'] as int?) ?? 0,
                stopOrder: Value(stopOrder),
              ),
            );
        debugPrint(
          'Downloaded flight_transit_location $id (stopOrder=$stopOrder)',
        );
      }
    } catch (e) {
      debugPrint('Error downloading flight_transit_locations: $e');
    }
  }

  /// 從 Firestore 下載事故記錄
  Future<void> _downloadIncidentRecords() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'incident_records',
      );

      debugPrint('下載事故記錄: 遠端有 ${snapshot.docs.length} 筆');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final incidentId = data['incidentId'];
        if (incidentId == null) continue;

        final existing =
            await (_db.select(_db.incidentRecord)
                  ..where((t) => t.incidentId.equals(incidentId as int)))
                .getSingleOrNull();

        if (existing != null) {
          debugPrint('事故記錄 $incidentId 已存在本地，跳過下載');
          continue;
        }

        await _db
            .into(_db.incidentRecord)
            .insert(
              IncidentRecordCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                incidentDate: data['incidentDate'] != null
                    ? DateTime.parse(data['incidentDate'])
                    : DateTime.now(),
                incidentPlaceCategoryId:
                    (data['incidentPlaceCategoryId'] as int?) ?? 1,
                incidentPlaceCategory2Id: Value(
                  data['incidentPlaceCategory2Id'] as int?,
                ),
                incidentPlaceFinal: Value(
                  data['incidentPlaceFinal'] as String?,
                ),
                notificationTime: data['notificationTime'] != null
                    ? Value(DateTime.parse(data['notificationTime']))
                    : const Value.absent(),
                notificationPerson: Value(
                  data['notificationPerson'] as String?,
                ),
                reportingUnitId: (data['reportingUnitId'] as int?) ?? 1,
                incomingPhone: Value(data['incomingPhone'] as String?),
                notificationToOccTime: data['notificationToOccTime'] != null
                    ? Value(DateTime.parse(data['notificationToOccTime']))
                    : const Value.absent(),
                teamDepartureTime: data['teamDepartureTime'] != null
                    ? Value(DateTime.parse(data['teamDepartureTime']))
                    : const Value.absent(),
                occArrived: Value(data['occArrived'] as bool? ?? false),
                beforeLanding: Value(data['beforeLanding'] as bool? ?? false),
                landingTime: data['landingTime'] != null
                    ? Value(DateTime.parse(data['landingTime']))
                    : const Value.absent(),
                medicalArrivalTime: data['medicalArrivalTime'] != null
                    ? Value(DateTime.parse(data['medicalArrivalTime']))
                    : const Value.absent(),
                examinationTime: data['examinationTime'] != null
                    ? Value(DateTime.parse(data['examinationTime']))
                    : const Value.absent(),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded incident_record $incidentId');
      }
    } catch (e) {
      debugPrint('Error downloading incident_records: $e');
    }
  }

  /// 從 Firestore 下載診斷證明書
  Future<void> _downloadCertificates() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'medical_certificates',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final certificateId = data['certificateId'];
        if (certificateId == null) continue;

        final existing =
            await (_db.select(_db.medicalCertificates)
                  ..where((t) => t.certificateId.equals(certificateId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        final issuanceDateStr = data['issuanceDate'] as String?;
        DateTime? issuanceDate;
        if (issuanceDateStr != null) {
          issuanceDate = DateTime.tryParse(issuanceDateStr);
        }

        await _db
            .into(_db.medicalCertificates)
            .insert(
              MedicalCertificatesCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                issuanceDate: Value(issuanceDate),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded medical_certificate $certificateId');
      }
    } catch (e) {
      debugPrint('Error downloading medical_certificates: $e');
    }
  }

  /// 從 Firestore 下載 TELEX 文件
  Future<void> _downloadTelexDocuments() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('telex_documents');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final documentId = data['documentId'];
        if (documentId == null) continue;

        final existing =
            await (_db.select(_db.telexDocuments)
                  ..where((t) => t.documentId.equals(documentId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        await _db
            .into(_db.telexDocuments)
            .insert(
              TelexDocumentsCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                toStationId: Value(data['toStationId'] as int?),
                fromStationId: Value(data['fromStationId'] as int?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded telex_document $documentId');
      }
    } catch (e) {
      debugPrint('Error downloading telex_documents: $e');
    }
  }

  /// 從 Firestore 下載聯絡人
  Future<void> _downloadContacts() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('contacts');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final id = data['id'];
        if (id == null) continue;

        final existing = await (_db.select(
          _db.contact,
        )..where((t) => t.id.equals(id as int))).getSingleOrNull();

        if (existing != null) continue;

        await _db
            .into(_db.contact)
            .insert(
              ContactCompanion.insert(
                name: (data['name'] as String?) ?? '',
                phone: Value(data['phone'] as String?),
                mobile: Value(data['mobile'] as String?),
                address: Value(data['address'] as String?),
                note: Value(data['note'] as String?),
                patientId: Value(data['patientId'] as int?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded contact $id');
      }
    } catch (e) {
      debugPrint('Error downloading contacts: $e');
    }
  }

  /// 從 Firestore 下載救護車記錄
  Future<void> _downloadAmbulanceRecords() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'ambulance_records',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final ambulanceId = data['ambulanceId'];
        if (ambulanceId == null) continue;

        final existing =
            await (_db.select(_db.ambulanceRecords)
                  ..where((t) => t.ambulanceId.equals(ambulanceId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        final dispatchTimeStr = data['dispatchTime'] as String?;
        DateTime? dispatchTime;
        if (dispatchTimeStr != null) {
          dispatchTime = DateTime.tryParse(dispatchTimeStr);
        }

        await _db
            .into(_db.ambulanceRecords)
            .insert(
              AmbulanceRecordsCompanion.insert(
                medicalId: Value((data['medicalId'] as int?) ?? 0),
                licensePlate: Value(data['licensePlate'] as String?),
                dispatchTime: Value(dispatchTime),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded ambulance_record $ambulanceId');
      }
    } catch (e) {
      debugPrint('Error downloading ambulance_records: $e');
    }
  }

  /// 從 Firestore 下載藥物記錄
  Future<void> _downloadMedications() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('medications');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final medicationId = data['medicationId'];
        if (medicationId == null) continue;

        final existing =
            await (_db.select(_db.medications)
                  ..where((t) => t.medicationId.equals(medicationId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        final createdAtStr = data['createdAt'] as String?;
        DateTime createdAt = DateTime.now();
        if (createdAtStr != null) {
          createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
        }

        await _db
            .into(_db.medications)
            .insert(
              MedicationsCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                name: Value(data['name'] as String?),
                method: Value(data['method'] as String?),
                frequency: Value(data['frequency'] as String?),
                days: Value(data['days'] as String?),
                dose: Value(data['dose'] as String?),
                unit: Value(data['unit'] as String?),
                remarks: Value(data['remarks'] as String?),
                createdAt: Value(createdAt),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded medication $medicationId');
      }
    } catch (e) {
      debugPrint('Error downloading medications: $e');
    }
  }

  /// 從 Firestore 下載急救處置
  Future<void> _downloadEmergencyTreatments() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'emergency_treatments',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final id = data['id'];
        if (id == null) continue;

        final existing = await (_db.select(
          _db.emergencyTreatment,
        )..where((t) => t.id.equals(id as int))).getSingleOrNull();

        if (existing != null) continue;

        final startTimeStr = data['startTime'] as String?;
        DateTime? startTime;
        if (startTimeStr != null) {
          startTime = DateTime.tryParse(startTimeStr);
        }

        await _db
            .into(_db.emergencyTreatment)
            .insert(
              EmergencyTreatmentCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                startTime: Value(startTime),
                diagnosis: Value(data['diagnosis'] as String?),
                incidentContext: Value(data['incidentContext'] as String?),
                intubationMethod: Value(data['intubationMethod'] as String?),
                intubationSize: Value(data['intubationSize'] as String?),
                ivLineSize: Value(data['ivLineSize'] as String?),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded emergency_treatment $id');
      }
    } catch (e) {
      debugPrint('Error downloading emergency_treatments: $e');
    }
  }

  // ============================================================
  // 新增：下載方法 (Download from Remote)
  // ============================================================

  /// 從 Firestore 下載主訴記錄
  Future<void> _downloadChiefComplaints() async {
    debugPrint('=== Downloading chief_complaints ===');
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'chief_complaints',
      );
      debugPrint('chief_complaints: Found ${snapshot.docs.length} docs');

      for (final doc in snapshot.docs) {
        debugPrint('Processing chief_complaint: ${doc.id}');

        final data = doc.data();

        final complaintId = data['complaintId'];
        if (complaintId == null) {
          debugPrint('  Skipping: complaintId is null');
          continue;
        }

        final existing =
            await (_db.select(_db.chiefComplaint)
                  ..where((t) => t.complaintId.equals(complaintId as int)))
                .getSingleOrNull();

        if (existing != null) {
          debugPrint('  Skipping: already exists');
          continue;
        }

        final createdAtStr = data['createdAt'] as String?;
        final onsetTimeStr = data['onsetTime'] as String?;
        DateTime createdAt = DateTime.now();
        DateTime? onsetTime;

        if (createdAtStr != null) {
          createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
        }
        if (onsetTimeStr != null) {
          onsetTime = DateTime.tryParse(onsetTimeStr);
        }

        await _db
            .into(_db.chiefComplaint)
            .insert(
              ChiefComplaintCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                chiefComplaintTypeId: Value(
                  data['chiefComplaintTypeId'] as int?,
                ),
                selectedSymptoms: Value(data['selectedSymptoms'] as String?),
                otherSymptomDetail: Value(
                  data['otherSymptomDetail'] as String?,
                ),
                chiefComplaintFinal: Value(
                  data['chiefComplaintFinal'] as String?,
                ),
                supplementaryNotes: Value(
                  data['supplementaryNotes'] as String?,
                ),
                onsetTime: Value(onsetTime),
                reportedBy: Value(data['reportedBy'] as String?),
                isConfirmed: Value(data['isConfirmed'] as bool? ?? false),
                createdAt: Value(createdAt),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded chief_complaint $complaintId');
      }
    } catch (e) {
      debugPrint('Error downloading chief_complaints: $e');
    }
  }

  /// 從 Firestore 下載病史記錄
  Future<void> _downloadMedicalHistories() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'medical_histories',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final historyId = data['historyId'];
        if (historyId == null) continue;

        final existing =
            await (_db.select(_db.medicalHistory)
                  ..where((t) => t.historyId.equals(historyId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        final createdAtStr = data['createdAt'] as String?;
        DateTime createdAt = DateTime.now();

        if (createdAtStr != null) {
          createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
        }

        await _db
            .into(_db.medicalHistory)
            .insert(
              MedicalHistoryCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                pastHistoryStatusId: Value(data['pastHistoryStatusId'] as int?),
                pastHistoryDetail: Value(data['pastHistoryDetail'] as String?),
                allergyStatusId: Value(data['allergyStatusId'] as int?),
                allergyDetail: Value(data['allergyDetail'] as String?),
                createdAt: Value(createdAt),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded medical_history $historyId');
      }
    } catch (e) {
      debugPrint('Error downloading medical_histories: $e');
    }
  }

  /// 從 Firestore 下載特別註記
  Future<void> _downloadSpecialNotes() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('special_notes');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final noteId = data['noteId'];
        if (noteId == null) continue;

        final existing = await (_db.select(
          _db.specialNotes,
        )..where((t) => t.noteId.equals(noteId as int))).getSingleOrNull();

        if (existing != null) continue;

        final createdAtStr = data['createdAt'] as String?;
        DateTime createdAt = DateTime.now();

        if (createdAtStr != null) {
          createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
        }

        await _db
            .into(_db.specialNotes)
            .insert(
              SpecialNotesCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                selectedNotes: Value(data['selectedNotes'] as String?),
                otherNotes: Value(data['otherNotes'] as String?),
                createdAt: Value(createdAt),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded special_note $noteId');
      }
    } catch (e) {
      debugPrint('Error downloading special_notes: $e');
    }
  }

  /// 從 Firestore 下載醫療影像
  Future<void> _downloadMedicalMedia() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot('medical_media');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        // 使用 doc.id 作為唯一識別（格式為 medicalId_mediaType）
        final docId = doc.id;

        // 從 doc.id 解析出 medicalId 和 mediaType
        final parts = docId.split('_');
        if (parts.length != 2) {
          debugPrint('Invalid doc.id format: $docId, skipping');
          continue;
        }

        final medicalId = int.tryParse(parts[0]);
        final mediaType = parts[1];

        if (medicalId == null) continue;

        // 檢查是否已有相同 medicalId + mediaType 的記錄
        final existingByType =
            await (_db.select(_db.medicalMedia)..where(
                  (t) =>
                      t.medicalId.equals(medicalId) &
                      t.mediaType.equals(mediaType),
                ))
                .getSingleOrNull();

        if (existingByType != null) {
          continue;
        }

        final createdAtStr = data['createdAt'] as String?;
        DateTime createdAt = DateTime.now();

        if (createdAtStr != null) {
          createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
        }

        await _db
            .into(_db.medicalMedia)
            .insert(
              MedicalMediaCompanion.insert(
                medicalId: medicalId,
                mediaType: mediaType,
                base64Data: data['base64Data'] as String? ?? '',
                description: Value(data['description'] as String?),
                createdAt: Value(createdAt),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
              ),
            );
        debugPrint('Downloaded medical_media $docId (type: $mediaType)');
      }
    } catch (e) {
      debugPrint('Error downloading medical_media: $e');
    }
  }

  /// 從 Firestore 下載醫療評估（生命徵象+理學檢查）
  Future<void> _downloadMedicalAssessments() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'medical_assessments',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final assessmentId = data['assessmentId'];
        if (assessmentId == null) continue;

        final existing =
            await (_db.select(_db.medicalAssessment)
                  ..where((t) => t.assessmentId.equals(assessmentId as int)))
                .getSingleOrNull();

        if (existing != null) continue;

        final assessmentTimeStr = data['assessmentTime'] as String?;
        DateTime assessmentTime = DateTime.now();

        if (assessmentTimeStr != null) {
          assessmentTime =
              DateTime.tryParse(assessmentTimeStr) ?? DateTime.now();
        }

        await _db
            .into(_db.medicalAssessment)
            .insert(
              MedicalAssessmentCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                temperature: Value(data['temperature'] as double?),
                pulse: Value(data['pulse'] as int?),
                breath: Value(data['breath'] as int?),
                systolic: Value(data['systolic'] as int?),
                diastolic: Value(data['diastolic'] as int?),
                spo2: Value(data['spo2'] as int?),
                painScore: Value(data['painScore'] as int?),
                consciousnessLevelId: Value(
                  data['consciousnessLevelId'] as int?,
                ),
                gcs: Value(data['gcs'] as int?),
                gcsE: Value(data['gcsE'] as String?),
                gcsM: Value(data['gcsM'] as String?),
                gcsV: Value(data['gcsV'] as String?),
                leftPupilReactionId: Value(data['leftPupilReactionId'] as int?),
                leftPupilReaction: Value(data['leftPupilReaction'] as String?),
                leftPupilSize: Value(data['leftPupilSize'] as double?),
                rightPupilReactionId: Value(
                  data['rightPupilReactionId'] as int?,
                ),
                rightPupilReaction: Value(
                  data['rightPupilReaction'] as String?,
                ),
                rightPupilSize: Value(data['rightPupilSize'] as double?),
                headNeckExam: Value(data['headNeckExam'] as String?),
                chestExam: Value(data['chestExam'] as String?),
                abdomenExam: Value(data['abdomenExam'] as String?),
                extremitiesExam: Value(data['extremitiesExam'] as String?),
                otherPhysicalExam: Value(data['otherPhysicalExam'] as String?),
                triageId: Value(data['triageId'] as int?),
                assessmentTime: Value(assessmentTime),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded medical_assessment $assessmentId');
      }
    } catch (e) {
      debugPrint('Error downloading medical_assessments: $e');
    }
  }

  // ============================================================
  // 新增：上傳方法 (Upload to Remote)
  // ============================================================

  /// 上傳醫療影像
  Future<void> _uploadMedicalMedia() async {
    final records = await (_db.select(
      _db.medicalMedia,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: medical_media - found ${records.length} records with syncStatus=1',
    );

    for (final record in records) {
      try {
        debugPrint(
          'UPLOAD: uploading medical_media ${record.mediaId}, type: ${record.mediaType}',
        );

        // 建立資料 map，過濾掉 null 值和空字串
        final Map<String, dynamic> data = {};

        // 只加入有值的欄位
        data['mediaId'] = record.mediaId;
        data['medicalId'] = record.medicalId;
        data['mediaType'] = record.mediaType;

        // base64Data 可能很大，只在有內容時加入
        if (record.base64Data.isNotEmpty) {
          data['base64Data'] = record.base64Data;
        }

        // description 只在非空時加入
        if (record.description != null && record.description!.isNotEmpty) {
          data['description'] = record.description;
        }

        data['createdAt'] = record.createdAt.toIso8601String();
        data['lastModified'] = FieldValue.serverTimestamp();

        debugPrint('UPLOAD: data keys: ${data.keys.toList()}');

        // 使用 medicalId + mediaType 作為 document ID，避免不同類型覆蓋
        final docId = '${record.medicalId}_${record.mediaType}';

        await _firebase.setDocument('medical_media', docId, data);

        await (_db.update(_db.medicalMedia)
              ..where((t) => t.mediaId.equals(record.mediaId)))
            .write(MedicalMediaCompanion(syncStatus: const Value(0)));
        debugPrint('UPLOAD: medical_media ${record.mediaId} success');
      } catch (e, stack) {
        debugPrint('Error uploading medical_media ${record.mediaId}: $e');
        debugPrint('Stack: $stack');
      }
    }
    debugPrint('Uploaded ${records.length} medical_media');
  }

  /// 上傳醫療評估（生命徵象+理學檢查）
  Future<void> _uploadMedicalAssessments() async {
    final records = await (_db.select(
      _db.medicalAssessment,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: medical_assessments - found ${records.length} records with syncStatus=1',
    );

    for (final record in records) {
      try {
        await _firebase.setDocument(
          'medical_assessments',
          record.assessmentId.toString(),
          {
            'assessmentId': record.assessmentId,
            'medicalId': record.medicalId,
            'temperature': record.temperature,
            'pulse': record.pulse,
            'breath': record.breath,
            'systolic': record.systolic,
            'diastolic': record.diastolic,
            'spo2': record.spo2,
            'painScore': record.painScore,
            'consciousnessLevelId': record.consciousnessLevelId,
            'gcs': record.gcs,
            'gcsE': record.gcsE,
            'gcsM': record.gcsM,
            'gcsV': record.gcsV,
            'leftPupilReactionId': record.leftPupilReactionId,
            'leftPupilReaction': record.leftPupilReaction,
            'leftPupilSize': record.leftPupilSize,
            'rightPupilReactionId': record.rightPupilReactionId,
            'rightPupilReaction': record.rightPupilReaction,
            'rightPupilSize': record.rightPupilSize,
            'headNeckExam': record.headNeckExam,
            'chestExam': record.chestExam,
            'abdomenExam': record.abdomenExam,
            'extremitiesExam': record.extremitiesExam,
            'otherPhysicalExam': record.otherPhysicalExam,
            'triageId': record.triageId,
            'assessmentTime': record.assessmentTime.toIso8601String(),
            'createdAt': record.assessmentTime.toIso8601String(),
            'lastModified': FieldValue.serverTimestamp(),
          },
        );

        await (_db.update(_db.medicalAssessment)
              ..where((t) => t.assessmentId.equals(record.assessmentId)))
            .write(MedicalAssessmentCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint(
          'Error uploading medical_assessment ${record.assessmentId}: $e',
        );
      }
    }
    debugPrint('Uploaded ${records.length} medical_assessments');
  }

  /// 上傳 CDC 健康評估表
  Future<void> _uploadHealthAssessments() async {
    final records = await (_db.select(
      _db.healthAssessmentForm,
    )..where((t) => t.syncStatus.equals(1))).get();

    debugPrint(
      'UPLOAD: health_assessments - found ${records.length} records with syncStatus=1',
    );

    for (final record in records) {
      try {
        debugPrint(
          'UPLOAD: uploading health_assessment ${record.assessmentFormId}',
        );
        await _firebase.setDocument(
          'health_assessments',
          record.assessmentFormId.toString(),
          {
            'assessmentFormId': record.assessmentFormId,
            'medicalId': record.medicalId,
            'name': record.name,
            'relation': record.relation,
            'temperature': record.temperature,
            'createdAt': record.createdAt.toIso8601String(),
            'lastModified': FieldValue.serverTimestamp(),
          },
        );

        await (_db.update(
              _db.healthAssessmentForm,
            )..where((t) => t.assessmentFormId.equals(record.assessmentFormId)))
            .write(HealthAssessmentFormCompanion(syncStatus: const Value(0)));
      } catch (e) {
        debugPrint(
          'Error uploading health_assessment ${record.assessmentFormId}: $e',
        );
      }
    }
    debugPrint('Uploaded ${records.length} health_assessments');
  }

  /// 從 Firestore 下載 CDC 健康評估表
  Future<void> _downloadHealthAssessments() async {
    try {
      final snapshot = await _firebase.getCollectionSnapshot(
        'health_assessments',
      );
      debugPrint('health_assessments: Found ${snapshot.docs.length} docs');

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final assessmentFormId = data['assessmentFormId'];
        if (assessmentFormId == null) continue;

        final existing =
            await (_db.select(_db.healthAssessmentForm)..where(
                  (t) => t.assessmentFormId.equals(assessmentFormId as int),
                ))
                .getSingleOrNull();

        if (existing != null) continue;

        final createdAtStr = data['createdAt'] as String?;
        DateTime createdAt = DateTime.now();

        if (createdAtStr != null) {
          createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
        }

        await _db
            .into(_db.healthAssessmentForm)
            .insert(
              HealthAssessmentFormCompanion.insert(
                medicalId: (data['medicalId'] as int?) ?? 0,
                name: data['name'] as String? ?? '',
                relation: Value(data['relation'] as String?),
                temperature: Value((data['temperature'] as num?)?.toDouble()),
                createdAt: Value(createdAt),
                syncStatus: const Value(0),
                remoteId: Value(doc.id),
                lastModified: Value(DateTime.now()),
              ),
            );
        debugPrint('Downloaded health_assessment $assessmentFormId');
      }
    } catch (e) {
      debugPrint('Error downloading health_assessments: $e');
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
