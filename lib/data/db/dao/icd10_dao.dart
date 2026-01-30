import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/icd10_tables.dart';

part 'icd10_dao.g.dart';

@DriftAccessor(tables: [Icd10Code])
class Icd10Dao extends DatabaseAccessor<AppDatabase> with _$Icd10DaoMixin {
  Icd10Dao(super.db);

  Future<List<Icd10CodeData>> search(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return (select(icd10Code)
          ..where(
            (c) =>
                c.code.like('%$lowercaseQuery%') |
                c.nameCh.like('%$query%') |
                c.nameEn.like('%$lowercaseQuery%'),
          )
          ..limit(20))
        .get();
  }

  Future<int> getCount() async {
    final countExpr = icd10Code.id.count();
    final query = selectOnly(icd10Code)..addColumns([countExpr]);
    final result = await query.getSingle();
    return result.read(countExpr) ?? 0;
  }

  Future<void> insertBatch(List<Icd10CodeCompanion> data) async {
    await batch((batch) {
      batch.insertAll(icd10Code, data);
    });
  }
}
