// data/models/plan_data.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class PlanData extends ChangeNotifier {
  // 疾病管制署篩檢
  bool screeningChecked = false;
  Map<String, bool> screeningMethods = {
    '喉頭採檢': false,
    '抽血驗證': false,
    '其他': false,
  };
  String? otherScreeningMethod;
  List<Map<String, String>> healthData = [];

  // 主訴
  int? mainSymptom; // 0: 外傷, 1: 非外傷
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
    '頭暈目眩': false,
    '意識改變': false,
    '癲癇': false,
    '喉嚨痛': false,
    '鼻塞鼻水': false,
    '五官症狀': false,
  };
  Map<String, bool> nonTraumaChestSymptoms = {
    '咳嗽': false,
    '呼吸困難': false,
    '胸悶胸痛': false,
    '心悸': false,
  };
  Map<String, bool> nonTraumaAbdomenSymptoms = {
    '腹脹腹痛': false,
    '噁心嘔吐': false,
    '腹瀉': false,
  };
  Map<String, bool> nonTraumaLimbsSymptoms = {'疼痛': false, '麻木無力': false};
  Map<String, bool> nonTraumaOtherSymptoms = {
    '發燒': false,
    '倦怠無力': false,
    '頻尿、解尿疼痛': false,
    '暈厥': false,
    '過敏': false,
    '精神異常': false,
    '其他': false,
  };
  String? symptomNote;

  // 照片類型
  Map<String, bool> photoTypes = {'外傷': false, '心電圖': false, '其他': false};
  // Note: Photo paths would be handled separately, perhaps stored in a different table or as a list of strings here.

  // 身體檢查
  String? bodyCheckHead;
  String? bodyCheckChest;
  String? bodyCheckAbdomen;
  String? bodyCheckLimbs;
  String? bodyCheckOther;

  // 生命徵象
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
  int? leftPupilScale; // Using int for radio group
  String? leftPupilSize;
  int? rightPupilScale; // Using int for radio group
  String? rightPupilSize;

  // 病史
  int? history; // 0:無, 1:不詳, 2:有
  int? allergy; // 0:無, 1:不詳, 2:有

  // 初步診斷
  String? initialDiagnosis;
  int? diagnosisCategory;
  String? selectedICD10Main;
  String? selectedICD10Sub1;
  String? selectedICD10Sub2;
  int? triageCategory;

  // 現場處置
  Map<String, bool> onSiteTreatments = {
    '諮詢衛教': false,
    '內科處置': false,
    '外科處置': false,
    '拒絕處置': false,
    '疑似傳染病診療': false,
  };

  // 處理摘要
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

  // 建議轉診
  int? referralPassageType;
  int? referralAmbulanceType;
  int? referralHospitalIdx;
  String? referralOtherHospital;
  String? referralEscort;

  // 插管
  int? intubationType;

  // 氧氣使用
  int? oxygenType;
  String? oxygenFlow;

  // 診斷書
  Map<String, bool> medicalCertificateTypes = {
    '中文診斷書': false,
    '英文診斷書': false,
    '中英文適航證明': false,
  };

  // 藥物使用
  List<Map<String, String>> prescriptionRows = [];

  // 後續結果
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

  // 人員
  String? selectedMainDoctor;
  String? selectedMainNurse;
  String? nurseSignature;
  String? selectedEMT;
  String? emtSignature;
  String? helperNamesText;
  List<String> selectedHelpers = [];

  // 特別註記
  Map<String, bool> specialNotes = {
    'OHCA醫護團隊到場前有CPR': false,
    'OHCA醫護團隊到場前有使用AED但無電擊': false,
    'OHCA醫護團隊到場前有使用AED有電擊': false,
    '現場恢復呼吸': false,
    '使用自動心律復甦機': false,
    '空白': false,
  };
  String? otherSpecialNote;

  void update() {
    notifyListeners();
  }

  void clear() {
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
      '頭暈目眩': false,
      '意識改變': false,
      '癲癇': false,
      '喉嚨痛': false,
      '鼻塞鼻水': false,
      '五官症狀': false,
    };
    nonTraumaChestSymptoms = {
      '咳嗽': false,
      '呼吸困難': false,
      '胸悶胸痛': false,
      '心悸': false,
    };
    nonTraumaLimbsSymptoms = {'疼痛': false, '麻木無力': false};
    nonTraumaOtherSymptoms = {
      '發燒': false,
      '倦怠無力': false,
      '頻尿、解尿疼痛': false,
      '暈厥': false,
      '過敏': false,
      '精神異常': false,
      '其他': false,
    };
    nonTraumaAbdomenSymptoms = {'腹脹腹痛': false, '噁心嘔吐': false, '腹瀉': false};
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
    medicalCertificateTypes = {
      '中文診斷書': false,
      '英文診斷書': false,
      '中英文適航證明': false,
    };
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
}
