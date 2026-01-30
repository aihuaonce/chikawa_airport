import 'package:drift/drift.dart';

@DataClassName('Icd10CodeData')
class Icd10Code extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameCh => text()();
  BoolColumn get isLeaf => boolean()();

  @override
  List<String> get customConstraints => [
        'UNIQUE (code)',
      ];
}
