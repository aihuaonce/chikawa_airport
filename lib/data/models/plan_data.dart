// lib/data/models/plan_data.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class PlanData extends ChangeNotifier {
  // === 常數列表 (從 plan.dart 移過來) ===
  static final List<String> icd10List = [
    'A00 Cholera - 霍亂',
    'A00.0 Cholera due to Vibrio cholerae 01, biovar cholerae - 血清型01霍亂弧菌霍亂',
    'A00.1 Cholera due to Vibrio cholerae 01, biovar eltor - 血清型01霍亂弧菌El Tor霍亂',
    'A00.9 Cholera, unspecified - 霍亂',
    'A01 Typhoid and paratyphoid fevers - 傷寒及副傷寒',
    'A01.0 Typhoid fever - 傷寒',
    'A01.01 Typhoid fever, unspecified - 傷寒',
    'A01.01 Typhoid meningitis - 傷寒腦膜炎',
  ];

  static final List<String> referralHospitals = [
    '諾新國際醫院',
    '林口長庚醫院',
    '衛生福利部桃園醫院',
    '衛生福利部桃園療養院',
    '桃園國際敏盛醫院',
    '聖保祿醫院',
    '中壢天晟醫院',
    '桃園榮民總醫院',
    '三峽恩主公醫院',
    '其他',
  ];

  static final List<String> otherHospitals = [
    '桃園經國敏盛醫院',
    '聖保祿醫院',
    '衛生福利部桃園醫院',
    '衛生福利部桃園療養院',
    '桃園榮民總醫院',
    '三峽恩主公醫院',
    '其他',
  ];

  static final List<String> visitingStaff = [
    '方詩旋',
    '夏瑿正',
    '江汪財',
    '呂學政',
    '周志勃',
    '金霏歌',
    '徐丕',
    '康曉妤',
  ];

  static final List<String> registeredNurses = [
    '陳怡穎',
    '邱霏鈴',
    '莊漫媛',
    '洪豔',
    '范育婕',
    '陳筱妤',
    '蔡可蓉',
    '粘瑞敏',
  ];

  static final List<String> emts = [
    '王文義',
    '游進昌',
    '胡勝淵',
    '黃逸斌',
    '峯承軒',
    '張致綸',
    '劉呈軒',
  ];

  static final List<String> helperNames = [
    '方詩婷',
    '夏增正',
    '江旺財',
    '呂學政',
    '海欣茹',
    '洪雲敏',
    '徐氏',
    '康曉朗',
    '黎裕昌',
    '戴逸旻',
    '廖詩怡',
    '許婷涵',
    '陳小山',
    '王悅朗',
    '劉金宇',
    '彭士書',
    '熊得志',
    '顧小',
    '蔡心文',
    '程皓',
    '楊敏度',
    '羅尹彤',
    '廖占用',
    '陳國平',
    '蘇敬婷',
    '黃梨梅',
    '朱森學',
    '陳怡穎',
    '邵詩婷',
    '莊抒淵',
    '洪豔',
    '林育緯',
    '唐詩婷',
    '蔡可蓉',
    '粘瑞敏',
    '黃馨儀',
    '陳冠羽',
    '陳怡玲',
    '峯雅柔',
    '何文豪',
    '王文義',
    '游橙晶',
    '胡雅淵',
    '黃逸誠',
    '峯季軒',
    '劉曉敏',
    '張峻維',
    '劉昱軒',
  ];

  static final List<String> diagnosisCategories = [
    'Mild Neurologic(headache、dizziness、vertigo)',
    'Severe Neurologic(syncope、seizure、CVA)',
    'GI non-OP (AGE Epigas mild bleeding)',
    'GI surgical (app cholecystitis PPU)',
    'Mild Trauma(含head injury、non-surgical intervention)',
    'Severe Trauma (surgical intervention)',
    'Mild CV (Palpitation Chest pain H/T hypo)',
    'Severe CV (AMI Arrythmia Shock Others)',
    'RESP(Asthma、COPD)',
    'Fever (cause undetermined)',
    'Musculoskeletal',
    'DM (hypoglycemia or hyperglycemia)',
    'GU (APN Stone or others)',
    'OHCA',
    'Derma',
    'GYN',
    'OPH/ENT',
    'Psychiatric (nervous、anxious、Alcohols/drug)',
    'Others',
  ];

  static final Map<String, List<String>> drugCategories = {
    '口服藥': [
      'Augmentin syrup',
      'Peace 藥錠',
      'Wempyn 潰瘍寧',
      'Ciprofloxacin',
      'Ibuprofen 伊洛芬',
    ],
    '注射劑': [
      'Ventolin 吸入劑',
      'Wycillin 筋注劑',
      'N/S 250ml',
      'D5W 250ml',
      'KCL 添加液',
    ],
    '點滴注射': ['D5S 500ml', 'Lactated Ringer\'s 乳酸林格氏液'],
  };

  static final List<String> usageOptions = ['口服', '靜脈注射', '肌肉注射', '皮下注射'];
  static final List<String> freqOptions = ['QD', 'BID', 'TID', 'QID', 'PRN'];
  static final List<String> daysOptions = ['1 天', '3 天', '5 天', '7 天'];
  static final List<String> doseUnitOptions = ['mg', 'g', 'tab', 'amp', 'vial'];

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
    '中文診斷書': false,
    '英文診斷書': false,
    '中英文適航證明': false,
  };
  List<Map<String, String>> prescriptionRows = [];

  // === 後續結果 ===
  Map<String, bool> followUpResults = {
    '繼續搭機旅行': false,
    '休息觀察或自行回家': false,
    '轉諾新國際醫院': false,
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
    nonTraumaAbdomenSymptoms = {'腹脹腹痛': false, '噁心嘔吐': false, '腹瀉': false};
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
      '轉諾新國際醫院': false,
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
