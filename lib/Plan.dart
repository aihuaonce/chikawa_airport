//plan.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/plan_data.dart';
import 'nav2.dart'; // SavableStateMixin interface

class PlanPage extends StatefulWidget {
  final int visitId;
  const PlanPage({super.key, required this.visitId});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage>
    with AutomaticKeepAliveClientMixin<PlanPage>, SavableStateMixin<PlanPage> {
  // ===============================================
  // Boilerplate & State Management
  // ===============================================
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // Text controllers for all text fields
  final Map<String, TextEditingController> _controllers = {
    'otherScreeningMethod': TextEditingController(),
    'symptomNote': TextEditingController(),
    'bodyCheckHead': TextEditingController(),
    'bodyCheckChest': TextEditingController(),
    'bodyCheckAbdomen': TextEditingController(),
    'bodyCheckLimbs': TextEditingController(),
    'bodyCheckOther': TextEditingController(),
    'temperature': TextEditingController(),
    'pulse': TextEditingController(),
    'respiration': TextEditingController(),
    'bpSystolic': TextEditingController(),
    'bpDiastolic': TextEditingController(),
    'spo2': TextEditingController(),
    'evmE': TextEditingController(),
    'evmV': TextEditingController(),
    'evmM': TextEditingController(),
    'leftPupilSize': TextEditingController(),
    'rightPupilSize': TextEditingController(),
    'initialDiagnosis': TextEditingController(),
    'ekgReading': TextEditingController(),
    'sugarReading': TextEditingController(),
    'otherSummary': TextEditingController(),
    'referralOtherHospital': TextEditingController(),
    'referralEscort': TextEditingController(),
    'oxygenFlow': TextEditingController(),
    'nurseSignature': TextEditingController(),
    'emtSignature': TextEditingController(),
    'helperNamesText': TextEditingController(),
    'otherSpecialNote': TextEditingController(),
  };

  // Lists for dialogs and options
  final List<String> icd10List = [
    'A00 Cholera - 霍亂',
    'A00.0 Cholera due to Vibrio cholerae 01, biovar cholerae - 血清型01霍亂弧菌霍亂',
    'A00.1 Cholera due to Vibrio cholerae 01, biovar eltor - 血清型01霍亂弧菌El Tor霍亂',
    'A00.9 Cholera, unspecified - 霍亂',
    'A01 Typhoid and paratyphoid fevers - 傷寒及副傷寒',
    'A01.0 Typhoid fever - 傷寒',
    'A01.01 Typhoid fever, unspecified - 傷寒',
    'A01.01 Typhoid meningitis - 傷寒腦膜炎',
  ];
  final List<String> referralHospitals = [
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
  final List<String> otherHospitals = [
    '桃園經國敏盛醫院',
    '聖保祿醫院',
    '衛生福利部桃園醫院',
    '衛生福利部桃園療養院',
    '桃園榮民總醫院',
    '三峽恩主公醫院',
    '其他',
  ];
  final List<String> VisitingStaff = [
    '方詩旋',
    '古璿正',
    '江汪財',
    '呂學政',
    '周志勃',
    '金霍歌',
    '徐丕',
    '康曉妍',
  ];
  final List<String> RegisteredNurses = [
    '陳思穎',
    '邱靜鈴',
    '莊杼媛',
    '洪萱',
    '范育婕',
    '陳珮妤',
    '蔡可葳',
    '粘瑞華',
  ];
  final List<String> EMTs = ['王文義', '游進昌', '胡勝捷', '黃逸斌', '吳承軒', '張致綸', '劉呈軒'];
  final List<String> _helperNames = [
    '方詩婷',
    '古增正',
    '江旺財',
    '呂學政',
    '海欣茹',
    '洪雲敏',
    '徐杰',
    '康曉朗',
    '黎裕昌',
    '戴逸旻',
    '廖詠怡',
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
    '廖名用',
    '陳國平',
    '蘇敬婷',
    '黃梨梅',
    '朱森學',
    '陳思穎',
    '邵詩婷',
    '莊抒捷',
    '洪萱',
    '林育緯',
    '唐詠婷',
    '蔡可葳',
    '粘瑞敏',
    '黃馨儀',
    '陳冠羽',
    '陳怡玲',
    '吳雅柔',
    '何文豪',
    '王文義',
    '游恩晶',
    '胡雅捷',
    '黃逸誠',
    '吳季軒',
    '劉曉華',
    '張峻維',
    '劉昱軒',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  // ===============================================
  // SavableStateMixin Implementation
  // ===============================================
  @override
  Future<void> saveData() async {
    try {
      _syncControllersToData();

      // 【核心修改】在儲存前執行條件檢查與建立
      await _handleConditionalCreation();

      // 執行原有的儲存邏輯
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('儲存計畫與處置頁面失敗: $e')));
      }
      rethrow;
    }
  }

  Future<void> _handleConditionalCreation() async {
    final planData = context.read<PlanData>();

    // 只有當 "建議轉診" 被勾選時才需要繼續
    if (planData.suggestReferral == false) {
      return;
    }

    // 【修改】獲取所有需要的 DAO
    final treatmentsDao = context.read<TreatmentsDao>();
    final referralFormsDao = context.read<ReferralFormsDao>();
    final ambulanceRecordsDao = context.read<AmbulanceRecordsDao>();

    // 1. 讀取資料庫中【儲存前】的原始 Treatment 資料
    final oldTreatment = await treatmentsDao.getByVisitId(widget.visitId);

    // 2. 條件檢查：
    //    - 舊資料不存在 (這是第一次儲存)，且新資料勾選了轉診
    //    - 或者，舊資料的轉診狀態為 false，而新資料變成了 true
    final shouldCreate =
        (oldTreatment == null || oldTreatment.suggestReferral == false);

    if (shouldCreate) {
      bool recordCreated = false; // 用一個旗標來判斷是否需要顯示提示

      // --- 建立救護車紀錄 ---
      bool ambulanceRecordExists = await ambulanceRecordsDao
          .recordExistsForVisit(widget.visitId);
      if (!ambulanceRecordExists) {
        debugPrint('條件滿足！正在為 Visit ${widget.visitId} 建立救護車紀錄...');
        await ambulanceRecordsDao.createRecordForVisit(widget.visitId);
        recordCreated = true;
      }

      // --- 建立轉診單紀錄 ---
      bool referralFormExists = await referralFormsDao.formExistsForVisit(
        widget.visitId,
      );
      if (!referralFormExists) {
        debugPrint('條件滿足！正在為 Visit ${widget.visitId} 建立轉診單...');
        await referralFormsDao.createFormForVisit(widget.visitId);
        recordCreated = true;
      }

      // 如果有任何一筆紀錄被建立，就顯示一個統一的提示
      if (mounted && recordCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已自動建立轉診單與救護車紀錄！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // ===============================================
  // Data Handling Logic
  // ===============================================

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<TreatmentsDao>();
      final planData = context.read<PlanData>();
      final record = await dao.getByVisitId(widget.visitId);

      planData.clear(); // Start with a fresh model

      if (record != null) {
        T decodeJson<T>(String? jsonString, T defaultValue) {
          if (jsonString == null || jsonString.isEmpty) return defaultValue;
          try {
            return jsonDecode(jsonString) as T;
          } catch (e) {
            return defaultValue;
          }
        }

        planData.screeningChecked = record.screeningChecked;
        planData.screeningMethods = Map<String, bool>.from(
          decodeJson(record.screeningMethodsJson, {}),
        );
        planData.otherScreeningMethod = record.otherScreeningMethod;
        planData.healthData = (decodeJson(record.healthDataJson, []) as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
        planData.mainSymptom = record.mainSymptom;
        planData.traumaSymptoms = Map<String, bool>.from(
          decodeJson(record.traumaSymptomsJson, {}),
        );
        planData.nonTraumaSymptoms = Map<String, bool>.from(
          decodeJson(record.nonTraumaSymptomsJson, {}),
        );
        planData.symptomNote = record.symptomNote;
        planData.photoTypes = Map<String, bool>.from(
          decodeJson(record.photoTypesJson, {}),
        );
        planData.bodyCheckHead = record.bodyCheckHead;
        planData.bodyCheckChest = record.bodyCheckChest;
        planData.bodyCheckAbdomen = record.bodyCheckAbdomen;
        planData.bodyCheckLimbs = record.bodyCheckLimbs;
        planData.bodyCheckOther = record.bodyCheckOther;
        planData.temperature = record.temperature;
        planData.pulse = record.pulse;
        planData.respiration = record.respiration;
        planData.bpSystolic = record.bpSystolic;
        planData.bpDiastolic = record.bpDiastolic;
        planData.spo2 = record.spo2;
        planData.consciousClear = record.consciousClear;
        planData.evmE = record.evmE;
        planData.evmV = record.evmV;
        planData.evmM = record.evmM;
        planData.leftPupilScale = record.leftPupilScale;
        planData.leftPupilSize = record.leftPupilSize;
        planData.rightPupilScale = record.rightPupilScale;
        planData.rightPupilSize = record.rightPupilSize;
        planData.history = record.history;
        planData.allergy = record.allergy;
        planData.initialDiagnosis = record.initialDiagnosis;
        planData.diagnosisCategory = record.diagnosisCategory;
        planData.selectedICD10Main = record.selectedICD10Main;
        planData.selectedICD10Sub1 = record.selectedICD10Sub1;
        planData.selectedICD10Sub2 = record.selectedICD10Sub2;
        planData.triageCategory = record.triageCategory;
        planData.onSiteTreatments = Map<String, bool>.from(
          decodeJson(record.onSiteTreatmentsJson, {}),
        );
        planData.ekgChecked = record.ekgChecked;
        planData.ekgReading = record.ekgReading;
        planData.sugarChecked = record.sugarChecked;
        planData.sugarReading = record.sugarReading;
        planData.suggestReferral = record.suggestReferral;
        planData.intubationChecked = record.intubationChecked;
        planData.cprChecked = record.cprChecked;
        planData.oxygenTherapyChecked = record.oxygenTherapyChecked;
        planData.medicalCertificateChecked = record.medicalCertificateChecked;
        planData.prescriptionChecked = record.prescriptionChecked;
        planData.otherChecked = record.otherChecked;
        planData.otherSummary = record.otherSummary;
        planData.referralPassageType = record.referralPassageType;
        planData.referralAmbulanceType = record.referralAmbulanceType;
        planData.referralHospitalIdx = record.referralHospitalIdx;
        planData.referralOtherHospital = record.referralOtherHospital;
        planData.referralEscort = record.referralEscort;
        planData.intubationType = record.intubationType;
        planData.oxygenType = record.oxygenType;
        planData.oxygenFlow = record.oxygenFlow;
        planData.medicalCertificateTypes = Map<String, bool>.from(
          decodeJson(record.medicalCertificateTypesJson, {}),
        );
        planData.prescriptionRows =
            (decodeJson(record.prescriptionRowsJson, []) as List)
                .map((item) => Map<String, String>.from(item))
                .toList();
        planData.followUpResults = Map<String, bool>.from(
          decodeJson(record.followUpResultsJson, {}),
        );
        planData.otherHospitalIdx = record.otherHospitalIdx;
        planData.selectedMainDoctor = record.selectedMainDoctor;
        planData.selectedMainNurse = record.selectedMainNurse;
        planData.nurseSignature = record.nurseSignature;
        planData.selectedEMT = record.selectedEMT;
        planData.emtSignature = record.emtSignature;
        planData.helperNamesText = record.helperNamesText;
        planData.selectedHelpers = List<String>.from(
          decodeJson(record.selectedHelpersJson, []),
        );
        planData.specialNotes = Map<String, bool>.from(
          decodeJson(record.specialNotesJson, {}),
        );
        planData.otherSpecialNote = record.otherSpecialNote;
      }

      _syncControllersFromData(planData);
      planData.update();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("載入資料失敗: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _syncControllersFromData(PlanData planData) {
    _controllers.forEach((key, controller) {
      final value = switch (key) {
        'otherScreeningMethod' => planData.otherScreeningMethod,
        'symptomNote' => planData.symptomNote,
        'bodyCheckHead' => planData.bodyCheckHead,
        'bodyCheckChest' => planData.bodyCheckChest,
        'bodyCheckAbdomen' => planData.bodyCheckAbdomen,
        'bodyCheckLimbs' => planData.bodyCheckLimbs,
        'bodyCheckOther' => planData.bodyCheckOther,
        'temperature' => planData.temperature,
        'pulse' => planData.pulse,
        'respiration' => planData.respiration,
        'bpSystolic' => planData.bpSystolic,
        'bpDiastolic' => planData.bpDiastolic,
        'spo2' => planData.spo2,
        'evmE' => planData.evmE,
        'evmV' => planData.evmV,
        'evmM' => planData.evmM,
        'leftPupilSize' => planData.leftPupilSize,
        'rightPupilSize' => planData.rightPupilSize,
        'initialDiagnosis' => planData.initialDiagnosis,
        'ekgReading' => planData.ekgReading,
        'sugarReading' => planData.sugarReading,
        'otherSummary' => planData.otherSummary,
        'referralOtherHospital' => planData.referralOtherHospital,
        'referralEscort' => planData.referralEscort,
        'oxygenFlow' => planData.oxygenFlow,
        'nurseSignature' => planData.nurseSignature,
        'emtSignature' => planData.emtSignature,
        'helperNamesText' => planData.helperNamesText,
        'otherSpecialNote' => planData.otherSpecialNote,
        _ => null,
      };
      if (value != null) controller.text = value;
    });
  }

  void _syncControllersToData() {
    final planData = context.read<PlanData>();
    _controllers.forEach((key, controller) {
      final text = controller.text.trim();
      switch (key) {
        case 'otherScreeningMethod':
          planData.otherScreeningMethod = text;
          break;
        case 'symptomNote':
          planData.symptomNote = text;
          break;
        case 'bodyCheckHead':
          planData.bodyCheckHead = text;
          break;
        case 'bodyCheckChest':
          planData.bodyCheckChest = text;
          break;
        case 'bodyCheckAbdomen':
          planData.bodyCheckAbdomen = text;
          break;
        case 'bodyCheckLimbs':
          planData.bodyCheckLimbs = text;
          break;
        case 'bodyCheckOther':
          planData.bodyCheckOther = text;
          break;
        case 'temperature':
          planData.temperature = text;
          break;
        case 'pulse':
          planData.pulse = text;
          break;
        case 'respiration':
          planData.respiration = text;
          break;
        case 'bpSystolic':
          planData.bpSystolic = text;
          break;
        case 'bpDiastolic':
          planData.bpDiastolic = text;
          break;
        case 'spo2':
          planData.spo2 = text;
          break;
        case 'evmE':
          planData.evmE = text;
          break;
        case 'evmV':
          planData.evmV = text;
          break;
        case 'evmM':
          planData.evmM = text;
          break;
        case 'leftPupilSize':
          planData.leftPupilSize = text;
          break;
        case 'rightPupilSize':
          planData.rightPupilSize = text;
          break;
        case 'initialDiagnosis':
          planData.initialDiagnosis = text;
          break;
        case 'ekgReading':
          planData.ekgReading = text;
          break;
        case 'sugarReading':
          planData.sugarReading = text;
          break;
        case 'otherSummary':
          planData.otherSummary = text;
          break;
        case 'referralOtherHospital':
          planData.referralOtherHospital = text;
          break;
        case 'referralEscort':
          planData.referralEscort = text;
          break;
        case 'oxygenFlow':
          planData.oxygenFlow = text;
          break;
        case 'nurseSignature':
          planData.nurseSignature = text;
          break;
        case 'emtSignature':
          planData.emtSignature = text;
          break;
        case 'helperNamesText':
          planData.helperNamesText = text;
          break;
        case 'otherSpecialNote':
          planData.otherSpecialNote = text;
          break;
      }
    });
  }

  Future<void> _saveData() async {
    final planDao = context.read<TreatmentsDao>();
    final visitsDao = context.read<VisitsDao>();
    final planData = context.read<PlanData>();

    // ✅ 正確做法：一行程式碼，呼叫您在 PlanData 中完美封裝好的方法
    //    這個方法會自動處理所有欄位的轉換，並同步更新 Visits 摘要表
    await planData.saveToDatabase(widget.visitId, planDao, visitsDao);
  }

  // ===============================================
  // UI Build Method
  // ===============================================
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<PlanData>(
      builder: (context, planData, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 900,
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: _buildFullUI(planData),
            ),
          ),
        );
      },
    );
  }

  // ===============================================
  // Main UI Structure (Extracted for Readability)
  // ===============================================
  Widget _buildFullUI(PlanData planData) {
    final Map<String, bool> onSiteTreatments = {
      '諮詢衛教': false,
      '內科處置': false,
      '外科處置': false,
      '拒絕處置': false,
      '疑似傳染病診療': false,
    };
    final Map<String, bool> specialNotes = {
      'OHCA醫護團隊到場前有CPR': false,
      'OHCA醫護團隊到場前有使用AED但無電擊': false,
      'OHCA醫護團隊到場前有使用AED有電擊': false,
      '現場恢復呼吸': false,
      '使用自動心律復甦機': false,
      '空白': false,
    };
    final Map<String, bool> followUpResults = {
      '繼續搭機旅行': false,
      '休息觀察或自行回家': false,
      '轉聯新國際醫院': false,
      '轉林口長庚醫院': false,
      '轉其他醫院': true,
      '建議轉診門診追蹤': false,
      '死亡': false,
      '拒絕轉診': false,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Left Column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('疾病管制署篩檢'),
                  _CheckBoxItem(
                    label: "啟用篩檢",
                    value: planData.screeningChecked,
                    onChanged: (v) {
                      planData.screeningChecked = v ?? false;
                      planData.update();
                    },
                  ),
                  const SizedBox(height: 24),
                  if (planData.screeningChecked) ...[
                    _SectionTitle('篩檢方式'),
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: planData.screeningMethods.keys
                          .map(
                            (label) => _CheckBoxItem(
                              label: label,
                              value: planData.screeningMethods[label] ?? false,
                              onChanged: (v) {
                                planData.screeningMethods[label] = v ?? false;
                                planData.update();
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('其他篩檢方式'),
                    TextField(
                      controller: _controllers['otherScreeningMethod'],
                      decoration: const InputDecoration(
                        hintText: '請填寫其他篩檢方式',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle('健康評估'),
                    _HealthDataTable(
                      healthData: planData.healthData,
                      onAdd: () => _addHealthDataDialog(planData),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _SectionTitle('主訴'),
                  Row(
                    children: [
                      _RadioItem(
                        "外傷",
                        value: 0,
                        groupValue: planData.mainSymptom,
                        onChanged: (v) {
                          planData.mainSymptom = v;
                          planData.update();
                        },
                      ),
                      _RadioItem(
                        "非外傷",
                        value: 1,
                        groupValue: planData.mainSymptom,
                        onChanged: (v) {
                          planData.mainSymptom = v;
                          planData.update();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (planData.mainSymptom == 0) ...[
                    _SectionTitle('外傷'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: planData.traumaSymptoms.keys
                          .map(
                            (label) => _CheckBoxItem(
                              label: label,
                              value: planData.traumaSymptoms[label] ?? false,
                              onChanged: (v) {
                                planData.traumaSymptoms[label] = v ?? false;
                                planData.update();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (planData.mainSymptom == 1) ...[
                    _SectionTitle('非外傷'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: planData.nonTraumaSymptoms.keys
                          .map(
                            (label) => _CheckBoxItem(
                              label: label,
                              value: planData.nonTraumaSymptoms[label] ?? false,
                              onChanged: (v) {
                                planData.nonTraumaSymptoms[label] = v ?? false;
                                planData.update();
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    if (planData.nonTraumaSymptoms['頭頸部'] == true) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('頭頸部'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: planData.nonTraumaHeadSymptoms.keys
                                .map(
                                  (label) => _CheckBoxItem(
                                    label: label,
                                    value:
                                        planData.nonTraumaHeadSymptoms[label] ??
                                        false,
                                    onChanged: (v) {
                                      planData.nonTraumaHeadSymptoms[label] =
                                          v ?? false;
                                      planData.update();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (planData.nonTraumaSymptoms['胸部'] == true) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('胸部'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: planData.nonTraumaChestSymptoms.keys
                                .map(
                                  (label) => _CheckBoxItem(
                                    label: label,
                                    value:
                                        planData
                                            .nonTraumaChestSymptoms[label] ??
                                        false,
                                    onChanged: (v) {
                                      planData.nonTraumaChestSymptoms[label] =
                                          v ?? false;
                                      planData.update();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (planData.nonTraumaSymptoms['腹部'] == true) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('腹部'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: planData.nonTraumaAbdomenSymptoms.keys
                                .map(
                                  (label) => _CheckBoxItem(
                                    label: label,
                                    value:
                                        planData
                                            .nonTraumaAbdomenSymptoms[label] ??
                                        false,
                                    onChanged: (v) {
                                      planData.nonTraumaAbdomenSymptoms[label] =
                                          v ?? false;
                                      planData.update();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (planData.nonTraumaSymptoms['四肢'] == true) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('四肢'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: planData.nonTraumaLimbsSymptoms.keys
                                .map(
                                  (label) => _CheckBoxItem(
                                    label: label,
                                    value:
                                        planData
                                            .nonTraumaLimbsSymptoms[label] ??
                                        false,
                                    onChanged: (v) {
                                      planData.nonTraumaLimbsSymptoms[label] =
                                          v ?? false;
                                      planData.update();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (planData.nonTraumaSymptoms['其他'] == true) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('其他'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: planData.nonTraumaOtherSymptoms.keys
                                .map(
                                  (label) => _CheckBoxItem(
                                    label: label,
                                    value:
                                        planData
                                            .nonTraumaOtherSymptoms[label] ??
                                        false,
                                    onChanged: (v) {
                                      planData.nonTraumaOtherSymptoms[label] =
                                          v ?? false;
                                      planData.update();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],

                  const SizedBox(height: 16),
                  _SectionTitle('補充說明'),
                  TextField(
                    controller: _controllers['symptomNote'],
                    decoration: const InputDecoration(
                      hintText: '填寫主訴補充說明',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('照片類型'),
                  Wrap(
                    spacing: 16,
                    children: planData.photoTypes.keys
                        .map(
                          (label) => _CheckBoxItem(
                            label: label,
                            value: planData.photoTypes[label] ?? false,
                            onChanged: (v) {
                              planData.photoTypes[label] = v ?? false;
                              planData.update();
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  if (planData.photoTypes['外傷'] == true) ...[
                    _SectionTitle('外傷照片'),
                    _PhotoGrid(title: '外傷照片'),
                    const SizedBox(height: 16),
                  ],
                  if (planData.photoTypes['心電圖'] == true) ...[
                    _SectionTitle('心電圖照片'),
                    _PhotoGrid(title: '心電圖照片'),
                    const SizedBox(height: 16),
                  ],
                  if (planData.photoTypes['其他'] == true) ...[
                    _SectionTitle('其他照片'),
                    _PhotoGrid(title: '其他照片'),
                    const SizedBox(height: 16),
                  ],
                  _SectionTitle('身體檢查'),
                  const SizedBox(height: 8),
                  _BodyCheckInput('頭頸部', _controllers['bodyCheckHead']!),
                  _BodyCheckInput('胸部', _controllers['bodyCheckChest']!),
                  _BodyCheckInput('腹部', _controllers['bodyCheckAbdomen']!),
                  _BodyCheckInput('四肢', _controllers['bodyCheckLimbs']!),
                  _BodyCheckInput('其他', _controllers['bodyCheckOther']!),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              // Right Column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('語音輸入：'),
                  const Text('這裡依序輸入體溫、脈搏、呼吸、血壓、血氧、血糖'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83ACA9),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('確認'),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('體溫(°C)'),
                  TextField(
                    controller: _controllers['temperature'],
                    decoration: const InputDecoration(
                      hintText: '輸入數字',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('脈搏(次/min)'),
                  TextField(
                    controller: _controllers['pulse'],
                    decoration: const InputDecoration(
                      hintText: '輸入整數',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('呼吸(次/min)'),
                  TextField(
                    controller: _controllers['respiration'],
                    decoration: const InputDecoration(
                      hintText: '輸入整數',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('血壓(mmHg)'),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _controllers['bpSystolic'],
                          decoration: const InputDecoration(
                            hintText: '整數',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('/'),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _controllers['bpDiastolic'],
                          decoration: const InputDecoration(
                            hintText: '整數',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('血氧(%)'),
                  TextField(
                    controller: _controllers['spo2'],
                    decoration: const InputDecoration(
                      hintText: '輸入數字',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _SectionTitle('意識清晰'),
                      Checkbox(
                        value: planData.consciousClear,
                        onChanged: (v) {
                          planData.consciousClear = v ?? true;
                          planData.update();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!planData.consciousClear) ...[
                    Row(
                      children: [
                        const Text(
                          'E',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _controllers['evmE'],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        const Text(
                          'V',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _controllers['evmV'],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        const Text(
                          'M',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _controllers['evmM'],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // GCS calculation logic would go here
                    const Row(
                      children: [
                        Text(
                          'GCS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text('0'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle('左瞳孔縮放'),
                    Row(
                      children: [
                        _RadioCircle(
                          label: '+',
                          value: 0,
                          groupValue: planData.leftPupilScale,
                          onChanged: (v) {
                            planData.leftPupilScale = v;
                            planData.update();
                          },
                        ),
                        _RadioCircle(
                          label: '-',
                          value: 1,
                          groupValue: planData.leftPupilScale,
                          onChanged: (v) {
                            planData.leftPupilScale = v;
                            planData.update();
                          },
                        ),
                        _RadioCircle(
                          label: '±',
                          value: 2,
                          groupValue: planData.leftPupilScale,
                          onChanged: (v) {
                            planData.leftPupilScale = v;
                            planData.update();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _SectionTitle('左瞳孔大小 (mm)'),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _controllers['leftPupilSize'],
                        decoration: const InputDecoration(
                          hintText: '輸入數字',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle('右瞳孔縮放'),
                    Row(
                      children: [
                        _RadioCircle(
                          label: '+',
                          value: 0,
                          groupValue: planData.rightPupilScale,
                          onChanged: (v) {
                            planData.rightPupilScale = v;
                            planData.update();
                          },
                        ),
                        _RadioCircle(
                          label: '-',
                          value: 1,
                          groupValue: planData.rightPupilScale,
                          onChanged: (v) {
                            planData.rightPupilScale = v;
                            planData.update();
                          },
                        ),
                        _RadioCircle(
                          label: '±',
                          value: 2,
                          groupValue: planData.rightPupilScale,
                          onChanged: (v) {
                            planData.rightPupilScale = v;
                            planData.update();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _SectionTitle('右瞳孔大小 (mm)'),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _controllers['rightPupilSize'],
                        decoration: const InputDecoration(
                          hintText: '輸入數字',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _SectionTitle('過去病史'),
                  Row(
                    children: [
                      _RadioItem(
                        "無",
                        value: 0,
                        groupValue: planData.history,
                        onChanged: (v) {
                          planData.history = v;
                          planData.update();
                        },
                      ),
                      _RadioItem(
                        "不詳",
                        value: 1,
                        groupValue: planData.history,
                        onChanged: (v) {
                          planData.history = v;
                          planData.update();
                        },
                      ),
                      _RadioItem(
                        "有",
                        value: 2,
                        groupValue: planData.history,
                        onChanged: (v) {
                          planData.history = v;
                          planData.update();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('過敏史'),
                  Row(
                    children: [
                      _RadioItem(
                        "無",
                        value: 0,
                        groupValue: planData.allergy,
                        onChanged: (v) {
                          planData.allergy = v;
                          planData.update();
                        },
                      ),
                      _RadioItem(
                        "不詳",
                        value: 1,
                        groupValue: planData.allergy,
                        onChanged: (v) {
                          planData.allergy = v;
                          planData.update();
                        },
                      ),
                      _RadioItem(
                        "有",
                        value: 2,
                        groupValue: planData.allergy,
                        onChanged: (v) {
                          planData.allergy = v;
                          planData.update();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _SectionTitle('初步診斷'),
        TextField(
          controller: _controllers['initialDiagnosis'],
          decoration: const InputDecoration(
            hintText: '請填寫初步診斷',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle('初步診斷類別'),
        _buildDiagnosisCategory(planData),
        const SizedBox(height: 24),
        _SectionTitle('初步診斷的ICD-10'),
        _buildICD10Selector("主診斷", planData.selectedICD10Main, (v) {
          planData.selectedICD10Main = v;
          planData.update();
        }),
        const SizedBox(height: 24),
        _SectionTitle('副診斷1的ICD-10'),
        _buildICD10Selector("副診斷1", planData.selectedICD10Sub1, (v) {
          planData.selectedICD10Sub1 = v;
          planData.update();
        }),
        const SizedBox(height: 24),
        _SectionTitle('副診斷2的ICD-10'),
        _buildICD10Selector("副診斷2", planData.selectedICD10Sub2, (v) {
          planData.selectedICD10Sub2 = v;
          planData.update();
        }),
        const SizedBox(height: 32),
        _SectionTitle('檢傷分類'),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: [
            _RadioItem(
              '第一級：復甦急救',
              value: 0,
              groupValue: planData.triageCategory,
              onChanged: (v) {
                planData.triageCategory = v;
                planData.update();
              },
            ),
            _RadioItem(
              '第二級：危急',
              value: 1,
              groupValue: planData.triageCategory,
              onChanged: (v) {
                planData.triageCategory = v;
                planData.update();
              },
            ),
            _RadioItem(
              '第三級：緊急',
              value: 2,
              groupValue: planData.triageCategory,
              onChanged: (v) {
                planData.triageCategory = v;
                planData.update();
              },
            ),
            _RadioItem(
              '第四級：次緊急',
              value: 3,
              groupValue: planData.triageCategory,
              onChanged: (v) {
                planData.triageCategory = v;
                planData.update();
              },
            ),
            _RadioItem(
              '第五級：非緊急',
              value: 4,
              groupValue: planData.triageCategory,
              onChanged: (v) {
                planData.triageCategory = v;
                planData.update();
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionTitle('現場處置'),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: onSiteTreatments.keys
              .map(
                (label) => _CheckBoxItem(
                  label: label,
                  value: planData.onSiteTreatments[label] ?? false,
                  onChanged: (v) {
                    planData.onSiteTreatments[label] = v ?? false;
                    planData.update();
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        _SectionTitle('處理摘要'),
        _buildSummaryCheckboxes(planData),
        const SizedBox(height: 16),
        if (planData.ekgChecked) ...[
          _SectionTitle('心電圖判讀'),
          TextField(
            controller: _controllers['ekgReading'],
            decoration: const InputDecoration(
              hintText: '請填寫判讀結果',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (planData.sugarChecked) ...[
          _SectionTitle('血糖(mg/dL)'),
          TextField(
            controller: _controllers['sugarReading'],
            decoration: const InputDecoration(
              hintText: '請填寫血糖記錄',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (planData.suggestReferral) _buildReferralSection(planData),
        if (planData.intubationChecked) ...[
          _SectionTitle('插管方式'),
          Row(
            children: [
              _RadioItem(
                'Endotracheal tube',
                value: 0,
                groupValue: planData.intubationType,
                onChanged: (v) {
                  planData.intubationType = v;
                  planData.update();
                },
              ),
              _RadioItem(
                'LMA',
                value: 1,
                groupValue: planData.intubationType,
                onChanged: (v) {
                  planData.intubationType = v;
                  planData.update();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (planData.cprChecked) ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF83ACA9),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('產生急救記錄單'),
          ),
          const SizedBox(height: 16),
        ],
        if (planData.oxygenTherapyChecked) _buildOxygenSection(planData),
        if (planData.medicalCertificateChecked) ...[
          _SectionTitle('診斷書種類'),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: planData.medicalCertificateTypes.keys
                .map(
                  (label) => _CheckBoxItem(
                    label: label,
                    value: planData.medicalCertificateTypes[label] ?? false,
                    onChanged: (v) {
                      planData.medicalCertificateTypes[label] = v ?? false;
                      planData.update();
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (planData.prescriptionChecked) ...[
          _SectionTitle('藥物記錄表'),
          _PrescriptionTable(
            prescriptionRows: planData.prescriptionRows,
            onAdd: () => _showPrescriptionDialog(planData),
          ),
          const SizedBox(height: 16),
        ],
        if (planData.otherChecked) ...[
          _SectionTitle('其他處理摘要'),
          TextField(
            controller: _controllers['otherSummary'],
            decoration: const InputDecoration(
              hintText: '請填寫其他處理摘要',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        _SectionTitle('後續結果'),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: followUpResults.keys.map((label) {
            bool isOtherHospital = label == '轉其他醫院';
            return _CheckBoxItem(
              label: label,
              value: isOtherHospital
                  ? planData.followUpResults['轉其他醫院'] ?? false
                  : planData.followUpResults[label] ?? false,
              onChanged: (v) {
                if (isOtherHospital) {
                  planData.followUpResults['轉其他醫院'] = v ?? false;
                } else {
                  planData.followUpResults[label] = v ?? false;
                }
                planData.update();
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        if (planData.followUpResults['轉其他醫院'] == true) ...[
          _SectionTitle('其他醫院'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              otherHospitals.length,
              (i) => _RadioItem(
                otherHospitals[i],
                value: i,
                groupValue: planData.otherHospitalIdx,
                onChanged: (v) {
                  planData.otherHospitalIdx = v;
                  planData.update();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        _SectionTitle('院長'),
        const SizedBox(height: 16),
        _SectionTitle('主責醫師', color: Colors.red),
        GestureDetector(
          onTap: () => _showStaffDialog(planData, '醫師'),
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(
                text: planData.selectedMainDoctor ?? '',
              ),
              decoration: const InputDecoration(
                hintText: '點擊選擇醫師的姓名（必填）',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle('主責護理師', color: Colors.red),
        GestureDetector(
          onTap: () => _showStaffDialog(planData, '護理師'),
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(
                text: planData.selectedMainNurse ?? '',
              ),
              decoration: const InputDecoration(
                hintText: '點擊選擇護理師的姓名（必填）',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle('護理師簽名'),
        TextField(
          controller: _controllers['nurseSignature'],
          decoration: const InputDecoration(
            hintText: '',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        _SectionTitle('EMT姓名'),
        GestureDetector(
          onTap: () => _showStaffDialog(planData, 'EMT'),
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(
                text: planData.selectedEMT ?? '',
              ),
              decoration: const InputDecoration(
                hintText: '點擊選擇EMT的姓名',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SectionTitle('EMT簽名'),
        TextField(
          controller: _controllers['emtSignature'],
          decoration: const InputDecoration(
            hintText: '',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        _SectionTitle('協助人員姓名'),
        TextField(
          controller: _controllers['helperNamesText'],
          decoration: const InputDecoration(
            hintText: '請填寫協助人員的姓名',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        _HelperTable(
          selectedHelpers: planData.selectedHelpers,
          onAdd: () => _showHelperSelectionDialog(planData),
        ),
        const SizedBox(height: 24),
        _SectionTitle('特別註記'),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: specialNotes.keys
              .map(
                (label) => _CheckBoxItem(
                  label: label,
                  value: planData.specialNotes[label] ?? false,
                  onChanged: (v) {
                    planData.specialNotes[label] = v ?? false;
                    planData.update();
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        _SectionTitle('其他特別註記'),
        TextField(
          controller: _controllers['otherSpecialNote'],
          decoration: const InputDecoration(
            hintText: '請輸入其他特別註記',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ... (Dialogs and other specific UI section builders)

  // ===============================================
  // Dialogs & Complex UI Section Builders
  // ===============================================

  Widget _buildSummaryCheckboxes(PlanData planData) {
    // A helper map to build the checkboxes
    final Map<String, bool> items = {
      '冰敷': planData.icePack,
      'EKG心電圖': planData.ekgChecked,
      '血糖': planData.sugarChecked,
      '傷口處置': planData.woundCare,
      '簽四聯單': planData.signQuadruplicate,
      '建議轉診': planData.suggestReferral,
      '插管': planData.intubationChecked,
      'CPR': planData.cprChecked,
      '氧氣使用': planData.oxygenTherapyChecked,
      '診斷書': planData.medicalCertificateChecked,
      '抽痰': planData.suction,
      '藥物使用': planData.prescriptionChecked,
      '其他': planData.otherChecked,
    };

    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: items.entries.map((entry) {
        return _CheckBoxItem(
          label: entry.key,
          value: entry.value,
          onChanged: (v) {
            switch (entry.key) {
              case '冰敷':
                planData.icePack = v ?? false;
                break;
              case 'EKG心電圖':
                planData.ekgChecked = v ?? false;
                break;
              case '血糖':
                planData.sugarChecked = v ?? false;
                break;
              case '傷口處置':
                planData.woundCare = v ?? false;
                break;
              case '簽四聯單':
                planData.signQuadruplicate = v ?? false;
                break;
              case '建議轉診':
                planData.suggestReferral = v ?? false;
                break;
              case '插管':
                planData.intubationChecked = v ?? false;
                break;
              case 'CPR':
                planData.cprChecked = v ?? false;
                break;
              case '氧氣使用':
                planData.oxygenTherapyChecked = v ?? false;
                break;
              case '診斷書':
                planData.medicalCertificateChecked = v ?? false;
                break;
              case '抽痰':
                planData.suction = v ?? false;
                break;
              case '藥物使用':
                planData.prescriptionChecked = v ?? false;
                break;
              case '其他':
                planData.otherChecked = v ?? false;
                break;
            }
            planData.update();
          },
        );
      }).toList(),
    );
  }

  Widget _buildReferralSection(PlanData planData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('通關方式'),
        Row(
          children: [
            _RadioItem(
              '一般通關',
              value: 0,
              groupValue: planData.referralPassageType,
              onChanged: (v) {
                planData.referralPassageType = v;
                planData.update();
              },
            ),
            _RadioItem(
              '緊急通關',
              value: 1,
              groupValue: planData.referralPassageType,
              onChanged: (v) {
                planData.referralPassageType = v;
                planData.update();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _SectionTitle('救護車'),
        Row(
          children: [
            _RadioItem(
              '醫療中心',
              value: 0,
              groupValue: planData.referralAmbulanceType,
              onChanged: (v) {
                planData.referralAmbulanceType = v;
                planData.update();
              },
            ),
            _RadioItem(
              '民間',
              value: 1,
              groupValue: planData.referralAmbulanceType,
              onChanged: (v) {
                planData.referralAmbulanceType = v;
                planData.update();
              },
            ),
            _RadioItem(
              '消防隊',
              value: 2,
              groupValue: planData.referralAmbulanceType,
              onChanged: (v) {
                planData.referralAmbulanceType = v;
                planData.update();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _SectionTitle('轉送醫院'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            referralHospitals.length,
            (i) => _RadioItem(
              referralHospitals[i],
              value: i,
              groupValue: planData.referralHospitalIdx,
              onChanged: (v) {
                planData.referralHospitalIdx = v;
                planData.update();
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        _SectionTitle('其他轉送醫院?'),
        TextField(
          controller: _controllers['referralOtherHospital'],
          decoration: const InputDecoration(
            hintText: '請填寫其他轉送醫院',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        _SectionTitle('隨車人員'),
        TextField(
          controller: _controllers['referralEscort'],
          decoration: const InputDecoration(
            hintText: '請填寫隨車人員的姓名',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF274C4A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('產生救護車紀錄單'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOxygenSection(PlanData planData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('氧氣使用'),
        Row(
          children: [
            _RadioItem(
              '鼻導管N/C',
              value: 0,
              groupValue: planData.oxygenType,
              onChanged: (v) {
                planData.oxygenType = v;
                planData.update();
              },
            ),
            _RadioItem(
              '面罩Mask',
              value: 1,
              groupValue: planData.oxygenType,
              onChanged: (v) {
                planData.oxygenType = v;
                planData.update();
              },
            ),
            _RadioItem(
              '非再吸入面罩',
              value: 2,
              groupValue: planData.oxygenType,
              onChanged: (v) {
                planData.oxygenType = v;
                planData.update();
              },
            ),
            _RadioItem(
              'Ambu',
              value: 3,
              groupValue: planData.oxygenType,
              onChanged: (v) {
                planData.oxygenType = v;
                planData.update();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _SectionTitle('氧氣流量(L/MIN)'),
        TextField(
          controller: _controllers['oxygenFlow'],
          decoration: const InputDecoration(
            hintText: '請填寫氧氣流量',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _addHealthDataDialog(PlanData planData) {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final tempController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("新增健康評估"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "姓名"),
            ),
            TextField(
              controller: relationController,
              decoration: const InputDecoration(labelText: "關係"),
            ),
            TextField(
              controller: tempController,
              decoration: const InputDecoration(labelText: "體溫"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF83ACA9),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              planData.healthData.add({
                "name": nameController.text,
                "relation": relationController.text,
                "temp": tempController.text,
              });
              planData.update();
              Navigator.pop(context);
            },
            child: const Text("儲存"),
          ),
        ],
      ),
    );
  }

  Future<void> _showICD10Dialog(ValueChanged<String?> onSelected) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('選擇ICD-10'),
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ListView(
              children: icd10List
                  .map(
                    (item) => ListTile(
                      title: Text(item),
                      onTap: () => Navigator.pop(context, item),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
    if (result != null) onSelected(result);
  }

  Future<void> _showStaffDialog(PlanData planData, String role) async {
    final List<String> staffList = switch (role) {
      '醫師' => VisitingStaff,
      '護理師' => RegisteredNurses,
      'EMT' => EMTs,
      _ => [],
    };
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('選擇$role'),
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ListView(
              children: staffList
                  .map(
                    (item) => ListTile(
                      title: Text(item),
                      onTap: () => Navigator.pop(context, item),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
    if (result != null) {
      switch (role) {
        case '醫師':
          planData.selectedMainDoctor = result;
          break;
        case '護理師':
          planData.selectedMainNurse = result;
          break;
        case 'EMT':
          planData.selectedEMT = result;
          break;
      }
      planData.update();
    }
  }

  Future<void> _showHelperSelectionDialog(PlanData planData) async {
    List<String> tempSelected = List.from(planData.selectedHelpers);
    List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('選擇協助人員姓名'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _helperNames.map((name) {
                    return CheckboxListTile(
                      title: Text(name),
                      value: tempSelected.contains(name),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            tempSelected.add(name);
                          } else {
                            tempSelected.remove(name);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('確定'),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelected);
                  },
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      planData.selectedHelpers = result;
      planData.update();
    }
  }

  Future<void> _showPrescriptionDialog(PlanData planData) async {
    Map<String, String>? result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String? selectedDrug,
            selectedUsage,
            selectedFreq,
            selectedDays,
            selectedDoseUnit;
        String note = '';
        final drugCategories = {
          '口服藥': [
            'Augmentin syrup',
            'Peace 藥錠',
            'Wempyn 潰瘍寧',
            'Ciprofloxacin',
            'Ibuprofen 佈洛芬',
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
        final usageOptions = ['口服', '靜脈注射', '肌肉注射', '皮下注射'];
        final freqOptions = ['QD', 'BID', 'TID', 'QID', 'PRN'];
        final daysOptions = ['1 天', '3 天', '5 天', '7 天'];
        final doseUnitOptions = ['mg', 'g', 'tab', 'amp', 'vial'];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('新增藥物記錄'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('藥品名稱'),
                    ...drugCategories.entries
                        .map(
                          (categoryEntry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  categoryEntry.key,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                children: categoryEntry.value
                                    .map(
                                      (drug) => ChoiceChip(
                                        label: Text(drug),
                                        selected: selectedDrug == drug,
                                        onSelected: (_) =>
                                            setState(() => selectedDrug = drug),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '使用方式'),
                      items: usageOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedUsage = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '服用頻率'),
                      items: freqOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedFreq = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '服用天數'),
                      items: daysOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedDays = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '劑量單位'),
                      items: doseUnitOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedDoseUnit = v,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: '備註'),
                      onChanged: (v) => note = v,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, {
                    '藥品名稱': selectedDrug ?? '',
                    '使用方式': selectedUsage ?? '',
                    '服用頻率': selectedFreq ?? '',
                    '服用天數': selectedDays ?? '',
                    '劑量單位': selectedDoseUnit ?? '',
                    '備註': note,
                  }),
                  child: const Text('儲存'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      planData.prescriptionRows.add(result);
      planData.update();
    }
  }

  Widget _buildICD10Selector(
    String title,
    String? value,
    ValueChanged<String?> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF83ACA9),
                foregroundColor: Colors.white,
              ),
              onPressed: () => _showICD10Dialog(onSelected),
              child: const Text('ICD10CM搜尋'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF83ACA9),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text('GOOGLE搜尋'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: TextEditingController(text: value ?? ''),
          decoration: InputDecoration(
            hintText: '請填寫 $title 的ICD-10代碼',
            border: const OutlineInputBorder(),
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildDiagnosisCategory(PlanData planData) {
    final categories = [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        categories.length,
        (i) => _RadioItem(
          categories[i],
          value: i,
          groupValue: planData.diagnosisCategory,
          onChanged: (v) {
            planData.diagnosisCategory = v;
            planData.update();
          },
        ),
      ),
    );
  }
}

// ===============================================
// Stateless Helper Widgets
// ===============================================

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color? color;
  const _SectionTitle(this.text, {this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 8),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
        fontSize: 16,
      ),
    ),
  );
}

class _RadioItem<T> extends StatelessWidget {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  const _RadioItem(
    this.label, {
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => onChanged(value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          activeColor: const Color(0xFF83ACA9),
          onChanged: onChanged,
        ),
        Flexible(
          child: Text(label, style: const TextStyle(color: Colors.black)),
        ),
      ],
    ),
  );
}

class _CheckBoxItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  const _CheckBoxItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => onChanged(!value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          activeColor: const Color(0xFF83ACA9),
          onChanged: onChanged,
        ),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    ),
  );
}

class _BodyCheckInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _BodyCheckInput(this.label, this.controller);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              hintText: '請輸入檢查資訊',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PhotoGrid extends StatelessWidget {
  final String title;
  const _PhotoGrid({required this.title});
  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 6,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) => Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('$title${index + 1}', style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

class _HealthDataTable extends StatelessWidget {
  final List<Map<String, String>> healthData;
  final VoidCallback onAdd;
  const _HealthDataTable({required this.healthData, required this.onAdd});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        color: const Color(0xFFF1F3F6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: const Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('姓名', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('關係', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('體溫', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      ...healthData.map(
        (row) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(row["name"] ?? "")),
              Expanded(flex: 2, child: Text(row["relation"] ?? "")),
              Expanded(flex: 2, child: Text(row["temp"] ?? "")),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: onAdd,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: const Text('加入資料行', style: TextStyle(color: Colors.blue)),
        ),
      ),
    ],
  );
}

class _RadioCircle extends StatelessWidget {
  final String label;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;
  const _RadioCircle({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => _RadioItem(
    label,
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
  );
}

class _PrescriptionTable extends StatelessWidget {
  final List<Map<String, String>> prescriptionRows;
  final VoidCallback onAdd;
  const _PrescriptionTable({
    required this.prescriptionRows,
    required this.onAdd,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        color: const Color(0xFFF1F3F6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: const Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '藥品名稱',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '使用方式',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '服用頻率',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '服用天數',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '劑量單位',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text('備註', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      ...prescriptionRows.map(
        (row) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(row['藥品名稱'] ?? '')),
              Expanded(flex: 2, child: Text(row['使用方式'] ?? '')),
              Expanded(flex: 2, child: Text(row['服用頻率'] ?? '')),
              Expanded(flex: 2, child: Text(row['服用天數'] ?? '')),
              Expanded(flex: 2, child: Text(row['劑量單位'] ?? '')),
              Expanded(flex: 2, child: Text(row['備註'] ?? '')),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: onAdd,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: const Text('加入資料行', style: TextStyle(color: Colors.blue)),
        ),
      ),
    ],
  );
}

class _HelperTable extends StatelessWidget {
  final List<String> selectedHelpers;
  final VoidCallback onAdd;
  const _HelperTable({required this.selectedHelpers, required this.onAdd});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: const Color(0xFFF1F3F6),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('協助人員姓名'),
        if (selectedHelpers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedHelpers
                  .map(
                    (helper) =>
                        Text(helper, style: const TextStyle(fontSize: 16)),
                  )
                  .toList(),
            ),
          )
        else
          const Text('尚未選擇協助人員', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        InkWell(
          onTap: onAdd,
          child: const Text('加入協助人員', style: TextStyle(color: Colors.blue)),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}
