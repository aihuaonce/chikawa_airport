import 'package:drift/drift.dart';
import 'medical_tables.dart';
import 'reference_tables.dart';

// 1. 主訴-症狀關聯表 (取代 ChiefComplaint.selectedSymptoms JSON)
class ChiefComplaintSymptomLinks extends Table {
  IntColumn get complaintId => 
      integer().references(ChiefComplaint, #complaintId)();
  IntColumn get symptomId => 
      integer().references(ChiefComplaintDetail, #id)();
  
  @override
  List<String> get customConstraints => [
    'PRIMARY KEY (complaint_id, symptom_id)'
  ];
}

// 2. 處置-項目關聯表 (取代 Treatment.actionSummary JSON)
class TreatmentActionLinks extends Table {
  IntColumn get treatmentId => 
      integer().references(Treatment, #treatmentId)();
  IntColumn get actionItemId => 
      integer().references(ActionItem, #id)();
  
  @override
  List<String> get customConstraints => [
    'PRIMARY KEY (treatment_id, action_item_id)'
  ];
}

// 3. 特別註記-選項關聯表 (取代 SpecialNotes.selectedNotes JSON)
class SpecialNoteLinks extends Table {
  IntColumn get noteId => 
      integer().references(SpecialNotes, #noteId)();
  IntColumn get noteRefId => 
      integer().references(SpecialNoteRef, #id)();
  
  @override
  List<String> get customConstraints => [
    'PRIMARY KEY (note_id, note_ref_id)'
  ];
}

// 4. 病史狀態參考表 (取代 '無'/'不詳'/'有' 硬編碼)
class HistoryStatusRef extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // none / unknown / yes
  TextColumn get name => text()(); // 無 / 不詳 / 有
  TextColumn get nameEn => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// 5. 醫護人員角色參考表 (取代硬編碼 role 字符串)
class MedicalStaffRole extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // DOCTOR / NURSE / EMT / ASSIST
  TextColumn get name => text()(); // 醫師 / 護理師 / EMT / 協助人員
  TextColumn get nameEn => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// 6. 瞳孔反應參考表 (取代 '+', '-', '±' 硬編碼)
class PupilReactionRef extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // positive / negative / equivocal
  TextColumn get symbol => text()(); // + / - / ±
  TextColumn get name => text()(); // 有反應 / 無反應 / 疑似
}

// 7. 意識狀態參考表 (取代硬編碼字符串)
class ConsciousnessLevelRef extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()(); // alert / drowsy / unconscious
  TextColumn get name => text()(); // 清醒 / 嗜睡 / 昏迷
  TextColumn get nameEn => text().nullable()();
}
