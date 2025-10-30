// lib/data/models/plan_data.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';
import 'package:flutter/foundation.dart'; 

class PlanData extends ChangeNotifier {
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
    '聯新國際醫院',
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

  static final List<String> escortOptions = [
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
  Set<String> screeningMethods = {};
  String? otherScreeningMethod;
  List<Map<String, String>> healthData = [];

  // === 主訴 ===
  String? mainSymptom; // 'trauma' or 'non_trauma'
  Set<String> traumaSymptoms = {};
  Set<String> nonTraumaSymptoms = {};
  Set<String> nonTraumaHeadSymptoms = {};
  Set<String> nonTraumaChestSymptoms = {};
  Set<String> nonTraumaAbdomenSymptoms = {};
  Set<String> nonTraumaLimbsSymptoms = {};
  Set<String> nonTraumaOtherSymptoms = {};
  String? symptomNote;

  // === 照片 ===
  Set<String> photoTypes = {};

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

  String? history; // 'none', 'unknown', 'yes'
  String? allergy; // 'none', 'unknown', 'yes'

  String? initialDiagnosis;
  String? diagnosisCategory;
  String? selectedICD10Main;
  String? selectedICD10Sub1;
  String? selectedICD10Sub2;
  String? triageCategory; // 'level_1', 'level_2', ...

  Set<String> onSiteTreatments = {};

  bool ekgChecked = false;
  String? ekgReading;
  bool sugarChecked = false;
  String? sugarReading;
  bool suggestReferral = false;
  bool intubationChecked = false;
  bool cprChecked = false;
  bool oxygenTherapyChecked = false;
  bool medicalCertificateChecked = false;
  bool prescriptionChecked = false;
  bool otherChecked = false;
  String? otherSummary;

  String? referralPassageType; // 'general', 'emergency'
  String? referralAmbulanceType; // 'medical_center', 'private', 'fire_dept'
  String? referralHospital;
  String? referralOtherHospital;
  String? referralEscortText;
  List<String> selectedEscorts = [];

  String? intubationType; // 'endotracheal', 'lma'
  String? oxygenType; // 'nc', 'mask', 'nrm', 'ambu'
  String? oxygenFlow;
  Set<String> medicalCertificateTypes = {};
  List<Map<String, String>> prescriptionRows = [];

  Set<String> followUpResults = {};

  String? selectedMainDoctor;
  String? selectedMainNurse;
  String? nurseSignature;
  String? selectedEMT;
  String? emtSignature;
  String? helperNamesText;
  List<String> selectedHelpers = [];

  Set<String> specialNotes = {};
  String? otherSpecialNote;

  void update() => notifyListeners();

  void clear() {
    screeningChecked = false;
    screeningMethods = {};
    otherScreeningMethod = null;
    healthData = [];

    mainSymptom = null;
    traumaSymptoms = {};
    nonTraumaSymptoms = {};
    nonTraumaHeadSymptoms = {};
    nonTraumaChestSymptoms = {};
    nonTraumaAbdomenSymptoms = {};
    nonTraumaLimbsSymptoms = {};
    nonTraumaOtherSymptoms = {};
    symptomNote = null;

    photoTypes = {};

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

    onSiteTreatments = {};
    ekgChecked = false;
    ekgReading = null;
    sugarChecked = false;
    sugarReading = null;
    suggestReferral = false;
    intubationChecked = false;
    cprChecked = false;
    oxygenTherapyChecked = false;
    medicalCertificateChecked = false;
    prescriptionChecked = false;
    otherChecked = false;
    otherSummary = null;

    referralPassageType = null;
    referralAmbulanceType = null;
    referralHospital = null;
    referralOtherHospital = null;
    referralEscortText = null;
    selectedEscorts = [];

    intubationType = null;
    oxygenType = null;
    oxygenFlow = null;
    medicalCertificateTypes = {};
    prescriptionRows = [];

    followUpResults = {};

    selectedMainDoctor = null;
    selectedMainNurse = null;
    nurseSignature = null;
    selectedEMT = null;
    emtSignature = null;
    helperNamesText = null;
    selectedHelpers = [];

    specialNotes = {};
    otherSpecialNote = null;

    notifyListeners();
  }

  TreatmentsCompanion toCompanion(int visitId) {
    return TreatmentsCompanion(
      visitId: Value(visitId),
      screeningChecked: Value(screeningChecked),
      screeningMethodsJson: Value(jsonEncode(screeningMethods.toList())),
      otherScreeningMethod: Value(otherScreeningMethod),
      healthDataJson: Value(jsonEncode(healthData)),
      mainSymptom: Value(mainSymptom),
      traumaSymptomsJson: Value(jsonEncode(traumaSymptoms.toList())),
      nonTraumaSymptomsJson: Value(jsonEncode(nonTraumaSymptoms.toList())),
      nonTraumaHeadSymptomsJson: Value(
        jsonEncode(nonTraumaHeadSymptoms.toList()),
      ),
      nonTraumaChestSymptomsJson: Value(
        jsonEncode(nonTraumaChestSymptoms.toList()),
      ),
      nonTraumaAbdomenSymptomsJson: Value(
        jsonEncode(nonTraumaAbdomenSymptoms.toList()),
      ),
      nonTraumaLimbsSymptomsJson: Value(
        jsonEncode(nonTraumaLimbsSymptoms.toList()),
      ),
      nonTraumaOtherSymptomsJson: Value(
        jsonEncode(nonTraumaOtherSymptoms.toList()),
      ),
      symptomNote: Value(symptomNote),
      photoTypesJson: Value(jsonEncode(photoTypes.toList())),
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
      onSiteTreatmentsJson: Value(jsonEncode(onSiteTreatments.toList())),
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
      referralHospital: Value(referralHospital),
      referralOtherHospital: Value(referralOtherHospital),
      referralEscortText: Value(referralEscortText),
      selectedEscortsJson: Value(jsonEncode(selectedEscorts)),
      intubationType: Value(intubationType),
      oxygenType: Value(oxygenType),
      oxygenFlow: Value(oxygenFlow),
      medicalCertificateTypesJson: Value(
        jsonEncode(medicalCertificateTypes.toList()),
      ),
      prescriptionRowsJson: Value(jsonEncode(prescriptionRows)),
      followUpResultsJson: Value(jsonEncode(followUpResults.toList())),
      selectedMainDoctor: Value(selectedMainDoctor),
      selectedMainNurse: Value(selectedMainNurse),
      nurseSignature: Value(nurseSignature),
      selectedEMT: Value(selectedEMT),
      emtSignature: Value(emtSignature),
      helperNamesText: Value(helperNamesText),
      selectedHelpersJson: Value(jsonEncode(selectedHelpers)),
      specialNotesJson: Value(jsonEncode(specialNotes.toList())),
      otherSpecialNote: Value(otherSpecialNote),
    );
  }

  VisitsCompanion toVisitsCompanion() {
    return VisitsCompanion(
      emergencyResult: Value(followUpResults.join('、')),
      note: Value(initialDiagnosis),
    );
  }

  Future<void> saveToDatabase(
    int visitId,
    TreatmentsDao planDao,
    VisitsDao visitsDao,
  ) async {
    try {
      await planDao.upsert(toCompanion(visitId));
      await visitsDao.updateVisit(visitId, toVisitsCompanion());
      debugPrint('現場處置與診斷資料已儲存並同步更新 Visits');
    } catch (e) {
      debugPrint('儲存現場處置資料失敗: $e');
      rethrow;
    }
  }
}
