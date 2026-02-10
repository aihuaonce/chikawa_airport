import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/ambulance_tables.dart';
import '../tables/reference_tables.dart';
import '../tables/medical_tables.dart';

part 'ambulance_dao.g.dart';

@DriftAccessor(tables: [
  AmbulanceRecords,
  AmbulancePersonalProperty,
  IncidentPlaceCategory, 
  IncidentPlaceCategory2,
  ReferralHospital,
  IncidentRecord,
  ReferralForms,
  Treatment
])
class AmbulanceDao extends DatabaseAccessor<AppDatabase> with _$AmbulanceDaoMixin {
  AmbulanceDao(super.db);

  // 取得救護車紀錄
  Future<AmbulanceRecord?> getAmbulanceRecord(int id) {
    return (select(ambulanceRecords)..where((t) => t.ambulanceId.equals(id))).getSingleOrNull();
  }
  
  // 透過 medicalId 取得救護車紀錄 (如果有的話)
  Future<AmbulanceRecord?> getAmbulanceRecordByMedicalId(int medicalId) {
    return (select(ambulanceRecords)..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 取得個人財物紀錄
  Future<AmbulancePersonalPropertyData?> getPersonalProperty(int medicalId) {
    return (select(ambulancePersonalProperty)..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 更新個人財物紀錄
  Future<int> updatePersonalProperty(AmbulancePersonalPropertyCompanion data) async {
    // 檢查是否已存在
    final existing = await (select(ambulancePersonalProperty)
      ..where((t) => t.medicalId.equals(data.medicalId.value)))
      .getSingleOrNull();

    if (existing != null) {
      // 如果存在，執行更新
      await (update(ambulancePersonalProperty)
        ..where((t) => t.medicalId.equals(data.medicalId.value)))
        .write(data);
      return existing.id;
    } else {
      // 如果不存在，執行插入
      return into(ambulancePersonalProperty).insert(data);
    }
  }

  // 建立救護車紀錄
  Future<int> createAmbulanceRecord(AmbulanceRecordsCompanion data) {
    return into(ambulanceRecords).insert(data);
  }

  // 更新救護車紀錄
  Future<bool> updateAmbulanceRecord(AmbulanceRecordsCompanion data) {
    return update(ambulanceRecords).replace(data);
  }
  
  // 插入或更新
  Future<int> insertOrUpdateAmbulanceRecord(AmbulanceRecordsCompanion data) async {
    return into(ambulanceRecords).insertOnConflictUpdate(data);
  }

  // 取得地點列表
  Future<List<IncidentPlaceCategoryData>> getIncidentLocations() {
    return (select(incidentPlaceCategory)..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }
  
  // 搜尋地點
  Future<List<IncidentPlaceCategoryData>> searchIncidentLocations(String query) {
    return (select(incidentPlaceCategory)
      ..where((t) => t.name.contains(query))
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])
    ).get();
  }

  // 取得二級地點列表
  Future<List<IncidentPlaceCategory2Data>> getIncidentLocation2s(int categoryId) {
    return (select(incidentPlaceCategory2)
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])
    ).get();
  }

  // 搜尋二級地點
  Future<List<IncidentPlaceCategory2Data>> searchIncidentLocation2s(String query, int? categoryId) {
    var stmt = select(incidentPlaceCategory2)
      ..where((t) => t.name.contains(query));
      
    if (categoryId != null) {
      stmt = stmt..where((t) => t.categoryId.equals(categoryId));
    }
      
    return (stmt..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }

  // 取得醫院列表
  Future<List<ReferralHospitalData>> getHospitals() {
    return (select(referralHospital)..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }
  
  // 搜尋醫院
  Future<List<ReferralHospitalData>> searchHospitals(String query) {
    return (select(referralHospital)
      ..where((t) => t.name.contains(query))
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])
    ).get();
  }
  
  // 取得相關 IncidentRecord
  Future<IncidentRecordData?> getIncidentRecordByMedicalId(int medicalId) {
    return (select(incidentRecord)..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }
  
  // 取得相關 ReferralForm
  Future<ReferralFormData?> getReferralFormByMedicalId(int medicalId) {
    return (select(referralForms)..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }

  // 取得相關 Treatment
  Future<TreatmentData?> getTreatmentByMedicalId(int medicalId) {
    return (select(treatment)..where((t) => t.medicalId.equals(medicalId))).getSingleOrNull();
  }
}
