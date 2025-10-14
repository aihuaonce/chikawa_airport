// lib/l10n/app_translations.dart
import 'package:flutter/material.dart';

class AppTranslations {
  final Locale locale;

  AppTranslations(this.locale);

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  static const LocalizationsDelegate<AppTranslations> delegate =
      _AppTranslationsDelegate();

  bool get isZh => locale.languageCode == 'zh';

  // ========== 通用 ==========
  String get appTitle => isZh ? '醫院應用程式' : 'Hospital App';
  String get valueNotAvailable => isZh ? '—' : 'N/A';

  String get save => isZh ? '儲存' : 'Save';
  String get cancel => isZh ? '取消' : 'Cancel';
  String get confirm => isZh ? '確定' : 'OK / Confirm';
  String get yes => isZh ? '是' : 'Yes';
  String get no => isZh ? '否' : 'No';
  String get name => isZh ? '姓名' : 'Name';
  String get gender => isZh ? '性別' : 'Gender';
  String get male => isZh ? '男' : 'Male';
  String get female => isZh ? '女' : 'Female';
  String get date => isZh ? '日期' : 'Date';
  String get time => isZh ? '時間' : 'Time';
  String get selectDate => isZh ? '請選擇日期' : 'Select Date';
  String get selectTime => isZh ? '請選擇時間' : 'Select Time';
  String get updateTime => isZh ? '更新時間' : 'Update Time';
  String get note => isZh ? '備註' : 'Note / Remark';
  String get other => isZh ? '其他' : 'Other';
  String get search => isZh ? '搜尋' : 'Search';
  String get add => isZh ? '新增' : 'Add';
  String get edit => isZh ? '編輯' : 'Edit';
  String get delete => isZh ? '刪除' : 'Delete';
  String get close => isZh ? '關閉' : 'Close';
  String get nationality => isZh ? '國籍' : 'Nationality';
  String get phone => isZh ? '電話' : 'Phone Number';
  String get address => isZh ? '地址' : 'Address';
  String get signature => isZh ? '簽名' : 'Signature';

  // ========== 首頁 (home.dart) ==========
  String get addPatient => isZh ? '+新增病患資料' : '+ Add Patient';
  String get columnSettings => isZh ? '欄位設定' : 'Column Settings';
  String get searchPlaceholder =>
      isZh ? '搜尋姓名/國籍/科別...' : 'Search name/nationality/dept...';
  String get noPatientRecords =>
      isZh ? '目前沒有任何病患紀錄。' : 'No patient records found.';
  String get patientName => isZh ? '病患' : 'Patient';
  String get updateTimeShort => isZh ? '更新時間' : 'Update Time';
  String get department => isZh ? '科別' : 'Department';
  String get filledBy => isZh ? '填寫人' : 'Filled By';
  String get selectColumns =>
      isZh ? '選擇要顯示的欄位 (最多7個)' : 'Select columns to display (max 7)';
  String get selectedCount => isZh ? '已選擇' : 'Selected';
  String get defaultSeven => isZh ? '預設7個' : 'Default 7';
  String get clearAll => isZh ? '全部清除' : 'Clear All';

  // ========== 首頁2 (急救紀錄) ==========
  String get addEmergencyRecord =>
      isZh ? '新增急救紀錄(由病患建立)' : 'Add Emergency Record (From Patient)';
  String get emergencyRecordHint => isZh
      ? '請從首頁新增病患，系統會自動建立急救紀錄。'
      : 'Please add patient from home page, the system will create emergency record automatically.';
  String get searchEmergencyRecord =>
      isZh ? '搜尋急救紀錄...' : 'Search emergency records...';
  String get noEmergencyRecords =>
      isZh ? '目前沒有任何急救紀錄。' : 'No emergency records found.';
  String get incidentDate => isZh ? '事發日期' : 'Incident Date';
  String get emergencyResult => isZh ? '急救結果' : 'Emergency Result';

  // ========== 首頁3 (救護車紀錄) ==========
  String get addAmbulanceRecord =>
      isZh ? '新增紀錄(由病患建立)' : 'Add Record (From Patient)';
  String get ambulanceRecordHint => isZh
      ? '請在病患的「處置」頁面勾選「建議轉診」以自動建立紀錄。'
      : 'Please check "Recommend Referral" in patient\'s treatment page to create record automatically.';
  String get searchAmbulance =>
      isZh ? '搜尋姓名/主訴/送往地點...' : 'Search name/complaint/destination...';
  String get noAmbulanceRecords =>
      isZh ? '目前沒有任何救護車出勤紀錄。' : 'No ambulance records found.';
  String get dutyTime => isZh ? '出勤時間' : 'Duty Time';
  String get chiefComplaint => isZh ? '病患主訴' : 'Chief Complaint';
  String get destination => isZh ? '送往地點' : 'Destination';
  String get totalFee => isZh ? '總費用' : 'Total Fee';
  String get mainDoctor => isZh ? '主責醫師' : 'Main Doctor';
  String get isRejection => isZh ? '是否拒絕' : 'Rejection';

  // ========== Nav1 (導航列) ==========
  String get airportVisit => isZh ? '機場出診單' : 'Airport Visit';
  String get emergencyRecord => isZh ? '急救紀錄單' : 'Emergency Record';
  String get ambulanceRecord => isZh ? '救護車紀錄單' : 'Ambulance Record';
  String get viewReports => isZh ? '查看報表' : 'View Reports';
  String get maintenance => isZh ? '各式列表維護' : 'List Maintenance';

  // ========== Nav2 (病患導航) ==========
  String get saveAllPages => isZh ? '儲存所有頁面' : 'Save All Pages';
  String get saving => isZh ? '儲存中...' : 'Saving...';
  String get saveSuccess =>
      isZh ? '所有頁面資料已成功儲存' : 'All data saved successfully';

  // ========== Nav3 (病患姓名) ==========
  String get patientNamePlaceholder =>
      isZh ? '請輸入患者姓名（必填）' : 'Please enter patient name (required)';

  // ========== Nav4 & Nav5 (急救/救護車導航) ==========
  String get personalInfo => isZh ? '個人資料' : 'Personal Info';
  String get flightRecord => isZh ? '飛航紀錄' : 'Flight Record';
  String get accidentRecord => isZh ? '事故紀錄' : 'Accident Record';
  String get treatmentRecord => isZh ? '處置紀錄' : 'Treatment Record';
  String get emergencySaved =>
      isZh ? '急救紀錄已儲存成功!' : 'Emergency record saved successfully!';
  String get ambulanceSaved =>
      isZh ? '救護車記錄已儲存成功!' : 'Ambulance record saved successfully!';

  // ========== PersonalInformation ==========
  String get personalInformation => isZh ? '個人資料' : 'Personal Information';
  String get birthday => isZh ? '生日' : 'Birthday';
  String get notSelected => isZh ? '尚未選擇' : 'Not Selected';
  String get age => isZh ? '年齡' : 'Age';
  String get birthdayNotSelected => isZh ? '尚未選擇生日' : 'Birthday Not Selected';
  String get passportOrId => isZh ? '護照號或身份證字號' : 'Passport No. / ID Number';
  String get enterPassportOrId =>
      isZh ? '請輸入護照號或身份證字號' : 'Please enter passport number or ID number';
  String get purposeOfVisit => isZh ? '為何至機場？' : 'Purpose of Visit to Airport';
  String get airlineCrew => isZh ? '航空公司機組員' : 'Airline Crew Member';
  String get passenger => isZh ? '旅客/民眾' : 'Passenger / Visitor';
  String get airportStaff => isZh ? '機場內部員工' : 'Airport Staff';
  String get taiwanNationality =>
      isZh ? '台灣 (中華民國) TAIWAN' : 'Taiwan (Republic of China)';
  String get enterAddress => isZh ? '請輸入地址' : 'Please enter address';
  String get contactNumber => isZh ? '聯絡電話' : 'Contact Number';
  String get enterContactNumber =>
      isZh ? '請輸入聯絡電話' : 'Please enter contact number';

  String get photoSelectionFailed =>
      isZh ? '選擇照片失敗: ' : 'Photo selection failed: ';

  // Nationalities (除了台灣)
  String get nationalityUSA => isZh ? '美國 UNITED STATES' : 'United States';
  String get nationalityVietnam => isZh ? '越南 VIETNAM' : 'Vietnam';
  String get nationalityThailand => isZh ? '泰國 THAILAND' : 'Thailand';
  String get nationalityIndonesia => isZh ? '印尼 INDONESIA' : 'Indonesia';
  String get nationalityPhilippines => isZh ? '菲律賓 PHILIPPINES' : 'Philippines';
  String get nationalityHongKong => isZh ? '香港 HONG KONG' : 'Hong Kong';
  String get nationalityMacau => isZh ? '澳門 MACAU' : 'Macau';
  String get nationalityCanada => isZh ? '加拿大 CANADA' : 'Canada';
  String get nationalityChina => isZh ? '中國大陸 CHINA' : 'China';
  String get nationalityJapan => isZh ? '日本 JAPAN' : 'Japan';
  String get nationalityOther => isZh ? '其他國籍' : 'Other Nationality';

  // Age formatting
  String ageWithUnit(int age) => isZh ? '$age 歲' : '$age years old';

  // ========== Plan Page (處置紀錄頁面) ==========
  String get savePlanFailed =>
      isZh ? '儲存計畫與處置頁面失敗: ' : 'Failed to save Plan & Treatment page: ';
  String get referralAndAmbulanceRecordCreated => isZh
      ? '已自動建立轉診單與救護車紀錄！'
      : 'Referral form and ambulance record have been automatically created!';
  String get loadDataFailed => isZh ? '載入資料失敗: ' : 'Failed to load data: ';
  String get cdcScreening => isZh ? '疾病管制署篩檢' : 'CDC Screening';
  String get enableScreening => isZh ? '啟用篩檢' : 'Enable Screening';
  String get screeningMethod => isZh ? '篩檢方式' : 'Screening Method';
  String get otherScreeningMethod => isZh ? '其他篩檢方式' : 'Other Screening Method';
  String get enterOtherScreeningMethod =>
      isZh ? '請填寫其他篩檢方式' : 'Please enter other screening method';
  String get healthAssessment => isZh ? '健康評估' : 'Health Assessment';
  String get additionalNotes => isZh ? '補充說明' : 'Additional Notes';
  String get enterComplaintNotes =>
      isZh ? '填寫主訴補充說明' : 'Enter additional notes for chief complaint';
  String get photoType => isZh ? '照片類型' : 'Photo Type';
  String get traumaPhotos => isZh ? '外傷照片' : 'Trauma Photos';
  String get ekgPhotos => isZh ? '心電圖照片' : 'EKG Photos';
  String get otherPhotos => isZh ? '其他照片' : 'Other Photos';
  String get physicalExam => isZh ? '身體檢查' : 'Physical Examination';
  String get headAndNeck => isZh ? '頭頸部' : 'Head & Neck';
  String get chest => isZh ? '胸部' : 'Chest';
  String get limbs => isZh ? '四肢' : 'Limbs';
  String get enterExamInfo =>
      isZh ? '請輸入檢查資訊' : 'Please enter examination info';
  String get voiceInput => isZh ? '語音輸入：' : 'Voice Input:';
  String get voiceInputHint => isZh
      ? '這裡依序輸入體溫、脈搏、呼吸、血壓、血氧、血糖'
      : 'Enter temp, pulse, respiration, BP, SpO2, blood sugar in order';
  String get temperatureLabel => isZh ? '體溫(°C)' : 'Temperature (°C)';
  String get pulseLabel => isZh ? '脈搏(次/min)' : 'Pulse (bpm)';
  String get respirationLabel => isZh ? '呼吸(次/min)' : 'Respiration (rpm)';
  String get bloodPressureLabel => isZh ? '血壓(mmHg)' : 'Blood Pressure (mmHg)';
  String get spo2Label => isZh ? '血氧(%)' : 'SpO2 (%)';
  String get consciousClear => isZh ? '意識清晰' : 'Conscious Clear';
  String get gcsScore => isZh ? 'GCS' : 'GCS';
  String get leftPupilReaction => isZh ? '左瞳孔縮放' : 'Left Pupil Reaction';
  String get leftPupilSizeLabel => isZh ? '左瞳孔大小 (mm)' : 'Left Pupil Size (mm)';
  String get rightPupilReaction => isZh ? '右瞳孔縮放' : 'Right Pupil Reaction';
  String get rightPupilSizeLabel =>
      isZh ? '右瞳孔大小 (mm)' : 'Right Pupil Size (mm)';
  String get pastHistory => isZh ? '過去病史' : 'Past History';
  String get hasHistory => isZh ? '有' : 'Yes';
  String get initialDiagnosis => isZh ? '初步診斷' : 'Initial Diagnosis';
  String get enterInitialDiagnosis =>
      isZh ? '請填寫初步診斷' : 'Please enter initial diagnosis';
  String get initialDiagnosisCategory =>
      isZh ? '初步診斷類別' : 'Initial Diagnosis Category';
  String get icd10InitialDiagnosis =>
      isZh ? '初步診斷的ICD-10' : 'ICD-10 for Initial Diagnosis';
  String get mainDiagnosis => isZh ? '主診斷' : 'Main Diagnosis';
  String get secondaryDiagnosis1 => isZh ? '副診斷1' : 'Secondary Diagnosis 1';
  String get secondaryDiagnosis2 => isZh ? '副診斷2' : 'Secondary Diagnosis 2';
  String get icd10Search => isZh ? 'ICD10CM搜尋' : 'Search ICD-10-CM';
  String get googleSearch => isZh ? 'GOOGLE搜尋' : 'Search Google';
  String get enterIcd10CodeFor =>
      isZh ? '請填寫 %s 的ICD-10代碼' : 'Please enter ICD-10 code for %s';
  String get triageCategory => isZh ? '檢傷分類' : 'Triage Category';
  String get onSiteTreatment => isZh ? '現場處置' : 'On-site Treatment';
  String get treatmentSummary => isZh ? '處理摘要' : 'Treatment Summary';
  String get ekgReading => isZh ? '心電圖判讀' : 'EKG Reading';
  String get enterEkgResult => isZh ? '請填寫判讀結果' : 'Please enter EKG result';
  String get bloodSugarLabel => isZh ? '血糖(mg/dL)' : 'Blood Sugar (mg/dL)';
  String get enterBloodSugar =>
      isZh ? '請填寫血糖記錄' : 'Please enter blood sugar record';
  String get passageMethod => isZh ? '通關方式' : 'Passage Method';
  String get generalPassage => isZh ? '一般通關' : 'General Passage';
  String get emergencyPassage => isZh ? '緊急通關' : 'Emergency Passage';
  String get medicalCenter => isZh ? '醫療中心' : 'Medical Center';
  String get privateAmbulance => isZh ? '民間' : 'Private';
  String get fireDeptAmbulance => isZh ? '消防隊' : 'Fire Department';
  String get transferHospital => isZh ? '轉送醫院' : 'Transfer Hospital';
  String get otherTransferHospital =>
      isZh ? '其他轉送醫院?' : 'Other transfer hospital?';
  String get enterOtherTransferHospital =>
      isZh ? '請填寫其他轉送醫院' : 'Please enter other transfer hospital';
  String get escortPersonnel => isZh ? '隨車人員' : 'Escort Personnel';
  String get enterEscortName =>
      isZh ? '請填寫隨車人員的姓名' : 'Please enter escort\'s name';
  String get generateAmbulanceRecord =>
      isZh ? '產生救護車紀錄單' : 'Generate Ambulance Record';
  String get oxygenUse => isZh ? '氧氣使用' : 'Oxygen Use';
  String get ambuBag => isZh ? 'Ambu' : 'Ambu Bag';
  String get oxygenFlow => isZh ? '氧氣流量(L/MIN)' : 'Oxygen Flow (L/MIN)';
  String get enterOxygenFlow => isZh ? '請填寫氧氣流量' : 'Please enter oxygen flow';
  String get medicalCertType => isZh ? '診斷書種類' : 'Type of Medical Certificate';
  String get medicationRecord => isZh ? '藥物記錄表' : 'Medication Record';
  String get otherTreatmentSummary =>
      isZh ? '其他處理摘要' : 'Other Treatment Summary';
  String get enterOtherTreatmentSummary =>
      isZh ? '請填寫其他處理摘要' : 'Please enter other treatment summary';
  String get followUpResult => isZh ? '後續結果' : 'Follow-up Result';
  String get director => isZh ? '院長' : 'Director';
  String get attendingPhysician => isZh ? '主責醫師' : 'Attending Physician';
  String get tapToSelectPhysician =>
      isZh ? '點擊選擇醫師的姓名（必填）' : 'Tap to select physician\'s name (required)';
  String get attendingNurse => isZh ? '主責護理師' : 'Attending Nurse';
  String get tapToSelectNurse =>
      isZh ? '點擊選擇護理師的姓名（必填）' : 'Tap to select nurse\'s name (required)';
  String get emtName => isZh ? 'EMT姓名' : 'EMT Name';
  String get tapToSelectEMT =>
      isZh ? '點擊選擇EMT的姓名' : 'Tap to select EMT\'s name';
  String get assistantsName => isZh ? '協助人員姓名' : 'Assistant(s) Name';
  String get enterAssistantsName =>
      isZh ? '請填寫協助人員的姓名' : 'Please enter assistant(s) name';
  String get addAssistant => isZh ? '加入協助人員' : 'Add Assistant(s)';
  String get specialNotes => isZh ? '特別註記' : 'Special Notes';
  String get otherSpecialNotes => isZh ? '其他特別註記' : 'Other Special Notes';
  String get enterOtherSpecialNotes =>
      isZh ? '請輸入其他特別註記' : 'Please enter other special notes';
  String get addHealthAssessment => isZh ? '新增健康評估' : 'Add Health Assessment';
  String get relation => isZh ? '關係' : 'Relation';
  String get selectIcd10 => isZh ? '選擇ICD-10' : 'Select ICD-10';
  String get selectRole => isZh ? '選擇%s' : 'Select %s'; // Placeholder for role
  String get physician => isZh ? '醫師' : 'Physician';
  String get nurse => isZh ? '護理師' : 'Nurse';
  String get selectAssistants => isZh ? '選擇協助人員姓名' : 'Select Assistant(s) Name';
  String get addMedicationRecord => isZh ? '新增藥物記錄' : 'Add Medication Record';
  String get medicationName => isZh ? '藥品名稱' : 'Medication Name';
  String get oralMedication => isZh ? '口服藥' : 'Oral Medication';
  String get injection => isZh ? '注射劑' : 'Injection';
  String get ivDrip => isZh ? '點滴注射' : 'IV Drip';
  String get usage => isZh ? '使用方式' : 'Usage';
  String get frequency => isZh ? '服用頻率' : 'Frequency';
  String get days => isZh ? '服用天數' : 'Days';
  String get doseUnit => isZh ? '劑量單位' : 'Dose Unit';

  // Triage Categories
  String get triage1 => isZh ? '第一級：復甦急救' : 'Level 1: Resuscitation';
  String get triage2 => isZh ? '第二級：危急' : 'Level 2: Emergent';
  String get triage3 => isZh ? '第三級：緊急' : 'Level 3: Urgent';
  String get triage4 => isZh ? '第四級：次緊急' : 'Level 4: Less Urgent';
  String get triage5 => isZh ? '第五級：非緊急' : 'Level 5: Non-urgent';

  // On-site Treatment options
  String get consultationEducation =>
      isZh ? '諮詢衛教' : 'Consultation & Education';
  String get medicalTreatment => isZh ? '內科處置' : 'Medical Treatment';
  String get surgicalTreatment => isZh ? '外科處置' : 'Surgical Treatment';
  String get refusedTreatment => isZh ? '拒絕處置' : 'Refused Treatment';
  String get suspectedInfectiousDisease =>
      isZh ? '疑似傳染病診療' : 'Suspected Infectious Disease';

  // Follow-up results
  String get continueFlight => isZh ? '繼續搭機旅行' : 'Continue Flight';
  String get restObserveGoHome =>
      isZh ? '休息觀察或自行回家' : 'Rest, Observe, or Go Home';
  String get transferLandseed =>
      isZh ? '轉聯新國際醫院' : 'Transfer to Landseed Hospital';
  String get transferLinkou =>
      isZh ? '轉林口長庚醫院' : 'Transfer to Linkou Chang Gung';
  String get transferOtherHospital =>
      isZh ? '轉其他醫院' : 'Transfer to Other Hospital';
  String get recommendOutpatient =>
      isZh ? '建議轉診門診追蹤' : 'Recommend Outpatient Follow-up';
  String get deceased => isZh ? '死亡' : 'Deceased';
  String get refusedReferral => isZh ? '拒絕轉診' : 'Refused Referral';

  // Special Notes
  String get ohcaCprBeforeEms =>
      isZh ? 'OHCA醫護團隊到場前有CPR' : 'OHCA: CPR before EMS arrival';
  String get ohcaAedNoShock =>
      isZh ? 'OHCA醫護團隊到場前有使用AED但無電擊' : 'OHCA: AED used before EMS, no shock';
  String get ohcaAedWithShock => isZh
      ? 'OHCA醫護團隊到場前有使用AED有電擊'
      : 'OHCA: AED used before EMS, shock delivered';
  String get resumedBreathing => isZh ? '現場恢復呼吸' : 'Resumed breathing on-site';
  String get mechanicalCprUsed =>
      isZh ? '使用自動心律復甦機' : 'Mechanical CPR device used';
  String get blank => isZh ? '空白' : 'Blank';

  // ========== Emergency Personal ==========
  String get idNumber => isZh ? '身分證字號' : 'National ID Number';
  String get enterIdNumber =>
      isZh ? '請輸入身分證字號' : 'Please enter the National ID number';
  String get birthDate => isZh ? '出生日期' : 'Date of Birth';
  String get today => isZh ? '今天' : 'Today';
  String get passportNumber => isZh ? '護照號碼' : 'Passport Number';
  String get enterPassportNumber =>
      isZh ? '請輸入護照號碼' : 'Please enter the passport number';

  // ========== Ambulance Plan ==========
  String get emergencyTreatment => isZh ? '急救處置:' : 'Emergency Treatments';
  String get airwayTreatment => isZh ? '呼吸道處置' : 'Airway Management';
  String get traumaTreatment => isZh ? '創傷處置' : 'Trauma Care';
  String get transport => isZh ? '搬運' : 'Transport';
  String get cpr => isZh ? '心肺復甦術' : 'Cardiopulmonary Resuscitation (CPR)';
  String get medicationProcedure => isZh ? '藥物處置' : 'Medication Administration';
  String get otherProcedure => isZh ? '其他處置' : 'Other Interventions';

  // 呼吸道處置選項
  String get oralAirway => isZh ? '口咽呼吸道' : 'Oropharyngeal Airway (OPA)';
  String get nasalAirway => isZh ? '鼻咽呼吸道' : 'Nasopharyngeal Airway (NPA)';
  String get suction => isZh ? '抽吸' : 'Suction';
  String get heimlichManeuver => isZh ? '哈姆立克法' : 'Heimlich Maneuver';
  String get nasalCannula => isZh ? '鼻管' : 'Nasal Cannula';
  String get mask => isZh ? '面罩' : 'Face Mask';
  String get nonRebreatherMask =>
      isZh ? '非再呼吸型面罩' : 'Non-Rebreather Mask (NRM)';
  String get bvm =>
      isZh ? 'BVM(正壓輔助呼吸)' : 'BVM (Positive Pressure Ventilation)';
  String get lma => isZh ? 'LMA' : 'Laryngeal Mask Airway (LMA)';
  String get igel => isZh ? 'Igel' : 'i-gel Supraglottic Airway';
  String get endotrachealTube => isZh ? '氣管內管' : 'Endotracheal Tube (ETT)';

  // 創傷處置選項
  String get cervicalCollar => isZh ? '頸圈' : 'Cervical Collar';
  String get woundCleaning => isZh ? '清洗傷口' : 'Wound Cleansing';
  String get hemostasisBandaging => isZh ? '止血、包紮' : 'Hemostasis / Bandaging';
  String get fractureFixation => isZh ? '骨折固定' : 'Fracture Immobilization';
  String get longBackboard => isZh ? '長背板固定' : 'Long Backboard Immobilization';
  String get scoopStretcher =>
      isZh ? '鏟式擔架固定' : 'Scoop Stretcher Immobilization';

  // 搬運方式
  String get walkToVehicle => isZh ? '自行上車' : 'Self-Boarding';
  String get appropriateTransport =>
      isZh ? '以適當方式搬運' : 'Transported by Appropriate Method';

  // CPR方式
  String get autoCpr => isZh ? '自動心肺復甦機' : 'Mechanical CPR Device';
  String get manualCpr => isZh ? 'CPR' : 'CPR';
  String get aed => isZh ? '使用AED' : 'Use AED';
  String get manualDefibrillator => isZh ? '手動電擊器' : 'Manual Defibrillation';

  // 藥物處置
  String get ivFluid => isZh ? '靜脈輸液' : 'Intravenous Infusion';
  String get oralGlucose => isZh ? '口服葡萄糖液/粉' : 'Oral Glucose Solution/Powder';
  String get assistAspirin => isZh ? '協助使用Aspirin' : 'Assist with Aspirin';
  String get assistNtg => isZh ? '協助使用NTG' : 'Assist with NTG (Nitroglycerin)';
  String get assistBronchodilator =>
      isZh ? '協助使用支氣管擴張劑' : 'Assist with Bronchodilator';

  // 其他急救處置
  String get warmth => isZh ? '保暖' : 'Warming';
  String get psychologicalSupport => isZh ? '心理支持' : 'Psychological Support';
  String get restraints => isZh ? '約束帶' : 'Restraint';
  String get refuseOxygen => isZh ? '拒絕使用氧氣' : 'Refuses Oxygen';
  String get vitalSignsMonitoring => isZh ? '生命徵象監測' : 'Vital Signs Monitoring';

  // 人形圖
  String get bodyDiagram => isZh ? '人形圖' : 'Body Diagram';
  String get editBodyDiagram => isZh ? '開啟人形圖編輯功能' : 'Open body diagram editor';
  String get clickToEditDiagram =>
      isZh ? '點擊按鈕開始編輯人形圖' : 'Tap to start editing the body diagram';
  String get bodyDiagramNote => isZh ? '人形圖備註:' : 'Body Diagram Notes:';
  String get enterNote => isZh ? '請填寫備註內容' : 'Please enter notes';

  // ASL處理
  String get aslTreatment => isZh ? 'ASL處理:' : 'ALS Treatment:';
  String get ettNumber => isZh ? '氣管內管號碼:' : 'Endotracheal Tube Size:';
  String get enterEttNumber => isZh ? '請填寫號碼' : 'Please enter the ETT size';
  String get ettDepth => isZh ? '固定公分數(cm):' : 'ETT Secured at (cm):';
  String get enterEttDepth =>
      isZh ? '請填寫公分數' : 'Please enter the secured depth (cm)';
  String get manualDefibCount => isZh ? '手動電擊次數:' : 'Number of Shocks:';
  String get enterDefibCount =>
      isZh ? '請填寫次數' : 'Please enter the number of shocks';
  String get manualDefibJoules => isZh ? '手動電擊焦耳數:' : 'Shock Energy (Joules):';
  String get enterDefibJoules =>
      isZh ? '請填寫焦耳數' : 'Please enter the shock energy (J)';

  // 線上指導醫師
  String get onlineMedicalDirection =>
      isZh ? '線上指導醫師指導說明:' : 'Online Medical Direction Notes:';
  String get enterInstructions =>
      isZh ? '請填寫指導說明' : 'Please enter the instruction notes';

  // 接收單位
  String get receivingUnit => isZh ? '接收單位:' : 'Receiving Unit:';
  String get enterReceivingUnit =>
      isZh ? '請填寫接收單位' : 'Please enter the receiving unit';
  String get receivingTime => isZh ? '接收時間:' : 'Receiving Time:';

  // 拒絕送醫
  String get refuseTransport =>
      isZh ? '是否拒絕送醫:' : 'Refuse Transport to Hospital:';
  String get refusalStatement =>
      isZh ? '拒絕醫療聲明：' : 'Refusal of Medical Care Statement:';
  String get refusalText => isZh
      ? '本人聲明，救護人員以解釋病情與送醫之需要，但我拒絕救護與送醫。'
      : 'I hereby declare that EMS personnel have explained my condition and the need for transport to hospital, but I refuse emergency care and transport.';
  String get enterName => isZh ? '請填寫姓名' : 'Please enter the name';

  // 關係人
  String get relationship => isZh ? '關係人身分:' : 'Relationship to Patient:';
  String get patient => isZh ? '病患' : 'Patient';
  String get familyMember => isZh ? '家屬' : 'Family Member';
  String get representative => isZh ? '關係人' : 'Representative';
  String get representativeName => isZh ? '關係人姓名:' : 'Representative\'s Name:';
  String get enterRepresentativeName =>
      isZh ? '請填寫關係人的姓名' : 'Please enter the representative\'s name';
  String get representativePhone =>
      isZh ? '關係人連絡電話:' : 'Representative\'s Contact Phone Number:';
  String get enterRepresentativePhone => isZh
      ? '請填寫關係人的連絡電話'
      : 'Please enter the representative\'s contact phone number';

  // 醫院列表
  String get landseedHospital =>
      isZh ? '聯新國際醫院' : 'Landseed International Hospital';
  String get linkouChangGung =>
      isZh ? '林口長庚醫院' : 'Linkou Chang Gung Memorial Hospital';
  String get taoyuanHospital => isZh
      ? '衛生福利部桃園醫院'
      : 'Taoyuan General Hospital, Ministry of Health and Welfare';

  // ========== 航廈位置 ==========
  String get terminal1 => isZh ? '第一航廈' : 'Terminal 1';
  String get terminal2 => isZh ? '第二航廈' : 'Terminal 2';
  String get remoteApron => isZh ? '遠端機坪' : 'Remote Apron';
  String get cargoOther =>
      isZh ? '貨運站/機坪其他' : 'Cargo Terminal / Other Apron Areas';
  String get novotelHotel => isZh ? '諾富特飯店' : 'Novotel Hotel';
  String get insideAircraft => isZh ? '飛機機艙內' : 'Inside Aircraft Cabin';

  String get departureCounter =>
      isZh ? '出境查驗台' : 'Departure Immigration Counter';
  String get arrivalCounter => isZh ? '入境查驗台' : 'Arrival Immigration Counter';
  String get vipLounge => isZh ? '貴賓室' : 'VIP Lounge';
  String get departureHallPublic =>
      isZh ? '出境大廳(管制區外)' : 'Departure Hall (Landside)';
  String get departureLevelRestricted =>
      isZh ? '出境層(管制區內)' : 'Departure Level (Airside)';
  String get arrivalHallPublic =>
      isZh ? '入境大廳(管制區外)' : 'Arrival Hall (Landside)';
  String get arrivalLevelRestricted =>
      isZh ? '入境層(管制區內)' : 'Arrival Level (Airside)';
  String get foodCourt => isZh ? '美食街' : 'Food Court';
  String get aviationPolice => isZh ? '航警局' : 'Aviation Police Bureau';
  String get airportMRT => isZh ? '機場捷運' : 'Airport MRT';
  String get carPark1 => isZh ? '1號停車場' : 'Car Park 1';
  String get carPark2 => isZh ? '2號停車場' : 'Car Park 2';

  String gateLabel(String gate) => isZh ? '登機門$gate' : 'Gate $gate';
  String get otherLocation => isZh ? '其他位置' : 'Other Location';
  String get locationNotes => isZh ? '地點備註' : 'Location Notes';
  String get enterLocationNotes =>
      isZh ? '請填寫地點備註' : 'Please enter location notes';

  // ========== AccidentRecord 額外翻譯 ==========
  String get reportUnit => isZh ? '通報單位' : 'Report Unit';
  String get otherReportUnit => isZh ? '其他通報單位' : 'Other Report Unit';
  String get enterOtherReportUnit =>
      isZh ? '請輸入其他通報單位' : 'Please enter other report unit';
  String get reporterName => isZh ? '通報人員' : 'Reporter Name';
  String get enterReporterName =>
      isZh ? '請填寫通報人員姓名' : 'Please enter reporter name';
  String get notifyTime => isZh ? '通報時間' : 'Notification Time';
  String get checkTime => isZh ? '檢查時間' : 'Check Time';
  String get oocPickUpTime => isZh ? '通報營運控制中心時間' : 'OOC Pick-up Time';
  String get medicDepartTime => isZh ? '醫護出發時間' : 'Medic Depart Time';
  String get accidentLocation => isZh ? '事故地點' : 'Accident Location';
  String get occArrived => isZh ? '營運控制中心到達現場' : 'OOC Arrived on Scene';
  String get medicArriveTime => isZh ? '醫護到達時間' : 'Medic Arrive Time';
  String get elapsedTime => isZh ? '花費時間(分秒)' : 'Elapsed Time (mm:ss)';
  String get exampleElapsedTimeHint => isZh ? '例如：10分30秒' : 'e.g.: 10min30sec';
  String get minutes => isZh ? '分' : 'min';
  String get seconds => isZh ? '秒' : 'sec';
  String get arrivalWithin10min =>
      isZh ? '10分鐘內到達' : 'Arrived within 10 minutes';
  String get reasonLateTitle =>
      isZh ? '未在10分鐘內到達的原因（可複選）' : 'Reasons for >10 min arrival (multi-select)';
  String get reasonPreLanding => isZh ? '落地前通知' : 'Pre-landing Notification';
  String get reasonOnDuty => isZh ? '線上勤務' : 'On-duty / Online Duty';
  String get reasonOther => isZh ? '其他' : 'Other';
  String get otherReason => isZh ? '其他原因' : 'Other Reason';
  String get enterOtherReason => isZh ? '請填寫其他原因' : 'Please enter other reason';
  String get landingTime => isZh ? '落地時間' : 'Landing Time';

  // ========== Ambulance Expenses (救護車費用) ==========
  String get ambulanceFeeWithStaff =>
      isZh ? '救護車費用含醫護人員:' : 'Ambulance Fee (incl. Medical Staff):';
  String get oxygenUsageFee => isZh ? '氧氣使用費用:' : 'Oxygen Usage Fee:';
  String get enterIntegerHint => isZh ? '請填寫整數' : 'Please enter an integer';
  String get chargeStatus => isZh ? '收費情形:' : 'Charge Status:';
  String get paid => isZh ? '已收費' : 'Paid';
  String get collectedByLandseed =>
      isZh ? '連新國際醫院代收' : 'Collected by Landseed Int\'l Hospital';
  String get unpaid => isZh ? '未收費' : 'Unpaid';
  String get paidMethod => isZh ? '已收費:' : 'Paid Method:';
  String get cash => isZh ? '現金' : 'Cash';
  String get creditCard => isZh ? '刷卡' : 'Credit Card';
  String get unpaidReason => isZh ? '未收費:' : 'Unpaid Reason:';
  String get accountsReceivable => isZh ? '欠款' : 'Accounts Receivable';
  String get remittance => isZh ? '匯款' : 'Remittance';
  String get unifiedBilling => isZh ? '統一請款' : 'Unified Billing';

  // ========== Ambulance Information (救護車資訊) ==========
  String get plateNumber => isZh ? '車牌號碼' : 'Plate Number';
  String get enterPlateNumberHint => isZh ? '請填寫車牌號碼' : 'Enter plate number';
  String get incidentLocation => isZh ? '發生地點' : 'Incident Location';
  String get dutyDateTime => isZh ? '出勤日期與時間' : 'Duty Date & Time';
  String get arriveSceneTime => isZh ? '到達現場時間' : 'Time of Arrival at Scene';
  String get destinationHospitalOrPlace =>
      isZh ? '送往醫院或地點' : 'Destination Hospital/Location';
  String get otherHospitalName => isZh ? '其他醫院名稱' : 'Other Hospital Name';
  String get leaveSceneTime => isZh ? '離開現場時間' : 'Time of Departure from Scene';
  String get arriveHospitalTime =>
      isZh ? '到達醫院時間' : 'Time of Arrival at Hospital';
  String get leaveHospitalTime =>
      isZh ? '離開醫院時間' : 'Time of Departure from Hospital';
  String get backToStandbyTime => isZh ? '返回待命時間' : 'Time Back to Standby';
  String get pleaseSelectTime => isZh ? '請選擇時間' : 'Please select time';
  String get useCurrentTime => isZh ? '更新時間' : 'Use Current Time';

  // 航廈 T1/T2 詳細地點
  String get departureBusDropOff => isZh ? '出境巴士下車處' : 'Departure Bus Drop-off';
  String get arrivalBusPickUp => isZh ? '入境巴士上車處' : 'Arrival Bus Pick-up';
  String get departureSecurityCheck =>
      isZh ? '出境安檢' : 'Departure Security Check';
  String get baggageClaim => isZh ? '行李轉盤' : 'Baggage Claim';
  String get customs => isZh ? '海關處' : 'Customs';
  String get transferCounterA => isZh ? 'A區轉機櫃檯' : 'Transfer Counter A';
  String get transferCounterB => isZh ? 'B區轉機櫃檯' : 'Transfer Counter B';
  String get transferCounterC => isZh ? 'C區轉機櫃檯' : 'Transfer Counter C';
  String get transferSecurityA => isZh ? 'A區轉機安檢' : 'Transfer Security A';
  String get transferSecurityB => isZh ? 'B區轉機安檢' : 'Transfer Security B';
  String get transferSecurityC => isZh ? 'C區轉機安檢' : 'Transfer Security C';
  String get skytrainAirside => isZh ? '航廈電車(管制區內)' : 'Skytrain (Airside)';
  String get skytrainLandside => isZh ? '航廈電車(管制區外)' : 'Skytrain (Landside)';
  String get carPark3 => isZh ? '3號停車場' : 'Car Park 3';
  String get carPark4 => isZh ? '4號停車場' : 'Car Park 4';
  String get northObservationDeck => isZh ? '北側觀景台' : 'North Observation Deck';
  String get southObservationDeck => isZh ? '南側觀景台' : 'South Observation Deck';
  String get northWing5F => isZh ? '北揚5樓' : 'North Wing 5F';
  String get southWing5F => isZh ? '南側5樓' : 'South Wing 5F';

  // 貨運站地點
  String get taxiway => isZh ? '滑行道' : 'Taxiway';
  String get tacHangar => isZh ? '台飛棚廠' : 'TAC Hangar';
  String get maintenanceApron => isZh ? '維修停機坪' : 'Maintenance Apron';
  String get evergreenAerospace =>
      isZh ? '長榮航太' : 'Evergreen Aviation Technologies';
  String get otherApronLocation => isZh ? '機坪其他位置' : 'Other Apron Location';

  // 醫院 (Ambulance Information)
  String get taoyuanPsychiatricCenter =>
      isZh ? '衛生福利部桃園療養院' : 'Taoyuan Psychiatric Center, MOHW';
  String get taoyuanMinSheng =>
      isZh ? '桃園經國敏盛醫院' : 'Taoyuan Min-Sheng General Hospital';
  String get stPaulsHospital => isZh ? '聖保祿醫院' : 'St. Paul\'s Hospital';
  String get tienShengHospital =>
      isZh ? '中壢天晟醫院' : 'Tien Sheng Memorial Hospital';
  String get taoyuanVeteransHospital =>
      isZh ? '桃園榮民總醫院' : 'Taoyuan Armed Forces General Hospital';
  String get enChuKungHospital => isZh ? '三峽恩主公醫院' : 'En Chu Kung Hospital';

  // 日期格式化方法
  String _two(int n) => n.toString().padLeft(2, '0');
  String formatFullDateTime(DateTime dt) {
    if (isZh) {
      return '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日 '
          '${_two(dt.hour)}時${_two(dt.minute)}分${_two(dt.second)}秒';
    }
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} '
        '${_two(dt.hour)}:${_two(dt.minute)}:${_two(dt.second)}';
  }

  // ========== Ambulance Personal (救護車個人資料) ==========
  String get idOrPassportNumber => isZh ? '身分證字號/護照號碼:' : 'ID/Passport Number:';
  String get enterIdOrPassportHint =>
      isZh ? '請填寫證件號碼' : 'Please enter ID or passport number';
  String get enterAddressHint => isZh ? '請填寫住址' : 'Please enter the address';
  String get patientBelongings => isZh ? '病患財物明細:' : 'Patient\'s Belongings:';
  String get enterBelongingsHint =>
      isZh ? '請填寫病患財物明細' : 'Please list patient\'s belongings';
  String get belongingsHandled => isZh ? '是否有經手:' : 'Handled Belongings:';
  String get notHandled => isZh ? '未經手' : 'Not Handled';
  String get custodianName => isZh ? '保管人姓名:' : 'Custodian\'s Name:';
  String get enterCustodianNameHint =>
      isZh ? '請填寫保管人姓名' : 'Please enter custodian\'s name';
  String get custodianSignature => isZh ? '保管人簽名:' : 'Custodian\'s Signature:';
  String get tapToSign => isZh ? '請點擊此處簽名' : 'Tap here to sign';

  // Signature Dialog
  String get signatureArea => isZh ? '簽名區' : 'Signature Area';
  String get redraw => isZh ? '重寫' : 'Redraw';
  String get clearSignature => isZh ? '清除簽名' : 'Clear Signature';
  String get done => isZh ? '完成' : 'Done';

  // ========== Ambulance Plan Page (救護計畫頁面) ==========
  String get otherExplanation => isZh ? '其他說明:' : 'Other Explanation:';
  String get enterOtherExplanationHint =>
      isZh ? '請填寫其他處置說明' : 'Please provide details for "Other"';
  String get aslManualDefib => isZh ? '手動電擊' : 'Manual Defibrillation';

  // 日期格式化 (可根據需求調整)
  String get yearMonthDayHourMinuteFormat =>
      isZh ? 'yyyy年MM月dd日 HH時mm分' : 'yyyy-MM-dd HH:mm';

  // ========== Ambulance Situation (救護車情境) ==========
  String get traumaClassification => isZh ? '創傷分類' : 'Trauma Classification';
  String get nonTrauma => isZh ? '非創傷' : 'Non-Trauma';
  String get trauma => isZh ? '創傷' : 'Trauma';
  String get nonTraumaCategory => isZh ? '非創傷類別' : 'Non-Trauma Category';
  String get acuteCondition => isZh ? '急症' : 'Acute Condition';
  String get generalSickness => isZh ? '一般疾病' : 'General Sickness';
  String get nonTraumaAcute => isZh ? '非創傷急症' : 'Non-Trauma (Acute)';
  String get breathingDifficulty =>
      isZh ? '呼吸問題(喘/呼吸急促)' : 'Breathing Difficulty (Shortness of Breath)';
  String get airwayObstruction =>
      isZh ? '呼吸道問題(異物噎塞)' : 'Airway Obstruction (Choking)';
  String get comaUnconscious => isZh ? '昏迷(意識不清)' : 'Coma / Unconscious';
  String get chestPainTightness => isZh ? '胸痛/胸悶' : 'Chest Pain / Tightness';
  String get abdominalPain => isZh ? '腹痛' : 'Abdominal Pain';
  String get suspectedPoisoning =>
      isZh ? '疑似毒藥物中毒' : 'Suspected Poisoning / Overdose';
  String get suspectedCOPoisoning =>
      isZh ? '疑似一氧化碳中毒' : 'Suspected CO Poisoning';
  String get seizureConvulsion => isZh ? '癲癇/抽搐' : 'Seizure / Convulsion';
  String get foundCollapsed => isZh ? '路倒' : 'Found Collapsed';
  String get psychiatricSymptoms => isZh ? '精神異常' : 'Psychiatric Symptoms';
  String get precipitousLabor => isZh ? '孕婦急產' : 'Precipitous Labor';
  String get ohca =>
      isZh ? '到院前心肺功能停止' : 'OHCA (Out-of-Hospital Cardiac Arrest)';
  String get otherNonTraumaAcute => isZh ? '非創傷其他急症' : 'Other Acute Non-Trauma';
  String get nonTraumaGeneral => isZh ? '非創傷一般疾病' : 'Non-Trauma (General)';
  String get headacheDizziness => isZh ? '頭痛/頭暈' : 'Headache / Dizziness';
  String get faintingSyncope => isZh ? '昏倒/昏厥' : 'Fainting / Syncope';
  String get fever => isZh ? '發燒' : 'Fever';
  String get nauseaVomitingDiarrhea =>
      isZh ? '噁心/嘔吐/腹瀉' : 'Nausea / Vomiting / Diarrhea';
  String get limbWeakness => isZh ? '肢體無力' : 'Limb Weakness';
  String get traumaCategory => isZh ? '創傷類別' : 'Trauma Category';
  String get generalTrauma => isZh ? '一般外傷' : 'General Trauma';
  String get mechanismOfInjury => isZh ? '受傷機轉' : 'Mechanism of Injury';
  String get drowning => isZh ? '溺水' : 'Drowning';
  String get fallInjury => isZh ? '摔跌傷' : 'Fall Injury';
  String get fallFromHeight => isZh ? '墜落傷' : 'Fall from Height';
  String get punctureWound => isZh ? '穿刺傷' : 'Puncture Wound';
  String get burns => isZh ? '燒燙傷' : 'Burns';
  String get electricShock => isZh ? '電擊傷' : 'Electric Shock';
  String get biteSting => isZh ? '生物咬螫傷' : 'Bite / Sting';
  String get otherTrauma => isZh ? '其他創傷' : 'Other Trauma';
  String get traumaGeneralInjury =>
      isZh ? '創傷—一般外傷' : 'Trauma - General Injury';
  String get headInjury => isZh ? '頭部外傷' : 'Head Injury';
  String get chestInjury => isZh ? '胸部外傷' : 'Chest Injury';
  String get abdominalInjury => isZh ? '腹部外傷' : 'Abdominal Injury';
  String get backInjury => isZh ? '背部外傷' : 'Back Injury';
  String get limbInjury => isZh ? '肢體外傷' : 'Limb Injury';
  String get otherGeneralTrauma => isZh ? '其他—一般外傷' : 'Other - General Injury';
  String get traumaMechanismOfInjury =>
      isZh ? '創傷—受傷機轉' : 'Trauma - Mechanism of Injury';
  String get trafficAccident => isZh ? '因交通事故' : 'Traffic Accident';
  String get nonTrafficAccident => isZh ? '非交通事故' : 'Non-Traffic Accident';
  String get heightMeters => isZh ? '高度(公尺)' : 'Height (meters)';
  String get burnDegree => isZh ? '燒燙傷度數' : 'Burn Degree';
  String get burnAreaPercentage => isZh ? '燒燙傷面積(%)' : 'Burn Area (%)';
  String get allergyHistory => isZh ? '過敏史' : 'Allergy History';
  String get none => isZh ? '無' : 'None';
  String get unknown => isZh ? '不詳' : 'Unknown';
  String get food => isZh ? '食物' : 'Food';
  String get medication => isZh ? '藥物' : 'Medication';
  String get otherAllergyHistory => isZh ? '其他過敏史' : 'Other Allergies';
  String get enterChiefComplaintHint =>
      isZh ? '請填寫病患主訴' : 'Please enter chief complaint';
  String get statementByProxy =>
      isZh ? '家屬或同事、友人代訴' : 'Statement by Proxy (Family, Colleague, Friend)';
  String get pastMedicalHistory => isZh ? '過去病史' : 'Past Medical History';
  String get hypertension => isZh ? '高血壓' : 'Hypertension';
  String get diabetes => isZh ? '糖尿病' : 'Diabetes';
  String get copd => isZh ? '慢性肺部疾病' : 'COPD';
  String get asthma => isZh ? '氣喘' : 'Asthma';
  String get cerebrovascularDisease =>
      isZh ? '腦血管疾病' : 'Cerebrovascular Disease';
  String get heartDisease => isZh ? '心臟疾病' : 'Heart Disease';
  String get kidneyDiseaseDialysis =>
      isZh ? '腎病/洗腎中' : 'Kidney Disease / Dialysis';
  String get liverDisease => isZh ? '肝臟疾病' : 'Liver Disease';
  String get otherPastMedicalHistory =>
      isZh ? '其他過去病史' : 'Other Past Medical History';

  // ========== Body Map Page (人形圖頁面) ==========
  String get bodyMapSaveSuccess =>
      isZh ? '人形圖儲存成功' : 'Body map saved successfully';
  String get bodyMapSaveFailed => isZh ? '儲存失敗: ' : 'Save failed: ';
  String get bodyMapLoadFailed => isZh ? '載入圖片失敗: ' : 'Failed to load image: ';
  String get retry => isZh ? '重試' : 'Retry';
  String get bodyMapInitFailed => isZh
      ? '無法初始化繪圖板資源，請重試。'
      : 'Failed to initialize painter resources, please retry.';

  // Toolbar Tooltips
  String get moveZoom => isZh ? '移動 / 縮放' : 'Move / Zoom';
  String get freeDraw => isZh ? '自由繪圖' : 'Free Draw';
  String get addText => isZh ? '新增文字' : 'Add Text';
  String get undo => isZh ? '撤銷' : 'Undo';
  String get redo => isZh ? '重做' : 'Redo';
  String get eraser => isZh ? '橡皮擦' : 'Eraser';
  String get clearAllItems => isZh ? '清除全部' : 'Clear All';
  String get color => isZh ? '顏色' : 'Color';
  String get strokeWidth => isZh ? '筆刷粗細' : 'Stroke Width';
  String get exportImage => isZh ? '匯出圖片' : 'Export Image';

  // Clear Dialog
  String get confirmClearTitle => isZh ? '確認清除' : 'Confirm Clear';
  String get confirmClearContent =>
      isZh ? '確定要清除所有繪圖嗎?' : 'Are you sure you want to clear all drawings?';

  // Stroke Widths
  String get strokeThin => isZh ? '細' : 'Thin';
  String get strokeMedium => isZh ? '中' : 'Medium';
  String get strokeThick => isZh ? '粗' : 'Thick';
  String get strokeExtraThick => isZh ? '特粗' : 'Extra Thick';

  // Export Messages
  String get imageRenderedSuccess =>
      isZh ? '圖片已成功渲染 (待儲存)' : 'Image rendered successfully (pending save)';
  String get exportFailed => isZh ? '匯出失敗: ' : 'Export failed: ';

  // ========== Electronic Documents Page (電傳文件頁面) ==========
  String get saveElectronicDocFailed =>
      isZh ? '儲存電傳文件失敗: ' : 'Failed to save electronic document: ';

  // Section Titles
  String get toOOC => isZh
      ? 'TO：桃園國際機場股份有限公司營運控制中心'
      : 'TO: Taoyuan International Airport Corp. Operation Control Center';
  String get fromMedicalCenter => isZh
      ? 'FROM：聯新國際醫院桃園國際機場醫療中心'
      : 'FROM: Landseed Hospital Taoyuan Airport Medical Center';

  // "TO" Options
  String get toOption1 => isZh ? 'T1 03-3063578' : 'T1 03-3063578';
  String get toOption2 => isZh ? 'T2 03-3063367' : 'T2 03-3063367';

  // "FROM" Options
  String get fromOption1 => isZh ? 'T1 03-3834225' : 'T1 03-3834225';
  String get fromOption2 => isZh ? 'T2 03-3983485' : 'T2 03-3983485';

  // ========== Emergency Accident Page (急救事故頁面) ==========
  String get incidentDateTime => isZh ? '事發日期與時間' : 'Incident Date & Time';

  // ========== Emergency Flight Page (急救飛航頁面) ==========
  String get source => isZh ? '來源' : 'Source';
  String get departure => isZh ? '出境' : 'Departure';
  String get arrival => isZh ? '入境' : 'Arrival';
  String get transit => isZh ? '過境' : 'Transit';

  String get airline => isZh ? '航空公司' : 'Airline';
  String get otherAirline => isZh ? '其他航空公司' : 'Other Airline';
  String get enterNationalityHint =>
      isZh ? '請輸入國籍' : 'Please enter nationality';

  // Airlines
  String get evaAir => isZh ? 'BR長榮航空' : 'BR EVA Air';
  String get chinaAirlines => isZh ? 'CI中華航空' : 'CI China Airlines';
  String get cathayPacific => isZh ? 'CX國泰航空' : 'CX Cathay Pacific';
  String get unitedAirlines => isZh ? 'UA聯合航空' : 'UA United Airlines';
  String get klm => isZh ? 'KL荷蘭航空' : 'KL Royal Dutch Airlines';
  String get chinaSouthern => isZh ? 'CZ中國南方航空' : 'CZ China Southern Airlines';
  String get tigerairTaiwan => isZh ? 'IT台灣虎航' : 'IT Tigerair Taiwan';
  String get emirates => isZh ? 'EK阿聯酋航空' : 'EK Emirates';
  String get airChina => isZh ? 'CA中國國際航空' : 'CA Air China';
  String get starlux => isZh ? 'JX星宇航空' : 'JX Starlux Airlines';
  String get mandarinAirlines => isZh ? 'AE華信航空' : 'AE Mandarin Airlines';
  String get uniAir => isZh ? 'B7立榮航空' : 'B7 UNI Air';
  String get chinaEastern => isZh ? 'MU中國東方航空' : 'MU China Eastern Airlines';
  String get xiamenAir => isZh ? 'MF廈門航空' : 'MF XiamenAir';
  String get peachAviation => isZh ? 'MM樂桃航空' : 'MM Peach Aviation';
  String get koreanAir => isZh ? 'KE大韓航空' : 'KE Korean Air';
  String get asianaAirlines => isZh ? 'OZ韓亞航空' : 'OZ Asiana Airlines';

  // Search Dialog
  String get searchMore => isZh ? '搜尋更多…' : 'Search more...';
  String get searchOrInput => isZh ? '搜尋 / 輸入' : 'Search / Input';
  String get filterWithKeywordHint =>
      isZh ? '輸入關鍵字過濾…' : 'Filter with keywords...';
  String get addNewPrefix => isZh ? '新增：' : 'Add: ';

  String formatDate(DateTime dt) {
    if (isZh) {
      return '${dt.year}年${_two(dt.month)}月${_two(dt.day)}日';
    }
    // English format
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)}';
  }

  // ========== Emergency Plan Page (急救計畫頁面) ==========
  String get emergencyBasicInfo =>
      isZh ? '急救基本資料' : 'Emergency Basic Information';
  String get firstAidStartTime => isZh ? '急救開始時間' : 'First Aid Start Time';
  String get diagnosis => isZh ? '診斷' : 'Diagnosis';
  String get enterDiagnosis => isZh ? '請輸入診斷' : 'Please enter diagnosis';
  String get situationDescription => isZh ? '發生情況' : 'Situation Description';
  String get enterSituationDescription =>
      isZh ? '請輸入發生情況' : 'Please describe the situation';
  String get patientCondition => isZh ? '病況' : 'Patient Condition';
  String get consciousness => isZh ? '意識' : 'Consciousness';
  String get heartRate => isZh ? '心跳(次/分)' : 'Heart Rate (bpm)';
  String get respirationRate => isZh ? '呼吸(次/分)' : 'Respiration Rate (rpm)';
  String get bloodPressure => isZh ? '血壓(mmHg)' : 'Blood Pressure (mmHg)';
  String get enterSystolicDiastolic =>
      isZh ? '請輸入收縮壓/舒張壓' : 'Enter Systolic/Diastolic';
  String get enterValue => isZh ? '請輸入' : 'Please enter';
  String get bodyTemperature => isZh ? '體溫' : 'Body Temperature';
  String get tempCold => isZh ? '冰冷' : 'Cold';
  String get tempWarm => isZh ? '溫暖' : 'Warm';
  String get pupils => isZh ? '瞳孔' : 'Pupils';
  String get leftPupilSize => isZh ? '左 Size(mm)' : 'Left Size (mm)';
  String get rightPupilSize => isZh ? '右 Size(mm)' : 'Right Size (mm)';
  String get emergencyProcedures => isZh ? '急救處置' : 'Emergency Procedures';
  String get intubationStartTime => isZh ? '插管開始時間' : 'Intubation Start Time';
  String get intubationMethod => isZh ? '插管方式' : 'Intubation Method';
  String get airwayContentCode => isZh ? '氣管內容氣碼' : 'Airway Content Code';
  String get enterAirwayContentCode =>
      isZh ? '請輸入氣管內容氣碼' : 'Please enter airway content code';
  String get intubationRecord => isZh ? '插管記錄' : 'Intubation Record';
  String get enterIntubationRecord =>
      isZh ? '請輸入插管記錄' : 'Please enter intubation record';
  String get emergencyEndAndResult =>
      isZh ? '急救結束與結果' : 'End of First Aid & Result';
  String get firstAidEndTime => isZh ? '急救結束時間' : 'First Aid End Time';
  String get firstAidEndRecord => isZh ? '急救結束紀錄' : 'First Aid End Record';
  // Note: emergencyResult is already defined and can be reused
  String get resultReferral => isZh ? '轉診' : 'Referral';
  String get resultDeath => isZh ? '死亡' : 'Death';
  String get participatingPersonnel =>
      isZh ? '參與人員' : 'Participating Personnel';
  String get emergencyDoctor => isZh ? '急救醫師' : 'Emergency Doctor';
  String get emergencyNurse => isZh ? '急救護理師' : 'Emergency Nurse';
  String get nurseSignature => isZh ? '護理師簽名' : 'Nurse Signature';
  String get signatureStamp => isZh ? '簽章' : 'Signature/Stamp';
  String get emergencyEMT => isZh ? '急救EMT' : 'Emergency EMT';
  String get emtSignature => isZh ? 'EMT簽名' : 'EMT Signature';
  String get assistantPersonnelList => isZh ? '協助人員列表' : 'List of Assistants';
  String get noAssistantsSelected =>
      isZh ? '尚未選擇協助人員' : 'No assistants selected yet';
  String get addEditAssistants => isZh ? '加入/編輯協助人員' : 'Add/Edit Assistants';
  String get selectDoctorDialogTitle =>
      isZh ? '選擇急救醫師' : 'Select Emergency Doctor';
  String get selectNurseDialogTitle =>
      isZh ? '選擇急救護理師' : 'Select Emergency Nurse';
  String get selectEMTDialogTitle => isZh ? '選擇急救EMT' : 'Select Emergency EMT';
  String get selectAssistantsDialogTitle =>
      isZh ? '選擇協助人員姓名' : 'Select Assistant(s)';
  String get tapToSelectRequired =>
      isZh ? '點擊選擇 (必填)' : 'Tap to select (Required)';
  String get tapToSelect => isZh ? '點擊選擇' : 'Tap to select';

  // Date format with seconds
  String get fullDateTimeSecondsFormat =>
      isZh ? 'yyyy年MM月dd日 HH時mm分ss秒' : 'yyyy-MM-dd HH:mm:ss';

  // ========== Flight Log Page (飛航紀錄頁面) ==========
  String get pleaseSelect => isZh ? '請選擇' : 'Please select';
  String get flightCode => isZh ? '班機代碼' : 'Flight Code';
  String get enterFlightNumberHint =>
      isZh ? '請輸入班機號碼' : 'Please enter flight number';
  String get travelStatus => isZh ? '旅行狀態' : 'Travel Status';
  String get otherTravelStatus => isZh ? '其他旅行狀態' : 'Other Travel Status';
  String get enterTravelStatusHint =>
      isZh ? '請輸入旅行狀態' : 'Please enter travel status';
  String get departurePlace => isZh ? '啟程地' : 'Departure';
  String get tapToSelectDeparture =>
      isZh ? '點擊選擇啟程地' : 'Tap to select departure';
  String get viaPlace => isZh ? '經過地' : 'Via';
  String get tapToSelectVia => isZh ? '點擊選擇經過地' : 'Tap to select via';
  String get destinationPlace => isZh ? '目的地' : 'Destination';
  String get tapToSelectDestination =>
      isZh ? '點擊選擇目的地' : 'Tap to select destination';
  String get selectLocation => isZh ? '選擇地點' : 'Select Location';

  // Travel Options (除了 departure, arrival, transit, other)
  String get transfer => isZh ? '轉機' : 'Transfer';
  String get emergencyLanding => isZh ? '迫降' : 'Emergency Landing';
  String get diversionLanding => isZh ? '轉降' : 'Diversion';
  String get technicalLanding => isZh ? '備降' : 'Technical Stop';

  // Airport Options
  String get airportTPE => isZh ? 'TPE台北 / 台灣' : 'TPE Taipei / Taiwan';
  String get airportHKG => isZh ? 'HKG香港 / 香港' : 'HKG Hong Kong / Hong Kong';
  String get airportLAX => isZh ? 'LAX洛杉磯 / 美國' : 'LAX Los Angeles / USA';
  String get airportSHA => isZh ? 'SHA上海 / 中國' : 'SHA Shanghai / China';
  String get airportTYO => isZh ? 'TYO東京 / 日本' : 'TYO Tokyo / Japan';
  String get airportBKK => isZh ? 'BKK曼谷 / 泰國' : 'BKK Bangkok / Thailand';
  String get airportSFO => isZh ? 'SFO舊金山 / 美國' : 'SFO San Francisco / USA';
  String get airportMNL => isZh ? 'MNL馬尼拉 / 菲律賓' : 'MNL Manila / Philippines';

  // ========== Medical Certificate Page (診斷證明頁面) ==========
  String get saveCertificateFailed =>
      isZh ? '儲存診斷證明失敗' : 'Failed to save certificate ';
  String get diagnosisLabel => isZh ? '診斷' : 'Diagnosis';
  String get enterDiagnosisHint => isZh ? '請輸入診斷' : 'Please enter diagnosis';
  String get defaultInstructionPhrase =>
      isZh ? '預設囑言片語' : 'Default Instruction Phrase';
  String get fitToFly => isZh ? '適宜飛行' : 'Fit to Fly';
  String get referral => isZh ? '轉診後送' : 'Referral';
  String get chineseInstructionLabel => isZh ? '中文囑言' : 'Chinese Instruction';
  String get enterChineseInstructionHint =>
      isZh ? '請輸入中文囑言' : 'Please enter Chinese instruction';
  String get englishInstructionLabel => isZh ? '英文囑言' : 'English Instruction';
  String get enterEnglishInstructionHint =>
      isZh ? '請輸入英文囑言' : 'Please enter English instructions';
  String get issueDateLabel => isZh ? '開立日期' : 'Issue Date';

  // Pre-filled instruction texts
  String get fitToFlyInstructionChinese =>
      "病人於今日因上述False原因，接受本機場醫療中心緊急醫療出診，目前生命徵象穩定適宜飛行。(以下空白)";
  String get fitToFlyInstructionEnglish =>
      "Due to above reasons, the patient received an outreach emergency medical. He/She is fit to fly.(Blank Below)";
  String get referralInstructionChinese =>
      "病人於今日因上述False原因，接受本醫療中心緊急醫療出診，建議轉診至醫院進行進一步檢查及治療。(以下空白)";
  String get referralInstructionEnglish =>
      "Due to above reasons, the patient received an outreach emergency medical. It is suggested to transfer to hospital for further evaluation and management.(Blank Below)";

  // ========== Medical Expenses Page (醫療費用頁面) ==========
  String get saveMedicalFeeFailed =>
      isZh ? '儲存醫療費用失敗: ' : 'Failed to save medical expenses: ';
  String get medicalFeeForm => isZh ? '醫療費用收費表' : 'Medical Fee Form';
  String get viewFeeSchedule => isZh ? '查看收費表' : 'View Fee Schedule';
  String get feeScheduleTitle => isZh ? '收費表' : 'Fee Schedule';
  String get feeScheduleContentPlaceholder => isZh
      ? '這裡可以顯示詳細收費表內容'
      : 'Detailed fee schedule content can be displayed here';
  String get chargeMethod =>
      isZh ? '醫療費用收取方式' : 'Medical Fee Collection Method';
  String get selfPay => isZh ? '自付' : 'Self-Pay';
  String get hospitalCollection => isZh ? '總院會核代收' : 'Hospital Collection';
  String get billingError => isZh ? '收費異常' : 'Billing Error';
  String get consultationFee => isZh ? '出診費' : 'Consultation Fee';
  String get ambulanceFee => isZh ? '救護車費用' : 'Ambulance Fee';
  // totalFee is already defined in the common section
  String get billingNotes => isZh ? '收費備註' : 'Billing Notes';
  String get enterAmountHint => isZh ? '輸入金額' : 'Enter amount';
  String get enterBillingNotesHint =>
      isZh ? '請填寫收費備註' : 'Please enter billing notes';
  String get agreementStatementZh => isZh
      ? '瞭解醫護人員說明明瞭醫療收費之後且同意'
      : 'I understand the explanation of the medical charges and agree to them.';
  String get agreementStatementEn => isZh
      ? 'Understand the medical charge and agree to it.'
      : 'Understand the medical charge and agree to it.';
  String get agreedBySignature =>
      isZh ? '同意人簽名/身份' : 'Signature / ID of Agreeing Person';
  String get witnessSignature =>
      isZh ? '見證人簽名/身份' : 'Signature / ID of Witness';

  // ========== Nav2Page (頁面導航與儲存邏輯) ==========
  String get saveFailed => isZh ? '儲存失敗' : 'Save Failed';
  String get commonData => isZh ? '公共資料' : 'Common Data';
  String get systemError => isZh ? '系統錯誤' : 'System Error';
  String get saveResult => isZh ? '儲存結果' : 'Save Result';
  String get savedSuccessfully => isZh ? '成功儲存:' : 'Saved Successfully:';
  String get saveFailedLabel => isZh ? '儲存失敗:' : 'Save Failed:';

  String get medicalCertificate => isZh ? '診斷證明' : 'Medical Certificate';
  String get medicalExpenses => isZh ? '醫療費用' : 'Medical Expenses';
  String get electronicDocuments => isZh ? '電傳文件' : 'Electronic Documents';
  String get bodyMap => isZh ? '人形圖' : 'Body Map';

  // ========== Nav5 (救護車導航標籤) ==========
  String get ambulanceInformation => isZh ? '派遣資料' : 'Dispatch Info';
  // '病患資料' -> 使用通用的 personalInfo
  String get ambulanceSituation => isZh ? '現場狀況' : 'On-site Situation';
  String get ambulancePlan => isZh ? '處置項目' : 'Treatment Items';
  String get ambulanceExpenses => isZh ? '收取費用' : 'Fees & Charges';

  // ========== Nursing Record Page (護理記錄頁面) ==========
  String get saveNursingRecordFailed =>
      isZh ? '儲存護理記錄失敗: ' : 'Failed to save nursing record: ';
  String get nursingRecordForm => isZh ? '護理記錄表' : 'Nursing Record Form';
  String get recordTime => isZh ? '紀錄時間' : 'Record Time';
  String get record => isZh ? '紀錄' : 'Record';
  String get nurseName => isZh ? '護理師姓名' : 'Nurse Name';
  String get timeHint => isZh ? '時間' : 'Time';
  String get contentHint => isZh ? '內容' : 'Content';
  String get nameHint => isZh ? '姓名' : 'Name';
  String get signatureHint => isZh ? '簽名' : 'Signature';
  String get addRow => isZh ? '＋ 加入資料行' : '+ Add Row';

  // ========== Referral Form Page (轉診表單頁面) ==========
  String get referralForm => isZh ? '轉診表單' : 'Referral Form';
  String get contactPersonInfo => isZh ? '聯絡人資料' : 'Contact Person Information';
  String get contactName => isZh ? '姓名:' : 'Name:';
  String get enterContactName =>
      isZh ? '請填寫聯絡人姓名' : 'Please enter contact name';
  String get contactPhoneNumber => isZh ? '電話:' : 'Phone:';
  String get enterContactPhone =>
      isZh ? '請填寫聯絡人電話' : 'Please enter contact phone';
  String get contactAddressLabel => isZh ? '地址:' : 'Address:';
  String get enterContactAddress =>
      isZh ? '請填寫聯絡人地址' : 'Please enter contact address';

  String get diagnosisIcd10 =>
      isZh ? '診斷ICD-10-CM/PCS病名' : 'Diagnosis ICD-10-CM/PCS';
  String get primaryDiagnosis => isZh ? '主診斷:' : 'Primary Diagnosis:';
  String get enterPrimaryDiagnosis => isZh ? '請輸入...' : 'Please enter...';
  String get secondaryDiagnosis1Label =>
      isZh ? '副診斷1:' : 'Secondary Diagnosis 1:';
  String get secondaryDiagnosis2Label =>
      isZh ? '副診斷2:' : 'Secondary Diagnosis 2:';

  String get examTreatmentSummary =>
      isZh ? '檢查及治療摘要' : 'Examination & Treatment Summary';
  String get lastExamResultDate =>
      isZh ? '最近一次檢查結果日期' : 'Latest Examination Result Date';
  String get lastMedicationSurgeryDate =>
      isZh ? '最近一次用藥或手術名稱日期' : 'Latest Medication/Surgery Date';

  String get referralPurpose => isZh ? '轉診目的' : 'Referral Purpose';
  String get emergencyTreatmentOption => isZh ? '急診治療' : 'Emergency Treatment';
  String get hospitalization => isZh ? '住院治療' : 'Hospitalization';
  String get outpatientTreatment => isZh ? '門診治療' : 'Outpatient Treatment';
  String get furtherExamination => isZh ? '進一步檢查' : 'Further Examination';
  String get examItem => isZh ? '檢查項目:' : 'Examination Item:';
  String get enterExamItem =>
      isZh ? '請填寫檢查項目' : 'Please enter examination item';
  String get returnToOriginalFacility => isZh
      ? '轉回轉出或適當之院所繼續追蹤'
      : 'Return to Original/Appropriate Facility for Follow-up';
  String get otherPurpose => isZh ? '其他' : 'Other';
  String get otherReferralPurpose =>
      isZh ? '其他轉診目的:' : 'Other Referral Purpose:';
  String get enterOtherPurpose =>
      isZh ? '請填寫其他轉診目的' : 'Please enter other purpose';

  String get treatingPhysicianName =>
      isZh ? '診治醫生姓名' : 'Treating Physician Name';
  String get physicianName => isZh ? '醫師姓名:' : 'Physician Name:';
  String get otherPhysician => isZh ? '其他:' : 'Other:';
  String get enterPhysicianName => isZh ? '請輸入姓名' : 'Please enter name';

  String get treatingPhysicianDept =>
      isZh ? '診治醫生科別' : 'Treating Physician Department';
  String get physicianDept => isZh ? '醫師科別:' : 'Physician Department:';
  String get enterDeptName => isZh ? '請輸入科別' : 'Please enter department';

  String get treatingPhysicianSignature =>
      isZh ? '診治醫師簽名' : 'Treating Physician Signature';

  String get issueDate => isZh ? '開單日期' : 'Issue Date';
  String get dateLabel => isZh ? '日期:' : 'Date:';

  String get appointmentDate => isZh ? '安排就醫日期' : 'Appointment Date';
  String get appointmentDepartment =>
      isZh ? '安排就醫科別:' : 'Appointment Department:';
  String get enterAppointmentDept => isZh ? '選填就醫科別' : 'Optional department';
  String get appointmentRoom => isZh ? '安排就醫診間:' : 'Appointment Room:';
  String get enterAppointmentRoom => isZh ? '選填就醫診間' : 'Optional room';
  String get appointmentNumberLabel => isZh ? '安排就醫號碼:' : 'Appointment Number:';
  String get enterAppointmentNumber => isZh ? '選填就醫號碼' : 'Optional number';

  String get recommendedReferralHospital =>
      isZh ? '建議轉診院所名稱:' : 'Recommended Referral Hospital:';
  String get landseedInternational =>
      isZh ? '聯新國際醫院' : 'Landseed International Hospital';
  String get recommendedHospitalDept =>
      isZh ? '建議院所科別:' : 'Recommended Hospital Department:';
  String get recommendedHospitalPhysician =>
      isZh ? '建議院所醫師姓名:' : 'Recommended Hospital Physician:';
  String get enterHospitalPhysician =>
      isZh ? '視情況填寫轉診院所醫師' : 'Optional physician name';
  String get recommendedHospitalAddress =>
      isZh ? '建議院所地址:' : 'Recommended Hospital Address:';
  String get enterHospitalAddress =>
      isZh ? '請填寫院所地址' : 'Please enter hospital address';
  String get recommendedHospitalPhone =>
      isZh ? '建議院所電話:' : 'Recommended Hospital Phone:';
  String get enterHospitalPhone =>
      isZh ? '請填寫院所電話' : 'Please enter hospital phone';

  String get consentStatement => isZh
      ? '經醫師解釋病情及轉診目的後同意轉院。'
      : 'Consent to transfer after physician explanation of condition and referral purpose.';
  String get consentPersonSignature =>
      isZh ? '同意人簽名' : 'Consent Person Signature';
  String get relationToPatientLabel => isZh ? '與病人關係:' : 'Relation to Patient:';
  String get enterRelation =>
      isZh ? '請填寫同意人與病人關係' : 'Please enter relation to patient';
  String get signatureDateTime => isZh ? '簽名日期:' : 'Signature Date:';
  String get updateTimeButton => isZh ? '更新時間' : 'Update Time';

  // Doctor names
  String get doctorFang => isZh ? '方詩旋' : 'Dr. Fang';
  String get doctorGu => isZh ? '古璿正' : 'Dr. Gu';
  String get doctorJiang => isZh ? '江旺財' : 'Dr. Jiang';
  String get doctorLu => isZh ? '呂學政' : 'Dr. Lu';
  String get doctorZhou => isZh ? '周志勃' : 'Dr. Zhou';
  String get doctorJin => isZh ? '金霞歌' : 'Dr. Jin';
  String get doctorXu => isZh ? '徐丕' : 'Dr. Xu';
  String get doctorKang => isZh ? '康曉妡' : 'Dr. Kang';

  // Department names
  String get emergencyMedicineDept => isZh ? '急診醫學科' : 'Emergency Medicine';
  String get generalMedicineDept => isZh ? '不分科' : 'General Medicine';
  String get familyMedicineDept => isZh ? '家醫科' : 'Family Medicine';
  String get internalMedicineDept => isZh ? '內科' : 'Internal Medicine';
  String get surgeryDept => isZh ? '外科' : 'Surgery';
  String get pediatricsDept => isZh ? '小兒科' : 'Pediatrics';
  String get obstetricsGynecologyDept =>
      isZh ? '婦產科' : 'Obstetrics & Gynecology';
  String get orthopedicsDept => isZh ? '骨科' : 'Orthopedics';
  String get ophthalmologyDept => isZh ? '眼科' : 'Ophthalmology';
}

// Delegate for AppTranslations
class _AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const _AppTranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) async {
    return AppTranslations(locale);
  }

  @override
  bool shouldReload(_AppTranslationsDelegate old) => false;
}
