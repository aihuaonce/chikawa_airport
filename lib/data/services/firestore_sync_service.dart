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

  FirestoreSyncService(this._db) : _firebase = FirebaseService();

  bool get isSyncing => _isSyncing;

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await Future.wait([
        _syncMedicalRecords(),
        _syncPatients(),
        _syncTreatments(),
        _syncAmbulanceRecords(),
        _syncFees(),
        _syncNursingRecords(),
        _syncReferralForms(),
      ]);
      debugPrint('Firestore sync completed');
    } catch (e) {
      debugPrint('Firestore sync error: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncMedicalRecords() async {
    final records = await (_db.select(
      _db.medicalRecord,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
              'syncStatus': syncStatusSynced,
            });

        await (_db.update(
          _db.medicalRecord,
        )..where((t) => t.medicalId.equals(record.medicalId))).write(
          MedicalRecordCompanion(syncStatus: const Value(syncStatusSynced)),
        );

        debugPrint('Synced medical_record ${record.medicalId}');
      } catch (e) {
        debugPrint('Error syncing medical_record ${record.medicalId}: $e');
      }
    }
  }

  Future<void> _syncPatients() async {
    final patients = await (_db.select(
      _db.patient,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
          'syncStatus': syncStatusSynced,
        });

        await (_db.update(_db.patient)
              ..where((t) => t.patientId.equals(patient.patientId)))
            .write(PatientCompanion(syncStatus: const Value(syncStatusSynced)));
      } catch (e) {
        debugPrint('Error syncing patient ${patient.patientId}: $e');
      }
    }
  }

  Future<void> _syncTreatments() async {
    final treatments = await (_db.select(
      _db.treatment,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
              'syncStatus': syncStatusSynced,
            });

        await (_db.update(
          _db.treatment,
        )..where((t) => t.treatmentId.equals(treatment.treatmentId))).write(
          TreatmentCompanion(syncStatus: const Value(syncStatusSynced)),
        );
      } catch (e) {
        debugPrint('Error syncing treatment ${treatment.treatmentId}: $e');
      }
    }
  }

  Future<void> _syncAmbulanceRecords() async {
    final records = await (_db.select(
      _db.ambulanceRecords,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
              'syncStatus': syncStatusSynced,
            });

        await (_db.update(
          _db.ambulanceRecords,
        )..where((t) => t.ambulanceId.equals(record.ambulanceId))).write(
          AmbulanceRecordsCompanion(syncStatus: const Value(syncStatusSynced)),
        );
      } catch (e) {
        debugPrint('Error syncing ambulance_record ${record.ambulanceId}: $e');
      }
    }
  }

  Future<void> _syncFees() async {
    final fees = await (_db.select(
      _db.medicalFees,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
          'syncStatus': syncStatusSynced,
        });

        await (_db.update(
          _db.medicalFees,
        )..where((t) => t.feeId.equals(fee.feeId))).write(
          MedicalFeesCompanion(syncStatus: const Value(syncStatusSynced)),
        );
      } catch (e) {
        debugPrint('Error syncing fee ${fee.feeId}: $e');
      }
    }
  }

  Future<void> _syncNursingRecords() async {
    final records = await (_db.select(
      _db.nursingRecords,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
              'syncStatus': syncStatusSynced,
            });

        await (_db.update(
          _db.nursingRecords,
        )..where((t) => t.recordId.equals(record.recordId))).write(
          NursingRecordsCompanion(syncStatus: const Value(syncStatusSynced)),
        );
      } catch (e) {
        debugPrint('Error syncing nursing_record ${record.recordId}: $e');
      }
    }
  }

  Future<void> _syncReferralForms() async {
    final forms = await (_db.select(
      _db.referralForms,
    )..where((t) => t.syncStatus.equals(syncStatusPending))).get();

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
          'syncStatus': syncStatusSynced,
        });

        await (_db.update(
          _db.referralForms,
        )..where((t) => t.formId.equals(form.formId))).write(
          ReferralFormsCompanion(syncStatus: const Value(syncStatusSynced)),
        );
      } catch (e) {
        debugPrint('Error syncing referral_form ${form.formId}: $e');
      }
    }
  }

  Future<void> pullFromServer() async {
    try {
      final docs = await _firebase.queryDocuments(
        'medical_records',
        whereField: 'syncStatus',
        whereEqualTo: syncStatusPending,
        limit: 100,
      );

      for (final doc in docs) {
        final data = Map<String, dynamic>.from(doc.data());
        await _applyRemoteRecord('medical_records', doc.id, data);
      }
    } catch (e) {
      debugPrint('Error pulling from server: $e');
    }
  }

  Future<void> _applyRemoteRecord(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    debugPrint('Applying remote record: $collection/$docId');
  }
}
