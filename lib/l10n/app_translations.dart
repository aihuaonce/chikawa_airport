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
  String get bodyDiagram => isZh ? '人形圖:' : 'Body Diagram';
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
