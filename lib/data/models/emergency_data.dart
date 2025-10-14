import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value, OldDbFieldInDatabaseAccessor;

import '../db/daos.dart';
import '../db/app_database.dart';

class EmergencyData extends ChangeNotifier {
  final int visitId;

  EmergencyData(this.visitId);

  // ==================== Personal (個人資料) ====================
  String? patientName;
  String? idNumber;
  String? passportNumber;
  String? gender;
  DateTime? birthDate;

  void updatePersonal({
    String? patientName,
    String? idNumber,
    String? passportNumber,
    String? gender,
    DateTime? birthDate,
  }) {
    if (patientName != null) this.patientName = patientName;
    if (idNumber != null) this.idNumber = idNumber;
    if (passportNumber != null) this.passportNumber = passportNumber;
    if (gender != null) this.gender = gender;
    if (birthDate != null) this.birthDate = birthDate;
    notifyListeners();
  }

  // ==================== Flight (飛航記錄) ====================
  int? sourceIndex;
  int? purposeIndex;
  int? airlineIndex;
  bool useOtherAirline = false;
  String? selectedOtherAirline;
  String? nationality;

  void updateFlight({
    int? sourceIndex,
    int? purposeIndex,
    int? airlineIndex,
    bool? useOtherAirline,
    String? selectedOtherAirline,
    String? nationality,
  }) {
    if (sourceIndex != null) this.sourceIndex = sourceIndex;
    if (purposeIndex != null) this.purposeIndex = purposeIndex;
    if (airlineIndex != null) this.airlineIndex = airlineIndex;
    if (useOtherAirline != null) this.useOtherAirline = useOtherAirline;
    if (selectedOtherAirline != null)
      this.selectedOtherAirline = selectedOtherAirline;
    if (nationality != null) this.nationality = nationality;
    notifyListeners();
  }

  // ==================== Accident (事故記錄) ====================
  DateTime? incidentDateTime;
  int? placeGroupIdx;
  int? t1Selected;
  int? t2Selected;
  int? remoteSelected;
  int? cargoSelected;
  int? novotelSelected;
  int? cabinSelected;
  String? placeNote;

  void updateAccident({
    DateTime? incidentDateTime,
    int? placeGroupIdx,
    int? t1Selected,
    int? t2Selected,
    int? remoteSelected,
    int? cargoSelected,
    int? novotelSelected,
    int? cabinSelected,
    String? placeNote,
  }) {
    if (incidentDateTime != null) this.incidentDateTime = incidentDateTime;
    if (placeGroupIdx != null) this.placeGroupIdx = placeGroupIdx;
    if (t1Selected != null) this.t1Selected = t1Selected;
    if (t2Selected != null) this.t2Selected = t2Selected;
    if (remoteSelected != null) this.remoteSelected = remoteSelected;
    if (cargoSelected != null) this.cargoSelected = cargoSelected;
    if (novotelSelected != null) this.novotelSelected = novotelSelected;
    if (cabinSelected != null) this.cabinSelected = cabinSelected;
    if (placeNote != null) this.placeNote = placeNote;
    notifyListeners();
  }

  // ==================== Plan (處置記錄) ====================
  DateTime? firstAidStartTime;
  DateTime? intubationStartTime;
  DateTime? onIVLineStartTime;
  DateTime? cardiacMassageStartTime;
  DateTime? cardiacMassageEndTime;
  DateTime? firstAidEndTime;

  String? diagnosis;
  String? situation;
  String? evmE, evmV, evmM;
  String? heartRate, respirationRate, bloodPressure;
  String? temperature;
  String? leftPupilSize, rightPupilSize;
  String? leftPupilReaction, rightPupilReaction;

  String? insertionMethod;
  String? airwayContent, insertionRecord;
  String? ivNeedleSize, ivLineRecord;
  String? cardiacMassageRecord;

  String? postResuscitationEvmE;
  String? postResuscitationEvmV;
  String? postResuscitationEvmM;
  String? postResuscitationHeartRate;
  String? postResuscitationRespirationMethod; // for Radio button
  String? postResuscitationBloodPressure;
  String? postResuscitationLeftPupilSize;
  String? postResuscitationRightPupilSize;
  String? postResuscitationLeftPupilLightReflex; // for Radio button
  String? postResuscitationRightPupilLightReflex; // for Radio button
  String? otherSupplements;

  String? endRecord, endResult;
  String? selectedHospital, otherHospital, otherEndResult;
  DateTime? deathTime;

  String? selectedDoctor, selectedNurse, selectedEMT;
  String? nurseSignature, emtSignature;
  List<String> selectedAssistants = [];
  List<Map<String, String>> medicationRecords = [];

  void updatePlan({
    DateTime? firstAidStartTime,
    DateTime? intubationStartTime,
    DateTime? onIVLineStartTime,
    DateTime? cardiacMassageStartTime,
    DateTime? cardiacMassageEndTime,
    DateTime? firstAidEndTime,
    String? diagnosis,
    String? situation,
    String? evmE,
    String? evmV,
    String? evmM,
    String? heartRate,
    String? respirationRate,
    String? bloodPressure,
    String? temperature,
    String? leftPupilSize,
    String? rightPupilSize,
    String? leftPupilReaction,
    String? rightPupilReaction,
    String? insertionMethod,
    String? airwayContent,
    String? insertionRecord,
    String? ivNeedleSize,
    String? ivLineRecord,
    String? cardiacMassageRecord,
    String? postResuscitationEvmE,
    String? postResuscitationEvmV,
    String? postResuscitationEvmM,
    String? postResuscitationHeartRate,
    String? postResuscitationRespirationMethod,
    String? postResuscitationBloodPressure,
    String? postResuscitationLeftPupilSize,
    String? postResuscitationRightPupilSize,
    String? postResuscitationLeftPupilLightReflex,
    String? postResuscitationRightPupilLightReflex,
    String? otherSupplements,
    String? endRecord,
    String? endResult,
    String? selectedHospital,
    String? otherHospital,
    String? otherEndResult,
    DateTime? deathTime,
    String? selectedDoctor,
    String? selectedNurse,
    String? selectedEMT,
    String? nurseSignature,
    String? emtSignature,
    List<String>? selectedAssistants,
    List<Map<String, String>>? medicationRecords,
  }) {
    if (firstAidStartTime != null) this.firstAidStartTime = firstAidStartTime;
    if (intubationStartTime != null)
      this.intubationStartTime = intubationStartTime;
    if (onIVLineStartTime != null) this.onIVLineStartTime = onIVLineStartTime;
    if (cardiacMassageStartTime != null)
      this.cardiacMassageStartTime = cardiacMassageStartTime;
    if (cardiacMassageEndTime != null)
      this.cardiacMassageEndTime = cardiacMassageEndTime;
    if (firstAidEndTime != null) this.firstAidEndTime = firstAidEndTime;
    if (diagnosis != null) this.diagnosis = diagnosis;
    if (situation != null) this.situation = situation;
    if (evmE != null) this.evmE = evmE;
    if (evmV != null) this.evmV = evmV;
    if (evmM != null) this.evmM = evmM;
    if (heartRate != null) this.heartRate = heartRate;
    if (respirationRate != null) this.respirationRate = respirationRate;
    if (bloodPressure != null) this.bloodPressure = bloodPressure;
    if (temperature != null) this.temperature = temperature;
    if (leftPupilSize != null) this.leftPupilSize = leftPupilSize;
    if (rightPupilSize != null) this.rightPupilSize = rightPupilSize;
    if (leftPupilReaction != null) this.leftPupilReaction = leftPupilReaction;
    if (rightPupilReaction != null)
      this.rightPupilReaction = rightPupilReaction;
    if (insertionMethod != null) this.insertionMethod = insertionMethod;
    if (airwayContent != null) this.airwayContent = airwayContent;
    if (insertionRecord != null) this.insertionRecord = insertionRecord;
    if (ivNeedleSize != null) this.ivNeedleSize = ivNeedleSize;
    if (ivLineRecord != null) this.ivLineRecord = ivLineRecord;
    if (cardiacMassageRecord != null)
      this.cardiacMassageRecord = cardiacMassageRecord;
    if (postResuscitationEvmE != null)
      this.postResuscitationEvmE = postResuscitationEvmE;
    if (postResuscitationEvmV != null)
      this.postResuscitationEvmV = postResuscitationEvmV;
    if (postResuscitationEvmM != null)
      this.postResuscitationEvmM = postResuscitationEvmM;
    if (postResuscitationHeartRate != null)
      this.postResuscitationHeartRate = postResuscitationHeartRate;
    if (postResuscitationRespirationMethod != null)
      this.postResuscitationRespirationMethod =
          postResuscitationRespirationMethod;
    if (postResuscitationBloodPressure != null)
      this.postResuscitationBloodPressure = postResuscitationBloodPressure;
    if (postResuscitationLeftPupilSize != null)
      this.postResuscitationLeftPupilSize = postResuscitationLeftPupilSize;
    if (postResuscitationRightPupilSize != null)
      this.postResuscitationRightPupilSize = postResuscitationRightPupilSize;
    if (postResuscitationLeftPupilLightReflex != null)
      this.postResuscitationLeftPupilLightReflex =
          postResuscitationLeftPupilLightReflex;
    if (postResuscitationRightPupilLightReflex != null)
      this.postResuscitationRightPupilLightReflex =
          postResuscitationRightPupilLightReflex;
    if (otherSupplements != null) this.otherSupplements = otherSupplements;
    if (endRecord != null) this.endRecord = endRecord;
    if (endResult != null) this.endResult = endResult;
    if (selectedHospital != null) this.selectedHospital = selectedHospital;
    if (otherHospital != null) this.otherHospital = otherHospital;
    if (otherEndResult != null) this.otherEndResult = otherEndResult;
    if (deathTime != null) this.deathTime = deathTime;
    if (selectedDoctor != null) this.selectedDoctor = selectedDoctor;
    if (selectedNurse != null) this.selectedNurse = selectedNurse;
    if (selectedEMT != null) this.selectedEMT = selectedEMT;
    if (nurseSignature != null) this.nurseSignature = nurseSignature;
    if (emtSignature != null) this.emtSignature = emtSignature;
    if (selectedAssistants != null)
      this.selectedAssistants = selectedAssistants;
    if (medicationRecords != null) this.medicationRecords = medicationRecords;
    notifyListeners();
  }

  // ✅ 清空所有資料
  void clearAll() {
    // Personal
    idNumber = null;
    passportNumber = null;
    gender = null;
    birthDate = null;
    patientName = null;

    // Flight
    sourceIndex = null;
    purposeIndex = null;
    airlineIndex = null;
    useOtherAirline = false;
    selectedOtherAirline = null;
    nationality = null;

    // Accident
    incidentDateTime = null;
    placeGroupIdx = null;
    t1Selected = null;
    t2Selected = null;
    remoteSelected = null;
    cargoSelected = null;
    novotelSelected = null;
    cabinSelected = null;
    placeNote = null;

    // Plan
    firstAidStartTime = null;
    intubationStartTime = null;
    onIVLineStartTime = null;
    cardiacMassageStartTime = null;
    cardiacMassageEndTime = null;
    firstAidEndTime = null;
    diagnosis = null;
    situation = null;
    evmE = null;
    evmV = null;
    evmM = null;
    heartRate = null;
    respirationRate = null;
    bloodPressure = null;
    temperature = null;
    leftPupilSize = null;
    rightPupilSize = null;
    leftPupilReaction = null;
    rightPupilReaction = null;
    insertionMethod = null;
    airwayContent = null;
    insertionRecord = null;
    ivNeedleSize = null;
    ivLineRecord = null;
    cardiacMassageRecord = null;
    postResuscitationEvmE = null;
    postResuscitationEvmV = null;
    postResuscitationEvmM = null;
    postResuscitationHeartRate = null;
    postResuscitationRespirationMethod = null;
    postResuscitationBloodPressure = null;
    postResuscitationLeftPupilSize = null;
    postResuscitationRightPupilSize = null;
    postResuscitationLeftPupilLightReflex = null;
    postResuscitationRightPupilLightReflex = null;
    otherSupplements = null;
    endRecord = null;
    endResult = null;
    selectedHospital = null;
    otherHospital = null;
    otherEndResult = null;
    deathTime = null;
    selectedDoctor = null;
    selectedNurse = null;
    selectedEMT = null;
    nurseSignature = null;
    emtSignature = null;
    selectedAssistants = [];
    medicationRecords = [];

    notifyListeners();
  }

  // ✅ 🆕 從其他資料表預填資料
  Future<void> _prefillFromOtherTables(EmergencyRecordsDao dao) async {
    try {
      print('🔍 開始從其他資料表預填資料...');

      // 1️⃣ 從 PatientProfiles 抓取個人資料
      final profile = await dao.db.patientProfilesDao.getByVisitId(visitId);
      if (profile != null) {
        print('✅ 找到 PatientProfile 資料');
        // 如果急救紀錄還沒有這些資料，就用 Profile 的
        if (gender == null && profile.gender != null) {
          gender = profile.gender;
          print('   - 預填性別: $gender');
        }
        if (birthDate == null && profile.birthday != null) {
          birthDate = profile.birthday;
          print('   - 預填生日: $birthDate');
        }
        if (idNumber == null && profile.idNumber != null) {
          idNumber = profile.idNumber;
          print('   - 預填身分證: $idNumber');
        }
        if (nationality == null && profile.nationality != null) {
          nationality = profile.nationality;
          print('   - 預填國籍: $nationality');
        }
      }

      // 2️⃣ 從 Visits 抓取病患姓名
      final visit = await dao.db.visitsDao.getById(visitId);
      if (visit != null && visit.patientName != null) {
        if (patientName == null) {
          patientName = visit.patientName;
          print('✅ 從 Visit 預填姓名: $patientName');
        }
      }

      // 3️⃣ 從 FlightLogs 抓取航班資料
      final flightLog = await dao.db.flightLogsDao.getByVisitId(visitId);
      if (flightLog != null) {
        print('✅ 找到 FlightLog 資料');
        if (airlineIndex == null && flightLog.airlineIndex != null) {
          airlineIndex = flightLog.airlineIndex;
          print('   - 預填航空公司: $airlineIndex');
        }
        if (!useOtherAirline && flightLog.useOtherAirline) {
          useOtherAirline = flightLog.useOtherAirline;
          selectedOtherAirline = flightLog.otherAirline;
          print('   - 預填其他航空公司: $selectedOtherAirline');
        }
      }

      // 4️⃣ 從 AccidentRecords 抓取事故資料
      final accidentRecord = await dao.db.accidentRecordsDao.getByVisitId(
        visitId,
      );
      if (accidentRecord != null) {
        print('✅ 找到 AccidentRecord 資料');
        if (incidentDateTime == null && accidentRecord.incidentDate != null) {
          incidentDateTime = accidentRecord.incidentDate;
          print('   - 預填事發時間: $incidentDateTime');
        }
        if (placeGroupIdx == null && accidentRecord.placeIdx != null) {
          placeGroupIdx = accidentRecord.placeIdx;
          print('   - 預填地點群組: $placeGroupIdx');
        }
        if (t1Selected == null && accidentRecord.t1PlaceIdx != null) {
          t1Selected = accidentRecord.t1PlaceIdx;
          print('   - 預填T1地點: $t1Selected');
        }
        if (t2Selected == null && accidentRecord.t2PlaceIdx != null) {
          t2Selected = accidentRecord.t2PlaceIdx;
          print('   - 預填T2地點: $t2Selected');
        }
        if (placeNote == null && accidentRecord.placeNote != null) {
          placeNote = accidentRecord.placeNote;
          print('   - 預填地點備註: $placeNote');
        }
      }

      print('✅ 預填資料完成！');
    } catch (e) {
      print('⚠️ 預填資料時發生錯誤: $e');
      // 即使預填失敗也繼續，不影響主流程
    }
  }

  // ✅ 從資料庫載入資料（含預填）
  Future<void> loadFromDatabase(EmergencyRecordsDao dao) async {
    try {
      final record = await dao.getByVisitId(visitId);

      if (record == null) {
        print('ℹ️ visitId $visitId 沒有急救紀錄，開始預填資料');
        // 🆕 如果沒有急救紀錄，從其他表預填
        await _prefillFromOtherTables(dao);
        notifyListeners();
        return;
      }

      print('✅ 找到急救紀錄，載入資料...');

      // 載入急救紀錄資料
      idNumber = record.idNumber;
      passportNumber = record.passportNumber;
      gender = record.gender;
      birthDate = record.birthDate;
      patientName = record.patientName;

      sourceIndex = record.sourceIndex;
      purposeIndex = record.purposeIndex;
      airlineIndex = record.airlineIndex;
      useOtherAirline = record.useOtherAirline;
      selectedOtherAirline = record.selectedOtherAirline;
      nationality = record.nationality;

      incidentDateTime = record.incidentDateTime;
      placeGroupIdx = record.placeGroupIdx;
      t1Selected = record.t1Selected;
      t2Selected = record.t2Selected;
      remoteSelected = record.remoteSelected;
      cargoSelected = record.cargoSelected;
      novotelSelected = record.novotelSelected;
      cabinSelected = record.cabinSelected;
      placeNote = record.placeNote;

      firstAidStartTime = record.firstAidStartTime;
      intubationStartTime = record.intubationStartTime;
      onIVLineStartTime = record.onIVLineStartTime;
      cardiacMassageStartTime = record.cardiacMassageStartTime;
      cardiacMassageEndTime = record.cardiacMassageEndTime;
      firstAidEndTime = record.firstAidEndTime;

      diagnosis = record.diagnosis;
      situation = record.situation;
      evmE = record.evmE;
      evmV = record.evmV;
      evmM = record.evmM;
      heartRate = record.heartRate;
      respirationRate = record.respirationRate;
      bloodPressure = record.bloodPressure;
      temperature = record.temperature;
      leftPupilSize = record.leftPupilSize;
      rightPupilSize = record.rightPupilSize;
      leftPupilReaction = record.leftPupilReaction;
      rightPupilReaction = record.rightPupilReaction;

      insertionMethod = record.insertionMethod;
      airwayContent = record.airwayContent;
      insertionRecord = record.insertionRecord;
      ivNeedleSize = record.ivNeedleSize;
      ivLineRecord = record.ivLineRecord;
      cardiacMassageRecord = record.cardiacMassageRecord;

      postResuscitationEvmE = record.postResuscitationEvmE;
      postResuscitationEvmV = record.postResuscitationEvmV;
      postResuscitationEvmM = record.postResuscitationEvmM;
      postResuscitationHeartRate = record.postResuscitationHeartRate;
      postResuscitationRespirationMethod =
          record.postResuscitationRespirationMethod;
      postResuscitationBloodPressure = record.postResuscitationBloodPressure;
      postResuscitationLeftPupilSize = record.postResuscitationLeftPupilSize;
      postResuscitationRightPupilSize = record.postResuscitationRightPupilSize;
      postResuscitationLeftPupilLightReflex =
          record.postResuscitationLeftPupilLightReflex;
      postResuscitationRightPupilLightReflex =
          record.postResuscitationRightPupilLightReflex;
      otherSupplements = record.otherSupplements;

      endRecord = record.endRecord;
      endResult = record.endResult;
      selectedHospital = record.selectedHospital;
      otherHospital = record.otherHospital;
      otherEndResult = record.otherEndResult;
      deathTime = record.deathTime;

      selectedDoctor = record.selectedDoctor;
      selectedNurse = record.selectedNurse;
      selectedEMT = record.selectedEMT;
      nurseSignature = record.nurseSignature;
      emtSignature = record.emtSignature;

      // 解析 JSON
      try {
        if (record.selectedAssistantsJson != null) {
          final decoded = jsonDecode(record.selectedAssistantsJson!);
          selectedAssistants = List<String>.from(decoded);
        }
      } catch (e) {
        print('⚠️ 解析 selectedAssistantsJson 失敗: $e');
        selectedAssistants = [];
      }

      try {
        if (record.medicationRecordsJson != null) {
          final decoded = jsonDecode(record.medicationRecordsJson!);
          medicationRecords = List<Map<String, String>>.from(
            decoded.map((item) => Map<String, String>.from(item)),
          );
        }
      } catch (e) {
        print('⚠️ 解析 medicationRecordsJson 失敗: $e');
        medicationRecords = [];
      }

      // 🆕 即使有急救紀錄，還是檢查是否有空白欄位需要預填
      await _prefillFromOtherTables(dao);

      notifyListeners();
      print('✅ 成功載入 visitId $visitId 的急救紀錄');
    } catch (e) {
      print('❌ 載入急救紀錄失敗: $e');
      clearAll();
    }
  }

  // ==================== ✅ 儲存到資料庫 ====================
  Future<void> saveToDatabase(
    EmergencyRecordsDao dao,
    VisitsDao visitsDao,
  ) async {
    try {
      // 檢查是否已存在記錄
      final exists = await dao.recordExistsForVisit(visitId);

      if (!exists) {
        // 如果不存在,先建立一筆
        await dao.createRecordForVisit(visitId);
      }

      // 更新急救記錄資料
      await dao.updateEmergencyRecord(
        EmergencyRecordsCompanion(
          visitId: Value(visitId),
          patientName: Value(patientName),
          idNumber: Value(idNumber),
          passportNumber: Value(passportNumber),
          gender: Value(gender),
          birthDate: Value(birthDate),
          sourceIndex: Value(sourceIndex),
          purposeIndex: Value(purposeIndex),
          airlineIndex: Value(airlineIndex),
          useOtherAirline: Value(useOtherAirline),
          selectedOtherAirline: Value(selectedOtherAirline),
          nationality: Value(nationality),
          incidentDateTime: Value(incidentDateTime),
          placeGroupIdx: Value(placeGroupIdx),
          t1Selected: Value(t1Selected),
          t2Selected: Value(t2Selected),
          remoteSelected: Value(remoteSelected),
          cargoSelected: Value(cargoSelected),
          novotelSelected: Value(novotelSelected),
          cabinSelected: Value(cabinSelected),
          placeNote: Value(placeNote),
          firstAidStartTime: Value(firstAidStartTime),
          intubationStartTime: Value(intubationStartTime),
          onIVLineStartTime: Value(onIVLineStartTime),
          cardiacMassageStartTime: Value(cardiacMassageStartTime),
          cardiacMassageEndTime: Value(cardiacMassageEndTime),
          firstAidEndTime: Value(firstAidEndTime),
          diagnosis: Value(diagnosis),
          situation: Value(situation),
          evmE: Value(evmE),
          evmV: Value(evmV),
          evmM: Value(evmM),
          heartRate: Value(heartRate),
          respirationRate: Value(respirationRate),
          bloodPressure: Value(bloodPressure),
          temperature: Value(temperature),
          leftPupilSize: Value(leftPupilSize),
          rightPupilSize: Value(rightPupilSize),
          leftPupilReaction: Value(leftPupilReaction),
          rightPupilReaction: Value(rightPupilReaction),
          insertionMethod: Value(insertionMethod),
          airwayContent: Value(airwayContent),
          insertionRecord: Value(insertionRecord),
          ivNeedleSize: Value(ivNeedleSize),
          ivLineRecord: Value(ivLineRecord),
          cardiacMassageRecord: Value(cardiacMassageRecord),
          postResuscitationEvmE: Value(postResuscitationEvmE),
          postResuscitationEvmV: Value(postResuscitationEvmV),
          postResuscitationEvmM: Value(postResuscitationEvmM),
          postResuscitationHeartRate: Value(postResuscitationHeartRate),
          postResuscitationRespirationMethod: Value(
            postResuscitationRespirationMethod,
          ),
          postResuscitationBloodPressure: Value(postResuscitationBloodPressure),
          postResuscitationLeftPupilSize: Value(postResuscitationLeftPupilSize),
          postResuscitationRightPupilSize: Value(
            postResuscitationRightPupilSize,
          ),
          postResuscitationLeftPupilLightReflex: Value(
            postResuscitationLeftPupilLightReflex,
          ),
          postResuscitationRightPupilLightReflex: Value(
            postResuscitationRightPupilLightReflex,
          ),
          otherSupplements: Value(otherSupplements),
          endRecord: Value(endRecord),
          endResult: Value(endResult),
          selectedHospital: Value(selectedHospital),
          otherHospital: Value(otherHospital),
          otherEndResult: Value(otherEndResult),
          deathTime: Value(deathTime),
          selectedDoctor: Value(selectedDoctor),
          selectedNurse: Value(selectedNurse),
          selectedEMT: Value(selectedEMT),
          nurseSignature: Value(nurseSignature),
          emtSignature: Value(emtSignature),
          selectedAssistantsJson: Value(jsonEncode(selectedAssistants)),
          medicationRecordsJson: Value(jsonEncode(medicationRecords)),
        ),
      );

      // ✅ 重要：更新 Visits 表，標記為急救記錄並儲存摘要資訊
      await visitsDao.updateVisitForEmergency(
        visitId,
        patientName: patientName,
        gender: gender,
        nationality: nationality,
        incidentDateTime: incidentDateTime,
        emergencyResult: endResult,
        uploadedAt: DateTime.now(),
      );

      print('✅ 急救記錄已成功儲存到資料庫 (visitId: $visitId)');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
