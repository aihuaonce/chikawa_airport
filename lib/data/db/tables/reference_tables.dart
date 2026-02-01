import 'package:drift/drift.dart';

//參考表
//病患-性別表
class Sex extends Table {
  IntColumn get sexId => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
}

//病患-國籍表
class Nationality extends Table {
  IntColumn get nationalityId => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  // 英文名稱
  TextColumn get nameEn => text().nullable()();
}

//飛航-航空公司表
class Airline extends Table {
  IntColumn get airlineId => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get name => text()();
}

//飛航-旅行狀態表
class TravelStatus extends Table {
  IntColumn get travelStatusId => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get name => text()();
}

//飛航-地點表
class Location extends Table {
  IntColumn get locationId => integer().autoIncrement()();
  TextColumn get code => text()(); // TPE / NRT
  TextColumn get name => text()();
}

//事故-一級地點表
class IncidentPlaceCategory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//特別註記選項表
class SpecialNoteRef extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//事故-二級地點表
class IncidentPlaceCategory2 extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId =>
      integer().references(IncidentPlaceCategory, #id)();

  TextColumn get name => text()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//事故通報單位表
class ReportingUnit extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//主訴類型表
class ChiefComplaintType extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // trauma / non_trauma
  TextColumn get name => text()(); // 外傷 / 非外傷
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//主訴細項表 (Symptom Grid)
class ChiefComplaintDetail extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chiefComplaintTypeId =>
      integer().references(ChiefComplaintType, #id)();
  TextColumn get name => text()(); // 鈍挫傷, 頭頸部...
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//診斷分類表
class DiagnosisCategory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//分級表
class TriageLevel extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get level => integer()(); // 1-5
  TextColumn get name => text()(); // 復甦急救 / 危急 / 緊急 / 次緊急 / 非緊急
  TextColumn get colorCode => text()(); // red / orange / yellow / green / blue
  TextColumn get description => text().nullable()();
}

//現場處置表
class TreatmentOnSite extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // 諮詢衛教 / 內科處置 / 外科處置 / 拒絕處置 / 疑似傳染病診療
  TextColumn get description => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//處置結果表
class TreatmentResult extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//轉診醫院表
class ReferralHospital extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // 林口長庚醫院 / 聯新國際醫院
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isOther => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//處置項目表
class ActionItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // 冰敷 / EKG心電圖 / 血糖 / 傷口處置...
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

//醫療人員表
class MedicalStaff extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get employeeId => text().nullable()();
  TextColumn get role => text()(); // physician / nurse / emt
  TextColumn get department => text().nullable()();
  TextColumn get phone => text().nullable()();
  BlobColumn get signature => blob().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 護理常用語表
class NursingPhrase extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 6. 付款方式參考表
class PaymentMethod extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // self_pay / unified_billing / hospital_collect / abnormal
  TextColumn get name => text()(); // 自付 / 統一請款 / 總院會核代收 / 收費異常
  TextColumn get nameEn => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 7. 收款狀態參考表
class CollectionStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // not_collected / collected / not_required
  TextColumn get name => text()(); // 尚未收款 / 已收款 / 不需要
  TextColumn get nameEn => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 8. 貨幣參考表
class CurrencyRef extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // TWD / USD / CNY / JPY / CAD
  TextColumn get name => text()(); // 台幣 / 美金 / 人民幣 / 日幣 / 加幣
  TextColumn get symbol => text().nullable()(); // $ / ¥ / €
}

// 9. 轉診目的參考表
class ReferralPurpose extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // emergency / inpatient / outpatient / further_exam / followup / other
  TextColumn get name => text()(); // 急診治療 / 住院治療 / 門診治療 / 進一步檢查 / 繼續追蹤 / 其它
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 10. 站點參考表（TELEX用）
class StationRef extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // T1_OCC / T2_OCC / T1_MED / T2_MED
  TextColumn get name => text()(); // T1 03-3063578 / T2 03-3063367 / T1 03-3834225 / T2 03-3983485
  TextColumn get description => text().nullable()(); // 桃機T1 OCC / 桃機T2 OCC / 機場醫療中心T1 / 機場醫療中心T2
}

// 11. 關係類型參考表（轉診單用）
class RelationshipType extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // self / spouse / parent / child / other
  TextColumn get name => text()(); // 本人 / 配偶 / 父母 / 子女 / 其他
  TextColumn get nameEn => text().nullable()();
}
