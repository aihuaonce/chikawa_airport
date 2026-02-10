import 'package:drift/drift.dart';
import 'medical_tables.dart';

// 救護車現場狀況紀錄表
@DataClassName('AmbulanceSceneRecordData')
class AmbulanceSceneRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 關聯到 MedicalRecord
  IntColumn get medicalId => integer().unique().references(MedicalRecord, #medicalId)();

  // 病患主訴
  TextColumn get patientComplaint => text().nullable()();
  
  // 是否為代訴 (True: 是, False: 否)
  BoolColumn get isProxyComplaint => boolean().withDefault(const Constant(false))();

  // 墜落高度
  TextColumn get fallHeight => text().nullable()();

  // 燒燙傷詳情
  TextColumn get burnDegree => text().nullable()(); // 度數
  TextColumn get burnArea => text().nullable()();   // 面積
  TextColumn get burnPercentage => text().nullable()(); // 百分比

  // 其它創傷說明
  TextColumn get otherTraumaNote => text().nullable()();

  // 過敏史狀態 (無/不詳/有)
  TextColumn get allergyStatus => text().withDefault(const Constant('無'))();
  // 過敏原說明
  TextColumn get allergyNote => text().nullable()();

  // 過去病史狀態 (無/不詳/有)
  TextColumn get historyStatus => text().withDefault(const Constant('無'))();
  // 其它病史說明
  TextColumn get historyNote => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 救護車參考選項表 (用於儲存各類選單項目)
@DataClassName('AmbulanceReferenceItemData')
class AmbulanceReferenceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 類別 (例如: TraumaGroup, GeneralTrauma, Mechanism, NonTraumaGroup, Acute, GeneralDisease, Allergy, History)
  TextColumn get category => text()();
  
  // 選項名稱
  TextColumn get name => text()();
  
  // 排序
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  
  // 是否啟用
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 救護車現場選項關聯表 (多對多)
@DataClassName('AmbulanceSceneItemLinkData')
class AmbulanceSceneItemLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 關聯到現場紀錄
  IntColumn get sceneRecordId => integer().references(AmbulanceSceneRecords, #id, onDelete: KeyAction.cascade)();
  
  // 關聯到參考選項
  IntColumn get itemId => integer().references(AmbulanceReferenceItems, #id, onDelete: KeyAction.cascade)();
}
