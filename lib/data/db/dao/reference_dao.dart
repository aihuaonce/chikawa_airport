import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/reference_tables.dart';

part 'reference_dao.g.dart';

@DriftAccessor(tables: [Sex, Nationality])
class ReferenceDao extends DatabaseAccessor<AppDatabase>
    with _$ReferenceDaoMixin {
  ReferenceDao(super.db);

  // ========== 性別相關 ==========

  /// 取得所有性別選項
  Future<List<SexData>> getAllSex() {
    return select(sex).get();
  }

  /// 根據 ID 取得性別
  Future<SexData?> getSexById(int id) {
    return (select(sex)..where((s) => s.sexId.equals(id))).getSingleOrNull();
  }

  /// 新增性別
  Future<int> addSex(String name) {
    return into(sex).insert(SexCompanion.insert(name: name));
  }

  /// 更新性別
  Future<int> updateSex(int id, String name) {
    return (update(
      sex,
    )..where((s) => s.sexId.equals(id))).write(SexCompanion(name: Value(name)));
  }

  /// 刪除性別
  Future<int> deleteSex(int id) {
    return (delete(sex)..where((s) => s.sexId.equals(id))).go();
  }

  // ========== 國籍相關 ==========

  /// 取得所有國籍選項
  Future<List<NationalityData>> getAllNationality() {
    return (select(
      nationality,
    )..orderBy([(n) => OrderingTerm.asc(n.name)])).get();
  }

  /// 根據 ID 取得國籍
  Future<NationalityData?> getNationalityById(int id) {
    return (select(
      nationality,
    )..where((n) => n.nationalityId.equals(id))).getSingleOrNull();
  }

  /// 根據代碼取得國籍
  Future<NationalityData?> getNationalityByCode(String code) {
    return (select(
      nationality,
    )..where((n) => n.code.equals(code))).getSingleOrNull();
  }

  /// 搜尋國籍 (模糊搜尋名稱)
  Future<List<NationalityData>> searchNationality(String keyword) {
    return (select(nationality)
          ..where((n) => n.name.like('%$keyword%'))
          ..orderBy([(n) => OrderingTerm.asc(n.name)]))
        .get();
  }

  /// 新增國籍
  Future<int> addNationality({required String name, String? code}) {
    return into(
      nationality,
    ).insert(NationalityCompanion.insert(name: name, code: Value(code)));
  }

  /// 批次新增國籍
  Future<void> addNationalityBatch(List<Map<String, String>> nationalityList) {
    return batch((batch) {
      batch.insertAll(
        nationality,
        nationalityList.map(
          (item) => NationalityCompanion.insert(
            name: item['name']!,
            code: Value(item['code']),
          ),
        ),
      );
    });
  }

  /// 更新國籍
  Future<int> updateNationality({required int id, String? name, String? code}) {
    return (update(
      nationality,
    )..where((n) => n.nationalityId.equals(id))).write(
      NationalityCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        code: code != null ? Value(code) : const Value.absent(),
      ),
    );
  }

  /// 刪除國籍
  Future<int> deleteNationality(int id) {
    return (delete(nationality)..where((n) => n.nationalityId.equals(id))).go();
  }

  // ========== 初始化參考資料 ==========

  /// 初始化所有參考資料
  Future<void> initializeAllReferenceData() async {
    await initializeSex();
    await initializeNationality();
  }

  /// 初始化性別資料
  Future<void> initializeSex() async {
    final count = await (select(sex).get()).then((list) => list.length);
    if (count == 0) {
      await batch((batch) {
        batch.insertAll(sex, [
          SexCompanion.insert(name: 'Male'),
          SexCompanion.insert(name: 'Female'),
          SexCompanion.insert(name: 'Other'),
        ]);
      });
    }
  }

  /// 初始化國籍資料
  Future<void> initializeNationality() async {
    final count = await (select(nationality).get()).then((list) => list.length);
    if (count == 0) {
      await addNationalityBatch([
        {'name': 'Taiwan', 'code': 'TW'},
        {'name': 'China', 'code': 'CN'},
        {'name': 'Hong Kong', 'code': 'HK'},
        {'name': 'Macau', 'code': 'MO'},
        {'name': 'Japan', 'code': 'JP'},
        {'name': 'South Korea', 'code': 'KR'},
        {'name': 'United States', 'code': 'US'},
        {'name': 'United Kingdom', 'code': 'GB'},
        {'name': 'Canada', 'code': 'CA'},
        {'name': 'Australia', 'code': 'AU'},
        {'name': 'Singapore', 'code': 'SG'},
        {'name': 'Malaysia', 'code': 'MY'},
        {'name': 'Thailand', 'code': 'TH'},
        {'name': 'Vietnam', 'code': 'VN'},
        {'name': 'Philippines', 'code': 'PH'},
        {'name': 'Indonesia', 'code': 'ID'},
        {'name': 'India', 'code': 'IN'},
        {'name': 'France', 'code': 'FR'},
        {'name': 'Germany', 'code': 'DE'},
        {'name': 'Italy', 'code': 'IT'},
        {'name': 'Spain', 'code': 'ES'},
        {'name': 'Netherlands', 'code': 'NL'},
        {'name': 'Switzerland', 'code': 'CH'},
        {'name': 'New Zealand', 'code': 'NZ'},
        {'name': 'Brazil', 'code': 'BR'},
      ]);
    }
  }

  // ========== 統計相關 ==========

  /// 取得參考表統計資訊
  Future<ReferenceStatistics> getStatistics() async {
    final sexCount = await (select(sex).get()).then((list) => list.length);
    final nationalityCount = await (select(
      nationality,
    ).get()).then((list) => list.length);

    return ReferenceStatistics(
      sexCount: sexCount,
      nationalityCount: nationalityCount,
    );
  }

  /// 檢查參考資料是否已初始化
  Future<bool> isInitialized() async {
    final stats = await getStatistics();
    return stats.sexCount > 0 && stats.nationalityCount > 0;
  }
}

// ========== 資料模型 ==========

/// 參考表統計資訊
class ReferenceStatistics {
  final int sexCount;
  final int nationalityCount;

  ReferenceStatistics({required this.sexCount, required this.nationalityCount});

  @override
  String toString() {
    return 'ReferenceStatistics('
        'sex: $sexCount, '
        'nationality: $nationalityCount, '
        ')';
  }
}
