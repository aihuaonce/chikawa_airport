import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../db/database.dart';
import '../db/dao/sync_dao.dart';
import '../db/dao/medical_dao.dart';
import '../db/dao/treatment_dao.dart';
import '../db/dao/certificate_dao.dart';
import '../db/dao/medical_fee_dao.dart';
import '../db/dao/nursing_record_dao.dart';
import '../db/dao/referral_form_dao.dart';
import '../db/dao/telex_dao.dart';
import '../db/dao/flight_dao.dart';
import '../db/dao/incident_dao.dart';
import '../db/dao/ambulance_dao.dart';
import '../db/tables/sync_tables.dart';
import 'network_service.dart';
import 'api_client.dart';
import '../sync/models/sync_models.dart';

class SyncService extends ChangeNotifier {
  final AppDatabase _db;
  final NetworkService _networkService;
  final ApiClient _apiClient;
  late final SyncDao _syncDao;
  late final MedicalDao _medicalDao;
  late final TreatmentDao _treatmentDao;
  late final CertificateDao _certificateDao;
  late final MedicalFeeDao _medicalFeeDao;
  late final NursingRecordDao _nursingRecordDao;
  late final ReferralFormDao _referralFormDao;
  late final TelexDao _telexDao;
  late final FlightDao _flightDao;
  late final IncidentDao _incidentDao;
  late final AmbulanceDao _ambulanceDao;

  SyncState _state = SyncState.idle;
  DateTime? _lastSyncTime;
  int _pendingCount = 0;
  String? _lastError;
  String? _deviceId;
  Timer? _periodicSyncTimer;
  int _conflictCount = 0;
  bool _isPushingPending = false;

  // Background sync interval (default: 15 minutes)
  static const Duration _syncInterval = Duration(minutes: 15);

  // Tables to include in snapshot (in FK order for proper resolution)
  static const List<String> snapshotTables = [
    'medical_records',
    'patients',
    'treatments',
    'medical_certificates',
    'medical_fees',
    'nursing_records',
    'referral_forms',
    'telex_documents',
    'flight_records',
    'incident_records',
    'ambulance_records',
    'ambulance_personal_property',
    'ambulance_fees',
    'ambulance_treatment_records',
    'ambulance_scene_records',
  ];

  SyncService({
    required AppDatabase db,
    required NetworkService networkService,
    required ApiClient apiClient,
  }) : _db = db,
       _networkService = networkService,
       _apiClient = apiClient {
    _syncDao = SyncDao(_db);
    _medicalDao = MedicalDao(_db);
    _treatmentDao = TreatmentDao(_db);
    _certificateDao = CertificateDao(_db);
    _medicalFeeDao = MedicalFeeDao(_db);
    _nursingRecordDao = NursingRecordDao(_db);
    _referralFormDao = ReferralFormDao(_db);
    _telexDao = TelexDao(_db);
    _flightDao = FlightDao(_db);
    _incidentDao = IncidentDao(_db);
    _ambulanceDao = AmbulanceDao(_db);
  }

  SyncState get state => _state;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingCount => _pendingCount;
  int get conflictCount => _conflictCount;
  String? get lastError => _lastError;
  bool get hasPendingChanges => _pendingCount > 0;
  bool get hasConflicts => _conflictCount > 0;
  bool get isOnline => _networkService.isOnline;
  String? get deviceId => _deviceId;

  Future<void> initialize() async {
    await _networkService.initialize();
    await _syncDao.deduplicatePendingLogs();
    _lastSyncTime = await _syncDao.getLastSyncTime();
    _pendingCount = await _syncDao.getPendingCount();

    _networkService.onConnectivityChanged.listen((isOnline) {
      if (isOnline && hasPendingChanges) {
        syncAll();
      }
    });

    // Start periodic background sync
    _startPeriodicSync();

    await _ensureDeviceId();
    notifyListeners();
  }

  Future<void> _ensureDeviceId() async {
    var deviceId = await _syncDao.getDeviceId();
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _syncDao.setDeviceId(deviceId);
    }
    _deviceId = deviceId;
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(_syncInterval, (_) {
      if (_networkService.isOnline) {
        debugPrint('Periodic background sync triggered');
        syncAll();
      }
    });
    debugPrint(
      'Periodic background sync started (interval: ${_syncInterval.inMinutes} minutes)',
    );
  }

  void _stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  void setPeriodicSyncEnabled(bool enabled) {
    if (enabled) {
      _startPeriodicSync();
    } else {
      _stopPeriodicSync();
    }
  }

  /// Sync triggered when user returns to home screen
  /// This is the main entry point for compare-first sync
  Future<SyncResult> syncOnHomeReturn() async {
    return syncAll();
  }

  /// Main sync method - compare-first approach
  Future<SyncResult> syncAll() async {
    if (_state == SyncState.syncing) {
      return SyncResult(
        success: false,
        errorMessage: 'Sync already in progress',
      );
    }

    if (!_networkService.isOnline) {
      _state = SyncState.offline;
      _lastError = 'No network connection';
      notifyListeners();
      return SyncResult(success: false, errorMessage: 'No network');
    }

    _state = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      // Step 1: Build local snapshot
      debugPrint('Building local snapshot...');
      final snapshot = await buildLocalSnapshot();
      debugPrint('Snapshot: ${snapshot.length} records');

      // Step 2: Compare with server
      debugPrint('Comparing with server...');
      final compareResponse = await _apiClient.compareSnapshot(
        CompareRequest(deviceId: _deviceId!, snapshot: snapshot),
      );

      // Step 3: Handle uploads (Flutter has newer data)
      if (compareResponse.toUpload.isNotEmpty) {
        debugPrint('Uploading ${compareResponse.toUpload.length} records...');
        await _handleUploads(compareResponse.toUpload);
      }

      // Step 4: Handle downloads (Server has newer data)
      if (compareResponse.toDownload.isNotEmpty) {
        debugPrint(
          'Downloading ${compareResponse.toDownload.length} records...',
        );
        await _handleDownloads(compareResponse.toDownload);
      }

      // Step 5: Handle conflicts
      if (compareResponse.conflicts.isNotEmpty) {
        debugPrint('Handling ${compareResponse.conflicts.length} conflicts...');
        await _handleConflicts(compareResponse.conflicts);
        _conflictCount = compareResponse.conflicts.length;
      }

      // Step 6: Update last sync time
      _lastSyncTime = compareResponse.serverTimestamp.toLocal();
      await _syncDao.setLastSyncTime(_lastSyncTime!);
      _pendingCount = await _syncDao.getPendingCount();

      _state = SyncState.idle;
      notifyListeners();

      return SyncResult(
        success: true,
        pushedCount: compareResponse.toUpload.length,
        pulledCount: compareResponse.toDownload.length,
        conflictCount: compareResponse.conflicts.length,
      );
    } catch (e) {
      _state = SyncState.error;
      _lastError = e.toString();
      notifyListeners();
      return SyncResult(success: false, errorMessage: e.toString());
    }
  }

  /// Build local snapshot from all tables
  /// Returns list of { table, id, lastModified }
  Future<List<LocalSnapshot>> buildLocalSnapshot() async {
    final snapshot = <LocalSnapshot>[];

    for (final tableName in snapshotTables) {
      try {
        final tableSnapshot = await _buildTableSnapshot(tableName);
        snapshot.addAll(tableSnapshot);
      } catch (e) {
        debugPrint('Error building snapshot for $tableName: $e');
      }
    }

    return snapshot;
  }

  Future<List<LocalSnapshot>> _buildTableSnapshot(String tableName) async {
    final snapshot = <LocalSnapshot>[];

    switch (tableName) {
      case 'medical_records':
        final records = await _db.select(_db.medicalRecord).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'medical_records',
              id: record.medicalId,
              lastModified:
                  record.lastModified?.millisecondsSinceEpoch ??
                  record.updatedAt.millisecondsSinceEpoch,
            ),
          );
        }
        break;
      case 'patients':
        final records = await _db.select(_db.patient).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'patients',
              id: record.patientId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'treatments':
        final records = await _db.select(_db.treatment).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'treatments',
              id: record.treatmentId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'medical_certificates':
        final records = await _db.select(_db.medicalCertificates).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'medical_certificates',
              id: record.certificateId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'medical_fees':
        final records = await _db.select(_db.medicalFees).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'medical_fees',
              id: record.feeId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'nursing_records':
        final records = await _db.select(_db.nursingRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'nursing_records',
              id: record.recordId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'referral_forms':
        final records = await _db.select(_db.referralForms).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'referral_forms',
              id: record.formId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'telex_documents':
        final records = await _db.select(_db.telexDocuments).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'telex_documents',
              id: record.documentId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'flight_records':
        final records = await _db.select(_db.flightRecord).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'flight_records',
              id: record.flightRecordId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'incident_records':
        final records = await _db.select(_db.incidentRecord).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'incident_records',
              id: record.incidentId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_records':
        final records = await _db.select(_db.ambulanceRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_records',
              id: record.ambulanceId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_personal_property':
        final records = await _db.select(_db.ambulancePersonalProperty).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_personal_property',
              id: record.id,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_fees':
        final records = await _db.select(_db.ambulanceFees).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_fees',
              id: record.feeId,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_treatment_records':
        final records = await _db.select(_db.ambulanceTreatmentRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_treatment_records',
              id: record.id,
              lastModified: record.lastModified?.millisecondsSinceEpoch ?? 0,
            ),
          );
        }
        break;
      case 'ambulance_scene_records':
        final records = await _db.select(_db.ambulanceSceneRecords).get();
        for (final record in records) {
          snapshot.add(
            LocalSnapshot(
              table: 'ambulance_scene_records',
              id: record.id,
              lastModified: record.updatedAt.millisecondsSinceEpoch,
            ),
          );
        }
        break;
    }

    return snapshot;
  }

  /// Handle uploads - push records that Flutter has but server doesn't
  Future<void> _handleUploads(List<UploadItem> toUpload) async {
    final pushChanges = <PushChange>[];

    for (final item in toUpload) {
      final fullData = await _resolveFullRecordData(item.table, item.id);
      if (fullData != null) {
        pushChanges.add(
          PushChange(
            table: item.table,
            localId: item.id,
            operation: 'upsert',
            data: fullData,
          ),
        );
      }
    }

    if (pushChanges.isEmpty) return;

    final request = PushRequest(
      clientTimestamp: DateTime.now().toUtc(),
      deviceId: _deviceId!,
      changes: pushChanges,
    );

    try {
      final response = await _apiClient.pushChanges(request);
      final syncedAt = response.serverTimestamp.toUtc();

      for (final result in response.results) {
        if (result.status == 'success') {
          await _markAsSynced(
            result.table,
            result.localId,
            result.remoteId ?? '',
            syncedAt,
          );
        }
      }

      for (final conflict in response.conflicts) {
        await _resolvePushConflict(conflict);
      }
    } catch (e) {
      debugPrint('Push error: $e');
      rethrow;
    }
  }

  /// Resolve full record data from local DB for upload
  Future<Map<String, dynamic>?> _resolveFullRecordData(
    String table,
    int id,
  ) async {
    switch (table) {
      case 'medical_records':
        final record = await (_db.select(
          _db.medicalRecord,
        )..where((t) => t.medicalId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'medicalId': record.medicalId,
          'isEmergency': record.isEmergency,
          'hasAmbulance': record.hasAmbulance,
          'cdcPassed': record.cdcPassed,
          'screeningMethod': record.screeningMethod,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'patients':
        final record = await (_db.select(
          _db.patient,
        )..where((t) => t.patientId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'patientId': record.patientId,
          'medicalId': record.medicalId,
          'name': record.name,
          'anonymizationName': record.anonymizationName,
          'birthday': record.birthday?.millisecondsSinceEpoch,
          'sexId': record.sexId,
          'passportOrIdNo': record.passportOrIdNo,
          'idNo': record.idNo,
          'visitReasonId': record.visitReasonId,
          'nationalityId': record.nationalityId,
          'telephone': record.telephone,
          'address': record.address,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'treatments':
        final record = await (_db.select(
          _db.treatment,
        )..where((t) => t.treatmentId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'treatmentId': record.treatmentId,
          'medicalId': record.medicalId,
          'tentativeCategoryId': record.tentativeCategoryId,
          'tentative': record.tentative,
          'secondaryDiagnosis1': record.secondaryDiagnosis1,
          'secondaryDiagnosis2': record.secondaryDiagnosis2,
          'triageId': record.triageId,
          'treatmentOnSiteId': record.treatmentOnSiteId,
          'actionSummary': record.actionSummary,
          'actionSummaryOther': record.actionSummaryOther,
          'ekgInterpretation': record.ekgInterpretation,
          'glucose': record.glucose,
          'intubationMethod': record.intubationMethod,
          'oxygenMethod': record.oxygenMethod,
          'oxygenFlow': record.oxygenFlow,
          'certificateLogs': record.certificateLogs,
          'resultId': record.resultId,
          'transportRequired': record.transportRequired,
          'transportMethod': record.transportMethod,
          'referralHospitalId': record.referralHospitalId,
          'referralHospitalFinal': record.referralHospitalFinal,
          'ambulanceStaffId': record.ambulanceStaffId,
          'arrivalTime': record.arrivalTime?.millisecondsSinceEpoch,
          'clearanceId': record.clearanceId,
          'expeditedClearanceId': record.expeditedClearanceId,
          'doctorOrderCh': record.doctorOrderCh,
          'doctorOrderEn': record.doctorOrderEn,
          'directorName': record.directorName,
          'assistStaff': record.assistStaff,
          'treatmentTime': record.treatmentTime.millisecondsSinceEpoch,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'medical_certificates':
        final record = await (_db.select(
          _db.medicalCertificates,
        )..where((t) => t.certificateId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'certificateId': record.certificateId,
          'medicalId': record.medicalId,
          'diagnosisCategoryId': record.diagnosisCategoryId,
          'diagnosisResult': record.diagnosisResult,
          'chineseAdvice': record.chineseAdvice,
          'englishAdvice': record.englishAdvice,
          'issuanceDate': record.issuanceDate?.millisecondsSinceEpoch,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'medical_fees':
        final record = await (_db.select(
          _db.medicalFees,
        )..where((t) => t.feeId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'feeId': record.feeId,
          'medicalId': record.medicalId,
          'paymentMethodId': record.paymentMethodId,
          'paymentType': record.paymentType,
          'consultFee': record.consultFee,
          'ambulanceFee': record.ambulanceFee,
          'currencyId': record.currencyId,
          'collectionStatusId': record.collectionStatusId,
          'receiptIssued': record.receiptIssued,
          'userAgreed': record.userAgreed,
          'applicantName': record.applicantName,
          'applicantUnit': record.applicantUnit,
          'applicantPhone': record.applicantPhone,
          'abnormalReason': record.abnormalReason,
          'remarks': record.remarks,
          'consenterSignature': record.consenterSignature,
          'witnessSignature': record.witnessSignature,
          'counterSignature': record.counterSignature,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'nursing_records':
        final record = await (_db.select(
          _db.nursingRecords,
        )..where((t) => t.recordId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'recordId': record.recordId,
          'medicalId': record.medicalId,
          'recordTime': record.recordTime.millisecondsSinceEpoch,
          'content': record.content,
          'nurseId': record.nurseId,
          'signature': record.signature,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'referral_forms':
        final record = await (_db.select(
          _db.referralForms,
        )..where((t) => t.formId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'formId': record.formId,
          'medicalId': record.medicalId,
          'contactName': record.contactName,
          'contactIdNo': record.contactIdNo,
          'contactPhone': record.contactPhone,
          'contactAddress': record.contactAddress,
          'primaryDiagnosis': record.primaryDiagnosis,
          'secondaryDiagnosis1': record.secondaryDiagnosis1,
          'secondaryDiagnosis2': record.secondaryDiagnosis2,
          'recentExamResult': record.recentExamResult,
          'examDate': record.examDate?.millisecondsSinceEpoch,
          'recentMedication': record.recentMedication,
          'medicationDate': record.medicationDate?.millisecondsSinceEpoch,
          'referralPurposeId': record.referralPurposeId,
          'otherPurpose': record.otherPurpose,
          'doctorName': record.doctorName,
          'doctorDepartment': record.doctorDepartment,
          'doctorSignature': record.doctorSignature,
          'orderDate': record.orderDate?.millisecondsSinceEpoch,
          'notes': record.notes,
          'hospitalName': record.hospitalName,
          'hospitalDept': record.hospitalDept,
          'hospitalDoctor': record.hospitalDoctor,
          'hospitalPhone': record.hospitalPhone,
          'hospitalAddress': record.hospitalAddress,
          'scheduledDate': record.scheduledDate?.millisecondsSinceEpoch,
          'scheduledDept': record.scheduledDept,
          'scheduledRoom': record.scheduledRoom,
          'scheduledNumber': record.scheduledNumber,
          'relationshipId': record.relationshipId,
          'otherRelationship': record.otherRelationship,
          'consentSignature': record.consentSignature,
          'consentDateTime': record.consentDateTime?.millisecondsSinceEpoch,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'telex_documents':
        final record = await (_db.select(
          _db.telexDocuments,
        )..where((t) => t.documentId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'documentId': record.documentId,
          'medicalId': record.medicalId,
          'toStationId': record.toStationId,
          'fromStationId': record.fromStationId,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'flight_records':
        final record = await (_db.select(
          _db.flightRecord,
        )..where((t) => t.flightRecordId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'flightRecordId': record.flightRecordId,
          'medicalId': record.medicalId,
          'airlineId': record.airlineId,
          'flightNumber': record.flightNumber,
          'travelStatusId': record.travelStatusId,
          'departureLocationId': record.departureLocationId,
          'arrivalLocationId': record.arrivalLocationId,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'incident_records':
        final record = await (_db.select(
          _db.incidentRecord,
        )..where((t) => t.incidentId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'incidentId': record.incidentId,
          'medicalId': record.medicalId,
          'incidentDate': record.incidentDate.millisecondsSinceEpoch,
          'incidentPlaceCategoryId': record.incidentPlaceCategoryId,
          'incidentPlaceCategory2Id': record.incidentPlaceCategory2Id,
          'incidentPlaceFinal': record.incidentPlaceFinal,
          'notificationTime': record.notificationTime?.millisecondsSinceEpoch,
          'notificationPerson': record.notificationPerson,
          'reportingUnitId': record.reportingUnitId,
          'incomingPhone': record.incomingPhone,
          'notificationToOccTime':
              record.notificationToOccTime?.millisecondsSinceEpoch,
          'teamDepartureTime': record.teamDepartureTime?.millisecondsSinceEpoch,
          'occArrived': record.occArrived,
          'beforeLanding': record.beforeLanding,
          'landingTime': record.landingTime?.millisecondsSinceEpoch,
          'medicalArrivalTime':
              record.medicalArrivalTime?.millisecondsSinceEpoch,
          'examinationTime': record.examinationTime?.millisecondsSinceEpoch,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'ambulance_records':
        final record = await (_db.select(
          _db.ambulanceRecords,
        )..where((t) => t.ambulanceId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'ambulanceId': record.ambulanceId,
          'medicalId': record.medicalId,
          'licensePlate': record.licensePlate,
          'incidentLocationId': record.incidentLocationId,
          'incidentLocation2Id': record.incidentLocation2Id,
          'locationRemarks': record.locationRemarks,
          'dispatchTime': record.dispatchTime?.millisecondsSinceEpoch,
          'arrivalTime': record.arrivalTime?.millisecondsSinceEpoch,
          'hospitalId': record.hospitalId,
          'transportReason': record.transportReason,
          'leavingSceneTime': record.leavingSceneTime?.millisecondsSinceEpoch,
          'arrivalHospitalTime':
              record.arrivalHospitalTime?.millisecondsSinceEpoch,
          'leavingHospitalTime':
              record.leavingHospitalTime?.millisecondsSinceEpoch,
          'returnStandbyTime': record.returnStandbyTime?.millisecondsSinceEpoch,
          'bodyMapJson': record.bodyMapJson,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'ambulance_personal_property':
        final record = await (_db.select(
          _db.ambulancePersonalProperty,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'id': record.id,
          'medicalId': record.medicalId,
          'financialDetails': record.financialDetails,
          'isHandled': record.isHandled,
          'custodianName': record.custodianName,
          'custodianSignature': record.custodianSignature,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'ambulance_fees':
        final record = await (_db.select(
          _db.ambulanceFees,
        )..where((t) => t.feeId.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'feeId': record.feeId,
          'medicalId': record.medicalId,
          'ambulanceFee': record.ambulanceFee,
          'oxygenFee': record.oxygenFee,
          'paymentStatus': record.paymentStatus,
          'paymentMethod': record.paymentMethod,
          'unpaidType': record.unpaidType,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'ambulance_treatment_records':
        final record = await (_db.select(
          _db.ambulanceTreatmentRecords,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'id': record.id,
          'medicalId': record.medicalId,
          'doctorInstructions': record.doctorInstructions,
          'receivingHospital': record.receivingHospital,
          'receivingTime': record.receivingTime,
          'isRefusedHospital': record.isRefusedHospital,
          'relationship': record.relationship,
          'relativeName': record.relativeName,
          'relativePhone': record.relativePhone,
          'lastModified':
              record.lastModified?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        };

      case 'ambulance_scene_records':
        final record = await (_db.select(
          _db.ambulanceSceneRecords,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (record == null) return null;
        return {
          'id': record.id,
          'medicalId': record.medicalId,
          'patientComplaint': record.patientComplaint,
          'isProxyComplaint': record.isProxyComplaint,
          'fallHeight': record.fallHeight,
          'burnDegree': record.burnDegree,
          'burnArea': record.burnArea,
          'burnPercentage': record.burnPercentage,
          'otherTraumaNote': record.otherTraumaNote,
          'allergyStatus': record.allergyStatus,
          'allergyNote': record.allergyNote,
          'historyStatus': record.historyStatus,
          'historyNote': record.historyNote,
          'lastModified': record.updatedAt.millisecondsSinceEpoch,
        };

      default:
        debugPrint('Unknown table for upload: $table');
        return null;
    }
  }

  /// Handle downloads - apply records from server
  Future<void> _handleDownloads(List<RemoteRecord> toDownload) async {
    for (final record in toDownload) {
      try {
        await _applyRemoteChange(record.table, record.remoteId, record.data);
      } catch (e) {
        debugPrint('Error applying download ${record.table}: $e');
      }
    }
  }

  dynamic _rawValue(Map<String, dynamic> data, String camelKey) {
    if (data.containsKey(camelKey)) return data[camelKey];
    final snakeKey = camelKey.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (m) => '_${m.group(1)!.toLowerCase()}',
    );
    if (data.containsKey(snakeKey)) return data[snakeKey];
    return null;
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  bool? _asBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toUtc();
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      final asMs = int.tryParse(trimmed);
      if (asMs != null) {
        return DateTime.fromMillisecondsSinceEpoch(asMs, isUtc: true);
      }
      final parsed = DateTime.tryParse(trimmed);
      return parsed?.toUtc();
    }
    return null;
  }

  Uint8List? _asBytes(dynamic value) {
    if (value == null) return null;
    if (value is Uint8List) return value;
    if (value is List<int>) return Uint8List.fromList(value);
    if (value is List) {
      final values = <int>[];
      for (final item in value) {
        if (item is int) values.add(item);
      }
      return Uint8List.fromList(values);
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      try {
        return base64Decode(trimmed);
      } catch (_) {
        return null;
      }
    }
    if (value is Map) {
      final type = value['type'];
      final data = value['data'];
      if (type == 'Buffer' && data is List) {
        final values = <int>[];
        for (final item in data) {
          if (item is int) values.add(item);
        }
        return Uint8List.fromList(values);
      }
    }
    return null;
  }

  /// Apply a remote change to local DB
  Future<void> _applyRemoteChange(
    String table,
    String remoteId,
    Map<String, dynamic> data,
  ) async {
    final modifiedAt =
        _asDateTime(_rawValue(data, 'lastModified')) ?? DateTime.now().toUtc();

    switch (table) {
      case 'medical_records':
        final medicalId = _asInt(_rawValue(data, 'medicalId'));
        if (medicalId == null) return;
        final companion = MedicalRecordCompanion(
          medicalId: Value(medicalId),
          isEmergency: Value(_asBool(_rawValue(data, 'isEmergency')) ?? false),
          hasAmbulance: Value(
            _asBool(_rawValue(data, 'hasAmbulance')) ?? false,
          ),
          cdcPassed: Value(_asBool(_rawValue(data, 'cdcPassed'))),
          screeningMethod: Value(_asString(_rawValue(data, 'screeningMethod'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final updated = await (_db.update(
          _db.medicalRecord,
        )..where((t) => t.medicalId.equals(medicalId))).write(companion);
        if (updated == 0) {
          await _db.into(_db.medicalRecord).insert(companion);
        }
        break;

      case 'patients':
        final patientId = _asInt(_rawValue(data, 'patientId'));
        final patientMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (patientId == null || patientMedicalId == null) return;
        final patientCompanion = PatientCompanion(
          patientId: Value(patientId),
          medicalId: Value(patientMedicalId),
          name: Value(_asString(_rawValue(data, 'name'))),
          anonymizationName: Value(
            _asString(_rawValue(data, 'anonymizationName')),
          ),
          birthday: Value(_asDateTime(_rawValue(data, 'birthday'))),
          sexId: Value(_asInt(_rawValue(data, 'sexId')) ?? 1),
          passportOrIdNo: Value(_asString(_rawValue(data, 'passportOrIdNo'))),
          idNo: Value(_asString(_rawValue(data, 'idNo'))),
          visitReasonId: Value(_asInt(_rawValue(data, 'visitReasonId')) ?? 1),
          nationalityId: Value(_asInt(_rawValue(data, 'nationalityId'))),
          telephone: Value(_asString(_rawValue(data, 'telephone'))),
          address: Value(_asString(_rawValue(data, 'address'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final patientUpdated = await (_db.update(
          _db.patient,
        )..where((t) => t.patientId.equals(patientId))).write(patientCompanion);
        if (patientUpdated == 0) {
          await _db.into(_db.patient).insert(patientCompanion);
        }
        break;
      case 'treatments':
        final treatmentId = _asInt(_rawValue(data, 'treatmentId'));
        final treatmentMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (treatmentId == null || treatmentMedicalId == null) return;
        final treatmentCompanion = TreatmentCompanion(
          treatmentId: Value(treatmentId),
          medicalId: Value(treatmentMedicalId),
          tentativeCategoryId: Value(
            _asInt(_rawValue(data, 'tentativeCategoryId')),
          ),
          tentative: Value(_asString(_rawValue(data, 'tentative'))),
          secondaryDiagnosis1: Value(
            _asString(_rawValue(data, 'secondaryDiagnosis1')),
          ),
          secondaryDiagnosis2: Value(
            _asString(_rawValue(data, 'secondaryDiagnosis2')),
          ),
          triageId: Value(_asInt(_rawValue(data, 'triageId'))),
          treatmentOnSiteId: Value(
            _asInt(_rawValue(data, 'treatmentOnSiteId')),
          ),
          actionSummary: Value(_asString(_rawValue(data, 'actionSummary'))),
          actionSummaryOther: Value(
            _asString(_rawValue(data, 'actionSummaryOther')),
          ),
          ekgInterpretation: Value(
            _asString(_rawValue(data, 'ekgInterpretation')),
          ),
          glucose: Value(_asString(_rawValue(data, 'glucose'))),
          intubationMethod: Value(
            _asString(_rawValue(data, 'intubationMethod')),
          ),
          oxygenMethod: Value(_asString(_rawValue(data, 'oxygenMethod'))),
          oxygenFlow: Value(_asDouble(_rawValue(data, 'oxygenFlow'))),
          certificateLogs: Value(_asString(_rawValue(data, 'certificateLogs'))),
          resultId: Value(_asInt(_rawValue(data, 'resultId'))),
          transportRequired: Value(
            _asBool(_rawValue(data, 'transportRequired')),
          ),
          transportMethod: Value(_asString(_rawValue(data, 'transportMethod'))),
          referralHospitalId: Value(
            _asInt(_rawValue(data, 'referralHospitalId')),
          ),
          referralHospitalFinal: Value(
            _asString(_rawValue(data, 'referralHospitalFinal')),
          ),
          ambulanceStaffId: Value(_asInt(_rawValue(data, 'ambulanceStaffId'))),
          arrivalTime: Value(_asDateTime(_rawValue(data, 'arrivalTime'))),
          clearanceId: Value(_asInt(_rawValue(data, 'clearanceId'))),
          expeditedClearanceId: Value(
            _asInt(_rawValue(data, 'expeditedClearanceId')),
          ),
          doctorOrderCh: Value(_asString(_rawValue(data, 'doctorOrderCh'))),
          doctorOrderEn: Value(_asString(_rawValue(data, 'doctorOrderEn'))),
          directorName: Value(_asString(_rawValue(data, 'directorName'))),
          assistStaff: Value(_asString(_rawValue(data, 'assistStaff'))),
          treatmentTime: Value(
            _asDateTime(_rawValue(data, 'treatmentTime')) ?? modifiedAt,
          ),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final treatmentUpdated =
            await (_db.update(_db.treatment)
                  ..where((t) => t.treatmentId.equals(treatmentId)))
                .write(treatmentCompanion);
        if (treatmentUpdated == 0) {
          await _db.into(_db.treatment).insert(treatmentCompanion);
        }
        break;
      case 'medical_certificates':
        final certificateId = _asInt(_rawValue(data, 'certificateId'));
        final certificateMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (certificateId == null || certificateMedicalId == null) return;
        final certificateCompanion = MedicalCertificatesCompanion(
          certificateId: Value(certificateId),
          medicalId: Value(certificateMedicalId),
          diagnosisCategoryId: Value(
            _asInt(_rawValue(data, 'diagnosisCategoryId')),
          ),
          diagnosisResult: Value(_asString(_rawValue(data, 'diagnosisResult'))),
          chineseAdvice: Value(_asString(_rawValue(data, 'chineseAdvice'))),
          englishAdvice: Value(_asString(_rawValue(data, 'englishAdvice'))),
          issuanceDate: Value(_asDateTime(_rawValue(data, 'issuanceDate'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final certificateUpdated =
            await (_db.update(_db.medicalCertificates)
                  ..where((t) => t.certificateId.equals(certificateId)))
                .write(certificateCompanion);
        if (certificateUpdated == 0) {
          await _db.into(_db.medicalCertificates).insert(certificateCompanion);
        }
        break;
      case 'medical_fees':
        final feeId = _asInt(_rawValue(data, 'feeId'));
        final feeMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (feeId == null || feeMedicalId == null) return;
        final feeCompanion = MedicalFeesCompanion(
          feeId: Value(feeId),
          medicalId: Value(feeMedicalId),
          paymentMethodId: Value(_asInt(_rawValue(data, 'paymentMethodId'))),
          paymentType: Value(_asString(_rawValue(data, 'paymentType'))),
          consultFee: Value(_asDouble(_rawValue(data, 'consultFee')) ?? 0),
          ambulanceFee: Value(_asDouble(_rawValue(data, 'ambulanceFee')) ?? 0),
          currencyId: Value(_asInt(_rawValue(data, 'currencyId'))),
          collectionStatusId: Value(
            _asInt(_rawValue(data, 'collectionStatusId')),
          ),
          receiptIssued: Value(
            _asBool(_rawValue(data, 'receiptIssued')) ?? false,
          ),
          userAgreed: Value(_asBool(_rawValue(data, 'userAgreed')) ?? false),
          applicantName: Value(_asString(_rawValue(data, 'applicantName'))),
          applicantUnit: Value(_asString(_rawValue(data, 'applicantUnit'))),
          applicantPhone: Value(_asString(_rawValue(data, 'applicantPhone'))),
          abnormalReason: Value(_asString(_rawValue(data, 'abnormalReason'))),
          remarks: Value(_asString(_rawValue(data, 'remarks'))),
          consenterSignature: Value(
            _asBytes(_rawValue(data, 'consenterSignature')),
          ),
          witnessSignature: Value(
            _asBytes(_rawValue(data, 'witnessSignature')),
          ),
          counterSignature: Value(
            _asBytes(_rawValue(data, 'counterSignature')),
          ),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final feeUpdated = await (_db.update(
          _db.medicalFees,
        )..where((t) => t.feeId.equals(feeId))).write(feeCompanion);
        if (feeUpdated == 0) {
          await _db.into(_db.medicalFees).insert(feeCompanion);
        }
        break;
      case 'nursing_records':
        final recordId = _asInt(_rawValue(data, 'recordId'));
        final nursingMedicalId = _asInt(_rawValue(data, 'medicalId'));
        final recordTime = _asDateTime(_rawValue(data, 'recordTime'));
        if (recordId == null ||
            nursingMedicalId == null ||
            recordTime == null) {
          return;
        }
        final nursingCompanion = NursingRecordsCompanion(
          recordId: Value(recordId),
          medicalId: Value(nursingMedicalId),
          recordTime: Value(recordTime),
          content: Value(_asString(_rawValue(data, 'content'))),
          nurseId: Value(_asInt(_rawValue(data, 'nurseId'))),
          signature: Value(_asBytes(_rawValue(data, 'signature'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final nursingUpdated = await (_db.update(
          _db.nursingRecords,
        )..where((t) => t.recordId.equals(recordId))).write(nursingCompanion);
        if (nursingUpdated == 0) {
          await _db.into(_db.nursingRecords).insert(nursingCompanion);
        }
        break;
      case 'referral_forms':
        final formId = _asInt(_rawValue(data, 'formId'));
        final referralMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (formId == null || referralMedicalId == null) return;
        final referralCompanion = ReferralFormsCompanion(
          formId: Value(formId),
          medicalId: Value(referralMedicalId),
          contactName: Value(_asString(_rawValue(data, 'contactName'))),
          contactIdNo: Value(_asString(_rawValue(data, 'contactIdNo'))),
          contactPhone: Value(_asString(_rawValue(data, 'contactPhone'))),
          contactAddress: Value(_asString(_rawValue(data, 'contactAddress'))),
          primaryDiagnosis: Value(
            _asString(_rawValue(data, 'primaryDiagnosis')),
          ),
          secondaryDiagnosis1: Value(
            _asString(_rawValue(data, 'secondaryDiagnosis1')),
          ),
          secondaryDiagnosis2: Value(
            _asString(_rawValue(data, 'secondaryDiagnosis2')),
          ),
          recentExamResult: Value(
            _asString(_rawValue(data, 'recentExamResult')),
          ),
          examDate: Value(_asDateTime(_rawValue(data, 'examDate'))),
          recentMedication: Value(
            _asString(_rawValue(data, 'recentMedication')),
          ),
          medicationDate: Value(_asDateTime(_rawValue(data, 'medicationDate'))),
          referralPurposeId: Value(
            _asInt(_rawValue(data, 'referralPurposeId')),
          ),
          otherPurpose: Value(_asString(_rawValue(data, 'otherPurpose'))),
          doctorName: Value(_asString(_rawValue(data, 'doctorName'))),
          doctorDepartment: Value(
            _asString(_rawValue(data, 'doctorDepartment')),
          ),
          doctorSignature: Value(_asBytes(_rawValue(data, 'doctorSignature'))),
          orderDate: Value(_asDateTime(_rawValue(data, 'orderDate'))),
          notes: Value(_asString(_rawValue(data, 'notes'))),
          hospitalName: Value(_asString(_rawValue(data, 'hospitalName'))),
          hospitalDept: Value(_asString(_rawValue(data, 'hospitalDept'))),
          hospitalDoctor: Value(_asString(_rawValue(data, 'hospitalDoctor'))),
          hospitalPhone: Value(_asString(_rawValue(data, 'hospitalPhone'))),
          hospitalAddress: Value(_asString(_rawValue(data, 'hospitalAddress'))),
          scheduledDate: Value(_asDateTime(_rawValue(data, 'scheduledDate'))),
          scheduledDept: Value(_asString(_rawValue(data, 'scheduledDept'))),
          scheduledRoom: Value(_asString(_rawValue(data, 'scheduledRoom'))),
          scheduledNumber: Value(_asString(_rawValue(data, 'scheduledNumber'))),
          relationshipId: Value(_asInt(_rawValue(data, 'relationshipId'))),
          otherRelationship: Value(
            _asString(_rawValue(data, 'otherRelationship')),
          ),
          consentSignature: Value(
            _asBytes(_rawValue(data, 'consentSignature')),
          ),
          consentDateTime: Value(
            _asDateTime(_rawValue(data, 'consentDateTime')),
          ),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final referralUpdated = await (_db.update(
          _db.referralForms,
        )..where((t) => t.formId.equals(formId))).write(referralCompanion);
        if (referralUpdated == 0) {
          await _db.into(_db.referralForms).insert(referralCompanion);
        }
        break;
      case 'telex_documents':
        final documentId = _asInt(_rawValue(data, 'documentId'));
        final telexMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (documentId == null || telexMedicalId == null) return;
        final telexCompanion = TelexDocumentsCompanion(
          documentId: Value(documentId),
          medicalId: Value(telexMedicalId),
          toStationId: Value(_asInt(_rawValue(data, 'toStationId'))),
          fromStationId: Value(_asInt(_rawValue(data, 'fromStationId'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final telexUpdated = await (_db.update(
          _db.telexDocuments,
        )..where((t) => t.documentId.equals(documentId))).write(telexCompanion);
        if (telexUpdated == 0) {
          await _db.into(_db.telexDocuments).insert(telexCompanion);
        }
        break;
      case 'flight_records':
        final flightRecordId = _asInt(_rawValue(data, 'flightRecordId'));
        final flightMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (flightRecordId == null || flightMedicalId == null) return;
        final flightCompanion = FlightRecordCompanion(
          flightRecordId: Value(flightRecordId),
          medicalId: Value(flightMedicalId),
          airlineId: Value(_asInt(_rawValue(data, 'airlineId'))),
          flightNumber: Value(_asString(_rawValue(data, 'flightNumber')) ?? ''),
          travelStatusId: Value(_asInt(_rawValue(data, 'travelStatusId'))),
          departureLocationId: Value(
            _asInt(_rawValue(data, 'departureLocationId')),
          ),
          arrivalLocationId: Value(
            _asInt(_rawValue(data, 'arrivalLocationId')),
          ),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final flightUpdated =
            await (_db.update(_db.flightRecord)
                  ..where((t) => t.flightRecordId.equals(flightRecordId)))
                .write(flightCompanion);
        if (flightUpdated == 0) {
          await _db.into(_db.flightRecord).insert(flightCompanion);
        }
        break;
      case 'incident_records':
        final incidentId = _asInt(_rawValue(data, 'incidentId'));
        final incidentMedicalId = _asInt(_rawValue(data, 'medicalId'));
        final incidentDate = _asDateTime(_rawValue(data, 'incidentDate'));
        final incidentPlaceCategoryId = _asInt(
          _rawValue(data, 'incidentPlaceCategoryId'),
        );
        final reportingUnitId = _asInt(_rawValue(data, 'reportingUnitId'));
        if (incidentId == null ||
            incidentMedicalId == null ||
            incidentDate == null ||
            incidentPlaceCategoryId == null ||
            reportingUnitId == null) {
          return;
        }
        final incidentCompanion = IncidentRecordCompanion(
          incidentId: Value(incidentId),
          medicalId: Value(incidentMedicalId),
          incidentDate: Value(incidentDate),
          incidentPlaceCategoryId: Value(incidentPlaceCategoryId),
          incidentPlaceCategory2Id: Value(
            _asInt(_rawValue(data, 'incidentPlaceCategory2Id')),
          ),
          incidentPlaceFinal: Value(
            _asString(_rawValue(data, 'incidentPlaceFinal')),
          ),
          notificationTime: Value(
            _asDateTime(_rawValue(data, 'notificationTime')),
          ),
          notificationPerson: Value(
            _asString(_rawValue(data, 'notificationPerson')),
          ),
          reportingUnitId: Value(reportingUnitId),
          incomingPhone: Value(_asString(_rawValue(data, 'incomingPhone'))),
          notificationToOccTime: Value(
            _asDateTime(_rawValue(data, 'notificationToOccTime')),
          ),
          teamDepartureTime: Value(
            _asDateTime(_rawValue(data, 'teamDepartureTime')),
          ),
          occArrived: Value(_asBool(_rawValue(data, 'occArrived')) ?? false),
          beforeLanding: Value(
            _asBool(_rawValue(data, 'beforeLanding')) ?? false,
          ),
          landingTime: Value(_asDateTime(_rawValue(data, 'landingTime'))),
          medicalArrivalTime: Value(
            _asDateTime(_rawValue(data, 'medicalArrivalTime')),
          ),
          examinationTime: Value(
            _asDateTime(_rawValue(data, 'examinationTime')),
          ),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final incidentUpdated =
            await (_db.update(_db.incidentRecord)
                  ..where((t) => t.incidentId.equals(incidentId)))
                .write(incidentCompanion);
        if (incidentUpdated == 0) {
          await _db.into(_db.incidentRecord).insert(incidentCompanion);
        }
        break;
      case 'ambulance_records':
        final ambulanceId = _asInt(_rawValue(data, 'ambulanceId'));
        if (ambulanceId == null) return;
        final ambulanceCompanion = AmbulanceRecordsCompanion(
          ambulanceId: Value(ambulanceId),
          medicalId: Value(_asInt(_rawValue(data, 'medicalId'))),
          licensePlate: Value(_asString(_rawValue(data, 'licensePlate'))),
          incidentLocationId: Value(
            _asInt(_rawValue(data, 'incidentLocationId')),
          ),
          incidentLocation2Id: Value(
            _asInt(_rawValue(data, 'incidentLocation2Id')),
          ),
          locationRemarks: Value(_asString(_rawValue(data, 'locationRemarks'))),
          dispatchTime: Value(_asDateTime(_rawValue(data, 'dispatchTime'))),
          arrivalTime: Value(_asDateTime(_rawValue(data, 'arrivalTime'))),
          hospitalId: Value(_asInt(_rawValue(data, 'hospitalId'))),
          transportReason: Value(_asString(_rawValue(data, 'transportReason'))),
          leavingSceneTime: Value(
            _asDateTime(_rawValue(data, 'leavingSceneTime')),
          ),
          arrivalHospitalTime: Value(
            _asDateTime(_rawValue(data, 'arrivalHospitalTime')),
          ),
          leavingHospitalTime: Value(
            _asDateTime(_rawValue(data, 'leavingHospitalTime')),
          ),
          returnStandbyTime: Value(
            _asDateTime(_rawValue(data, 'returnStandbyTime')),
          ),
          bodyMapJson: Value(_asString(_rawValue(data, 'bodyMapJson'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final ambulanceUpdated =
            await (_db.update(_db.ambulanceRecords)
                  ..where((t) => t.ambulanceId.equals(ambulanceId)))
                .write(ambulanceCompanion);
        if (ambulanceUpdated == 0) {
          await _db.into(_db.ambulanceRecords).insert(ambulanceCompanion);
        }
        break;
      case 'ambulance_personal_property':
        final personalPropertyId = _asInt(_rawValue(data, 'id'));
        final personalPropertyMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (personalPropertyId == null || personalPropertyMedicalId == null) {
          return;
        }
        final personalPropertyCompanion = AmbulancePersonalPropertyCompanion(
          id: Value(personalPropertyId),
          medicalId: Value(personalPropertyMedicalId),
          financialDetails: Value(
            _asString(_rawValue(data, 'financialDetails')),
          ),
          isHandled: Value(_asBool(_rawValue(data, 'isHandled')) ?? false),
          custodianName: Value(_asString(_rawValue(data, 'custodianName'))),
          custodianSignature: Value(
            _asBytes(_rawValue(data, 'custodianSignature')),
          ),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final personalPropertyUpdated =
            await (_db.update(_db.ambulancePersonalProperty)
                  ..where((t) => t.id.equals(personalPropertyId)))
                .write(personalPropertyCompanion);
        if (personalPropertyUpdated == 0) {
          await _db
              .into(_db.ambulancePersonalProperty)
              .insert(personalPropertyCompanion);
        }
        break;
      case 'ambulance_fees':
        final ambulanceFeeId = _asInt(_rawValue(data, 'feeId'));
        final ambulanceFeeMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (ambulanceFeeId == null || ambulanceFeeMedicalId == null) return;
        final ambulanceFeeCompanion = AmbulanceFeesCompanion(
          feeId: Value(ambulanceFeeId),
          medicalId: Value(ambulanceFeeMedicalId),
          ambulanceFee: Value(_asDouble(_rawValue(data, 'ambulanceFee')) ?? 0),
          oxygenFee: Value(_asDouble(_rawValue(data, 'oxygenFee')) ?? 0),
          paymentStatus: Value(_asString(_rawValue(data, 'paymentStatus'))),
          paymentMethod: Value(_asString(_rawValue(data, 'paymentMethod'))),
          unpaidType: Value(_asString(_rawValue(data, 'unpaidType'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final ambulanceFeeUpdated =
            await (_db.update(_db.ambulanceFees)
                  ..where((t) => t.feeId.equals(ambulanceFeeId)))
                .write(ambulanceFeeCompanion);
        if (ambulanceFeeUpdated == 0) {
          await _db.into(_db.ambulanceFees).insert(ambulanceFeeCompanion);
        }
        break;
      case 'ambulance_treatment_records':
        final ambulanceTreatmentId = _asInt(_rawValue(data, 'id'));
        final ambulanceTreatmentMedicalId = _asInt(
          _rawValue(data, 'medicalId'),
        );
        if (ambulanceTreatmentId == null ||
            ambulanceTreatmentMedicalId == null) {
          return;
        }
        final ambulanceTreatmentCompanion = AmbulanceTreatmentRecordsCompanion(
          id: Value(ambulanceTreatmentId),
          medicalId: Value(ambulanceTreatmentMedicalId),
          doctorInstructions: Value(
            _asString(_rawValue(data, 'doctorInstructions')),
          ),
          receivingHospital: Value(
            _asString(_rawValue(data, 'receivingHospital')),
          ),
          receivingTime: Value(_asString(_rawValue(data, 'receivingTime'))),
          isRefusedHospital: Value(
            _asBool(_rawValue(data, 'isRefusedHospital')) ?? false,
          ),
          relationship: Value(
            _asString(_rawValue(data, 'relationship')) ?? '病患 Patient',
          ),
          relativeName: Value(_asString(_rawValue(data, 'relativeName'))),
          relativePhone: Value(_asString(_rawValue(data, 'relativePhone'))),
          syncStatus: const Value(SyncStatus.synced),
          remoteId: Value(remoteId),
          lastModified: Value(modifiedAt),
        );
        final ambulanceTreatmentUpdated =
            await (_db.update(_db.ambulanceTreatmentRecords)
                  ..where((t) => t.id.equals(ambulanceTreatmentId)))
                .write(ambulanceTreatmentCompanion);
        if (ambulanceTreatmentUpdated == 0) {
          await _db
              .into(_db.ambulanceTreatmentRecords)
              .insert(ambulanceTreatmentCompanion);
        }
        break;
      case 'ambulance_scene_records':
        final ambulanceSceneId = _asInt(_rawValue(data, 'id'));
        final ambulanceSceneMedicalId = _asInt(_rawValue(data, 'medicalId'));
        if (ambulanceSceneId == null || ambulanceSceneMedicalId == null) return;
        final ambulanceSceneCompanion = AmbulanceSceneRecordsCompanion(
          id: Value(ambulanceSceneId),
          medicalId: Value(ambulanceSceneMedicalId),
          patientComplaint: Value(
            _asString(_rawValue(data, 'patientComplaint')),
          ),
          isProxyComplaint: Value(
            _asBool(_rawValue(data, 'isProxyComplaint')) ?? false,
          ),
          fallHeight: Value(_asString(_rawValue(data, 'fallHeight'))),
          burnDegree: Value(_asString(_rawValue(data, 'burnDegree'))),
          burnArea: Value(_asString(_rawValue(data, 'burnArea'))),
          burnPercentage: Value(_asString(_rawValue(data, 'burnPercentage'))),
          otherTraumaNote: Value(_asString(_rawValue(data, 'otherTraumaNote'))),
          allergyStatus: Value(
            _asString(_rawValue(data, 'allergyStatus')) ?? '無',
          ),
          allergyNote: Value(_asString(_rawValue(data, 'allergyNote'))),
          historyStatus: Value(
            _asString(_rawValue(data, 'historyStatus')) ?? '無',
          ),
          historyNote: Value(_asString(_rawValue(data, 'historyNote'))),
          updatedAt: Value(modifiedAt),
        );
        final ambulanceSceneUpdated =
            await (_db.update(_db.ambulanceSceneRecords)
                  ..where((t) => t.id.equals(ambulanceSceneId)))
                .write(ambulanceSceneCompanion);
        if (ambulanceSceneUpdated == 0) {
          await _db
              .into(_db.ambulanceSceneRecords)
              .insert(ambulanceSceneCompanion);
        }
        break;

      default:
        debugPrint('Unknown table for download: $table');
    }
  }

  /// Handle conflicts from compare response
  Future<void> _handleConflicts(List<CompareConflict> conflicts) async {
    for (final conflict in conflicts) {
      // For triage_id conflicts: show manual resolution UI
      // For all others: accept server version (server wins)
      if (conflict.table == 'treatments') {
        // TODO: Mark for manual resolution
        debugPrint('Triage conflict for treatment ${conflict.id}');
      } else {
        // Server wins - apply server data
        await _applyServerWinsConflict(conflict);
      }
    }
  }

  /// Apply server-wins conflict resolution
  Future<void> _applyServerWinsConflict(CompareConflict conflict) async {
    // TODO: Implement server-wins resolution
    debugPrint('Applying server-wins for ${conflict.table} ${conflict.id}');
  }

  /// Resolve conflict from push response
  Future<void> _resolvePushConflict(PushConflict conflict) async {
    final serverData = conflict.serverVersion;
    if (serverData == null) return;

    // Apply server data to local
    await _applyRemoteChange(
      conflict.table,
      conflict.remoteId ?? '',
      serverData,
    );
  }

  /// Mark record as synced
  Future<void> _markAsSynced(
    String table,
    int localId,
    String remoteId,
    DateTime syncedAt,
  ) async {
    switch (table) {
      case 'medical_records':
        await (_db.update(
          _db.medicalRecord,
        )..where((t) => t.medicalId.equals(localId))).write(
          MedicalRecordCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'patients':
        await (_db.update(
          _db.patient,
        )..where((t) => t.patientId.equals(localId))).write(
          PatientCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'treatments':
        await (_db.update(
          _db.treatment,
        )..where((t) => t.treatmentId.equals(localId))).write(
          TreatmentCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'medical_certificates':
        await (_db.update(
          _db.medicalCertificates,
        )..where((t) => t.certificateId.equals(localId))).write(
          MedicalCertificatesCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'medical_fees':
        await (_db.update(
          _db.medicalFees,
        )..where((t) => t.feeId.equals(localId))).write(
          MedicalFeesCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'nursing_records':
        await (_db.update(
          _db.nursingRecords,
        )..where((t) => t.recordId.equals(localId))).write(
          NursingRecordsCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'referral_forms':
        await (_db.update(
          _db.referralForms,
        )..where((t) => t.formId.equals(localId))).write(
          ReferralFormsCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'telex_documents':
        await (_db.update(
          _db.telexDocuments,
        )..where((t) => t.documentId.equals(localId))).write(
          TelexDocumentsCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'flight_records':
        await (_db.update(
          _db.flightRecord,
        )..where((t) => t.flightRecordId.equals(localId))).write(
          FlightRecordCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'incident_records':
        await (_db.update(
          _db.incidentRecord,
        )..where((t) => t.incidentId.equals(localId))).write(
          IncidentRecordCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'ambulance_records':
        await (_db.update(
          _db.ambulanceRecords,
        )..where((t) => t.ambulanceId.equals(localId))).write(
          AmbulanceRecordsCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'ambulance_personal_property':
        await (_db.update(
          _db.ambulancePersonalProperty,
        )..where((t) => t.id.equals(localId))).write(
          AmbulancePersonalPropertyCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'ambulance_fees':
        await (_db.update(
          _db.ambulanceFees,
        )..where((t) => t.feeId.equals(localId))).write(
          AmbulanceFeesCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'ambulance_treatment_records':
        await (_db.update(
          _db.ambulanceTreatmentRecords,
        )..where((t) => t.id.equals(localId))).write(
          AmbulanceTreatmentRecordsCompanion(
            syncStatus: const Value(SyncStatus.synced),
            remoteId: Value(remoteId),
            lastModified: Value(syncedAt),
          ),
        );
        break;
      case 'ambulance_scene_records':
        await (_db.update(_db.ambulanceSceneRecords)
              ..where((t) => t.id.equals(localId)))
            .write(AmbulanceSceneRecordsCompanion(updatedAt: Value(syncedAt)));
        break;
      default:
        debugPrint('Unknown table for markAsSynced: $table');
    }
  }

  /// Legacy pull method (kept for backward compatibility)
  Future<void> pullChanges() async {
    try {
      final lastSync = await _syncDao.getLastSyncTime();
      final request = PullRequest(since: lastSync, deviceId: _deviceId);
      final response = await _apiClient.pullChanges(request);

      for (final change in response.changes) {
        await _applyRemoteChange(change.table, change.remoteId, change.data);
      }

      for (final deleted in response.deletedRecords) {
        await _applyRemoteDelete(deleted);
      }

      await _syncDao.setLastSyncTime(response.serverTimestamp);
    } catch (e) {
      debugPrint('Pull changes error: $e');
      rethrow;
    }
  }

  Future<void> _applyRemoteDelete(DeletedRecord deleted) async {
    debugPrint(
      'Applying remote delete: ${deleted.table} - ${deleted.remoteId}',
    );
    // TODO: Implement delete
  }

  /// Legacy push method (kept for backward compatibility)
  Future<void> pushChanges() async {
    if (_isPushingPending) return;
    _isPushingPending = true;

    try {
      final pendingLogs = await _syncDao.getPendingLogs();

      if (pendingLogs.isEmpty) {
        debugPrint('Push skipped: no pending logs');
        return;
      }

      final tables =
          pendingLogs.map((log) => log.syncTableName).toSet().toList()..sort();
      debugPrint(
        'Push pending logs: ${pendingLogs.length} (${tables.join(', ')})',
      );

      final deviceId = await _syncDao.getDeviceId() ?? 'unknown';

      final tableOrder = <String, int>{
        for (var i = 0; i < snapshotTables.length; i++) snapshotTables[i]: i,
      };
      final sortedPendingLogs = [...pendingLogs]
        ..sort((a, b) {
          final ai = tableOrder[a.syncTableName] ?? 999;
          final bi = tableOrder[b.syncTableName] ?? 999;
          if (ai != bi) return ai.compareTo(bi);
          return a.createdAt.compareTo(b.createdAt);
        });

      // De-duplicate by table + record, keeping latest payload.
      final dedupByKey = <String, SyncLogEntry>{};
      for (final log in sortedPendingLogs) {
        final key = '${log.syncTableName}:${log.recordId}';
        dedupByKey[key] = log;
      }
      final uniquePendingLogs = dedupByKey.values.toList()
        ..sort((a, b) {
          final ai = tableOrder[a.syncTableName] ?? 999;
          final bi = tableOrder[b.syncTableName] ?? 999;
          if (ai != bi) return ai.compareTo(bi);
          return a.createdAt.compareTo(b.createdAt);
        });

      final changes = uniquePendingLogs
          .map(
            (log) => PushChange(
              table: log.syncTableName,
              localId: log.recordId,
              operation: log.operation,
              data: jsonDecode(log.payload) as Map<String, dynamic>,
            ),
          )
          .toList();

      final request = PushRequest(
        clientTimestamp: DateTime.now().toUtc(),
        deviceId: deviceId,
        changes: changes,
      );

      final response = await _apiClient.pushChanges(request);

      for (final result in response.results) {
        if (result.status != 'success') continue;

        final matchedByTable = sortedPendingLogs.where(
          (l) =>
              l.recordId == result.localId &&
              (result.table.isEmpty || l.syncTableName == result.table),
        );

        final fallback = sortedPendingLogs.where(
          (l) => l.recordId == result.localId,
        );
        final log = matchedByTable.isNotEmpty
            ? matchedByTable.first
            : (fallback.isNotEmpty ? fallback.first : null);
        if (log == null) continue;

        // Mark all duplicate pending logs (same table + record) as synced.
        final logsToSync = sortedPendingLogs.where(
          (l) =>
              l.syncTableName == log.syncTableName &&
              l.recordId == log.recordId,
        );
        for (final item in logsToSync) {
          await _syncDao.updateSyncLogStatus(
            item.id,
            status: SyncStatus.synced,
            syncedAt: DateTime.now().toUtc(),
          );
        }
      }

      for (final conflict in response.conflicts) {
        await _resolvePushConflict(conflict);
      }

      _pendingCount = await _syncDao.getPendingCount();
    } catch (e) {
      debugPrint('Push changes error: $e');

      final failedLogs = await _syncDao.getPendingLogs();
      for (final log in failedLogs) {
        await _syncDao.incrementRetryCount(log.id);
        if (log.retryCount >= 3) {
          await _syncDao.updateSyncLogStatus(
            log.id,
            status: SyncStatus.failed,
            errorMessage: 'Max retries exceeded',
          );
        }
      }

      rethrow;
    } finally {
      _isPushingPending = false;
    }
  }

  Future<void> markAsPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    await _ensureParentMedicalRecordPending(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      data: data,
    );

    await _syncDao.upsertSyncLog(
      SyncLogTableCompanion(
        syncTableName: Value(tableName),
        recordId: Value(recordId),
        operation: Value(operation),
        payload: Value(jsonEncode(data)),
        status: const Value(SyncStatus.pending),
        createdAt: Value(DateTime.now().toUtc()),
        retryCount: const Value(0),
      ),
    );

    _pendingCount = await _syncDao.getPendingCount();
    notifyListeners();

    if (_networkService.isOnline) {
      await pushChanges();
    }
  }

  Future<void> _ensureParentMedicalRecordPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    if (operation == 'delete' || tableName == 'medical_records') return;

    final medicalId = _extractMedicalId(
      tableName: tableName,
      recordId: recordId,
      data: data,
    );
    if (medicalId == null || medicalId <= 0) return;

    final medicalData = await _resolveFullRecordData(
      'medical_records',
      medicalId,
    );
    if (medicalData == null) return;

    await _syncDao.upsertSyncLog(
      SyncLogTableCompanion(
        syncTableName: const Value('medical_records'),
        recordId: Value(medicalId),
        operation: const Value('update'),
        payload: Value(jsonEncode(medicalData)),
        status: const Value(SyncStatus.pending),
        createdAt: Value(DateTime.now().toUtc()),
        retryCount: const Value(0),
      ),
    );
  }

  int? _extractMedicalId({
    required String tableName,
    required int recordId,
    required Map<String, dynamic> data,
  }) {
    if (tableName == 'medical_records') return recordId > 0 ? recordId : null;

    final medicalIdRaw = data['medicalId'];
    if (medicalIdRaw is int) return medicalIdRaw;
    if (medicalIdRaw is num) return medicalIdRaw.toInt();
    if (medicalIdRaw is String) return int.tryParse(medicalIdRaw);

    return null;
  }

  Future<void> retryFailed() async {
    final failedLogs = await _syncDao.getFailedLogs();

    for (final log in failedLogs) {
      await _syncDao.updateSyncLogStatus(log.id, status: SyncStatus.pending);
    }

    if (_networkService.isOnline) {
      await syncAll();
    }
  }

  Future<void> clearSyncedLogs() async {
    await _syncDao.deleteSyncedLogs();
    _pendingCount = await _syncDao.getPendingCount();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopPeriodicSync();
    super.dispose();
  }
}
