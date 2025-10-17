// lib/data/models/plan_data.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class PlanData extends ChangeNotifier {
  // === 篩檢 ===
  bool screeningChecked = false;
  Map<String, bool> screeningMethods = {
    '喉頭採檢': false,
    '抽血驗證': false,
    '其他': false,
  };
  String? otherScreeningMethod;
  List<Map<String, String>> healthData = [];

  // === 主訴 ===
  int? mainSymptom;
  Map<String, bool> traumaSymptoms = {
    '鈍挫傷': false,
    '扭傷': false,
    '撕裂傷': false,
    '擦傷': false,
    '肢體變形': false,
    '其他': false,
  };
  Map<String, bool> nonTraumaSymptoms = {
    '頭頸部': false,
    '胸部': false,
    '腹部': false,
    '四肢': false,
    '其他': false,
  };
  Map<String, bool> nonTraumaHeadSymptoms = {
    '頭痛': false,
    '頭暈': false,
    '眩暈': false,
    '視力模糊': false,
    '耳鳴': false,
    '意識改變': false,
    '其他': false,
  };
  Map<String, bool> nonTraumaChestSymptoms = {
    '胸痛': false,
    '胸悶': false,
    '呼吸困難': false,
    '心悸': false,
    '咳嗽': false,
    '咳血': false,
    '其他': false,
  };
  Map<String, bool> nonTraumaAbdomenSymptoms = {
    '腹痛': false,
    '腹脹': false,
    '噁心': false,
    '嘔吐': false,
    '拉肚子': false,
    '血便': false,
    '其他': false,
  };
  Map<String, bool> nonTraumaLimbsSymptoms = {
    '肢體無力': false,
    '肢體麻木': false,
    '肢體疼痛': false,
    '關節腫痛': false,
    '其他': false,
  };
  Map<String, bool> nonTraumaOtherSymptoms = {
    '發燒': false,
    '皮膚紅疹': false,
    '皮膚癢': false,
    '其他': false,
  };
  String? symptomNote;

  // === 照片 ===
  Map<String, bool> photoTypes = {'外傷': false, '心電圖': false, '其他': false};

  // === 身體檢查 ===
  String? bodyCheckHead;
  String? bodyCheckChest;
  String? bodyCheckAbdomen;
  String? bodyCheckLimbs;
  String? bodyCheckOther;

  // === 生命徵象 ===
  String? temperature;
  String? pulse;
  String? respiration;
  String? bpSystolic;
  String? bpDiastolic;
  String? spo2;
  bool consciousClear = true;
  String? evmE;
  String? evmV;
  String? evmM;
  int? leftPupilScale;
  String? leftPupilSize;
  int? rightPupilScale;
  String? rightPupilSize;

  // === 病史 ===
  int? history;
  int? allergy;

  // === 診斷 ===
  String? initialDiagnosis;
  int? diagnosisCategory;
  String? selectedICD10Main;
  String? selectedICD10Sub1;
  String? selectedICD10Sub2;
  int? triageCategory;

  // === 處理摘要 ===
  Map<String, bool> onSiteTreatments = {
    '諮詢衛教': false,
    '內科處置': false,
    '外科處置': false,
    '拒絕處置': false,
    '疑似傳染病診療': false,
  };
  bool icePack = false;
  bool ekgChecked = false;
  String? ekgReading;
  bool sugarChecked = false;
  String? sugarReading;
  bool woundCare = false;
  bool signQuadruplicate = false;
  bool suggestReferral = false;
  bool intubationChecked = false;
  bool cprChecked = false;
  bool oxygenTherapyChecked = false;
  bool medicalCertificateChecked = false;
  bool suction = false;
  bool prescriptionChecked = false;
  bool otherChecked = false;
  String? otherSummary;

  // === 轉診詳情 ===
  int? referralPassageType;
  int? referralAmbulanceType;
  int? referralHospitalIdx;
  String? referralOtherHospital;
  String? referralEscort;

  // === 處置詳情 ===
  int? intubationType;
  int? oxygenType;
  String? oxygenFlow;
  Map<String, bool> medicalCertificateTypes = {
    '適航證明': false,
    '診斷證明': false,
    '就診證明': false,
  };
  List<Map<String, String>> prescriptionRows = [];

  // === 後續結果 ===
  Map<String, bool> followUpResults = {
    '繼續搭機旅行': false,
    '休息觀察或自行回家': false,
    '轉聯新國際醫院': false,
    '轉林口長庚醫院': false,
    '轉其他醫院': false,
    '建議轉診門診追蹤': false,
    '死亡': false,
    '拒絕轉診': false,
  };
  int? otherHospitalIdx;

  // === 人員簽名 ===
  String? selectedMainDoctor;
  String? selectedMainNurse;
  String? nurseSignature;
  String? selectedEMT;
  String? emtSignature;
  String? helperNamesText;
  List<String> selectedHelpers = [];

  // === 特別註記 ===
  Map<String, bool> specialNotes = {
    'OHCA醫護團隊到場前有CPR': false,
    'OHCA醫護團隊到場前有使用AED但無電擊': false,
    'OHCA醫護團隊到場前有使用AED有電擊': false,
    '現場恢復呼吸': false,
    '使用自動心律復甦機': false,
    '空白': false,
  };
  String? otherSpecialNote;

  void update() => notifyListeners();

  void clear() {
    // 將所有欄位重設為初始值
    screeningChecked = false;
    screeningMethods = {'喉頭採檢': false, '抽血驗證': false, '其他': false};
    otherScreeningMethod = null;
    healthData = [];
    mainSymptom = null;
    traumaSymptoms = {
      '鈍挫傷': false,
      '扭傷': false,
      '撕裂傷': false,
      '擦傷': false,
      '肢體變形': false,
      '其他': false,
    };
    nonTraumaSymptoms = {
      '頭頸部': false,
      '胸部': false,
      '腹部': false,
      '四肢': false,
      '其他': false,
    };
    nonTraumaHeadSymptoms = {
      '頭痛': false,
      '頭暈': false,
      '眩暈': false,
      '視力模糊': false,
      '耳鳴': false,
      '意識改變': false,
      '其他': false,
    };
    nonTraumaChestSymptoms = {
      '胸痛': false,
      '胸悶': false,
      '呼吸困難': false,
      '心悸': false,
      '咳嗽': false,
      '咳血': false,
      '其他': false,
    };
    nonTraumaAbdomenSymptoms = {
      '腹痛': false,
      '腹脹': false,
      '噁心': false,
      '嘔吐': false,
      '拉肚子': false,
      '血便': false,
      '其他': false,
    };
    nonTraumaLimbsSymptoms = {
      '肢體無力': false,
      '肢體麻木': false,
      '肢體疼痛': false,
      '關節腫痛': false,
      '其他': false,
    };
    nonTraumaOtherSymptoms = {
      '發燒': false,
      '皮膚紅疹': false,
      '皮膚癢': false,
      '其他': false,
    };
    symptomNote = null;
    photoTypes = {'外傷': false, '心電圖': false, '其他': false};
    bodyCheckHead = null;
    bodyCheckChest = null;
    bodyCheckAbdomen = null;
    bodyCheckLimbs = null;
    bodyCheckOther = null;
    temperature = null;
    pulse = null;
    respiration = null;
    bpSystolic = null;
    bpDiastolic = null;
    spo2 = null;
    consciousClear = true;
    evmE = null;
    evmV = null;
    evmM = null;
    leftPupilScale = null;
    leftPupilSize = null;
    rightPupilScale = null;
    rightPupilSize = null;
    history = null;
    allergy = null;
    initialDiagnosis = null;
    diagnosisCategory = null;
    selectedICD10Main = null;
    selectedICD10Sub1 = null;
    selectedICD10Sub2 = null;
    triageCategory = null;
    onSiteTreatments = {
      '諮詢衛教': false,
      '內科處置': false,
      '外科處置': false,
      '拒絕處置': false,
      '疑似傳染病診療': false,
    };
    icePack = false;
    ekgChecked = false;
    ekgReading = null;
    sugarChecked = false;
    sugarReading = null;
    woundCare = false;
    signQuadruplicate = false;
    suggestReferral = false;
    intubationChecked = false;
    cprChecked = false;
    oxygenTherapyChecked = false;
    medicalCertificateChecked = false;
    suction = false;
    prescriptionChecked = false;
    otherChecked = false;
    otherSummary = null;
    referralPassageType = null;
    referralAmbulanceType = null;
    referralHospitalIdx = null;
    referralOtherHospital = null;
    referralEscort = null;
    intubationType = null;
    oxygenType = null;
    oxygenFlow = null;
    medicalCertificateTypes = {'適航證明': false, '診斷證明': false, '就診證明': false};
    prescriptionRows = [];
    followUpResults = {
      '繼續搭機旅行': false,
      '休息觀察或自行回家': false,
      '轉聯新國際醫院': false,
      '轉林口長庚醫院': false,
      '轉其他醫院': false,
      '建議轉診門診追蹤': false,
      '死亡': false,
      '拒絕轉診': false,
    };
    otherHospitalIdx = null;
    selectedMainDoctor = null;
    selectedMainNurse = null;
    nurseSignature = null;
    selectedEMT = null;
    emtSignature = null;
    helperNamesText = null;
    selectedHelpers = [];
    specialNotes = {
      'OHCA醫護團隊到場前有CPR': false,
      'OHCA醫護團隊到場前有使用AED但無電擊': false,
      'OHCA醫護團隊到場前有使用AED有電擊': false,
      '現場恢復呼吸': false,
      '使用自動心律復甦機': false,
      '空白': false,
    };
    otherSpecialNote = null;

    notifyListeners();
  }

  // ✅ 轉換為 Companion (完整版)
  TreatmentsCompanion toCompanion(int visitId) {
    return TreatmentsCompanion(
      visitId: Value(visitId),
      screeningChecked: Value(screeningChecked),
      screeningMethodsJson: Value(jsonEncode(screeningMethods)),
      otherScreeningMethod: Value(otherScreeningMethod),
      healthDataJson: Value(jsonEncode(healthData)),
      mainSymptom: Value(mainSymptom),
      traumaSymptomsJson: Value(jsonEncode(traumaSymptoms)),
      nonTraumaSymptomsJson: Value(jsonEncode(nonTraumaSymptoms)),
      nonTraumaHeadSymptomsJson: Value(jsonEncode(nonTraumaHeadSymptoms)),
      nonTraumaChestSymptomsJson: Value(jsonEncode(nonTraumaChestSymptoms)),
      nonTraumaAbdomenSymptomsJson: Value(jsonEncode(nonTraumaAbdomenSymptoms)),
      nonTraumaLimbsSymptomsJson: Value(jsonEncode(nonTraumaLimbsSymptoms)),
      nonTraumaOtherSymptomsJson: Value(jsonEncode(nonTraumaOtherSymptoms)),
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
    );
  }

  // ✅ 同步更新 Visits 摘要表
  VisitsCompanion toVisitsCompanion() {
    String? result = followUpResults.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .join('、');
    return VisitsCompanion(
      emergencyResult: Value(result.isNotEmpty ? result : null),
      note: Value(initialDiagnosis),
    );
  }

  // ✅ 資料庫保存
  Future<void> saveToDatabase(
    int visitId,
    TreatmentsDao planDao,
    VisitsDao visitsDao,
  ) async {
    try {
      await planDao.upsert(toCompanion(visitId));
      await visitsDao.updateVisit(visitId, toVisitsCompanion());
      print('✅ 現場處置與診斷資料已儲存並同步更新 Visits');
    } catch (e) {
      print('❌ 儲存現場處置資料失敗: $e');
      rethrow;
    }
  }
}
