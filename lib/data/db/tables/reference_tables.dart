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
  TextColumn get code => text().withLength(min: 1, max: 10).nullable()();
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
  TextColumn get countryCode => text()(); // TW / JP
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
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
