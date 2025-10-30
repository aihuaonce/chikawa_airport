// lib/plan.dart
import 'dart:convert';
import 'package:chikawa_airport/l10n/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/plan_data.dart';
import 'nav2.dart';

class PlanPage extends StatefulWidget {
  final int visitId;
  const PlanPage({super.key, required this.visitId});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage>
    with AutomaticKeepAliveClientMixin<PlanPage>, SavableStateMixin<PlanPage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

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
    'referralEscortText': TextEditingController(),
    'oxygenFlow': TextEditingController(),
    'nurseSignature': TextEditingController(),
    'emtSignature': TextEditingController(),
    'helperNamesText': TextEditingController(),
    'otherSpecialNote': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      _syncControllersToData();
      await _handleConditionalCreation();
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.savePlanFailed + e.toString())),
        );
      }
      rethrow;
    }
  }

  Future<void> _handleConditionalCreation() async {
    if (!mounted) return;
    final planData = context.read<PlanData>();
    final treatmentsDao = context.read<TreatmentsDao>();
    final t = AppTranslations.of(context);

    final oldTreatment = await treatmentsDao.getByVisitId(widget.visitId);

    if (planData.suggestReferral == true) {
      final shouldCreateReferral =
          (oldTreatment == null || oldTreatment.suggestReferral == false);

      if (shouldCreateReferral) {
        final referralFormsDao = context.read<ReferralFormsDao>();
        final ambulanceRecordsDao = context.read<AmbulanceRecordsDao>();
        bool recordCreated = false;

        bool ambulanceRecordExists = await ambulanceRecordsDao
            .recordExistsForVisit(widget.visitId);
        if (!ambulanceRecordExists) {
          await ambulanceRecordsDao.createRecordForVisit(widget.visitId);
          recordCreated = true;
        }

        bool referralFormExists = await referralFormsDao.formExistsForVisit(
          widget.visitId,
        );
        if (!referralFormExists) {
          await referralFormsDao.createFormForVisit(widget.visitId);
          recordCreated = true;
        }

        if (mounted && recordCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.referralAndAmbulanceRecordCreated),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }

    if (planData.cprChecked == true) {
      final shouldCreateEmergency =
          (oldTreatment == null || oldTreatment.cprChecked == false);

      if (shouldCreateEmergency) {
        final emergencyRecordsDao = context.read<EmergencyRecordsDao>();
        bool emergencyRecordExists = await emergencyRecordsDao
            .recordExistsForVisit(widget.visitId);

        if (!emergencyRecordExists) {
          await emergencyRecordsDao.createRecordForVisit(widget.visitId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ 已自動產生急救紀錄單!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      final dao = context.read<TreatmentsDao>();
      final planData = context.read<PlanData>();
      final record = await dao.getByVisitId(widget.visitId);

      planData.clear();

      if (record != null) {
        dynamic decodeJson(String? jsonString, dynamic defaultValue) {
          if (jsonString == null || jsonString.isEmpty) return defaultValue;
          try {
            return jsonDecode(jsonString);
          } catch (e) {
            return defaultValue;
          }
        }

        planData.screeningChecked = record.screeningChecked;
        planData.screeningMethods = Set<String>.from(
          decodeJson(record.screeningMethodsJson, []),
        );
        planData.otherScreeningMethod = record.otherScreeningMethod;
        planData.healthData = (decodeJson(record.healthDataJson, []) as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
        planData.mainSymptom = record.mainSymptom;
        planData.traumaSymptoms = Set<String>.from(
          decodeJson(record.traumaSymptomsJson, []),
        );
        planData.nonTraumaSymptoms = Set<String>.from(
          decodeJson(record.nonTraumaSymptomsJson, []),
        );
        planData.symptomNote = record.symptomNote;
        planData.photoTypes = Set<String>.from(
          decodeJson(record.photoTypesJson, []),
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
        planData.onSiteTreatments = Set<String>.from(
          decodeJson(record.onSiteTreatmentsJson, []),
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
        planData.referralHospital = record.referralHospital;
        planData.referralOtherHospital = record.referralOtherHospital;
        planData.referralEscortText = record.referralEscortText;
        planData.selectedEscorts = List<String>.from(
          decodeJson(record.selectedEscortsJson, []),
        );
        planData.intubationType = record.intubationType;
        planData.oxygenType = record.oxygenType;
        planData.oxygenFlow = record.oxygenFlow;
        planData.medicalCertificateTypes = Set<String>.from(
          decodeJson(record.medicalCertificateTypesJson, []),
        );
        planData.prescriptionRows =
            (decodeJson(record.prescriptionRowsJson, []) as List)
                .map((item) => Map<String, String>.from(item))
                .toList();
        planData.followUpResults = Set<String>.from(
          decodeJson(record.followUpResultsJson, []),
        );
        planData.selectedMainDoctor = record.selectedMainDoctor;
        planData.selectedMainNurse = record.selectedMainNurse;
        planData.nurseSignature = record.nurseSignature;
        planData.selectedEMT = record.selectedEMT;
        planData.emtSignature = record.emtSignature;
        planData.helperNamesText = record.helperNamesText;
        planData.selectedHelpers = List<String>.from(
          decodeJson(record.selectedHelpersJson, []),
        );
        planData.specialNotes = Set<String>.from(
          decodeJson(record.specialNotesJson, []),
        );
        planData.otherSpecialNote = record.otherSpecialNote;
      }

      _syncControllersFromData(planData);
      planData.update();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.loadDataFailed + e.toString())),
        );
      }
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
        'referralEscortText' => planData.referralEscortText,
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
        case 'symptomNote':
          planData.symptomNote = text;
        case 'bodyCheckHead':
          planData.bodyCheckHead = text;
        case 'bodyCheckChest':
          planData.bodyCheckChest = text;
        case 'bodyCheckAbdomen':
          planData.bodyCheckAbdomen = text;
        case 'bodyCheckLimbs':
          planData.bodyCheckLimbs = text;
        case 'bodyCheckOther':
          planData.bodyCheckOther = text;
        case 'temperature':
          planData.temperature = text;
        case 'pulse':
          planData.pulse = text;
        case 'respiration':
          planData.respiration = text;
        case 'bpSystolic':
          planData.bpSystolic = text;
        case 'bpDiastolic':
          planData.bpDiastolic = text;
        case 'spo2':
          planData.spo2 = text;
        case 'evmE':
          planData.evmE = text;
        case 'evmV':
          planData.evmV = text;
        case 'evmM':
          planData.evmM = text;
        case 'leftPupilSize':
          planData.leftPupilSize = text;
        case 'rightPupilSize':
          planData.rightPupilSize = text;
        case 'initialDiagnosis':
          planData.initialDiagnosis = text;
        case 'ekgReading':
          planData.ekgReading = text;
        case 'sugarReading':
          planData.sugarReading = text;
        case 'otherSummary':
          planData.otherSummary = text;
        case 'referralOtherHospital':
          planData.referralOtherHospital = text;
        case 'referralEscortText':
          planData.referralEscortText = text;
        case 'oxygenFlow':
          planData.oxygenFlow = text;
        case 'nurseSignature':
          planData.nurseSignature = text;
        case 'emtSignature':
          planData.emtSignature = text;
        case 'helperNamesText':
          planData.helperNamesText = text;
        case 'otherSpecialNote':
          planData.otherSpecialNote = text;
      }
    });
  }

  Future<void> _saveData() async {
    final planDao = context.read<TreatmentsDao>();
    final visitsDao = context.read<VisitsDao>();
    final planData = context.read<PlanData>();
    await planData.saveToDatabase(widget.visitId, planDao, visitsDao);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final t = AppTranslations.of(context);

    return Consumer<PlanData>(
      builder: (context, planData, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 1000,
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: _buildFullUI(planData, t),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullUI(PlanData planData, AppTranslations t) {
    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF83ACA9),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );

    final screeningMethodOptions = {
      'throat_swab': "喉頭採檢",
      'blood_test': '抽血檢驗',
      'other': t.other,
    };

    final photoTypeOptions = {
      'trauma': t.traumaPhotos,
      'ekg': t.ekgPhotos,
      'other': t.otherPhotos,
    };

    final onSiteTreatmentOptions = {
      'consultation_education': t.consultationEducation,
      'medical_treatment': t.medicalTreatment,
      'surgical_treatment': t.surgicalTreatment,
      'refused_treatment': t.refusedTreatment,
      'suspected_infectious_disease': t.suspectedInfectiousDisease,
    };

    final specialNoteOptions = {
      'ohca_cpr_before_ems': t.ohcaCprBeforeEms,
      'ohca_aed_no_shock': t.ohcaAedNoShock,
      'ohca_aed_with_shock': t.ohcaAedWithShock,
      'resumed_breathing': t.resumedBreathing,
      'mechanical_cpr_used': t.mechanicalCprUsed,
      'blank': t.blank,
    };

    final followUpResultOptions = {
      'continue_flight': t.continueFlight,
      'rest_observe_go_home': t.restObserveGoHome,
      'transfer_landseed': t.transferLandseed,
      'transfer_linkou': t.transferLinkou,
      'transfer_other_hospital': t.transferOtherHospital,
      'recommend_outpatient': t.recommendOutpatient,
      'deceased': t.deceased,
      'refused_referral': t.refusedReferral,
    };

    final traumaSymptomOptions = {
      'blunt_trauma': '鈍挫傷',
      'sprain': '扭傷',
      'laceration': '撕裂傷',
      'abrasion': '擦傷',
      'deformity': '肢體變形',
      'other': t.other,
    };

    final nonTraumaSymptomOptions = {
      'head_neck': t.headAndNeck,
      'chest': t.chest,
      'abdomen': '腹部',
      'limbs': t.limbs,
      'other': t.other,
    };

    final nonTraumaHeadSymptomOptions = {
      'headache': '頭痛',
      'dizziness': '頭暈目眩',
      'consciousness_change': '意識改變',
      'seizure': '癲癇',
      'sore_throat': '喉嚨痛',
      'nasal_congestion': '鼻塞鼻水',
      'ent_symptom': '五官症狀',
    };

    final nonTraumaChestSymptomOptions = {
      'cough': '咳嗽',
      'dyspnea': '呼吸困難',
      'chest_pain': '胸悶胸痛',
      'palpitation': '心悸',
    };

    final nonTraumaAbdomenSymptomOptions = {
      'abdominal_pain': '腹脹腹痛',
      'nausea_vomiting': '噁心嘔吐',
      'diarrhea': '腹瀉',
    };

    final nonTraumaLimbsSymptomOptions = {
      'pain': '疼痛',
      'numbness_weakness': '麻木無力',
    };

    final nonTraumaOtherSymptomOptions = {
      'fever': '發燒',
      'fatigue': '倦怠無力',
      'dysuria': '頻尿、解尿疼痛',
      'syncope': '暈厥',
      'allergy': '過敏',
      'psychiatric': '精神異常',
      'other': t.other,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======= 上方左右分欄區塊 =======
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左側欄位
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(t.cdcScreening),
                  InkWell(
                    onTap: () => setState(() {
                      planData.screeningChecked = !planData.screeningChecked;
                    }),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: planData.screeningChecked,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) => setState(() {
                            planData.screeningChecked = v ?? false;
                          }),
                        ),
                        const Text(''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (planData.screeningChecked) ...[
                    const SizedBox(height: 16),
                    _SectionTitle(t.screeningMethod),
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: screeningMethodOptions.entries
                          .map(
                            (entry) => InkWell(
                              onTap: () => setState(() {
                                if (planData.screeningMethods.contains(
                                  entry.key,
                                )) {
                                  planData.screeningMethods.remove(entry.key);
                                } else {
                                  planData.screeningMethods.add(entry.key);
                                }
                              }),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: planData.screeningMethods.contains(
                                      entry.key,
                                    ),
                                    activeColor: const Color(0xFF83ACA9),
                                    onChanged: (v) => setState(() {
                                      if (v ?? false) {
                                        planData.screeningMethods.add(
                                          entry.key,
                                        );
                                      } else {
                                        planData.screeningMethods.remove(
                                          entry.key,
                                        );
                                      }
                                    }),
                                  ),
                                  Text(
                                    entry.value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    if (planData.screeningMethods.contains('other')) ...[
                      _SectionTitle(t.otherScreeningMethod),
                      TextField(
                        controller: _controllers['otherScreeningMethod'],
                        decoration: InputDecoration(
                          hintText: t.enterOtherScreeningMethod,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    _SectionTitle(t.healthAssessment),
                    _HealthDataTable(
                      healthData: planData.healthData,
                      onAdd: () =>
                          _addHealthDataDialog(planData, actionButtonStyle, t),
                      t: t,
                    ),
                    const SizedBox(height: 24),
                  ],

                  _SectionTitle(t.chiefComplaint),
                  Row(
                    children: [
                      InkWell(
                        onTap: () =>
                            setState(() => planData.mainSymptom = 'trauma'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'trauma',
                              groupValue: planData.mainSymptom,
                              onChanged: (v) =>
                                  setState(() => planData.mainSymptom = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.trauma),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            setState(() => planData.mainSymptom = 'non_trauma'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'non_trauma',
                              groupValue: planData.mainSymptom,
                              onChanged: (v) =>
                                  setState(() => planData.mainSymptom = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.nonTrauma),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (planData.mainSymptom == 'trauma') ...[
                    _SectionTitle('外傷'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: traumaSymptomOptions.entries
                          .map(
                            (entry) => _CheckBoxItem(
                              label: entry.value,
                              value: planData.traumaSymptoms.contains(
                                entry.key,
                              ),
                              onChanged: (v) {
                                setState(() {
                                  if (v ?? false) {
                                    planData.traumaSymptoms.add(entry.key);
                                  } else {
                                    planData.traumaSymptoms.remove(entry.key);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (planData.mainSymptom == 'non_trauma') ...[
                    _SectionTitle('非外傷'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: nonTraumaSymptomOptions.entries
                          .map(
                            (entry) => _CheckBoxItem(
                              label: entry.value,
                              value: planData.nonTraumaSymptoms.contains(
                                entry.key,
                              ),
                              onChanged: (v) {
                                setState(() {
                                  if (v ?? false) {
                                    planData.nonTraumaSymptoms.add(entry.key);
                                  } else {
                                    planData.nonTraumaSymptoms.remove(
                                      entry.key,
                                    );
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    if (planData.nonTraumaSymptoms.contains('head_neck')) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('頭頸部'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: nonTraumaHeadSymptomOptions.entries
                                .map(
                                  (entry) => _CheckBoxItem(
                                    label: entry.value,
                                    value: planData.nonTraumaHeadSymptoms
                                        .contains(entry.key),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v ?? false) {
                                          planData.nonTraumaHeadSymptoms.add(
                                            entry.key,
                                          );
                                        } else {
                                          planData.nonTraumaHeadSymptoms.remove(
                                            entry.key,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (planData.nonTraumaSymptoms.contains('chest')) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('胸部'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: nonTraumaChestSymptomOptions.entries
                                .map(
                                  (entry) => _CheckBoxItem(
                                    label: entry.value,
                                    value: planData.nonTraumaChestSymptoms
                                        .contains(entry.key),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v ?? false) {
                                          planData.nonTraumaChestSymptoms.add(
                                            entry.key,
                                          );
                                        } else {
                                          planData.nonTraumaChestSymptoms
                                              .remove(entry.key);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (planData.nonTraumaSymptoms.contains('abdomen')) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('腹部'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: nonTraumaAbdomenSymptomOptions.entries
                                .map(
                                  (entry) => _CheckBoxItem(
                                    label: entry.value,
                                    value: planData.nonTraumaAbdomenSymptoms
                                        .contains(entry.key),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v ?? false) {
                                          planData.nonTraumaAbdomenSymptoms.add(
                                            entry.key,
                                          );
                                        } else {
                                          planData.nonTraumaAbdomenSymptoms
                                              .remove(entry.key);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (planData.nonTraumaSymptoms.contains('limbs')) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('四肢'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: nonTraumaLimbsSymptomOptions.entries
                                .map(
                                  (entry) => _CheckBoxItem(
                                    label: entry.value,
                                    value: planData.nonTraumaLimbsSymptoms
                                        .contains(entry.key),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v ?? false) {
                                          planData.nonTraumaLimbsSymptoms.add(
                                            entry.key,
                                          );
                                        } else {
                                          planData.nonTraumaLimbsSymptoms
                                              .remove(entry.key);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (planData.nonTraumaSymptoms.contains('other')) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('其他'),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: nonTraumaOtherSymptomOptions.entries
                                .map(
                                  (entry) => _CheckBoxItem(
                                    label: entry.value,
                                    value: planData.nonTraumaOtherSymptoms
                                        .contains(entry.key),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v ?? false) {
                                          planData.nonTraumaOtherSymptoms.add(
                                            entry.key,
                                          );
                                        } else {
                                          planData.nonTraumaOtherSymptoms
                                              .remove(entry.key);
                                        }
                                      });
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
                  _SectionTitle(t.additionalNotes),
                  TextField(
                    controller: _controllers['symptomNote'],
                    decoration: InputDecoration(
                      hintText: t.enterComplaintNotes,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  _SectionTitle(t.photoType),
                  Wrap(
                    spacing: 16,
                    children: photoTypeOptions.entries
                        .map(
                          (entry) => _CheckBoxItem(
                            label: entry.value,
                            value: planData.photoTypes.contains(entry.key),
                            onChanged: (v) {
                              setState(() {
                                if (v ?? false) {
                                  planData.photoTypes.add(entry.key);
                                } else {
                                  planData.photoTypes.remove(entry.key);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),

                  // 恢復照片上傳UI
                  if (planData.photoTypes.contains('trauma')) ...[
                    _SectionTitle(t.traumaPhotos),
                    _PhotoGrid(title: t.traumaPhotos),
                    const SizedBox(height: 16),
                  ],
                  if (planData.photoTypes.contains('ekg')) ...[
                    _SectionTitle(t.ekgPhotos),
                    _PhotoGrid(title: t.ekgPhotos),
                    const SizedBox(height: 16),
                  ],
                  if (planData.photoTypes.contains('other')) ...[
                    _SectionTitle(t.otherPhotos),
                    _PhotoGrid(title: t.otherPhotos),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 32),
                  _SectionTitle(t.physicalExam),
                  const SizedBox(height: 8),
                  _BodyCheckInput(
                    t.headAndNeck,
                    _controllers['bodyCheckHead']!,
                  ),
                  const SizedBox(height: 8),
                  _BodyCheckInput(t.chest, _controllers['bodyCheckChest']!),
                  const SizedBox(height: 8),
                  _BodyCheckInput('腹部', _controllers['bodyCheckAbdomen']!),
                  const SizedBox(height: 8),
                  _BodyCheckInput(t.limbs, _controllers['bodyCheckLimbs']!),
                  const SizedBox(height: 8),
                  _BodyCheckInput(t.other, _controllers['bodyCheckOther']!),
                ],
              ),
            ),
            const SizedBox(width: 48),

            // 右側欄位
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(t.voiceInput),
                  Text(
                    t.voiceInputHint,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: actionButtonStyle,
                    onPressed: () {},
                    child: Text(t.confirm),
                  ),
                  const SizedBox(height: 24),

                  _SectionTitle(t.temperatureLabel),
                  TextField(
                    controller: _controllers['temperature'],
                    decoration: InputDecoration(
                      hintText: t.enterValue,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle(t.pulseLabel),
                  TextField(
                    controller: _controllers['pulse'],
                    decoration: const InputDecoration(
                      hintText: '輸入整數',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle(t.respirationLabel),
                  TextField(
                    controller: _controllers['respiration'],
                    decoration: const InputDecoration(
                      hintText: '輸入整數',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle(t.bloodPressureLabel),
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('/'),
                      ),
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

                  _SectionTitle(t.spo2Label),
                  TextField(
                    controller: _controllers['spo2'],
                    decoration: InputDecoration(
                      hintText: t.enterValue,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _SectionTitle(t.consciousClear),
                      InkWell(
                        onTap: () => setState(() {
                          planData.consciousClear = !planData.consciousClear;
                        }),
                        child: Checkbox(
                          value: planData.consciousClear,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) => setState(() {
                            planData.consciousClear = v ?? false;
                          }),
                        ),
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
                    Row(
                      children: const [
                        Text(
                          'GCS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text('0'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _SectionTitle(t.leftPupilReaction),
                    _PupilScaleSelector(
                      groupValue: planData.leftPupilScale,
                      onChanged: (v) {
                        setState(() {
                          planData.leftPupilScale = v;
                        });
                      },
                    ),
                    const SizedBox(height: 8),

                    _SectionTitle(t.leftPupilSizeLabel),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _controllers['leftPupilSize'],
                        decoration: InputDecoration(
                          hintText: t.enterValue,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _SectionTitle(t.rightPupilReaction),
                    _PupilScaleSelector(
                      groupValue: planData.rightPupilScale,
                      onChanged: (v) {
                        setState(() {
                          planData.rightPupilScale = v;
                        });
                      },
                    ),
                    const SizedBox(height: 8),

                    _SectionTitle(t.rightPupilSizeLabel),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _controllers['rightPupilSize'],
                        decoration: InputDecoration(
                          hintText: t.enterValue,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  _SectionTitle(t.pastHistory),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => planData.history = 'none'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'none',
                              groupValue: planData.history,
                              onChanged: (v) =>
                                  setState(() => planData.history = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.none),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            setState(() => planData.history = 'unknown'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'unknown',
                              groupValue: planData.history,
                              onChanged: (v) =>
                                  setState(() => planData.history = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.unknown),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => planData.history = 'yes'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'yes',
                              groupValue: planData.history,
                              onChanged: (v) =>
                                  setState(() => planData.history = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.hasHistory),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SectionTitle(t.allergyHistory),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => planData.allergy = 'none'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'none',
                              groupValue: planData.allergy,
                              onChanged: (v) =>
                                  setState(() => planData.allergy = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.none),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            setState(() => planData.allergy = 'unknown'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'unknown',
                              groupValue: planData.allergy,
                              onChanged: (v) =>
                                  setState(() => planData.allergy = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.unknown),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => planData.allergy = 'food'),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'food',
                              groupValue: planData.allergy,
                              onChanged: (v) =>
                                  setState(() => planData.allergy = v),
                              activeColor: const Color(0xFF83ACA9),
                            ),
                            Text(t.food),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // ===== 初步診斷區塊 =====
        const SizedBox(height: 40),
        _SectionTitle(t.initialDiagnosis),
        TextField(
          controller: _controllers['initialDiagnosis'],
          decoration: InputDecoration(
            hintText: t.enterInitialDiagnosis,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),

        _SectionTitle(t.initialDiagnosisCategory),
        _buildDiagnosisCategory(planData, t),
        const SizedBox(height: 24),

        _SectionTitle(t.icd10InitialDiagnosis),
        _buildICD10Selector(
          t.mainDiagnosis,
          planData.selectedICD10Main,
          (v) {
            setState(() {
              planData.selectedICD10Main = v;
            });
          },
          actionButtonStyle,
          t,
        ),
        const SizedBox(height: 24),

        _buildICD10Selector(
          t.secondaryDiagnosis1,
          planData.selectedICD10Sub1,
          (v) {
            setState(() {
              planData.selectedICD10Sub1 = v;
            });
          },
          actionButtonStyle,
          t,
        ),
        const SizedBox(height: 32),

        _buildICD10Selector(
          t.secondaryDiagnosis2,
          planData.selectedICD10Sub2,
          (v) {
            setState(() {
              planData.selectedICD10Sub2 = v;
            });
          },
          actionButtonStyle,
          t,
        ),
        const SizedBox(height: 32),

        _SectionTitle(t.triageCategory),
        _buildTriage(planData, t),
        const SizedBox(height: 16),

        _SectionTitle(t.onSiteTreatment),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: onSiteTreatmentOptions.entries
              .map(
                (entry) => _CheckBoxItem(
                  label: entry.value,
                  value: planData.onSiteTreatments.contains(entry.key),
                  onChanged: (v) {
                    setState(() {
                      if (v ?? false) {
                        planData.onSiteTreatments.add(entry.key);
                      } else {
                        planData.onSiteTreatments.remove(entry.key);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        _SectionTitle(t.treatmentSummary),
        _buildSummaryCheckboxes(planData, t),
        const SizedBox(height: 16),

        if (planData.ekgChecked) ...[
          _SectionTitle(t.ekgReading),
          TextField(
            controller: _controllers['ekgReading'],
            decoration: InputDecoration(
              hintText: t.enterEkgResult,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (planData.sugarChecked) ...[
          _SectionTitle(t.bloodSugarLabel),
          TextField(
            controller: _controllers['sugarReading'],
            decoration: InputDecoration(
              hintText: t.enterBloodSugar,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (planData.suggestReferral)
          _buildReferralSection(planData, actionButtonStyle, t),

        if (planData.intubationChecked) _buildIntubationSection(planData, t),

        if (planData.oxygenTherapyChecked) _buildOxygenSection(planData, t),

        if (planData.medicalCertificateChecked)
          _buildMedicalCertSection(planData, t),

        if (planData.prescriptionChecked) ...[
          _SectionTitle(t.medicationRecord),
          _PrescriptionTable(
            prescriptionRows: planData.prescriptionRows,
            onAdd: () =>
                _showPrescriptionDialog(planData, actionButtonStyle, t),
            t: t,
          ),
          const SizedBox(height: 16),
        ],

        if (planData.otherChecked) ...[
          _SectionTitle(t.otherTreatmentSummary),
          TextField(
            controller: _controllers['otherSummary'],
            decoration: InputDecoration(
              hintText: t.enterOtherTreatmentSummary,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        _SectionTitle(t.followUpResult),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: followUpResultOptions.entries
              .map(
                (entry) => _CheckBoxItem(
                  label: entry.value,
                  value: planData.followUpResults.contains(entry.key),
                  onChanged: (v) => setState(() {
                    if (v ?? false) {
                      planData.followUpResults.add(entry.key);
                    } else {
                      planData.followUpResults.remove(entry.key);
                    }
                  }),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),

        _SectionTitle(t.director),
        const SizedBox(height: 16),

        _SectionTitle(t.attendingPhysician, color: Colors.red),
        _buildStaffSelector(
          planData.selectedMainDoctor,
          t.tapToSelectPhysician,
          () => _showStaffDialog(planData, '醫師', t),
        ),
        const SizedBox(height: 16),

        _SectionTitle(t.attendingNurse, color: Colors.red),
        _buildStaffSelector(
          planData.selectedMainNurse,
          t.tapToSelectNurse,
          () => _showStaffDialog(planData, '護理師', t),
        ),
        const SizedBox(height: 16),

        _SectionTitle(t.nurseSignature),
        TextField(
          controller: _controllers['nurseSignature'],
          decoration: const InputDecoration(
            hintText: '',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24),

        _SectionTitle(t.emtName, color: Colors.black),
        _buildStaffSelector(
          planData.selectedEMT,
          t.tapToSelectEMT,
          () => _showStaffDialog(planData, 'EMT', t),
        ),
        const SizedBox(height: 16),

        _SectionTitle(t.emtSignature),
        TextField(
          controller: _controllers['emtSignature'],
          decoration: const InputDecoration(
            hintText: '',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24),

        _SectionTitle(t.assistantsName),
        TextField(
          controller: _controllers['helperNamesText'],
          decoration: InputDecoration(
            hintText: t.enterAssistantsName,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _HelperTable(
          selectedHelpers: planData.selectedHelpers,
          onAdd: () =>
              _showHelperSelectionDialog(planData, actionButtonStyle, t),
          t: t,
        ),
        const SizedBox(height: 24),

        _SectionTitle(t.specialNotes),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: specialNoteOptions.entries
              .map(
                (entry) => _CheckBoxItem(
                  label: entry.value,
                  value: planData.specialNotes.contains(entry.key),
                  onChanged: (v) => setState(() {
                    if (v ?? false) {
                      planData.specialNotes.add(entry.key);
                    } else {
                      planData.specialNotes.remove(entry.key);
                    }
                  }),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),

        _SectionTitle(t.otherSpecialNotes),
        TextField(
          controller: _controllers['otherSpecialNote'],
          decoration: InputDecoration(
            hintText: t.enterOtherSpecialNotes,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildStaffSelector(
    String? currentValue,
    String hint,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: currentValue ?? ''),
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildSummaryCheckboxes(PlanData planData, AppTranslations t) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        _CheckBoxItem(label: '冰敷', value: false, onChanged: (v) {}),
        _CheckBoxItem(label: '傷口處置', value: false, onChanged: (v) {}),
        _CheckBoxItem(label: '簽四聯單', value: false, onChanged: (v) {}),
        _CheckBoxItem(label: '抽痰', value: false, onChanged: (v) {}),
        _CheckBoxItem(
          label: t.ekgReading,
          value: planData.ekgChecked,
          onChanged: (v) => setState(() => planData.ekgChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.bloodSugarLabel,
          value: planData.sugarChecked,
          onChanged: (v) => setState(() => planData.sugarChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.recommendReferral,
          value: planData.suggestReferral,
          onChanged: (v) =>
              setState(() => planData.suggestReferral = v ?? false),
        ),
        _CheckBoxItem(
          label: "插管",
          value: planData.intubationChecked,
          onChanged: (v) =>
              setState(() => planData.intubationChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.cpr,
          value: planData.cprChecked,
          onChanged: (v) => setState(() => planData.cprChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.oxygenUse,
          value: planData.oxygenTherapyChecked,
          onChanged: (v) =>
              setState(() => planData.oxygenTherapyChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.medicalCertType,
          value: planData.medicalCertificateChecked,
          onChanged: (v) =>
              setState(() => planData.medicalCertificateChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.medication,
          value: planData.prescriptionChecked,
          onChanged: (v) =>
              setState(() => planData.prescriptionChecked = v ?? false),
        ),
        _CheckBoxItem(
          label: t.other,
          value: planData.otherChecked,
          onChanged: (v) => setState(() => planData.otherChecked = v ?? false),
        ),
      ],
    );
  }

  Widget _buildReferralSection(
    PlanData planData,
    ButtonStyle buttonStyle,
    AppTranslations t,
  ) {
    // 🔥 使用您指定的醫院列表
    final List<String> hospitals = [
      t.landseedHospital,
      t.linkouChangGung,
      t.taoyuanHospital,
      t.taoyuanPsychiatricCenter,
      t.taoyuanMinSheng,
      t.stPaulsHospital,
      t.tienShengHospital,
      t.taoyuanVeteransHospital,
      t.enChuKungHospital,
      t.other,
    ];

    // 🔥 創建對應的 key 值
    final List<String> hospitalKeys = [
      'landseed',
      'linkou_chang_gung',
      'taoyuan_general',
      'taoyuan_psychiatric',
      'minsheng',
      'st_pauls',
      'tien_sheng',
      'taoyuan_veterans',
      'en_chu_kung',
      'other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.passageMethod, color: Colors.black),
        Row(
          children: [
            InkWell(
              onTap: () =>
                  setState(() => planData.referralPassageType = 'general'),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'general',
                    groupValue: planData.referralPassageType,
                    onChanged: (v) =>
                        setState(() => planData.referralPassageType = v),
                    activeColor: const Color(0xFF274C4A),
                  ),
                  Text(t.generalPassage),
                ],
              ),
            ),
            InkWell(
              onTap: () =>
                  setState(() => planData.referralPassageType = 'emergency'),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'emergency',
                    groupValue: planData.referralPassageType,
                    onChanged: (v) =>
                        setState(() => planData.referralPassageType = v),
                    activeColor: const Color(0xFF274C4A),
                  ),
                  Text(t.emergencyPassage),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        _SectionTitle(t.ambulanceRecord, color: Colors.black),
        Row(
          children: [
            InkWell(
              onTap: () => setState(
                () => planData.referralAmbulanceType = 'medical_center',
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'medical_center',
                    groupValue: planData.referralAmbulanceType,
                    onChanged: (v) =>
                        setState(() => planData.referralAmbulanceType = v),
                    activeColor: const Color(0xFF274C4A),
                  ),
                  Text(t.medicalCenter),
                ],
              ),
            ),
            InkWell(
              onTap: () =>
                  setState(() => planData.referralAmbulanceType = 'private'),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'private',
                    groupValue: planData.referralAmbulanceType,
                    onChanged: (v) =>
                        setState(() => planData.referralAmbulanceType = v),
                    activeColor: const Color(0xFF274C4A),
                  ),
                  Text(t.privateAmbulance),
                ],
              ),
            ),
            InkWell(
              onTap: () =>
                  setState(() => planData.referralAmbulanceType = 'fire_dept'),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'fire_dept',
                    groupValue: planData.referralAmbulanceType,
                    onChanged: (v) =>
                        setState(() => planData.referralAmbulanceType = v),
                    activeColor: const Color(0xFF274C4A),
                  ),
                  Text(t.fireDeptAmbulance),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 🔥 一級選單：轉送醫院選擇
        _SectionTitle(t.transferHospital, color: Colors.black),
        _stringRadioWrap(
          options: hospitals,
          groupValue: planData.referralHospital,
          dbValues: hospitalKeys,
          onChanged: (value) {
            setState(() {
              planData.referralHospital = value;
              if (value != 'other') {
                planData.referralOtherHospital = '';
                _controllers['referralOtherHospital']?.text = '';
              }
            });
          },
        ),
        const SizedBox(height: 8),

        // 🔥 如果選擇"其他"，顯示輸入框
        if (planData.referralHospital == 'other') ...[
          _SectionTitle(t.otherTransferHospital, color: Colors.black),
          TextField(
            controller: _controllers['referralOtherHospital'],
            onChanged: (_) => _syncControllersToData(),
            decoration: InputDecoration(
              hintText: t.enterOtherTransferHospital,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
        ],

        _SectionTitle(t.escortPersonnel, color: Colors.black),
        TextField(
          controller: _controllers['referralEscortText'],
          onChanged: (_) => _syncControllersToData(),
          decoration: InputDecoration(
            hintText: t.enterEscortName,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        _EscortTable(
          selectedEscorts: planData.selectedEscorts,
          onAdd: () => _showEscortSelectionDialog(planData, buttonStyle, t),
          t: t,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOxygenSection(PlanData planData, AppTranslations t) {
    final oxygenOptions = {
      'nasal_cannula': t.nasalCannula,
      'mask': t.mask,
      'non_rebreather': t.nonRebreatherMask,
      'ambu_bag': t.ambuBag,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.oxygenUse),
        Row(
          children: oxygenOptions.entries
              .map(
                (entry) => InkWell(
                  onTap: () => setState(() => planData.oxygenType = entry.key),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: entry.key,
                        groupValue: planData.oxygenType,
                        onChanged: (v) =>
                            setState(() => planData.oxygenType = v),
                        activeColor: const Color(0xFF83ACA9),
                      ),
                      Text(entry.value),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        _SectionTitle(t.oxygenFlow),
        TextField(
          controller: _controllers['oxygenFlow'],
          decoration: InputDecoration(
            hintText: t.enterOxygenFlow,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIntubationSection(PlanData planData, AppTranslations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.intubationMethod),
        Row(
          children: [
            InkWell(
              onTap: () =>
                  setState(() => planData.intubationType = 'endotracheal'),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'endotracheal',
                    groupValue: planData.intubationType,
                    onChanged: (v) =>
                        setState(() => planData.intubationType = v),
                    activeColor: const Color(0xFF83ACA9),
                  ),
                  const Text('Endotracheal tube'),
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => planData.intubationType = 'lma'),
              child: Row(
                children: [
                  Radio<String>(
                    value: 'lma',
                    groupValue: planData.intubationType,
                    onChanged: (v) =>
                        setState(() => planData.intubationType = v),
                    activeColor: const Color(0xFF83ACA9),
                  ),
                  const Text('LMA'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMedicalCertSection(PlanData planData, AppTranslations t) {
    final certTypes = {
      'chinese_cert': '中文診斷書',
      'english_cert': '英文診斷書',
      'fit_to_fly': '中英文適航證明',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SectionTitle(t.medicalCertType),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: certTypes.entries
              .map(
                (entry) => _CheckBoxItem(
                  label: entry.value,
                  value: planData.medicalCertificateTypes.contains(entry.key),
                  onChanged: (v) => setState(() {
                    if (v ?? false) {
                      planData.medicalCertificateTypes.add(entry.key);
                    } else {
                      planData.medicalCertificateTypes.remove(entry.key);
                    }
                  }),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _stringRadioWrap({
    required List<String> options,
    required String? groupValue,
    required List<String> dbValues,
    required ValueChanged<String>? onChanged,
  }) {
    final isEnabled = onChanged != null;
    const Color _deepGreen = Color(0xFF274C4A);

    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: List.generate(options.length, (i) {
        if (i >= dbValues.length) return const SizedBox.shrink();

        final selected = groupValue == dbValues[i];
        return InkWell(
          onTap: isEnabled ? () => onChanged!(dbValues[i]) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected
                    ? _deepGreen
                    : (isEnabled ? Colors.black45 : Colors.grey.shade400),
              ),
              const SizedBox(width: 6),
              Text(
                options[i],
                style: TextStyle(
                  color: isEnabled ? Colors.black87 : Colors.black54,
                  fontSize: 15.5,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _addHealthDataDialog(
    PlanData planData,
    ButtonStyle buttonStyle,
    AppTranslations t,
  ) {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final tempController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(t.addHealthAssessment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: t.name),
            ),
            TextField(
              controller: relationController,
              decoration: InputDecoration(labelText: t.relation),
            ),
            TextField(
              controller: tempController,
              decoration: InputDecoration(labelText: t.temperatureLabel),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF83ACA9),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            style: buttonStyle,
            onPressed: () {
              setState(() {
                planData.healthData.add({
                  "name": nameController.text,
                  "relation": relationController.text,
                  "temp": tempController.text,
                });
              });
              Navigator.pop(context);
            },
            child: Text(t.save),
          ),
        ],
      ),
    );
  }

  Future<void> _showICD10Dialog(
    ValueChanged<String?> onSelected,
    AppTranslations t,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(t.selectIcd10),
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ListView(
              children: PlanData.icd10List
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

  Future<void> _showStaffDialog(
    PlanData planData,
    String role,
    AppTranslations t,
  ) async {
    final List<String> staffList;
    final String title;
    switch (role) {
      case '醫師':
        staffList = PlanData.visitingStaff;
        title = t.selectRole.replaceAll('%s', t.physician);
        break;
      case '護理師':
        staffList = PlanData.registeredNurses;
        title = t.selectRole.replaceAll('%s', t.nurse);
        break;
      case 'EMT':
        staffList = PlanData.emts;
        title = t.selectRole.replaceAll('%s', 'EMT');
        break;
      default:
        return;
    }
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
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
      setState(() {
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
      });
    }
  }

  Future<void> _showHelperSelectionDialog(
    PlanData planData,
    ButtonStyle buttonStyle,
    AppTranslations t,
  ) async {
    List<String> tempSelected = List.from(planData.selectedHelpers);
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(t.selectAssistants),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: PlanData.helperNames.map((name) {
                  return CheckboxListTile(
                    title: Text(name),
                    value: tempSelected.contains(name),
                    activeColor: const Color(0xFF274C4A),
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
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF83ACA9),
                ),
                child: Text(t.cancel),
                onPressed: () => Navigator.of(context).pop(null),
              ),
              ElevatedButton(
                style: buttonStyle,
                child: Text(t.confirm),
                onPressed: () {
                  Navigator.of(context).pop(tempSelected);
                },
              ),
            ],
          );
        },
      ),
    );
    if (result != null) {
      setState(() {
        planData.selectedHelpers = result;
      });
    }
  }

  Future<void> _showPrescriptionDialog(
    PlanData planData,
    ButtonStyle buttonStyle,
    AppTranslations t,
  ) async {
    Map<String, String>? result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String? selectedDrug,
            selectedUsage,
            selectedFreq,
            selectedDays,
            selectedDoseUnit;
        String note = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(t.addMedicationRecord),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.medicationName),
                    ...PlanData.drugCategories.entries
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
                                        selectedColor: const Color(0xFF274C4A),
                                        labelStyle: TextStyle(
                                          color: selectedDrug == drug
                                              ? Colors.white
                                              : Colors.black,
                                        ),
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
                      decoration: InputDecoration(labelText: t.usage),
                      items: PlanData.usageOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedUsage = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: t.frequency),
                      items: PlanData.freqOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedFreq = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: t.days),
                      items: PlanData.daysOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedDays = v,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: t.doseUnit),
                      items: PlanData.doseUnitOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => selectedDoseUnit = v,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(labelText: t.note),
                      onChanged: (v) => note = v,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.cancel),
                ),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => Navigator.pop(context, {
                    '藥品名稱': selectedDrug ?? '',
                    '使用方式': selectedUsage ?? '',
                    '服用頻率': selectedFreq ?? '',
                    '服用天數': selectedDays ?? '',
                    '劑量單位': selectedDoseUnit ?? '',
                    '備註': note,
                  }),
                  child: Text(t.save),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() {
        planData.prescriptionRows.add(result);
      });
    }
  }

  Widget _buildICD10Selector(
    String title,
    String? value,
    ValueChanged<String?> onSelected,
    ButtonStyle buttonStyle,
    AppTranslations t,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => _showICD10Dialog(onSelected, t),
              child: Text(t.icd10Search),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {},
              child: Text(t.googleSearch),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: TextEditingController(text: value ?? ''),
          decoration: InputDecoration(
            hintText: t.enterIcd10CodeFor.replaceAll('%s', title),
            border: const OutlineInputBorder(),
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildDiagnosisCategory(PlanData planData, AppTranslations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PlanData.diagnosisCategories
          .map(
            (category) => InkWell(
              onTap: () =>
                  setState(() => planData.diagnosisCategory = category),
              child: Row(
                children: [
                  Radio<String>(
                    value: category,
                    groupValue: planData.diagnosisCategory,
                    onChanged: (v) =>
                        setState(() => planData.diagnosisCategory = v),
                    activeColor: const Color(0xFF83ACA9),
                  ),
                  Flexible(
                    child: Text(
                      category.split('(').first.trim(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTriage(PlanData planData, AppTranslations t) {
    final triageOptions = {
      'level_1': t.triage1,
      'level_2': t.triage2,
      'level_3': t.triage3,
      'level_4': t.triage4,
      'level_5': t.triage5,
    };
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: triageOptions.entries
          .map(
            (entry) => InkWell(
              onTap: () => setState(() => planData.triageCategory = entry.key),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: entry.key,
                    groupValue: planData.triageCategory,
                    onChanged: (v) =>
                        setState(() => planData.triageCategory = v),
                    activeColor: const Color(0xFF83ACA9),
                  ),
                  Text(entry.value),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _showEscortSelectionDialog(
    PlanData planData,
    ButtonStyle buttonStyle,
    AppTranslations t,
  ) async {
    List<String> tempSelected = List.from(planData.selectedEscorts);
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(t.selectAssistants),
            content: SingleChildScrollView(
              child: ListBody(
                children: PlanData.escortOptions.map((name) {
                  return CheckboxListTile(
                    title: Text(name),
                    value: tempSelected.contains(name),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
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
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF83ACA9),
                ),
                child: Text(t.cancel),
                onPressed: () => Navigator.pop(context, null),
              ),
              ElevatedButton(
                style: buttonStyle,
                child: Text(t.confirm),
                onPressed: () {
                  Navigator.pop(context, tempSelected);
                },
              ),
            ],
          );
        },
      ),
    );

    if (result != null) {
      setState(() {
        planData.selectedEscorts = result;
      });
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color? color;
  const _SectionTitle(this.text, {this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
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
  Widget build(BuildContext context) => Row(
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
      SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '請輸入檢查資訊',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );
}

class _PupilScaleSelector extends StatelessWidget {
  final int? groupValue;
  final ValueChanged<int?> onChanged;
  const _PupilScaleSelector({
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onChanged(0),
          child: Row(
            children: [
              Radio<int>(
                value: 0,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFF83ACA9),
              ),
              const Text('+'),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged(1),
          child: Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFF83ACA9),
              ),
              const Text('-'),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged(2),
          child: Row(
            children: [
              Radio<int>(
                value: 2,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFF83ACA9),
              ),
              const Text('±'),
            ],
          ),
        ),
      ],
    );
  }
}

// 恢復照片上傳網格組件
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
  final AppTranslations t;
  const _HealthDataTable({
    required this.healthData,
    required this.onAdd,
    required this.t,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        color: const Color(0xFFF1F3F6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                t.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.relation,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.temperatureLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      ...healthData.map(
        (row) => Container(
          width: double.infinity,
          color: Colors.transparent,
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
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(t.addRow, style: const TextStyle(color: Colors.blue)),
        ),
      ),
    ],
  );
}

class _PrescriptionTable extends StatelessWidget {
  final List<Map<String, String>> prescriptionRows;
  final VoidCallback onAdd;
  final AppTranslations t;
  const _PrescriptionTable({
    required this.prescriptionRows,
    required this.onAdd,
    required this.t,
  });
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        color: const Color(0xFFF1F3F6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                t.medicationName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.usage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.frequency,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.days,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.doseUnit,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.note,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      ...prescriptionRows.map(
        (row) => Container(
          width: double.infinity,
          color: Colors.transparent,
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
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            t.addMedicationRecord,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ),
    ],
  );
}

class _HelperTable extends StatelessWidget {
  final List<String> selectedHelpers;
  final VoidCallback onAdd;
  final AppTranslations t;
  const _HelperTable({
    required this.selectedHelpers,
    required this.onAdd,
    required this.t,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: const Color(0xFFF1F3F6),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.assistantsName),
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
          Text(
            t.noAssistantsSelected,
            style: const TextStyle(color: Colors.grey),
          ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onAdd,
          child: Text(
            t.addAssistant,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}

class _EscortTable extends StatelessWidget {
  final List<String> selectedEscorts;
  final VoidCallback onAdd;
  final AppTranslations t;
  const _EscortTable({
    required this.selectedEscorts,
    required this.onAdd,
    required this.t,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: const Color(0xFFF1F3F6),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('隨車人員'),
        if (selectedEscorts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedEscorts
                  .map(
                    (escort) =>
                        Text(escort, style: const TextStyle(fontSize: 16)),
                  )
                  .toList(),
            ),
          )
        else
          const Text('尚未選擇隨車人員', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        InkWell(
          onTap: onAdd,
          child: Text(
            t.addParamedic,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}
