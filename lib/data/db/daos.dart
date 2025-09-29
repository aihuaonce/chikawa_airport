import 'dart:convert';

import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Visits])
class VisitsDao extends DatabaseAccessor<AppDatabase> with _$VisitsDaoMixin {
  VisitsDao(AppDatabase db) : super(db);

  // 建立一筆主檔（回 visitId）
  Future<int> createVisit({String? patientName}) async {
    final id = await into(
      visits,
    ).insert(VisitsCompanion.insert(patientName: Value(patientName)));
    return id;
  }

  // HomePage 列表（可加 keyword 搜尋姓名/國籍/科別）
  Stream<List<Visit>> watchAll({String? keyword}) {
    final q = select(visits)..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)]);
    if (keyword != null && keyword.trim().isNotEmpty) {
      final like = '%${keyword.trim()}%';
      q.where(
        (t) =>
            t.patientName.like(like) |
            t.nationality.like(like) |
            t.dept.like(like),
      );
    }
    return q.watch();
  }

  // 回寫摘要（各分頁存檔時呼叫）
  Future<int> updateVisitSummary(
    int visitId, {
    String? patientName,
    String? gender,
    String? nationality,
    String? dept,
    String? note,
    String? filledBy,
    DateTime? uploadedAt, // 若要更新上傳時間
  }) {
    return (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      VisitsCompanion(
        patientName: patientName == null
            ? const Value.absent()
            : Value(patientName),
        gender: gender == null ? const Value.absent() : Value(gender),
        nationality: nationality == null
            ? const Value.absent()
            : Value(nationality),
        dept: dept == null ? const Value.absent() : Value(dept),
        note: note == null ? const Value.absent() : Value(note),
        filledBy: filledBy == null ? const Value.absent() : Value(filledBy),
        uploadedAt: uploadedAt == null
            ? const Value.absent()
            : Value(uploadedAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteVisit(int visitId) async {
    // 初期用手動刪子表（之後可改成 FK 級聯）
    await (delete(
      db.patientProfiles,
    )..where((t) => t.visitId.equals(visitId))).go();
    return (delete(visits)..where((t) => t.visitId.equals(visitId))).go();
  }

  Future<Visit?> getById(int visitId) => (select(
    visits,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();
}

@DriftAccessor(tables: [PatientProfiles, Visits])
class PatientProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$PatientProfilesDaoMixin {
  PatientProfilesDao(AppDatabase db) : super(db);

  // 抓本頁資料
  Future<PatientProfile?> getByVisitId(int visitId) => (select(
    patientProfiles,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存（沒有就 insert，有就 update），並順便回寫 Visits 摘要
  Future<void> upsertByVisitId({
    required int visitId,
    DateTime? birthday,
    String? gender,
    String? reason,
    String? nationality,
    String? idNumber,
    String? address,
    String? phone,
    String? photoPath,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(patientProfiles).insert(
        PatientProfilesCompanion.insert(
          visitId: visitId,
          birthday: Value(birthday),
          gender: Value(gender),
          reason: Value(reason),
          nationality: Value(nationality),
          idNumber: Value(idNumber),
          address: Value(address),
          phone: Value(phone),
          photoPath: Value(photoPath),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(
        patientProfiles,
      )..where((t) => t.visitId.equals(visitId))).write(
        PatientProfilesCompanion(
          birthday: Value(birthday),
          gender: Value(gender),
          reason: Value(reason),
          nationality: Value(nationality),
          idNumber: Value(idNumber),
          address: Value(address),
          phone: Value(phone),
          photoPath: Value(photoPath),
          updatedAt: Value(now),
        ),
      );
    }

    // 回寫 HomePage 列表所需摘要
    await (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      VisitsCompanion(
        gender: gender == null ? const Value.absent() : Value(gender),
        nationality: nationality == null
            ? const Value.absent()
            : Value(nationality),
        uploadedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}

@DriftAccessor(tables: [AccidentRecords])
class AccidentRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$AccidentRecordsDaoMixin {
  AccidentRecordsDao(AppDatabase db) : super(db);

  // 抓本頁資料
  Future<AccidentRecord?> getByVisitId(int visitId) => (select(
    accidentRecords,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存資料 - 更新版本，包含子地點參數
  Future<void> upsertByVisitId({
    required int visitId,
    DateTime? incidentDate,
    DateTime? notifyTime,
    DateTime? pickUpTime,
    DateTime? medicArriveTime,
    DateTime? ambulanceDepartTime,
    DateTime? checkTime,
    DateTime? landingTime,
    int? reportUnitIdx,
    String? otherReportUnit,
    String? notifier,
    String? phone,
    int? placeIdx,
    String? placeNote,

    // 新增子地點參數
    int? t1PlaceIdx,
    int? t2PlaceIdx,
    int? remotePlaceIdx,
    int? cargoPlaceIdx,
    int? novotelPlaceIdx,
    int? cabinPlaceIdx,

    bool occArrived = false,
    String? cost,
    int? within10min,
    bool reasonLanding = false,
    bool reasonOnline = false,
    bool reasonOther = false,
    String? reasonOtherText,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(accidentRecords).insert(
        AccidentRecordsCompanion.insert(
          visitId: visitId,
          incidentDate: Value(incidentDate),
          notifyTime: Value(notifyTime),
          pickUpTime: Value(pickUpTime),
          medicArriveTime: Value(medicArriveTime),
          ambulanceDepartTime: Value(ambulanceDepartTime),
          checkTime: Value(checkTime),
          landingTime: Value(landingTime),
          reportUnitIdx: Value(reportUnitIdx),
          otherReportUnit: Value(otherReportUnit),
          notifier: Value(notifier),
          phone: Value(phone),
          placeIdx: Value(placeIdx),
          placeNote: Value(placeNote),

          // 新增子地點字段
          t1PlaceIdx: Value(t1PlaceIdx),
          t2PlaceIdx: Value(t2PlaceIdx),
          remotePlaceIdx: Value(remotePlaceIdx),
          cargoPlaceIdx: Value(cargoPlaceIdx),
          novotelPlaceIdx: Value(novotelPlaceIdx),
          cabinPlaceIdx: Value(cabinPlaceIdx),

          occArrived: Value(occArrived),
          cost: Value(cost),
          within10min: Value(within10min),
          reasonLanding: Value(reasonLanding),
          reasonOnline: Value(reasonOnline),
          reasonOther: Value(reasonOther),
          reasonOtherText: Value(reasonOtherText),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(
        accidentRecords,
      )..where((t) => t.visitId.equals(visitId))).write(
        AccidentRecordsCompanion(
          incidentDate: Value(incidentDate),
          notifyTime: Value(notifyTime),
          pickUpTime: Value(pickUpTime),
          medicArriveTime: Value(medicArriveTime),
          ambulanceDepartTime: Value(ambulanceDepartTime),
          checkTime: Value(checkTime),
          landingTime: Value(landingTime),
          reportUnitIdx: Value(reportUnitIdx),
          otherReportUnit: Value(otherReportUnit),
          notifier: Value(notifier),
          phone: Value(phone),
          placeIdx: Value(placeIdx),
          placeNote: Value(placeNote),

          // 新增子地點字段
          t1PlaceIdx: Value(t1PlaceIdx),
          t2PlaceIdx: Value(t2PlaceIdx),
          remotePlaceIdx: Value(remotePlaceIdx),
          cargoPlaceIdx: Value(cargoPlaceIdx),
          novotelPlaceIdx: Value(novotelPlaceIdx),
          cabinPlaceIdx: Value(cabinPlaceIdx),

          occArrived: Value(occArrived),
          cost: Value(cost),
          within10min: Value(within10min),
          reasonLanding: Value(reasonLanding),
          reasonOnline: Value(reasonOnline),
          reasonOther: Value(reasonOther),
          reasonOtherText: Value(reasonOtherText),
          updatedAt: Value(now),
        ),
      );
    }
  }
}

@DriftAccessor(tables: [FlightLogs])
class FlightLogsDao extends DatabaseAccessor<AppDatabase>
    with _$FlightLogsDaoMixin {
  FlightLogsDao(AppDatabase db) : super(db);

  // 抓本頁資料
  Future<FlightLog?> getByVisitId(int visitId) => (select(
    flightLogs,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存（沒有就 insert，有就 update）
  Future<void> upsertByVisitId({
    required int visitId,
    int? airlineIndex,
    bool useOtherAirline = false,
    String? otherAirline,
    String? flightNo,
    int? travelStatusIndex,
    String? otherTravelStatus,
    String? departure,
    String? via,
    String? destination,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(flightLogs).insert(
        FlightLogsCompanion.insert(
          visitId: visitId,
          airlineIndex: Value(airlineIndex),
          useOtherAirline: Value(useOtherAirline),
          otherAirline: Value(otherAirline),
          flightNo: Value(flightNo),
          travelStatusIndex: Value(travelStatusIndex),
          otherTravelStatus: Value(otherTravelStatus),
          departure: Value(departure),
          via: Value(via),
          destination: Value(destination),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(flightLogs)..where((t) => t.visitId.equals(visitId))).write(
        FlightLogsCompanion(
          airlineIndex: Value(airlineIndex),
          useOtherAirline: Value(useOtherAirline),
          otherAirline: Value(otherAirline),
          flightNo: Value(flightNo),
          travelStatusIndex: Value(travelStatusIndex),
          otherTravelStatus: Value(otherTravelStatus),
          departure: Value(departure),
          via: Value(via),
          destination: Value(destination),
          updatedAt: Value(now),
        ),
      );
    }
  }
}

@DriftAccessor(tables: [Treatments])
class TreatmentsDao extends DatabaseAccessor<AppDatabase>
    with _$TreatmentsDaoMixin {
  TreatmentsDao(AppDatabase db) : super(db);

  Future<Treatment?> getByVisitId(int visitId) => (select(
    treatments,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  Future<void> upsertByVisitId({
    required int visitId,
    required bool screeningChecked,
    required Map<String, bool> screeningMethods,
    String? otherScreeningMethod,
    required List<Map<String, String>> healthData,
    int? mainSymptom,
    required Map<String, bool> traumaSymptoms,
    required Map<String, bool> nonTraumaSymptoms,
    String? symptomNote,
    required Map<String, bool> photoTypes,
    String? bodyCheckHead,
    String? bodyCheckChest,
    String? bodyCheckAbdomen,
    String? bodyCheckLimbs,
    String? bodyCheckOther,
    String? temperature,
    String? pulse,
    String? respiration,
    String? bpSystolic,
    String? bpDiastolic,
    String? spo2,
    required bool consciousClear,
    String? evmE,
    String? evmV,
    String? evmM,
    int? leftPupilScale,
    String? leftPupilSize,
    int? rightPupilScale,
    String? rightPupilSize,
    int? history,
    int? allergy,
    String? initialDiagnosis,
    int? diagnosisCategory,
    String? selectedICD10Main,
    String? selectedICD10Sub1,
    String? selectedICD10Sub2,
    int? triageCategory,
    required Map<String, bool> onSiteTreatments,
    required bool ekgChecked,
    String? ekgReading,
    required bool sugarChecked,
    String? sugarReading,
    required bool suggestReferral,
    required bool intubationChecked,
    required bool cprChecked,
    required bool oxygenTherapyChecked,
    required bool medicalCertificateChecked,
    required bool prescriptionChecked,
    required bool otherChecked,
    String? otherSummary,
    int? referralPassageType,
    int? referralAmbulanceType,
    int? referralHospitalIdx,
    String? referralOtherHospital,
    String? referralEscort,
    int? intubationType,
    int? oxygenType,
    String? oxygenFlow,
    required Map<String, bool> medicalCertificateTypes,
    required List<Map<String, String>> prescriptionRows,
    required Map<String, bool> followUpResults,
    int? otherHospitalIdx,
    String? selectedMainDoctor,
    String? selectedMainNurse,
    String? nurseSignature,
    String? selectedEMT,
    String? emtSignature,
    String? helperNamesText,
    required List<String> selectedHelpers,
    required Map<String, bool> specialNotes,
    String? otherSpecialNote,
  }) async {
    final companion = TreatmentsCompanion(
      visitId: Value(visitId),
      screeningChecked: Value(screeningChecked),
      screeningMethodsJson: Value(jsonEncode(screeningMethods)),
      otherScreeningMethod: Value(otherScreeningMethod),
      healthDataJson: Value(jsonEncode(healthData)),
      mainSymptom: Value(mainSymptom),
      traumaSymptomsJson: Value(jsonEncode(traumaSymptoms)),
      nonTraumaSymptomsJson: Value(jsonEncode(nonTraumaSymptoms)),
      symptomNote: Value(symptomNote),
      photoTypesJson: Value(jsonEncode(photoTypes)),
      bodyCheckHead: Value(bodyCheckHead),
      bodyCheckChest: Value(bodyCheckChest),
      bodyCheckAbdomen: Value(bodyCheckAbdomen),
      bodyCheckLimbs: Value(bodyCheckLimbs),
      bodyCheckOther: Value(bodyCheckOther),
      temperature: Value(temperature),
      pulse: Value(pulse),
      respiration: Value(respiration),
      bpSystolic: Value(bpSystolic),
      bpDiastolic: Value(bpDiastolic),
      spo2: Value(spo2),
      consciousClear: Value(consciousClear),
      evmE: Value(evmE),
      evmV: Value(evmV),
      evmM: Value(evmM),
      leftPupilScale: Value(leftPupilScale),
      leftPupilSize: Value(leftPupilSize),
      rightPupilScale: Value(rightPupilScale),
      rightPupilSize: Value(rightPupilSize),
      history: Value(history),
      allergy: Value(allergy),
      initialDiagnosis: Value(initialDiagnosis),
      diagnosisCategory: Value(diagnosisCategory),
      selectedICD10Main: Value(selectedICD10Main),
      selectedICD10Sub1: Value(selectedICD10Sub1),
      selectedICD10Sub2: Value(selectedICD10Sub2),
      triageCategory: Value(triageCategory),
      onSiteTreatmentsJson: Value(jsonEncode(onSiteTreatments)),
      ekgChecked: Value(ekgChecked),
      ekgReading: Value(ekgReading),
      sugarChecked: Value(sugarChecked),
      sugarReading: Value(sugarReading),
      suggestReferral: Value(suggestReferral),
      intubationChecked: Value(intubationChecked),
      cprChecked: Value(cprChecked),
      oxygenTherapyChecked: Value(oxygenTherapyChecked),
      medicalCertificateChecked: Value(medicalCertificateChecked),
      prescriptionChecked: Value(prescriptionChecked),
      otherChecked: Value(otherChecked),
      otherSummary: Value(otherSummary),
      referralPassageType: Value(referralPassageType),
      referralAmbulanceType: Value(referralAmbulanceType),
      referralHospitalIdx: Value(referralHospitalIdx),
      referralOtherHospital: Value(referralOtherHospital),
      referralEscort: Value(referralEscort),
      intubationType: Value(intubationType),
      oxygenType: Value(oxygenType),
      oxygenFlow: Value(oxygenFlow),
      medicalCertificateTypesJson: Value(jsonEncode(medicalCertificateTypes)),
      prescriptionRowsJson: Value(jsonEncode(prescriptionRows)),
      followUpResultsJson: Value(jsonEncode(followUpResults)),
      otherHospitalIdx: Value(otherHospitalIdx),
      selectedMainDoctor: Value(selectedMainDoctor),
      selectedMainNurse: Value(selectedMainNurse),
      nurseSignature: Value(nurseSignature),
      selectedEMT: Value(selectedEMT),
      emtSignature: Value(emtSignature),
      helperNamesText: Value(helperNamesText),
      selectedHelpersJson: Value(jsonEncode(selectedHelpers)),
      specialNotesJson: Value(jsonEncode(specialNotes)),
      otherSpecialNote: Value(otherSpecialNote),
      updatedAt: Value(DateTime.now()),
    );

    final existing = await getByVisitId(visitId);
    if (existing == null) {
      await into(treatments).insert(companion);
    } else {
      await (update(
        treatments,
      )..where((t) => t.visitId.equals(visitId))).write(companion);
    }
  }
}

@DriftAccessor(tables: [MedicalCosts])
class MedicalCostsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalCostsDaoMixin {
  MedicalCostsDao(AppDatabase db) : super(db);

  // 透過 visitId 取得資料
  Future<MedicalCost?> getByVisitId(int visitId) => (select(
    medicalCosts,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 新增或更新資料
  Future<void> upsertByVisitId({
    required int visitId,
    String? chargeMethod,
    String? visitFee,
    String? ambulanceFee,
    String? note,
    String? photoPath,
    String? agreementSignaturePath,
    String? witnessSignaturePath,
  }) async {
    final companion = MedicalCostsCompanion(
      visitId: Value(visitId),
      chargeMethod: Value(chargeMethod),
      visitFee: Value(visitFee),
      ambulanceFee: Value(ambulanceFee),
      note: Value(note),
      photoPath: Value(photoPath),
      agreementSignaturePath: Value(agreementSignaturePath),
      witnessSignaturePath: Value(witnessSignaturePath),
      updatedAt: Value(DateTime.now()),
    );

    final existing = await getByVisitId(visitId);
    if (existing == null) {
      await into(medicalCosts).insert(companion);
    } else {
      await (update(
        medicalCosts,
      )..where((t) => t.visitId.equals(visitId))).write(companion);
    }
  }
}

@DriftAccessor(tables: [MedicalCertificates])
class MedicalCertificatesDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalCertificatesDaoMixin {
  MedicalCertificatesDao(AppDatabase db) : super(db);

  // 透過 visitId 取得資料
  Future<MedicalCertificate?> getByVisitId(int visitId) => (select(
    medicalCertificates,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 新增或更新資料
  Future<void> upsertByVisitId({
    required int visitId,
    String? diagnosis,
    int? instructionOption,
    String? chineseInstruction,
    String? englishInstruction,
    DateTime? issueDate,
  }) async {
    final companion = MedicalCertificatesCompanion(
      visitId: Value(visitId),
      diagnosis: Value(diagnosis),
      instructionOption: Value(instructionOption),
      chineseInstruction: Value(chineseInstruction),
      englishInstruction: Value(englishInstruction),
      issueDate: Value(issueDate),
      updatedAt: Value(DateTime.now()),
    );

    final existing = await getByVisitId(visitId);
    if (existing == null) {
      await into(medicalCertificates).insert(companion);
    } else {
      await (update(
        medicalCertificates,
      )..where((t) => t.visitId.equals(visitId))).write(companion);
    }
  }
}

@DriftAccessor(tables: [Undertakings])
class UndertakingsDao extends DatabaseAccessor<AppDatabase> with _$UndertakingsDaoMixin {
  UndertakingsDao(AppDatabase db) : super(db);

  // 透過 visitId 取得資料
  Future<Undertaking?> getByVisitId(int visitId) =>
      (select(undertakings)..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 新增或更新資料
  Future<void> upsertByVisitId({
    required int visitId,
    String? signerName,
    String? signerId,
    required bool isSelf,
    String? relation,
    String? address,
    String? phone,
    String? doctor,
    Uint8List? signatureBytes,
  }) async {
    final companion = UndertakingsCompanion(
      visitId: Value(visitId),
      signerName: Value(signerName),
      signerId: Value(signerId),
      isSelf: Value(isSelf),
      relation: Value(relation),
      address: Value(address),
      phone: Value(phone),
      doctor: Value(doctor),
      signatureBytes: Value(signatureBytes),
      updatedAt: Value(DateTime.now()),
    );

    final existing = await getByVisitId(visitId);
    if (existing == null) {
      await into(undertakings).insert(companion);
    } else {
      await (update(undertakings)..where((t) => t.visitId.equals(visitId))).write(companion);
    }
  }
}

@DriftAccessor(tables: [ElectronicDocuments])
class ElectronicDocumentsDao extends DatabaseAccessor<AppDatabase> with _$ElectronicDocumentsDaoMixin {
  ElectronicDocumentsDao(AppDatabase db) : super(db);

  // 透過 visitId 取得資料
  Future<ElectronicDocument?> getByVisitId(int visitId) =>
      (select(electronicDocuments)..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 新增或更新資料
  Future<void> upsertByVisitId({
    required int visitId,
    int? toSelectedIndex,
    int? fromSelectedIndex,
  }) async {
    final companion = ElectronicDocumentsCompanion(
      visitId: Value(visitId),
      toSelectedIndex: Value(toSelectedIndex),
      fromSelectedIndex: Value(fromSelectedIndex),
      updatedAt: Value(DateTime.now()),
    );

    final existing = await getByVisitId(visitId);
    if (existing == null) {
      await into(electronicDocuments).insert(companion);
    } else {
      await (update(electronicDocuments)..where((t) => t.visitId.equals(visitId))).write(companion);
    }
  }
}

@DriftAccessor(tables: [NursingRecords])
class NursingRecordsDao extends DatabaseAccessor<AppDatabase> with _$NursingRecordsDaoMixin {
  NursingRecordsDao(AppDatabase db) : super(db);

  // 透過 visitId 取得資料
  Future<NursingRecord?> getByVisitId(int visitId) =>
      (select(nursingRecords)..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 新增或更新資料
  Future<void> upsertByVisitId({
    required int visitId,
    required List<Map<String, dynamic>> records, // 傳入 Map 列表
  }) async {
    final companion = NursingRecordsCompanion(
      visitId: Value(visitId),
      recordsJson: Value(jsonEncode(records)), // 序列化為 JSON
      updatedAt: Value(DateTime.now()),
    );

    final existing = await getByVisitId(visitId);
    if (existing == null) {
      await into(nursingRecords).insert(companion);
    } else {
      await (update(nursingRecords)..where((t) => t.visitId.equals(visitId))).write(companion);
    }
  }
}