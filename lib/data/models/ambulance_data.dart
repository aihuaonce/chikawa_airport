// lib/data/models/ambulance_data.dart
import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../db/daos.dart';
import 'medication_record_model.dart';
import 'paramedic_record_model.dart';
import 'vital_sign_record_model.dart';

class AmbulanceData extends ChangeNotifier {
  final int visitId;

  AmbulanceData(this.visitId);

  // ========== Information ==========
  String? plateNumber;
  int? placeGroupIdx;
  int? t1PlaceIdx;
  int? t2PlaceIdx;
  int? remotePlaceIdx;
  int? cargoPlaceIdx;
  int? novotelPlaceIdx;
  int? cabinPlaceIdx;
  String? placeNote;
  DateTime? dutyTime;
  DateTime? arriveSceneTime;
  DateTime? leaveSceneTime;
  DateTime? arriveHospitalTime;
  DateTime? leaveHospitalTime;
  DateTime? backStandbyTime;
  int? destinationHospitalIdx;
  String? otherDestinationHospital;
  String? destinationHospital;

  // ========== Personal ==========
  String? gender;
  String? idNumber;
  int? age;
  String? address;
  String? patientBelongings;
  String? belongingsHandled;
  String? custodianName;
  Uint8List? custodianSignature;

  // ========== Situation ==========
  String? chiefComplaint;
  Set<String> traumaClass = {};
  Set<String> nonTraumaType = {};
  Set<String> nonTraumaAcutePicked = {};
  Set<String> nonTraumaGeneralPicked = {};
  Set<String> traumaTypePicked = {};
  Set<String> traumaGeneralBodyPicked = {};
  Set<String> traumaMechanismPicked = {};
  Set<String> allergy = {};
  Set<String> pmh = {};
  String? allergyOther;
  String? pmhOther;
  String? nonTraumaAcuteOther;
  String? traumaGeneralOther;
  String? fallHeight;
  String? burnDegree;
  String? burnArea; // 【修正】將 SafeArea 更名為 burnArea，以匹配 UI 和先前修正
  String? traumaOther; // 此欄位由 Ambulance_Situation.dart 使用
  bool? isProxyStatement;

  // ========== Plan ==========
  Map<String, bool> emergencyTreatments = {};
  Map<String, bool> airwayTreatments = {};
  Map<String, bool> traumaTreatments = {};
  Map<String, bool> transportMethods = {};
  Map<String, bool> cprMethods = {};
  Map<String, bool> medicationProcedures = {};
  Map<String, bool> otherEmergencyProcedures = {};
  String? bodyDiagramNote; // 此欄位將被 Ambulance_Plan.dart 用於創傷處置的「其他」文字
  String? bodyDiagramPath;
  String? airwayOther;
  String? otherEmergencyOther;
  String? aslType;
  String? ettSize;
  String? ettDepth;
  String? manualDefibCount;
  String? manualDefibJoules;
  String? guideNote;
  String? receivingUnit;
  DateTime? receivingTime;
  bool? isRejection;
  String? rejectionName;
  String? relationshipType;
  String? contactName;
  String? contactPhone;
  List<MedicationRecordModel> medicationRecords = [];
  List<ParamedicRecordModel> paramedicRecords = [];
  List<VitalSignRecordModel> vitalSignsRecords = [];

  // ========== Expenses ==========
  int? staffFee;
  int? oxygenFee;
  int? totalFee;
  String? chargeStatus;
  String? paidType;
  String? unpaidType;

  // ========== Update Methods ==========

  void updateInformation({
    String? plateNumber,
    int? placeGroupIdx,
    int? t1PlaceIdx,
    int? t2PlaceIdx,
    int? remotePlaceIdx,
    int? cargoPlaceIdx,
    int? novotelPlaceIdx,
    int? cabinPlaceIdx,
    String? placeNote,
    DateTime? dutyTime,
    DateTime? arriveSceneTime,
    DateTime? leaveSceneTime,
    DateTime? arriveHospitalTime,
    DateTime? leaveHospitalTime,
    DateTime? backStandbyTime,
    int? destinationHospitalIdx,
    String? otherDestinationHospital,
    String? destinationHospital,
  }) {
    if (plateNumber != null) this.plateNumber = plateNumber;
    if (placeGroupIdx != null) this.placeGroupIdx = placeGroupIdx;
    if (t1PlaceIdx != null) this.t1PlaceIdx = t1PlaceIdx;
    if (t2PlaceIdx != null) this.t2PlaceIdx = t2PlaceIdx;
    if (remotePlaceIdx != null) this.remotePlaceIdx = remotePlaceIdx;
    if (cargoPlaceIdx != null) this.cargoPlaceIdx = cargoPlaceIdx;
    if (novotelPlaceIdx != null) this.novotelPlaceIdx = novotelPlaceIdx;
    if (cabinPlaceIdx != null) this.cabinPlaceIdx = cabinPlaceIdx;
    if (placeNote != null) this.placeNote = placeNote;
    if (dutyTime != null) this.dutyTime = dutyTime;
    if (arriveSceneTime != null) this.arriveSceneTime = arriveSceneTime;
    if (leaveSceneTime != null) this.leaveSceneTime = leaveSceneTime;
    if (arriveHospitalTime != null)
      this.arriveHospitalTime = arriveHospitalTime;
    if (leaveHospitalTime != null) this.leaveHospitalTime = leaveHospitalTime;
    if (backStandbyTime != null) this.backStandbyTime = backStandbyTime;
    if (destinationHospitalIdx != null)
      this.destinationHospitalIdx = destinationHospitalIdx;
    if (otherDestinationHospital != null)
      this.otherDestinationHospital = otherDestinationHospital;
    if (destinationHospital != null)
      this.destinationHospital = destinationHospital;
    notifyListeners();
  }

  void updatePersonal({
    String? gender,
    String? idNumber,
    int? age,
    String? address,
    String? patientBelongings,
    String? belongingsHandled,
    String? custodianName,
    Uint8List? custodianSignature,
  }) {
    if (gender != null) this.gender = gender;
    if (idNumber != null) this.idNumber = idNumber;
    if (age != null) this.age = age;
    if (address != null) this.address = address;
    if (patientBelongings != null) this.patientBelongings = patientBelongings;
    if (belongingsHandled != null) this.belongingsHandled = belongingsHandled;
    if (custodianName != null) this.custodianName = custodianName;
    if (custodianSignature != null)
      this.custodianSignature = custodianSignature;
    notifyListeners();
  }

  void updateSituation({
    String? chiefComplaint,
    Set<String>? traumaClass,
    Set<String>? nonTraumaType,
    Set<String>? nonTraumaAcutePicked,
    Set<String>? nonTraumaGeneralPicked,
    Set<String>? traumaTypePicked,
    Set<String>? traumaGeneralBodyPicked,
    Set<String>? traumaMechanismPicked,
    Set<String>? allergy,
    Set<String>? pmh,
    String? allergyOther,
    String? pmhOther,
    String? nonTraumaAcuteOther,
    String? traumaGeneralOther,
    String? fallHeight,
    String? burnDegree,
    String? burnArea,
    String? traumaOther,
    bool? isProxyStatement,
  }) {
    if (chiefComplaint != null) this.chiefComplaint = chiefComplaint;
    if (traumaClass != null) this.traumaClass = traumaClass;
    if (nonTraumaType != null) this.nonTraumaType = nonTraumaType;
    if (nonTraumaAcutePicked != null)
      this.nonTraumaAcutePicked = nonTraumaAcutePicked;
    if (nonTraumaGeneralPicked != null)
      this.nonTraumaGeneralPicked = nonTraumaGeneralPicked;
    if (traumaTypePicked != null) this.traumaTypePicked = traumaTypePicked;
    if (traumaGeneralBodyPicked != null)
      this.traumaGeneralBodyPicked = traumaGeneralBodyPicked;
    if (traumaMechanismPicked != null)
      this.traumaMechanismPicked = traumaMechanismPicked;
    if (allergy != null) this.allergy = allergy;
    if (pmh != null) this.pmh = pmh;
    if (allergyOther != null) this.allergyOther = allergyOther;
    if (pmhOther != null) this.pmhOther = pmhOther;
    if (nonTraumaAcuteOther != null)
      this.nonTraumaAcuteOther = nonTraumaAcuteOther;
    if (traumaGeneralOther != null)
      this.traumaGeneralOther = traumaGeneralOther;
    if (fallHeight != null) this.fallHeight = fallHeight;
    if (burnDegree != null) this.burnDegree = burnDegree;
    if (burnArea != null) this.burnArea = burnArea;
    if (traumaOther != null) this.traumaOther = traumaOther;
    if (isProxyStatement != null) this.isProxyStatement = isProxyStatement;
    notifyListeners();
  }

  void updatePlan({
    Map<String, bool>? emergencyTreatments,
    Map<String, bool>? airwayTreatments,
    Map<String, bool>? traumaTreatments,
    Map<String, bool>? transportMethods,
    Map<String, bool>? cprMethods,
    Map<String, bool>? medicationProcedures,
    Map<String, bool>? otherEmergencyProcedures,
    String? bodyDiagramNote,
    String? bodyDiagramPath,
    String? airwayOther,
    String? otherEmergencyOther,
    String? aslType,
    String? ettSize,
    String? ettDepth,
    String? manualDefibCount,
    String? manualDefibJoules,
    String? guideNote,
    String? receivingUnit,
    DateTime? receivingTime,
    bool? isRejection,
    String? rejectionName,
    String? relationshipType,
    String? contactName,
    String? contactPhone,
    List<MedicationRecordModel>? medicationRecords,
    List<ParamedicRecordModel>? paramedicRecords,
    List<VitalSignRecordModel>? vitalSignsRecords,
  }) {
    if (emergencyTreatments != null)
      this.emergencyTreatments = emergencyTreatments;
    if (airwayTreatments != null) this.airwayTreatments = airwayTreatments;
    if (traumaTreatments != null) this.traumaTreatments = traumaTreatments;
    if (transportMethods != null) this.transportMethods = transportMethods;
    if (cprMethods != null) this.cprMethods = cprMethods;
    if (medicationProcedures != null)
      this.medicationProcedures = medicationProcedures;
    if (otherEmergencyProcedures != null)
      this.otherEmergencyProcedures = otherEmergencyProcedures;
    if (bodyDiagramNote != null) this.bodyDiagramNote = bodyDiagramNote;
    if (bodyDiagramPath != null) this.bodyDiagramPath = bodyDiagramPath;
    if (airwayOther != null) this.airwayOther = airwayOther;
    if (otherEmergencyOther != null)
      this.otherEmergencyOther = otherEmergencyOther;
    this.aslType = (aslType == null || aslType.isEmpty) ? null : aslType;
    if (ettSize != null) this.ettSize = ettSize;
    if (ettDepth != null) this.ettDepth = ettDepth;
    if (manualDefibCount != null) this.manualDefibCount = manualDefibCount;
    if (manualDefibJoules != null) this.manualDefibJoules = manualDefibJoules;
    if (guideNote != null) this.guideNote = guideNote;
    if (receivingUnit != null) this.receivingUnit = receivingUnit;
    if (receivingTime != null) this.receivingTime = receivingTime;
    if (isRejection != null) this.isRejection = isRejection;
    if (rejectionName != null) this.rejectionName = rejectionName;
    if (relationshipType != null) this.relationshipType = relationshipType;
    if (contactName != null) this.contactName = contactName;
    if (contactPhone != null) this.contactPhone = contactPhone;
    if (medicationRecords != null) this.medicationRecords = medicationRecords;
    if (paramedicRecords != null) this.paramedicRecords = paramedicRecords;
    if (vitalSignsRecords != null) this.vitalSignsRecords = vitalSignsRecords;
    notifyListeners();
  }

  void updateExpenses({
    int? staffFee,
    int? oxygenFee,
    int? totalFee,
    String? chargeStatus,
    String? paidType,
    String? unpaidType,
  }) {
    if (staffFee != null) this.staffFee = staffFee;
    if (oxygenFee != null) this.oxygenFee = oxygenFee;
    if (totalFee != null) this.totalFee = totalFee;
    if (chargeStatus != null) this.chargeStatus = chargeStatus;
    if (paidType != null) this.paidType = paidType;
    if (unpaidType != null) this.unpaidType = unpaidType;
    notifyListeners();
  }

  void clearAll() {
    plateNumber = null;
    placeGroupIdx = null;
    t1PlaceIdx = null;
    t2PlaceIdx = null;
    remotePlaceIdx = null;
    cargoPlaceIdx = null;
    novotelPlaceIdx = null;
    cabinPlaceIdx = null;
    placeNote = null;
    dutyTime = null;
    arriveSceneTime = null;
    leaveSceneTime = null;
    arriveHospitalTime = null;
    leaveHospitalTime = null;
    backStandbyTime = null;
    destinationHospitalIdx = null;
    otherDestinationHospital = null;
    destinationHospital = null;

    gender = null;
    idNumber = null;
    age = null;
    address = null;
    patientBelongings = null;
    belongingsHandled = null;
    custodianName = null;
    custodianSignature = null;

    chiefComplaint = null;
    traumaClass = {};
    nonTraumaType = {};
    nonTraumaAcutePicked = {};
    nonTraumaGeneralPicked = {};
    traumaTypePicked = {};
    traumaGeneralBodyPicked = {};
    traumaMechanismPicked = {};
    allergy = {};
    pmh = {};
    allergyOther = null;
    pmhOther = null;
    nonTraumaAcuteOther = null;
    traumaGeneralOther = null;
    fallHeight = null;
    burnDegree = null;
    burnArea = null;
    traumaOther = null;
    isProxyStatement = null;

    emergencyTreatments = {};
    airwayTreatments = {};
    traumaTreatments = {};
    transportMethods = {};
    cprMethods = {};
    medicationProcedures = {};
    otherEmergencyProcedures = {};
    bodyDiagramNote = null;
    bodyDiagramPath = null;
    airwayOther = null;
    otherEmergencyOther = null;
    aslType = null;
    ettSize = null;
    ettDepth = null;
    manualDefibCount = null;
    manualDefibJoules = null;
    guideNote = null;
    receivingUnit = null;
    receivingTime = null;
    isRejection = null;
    rejectionName = null;
    relationshipType = null;
    contactName = null;
    contactPhone = null;
    medicationRecords = [];
    paramedicRecords = [];
    vitalSignsRecords = [];

    staffFee = null;
    oxygenFee = null;
    totalFee = null;
    chargeStatus = null;
    paidType = null;
    unpaidType = null;

    notifyListeners();
  }

  Future<void> _prefillFromOtherTables(AmbulanceRecordsDao dao) async {
    try {
      print('🔍 開始從其他資料表預填資料...');
      final profile = await dao.db.patientProfilesDao.getByVisitId(visitId);
      if (profile != null) {
        print('✅ 找到 PatientProfile 資料');
        if (gender == null && profile.gender != null) gender = profile.gender;
        if (age == null && profile.age != null) age = profile.age;
        if (idNumber == null && profile.idNumber != null)
          idNumber = profile.idNumber;
        if (address == null && profile.address != null)
          address = profile.address;
      }
      final accidentRecord = await dao.db.accidentRecordsDao.getByVisitId(
        visitId,
      );
      if (accidentRecord != null) {
        print('✅ 找到 AccidentRecord 資料');
        if (placeGroupIdx == null && accidentRecord.placeIdx != null)
          placeGroupIdx = accidentRecord.placeIdx;
        if (t1PlaceIdx == null && accidentRecord.t1PlaceIdx != null)
          t1PlaceIdx = accidentRecord.t1PlaceIdx;
        if (t2PlaceIdx == null && accidentRecord.t2PlaceIdx != null)
          t2PlaceIdx = accidentRecord.t2PlaceIdx;
        if (placeNote == null && accidentRecord.placeNote != null)
          placeNote = accidentRecord.placeNote;
      }
      print('✅ 預填資料完成!');
    } catch (e) {
      print('⚠️ 預填資料時發生錯誤: $e');
    }
  }

  Future<void> loadFromDatabase(AmbulanceRecordsDao dao) async {
    try {
      final record = await dao.getByVisitId(visitId);

      // ==================== 【【【【核心修正區塊】】】】 ====================
      // 檢查紀錄是否存在
      if (record == null) {
        // 【【步驟 1】】 這是一筆新紀錄，開始初始化流程
        print('📝 找不到 visitId: $visitId 的現有記錄，正在初始化新的救護記錄...');

        // 【【步驟 2】】 清除可能存在的舊資料，確保表單是乾淨的
        clearAll();

        dutyTime = DateTime.now();
        receivingTime = DateTime.now();
        isRejection = false; // 預設為「否」
        isProxyStatement = false; // 預設為「否」

        // 【【步驟 4】】 嘗試從其他關聯表中預填更精確的資料
        await _prefillFromOtherTables(dao);

        // 【【步驟 5】】 通知所有監聽此 Provider 的 UI 元件進行重繪
        notifyListeners();
        return; // 初始化完成，直接返回，不執行後續的舊資料載入邏輯
      }
      // =================================================================

      // --- 如果 record 不是 null，則執行現有紀錄的載入邏輯 ---
      print('✅ 找到救護車記錄, 載入資料...');
      plateNumber = record.plateNumber;
      placeGroupIdx = record.placeGroupIdx;
      t1PlaceIdx = record.t1PlaceIdx;
      t2PlaceIdx = record.t2PlaceIdx;
      remotePlaceIdx = record.remotePlaceIdx;
      cargoPlaceIdx = record.cargoPlaceIdx;
      novotelPlaceIdx = record.novotelPlaceIdx;
      cabinPlaceIdx = record.cabinPlaceIdx;
      placeNote = record.placeNote;
      dutyTime = record.dutyTime;
      arriveSceneTime = record.arriveSceneTime;
      leaveSceneTime = record.leaveSceneTime;
      arriveHospitalTime = record.arriveHospitalTime;
      leaveHospitalTime = record.leaveHospitalTime;
      backStandbyTime = record.backStandbyTime;
      destinationHospitalIdx = record.destinationHospitalIdx;
      otherDestinationHospital = record.otherDestinationHospital;
      destinationHospital = record.destinationHospital;

      final profile = await dao.db.patientProfilesDao.getByVisitId(visitId);
      if (profile != null) {
        gender = profile.gender;
        idNumber = profile.idNumber;
        age = profile.age;
        address = profile.address;
      }
      patientBelongings = record.patientBelongings;
      belongingsHandled = record.belongingsHandled;
      custodianName = record.custodianName;
      custodianSignature = record.custodianSignature;

      chiefComplaint = record.chiefComplaint;
      traumaClass = _jsonToSet(record.traumaClassJson);
      nonTraumaType = _jsonToSet(record.nonTraumaTypeJson);
      nonTraumaAcutePicked = _jsonToSet(record.nonTraumaAcutePickedJson);
      nonTraumaGeneralPicked = _jsonToSet(record.nonTraumaGeneralPickedJson);
      traumaTypePicked = _jsonToSet(record.traumaTypePickedJson);
      traumaGeneralBodyPicked = _jsonToSet(record.traumaGeneralBodyPickedJson);
      traumaMechanismPicked = _jsonToSet(record.traumaMechanismPickedJson);
      allergy = _jsonToSet(record.allergyJson);
      pmh = _jsonToSet(record.pmhJson);
      allergyOther = record.allergyOther;
      pmhOther = record.pmhOther;
      nonTraumaAcuteOther = record.nonTraumaAcuteOther;
      traumaGeneralOther = record.traumaGeneralOther;
      fallHeight = record.fallHeight;
      burnDegree = record.burnDegree;
      burnArea = record.burnArea;
      isProxyStatement = record.isProxyStatement;
      traumaOther = record.traumaOther;

      emergencyTreatments = _jsonToMap(record.emergencyTreatmentsJson);
      airwayTreatments = _jsonToMap(record.airwayTreatmentsJson);
      traumaTreatments = _jsonToMap(record.traumaTreatmentsJson);
      transportMethods = _jsonToMap(record.transportMethodsJson);
      cprMethods = _jsonToMap(record.cprMethodsJson);
      medicationProcedures = _jsonToMap(record.medicationProceduresJson);
      otherEmergencyProcedures = _jsonToMap(
        record.otherEmergencyProceduresJson,
      );
      bodyDiagramNote = record.bodyDiagramNote;
      bodyDiagramPath = record.bodyDiagramPath;
      airwayOther = record.airwayOther;
      otherEmergencyOther = record.otherEmergencyOther;
      aslType = record.aslType;
      ettSize = record.ettSize;
      ettDepth = record.ettDepth;
      manualDefibCount = record.manualDefibCount;
      manualDefibJoules = record.manualDefibJoules;
      guideNote = record.guideNote;
      receivingUnit = record.receivingUnit;
      receivingTime = record.receivingTime;
      isRejection = record.isRejection;
      rejectionName = record.rejectionName;
      relationshipType = record.relationshipType;
      contactName = record.contactName;
      contactPhone = record.contactPhone;

      try {
        medicationRecords = (jsonDecode(record.medicationRecordsJson) as List)
            .map((item) => MedicationRecordModel.fromJson(item))
            .toList();
      } catch (e) {
        print('⚠️ 解碼 medicationRecordsJson 失敗: $e');
        medicationRecords = [];
      }

      try {
        final jsonString = record.paramedicRecordsJson; // 這是一個新欄位
        if (jsonString != null && jsonString.isNotEmpty) {
          paramedicRecords = (jsonDecode(jsonString) as List)
              .map((item) => ParamedicRecordModel.fromJson(item))
              .toList();
        } else {
          paramedicRecords = [];
        }
      } catch (e) {
        print('⚠️ 解碼 paramedicRecordsJson 失敗: $e');
        paramedicRecords = [];
      }

      try {
        final jsonString = record.vitalSignsRecordsJson; // 使用新欄位
        if (jsonString != null && jsonString.isNotEmpty) {
          vitalSignsRecords = (jsonDecode(jsonString) as List)
              .map((item) => VitalSignRecordModel.fromJson(item))
              .toList();
        } else {
          vitalSignsRecords = [];
        }
      } catch (e) {
        print('⚠️ 解碼 vitalSignsRecordsJson 失敗: $e');
        vitalSignsRecords = [];
      }

      staffFee = record.staffFee;
      oxygenFee = record.oxygenFee;
      totalFee = record.totalFee;
      chargeStatus = record.chargeStatus;
      paidType = record.paidType;
      unpaidType = record.unpaidType;

      // 為了確保資料同步，即使是舊紀錄，也再次嘗試預填（只會填補空值）
      await _prefillFromOtherTables(dao);
      notifyListeners();
      print('✅ 成功載入 visitId $visitId 的救護車記錄');
    } catch (e) {
      print('❌ 載入救護車記錄失敗: $e');
      clearAll();
      notifyListeners(); // 發生錯誤時也通知 UI 更新為空白狀態
    }
  }

  Set<String> _jsonToSet(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      return List<String>.from(jsonDecode(jsonString)).toSet();
    } catch (e) {
      return {};
    }
  }

  Map<String, bool> _jsonToMap(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map) {
        return Map<String, bool>.from(
          decoded.map((key, value) => MapEntry(key.toString(), value as bool)),
        );
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  AmbulanceRecordsCompanion toCompanion() {
    return AmbulanceRecordsCompanion(
      visitId: Value(visitId),
      plateNumber: Value(plateNumber),
      placeGroupIdx: Value(placeGroupIdx),
      t1PlaceIdx: Value(t1PlaceIdx),
      t2PlaceIdx: Value(t2PlaceIdx),
      remotePlaceIdx: Value(remotePlaceIdx),
      cargoPlaceIdx: Value(cargoPlaceIdx),
      novotelPlaceIdx: Value(novotelPlaceIdx),
      cabinPlaceIdx: Value(cabinPlaceIdx),
      placeNote: Value(placeNote),
      dutyTime: Value(dutyTime),
      arriveSceneTime: Value(arriveSceneTime),
      leaveSceneTime: Value(leaveSceneTime),
      arriveHospitalTime: Value(arriveHospitalTime),
      leaveHospitalTime: Value(leaveHospitalTime),
      backStandbyTime: Value(backStandbyTime),
      destinationHospitalIdx: Value(destinationHospitalIdx),
      otherDestinationHospital: Value(otherDestinationHospital),
      destinationHospital: Value(destinationHospital),
      patientBelongings: Value(patientBelongings),
      belongingsHandled: Value(belongingsHandled),
      custodianName: Value(custodianName),
      custodianSignature: Value(custodianSignature),
      chiefComplaint: Value(chiefComplaint),
      traumaClassJson: Value(jsonEncode(traumaClass.toList())),
      nonTraumaTypeJson: Value(jsonEncode(nonTraumaType.toList())),
      nonTraumaAcutePickedJson: Value(
        jsonEncode(nonTraumaAcutePicked.toList()),
      ),
      nonTraumaGeneralPickedJson: Value(
        jsonEncode(nonTraumaGeneralPicked.toList()),
      ),
      traumaTypePickedJson: Value(jsonEncode(traumaTypePicked.toList())),
      traumaGeneralBodyPickedJson: Value(
        jsonEncode(traumaGeneralBodyPicked.toList()),
      ),
      traumaMechanismPickedJson: Value(
        jsonEncode(traumaMechanismPicked.toList()),
      ),
      allergyJson: Value(jsonEncode(allergy.toList())),
      pmhJson: Value(jsonEncode(pmh.toList())),
      allergyOther: Value(allergyOther),
      pmhOther: Value(pmhOther),
      nonTraumaAcuteOther: Value(nonTraumaAcuteOther),
      traumaGeneralOther: Value(traumaGeneralOther),
      fallHeight: Value(fallHeight),
      burnDegree: Value(burnDegree),
      burnArea: Value(burnArea),
      traumaOther: Value(traumaOther),
      isProxyStatement: Value(isProxyStatement),
      emergencyTreatmentsJson: Value(jsonEncode(emergencyTreatments)),
      airwayTreatmentsJson: Value(jsonEncode(airwayTreatments)),
      traumaTreatmentsJson: Value(jsonEncode(traumaTreatments)),
      transportMethodsJson: Value(jsonEncode(transportMethods)),
      cprMethodsJson: Value(jsonEncode(cprMethods)),
      medicationProceduresJson: Value(jsonEncode(medicationProcedures)),
      otherEmergencyProceduresJson: Value(jsonEncode(otherEmergencyProcedures)),
      bodyDiagramNote: Value(bodyDiagramNote),
      bodyDiagramPath: Value(bodyDiagramPath),
      airwayOther: Value(airwayOther),
      otherEmergencyOther: Value(otherEmergencyOther),
      aslType: Value(aslType),
      ettSize: Value(ettSize),
      ettDepth: Value(ettDepth),
      manualDefibCount: Value(manualDefibCount),
      manualDefibJoules: Value(manualDefibJoules),
      guideNote: Value(guideNote),
      receivingUnit: Value(receivingUnit),
      receivingTime: Value(receivingTime),
      isRejection: Value(isRejection ?? false),
      rejectionName: Value(rejectionName),
      relationshipType: Value(relationshipType),
      contactName: Value(contactName),
      contactPhone: Value(contactPhone),
      medicationRecordsJson: Value(
        jsonEncode(medicationRecords.map((r) => r.toJson()).toList()),
      ),
      paramedicRecordsJson: Value(
        jsonEncode(paramedicRecords.map((r) => r.toJson()).toList()),
      ),
      vitalSignsRecordsJson: Value(
        jsonEncode(vitalSignsRecords.map((r) => r.toJson()).toList()),
      ),
      staffFee: Value(staffFee),
      oxygenFee: Value(oxygenFee),
      totalFee: Value(totalFee),
      chargeStatus: Value(chargeStatus),
      paidType: Value(paidType),
      unpaidType: Value(unpaidType),
    );
  }

  Future<void> saveToDatabase(
    AmbulanceRecordsDao dao,
    PatientProfilesDao profileDao,
    VisitsDao visitsDao,
  ) async {
    try {
      await dao.upsert(toCompanion());
      await profileDao.upsert(
        PatientProfilesCompanion(
          visitId: Value(visitId),
          gender: Value(gender),
          idNumber: Value(idNumber),
          address: Value(address),
        ),
      );
      await visitsDao.updateVisit(
        visitId,
        VisitsCompanion(
          gender: Value(gender),
          uploadedAt: Value(DateTime.now()),
        ),
      );
      print('✅ 救護車記錄已成功儲存到資料庫 (visitId: $visitId)');
    } catch (e) {
      print('❌ 儲存失敗: $e');
      rethrow;
    }
  }
}
