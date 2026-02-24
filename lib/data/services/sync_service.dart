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

  SyncState _state = SyncState.idle;
  DateTime? _lastSyncTime;
  int _pendingCount = 0;
  String? _lastError;

  SyncService({
    required AppDatabase db,
    required NetworkService networkService,
    required ApiClient apiClient,
  })  : _db = db,
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
  }

  SyncState get state => _state;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingCount => _pendingCount;
  String? get lastError => _lastError;
  bool get hasPendingChanges => _pendingCount > 0;
  bool get isOnline => _networkService.isOnline;

  Future<void> initialize() async {
    await _networkService.initialize();
    _lastSyncTime = await _syncDao.getLastSyncTime();
    _pendingCount = await _syncDao.getPendingCount();
    
    _networkService.onConnectivityChanged.listen((isOnline) {
      if (isOnline && hasPendingChanges) {
        syncAll();
      }
    });

    await _ensureDeviceId();
    notifyListeners();
  }

  Future<void> _ensureDeviceId() async {
    var deviceId = await _syncDao.getDeviceId();
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _syncDao.setDeviceId(deviceId);
    }
  }

  Future<SyncResult> syncAll() async {
    if (_state == SyncState.syncing) {
      return SyncResult(success: false, errorMessage: 'Sync already in progress');
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
      await pullChanges();
      await pushChanges();
      
      _lastSyncTime = DateTime.now().toUtc();
      await _syncDao.setLastSyncTime(_lastSyncTime!);
      _pendingCount = await _syncDao.getPendingCount();
      
      _state = SyncState.idle;
      notifyListeners();
      
      return SyncResult(
        success: true,
        pushedCount: 0,
        pulledCount: 0,
      );
    } catch (e) {
      _state = SyncState.error;
      _lastError = e.toString();
      notifyListeners();
      return SyncResult(success: false, errorMessage: e.toString());
    }
  }

  Future<void> pullChanges() async {
    try {
      final lastSync = await _syncDao.getLastSyncTime();
      final request = PullRequest(since: lastSync);
      final response = await _apiClient.pullChanges(request);

      for (final change in response.changes) {
        await _applyRemoteChange(change);
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

  Future<void> _applyRemoteChange(RemoteChange change) async {
    debugPrint('Applying remote change: ${change.table} - ${change.operation}');

    final data = change.data;
    final remoteId = change.remoteId;
    final modifiedAt = change.modifiedAt;

    switch (change.table) {
      case 'medical_records':
        await _applyMedicalRecordChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'patients':
        await _applyPatientChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'treatments':
        await _applyTreatmentChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'medical_certificates':
        await _applyCertificateChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'medical_fees':
        await _applyMedicalFeeChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'nursing_records':
        await _applyNursingRecordChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'referral_forms':
        await _applyReferralFormChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'telex_documents':
        await _applyTelexChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'flight_records':
        await _applyFlightRecordChange(change.operation, data, remoteId, modifiedAt);
        break;
      case 'incident_records':
        await _applyIncidentRecordChange(change.operation, data, remoteId, modifiedAt);
        break;
      default:
        debugPrint('Unknown table: ${change.table}');
    }
  }

  Future<void> _applyMedicalRecordChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final medicalId = data['medicalId'] as int?;
    if (medicalId == null) return;

    final companion = MedicalRecordCompanion(
      isEmergency: Value(data['isEmergency'] as bool? ?? false),
      hasAmbulance: Value(data['hasAmbulance'] as bool? ?? false),
      cdcPassed: Value(data['cdcPassed'] as bool?),
      screeningMethod: Value(data['screeningMethod'] as String?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.medicalRecord)
          ..where((t) => t.medicalId.equals(medicalId)))
        .write(companion);
  }

  Future<void> _applyPatientChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final patientId = data['patientId'] as int?;
    if (patientId == null) return;

    final companion = PatientCompanion(
      name: Value(data['name'] as String?),
      anonymizationName: Value(data['anonymizationName'] as String?),
      birthday: Value(data['birthday'] != null
          ? DateTime.parse(data['birthday'] as String)
          : null),
      sexId: Value(data['sexId'] as int?),
      passportOrIdNo: Value(data['passportOrIdNo'] as String?),
      idNo: Value(data['idNo'] as String?),
      visitReasonId: Value(data['visitReasonId'] as int?),
      nationalityId: Value(data['nationalityId'] as int?),
      telephone: Value(data['telephone'] as String?),
      address: Value(data['address'] as String?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.patient)..where((t) => t.patientId.equals(patientId)))
        .write(companion);
  }

  Future<void> _applyTreatmentChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final treatmentId = data['treatmentId'] as int?;
    if (treatmentId == null) return;

    final companion = TreatmentCompanion(
      tentativeCategoryId: Value(data['tentativeCategoryId'] as int?),
      tentative: Value(data['tentative'] as String?),
      secondaryDiagnosis1: Value(data['secondaryDiagnosis1'] as String?),
      secondaryDiagnosis2: Value(data['secondaryDiagnosis2'] as String?),
      triageId: Value(data['triageId'] as int?),
      treatmentOnSiteId: Value(data['treatmentOnSiteId'] as int?),
      actionSummary: Value(data['actionSummary'] as String?),
      actionSummaryOther: Value(data['actionSummaryOther'] as String?),
      ekgInterpretation: Value(data['ekgInterpretation'] as String?),
      glucose: Value(data['glucose'] as String?),
      intubationMethod: Value(data['intubationMethod'] as String?),
      oxygenMethod: Value(data['oxygenMethod'] as String?),
      oxygenFlow: Value(data['oxygenFlow'] as double?),
      certificateLogs: Value(data['certificateLogs'] as String?),
      resultId: Value(data['resultId'] as int?),
      transportRequired: Value(data['transportRequired'] as bool?),
      transportMethod: Value(data['transportMethod'] as String?),
      referralHospitalId: Value(data['referralHospitalId'] as int?),
      referralHospitalFinal: Value(data['referralHospitalFinal'] as String?),
      ambulanceStaffId: Value(data['ambulanceStaffId'] as int?),
      arrivalTime: Value(data['arrivalTime'] != null
          ? DateTime.parse(data['arrivalTime'] as String)
          : null),
      clearanceId: Value(data['clearanceId'] as int?),
      expeditedClearanceId: Value(data['expeditedClearanceId'] as int?),
      doctorOrderCh: Value(data['doctorOrderCh'] as String?),
      doctorOrderEn: Value(data['doctorOrderEn'] as String?),
      directorName: Value(data['directorName'] as String?),
      assistStaff: Value(data['assistStaff'] as String?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.treatment)
          ..where((t) => t.treatmentId.equals(treatmentId)))
        .write(companion);
  }

  Future<void> _applyCertificateChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final certificateId = data['certificateId'] as int?;
    if (certificateId == null) return;

    final companion = MedicalCertificatesCompanion(
      diagnosisCategoryId: Value(data['diagnosisCategoryId'] as int?),
      diagnosisResult: Value(data['diagnosisResult'] as String?),
      chineseAdvice: Value(data['chineseAdvice'] as String?),
      englishAdvice: Value(data['englishAdvice'] as String?),
      issuanceDate: Value(data['issuanceDate'] != null
          ? DateTime.parse(data['issuanceDate'] as String)
          : null),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.medicalCertificates)
          ..where((t) => t.certificateId.equals(certificateId)))
        .write(companion);
  }

  Future<void> _applyMedicalFeeChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final feeId = data['feeId'] as int?;
    if (feeId == null) return;

    final companion = MedicalFeesCompanion(
      paymentMethodId: Value(data['paymentMethodId'] as int?),
      paymentType: Value(data['paymentType'] as String?),
      consultFee: Value(data['consultFee'] as double? ?? 0),
      ambulanceFee: Value(data['ambulanceFee'] as double? ?? 0),
      currencyId: Value(data['currencyId'] as int?),
      collectionStatusId: Value(data['collectionStatusId'] as int?),
      receiptIssued: Value(data['receiptIssued'] as bool? ?? false),
      userAgreed: Value(data['userAgreed'] as bool? ?? false),
      applicantName: Value(data['applicantName'] as String?),
      applicantUnit: Value(data['applicantUnit'] as String?),
      applicantPhone: Value(data['applicantPhone'] as String?),
      abnormalReason: Value(data['abnormalReason'] as String?),
      remarks: Value(data['remarks'] as String?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.medicalFees)
          ..where((t) => t.feeId.equals(feeId)))
        .write(companion);
  }

  Future<void> _applyNursingRecordChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final recordId = data['recordId'] as int?;
    if (recordId == null) return;

    final companion = NursingRecordsCompanion(
      recordTime: Value(data['recordTime'] != null
          ? DateTime.parse(data['recordTime'] as String)
          : DateTime.now()),
      content: Value(data['content'] as String?),
      nurseId: Value(data['nurseId'] as int?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.nursingRecords)
          ..where((t) => t.recordId.equals(recordId)))
        .write(companion);
  }

  Future<void> _applyReferralFormChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final formId = data['formId'] as int?;
    if (formId == null) return;

    final companion = ReferralFormsCompanion(
      contactName: Value(data['contactName'] as String?),
      contactIdNo: Value(data['contactIdNo'] as String?),
      contactPhone: Value(data['contactPhone'] as String?),
      contactAddress: Value(data['contactAddress'] as String?),
      primaryDiagnosis: Value(data['primaryDiagnosis'] as String?),
      secondaryDiagnosis1: Value(data['secondaryDiagnosis1'] as String?),
      secondaryDiagnosis2: Value(data['secondaryDiagnosis2'] as String?),
      recentExamResult: Value(data['recentExamResult'] as String?),
      examDate: Value(data['examDate'] != null
          ? DateTime.parse(data['examDate'] as String)
          : null),
      recentMedication: Value(data['recentMedication'] as String?),
      medicationDate: Value(data['medicationDate'] != null
          ? DateTime.parse(data['medicationDate'] as String)
          : null),
      referralPurposeId: Value(data['referralPurposeId'] as int?),
      otherPurpose: Value(data['otherPurpose'] as String?),
      doctorName: Value(data['doctorName'] as String?),
      doctorDepartment: Value(data['doctorDepartment'] as String?),
      orderDate: Value(data['orderDate'] != null
          ? DateTime.parse(data['orderDate'] as String)
          : null),
      notes: Value(data['notes'] as String?),
      hospitalName: Value(data['hospitalName'] as String?),
      hospitalDept: Value(data['hospitalDept'] as String?),
      hospitalDoctor: Value(data['hospitalDoctor'] as String?),
      hospitalPhone: Value(data['hospitalPhone'] as String?),
      hospitalAddress: Value(data['hospitalAddress'] as String?),
      scheduledDate: Value(data['scheduledDate'] != null
          ? DateTime.parse(data['scheduledDate'] as String)
          : null),
      scheduledDept: Value(data['scheduledDept'] as String?),
      scheduledRoom: Value(data['scheduledRoom'] as String?),
      scheduledNumber: Value(data['scheduledNumber'] as String?),
      relationshipId: Value(data['relationshipId'] as int?),
      otherRelationship: Value(data['otherRelationship'] as String?),
      consentDateTime: Value(data['consentDateTime'] != null
          ? DateTime.parse(data['consentDateTime'] as String)
          : null),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.referralForms)
          ..where((t) => t.formId.equals(formId)))
        .write(companion);
  }

  Future<void> _applyTelexChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final documentId = data['documentId'] as int?;
    if (documentId == null) return;

    final companion = TelexDocumentsCompanion(
      toStationId: Value(data['toStationId'] as int?),
      fromStationId: Value(data['fromStationId'] as int?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.telexDocuments)
          ..where((t) => t.documentId.equals(documentId)))
        .write(companion);
  }

  Future<void> _applyFlightRecordChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final flightRecordId = data['flightRecordId'] as int?;
    if (flightRecordId == null) return;

    final companion = FlightRecordCompanion(
      airlineId: Value(data['airlineId'] as int?),
      flightNumber: Value(data['flightNumber'] as String? ?? ''),
      travelStatusId: Value(data['travelStatusId'] as int?),
      departureLocationId: Value(data['departureLocationId'] as int?),
      arrivalLocationId: Value(data['arrivalLocationId'] as int?),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.flightRecord)
          ..where((t) => t.flightRecordId.equals(flightRecordId)))
        .write(companion);
  }

  Future<void> _applyIncidentRecordChange(
    String operation,
    Map<String, dynamic> data,
    String remoteId,
    DateTime modifiedAt,
  ) async {
    if (operation == 'delete') {
      return;
    }

    final incidentId = data['incidentId'] as int?;
    if (incidentId == null) return;

    final companion = IncidentRecordCompanion(
      incidentDate: Value(data['incidentDate'] != null
          ? DateTime.parse(data['incidentDate'] as String)
          : DateTime.now()),
      incidentPlaceCategoryId: Value(data['incidentPlaceCategoryId'] as int? ?? 0),
      incidentPlaceCategory2Id: Value(data['incidentPlaceCategory2Id'] as int?),
      incidentPlaceFinal: Value(data['incidentPlaceFinal'] as String?),
      notificationTime: Value(data['notificationTime'] != null
          ? DateTime.parse(data['notificationTime'] as String)
          : null),
      notificationPerson: Value(data['notificationPerson'] as String?),
      reportingUnitId: Value(data['reportingUnitId'] as int? ?? 0),
      incomingPhone: Value(data['incomingPhone'] as String?),
      notificationToOccTime: Value(data['notificationToOccTime'] != null
          ? DateTime.parse(data['notificationToOccTime'] as String)
          : null),
      teamDepartureTime: Value(data['teamDepartureTime'] != null
          ? DateTime.parse(data['teamDepartureTime'] as String)
          : null),
      occArrived: Value(data['occArrived'] as bool? ?? false),
      beforeLanding: Value(data['beforeLanding'] as bool? ?? false),
      landingTime: Value(data['landingTime'] != null
          ? DateTime.parse(data['landingTime'] as String)
          : null),
      medicalArrivalTime: Value(data['medicalArrivalTime'] != null
          ? DateTime.parse(data['medicalArrivalTime'] as String)
          : null),
      examinationTime: Value(data['examinationTime'] != null
          ? DateTime.parse(data['examinationTime'] as String)
          : null),
      syncStatus: const Value(0),
      remoteId: Value(remoteId),
      lastModified: Value(modifiedAt),
    );

    await (_db.update(_db.incidentRecord)
          ..where((t) => t.incidentId.equals(incidentId)))
        .write(companion);
  }

  Future<void> _applyRemoteDelete(DeletedRecord deleted) async {
    debugPrint('Applying remote delete: ${deleted.table} - ${deleted.remoteId}');

    switch (deleted.table) {
      case 'medical_records':
        break;
      case 'patients':
        break;
      case 'treatments':
        break;
      case 'medical_certificates':
        break;
      case 'medical_fees':
        break;
      case 'nursing_records':
        break;
      case 'referral_forms':
        break;
      case 'telex_documents':
        break;
      case 'flight_records':
        break;
      case 'incident_records':
        break;
      default:
        debugPrint('Unknown table for delete: ${deleted.table}');
    }
  }

  Future<void> pushChanges() async {
    try {
      final pendingLogs = await _syncDao.getPendingLogs();
      
      if (pendingLogs.isEmpty) {
        return;
      }

      final deviceId = await _syncDao.getDeviceId() ?? 'unknown';
      
      final changes = pendingLogs.map((log) => PushChange(
        table: log.syncTableName,
        localId: log.recordId,
        operation: log.operation,
        data: jsonDecode(log.payload) as Map<String, dynamic>,
      )).toList();

      final request = PushRequest(
        clientTimestamp: DateTime.now().toUtc(),
        deviceId: deviceId,
        changes: changes,
      );

      final response = await _apiClient.pushChanges(request);

      for (final result in response.results) {
        final log = pendingLogs.firstWhere((l) => l.recordId == result.localId);
        await _syncDao.updateSyncLogStatus(
          log.id,
          status: SyncStatus.synced,
          syncedAt: DateTime.now().toUtc(),
        );
      }

      for (final conflict in response.conflicts) {
        final log = pendingLogs.firstWhere((l) => l.recordId == conflict.localId);
        await _resolveConflict(conflict.toConflict());
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
    }
  }

  Future<void> _resolveConflict(Conflict conflict) async {
    debugPrint('Resolving conflict with server_wins strategy for ${conflict.tableName}');

    final serverData = conflict.serverVersion;
    final modifiedAt = DateTime.now().toUtc();

    final remoteChange = RemoteChange(
      table: conflict.tableName,
      operation: 'update',
      data: serverData,
      remoteId: conflict.remoteId,
      modifiedAt: modifiedAt,
    );

    await _applyRemoteChange(remoteChange);

    final pendingLogs = await _syncDao.getPendingLogs();
    final log = pendingLogs.where((l) => l.recordId == conflict.localId).firstOrNull;
    
    if (log != null) {
      await _syncDao.updateSyncLogStatus(
        log.id,
        status: SyncStatus.synced,
        syncedAt: modifiedAt,
      );
    }
  }

  Future<void> markAsPending({
    required String tableName,
    required int recordId,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    await _syncDao.insertSyncLog(
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

  Future<void> retryFailed() async {
    final failedLogs = await _syncDao.getFailedLogs();
    
    for (final log in failedLogs) {
      await _syncDao.updateSyncLogStatus(
        log.id,
        status: SyncStatus.pending,
      );
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
}
