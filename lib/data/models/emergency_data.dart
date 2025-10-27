// ==================== 3️⃣ emergency_data.dart ====================
import 'dart:convert';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class EmergencyData extends ChangeNotifier {
  final int visitId;
  bool isLoaded = false;

  EmergencyData(this.visitId);

  // Flight
  String? travelStatus;
  int? purposeIndex;
  String? airline;

  // Accident
  DateTime? incidentDateTime;
  int? placeGroupIdx;
  int? t1Selected;
  int? t2Selected;
  int? remoteSelected;
  int? cargoSelected;
  int? novotelSelected;
  int? cabinSelected;
  String? placeNote;

  // Plan
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
  String? postResuscitationRespirationMethod;
  String? postResuscitationBloodPressure;
  String? postResuscitationLeftPupilSize;
  String? postResuscitationRightPupilSize;
  String? postResuscitationLeftPupilLightReflex;
  String? postResuscitationRightPupilLightReflex;
  String? otherSupplements;

  String? endRecord, endResult;
  String? selectedHospital, otherHospital, otherEndResult;
  DateTime? deathTime;

  String? selectedDoctor, selectedNurse, selectedEMT;
  String? nurseSignature, emtSignature;
  List<String> selectedAssistants = [];
  List<Map<String, String>> medicationRecords = [];

  // 【修改】更新方法以匹配新的屬性
  void updateFlight({
    String? travelStatus,
    int? purposeIndex,
    String? airline,
  }) {
    if (travelStatus != null) this.travelStatus = travelStatus;
    if (purposeIndex != null) this.purposeIndex = purposeIndex;
    if (airline != null) this.airline = airline;
    notifyListeners();
  }

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

  void clearAll() {
    travelStatus = null;
    purposeIndex = null;
    airline = null;
    incidentDateTime = null;
    placeGroupIdx = null;
    t1Selected = null;
    t2Selected = null;
    remoteSelected = null;
    cargoSelected = null;
    novotelSelected = null;
    cabinSelected = null;
    placeNote = null;
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

  // 【修改】重構載入邏輯
  Future<void> loadFromDatabase(
    EmergencyRecordsDao emergencyDao,
    PatientProfilesDao profilesDao,
    FlightLogsDao flightLogsDao,
  ) async {
    try {
      clearAll();

      // 1. 載入主急救記錄
      final record = await emergencyDao.getByVisitId(visitId);
      final profile = await profilesDao.getByVisitId(visitId);
      final flightLog = await flightLogsDao.getByVisitId(visitId);

      // 2. 載入飛航 & 個人資料相關
      if (flightLog != null) {
        travelStatus = flightLog.travelStatus;
        airline = flightLog.airline;
      }
      if (profile != null) {
        // 將文字轉回索引
        const reasons = ["航空公司機組員", "旅客/民眾", "機場內部員工"];
        purposeIndex = reasons.indexOf(profile.reason ?? "");
        if (purposeIndex == -1) purposeIndex = null;
      }

      // 步驟 3: 如果紀錄確實存在於資料庫，才載入資料
      if (record != null) {
        print('✅ 找到急救紀錄，載入資料...');
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
        postResuscitationRightPupilSize =
            record.postResuscitationRightPupilSize;
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

        print('✅ 成功載入 visitId $visitId 的急救紀錄');
      } else {
        print('ℹ️ visitId $visitId 尚無急救紀錄，將顯示空白表單。');
      }

      // 步驟 5: 最後，通知所有監聽者(UI)更新畫面
      isLoaded = true;
      notifyListeners();
    } catch (e) {
      // 步驟 6: 處理任何可能發生的錯誤
      print('❌ 載入急救紀錄時失敗: $e');
      isLoaded = true;
      clearAll();
      notifyListeners();
    }
  }

  // ✅ 新增：轉換為 Companion
  EmergencyRecordsCompanion toCompanion() {
    // 【修改】移除已不存在的欄位
    return EmergencyRecordsCompanion(
      visitId: Value(visitId),
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
      postResuscitationRightPupilSize: Value(postResuscitationRightPupilSize),
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
    );
  }

  // 【修改】重構儲存邏輯，以儲存到多個資料表
  Future<void> saveToDatabase({
    required EmergencyRecordsDao emergencyDao,
    required PatientProfilesDao profilesDao,
    required FlightLogsDao flightLogsDao,
    required VisitsDao visitsDao,
  }) async {
    try {
      // 1. 儲存到 EmergencyRecords
      await emergencyDao.upsert(toCompanion());

      // 2. 儲存到 FlightLogs
      final flightCompanion = FlightLogsCompanion(
        visitId: Value(visitId),
        travelStatus: Value(travelStatus),
        airline: Value(airline),
      );
      await flightLogsDao.upsert(flightCompanion);

      // 3. 儲存到 PatientProfiles
      String? reasonText;
      if (purposeIndex != null) {
        const reasons = ["航空公司機組員", "旅客/民眾", "機場內部員工"];
        if (purposeIndex! >= 0 && purposeIndex! < reasons.length) {
          reasonText = reasons[purposeIndex!];
        }
      }
      final profileCompanion = PatientProfilesCompanion(
        visitId: Value(visitId),
        reason: Value(reasonText),
      );
      await profilesDao.upsert(profileCompanion);

      // 4. 更新 Visits 表
      await visitsDao.updateVisit(
        visitId,
        VisitsCompanion(
          hasEmergencyRecord: const Value(true),
          incidentDateTime: Value(incidentDateTime),
          emergencyResult: Value(endResult),
          uploadedAt: Value(DateTime.now()),
        ),
      );
      print('✅ 急救相關記錄已成功儲存到資料庫 (visitId: $visitId)');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
