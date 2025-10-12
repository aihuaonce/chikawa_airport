import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import '../db/daos.dart';
import '../db/app_database.dart';

class EmergencyData extends ChangeNotifier {
  final int visitId;

  EmergencyData(this.visitId);

  // ==================== Personal (個人資料) ====================
  String? patientName; // ✅ 病患姓名（必須在最前面）
  String? idNumber;
  String? passportNumber;
  String? gender;
  DateTime? birthDate;

  void updatePersonal({
    String? patientName, // ✅ 新增
    String? idNumber,
    String? passportNumber,
    String? gender,
    DateTime? birthDate,
  }) {
    if (patientName != null) this.patientName = patientName; // ✅ 新增
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
    if (selectedOtherAirline != null) this.selectedOtherAirline = selectedOtherAirline;
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
    String? evmE, String? evmV, String? evmM,
    String? heartRate, String? respirationRate, String? bloodPressure,
    String? temperature,
    String? leftPupilSize, String? rightPupilSize,
    String? leftPupilReaction, String? rightPupilReaction,
    String? insertionMethod,
    String? airwayContent, String? insertionRecord,
    String? ivNeedleSize, String? ivLineRecord,
    String? cardiacMassageRecord,
    String? endRecord, String? endResult,
    String? selectedHospital, String? otherHospital, String? otherEndResult,
    DateTime? deathTime,
    String? selectedDoctor, String? selectedNurse, String? selectedEMT,
    String? nurseSignature, String? emtSignature,
    List<String>? selectedAssistants,
    List<Map<String, String>>? medicationRecords,
  }) {
    if (firstAidStartTime != null) this.firstAidStartTime = firstAidStartTime;
    if (intubationStartTime != null) this.intubationStartTime = intubationStartTime;
    if (onIVLineStartTime != null) this.onIVLineStartTime = onIVLineStartTime;
    if (cardiacMassageStartTime != null) this.cardiacMassageStartTime = cardiacMassageStartTime;
    if (cardiacMassageEndTime != null) this.cardiacMassageEndTime = cardiacMassageEndTime;
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
    if (rightPupilReaction != null) this.rightPupilReaction = rightPupilReaction;
    if (insertionMethod != null) this.insertionMethod = insertionMethod;
    if (airwayContent != null) this.airwayContent = airwayContent;
    if (insertionRecord != null) this.insertionRecord = insertionRecord;
    if (ivNeedleSize != null) this.ivNeedleSize = ivNeedleSize;
    if (ivLineRecord != null) this.ivLineRecord = ivLineRecord;
    if (cardiacMassageRecord != null) this.cardiacMassageRecord = cardiacMassageRecord;
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
    if (selectedAssistants != null) this.selectedAssistants = selectedAssistants;
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
    patientName = null; // ✅ 新增

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

  // ✅ 從資料庫載入資料
  Future<void> loadFromDatabase(EmergencyRecordsDao dao) async {
    try {
      final record = await dao.getByVisitId(visitId);
      
      if (record == null) {
        print('ℹ️ visitId $visitId 沒有急救記錄,保持空白');
        clearAll();
        return;
      }

      // 載入資料
      idNumber = record.idNumber;
      passportNumber = record.passportNumber;
      gender = record.gender;
      birthDate = record.birthDate;
      patientName = record.patientName; // ✅ 新增
      
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
            decoded.map((item) => Map<String, String>.from(item))
          );
        }
      } catch (e) {
        print('⚠️ 解析 medicationRecordsJson 失敗: $e');
        medicationRecords = [];
      }

      notifyListeners();
      print('✅ 成功載入 visitId $visitId 的急救記錄');
    } catch (e) {
      print('❌ 載入急救記錄失敗: $e');
      clearAll();
    }
  }

  // ==================== ✅ 修改：儲存到資料庫 ====================
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
          // patientName: Value(patientName), // ✅ 新增
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