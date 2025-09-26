import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Visits])
class VisitsDao extends DatabaseAccessor<AppDatabase> with _$VisitsDaoMixin {
  VisitsDao(AppDatabase db) : super(db);

  // 建立一筆主檔（回 visitId）
  Future<int> createVisit({String? patientName}) async {
    final id = await into(
      visits,
    ).insert(VisitsCompanion.insert(patientName: Value(patientName)));
    return id;
  }

  // HomePage 列表（可加 keyword 搜尋姓名/國籍/科別）
  Stream<List<Visit>> watchAll({String? keyword}) {
    final q = select(visits)..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)]);
    if (keyword != null && keyword.trim().isNotEmpty) {
      final like = '%${keyword.trim()}%';
      q.where(
        (t) =>
            t.patientName.like(like) |
            t.nationality.like(like) |
            t.dept.like(like),
      );
    }
    return q.watch();
  }

  // 回寫摘要（各分頁存檔時呼叫）
  Future<int> updateVisitSummary(
    int visitId, {
    String? patientName,
    String? gender,
    String? nationality,
    String? dept,
    String? note,
    String? filledBy,
    DateTime? uploadedAt, // 若要更新上傳時間
  }) {
    return (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      VisitsCompanion(
        patientName: patientName == null
            ? const Value.absent()
            : Value(patientName),
        gender: gender == null ? const Value.absent() : Value(gender),
        nationality: nationality == null
            ? const Value.absent()
            : Value(nationality),
        dept: dept == null ? const Value.absent() : Value(dept),
        note: note == null ? const Value.absent() : Value(note),
        filledBy: filledBy == null ? const Value.absent() : Value(filledBy),
        uploadedAt: uploadedAt == null
            ? const Value.absent()
            : Value(uploadedAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteVisit(int visitId) async {
    // 初期用手動刪子表（之後可改成 FK 級聯）
    await (delete(
      db.patientProfiles,
    )..where((t) => t.visitId.equals(visitId))).go();
    return (delete(visits)..where((t) => t.visitId.equals(visitId))).go();
  }

  Future<Visit?> getById(int visitId) => (select(
    visits,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();
}

@DriftAccessor(tables: [PatientProfiles, Visits])
class PatientProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$PatientProfilesDaoMixin {
  PatientProfilesDao(AppDatabase db) : super(db);

  // 抓本頁資料
  Future<PatientProfile?> getByVisitId(int visitId) => (select(
    patientProfiles,
  )..where((t) => t.visitId.equals(visitId))).getSingleOrNull();

  // 儲存（沒有就 insert，有就 update），並順便回寫 Visits 摘要
  Future<void> upsertByVisitId({
    required int visitId,
    DateTime? birthday,
    String? gender,
    String? reason,
    String? nationality,
    String? idNumber,
    String? address,
    String? phone,
    String? photoPath,
  }) async {
    final existing = await getByVisitId(visitId);
    final now = DateTime.now();

    if (existing == null) {
      await into(patientProfiles).insert(
        PatientProfilesCompanion.insert(
          visitId: visitId,
          birthday: Value(birthday),
          gender: Value(gender),
          reason: Value(reason),
          nationality: Value(nationality),
          idNumber: Value(idNumber),
          address: Value(address),
          phone: Value(phone),
          photoPath: Value(photoPath),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(
        patientProfiles,
      )..where((t) => t.visitId.equals(visitId))).write(
        PatientProfilesCompanion(
          birthday: Value(birthday),
          gender: Value(gender),
          reason: Value(reason),
          nationality: Value(nationality),
          idNumber: Value(idNumber),
          address: Value(address),
          phone: Value(phone),
          photoPath: Value(photoPath),
          updatedAt: Value(now),
        ),
      );
    }

    // 回寫 HomePage 列表所需摘要
    await (update(visits)..where((t) => t.visitId.equals(visitId))).write(
      VisitsCompanion(
        gender: gender == null ? const Value.absent() : Value(gender),
        nationality: nationality == null
            ? const Value.absent()
            : Value(nationality),
        uploadedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
