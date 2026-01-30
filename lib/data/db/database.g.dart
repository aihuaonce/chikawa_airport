// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SexTable extends Sex with TableInfo<$SexTable, SexData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SexTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sexIdMeta = const VerificationMeta('sexId');
  @override
  late final GeneratedColumn<int> sexId = GeneratedColumn<int>(
    'sex_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sexId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sex';
  @override
  VerificationContext validateIntegrity(
    Insertable<SexData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sex_id')) {
      context.handle(
        _sexIdMeta,
        sexId.isAcceptableOrUnknown(data['sex_id']!, _sexIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sexId};
  @override
  SexData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SexData(
      sexId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sex_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $SexTable createAlias(String alias) {
    return $SexTable(attachedDatabase, alias);
  }
}

class SexData extends DataClass implements Insertable<SexData> {
  final int sexId;
  final String name;
  const SexData({required this.sexId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sex_id'] = Variable<int>(sexId);
    map['name'] = Variable<String>(name);
    return map;
  }

  SexCompanion toCompanion(bool nullToAbsent) {
    return SexCompanion(sexId: Value(sexId), name: Value(name));
  }

  factory SexData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SexData(
      sexId: serializer.fromJson<int>(json['sexId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sexId': serializer.toJson<int>(sexId),
      'name': serializer.toJson<String>(name),
    };
  }

  SexData copyWith({int? sexId, String? name}) =>
      SexData(sexId: sexId ?? this.sexId, name: name ?? this.name);
  SexData copyWithCompanion(SexCompanion data) {
    return SexData(
      sexId: data.sexId.present ? data.sexId.value : this.sexId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SexData(')
          ..write('sexId: $sexId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sexId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SexData &&
          other.sexId == this.sexId &&
          other.name == this.name);
}

class SexCompanion extends UpdateCompanion<SexData> {
  final Value<int> sexId;
  final Value<String> name;
  const SexCompanion({
    this.sexId = const Value.absent(),
    this.name = const Value.absent(),
  });
  SexCompanion.insert({this.sexId = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<SexData> custom({
    Expression<int>? sexId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (sexId != null) 'sex_id': sexId,
      if (name != null) 'name': name,
    });
  }

  SexCompanion copyWith({Value<int>? sexId, Value<String>? name}) {
    return SexCompanion(sexId: sexId ?? this.sexId, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sexId.present) {
      map['sex_id'] = Variable<int>(sexId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SexCompanion(')
          ..write('sexId: $sexId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $NationalityTable extends Nationality
    with TableInfo<$NationalityTable, NationalityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NationalityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nationalityIdMeta = const VerificationMeta(
    'nationalityId',
  );
  @override
  late final GeneratedColumn<int> nationalityId = GeneratedColumn<int>(
    'nationality_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [nationalityId, name, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nationality';
  @override
  VerificationContext validateIntegrity(
    Insertable<NationalityData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('nationality_id')) {
      context.handle(
        _nationalityIdMeta,
        nationalityId.isAcceptableOrUnknown(
          data['nationality_id']!,
          _nationalityIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {nationalityId};
  @override
  NationalityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NationalityData(
      nationalityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nationality_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
    );
  }

  @override
  $NationalityTable createAlias(String alias) {
    return $NationalityTable(attachedDatabase, alias);
  }
}

class NationalityData extends DataClass implements Insertable<NationalityData> {
  final int nationalityId;
  final String name;
  final String? nameEn;
  const NationalityData({
    required this.nationalityId,
    required this.name,
    this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['nationality_id'] = Variable<int>(nationalityId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    return map;
  }

  NationalityCompanion toCompanion(bool nullToAbsent) {
    return NationalityCompanion(
      nationalityId: Value(nationalityId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
    );
  }

  factory NationalityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NationalityData(
      nationalityId: serializer.fromJson<int>(json['nationalityId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nationalityId': serializer.toJson<int>(nationalityId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
    };
  }

  NationalityData copyWith({
    int? nationalityId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
  }) => NationalityData(
    nationalityId: nationalityId ?? this.nationalityId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
  );
  NationalityData copyWithCompanion(NationalityCompanion data) {
    return NationalityData(
      nationalityId: data.nationalityId.present
          ? data.nationalityId.value
          : this.nationalityId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NationalityData(')
          ..write('nationalityId: $nationalityId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(nationalityId, name, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NationalityData &&
          other.nationalityId == this.nationalityId &&
          other.name == this.name &&
          other.nameEn == this.nameEn);
}

class NationalityCompanion extends UpdateCompanion<NationalityData> {
  final Value<int> nationalityId;
  final Value<String> name;
  final Value<String?> nameEn;
  const NationalityCompanion({
    this.nationalityId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  NationalityCompanion.insert({
    this.nationalityId = const Value.absent(),
    required String name,
    this.nameEn = const Value.absent(),
  }) : name = Value(name);
  static Insertable<NationalityData> custom({
    Expression<int>? nationalityId,
    Expression<String>? name,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (nationalityId != null) 'nationality_id': nationalityId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  NationalityCompanion copyWith({
    Value<int>? nationalityId,
    Value<String>? name,
    Value<String?>? nameEn,
  }) {
    return NationalityCompanion(
      nationalityId: nationalityId ?? this.nationalityId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nationalityId.present) {
      map['nationality_id'] = Variable<int>(nationalityId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NationalityCompanion(')
          ..write('nationalityId: $nationalityId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $AirlineTable extends Airline with TableInfo<$AirlineTable, AirlineData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AirlineTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _airlineIdMeta = const VerificationMeta(
    'airlineId',
  );
  @override
  late final GeneratedColumn<int> airlineId = GeneratedColumn<int>(
    'airline_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [airlineId, code, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'airline';
  @override
  VerificationContext validateIntegrity(
    Insertable<AirlineData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('airline_id')) {
      context.handle(
        _airlineIdMeta,
        airlineId.isAcceptableOrUnknown(data['airline_id']!, _airlineIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {airlineId};
  @override
  AirlineData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AirlineData(
      airlineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}airline_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $AirlineTable createAlias(String alias) {
    return $AirlineTable(attachedDatabase, alias);
  }
}

class AirlineData extends DataClass implements Insertable<AirlineData> {
  final int airlineId;
  final String code;
  final String name;
  const AirlineData({
    required this.airlineId,
    required this.code,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['airline_id'] = Variable<int>(airlineId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    return map;
  }

  AirlineCompanion toCompanion(bool nullToAbsent) {
    return AirlineCompanion(
      airlineId: Value(airlineId),
      code: Value(code),
      name: Value(name),
    );
  }

  factory AirlineData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AirlineData(
      airlineId: serializer.fromJson<int>(json['airlineId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'airlineId': serializer.toJson<int>(airlineId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
    };
  }

  AirlineData copyWith({int? airlineId, String? code, String? name}) =>
      AirlineData(
        airlineId: airlineId ?? this.airlineId,
        code: code ?? this.code,
        name: name ?? this.name,
      );
  AirlineData copyWithCompanion(AirlineCompanion data) {
    return AirlineData(
      airlineId: data.airlineId.present ? data.airlineId.value : this.airlineId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AirlineData(')
          ..write('airlineId: $airlineId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(airlineId, code, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AirlineData &&
          other.airlineId == this.airlineId &&
          other.code == this.code &&
          other.name == this.name);
}

class AirlineCompanion extends UpdateCompanion<AirlineData> {
  final Value<int> airlineId;
  final Value<String> code;
  final Value<String> name;
  const AirlineCompanion({
    this.airlineId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
  });
  AirlineCompanion.insert({
    this.airlineId = const Value.absent(),
    required String code,
    required String name,
  }) : code = Value(code),
       name = Value(name);
  static Insertable<AirlineData> custom({
    Expression<int>? airlineId,
    Expression<String>? code,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (airlineId != null) 'airline_id': airlineId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
    });
  }

  AirlineCompanion copyWith({
    Value<int>? airlineId,
    Value<String>? code,
    Value<String>? name,
  }) {
    return AirlineCompanion(
      airlineId: airlineId ?? this.airlineId,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (airlineId.present) {
      map['airline_id'] = Variable<int>(airlineId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AirlineCompanion(')
          ..write('airlineId: $airlineId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $TravelStatusTable extends TravelStatus
    with TableInfo<$TravelStatusTable, TravelStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TravelStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _travelStatusIdMeta = const VerificationMeta(
    'travelStatusId',
  );
  @override
  late final GeneratedColumn<int> travelStatusId = GeneratedColumn<int>(
    'travel_status_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [travelStatusId, code, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'travel_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<TravelStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('travel_status_id')) {
      context.handle(
        _travelStatusIdMeta,
        travelStatusId.isAcceptableOrUnknown(
          data['travel_status_id']!,
          _travelStatusIdMeta,
        ),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {travelStatusId};
  @override
  TravelStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TravelStatusData(
      travelStatusId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travel_status_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TravelStatusTable createAlias(String alias) {
    return $TravelStatusTable(attachedDatabase, alias);
  }
}

class TravelStatusData extends DataClass
    implements Insertable<TravelStatusData> {
  final int travelStatusId;
  final String code;
  final String name;
  const TravelStatusData({
    required this.travelStatusId,
    required this.code,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['travel_status_id'] = Variable<int>(travelStatusId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    return map;
  }

  TravelStatusCompanion toCompanion(bool nullToAbsent) {
    return TravelStatusCompanion(
      travelStatusId: Value(travelStatusId),
      code: Value(code),
      name: Value(name),
    );
  }

  factory TravelStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TravelStatusData(
      travelStatusId: serializer.fromJson<int>(json['travelStatusId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'travelStatusId': serializer.toJson<int>(travelStatusId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
    };
  }

  TravelStatusData copyWith({
    int? travelStatusId,
    String? code,
    String? name,
  }) => TravelStatusData(
    travelStatusId: travelStatusId ?? this.travelStatusId,
    code: code ?? this.code,
    name: name ?? this.name,
  );
  TravelStatusData copyWithCompanion(TravelStatusCompanion data) {
    return TravelStatusData(
      travelStatusId: data.travelStatusId.present
          ? data.travelStatusId.value
          : this.travelStatusId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TravelStatusData(')
          ..write('travelStatusId: $travelStatusId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(travelStatusId, code, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TravelStatusData &&
          other.travelStatusId == this.travelStatusId &&
          other.code == this.code &&
          other.name == this.name);
}

class TravelStatusCompanion extends UpdateCompanion<TravelStatusData> {
  final Value<int> travelStatusId;
  final Value<String> code;
  final Value<String> name;
  const TravelStatusCompanion({
    this.travelStatusId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
  });
  TravelStatusCompanion.insert({
    this.travelStatusId = const Value.absent(),
    required String code,
    required String name,
  }) : code = Value(code),
       name = Value(name);
  static Insertable<TravelStatusData> custom({
    Expression<int>? travelStatusId,
    Expression<String>? code,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (travelStatusId != null) 'travel_status_id': travelStatusId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
    });
  }

  TravelStatusCompanion copyWith({
    Value<int>? travelStatusId,
    Value<String>? code,
    Value<String>? name,
  }) {
    return TravelStatusCompanion(
      travelStatusId: travelStatusId ?? this.travelStatusId,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (travelStatusId.present) {
      map['travel_status_id'] = Variable<int>(travelStatusId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TravelStatusCompanion(')
          ..write('travelStatusId: $travelStatusId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $LocationTable extends Location
    with TableInfo<$LocationTable, LocationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [locationId, code, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'location';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {locationId};
  @override
  LocationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationData(
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $LocationTable createAlias(String alias) {
    return $LocationTable(attachedDatabase, alias);
  }
}

class LocationData extends DataClass implements Insertable<LocationData> {
  final int locationId;
  final String code;
  final String name;
  const LocationData({
    required this.locationId,
    required this.code,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['location_id'] = Variable<int>(locationId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    return map;
  }

  LocationCompanion toCompanion(bool nullToAbsent) {
    return LocationCompanion(
      locationId: Value(locationId),
      code: Value(code),
      name: Value(name),
    );
  }

  factory LocationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationData(
      locationId: serializer.fromJson<int>(json['locationId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'locationId': serializer.toJson<int>(locationId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
    };
  }

  LocationData copyWith({int? locationId, String? code, String? name}) =>
      LocationData(
        locationId: locationId ?? this.locationId,
        code: code ?? this.code,
        name: name ?? this.name,
      );
  LocationData copyWithCompanion(LocationCompanion data) {
    return LocationData(
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationData(')
          ..write('locationId: $locationId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(locationId, code, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationData &&
          other.locationId == this.locationId &&
          other.code == this.code &&
          other.name == this.name);
}

class LocationCompanion extends UpdateCompanion<LocationData> {
  final Value<int> locationId;
  final Value<String> code;
  final Value<String> name;
  const LocationCompanion({
    this.locationId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
  });
  LocationCompanion.insert({
    this.locationId = const Value.absent(),
    required String code,
    required String name,
  }) : code = Value(code),
       name = Value(name);
  static Insertable<LocationData> custom({
    Expression<int>? locationId,
    Expression<String>? code,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (locationId != null) 'location_id': locationId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
    });
  }

  LocationCompanion copyWith({
    Value<int>? locationId,
    Value<String>? code,
    Value<String>? name,
  }) {
    return LocationCompanion(
      locationId: locationId ?? this.locationId,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationCompanion(')
          ..write('locationId: $locationId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $IncidentPlaceCategoryTable extends IncidentPlaceCategory
    with TableInfo<$IncidentPlaceCategoryTable, IncidentPlaceCategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidentPlaceCategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incident_place_category';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncidentPlaceCategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncidentPlaceCategoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncidentPlaceCategoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $IncidentPlaceCategoryTable createAlias(String alias) {
    return $IncidentPlaceCategoryTable(attachedDatabase, alias);
  }
}

class IncidentPlaceCategoryData extends DataClass
    implements Insertable<IncidentPlaceCategoryData> {
  final int id;
  final String name;
  final int sortOrder;
  final bool isActive;
  const IncidentPlaceCategoryData({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  IncidentPlaceCategoryCompanion toCompanion(bool nullToAbsent) {
    return IncidentPlaceCategoryCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory IncidentPlaceCategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncidentPlaceCategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  IncidentPlaceCategoryData copyWith({
    int? id,
    String? name,
    int? sortOrder,
    bool? isActive,
  }) => IncidentPlaceCategoryData(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  IncidentPlaceCategoryData copyWithCompanion(
    IncidentPlaceCategoryCompanion data,
  ) {
    return IncidentPlaceCategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncidentPlaceCategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncidentPlaceCategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class IncidentPlaceCategoryCompanion
    extends UpdateCompanion<IncidentPlaceCategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const IncidentPlaceCategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  IncidentPlaceCategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<IncidentPlaceCategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  IncidentPlaceCategoryCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return IncidentPlaceCategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentPlaceCategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $IncidentPlaceCategory2Table extends IncidentPlaceCategory2
    with TableInfo<$IncidentPlaceCategory2Table, IncidentPlaceCategory2Data> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidentPlaceCategory2Table(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES incident_place_category (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    name,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incident_place_category2';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncidentPlaceCategory2Data> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncidentPlaceCategory2Data map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncidentPlaceCategory2Data(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $IncidentPlaceCategory2Table createAlias(String alias) {
    return $IncidentPlaceCategory2Table(attachedDatabase, alias);
  }
}

class IncidentPlaceCategory2Data extends DataClass
    implements Insertable<IncidentPlaceCategory2Data> {
  final int id;
  final int categoryId;
  final String name;
  final int sortOrder;
  final bool isActive;
  const IncidentPlaceCategory2Data({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  IncidentPlaceCategory2Companion toCompanion(bool nullToAbsent) {
    return IncidentPlaceCategory2Companion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory IncidentPlaceCategory2Data.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncidentPlaceCategory2Data(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  IncidentPlaceCategory2Data copyWith({
    int? id,
    int? categoryId,
    String? name,
    int? sortOrder,
    bool? isActive,
  }) => IncidentPlaceCategory2Data(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  IncidentPlaceCategory2Data copyWithCompanion(
    IncidentPlaceCategory2Companion data,
  ) {
    return IncidentPlaceCategory2Data(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncidentPlaceCategory2Data(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncidentPlaceCategory2Data &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class IncidentPlaceCategory2Companion
    extends UpdateCompanion<IncidentPlaceCategory2Data> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const IncidentPlaceCategory2Companion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  IncidentPlaceCategory2Companion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : categoryId = Value(categoryId),
       name = Value(name);
  static Insertable<IncidentPlaceCategory2Data> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  IncidentPlaceCategory2Companion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return IncidentPlaceCategory2Companion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentPlaceCategory2Companion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ReportingUnitTable extends ReportingUnit
    with TableInfo<$ReportingUnitTable, ReportingUnitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportingUnitTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reporting_unit';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportingUnitData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportingUnitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportingUnitData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ReportingUnitTable createAlias(String alias) {
    return $ReportingUnitTable(attachedDatabase, alias);
  }
}

class ReportingUnitData extends DataClass
    implements Insertable<ReportingUnitData> {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  const ReportingUnitData({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ReportingUnitCompanion toCompanion(bool nullToAbsent) {
    return ReportingUnitCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
    );
  }

  factory ReportingUnitData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportingUnitData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ReportingUnitData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isActive,
  }) => ReportingUnitData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
  );
  ReportingUnitData copyWithCompanion(ReportingUnitCompanion data) {
    return ReportingUnitData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportingUnitData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportingUnitData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isActive == this.isActive);
}

class ReportingUnitCompanion extends UpdateCompanion<ReportingUnitData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isActive;
  const ReportingUnitCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ReportingUnitCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ReportingUnitData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ReportingUnitCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isActive,
  }) {
    return ReportingUnitCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportingUnitCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ChiefComplaintTypeTable extends ChiefComplaintType
    with TableInfo<$ChiefComplaintTypeTable, ChiefComplaintTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChiefComplaintTypeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chief_complaint_type';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChiefComplaintTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChiefComplaintTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChiefComplaintTypeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ChiefComplaintTypeTable createAlias(String alias) {
    return $ChiefComplaintTypeTable(attachedDatabase, alias);
  }
}

class ChiefComplaintTypeData extends DataClass
    implements Insertable<ChiefComplaintTypeData> {
  final int id;
  final String code;
  final String name;
  final bool isActive;
  const ChiefComplaintTypeData({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ChiefComplaintTypeCompanion toCompanion(bool nullToAbsent) {
    return ChiefComplaintTypeCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      isActive: Value(isActive),
    );
  }

  factory ChiefComplaintTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChiefComplaintTypeData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ChiefComplaintTypeData copyWith({
    int? id,
    String? code,
    String? name,
    bool? isActive,
  }) => ChiefComplaintTypeData(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
  );
  ChiefComplaintTypeData copyWithCompanion(ChiefComplaintTypeCompanion data) {
    return ChiefComplaintTypeData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChiefComplaintTypeData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChiefComplaintTypeData &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class ChiefComplaintTypeCompanion
    extends UpdateCompanion<ChiefComplaintTypeData> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<bool> isActive;
  const ChiefComplaintTypeCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ChiefComplaintTypeCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.isActive = const Value.absent(),
  }) : code = Value(code),
       name = Value(name);
  static Insertable<ChiefComplaintTypeData> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ChiefComplaintTypeCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<bool>? isActive,
  }) {
    return ChiefComplaintTypeCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChiefComplaintTypeCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ChiefComplaintDetailTable extends ChiefComplaintDetail
    with TableInfo<$ChiefComplaintDetailTable, ChiefComplaintDetailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChiefComplaintDetailTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chiefComplaintTypeIdMeta =
      const VerificationMeta('chiefComplaintTypeId');
  @override
  late final GeneratedColumn<int> chiefComplaintTypeId = GeneratedColumn<int>(
    'chief_complaint_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chief_complaint_type (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chiefComplaintTypeId,
    name,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chief_complaint_detail';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChiefComplaintDetailData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chief_complaint_type_id')) {
      context.handle(
        _chiefComplaintTypeIdMeta,
        chiefComplaintTypeId.isAcceptableOrUnknown(
          data['chief_complaint_type_id']!,
          _chiefComplaintTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chiefComplaintTypeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChiefComplaintDetailData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChiefComplaintDetailData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chiefComplaintTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chief_complaint_type_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ChiefComplaintDetailTable createAlias(String alias) {
    return $ChiefComplaintDetailTable(attachedDatabase, alias);
  }
}

class ChiefComplaintDetailData extends DataClass
    implements Insertable<ChiefComplaintDetailData> {
  final int id;
  final int chiefComplaintTypeId;
  final String name;
  final int sortOrder;
  final bool isActive;
  const ChiefComplaintDetailData({
    required this.id,
    required this.chiefComplaintTypeId,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chief_complaint_type_id'] = Variable<int>(chiefComplaintTypeId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ChiefComplaintDetailCompanion toCompanion(bool nullToAbsent) {
    return ChiefComplaintDetailCompanion(
      id: Value(id),
      chiefComplaintTypeId: Value(chiefComplaintTypeId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory ChiefComplaintDetailData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChiefComplaintDetailData(
      id: serializer.fromJson<int>(json['id']),
      chiefComplaintTypeId: serializer.fromJson<int>(
        json['chiefComplaintTypeId'],
      ),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chiefComplaintTypeId': serializer.toJson<int>(chiefComplaintTypeId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ChiefComplaintDetailData copyWith({
    int? id,
    int? chiefComplaintTypeId,
    String? name,
    int? sortOrder,
    bool? isActive,
  }) => ChiefComplaintDetailData(
    id: id ?? this.id,
    chiefComplaintTypeId: chiefComplaintTypeId ?? this.chiefComplaintTypeId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  ChiefComplaintDetailData copyWithCompanion(
    ChiefComplaintDetailCompanion data,
  ) {
    return ChiefComplaintDetailData(
      id: data.id.present ? data.id.value : this.id,
      chiefComplaintTypeId: data.chiefComplaintTypeId.present
          ? data.chiefComplaintTypeId.value
          : this.chiefComplaintTypeId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChiefComplaintDetailData(')
          ..write('id: $id, ')
          ..write('chiefComplaintTypeId: $chiefComplaintTypeId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chiefComplaintTypeId, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChiefComplaintDetailData &&
          other.id == this.id &&
          other.chiefComplaintTypeId == this.chiefComplaintTypeId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class ChiefComplaintDetailCompanion
    extends UpdateCompanion<ChiefComplaintDetailData> {
  final Value<int> id;
  final Value<int> chiefComplaintTypeId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const ChiefComplaintDetailCompanion({
    this.id = const Value.absent(),
    this.chiefComplaintTypeId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ChiefComplaintDetailCompanion.insert({
    this.id = const Value.absent(),
    required int chiefComplaintTypeId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : chiefComplaintTypeId = Value(chiefComplaintTypeId),
       name = Value(name);
  static Insertable<ChiefComplaintDetailData> custom({
    Expression<int>? id,
    Expression<int>? chiefComplaintTypeId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chiefComplaintTypeId != null)
        'chief_complaint_type_id': chiefComplaintTypeId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ChiefComplaintDetailCompanion copyWith({
    Value<int>? id,
    Value<int>? chiefComplaintTypeId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return ChiefComplaintDetailCompanion(
      id: id ?? this.id,
      chiefComplaintTypeId: chiefComplaintTypeId ?? this.chiefComplaintTypeId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chiefComplaintTypeId.present) {
      map['chief_complaint_type_id'] = Variable<int>(
        chiefComplaintTypeId.value,
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChiefComplaintDetailCompanion(')
          ..write('id: $id, ')
          ..write('chiefComplaintTypeId: $chiefComplaintTypeId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $DiagnosisCategoryTable extends DiagnosisCategory
    with TableInfo<$DiagnosisCategoryTable, DiagnosisCategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosisCategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnosis_category';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiagnosisCategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiagnosisCategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiagnosisCategoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $DiagnosisCategoryTable createAlias(String alias) {
    return $DiagnosisCategoryTable(attachedDatabase, alias);
  }
}

class DiagnosisCategoryData extends DataClass
    implements Insertable<DiagnosisCategoryData> {
  final int id;
  final String name;
  final String? description;
  final int sortOrder;
  final bool isActive;
  const DiagnosisCategoryData({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DiagnosisCategoryCompanion toCompanion(bool nullToAbsent) {
    return DiagnosisCategoryCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory DiagnosisCategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiagnosisCategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  DiagnosisCategoryData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isActive,
  }) => DiagnosisCategoryData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  DiagnosisCategoryData copyWithCompanion(DiagnosisCategoryCompanion data) {
    return DiagnosisCategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosisCategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiagnosisCategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class DiagnosisCategoryCompanion
    extends UpdateCompanion<DiagnosisCategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const DiagnosisCategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  DiagnosisCategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DiagnosisCategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  DiagnosisCategoryCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return DiagnosisCategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosisCategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TriageLevelTable extends TriageLevel
    with TableInfo<$TriageLevelTable, TriageLevelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriageLevelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorCodeMeta = const VerificationMeta(
    'colorCode',
  );
  @override
  late final GeneratedColumn<String> colorCode = GeneratedColumn<String>(
    'color_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    name,
    colorCode,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'triage_level';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriageLevelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_code')) {
      context.handle(
        _colorCodeMeta,
        colorCode.isAcceptableOrUnknown(data['color_code']!, _colorCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_colorCodeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TriageLevelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriageLevelData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_code'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $TriageLevelTable createAlias(String alias) {
    return $TriageLevelTable(attachedDatabase, alias);
  }
}

class TriageLevelData extends DataClass implements Insertable<TriageLevelData> {
  final int id;
  final int level;
  final String name;
  final String colorCode;
  final String? description;
  const TriageLevelData({
    required this.id,
    required this.level,
    required this.name,
    required this.colorCode,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['name'] = Variable<String>(name);
    map['color_code'] = Variable<String>(colorCode);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TriageLevelCompanion toCompanion(bool nullToAbsent) {
    return TriageLevelCompanion(
      id: Value(id),
      level: Value(level),
      name: Value(name),
      colorCode: Value(colorCode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory TriageLevelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriageLevelData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      name: serializer.fromJson<String>(json['name']),
      colorCode: serializer.fromJson<String>(json['colorCode']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'name': serializer.toJson<String>(name),
      'colorCode': serializer.toJson<String>(colorCode),
      'description': serializer.toJson<String?>(description),
    };
  }

  TriageLevelData copyWith({
    int? id,
    int? level,
    String? name,
    String? colorCode,
    Value<String?> description = const Value.absent(),
  }) => TriageLevelData(
    id: id ?? this.id,
    level: level ?? this.level,
    name: name ?? this.name,
    colorCode: colorCode ?? this.colorCode,
    description: description.present ? description.value : this.description,
  );
  TriageLevelData copyWithCompanion(TriageLevelCompanion data) {
    return TriageLevelData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      name: data.name.present ? data.name.value : this.name,
      colorCode: data.colorCode.present ? data.colorCode.value : this.colorCode,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriageLevelData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('name: $name, ')
          ..write('colorCode: $colorCode, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, name, colorCode, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriageLevelData &&
          other.id == this.id &&
          other.level == this.level &&
          other.name == this.name &&
          other.colorCode == this.colorCode &&
          other.description == this.description);
}

class TriageLevelCompanion extends UpdateCompanion<TriageLevelData> {
  final Value<int> id;
  final Value<int> level;
  final Value<String> name;
  final Value<String> colorCode;
  final Value<String?> description;
  const TriageLevelCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.name = const Value.absent(),
    this.colorCode = const Value.absent(),
    this.description = const Value.absent(),
  });
  TriageLevelCompanion.insert({
    this.id = const Value.absent(),
    required int level,
    required String name,
    required String colorCode,
    this.description = const Value.absent(),
  }) : level = Value(level),
       name = Value(name),
       colorCode = Value(colorCode);
  static Insertable<TriageLevelData> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<String>? name,
    Expression<String>? colorCode,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (name != null) 'name': name,
      if (colorCode != null) 'color_code': colorCode,
      if (description != null) 'description': description,
    });
  }

  TriageLevelCompanion copyWith({
    Value<int>? id,
    Value<int>? level,
    Value<String>? name,
    Value<String>? colorCode,
    Value<String?>? description,
  }) {
    return TriageLevelCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorCode.present) {
      map['color_code'] = Variable<String>(colorCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TriageLevelCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('name: $name, ')
          ..write('colorCode: $colorCode, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $TreatmentOnSiteTable extends TreatmentOnSite
    with TableInfo<$TreatmentOnSiteTable, TreatmentOnSiteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentOnSiteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treatment_on_site';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreatmentOnSiteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreatmentOnSiteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreatmentOnSiteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TreatmentOnSiteTable createAlias(String alias) {
    return $TreatmentOnSiteTable(attachedDatabase, alias);
  }
}

class TreatmentOnSiteData extends DataClass
    implements Insertable<TreatmentOnSiteData> {
  final int id;
  final String name;
  final String? description;
  final int sortOrder;
  final bool isActive;
  const TreatmentOnSiteData({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TreatmentOnSiteCompanion toCompanion(bool nullToAbsent) {
    return TreatmentOnSiteCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory TreatmentOnSiteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreatmentOnSiteData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  TreatmentOnSiteData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isActive,
  }) => TreatmentOnSiteData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  TreatmentOnSiteData copyWithCompanion(TreatmentOnSiteCompanion data) {
    return TreatmentOnSiteData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentOnSiteData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreatmentOnSiteData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class TreatmentOnSiteCompanion extends UpdateCompanion<TreatmentOnSiteData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const TreatmentOnSiteCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  TreatmentOnSiteCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TreatmentOnSiteData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  TreatmentOnSiteCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return TreatmentOnSiteCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentOnSiteCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TreatmentResultTable extends TreatmentResult
    with TableInfo<$TreatmentResultTable, TreatmentResultData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentResultTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treatment_result';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreatmentResultData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreatmentResultData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreatmentResultData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TreatmentResultTable createAlias(String alias) {
    return $TreatmentResultTable(attachedDatabase, alias);
  }
}

class TreatmentResultData extends DataClass
    implements Insertable<TreatmentResultData> {
  final int id;
  final String name;
  final String? description;
  final int sortOrder;
  final bool isActive;
  const TreatmentResultData({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TreatmentResultCompanion toCompanion(bool nullToAbsent) {
    return TreatmentResultCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory TreatmentResultData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreatmentResultData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  TreatmentResultData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isActive,
  }) => TreatmentResultData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  TreatmentResultData copyWithCompanion(TreatmentResultCompanion data) {
    return TreatmentResultData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentResultData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreatmentResultData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class TreatmentResultCompanion extends UpdateCompanion<TreatmentResultData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const TreatmentResultCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  TreatmentResultCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TreatmentResultData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  TreatmentResultCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return TreatmentResultCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentResultCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ReferralHospitalTable extends ReferralHospital
    with TableInfo<$ReferralHospitalTable, ReferralHospitalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReferralHospitalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isOtherMeta = const VerificationMeta(
    'isOther',
  );
  @override
  late final GeneratedColumn<bool> isOther = GeneratedColumn<bool>(
    'is_other',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_other" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    phone,
    sortOrder,
    isOther,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'referral_hospital';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReferralHospitalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_other')) {
      context.handle(
        _isOtherMeta,
        isOther.isAcceptableOrUnknown(data['is_other']!, _isOtherMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReferralHospitalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReferralHospitalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isOther: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_other'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ReferralHospitalTable createAlias(String alias) {
    return $ReferralHospitalTable(attachedDatabase, alias);
  }
}

class ReferralHospitalData extends DataClass
    implements Insertable<ReferralHospitalData> {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final int sortOrder;
  final bool isOther;
  final bool isActive;
  const ReferralHospitalData({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    required this.sortOrder,
    required this.isOther,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_other'] = Variable<bool>(isOther);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ReferralHospitalCompanion toCompanion(bool nullToAbsent) {
    return ReferralHospitalCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      sortOrder: Value(sortOrder),
      isOther: Value(isOther),
      isActive: Value(isActive),
    );
  }

  factory ReferralHospitalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReferralHospitalData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isOther: serializer.fromJson<bool>(json['isOther']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isOther': serializer.toJson<bool>(isOther),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ReferralHospitalData copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    int? sortOrder,
    bool? isOther,
    bool? isActive,
  }) => ReferralHospitalData(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    sortOrder: sortOrder ?? this.sortOrder,
    isOther: isOther ?? this.isOther,
    isActive: isActive ?? this.isActive,
  );
  ReferralHospitalData copyWithCompanion(ReferralHospitalCompanion data) {
    return ReferralHospitalData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isOther: data.isOther.present ? data.isOther.value : this.isOther,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReferralHospitalData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isOther: $isOther, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, address, phone, sortOrder, isOther, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReferralHospitalData &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.sortOrder == this.sortOrder &&
          other.isOther == this.isOther &&
          other.isActive == this.isActive);
}

class ReferralHospitalCompanion extends UpdateCompanion<ReferralHospitalData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<int> sortOrder;
  final Value<bool> isOther;
  final Value<bool> isActive;
  const ReferralHospitalCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isOther = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ReferralHospitalCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isOther = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ReferralHospitalData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<int>? sortOrder,
    Expression<bool>? isOther,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isOther != null) 'is_other': isOther,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ReferralHospitalCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? phone,
    Value<int>? sortOrder,
    Value<bool>? isOther,
    Value<bool>? isActive,
  }) {
    return ReferralHospitalCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      sortOrder: sortOrder ?? this.sortOrder,
      isOther: isOther ?? this.isOther,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isOther.present) {
      map['is_other'] = Variable<bool>(isOther.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReferralHospitalCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isOther: $isOther, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ActionItemTable extends ActionItem
    with TableInfo<$ActionItemTable, ActionItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'action_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActionItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActionItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ActionItemTable createAlias(String alias) {
    return $ActionItemTable(attachedDatabase, alias);
  }
}

class ActionItemData extends DataClass implements Insertable<ActionItemData> {
  final int id;
  final String name;
  final int sortOrder;
  final bool isActive;
  const ActionItemData({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ActionItemCompanion toCompanion(bool nullToAbsent) {
    return ActionItemCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory ActionItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActionItemData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ActionItemData copyWith({
    int? id,
    String? name,
    int? sortOrder,
    bool? isActive,
  }) => ActionItemData(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  ActionItemData copyWithCompanion(ActionItemCompanion data) {
    return ActionItemData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActionItemData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionItemData &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class ActionItemCompanion extends UpdateCompanion<ActionItemData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const ActionItemCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ActionItemCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ActionItemData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ActionItemCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return ActionItemCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionItemCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MedicalStaffTable extends MedicalStaff
    with TableInfo<$MedicalStaffTable, MedicalStaffData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalStaffTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<Uint8List> signature = GeneratedColumn<Uint8List>(
    'signature',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    employeeId,
    role,
    department,
    phone,
    signature,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_staff';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalStaffData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalStaffData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalStaffData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}signature'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MedicalStaffTable createAlias(String alias) {
    return $MedicalStaffTable(attachedDatabase, alias);
  }
}

class MedicalStaffData extends DataClass
    implements Insertable<MedicalStaffData> {
  final int id;
  final String name;
  final String? employeeId;
  final String role;
  final String? department;
  final String? phone;
  final Uint8List? signature;
  final bool isActive;
  const MedicalStaffData({
    required this.id,
    required this.name,
    this.employeeId,
    required this.role,
    this.department,
    this.phone,
    this.signature,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || signature != null) {
      map['signature'] = Variable<Uint8List>(signature);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MedicalStaffCompanion toCompanion(bool nullToAbsent) {
    return MedicalStaffCompanion(
      id: Value(id),
      name: Value(name),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      role: Value(role),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      signature: signature == null && nullToAbsent
          ? const Value.absent()
          : Value(signature),
      isActive: Value(isActive),
    );
  }

  factory MedicalStaffData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalStaffData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      role: serializer.fromJson<String>(json['role']),
      department: serializer.fromJson<String?>(json['department']),
      phone: serializer.fromJson<String?>(json['phone']),
      signature: serializer.fromJson<Uint8List?>(json['signature']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'employeeId': serializer.toJson<String?>(employeeId),
      'role': serializer.toJson<String>(role),
      'department': serializer.toJson<String?>(department),
      'phone': serializer.toJson<String?>(phone),
      'signature': serializer.toJson<Uint8List?>(signature),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MedicalStaffData copyWith({
    int? id,
    String? name,
    Value<String?> employeeId = const Value.absent(),
    String? role,
    Value<String?> department = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<Uint8List?> signature = const Value.absent(),
    bool? isActive,
  }) => MedicalStaffData(
    id: id ?? this.id,
    name: name ?? this.name,
    employeeId: employeeId.present ? employeeId.value : this.employeeId,
    role: role ?? this.role,
    department: department.present ? department.value : this.department,
    phone: phone.present ? phone.value : this.phone,
    signature: signature.present ? signature.value : this.signature,
    isActive: isActive ?? this.isActive,
  );
  MedicalStaffData copyWithCompanion(MedicalStaffCompanion data) {
    return MedicalStaffData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      role: data.role.present ? data.role.value : this.role,
      department: data.department.present
          ? data.department.value
          : this.department,
      phone: data.phone.present ? data.phone.value : this.phone,
      signature: data.signature.present ? data.signature.value : this.signature,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalStaffData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('employeeId: $employeeId, ')
          ..write('role: $role, ')
          ..write('department: $department, ')
          ..write('phone: $phone, ')
          ..write('signature: $signature, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    employeeId,
    role,
    department,
    phone,
    $driftBlobEquality.hash(signature),
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalStaffData &&
          other.id == this.id &&
          other.name == this.name &&
          other.employeeId == this.employeeId &&
          other.role == this.role &&
          other.department == this.department &&
          other.phone == this.phone &&
          $driftBlobEquality.equals(other.signature, this.signature) &&
          other.isActive == this.isActive);
}

class MedicalStaffCompanion extends UpdateCompanion<MedicalStaffData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> employeeId;
  final Value<String> role;
  final Value<String?> department;
  final Value<String?> phone;
  final Value<Uint8List?> signature;
  final Value<bool> isActive;
  const MedicalStaffCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.role = const Value.absent(),
    this.department = const Value.absent(),
    this.phone = const Value.absent(),
    this.signature = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MedicalStaffCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.employeeId = const Value.absent(),
    required String role,
    this.department = const Value.absent(),
    this.phone = const Value.absent(),
    this.signature = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       role = Value(role);
  static Insertable<MedicalStaffData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? employeeId,
    Expression<String>? role,
    Expression<String>? department,
    Expression<String>? phone,
    Expression<Uint8List>? signature,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (employeeId != null) 'employee_id': employeeId,
      if (role != null) 'role': role,
      if (department != null) 'department': department,
      if (phone != null) 'phone': phone,
      if (signature != null) 'signature': signature,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MedicalStaffCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? employeeId,
    Value<String>? role,
    Value<String?>? department,
    Value<String?>? phone,
    Value<Uint8List?>? signature,
    Value<bool>? isActive,
  }) {
    return MedicalStaffCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      role: role ?? this.role,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      signature: signature ?? this.signature,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (signature.present) {
      map['signature'] = Variable<Uint8List>(signature.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalStaffCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('employeeId: $employeeId, ')
          ..write('role: $role, ')
          ..write('department: $department, ')
          ..write('phone: $phone, ')
          ..write('signature: $signature, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SpecialNoteRefTable extends SpecialNoteRef
    with TableInfo<$SpecialNoteRefTable, SpecialNoteRefData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpecialNoteRefTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'special_note_ref';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpecialNoteRefData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpecialNoteRefData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpecialNoteRefData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SpecialNoteRefTable createAlias(String alias) {
    return $SpecialNoteRefTable(attachedDatabase, alias);
  }
}

class SpecialNoteRefData extends DataClass
    implements Insertable<SpecialNoteRefData> {
  final int id;
  final String name;
  final int sortOrder;
  final bool isActive;
  const SpecialNoteRefData({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SpecialNoteRefCompanion toCompanion(bool nullToAbsent) {
    return SpecialNoteRefCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory SpecialNoteRefData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpecialNoteRefData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SpecialNoteRefData copyWith({
    int? id,
    String? name,
    int? sortOrder,
    bool? isActive,
  }) => SpecialNoteRefData(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  SpecialNoteRefData copyWithCompanion(SpecialNoteRefCompanion data) {
    return SpecialNoteRefData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpecialNoteRefData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpecialNoteRefData &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class SpecialNoteRefCompanion extends UpdateCompanion<SpecialNoteRefData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const SpecialNoteRefCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  SpecialNoteRefCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<SpecialNoteRefData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  SpecialNoteRefCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return SpecialNoteRefCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpecialNoteRefCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $NursingPhraseTable extends NursingPhrase
    with TableInfo<$NursingPhraseTable, NursingPhraseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NursingPhraseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nursing_phrase';
  @override
  VerificationContext validateIntegrity(
    Insertable<NursingPhraseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NursingPhraseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NursingPhraseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $NursingPhraseTable createAlias(String alias) {
    return $NursingPhraseTable(attachedDatabase, alias);
  }
}

class NursingPhraseData extends DataClass
    implements Insertable<NursingPhraseData> {
  final int id;
  final String title;
  final String content;
  final int sortOrder;
  final bool isActive;
  const NursingPhraseData({
    required this.id,
    required this.title,
    required this.content,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  NursingPhraseCompanion toCompanion(bool nullToAbsent) {
    return NursingPhraseCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory NursingPhraseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NursingPhraseData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  NursingPhraseData copyWith({
    int? id,
    String? title,
    String? content,
    int? sortOrder,
    bool? isActive,
  }) => NursingPhraseData(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  NursingPhraseData copyWithCompanion(NursingPhraseCompanion data) {
    return NursingPhraseData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NursingPhraseData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NursingPhraseData &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class NursingPhraseCompanion extends UpdateCompanion<NursingPhraseData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const NursingPhraseCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  NursingPhraseCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : title = Value(title),
       content = Value(content);
  static Insertable<NursingPhraseData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  NursingPhraseCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? content,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return NursingPhraseCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NursingPhraseCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MedicalRecordTable extends MedicalRecord
    with TableInfo<$MedicalRecordTable, MedicalRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalRecordTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _isEmergencyMeta = const VerificationMeta(
    'isEmergency',
  );
  @override
  late final GeneratedColumn<bool> isEmergency = GeneratedColumn<bool>(
    'is_emergency',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_emergency" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasAmbulanceMeta = const VerificationMeta(
    'hasAmbulance',
  );
  @override
  late final GeneratedColumn<bool> hasAmbulance = GeneratedColumn<bool>(
    'has_ambulance',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_ambulance" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cdcPassedMeta = const VerificationMeta(
    'cdcPassed',
  );
  @override
  late final GeneratedColumn<bool> cdcPassed = GeneratedColumn<bool>(
    'cdc_passed',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cdc_passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _screeningMethodMeta = const VerificationMeta(
    'screeningMethod',
  );
  @override
  late final GeneratedColumn<String> screeningMethod = GeneratedColumn<String>(
    'screening_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    medicalId,
    isEmergency,
    hasAmbulance,
    cdcPassed,
    screeningMethod,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    }
    if (data.containsKey('is_emergency')) {
      context.handle(
        _isEmergencyMeta,
        isEmergency.isAcceptableOrUnknown(
          data['is_emergency']!,
          _isEmergencyMeta,
        ),
      );
    }
    if (data.containsKey('has_ambulance')) {
      context.handle(
        _hasAmbulanceMeta,
        hasAmbulance.isAcceptableOrUnknown(
          data['has_ambulance']!,
          _hasAmbulanceMeta,
        ),
      );
    }
    if (data.containsKey('cdc_passed')) {
      context.handle(
        _cdcPassedMeta,
        cdcPassed.isAcceptableOrUnknown(data['cdc_passed']!, _cdcPassedMeta),
      );
    }
    if (data.containsKey('screening_method')) {
      context.handle(
        _screeningMethodMeta,
        screeningMethod.isAcceptableOrUnknown(
          data['screening_method']!,
          _screeningMethodMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicalId};
  @override
  MedicalRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalRecordData(
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      isEmergency: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_emergency'],
      )!,
      hasAmbulance: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_ambulance'],
      )!,
      cdcPassed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cdc_passed'],
      ),
      screeningMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}screening_method'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicalRecordTable createAlias(String alias) {
    return $MedicalRecordTable(attachedDatabase, alias);
  }
}

class MedicalRecordData extends DataClass
    implements Insertable<MedicalRecordData> {
  final int medicalId;
  final bool isEmergency;
  final bool hasAmbulance;
  final bool? cdcPassed;
  final String? screeningMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicalRecordData({
    required this.medicalId,
    required this.isEmergency,
    required this.hasAmbulance,
    this.cdcPassed,
    this.screeningMethod,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medical_id'] = Variable<int>(medicalId);
    map['is_emergency'] = Variable<bool>(isEmergency);
    map['has_ambulance'] = Variable<bool>(hasAmbulance);
    if (!nullToAbsent || cdcPassed != null) {
      map['cdc_passed'] = Variable<bool>(cdcPassed);
    }
    if (!nullToAbsent || screeningMethod != null) {
      map['screening_method'] = Variable<String>(screeningMethod);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalRecordCompanion toCompanion(bool nullToAbsent) {
    return MedicalRecordCompanion(
      medicalId: Value(medicalId),
      isEmergency: Value(isEmergency),
      hasAmbulance: Value(hasAmbulance),
      cdcPassed: cdcPassed == null && nullToAbsent
          ? const Value.absent()
          : Value(cdcPassed),
      screeningMethod: screeningMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(screeningMethod),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicalRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalRecordData(
      medicalId: serializer.fromJson<int>(json['medicalId']),
      isEmergency: serializer.fromJson<bool>(json['isEmergency']),
      hasAmbulance: serializer.fromJson<bool>(json['hasAmbulance']),
      cdcPassed: serializer.fromJson<bool?>(json['cdcPassed']),
      screeningMethod: serializer.fromJson<String?>(json['screeningMethod']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicalId': serializer.toJson<int>(medicalId),
      'isEmergency': serializer.toJson<bool>(isEmergency),
      'hasAmbulance': serializer.toJson<bool>(hasAmbulance),
      'cdcPassed': serializer.toJson<bool?>(cdcPassed),
      'screeningMethod': serializer.toJson<String?>(screeningMethod),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalRecordData copyWith({
    int? medicalId,
    bool? isEmergency,
    bool? hasAmbulance,
    Value<bool?> cdcPassed = const Value.absent(),
    Value<String?> screeningMethod = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicalRecordData(
    medicalId: medicalId ?? this.medicalId,
    isEmergency: isEmergency ?? this.isEmergency,
    hasAmbulance: hasAmbulance ?? this.hasAmbulance,
    cdcPassed: cdcPassed.present ? cdcPassed.value : this.cdcPassed,
    screeningMethod: screeningMethod.present
        ? screeningMethod.value
        : this.screeningMethod,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicalRecordData copyWithCompanion(MedicalRecordCompanion data) {
    return MedicalRecordData(
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      isEmergency: data.isEmergency.present
          ? data.isEmergency.value
          : this.isEmergency,
      hasAmbulance: data.hasAmbulance.present
          ? data.hasAmbulance.value
          : this.hasAmbulance,
      cdcPassed: data.cdcPassed.present ? data.cdcPassed.value : this.cdcPassed,
      screeningMethod: data.screeningMethod.present
          ? data.screeningMethod.value
          : this.screeningMethod,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecordData(')
          ..write('medicalId: $medicalId, ')
          ..write('isEmergency: $isEmergency, ')
          ..write('hasAmbulance: $hasAmbulance, ')
          ..write('cdcPassed: $cdcPassed, ')
          ..write('screeningMethod: $screeningMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    medicalId,
    isEmergency,
    hasAmbulance,
    cdcPassed,
    screeningMethod,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalRecordData &&
          other.medicalId == this.medicalId &&
          other.isEmergency == this.isEmergency &&
          other.hasAmbulance == this.hasAmbulance &&
          other.cdcPassed == this.cdcPassed &&
          other.screeningMethod == this.screeningMethod &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicalRecordCompanion extends UpdateCompanion<MedicalRecordData> {
  final Value<int> medicalId;
  final Value<bool> isEmergency;
  final Value<bool> hasAmbulance;
  final Value<bool?> cdcPassed;
  final Value<String?> screeningMethod;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MedicalRecordCompanion({
    this.medicalId = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.hasAmbulance = const Value.absent(),
    this.cdcPassed = const Value.absent(),
    this.screeningMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MedicalRecordCompanion.insert({
    this.medicalId = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.hasAmbulance = const Value.absent(),
    this.cdcPassed = const Value.absent(),
    this.screeningMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<MedicalRecordData> custom({
    Expression<int>? medicalId,
    Expression<bool>? isEmergency,
    Expression<bool>? hasAmbulance,
    Expression<bool>? cdcPassed,
    Expression<String>? screeningMethod,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (medicalId != null) 'medical_id': medicalId,
      if (isEmergency != null) 'is_emergency': isEmergency,
      if (hasAmbulance != null) 'has_ambulance': hasAmbulance,
      if (cdcPassed != null) 'cdc_passed': cdcPassed,
      if (screeningMethod != null) 'screening_method': screeningMethod,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MedicalRecordCompanion copyWith({
    Value<int>? medicalId,
    Value<bool>? isEmergency,
    Value<bool>? hasAmbulance,
    Value<bool?>? cdcPassed,
    Value<String?>? screeningMethod,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MedicalRecordCompanion(
      medicalId: medicalId ?? this.medicalId,
      isEmergency: isEmergency ?? this.isEmergency,
      hasAmbulance: hasAmbulance ?? this.hasAmbulance,
      cdcPassed: cdcPassed ?? this.cdcPassed,
      screeningMethod: screeningMethod ?? this.screeningMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (isEmergency.present) {
      map['is_emergency'] = Variable<bool>(isEmergency.value);
    }
    if (hasAmbulance.present) {
      map['has_ambulance'] = Variable<bool>(hasAmbulance.value);
    }
    if (cdcPassed.present) {
      map['cdc_passed'] = Variable<bool>(cdcPassed.value);
    }
    if (screeningMethod.present) {
      map['screening_method'] = Variable<String>(screeningMethod.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecordCompanion(')
          ..write('medicalId: $medicalId, ')
          ..write('isEmergency: $isEmergency, ')
          ..write('hasAmbulance: $hasAmbulance, ')
          ..write('cdcPassed: $cdcPassed, ')
          ..write('screeningMethod: $screeningMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PatientTable extends Patient with TableInfo<$PatientTable, PatientData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anonymizationNameMeta = const VerificationMeta(
    'anonymizationName',
  );
  @override
  late final GeneratedColumn<String> anonymizationName =
      GeneratedColumn<String>(
        'anonymization_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
    'birthday',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexIdMeta = const VerificationMeta('sexId');
  @override
  late final GeneratedColumn<int> sexId = GeneratedColumn<int>(
    'sex_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sex (sex_id)',
    ),
  );
  static const VerificationMeta _passportOrIdNoMeta = const VerificationMeta(
    'passportOrIdNo',
  );
  @override
  late final GeneratedColumn<String> passportOrIdNo = GeneratedColumn<String>(
    'passport_or_id_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationalityIdMeta = const VerificationMeta(
    'nationalityId',
  );
  @override
  late final GeneratedColumn<int> nationalityId = GeneratedColumn<int>(
    'nationality_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nationality (nationality_id)',
    ),
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    patientId,
    medicalId,
    name,
    anonymizationName,
    birthday,
    age,
    sexId,
    passportOrIdNo,
    nationalityId,
    telephone,
    address,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('anonymization_name')) {
      context.handle(
        _anonymizationNameMeta,
        anonymizationName.isAcceptableOrUnknown(
          data['anonymization_name']!,
          _anonymizationNameMeta,
        ),
      );
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('sex_id')) {
      context.handle(
        _sexIdMeta,
        sexId.isAcceptableOrUnknown(data['sex_id']!, _sexIdMeta),
      );
    }
    if (data.containsKey('passport_or_id_no')) {
      context.handle(
        _passportOrIdNoMeta,
        passportOrIdNo.isAcceptableOrUnknown(
          data['passport_or_id_no']!,
          _passportOrIdNoMeta,
        ),
      );
    }
    if (data.containsKey('nationality_id')) {
      context.handle(
        _nationalityIdMeta,
        nationalityId.isAcceptableOrUnknown(
          data['nationality_id']!,
          _nationalityIdMeta,
        ),
      );
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {patientId};
  @override
  PatientData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientData(
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      anonymizationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anonymization_name'],
      ),
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birthday'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      sexId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sex_id'],
      ),
      passportOrIdNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}passport_or_id_no'],
      ),
      nationalityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nationality_id'],
      ),
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PatientTable createAlias(String alias) {
    return $PatientTable(attachedDatabase, alias);
  }
}

class PatientData extends DataClass implements Insertable<PatientData> {
  final int patientId;
  final int medicalId;
  final String? name;
  final String? anonymizationName;
  final DateTime? birthday;
  final int? age;
  final int? sexId;
  final String? passportOrIdNo;
  final int? nationalityId;
  final String? telephone;
  final String? address;
  final DateTime createdAt;
  const PatientData({
    required this.patientId,
    required this.medicalId,
    this.name,
    this.anonymizationName,
    this.birthday,
    this.age,
    this.sexId,
    this.passportOrIdNo,
    this.nationalityId,
    this.telephone,
    this.address,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['patient_id'] = Variable<int>(patientId);
    map['medical_id'] = Variable<int>(medicalId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || anonymizationName != null) {
      map['anonymization_name'] = Variable<String>(anonymizationName);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || sexId != null) {
      map['sex_id'] = Variable<int>(sexId);
    }
    if (!nullToAbsent || passportOrIdNo != null) {
      map['passport_or_id_no'] = Variable<String>(passportOrIdNo);
    }
    if (!nullToAbsent || nationalityId != null) {
      map['nationality_id'] = Variable<int>(nationalityId);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PatientCompanion toCompanion(bool nullToAbsent) {
    return PatientCompanion(
      patientId: Value(patientId),
      medicalId: Value(medicalId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      anonymizationName: anonymizationName == null && nullToAbsent
          ? const Value.absent()
          : Value(anonymizationName),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      sexId: sexId == null && nullToAbsent
          ? const Value.absent()
          : Value(sexId),
      passportOrIdNo: passportOrIdNo == null && nullToAbsent
          ? const Value.absent()
          : Value(passportOrIdNo),
      nationalityId: nationalityId == null && nullToAbsent
          ? const Value.absent()
          : Value(nationalityId),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory PatientData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientData(
      patientId: serializer.fromJson<int>(json['patientId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      name: serializer.fromJson<String?>(json['name']),
      anonymizationName: serializer.fromJson<String?>(
        json['anonymizationName'],
      ),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      age: serializer.fromJson<int?>(json['age']),
      sexId: serializer.fromJson<int?>(json['sexId']),
      passportOrIdNo: serializer.fromJson<String?>(json['passportOrIdNo']),
      nationalityId: serializer.fromJson<int?>(json['nationalityId']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      address: serializer.fromJson<String?>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'patientId': serializer.toJson<int>(patientId),
      'medicalId': serializer.toJson<int>(medicalId),
      'name': serializer.toJson<String?>(name),
      'anonymizationName': serializer.toJson<String?>(anonymizationName),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'age': serializer.toJson<int?>(age),
      'sexId': serializer.toJson<int?>(sexId),
      'passportOrIdNo': serializer.toJson<String?>(passportOrIdNo),
      'nationalityId': serializer.toJson<int?>(nationalityId),
      'telephone': serializer.toJson<String?>(telephone),
      'address': serializer.toJson<String?>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PatientData copyWith({
    int? patientId,
    int? medicalId,
    Value<String?> name = const Value.absent(),
    Value<String?> anonymizationName = const Value.absent(),
    Value<DateTime?> birthday = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<int?> sexId = const Value.absent(),
    Value<String?> passportOrIdNo = const Value.absent(),
    Value<int?> nationalityId = const Value.absent(),
    Value<String?> telephone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    DateTime? createdAt,
  }) => PatientData(
    patientId: patientId ?? this.patientId,
    medicalId: medicalId ?? this.medicalId,
    name: name.present ? name.value : this.name,
    anonymizationName: anonymizationName.present
        ? anonymizationName.value
        : this.anonymizationName,
    birthday: birthday.present ? birthday.value : this.birthday,
    age: age.present ? age.value : this.age,
    sexId: sexId.present ? sexId.value : this.sexId,
    passportOrIdNo: passportOrIdNo.present
        ? passportOrIdNo.value
        : this.passportOrIdNo,
    nationalityId: nationalityId.present
        ? nationalityId.value
        : this.nationalityId,
    telephone: telephone.present ? telephone.value : this.telephone,
    address: address.present ? address.value : this.address,
    createdAt: createdAt ?? this.createdAt,
  );
  PatientData copyWithCompanion(PatientCompanion data) {
    return PatientData(
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      name: data.name.present ? data.name.value : this.name,
      anonymizationName: data.anonymizationName.present
          ? data.anonymizationName.value
          : this.anonymizationName,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      age: data.age.present ? data.age.value : this.age,
      sexId: data.sexId.present ? data.sexId.value : this.sexId,
      passportOrIdNo: data.passportOrIdNo.present
          ? data.passportOrIdNo.value
          : this.passportOrIdNo,
      nationalityId: data.nationalityId.present
          ? data.nationalityId.value
          : this.nationalityId,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientData(')
          ..write('patientId: $patientId, ')
          ..write('medicalId: $medicalId, ')
          ..write('name: $name, ')
          ..write('anonymizationName: $anonymizationName, ')
          ..write('birthday: $birthday, ')
          ..write('age: $age, ')
          ..write('sexId: $sexId, ')
          ..write('passportOrIdNo: $passportOrIdNo, ')
          ..write('nationalityId: $nationalityId, ')
          ..write('telephone: $telephone, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    patientId,
    medicalId,
    name,
    anonymizationName,
    birthday,
    age,
    sexId,
    passportOrIdNo,
    nationalityId,
    telephone,
    address,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientData &&
          other.patientId == this.patientId &&
          other.medicalId == this.medicalId &&
          other.name == this.name &&
          other.anonymizationName == this.anonymizationName &&
          other.birthday == this.birthday &&
          other.age == this.age &&
          other.sexId == this.sexId &&
          other.passportOrIdNo == this.passportOrIdNo &&
          other.nationalityId == this.nationalityId &&
          other.telephone == this.telephone &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class PatientCompanion extends UpdateCompanion<PatientData> {
  final Value<int> patientId;
  final Value<int> medicalId;
  final Value<String?> name;
  final Value<String?> anonymizationName;
  final Value<DateTime?> birthday;
  final Value<int?> age;
  final Value<int?> sexId;
  final Value<String?> passportOrIdNo;
  final Value<int?> nationalityId;
  final Value<String?> telephone;
  final Value<String?> address;
  final Value<DateTime> createdAt;
  const PatientCompanion({
    this.patientId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.name = const Value.absent(),
    this.anonymizationName = const Value.absent(),
    this.birthday = const Value.absent(),
    this.age = const Value.absent(),
    this.sexId = const Value.absent(),
    this.passportOrIdNo = const Value.absent(),
    this.nationalityId = const Value.absent(),
    this.telephone = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PatientCompanion.insert({
    this.patientId = const Value.absent(),
    required int medicalId,
    this.name = const Value.absent(),
    this.anonymizationName = const Value.absent(),
    this.birthday = const Value.absent(),
    this.age = const Value.absent(),
    this.sexId = const Value.absent(),
    this.passportOrIdNo = const Value.absent(),
    this.nationalityId = const Value.absent(),
    this.telephone = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId);
  static Insertable<PatientData> custom({
    Expression<int>? patientId,
    Expression<int>? medicalId,
    Expression<String>? name,
    Expression<String>? anonymizationName,
    Expression<DateTime>? birthday,
    Expression<int>? age,
    Expression<int>? sexId,
    Expression<String>? passportOrIdNo,
    Expression<int>? nationalityId,
    Expression<String>? telephone,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (patientId != null) 'patient_id': patientId,
      if (medicalId != null) 'medical_id': medicalId,
      if (name != null) 'name': name,
      if (anonymizationName != null) 'anonymization_name': anonymizationName,
      if (birthday != null) 'birthday': birthday,
      if (age != null) 'age': age,
      if (sexId != null) 'sex_id': sexId,
      if (passportOrIdNo != null) 'passport_or_id_no': passportOrIdNo,
      if (nationalityId != null) 'nationality_id': nationalityId,
      if (telephone != null) 'telephone': telephone,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PatientCompanion copyWith({
    Value<int>? patientId,
    Value<int>? medicalId,
    Value<String?>? name,
    Value<String?>? anonymizationName,
    Value<DateTime?>? birthday,
    Value<int?>? age,
    Value<int?>? sexId,
    Value<String?>? passportOrIdNo,
    Value<int?>? nationalityId,
    Value<String?>? telephone,
    Value<String?>? address,
    Value<DateTime>? createdAt,
  }) {
    return PatientCompanion(
      patientId: patientId ?? this.patientId,
      medicalId: medicalId ?? this.medicalId,
      name: name ?? this.name,
      anonymizationName: anonymizationName ?? this.anonymizationName,
      birthday: birthday ?? this.birthday,
      age: age ?? this.age,
      sexId: sexId ?? this.sexId,
      passportOrIdNo: passportOrIdNo ?? this.passportOrIdNo,
      nationalityId: nationalityId ?? this.nationalityId,
      telephone: telephone ?? this.telephone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (anonymizationName.present) {
      map['anonymization_name'] = Variable<String>(anonymizationName.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sexId.present) {
      map['sex_id'] = Variable<int>(sexId.value);
    }
    if (passportOrIdNo.present) {
      map['passport_or_id_no'] = Variable<String>(passportOrIdNo.value);
    }
    if (nationalityId.present) {
      map['nationality_id'] = Variable<int>(nationalityId.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientCompanion(')
          ..write('patientId: $patientId, ')
          ..write('medicalId: $medicalId, ')
          ..write('name: $name, ')
          ..write('anonymizationName: $anonymizationName, ')
          ..write('birthday: $birthday, ')
          ..write('age: $age, ')
          ..write('sexId: $sexId, ')
          ..write('passportOrIdNo: $passportOrIdNo, ')
          ..write('nationalityId: $nationalityId, ')
          ..write('telephone: $telephone, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FlightRecordTable extends FlightRecord
    with TableInfo<$FlightRecordTable, FlightRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightRecordTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _flightRecordIdMeta = const VerificationMeta(
    'flightRecordId',
  );
  @override
  late final GeneratedColumn<int> flightRecordId = GeneratedColumn<int>(
    'flight_record_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _airlineIdMeta = const VerificationMeta(
    'airlineId',
  );
  @override
  late final GeneratedColumn<int> airlineId = GeneratedColumn<int>(
    'airline_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES airline (airline_id)',
    ),
  );
  static const VerificationMeta _flightNumberMeta = const VerificationMeta(
    'flightNumber',
  );
  @override
  late final GeneratedColumn<String> flightNumber = GeneratedColumn<String>(
    'flight_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _travelStatusIdMeta = const VerificationMeta(
    'travelStatusId',
  );
  @override
  late final GeneratedColumn<int> travelStatusId = GeneratedColumn<int>(
    'travel_status_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES travel_status (travel_status_id)',
    ),
  );
  static const VerificationMeta _departureLocationIdMeta =
      const VerificationMeta('departureLocationId');
  @override
  late final GeneratedColumn<int> departureLocationId = GeneratedColumn<int>(
    'departure_location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES location (location_id)',
    ),
  );
  static const VerificationMeta _arrivalLocationIdMeta = const VerificationMeta(
    'arrivalLocationId',
  );
  @override
  late final GeneratedColumn<int> arrivalLocationId = GeneratedColumn<int>(
    'arrival_location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES location (location_id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    flightRecordId,
    medicalId,
    airlineId,
    flightNumber,
    travelStatusId,
    departureLocationId,
    arrivalLocationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlightRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('flight_record_id')) {
      context.handle(
        _flightRecordIdMeta,
        flightRecordId.isAcceptableOrUnknown(
          data['flight_record_id']!,
          _flightRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('airline_id')) {
      context.handle(
        _airlineIdMeta,
        airlineId.isAcceptableOrUnknown(data['airline_id']!, _airlineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_airlineIdMeta);
    }
    if (data.containsKey('flight_number')) {
      context.handle(
        _flightNumberMeta,
        flightNumber.isAcceptableOrUnknown(
          data['flight_number']!,
          _flightNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_flightNumberMeta);
    }
    if (data.containsKey('travel_status_id')) {
      context.handle(
        _travelStatusIdMeta,
        travelStatusId.isAcceptableOrUnknown(
          data['travel_status_id']!,
          _travelStatusIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_travelStatusIdMeta);
    }
    if (data.containsKey('departure_location_id')) {
      context.handle(
        _departureLocationIdMeta,
        departureLocationId.isAcceptableOrUnknown(
          data['departure_location_id']!,
          _departureLocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departureLocationIdMeta);
    }
    if (data.containsKey('arrival_location_id')) {
      context.handle(
        _arrivalLocationIdMeta,
        arrivalLocationId.isAcceptableOrUnknown(
          data['arrival_location_id']!,
          _arrivalLocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arrivalLocationIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {flightRecordId};
  @override
  FlightRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlightRecordData(
      flightRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_record_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      airlineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}airline_id'],
      )!,
      flightNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flight_number'],
      )!,
      travelStatusId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travel_status_id'],
      )!,
      departureLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}departure_location_id'],
      )!,
      arrivalLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}arrival_location_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FlightRecordTable createAlias(String alias) {
    return $FlightRecordTable(attachedDatabase, alias);
  }
}

class FlightRecordData extends DataClass
    implements Insertable<FlightRecordData> {
  final int flightRecordId;
  final int medicalId;
  final int airlineId;
  final String flightNumber;
  final int travelStatusId;
  final int departureLocationId;
  final int arrivalLocationId;
  final DateTime createdAt;
  const FlightRecordData({
    required this.flightRecordId,
    required this.medicalId,
    required this.airlineId,
    required this.flightNumber,
    required this.travelStatusId,
    required this.departureLocationId,
    required this.arrivalLocationId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['flight_record_id'] = Variable<int>(flightRecordId);
    map['medical_id'] = Variable<int>(medicalId);
    map['airline_id'] = Variable<int>(airlineId);
    map['flight_number'] = Variable<String>(flightNumber);
    map['travel_status_id'] = Variable<int>(travelStatusId);
    map['departure_location_id'] = Variable<int>(departureLocationId);
    map['arrival_location_id'] = Variable<int>(arrivalLocationId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FlightRecordCompanion toCompanion(bool nullToAbsent) {
    return FlightRecordCompanion(
      flightRecordId: Value(flightRecordId),
      medicalId: Value(medicalId),
      airlineId: Value(airlineId),
      flightNumber: Value(flightNumber),
      travelStatusId: Value(travelStatusId),
      departureLocationId: Value(departureLocationId),
      arrivalLocationId: Value(arrivalLocationId),
      createdAt: Value(createdAt),
    );
  }

  factory FlightRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlightRecordData(
      flightRecordId: serializer.fromJson<int>(json['flightRecordId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      airlineId: serializer.fromJson<int>(json['airlineId']),
      flightNumber: serializer.fromJson<String>(json['flightNumber']),
      travelStatusId: serializer.fromJson<int>(json['travelStatusId']),
      departureLocationId: serializer.fromJson<int>(
        json['departureLocationId'],
      ),
      arrivalLocationId: serializer.fromJson<int>(json['arrivalLocationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'flightRecordId': serializer.toJson<int>(flightRecordId),
      'medicalId': serializer.toJson<int>(medicalId),
      'airlineId': serializer.toJson<int>(airlineId),
      'flightNumber': serializer.toJson<String>(flightNumber),
      'travelStatusId': serializer.toJson<int>(travelStatusId),
      'departureLocationId': serializer.toJson<int>(departureLocationId),
      'arrivalLocationId': serializer.toJson<int>(arrivalLocationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FlightRecordData copyWith({
    int? flightRecordId,
    int? medicalId,
    int? airlineId,
    String? flightNumber,
    int? travelStatusId,
    int? departureLocationId,
    int? arrivalLocationId,
    DateTime? createdAt,
  }) => FlightRecordData(
    flightRecordId: flightRecordId ?? this.flightRecordId,
    medicalId: medicalId ?? this.medicalId,
    airlineId: airlineId ?? this.airlineId,
    flightNumber: flightNumber ?? this.flightNumber,
    travelStatusId: travelStatusId ?? this.travelStatusId,
    departureLocationId: departureLocationId ?? this.departureLocationId,
    arrivalLocationId: arrivalLocationId ?? this.arrivalLocationId,
    createdAt: createdAt ?? this.createdAt,
  );
  FlightRecordData copyWithCompanion(FlightRecordCompanion data) {
    return FlightRecordData(
      flightRecordId: data.flightRecordId.present
          ? data.flightRecordId.value
          : this.flightRecordId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      airlineId: data.airlineId.present ? data.airlineId.value : this.airlineId,
      flightNumber: data.flightNumber.present
          ? data.flightNumber.value
          : this.flightNumber,
      travelStatusId: data.travelStatusId.present
          ? data.travelStatusId.value
          : this.travelStatusId,
      departureLocationId: data.departureLocationId.present
          ? data.departureLocationId.value
          : this.departureLocationId,
      arrivalLocationId: data.arrivalLocationId.present
          ? data.arrivalLocationId.value
          : this.arrivalLocationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightRecordData(')
          ..write('flightRecordId: $flightRecordId, ')
          ..write('medicalId: $medicalId, ')
          ..write('airlineId: $airlineId, ')
          ..write('flightNumber: $flightNumber, ')
          ..write('travelStatusId: $travelStatusId, ')
          ..write('departureLocationId: $departureLocationId, ')
          ..write('arrivalLocationId: $arrivalLocationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    flightRecordId,
    medicalId,
    airlineId,
    flightNumber,
    travelStatusId,
    departureLocationId,
    arrivalLocationId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlightRecordData &&
          other.flightRecordId == this.flightRecordId &&
          other.medicalId == this.medicalId &&
          other.airlineId == this.airlineId &&
          other.flightNumber == this.flightNumber &&
          other.travelStatusId == this.travelStatusId &&
          other.departureLocationId == this.departureLocationId &&
          other.arrivalLocationId == this.arrivalLocationId &&
          other.createdAt == this.createdAt);
}

class FlightRecordCompanion extends UpdateCompanion<FlightRecordData> {
  final Value<int> flightRecordId;
  final Value<int> medicalId;
  final Value<int> airlineId;
  final Value<String> flightNumber;
  final Value<int> travelStatusId;
  final Value<int> departureLocationId;
  final Value<int> arrivalLocationId;
  final Value<DateTime> createdAt;
  const FlightRecordCompanion({
    this.flightRecordId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.airlineId = const Value.absent(),
    this.flightNumber = const Value.absent(),
    this.travelStatusId = const Value.absent(),
    this.departureLocationId = const Value.absent(),
    this.arrivalLocationId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FlightRecordCompanion.insert({
    this.flightRecordId = const Value.absent(),
    required int medicalId,
    required int airlineId,
    required String flightNumber,
    required int travelStatusId,
    required int departureLocationId,
    required int arrivalLocationId,
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId),
       airlineId = Value(airlineId),
       flightNumber = Value(flightNumber),
       travelStatusId = Value(travelStatusId),
       departureLocationId = Value(departureLocationId),
       arrivalLocationId = Value(arrivalLocationId);
  static Insertable<FlightRecordData> custom({
    Expression<int>? flightRecordId,
    Expression<int>? medicalId,
    Expression<int>? airlineId,
    Expression<String>? flightNumber,
    Expression<int>? travelStatusId,
    Expression<int>? departureLocationId,
    Expression<int>? arrivalLocationId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (flightRecordId != null) 'flight_record_id': flightRecordId,
      if (medicalId != null) 'medical_id': medicalId,
      if (airlineId != null) 'airline_id': airlineId,
      if (flightNumber != null) 'flight_number': flightNumber,
      if (travelStatusId != null) 'travel_status_id': travelStatusId,
      if (departureLocationId != null)
        'departure_location_id': departureLocationId,
      if (arrivalLocationId != null) 'arrival_location_id': arrivalLocationId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FlightRecordCompanion copyWith({
    Value<int>? flightRecordId,
    Value<int>? medicalId,
    Value<int>? airlineId,
    Value<String>? flightNumber,
    Value<int>? travelStatusId,
    Value<int>? departureLocationId,
    Value<int>? arrivalLocationId,
    Value<DateTime>? createdAt,
  }) {
    return FlightRecordCompanion(
      flightRecordId: flightRecordId ?? this.flightRecordId,
      medicalId: medicalId ?? this.medicalId,
      airlineId: airlineId ?? this.airlineId,
      flightNumber: flightNumber ?? this.flightNumber,
      travelStatusId: travelStatusId ?? this.travelStatusId,
      departureLocationId: departureLocationId ?? this.departureLocationId,
      arrivalLocationId: arrivalLocationId ?? this.arrivalLocationId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (flightRecordId.present) {
      map['flight_record_id'] = Variable<int>(flightRecordId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (airlineId.present) {
      map['airline_id'] = Variable<int>(airlineId.value);
    }
    if (flightNumber.present) {
      map['flight_number'] = Variable<String>(flightNumber.value);
    }
    if (travelStatusId.present) {
      map['travel_status_id'] = Variable<int>(travelStatusId.value);
    }
    if (departureLocationId.present) {
      map['departure_location_id'] = Variable<int>(departureLocationId.value);
    }
    if (arrivalLocationId.present) {
      map['arrival_location_id'] = Variable<int>(arrivalLocationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightRecordCompanion(')
          ..write('flightRecordId: $flightRecordId, ')
          ..write('medicalId: $medicalId, ')
          ..write('airlineId: $airlineId, ')
          ..write('flightNumber: $flightNumber, ')
          ..write('travelStatusId: $travelStatusId, ')
          ..write('departureLocationId: $departureLocationId, ')
          ..write('arrivalLocationId: $arrivalLocationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FlightTransitLocationsTable extends FlightTransitLocations
    with TableInfo<$FlightTransitLocationsTable, FlightTransitLocationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightTransitLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _flightRecordIdMeta = const VerificationMeta(
    'flightRecordId',
  );
  @override
  late final GeneratedColumn<int> flightRecordId = GeneratedColumn<int>(
    'flight_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flight_record (flight_record_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES location (location_id)',
    ),
  );
  static const VerificationMeta _stopOrderMeta = const VerificationMeta(
    'stopOrder',
  );
  @override
  late final GeneratedColumn<int> stopOrder = GeneratedColumn<int>(
    'stop_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    flightRecordId,
    locationId,
    stopOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_transit_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlightTransitLocationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('flight_record_id')) {
      context.handle(
        _flightRecordIdMeta,
        flightRecordId.isAcceptableOrUnknown(
          data['flight_record_id']!,
          _flightRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_flightRecordIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('stop_order')) {
      context.handle(
        _stopOrderMeta,
        stopOrder.isAcceptableOrUnknown(data['stop_order']!, _stopOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlightTransitLocationData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlightTransitLocationData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      flightRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_record_id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      )!,
      stopOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stop_order'],
      )!,
    );
  }

  @override
  $FlightTransitLocationsTable createAlias(String alias) {
    return $FlightTransitLocationsTable(attachedDatabase, alias);
  }
}

class FlightTransitLocationData extends DataClass
    implements Insertable<FlightTransitLocationData> {
  final int id;
  final int flightRecordId;
  final int locationId;
  final int stopOrder;
  const FlightTransitLocationData({
    required this.id,
    required this.flightRecordId,
    required this.locationId,
    required this.stopOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['flight_record_id'] = Variable<int>(flightRecordId);
    map['location_id'] = Variable<int>(locationId);
    map['stop_order'] = Variable<int>(stopOrder);
    return map;
  }

  FlightTransitLocationsCompanion toCompanion(bool nullToAbsent) {
    return FlightTransitLocationsCompanion(
      id: Value(id),
      flightRecordId: Value(flightRecordId),
      locationId: Value(locationId),
      stopOrder: Value(stopOrder),
    );
  }

  factory FlightTransitLocationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlightTransitLocationData(
      id: serializer.fromJson<int>(json['id']),
      flightRecordId: serializer.fromJson<int>(json['flightRecordId']),
      locationId: serializer.fromJson<int>(json['locationId']),
      stopOrder: serializer.fromJson<int>(json['stopOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'flightRecordId': serializer.toJson<int>(flightRecordId),
      'locationId': serializer.toJson<int>(locationId),
      'stopOrder': serializer.toJson<int>(stopOrder),
    };
  }

  FlightTransitLocationData copyWith({
    int? id,
    int? flightRecordId,
    int? locationId,
    int? stopOrder,
  }) => FlightTransitLocationData(
    id: id ?? this.id,
    flightRecordId: flightRecordId ?? this.flightRecordId,
    locationId: locationId ?? this.locationId,
    stopOrder: stopOrder ?? this.stopOrder,
  );
  FlightTransitLocationData copyWithCompanion(
    FlightTransitLocationsCompanion data,
  ) {
    return FlightTransitLocationData(
      id: data.id.present ? data.id.value : this.id,
      flightRecordId: data.flightRecordId.present
          ? data.flightRecordId.value
          : this.flightRecordId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      stopOrder: data.stopOrder.present ? data.stopOrder.value : this.stopOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightTransitLocationData(')
          ..write('id: $id, ')
          ..write('flightRecordId: $flightRecordId, ')
          ..write('locationId: $locationId, ')
          ..write('stopOrder: $stopOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, flightRecordId, locationId, stopOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlightTransitLocationData &&
          other.id == this.id &&
          other.flightRecordId == this.flightRecordId &&
          other.locationId == this.locationId &&
          other.stopOrder == this.stopOrder);
}

class FlightTransitLocationsCompanion
    extends UpdateCompanion<FlightTransitLocationData> {
  final Value<int> id;
  final Value<int> flightRecordId;
  final Value<int> locationId;
  final Value<int> stopOrder;
  const FlightTransitLocationsCompanion({
    this.id = const Value.absent(),
    this.flightRecordId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.stopOrder = const Value.absent(),
  });
  FlightTransitLocationsCompanion.insert({
    this.id = const Value.absent(),
    required int flightRecordId,
    required int locationId,
    this.stopOrder = const Value.absent(),
  }) : flightRecordId = Value(flightRecordId),
       locationId = Value(locationId);
  static Insertable<FlightTransitLocationData> custom({
    Expression<int>? id,
    Expression<int>? flightRecordId,
    Expression<int>? locationId,
    Expression<int>? stopOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flightRecordId != null) 'flight_record_id': flightRecordId,
      if (locationId != null) 'location_id': locationId,
      if (stopOrder != null) 'stop_order': stopOrder,
    });
  }

  FlightTransitLocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? flightRecordId,
    Value<int>? locationId,
    Value<int>? stopOrder,
  }) {
    return FlightTransitLocationsCompanion(
      id: id ?? this.id,
      flightRecordId: flightRecordId ?? this.flightRecordId,
      locationId: locationId ?? this.locationId,
      stopOrder: stopOrder ?? this.stopOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (flightRecordId.present) {
      map['flight_record_id'] = Variable<int>(flightRecordId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (stopOrder.present) {
      map['stop_order'] = Variable<int>(stopOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightTransitLocationsCompanion(')
          ..write('id: $id, ')
          ..write('flightRecordId: $flightRecordId, ')
          ..write('locationId: $locationId, ')
          ..write('stopOrder: $stopOrder')
          ..write(')'))
        .toString();
  }
}

class $IncidentRecordTable extends IncidentRecord
    with TableInfo<$IncidentRecordTable, IncidentRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidentRecordTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _incidentIdMeta = const VerificationMeta(
    'incidentId',
  );
  @override
  late final GeneratedColumn<int> incidentId = GeneratedColumn<int>(
    'incident_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _incidentDateMeta = const VerificationMeta(
    'incidentDate',
  );
  @override
  late final GeneratedColumn<DateTime> incidentDate = GeneratedColumn<DateTime>(
    'incident_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incidentPlaceCategoryIdMeta =
      const VerificationMeta('incidentPlaceCategoryId');
  @override
  late final GeneratedColumn<int> incidentPlaceCategoryId =
      GeneratedColumn<int>(
        'incident_place_category_id',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES incident_place_category (id)',
        ),
      );
  static const VerificationMeta _incidentPlaceCategory2IdMeta =
      const VerificationMeta('incidentPlaceCategory2Id');
  @override
  late final GeneratedColumn<int> incidentPlaceCategory2Id =
      GeneratedColumn<int>(
        'incident_place_category2_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES incident_place_category2 (id)',
        ),
      );
  static const VerificationMeta _incidentPlaceFinalMeta =
      const VerificationMeta('incidentPlaceFinal');
  @override
  late final GeneratedColumn<String> incidentPlaceFinal =
      GeneratedColumn<String>(
        'incident_place_final',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notificationTimeMeta = const VerificationMeta(
    'notificationTime',
  );
  @override
  late final GeneratedColumn<DateTime> notificationTime =
      GeneratedColumn<DateTime>(
        'notification_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notificationPersonMeta =
      const VerificationMeta('notificationPerson');
  @override
  late final GeneratedColumn<String> notificationPerson =
      GeneratedColumn<String>(
        'notification_person',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reportingUnitIdMeta = const VerificationMeta(
    'reportingUnitId',
  );
  @override
  late final GeneratedColumn<int> reportingUnitId = GeneratedColumn<int>(
    'reporting_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reporting_unit (id)',
    ),
  );
  static const VerificationMeta _incomingPhoneMeta = const VerificationMeta(
    'incomingPhone',
  );
  @override
  late final GeneratedColumn<String> incomingPhone = GeneratedColumn<String>(
    'incoming_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationToOccTimeMeta =
      const VerificationMeta('notificationToOccTime');
  @override
  late final GeneratedColumn<DateTime> notificationToOccTime =
      GeneratedColumn<DateTime>(
        'notification_to_occ_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _teamDepartureTimeMeta = const VerificationMeta(
    'teamDepartureTime',
  );
  @override
  late final GeneratedColumn<DateTime> teamDepartureTime =
      GeneratedColumn<DateTime>(
        'team_departure_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _occArrivedMeta = const VerificationMeta(
    'occArrived',
  );
  @override
  late final GeneratedColumn<bool> occArrived = GeneratedColumn<bool>(
    'occ_arrived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("occ_arrived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _beforeLandingMeta = const VerificationMeta(
    'beforeLanding',
  );
  @override
  late final GeneratedColumn<bool> beforeLanding = GeneratedColumn<bool>(
    'before_landing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("before_landing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _landingTimeMeta = const VerificationMeta(
    'landingTime',
  );
  @override
  late final GeneratedColumn<DateTime> landingTime = GeneratedColumn<DateTime>(
    'landing_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicalArrivalTimeMeta =
      const VerificationMeta('medicalArrivalTime');
  @override
  late final GeneratedColumn<DateTime> medicalArrivalTime =
      GeneratedColumn<DateTime>(
        'medical_arrival_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _examinationTimeMeta = const VerificationMeta(
    'examinationTime',
  );
  @override
  late final GeneratedColumn<DateTime> examinationTime =
      GeneratedColumn<DateTime>(
        'examination_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    incidentId,
    medicalId,
    incidentDate,
    incidentPlaceCategoryId,
    incidentPlaceCategory2Id,
    incidentPlaceFinal,
    notificationTime,
    notificationPerson,
    reportingUnitId,
    incomingPhone,
    notificationToOccTime,
    teamDepartureTime,
    occArrived,
    beforeLanding,
    landingTime,
    medicalArrivalTime,
    examinationTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incident_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncidentRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('incident_id')) {
      context.handle(
        _incidentIdMeta,
        incidentId.isAcceptableOrUnknown(data['incident_id']!, _incidentIdMeta),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('incident_date')) {
      context.handle(
        _incidentDateMeta,
        incidentDate.isAcceptableOrUnknown(
          data['incident_date']!,
          _incidentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incidentDateMeta);
    }
    if (data.containsKey('incident_place_category_id')) {
      context.handle(
        _incidentPlaceCategoryIdMeta,
        incidentPlaceCategoryId.isAcceptableOrUnknown(
          data['incident_place_category_id']!,
          _incidentPlaceCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incidentPlaceCategoryIdMeta);
    }
    if (data.containsKey('incident_place_category2_id')) {
      context.handle(
        _incidentPlaceCategory2IdMeta,
        incidentPlaceCategory2Id.isAcceptableOrUnknown(
          data['incident_place_category2_id']!,
          _incidentPlaceCategory2IdMeta,
        ),
      );
    }
    if (data.containsKey('incident_place_final')) {
      context.handle(
        _incidentPlaceFinalMeta,
        incidentPlaceFinal.isAcceptableOrUnknown(
          data['incident_place_final']!,
          _incidentPlaceFinalMeta,
        ),
      );
    }
    if (data.containsKey('notification_time')) {
      context.handle(
        _notificationTimeMeta,
        notificationTime.isAcceptableOrUnknown(
          data['notification_time']!,
          _notificationTimeMeta,
        ),
      );
    }
    if (data.containsKey('notification_person')) {
      context.handle(
        _notificationPersonMeta,
        notificationPerson.isAcceptableOrUnknown(
          data['notification_person']!,
          _notificationPersonMeta,
        ),
      );
    }
    if (data.containsKey('reporting_unit_id')) {
      context.handle(
        _reportingUnitIdMeta,
        reportingUnitId.isAcceptableOrUnknown(
          data['reporting_unit_id']!,
          _reportingUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reportingUnitIdMeta);
    }
    if (data.containsKey('incoming_phone')) {
      context.handle(
        _incomingPhoneMeta,
        incomingPhone.isAcceptableOrUnknown(
          data['incoming_phone']!,
          _incomingPhoneMeta,
        ),
      );
    }
    if (data.containsKey('notification_to_occ_time')) {
      context.handle(
        _notificationToOccTimeMeta,
        notificationToOccTime.isAcceptableOrUnknown(
          data['notification_to_occ_time']!,
          _notificationToOccTimeMeta,
        ),
      );
    }
    if (data.containsKey('team_departure_time')) {
      context.handle(
        _teamDepartureTimeMeta,
        teamDepartureTime.isAcceptableOrUnknown(
          data['team_departure_time']!,
          _teamDepartureTimeMeta,
        ),
      );
    }
    if (data.containsKey('occ_arrived')) {
      context.handle(
        _occArrivedMeta,
        occArrived.isAcceptableOrUnknown(data['occ_arrived']!, _occArrivedMeta),
      );
    }
    if (data.containsKey('before_landing')) {
      context.handle(
        _beforeLandingMeta,
        beforeLanding.isAcceptableOrUnknown(
          data['before_landing']!,
          _beforeLandingMeta,
        ),
      );
    }
    if (data.containsKey('landing_time')) {
      context.handle(
        _landingTimeMeta,
        landingTime.isAcceptableOrUnknown(
          data['landing_time']!,
          _landingTimeMeta,
        ),
      );
    }
    if (data.containsKey('medical_arrival_time')) {
      context.handle(
        _medicalArrivalTimeMeta,
        medicalArrivalTime.isAcceptableOrUnknown(
          data['medical_arrival_time']!,
          _medicalArrivalTimeMeta,
        ),
      );
    }
    if (data.containsKey('examination_time')) {
      context.handle(
        _examinationTimeMeta,
        examinationTime.isAcceptableOrUnknown(
          data['examination_time']!,
          _examinationTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {incidentId};
  @override
  IncidentRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncidentRecordData(
      incidentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incident_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      incidentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}incident_date'],
      )!,
      incidentPlaceCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incident_place_category_id'],
      )!,
      incidentPlaceCategory2Id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incident_place_category2_id'],
      ),
      incidentPlaceFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}incident_place_final'],
      ),
      notificationTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}notification_time'],
      ),
      notificationPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_person'],
      ),
      reportingUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reporting_unit_id'],
      )!,
      incomingPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}incoming_phone'],
      ),
      notificationToOccTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}notification_to_occ_time'],
      ),
      teamDepartureTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}team_departure_time'],
      ),
      occArrived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}occ_arrived'],
      )!,
      beforeLanding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}before_landing'],
      )!,
      landingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}landing_time'],
      ),
      medicalArrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}medical_arrival_time'],
      ),
      examinationTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}examination_time'],
      ),
    );
  }

  @override
  $IncidentRecordTable createAlias(String alias) {
    return $IncidentRecordTable(attachedDatabase, alias);
  }
}

class IncidentRecordData extends DataClass
    implements Insertable<IncidentRecordData> {
  final int incidentId;
  final int medicalId;
  final DateTime incidentDate;
  final int incidentPlaceCategoryId;
  final int? incidentPlaceCategory2Id;
  final String? incidentPlaceFinal;
  final DateTime? notificationTime;
  final String? notificationPerson;
  final int reportingUnitId;
  final String? incomingPhone;
  final DateTime? notificationToOccTime;
  final DateTime? teamDepartureTime;
  final bool occArrived;
  final bool beforeLanding;
  final DateTime? landingTime;
  final DateTime? medicalArrivalTime;
  final DateTime? examinationTime;
  const IncidentRecordData({
    required this.incidentId,
    required this.medicalId,
    required this.incidentDate,
    required this.incidentPlaceCategoryId,
    this.incidentPlaceCategory2Id,
    this.incidentPlaceFinal,
    this.notificationTime,
    this.notificationPerson,
    required this.reportingUnitId,
    this.incomingPhone,
    this.notificationToOccTime,
    this.teamDepartureTime,
    required this.occArrived,
    required this.beforeLanding,
    this.landingTime,
    this.medicalArrivalTime,
    this.examinationTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['incident_id'] = Variable<int>(incidentId);
    map['medical_id'] = Variable<int>(medicalId);
    map['incident_date'] = Variable<DateTime>(incidentDate);
    map['incident_place_category_id'] = Variable<int>(incidentPlaceCategoryId);
    if (!nullToAbsent || incidentPlaceCategory2Id != null) {
      map['incident_place_category2_id'] = Variable<int>(
        incidentPlaceCategory2Id,
      );
    }
    if (!nullToAbsent || incidentPlaceFinal != null) {
      map['incident_place_final'] = Variable<String>(incidentPlaceFinal);
    }
    if (!nullToAbsent || notificationTime != null) {
      map['notification_time'] = Variable<DateTime>(notificationTime);
    }
    if (!nullToAbsent || notificationPerson != null) {
      map['notification_person'] = Variable<String>(notificationPerson);
    }
    map['reporting_unit_id'] = Variable<int>(reportingUnitId);
    if (!nullToAbsent || incomingPhone != null) {
      map['incoming_phone'] = Variable<String>(incomingPhone);
    }
    if (!nullToAbsent || notificationToOccTime != null) {
      map['notification_to_occ_time'] = Variable<DateTime>(
        notificationToOccTime,
      );
    }
    if (!nullToAbsent || teamDepartureTime != null) {
      map['team_departure_time'] = Variable<DateTime>(teamDepartureTime);
    }
    map['occ_arrived'] = Variable<bool>(occArrived);
    map['before_landing'] = Variable<bool>(beforeLanding);
    if (!nullToAbsent || landingTime != null) {
      map['landing_time'] = Variable<DateTime>(landingTime);
    }
    if (!nullToAbsent || medicalArrivalTime != null) {
      map['medical_arrival_time'] = Variable<DateTime>(medicalArrivalTime);
    }
    if (!nullToAbsent || examinationTime != null) {
      map['examination_time'] = Variable<DateTime>(examinationTime);
    }
    return map;
  }

  IncidentRecordCompanion toCompanion(bool nullToAbsent) {
    return IncidentRecordCompanion(
      incidentId: Value(incidentId),
      medicalId: Value(medicalId),
      incidentDate: Value(incidentDate),
      incidentPlaceCategoryId: Value(incidentPlaceCategoryId),
      incidentPlaceCategory2Id: incidentPlaceCategory2Id == null && nullToAbsent
          ? const Value.absent()
          : Value(incidentPlaceCategory2Id),
      incidentPlaceFinal: incidentPlaceFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(incidentPlaceFinal),
      notificationTime: notificationTime == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationTime),
      notificationPerson: notificationPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationPerson),
      reportingUnitId: Value(reportingUnitId),
      incomingPhone: incomingPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(incomingPhone),
      notificationToOccTime: notificationToOccTime == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationToOccTime),
      teamDepartureTime: teamDepartureTime == null && nullToAbsent
          ? const Value.absent()
          : Value(teamDepartureTime),
      occArrived: Value(occArrived),
      beforeLanding: Value(beforeLanding),
      landingTime: landingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(landingTime),
      medicalArrivalTime: medicalArrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalArrivalTime),
      examinationTime: examinationTime == null && nullToAbsent
          ? const Value.absent()
          : Value(examinationTime),
    );
  }

  factory IncidentRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncidentRecordData(
      incidentId: serializer.fromJson<int>(json['incidentId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      incidentDate: serializer.fromJson<DateTime>(json['incidentDate']),
      incidentPlaceCategoryId: serializer.fromJson<int>(
        json['incidentPlaceCategoryId'],
      ),
      incidentPlaceCategory2Id: serializer.fromJson<int?>(
        json['incidentPlaceCategory2Id'],
      ),
      incidentPlaceFinal: serializer.fromJson<String?>(
        json['incidentPlaceFinal'],
      ),
      notificationTime: serializer.fromJson<DateTime?>(
        json['notificationTime'],
      ),
      notificationPerson: serializer.fromJson<String?>(
        json['notificationPerson'],
      ),
      reportingUnitId: serializer.fromJson<int>(json['reportingUnitId']),
      incomingPhone: serializer.fromJson<String?>(json['incomingPhone']),
      notificationToOccTime: serializer.fromJson<DateTime?>(
        json['notificationToOccTime'],
      ),
      teamDepartureTime: serializer.fromJson<DateTime?>(
        json['teamDepartureTime'],
      ),
      occArrived: serializer.fromJson<bool>(json['occArrived']),
      beforeLanding: serializer.fromJson<bool>(json['beforeLanding']),
      landingTime: serializer.fromJson<DateTime?>(json['landingTime']),
      medicalArrivalTime: serializer.fromJson<DateTime?>(
        json['medicalArrivalTime'],
      ),
      examinationTime: serializer.fromJson<DateTime?>(json['examinationTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'incidentId': serializer.toJson<int>(incidentId),
      'medicalId': serializer.toJson<int>(medicalId),
      'incidentDate': serializer.toJson<DateTime>(incidentDate),
      'incidentPlaceCategoryId': serializer.toJson<int>(
        incidentPlaceCategoryId,
      ),
      'incidentPlaceCategory2Id': serializer.toJson<int?>(
        incidentPlaceCategory2Id,
      ),
      'incidentPlaceFinal': serializer.toJson<String?>(incidentPlaceFinal),
      'notificationTime': serializer.toJson<DateTime?>(notificationTime),
      'notificationPerson': serializer.toJson<String?>(notificationPerson),
      'reportingUnitId': serializer.toJson<int>(reportingUnitId),
      'incomingPhone': serializer.toJson<String?>(incomingPhone),
      'notificationToOccTime': serializer.toJson<DateTime?>(
        notificationToOccTime,
      ),
      'teamDepartureTime': serializer.toJson<DateTime?>(teamDepartureTime),
      'occArrived': serializer.toJson<bool>(occArrived),
      'beforeLanding': serializer.toJson<bool>(beforeLanding),
      'landingTime': serializer.toJson<DateTime?>(landingTime),
      'medicalArrivalTime': serializer.toJson<DateTime?>(medicalArrivalTime),
      'examinationTime': serializer.toJson<DateTime?>(examinationTime),
    };
  }

  IncidentRecordData copyWith({
    int? incidentId,
    int? medicalId,
    DateTime? incidentDate,
    int? incidentPlaceCategoryId,
    Value<int?> incidentPlaceCategory2Id = const Value.absent(),
    Value<String?> incidentPlaceFinal = const Value.absent(),
    Value<DateTime?> notificationTime = const Value.absent(),
    Value<String?> notificationPerson = const Value.absent(),
    int? reportingUnitId,
    Value<String?> incomingPhone = const Value.absent(),
    Value<DateTime?> notificationToOccTime = const Value.absent(),
    Value<DateTime?> teamDepartureTime = const Value.absent(),
    bool? occArrived,
    bool? beforeLanding,
    Value<DateTime?> landingTime = const Value.absent(),
    Value<DateTime?> medicalArrivalTime = const Value.absent(),
    Value<DateTime?> examinationTime = const Value.absent(),
  }) => IncidentRecordData(
    incidentId: incidentId ?? this.incidentId,
    medicalId: medicalId ?? this.medicalId,
    incidentDate: incidentDate ?? this.incidentDate,
    incidentPlaceCategoryId:
        incidentPlaceCategoryId ?? this.incidentPlaceCategoryId,
    incidentPlaceCategory2Id: incidentPlaceCategory2Id.present
        ? incidentPlaceCategory2Id.value
        : this.incidentPlaceCategory2Id,
    incidentPlaceFinal: incidentPlaceFinal.present
        ? incidentPlaceFinal.value
        : this.incidentPlaceFinal,
    notificationTime: notificationTime.present
        ? notificationTime.value
        : this.notificationTime,
    notificationPerson: notificationPerson.present
        ? notificationPerson.value
        : this.notificationPerson,
    reportingUnitId: reportingUnitId ?? this.reportingUnitId,
    incomingPhone: incomingPhone.present
        ? incomingPhone.value
        : this.incomingPhone,
    notificationToOccTime: notificationToOccTime.present
        ? notificationToOccTime.value
        : this.notificationToOccTime,
    teamDepartureTime: teamDepartureTime.present
        ? teamDepartureTime.value
        : this.teamDepartureTime,
    occArrived: occArrived ?? this.occArrived,
    beforeLanding: beforeLanding ?? this.beforeLanding,
    landingTime: landingTime.present ? landingTime.value : this.landingTime,
    medicalArrivalTime: medicalArrivalTime.present
        ? medicalArrivalTime.value
        : this.medicalArrivalTime,
    examinationTime: examinationTime.present
        ? examinationTime.value
        : this.examinationTime,
  );
  IncidentRecordData copyWithCompanion(IncidentRecordCompanion data) {
    return IncidentRecordData(
      incidentId: data.incidentId.present
          ? data.incidentId.value
          : this.incidentId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      incidentDate: data.incidentDate.present
          ? data.incidentDate.value
          : this.incidentDate,
      incidentPlaceCategoryId: data.incidentPlaceCategoryId.present
          ? data.incidentPlaceCategoryId.value
          : this.incidentPlaceCategoryId,
      incidentPlaceCategory2Id: data.incidentPlaceCategory2Id.present
          ? data.incidentPlaceCategory2Id.value
          : this.incidentPlaceCategory2Id,
      incidentPlaceFinal: data.incidentPlaceFinal.present
          ? data.incidentPlaceFinal.value
          : this.incidentPlaceFinal,
      notificationTime: data.notificationTime.present
          ? data.notificationTime.value
          : this.notificationTime,
      notificationPerson: data.notificationPerson.present
          ? data.notificationPerson.value
          : this.notificationPerson,
      reportingUnitId: data.reportingUnitId.present
          ? data.reportingUnitId.value
          : this.reportingUnitId,
      incomingPhone: data.incomingPhone.present
          ? data.incomingPhone.value
          : this.incomingPhone,
      notificationToOccTime: data.notificationToOccTime.present
          ? data.notificationToOccTime.value
          : this.notificationToOccTime,
      teamDepartureTime: data.teamDepartureTime.present
          ? data.teamDepartureTime.value
          : this.teamDepartureTime,
      occArrived: data.occArrived.present
          ? data.occArrived.value
          : this.occArrived,
      beforeLanding: data.beforeLanding.present
          ? data.beforeLanding.value
          : this.beforeLanding,
      landingTime: data.landingTime.present
          ? data.landingTime.value
          : this.landingTime,
      medicalArrivalTime: data.medicalArrivalTime.present
          ? data.medicalArrivalTime.value
          : this.medicalArrivalTime,
      examinationTime: data.examinationTime.present
          ? data.examinationTime.value
          : this.examinationTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncidentRecordData(')
          ..write('incidentId: $incidentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('incidentDate: $incidentDate, ')
          ..write('incidentPlaceCategoryId: $incidentPlaceCategoryId, ')
          ..write('incidentPlaceCategory2Id: $incidentPlaceCategory2Id, ')
          ..write('incidentPlaceFinal: $incidentPlaceFinal, ')
          ..write('notificationTime: $notificationTime, ')
          ..write('notificationPerson: $notificationPerson, ')
          ..write('reportingUnitId: $reportingUnitId, ')
          ..write('incomingPhone: $incomingPhone, ')
          ..write('notificationToOccTime: $notificationToOccTime, ')
          ..write('teamDepartureTime: $teamDepartureTime, ')
          ..write('occArrived: $occArrived, ')
          ..write('beforeLanding: $beforeLanding, ')
          ..write('landingTime: $landingTime, ')
          ..write('medicalArrivalTime: $medicalArrivalTime, ')
          ..write('examinationTime: $examinationTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    incidentId,
    medicalId,
    incidentDate,
    incidentPlaceCategoryId,
    incidentPlaceCategory2Id,
    incidentPlaceFinal,
    notificationTime,
    notificationPerson,
    reportingUnitId,
    incomingPhone,
    notificationToOccTime,
    teamDepartureTime,
    occArrived,
    beforeLanding,
    landingTime,
    medicalArrivalTime,
    examinationTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncidentRecordData &&
          other.incidentId == this.incidentId &&
          other.medicalId == this.medicalId &&
          other.incidentDate == this.incidentDate &&
          other.incidentPlaceCategoryId == this.incidentPlaceCategoryId &&
          other.incidentPlaceCategory2Id == this.incidentPlaceCategory2Id &&
          other.incidentPlaceFinal == this.incidentPlaceFinal &&
          other.notificationTime == this.notificationTime &&
          other.notificationPerson == this.notificationPerson &&
          other.reportingUnitId == this.reportingUnitId &&
          other.incomingPhone == this.incomingPhone &&
          other.notificationToOccTime == this.notificationToOccTime &&
          other.teamDepartureTime == this.teamDepartureTime &&
          other.occArrived == this.occArrived &&
          other.beforeLanding == this.beforeLanding &&
          other.landingTime == this.landingTime &&
          other.medicalArrivalTime == this.medicalArrivalTime &&
          other.examinationTime == this.examinationTime);
}

class IncidentRecordCompanion extends UpdateCompanion<IncidentRecordData> {
  final Value<int> incidentId;
  final Value<int> medicalId;
  final Value<DateTime> incidentDate;
  final Value<int> incidentPlaceCategoryId;
  final Value<int?> incidentPlaceCategory2Id;
  final Value<String?> incidentPlaceFinal;
  final Value<DateTime?> notificationTime;
  final Value<String?> notificationPerson;
  final Value<int> reportingUnitId;
  final Value<String?> incomingPhone;
  final Value<DateTime?> notificationToOccTime;
  final Value<DateTime?> teamDepartureTime;
  final Value<bool> occArrived;
  final Value<bool> beforeLanding;
  final Value<DateTime?> landingTime;
  final Value<DateTime?> medicalArrivalTime;
  final Value<DateTime?> examinationTime;
  const IncidentRecordCompanion({
    this.incidentId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.incidentDate = const Value.absent(),
    this.incidentPlaceCategoryId = const Value.absent(),
    this.incidentPlaceCategory2Id = const Value.absent(),
    this.incidentPlaceFinal = const Value.absent(),
    this.notificationTime = const Value.absent(),
    this.notificationPerson = const Value.absent(),
    this.reportingUnitId = const Value.absent(),
    this.incomingPhone = const Value.absent(),
    this.notificationToOccTime = const Value.absent(),
    this.teamDepartureTime = const Value.absent(),
    this.occArrived = const Value.absent(),
    this.beforeLanding = const Value.absent(),
    this.landingTime = const Value.absent(),
    this.medicalArrivalTime = const Value.absent(),
    this.examinationTime = const Value.absent(),
  });
  IncidentRecordCompanion.insert({
    this.incidentId = const Value.absent(),
    required int medicalId,
    required DateTime incidentDate,
    required int incidentPlaceCategoryId,
    this.incidentPlaceCategory2Id = const Value.absent(),
    this.incidentPlaceFinal = const Value.absent(),
    this.notificationTime = const Value.absent(),
    this.notificationPerson = const Value.absent(),
    required int reportingUnitId,
    this.incomingPhone = const Value.absent(),
    this.notificationToOccTime = const Value.absent(),
    this.teamDepartureTime = const Value.absent(),
    this.occArrived = const Value.absent(),
    this.beforeLanding = const Value.absent(),
    this.landingTime = const Value.absent(),
    this.medicalArrivalTime = const Value.absent(),
    this.examinationTime = const Value.absent(),
  }) : medicalId = Value(medicalId),
       incidentDate = Value(incidentDate),
       incidentPlaceCategoryId = Value(incidentPlaceCategoryId),
       reportingUnitId = Value(reportingUnitId);
  static Insertable<IncidentRecordData> custom({
    Expression<int>? incidentId,
    Expression<int>? medicalId,
    Expression<DateTime>? incidentDate,
    Expression<int>? incidentPlaceCategoryId,
    Expression<int>? incidentPlaceCategory2Id,
    Expression<String>? incidentPlaceFinal,
    Expression<DateTime>? notificationTime,
    Expression<String>? notificationPerson,
    Expression<int>? reportingUnitId,
    Expression<String>? incomingPhone,
    Expression<DateTime>? notificationToOccTime,
    Expression<DateTime>? teamDepartureTime,
    Expression<bool>? occArrived,
    Expression<bool>? beforeLanding,
    Expression<DateTime>? landingTime,
    Expression<DateTime>? medicalArrivalTime,
    Expression<DateTime>? examinationTime,
  }) {
    return RawValuesInsertable({
      if (incidentId != null) 'incident_id': incidentId,
      if (medicalId != null) 'medical_id': medicalId,
      if (incidentDate != null) 'incident_date': incidentDate,
      if (incidentPlaceCategoryId != null)
        'incident_place_category_id': incidentPlaceCategoryId,
      if (incidentPlaceCategory2Id != null)
        'incident_place_category2_id': incidentPlaceCategory2Id,
      if (incidentPlaceFinal != null)
        'incident_place_final': incidentPlaceFinal,
      if (notificationTime != null) 'notification_time': notificationTime,
      if (notificationPerson != null) 'notification_person': notificationPerson,
      if (reportingUnitId != null) 'reporting_unit_id': reportingUnitId,
      if (incomingPhone != null) 'incoming_phone': incomingPhone,
      if (notificationToOccTime != null)
        'notification_to_occ_time': notificationToOccTime,
      if (teamDepartureTime != null) 'team_departure_time': teamDepartureTime,
      if (occArrived != null) 'occ_arrived': occArrived,
      if (beforeLanding != null) 'before_landing': beforeLanding,
      if (landingTime != null) 'landing_time': landingTime,
      if (medicalArrivalTime != null)
        'medical_arrival_time': medicalArrivalTime,
      if (examinationTime != null) 'examination_time': examinationTime,
    });
  }

  IncidentRecordCompanion copyWith({
    Value<int>? incidentId,
    Value<int>? medicalId,
    Value<DateTime>? incidentDate,
    Value<int>? incidentPlaceCategoryId,
    Value<int?>? incidentPlaceCategory2Id,
    Value<String?>? incidentPlaceFinal,
    Value<DateTime?>? notificationTime,
    Value<String?>? notificationPerson,
    Value<int>? reportingUnitId,
    Value<String?>? incomingPhone,
    Value<DateTime?>? notificationToOccTime,
    Value<DateTime?>? teamDepartureTime,
    Value<bool>? occArrived,
    Value<bool>? beforeLanding,
    Value<DateTime?>? landingTime,
    Value<DateTime?>? medicalArrivalTime,
    Value<DateTime?>? examinationTime,
  }) {
    return IncidentRecordCompanion(
      incidentId: incidentId ?? this.incidentId,
      medicalId: medicalId ?? this.medicalId,
      incidentDate: incidentDate ?? this.incidentDate,
      incidentPlaceCategoryId:
          incidentPlaceCategoryId ?? this.incidentPlaceCategoryId,
      incidentPlaceCategory2Id:
          incidentPlaceCategory2Id ?? this.incidentPlaceCategory2Id,
      incidentPlaceFinal: incidentPlaceFinal ?? this.incidentPlaceFinal,
      notificationTime: notificationTime ?? this.notificationTime,
      notificationPerson: notificationPerson ?? this.notificationPerson,
      reportingUnitId: reportingUnitId ?? this.reportingUnitId,
      incomingPhone: incomingPhone ?? this.incomingPhone,
      notificationToOccTime:
          notificationToOccTime ?? this.notificationToOccTime,
      teamDepartureTime: teamDepartureTime ?? this.teamDepartureTime,
      occArrived: occArrived ?? this.occArrived,
      beforeLanding: beforeLanding ?? this.beforeLanding,
      landingTime: landingTime ?? this.landingTime,
      medicalArrivalTime: medicalArrivalTime ?? this.medicalArrivalTime,
      examinationTime: examinationTime ?? this.examinationTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (incidentId.present) {
      map['incident_id'] = Variable<int>(incidentId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (incidentDate.present) {
      map['incident_date'] = Variable<DateTime>(incidentDate.value);
    }
    if (incidentPlaceCategoryId.present) {
      map['incident_place_category_id'] = Variable<int>(
        incidentPlaceCategoryId.value,
      );
    }
    if (incidentPlaceCategory2Id.present) {
      map['incident_place_category2_id'] = Variable<int>(
        incidentPlaceCategory2Id.value,
      );
    }
    if (incidentPlaceFinal.present) {
      map['incident_place_final'] = Variable<String>(incidentPlaceFinal.value);
    }
    if (notificationTime.present) {
      map['notification_time'] = Variable<DateTime>(notificationTime.value);
    }
    if (notificationPerson.present) {
      map['notification_person'] = Variable<String>(notificationPerson.value);
    }
    if (reportingUnitId.present) {
      map['reporting_unit_id'] = Variable<int>(reportingUnitId.value);
    }
    if (incomingPhone.present) {
      map['incoming_phone'] = Variable<String>(incomingPhone.value);
    }
    if (notificationToOccTime.present) {
      map['notification_to_occ_time'] = Variable<DateTime>(
        notificationToOccTime.value,
      );
    }
    if (teamDepartureTime.present) {
      map['team_departure_time'] = Variable<DateTime>(teamDepartureTime.value);
    }
    if (occArrived.present) {
      map['occ_arrived'] = Variable<bool>(occArrived.value);
    }
    if (beforeLanding.present) {
      map['before_landing'] = Variable<bool>(beforeLanding.value);
    }
    if (landingTime.present) {
      map['landing_time'] = Variable<DateTime>(landingTime.value);
    }
    if (medicalArrivalTime.present) {
      map['medical_arrival_time'] = Variable<DateTime>(
        medicalArrivalTime.value,
      );
    }
    if (examinationTime.present) {
      map['examination_time'] = Variable<DateTime>(examinationTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentRecordCompanion(')
          ..write('incidentId: $incidentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('incidentDate: $incidentDate, ')
          ..write('incidentPlaceCategoryId: $incidentPlaceCategoryId, ')
          ..write('incidentPlaceCategory2Id: $incidentPlaceCategory2Id, ')
          ..write('incidentPlaceFinal: $incidentPlaceFinal, ')
          ..write('notificationTime: $notificationTime, ')
          ..write('notificationPerson: $notificationPerson, ')
          ..write('reportingUnitId: $reportingUnitId, ')
          ..write('incomingPhone: $incomingPhone, ')
          ..write('notificationToOccTime: $notificationToOccTime, ')
          ..write('teamDepartureTime: $teamDepartureTime, ')
          ..write('occArrived: $occArrived, ')
          ..write('beforeLanding: $beforeLanding, ')
          ..write('landingTime: $landingTime, ')
          ..write('medicalArrivalTime: $medicalArrivalTime, ')
          ..write('examinationTime: $examinationTime')
          ..write(')'))
        .toString();
  }
}

class $ChiefComplaintTable extends ChiefComplaint
    with TableInfo<$ChiefComplaintTable, ChiefComplaintData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChiefComplaintTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _complaintIdMeta = const VerificationMeta(
    'complaintId',
  );
  @override
  late final GeneratedColumn<int> complaintId = GeneratedColumn<int>(
    'complaint_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _chiefComplaintTypeIdMeta =
      const VerificationMeta('chiefComplaintTypeId');
  @override
  late final GeneratedColumn<int> chiefComplaintTypeId = GeneratedColumn<int>(
    'chief_complaint_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedSymptomsMeta = const VerificationMeta(
    'selectedSymptoms',
  );
  @override
  late final GeneratedColumn<String> selectedSymptoms = GeneratedColumn<String>(
    'selected_symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherSymptomDetailMeta =
      const VerificationMeta('otherSymptomDetail');
  @override
  late final GeneratedColumn<String> otherSymptomDetail =
      GeneratedColumn<String>(
        'other_symptom_detail',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _chiefComplaintFinalMeta =
      const VerificationMeta('chiefComplaintFinal');
  @override
  late final GeneratedColumn<String> chiefComplaintFinal =
      GeneratedColumn<String>(
        'chief_complaint_final',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _supplementaryNotesMeta =
      const VerificationMeta('supplementaryNotes');
  @override
  late final GeneratedColumn<String> supplementaryNotes =
      GeneratedColumn<String>(
        'supplementary_notes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _onsetTimeMeta = const VerificationMeta(
    'onsetTime',
  );
  @override
  late final GeneratedColumn<DateTime> onsetTime = GeneratedColumn<DateTime>(
    'onset_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reportedByMeta = const VerificationMeta(
    'reportedBy',
  );
  @override
  late final GeneratedColumn<String> reportedBy = GeneratedColumn<String>(
    'reported_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isConfirmedMeta = const VerificationMeta(
    'isConfirmed',
  );
  @override
  late final GeneratedColumn<bool> isConfirmed = GeneratedColumn<bool>(
    'is_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    complaintId,
    medicalId,
    chiefComplaintTypeId,
    selectedSymptoms,
    otherSymptomDetail,
    chiefComplaintFinal,
    supplementaryNotes,
    onsetTime,
    reportedBy,
    isConfirmed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chief_complaint';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChiefComplaintData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('complaint_id')) {
      context.handle(
        _complaintIdMeta,
        complaintId.isAcceptableOrUnknown(
          data['complaint_id']!,
          _complaintIdMeta,
        ),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('chief_complaint_type_id')) {
      context.handle(
        _chiefComplaintTypeIdMeta,
        chiefComplaintTypeId.isAcceptableOrUnknown(
          data['chief_complaint_type_id']!,
          _chiefComplaintTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_symptoms')) {
      context.handle(
        _selectedSymptomsMeta,
        selectedSymptoms.isAcceptableOrUnknown(
          data['selected_symptoms']!,
          _selectedSymptomsMeta,
        ),
      );
    }
    if (data.containsKey('other_symptom_detail')) {
      context.handle(
        _otherSymptomDetailMeta,
        otherSymptomDetail.isAcceptableOrUnknown(
          data['other_symptom_detail']!,
          _otherSymptomDetailMeta,
        ),
      );
    }
    if (data.containsKey('chief_complaint_final')) {
      context.handle(
        _chiefComplaintFinalMeta,
        chiefComplaintFinal.isAcceptableOrUnknown(
          data['chief_complaint_final']!,
          _chiefComplaintFinalMeta,
        ),
      );
    }
    if (data.containsKey('supplementary_notes')) {
      context.handle(
        _supplementaryNotesMeta,
        supplementaryNotes.isAcceptableOrUnknown(
          data['supplementary_notes']!,
          _supplementaryNotesMeta,
        ),
      );
    }
    if (data.containsKey('onset_time')) {
      context.handle(
        _onsetTimeMeta,
        onsetTime.isAcceptableOrUnknown(data['onset_time']!, _onsetTimeMeta),
      );
    }
    if (data.containsKey('reported_by')) {
      context.handle(
        _reportedByMeta,
        reportedBy.isAcceptableOrUnknown(data['reported_by']!, _reportedByMeta),
      );
    }
    if (data.containsKey('is_confirmed')) {
      context.handle(
        _isConfirmedMeta,
        isConfirmed.isAcceptableOrUnknown(
          data['is_confirmed']!,
          _isConfirmedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {complaintId};
  @override
  ChiefComplaintData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChiefComplaintData(
      complaintId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}complaint_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      chiefComplaintTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chief_complaint_type_id'],
      ),
      selectedSymptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_symptoms'],
      ),
      otherSymptomDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_symptom_detail'],
      ),
      chiefComplaintFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chief_complaint_final'],
      ),
      supplementaryNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplementary_notes'],
      ),
      onsetTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}onset_time'],
      ),
      reportedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reported_by'],
      ),
      isConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_confirmed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChiefComplaintTable createAlias(String alias) {
    return $ChiefComplaintTable(attachedDatabase, alias);
  }
}

class ChiefComplaintData extends DataClass
    implements Insertable<ChiefComplaintData> {
  final int complaintId;
  final int medicalId;
  final int? chiefComplaintTypeId;
  final String? selectedSymptoms;
  final String? otherSymptomDetail;
  final String? chiefComplaintFinal;
  final String? supplementaryNotes;
  final DateTime? onsetTime;
  final String? reportedBy;
  final bool isConfirmed;
  final DateTime createdAt;
  const ChiefComplaintData({
    required this.complaintId,
    required this.medicalId,
    this.chiefComplaintTypeId,
    this.selectedSymptoms,
    this.otherSymptomDetail,
    this.chiefComplaintFinal,
    this.supplementaryNotes,
    this.onsetTime,
    this.reportedBy,
    required this.isConfirmed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['complaint_id'] = Variable<int>(complaintId);
    map['medical_id'] = Variable<int>(medicalId);
    if (!nullToAbsent || chiefComplaintTypeId != null) {
      map['chief_complaint_type_id'] = Variable<int>(chiefComplaintTypeId);
    }
    if (!nullToAbsent || selectedSymptoms != null) {
      map['selected_symptoms'] = Variable<String>(selectedSymptoms);
    }
    if (!nullToAbsent || otherSymptomDetail != null) {
      map['other_symptom_detail'] = Variable<String>(otherSymptomDetail);
    }
    if (!nullToAbsent || chiefComplaintFinal != null) {
      map['chief_complaint_final'] = Variable<String>(chiefComplaintFinal);
    }
    if (!nullToAbsent || supplementaryNotes != null) {
      map['supplementary_notes'] = Variable<String>(supplementaryNotes);
    }
    if (!nullToAbsent || onsetTime != null) {
      map['onset_time'] = Variable<DateTime>(onsetTime);
    }
    if (!nullToAbsent || reportedBy != null) {
      map['reported_by'] = Variable<String>(reportedBy);
    }
    map['is_confirmed'] = Variable<bool>(isConfirmed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChiefComplaintCompanion toCompanion(bool nullToAbsent) {
    return ChiefComplaintCompanion(
      complaintId: Value(complaintId),
      medicalId: Value(medicalId),
      chiefComplaintTypeId: chiefComplaintTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(chiefComplaintTypeId),
      selectedSymptoms: selectedSymptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedSymptoms),
      otherSymptomDetail: otherSymptomDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(otherSymptomDetail),
      chiefComplaintFinal: chiefComplaintFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(chiefComplaintFinal),
      supplementaryNotes: supplementaryNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(supplementaryNotes),
      onsetTime: onsetTime == null && nullToAbsent
          ? const Value.absent()
          : Value(onsetTime),
      reportedBy: reportedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(reportedBy),
      isConfirmed: Value(isConfirmed),
      createdAt: Value(createdAt),
    );
  }

  factory ChiefComplaintData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChiefComplaintData(
      complaintId: serializer.fromJson<int>(json['complaintId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      chiefComplaintTypeId: serializer.fromJson<int?>(
        json['chiefComplaintTypeId'],
      ),
      selectedSymptoms: serializer.fromJson<String?>(json['selectedSymptoms']),
      otherSymptomDetail: serializer.fromJson<String?>(
        json['otherSymptomDetail'],
      ),
      chiefComplaintFinal: serializer.fromJson<String?>(
        json['chiefComplaintFinal'],
      ),
      supplementaryNotes: serializer.fromJson<String?>(
        json['supplementaryNotes'],
      ),
      onsetTime: serializer.fromJson<DateTime?>(json['onsetTime']),
      reportedBy: serializer.fromJson<String?>(json['reportedBy']),
      isConfirmed: serializer.fromJson<bool>(json['isConfirmed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'complaintId': serializer.toJson<int>(complaintId),
      'medicalId': serializer.toJson<int>(medicalId),
      'chiefComplaintTypeId': serializer.toJson<int?>(chiefComplaintTypeId),
      'selectedSymptoms': serializer.toJson<String?>(selectedSymptoms),
      'otherSymptomDetail': serializer.toJson<String?>(otherSymptomDetail),
      'chiefComplaintFinal': serializer.toJson<String?>(chiefComplaintFinal),
      'supplementaryNotes': serializer.toJson<String?>(supplementaryNotes),
      'onsetTime': serializer.toJson<DateTime?>(onsetTime),
      'reportedBy': serializer.toJson<String?>(reportedBy),
      'isConfirmed': serializer.toJson<bool>(isConfirmed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChiefComplaintData copyWith({
    int? complaintId,
    int? medicalId,
    Value<int?> chiefComplaintTypeId = const Value.absent(),
    Value<String?> selectedSymptoms = const Value.absent(),
    Value<String?> otherSymptomDetail = const Value.absent(),
    Value<String?> chiefComplaintFinal = const Value.absent(),
    Value<String?> supplementaryNotes = const Value.absent(),
    Value<DateTime?> onsetTime = const Value.absent(),
    Value<String?> reportedBy = const Value.absent(),
    bool? isConfirmed,
    DateTime? createdAt,
  }) => ChiefComplaintData(
    complaintId: complaintId ?? this.complaintId,
    medicalId: medicalId ?? this.medicalId,
    chiefComplaintTypeId: chiefComplaintTypeId.present
        ? chiefComplaintTypeId.value
        : this.chiefComplaintTypeId,
    selectedSymptoms: selectedSymptoms.present
        ? selectedSymptoms.value
        : this.selectedSymptoms,
    otherSymptomDetail: otherSymptomDetail.present
        ? otherSymptomDetail.value
        : this.otherSymptomDetail,
    chiefComplaintFinal: chiefComplaintFinal.present
        ? chiefComplaintFinal.value
        : this.chiefComplaintFinal,
    supplementaryNotes: supplementaryNotes.present
        ? supplementaryNotes.value
        : this.supplementaryNotes,
    onsetTime: onsetTime.present ? onsetTime.value : this.onsetTime,
    reportedBy: reportedBy.present ? reportedBy.value : this.reportedBy,
    isConfirmed: isConfirmed ?? this.isConfirmed,
    createdAt: createdAt ?? this.createdAt,
  );
  ChiefComplaintData copyWithCompanion(ChiefComplaintCompanion data) {
    return ChiefComplaintData(
      complaintId: data.complaintId.present
          ? data.complaintId.value
          : this.complaintId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      chiefComplaintTypeId: data.chiefComplaintTypeId.present
          ? data.chiefComplaintTypeId.value
          : this.chiefComplaintTypeId,
      selectedSymptoms: data.selectedSymptoms.present
          ? data.selectedSymptoms.value
          : this.selectedSymptoms,
      otherSymptomDetail: data.otherSymptomDetail.present
          ? data.otherSymptomDetail.value
          : this.otherSymptomDetail,
      chiefComplaintFinal: data.chiefComplaintFinal.present
          ? data.chiefComplaintFinal.value
          : this.chiefComplaintFinal,
      supplementaryNotes: data.supplementaryNotes.present
          ? data.supplementaryNotes.value
          : this.supplementaryNotes,
      onsetTime: data.onsetTime.present ? data.onsetTime.value : this.onsetTime,
      reportedBy: data.reportedBy.present
          ? data.reportedBy.value
          : this.reportedBy,
      isConfirmed: data.isConfirmed.present
          ? data.isConfirmed.value
          : this.isConfirmed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChiefComplaintData(')
          ..write('complaintId: $complaintId, ')
          ..write('medicalId: $medicalId, ')
          ..write('chiefComplaintTypeId: $chiefComplaintTypeId, ')
          ..write('selectedSymptoms: $selectedSymptoms, ')
          ..write('otherSymptomDetail: $otherSymptomDetail, ')
          ..write('chiefComplaintFinal: $chiefComplaintFinal, ')
          ..write('supplementaryNotes: $supplementaryNotes, ')
          ..write('onsetTime: $onsetTime, ')
          ..write('reportedBy: $reportedBy, ')
          ..write('isConfirmed: $isConfirmed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    complaintId,
    medicalId,
    chiefComplaintTypeId,
    selectedSymptoms,
    otherSymptomDetail,
    chiefComplaintFinal,
    supplementaryNotes,
    onsetTime,
    reportedBy,
    isConfirmed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChiefComplaintData &&
          other.complaintId == this.complaintId &&
          other.medicalId == this.medicalId &&
          other.chiefComplaintTypeId == this.chiefComplaintTypeId &&
          other.selectedSymptoms == this.selectedSymptoms &&
          other.otherSymptomDetail == this.otherSymptomDetail &&
          other.chiefComplaintFinal == this.chiefComplaintFinal &&
          other.supplementaryNotes == this.supplementaryNotes &&
          other.onsetTime == this.onsetTime &&
          other.reportedBy == this.reportedBy &&
          other.isConfirmed == this.isConfirmed &&
          other.createdAt == this.createdAt);
}

class ChiefComplaintCompanion extends UpdateCompanion<ChiefComplaintData> {
  final Value<int> complaintId;
  final Value<int> medicalId;
  final Value<int?> chiefComplaintTypeId;
  final Value<String?> selectedSymptoms;
  final Value<String?> otherSymptomDetail;
  final Value<String?> chiefComplaintFinal;
  final Value<String?> supplementaryNotes;
  final Value<DateTime?> onsetTime;
  final Value<String?> reportedBy;
  final Value<bool> isConfirmed;
  final Value<DateTime> createdAt;
  const ChiefComplaintCompanion({
    this.complaintId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.chiefComplaintTypeId = const Value.absent(),
    this.selectedSymptoms = const Value.absent(),
    this.otherSymptomDetail = const Value.absent(),
    this.chiefComplaintFinal = const Value.absent(),
    this.supplementaryNotes = const Value.absent(),
    this.onsetTime = const Value.absent(),
    this.reportedBy = const Value.absent(),
    this.isConfirmed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChiefComplaintCompanion.insert({
    this.complaintId = const Value.absent(),
    required int medicalId,
    this.chiefComplaintTypeId = const Value.absent(),
    this.selectedSymptoms = const Value.absent(),
    this.otherSymptomDetail = const Value.absent(),
    this.chiefComplaintFinal = const Value.absent(),
    this.supplementaryNotes = const Value.absent(),
    this.onsetTime = const Value.absent(),
    this.reportedBy = const Value.absent(),
    this.isConfirmed = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId);
  static Insertable<ChiefComplaintData> custom({
    Expression<int>? complaintId,
    Expression<int>? medicalId,
    Expression<int>? chiefComplaintTypeId,
    Expression<String>? selectedSymptoms,
    Expression<String>? otherSymptomDetail,
    Expression<String>? chiefComplaintFinal,
    Expression<String>? supplementaryNotes,
    Expression<DateTime>? onsetTime,
    Expression<String>? reportedBy,
    Expression<bool>? isConfirmed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (complaintId != null) 'complaint_id': complaintId,
      if (medicalId != null) 'medical_id': medicalId,
      if (chiefComplaintTypeId != null)
        'chief_complaint_type_id': chiefComplaintTypeId,
      if (selectedSymptoms != null) 'selected_symptoms': selectedSymptoms,
      if (otherSymptomDetail != null)
        'other_symptom_detail': otherSymptomDetail,
      if (chiefComplaintFinal != null)
        'chief_complaint_final': chiefComplaintFinal,
      if (supplementaryNotes != null) 'supplementary_notes': supplementaryNotes,
      if (onsetTime != null) 'onset_time': onsetTime,
      if (reportedBy != null) 'reported_by': reportedBy,
      if (isConfirmed != null) 'is_confirmed': isConfirmed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChiefComplaintCompanion copyWith({
    Value<int>? complaintId,
    Value<int>? medicalId,
    Value<int?>? chiefComplaintTypeId,
    Value<String?>? selectedSymptoms,
    Value<String?>? otherSymptomDetail,
    Value<String?>? chiefComplaintFinal,
    Value<String?>? supplementaryNotes,
    Value<DateTime?>? onsetTime,
    Value<String?>? reportedBy,
    Value<bool>? isConfirmed,
    Value<DateTime>? createdAt,
  }) {
    return ChiefComplaintCompanion(
      complaintId: complaintId ?? this.complaintId,
      medicalId: medicalId ?? this.medicalId,
      chiefComplaintTypeId: chiefComplaintTypeId ?? this.chiefComplaintTypeId,
      selectedSymptoms: selectedSymptoms ?? this.selectedSymptoms,
      otherSymptomDetail: otherSymptomDetail ?? this.otherSymptomDetail,
      chiefComplaintFinal: chiefComplaintFinal ?? this.chiefComplaintFinal,
      supplementaryNotes: supplementaryNotes ?? this.supplementaryNotes,
      onsetTime: onsetTime ?? this.onsetTime,
      reportedBy: reportedBy ?? this.reportedBy,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (complaintId.present) {
      map['complaint_id'] = Variable<int>(complaintId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (chiefComplaintTypeId.present) {
      map['chief_complaint_type_id'] = Variable<int>(
        chiefComplaintTypeId.value,
      );
    }
    if (selectedSymptoms.present) {
      map['selected_symptoms'] = Variable<String>(selectedSymptoms.value);
    }
    if (otherSymptomDetail.present) {
      map['other_symptom_detail'] = Variable<String>(otherSymptomDetail.value);
    }
    if (chiefComplaintFinal.present) {
      map['chief_complaint_final'] = Variable<String>(
        chiefComplaintFinal.value,
      );
    }
    if (supplementaryNotes.present) {
      map['supplementary_notes'] = Variable<String>(supplementaryNotes.value);
    }
    if (onsetTime.present) {
      map['onset_time'] = Variable<DateTime>(onsetTime.value);
    }
    if (reportedBy.present) {
      map['reported_by'] = Variable<String>(reportedBy.value);
    }
    if (isConfirmed.present) {
      map['is_confirmed'] = Variable<bool>(isConfirmed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChiefComplaintCompanion(')
          ..write('complaintId: $complaintId, ')
          ..write('medicalId: $medicalId, ')
          ..write('chiefComplaintTypeId: $chiefComplaintTypeId, ')
          ..write('selectedSymptoms: $selectedSymptoms, ')
          ..write('otherSymptomDetail: $otherSymptomDetail, ')
          ..write('chiefComplaintFinal: $chiefComplaintFinal, ')
          ..write('supplementaryNotes: $supplementaryNotes, ')
          ..write('onsetTime: $onsetTime, ')
          ..write('reportedBy: $reportedBy, ')
          ..write('isConfirmed: $isConfirmed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HealthAssessmentFormTable extends HealthAssessmentForm
    with TableInfo<$HealthAssessmentFormTable, HealthAssessmentFormData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthAssessmentFormTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assessmentFormIdMeta = const VerificationMeta(
    'assessmentFormId',
  );
  @override
  late final GeneratedColumn<int> assessmentFormId = GeneratedColumn<int>(
    'assessment_form_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
    'relation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    assessmentFormId,
    medicalId,
    name,
    relation,
    temperature,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_assessment_form';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthAssessmentFormData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('assessment_form_id')) {
      context.handle(
        _assessmentFormIdMeta,
        assessmentFormId.isAcceptableOrUnknown(
          data['assessment_form_id']!,
          _assessmentFormIdMeta,
        ),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
      );
    } else if (isInserting) {
      context.missing(_relationMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assessmentFormId};
  @override
  HealthAssessmentFormData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthAssessmentFormData(
      assessmentFormId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assessment_form_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HealthAssessmentFormTable createAlias(String alias) {
    return $HealthAssessmentFormTable(attachedDatabase, alias);
  }
}

class HealthAssessmentFormData extends DataClass
    implements Insertable<HealthAssessmentFormData> {
  final int assessmentFormId;
  final int medicalId;
  final String name;
  final String relation;
  final double temperature;
  final DateTime createdAt;
  const HealthAssessmentFormData({
    required this.assessmentFormId,
    required this.medicalId,
    required this.name,
    required this.relation,
    required this.temperature,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['assessment_form_id'] = Variable<int>(assessmentFormId);
    map['medical_id'] = Variable<int>(medicalId);
    map['name'] = Variable<String>(name);
    map['relation'] = Variable<String>(relation);
    map['temperature'] = Variable<double>(temperature);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HealthAssessmentFormCompanion toCompanion(bool nullToAbsent) {
    return HealthAssessmentFormCompanion(
      assessmentFormId: Value(assessmentFormId),
      medicalId: Value(medicalId),
      name: Value(name),
      relation: Value(relation),
      temperature: Value(temperature),
      createdAt: Value(createdAt),
    );
  }

  factory HealthAssessmentFormData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthAssessmentFormData(
      assessmentFormId: serializer.fromJson<int>(json['assessmentFormId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      name: serializer.fromJson<String>(json['name']),
      relation: serializer.fromJson<String>(json['relation']),
      temperature: serializer.fromJson<double>(json['temperature']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assessmentFormId': serializer.toJson<int>(assessmentFormId),
      'medicalId': serializer.toJson<int>(medicalId),
      'name': serializer.toJson<String>(name),
      'relation': serializer.toJson<String>(relation),
      'temperature': serializer.toJson<double>(temperature),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HealthAssessmentFormData copyWith({
    int? assessmentFormId,
    int? medicalId,
    String? name,
    String? relation,
    double? temperature,
    DateTime? createdAt,
  }) => HealthAssessmentFormData(
    assessmentFormId: assessmentFormId ?? this.assessmentFormId,
    medicalId: medicalId ?? this.medicalId,
    name: name ?? this.name,
    relation: relation ?? this.relation,
    temperature: temperature ?? this.temperature,
    createdAt: createdAt ?? this.createdAt,
  );
  HealthAssessmentFormData copyWithCompanion(
    HealthAssessmentFormCompanion data,
  ) {
    return HealthAssessmentFormData(
      assessmentFormId: data.assessmentFormId.present
          ? data.assessmentFormId.value
          : this.assessmentFormId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      name: data.name.present ? data.name.value : this.name,
      relation: data.relation.present ? data.relation.value : this.relation,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthAssessmentFormData(')
          ..write('assessmentFormId: $assessmentFormId, ')
          ..write('medicalId: $medicalId, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('temperature: $temperature, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    assessmentFormId,
    medicalId,
    name,
    relation,
    temperature,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthAssessmentFormData &&
          other.assessmentFormId == this.assessmentFormId &&
          other.medicalId == this.medicalId &&
          other.name == this.name &&
          other.relation == this.relation &&
          other.temperature == this.temperature &&
          other.createdAt == this.createdAt);
}

class HealthAssessmentFormCompanion
    extends UpdateCompanion<HealthAssessmentFormData> {
  final Value<int> assessmentFormId;
  final Value<int> medicalId;
  final Value<String> name;
  final Value<String> relation;
  final Value<double> temperature;
  final Value<DateTime> createdAt;
  const HealthAssessmentFormCompanion({
    this.assessmentFormId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.name = const Value.absent(),
    this.relation = const Value.absent(),
    this.temperature = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HealthAssessmentFormCompanion.insert({
    this.assessmentFormId = const Value.absent(),
    required int medicalId,
    required String name,
    required String relation,
    required double temperature,
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId),
       name = Value(name),
       relation = Value(relation),
       temperature = Value(temperature);
  static Insertable<HealthAssessmentFormData> custom({
    Expression<int>? assessmentFormId,
    Expression<int>? medicalId,
    Expression<String>? name,
    Expression<String>? relation,
    Expression<double>? temperature,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (assessmentFormId != null) 'assessment_form_id': assessmentFormId,
      if (medicalId != null) 'medical_id': medicalId,
      if (name != null) 'name': name,
      if (relation != null) 'relation': relation,
      if (temperature != null) 'temperature': temperature,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HealthAssessmentFormCompanion copyWith({
    Value<int>? assessmentFormId,
    Value<int>? medicalId,
    Value<String>? name,
    Value<String>? relation,
    Value<double>? temperature,
    Value<DateTime>? createdAt,
  }) {
    return HealthAssessmentFormCompanion(
      assessmentFormId: assessmentFormId ?? this.assessmentFormId,
      medicalId: medicalId ?? this.medicalId,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      temperature: temperature ?? this.temperature,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assessmentFormId.present) {
      map['assessment_form_id'] = Variable<int>(assessmentFormId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthAssessmentFormCompanion(')
          ..write('assessmentFormId: $assessmentFormId, ')
          ..write('medicalId: $medicalId, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('temperature: $temperature, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MedicalMediaTable extends MedicalMedia
    with TableInfo<$MedicalMediaTable, MedicalMediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _base64DataMeta = const VerificationMeta(
    'base64Data',
  );
  @override
  late final GeneratedColumn<String> base64Data = GeneratedColumn<String>(
    'base64_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    mediaId,
    medicalId,
    mediaType,
    base64Data,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalMediaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('base64_data')) {
      context.handle(
        _base64DataMeta,
        base64Data.isAcceptableOrUnknown(data['base64_data']!, _base64DataMeta),
      );
    } else if (isInserting) {
      context.missing(_base64DataMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MedicalMediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalMediaData(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      base64Data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base64_data'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicalMediaTable createAlias(String alias) {
    return $MedicalMediaTable(attachedDatabase, alias);
  }
}

class MedicalMediaData extends DataClass
    implements Insertable<MedicalMediaData> {
  final int mediaId;
  final int medicalId;
  final String mediaType;
  final String base64Data;
  final String? description;
  final DateTime createdAt;
  const MedicalMediaData({
    required this.mediaId,
    required this.medicalId,
    required this.mediaType,
    required this.base64Data,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<int>(mediaId);
    map['medical_id'] = Variable<int>(medicalId);
    map['media_type'] = Variable<String>(mediaType);
    map['base64_data'] = Variable<String>(base64Data);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicalMediaCompanion toCompanion(bool nullToAbsent) {
    return MedicalMediaCompanion(
      mediaId: Value(mediaId),
      medicalId: Value(medicalId),
      mediaType: Value(mediaType),
      base64Data: Value(base64Data),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory MedicalMediaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalMediaData(
      mediaId: serializer.fromJson<int>(json['mediaId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      base64Data: serializer.fromJson<String>(json['base64Data']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<int>(mediaId),
      'medicalId': serializer.toJson<int>(medicalId),
      'mediaType': serializer.toJson<String>(mediaType),
      'base64Data': serializer.toJson<String>(base64Data),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicalMediaData copyWith({
    int? mediaId,
    int? medicalId,
    String? mediaType,
    String? base64Data,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
  }) => MedicalMediaData(
    mediaId: mediaId ?? this.mediaId,
    medicalId: medicalId ?? this.medicalId,
    mediaType: mediaType ?? this.mediaType,
    base64Data: base64Data ?? this.base64Data,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  MedicalMediaData copyWithCompanion(MedicalMediaCompanion data) {
    return MedicalMediaData(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      base64Data: data.base64Data.present
          ? data.base64Data.value
          : this.base64Data,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalMediaData(')
          ..write('mediaId: $mediaId, ')
          ..write('medicalId: $medicalId, ')
          ..write('mediaType: $mediaType, ')
          ..write('base64Data: $base64Data, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaId,
    medicalId,
    mediaType,
    base64Data,
    description,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalMediaData &&
          other.mediaId == this.mediaId &&
          other.medicalId == this.medicalId &&
          other.mediaType == this.mediaType &&
          other.base64Data == this.base64Data &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class MedicalMediaCompanion extends UpdateCompanion<MedicalMediaData> {
  final Value<int> mediaId;
  final Value<int> medicalId;
  final Value<String> mediaType;
  final Value<String> base64Data;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const MedicalMediaCompanion({
    this.mediaId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.base64Data = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MedicalMediaCompanion.insert({
    this.mediaId = const Value.absent(),
    required int medicalId,
    required String mediaType,
    required String base64Data,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId),
       mediaType = Value(mediaType),
       base64Data = Value(base64Data);
  static Insertable<MedicalMediaData> custom({
    Expression<int>? mediaId,
    Expression<int>? medicalId,
    Expression<String>? mediaType,
    Expression<String>? base64Data,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (medicalId != null) 'medical_id': medicalId,
      if (mediaType != null) 'media_type': mediaType,
      if (base64Data != null) 'base64_data': base64Data,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MedicalMediaCompanion copyWith({
    Value<int>? mediaId,
    Value<int>? medicalId,
    Value<String>? mediaType,
    Value<String>? base64Data,
    Value<String?>? description,
    Value<DateTime>? createdAt,
  }) {
    return MedicalMediaCompanion(
      mediaId: mediaId ?? this.mediaId,
      medicalId: medicalId ?? this.medicalId,
      mediaType: mediaType ?? this.mediaType,
      base64Data: base64Data ?? this.base64Data,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (base64Data.present) {
      map['base64_data'] = Variable<String>(base64Data.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalMediaCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('medicalId: $medicalId, ')
          ..write('mediaType: $mediaType, ')
          ..write('base64Data: $base64Data, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MedicalAssessmentTable extends MedicalAssessment
    with TableInfo<$MedicalAssessmentTable, MedicalAssessmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalAssessmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assessmentIdMeta = const VerificationMeta(
    'assessmentId',
  );
  @override
  late final GeneratedColumn<int> assessmentId = GeneratedColumn<int>(
    'assessment_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pulseMeta = const VerificationMeta('pulse');
  @override
  late final GeneratedColumn<int> pulse = GeneratedColumn<int>(
    'pulse',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breathMeta = const VerificationMeta('breath');
  @override
  late final GeneratedColumn<int> breath = GeneratedColumn<int>(
    'breath',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _systolicMeta = const VerificationMeta(
    'systolic',
  );
  @override
  late final GeneratedColumn<int> systolic = GeneratedColumn<int>(
    'systolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diastolicMeta = const VerificationMeta(
    'diastolic',
  );
  @override
  late final GeneratedColumn<int> diastolic = GeneratedColumn<int>(
    'diastolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2Meta = const VerificationMeta('spo2');
  @override
  late final GeneratedColumn<int> spo2 = GeneratedColumn<int>(
    'spo2',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painScoreMeta = const VerificationMeta(
    'painScore',
  );
  @override
  late final GeneratedColumn<int> painScore = GeneratedColumn<int>(
    'pain_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consciousnessLevelMeta =
      const VerificationMeta('consciousnessLevel');
  @override
  late final GeneratedColumn<String> consciousnessLevel =
      GeneratedColumn<String>(
        'consciousness_level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _gcsMeta = const VerificationMeta('gcs');
  @override
  late final GeneratedColumn<int> gcs = GeneratedColumn<int>(
    'gcs',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gcsEMeta = const VerificationMeta('gcsE');
  @override
  late final GeneratedColumn<String> gcsE = GeneratedColumn<String>(
    'gcs_e',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gcsMMeta = const VerificationMeta('gcsM');
  @override
  late final GeneratedColumn<String> gcsM = GeneratedColumn<String>(
    'gcs_m',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gcsVMeta = const VerificationMeta('gcsV');
  @override
  late final GeneratedColumn<String> gcsV = GeneratedColumn<String>(
    'gcs_v',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftPupilReactionMeta = const VerificationMeta(
    'leftPupilReaction',
  );
  @override
  late final GeneratedColumn<String> leftPupilReaction =
      GeneratedColumn<String>(
        'left_pupil_reaction',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _leftPupilSizeMeta = const VerificationMeta(
    'leftPupilSize',
  );
  @override
  late final GeneratedColumn<double> leftPupilSize = GeneratedColumn<double>(
    'left_pupil_size',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightPupilReactionMeta =
      const VerificationMeta('rightPupilReaction');
  @override
  late final GeneratedColumn<String> rightPupilReaction =
      GeneratedColumn<String>(
        'right_pupil_reaction',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rightPupilSizeMeta = const VerificationMeta(
    'rightPupilSize',
  );
  @override
  late final GeneratedColumn<double> rightPupilSize = GeneratedColumn<double>(
    'right_pupil_size',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headNeckExamMeta = const VerificationMeta(
    'headNeckExam',
  );
  @override
  late final GeneratedColumn<String> headNeckExam = GeneratedColumn<String>(
    'head_neck_exam',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chestExamMeta = const VerificationMeta(
    'chestExam',
  );
  @override
  late final GeneratedColumn<String> chestExam = GeneratedColumn<String>(
    'chest_exam',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _abdomenExamMeta = const VerificationMeta(
    'abdomenExam',
  );
  @override
  late final GeneratedColumn<String> abdomenExam = GeneratedColumn<String>(
    'abdomen_exam',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extremitiesExamMeta = const VerificationMeta(
    'extremitiesExam',
  );
  @override
  late final GeneratedColumn<String> extremitiesExam = GeneratedColumn<String>(
    'extremities_exam',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherPhysicalExamMeta = const VerificationMeta(
    'otherPhysicalExam',
  );
  @override
  late final GeneratedColumn<String> otherPhysicalExam =
      GeneratedColumn<String>(
        'other_physical_exam',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _triageIdMeta = const VerificationMeta(
    'triageId',
  );
  @override
  late final GeneratedColumn<int> triageId = GeneratedColumn<int>(
    'triage_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assessmentTimeMeta = const VerificationMeta(
    'assessmentTime',
  );
  @override
  late final GeneratedColumn<DateTime> assessmentTime =
      GeneratedColumn<DateTime>(
        'assessment_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    assessmentId,
    medicalId,
    temperature,
    pulse,
    breath,
    systolic,
    diastolic,
    spo2,
    painScore,
    consciousnessLevel,
    gcs,
    gcsE,
    gcsM,
    gcsV,
    leftPupilReaction,
    leftPupilSize,
    rightPupilReaction,
    rightPupilSize,
    headNeckExam,
    chestExam,
    abdomenExam,
    extremitiesExam,
    otherPhysicalExam,
    triageId,
    assessmentTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_assessment';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalAssessmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('assessment_id')) {
      context.handle(
        _assessmentIdMeta,
        assessmentId.isAcceptableOrUnknown(
          data['assessment_id']!,
          _assessmentIdMeta,
        ),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('pulse')) {
      context.handle(
        _pulseMeta,
        pulse.isAcceptableOrUnknown(data['pulse']!, _pulseMeta),
      );
    }
    if (data.containsKey('breath')) {
      context.handle(
        _breathMeta,
        breath.isAcceptableOrUnknown(data['breath']!, _breathMeta),
      );
    }
    if (data.containsKey('systolic')) {
      context.handle(
        _systolicMeta,
        systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta),
      );
    }
    if (data.containsKey('diastolic')) {
      context.handle(
        _diastolicMeta,
        diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta),
      );
    }
    if (data.containsKey('spo2')) {
      context.handle(
        _spo2Meta,
        spo2.isAcceptableOrUnknown(data['spo2']!, _spo2Meta),
      );
    }
    if (data.containsKey('pain_score')) {
      context.handle(
        _painScoreMeta,
        painScore.isAcceptableOrUnknown(data['pain_score']!, _painScoreMeta),
      );
    }
    if (data.containsKey('consciousness_level')) {
      context.handle(
        _consciousnessLevelMeta,
        consciousnessLevel.isAcceptableOrUnknown(
          data['consciousness_level']!,
          _consciousnessLevelMeta,
        ),
      );
    }
    if (data.containsKey('gcs')) {
      context.handle(
        _gcsMeta,
        gcs.isAcceptableOrUnknown(data['gcs']!, _gcsMeta),
      );
    }
    if (data.containsKey('gcs_e')) {
      context.handle(
        _gcsEMeta,
        gcsE.isAcceptableOrUnknown(data['gcs_e']!, _gcsEMeta),
      );
    }
    if (data.containsKey('gcs_m')) {
      context.handle(
        _gcsMMeta,
        gcsM.isAcceptableOrUnknown(data['gcs_m']!, _gcsMMeta),
      );
    }
    if (data.containsKey('gcs_v')) {
      context.handle(
        _gcsVMeta,
        gcsV.isAcceptableOrUnknown(data['gcs_v']!, _gcsVMeta),
      );
    }
    if (data.containsKey('left_pupil_reaction')) {
      context.handle(
        _leftPupilReactionMeta,
        leftPupilReaction.isAcceptableOrUnknown(
          data['left_pupil_reaction']!,
          _leftPupilReactionMeta,
        ),
      );
    }
    if (data.containsKey('left_pupil_size')) {
      context.handle(
        _leftPupilSizeMeta,
        leftPupilSize.isAcceptableOrUnknown(
          data['left_pupil_size']!,
          _leftPupilSizeMeta,
        ),
      );
    }
    if (data.containsKey('right_pupil_reaction')) {
      context.handle(
        _rightPupilReactionMeta,
        rightPupilReaction.isAcceptableOrUnknown(
          data['right_pupil_reaction']!,
          _rightPupilReactionMeta,
        ),
      );
    }
    if (data.containsKey('right_pupil_size')) {
      context.handle(
        _rightPupilSizeMeta,
        rightPupilSize.isAcceptableOrUnknown(
          data['right_pupil_size']!,
          _rightPupilSizeMeta,
        ),
      );
    }
    if (data.containsKey('head_neck_exam')) {
      context.handle(
        _headNeckExamMeta,
        headNeckExam.isAcceptableOrUnknown(
          data['head_neck_exam']!,
          _headNeckExamMeta,
        ),
      );
    }
    if (data.containsKey('chest_exam')) {
      context.handle(
        _chestExamMeta,
        chestExam.isAcceptableOrUnknown(data['chest_exam']!, _chestExamMeta),
      );
    }
    if (data.containsKey('abdomen_exam')) {
      context.handle(
        _abdomenExamMeta,
        abdomenExam.isAcceptableOrUnknown(
          data['abdomen_exam']!,
          _abdomenExamMeta,
        ),
      );
    }
    if (data.containsKey('extremities_exam')) {
      context.handle(
        _extremitiesExamMeta,
        extremitiesExam.isAcceptableOrUnknown(
          data['extremities_exam']!,
          _extremitiesExamMeta,
        ),
      );
    }
    if (data.containsKey('other_physical_exam')) {
      context.handle(
        _otherPhysicalExamMeta,
        otherPhysicalExam.isAcceptableOrUnknown(
          data['other_physical_exam']!,
          _otherPhysicalExamMeta,
        ),
      );
    }
    if (data.containsKey('triage_id')) {
      context.handle(
        _triageIdMeta,
        triageId.isAcceptableOrUnknown(data['triage_id']!, _triageIdMeta),
      );
    }
    if (data.containsKey('assessment_time')) {
      context.handle(
        _assessmentTimeMeta,
        assessmentTime.isAcceptableOrUnknown(
          data['assessment_time']!,
          _assessmentTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assessmentId};
  @override
  MedicalAssessmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalAssessmentData(
      assessmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assessment_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      pulse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pulse'],
      ),
      breath: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breath'],
      ),
      systolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}systolic'],
      ),
      diastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diastolic'],
      ),
      spo2: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spo2'],
      ),
      painScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pain_score'],
      ),
      consciousnessLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consciousness_level'],
      ),
      gcs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gcs'],
      ),
      gcsE: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gcs_e'],
      ),
      gcsM: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gcs_m'],
      ),
      gcsV: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gcs_v'],
      ),
      leftPupilReaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}left_pupil_reaction'],
      ),
      leftPupilSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_pupil_size'],
      ),
      rightPupilReaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}right_pupil_reaction'],
      ),
      rightPupilSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_pupil_size'],
      ),
      headNeckExam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}head_neck_exam'],
      ),
      chestExam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chest_exam'],
      ),
      abdomenExam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abdomen_exam'],
      ),
      extremitiesExam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extremities_exam'],
      ),
      otherPhysicalExam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_physical_exam'],
      ),
      triageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triage_id'],
      ),
      assessmentTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assessment_time'],
      )!,
    );
  }

  @override
  $MedicalAssessmentTable createAlias(String alias) {
    return $MedicalAssessmentTable(attachedDatabase, alias);
  }
}

class MedicalAssessmentData extends DataClass
    implements Insertable<MedicalAssessmentData> {
  final int assessmentId;
  final int medicalId;
  final double? temperature;
  final int? pulse;
  final int? breath;
  final int? systolic;
  final int? diastolic;
  final int? spo2;
  final int? painScore;
  final String? consciousnessLevel;
  final int? gcs;
  final String? gcsE;
  final String? gcsM;
  final String? gcsV;
  final String? leftPupilReaction;
  final double? leftPupilSize;
  final String? rightPupilReaction;
  final double? rightPupilSize;
  final String? headNeckExam;
  final String? chestExam;
  final String? abdomenExam;
  final String? extremitiesExam;
  final String? otherPhysicalExam;
  final int? triageId;
  final DateTime assessmentTime;
  const MedicalAssessmentData({
    required this.assessmentId,
    required this.medicalId,
    this.temperature,
    this.pulse,
    this.breath,
    this.systolic,
    this.diastolic,
    this.spo2,
    this.painScore,
    this.consciousnessLevel,
    this.gcs,
    this.gcsE,
    this.gcsM,
    this.gcsV,
    this.leftPupilReaction,
    this.leftPupilSize,
    this.rightPupilReaction,
    this.rightPupilSize,
    this.headNeckExam,
    this.chestExam,
    this.abdomenExam,
    this.extremitiesExam,
    this.otherPhysicalExam,
    this.triageId,
    required this.assessmentTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['assessment_id'] = Variable<int>(assessmentId);
    map['medical_id'] = Variable<int>(medicalId);
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || pulse != null) {
      map['pulse'] = Variable<int>(pulse);
    }
    if (!nullToAbsent || breath != null) {
      map['breath'] = Variable<int>(breath);
    }
    if (!nullToAbsent || systolic != null) {
      map['systolic'] = Variable<int>(systolic);
    }
    if (!nullToAbsent || diastolic != null) {
      map['diastolic'] = Variable<int>(diastolic);
    }
    if (!nullToAbsent || spo2 != null) {
      map['spo2'] = Variable<int>(spo2);
    }
    if (!nullToAbsent || painScore != null) {
      map['pain_score'] = Variable<int>(painScore);
    }
    if (!nullToAbsent || consciousnessLevel != null) {
      map['consciousness_level'] = Variable<String>(consciousnessLevel);
    }
    if (!nullToAbsent || gcs != null) {
      map['gcs'] = Variable<int>(gcs);
    }
    if (!nullToAbsent || gcsE != null) {
      map['gcs_e'] = Variable<String>(gcsE);
    }
    if (!nullToAbsent || gcsM != null) {
      map['gcs_m'] = Variable<String>(gcsM);
    }
    if (!nullToAbsent || gcsV != null) {
      map['gcs_v'] = Variable<String>(gcsV);
    }
    if (!nullToAbsent || leftPupilReaction != null) {
      map['left_pupil_reaction'] = Variable<String>(leftPupilReaction);
    }
    if (!nullToAbsent || leftPupilSize != null) {
      map['left_pupil_size'] = Variable<double>(leftPupilSize);
    }
    if (!nullToAbsent || rightPupilReaction != null) {
      map['right_pupil_reaction'] = Variable<String>(rightPupilReaction);
    }
    if (!nullToAbsent || rightPupilSize != null) {
      map['right_pupil_size'] = Variable<double>(rightPupilSize);
    }
    if (!nullToAbsent || headNeckExam != null) {
      map['head_neck_exam'] = Variable<String>(headNeckExam);
    }
    if (!nullToAbsent || chestExam != null) {
      map['chest_exam'] = Variable<String>(chestExam);
    }
    if (!nullToAbsent || abdomenExam != null) {
      map['abdomen_exam'] = Variable<String>(abdomenExam);
    }
    if (!nullToAbsent || extremitiesExam != null) {
      map['extremities_exam'] = Variable<String>(extremitiesExam);
    }
    if (!nullToAbsent || otherPhysicalExam != null) {
      map['other_physical_exam'] = Variable<String>(otherPhysicalExam);
    }
    if (!nullToAbsent || triageId != null) {
      map['triage_id'] = Variable<int>(triageId);
    }
    map['assessment_time'] = Variable<DateTime>(assessmentTime);
    return map;
  }

  MedicalAssessmentCompanion toCompanion(bool nullToAbsent) {
    return MedicalAssessmentCompanion(
      assessmentId: Value(assessmentId),
      medicalId: Value(medicalId),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      pulse: pulse == null && nullToAbsent
          ? const Value.absent()
          : Value(pulse),
      breath: breath == null && nullToAbsent
          ? const Value.absent()
          : Value(breath),
      systolic: systolic == null && nullToAbsent
          ? const Value.absent()
          : Value(systolic),
      diastolic: diastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(diastolic),
      spo2: spo2 == null && nullToAbsent ? const Value.absent() : Value(spo2),
      painScore: painScore == null && nullToAbsent
          ? const Value.absent()
          : Value(painScore),
      consciousnessLevel: consciousnessLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(consciousnessLevel),
      gcs: gcs == null && nullToAbsent ? const Value.absent() : Value(gcs),
      gcsE: gcsE == null && nullToAbsent ? const Value.absent() : Value(gcsE),
      gcsM: gcsM == null && nullToAbsent ? const Value.absent() : Value(gcsM),
      gcsV: gcsV == null && nullToAbsent ? const Value.absent() : Value(gcsV),
      leftPupilReaction: leftPupilReaction == null && nullToAbsent
          ? const Value.absent()
          : Value(leftPupilReaction),
      leftPupilSize: leftPupilSize == null && nullToAbsent
          ? const Value.absent()
          : Value(leftPupilSize),
      rightPupilReaction: rightPupilReaction == null && nullToAbsent
          ? const Value.absent()
          : Value(rightPupilReaction),
      rightPupilSize: rightPupilSize == null && nullToAbsent
          ? const Value.absent()
          : Value(rightPupilSize),
      headNeckExam: headNeckExam == null && nullToAbsent
          ? const Value.absent()
          : Value(headNeckExam),
      chestExam: chestExam == null && nullToAbsent
          ? const Value.absent()
          : Value(chestExam),
      abdomenExam: abdomenExam == null && nullToAbsent
          ? const Value.absent()
          : Value(abdomenExam),
      extremitiesExam: extremitiesExam == null && nullToAbsent
          ? const Value.absent()
          : Value(extremitiesExam),
      otherPhysicalExam: otherPhysicalExam == null && nullToAbsent
          ? const Value.absent()
          : Value(otherPhysicalExam),
      triageId: triageId == null && nullToAbsent
          ? const Value.absent()
          : Value(triageId),
      assessmentTime: Value(assessmentTime),
    );
  }

  factory MedicalAssessmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalAssessmentData(
      assessmentId: serializer.fromJson<int>(json['assessmentId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      pulse: serializer.fromJson<int?>(json['pulse']),
      breath: serializer.fromJson<int?>(json['breath']),
      systolic: serializer.fromJson<int?>(json['systolic']),
      diastolic: serializer.fromJson<int?>(json['diastolic']),
      spo2: serializer.fromJson<int?>(json['spo2']),
      painScore: serializer.fromJson<int?>(json['painScore']),
      consciousnessLevel: serializer.fromJson<String?>(
        json['consciousnessLevel'],
      ),
      gcs: serializer.fromJson<int?>(json['gcs']),
      gcsE: serializer.fromJson<String?>(json['gcsE']),
      gcsM: serializer.fromJson<String?>(json['gcsM']),
      gcsV: serializer.fromJson<String?>(json['gcsV']),
      leftPupilReaction: serializer.fromJson<String?>(
        json['leftPupilReaction'],
      ),
      leftPupilSize: serializer.fromJson<double?>(json['leftPupilSize']),
      rightPupilReaction: serializer.fromJson<String?>(
        json['rightPupilReaction'],
      ),
      rightPupilSize: serializer.fromJson<double?>(json['rightPupilSize']),
      headNeckExam: serializer.fromJson<String?>(json['headNeckExam']),
      chestExam: serializer.fromJson<String?>(json['chestExam']),
      abdomenExam: serializer.fromJson<String?>(json['abdomenExam']),
      extremitiesExam: serializer.fromJson<String?>(json['extremitiesExam']),
      otherPhysicalExam: serializer.fromJson<String?>(
        json['otherPhysicalExam'],
      ),
      triageId: serializer.fromJson<int?>(json['triageId']),
      assessmentTime: serializer.fromJson<DateTime>(json['assessmentTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assessmentId': serializer.toJson<int>(assessmentId),
      'medicalId': serializer.toJson<int>(medicalId),
      'temperature': serializer.toJson<double?>(temperature),
      'pulse': serializer.toJson<int?>(pulse),
      'breath': serializer.toJson<int?>(breath),
      'systolic': serializer.toJson<int?>(systolic),
      'diastolic': serializer.toJson<int?>(diastolic),
      'spo2': serializer.toJson<int?>(spo2),
      'painScore': serializer.toJson<int?>(painScore),
      'consciousnessLevel': serializer.toJson<String?>(consciousnessLevel),
      'gcs': serializer.toJson<int?>(gcs),
      'gcsE': serializer.toJson<String?>(gcsE),
      'gcsM': serializer.toJson<String?>(gcsM),
      'gcsV': serializer.toJson<String?>(gcsV),
      'leftPupilReaction': serializer.toJson<String?>(leftPupilReaction),
      'leftPupilSize': serializer.toJson<double?>(leftPupilSize),
      'rightPupilReaction': serializer.toJson<String?>(rightPupilReaction),
      'rightPupilSize': serializer.toJson<double?>(rightPupilSize),
      'headNeckExam': serializer.toJson<String?>(headNeckExam),
      'chestExam': serializer.toJson<String?>(chestExam),
      'abdomenExam': serializer.toJson<String?>(abdomenExam),
      'extremitiesExam': serializer.toJson<String?>(extremitiesExam),
      'otherPhysicalExam': serializer.toJson<String?>(otherPhysicalExam),
      'triageId': serializer.toJson<int?>(triageId),
      'assessmentTime': serializer.toJson<DateTime>(assessmentTime),
    };
  }

  MedicalAssessmentData copyWith({
    int? assessmentId,
    int? medicalId,
    Value<double?> temperature = const Value.absent(),
    Value<int?> pulse = const Value.absent(),
    Value<int?> breath = const Value.absent(),
    Value<int?> systolic = const Value.absent(),
    Value<int?> diastolic = const Value.absent(),
    Value<int?> spo2 = const Value.absent(),
    Value<int?> painScore = const Value.absent(),
    Value<String?> consciousnessLevel = const Value.absent(),
    Value<int?> gcs = const Value.absent(),
    Value<String?> gcsE = const Value.absent(),
    Value<String?> gcsM = const Value.absent(),
    Value<String?> gcsV = const Value.absent(),
    Value<String?> leftPupilReaction = const Value.absent(),
    Value<double?> leftPupilSize = const Value.absent(),
    Value<String?> rightPupilReaction = const Value.absent(),
    Value<double?> rightPupilSize = const Value.absent(),
    Value<String?> headNeckExam = const Value.absent(),
    Value<String?> chestExam = const Value.absent(),
    Value<String?> abdomenExam = const Value.absent(),
    Value<String?> extremitiesExam = const Value.absent(),
    Value<String?> otherPhysicalExam = const Value.absent(),
    Value<int?> triageId = const Value.absent(),
    DateTime? assessmentTime,
  }) => MedicalAssessmentData(
    assessmentId: assessmentId ?? this.assessmentId,
    medicalId: medicalId ?? this.medicalId,
    temperature: temperature.present ? temperature.value : this.temperature,
    pulse: pulse.present ? pulse.value : this.pulse,
    breath: breath.present ? breath.value : this.breath,
    systolic: systolic.present ? systolic.value : this.systolic,
    diastolic: diastolic.present ? diastolic.value : this.diastolic,
    spo2: spo2.present ? spo2.value : this.spo2,
    painScore: painScore.present ? painScore.value : this.painScore,
    consciousnessLevel: consciousnessLevel.present
        ? consciousnessLevel.value
        : this.consciousnessLevel,
    gcs: gcs.present ? gcs.value : this.gcs,
    gcsE: gcsE.present ? gcsE.value : this.gcsE,
    gcsM: gcsM.present ? gcsM.value : this.gcsM,
    gcsV: gcsV.present ? gcsV.value : this.gcsV,
    leftPupilReaction: leftPupilReaction.present
        ? leftPupilReaction.value
        : this.leftPupilReaction,
    leftPupilSize: leftPupilSize.present
        ? leftPupilSize.value
        : this.leftPupilSize,
    rightPupilReaction: rightPupilReaction.present
        ? rightPupilReaction.value
        : this.rightPupilReaction,
    rightPupilSize: rightPupilSize.present
        ? rightPupilSize.value
        : this.rightPupilSize,
    headNeckExam: headNeckExam.present ? headNeckExam.value : this.headNeckExam,
    chestExam: chestExam.present ? chestExam.value : this.chestExam,
    abdomenExam: abdomenExam.present ? abdomenExam.value : this.abdomenExam,
    extremitiesExam: extremitiesExam.present
        ? extremitiesExam.value
        : this.extremitiesExam,
    otherPhysicalExam: otherPhysicalExam.present
        ? otherPhysicalExam.value
        : this.otherPhysicalExam,
    triageId: triageId.present ? triageId.value : this.triageId,
    assessmentTime: assessmentTime ?? this.assessmentTime,
  );
  MedicalAssessmentData copyWithCompanion(MedicalAssessmentCompanion data) {
    return MedicalAssessmentData(
      assessmentId: data.assessmentId.present
          ? data.assessmentId.value
          : this.assessmentId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      pulse: data.pulse.present ? data.pulse.value : this.pulse,
      breath: data.breath.present ? data.breath.value : this.breath,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      spo2: data.spo2.present ? data.spo2.value : this.spo2,
      painScore: data.painScore.present ? data.painScore.value : this.painScore,
      consciousnessLevel: data.consciousnessLevel.present
          ? data.consciousnessLevel.value
          : this.consciousnessLevel,
      gcs: data.gcs.present ? data.gcs.value : this.gcs,
      gcsE: data.gcsE.present ? data.gcsE.value : this.gcsE,
      gcsM: data.gcsM.present ? data.gcsM.value : this.gcsM,
      gcsV: data.gcsV.present ? data.gcsV.value : this.gcsV,
      leftPupilReaction: data.leftPupilReaction.present
          ? data.leftPupilReaction.value
          : this.leftPupilReaction,
      leftPupilSize: data.leftPupilSize.present
          ? data.leftPupilSize.value
          : this.leftPupilSize,
      rightPupilReaction: data.rightPupilReaction.present
          ? data.rightPupilReaction.value
          : this.rightPupilReaction,
      rightPupilSize: data.rightPupilSize.present
          ? data.rightPupilSize.value
          : this.rightPupilSize,
      headNeckExam: data.headNeckExam.present
          ? data.headNeckExam.value
          : this.headNeckExam,
      chestExam: data.chestExam.present ? data.chestExam.value : this.chestExam,
      abdomenExam: data.abdomenExam.present
          ? data.abdomenExam.value
          : this.abdomenExam,
      extremitiesExam: data.extremitiesExam.present
          ? data.extremitiesExam.value
          : this.extremitiesExam,
      otherPhysicalExam: data.otherPhysicalExam.present
          ? data.otherPhysicalExam.value
          : this.otherPhysicalExam,
      triageId: data.triageId.present ? data.triageId.value : this.triageId,
      assessmentTime: data.assessmentTime.present
          ? data.assessmentTime.value
          : this.assessmentTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalAssessmentData(')
          ..write('assessmentId: $assessmentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('temperature: $temperature, ')
          ..write('pulse: $pulse, ')
          ..write('breath: $breath, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('spo2: $spo2, ')
          ..write('painScore: $painScore, ')
          ..write('consciousnessLevel: $consciousnessLevel, ')
          ..write('gcs: $gcs, ')
          ..write('gcsE: $gcsE, ')
          ..write('gcsM: $gcsM, ')
          ..write('gcsV: $gcsV, ')
          ..write('leftPupilReaction: $leftPupilReaction, ')
          ..write('leftPupilSize: $leftPupilSize, ')
          ..write('rightPupilReaction: $rightPupilReaction, ')
          ..write('rightPupilSize: $rightPupilSize, ')
          ..write('headNeckExam: $headNeckExam, ')
          ..write('chestExam: $chestExam, ')
          ..write('abdomenExam: $abdomenExam, ')
          ..write('extremitiesExam: $extremitiesExam, ')
          ..write('otherPhysicalExam: $otherPhysicalExam, ')
          ..write('triageId: $triageId, ')
          ..write('assessmentTime: $assessmentTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    assessmentId,
    medicalId,
    temperature,
    pulse,
    breath,
    systolic,
    diastolic,
    spo2,
    painScore,
    consciousnessLevel,
    gcs,
    gcsE,
    gcsM,
    gcsV,
    leftPupilReaction,
    leftPupilSize,
    rightPupilReaction,
    rightPupilSize,
    headNeckExam,
    chestExam,
    abdomenExam,
    extremitiesExam,
    otherPhysicalExam,
    triageId,
    assessmentTime,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalAssessmentData &&
          other.assessmentId == this.assessmentId &&
          other.medicalId == this.medicalId &&
          other.temperature == this.temperature &&
          other.pulse == this.pulse &&
          other.breath == this.breath &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.spo2 == this.spo2 &&
          other.painScore == this.painScore &&
          other.consciousnessLevel == this.consciousnessLevel &&
          other.gcs == this.gcs &&
          other.gcsE == this.gcsE &&
          other.gcsM == this.gcsM &&
          other.gcsV == this.gcsV &&
          other.leftPupilReaction == this.leftPupilReaction &&
          other.leftPupilSize == this.leftPupilSize &&
          other.rightPupilReaction == this.rightPupilReaction &&
          other.rightPupilSize == this.rightPupilSize &&
          other.headNeckExam == this.headNeckExam &&
          other.chestExam == this.chestExam &&
          other.abdomenExam == this.abdomenExam &&
          other.extremitiesExam == this.extremitiesExam &&
          other.otherPhysicalExam == this.otherPhysicalExam &&
          other.triageId == this.triageId &&
          other.assessmentTime == this.assessmentTime);
}

class MedicalAssessmentCompanion
    extends UpdateCompanion<MedicalAssessmentData> {
  final Value<int> assessmentId;
  final Value<int> medicalId;
  final Value<double?> temperature;
  final Value<int?> pulse;
  final Value<int?> breath;
  final Value<int?> systolic;
  final Value<int?> diastolic;
  final Value<int?> spo2;
  final Value<int?> painScore;
  final Value<String?> consciousnessLevel;
  final Value<int?> gcs;
  final Value<String?> gcsE;
  final Value<String?> gcsM;
  final Value<String?> gcsV;
  final Value<String?> leftPupilReaction;
  final Value<double?> leftPupilSize;
  final Value<String?> rightPupilReaction;
  final Value<double?> rightPupilSize;
  final Value<String?> headNeckExam;
  final Value<String?> chestExam;
  final Value<String?> abdomenExam;
  final Value<String?> extremitiesExam;
  final Value<String?> otherPhysicalExam;
  final Value<int?> triageId;
  final Value<DateTime> assessmentTime;
  const MedicalAssessmentCompanion({
    this.assessmentId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.pulse = const Value.absent(),
    this.breath = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.painScore = const Value.absent(),
    this.consciousnessLevel = const Value.absent(),
    this.gcs = const Value.absent(),
    this.gcsE = const Value.absent(),
    this.gcsM = const Value.absent(),
    this.gcsV = const Value.absent(),
    this.leftPupilReaction = const Value.absent(),
    this.leftPupilSize = const Value.absent(),
    this.rightPupilReaction = const Value.absent(),
    this.rightPupilSize = const Value.absent(),
    this.headNeckExam = const Value.absent(),
    this.chestExam = const Value.absent(),
    this.abdomenExam = const Value.absent(),
    this.extremitiesExam = const Value.absent(),
    this.otherPhysicalExam = const Value.absent(),
    this.triageId = const Value.absent(),
    this.assessmentTime = const Value.absent(),
  });
  MedicalAssessmentCompanion.insert({
    this.assessmentId = const Value.absent(),
    required int medicalId,
    this.temperature = const Value.absent(),
    this.pulse = const Value.absent(),
    this.breath = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.painScore = const Value.absent(),
    this.consciousnessLevel = const Value.absent(),
    this.gcs = const Value.absent(),
    this.gcsE = const Value.absent(),
    this.gcsM = const Value.absent(),
    this.gcsV = const Value.absent(),
    this.leftPupilReaction = const Value.absent(),
    this.leftPupilSize = const Value.absent(),
    this.rightPupilReaction = const Value.absent(),
    this.rightPupilSize = const Value.absent(),
    this.headNeckExam = const Value.absent(),
    this.chestExam = const Value.absent(),
    this.abdomenExam = const Value.absent(),
    this.extremitiesExam = const Value.absent(),
    this.otherPhysicalExam = const Value.absent(),
    this.triageId = const Value.absent(),
    this.assessmentTime = const Value.absent(),
  }) : medicalId = Value(medicalId);
  static Insertable<MedicalAssessmentData> custom({
    Expression<int>? assessmentId,
    Expression<int>? medicalId,
    Expression<double>? temperature,
    Expression<int>? pulse,
    Expression<int>? breath,
    Expression<int>? systolic,
    Expression<int>? diastolic,
    Expression<int>? spo2,
    Expression<int>? painScore,
    Expression<String>? consciousnessLevel,
    Expression<int>? gcs,
    Expression<String>? gcsE,
    Expression<String>? gcsM,
    Expression<String>? gcsV,
    Expression<String>? leftPupilReaction,
    Expression<double>? leftPupilSize,
    Expression<String>? rightPupilReaction,
    Expression<double>? rightPupilSize,
    Expression<String>? headNeckExam,
    Expression<String>? chestExam,
    Expression<String>? abdomenExam,
    Expression<String>? extremitiesExam,
    Expression<String>? otherPhysicalExam,
    Expression<int>? triageId,
    Expression<DateTime>? assessmentTime,
  }) {
    return RawValuesInsertable({
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (medicalId != null) 'medical_id': medicalId,
      if (temperature != null) 'temperature': temperature,
      if (pulse != null) 'pulse': pulse,
      if (breath != null) 'breath': breath,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (spo2 != null) 'spo2': spo2,
      if (painScore != null) 'pain_score': painScore,
      if (consciousnessLevel != null) 'consciousness_level': consciousnessLevel,
      if (gcs != null) 'gcs': gcs,
      if (gcsE != null) 'gcs_e': gcsE,
      if (gcsM != null) 'gcs_m': gcsM,
      if (gcsV != null) 'gcs_v': gcsV,
      if (leftPupilReaction != null) 'left_pupil_reaction': leftPupilReaction,
      if (leftPupilSize != null) 'left_pupil_size': leftPupilSize,
      if (rightPupilReaction != null)
        'right_pupil_reaction': rightPupilReaction,
      if (rightPupilSize != null) 'right_pupil_size': rightPupilSize,
      if (headNeckExam != null) 'head_neck_exam': headNeckExam,
      if (chestExam != null) 'chest_exam': chestExam,
      if (abdomenExam != null) 'abdomen_exam': abdomenExam,
      if (extremitiesExam != null) 'extremities_exam': extremitiesExam,
      if (otherPhysicalExam != null) 'other_physical_exam': otherPhysicalExam,
      if (triageId != null) 'triage_id': triageId,
      if (assessmentTime != null) 'assessment_time': assessmentTime,
    });
  }

  MedicalAssessmentCompanion copyWith({
    Value<int>? assessmentId,
    Value<int>? medicalId,
    Value<double?>? temperature,
    Value<int?>? pulse,
    Value<int?>? breath,
    Value<int?>? systolic,
    Value<int?>? diastolic,
    Value<int?>? spo2,
    Value<int?>? painScore,
    Value<String?>? consciousnessLevel,
    Value<int?>? gcs,
    Value<String?>? gcsE,
    Value<String?>? gcsM,
    Value<String?>? gcsV,
    Value<String?>? leftPupilReaction,
    Value<double?>? leftPupilSize,
    Value<String?>? rightPupilReaction,
    Value<double?>? rightPupilSize,
    Value<String?>? headNeckExam,
    Value<String?>? chestExam,
    Value<String?>? abdomenExam,
    Value<String?>? extremitiesExam,
    Value<String?>? otherPhysicalExam,
    Value<int?>? triageId,
    Value<DateTime>? assessmentTime,
  }) {
    return MedicalAssessmentCompanion(
      assessmentId: assessmentId ?? this.assessmentId,
      medicalId: medicalId ?? this.medicalId,
      temperature: temperature ?? this.temperature,
      pulse: pulse ?? this.pulse,
      breath: breath ?? this.breath,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      spo2: spo2 ?? this.spo2,
      painScore: painScore ?? this.painScore,
      consciousnessLevel: consciousnessLevel ?? this.consciousnessLevel,
      gcs: gcs ?? this.gcs,
      gcsE: gcsE ?? this.gcsE,
      gcsM: gcsM ?? this.gcsM,
      gcsV: gcsV ?? this.gcsV,
      leftPupilReaction: leftPupilReaction ?? this.leftPupilReaction,
      leftPupilSize: leftPupilSize ?? this.leftPupilSize,
      rightPupilReaction: rightPupilReaction ?? this.rightPupilReaction,
      rightPupilSize: rightPupilSize ?? this.rightPupilSize,
      headNeckExam: headNeckExam ?? this.headNeckExam,
      chestExam: chestExam ?? this.chestExam,
      abdomenExam: abdomenExam ?? this.abdomenExam,
      extremitiesExam: extremitiesExam ?? this.extremitiesExam,
      otherPhysicalExam: otherPhysicalExam ?? this.otherPhysicalExam,
      triageId: triageId ?? this.triageId,
      assessmentTime: assessmentTime ?? this.assessmentTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assessmentId.present) {
      map['assessment_id'] = Variable<int>(assessmentId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (pulse.present) {
      map['pulse'] = Variable<int>(pulse.value);
    }
    if (breath.present) {
      map['breath'] = Variable<int>(breath.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<int>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<int>(diastolic.value);
    }
    if (spo2.present) {
      map['spo2'] = Variable<int>(spo2.value);
    }
    if (painScore.present) {
      map['pain_score'] = Variable<int>(painScore.value);
    }
    if (consciousnessLevel.present) {
      map['consciousness_level'] = Variable<String>(consciousnessLevel.value);
    }
    if (gcs.present) {
      map['gcs'] = Variable<int>(gcs.value);
    }
    if (gcsE.present) {
      map['gcs_e'] = Variable<String>(gcsE.value);
    }
    if (gcsM.present) {
      map['gcs_m'] = Variable<String>(gcsM.value);
    }
    if (gcsV.present) {
      map['gcs_v'] = Variable<String>(gcsV.value);
    }
    if (leftPupilReaction.present) {
      map['left_pupil_reaction'] = Variable<String>(leftPupilReaction.value);
    }
    if (leftPupilSize.present) {
      map['left_pupil_size'] = Variable<double>(leftPupilSize.value);
    }
    if (rightPupilReaction.present) {
      map['right_pupil_reaction'] = Variable<String>(rightPupilReaction.value);
    }
    if (rightPupilSize.present) {
      map['right_pupil_size'] = Variable<double>(rightPupilSize.value);
    }
    if (headNeckExam.present) {
      map['head_neck_exam'] = Variable<String>(headNeckExam.value);
    }
    if (chestExam.present) {
      map['chest_exam'] = Variable<String>(chestExam.value);
    }
    if (abdomenExam.present) {
      map['abdomen_exam'] = Variable<String>(abdomenExam.value);
    }
    if (extremitiesExam.present) {
      map['extremities_exam'] = Variable<String>(extremitiesExam.value);
    }
    if (otherPhysicalExam.present) {
      map['other_physical_exam'] = Variable<String>(otherPhysicalExam.value);
    }
    if (triageId.present) {
      map['triage_id'] = Variable<int>(triageId.value);
    }
    if (assessmentTime.present) {
      map['assessment_time'] = Variable<DateTime>(assessmentTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalAssessmentCompanion(')
          ..write('assessmentId: $assessmentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('temperature: $temperature, ')
          ..write('pulse: $pulse, ')
          ..write('breath: $breath, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('spo2: $spo2, ')
          ..write('painScore: $painScore, ')
          ..write('consciousnessLevel: $consciousnessLevel, ')
          ..write('gcs: $gcs, ')
          ..write('gcsE: $gcsE, ')
          ..write('gcsM: $gcsM, ')
          ..write('gcsV: $gcsV, ')
          ..write('leftPupilReaction: $leftPupilReaction, ')
          ..write('leftPupilSize: $leftPupilSize, ')
          ..write('rightPupilReaction: $rightPupilReaction, ')
          ..write('rightPupilSize: $rightPupilSize, ')
          ..write('headNeckExam: $headNeckExam, ')
          ..write('chestExam: $chestExam, ')
          ..write('abdomenExam: $abdomenExam, ')
          ..write('extremitiesExam: $extremitiesExam, ')
          ..write('otherPhysicalExam: $otherPhysicalExam, ')
          ..write('triageId: $triageId, ')
          ..write('assessmentTime: $assessmentTime')
          ..write(')'))
        .toString();
  }
}

class $MedicalHistoryTable extends MedicalHistory
    with TableInfo<$MedicalHistoryTable, MedicalHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _historyIdMeta = const VerificationMeta(
    'historyId',
  );
  @override
  late final GeneratedColumn<int> historyId = GeneratedColumn<int>(
    'history_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _pastHistoryStatusMeta = const VerificationMeta(
    'pastHistoryStatus',
  );
  @override
  late final GeneratedColumn<String> pastHistoryStatus =
      GeneratedColumn<String>(
        'past_history_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _pastHistoryDetailMeta = const VerificationMeta(
    'pastHistoryDetail',
  );
  @override
  late final GeneratedColumn<String> pastHistoryDetail =
      GeneratedColumn<String>(
        'past_history_detail',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _allergyStatusMeta = const VerificationMeta(
    'allergyStatus',
  );
  @override
  late final GeneratedColumn<String> allergyStatus = GeneratedColumn<String>(
    'allergy_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allergyDetailMeta = const VerificationMeta(
    'allergyDetail',
  );
  @override
  late final GeneratedColumn<String> allergyDetail = GeneratedColumn<String>(
    'allergy_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    historyId,
    medicalId,
    pastHistoryStatus,
    pastHistoryDetail,
    allergyStatus,
    allergyDetail,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('history_id')) {
      context.handle(
        _historyIdMeta,
        historyId.isAcceptableOrUnknown(data['history_id']!, _historyIdMeta),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('past_history_status')) {
      context.handle(
        _pastHistoryStatusMeta,
        pastHistoryStatus.isAcceptableOrUnknown(
          data['past_history_status']!,
          _pastHistoryStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pastHistoryStatusMeta);
    }
    if (data.containsKey('past_history_detail')) {
      context.handle(
        _pastHistoryDetailMeta,
        pastHistoryDetail.isAcceptableOrUnknown(
          data['past_history_detail']!,
          _pastHistoryDetailMeta,
        ),
      );
    }
    if (data.containsKey('allergy_status')) {
      context.handle(
        _allergyStatusMeta,
        allergyStatus.isAcceptableOrUnknown(
          data['allergy_status']!,
          _allergyStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allergyStatusMeta);
    }
    if (data.containsKey('allergy_detail')) {
      context.handle(
        _allergyDetailMeta,
        allergyDetail.isAcceptableOrUnknown(
          data['allergy_detail']!,
          _allergyDetailMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {historyId};
  @override
  MedicalHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalHistoryData(
      historyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}history_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      pastHistoryStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}past_history_status'],
      )!,
      pastHistoryDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}past_history_detail'],
      ),
      allergyStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergy_status'],
      )!,
      allergyDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergy_detail'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicalHistoryTable createAlias(String alias) {
    return $MedicalHistoryTable(attachedDatabase, alias);
  }
}

class MedicalHistoryData extends DataClass
    implements Insertable<MedicalHistoryData> {
  final int historyId;
  final int medicalId;
  final String pastHistoryStatus;
  final String? pastHistoryDetail;
  final String allergyStatus;
  final String? allergyDetail;
  final DateTime createdAt;
  const MedicalHistoryData({
    required this.historyId,
    required this.medicalId,
    required this.pastHistoryStatus,
    this.pastHistoryDetail,
    required this.allergyStatus,
    this.allergyDetail,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['history_id'] = Variable<int>(historyId);
    map['medical_id'] = Variable<int>(medicalId);
    map['past_history_status'] = Variable<String>(pastHistoryStatus);
    if (!nullToAbsent || pastHistoryDetail != null) {
      map['past_history_detail'] = Variable<String>(pastHistoryDetail);
    }
    map['allergy_status'] = Variable<String>(allergyStatus);
    if (!nullToAbsent || allergyDetail != null) {
      map['allergy_detail'] = Variable<String>(allergyDetail);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicalHistoryCompanion toCompanion(bool nullToAbsent) {
    return MedicalHistoryCompanion(
      historyId: Value(historyId),
      medicalId: Value(medicalId),
      pastHistoryStatus: Value(pastHistoryStatus),
      pastHistoryDetail: pastHistoryDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(pastHistoryDetail),
      allergyStatus: Value(allergyStatus),
      allergyDetail: allergyDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(allergyDetail),
      createdAt: Value(createdAt),
    );
  }

  factory MedicalHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalHistoryData(
      historyId: serializer.fromJson<int>(json['historyId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      pastHistoryStatus: serializer.fromJson<String>(json['pastHistoryStatus']),
      pastHistoryDetail: serializer.fromJson<String?>(
        json['pastHistoryDetail'],
      ),
      allergyStatus: serializer.fromJson<String>(json['allergyStatus']),
      allergyDetail: serializer.fromJson<String?>(json['allergyDetail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'historyId': serializer.toJson<int>(historyId),
      'medicalId': serializer.toJson<int>(medicalId),
      'pastHistoryStatus': serializer.toJson<String>(pastHistoryStatus),
      'pastHistoryDetail': serializer.toJson<String?>(pastHistoryDetail),
      'allergyStatus': serializer.toJson<String>(allergyStatus),
      'allergyDetail': serializer.toJson<String?>(allergyDetail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicalHistoryData copyWith({
    int? historyId,
    int? medicalId,
    String? pastHistoryStatus,
    Value<String?> pastHistoryDetail = const Value.absent(),
    String? allergyStatus,
    Value<String?> allergyDetail = const Value.absent(),
    DateTime? createdAt,
  }) => MedicalHistoryData(
    historyId: historyId ?? this.historyId,
    medicalId: medicalId ?? this.medicalId,
    pastHistoryStatus: pastHistoryStatus ?? this.pastHistoryStatus,
    pastHistoryDetail: pastHistoryDetail.present
        ? pastHistoryDetail.value
        : this.pastHistoryDetail,
    allergyStatus: allergyStatus ?? this.allergyStatus,
    allergyDetail: allergyDetail.present
        ? allergyDetail.value
        : this.allergyDetail,
    createdAt: createdAt ?? this.createdAt,
  );
  MedicalHistoryData copyWithCompanion(MedicalHistoryCompanion data) {
    return MedicalHistoryData(
      historyId: data.historyId.present ? data.historyId.value : this.historyId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      pastHistoryStatus: data.pastHistoryStatus.present
          ? data.pastHistoryStatus.value
          : this.pastHistoryStatus,
      pastHistoryDetail: data.pastHistoryDetail.present
          ? data.pastHistoryDetail.value
          : this.pastHistoryDetail,
      allergyStatus: data.allergyStatus.present
          ? data.allergyStatus.value
          : this.allergyStatus,
      allergyDetail: data.allergyDetail.present
          ? data.allergyDetail.value
          : this.allergyDetail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalHistoryData(')
          ..write('historyId: $historyId, ')
          ..write('medicalId: $medicalId, ')
          ..write('pastHistoryStatus: $pastHistoryStatus, ')
          ..write('pastHistoryDetail: $pastHistoryDetail, ')
          ..write('allergyStatus: $allergyStatus, ')
          ..write('allergyDetail: $allergyDetail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    historyId,
    medicalId,
    pastHistoryStatus,
    pastHistoryDetail,
    allergyStatus,
    allergyDetail,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalHistoryData &&
          other.historyId == this.historyId &&
          other.medicalId == this.medicalId &&
          other.pastHistoryStatus == this.pastHistoryStatus &&
          other.pastHistoryDetail == this.pastHistoryDetail &&
          other.allergyStatus == this.allergyStatus &&
          other.allergyDetail == this.allergyDetail &&
          other.createdAt == this.createdAt);
}

class MedicalHistoryCompanion extends UpdateCompanion<MedicalHistoryData> {
  final Value<int> historyId;
  final Value<int> medicalId;
  final Value<String> pastHistoryStatus;
  final Value<String?> pastHistoryDetail;
  final Value<String> allergyStatus;
  final Value<String?> allergyDetail;
  final Value<DateTime> createdAt;
  const MedicalHistoryCompanion({
    this.historyId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.pastHistoryStatus = const Value.absent(),
    this.pastHistoryDetail = const Value.absent(),
    this.allergyStatus = const Value.absent(),
    this.allergyDetail = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MedicalHistoryCompanion.insert({
    this.historyId = const Value.absent(),
    required int medicalId,
    required String pastHistoryStatus,
    this.pastHistoryDetail = const Value.absent(),
    required String allergyStatus,
    this.allergyDetail = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId),
       pastHistoryStatus = Value(pastHistoryStatus),
       allergyStatus = Value(allergyStatus);
  static Insertable<MedicalHistoryData> custom({
    Expression<int>? historyId,
    Expression<int>? medicalId,
    Expression<String>? pastHistoryStatus,
    Expression<String>? pastHistoryDetail,
    Expression<String>? allergyStatus,
    Expression<String>? allergyDetail,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (historyId != null) 'history_id': historyId,
      if (medicalId != null) 'medical_id': medicalId,
      if (pastHistoryStatus != null) 'past_history_status': pastHistoryStatus,
      if (pastHistoryDetail != null) 'past_history_detail': pastHistoryDetail,
      if (allergyStatus != null) 'allergy_status': allergyStatus,
      if (allergyDetail != null) 'allergy_detail': allergyDetail,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MedicalHistoryCompanion copyWith({
    Value<int>? historyId,
    Value<int>? medicalId,
    Value<String>? pastHistoryStatus,
    Value<String?>? pastHistoryDetail,
    Value<String>? allergyStatus,
    Value<String?>? allergyDetail,
    Value<DateTime>? createdAt,
  }) {
    return MedicalHistoryCompanion(
      historyId: historyId ?? this.historyId,
      medicalId: medicalId ?? this.medicalId,
      pastHistoryStatus: pastHistoryStatus ?? this.pastHistoryStatus,
      pastHistoryDetail: pastHistoryDetail ?? this.pastHistoryDetail,
      allergyStatus: allergyStatus ?? this.allergyStatus,
      allergyDetail: allergyDetail ?? this.allergyDetail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (historyId.present) {
      map['history_id'] = Variable<int>(historyId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (pastHistoryStatus.present) {
      map['past_history_status'] = Variable<String>(pastHistoryStatus.value);
    }
    if (pastHistoryDetail.present) {
      map['past_history_detail'] = Variable<String>(pastHistoryDetail.value);
    }
    if (allergyStatus.present) {
      map['allergy_status'] = Variable<String>(allergyStatus.value);
    }
    if (allergyDetail.present) {
      map['allergy_detail'] = Variable<String>(allergyDetail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalHistoryCompanion(')
          ..write('historyId: $historyId, ')
          ..write('medicalId: $medicalId, ')
          ..write('pastHistoryStatus: $pastHistoryStatus, ')
          ..write('pastHistoryDetail: $pastHistoryDetail, ')
          ..write('allergyStatus: $allergyStatus, ')
          ..write('allergyDetail: $allergyDetail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TreatmentTable extends Treatment
    with TableInfo<$TreatmentTable, TreatmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _treatmentIdMeta = const VerificationMeta(
    'treatmentId',
  );
  @override
  late final GeneratedColumn<int> treatmentId = GeneratedColumn<int>(
    'treatment_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _tentativeCategoryIdMeta =
      const VerificationMeta('tentativeCategoryId');
  @override
  late final GeneratedColumn<int> tentativeCategoryId = GeneratedColumn<int>(
    'tentative_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tentativeMeta = const VerificationMeta(
    'tentative',
  );
  @override
  late final GeneratedColumn<String> tentative = GeneratedColumn<String>(
    'tentative',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _secondaryDiagnosis1Meta =
      const VerificationMeta('secondaryDiagnosis1');
  @override
  late final GeneratedColumn<String> secondaryDiagnosis1 =
      GeneratedColumn<String>(
        'secondary_diagnosis1',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _secondaryDiagnosis2Meta =
      const VerificationMeta('secondaryDiagnosis2');
  @override
  late final GeneratedColumn<String> secondaryDiagnosis2 =
      GeneratedColumn<String>(
        'secondary_diagnosis2',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _triageIdMeta = const VerificationMeta(
    'triageId',
  );
  @override
  late final GeneratedColumn<int> triageId = GeneratedColumn<int>(
    'triage_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _treatmentOnSiteIdMeta = const VerificationMeta(
    'treatmentOnSiteId',
  );
  @override
  late final GeneratedColumn<int> treatmentOnSiteId = GeneratedColumn<int>(
    'treatment_on_site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionSummaryMeta = const VerificationMeta(
    'actionSummary',
  );
  @override
  late final GeneratedColumn<String> actionSummary = GeneratedColumn<String>(
    'action_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionSummaryOtherMeta =
      const VerificationMeta('actionSummaryOther');
  @override
  late final GeneratedColumn<String> actionSummaryOther =
      GeneratedColumn<String>(
        'action_summary_other',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _resultIdMeta = const VerificationMeta(
    'resultId',
  );
  @override
  late final GeneratedColumn<int> resultId = GeneratedColumn<int>(
    'result_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transportRequiredMeta = const VerificationMeta(
    'transportRequired',
  );
  @override
  late final GeneratedColumn<bool> transportRequired = GeneratedColumn<bool>(
    'transport_required',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("transport_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _transportMethodMeta = const VerificationMeta(
    'transportMethod',
  );
  @override
  late final GeneratedColumn<String> transportMethod = GeneratedColumn<String>(
    'transport_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referralHospitalIdMeta =
      const VerificationMeta('referralHospitalId');
  @override
  late final GeneratedColumn<int> referralHospitalId = GeneratedColumn<int>(
    'referral_hospital_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referralHospitalFinalMeta =
      const VerificationMeta('referralHospitalFinal');
  @override
  late final GeneratedColumn<String> referralHospitalFinal =
      GeneratedColumn<String>(
        'referral_hospital_final',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _arrivalTimeMeta = const VerificationMeta(
    'arrivalTime',
  );
  @override
  late final GeneratedColumn<DateTime> arrivalTime = GeneratedColumn<DateTime>(
    'arrival_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clearanceIdMeta = const VerificationMeta(
    'clearanceId',
  );
  @override
  late final GeneratedColumn<int> clearanceId = GeneratedColumn<int>(
    'clearance_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expeditedClearanceIdMeta =
      const VerificationMeta('expeditedClearanceId');
  @override
  late final GeneratedColumn<int> expeditedClearanceId = GeneratedColumn<int>(
    'expedited_clearance_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorOrderChMeta = const VerificationMeta(
    'doctorOrderCh',
  );
  @override
  late final GeneratedColumn<String> doctorOrderCh = GeneratedColumn<String>(
    'doctor_order_ch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorOrderEnMeta = const VerificationMeta(
    'doctorOrderEn',
  );
  @override
  late final GeneratedColumn<String> doctorOrderEn = GeneratedColumn<String>(
    'doctor_order_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _directorNameMeta = const VerificationMeta(
    'directorName',
  );
  @override
  late final GeneratedColumn<String> directorName = GeneratedColumn<String>(
    'director_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assistStaffMeta = const VerificationMeta(
    'assistStaff',
  );
  @override
  late final GeneratedColumn<String> assistStaff = GeneratedColumn<String>(
    'assist_staff',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _treatmentTimeMeta = const VerificationMeta(
    'treatmentTime',
  );
  @override
  late final GeneratedColumn<DateTime> treatmentTime =
      GeneratedColumn<DateTime>(
        'treatment_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    treatmentId,
    medicalId,
    tentativeCategoryId,
    tentative,
    secondaryDiagnosis1,
    secondaryDiagnosis2,
    triageId,
    treatmentOnSiteId,
    actionSummary,
    actionSummaryOther,
    resultId,
    transportRequired,
    transportMethod,
    referralHospitalId,
    referralHospitalFinal,
    arrivalTime,
    clearanceId,
    expeditedClearanceId,
    doctorOrderCh,
    doctorOrderEn,
    directorName,
    assistStaff,
    treatmentTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treatment';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreatmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('treatment_id')) {
      context.handle(
        _treatmentIdMeta,
        treatmentId.isAcceptableOrUnknown(
          data['treatment_id']!,
          _treatmentIdMeta,
        ),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('tentative_category_id')) {
      context.handle(
        _tentativeCategoryIdMeta,
        tentativeCategoryId.isAcceptableOrUnknown(
          data['tentative_category_id']!,
          _tentativeCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('tentative')) {
      context.handle(
        _tentativeMeta,
        tentative.isAcceptableOrUnknown(data['tentative']!, _tentativeMeta),
      );
    }
    if (data.containsKey('secondary_diagnosis1')) {
      context.handle(
        _secondaryDiagnosis1Meta,
        secondaryDiagnosis1.isAcceptableOrUnknown(
          data['secondary_diagnosis1']!,
          _secondaryDiagnosis1Meta,
        ),
      );
    }
    if (data.containsKey('secondary_diagnosis2')) {
      context.handle(
        _secondaryDiagnosis2Meta,
        secondaryDiagnosis2.isAcceptableOrUnknown(
          data['secondary_diagnosis2']!,
          _secondaryDiagnosis2Meta,
        ),
      );
    }
    if (data.containsKey('triage_id')) {
      context.handle(
        _triageIdMeta,
        triageId.isAcceptableOrUnknown(data['triage_id']!, _triageIdMeta),
      );
    }
    if (data.containsKey('treatment_on_site_id')) {
      context.handle(
        _treatmentOnSiteIdMeta,
        treatmentOnSiteId.isAcceptableOrUnknown(
          data['treatment_on_site_id']!,
          _treatmentOnSiteIdMeta,
        ),
      );
    }
    if (data.containsKey('action_summary')) {
      context.handle(
        _actionSummaryMeta,
        actionSummary.isAcceptableOrUnknown(
          data['action_summary']!,
          _actionSummaryMeta,
        ),
      );
    }
    if (data.containsKey('action_summary_other')) {
      context.handle(
        _actionSummaryOtherMeta,
        actionSummaryOther.isAcceptableOrUnknown(
          data['action_summary_other']!,
          _actionSummaryOtherMeta,
        ),
      );
    }
    if (data.containsKey('result_id')) {
      context.handle(
        _resultIdMeta,
        resultId.isAcceptableOrUnknown(data['result_id']!, _resultIdMeta),
      );
    }
    if (data.containsKey('transport_required')) {
      context.handle(
        _transportRequiredMeta,
        transportRequired.isAcceptableOrUnknown(
          data['transport_required']!,
          _transportRequiredMeta,
        ),
      );
    }
    if (data.containsKey('transport_method')) {
      context.handle(
        _transportMethodMeta,
        transportMethod.isAcceptableOrUnknown(
          data['transport_method']!,
          _transportMethodMeta,
        ),
      );
    }
    if (data.containsKey('referral_hospital_id')) {
      context.handle(
        _referralHospitalIdMeta,
        referralHospitalId.isAcceptableOrUnknown(
          data['referral_hospital_id']!,
          _referralHospitalIdMeta,
        ),
      );
    }
    if (data.containsKey('referral_hospital_final')) {
      context.handle(
        _referralHospitalFinalMeta,
        referralHospitalFinal.isAcceptableOrUnknown(
          data['referral_hospital_final']!,
          _referralHospitalFinalMeta,
        ),
      );
    }
    if (data.containsKey('arrival_time')) {
      context.handle(
        _arrivalTimeMeta,
        arrivalTime.isAcceptableOrUnknown(
          data['arrival_time']!,
          _arrivalTimeMeta,
        ),
      );
    }
    if (data.containsKey('clearance_id')) {
      context.handle(
        _clearanceIdMeta,
        clearanceId.isAcceptableOrUnknown(
          data['clearance_id']!,
          _clearanceIdMeta,
        ),
      );
    }
    if (data.containsKey('expedited_clearance_id')) {
      context.handle(
        _expeditedClearanceIdMeta,
        expeditedClearanceId.isAcceptableOrUnknown(
          data['expedited_clearance_id']!,
          _expeditedClearanceIdMeta,
        ),
      );
    }
    if (data.containsKey('doctor_order_ch')) {
      context.handle(
        _doctorOrderChMeta,
        doctorOrderCh.isAcceptableOrUnknown(
          data['doctor_order_ch']!,
          _doctorOrderChMeta,
        ),
      );
    }
    if (data.containsKey('doctor_order_en')) {
      context.handle(
        _doctorOrderEnMeta,
        doctorOrderEn.isAcceptableOrUnknown(
          data['doctor_order_en']!,
          _doctorOrderEnMeta,
        ),
      );
    }
    if (data.containsKey('director_name')) {
      context.handle(
        _directorNameMeta,
        directorName.isAcceptableOrUnknown(
          data['director_name']!,
          _directorNameMeta,
        ),
      );
    }
    if (data.containsKey('assist_staff')) {
      context.handle(
        _assistStaffMeta,
        assistStaff.isAcceptableOrUnknown(
          data['assist_staff']!,
          _assistStaffMeta,
        ),
      );
    }
    if (data.containsKey('treatment_time')) {
      context.handle(
        _treatmentTimeMeta,
        treatmentTime.isAcceptableOrUnknown(
          data['treatment_time']!,
          _treatmentTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {treatmentId};
  @override
  TreatmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreatmentData(
      treatmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}treatment_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      tentativeCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tentative_category_id'],
      ),
      tentative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tentative'],
      ),
      secondaryDiagnosis1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_diagnosis1'],
      ),
      secondaryDiagnosis2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_diagnosis2'],
      ),
      triageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triage_id'],
      ),
      treatmentOnSiteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}treatment_on_site_id'],
      ),
      actionSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_summary'],
      ),
      actionSummaryOther: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_summary_other'],
      ),
      resultId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}result_id'],
      ),
      transportRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}transport_required'],
      ),
      transportMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_method'],
      ),
      referralHospitalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referral_hospital_id'],
      ),
      referralHospitalFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referral_hospital_final'],
      ),
      arrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrival_time'],
      ),
      clearanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clearance_id'],
      ),
      expeditedClearanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expedited_clearance_id'],
      ),
      doctorOrderCh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_order_ch'],
      ),
      doctorOrderEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_order_en'],
      ),
      directorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}director_name'],
      ),
      assistStaff: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assist_staff'],
      ),
      treatmentTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}treatment_time'],
      )!,
    );
  }

  @override
  $TreatmentTable createAlias(String alias) {
    return $TreatmentTable(attachedDatabase, alias);
  }
}

class TreatmentData extends DataClass implements Insertable<TreatmentData> {
  final int treatmentId;
  final int medicalId;
  final int? tentativeCategoryId;
  final String? tentative;
  final String? secondaryDiagnosis1;
  final String? secondaryDiagnosis2;
  final int? triageId;
  final int? treatmentOnSiteId;
  final String? actionSummary;
  final String? actionSummaryOther;
  final int? resultId;
  final bool? transportRequired;
  final String? transportMethod;
  final int? referralHospitalId;
  final String? referralHospitalFinal;
  final DateTime? arrivalTime;
  final int? clearanceId;
  final int? expeditedClearanceId;
  final String? doctorOrderCh;
  final String? doctorOrderEn;
  final String? directorName;
  final String? assistStaff;
  final DateTime treatmentTime;
  const TreatmentData({
    required this.treatmentId,
    required this.medicalId,
    this.tentativeCategoryId,
    this.tentative,
    this.secondaryDiagnosis1,
    this.secondaryDiagnosis2,
    this.triageId,
    this.treatmentOnSiteId,
    this.actionSummary,
    this.actionSummaryOther,
    this.resultId,
    this.transportRequired,
    this.transportMethod,
    this.referralHospitalId,
    this.referralHospitalFinal,
    this.arrivalTime,
    this.clearanceId,
    this.expeditedClearanceId,
    this.doctorOrderCh,
    this.doctorOrderEn,
    this.directorName,
    this.assistStaff,
    required this.treatmentTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['treatment_id'] = Variable<int>(treatmentId);
    map['medical_id'] = Variable<int>(medicalId);
    if (!nullToAbsent || tentativeCategoryId != null) {
      map['tentative_category_id'] = Variable<int>(tentativeCategoryId);
    }
    if (!nullToAbsent || tentative != null) {
      map['tentative'] = Variable<String>(tentative);
    }
    if (!nullToAbsent || secondaryDiagnosis1 != null) {
      map['secondary_diagnosis1'] = Variable<String>(secondaryDiagnosis1);
    }
    if (!nullToAbsent || secondaryDiagnosis2 != null) {
      map['secondary_diagnosis2'] = Variable<String>(secondaryDiagnosis2);
    }
    if (!nullToAbsent || triageId != null) {
      map['triage_id'] = Variable<int>(triageId);
    }
    if (!nullToAbsent || treatmentOnSiteId != null) {
      map['treatment_on_site_id'] = Variable<int>(treatmentOnSiteId);
    }
    if (!nullToAbsent || actionSummary != null) {
      map['action_summary'] = Variable<String>(actionSummary);
    }
    if (!nullToAbsent || actionSummaryOther != null) {
      map['action_summary_other'] = Variable<String>(actionSummaryOther);
    }
    if (!nullToAbsent || resultId != null) {
      map['result_id'] = Variable<int>(resultId);
    }
    if (!nullToAbsent || transportRequired != null) {
      map['transport_required'] = Variable<bool>(transportRequired);
    }
    if (!nullToAbsent || transportMethod != null) {
      map['transport_method'] = Variable<String>(transportMethod);
    }
    if (!nullToAbsent || referralHospitalId != null) {
      map['referral_hospital_id'] = Variable<int>(referralHospitalId);
    }
    if (!nullToAbsent || referralHospitalFinal != null) {
      map['referral_hospital_final'] = Variable<String>(referralHospitalFinal);
    }
    if (!nullToAbsent || arrivalTime != null) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime);
    }
    if (!nullToAbsent || clearanceId != null) {
      map['clearance_id'] = Variable<int>(clearanceId);
    }
    if (!nullToAbsent || expeditedClearanceId != null) {
      map['expedited_clearance_id'] = Variable<int>(expeditedClearanceId);
    }
    if (!nullToAbsent || doctorOrderCh != null) {
      map['doctor_order_ch'] = Variable<String>(doctorOrderCh);
    }
    if (!nullToAbsent || doctorOrderEn != null) {
      map['doctor_order_en'] = Variable<String>(doctorOrderEn);
    }
    if (!nullToAbsent || directorName != null) {
      map['director_name'] = Variable<String>(directorName);
    }
    if (!nullToAbsent || assistStaff != null) {
      map['assist_staff'] = Variable<String>(assistStaff);
    }
    map['treatment_time'] = Variable<DateTime>(treatmentTime);
    return map;
  }

  TreatmentCompanion toCompanion(bool nullToAbsent) {
    return TreatmentCompanion(
      treatmentId: Value(treatmentId),
      medicalId: Value(medicalId),
      tentativeCategoryId: tentativeCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(tentativeCategoryId),
      tentative: tentative == null && nullToAbsent
          ? const Value.absent()
          : Value(tentative),
      secondaryDiagnosis1: secondaryDiagnosis1 == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryDiagnosis1),
      secondaryDiagnosis2: secondaryDiagnosis2 == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryDiagnosis2),
      triageId: triageId == null && nullToAbsent
          ? const Value.absent()
          : Value(triageId),
      treatmentOnSiteId: treatmentOnSiteId == null && nullToAbsent
          ? const Value.absent()
          : Value(treatmentOnSiteId),
      actionSummary: actionSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(actionSummary),
      actionSummaryOther: actionSummaryOther == null && nullToAbsent
          ? const Value.absent()
          : Value(actionSummaryOther),
      resultId: resultId == null && nullToAbsent
          ? const Value.absent()
          : Value(resultId),
      transportRequired: transportRequired == null && nullToAbsent
          ? const Value.absent()
          : Value(transportRequired),
      transportMethod: transportMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(transportMethod),
      referralHospitalId: referralHospitalId == null && nullToAbsent
          ? const Value.absent()
          : Value(referralHospitalId),
      referralHospitalFinal: referralHospitalFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(referralHospitalFinal),
      arrivalTime: arrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalTime),
      clearanceId: clearanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(clearanceId),
      expeditedClearanceId: expeditedClearanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(expeditedClearanceId),
      doctorOrderCh: doctorOrderCh == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorOrderCh),
      doctorOrderEn: doctorOrderEn == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorOrderEn),
      directorName: directorName == null && nullToAbsent
          ? const Value.absent()
          : Value(directorName),
      assistStaff: assistStaff == null && nullToAbsent
          ? const Value.absent()
          : Value(assistStaff),
      treatmentTime: Value(treatmentTime),
    );
  }

  factory TreatmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreatmentData(
      treatmentId: serializer.fromJson<int>(json['treatmentId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      tentativeCategoryId: serializer.fromJson<int?>(
        json['tentativeCategoryId'],
      ),
      tentative: serializer.fromJson<String?>(json['tentative']),
      secondaryDiagnosis1: serializer.fromJson<String?>(
        json['secondaryDiagnosis1'],
      ),
      secondaryDiagnosis2: serializer.fromJson<String?>(
        json['secondaryDiagnosis2'],
      ),
      triageId: serializer.fromJson<int?>(json['triageId']),
      treatmentOnSiteId: serializer.fromJson<int?>(json['treatmentOnSiteId']),
      actionSummary: serializer.fromJson<String?>(json['actionSummary']),
      actionSummaryOther: serializer.fromJson<String?>(
        json['actionSummaryOther'],
      ),
      resultId: serializer.fromJson<int?>(json['resultId']),
      transportRequired: serializer.fromJson<bool?>(json['transportRequired']),
      transportMethod: serializer.fromJson<String?>(json['transportMethod']),
      referralHospitalId: serializer.fromJson<int?>(json['referralHospitalId']),
      referralHospitalFinal: serializer.fromJson<String?>(
        json['referralHospitalFinal'],
      ),
      arrivalTime: serializer.fromJson<DateTime?>(json['arrivalTime']),
      clearanceId: serializer.fromJson<int?>(json['clearanceId']),
      expeditedClearanceId: serializer.fromJson<int?>(
        json['expeditedClearanceId'],
      ),
      doctorOrderCh: serializer.fromJson<String?>(json['doctorOrderCh']),
      doctorOrderEn: serializer.fromJson<String?>(json['doctorOrderEn']),
      directorName: serializer.fromJson<String?>(json['directorName']),
      assistStaff: serializer.fromJson<String?>(json['assistStaff']),
      treatmentTime: serializer.fromJson<DateTime>(json['treatmentTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'treatmentId': serializer.toJson<int>(treatmentId),
      'medicalId': serializer.toJson<int>(medicalId),
      'tentativeCategoryId': serializer.toJson<int?>(tentativeCategoryId),
      'tentative': serializer.toJson<String?>(tentative),
      'secondaryDiagnosis1': serializer.toJson<String?>(secondaryDiagnosis1),
      'secondaryDiagnosis2': serializer.toJson<String?>(secondaryDiagnosis2),
      'triageId': serializer.toJson<int?>(triageId),
      'treatmentOnSiteId': serializer.toJson<int?>(treatmentOnSiteId),
      'actionSummary': serializer.toJson<String?>(actionSummary),
      'actionSummaryOther': serializer.toJson<String?>(actionSummaryOther),
      'resultId': serializer.toJson<int?>(resultId),
      'transportRequired': serializer.toJson<bool?>(transportRequired),
      'transportMethod': serializer.toJson<String?>(transportMethod),
      'referralHospitalId': serializer.toJson<int?>(referralHospitalId),
      'referralHospitalFinal': serializer.toJson<String?>(
        referralHospitalFinal,
      ),
      'arrivalTime': serializer.toJson<DateTime?>(arrivalTime),
      'clearanceId': serializer.toJson<int?>(clearanceId),
      'expeditedClearanceId': serializer.toJson<int?>(expeditedClearanceId),
      'doctorOrderCh': serializer.toJson<String?>(doctorOrderCh),
      'doctorOrderEn': serializer.toJson<String?>(doctorOrderEn),
      'directorName': serializer.toJson<String?>(directorName),
      'assistStaff': serializer.toJson<String?>(assistStaff),
      'treatmentTime': serializer.toJson<DateTime>(treatmentTime),
    };
  }

  TreatmentData copyWith({
    int? treatmentId,
    int? medicalId,
    Value<int?> tentativeCategoryId = const Value.absent(),
    Value<String?> tentative = const Value.absent(),
    Value<String?> secondaryDiagnosis1 = const Value.absent(),
    Value<String?> secondaryDiagnosis2 = const Value.absent(),
    Value<int?> triageId = const Value.absent(),
    Value<int?> treatmentOnSiteId = const Value.absent(),
    Value<String?> actionSummary = const Value.absent(),
    Value<String?> actionSummaryOther = const Value.absent(),
    Value<int?> resultId = const Value.absent(),
    Value<bool?> transportRequired = const Value.absent(),
    Value<String?> transportMethod = const Value.absent(),
    Value<int?> referralHospitalId = const Value.absent(),
    Value<String?> referralHospitalFinal = const Value.absent(),
    Value<DateTime?> arrivalTime = const Value.absent(),
    Value<int?> clearanceId = const Value.absent(),
    Value<int?> expeditedClearanceId = const Value.absent(),
    Value<String?> doctorOrderCh = const Value.absent(),
    Value<String?> doctorOrderEn = const Value.absent(),
    Value<String?> directorName = const Value.absent(),
    Value<String?> assistStaff = const Value.absent(),
    DateTime? treatmentTime,
  }) => TreatmentData(
    treatmentId: treatmentId ?? this.treatmentId,
    medicalId: medicalId ?? this.medicalId,
    tentativeCategoryId: tentativeCategoryId.present
        ? tentativeCategoryId.value
        : this.tentativeCategoryId,
    tentative: tentative.present ? tentative.value : this.tentative,
    secondaryDiagnosis1: secondaryDiagnosis1.present
        ? secondaryDiagnosis1.value
        : this.secondaryDiagnosis1,
    secondaryDiagnosis2: secondaryDiagnosis2.present
        ? secondaryDiagnosis2.value
        : this.secondaryDiagnosis2,
    triageId: triageId.present ? triageId.value : this.triageId,
    treatmentOnSiteId: treatmentOnSiteId.present
        ? treatmentOnSiteId.value
        : this.treatmentOnSiteId,
    actionSummary: actionSummary.present
        ? actionSummary.value
        : this.actionSummary,
    actionSummaryOther: actionSummaryOther.present
        ? actionSummaryOther.value
        : this.actionSummaryOther,
    resultId: resultId.present ? resultId.value : this.resultId,
    transportRequired: transportRequired.present
        ? transportRequired.value
        : this.transportRequired,
    transportMethod: transportMethod.present
        ? transportMethod.value
        : this.transportMethod,
    referralHospitalId: referralHospitalId.present
        ? referralHospitalId.value
        : this.referralHospitalId,
    referralHospitalFinal: referralHospitalFinal.present
        ? referralHospitalFinal.value
        : this.referralHospitalFinal,
    arrivalTime: arrivalTime.present ? arrivalTime.value : this.arrivalTime,
    clearanceId: clearanceId.present ? clearanceId.value : this.clearanceId,
    expeditedClearanceId: expeditedClearanceId.present
        ? expeditedClearanceId.value
        : this.expeditedClearanceId,
    doctorOrderCh: doctorOrderCh.present
        ? doctorOrderCh.value
        : this.doctorOrderCh,
    doctorOrderEn: doctorOrderEn.present
        ? doctorOrderEn.value
        : this.doctorOrderEn,
    directorName: directorName.present ? directorName.value : this.directorName,
    assistStaff: assistStaff.present ? assistStaff.value : this.assistStaff,
    treatmentTime: treatmentTime ?? this.treatmentTime,
  );
  TreatmentData copyWithCompanion(TreatmentCompanion data) {
    return TreatmentData(
      treatmentId: data.treatmentId.present
          ? data.treatmentId.value
          : this.treatmentId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      tentativeCategoryId: data.tentativeCategoryId.present
          ? data.tentativeCategoryId.value
          : this.tentativeCategoryId,
      tentative: data.tentative.present ? data.tentative.value : this.tentative,
      secondaryDiagnosis1: data.secondaryDiagnosis1.present
          ? data.secondaryDiagnosis1.value
          : this.secondaryDiagnosis1,
      secondaryDiagnosis2: data.secondaryDiagnosis2.present
          ? data.secondaryDiagnosis2.value
          : this.secondaryDiagnosis2,
      triageId: data.triageId.present ? data.triageId.value : this.triageId,
      treatmentOnSiteId: data.treatmentOnSiteId.present
          ? data.treatmentOnSiteId.value
          : this.treatmentOnSiteId,
      actionSummary: data.actionSummary.present
          ? data.actionSummary.value
          : this.actionSummary,
      actionSummaryOther: data.actionSummaryOther.present
          ? data.actionSummaryOther.value
          : this.actionSummaryOther,
      resultId: data.resultId.present ? data.resultId.value : this.resultId,
      transportRequired: data.transportRequired.present
          ? data.transportRequired.value
          : this.transportRequired,
      transportMethod: data.transportMethod.present
          ? data.transportMethod.value
          : this.transportMethod,
      referralHospitalId: data.referralHospitalId.present
          ? data.referralHospitalId.value
          : this.referralHospitalId,
      referralHospitalFinal: data.referralHospitalFinal.present
          ? data.referralHospitalFinal.value
          : this.referralHospitalFinal,
      arrivalTime: data.arrivalTime.present
          ? data.arrivalTime.value
          : this.arrivalTime,
      clearanceId: data.clearanceId.present
          ? data.clearanceId.value
          : this.clearanceId,
      expeditedClearanceId: data.expeditedClearanceId.present
          ? data.expeditedClearanceId.value
          : this.expeditedClearanceId,
      doctorOrderCh: data.doctorOrderCh.present
          ? data.doctorOrderCh.value
          : this.doctorOrderCh,
      doctorOrderEn: data.doctorOrderEn.present
          ? data.doctorOrderEn.value
          : this.doctorOrderEn,
      directorName: data.directorName.present
          ? data.directorName.value
          : this.directorName,
      assistStaff: data.assistStaff.present
          ? data.assistStaff.value
          : this.assistStaff,
      treatmentTime: data.treatmentTime.present
          ? data.treatmentTime.value
          : this.treatmentTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentData(')
          ..write('treatmentId: $treatmentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('tentativeCategoryId: $tentativeCategoryId, ')
          ..write('tentative: $tentative, ')
          ..write('secondaryDiagnosis1: $secondaryDiagnosis1, ')
          ..write('secondaryDiagnosis2: $secondaryDiagnosis2, ')
          ..write('triageId: $triageId, ')
          ..write('treatmentOnSiteId: $treatmentOnSiteId, ')
          ..write('actionSummary: $actionSummary, ')
          ..write('actionSummaryOther: $actionSummaryOther, ')
          ..write('resultId: $resultId, ')
          ..write('transportRequired: $transportRequired, ')
          ..write('transportMethod: $transportMethod, ')
          ..write('referralHospitalId: $referralHospitalId, ')
          ..write('referralHospitalFinal: $referralHospitalFinal, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('clearanceId: $clearanceId, ')
          ..write('expeditedClearanceId: $expeditedClearanceId, ')
          ..write('doctorOrderCh: $doctorOrderCh, ')
          ..write('doctorOrderEn: $doctorOrderEn, ')
          ..write('directorName: $directorName, ')
          ..write('assistStaff: $assistStaff, ')
          ..write('treatmentTime: $treatmentTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    treatmentId,
    medicalId,
    tentativeCategoryId,
    tentative,
    secondaryDiagnosis1,
    secondaryDiagnosis2,
    triageId,
    treatmentOnSiteId,
    actionSummary,
    actionSummaryOther,
    resultId,
    transportRequired,
    transportMethod,
    referralHospitalId,
    referralHospitalFinal,
    arrivalTime,
    clearanceId,
    expeditedClearanceId,
    doctorOrderCh,
    doctorOrderEn,
    directorName,
    assistStaff,
    treatmentTime,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreatmentData &&
          other.treatmentId == this.treatmentId &&
          other.medicalId == this.medicalId &&
          other.tentativeCategoryId == this.tentativeCategoryId &&
          other.tentative == this.tentative &&
          other.secondaryDiagnosis1 == this.secondaryDiagnosis1 &&
          other.secondaryDiagnosis2 == this.secondaryDiagnosis2 &&
          other.triageId == this.triageId &&
          other.treatmentOnSiteId == this.treatmentOnSiteId &&
          other.actionSummary == this.actionSummary &&
          other.actionSummaryOther == this.actionSummaryOther &&
          other.resultId == this.resultId &&
          other.transportRequired == this.transportRequired &&
          other.transportMethod == this.transportMethod &&
          other.referralHospitalId == this.referralHospitalId &&
          other.referralHospitalFinal == this.referralHospitalFinal &&
          other.arrivalTime == this.arrivalTime &&
          other.clearanceId == this.clearanceId &&
          other.expeditedClearanceId == this.expeditedClearanceId &&
          other.doctorOrderCh == this.doctorOrderCh &&
          other.doctorOrderEn == this.doctorOrderEn &&
          other.directorName == this.directorName &&
          other.assistStaff == this.assistStaff &&
          other.treatmentTime == this.treatmentTime);
}

class TreatmentCompanion extends UpdateCompanion<TreatmentData> {
  final Value<int> treatmentId;
  final Value<int> medicalId;
  final Value<int?> tentativeCategoryId;
  final Value<String?> tentative;
  final Value<String?> secondaryDiagnosis1;
  final Value<String?> secondaryDiagnosis2;
  final Value<int?> triageId;
  final Value<int?> treatmentOnSiteId;
  final Value<String?> actionSummary;
  final Value<String?> actionSummaryOther;
  final Value<int?> resultId;
  final Value<bool?> transportRequired;
  final Value<String?> transportMethod;
  final Value<int?> referralHospitalId;
  final Value<String?> referralHospitalFinal;
  final Value<DateTime?> arrivalTime;
  final Value<int?> clearanceId;
  final Value<int?> expeditedClearanceId;
  final Value<String?> doctorOrderCh;
  final Value<String?> doctorOrderEn;
  final Value<String?> directorName;
  final Value<String?> assistStaff;
  final Value<DateTime> treatmentTime;
  const TreatmentCompanion({
    this.treatmentId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.tentativeCategoryId = const Value.absent(),
    this.tentative = const Value.absent(),
    this.secondaryDiagnosis1 = const Value.absent(),
    this.secondaryDiagnosis2 = const Value.absent(),
    this.triageId = const Value.absent(),
    this.treatmentOnSiteId = const Value.absent(),
    this.actionSummary = const Value.absent(),
    this.actionSummaryOther = const Value.absent(),
    this.resultId = const Value.absent(),
    this.transportRequired = const Value.absent(),
    this.transportMethod = const Value.absent(),
    this.referralHospitalId = const Value.absent(),
    this.referralHospitalFinal = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.clearanceId = const Value.absent(),
    this.expeditedClearanceId = const Value.absent(),
    this.doctorOrderCh = const Value.absent(),
    this.doctorOrderEn = const Value.absent(),
    this.directorName = const Value.absent(),
    this.assistStaff = const Value.absent(),
    this.treatmentTime = const Value.absent(),
  });
  TreatmentCompanion.insert({
    this.treatmentId = const Value.absent(),
    required int medicalId,
    this.tentativeCategoryId = const Value.absent(),
    this.tentative = const Value.absent(),
    this.secondaryDiagnosis1 = const Value.absent(),
    this.secondaryDiagnosis2 = const Value.absent(),
    this.triageId = const Value.absent(),
    this.treatmentOnSiteId = const Value.absent(),
    this.actionSummary = const Value.absent(),
    this.actionSummaryOther = const Value.absent(),
    this.resultId = const Value.absent(),
    this.transportRequired = const Value.absent(),
    this.transportMethod = const Value.absent(),
    this.referralHospitalId = const Value.absent(),
    this.referralHospitalFinal = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.clearanceId = const Value.absent(),
    this.expeditedClearanceId = const Value.absent(),
    this.doctorOrderCh = const Value.absent(),
    this.doctorOrderEn = const Value.absent(),
    this.directorName = const Value.absent(),
    this.assistStaff = const Value.absent(),
    this.treatmentTime = const Value.absent(),
  }) : medicalId = Value(medicalId);
  static Insertable<TreatmentData> custom({
    Expression<int>? treatmentId,
    Expression<int>? medicalId,
    Expression<int>? tentativeCategoryId,
    Expression<String>? tentative,
    Expression<String>? secondaryDiagnosis1,
    Expression<String>? secondaryDiagnosis2,
    Expression<int>? triageId,
    Expression<int>? treatmentOnSiteId,
    Expression<String>? actionSummary,
    Expression<String>? actionSummaryOther,
    Expression<int>? resultId,
    Expression<bool>? transportRequired,
    Expression<String>? transportMethod,
    Expression<int>? referralHospitalId,
    Expression<String>? referralHospitalFinal,
    Expression<DateTime>? arrivalTime,
    Expression<int>? clearanceId,
    Expression<int>? expeditedClearanceId,
    Expression<String>? doctorOrderCh,
    Expression<String>? doctorOrderEn,
    Expression<String>? directorName,
    Expression<String>? assistStaff,
    Expression<DateTime>? treatmentTime,
  }) {
    return RawValuesInsertable({
      if (treatmentId != null) 'treatment_id': treatmentId,
      if (medicalId != null) 'medical_id': medicalId,
      if (tentativeCategoryId != null)
        'tentative_category_id': tentativeCategoryId,
      if (tentative != null) 'tentative': tentative,
      if (secondaryDiagnosis1 != null)
        'secondary_diagnosis1': secondaryDiagnosis1,
      if (secondaryDiagnosis2 != null)
        'secondary_diagnosis2': secondaryDiagnosis2,
      if (triageId != null) 'triage_id': triageId,
      if (treatmentOnSiteId != null) 'treatment_on_site_id': treatmentOnSiteId,
      if (actionSummary != null) 'action_summary': actionSummary,
      if (actionSummaryOther != null)
        'action_summary_other': actionSummaryOther,
      if (resultId != null) 'result_id': resultId,
      if (transportRequired != null) 'transport_required': transportRequired,
      if (transportMethod != null) 'transport_method': transportMethod,
      if (referralHospitalId != null)
        'referral_hospital_id': referralHospitalId,
      if (referralHospitalFinal != null)
        'referral_hospital_final': referralHospitalFinal,
      if (arrivalTime != null) 'arrival_time': arrivalTime,
      if (clearanceId != null) 'clearance_id': clearanceId,
      if (expeditedClearanceId != null)
        'expedited_clearance_id': expeditedClearanceId,
      if (doctorOrderCh != null) 'doctor_order_ch': doctorOrderCh,
      if (doctorOrderEn != null) 'doctor_order_en': doctorOrderEn,
      if (directorName != null) 'director_name': directorName,
      if (assistStaff != null) 'assist_staff': assistStaff,
      if (treatmentTime != null) 'treatment_time': treatmentTime,
    });
  }

  TreatmentCompanion copyWith({
    Value<int>? treatmentId,
    Value<int>? medicalId,
    Value<int?>? tentativeCategoryId,
    Value<String?>? tentative,
    Value<String?>? secondaryDiagnosis1,
    Value<String?>? secondaryDiagnosis2,
    Value<int?>? triageId,
    Value<int?>? treatmentOnSiteId,
    Value<String?>? actionSummary,
    Value<String?>? actionSummaryOther,
    Value<int?>? resultId,
    Value<bool?>? transportRequired,
    Value<String?>? transportMethod,
    Value<int?>? referralHospitalId,
    Value<String?>? referralHospitalFinal,
    Value<DateTime?>? arrivalTime,
    Value<int?>? clearanceId,
    Value<int?>? expeditedClearanceId,
    Value<String?>? doctorOrderCh,
    Value<String?>? doctorOrderEn,
    Value<String?>? directorName,
    Value<String?>? assistStaff,
    Value<DateTime>? treatmentTime,
  }) {
    return TreatmentCompanion(
      treatmentId: treatmentId ?? this.treatmentId,
      medicalId: medicalId ?? this.medicalId,
      tentativeCategoryId: tentativeCategoryId ?? this.tentativeCategoryId,
      tentative: tentative ?? this.tentative,
      secondaryDiagnosis1: secondaryDiagnosis1 ?? this.secondaryDiagnosis1,
      secondaryDiagnosis2: secondaryDiagnosis2 ?? this.secondaryDiagnosis2,
      triageId: triageId ?? this.triageId,
      treatmentOnSiteId: treatmentOnSiteId ?? this.treatmentOnSiteId,
      actionSummary: actionSummary ?? this.actionSummary,
      actionSummaryOther: actionSummaryOther ?? this.actionSummaryOther,
      resultId: resultId ?? this.resultId,
      transportRequired: transportRequired ?? this.transportRequired,
      transportMethod: transportMethod ?? this.transportMethod,
      referralHospitalId: referralHospitalId ?? this.referralHospitalId,
      referralHospitalFinal:
          referralHospitalFinal ?? this.referralHospitalFinal,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      clearanceId: clearanceId ?? this.clearanceId,
      expeditedClearanceId: expeditedClearanceId ?? this.expeditedClearanceId,
      doctorOrderCh: doctorOrderCh ?? this.doctorOrderCh,
      doctorOrderEn: doctorOrderEn ?? this.doctorOrderEn,
      directorName: directorName ?? this.directorName,
      assistStaff: assistStaff ?? this.assistStaff,
      treatmentTime: treatmentTime ?? this.treatmentTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (treatmentId.present) {
      map['treatment_id'] = Variable<int>(treatmentId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (tentativeCategoryId.present) {
      map['tentative_category_id'] = Variable<int>(tentativeCategoryId.value);
    }
    if (tentative.present) {
      map['tentative'] = Variable<String>(tentative.value);
    }
    if (secondaryDiagnosis1.present) {
      map['secondary_diagnosis1'] = Variable<String>(secondaryDiagnosis1.value);
    }
    if (secondaryDiagnosis2.present) {
      map['secondary_diagnosis2'] = Variable<String>(secondaryDiagnosis2.value);
    }
    if (triageId.present) {
      map['triage_id'] = Variable<int>(triageId.value);
    }
    if (treatmentOnSiteId.present) {
      map['treatment_on_site_id'] = Variable<int>(treatmentOnSiteId.value);
    }
    if (actionSummary.present) {
      map['action_summary'] = Variable<String>(actionSummary.value);
    }
    if (actionSummaryOther.present) {
      map['action_summary_other'] = Variable<String>(actionSummaryOther.value);
    }
    if (resultId.present) {
      map['result_id'] = Variable<int>(resultId.value);
    }
    if (transportRequired.present) {
      map['transport_required'] = Variable<bool>(transportRequired.value);
    }
    if (transportMethod.present) {
      map['transport_method'] = Variable<String>(transportMethod.value);
    }
    if (referralHospitalId.present) {
      map['referral_hospital_id'] = Variable<int>(referralHospitalId.value);
    }
    if (referralHospitalFinal.present) {
      map['referral_hospital_final'] = Variable<String>(
        referralHospitalFinal.value,
      );
    }
    if (arrivalTime.present) {
      map['arrival_time'] = Variable<DateTime>(arrivalTime.value);
    }
    if (clearanceId.present) {
      map['clearance_id'] = Variable<int>(clearanceId.value);
    }
    if (expeditedClearanceId.present) {
      map['expedited_clearance_id'] = Variable<int>(expeditedClearanceId.value);
    }
    if (doctorOrderCh.present) {
      map['doctor_order_ch'] = Variable<String>(doctorOrderCh.value);
    }
    if (doctorOrderEn.present) {
      map['doctor_order_en'] = Variable<String>(doctorOrderEn.value);
    }
    if (directorName.present) {
      map['director_name'] = Variable<String>(directorName.value);
    }
    if (assistStaff.present) {
      map['assist_staff'] = Variable<String>(assistStaff.value);
    }
    if (treatmentTime.present) {
      map['treatment_time'] = Variable<DateTime>(treatmentTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentCompanion(')
          ..write('treatmentId: $treatmentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('tentativeCategoryId: $tentativeCategoryId, ')
          ..write('tentative: $tentative, ')
          ..write('secondaryDiagnosis1: $secondaryDiagnosis1, ')
          ..write('secondaryDiagnosis2: $secondaryDiagnosis2, ')
          ..write('triageId: $triageId, ')
          ..write('treatmentOnSiteId: $treatmentOnSiteId, ')
          ..write('actionSummary: $actionSummary, ')
          ..write('actionSummaryOther: $actionSummaryOther, ')
          ..write('resultId: $resultId, ')
          ..write('transportRequired: $transportRequired, ')
          ..write('transportMethod: $transportMethod, ')
          ..write('referralHospitalId: $referralHospitalId, ')
          ..write('referralHospitalFinal: $referralHospitalFinal, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('clearanceId: $clearanceId, ')
          ..write('expeditedClearanceId: $expeditedClearanceId, ')
          ..write('doctorOrderCh: $doctorOrderCh, ')
          ..write('doctorOrderEn: $doctorOrderEn, ')
          ..write('directorName: $directorName, ')
          ..write('assistStaff: $assistStaff, ')
          ..write('treatmentTime: $treatmentTime')
          ..write(')'))
        .toString();
  }
}

class $MedicalStaffAssignmentTable extends MedicalStaffAssignment
    with TableInfo<$MedicalStaffAssignmentTable, MedicalStaffAssignmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalStaffAssignmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _staffAssignmentIdMeta = const VerificationMeta(
    'staffAssignmentId',
  );
  @override
  late final GeneratedColumn<int> staffAssignmentId = GeneratedColumn<int>(
    'staff_assignment_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _staffRoleMeta = const VerificationMeta(
    'staffRole',
  );
  @override
  late final GeneratedColumn<String> staffRole = GeneratedColumn<String>(
    'staff_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
    'staff_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _staffNameMeta = const VerificationMeta(
    'staffName',
  );
  @override
  late final GeneratedColumn<String> staffName = GeneratedColumn<String>(
    'staff_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<Uint8List> signature = GeneratedColumn<Uint8List>(
    'signature',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signedAtMeta = const VerificationMeta(
    'signedAt',
  );
  @override
  late final GeneratedColumn<DateTime> signedAt = GeneratedColumn<DateTime>(
    'signed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedAtMeta = const VerificationMeta(
    'assignedAt',
  );
  @override
  late final GeneratedColumn<DateTime> assignedAt = GeneratedColumn<DateTime>(
    'assigned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    staffAssignmentId,
    medicalId,
    staffRole,
    staffId,
    staffName,
    isPrimary,
    signature,
    signedAt,
    assignedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_staff_assignment';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalStaffAssignmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('staff_assignment_id')) {
      context.handle(
        _staffAssignmentIdMeta,
        staffAssignmentId.isAcceptableOrUnknown(
          data['staff_assignment_id']!,
          _staffAssignmentIdMeta,
        ),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('staff_role')) {
      context.handle(
        _staffRoleMeta,
        staffRole.isAcceptableOrUnknown(data['staff_role']!, _staffRoleMeta),
      );
    } else if (isInserting) {
      context.missing(_staffRoleMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    }
    if (data.containsKey('staff_name')) {
      context.handle(
        _staffNameMeta,
        staffName.isAcceptableOrUnknown(data['staff_name']!, _staffNameMeta),
      );
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    }
    if (data.containsKey('signed_at')) {
      context.handle(
        _signedAtMeta,
        signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta),
      );
    }
    if (data.containsKey('assigned_at')) {
      context.handle(
        _assignedAtMeta,
        assignedAt.isAcceptableOrUnknown(data['assigned_at']!, _assignedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {staffAssignmentId};
  @override
  MedicalStaffAssignmentData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalStaffAssignmentData(
      staffAssignmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_assignment_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      staffRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_role'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_id'],
      ),
      staffName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_name'],
      ),
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}signature'],
      ),
      signedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signed_at'],
      ),
      assignedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_at'],
      )!,
    );
  }

  @override
  $MedicalStaffAssignmentTable createAlias(String alias) {
    return $MedicalStaffAssignmentTable(attachedDatabase, alias);
  }
}

class MedicalStaffAssignmentData extends DataClass
    implements Insertable<MedicalStaffAssignmentData> {
  final int staffAssignmentId;
  final int medicalId;
  final String staffRole;
  final int? staffId;
  final String? staffName;
  final bool isPrimary;
  final Uint8List? signature;
  final DateTime? signedAt;
  final DateTime assignedAt;
  const MedicalStaffAssignmentData({
    required this.staffAssignmentId,
    required this.medicalId,
    required this.staffRole,
    this.staffId,
    this.staffName,
    required this.isPrimary,
    this.signature,
    this.signedAt,
    required this.assignedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['staff_assignment_id'] = Variable<int>(staffAssignmentId);
    map['medical_id'] = Variable<int>(medicalId);
    map['staff_role'] = Variable<String>(staffRole);
    if (!nullToAbsent || staffId != null) {
      map['staff_id'] = Variable<int>(staffId);
    }
    if (!nullToAbsent || staffName != null) {
      map['staff_name'] = Variable<String>(staffName);
    }
    map['is_primary'] = Variable<bool>(isPrimary);
    if (!nullToAbsent || signature != null) {
      map['signature'] = Variable<Uint8List>(signature);
    }
    if (!nullToAbsent || signedAt != null) {
      map['signed_at'] = Variable<DateTime>(signedAt);
    }
    map['assigned_at'] = Variable<DateTime>(assignedAt);
    return map;
  }

  MedicalStaffAssignmentCompanion toCompanion(bool nullToAbsent) {
    return MedicalStaffAssignmentCompanion(
      staffAssignmentId: Value(staffAssignmentId),
      medicalId: Value(medicalId),
      staffRole: Value(staffRole),
      staffId: staffId == null && nullToAbsent
          ? const Value.absent()
          : Value(staffId),
      staffName: staffName == null && nullToAbsent
          ? const Value.absent()
          : Value(staffName),
      isPrimary: Value(isPrimary),
      signature: signature == null && nullToAbsent
          ? const Value.absent()
          : Value(signature),
      signedAt: signedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(signedAt),
      assignedAt: Value(assignedAt),
    );
  }

  factory MedicalStaffAssignmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalStaffAssignmentData(
      staffAssignmentId: serializer.fromJson<int>(json['staffAssignmentId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      staffRole: serializer.fromJson<String>(json['staffRole']),
      staffId: serializer.fromJson<int?>(json['staffId']),
      staffName: serializer.fromJson<String?>(json['staffName']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      signature: serializer.fromJson<Uint8List?>(json['signature']),
      signedAt: serializer.fromJson<DateTime?>(json['signedAt']),
      assignedAt: serializer.fromJson<DateTime>(json['assignedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'staffAssignmentId': serializer.toJson<int>(staffAssignmentId),
      'medicalId': serializer.toJson<int>(medicalId),
      'staffRole': serializer.toJson<String>(staffRole),
      'staffId': serializer.toJson<int?>(staffId),
      'staffName': serializer.toJson<String?>(staffName),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'signature': serializer.toJson<Uint8List?>(signature),
      'signedAt': serializer.toJson<DateTime?>(signedAt),
      'assignedAt': serializer.toJson<DateTime>(assignedAt),
    };
  }

  MedicalStaffAssignmentData copyWith({
    int? staffAssignmentId,
    int? medicalId,
    String? staffRole,
    Value<int?> staffId = const Value.absent(),
    Value<String?> staffName = const Value.absent(),
    bool? isPrimary,
    Value<Uint8List?> signature = const Value.absent(),
    Value<DateTime?> signedAt = const Value.absent(),
    DateTime? assignedAt,
  }) => MedicalStaffAssignmentData(
    staffAssignmentId: staffAssignmentId ?? this.staffAssignmentId,
    medicalId: medicalId ?? this.medicalId,
    staffRole: staffRole ?? this.staffRole,
    staffId: staffId.present ? staffId.value : this.staffId,
    staffName: staffName.present ? staffName.value : this.staffName,
    isPrimary: isPrimary ?? this.isPrimary,
    signature: signature.present ? signature.value : this.signature,
    signedAt: signedAt.present ? signedAt.value : this.signedAt,
    assignedAt: assignedAt ?? this.assignedAt,
  );
  MedicalStaffAssignmentData copyWithCompanion(
    MedicalStaffAssignmentCompanion data,
  ) {
    return MedicalStaffAssignmentData(
      staffAssignmentId: data.staffAssignmentId.present
          ? data.staffAssignmentId.value
          : this.staffAssignmentId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      staffRole: data.staffRole.present ? data.staffRole.value : this.staffRole,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      staffName: data.staffName.present ? data.staffName.value : this.staffName,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      signature: data.signature.present ? data.signature.value : this.signature,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
      assignedAt: data.assignedAt.present
          ? data.assignedAt.value
          : this.assignedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalStaffAssignmentData(')
          ..write('staffAssignmentId: $staffAssignmentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('staffRole: $staffRole, ')
          ..write('staffId: $staffId, ')
          ..write('staffName: $staffName, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('signature: $signature, ')
          ..write('signedAt: $signedAt, ')
          ..write('assignedAt: $assignedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    staffAssignmentId,
    medicalId,
    staffRole,
    staffId,
    staffName,
    isPrimary,
    $driftBlobEquality.hash(signature),
    signedAt,
    assignedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalStaffAssignmentData &&
          other.staffAssignmentId == this.staffAssignmentId &&
          other.medicalId == this.medicalId &&
          other.staffRole == this.staffRole &&
          other.staffId == this.staffId &&
          other.staffName == this.staffName &&
          other.isPrimary == this.isPrimary &&
          $driftBlobEquality.equals(other.signature, this.signature) &&
          other.signedAt == this.signedAt &&
          other.assignedAt == this.assignedAt);
}

class MedicalStaffAssignmentCompanion
    extends UpdateCompanion<MedicalStaffAssignmentData> {
  final Value<int> staffAssignmentId;
  final Value<int> medicalId;
  final Value<String> staffRole;
  final Value<int?> staffId;
  final Value<String?> staffName;
  final Value<bool> isPrimary;
  final Value<Uint8List?> signature;
  final Value<DateTime?> signedAt;
  final Value<DateTime> assignedAt;
  const MedicalStaffAssignmentCompanion({
    this.staffAssignmentId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.staffRole = const Value.absent(),
    this.staffId = const Value.absent(),
    this.staffName = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.signature = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.assignedAt = const Value.absent(),
  });
  MedicalStaffAssignmentCompanion.insert({
    this.staffAssignmentId = const Value.absent(),
    required int medicalId,
    required String staffRole,
    this.staffId = const Value.absent(),
    this.staffName = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.signature = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.assignedAt = const Value.absent(),
  }) : medicalId = Value(medicalId),
       staffRole = Value(staffRole);
  static Insertable<MedicalStaffAssignmentData> custom({
    Expression<int>? staffAssignmentId,
    Expression<int>? medicalId,
    Expression<String>? staffRole,
    Expression<int>? staffId,
    Expression<String>? staffName,
    Expression<bool>? isPrimary,
    Expression<Uint8List>? signature,
    Expression<DateTime>? signedAt,
    Expression<DateTime>? assignedAt,
  }) {
    return RawValuesInsertable({
      if (staffAssignmentId != null) 'staff_assignment_id': staffAssignmentId,
      if (medicalId != null) 'medical_id': medicalId,
      if (staffRole != null) 'staff_role': staffRole,
      if (staffId != null) 'staff_id': staffId,
      if (staffName != null) 'staff_name': staffName,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (signature != null) 'signature': signature,
      if (signedAt != null) 'signed_at': signedAt,
      if (assignedAt != null) 'assigned_at': assignedAt,
    });
  }

  MedicalStaffAssignmentCompanion copyWith({
    Value<int>? staffAssignmentId,
    Value<int>? medicalId,
    Value<String>? staffRole,
    Value<int?>? staffId,
    Value<String?>? staffName,
    Value<bool>? isPrimary,
    Value<Uint8List?>? signature,
    Value<DateTime?>? signedAt,
    Value<DateTime>? assignedAt,
  }) {
    return MedicalStaffAssignmentCompanion(
      staffAssignmentId: staffAssignmentId ?? this.staffAssignmentId,
      medicalId: medicalId ?? this.medicalId,
      staffRole: staffRole ?? this.staffRole,
      staffId: staffId ?? this.staffId,
      staffName: staffName ?? this.staffName,
      isPrimary: isPrimary ?? this.isPrimary,
      signature: signature ?? this.signature,
      signedAt: signedAt ?? this.signedAt,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (staffAssignmentId.present) {
      map['staff_assignment_id'] = Variable<int>(staffAssignmentId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (staffRole.present) {
      map['staff_role'] = Variable<String>(staffRole.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (staffName.present) {
      map['staff_name'] = Variable<String>(staffName.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (signature.present) {
      map['signature'] = Variable<Uint8List>(signature.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<DateTime>(signedAt.value);
    }
    if (assignedAt.present) {
      map['assigned_at'] = Variable<DateTime>(assignedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalStaffAssignmentCompanion(')
          ..write('staffAssignmentId: $staffAssignmentId, ')
          ..write('medicalId: $medicalId, ')
          ..write('staffRole: $staffRole, ')
          ..write('staffId: $staffId, ')
          ..write('staffName: $staffName, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('signature: $signature, ')
          ..write('signedAt: $signedAt, ')
          ..write('assignedAt: $assignedAt')
          ..write(')'))
        .toString();
  }
}

class $SpecialNotesTable extends SpecialNotes
    with TableInfo<$SpecialNotesTable, SpecialNotesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpecialNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<int> noteId = GeneratedColumn<int>(
    'note_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<int> medicalId = GeneratedColumn<int>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_record (medical_id)',
    ),
  );
  static const VerificationMeta _selectedNotesMeta = const VerificationMeta(
    'selectedNotes',
  );
  @override
  late final GeneratedColumn<String> selectedNotes = GeneratedColumn<String>(
    'selected_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherNotesMeta = const VerificationMeta(
    'otherNotes',
  );
  @override
  late final GeneratedColumn<String> otherNotes = GeneratedColumn<String>(
    'other_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    noteId,
    medicalId,
    selectedNotes,
    otherNotes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'special_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpecialNotesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('selected_notes')) {
      context.handle(
        _selectedNotesMeta,
        selectedNotes.isAcceptableOrUnknown(
          data['selected_notes']!,
          _selectedNotesMeta,
        ),
      );
    }
    if (data.containsKey('other_notes')) {
      context.handle(
        _otherNotesMeta,
        otherNotes.isAcceptableOrUnknown(data['other_notes']!, _otherNotesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId};
  @override
  SpecialNotesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpecialNotesData(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}note_id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medical_id'],
      )!,
      selectedNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_notes'],
      ),
      otherNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SpecialNotesTable createAlias(String alias) {
    return $SpecialNotesTable(attachedDatabase, alias);
  }
}

class SpecialNotesData extends DataClass
    implements Insertable<SpecialNotesData> {
  final int noteId;
  final int medicalId;
  final String? selectedNotes;
  final String? otherNotes;
  final DateTime createdAt;
  const SpecialNotesData({
    required this.noteId,
    required this.medicalId,
    this.selectedNotes,
    this.otherNotes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<int>(noteId);
    map['medical_id'] = Variable<int>(medicalId);
    if (!nullToAbsent || selectedNotes != null) {
      map['selected_notes'] = Variable<String>(selectedNotes);
    }
    if (!nullToAbsent || otherNotes != null) {
      map['other_notes'] = Variable<String>(otherNotes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SpecialNotesCompanion toCompanion(bool nullToAbsent) {
    return SpecialNotesCompanion(
      noteId: Value(noteId),
      medicalId: Value(medicalId),
      selectedNotes: selectedNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedNotes),
      otherNotes: otherNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(otherNotes),
      createdAt: Value(createdAt),
    );
  }

  factory SpecialNotesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpecialNotesData(
      noteId: serializer.fromJson<int>(json['noteId']),
      medicalId: serializer.fromJson<int>(json['medicalId']),
      selectedNotes: serializer.fromJson<String?>(json['selectedNotes']),
      otherNotes: serializer.fromJson<String?>(json['otherNotes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<int>(noteId),
      'medicalId': serializer.toJson<int>(medicalId),
      'selectedNotes': serializer.toJson<String?>(selectedNotes),
      'otherNotes': serializer.toJson<String?>(otherNotes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SpecialNotesData copyWith({
    int? noteId,
    int? medicalId,
    Value<String?> selectedNotes = const Value.absent(),
    Value<String?> otherNotes = const Value.absent(),
    DateTime? createdAt,
  }) => SpecialNotesData(
    noteId: noteId ?? this.noteId,
    medicalId: medicalId ?? this.medicalId,
    selectedNotes: selectedNotes.present
        ? selectedNotes.value
        : this.selectedNotes,
    otherNotes: otherNotes.present ? otherNotes.value : this.otherNotes,
    createdAt: createdAt ?? this.createdAt,
  );
  SpecialNotesData copyWithCompanion(SpecialNotesCompanion data) {
    return SpecialNotesData(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      selectedNotes: data.selectedNotes.present
          ? data.selectedNotes.value
          : this.selectedNotes,
      otherNotes: data.otherNotes.present
          ? data.otherNotes.value
          : this.otherNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpecialNotesData(')
          ..write('noteId: $noteId, ')
          ..write('medicalId: $medicalId, ')
          ..write('selectedNotes: $selectedNotes, ')
          ..write('otherNotes: $otherNotes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(noteId, medicalId, selectedNotes, otherNotes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpecialNotesData &&
          other.noteId == this.noteId &&
          other.medicalId == this.medicalId &&
          other.selectedNotes == this.selectedNotes &&
          other.otherNotes == this.otherNotes &&
          other.createdAt == this.createdAt);
}

class SpecialNotesCompanion extends UpdateCompanion<SpecialNotesData> {
  final Value<int> noteId;
  final Value<int> medicalId;
  final Value<String?> selectedNotes;
  final Value<String?> otherNotes;
  final Value<DateTime> createdAt;
  const SpecialNotesCompanion({
    this.noteId = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.selectedNotes = const Value.absent(),
    this.otherNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SpecialNotesCompanion.insert({
    this.noteId = const Value.absent(),
    required int medicalId,
    this.selectedNotes = const Value.absent(),
    this.otherNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : medicalId = Value(medicalId);
  static Insertable<SpecialNotesData> custom({
    Expression<int>? noteId,
    Expression<int>? medicalId,
    Expression<String>? selectedNotes,
    Expression<String>? otherNotes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (medicalId != null) 'medical_id': medicalId,
      if (selectedNotes != null) 'selected_notes': selectedNotes,
      if (otherNotes != null) 'other_notes': otherNotes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SpecialNotesCompanion copyWith({
    Value<int>? noteId,
    Value<int>? medicalId,
    Value<String?>? selectedNotes,
    Value<String?>? otherNotes,
    Value<DateTime>? createdAt,
  }) {
    return SpecialNotesCompanion(
      noteId: noteId ?? this.noteId,
      medicalId: medicalId ?? this.medicalId,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      otherNotes: otherNotes ?? this.otherNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<int>(noteId.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<int>(medicalId.value);
    }
    if (selectedNotes.present) {
      map['selected_notes'] = Variable<String>(selectedNotes.value);
    }
    if (otherNotes.present) {
      map['other_notes'] = Variable<String>(otherNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpecialNotesCompanion(')
          ..write('noteId: $noteId, ')
          ..write('medicalId: $medicalId, ')
          ..write('selectedNotes: $selectedNotes, ')
          ..write('otherNotes: $otherNotes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $Icd10CodeTable extends Icd10Code
    with TableInfo<$Icd10CodeTable, Icd10CodeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Icd10CodeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameChMeta = const VerificationMeta('nameCh');
  @override
  late final GeneratedColumn<String> nameCh = GeneratedColumn<String>(
    'name_ch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLeafMeta = const VerificationMeta('isLeaf');
  @override
  late final GeneratedColumn<bool> isLeaf = GeneratedColumn<bool>(
    'is_leaf',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_leaf" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, nameEn, nameCh, isLeaf];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'icd10_code';
  @override
  VerificationContext validateIntegrity(
    Insertable<Icd10CodeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ch')) {
      context.handle(
        _nameChMeta,
        nameCh.isAcceptableOrUnknown(data['name_ch']!, _nameChMeta),
      );
    } else if (isInserting) {
      context.missing(_nameChMeta);
    }
    if (data.containsKey('is_leaf')) {
      context.handle(
        _isLeafMeta,
        isLeaf.isAcceptableOrUnknown(data['is_leaf']!, _isLeafMeta),
      );
    } else if (isInserting) {
      context.missing(_isLeafMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Icd10CodeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Icd10CodeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameCh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ch'],
      )!,
      isLeaf: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_leaf'],
      )!,
    );
  }

  @override
  $Icd10CodeTable createAlias(String alias) {
    return $Icd10CodeTable(attachedDatabase, alias);
  }
}

class Icd10CodeData extends DataClass implements Insertable<Icd10CodeData> {
  final int id;
  final String code;
  final String nameEn;
  final String nameCh;
  final bool isLeaf;
  const Icd10CodeData({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameCh,
    required this.isLeaf,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ch'] = Variable<String>(nameCh);
    map['is_leaf'] = Variable<bool>(isLeaf);
    return map;
  }

  Icd10CodeCompanion toCompanion(bool nullToAbsent) {
    return Icd10CodeCompanion(
      id: Value(id),
      code: Value(code),
      nameEn: Value(nameEn),
      nameCh: Value(nameCh),
      isLeaf: Value(isLeaf),
    );
  }

  factory Icd10CodeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Icd10CodeData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameCh: serializer.fromJson<String>(json['nameCh']),
      isLeaf: serializer.fromJson<bool>(json['isLeaf']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameCh': serializer.toJson<String>(nameCh),
      'isLeaf': serializer.toJson<bool>(isLeaf),
    };
  }

  Icd10CodeData copyWith({
    int? id,
    String? code,
    String? nameEn,
    String? nameCh,
    bool? isLeaf,
  }) => Icd10CodeData(
    id: id ?? this.id,
    code: code ?? this.code,
    nameEn: nameEn ?? this.nameEn,
    nameCh: nameCh ?? this.nameCh,
    isLeaf: isLeaf ?? this.isLeaf,
  );
  Icd10CodeData copyWithCompanion(Icd10CodeCompanion data) {
    return Icd10CodeData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameCh: data.nameCh.present ? data.nameCh.value : this.nameCh,
      isLeaf: data.isLeaf.present ? data.isLeaf.value : this.isLeaf,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Icd10CodeData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameCh: $nameCh, ')
          ..write('isLeaf: $isLeaf')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, nameEn, nameCh, isLeaf);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Icd10CodeData &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameEn == this.nameEn &&
          other.nameCh == this.nameCh &&
          other.isLeaf == this.isLeaf);
}

class Icd10CodeCompanion extends UpdateCompanion<Icd10CodeData> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameEn;
  final Value<String> nameCh;
  final Value<bool> isLeaf;
  const Icd10CodeCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameCh = const Value.absent(),
    this.isLeaf = const Value.absent(),
  });
  Icd10CodeCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameEn,
    required String nameCh,
    required bool isLeaf,
  }) : code = Value(code),
       nameEn = Value(nameEn),
       nameCh = Value(nameCh),
       isLeaf = Value(isLeaf);
  static Insertable<Icd10CodeData> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameEn,
    Expression<String>? nameCh,
    Expression<bool>? isLeaf,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameEn != null) 'name_en': nameEn,
      if (nameCh != null) 'name_ch': nameCh,
      if (isLeaf != null) 'is_leaf': isLeaf,
    });
  }

  Icd10CodeCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameEn,
    Value<String>? nameCh,
    Value<bool>? isLeaf,
  }) {
    return Icd10CodeCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameCh: nameCh ?? this.nameCh,
      isLeaf: isLeaf ?? this.isLeaf,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameCh.present) {
      map['name_ch'] = Variable<String>(nameCh.value);
    }
    if (isLeaf.present) {
      map['is_leaf'] = Variable<bool>(isLeaf.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Icd10CodeCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameCh: $nameCh, ')
          ..write('isLeaf: $isLeaf')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SexTable sex = $SexTable(this);
  late final $NationalityTable nationality = $NationalityTable(this);
  late final $AirlineTable airline = $AirlineTable(this);
  late final $TravelStatusTable travelStatus = $TravelStatusTable(this);
  late final $LocationTable location = $LocationTable(this);
  late final $IncidentPlaceCategoryTable incidentPlaceCategory =
      $IncidentPlaceCategoryTable(this);
  late final $IncidentPlaceCategory2Table incidentPlaceCategory2 =
      $IncidentPlaceCategory2Table(this);
  late final $ReportingUnitTable reportingUnit = $ReportingUnitTable(this);
  late final $ChiefComplaintTypeTable chiefComplaintType =
      $ChiefComplaintTypeTable(this);
  late final $ChiefComplaintDetailTable chiefComplaintDetail =
      $ChiefComplaintDetailTable(this);
  late final $DiagnosisCategoryTable diagnosisCategory =
      $DiagnosisCategoryTable(this);
  late final $TriageLevelTable triageLevel = $TriageLevelTable(this);
  late final $TreatmentOnSiteTable treatmentOnSite = $TreatmentOnSiteTable(
    this,
  );
  late final $TreatmentResultTable treatmentResult = $TreatmentResultTable(
    this,
  );
  late final $ReferralHospitalTable referralHospital = $ReferralHospitalTable(
    this,
  );
  late final $ActionItemTable actionItem = $ActionItemTable(this);
  late final $MedicalStaffTable medicalStaff = $MedicalStaffTable(this);
  late final $SpecialNoteRefTable specialNoteRef = $SpecialNoteRefTable(this);
  late final $NursingPhraseTable nursingPhrase = $NursingPhraseTable(this);
  late final $MedicalRecordTable medicalRecord = $MedicalRecordTable(this);
  late final $PatientTable patient = $PatientTable(this);
  late final $FlightRecordTable flightRecord = $FlightRecordTable(this);
  late final $FlightTransitLocationsTable flightTransitLocations =
      $FlightTransitLocationsTable(this);
  late final $IncidentRecordTable incidentRecord = $IncidentRecordTable(this);
  late final $ChiefComplaintTable chiefComplaint = $ChiefComplaintTable(this);
  late final $HealthAssessmentFormTable healthAssessmentForm =
      $HealthAssessmentFormTable(this);
  late final $MedicalMediaTable medicalMedia = $MedicalMediaTable(this);
  late final $MedicalAssessmentTable medicalAssessment =
      $MedicalAssessmentTable(this);
  late final $MedicalHistoryTable medicalHistory = $MedicalHistoryTable(this);
  late final $TreatmentTable treatment = $TreatmentTable(this);
  late final $MedicalStaffAssignmentTable medicalStaffAssignment =
      $MedicalStaffAssignmentTable(this);
  late final $SpecialNotesTable specialNotes = $SpecialNotesTable(this);
  late final $Icd10CodeTable icd10Code = $Icd10CodeTable(this);
  late final ReferenceDao referenceDao = ReferenceDao(this as AppDatabase);
  late final MedicalDao medicalDao = MedicalDao(this as AppDatabase);
  late final FlightDao flightDao = FlightDao(this as AppDatabase);
  late final IncidentDao incidentDao = IncidentDao(this as AppDatabase);
  late final TreatmentDao treatmentDao = TreatmentDao(this as AppDatabase);
  late final Icd10Dao icd10Dao = Icd10Dao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sex,
    nationality,
    airline,
    travelStatus,
    location,
    incidentPlaceCategory,
    incidentPlaceCategory2,
    reportingUnit,
    chiefComplaintType,
    chiefComplaintDetail,
    diagnosisCategory,
    triageLevel,
    treatmentOnSite,
    treatmentResult,
    referralHospital,
    actionItem,
    medicalStaff,
    specialNoteRef,
    nursingPhrase,
    medicalRecord,
    patient,
    flightRecord,
    flightTransitLocations,
    incidentRecord,
    chiefComplaint,
    healthAssessmentForm,
    medicalMedia,
    medicalAssessment,
    medicalHistory,
    treatment,
    medicalStaffAssignment,
    specialNotes,
    icd10Code,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flight_record',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('flight_transit_locations', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$SexTableCreateCompanionBuilder =
    SexCompanion Function({Value<int> sexId, required String name});
typedef $$SexTableUpdateCompanionBuilder =
    SexCompanion Function({Value<int> sexId, Value<String> name});

final class $$SexTableReferences
    extends BaseReferences<_$AppDatabase, $SexTable, SexData> {
  $$SexTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PatientTable, List<PatientData>>
  _patientRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.patient,
    aliasName: $_aliasNameGenerator(db.sex.sexId, db.patient.sexId),
  );

  $$PatientTableProcessedTableManager get patientRefs {
    final manager = $$PatientTableTableManager(
      $_db,
      $_db.patient,
    ).filter((f) => f.sexId.sexId.sqlEquals($_itemColumn<int>('sex_id')!));

    final cache = $_typedResult.readTableOrNull(_patientRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SexTableFilterComposer extends Composer<_$AppDatabase, $SexTable> {
  $$SexTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sexId => $composableBuilder(
    column: $table.sexId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> patientRefs(
    Expression<bool> Function($$PatientTableFilterComposer f) f,
  ) {
    final $$PatientTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sexId,
      referencedTable: $db.patient,
      getReferencedColumn: (t) => t.sexId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientTableFilterComposer(
            $db: $db,
            $table: $db.patient,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SexTableOrderingComposer extends Composer<_$AppDatabase, $SexTable> {
  $$SexTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sexId => $composableBuilder(
    column: $table.sexId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SexTableAnnotationComposer extends Composer<_$AppDatabase, $SexTable> {
  $$SexTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sexId =>
      $composableBuilder(column: $table.sexId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> patientRefs<T extends Object>(
    Expression<T> Function($$PatientTableAnnotationComposer a) f,
  ) {
    final $$PatientTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sexId,
      referencedTable: $db.patient,
      getReferencedColumn: (t) => t.sexId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientTableAnnotationComposer(
            $db: $db,
            $table: $db.patient,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SexTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SexTable,
          SexData,
          $$SexTableFilterComposer,
          $$SexTableOrderingComposer,
          $$SexTableAnnotationComposer,
          $$SexTableCreateCompanionBuilder,
          $$SexTableUpdateCompanionBuilder,
          (SexData, $$SexTableReferences),
          SexData,
          PrefetchHooks Function({bool patientRefs})
        > {
  $$SexTableTableManager(_$AppDatabase db, $SexTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SexTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SexTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SexTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sexId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => SexCompanion(sexId: sexId, name: name),
          createCompanionCallback:
              ({
                Value<int> sexId = const Value.absent(),
                required String name,
              }) => SexCompanion.insert(sexId: sexId, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), $$SexTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({patientRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (patientRefs) db.patient],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (patientRefs)
                    await $_getPrefetchedData<SexData, $SexTable, PatientData>(
                      currentTable: table,
                      referencedTable: $$SexTableReferences._patientRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SexTableReferences(db, table, p0).patientRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sexId == item.sexId),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SexTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SexTable,
      SexData,
      $$SexTableFilterComposer,
      $$SexTableOrderingComposer,
      $$SexTableAnnotationComposer,
      $$SexTableCreateCompanionBuilder,
      $$SexTableUpdateCompanionBuilder,
      (SexData, $$SexTableReferences),
      SexData,
      PrefetchHooks Function({bool patientRefs})
    >;
typedef $$NationalityTableCreateCompanionBuilder =
    NationalityCompanion Function({
      Value<int> nationalityId,
      required String name,
      Value<String?> nameEn,
    });
typedef $$NationalityTableUpdateCompanionBuilder =
    NationalityCompanion Function({
      Value<int> nationalityId,
      Value<String> name,
      Value<String?> nameEn,
    });

final class $$NationalityTableReferences
    extends BaseReferences<_$AppDatabase, $NationalityTable, NationalityData> {
  $$NationalityTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PatientTable, List<PatientData>>
  _patientRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.patient,
    aliasName: $_aliasNameGenerator(
      db.nationality.nationalityId,
      db.patient.nationalityId,
    ),
  );

  $$PatientTableProcessedTableManager get patientRefs {
    final manager = $$PatientTableTableManager($_db, $_db.patient).filter(
      (f) => f.nationalityId.nationalityId.sqlEquals(
        $_itemColumn<int>('nationality_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_patientRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NationalityTableFilterComposer
    extends Composer<_$AppDatabase, $NationalityTable> {
  $$NationalityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nationalityId => $composableBuilder(
    column: $table.nationalityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> patientRefs(
    Expression<bool> Function($$PatientTableFilterComposer f) f,
  ) {
    final $$PatientTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationalityId,
      referencedTable: $db.patient,
      getReferencedColumn: (t) => t.nationalityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientTableFilterComposer(
            $db: $db,
            $table: $db.patient,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NationalityTableOrderingComposer
    extends Composer<_$AppDatabase, $NationalityTable> {
  $$NationalityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nationalityId => $composableBuilder(
    column: $table.nationalityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NationalityTableAnnotationComposer
    extends Composer<_$AppDatabase, $NationalityTable> {
  $$NationalityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nationalityId => $composableBuilder(
    column: $table.nationalityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  Expression<T> patientRefs<T extends Object>(
    Expression<T> Function($$PatientTableAnnotationComposer a) f,
  ) {
    final $$PatientTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationalityId,
      referencedTable: $db.patient,
      getReferencedColumn: (t) => t.nationalityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientTableAnnotationComposer(
            $db: $db,
            $table: $db.patient,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NationalityTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NationalityTable,
          NationalityData,
          $$NationalityTableFilterComposer,
          $$NationalityTableOrderingComposer,
          $$NationalityTableAnnotationComposer,
          $$NationalityTableCreateCompanionBuilder,
          $$NationalityTableUpdateCompanionBuilder,
          (NationalityData, $$NationalityTableReferences),
          NationalityData,
          PrefetchHooks Function({bool patientRefs})
        > {
  $$NationalityTableTableManager(_$AppDatabase db, $NationalityTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NationalityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NationalityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NationalityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> nationalityId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
              }) => NationalityCompanion(
                nationalityId: nationalityId,
                name: name,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> nationalityId = const Value.absent(),
                required String name,
                Value<String?> nameEn = const Value.absent(),
              }) => NationalityCompanion.insert(
                nationalityId: nationalityId,
                name: name,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NationalityTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (patientRefs) db.patient],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (patientRefs)
                    await $_getPrefetchedData<
                      NationalityData,
                      $NationalityTable,
                      PatientData
                    >(
                      currentTable: table,
                      referencedTable: $$NationalityTableReferences
                          ._patientRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NationalityTableReferences(
                            db,
                            table,
                            p0,
                          ).patientRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.nationalityId == item.nationalityId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NationalityTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NationalityTable,
      NationalityData,
      $$NationalityTableFilterComposer,
      $$NationalityTableOrderingComposer,
      $$NationalityTableAnnotationComposer,
      $$NationalityTableCreateCompanionBuilder,
      $$NationalityTableUpdateCompanionBuilder,
      (NationalityData, $$NationalityTableReferences),
      NationalityData,
      PrefetchHooks Function({bool patientRefs})
    >;
typedef $$AirlineTableCreateCompanionBuilder =
    AirlineCompanion Function({
      Value<int> airlineId,
      required String code,
      required String name,
    });
typedef $$AirlineTableUpdateCompanionBuilder =
    AirlineCompanion Function({
      Value<int> airlineId,
      Value<String> code,
      Value<String> name,
    });

final class $$AirlineTableReferences
    extends BaseReferences<_$AppDatabase, $AirlineTable, AirlineData> {
  $$AirlineTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FlightRecordTable, List<FlightRecordData>>
  _flightRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flightRecord,
    aliasName: $_aliasNameGenerator(
      db.airline.airlineId,
      db.flightRecord.airlineId,
    ),
  );

  $$FlightRecordTableProcessedTableManager get flightRecordRefs {
    final manager = $$FlightRecordTableTableManager($_db, $_db.flightRecord)
        .filter(
          (f) =>
              f.airlineId.airlineId.sqlEquals($_itemColumn<int>('airline_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_flightRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AirlineTableFilterComposer
    extends Composer<_$AppDatabase, $AirlineTable> {
  $$AirlineTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get airlineId => $composableBuilder(
    column: $table.airlineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flightRecordRefs(
    Expression<bool> Function($$FlightRecordTableFilterComposer f) f,
  ) {
    final $$FlightRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.airlineId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.airlineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableFilterComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AirlineTableOrderingComposer
    extends Composer<_$AppDatabase, $AirlineTable> {
  $$AirlineTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get airlineId => $composableBuilder(
    column: $table.airlineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AirlineTableAnnotationComposer
    extends Composer<_$AppDatabase, $AirlineTable> {
  $$AirlineTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get airlineId =>
      $composableBuilder(column: $table.airlineId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> flightRecordRefs<T extends Object>(
    Expression<T> Function($$FlightRecordTableAnnotationComposer a) f,
  ) {
    final $$FlightRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.airlineId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.airlineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AirlineTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AirlineTable,
          AirlineData,
          $$AirlineTableFilterComposer,
          $$AirlineTableOrderingComposer,
          $$AirlineTableAnnotationComposer,
          $$AirlineTableCreateCompanionBuilder,
          $$AirlineTableUpdateCompanionBuilder,
          (AirlineData, $$AirlineTableReferences),
          AirlineData,
          PrefetchHooks Function({bool flightRecordRefs})
        > {
  $$AirlineTableTableManager(_$AppDatabase db, $AirlineTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AirlineTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AirlineTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AirlineTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> airlineId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => AirlineCompanion(
                airlineId: airlineId,
                code: code,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> airlineId = const Value.absent(),
                required String code,
                required String name,
              }) => AirlineCompanion.insert(
                airlineId: airlineId,
                code: code,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AirlineTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightRecordRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (flightRecordRefs) db.flightRecord],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flightRecordRefs)
                    await $_getPrefetchedData<
                      AirlineData,
                      $AirlineTable,
                      FlightRecordData
                    >(
                      currentTable: table,
                      referencedTable: $$AirlineTableReferences
                          ._flightRecordRefsTable(db),
                      managerFromTypedResult: (p0) => $$AirlineTableReferences(
                        db,
                        table,
                        p0,
                      ).flightRecordRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.airlineId == item.airlineId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AirlineTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AirlineTable,
      AirlineData,
      $$AirlineTableFilterComposer,
      $$AirlineTableOrderingComposer,
      $$AirlineTableAnnotationComposer,
      $$AirlineTableCreateCompanionBuilder,
      $$AirlineTableUpdateCompanionBuilder,
      (AirlineData, $$AirlineTableReferences),
      AirlineData,
      PrefetchHooks Function({bool flightRecordRefs})
    >;
typedef $$TravelStatusTableCreateCompanionBuilder =
    TravelStatusCompanion Function({
      Value<int> travelStatusId,
      required String code,
      required String name,
    });
typedef $$TravelStatusTableUpdateCompanionBuilder =
    TravelStatusCompanion Function({
      Value<int> travelStatusId,
      Value<String> code,
      Value<String> name,
    });

final class $$TravelStatusTableReferences
    extends
        BaseReferences<_$AppDatabase, $TravelStatusTable, TravelStatusData> {
  $$TravelStatusTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FlightRecordTable, List<FlightRecordData>>
  _flightRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flightRecord,
    aliasName: $_aliasNameGenerator(
      db.travelStatus.travelStatusId,
      db.flightRecord.travelStatusId,
    ),
  );

  $$FlightRecordTableProcessedTableManager get flightRecordRefs {
    final manager = $$FlightRecordTableTableManager($_db, $_db.flightRecord)
        .filter(
          (f) => f.travelStatusId.travelStatusId.sqlEquals(
            $_itemColumn<int>('travel_status_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_flightRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TravelStatusTableFilterComposer
    extends Composer<_$AppDatabase, $TravelStatusTable> {
  $$TravelStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get travelStatusId => $composableBuilder(
    column: $table.travelStatusId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flightRecordRefs(
    Expression<bool> Function($$FlightRecordTableFilterComposer f) f,
  ) {
    final $$FlightRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.travelStatusId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.travelStatusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableFilterComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TravelStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $TravelStatusTable> {
  $$TravelStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get travelStatusId => $composableBuilder(
    column: $table.travelStatusId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TravelStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $TravelStatusTable> {
  $$TravelStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get travelStatusId => $composableBuilder(
    column: $table.travelStatusId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> flightRecordRefs<T extends Object>(
    Expression<T> Function($$FlightRecordTableAnnotationComposer a) f,
  ) {
    final $$FlightRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.travelStatusId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.travelStatusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TravelStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TravelStatusTable,
          TravelStatusData,
          $$TravelStatusTableFilterComposer,
          $$TravelStatusTableOrderingComposer,
          $$TravelStatusTableAnnotationComposer,
          $$TravelStatusTableCreateCompanionBuilder,
          $$TravelStatusTableUpdateCompanionBuilder,
          (TravelStatusData, $$TravelStatusTableReferences),
          TravelStatusData,
          PrefetchHooks Function({bool flightRecordRefs})
        > {
  $$TravelStatusTableTableManager(_$AppDatabase db, $TravelStatusTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TravelStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TravelStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TravelStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> travelStatusId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TravelStatusCompanion(
                travelStatusId: travelStatusId,
                code: code,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> travelStatusId = const Value.absent(),
                required String code,
                required String name,
              }) => TravelStatusCompanion.insert(
                travelStatusId: travelStatusId,
                code: code,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TravelStatusTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightRecordRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (flightRecordRefs) db.flightRecord],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flightRecordRefs)
                    await $_getPrefetchedData<
                      TravelStatusData,
                      $TravelStatusTable,
                      FlightRecordData
                    >(
                      currentTable: table,
                      referencedTable: $$TravelStatusTableReferences
                          ._flightRecordRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TravelStatusTableReferences(
                            db,
                            table,
                            p0,
                          ).flightRecordRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.travelStatusId == item.travelStatusId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TravelStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TravelStatusTable,
      TravelStatusData,
      $$TravelStatusTableFilterComposer,
      $$TravelStatusTableOrderingComposer,
      $$TravelStatusTableAnnotationComposer,
      $$TravelStatusTableCreateCompanionBuilder,
      $$TravelStatusTableUpdateCompanionBuilder,
      (TravelStatusData, $$TravelStatusTableReferences),
      TravelStatusData,
      PrefetchHooks Function({bool flightRecordRefs})
    >;
typedef $$LocationTableCreateCompanionBuilder =
    LocationCompanion Function({
      Value<int> locationId,
      required String code,
      required String name,
    });
typedef $$LocationTableUpdateCompanionBuilder =
    LocationCompanion Function({
      Value<int> locationId,
      Value<String> code,
      Value<String> name,
    });

final class $$LocationTableReferences
    extends BaseReferences<_$AppDatabase, $LocationTable, LocationData> {
  $$LocationTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $FlightTransitLocationsTable,
    List<FlightTransitLocationData>
  >
  _flightTransitLocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.flightTransitLocations,
        aliasName: $_aliasNameGenerator(
          db.location.locationId,
          db.flightTransitLocations.locationId,
        ),
      );

  $$FlightTransitLocationsTableProcessedTableManager
  get flightTransitLocationsRefs {
    final manager =
        $$FlightTransitLocationsTableTableManager(
          $_db,
          $_db.flightTransitLocations,
        ).filter(
          (f) => f.locationId.locationId.sqlEquals(
            $_itemColumn<int>('location_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _flightTransitLocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationTableFilterComposer
    extends Composer<_$AppDatabase, $LocationTable> {
  $$LocationTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flightTransitLocationsRefs(
    Expression<bool> Function($$FlightTransitLocationsTableFilterComposer f) f,
  ) {
    final $$FlightTransitLocationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.locationId,
          referencedTable: $db.flightTransitLocations,
          getReferencedColumn: (t) => t.locationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlightTransitLocationsTableFilterComposer(
                $db: $db,
                $table: $db.flightTransitLocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocationTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationTable> {
  $$LocationTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationTable> {
  $$LocationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> flightTransitLocationsRefs<T extends Object>(
    Expression<T> Function($$FlightTransitLocationsTableAnnotationComposer a) f,
  ) {
    final $$FlightTransitLocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.locationId,
          referencedTable: $db.flightTransitLocations,
          getReferencedColumn: (t) => t.locationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlightTransitLocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.flightTransitLocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocationTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationTable,
          LocationData,
          $$LocationTableFilterComposer,
          $$LocationTableOrderingComposer,
          $$LocationTableAnnotationComposer,
          $$LocationTableCreateCompanionBuilder,
          $$LocationTableUpdateCompanionBuilder,
          (LocationData, $$LocationTableReferences),
          LocationData,
          PrefetchHooks Function({bool flightTransitLocationsRefs})
        > {
  $$LocationTableTableManager(_$AppDatabase db, $LocationTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> locationId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => LocationCompanion(
                locationId: locationId,
                code: code,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> locationId = const Value.absent(),
                required String code,
                required String name,
              }) => LocationCompanion.insert(
                locationId: locationId,
                code: code,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocationTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightTransitLocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (flightTransitLocationsRefs) db.flightTransitLocations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flightTransitLocationsRefs)
                    await $_getPrefetchedData<
                      LocationData,
                      $LocationTable,
                      FlightTransitLocationData
                    >(
                      currentTable: table,
                      referencedTable: $$LocationTableReferences
                          ._flightTransitLocationsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LocationTableReferences(
                        db,
                        table,
                        p0,
                      ).flightTransitLocationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.locationId == item.locationId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocationTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationTable,
      LocationData,
      $$LocationTableFilterComposer,
      $$LocationTableOrderingComposer,
      $$LocationTableAnnotationComposer,
      $$LocationTableCreateCompanionBuilder,
      $$LocationTableUpdateCompanionBuilder,
      (LocationData, $$LocationTableReferences),
      LocationData,
      PrefetchHooks Function({bool flightTransitLocationsRefs})
    >;
typedef $$IncidentPlaceCategoryTableCreateCompanionBuilder =
    IncidentPlaceCategoryCompanion Function({
      Value<int> id,
      required String name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$IncidentPlaceCategoryTableUpdateCompanionBuilder =
    IncidentPlaceCategoryCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

final class $$IncidentPlaceCategoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncidentPlaceCategoryTable,
          IncidentPlaceCategoryData
        > {
  $$IncidentPlaceCategoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $IncidentPlaceCategory2Table,
    List<IncidentPlaceCategory2Data>
  >
  _incidentPlaceCategory2RefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.incidentPlaceCategory2,
        aliasName: $_aliasNameGenerator(
          db.incidentPlaceCategory.id,
          db.incidentPlaceCategory2.categoryId,
        ),
      );

  $$IncidentPlaceCategory2TableProcessedTableManager
  get incidentPlaceCategory2Refs {
    final manager = $$IncidentPlaceCategory2TableTableManager(
      $_db,
      $_db.incidentPlaceCategory2,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incidentPlaceCategory2RefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncidentRecordTable, List<IncidentRecordData>>
  _incidentRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incidentRecord,
    aliasName: $_aliasNameGenerator(
      db.incidentPlaceCategory.id,
      db.incidentRecord.incidentPlaceCategoryId,
    ),
  );

  $$IncidentRecordTableProcessedTableManager get incidentRecordRefs {
    final manager = $$IncidentRecordTableTableManager($_db, $_db.incidentRecord)
        .filter(
          (f) =>
              f.incidentPlaceCategoryId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_incidentRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncidentPlaceCategoryTableFilterComposer
    extends Composer<_$AppDatabase, $IncidentPlaceCategoryTable> {
  $$IncidentPlaceCategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> incidentPlaceCategory2Refs(
    Expression<bool> Function($$IncidentPlaceCategory2TableFilterComposer f) f,
  ) {
    final $$IncidentPlaceCategory2TableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.incidentPlaceCategory2,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategory2TableFilterComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory2,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> incidentRecordRefs(
    Expression<bool> Function($$IncidentRecordTableFilterComposer f) f,
  ) {
    final $$IncidentRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.incidentPlaceCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableFilterComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncidentPlaceCategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $IncidentPlaceCategoryTable> {
  $$IncidentPlaceCategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncidentPlaceCategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidentPlaceCategoryTable> {
  $$IncidentPlaceCategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> incidentPlaceCategory2Refs<T extends Object>(
    Expression<T> Function($$IncidentPlaceCategory2TableAnnotationComposer a) f,
  ) {
    final $$IncidentPlaceCategory2TableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.incidentPlaceCategory2,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategory2TableAnnotationComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory2,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incidentRecordRefs<T extends Object>(
    Expression<T> Function($$IncidentRecordTableAnnotationComposer a) f,
  ) {
    final $$IncidentRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.incidentPlaceCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncidentPlaceCategoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncidentPlaceCategoryTable,
          IncidentPlaceCategoryData,
          $$IncidentPlaceCategoryTableFilterComposer,
          $$IncidentPlaceCategoryTableOrderingComposer,
          $$IncidentPlaceCategoryTableAnnotationComposer,
          $$IncidentPlaceCategoryTableCreateCompanionBuilder,
          $$IncidentPlaceCategoryTableUpdateCompanionBuilder,
          (IncidentPlaceCategoryData, $$IncidentPlaceCategoryTableReferences),
          IncidentPlaceCategoryData,
          PrefetchHooks Function({
            bool incidentPlaceCategory2Refs,
            bool incidentRecordRefs,
          })
        > {
  $$IncidentPlaceCategoryTableTableManager(
    _$AppDatabase db,
    $IncidentPlaceCategoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidentPlaceCategoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IncidentPlaceCategoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IncidentPlaceCategoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => IncidentPlaceCategoryCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => IncidentPlaceCategoryCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncidentPlaceCategoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                incidentPlaceCategory2Refs = false,
                incidentRecordRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incidentPlaceCategory2Refs) db.incidentPlaceCategory2,
                    if (incidentRecordRefs) db.incidentRecord,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incidentPlaceCategory2Refs)
                        await $_getPrefetchedData<
                          IncidentPlaceCategoryData,
                          $IncidentPlaceCategoryTable,
                          IncidentPlaceCategory2Data
                        >(
                          currentTable: table,
                          referencedTable:
                              $$IncidentPlaceCategoryTableReferences
                                  ._incidentPlaceCategory2RefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncidentPlaceCategoryTableReferences(
                                db,
                                table,
                                p0,
                              ).incidentPlaceCategory2Refs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incidentRecordRefs)
                        await $_getPrefetchedData<
                          IncidentPlaceCategoryData,
                          $IncidentPlaceCategoryTable,
                          IncidentRecordData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$IncidentPlaceCategoryTableReferences
                                  ._incidentRecordRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncidentPlaceCategoryTableReferences(
                                db,
                                table,
                                p0,
                              ).incidentRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incidentPlaceCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IncidentPlaceCategoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncidentPlaceCategoryTable,
      IncidentPlaceCategoryData,
      $$IncidentPlaceCategoryTableFilterComposer,
      $$IncidentPlaceCategoryTableOrderingComposer,
      $$IncidentPlaceCategoryTableAnnotationComposer,
      $$IncidentPlaceCategoryTableCreateCompanionBuilder,
      $$IncidentPlaceCategoryTableUpdateCompanionBuilder,
      (IncidentPlaceCategoryData, $$IncidentPlaceCategoryTableReferences),
      IncidentPlaceCategoryData,
      PrefetchHooks Function({
        bool incidentPlaceCategory2Refs,
        bool incidentRecordRefs,
      })
    >;
typedef $$IncidentPlaceCategory2TableCreateCompanionBuilder =
    IncidentPlaceCategory2Companion Function({
      Value<int> id,
      required int categoryId,
      required String name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$IncidentPlaceCategory2TableUpdateCompanionBuilder =
    IncidentPlaceCategory2Companion Function({
      Value<int> id,
      Value<int> categoryId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

final class $$IncidentPlaceCategory2TableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncidentPlaceCategory2Table,
          IncidentPlaceCategory2Data
        > {
  $$IncidentPlaceCategory2TableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IncidentPlaceCategoryTable _categoryIdTable(_$AppDatabase db) =>
      db.incidentPlaceCategory.createAlias(
        $_aliasNameGenerator(
          db.incidentPlaceCategory2.categoryId,
          db.incidentPlaceCategory.id,
        ),
      );

  $$IncidentPlaceCategoryTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$IncidentPlaceCategoryTableTableManager(
      $_db,
      $_db.incidentPlaceCategory,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IncidentRecordTable, List<IncidentRecordData>>
  _incidentRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incidentRecord,
    aliasName: $_aliasNameGenerator(
      db.incidentPlaceCategory2.id,
      db.incidentRecord.incidentPlaceCategory2Id,
    ),
  );

  $$IncidentRecordTableProcessedTableManager get incidentRecordRefs {
    final manager = $$IncidentRecordTableTableManager($_db, $_db.incidentRecord)
        .filter(
          (f) =>
              f.incidentPlaceCategory2Id.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_incidentRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncidentPlaceCategory2TableFilterComposer
    extends Composer<_$AppDatabase, $IncidentPlaceCategory2Table> {
  $$IncidentPlaceCategory2TableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$IncidentPlaceCategoryTableFilterComposer get categoryId {
    final $$IncidentPlaceCategoryTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.incidentPlaceCategory,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategoryTableFilterComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> incidentRecordRefs(
    Expression<bool> Function($$IncidentRecordTableFilterComposer f) f,
  ) {
    final $$IncidentRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.incidentPlaceCategory2Id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableFilterComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncidentPlaceCategory2TableOrderingComposer
    extends Composer<_$AppDatabase, $IncidentPlaceCategory2Table> {
  $$IncidentPlaceCategory2TableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$IncidentPlaceCategoryTableOrderingComposer get categoryId {
    final $$IncidentPlaceCategoryTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.incidentPlaceCategory,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategoryTableOrderingComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$IncidentPlaceCategory2TableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidentPlaceCategory2Table> {
  $$IncidentPlaceCategory2TableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$IncidentPlaceCategoryTableAnnotationComposer get categoryId {
    final $$IncidentPlaceCategoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.incidentPlaceCategory,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategoryTableAnnotationComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> incidentRecordRefs<T extends Object>(
    Expression<T> Function($$IncidentRecordTableAnnotationComposer a) f,
  ) {
    final $$IncidentRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.incidentPlaceCategory2Id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncidentPlaceCategory2TableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncidentPlaceCategory2Table,
          IncidentPlaceCategory2Data,
          $$IncidentPlaceCategory2TableFilterComposer,
          $$IncidentPlaceCategory2TableOrderingComposer,
          $$IncidentPlaceCategory2TableAnnotationComposer,
          $$IncidentPlaceCategory2TableCreateCompanionBuilder,
          $$IncidentPlaceCategory2TableUpdateCompanionBuilder,
          (IncidentPlaceCategory2Data, $$IncidentPlaceCategory2TableReferences),
          IncidentPlaceCategory2Data,
          PrefetchHooks Function({bool categoryId, bool incidentRecordRefs})
        > {
  $$IncidentPlaceCategory2TableTableManager(
    _$AppDatabase db,
    $IncidentPlaceCategory2Table table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidentPlaceCategory2TableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IncidentPlaceCategory2TableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IncidentPlaceCategory2TableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => IncidentPlaceCategory2Companion(
                id: id,
                categoryId: categoryId,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => IncidentPlaceCategory2Companion.insert(
                id: id,
                categoryId: categoryId,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncidentPlaceCategory2TableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, incidentRecordRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incidentRecordRefs) db.incidentRecord,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$IncidentPlaceCategory2TableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$IncidentPlaceCategory2TableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incidentRecordRefs)
                        await $_getPrefetchedData<
                          IncidentPlaceCategory2Data,
                          $IncidentPlaceCategory2Table,
                          IncidentRecordData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$IncidentPlaceCategory2TableReferences
                                  ._incidentRecordRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncidentPlaceCategory2TableReferences(
                                db,
                                table,
                                p0,
                              ).incidentRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incidentPlaceCategory2Id == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IncidentPlaceCategory2TableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncidentPlaceCategory2Table,
      IncidentPlaceCategory2Data,
      $$IncidentPlaceCategory2TableFilterComposer,
      $$IncidentPlaceCategory2TableOrderingComposer,
      $$IncidentPlaceCategory2TableAnnotationComposer,
      $$IncidentPlaceCategory2TableCreateCompanionBuilder,
      $$IncidentPlaceCategory2TableUpdateCompanionBuilder,
      (IncidentPlaceCategory2Data, $$IncidentPlaceCategory2TableReferences),
      IncidentPlaceCategory2Data,
      PrefetchHooks Function({bool categoryId, bool incidentRecordRefs})
    >;
typedef $$ReportingUnitTableCreateCompanionBuilder =
    ReportingUnitCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<bool> isActive,
    });
typedef $$ReportingUnitTableUpdateCompanionBuilder =
    ReportingUnitCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> isActive,
    });

final class $$ReportingUnitTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReportingUnitTable, ReportingUnitData> {
  $$ReportingUnitTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$IncidentRecordTable, List<IncidentRecordData>>
  _incidentRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incidentRecord,
    aliasName: $_aliasNameGenerator(
      db.reportingUnit.id,
      db.incidentRecord.reportingUnitId,
    ),
  );

  $$IncidentRecordTableProcessedTableManager get incidentRecordRefs {
    final manager = $$IncidentRecordTableTableManager(
      $_db,
      $_db.incidentRecord,
    ).filter((f) => f.reportingUnitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incidentRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReportingUnitTableFilterComposer
    extends Composer<_$AppDatabase, $ReportingUnitTable> {
  $$ReportingUnitTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> incidentRecordRefs(
    Expression<bool> Function($$IncidentRecordTableFilterComposer f) f,
  ) {
    final $$IncidentRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.reportingUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableFilterComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReportingUnitTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportingUnitTable> {
  $$ReportingUnitTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportingUnitTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportingUnitTable> {
  $$ReportingUnitTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> incidentRecordRefs<T extends Object>(
    Expression<T> Function($$IncidentRecordTableAnnotationComposer a) f,
  ) {
    final $$IncidentRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.reportingUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReportingUnitTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportingUnitTable,
          ReportingUnitData,
          $$ReportingUnitTableFilterComposer,
          $$ReportingUnitTableOrderingComposer,
          $$ReportingUnitTableAnnotationComposer,
          $$ReportingUnitTableCreateCompanionBuilder,
          $$ReportingUnitTableUpdateCompanionBuilder,
          (ReportingUnitData, $$ReportingUnitTableReferences),
          ReportingUnitData,
          PrefetchHooks Function({bool incidentRecordRefs})
        > {
  $$ReportingUnitTableTableManager(_$AppDatabase db, $ReportingUnitTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportingUnitTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportingUnitTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportingUnitTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ReportingUnitCompanion(
                id: id,
                name: name,
                description: description,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ReportingUnitCompanion.insert(
                id: id,
                name: name,
                description: description,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReportingUnitTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({incidentRecordRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (incidentRecordRefs) db.incidentRecord,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (incidentRecordRefs)
                    await $_getPrefetchedData<
                      ReportingUnitData,
                      $ReportingUnitTable,
                      IncidentRecordData
                    >(
                      currentTable: table,
                      referencedTable: $$ReportingUnitTableReferences
                          ._incidentRecordRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ReportingUnitTableReferences(
                            db,
                            table,
                            p0,
                          ).incidentRecordRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.reportingUnitId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ReportingUnitTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportingUnitTable,
      ReportingUnitData,
      $$ReportingUnitTableFilterComposer,
      $$ReportingUnitTableOrderingComposer,
      $$ReportingUnitTableAnnotationComposer,
      $$ReportingUnitTableCreateCompanionBuilder,
      $$ReportingUnitTableUpdateCompanionBuilder,
      (ReportingUnitData, $$ReportingUnitTableReferences),
      ReportingUnitData,
      PrefetchHooks Function({bool incidentRecordRefs})
    >;
typedef $$ChiefComplaintTypeTableCreateCompanionBuilder =
    ChiefComplaintTypeCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      Value<bool> isActive,
    });
typedef $$ChiefComplaintTypeTableUpdateCompanionBuilder =
    ChiefComplaintTypeCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<bool> isActive,
    });

final class $$ChiefComplaintTypeTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChiefComplaintTypeTable,
          ChiefComplaintTypeData
        > {
  $$ChiefComplaintTypeTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ChiefComplaintDetailTable,
    List<ChiefComplaintDetailData>
  >
  _chiefComplaintDetailRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.chiefComplaintDetail,
        aliasName: $_aliasNameGenerator(
          db.chiefComplaintType.id,
          db.chiefComplaintDetail.chiefComplaintTypeId,
        ),
      );

  $$ChiefComplaintDetailTableProcessedTableManager
  get chiefComplaintDetailRefs {
    final manager =
        $$ChiefComplaintDetailTableTableManager(
          $_db,
          $_db.chiefComplaintDetail,
        ).filter(
          (f) => f.chiefComplaintTypeId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _chiefComplaintDetailRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChiefComplaintTypeTableFilterComposer
    extends Composer<_$AppDatabase, $ChiefComplaintTypeTable> {
  $$ChiefComplaintTypeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chiefComplaintDetailRefs(
    Expression<bool> Function($$ChiefComplaintDetailTableFilterComposer f) f,
  ) {
    final $$ChiefComplaintDetailTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chiefComplaintDetail,
      getReferencedColumn: (t) => t.chiefComplaintTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChiefComplaintDetailTableFilterComposer(
            $db: $db,
            $table: $db.chiefComplaintDetail,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChiefComplaintTypeTableOrderingComposer
    extends Composer<_$AppDatabase, $ChiefComplaintTypeTable> {
  $$ChiefComplaintTypeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChiefComplaintTypeTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChiefComplaintTypeTable> {
  $$ChiefComplaintTypeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> chiefComplaintDetailRefs<T extends Object>(
    Expression<T> Function($$ChiefComplaintDetailTableAnnotationComposer a) f,
  ) {
    final $$ChiefComplaintDetailTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.chiefComplaintDetail,
          getReferencedColumn: (t) => t.chiefComplaintTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChiefComplaintDetailTableAnnotationComposer(
                $db: $db,
                $table: $db.chiefComplaintDetail,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ChiefComplaintTypeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChiefComplaintTypeTable,
          ChiefComplaintTypeData,
          $$ChiefComplaintTypeTableFilterComposer,
          $$ChiefComplaintTypeTableOrderingComposer,
          $$ChiefComplaintTypeTableAnnotationComposer,
          $$ChiefComplaintTypeTableCreateCompanionBuilder,
          $$ChiefComplaintTypeTableUpdateCompanionBuilder,
          (ChiefComplaintTypeData, $$ChiefComplaintTypeTableReferences),
          ChiefComplaintTypeData,
          PrefetchHooks Function({bool chiefComplaintDetailRefs})
        > {
  $$ChiefComplaintTypeTableTableManager(
    _$AppDatabase db,
    $ChiefComplaintTypeTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChiefComplaintTypeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChiefComplaintTypeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChiefComplaintTypeTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ChiefComplaintTypeCompanion(
                id: id,
                code: code,
                name: name,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                Value<bool> isActive = const Value.absent(),
              }) => ChiefComplaintTypeCompanion.insert(
                id: id,
                code: code,
                name: name,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChiefComplaintTypeTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chiefComplaintDetailRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chiefComplaintDetailRefs) db.chiefComplaintDetail,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chiefComplaintDetailRefs)
                    await $_getPrefetchedData<
                      ChiefComplaintTypeData,
                      $ChiefComplaintTypeTable,
                      ChiefComplaintDetailData
                    >(
                      currentTable: table,
                      referencedTable: $$ChiefComplaintTypeTableReferences
                          ._chiefComplaintDetailRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChiefComplaintTypeTableReferences(
                            db,
                            table,
                            p0,
                          ).chiefComplaintDetailRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.chiefComplaintTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChiefComplaintTypeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChiefComplaintTypeTable,
      ChiefComplaintTypeData,
      $$ChiefComplaintTypeTableFilterComposer,
      $$ChiefComplaintTypeTableOrderingComposer,
      $$ChiefComplaintTypeTableAnnotationComposer,
      $$ChiefComplaintTypeTableCreateCompanionBuilder,
      $$ChiefComplaintTypeTableUpdateCompanionBuilder,
      (ChiefComplaintTypeData, $$ChiefComplaintTypeTableReferences),
      ChiefComplaintTypeData,
      PrefetchHooks Function({bool chiefComplaintDetailRefs})
    >;
typedef $$ChiefComplaintDetailTableCreateCompanionBuilder =
    ChiefComplaintDetailCompanion Function({
      Value<int> id,
      required int chiefComplaintTypeId,
      required String name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$ChiefComplaintDetailTableUpdateCompanionBuilder =
    ChiefComplaintDetailCompanion Function({
      Value<int> id,
      Value<int> chiefComplaintTypeId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

final class $$ChiefComplaintDetailTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChiefComplaintDetailTable,
          ChiefComplaintDetailData
        > {
  $$ChiefComplaintDetailTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChiefComplaintTypeTable _chiefComplaintTypeIdTable(
    _$AppDatabase db,
  ) => db.chiefComplaintType.createAlias(
    $_aliasNameGenerator(
      db.chiefComplaintDetail.chiefComplaintTypeId,
      db.chiefComplaintType.id,
    ),
  );

  $$ChiefComplaintTypeTableProcessedTableManager get chiefComplaintTypeId {
    final $_column = $_itemColumn<int>('chief_complaint_type_id')!;

    final manager = $$ChiefComplaintTypeTableTableManager(
      $_db,
      $_db.chiefComplaintType,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _chiefComplaintTypeIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChiefComplaintDetailTableFilterComposer
    extends Composer<_$AppDatabase, $ChiefComplaintDetailTable> {
  $$ChiefComplaintDetailTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$ChiefComplaintTypeTableFilterComposer get chiefComplaintTypeId {
    final $$ChiefComplaintTypeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chiefComplaintTypeId,
      referencedTable: $db.chiefComplaintType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChiefComplaintTypeTableFilterComposer(
            $db: $db,
            $table: $db.chiefComplaintType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChiefComplaintDetailTableOrderingComposer
    extends Composer<_$AppDatabase, $ChiefComplaintDetailTable> {
  $$ChiefComplaintDetailTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChiefComplaintTypeTableOrderingComposer get chiefComplaintTypeId {
    final $$ChiefComplaintTypeTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chiefComplaintTypeId,
      referencedTable: $db.chiefComplaintType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChiefComplaintTypeTableOrderingComposer(
            $db: $db,
            $table: $db.chiefComplaintType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChiefComplaintDetailTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChiefComplaintDetailTable> {
  $$ChiefComplaintDetailTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ChiefComplaintTypeTableAnnotationComposer get chiefComplaintTypeId {
    final $$ChiefComplaintTypeTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.chiefComplaintTypeId,
          referencedTable: $db.chiefComplaintType,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChiefComplaintTypeTableAnnotationComposer(
                $db: $db,
                $table: $db.chiefComplaintType,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ChiefComplaintDetailTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChiefComplaintDetailTable,
          ChiefComplaintDetailData,
          $$ChiefComplaintDetailTableFilterComposer,
          $$ChiefComplaintDetailTableOrderingComposer,
          $$ChiefComplaintDetailTableAnnotationComposer,
          $$ChiefComplaintDetailTableCreateCompanionBuilder,
          $$ChiefComplaintDetailTableUpdateCompanionBuilder,
          (ChiefComplaintDetailData, $$ChiefComplaintDetailTableReferences),
          ChiefComplaintDetailData,
          PrefetchHooks Function({bool chiefComplaintTypeId})
        > {
  $$ChiefComplaintDetailTableTableManager(
    _$AppDatabase db,
    $ChiefComplaintDetailTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChiefComplaintDetailTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChiefComplaintDetailTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ChiefComplaintDetailTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chiefComplaintTypeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ChiefComplaintDetailCompanion(
                id: id,
                chiefComplaintTypeId: chiefComplaintTypeId,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chiefComplaintTypeId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ChiefComplaintDetailCompanion.insert(
                id: id,
                chiefComplaintTypeId: chiefComplaintTypeId,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChiefComplaintDetailTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chiefComplaintTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chiefComplaintTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chiefComplaintTypeId,
                                referencedTable:
                                    $$ChiefComplaintDetailTableReferences
                                        ._chiefComplaintTypeIdTable(db),
                                referencedColumn:
                                    $$ChiefComplaintDetailTableReferences
                                        ._chiefComplaintTypeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChiefComplaintDetailTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChiefComplaintDetailTable,
      ChiefComplaintDetailData,
      $$ChiefComplaintDetailTableFilterComposer,
      $$ChiefComplaintDetailTableOrderingComposer,
      $$ChiefComplaintDetailTableAnnotationComposer,
      $$ChiefComplaintDetailTableCreateCompanionBuilder,
      $$ChiefComplaintDetailTableUpdateCompanionBuilder,
      (ChiefComplaintDetailData, $$ChiefComplaintDetailTableReferences),
      ChiefComplaintDetailData,
      PrefetchHooks Function({bool chiefComplaintTypeId})
    >;
typedef $$DiagnosisCategoryTableCreateCompanionBuilder =
    DiagnosisCategoryCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$DiagnosisCategoryTableUpdateCompanionBuilder =
    DiagnosisCategoryCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

class $$DiagnosisCategoryTableFilterComposer
    extends Composer<_$AppDatabase, $DiagnosisCategoryTable> {
  $$DiagnosisCategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiagnosisCategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagnosisCategoryTable> {
  $$DiagnosisCategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagnosisCategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagnosisCategoryTable> {
  $$DiagnosisCategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$DiagnosisCategoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagnosisCategoryTable,
          DiagnosisCategoryData,
          $$DiagnosisCategoryTableFilterComposer,
          $$DiagnosisCategoryTableOrderingComposer,
          $$DiagnosisCategoryTableAnnotationComposer,
          $$DiagnosisCategoryTableCreateCompanionBuilder,
          $$DiagnosisCategoryTableUpdateCompanionBuilder,
          (
            DiagnosisCategoryData,
            BaseReferences<
              _$AppDatabase,
              $DiagnosisCategoryTable,
              DiagnosisCategoryData
            >,
          ),
          DiagnosisCategoryData,
          PrefetchHooks Function()
        > {
  $$DiagnosisCategoryTableTableManager(
    _$AppDatabase db,
    $DiagnosisCategoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosisCategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagnosisCategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagnosisCategoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DiagnosisCategoryCompanion(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DiagnosisCategoryCompanion.insert(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiagnosisCategoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagnosisCategoryTable,
      DiagnosisCategoryData,
      $$DiagnosisCategoryTableFilterComposer,
      $$DiagnosisCategoryTableOrderingComposer,
      $$DiagnosisCategoryTableAnnotationComposer,
      $$DiagnosisCategoryTableCreateCompanionBuilder,
      $$DiagnosisCategoryTableUpdateCompanionBuilder,
      (
        DiagnosisCategoryData,
        BaseReferences<
          _$AppDatabase,
          $DiagnosisCategoryTable,
          DiagnosisCategoryData
        >,
      ),
      DiagnosisCategoryData,
      PrefetchHooks Function()
    >;
typedef $$TriageLevelTableCreateCompanionBuilder =
    TriageLevelCompanion Function({
      Value<int> id,
      required int level,
      required String name,
      required String colorCode,
      Value<String?> description,
    });
typedef $$TriageLevelTableUpdateCompanionBuilder =
    TriageLevelCompanion Function({
      Value<int> id,
      Value<int> level,
      Value<String> name,
      Value<String> colorCode,
      Value<String?> description,
    });

class $$TriageLevelTableFilterComposer
    extends Composer<_$AppDatabase, $TriageLevelTable> {
  $$TriageLevelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorCode => $composableBuilder(
    column: $table.colorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TriageLevelTableOrderingComposer
    extends Composer<_$AppDatabase, $TriageLevelTable> {
  $$TriageLevelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorCode => $composableBuilder(
    column: $table.colorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TriageLevelTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriageLevelTable> {
  $$TriageLevelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorCode =>
      $composableBuilder(column: $table.colorCode, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$TriageLevelTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriageLevelTable,
          TriageLevelData,
          $$TriageLevelTableFilterComposer,
          $$TriageLevelTableOrderingComposer,
          $$TriageLevelTableAnnotationComposer,
          $$TriageLevelTableCreateCompanionBuilder,
          $$TriageLevelTableUpdateCompanionBuilder,
          (
            TriageLevelData,
            BaseReferences<_$AppDatabase, $TriageLevelTable, TriageLevelData>,
          ),
          TriageLevelData,
          PrefetchHooks Function()
        > {
  $$TriageLevelTableTableManager(_$AppDatabase db, $TriageLevelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriageLevelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriageLevelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriageLevelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorCode = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => TriageLevelCompanion(
                id: id,
                level: level,
                name: name,
                colorCode: colorCode,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int level,
                required String name,
                required String colorCode,
                Value<String?> description = const Value.absent(),
              }) => TriageLevelCompanion.insert(
                id: id,
                level: level,
                name: name,
                colorCode: colorCode,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TriageLevelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriageLevelTable,
      TriageLevelData,
      $$TriageLevelTableFilterComposer,
      $$TriageLevelTableOrderingComposer,
      $$TriageLevelTableAnnotationComposer,
      $$TriageLevelTableCreateCompanionBuilder,
      $$TriageLevelTableUpdateCompanionBuilder,
      (
        TriageLevelData,
        BaseReferences<_$AppDatabase, $TriageLevelTable, TriageLevelData>,
      ),
      TriageLevelData,
      PrefetchHooks Function()
    >;
typedef $$TreatmentOnSiteTableCreateCompanionBuilder =
    TreatmentOnSiteCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$TreatmentOnSiteTableUpdateCompanionBuilder =
    TreatmentOnSiteCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

class $$TreatmentOnSiteTableFilterComposer
    extends Composer<_$AppDatabase, $TreatmentOnSiteTable> {
  $$TreatmentOnSiteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreatmentOnSiteTableOrderingComposer
    extends Composer<_$AppDatabase, $TreatmentOnSiteTable> {
  $$TreatmentOnSiteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreatmentOnSiteTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreatmentOnSiteTable> {
  $$TreatmentOnSiteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$TreatmentOnSiteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreatmentOnSiteTable,
          TreatmentOnSiteData,
          $$TreatmentOnSiteTableFilterComposer,
          $$TreatmentOnSiteTableOrderingComposer,
          $$TreatmentOnSiteTableAnnotationComposer,
          $$TreatmentOnSiteTableCreateCompanionBuilder,
          $$TreatmentOnSiteTableUpdateCompanionBuilder,
          (
            TreatmentOnSiteData,
            BaseReferences<
              _$AppDatabase,
              $TreatmentOnSiteTable,
              TreatmentOnSiteData
            >,
          ),
          TreatmentOnSiteData,
          PrefetchHooks Function()
        > {
  $$TreatmentOnSiteTableTableManager(
    _$AppDatabase db,
    $TreatmentOnSiteTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentOnSiteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentOnSiteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentOnSiteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TreatmentOnSiteCompanion(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TreatmentOnSiteCompanion.insert(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreatmentOnSiteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreatmentOnSiteTable,
      TreatmentOnSiteData,
      $$TreatmentOnSiteTableFilterComposer,
      $$TreatmentOnSiteTableOrderingComposer,
      $$TreatmentOnSiteTableAnnotationComposer,
      $$TreatmentOnSiteTableCreateCompanionBuilder,
      $$TreatmentOnSiteTableUpdateCompanionBuilder,
      (
        TreatmentOnSiteData,
        BaseReferences<
          _$AppDatabase,
          $TreatmentOnSiteTable,
          TreatmentOnSiteData
        >,
      ),
      TreatmentOnSiteData,
      PrefetchHooks Function()
    >;
typedef $$TreatmentResultTableCreateCompanionBuilder =
    TreatmentResultCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$TreatmentResultTableUpdateCompanionBuilder =
    TreatmentResultCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

class $$TreatmentResultTableFilterComposer
    extends Composer<_$AppDatabase, $TreatmentResultTable> {
  $$TreatmentResultTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreatmentResultTableOrderingComposer
    extends Composer<_$AppDatabase, $TreatmentResultTable> {
  $$TreatmentResultTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreatmentResultTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreatmentResultTable> {
  $$TreatmentResultTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$TreatmentResultTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreatmentResultTable,
          TreatmentResultData,
          $$TreatmentResultTableFilterComposer,
          $$TreatmentResultTableOrderingComposer,
          $$TreatmentResultTableAnnotationComposer,
          $$TreatmentResultTableCreateCompanionBuilder,
          $$TreatmentResultTableUpdateCompanionBuilder,
          (
            TreatmentResultData,
            BaseReferences<
              _$AppDatabase,
              $TreatmentResultTable,
              TreatmentResultData
            >,
          ),
          TreatmentResultData,
          PrefetchHooks Function()
        > {
  $$TreatmentResultTableTableManager(
    _$AppDatabase db,
    $TreatmentResultTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentResultTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentResultTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentResultTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TreatmentResultCompanion(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TreatmentResultCompanion.insert(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreatmentResultTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreatmentResultTable,
      TreatmentResultData,
      $$TreatmentResultTableFilterComposer,
      $$TreatmentResultTableOrderingComposer,
      $$TreatmentResultTableAnnotationComposer,
      $$TreatmentResultTableCreateCompanionBuilder,
      $$TreatmentResultTableUpdateCompanionBuilder,
      (
        TreatmentResultData,
        BaseReferences<
          _$AppDatabase,
          $TreatmentResultTable,
          TreatmentResultData
        >,
      ),
      TreatmentResultData,
      PrefetchHooks Function()
    >;
typedef $$ReferralHospitalTableCreateCompanionBuilder =
    ReferralHospitalCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<String?> phone,
      Value<int> sortOrder,
      Value<bool> isOther,
      Value<bool> isActive,
    });
typedef $$ReferralHospitalTableUpdateCompanionBuilder =
    ReferralHospitalCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> phone,
      Value<int> sortOrder,
      Value<bool> isOther,
      Value<bool> isActive,
    });

class $$ReferralHospitalTableFilterComposer
    extends Composer<_$AppDatabase, $ReferralHospitalTable> {
  $$ReferralHospitalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOther => $composableBuilder(
    column: $table.isOther,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReferralHospitalTableOrderingComposer
    extends Composer<_$AppDatabase, $ReferralHospitalTable> {
  $$ReferralHospitalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOther => $composableBuilder(
    column: $table.isOther,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReferralHospitalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReferralHospitalTable> {
  $$ReferralHospitalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isOther =>
      $composableBuilder(column: $table.isOther, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ReferralHospitalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReferralHospitalTable,
          ReferralHospitalData,
          $$ReferralHospitalTableFilterComposer,
          $$ReferralHospitalTableOrderingComposer,
          $$ReferralHospitalTableAnnotationComposer,
          $$ReferralHospitalTableCreateCompanionBuilder,
          $$ReferralHospitalTableUpdateCompanionBuilder,
          (
            ReferralHospitalData,
            BaseReferences<
              _$AppDatabase,
              $ReferralHospitalTable,
              ReferralHospitalData
            >,
          ),
          ReferralHospitalData,
          PrefetchHooks Function()
        > {
  $$ReferralHospitalTableTableManager(
    _$AppDatabase db,
    $ReferralHospitalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReferralHospitalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReferralHospitalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReferralHospitalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isOther = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ReferralHospitalCompanion(
                id: id,
                name: name,
                address: address,
                phone: phone,
                sortOrder: sortOrder,
                isOther: isOther,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isOther = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ReferralHospitalCompanion.insert(
                id: id,
                name: name,
                address: address,
                phone: phone,
                sortOrder: sortOrder,
                isOther: isOther,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReferralHospitalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReferralHospitalTable,
      ReferralHospitalData,
      $$ReferralHospitalTableFilterComposer,
      $$ReferralHospitalTableOrderingComposer,
      $$ReferralHospitalTableAnnotationComposer,
      $$ReferralHospitalTableCreateCompanionBuilder,
      $$ReferralHospitalTableUpdateCompanionBuilder,
      (
        ReferralHospitalData,
        BaseReferences<
          _$AppDatabase,
          $ReferralHospitalTable,
          ReferralHospitalData
        >,
      ),
      ReferralHospitalData,
      PrefetchHooks Function()
    >;
typedef $$ActionItemTableCreateCompanionBuilder =
    ActionItemCompanion Function({
      Value<int> id,
      required String name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$ActionItemTableUpdateCompanionBuilder =
    ActionItemCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

class $$ActionItemTableFilterComposer
    extends Composer<_$AppDatabase, $ActionItemTable> {
  $$ActionItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActionItemTableOrderingComposer
    extends Composer<_$AppDatabase, $ActionItemTable> {
  $$ActionItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActionItemTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActionItemTable> {
  $$ActionItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ActionItemTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActionItemTable,
          ActionItemData,
          $$ActionItemTableFilterComposer,
          $$ActionItemTableOrderingComposer,
          $$ActionItemTableAnnotationComposer,
          $$ActionItemTableCreateCompanionBuilder,
          $$ActionItemTableUpdateCompanionBuilder,
          (
            ActionItemData,
            BaseReferences<_$AppDatabase, $ActionItemTable, ActionItemData>,
          ),
          ActionItemData,
          PrefetchHooks Function()
        > {
  $$ActionItemTableTableManager(_$AppDatabase db, $ActionItemTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ActionItemCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ActionItemCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActionItemTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActionItemTable,
      ActionItemData,
      $$ActionItemTableFilterComposer,
      $$ActionItemTableOrderingComposer,
      $$ActionItemTableAnnotationComposer,
      $$ActionItemTableCreateCompanionBuilder,
      $$ActionItemTableUpdateCompanionBuilder,
      (
        ActionItemData,
        BaseReferences<_$AppDatabase, $ActionItemTable, ActionItemData>,
      ),
      ActionItemData,
      PrefetchHooks Function()
    >;
typedef $$MedicalStaffTableCreateCompanionBuilder =
    MedicalStaffCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> employeeId,
      required String role,
      Value<String?> department,
      Value<String?> phone,
      Value<Uint8List?> signature,
      Value<bool> isActive,
    });
typedef $$MedicalStaffTableUpdateCompanionBuilder =
    MedicalStaffCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> employeeId,
      Value<String> role,
      Value<String?> department,
      Value<String?> phone,
      Value<Uint8List?> signature,
      Value<bool> isActive,
    });

class $$MedicalStaffTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalStaffTable> {
  $$MedicalStaffTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicalStaffTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalStaffTable> {
  $$MedicalStaffTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalStaffTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalStaffTable> {
  $$MedicalStaffTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<Uint8List> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$MedicalStaffTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalStaffTable,
          MedicalStaffData,
          $$MedicalStaffTableFilterComposer,
          $$MedicalStaffTableOrderingComposer,
          $$MedicalStaffTableAnnotationComposer,
          $$MedicalStaffTableCreateCompanionBuilder,
          $$MedicalStaffTableUpdateCompanionBuilder,
          (
            MedicalStaffData,
            BaseReferences<_$AppDatabase, $MedicalStaffTable, MedicalStaffData>,
          ),
          MedicalStaffData,
          PrefetchHooks Function()
        > {
  $$MedicalStaffTableTableManager(_$AppDatabase db, $MedicalStaffTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalStaffTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalStaffTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalStaffTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> employeeId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<Uint8List?> signature = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MedicalStaffCompanion(
                id: id,
                name: name,
                employeeId: employeeId,
                role: role,
                department: department,
                phone: phone,
                signature: signature,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> employeeId = const Value.absent(),
                required String role,
                Value<String?> department = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<Uint8List?> signature = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MedicalStaffCompanion.insert(
                id: id,
                name: name,
                employeeId: employeeId,
                role: role,
                department: department,
                phone: phone,
                signature: signature,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicalStaffTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalStaffTable,
      MedicalStaffData,
      $$MedicalStaffTableFilterComposer,
      $$MedicalStaffTableOrderingComposer,
      $$MedicalStaffTableAnnotationComposer,
      $$MedicalStaffTableCreateCompanionBuilder,
      $$MedicalStaffTableUpdateCompanionBuilder,
      (
        MedicalStaffData,
        BaseReferences<_$AppDatabase, $MedicalStaffTable, MedicalStaffData>,
      ),
      MedicalStaffData,
      PrefetchHooks Function()
    >;
typedef $$SpecialNoteRefTableCreateCompanionBuilder =
    SpecialNoteRefCompanion Function({
      Value<int> id,
      required String name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$SpecialNoteRefTableUpdateCompanionBuilder =
    SpecialNoteRefCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

class $$SpecialNoteRefTableFilterComposer
    extends Composer<_$AppDatabase, $SpecialNoteRefTable> {
  $$SpecialNoteRefTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpecialNoteRefTableOrderingComposer
    extends Composer<_$AppDatabase, $SpecialNoteRefTable> {
  $$SpecialNoteRefTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpecialNoteRefTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpecialNoteRefTable> {
  $$SpecialNoteRefTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SpecialNoteRefTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpecialNoteRefTable,
          SpecialNoteRefData,
          $$SpecialNoteRefTableFilterComposer,
          $$SpecialNoteRefTableOrderingComposer,
          $$SpecialNoteRefTableAnnotationComposer,
          $$SpecialNoteRefTableCreateCompanionBuilder,
          $$SpecialNoteRefTableUpdateCompanionBuilder,
          (
            SpecialNoteRefData,
            BaseReferences<
              _$AppDatabase,
              $SpecialNoteRefTable,
              SpecialNoteRefData
            >,
          ),
          SpecialNoteRefData,
          PrefetchHooks Function()
        > {
  $$SpecialNoteRefTableTableManager(
    _$AppDatabase db,
    $SpecialNoteRefTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpecialNoteRefTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpecialNoteRefTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpecialNoteRefTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => SpecialNoteRefCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => SpecialNoteRefCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpecialNoteRefTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpecialNoteRefTable,
      SpecialNoteRefData,
      $$SpecialNoteRefTableFilterComposer,
      $$SpecialNoteRefTableOrderingComposer,
      $$SpecialNoteRefTableAnnotationComposer,
      $$SpecialNoteRefTableCreateCompanionBuilder,
      $$SpecialNoteRefTableUpdateCompanionBuilder,
      (
        SpecialNoteRefData,
        BaseReferences<_$AppDatabase, $SpecialNoteRefTable, SpecialNoteRefData>,
      ),
      SpecialNoteRefData,
      PrefetchHooks Function()
    >;
typedef $$NursingPhraseTableCreateCompanionBuilder =
    NursingPhraseCompanion Function({
      Value<int> id,
      required String title,
      required String content,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$NursingPhraseTableUpdateCompanionBuilder =
    NursingPhraseCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

class $$NursingPhraseTableFilterComposer
    extends Composer<_$AppDatabase, $NursingPhraseTable> {
  $$NursingPhraseTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NursingPhraseTableOrderingComposer
    extends Composer<_$AppDatabase, $NursingPhraseTable> {
  $$NursingPhraseTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NursingPhraseTableAnnotationComposer
    extends Composer<_$AppDatabase, $NursingPhraseTable> {
  $$NursingPhraseTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$NursingPhraseTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NursingPhraseTable,
          NursingPhraseData,
          $$NursingPhraseTableFilterComposer,
          $$NursingPhraseTableOrderingComposer,
          $$NursingPhraseTableAnnotationComposer,
          $$NursingPhraseTableCreateCompanionBuilder,
          $$NursingPhraseTableUpdateCompanionBuilder,
          (
            NursingPhraseData,
            BaseReferences<
              _$AppDatabase,
              $NursingPhraseTable,
              NursingPhraseData
            >,
          ),
          NursingPhraseData,
          PrefetchHooks Function()
        > {
  $$NursingPhraseTableTableManager(_$AppDatabase db, $NursingPhraseTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NursingPhraseTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NursingPhraseTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NursingPhraseTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => NursingPhraseCompanion(
                id: id,
                title: title,
                content: content,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String content,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => NursingPhraseCompanion.insert(
                id: id,
                title: title,
                content: content,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NursingPhraseTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NursingPhraseTable,
      NursingPhraseData,
      $$NursingPhraseTableFilterComposer,
      $$NursingPhraseTableOrderingComposer,
      $$NursingPhraseTableAnnotationComposer,
      $$NursingPhraseTableCreateCompanionBuilder,
      $$NursingPhraseTableUpdateCompanionBuilder,
      (
        NursingPhraseData,
        BaseReferences<_$AppDatabase, $NursingPhraseTable, NursingPhraseData>,
      ),
      NursingPhraseData,
      PrefetchHooks Function()
    >;
typedef $$MedicalRecordTableCreateCompanionBuilder =
    MedicalRecordCompanion Function({
      Value<int> medicalId,
      Value<bool> isEmergency,
      Value<bool> hasAmbulance,
      Value<bool?> cdcPassed,
      Value<String?> screeningMethod,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MedicalRecordTableUpdateCompanionBuilder =
    MedicalRecordCompanion Function({
      Value<int> medicalId,
      Value<bool> isEmergency,
      Value<bool> hasAmbulance,
      Value<bool?> cdcPassed,
      Value<String?> screeningMethod,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$MedicalRecordTableReferences
    extends
        BaseReferences<_$AppDatabase, $MedicalRecordTable, MedicalRecordData> {
  $$MedicalRecordTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PatientTable, List<PatientData>>
  _patientRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.patient,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.patient.medicalId,
    ),
  );

  $$PatientTableProcessedTableManager get patientRefs {
    final manager = $$PatientTableTableManager($_db, $_db.patient).filter(
      (f) => f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_patientRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FlightRecordTable, List<FlightRecordData>>
  _flightRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flightRecord,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.flightRecord.medicalId,
    ),
  );

  $$FlightRecordTableProcessedTableManager get flightRecordRefs {
    final manager = $$FlightRecordTableTableManager($_db, $_db.flightRecord)
        .filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_flightRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncidentRecordTable, List<IncidentRecordData>>
  _incidentRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incidentRecord,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.incidentRecord.medicalId,
    ),
  );

  $$IncidentRecordTableProcessedTableManager get incidentRecordRefs {
    final manager = $$IncidentRecordTableTableManager($_db, $_db.incidentRecord)
        .filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_incidentRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChiefComplaintTable, List<ChiefComplaintData>>
  _chiefComplaintRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chiefComplaint,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.chiefComplaint.medicalId,
    ),
  );

  $$ChiefComplaintTableProcessedTableManager get chiefComplaintRefs {
    final manager = $$ChiefComplaintTableTableManager($_db, $_db.chiefComplaint)
        .filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_chiefComplaintRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $HealthAssessmentFormTable,
    List<HealthAssessmentFormData>
  >
  _healthAssessmentFormRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.healthAssessmentForm,
        aliasName: $_aliasNameGenerator(
          db.medicalRecord.medicalId,
          db.healthAssessmentForm.medicalId,
        ),
      );

  $$HealthAssessmentFormTableProcessedTableManager
  get healthAssessmentFormRefs {
    final manager =
        $$HealthAssessmentFormTableTableManager(
          $_db,
          $_db.healthAssessmentForm,
        ).filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _healthAssessmentFormRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicalMediaTable, List<MedicalMediaData>>
  _medicalMediaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicalMedia,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.medicalMedia.medicalId,
    ),
  );

  $$MedicalMediaTableProcessedTableManager get medicalMediaRefs {
    final manager = $$MedicalMediaTableTableManager($_db, $_db.medicalMedia)
        .filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_medicalMediaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MedicalAssessmentTable,
    List<MedicalAssessmentData>
  >
  _medicalAssessmentRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicalAssessment,
        aliasName: $_aliasNameGenerator(
          db.medicalRecord.medicalId,
          db.medicalAssessment.medicalId,
        ),
      );

  $$MedicalAssessmentTableProcessedTableManager get medicalAssessmentRefs {
    final manager =
        $$MedicalAssessmentTableTableManager(
          $_db,
          $_db.medicalAssessment,
        ).filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _medicalAssessmentRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicalHistoryTable, List<MedicalHistoryData>>
  _medicalHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicalHistory,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.medicalHistory.medicalId,
    ),
  );

  $$MedicalHistoryTableProcessedTableManager get medicalHistoryRefs {
    final manager = $$MedicalHistoryTableTableManager($_db, $_db.medicalHistory)
        .filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_medicalHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TreatmentTable, List<TreatmentData>>
  _treatmentRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.treatment,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.treatment.medicalId,
    ),
  );

  $$TreatmentTableProcessedTableManager get treatmentRefs {
    final manager = $$TreatmentTableTableManager($_db, $_db.treatment).filter(
      (f) => f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_treatmentRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MedicalStaffAssignmentTable,
    List<MedicalStaffAssignmentData>
  >
  _medicalStaffAssignmentRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicalStaffAssignment,
        aliasName: $_aliasNameGenerator(
          db.medicalRecord.medicalId,
          db.medicalStaffAssignment.medicalId,
        ),
      );

  $$MedicalStaffAssignmentTableProcessedTableManager
  get medicalStaffAssignmentRefs {
    final manager =
        $$MedicalStaffAssignmentTableTableManager(
          $_db,
          $_db.medicalStaffAssignment,
        ).filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _medicalStaffAssignmentRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpecialNotesTable, List<SpecialNotesData>>
  _specialNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.specialNotes,
    aliasName: $_aliasNameGenerator(
      db.medicalRecord.medicalId,
      db.specialNotes.medicalId,
    ),
  );

  $$SpecialNotesTableProcessedTableManager get specialNotesRefs {
    final manager = $$SpecialNotesTableTableManager($_db, $_db.specialNotes)
        .filter(
          (f) =>
              f.medicalId.medicalId.sqlEquals($_itemColumn<int>('medical_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_specialNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicalRecordTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalRecordTable> {
  $$MedicalRecordTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get medicalId => $composableBuilder(
    column: $table.medicalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAmbulance => $composableBuilder(
    column: $table.hasAmbulance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cdcPassed => $composableBuilder(
    column: $table.cdcPassed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get screeningMethod => $composableBuilder(
    column: $table.screeningMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> patientRefs(
    Expression<bool> Function($$PatientTableFilterComposer f) f,
  ) {
    final $$PatientTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.patient,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientTableFilterComposer(
            $db: $db,
            $table: $db.patient,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flightRecordRefs(
    Expression<bool> Function($$FlightRecordTableFilterComposer f) f,
  ) {
    final $$FlightRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableFilterComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incidentRecordRefs(
    Expression<bool> Function($$IncidentRecordTableFilterComposer f) f,
  ) {
    final $$IncidentRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableFilterComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chiefComplaintRefs(
    Expression<bool> Function($$ChiefComplaintTableFilterComposer f) f,
  ) {
    final $$ChiefComplaintTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.chiefComplaint,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChiefComplaintTableFilterComposer(
            $db: $db,
            $table: $db.chiefComplaint,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> healthAssessmentFormRefs(
    Expression<bool> Function($$HealthAssessmentFormTableFilterComposer f) f,
  ) {
    final $$HealthAssessmentFormTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.healthAssessmentForm,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HealthAssessmentFormTableFilterComposer(
            $db: $db,
            $table: $db.healthAssessmentForm,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicalMediaRefs(
    Expression<bool> Function($$MedicalMediaTableFilterComposer f) f,
  ) {
    final $$MedicalMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalMedia,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalMediaTableFilterComposer(
            $db: $db,
            $table: $db.medicalMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicalAssessmentRefs(
    Expression<bool> Function($$MedicalAssessmentTableFilterComposer f) f,
  ) {
    final $$MedicalAssessmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalAssessment,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalAssessmentTableFilterComposer(
            $db: $db,
            $table: $db.medicalAssessment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicalHistoryRefs(
    Expression<bool> Function($$MedicalHistoryTableFilterComposer f) f,
  ) {
    final $$MedicalHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalHistory,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalHistoryTableFilterComposer(
            $db: $db,
            $table: $db.medicalHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> treatmentRefs(
    Expression<bool> Function($$TreatmentTableFilterComposer f) f,
  ) {
    final $$TreatmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.treatment,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreatmentTableFilterComposer(
            $db: $db,
            $table: $db.treatment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicalStaffAssignmentRefs(
    Expression<bool> Function($$MedicalStaffAssignmentTableFilterComposer f) f,
  ) {
    final $$MedicalStaffAssignmentTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.medicalId,
          referencedTable: $db.medicalStaffAssignment,
          getReferencedColumn: (t) => t.medicalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicalStaffAssignmentTableFilterComposer(
                $db: $db,
                $table: $db.medicalStaffAssignment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> specialNotesRefs(
    Expression<bool> Function($$SpecialNotesTableFilterComposer f) f,
  ) {
    final $$SpecialNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.specialNotes,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpecialNotesTableFilterComposer(
            $db: $db,
            $table: $db.specialNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalRecordTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalRecordTable> {
  $$MedicalRecordTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get medicalId => $composableBuilder(
    column: $table.medicalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAmbulance => $composableBuilder(
    column: $table.hasAmbulance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cdcPassed => $composableBuilder(
    column: $table.cdcPassed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screeningMethod => $composableBuilder(
    column: $table.screeningMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalRecordTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalRecordTable> {
  $$MedicalRecordTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get medicalId =>
      $composableBuilder(column: $table.medicalId, builder: (column) => column);

  GeneratedColumn<bool> get isEmergency => $composableBuilder(
    column: $table.isEmergency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAmbulance => $composableBuilder(
    column: $table.hasAmbulance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cdcPassed =>
      $composableBuilder(column: $table.cdcPassed, builder: (column) => column);

  GeneratedColumn<String> get screeningMethod => $composableBuilder(
    column: $table.screeningMethod,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> patientRefs<T extends Object>(
    Expression<T> Function($$PatientTableAnnotationComposer a) f,
  ) {
    final $$PatientTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.patient,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientTableAnnotationComposer(
            $db: $db,
            $table: $db.patient,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> flightRecordRefs<T extends Object>(
    Expression<T> Function($$FlightRecordTableAnnotationComposer a) f,
  ) {
    final $$FlightRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incidentRecordRefs<T extends Object>(
    Expression<T> Function($$IncidentRecordTableAnnotationComposer a) f,
  ) {
    final $$IncidentRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.incidentRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.incidentRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chiefComplaintRefs<T extends Object>(
    Expression<T> Function($$ChiefComplaintTableAnnotationComposer a) f,
  ) {
    final $$ChiefComplaintTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.chiefComplaint,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChiefComplaintTableAnnotationComposer(
            $db: $db,
            $table: $db.chiefComplaint,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> healthAssessmentFormRefs<T extends Object>(
    Expression<T> Function($$HealthAssessmentFormTableAnnotationComposer a) f,
  ) {
    final $$HealthAssessmentFormTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.medicalId,
          referencedTable: $db.healthAssessmentForm,
          getReferencedColumn: (t) => t.medicalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HealthAssessmentFormTableAnnotationComposer(
                $db: $db,
                $table: $db.healthAssessmentForm,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> medicalMediaRefs<T extends Object>(
    Expression<T> Function($$MedicalMediaTableAnnotationComposer a) f,
  ) {
    final $$MedicalMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalMedia,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicalAssessmentRefs<T extends Object>(
    Expression<T> Function($$MedicalAssessmentTableAnnotationComposer a) f,
  ) {
    final $$MedicalAssessmentTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.medicalId,
          referencedTable: $db.medicalAssessment,
          getReferencedColumn: (t) => t.medicalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicalAssessmentTableAnnotationComposer(
                $db: $db,
                $table: $db.medicalAssessment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> medicalHistoryRefs<T extends Object>(
    Expression<T> Function($$MedicalHistoryTableAnnotationComposer a) f,
  ) {
    final $$MedicalHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalHistory,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> treatmentRefs<T extends Object>(
    Expression<T> Function($$TreatmentTableAnnotationComposer a) f,
  ) {
    final $$TreatmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.treatment,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreatmentTableAnnotationComposer(
            $db: $db,
            $table: $db.treatment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicalStaffAssignmentRefs<T extends Object>(
    Expression<T> Function($$MedicalStaffAssignmentTableAnnotationComposer a) f,
  ) {
    final $$MedicalStaffAssignmentTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.medicalId,
          referencedTable: $db.medicalStaffAssignment,
          getReferencedColumn: (t) => t.medicalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicalStaffAssignmentTableAnnotationComposer(
                $db: $db,
                $table: $db.medicalStaffAssignment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> specialNotesRefs<T extends Object>(
    Expression<T> Function($$SpecialNotesTableAnnotationComposer a) f,
  ) {
    final $$SpecialNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.specialNotes,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpecialNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.specialNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalRecordTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalRecordTable,
          MedicalRecordData,
          $$MedicalRecordTableFilterComposer,
          $$MedicalRecordTableOrderingComposer,
          $$MedicalRecordTableAnnotationComposer,
          $$MedicalRecordTableCreateCompanionBuilder,
          $$MedicalRecordTableUpdateCompanionBuilder,
          (MedicalRecordData, $$MedicalRecordTableReferences),
          MedicalRecordData,
          PrefetchHooks Function({
            bool patientRefs,
            bool flightRecordRefs,
            bool incidentRecordRefs,
            bool chiefComplaintRefs,
            bool healthAssessmentFormRefs,
            bool medicalMediaRefs,
            bool medicalAssessmentRefs,
            bool medicalHistoryRefs,
            bool treatmentRefs,
            bool medicalStaffAssignmentRefs,
            bool specialNotesRefs,
          })
        > {
  $$MedicalRecordTableTableManager(_$AppDatabase db, $MedicalRecordTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalRecordTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalRecordTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalRecordTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> medicalId = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<bool> hasAmbulance = const Value.absent(),
                Value<bool?> cdcPassed = const Value.absent(),
                Value<String?> screeningMethod = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicalRecordCompanion(
                medicalId: medicalId,
                isEmergency: isEmergency,
                hasAmbulance: hasAmbulance,
                cdcPassed: cdcPassed,
                screeningMethod: screeningMethod,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> medicalId = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<bool> hasAmbulance = const Value.absent(),
                Value<bool?> cdcPassed = const Value.absent(),
                Value<String?> screeningMethod = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicalRecordCompanion.insert(
                medicalId: medicalId,
                isEmergency: isEmergency,
                hasAmbulance: hasAmbulance,
                cdcPassed: cdcPassed,
                screeningMethod: screeningMethod,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicalRecordTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                patientRefs = false,
                flightRecordRefs = false,
                incidentRecordRefs = false,
                chiefComplaintRefs = false,
                healthAssessmentFormRefs = false,
                medicalMediaRefs = false,
                medicalAssessmentRefs = false,
                medicalHistoryRefs = false,
                treatmentRefs = false,
                medicalStaffAssignmentRefs = false,
                specialNotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (patientRefs) db.patient,
                    if (flightRecordRefs) db.flightRecord,
                    if (incidentRecordRefs) db.incidentRecord,
                    if (chiefComplaintRefs) db.chiefComplaint,
                    if (healthAssessmentFormRefs) db.healthAssessmentForm,
                    if (medicalMediaRefs) db.medicalMedia,
                    if (medicalAssessmentRefs) db.medicalAssessment,
                    if (medicalHistoryRefs) db.medicalHistory,
                    if (treatmentRefs) db.treatment,
                    if (medicalStaffAssignmentRefs) db.medicalStaffAssignment,
                    if (specialNotesRefs) db.specialNotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (patientRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          PatientData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._patientRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).patientRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (flightRecordRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          FlightRecordData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._flightRecordRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).flightRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (incidentRecordRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          IncidentRecordData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._incidentRecordRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).incidentRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (chiefComplaintRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          ChiefComplaintData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._chiefComplaintRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).chiefComplaintRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (healthAssessmentFormRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          HealthAssessmentFormData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._healthAssessmentFormRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).healthAssessmentFormRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (medicalMediaRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          MedicalMediaData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._medicalMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).medicalMediaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (medicalAssessmentRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          MedicalAssessmentData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._medicalAssessmentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).medicalAssessmentRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (medicalHistoryRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          MedicalHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._medicalHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).medicalHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (treatmentRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          TreatmentData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._treatmentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).treatmentRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (medicalStaffAssignmentRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          MedicalStaffAssignmentData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._medicalStaffAssignmentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).medicalStaffAssignmentRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                      if (specialNotesRefs)
                        await $_getPrefetchedData<
                          MedicalRecordData,
                          $MedicalRecordTable,
                          SpecialNotesData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalRecordTableReferences
                              ._specialNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).specialNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicalId == item.medicalId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicalRecordTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalRecordTable,
      MedicalRecordData,
      $$MedicalRecordTableFilterComposer,
      $$MedicalRecordTableOrderingComposer,
      $$MedicalRecordTableAnnotationComposer,
      $$MedicalRecordTableCreateCompanionBuilder,
      $$MedicalRecordTableUpdateCompanionBuilder,
      (MedicalRecordData, $$MedicalRecordTableReferences),
      MedicalRecordData,
      PrefetchHooks Function({
        bool patientRefs,
        bool flightRecordRefs,
        bool incidentRecordRefs,
        bool chiefComplaintRefs,
        bool healthAssessmentFormRefs,
        bool medicalMediaRefs,
        bool medicalAssessmentRefs,
        bool medicalHistoryRefs,
        bool treatmentRefs,
        bool medicalStaffAssignmentRefs,
        bool specialNotesRefs,
      })
    >;
typedef $$PatientTableCreateCompanionBuilder =
    PatientCompanion Function({
      Value<int> patientId,
      required int medicalId,
      Value<String?> name,
      Value<String?> anonymizationName,
      Value<DateTime?> birthday,
      Value<int?> age,
      Value<int?> sexId,
      Value<String?> passportOrIdNo,
      Value<int?> nationalityId,
      Value<String?> telephone,
      Value<String?> address,
      Value<DateTime> createdAt,
    });
typedef $$PatientTableUpdateCompanionBuilder =
    PatientCompanion Function({
      Value<int> patientId,
      Value<int> medicalId,
      Value<String?> name,
      Value<String?> anonymizationName,
      Value<DateTime?> birthday,
      Value<int?> age,
      Value<int?> sexId,
      Value<String?> passportOrIdNo,
      Value<int?> nationalityId,
      Value<String?> telephone,
      Value<String?> address,
      Value<DateTime> createdAt,
    });

final class $$PatientTableReferences
    extends BaseReferences<_$AppDatabase, $PatientTable, PatientData> {
  $$PatientTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(db.patient.medicalId, db.medicalRecord.medicalId),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SexTable _sexIdTable(_$AppDatabase db) =>
      db.sex.createAlias($_aliasNameGenerator(db.patient.sexId, db.sex.sexId));

  $$SexTableProcessedTableManager? get sexId {
    final $_column = $_itemColumn<int>('sex_id');
    if ($_column == null) return null;
    final manager = $$SexTableTableManager(
      $_db,
      $_db.sex,
    ).filter((f) => f.sexId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sexIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $NationalityTable _nationalityIdTable(_$AppDatabase db) =>
      db.nationality.createAlias(
        $_aliasNameGenerator(
          db.patient.nationalityId,
          db.nationality.nationalityId,
        ),
      );

  $$NationalityTableProcessedTableManager? get nationalityId {
    final $_column = $_itemColumn<int>('nationality_id');
    if ($_column == null) return null;
    final manager = $$NationalityTableTableManager(
      $_db,
      $_db.nationality,
    ).filter((f) => f.nationalityId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nationalityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PatientTableFilterComposer
    extends Composer<_$AppDatabase, $PatientTable> {
  $$PatientTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anonymizationName => $composableBuilder(
    column: $table.anonymizationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passportOrIdNo => $composableBuilder(
    column: $table.passportOrIdNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SexTableFilterComposer get sexId {
    final $$SexTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sexId,
      referencedTable: $db.sex,
      getReferencedColumn: (t) => t.sexId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SexTableFilterComposer(
            $db: $db,
            $table: $db.sex,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NationalityTableFilterComposer get nationalityId {
    final $$NationalityTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationalityId,
      referencedTable: $db.nationality,
      getReferencedColumn: (t) => t.nationalityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationalityTableFilterComposer(
            $db: $db,
            $table: $db.nationality,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PatientTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientTable> {
  $$PatientTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anonymizationName => $composableBuilder(
    column: $table.anonymizationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passportOrIdNo => $composableBuilder(
    column: $table.passportOrIdNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SexTableOrderingComposer get sexId {
    final $$SexTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sexId,
      referencedTable: $db.sex,
      getReferencedColumn: (t) => t.sexId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SexTableOrderingComposer(
            $db: $db,
            $table: $db.sex,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NationalityTableOrderingComposer get nationalityId {
    final $$NationalityTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationalityId,
      referencedTable: $db.nationality,
      getReferencedColumn: (t) => t.nationalityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationalityTableOrderingComposer(
            $db: $db,
            $table: $db.nationality,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PatientTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientTable> {
  $$PatientTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get anonymizationName => $composableBuilder(
    column: $table.anonymizationName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get passportOrIdNo => $composableBuilder(
    column: $table.passportOrIdNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SexTableAnnotationComposer get sexId {
    final $$SexTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sexId,
      referencedTable: $db.sex,
      getReferencedColumn: (t) => t.sexId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SexTableAnnotationComposer(
            $db: $db,
            $table: $db.sex,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NationalityTableAnnotationComposer get nationalityId {
    final $$NationalityTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationalityId,
      referencedTable: $db.nationality,
      getReferencedColumn: (t) => t.nationalityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationalityTableAnnotationComposer(
            $db: $db,
            $table: $db.nationality,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PatientTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientTable,
          PatientData,
          $$PatientTableFilterComposer,
          $$PatientTableOrderingComposer,
          $$PatientTableAnnotationComposer,
          $$PatientTableCreateCompanionBuilder,
          $$PatientTableUpdateCompanionBuilder,
          (PatientData, $$PatientTableReferences),
          PatientData,
          PrefetchHooks Function({
            bool medicalId,
            bool sexId,
            bool nationalityId,
          })
        > {
  $$PatientTableTableManager(_$AppDatabase db, $PatientTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> patientId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> anonymizationName = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<int?> sexId = const Value.absent(),
                Value<String?> passportOrIdNo = const Value.absent(),
                Value<int?> nationalityId = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PatientCompanion(
                patientId: patientId,
                medicalId: medicalId,
                name: name,
                anonymizationName: anonymizationName,
                birthday: birthday,
                age: age,
                sexId: sexId,
                passportOrIdNo: passportOrIdNo,
                nationalityId: nationalityId,
                telephone: telephone,
                address: address,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> patientId = const Value.absent(),
                required int medicalId,
                Value<String?> name = const Value.absent(),
                Value<String?> anonymizationName = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<int?> sexId = const Value.absent(),
                Value<String?> passportOrIdNo = const Value.absent(),
                Value<int?> nationalityId = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PatientCompanion.insert(
                patientId: patientId,
                medicalId: medicalId,
                name: name,
                anonymizationName: anonymizationName,
                birthday: birthday,
                age: age,
                sexId: sexId,
                passportOrIdNo: passportOrIdNo,
                nationalityId: nationalityId,
                telephone: telephone,
                address: address,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PatientTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({medicalId = false, sexId = false, nationalityId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medicalId,
                                    referencedTable: $$PatientTableReferences
                                        ._medicalIdTable(db),
                                    referencedColumn: $$PatientTableReferences
                                        ._medicalIdTable(db)
                                        .medicalId,
                                  )
                                  as T;
                        }
                        if (sexId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sexId,
                                    referencedTable: $$PatientTableReferences
                                        ._sexIdTable(db),
                                    referencedColumn: $$PatientTableReferences
                                        ._sexIdTable(db)
                                        .sexId,
                                  )
                                  as T;
                        }
                        if (nationalityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.nationalityId,
                                    referencedTable: $$PatientTableReferences
                                        ._nationalityIdTable(db),
                                    referencedColumn: $$PatientTableReferences
                                        ._nationalityIdTable(db)
                                        .nationalityId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PatientTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientTable,
      PatientData,
      $$PatientTableFilterComposer,
      $$PatientTableOrderingComposer,
      $$PatientTableAnnotationComposer,
      $$PatientTableCreateCompanionBuilder,
      $$PatientTableUpdateCompanionBuilder,
      (PatientData, $$PatientTableReferences),
      PatientData,
      PrefetchHooks Function({bool medicalId, bool sexId, bool nationalityId})
    >;
typedef $$FlightRecordTableCreateCompanionBuilder =
    FlightRecordCompanion Function({
      Value<int> flightRecordId,
      required int medicalId,
      required int airlineId,
      required String flightNumber,
      required int travelStatusId,
      required int departureLocationId,
      required int arrivalLocationId,
      Value<DateTime> createdAt,
    });
typedef $$FlightRecordTableUpdateCompanionBuilder =
    FlightRecordCompanion Function({
      Value<int> flightRecordId,
      Value<int> medicalId,
      Value<int> airlineId,
      Value<String> flightNumber,
      Value<int> travelStatusId,
      Value<int> departureLocationId,
      Value<int> arrivalLocationId,
      Value<DateTime> createdAt,
    });

final class $$FlightRecordTableReferences
    extends
        BaseReferences<_$AppDatabase, $FlightRecordTable, FlightRecordData> {
  $$FlightRecordTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.flightRecord.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AirlineTable _airlineIdTable(_$AppDatabase db) =>
      db.airline.createAlias(
        $_aliasNameGenerator(db.flightRecord.airlineId, db.airline.airlineId),
      );

  $$AirlineTableProcessedTableManager get airlineId {
    final $_column = $_itemColumn<int>('airline_id')!;

    final manager = $$AirlineTableTableManager(
      $_db,
      $_db.airline,
    ).filter((f) => f.airlineId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_airlineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TravelStatusTable _travelStatusIdTable(_$AppDatabase db) =>
      db.travelStatus.createAlias(
        $_aliasNameGenerator(
          db.flightRecord.travelStatusId,
          db.travelStatus.travelStatusId,
        ),
      );

  $$TravelStatusTableProcessedTableManager get travelStatusId {
    final $_column = $_itemColumn<int>('travel_status_id')!;

    final manager = $$TravelStatusTableTableManager(
      $_db,
      $_db.travelStatus,
    ).filter((f) => f.travelStatusId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_travelStatusIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationTable _departureLocationIdTable(_$AppDatabase db) =>
      db.location.createAlias(
        $_aliasNameGenerator(
          db.flightRecord.departureLocationId,
          db.location.locationId,
        ),
      );

  $$LocationTableProcessedTableManager get departureLocationId {
    final $_column = $_itemColumn<int>('departure_location_id')!;

    final manager = $$LocationTableTableManager(
      $_db,
      $_db.location,
    ).filter((f) => f.locationId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departureLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationTable _arrivalLocationIdTable(_$AppDatabase db) =>
      db.location.createAlias(
        $_aliasNameGenerator(
          db.flightRecord.arrivalLocationId,
          db.location.locationId,
        ),
      );

  $$LocationTableProcessedTableManager get arrivalLocationId {
    final $_column = $_itemColumn<int>('arrival_location_id')!;

    final manager = $$LocationTableTableManager(
      $_db,
      $_db.location,
    ).filter((f) => f.locationId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_arrivalLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $FlightTransitLocationsTable,
    List<FlightTransitLocationData>
  >
  _flightTransitLocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.flightTransitLocations,
        aliasName: $_aliasNameGenerator(
          db.flightRecord.flightRecordId,
          db.flightTransitLocations.flightRecordId,
        ),
      );

  $$FlightTransitLocationsTableProcessedTableManager
  get flightTransitLocationsRefs {
    final manager =
        $$FlightTransitLocationsTableTableManager(
          $_db,
          $_db.flightTransitLocations,
        ).filter(
          (f) => f.flightRecordId.flightRecordId.sqlEquals(
            $_itemColumn<int>('flight_record_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _flightTransitLocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlightRecordTableFilterComposer
    extends Composer<_$AppDatabase, $FlightRecordTable> {
  $$FlightRecordTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get flightRecordId => $composableBuilder(
    column: $table.flightRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AirlineTableFilterComposer get airlineId {
    final $$AirlineTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.airlineId,
      referencedTable: $db.airline,
      getReferencedColumn: (t) => t.airlineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AirlineTableFilterComposer(
            $db: $db,
            $table: $db.airline,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TravelStatusTableFilterComposer get travelStatusId {
    final $$TravelStatusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.travelStatusId,
      referencedTable: $db.travelStatus,
      getReferencedColumn: (t) => t.travelStatusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelStatusTableFilterComposer(
            $db: $db,
            $table: $db.travelStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableFilterComposer get departureLocationId {
    final $$LocationTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departureLocationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableFilterComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableFilterComposer get arrivalLocationId {
    final $$LocationTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.arrivalLocationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableFilterComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> flightTransitLocationsRefs(
    Expression<bool> Function($$FlightTransitLocationsTableFilterComposer f) f,
  ) {
    final $$FlightTransitLocationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.flightRecordId,
          referencedTable: $db.flightTransitLocations,
          getReferencedColumn: (t) => t.flightRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlightTransitLocationsTableFilterComposer(
                $db: $db,
                $table: $db.flightTransitLocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FlightRecordTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightRecordTable> {
  $$FlightRecordTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get flightRecordId => $composableBuilder(
    column: $table.flightRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AirlineTableOrderingComposer get airlineId {
    final $$AirlineTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.airlineId,
      referencedTable: $db.airline,
      getReferencedColumn: (t) => t.airlineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AirlineTableOrderingComposer(
            $db: $db,
            $table: $db.airline,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TravelStatusTableOrderingComposer get travelStatusId {
    final $$TravelStatusTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.travelStatusId,
      referencedTable: $db.travelStatus,
      getReferencedColumn: (t) => t.travelStatusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelStatusTableOrderingComposer(
            $db: $db,
            $table: $db.travelStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableOrderingComposer get departureLocationId {
    final $$LocationTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departureLocationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableOrderingComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableOrderingComposer get arrivalLocationId {
    final $$LocationTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.arrivalLocationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableOrderingComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightRecordTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightRecordTable> {
  $$FlightRecordTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get flightRecordId => $composableBuilder(
    column: $table.flightRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AirlineTableAnnotationComposer get airlineId {
    final $$AirlineTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.airlineId,
      referencedTable: $db.airline,
      getReferencedColumn: (t) => t.airlineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AirlineTableAnnotationComposer(
            $db: $db,
            $table: $db.airline,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TravelStatusTableAnnotationComposer get travelStatusId {
    final $$TravelStatusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.travelStatusId,
      referencedTable: $db.travelStatus,
      getReferencedColumn: (t) => t.travelStatusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelStatusTableAnnotationComposer(
            $db: $db,
            $table: $db.travelStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableAnnotationComposer get departureLocationId {
    final $$LocationTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departureLocationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableAnnotationComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableAnnotationComposer get arrivalLocationId {
    final $$LocationTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.arrivalLocationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableAnnotationComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> flightTransitLocationsRefs<T extends Object>(
    Expression<T> Function($$FlightTransitLocationsTableAnnotationComposer a) f,
  ) {
    final $$FlightTransitLocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.flightRecordId,
          referencedTable: $db.flightTransitLocations,
          getReferencedColumn: (t) => t.flightRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlightTransitLocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.flightTransitLocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FlightRecordTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightRecordTable,
          FlightRecordData,
          $$FlightRecordTableFilterComposer,
          $$FlightRecordTableOrderingComposer,
          $$FlightRecordTableAnnotationComposer,
          $$FlightRecordTableCreateCompanionBuilder,
          $$FlightRecordTableUpdateCompanionBuilder,
          (FlightRecordData, $$FlightRecordTableReferences),
          FlightRecordData,
          PrefetchHooks Function({
            bool medicalId,
            bool airlineId,
            bool travelStatusId,
            bool departureLocationId,
            bool arrivalLocationId,
            bool flightTransitLocationsRefs,
          })
        > {
  $$FlightRecordTableTableManager(_$AppDatabase db, $FlightRecordTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightRecordTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlightRecordTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlightRecordTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> flightRecordId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<int> airlineId = const Value.absent(),
                Value<String> flightNumber = const Value.absent(),
                Value<int> travelStatusId = const Value.absent(),
                Value<int> departureLocationId = const Value.absent(),
                Value<int> arrivalLocationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlightRecordCompanion(
                flightRecordId: flightRecordId,
                medicalId: medicalId,
                airlineId: airlineId,
                flightNumber: flightNumber,
                travelStatusId: travelStatusId,
                departureLocationId: departureLocationId,
                arrivalLocationId: arrivalLocationId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> flightRecordId = const Value.absent(),
                required int medicalId,
                required int airlineId,
                required String flightNumber,
                required int travelStatusId,
                required int departureLocationId,
                required int arrivalLocationId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlightRecordCompanion.insert(
                flightRecordId: flightRecordId,
                medicalId: medicalId,
                airlineId: airlineId,
                flightNumber: flightNumber,
                travelStatusId: travelStatusId,
                departureLocationId: departureLocationId,
                arrivalLocationId: arrivalLocationId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlightRecordTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                medicalId = false,
                airlineId = false,
                travelStatusId = false,
                departureLocationId = false,
                arrivalLocationId = false,
                flightTransitLocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (flightTransitLocationsRefs) db.flightTransitLocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medicalId,
                                    referencedTable:
                                        $$FlightRecordTableReferences
                                            ._medicalIdTable(db),
                                    referencedColumn:
                                        $$FlightRecordTableReferences
                                            ._medicalIdTable(db)
                                            .medicalId,
                                  )
                                  as T;
                        }
                        if (airlineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.airlineId,
                                    referencedTable:
                                        $$FlightRecordTableReferences
                                            ._airlineIdTable(db),
                                    referencedColumn:
                                        $$FlightRecordTableReferences
                                            ._airlineIdTable(db)
                                            .airlineId,
                                  )
                                  as T;
                        }
                        if (travelStatusId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.travelStatusId,
                                    referencedTable:
                                        $$FlightRecordTableReferences
                                            ._travelStatusIdTable(db),
                                    referencedColumn:
                                        $$FlightRecordTableReferences
                                            ._travelStatusIdTable(db)
                                            .travelStatusId,
                                  )
                                  as T;
                        }
                        if (departureLocationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.departureLocationId,
                                    referencedTable:
                                        $$FlightRecordTableReferences
                                            ._departureLocationIdTable(db),
                                    referencedColumn:
                                        $$FlightRecordTableReferences
                                            ._departureLocationIdTable(db)
                                            .locationId,
                                  )
                                  as T;
                        }
                        if (arrivalLocationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.arrivalLocationId,
                                    referencedTable:
                                        $$FlightRecordTableReferences
                                            ._arrivalLocationIdTable(db),
                                    referencedColumn:
                                        $$FlightRecordTableReferences
                                            ._arrivalLocationIdTable(db)
                                            .locationId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (flightTransitLocationsRefs)
                        await $_getPrefetchedData<
                          FlightRecordData,
                          $FlightRecordTable,
                          FlightTransitLocationData
                        >(
                          currentTable: table,
                          referencedTable: $$FlightRecordTableReferences
                              ._flightTransitLocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlightRecordTableReferences(
                                db,
                                table,
                                p0,
                              ).flightTransitLocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.flightRecordId == item.flightRecordId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FlightRecordTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightRecordTable,
      FlightRecordData,
      $$FlightRecordTableFilterComposer,
      $$FlightRecordTableOrderingComposer,
      $$FlightRecordTableAnnotationComposer,
      $$FlightRecordTableCreateCompanionBuilder,
      $$FlightRecordTableUpdateCompanionBuilder,
      (FlightRecordData, $$FlightRecordTableReferences),
      FlightRecordData,
      PrefetchHooks Function({
        bool medicalId,
        bool airlineId,
        bool travelStatusId,
        bool departureLocationId,
        bool arrivalLocationId,
        bool flightTransitLocationsRefs,
      })
    >;
typedef $$FlightTransitLocationsTableCreateCompanionBuilder =
    FlightTransitLocationsCompanion Function({
      Value<int> id,
      required int flightRecordId,
      required int locationId,
      Value<int> stopOrder,
    });
typedef $$FlightTransitLocationsTableUpdateCompanionBuilder =
    FlightTransitLocationsCompanion Function({
      Value<int> id,
      Value<int> flightRecordId,
      Value<int> locationId,
      Value<int> stopOrder,
    });

final class $$FlightTransitLocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FlightTransitLocationsTable,
          FlightTransitLocationData
        > {
  $$FlightTransitLocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FlightRecordTable _flightRecordIdTable(_$AppDatabase db) =>
      db.flightRecord.createAlias(
        $_aliasNameGenerator(
          db.flightTransitLocations.flightRecordId,
          db.flightRecord.flightRecordId,
        ),
      );

  $$FlightRecordTableProcessedTableManager get flightRecordId {
    final $_column = $_itemColumn<int>('flight_record_id')!;

    final manager = $$FlightRecordTableTableManager(
      $_db,
      $_db.flightRecord,
    ).filter((f) => f.flightRecordId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flightRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationTable _locationIdTable(_$AppDatabase db) =>
      db.location.createAlias(
        $_aliasNameGenerator(
          db.flightTransitLocations.locationId,
          db.location.locationId,
        ),
      );

  $$LocationTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<int>('location_id')!;

    final manager = $$LocationTableTableManager(
      $_db,
      $_db.location,
    ).filter((f) => f.locationId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlightTransitLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $FlightTransitLocationsTable> {
  $$FlightTransitLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stopOrder => $composableBuilder(
    column: $table.stopOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$FlightRecordTableFilterComposer get flightRecordId {
    final $$FlightRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightRecordId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.flightRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableFilterComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableFilterComposer get locationId {
    final $$LocationTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableFilterComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightTransitLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightTransitLocationsTable> {
  $$FlightTransitLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stopOrder => $composableBuilder(
    column: $table.stopOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlightRecordTableOrderingComposer get flightRecordId {
    final $$FlightRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightRecordId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.flightRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableOrderingComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableOrderingComposer get locationId {
    final $$LocationTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableOrderingComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightTransitLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightTransitLocationsTable> {
  $$FlightTransitLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stopOrder =>
      $composableBuilder(column: $table.stopOrder, builder: (column) => column);

  $$FlightRecordTableAnnotationComposer get flightRecordId {
    final $$FlightRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightRecordId,
      referencedTable: $db.flightRecord,
      getReferencedColumn: (t) => t.flightRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.flightRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationTableAnnotationComposer get locationId {
    final $$LocationTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.location,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationTableAnnotationComposer(
            $db: $db,
            $table: $db.location,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightTransitLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightTransitLocationsTable,
          FlightTransitLocationData,
          $$FlightTransitLocationsTableFilterComposer,
          $$FlightTransitLocationsTableOrderingComposer,
          $$FlightTransitLocationsTableAnnotationComposer,
          $$FlightTransitLocationsTableCreateCompanionBuilder,
          $$FlightTransitLocationsTableUpdateCompanionBuilder,
          (FlightTransitLocationData, $$FlightTransitLocationsTableReferences),
          FlightTransitLocationData,
          PrefetchHooks Function({bool flightRecordId, bool locationId})
        > {
  $$FlightTransitLocationsTableTableManager(
    _$AppDatabase db,
    $FlightTransitLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightTransitLocationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FlightTransitLocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FlightTransitLocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> flightRecordId = const Value.absent(),
                Value<int> locationId = const Value.absent(),
                Value<int> stopOrder = const Value.absent(),
              }) => FlightTransitLocationsCompanion(
                id: id,
                flightRecordId: flightRecordId,
                locationId: locationId,
                stopOrder: stopOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int flightRecordId,
                required int locationId,
                Value<int> stopOrder = const Value.absent(),
              }) => FlightTransitLocationsCompanion.insert(
                id: id,
                flightRecordId: flightRecordId,
                locationId: locationId,
                stopOrder: stopOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlightTransitLocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({flightRecordId = false, locationId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (flightRecordId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.flightRecordId,
                                    referencedTable:
                                        $$FlightTransitLocationsTableReferences
                                            ._flightRecordIdTable(db),
                                    referencedColumn:
                                        $$FlightTransitLocationsTableReferences
                                            ._flightRecordIdTable(db)
                                            .flightRecordId,
                                  )
                                  as T;
                        }
                        if (locationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.locationId,
                                    referencedTable:
                                        $$FlightTransitLocationsTableReferences
                                            ._locationIdTable(db),
                                    referencedColumn:
                                        $$FlightTransitLocationsTableReferences
                                            ._locationIdTable(db)
                                            .locationId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$FlightTransitLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightTransitLocationsTable,
      FlightTransitLocationData,
      $$FlightTransitLocationsTableFilterComposer,
      $$FlightTransitLocationsTableOrderingComposer,
      $$FlightTransitLocationsTableAnnotationComposer,
      $$FlightTransitLocationsTableCreateCompanionBuilder,
      $$FlightTransitLocationsTableUpdateCompanionBuilder,
      (FlightTransitLocationData, $$FlightTransitLocationsTableReferences),
      FlightTransitLocationData,
      PrefetchHooks Function({bool flightRecordId, bool locationId})
    >;
typedef $$IncidentRecordTableCreateCompanionBuilder =
    IncidentRecordCompanion Function({
      Value<int> incidentId,
      required int medicalId,
      required DateTime incidentDate,
      required int incidentPlaceCategoryId,
      Value<int?> incidentPlaceCategory2Id,
      Value<String?> incidentPlaceFinal,
      Value<DateTime?> notificationTime,
      Value<String?> notificationPerson,
      required int reportingUnitId,
      Value<String?> incomingPhone,
      Value<DateTime?> notificationToOccTime,
      Value<DateTime?> teamDepartureTime,
      Value<bool> occArrived,
      Value<bool> beforeLanding,
      Value<DateTime?> landingTime,
      Value<DateTime?> medicalArrivalTime,
      Value<DateTime?> examinationTime,
    });
typedef $$IncidentRecordTableUpdateCompanionBuilder =
    IncidentRecordCompanion Function({
      Value<int> incidentId,
      Value<int> medicalId,
      Value<DateTime> incidentDate,
      Value<int> incidentPlaceCategoryId,
      Value<int?> incidentPlaceCategory2Id,
      Value<String?> incidentPlaceFinal,
      Value<DateTime?> notificationTime,
      Value<String?> notificationPerson,
      Value<int> reportingUnitId,
      Value<String?> incomingPhone,
      Value<DateTime?> notificationToOccTime,
      Value<DateTime?> teamDepartureTime,
      Value<bool> occArrived,
      Value<bool> beforeLanding,
      Value<DateTime?> landingTime,
      Value<DateTime?> medicalArrivalTime,
      Value<DateTime?> examinationTime,
    });

final class $$IncidentRecordTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncidentRecordTable,
          IncidentRecordData
        > {
  $$IncidentRecordTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.incidentRecord.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncidentPlaceCategoryTable _incidentPlaceCategoryIdTable(
    _$AppDatabase db,
  ) => db.incidentPlaceCategory.createAlias(
    $_aliasNameGenerator(
      db.incidentRecord.incidentPlaceCategoryId,
      db.incidentPlaceCategory.id,
    ),
  );

  $$IncidentPlaceCategoryTableProcessedTableManager
  get incidentPlaceCategoryId {
    final $_column = $_itemColumn<int>('incident_place_category_id')!;

    final manager = $$IncidentPlaceCategoryTableTableManager(
      $_db,
      $_db.incidentPlaceCategory,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _incidentPlaceCategoryIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncidentPlaceCategory2Table _incidentPlaceCategory2IdTable(
    _$AppDatabase db,
  ) => db.incidentPlaceCategory2.createAlias(
    $_aliasNameGenerator(
      db.incidentRecord.incidentPlaceCategory2Id,
      db.incidentPlaceCategory2.id,
    ),
  );

  $$IncidentPlaceCategory2TableProcessedTableManager?
  get incidentPlaceCategory2Id {
    final $_column = $_itemColumn<int>('incident_place_category2_id');
    if ($_column == null) return null;
    final manager = $$IncidentPlaceCategory2TableTableManager(
      $_db,
      $_db.incidentPlaceCategory2,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _incidentPlaceCategory2IdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReportingUnitTable _reportingUnitIdTable(_$AppDatabase db) =>
      db.reportingUnit.createAlias(
        $_aliasNameGenerator(
          db.incidentRecord.reportingUnitId,
          db.reportingUnit.id,
        ),
      );

  $$ReportingUnitTableProcessedTableManager get reportingUnitId {
    final $_column = $_itemColumn<int>('reporting_unit_id')!;

    final manager = $$ReportingUnitTableTableManager(
      $_db,
      $_db.reportingUnit,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reportingUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IncidentRecordTableFilterComposer
    extends Composer<_$AppDatabase, $IncidentRecordTable> {
  $$IncidentRecordTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get incidentId => $composableBuilder(
    column: $table.incidentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incidentPlaceFinal => $composableBuilder(
    column: $table.incidentPlaceFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notificationTime => $composableBuilder(
    column: $table.notificationTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationPerson => $composableBuilder(
    column: $table.notificationPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incomingPhone => $composableBuilder(
    column: $table.incomingPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notificationToOccTime => $composableBuilder(
    column: $table.notificationToOccTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get teamDepartureTime => $composableBuilder(
    column: $table.teamDepartureTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get occArrived => $composableBuilder(
    column: $table.occArrived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get beforeLanding => $composableBuilder(
    column: $table.beforeLanding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get landingTime => $composableBuilder(
    column: $table.landingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get medicalArrivalTime => $composableBuilder(
    column: $table.medicalArrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get examinationTime => $composableBuilder(
    column: $table.examinationTime,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncidentPlaceCategoryTableFilterComposer get incidentPlaceCategoryId {
    final $$IncidentPlaceCategoryTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incidentPlaceCategoryId,
          referencedTable: $db.incidentPlaceCategory,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategoryTableFilterComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IncidentPlaceCategory2TableFilterComposer get incidentPlaceCategory2Id {
    final $$IncidentPlaceCategory2TableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incidentPlaceCategory2Id,
          referencedTable: $db.incidentPlaceCategory2,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategory2TableFilterComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory2,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReportingUnitTableFilterComposer get reportingUnitId {
    final $$ReportingUnitTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportingUnitId,
      referencedTable: $db.reportingUnit,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportingUnitTableFilterComposer(
            $db: $db,
            $table: $db.reportingUnit,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncidentRecordTableOrderingComposer
    extends Composer<_$AppDatabase, $IncidentRecordTable> {
  $$IncidentRecordTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get incidentId => $composableBuilder(
    column: $table.incidentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incidentPlaceFinal => $composableBuilder(
    column: $table.incidentPlaceFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notificationTime => $composableBuilder(
    column: $table.notificationTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationPerson => $composableBuilder(
    column: $table.notificationPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomingPhone => $composableBuilder(
    column: $table.incomingPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notificationToOccTime => $composableBuilder(
    column: $table.notificationToOccTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get teamDepartureTime => $composableBuilder(
    column: $table.teamDepartureTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get occArrived => $composableBuilder(
    column: $table.occArrived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get beforeLanding => $composableBuilder(
    column: $table.beforeLanding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get landingTime => $composableBuilder(
    column: $table.landingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get medicalArrivalTime => $composableBuilder(
    column: $table.medicalArrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get examinationTime => $composableBuilder(
    column: $table.examinationTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncidentPlaceCategoryTableOrderingComposer get incidentPlaceCategoryId {
    final $$IncidentPlaceCategoryTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incidentPlaceCategoryId,
          referencedTable: $db.incidentPlaceCategory,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategoryTableOrderingComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IncidentPlaceCategory2TableOrderingComposer get incidentPlaceCategory2Id {
    final $$IncidentPlaceCategory2TableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incidentPlaceCategory2Id,
          referencedTable: $db.incidentPlaceCategory2,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategory2TableOrderingComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory2,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReportingUnitTableOrderingComposer get reportingUnitId {
    final $$ReportingUnitTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportingUnitId,
      referencedTable: $db.reportingUnit,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportingUnitTableOrderingComposer(
            $db: $db,
            $table: $db.reportingUnit,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncidentRecordTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidentRecordTable> {
  $$IncidentRecordTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get incidentId => $composableBuilder(
    column: $table.incidentId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get incidentPlaceFinal => $composableBuilder(
    column: $table.incidentPlaceFinal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get notificationTime => $composableBuilder(
    column: $table.notificationTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationPerson => $composableBuilder(
    column: $table.notificationPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get incomingPhone => $composableBuilder(
    column: $table.incomingPhone,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get notificationToOccTime => $composableBuilder(
    column: $table.notificationToOccTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get teamDepartureTime => $composableBuilder(
    column: $table.teamDepartureTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get occArrived => $composableBuilder(
    column: $table.occArrived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get beforeLanding => $composableBuilder(
    column: $table.beforeLanding,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get landingTime => $composableBuilder(
    column: $table.landingTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get medicalArrivalTime => $composableBuilder(
    column: $table.medicalArrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get examinationTime => $composableBuilder(
    column: $table.examinationTime,
    builder: (column) => column,
  );

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncidentPlaceCategoryTableAnnotationComposer get incidentPlaceCategoryId {
    final $$IncidentPlaceCategoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incidentPlaceCategoryId,
          referencedTable: $db.incidentPlaceCategory,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategoryTableAnnotationComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IncidentPlaceCategory2TableAnnotationComposer get incidentPlaceCategory2Id {
    final $$IncidentPlaceCategory2TableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incidentPlaceCategory2Id,
          referencedTable: $db.incidentPlaceCategory2,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncidentPlaceCategory2TableAnnotationComposer(
                $db: $db,
                $table: $db.incidentPlaceCategory2,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReportingUnitTableAnnotationComposer get reportingUnitId {
    final $$ReportingUnitTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportingUnitId,
      referencedTable: $db.reportingUnit,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportingUnitTableAnnotationComposer(
            $db: $db,
            $table: $db.reportingUnit,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncidentRecordTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncidentRecordTable,
          IncidentRecordData,
          $$IncidentRecordTableFilterComposer,
          $$IncidentRecordTableOrderingComposer,
          $$IncidentRecordTableAnnotationComposer,
          $$IncidentRecordTableCreateCompanionBuilder,
          $$IncidentRecordTableUpdateCompanionBuilder,
          (IncidentRecordData, $$IncidentRecordTableReferences),
          IncidentRecordData,
          PrefetchHooks Function({
            bool medicalId,
            bool incidentPlaceCategoryId,
            bool incidentPlaceCategory2Id,
            bool reportingUnitId,
          })
        > {
  $$IncidentRecordTableTableManager(
    _$AppDatabase db,
    $IncidentRecordTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidentRecordTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncidentRecordTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncidentRecordTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> incidentId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<DateTime> incidentDate = const Value.absent(),
                Value<int> incidentPlaceCategoryId = const Value.absent(),
                Value<int?> incidentPlaceCategory2Id = const Value.absent(),
                Value<String?> incidentPlaceFinal = const Value.absent(),
                Value<DateTime?> notificationTime = const Value.absent(),
                Value<String?> notificationPerson = const Value.absent(),
                Value<int> reportingUnitId = const Value.absent(),
                Value<String?> incomingPhone = const Value.absent(),
                Value<DateTime?> notificationToOccTime = const Value.absent(),
                Value<DateTime?> teamDepartureTime = const Value.absent(),
                Value<bool> occArrived = const Value.absent(),
                Value<bool> beforeLanding = const Value.absent(),
                Value<DateTime?> landingTime = const Value.absent(),
                Value<DateTime?> medicalArrivalTime = const Value.absent(),
                Value<DateTime?> examinationTime = const Value.absent(),
              }) => IncidentRecordCompanion(
                incidentId: incidentId,
                medicalId: medicalId,
                incidentDate: incidentDate,
                incidentPlaceCategoryId: incidentPlaceCategoryId,
                incidentPlaceCategory2Id: incidentPlaceCategory2Id,
                incidentPlaceFinal: incidentPlaceFinal,
                notificationTime: notificationTime,
                notificationPerson: notificationPerson,
                reportingUnitId: reportingUnitId,
                incomingPhone: incomingPhone,
                notificationToOccTime: notificationToOccTime,
                teamDepartureTime: teamDepartureTime,
                occArrived: occArrived,
                beforeLanding: beforeLanding,
                landingTime: landingTime,
                medicalArrivalTime: medicalArrivalTime,
                examinationTime: examinationTime,
              ),
          createCompanionCallback:
              ({
                Value<int> incidentId = const Value.absent(),
                required int medicalId,
                required DateTime incidentDate,
                required int incidentPlaceCategoryId,
                Value<int?> incidentPlaceCategory2Id = const Value.absent(),
                Value<String?> incidentPlaceFinal = const Value.absent(),
                Value<DateTime?> notificationTime = const Value.absent(),
                Value<String?> notificationPerson = const Value.absent(),
                required int reportingUnitId,
                Value<String?> incomingPhone = const Value.absent(),
                Value<DateTime?> notificationToOccTime = const Value.absent(),
                Value<DateTime?> teamDepartureTime = const Value.absent(),
                Value<bool> occArrived = const Value.absent(),
                Value<bool> beforeLanding = const Value.absent(),
                Value<DateTime?> landingTime = const Value.absent(),
                Value<DateTime?> medicalArrivalTime = const Value.absent(),
                Value<DateTime?> examinationTime = const Value.absent(),
              }) => IncidentRecordCompanion.insert(
                incidentId: incidentId,
                medicalId: medicalId,
                incidentDate: incidentDate,
                incidentPlaceCategoryId: incidentPlaceCategoryId,
                incidentPlaceCategory2Id: incidentPlaceCategory2Id,
                incidentPlaceFinal: incidentPlaceFinal,
                notificationTime: notificationTime,
                notificationPerson: notificationPerson,
                reportingUnitId: reportingUnitId,
                incomingPhone: incomingPhone,
                notificationToOccTime: notificationToOccTime,
                teamDepartureTime: teamDepartureTime,
                occArrived: occArrived,
                beforeLanding: beforeLanding,
                landingTime: landingTime,
                medicalArrivalTime: medicalArrivalTime,
                examinationTime: examinationTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncidentRecordTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                medicalId = false,
                incidentPlaceCategoryId = false,
                incidentPlaceCategory2Id = false,
                reportingUnitId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medicalId,
                                    referencedTable:
                                        $$IncidentRecordTableReferences
                                            ._medicalIdTable(db),
                                    referencedColumn:
                                        $$IncidentRecordTableReferences
                                            ._medicalIdTable(db)
                                            .medicalId,
                                  )
                                  as T;
                        }
                        if (incidentPlaceCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn:
                                        table.incidentPlaceCategoryId,
                                    referencedTable:
                                        $$IncidentRecordTableReferences
                                            ._incidentPlaceCategoryIdTable(db),
                                    referencedColumn:
                                        $$IncidentRecordTableReferences
                                            ._incidentPlaceCategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (incidentPlaceCategory2Id) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn:
                                        table.incidentPlaceCategory2Id,
                                    referencedTable:
                                        $$IncidentRecordTableReferences
                                            ._incidentPlaceCategory2IdTable(db),
                                    referencedColumn:
                                        $$IncidentRecordTableReferences
                                            ._incidentPlaceCategory2IdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (reportingUnitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.reportingUnitId,
                                    referencedTable:
                                        $$IncidentRecordTableReferences
                                            ._reportingUnitIdTable(db),
                                    referencedColumn:
                                        $$IncidentRecordTableReferences
                                            ._reportingUnitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$IncidentRecordTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncidentRecordTable,
      IncidentRecordData,
      $$IncidentRecordTableFilterComposer,
      $$IncidentRecordTableOrderingComposer,
      $$IncidentRecordTableAnnotationComposer,
      $$IncidentRecordTableCreateCompanionBuilder,
      $$IncidentRecordTableUpdateCompanionBuilder,
      (IncidentRecordData, $$IncidentRecordTableReferences),
      IncidentRecordData,
      PrefetchHooks Function({
        bool medicalId,
        bool incidentPlaceCategoryId,
        bool incidentPlaceCategory2Id,
        bool reportingUnitId,
      })
    >;
typedef $$ChiefComplaintTableCreateCompanionBuilder =
    ChiefComplaintCompanion Function({
      Value<int> complaintId,
      required int medicalId,
      Value<int?> chiefComplaintTypeId,
      Value<String?> selectedSymptoms,
      Value<String?> otherSymptomDetail,
      Value<String?> chiefComplaintFinal,
      Value<String?> supplementaryNotes,
      Value<DateTime?> onsetTime,
      Value<String?> reportedBy,
      Value<bool> isConfirmed,
      Value<DateTime> createdAt,
    });
typedef $$ChiefComplaintTableUpdateCompanionBuilder =
    ChiefComplaintCompanion Function({
      Value<int> complaintId,
      Value<int> medicalId,
      Value<int?> chiefComplaintTypeId,
      Value<String?> selectedSymptoms,
      Value<String?> otherSymptomDetail,
      Value<String?> chiefComplaintFinal,
      Value<String?> supplementaryNotes,
      Value<DateTime?> onsetTime,
      Value<String?> reportedBy,
      Value<bool> isConfirmed,
      Value<DateTime> createdAt,
    });

final class $$ChiefComplaintTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChiefComplaintTable,
          ChiefComplaintData
        > {
  $$ChiefComplaintTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.chiefComplaint.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChiefComplaintTableFilterComposer
    extends Composer<_$AppDatabase, $ChiefComplaintTable> {
  $$ChiefComplaintTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get complaintId => $composableBuilder(
    column: $table.complaintId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chiefComplaintTypeId => $composableBuilder(
    column: $table.chiefComplaintTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedSymptoms => $composableBuilder(
    column: $table.selectedSymptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherSymptomDetail => $composableBuilder(
    column: $table.otherSymptomDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chiefComplaintFinal => $composableBuilder(
    column: $table.chiefComplaintFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplementaryNotes => $composableBuilder(
    column: $table.supplementaryNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get onsetTime => $composableBuilder(
    column: $table.onsetTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportedBy => $composableBuilder(
    column: $table.reportedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChiefComplaintTableOrderingComposer
    extends Composer<_$AppDatabase, $ChiefComplaintTable> {
  $$ChiefComplaintTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get complaintId => $composableBuilder(
    column: $table.complaintId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chiefComplaintTypeId => $composableBuilder(
    column: $table.chiefComplaintTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedSymptoms => $composableBuilder(
    column: $table.selectedSymptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherSymptomDetail => $composableBuilder(
    column: $table.otherSymptomDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chiefComplaintFinal => $composableBuilder(
    column: $table.chiefComplaintFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplementaryNotes => $composableBuilder(
    column: $table.supplementaryNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get onsetTime => $composableBuilder(
    column: $table.onsetTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportedBy => $composableBuilder(
    column: $table.reportedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChiefComplaintTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChiefComplaintTable> {
  $$ChiefComplaintTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get complaintId => $composableBuilder(
    column: $table.complaintId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chiefComplaintTypeId => $composableBuilder(
    column: $table.chiefComplaintTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedSymptoms => $composableBuilder(
    column: $table.selectedSymptoms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherSymptomDetail => $composableBuilder(
    column: $table.otherSymptomDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chiefComplaintFinal => $composableBuilder(
    column: $table.chiefComplaintFinal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplementaryNotes => $composableBuilder(
    column: $table.supplementaryNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get onsetTime =>
      $composableBuilder(column: $table.onsetTime, builder: (column) => column);

  GeneratedColumn<String> get reportedBy => $composableBuilder(
    column: $table.reportedBy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChiefComplaintTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChiefComplaintTable,
          ChiefComplaintData,
          $$ChiefComplaintTableFilterComposer,
          $$ChiefComplaintTableOrderingComposer,
          $$ChiefComplaintTableAnnotationComposer,
          $$ChiefComplaintTableCreateCompanionBuilder,
          $$ChiefComplaintTableUpdateCompanionBuilder,
          (ChiefComplaintData, $$ChiefComplaintTableReferences),
          ChiefComplaintData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$ChiefComplaintTableTableManager(
    _$AppDatabase db,
    $ChiefComplaintTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChiefComplaintTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChiefComplaintTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChiefComplaintTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> complaintId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<int?> chiefComplaintTypeId = const Value.absent(),
                Value<String?> selectedSymptoms = const Value.absent(),
                Value<String?> otherSymptomDetail = const Value.absent(),
                Value<String?> chiefComplaintFinal = const Value.absent(),
                Value<String?> supplementaryNotes = const Value.absent(),
                Value<DateTime?> onsetTime = const Value.absent(),
                Value<String?> reportedBy = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ChiefComplaintCompanion(
                complaintId: complaintId,
                medicalId: medicalId,
                chiefComplaintTypeId: chiefComplaintTypeId,
                selectedSymptoms: selectedSymptoms,
                otherSymptomDetail: otherSymptomDetail,
                chiefComplaintFinal: chiefComplaintFinal,
                supplementaryNotes: supplementaryNotes,
                onsetTime: onsetTime,
                reportedBy: reportedBy,
                isConfirmed: isConfirmed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> complaintId = const Value.absent(),
                required int medicalId,
                Value<int?> chiefComplaintTypeId = const Value.absent(),
                Value<String?> selectedSymptoms = const Value.absent(),
                Value<String?> otherSymptomDetail = const Value.absent(),
                Value<String?> chiefComplaintFinal = const Value.absent(),
                Value<String?> supplementaryNotes = const Value.absent(),
                Value<DateTime?> onsetTime = const Value.absent(),
                Value<String?> reportedBy = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ChiefComplaintCompanion.insert(
                complaintId: complaintId,
                medicalId: medicalId,
                chiefComplaintTypeId: chiefComplaintTypeId,
                selectedSymptoms: selectedSymptoms,
                otherSymptomDetail: otherSymptomDetail,
                chiefComplaintFinal: chiefComplaintFinal,
                supplementaryNotes: supplementaryNotes,
                onsetTime: onsetTime,
                reportedBy: reportedBy,
                isConfirmed: isConfirmed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChiefComplaintTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable: $$ChiefComplaintTableReferences
                                    ._medicalIdTable(db),
                                referencedColumn:
                                    $$ChiefComplaintTableReferences
                                        ._medicalIdTable(db)
                                        .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChiefComplaintTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChiefComplaintTable,
      ChiefComplaintData,
      $$ChiefComplaintTableFilterComposer,
      $$ChiefComplaintTableOrderingComposer,
      $$ChiefComplaintTableAnnotationComposer,
      $$ChiefComplaintTableCreateCompanionBuilder,
      $$ChiefComplaintTableUpdateCompanionBuilder,
      (ChiefComplaintData, $$ChiefComplaintTableReferences),
      ChiefComplaintData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$HealthAssessmentFormTableCreateCompanionBuilder =
    HealthAssessmentFormCompanion Function({
      Value<int> assessmentFormId,
      required int medicalId,
      required String name,
      required String relation,
      required double temperature,
      Value<DateTime> createdAt,
    });
typedef $$HealthAssessmentFormTableUpdateCompanionBuilder =
    HealthAssessmentFormCompanion Function({
      Value<int> assessmentFormId,
      Value<int> medicalId,
      Value<String> name,
      Value<String> relation,
      Value<double> temperature,
      Value<DateTime> createdAt,
    });

final class $$HealthAssessmentFormTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HealthAssessmentFormTable,
          HealthAssessmentFormData
        > {
  $$HealthAssessmentFormTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.healthAssessmentForm.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HealthAssessmentFormTableFilterComposer
    extends Composer<_$AppDatabase, $HealthAssessmentFormTable> {
  $$HealthAssessmentFormTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get assessmentFormId => $composableBuilder(
    column: $table.assessmentFormId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthAssessmentFormTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthAssessmentFormTable> {
  $$HealthAssessmentFormTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get assessmentFormId => $composableBuilder(
    column: $table.assessmentFormId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthAssessmentFormTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthAssessmentFormTable> {
  $$HealthAssessmentFormTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get assessmentFormId => $composableBuilder(
    column: $table.assessmentFormId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthAssessmentFormTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthAssessmentFormTable,
          HealthAssessmentFormData,
          $$HealthAssessmentFormTableFilterComposer,
          $$HealthAssessmentFormTableOrderingComposer,
          $$HealthAssessmentFormTableAnnotationComposer,
          $$HealthAssessmentFormTableCreateCompanionBuilder,
          $$HealthAssessmentFormTableUpdateCompanionBuilder,
          (HealthAssessmentFormData, $$HealthAssessmentFormTableReferences),
          HealthAssessmentFormData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$HealthAssessmentFormTableTableManager(
    _$AppDatabase db,
    $HealthAssessmentFormTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthAssessmentFormTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthAssessmentFormTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HealthAssessmentFormTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> assessmentFormId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> relation = const Value.absent(),
                Value<double> temperature = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HealthAssessmentFormCompanion(
                assessmentFormId: assessmentFormId,
                medicalId: medicalId,
                name: name,
                relation: relation,
                temperature: temperature,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> assessmentFormId = const Value.absent(),
                required int medicalId,
                required String name,
                required String relation,
                required double temperature,
                Value<DateTime> createdAt = const Value.absent(),
              }) => HealthAssessmentFormCompanion.insert(
                assessmentFormId: assessmentFormId,
                medicalId: medicalId,
                name: name,
                relation: relation,
                temperature: temperature,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HealthAssessmentFormTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable:
                                    $$HealthAssessmentFormTableReferences
                                        ._medicalIdTable(db),
                                referencedColumn:
                                    $$HealthAssessmentFormTableReferences
                                        ._medicalIdTable(db)
                                        .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HealthAssessmentFormTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthAssessmentFormTable,
      HealthAssessmentFormData,
      $$HealthAssessmentFormTableFilterComposer,
      $$HealthAssessmentFormTableOrderingComposer,
      $$HealthAssessmentFormTableAnnotationComposer,
      $$HealthAssessmentFormTableCreateCompanionBuilder,
      $$HealthAssessmentFormTableUpdateCompanionBuilder,
      (HealthAssessmentFormData, $$HealthAssessmentFormTableReferences),
      HealthAssessmentFormData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$MedicalMediaTableCreateCompanionBuilder =
    MedicalMediaCompanion Function({
      Value<int> mediaId,
      required int medicalId,
      required String mediaType,
      required String base64Data,
      Value<String?> description,
      Value<DateTime> createdAt,
    });
typedef $$MedicalMediaTableUpdateCompanionBuilder =
    MedicalMediaCompanion Function({
      Value<int> mediaId,
      Value<int> medicalId,
      Value<String> mediaType,
      Value<String> base64Data,
      Value<String?> description,
      Value<DateTime> createdAt,
    });

final class $$MedicalMediaTableReferences
    extends
        BaseReferences<_$AppDatabase, $MedicalMediaTable, MedicalMediaData> {
  $$MedicalMediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.medicalMedia.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicalMediaTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalMediaTable> {
  $$MedicalMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get base64Data => $composableBuilder(
    column: $table.base64Data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalMediaTable> {
  $$MedicalMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get base64Data => $composableBuilder(
    column: $table.base64Data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalMediaTable> {
  $$MedicalMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get base64Data => $composableBuilder(
    column: $table.base64Data,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalMediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalMediaTable,
          MedicalMediaData,
          $$MedicalMediaTableFilterComposer,
          $$MedicalMediaTableOrderingComposer,
          $$MedicalMediaTableAnnotationComposer,
          $$MedicalMediaTableCreateCompanionBuilder,
          $$MedicalMediaTableUpdateCompanionBuilder,
          (MedicalMediaData, $$MedicalMediaTableReferences),
          MedicalMediaData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$MedicalMediaTableTableManager(_$AppDatabase db, $MedicalMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> base64Data = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MedicalMediaCompanion(
                mediaId: mediaId,
                medicalId: medicalId,
                mediaType: mediaType,
                base64Data: base64Data,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> mediaId = const Value.absent(),
                required int medicalId,
                required String mediaType,
                required String base64Data,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MedicalMediaCompanion.insert(
                mediaId: mediaId,
                medicalId: medicalId,
                mediaType: mediaType,
                base64Data: base64Data,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicalMediaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable: $$MedicalMediaTableReferences
                                    ._medicalIdTable(db),
                                referencedColumn: $$MedicalMediaTableReferences
                                    ._medicalIdTable(db)
                                    .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicalMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalMediaTable,
      MedicalMediaData,
      $$MedicalMediaTableFilterComposer,
      $$MedicalMediaTableOrderingComposer,
      $$MedicalMediaTableAnnotationComposer,
      $$MedicalMediaTableCreateCompanionBuilder,
      $$MedicalMediaTableUpdateCompanionBuilder,
      (MedicalMediaData, $$MedicalMediaTableReferences),
      MedicalMediaData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$MedicalAssessmentTableCreateCompanionBuilder =
    MedicalAssessmentCompanion Function({
      Value<int> assessmentId,
      required int medicalId,
      Value<double?> temperature,
      Value<int?> pulse,
      Value<int?> breath,
      Value<int?> systolic,
      Value<int?> diastolic,
      Value<int?> spo2,
      Value<int?> painScore,
      Value<String?> consciousnessLevel,
      Value<int?> gcs,
      Value<String?> gcsE,
      Value<String?> gcsM,
      Value<String?> gcsV,
      Value<String?> leftPupilReaction,
      Value<double?> leftPupilSize,
      Value<String?> rightPupilReaction,
      Value<double?> rightPupilSize,
      Value<String?> headNeckExam,
      Value<String?> chestExam,
      Value<String?> abdomenExam,
      Value<String?> extremitiesExam,
      Value<String?> otherPhysicalExam,
      Value<int?> triageId,
      Value<DateTime> assessmentTime,
    });
typedef $$MedicalAssessmentTableUpdateCompanionBuilder =
    MedicalAssessmentCompanion Function({
      Value<int> assessmentId,
      Value<int> medicalId,
      Value<double?> temperature,
      Value<int?> pulse,
      Value<int?> breath,
      Value<int?> systolic,
      Value<int?> diastolic,
      Value<int?> spo2,
      Value<int?> painScore,
      Value<String?> consciousnessLevel,
      Value<int?> gcs,
      Value<String?> gcsE,
      Value<String?> gcsM,
      Value<String?> gcsV,
      Value<String?> leftPupilReaction,
      Value<double?> leftPupilSize,
      Value<String?> rightPupilReaction,
      Value<double?> rightPupilSize,
      Value<String?> headNeckExam,
      Value<String?> chestExam,
      Value<String?> abdomenExam,
      Value<String?> extremitiesExam,
      Value<String?> otherPhysicalExam,
      Value<int?> triageId,
      Value<DateTime> assessmentTime,
    });

final class $$MedicalAssessmentTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicalAssessmentTable,
          MedicalAssessmentData
        > {
  $$MedicalAssessmentTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.medicalAssessment.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicalAssessmentTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalAssessmentTable> {
  $$MedicalAssessmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get assessmentId => $composableBuilder(
    column: $table.assessmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breath => $composableBuilder(
    column: $table.breath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get painScore => $composableBuilder(
    column: $table.painScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consciousnessLevel => $composableBuilder(
    column: $table.consciousnessLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gcs => $composableBuilder(
    column: $table.gcs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gcsE => $composableBuilder(
    column: $table.gcsE,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gcsM => $composableBuilder(
    column: $table.gcsM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gcsV => $composableBuilder(
    column: $table.gcsV,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leftPupilReaction => $composableBuilder(
    column: $table.leftPupilReaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftPupilSize => $composableBuilder(
    column: $table.leftPupilSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rightPupilReaction => $composableBuilder(
    column: $table.rightPupilReaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightPupilSize => $composableBuilder(
    column: $table.rightPupilSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headNeckExam => $composableBuilder(
    column: $table.headNeckExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chestExam => $composableBuilder(
    column: $table.chestExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abdomenExam => $composableBuilder(
    column: $table.abdomenExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extremitiesExam => $composableBuilder(
    column: $table.extremitiesExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherPhysicalExam => $composableBuilder(
    column: $table.otherPhysicalExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triageId => $composableBuilder(
    column: $table.triageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assessmentTime => $composableBuilder(
    column: $table.assessmentTime,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalAssessmentTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalAssessmentTable> {
  $$MedicalAssessmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get assessmentId => $composableBuilder(
    column: $table.assessmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breath => $composableBuilder(
    column: $table.breath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get painScore => $composableBuilder(
    column: $table.painScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consciousnessLevel => $composableBuilder(
    column: $table.consciousnessLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gcs => $composableBuilder(
    column: $table.gcs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gcsE => $composableBuilder(
    column: $table.gcsE,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gcsM => $composableBuilder(
    column: $table.gcsM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gcsV => $composableBuilder(
    column: $table.gcsV,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leftPupilReaction => $composableBuilder(
    column: $table.leftPupilReaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftPupilSize => $composableBuilder(
    column: $table.leftPupilSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rightPupilReaction => $composableBuilder(
    column: $table.rightPupilReaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightPupilSize => $composableBuilder(
    column: $table.rightPupilSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headNeckExam => $composableBuilder(
    column: $table.headNeckExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chestExam => $composableBuilder(
    column: $table.chestExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abdomenExam => $composableBuilder(
    column: $table.abdomenExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extremitiesExam => $composableBuilder(
    column: $table.extremitiesExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherPhysicalExam => $composableBuilder(
    column: $table.otherPhysicalExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triageId => $composableBuilder(
    column: $table.triageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assessmentTime => $composableBuilder(
    column: $table.assessmentTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalAssessmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalAssessmentTable> {
  $$MedicalAssessmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get assessmentId => $composableBuilder(
    column: $table.assessmentId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pulse =>
      $composableBuilder(column: $table.pulse, builder: (column) => column);

  GeneratedColumn<int> get breath =>
      $composableBuilder(column: $table.breath, builder: (column) => column);

  GeneratedColumn<int> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<int> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<int> get spo2 =>
      $composableBuilder(column: $table.spo2, builder: (column) => column);

  GeneratedColumn<int> get painScore =>
      $composableBuilder(column: $table.painScore, builder: (column) => column);

  GeneratedColumn<String> get consciousnessLevel => $composableBuilder(
    column: $table.consciousnessLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gcs =>
      $composableBuilder(column: $table.gcs, builder: (column) => column);

  GeneratedColumn<String> get gcsE =>
      $composableBuilder(column: $table.gcsE, builder: (column) => column);

  GeneratedColumn<String> get gcsM =>
      $composableBuilder(column: $table.gcsM, builder: (column) => column);

  GeneratedColumn<String> get gcsV =>
      $composableBuilder(column: $table.gcsV, builder: (column) => column);

  GeneratedColumn<String> get leftPupilReaction => $composableBuilder(
    column: $table.leftPupilReaction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leftPupilSize => $composableBuilder(
    column: $table.leftPupilSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rightPupilReaction => $composableBuilder(
    column: $table.rightPupilReaction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rightPupilSize => $composableBuilder(
    column: $table.rightPupilSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get headNeckExam => $composableBuilder(
    column: $table.headNeckExam,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chestExam =>
      $composableBuilder(column: $table.chestExam, builder: (column) => column);

  GeneratedColumn<String> get abdomenExam => $composableBuilder(
    column: $table.abdomenExam,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extremitiesExam => $composableBuilder(
    column: $table.extremitiesExam,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherPhysicalExam => $composableBuilder(
    column: $table.otherPhysicalExam,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triageId =>
      $composableBuilder(column: $table.triageId, builder: (column) => column);

  GeneratedColumn<DateTime> get assessmentTime => $composableBuilder(
    column: $table.assessmentTime,
    builder: (column) => column,
  );

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalAssessmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalAssessmentTable,
          MedicalAssessmentData,
          $$MedicalAssessmentTableFilterComposer,
          $$MedicalAssessmentTableOrderingComposer,
          $$MedicalAssessmentTableAnnotationComposer,
          $$MedicalAssessmentTableCreateCompanionBuilder,
          $$MedicalAssessmentTableUpdateCompanionBuilder,
          (MedicalAssessmentData, $$MedicalAssessmentTableReferences),
          MedicalAssessmentData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$MedicalAssessmentTableTableManager(
    _$AppDatabase db,
    $MedicalAssessmentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalAssessmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalAssessmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalAssessmentTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> assessmentId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<int?> pulse = const Value.absent(),
                Value<int?> breath = const Value.absent(),
                Value<int?> systolic = const Value.absent(),
                Value<int?> diastolic = const Value.absent(),
                Value<int?> spo2 = const Value.absent(),
                Value<int?> painScore = const Value.absent(),
                Value<String?> consciousnessLevel = const Value.absent(),
                Value<int?> gcs = const Value.absent(),
                Value<String?> gcsE = const Value.absent(),
                Value<String?> gcsM = const Value.absent(),
                Value<String?> gcsV = const Value.absent(),
                Value<String?> leftPupilReaction = const Value.absent(),
                Value<double?> leftPupilSize = const Value.absent(),
                Value<String?> rightPupilReaction = const Value.absent(),
                Value<double?> rightPupilSize = const Value.absent(),
                Value<String?> headNeckExam = const Value.absent(),
                Value<String?> chestExam = const Value.absent(),
                Value<String?> abdomenExam = const Value.absent(),
                Value<String?> extremitiesExam = const Value.absent(),
                Value<String?> otherPhysicalExam = const Value.absent(),
                Value<int?> triageId = const Value.absent(),
                Value<DateTime> assessmentTime = const Value.absent(),
              }) => MedicalAssessmentCompanion(
                assessmentId: assessmentId,
                medicalId: medicalId,
                temperature: temperature,
                pulse: pulse,
                breath: breath,
                systolic: systolic,
                diastolic: diastolic,
                spo2: spo2,
                painScore: painScore,
                consciousnessLevel: consciousnessLevel,
                gcs: gcs,
                gcsE: gcsE,
                gcsM: gcsM,
                gcsV: gcsV,
                leftPupilReaction: leftPupilReaction,
                leftPupilSize: leftPupilSize,
                rightPupilReaction: rightPupilReaction,
                rightPupilSize: rightPupilSize,
                headNeckExam: headNeckExam,
                chestExam: chestExam,
                abdomenExam: abdomenExam,
                extremitiesExam: extremitiesExam,
                otherPhysicalExam: otherPhysicalExam,
                triageId: triageId,
                assessmentTime: assessmentTime,
              ),
          createCompanionCallback:
              ({
                Value<int> assessmentId = const Value.absent(),
                required int medicalId,
                Value<double?> temperature = const Value.absent(),
                Value<int?> pulse = const Value.absent(),
                Value<int?> breath = const Value.absent(),
                Value<int?> systolic = const Value.absent(),
                Value<int?> diastolic = const Value.absent(),
                Value<int?> spo2 = const Value.absent(),
                Value<int?> painScore = const Value.absent(),
                Value<String?> consciousnessLevel = const Value.absent(),
                Value<int?> gcs = const Value.absent(),
                Value<String?> gcsE = const Value.absent(),
                Value<String?> gcsM = const Value.absent(),
                Value<String?> gcsV = const Value.absent(),
                Value<String?> leftPupilReaction = const Value.absent(),
                Value<double?> leftPupilSize = const Value.absent(),
                Value<String?> rightPupilReaction = const Value.absent(),
                Value<double?> rightPupilSize = const Value.absent(),
                Value<String?> headNeckExam = const Value.absent(),
                Value<String?> chestExam = const Value.absent(),
                Value<String?> abdomenExam = const Value.absent(),
                Value<String?> extremitiesExam = const Value.absent(),
                Value<String?> otherPhysicalExam = const Value.absent(),
                Value<int?> triageId = const Value.absent(),
                Value<DateTime> assessmentTime = const Value.absent(),
              }) => MedicalAssessmentCompanion.insert(
                assessmentId: assessmentId,
                medicalId: medicalId,
                temperature: temperature,
                pulse: pulse,
                breath: breath,
                systolic: systolic,
                diastolic: diastolic,
                spo2: spo2,
                painScore: painScore,
                consciousnessLevel: consciousnessLevel,
                gcs: gcs,
                gcsE: gcsE,
                gcsM: gcsM,
                gcsV: gcsV,
                leftPupilReaction: leftPupilReaction,
                leftPupilSize: leftPupilSize,
                rightPupilReaction: rightPupilReaction,
                rightPupilSize: rightPupilSize,
                headNeckExam: headNeckExam,
                chestExam: chestExam,
                abdomenExam: abdomenExam,
                extremitiesExam: extremitiesExam,
                otherPhysicalExam: otherPhysicalExam,
                triageId: triageId,
                assessmentTime: assessmentTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicalAssessmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable:
                                    $$MedicalAssessmentTableReferences
                                        ._medicalIdTable(db),
                                referencedColumn:
                                    $$MedicalAssessmentTableReferences
                                        ._medicalIdTable(db)
                                        .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicalAssessmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalAssessmentTable,
      MedicalAssessmentData,
      $$MedicalAssessmentTableFilterComposer,
      $$MedicalAssessmentTableOrderingComposer,
      $$MedicalAssessmentTableAnnotationComposer,
      $$MedicalAssessmentTableCreateCompanionBuilder,
      $$MedicalAssessmentTableUpdateCompanionBuilder,
      (MedicalAssessmentData, $$MedicalAssessmentTableReferences),
      MedicalAssessmentData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$MedicalHistoryTableCreateCompanionBuilder =
    MedicalHistoryCompanion Function({
      Value<int> historyId,
      required int medicalId,
      required String pastHistoryStatus,
      Value<String?> pastHistoryDetail,
      required String allergyStatus,
      Value<String?> allergyDetail,
      Value<DateTime> createdAt,
    });
typedef $$MedicalHistoryTableUpdateCompanionBuilder =
    MedicalHistoryCompanion Function({
      Value<int> historyId,
      Value<int> medicalId,
      Value<String> pastHistoryStatus,
      Value<String?> pastHistoryDetail,
      Value<String> allergyStatus,
      Value<String?> allergyDetail,
      Value<DateTime> createdAt,
    });

final class $$MedicalHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicalHistoryTable,
          MedicalHistoryData
        > {
  $$MedicalHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.medicalHistory.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicalHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalHistoryTable> {
  $$MedicalHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get historyId => $composableBuilder(
    column: $table.historyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pastHistoryStatus => $composableBuilder(
    column: $table.pastHistoryStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pastHistoryDetail => $composableBuilder(
    column: $table.pastHistoryDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergyStatus => $composableBuilder(
    column: $table.allergyStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergyDetail => $composableBuilder(
    column: $table.allergyDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalHistoryTable> {
  $$MedicalHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get historyId => $composableBuilder(
    column: $table.historyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pastHistoryStatus => $composableBuilder(
    column: $table.pastHistoryStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pastHistoryDetail => $composableBuilder(
    column: $table.pastHistoryDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergyStatus => $composableBuilder(
    column: $table.allergyStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergyDetail => $composableBuilder(
    column: $table.allergyDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalHistoryTable> {
  $$MedicalHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get historyId =>
      $composableBuilder(column: $table.historyId, builder: (column) => column);

  GeneratedColumn<String> get pastHistoryStatus => $composableBuilder(
    column: $table.pastHistoryStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pastHistoryDetail => $composableBuilder(
    column: $table.pastHistoryDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergyStatus => $composableBuilder(
    column: $table.allergyStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergyDetail => $composableBuilder(
    column: $table.allergyDetail,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalHistoryTable,
          MedicalHistoryData,
          $$MedicalHistoryTableFilterComposer,
          $$MedicalHistoryTableOrderingComposer,
          $$MedicalHistoryTableAnnotationComposer,
          $$MedicalHistoryTableCreateCompanionBuilder,
          $$MedicalHistoryTableUpdateCompanionBuilder,
          (MedicalHistoryData, $$MedicalHistoryTableReferences),
          MedicalHistoryData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$MedicalHistoryTableTableManager(
    _$AppDatabase db,
    $MedicalHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> historyId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<String> pastHistoryStatus = const Value.absent(),
                Value<String?> pastHistoryDetail = const Value.absent(),
                Value<String> allergyStatus = const Value.absent(),
                Value<String?> allergyDetail = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MedicalHistoryCompanion(
                historyId: historyId,
                medicalId: medicalId,
                pastHistoryStatus: pastHistoryStatus,
                pastHistoryDetail: pastHistoryDetail,
                allergyStatus: allergyStatus,
                allergyDetail: allergyDetail,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> historyId = const Value.absent(),
                required int medicalId,
                required String pastHistoryStatus,
                Value<String?> pastHistoryDetail = const Value.absent(),
                required String allergyStatus,
                Value<String?> allergyDetail = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MedicalHistoryCompanion.insert(
                historyId: historyId,
                medicalId: medicalId,
                pastHistoryStatus: pastHistoryStatus,
                pastHistoryDetail: pastHistoryDetail,
                allergyStatus: allergyStatus,
                allergyDetail: allergyDetail,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicalHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable: $$MedicalHistoryTableReferences
                                    ._medicalIdTable(db),
                                referencedColumn:
                                    $$MedicalHistoryTableReferences
                                        ._medicalIdTable(db)
                                        .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicalHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalHistoryTable,
      MedicalHistoryData,
      $$MedicalHistoryTableFilterComposer,
      $$MedicalHistoryTableOrderingComposer,
      $$MedicalHistoryTableAnnotationComposer,
      $$MedicalHistoryTableCreateCompanionBuilder,
      $$MedicalHistoryTableUpdateCompanionBuilder,
      (MedicalHistoryData, $$MedicalHistoryTableReferences),
      MedicalHistoryData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$TreatmentTableCreateCompanionBuilder =
    TreatmentCompanion Function({
      Value<int> treatmentId,
      required int medicalId,
      Value<int?> tentativeCategoryId,
      Value<String?> tentative,
      Value<String?> secondaryDiagnosis1,
      Value<String?> secondaryDiagnosis2,
      Value<int?> triageId,
      Value<int?> treatmentOnSiteId,
      Value<String?> actionSummary,
      Value<String?> actionSummaryOther,
      Value<int?> resultId,
      Value<bool?> transportRequired,
      Value<String?> transportMethod,
      Value<int?> referralHospitalId,
      Value<String?> referralHospitalFinal,
      Value<DateTime?> arrivalTime,
      Value<int?> clearanceId,
      Value<int?> expeditedClearanceId,
      Value<String?> doctorOrderCh,
      Value<String?> doctorOrderEn,
      Value<String?> directorName,
      Value<String?> assistStaff,
      Value<DateTime> treatmentTime,
    });
typedef $$TreatmentTableUpdateCompanionBuilder =
    TreatmentCompanion Function({
      Value<int> treatmentId,
      Value<int> medicalId,
      Value<int?> tentativeCategoryId,
      Value<String?> tentative,
      Value<String?> secondaryDiagnosis1,
      Value<String?> secondaryDiagnosis2,
      Value<int?> triageId,
      Value<int?> treatmentOnSiteId,
      Value<String?> actionSummary,
      Value<String?> actionSummaryOther,
      Value<int?> resultId,
      Value<bool?> transportRequired,
      Value<String?> transportMethod,
      Value<int?> referralHospitalId,
      Value<String?> referralHospitalFinal,
      Value<DateTime?> arrivalTime,
      Value<int?> clearanceId,
      Value<int?> expeditedClearanceId,
      Value<String?> doctorOrderCh,
      Value<String?> doctorOrderEn,
      Value<String?> directorName,
      Value<String?> assistStaff,
      Value<DateTime> treatmentTime,
    });

final class $$TreatmentTableReferences
    extends BaseReferences<_$AppDatabase, $TreatmentTable, TreatmentData> {
  $$TreatmentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.treatment.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TreatmentTableFilterComposer
    extends Composer<_$AppDatabase, $TreatmentTable> {
  $$TreatmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get treatmentId => $composableBuilder(
    column: $table.treatmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tentativeCategoryId => $composableBuilder(
    column: $table.tentativeCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tentative => $composableBuilder(
    column: $table.tentative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryDiagnosis1 => $composableBuilder(
    column: $table.secondaryDiagnosis1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryDiagnosis2 => $composableBuilder(
    column: $table.secondaryDiagnosis2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triageId => $composableBuilder(
    column: $table.triageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get treatmentOnSiteId => $composableBuilder(
    column: $table.treatmentOnSiteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionSummary => $composableBuilder(
    column: $table.actionSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionSummaryOther => $composableBuilder(
    column: $table.actionSummaryOther,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resultId => $composableBuilder(
    column: $table.resultId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get transportRequired => $composableBuilder(
    column: $table.transportRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportMethod => $composableBuilder(
    column: $table.transportMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referralHospitalId => $composableBuilder(
    column: $table.referralHospitalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referralHospitalFinal => $composableBuilder(
    column: $table.referralHospitalFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clearanceId => $composableBuilder(
    column: $table.clearanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expeditedClearanceId => $composableBuilder(
    column: $table.expeditedClearanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorOrderCh => $composableBuilder(
    column: $table.doctorOrderCh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorOrderEn => $composableBuilder(
    column: $table.doctorOrderEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directorName => $composableBuilder(
    column: $table.directorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assistStaff => $composableBuilder(
    column: $table.assistStaff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get treatmentTime => $composableBuilder(
    column: $table.treatmentTime,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreatmentTableOrderingComposer
    extends Composer<_$AppDatabase, $TreatmentTable> {
  $$TreatmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get treatmentId => $composableBuilder(
    column: $table.treatmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tentativeCategoryId => $composableBuilder(
    column: $table.tentativeCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tentative => $composableBuilder(
    column: $table.tentative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryDiagnosis1 => $composableBuilder(
    column: $table.secondaryDiagnosis1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryDiagnosis2 => $composableBuilder(
    column: $table.secondaryDiagnosis2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triageId => $composableBuilder(
    column: $table.triageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get treatmentOnSiteId => $composableBuilder(
    column: $table.treatmentOnSiteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionSummary => $composableBuilder(
    column: $table.actionSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionSummaryOther => $composableBuilder(
    column: $table.actionSummaryOther,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resultId => $composableBuilder(
    column: $table.resultId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get transportRequired => $composableBuilder(
    column: $table.transportRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportMethod => $composableBuilder(
    column: $table.transportMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referralHospitalId => $composableBuilder(
    column: $table.referralHospitalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referralHospitalFinal => $composableBuilder(
    column: $table.referralHospitalFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clearanceId => $composableBuilder(
    column: $table.clearanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expeditedClearanceId => $composableBuilder(
    column: $table.expeditedClearanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorOrderCh => $composableBuilder(
    column: $table.doctorOrderCh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorOrderEn => $composableBuilder(
    column: $table.doctorOrderEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directorName => $composableBuilder(
    column: $table.directorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assistStaff => $composableBuilder(
    column: $table.assistStaff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get treatmentTime => $composableBuilder(
    column: $table.treatmentTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreatmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreatmentTable> {
  $$TreatmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get treatmentId => $composableBuilder(
    column: $table.treatmentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tentativeCategoryId => $composableBuilder(
    column: $table.tentativeCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tentative =>
      $composableBuilder(column: $table.tentative, builder: (column) => column);

  GeneratedColumn<String> get secondaryDiagnosis1 => $composableBuilder(
    column: $table.secondaryDiagnosis1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryDiagnosis2 => $composableBuilder(
    column: $table.secondaryDiagnosis2,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triageId =>
      $composableBuilder(column: $table.triageId, builder: (column) => column);

  GeneratedColumn<int> get treatmentOnSiteId => $composableBuilder(
    column: $table.treatmentOnSiteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionSummary => $composableBuilder(
    column: $table.actionSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionSummaryOther => $composableBuilder(
    column: $table.actionSummaryOther,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resultId =>
      $composableBuilder(column: $table.resultId, builder: (column) => column);

  GeneratedColumn<bool> get transportRequired => $composableBuilder(
    column: $table.transportRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transportMethod => $composableBuilder(
    column: $table.transportMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referralHospitalId => $composableBuilder(
    column: $table.referralHospitalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referralHospitalFinal => $composableBuilder(
    column: $table.referralHospitalFinal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clearanceId => $composableBuilder(
    column: $table.clearanceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expeditedClearanceId => $composableBuilder(
    column: $table.expeditedClearanceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorOrderCh => $composableBuilder(
    column: $table.doctorOrderCh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorOrderEn => $composableBuilder(
    column: $table.doctorOrderEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directorName => $composableBuilder(
    column: $table.directorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assistStaff => $composableBuilder(
    column: $table.assistStaff,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get treatmentTime => $composableBuilder(
    column: $table.treatmentTime,
    builder: (column) => column,
  );

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreatmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreatmentTable,
          TreatmentData,
          $$TreatmentTableFilterComposer,
          $$TreatmentTableOrderingComposer,
          $$TreatmentTableAnnotationComposer,
          $$TreatmentTableCreateCompanionBuilder,
          $$TreatmentTableUpdateCompanionBuilder,
          (TreatmentData, $$TreatmentTableReferences),
          TreatmentData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$TreatmentTableTableManager(_$AppDatabase db, $TreatmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> treatmentId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<int?> tentativeCategoryId = const Value.absent(),
                Value<String?> tentative = const Value.absent(),
                Value<String?> secondaryDiagnosis1 = const Value.absent(),
                Value<String?> secondaryDiagnosis2 = const Value.absent(),
                Value<int?> triageId = const Value.absent(),
                Value<int?> treatmentOnSiteId = const Value.absent(),
                Value<String?> actionSummary = const Value.absent(),
                Value<String?> actionSummaryOther = const Value.absent(),
                Value<int?> resultId = const Value.absent(),
                Value<bool?> transportRequired = const Value.absent(),
                Value<String?> transportMethod = const Value.absent(),
                Value<int?> referralHospitalId = const Value.absent(),
                Value<String?> referralHospitalFinal = const Value.absent(),
                Value<DateTime?> arrivalTime = const Value.absent(),
                Value<int?> clearanceId = const Value.absent(),
                Value<int?> expeditedClearanceId = const Value.absent(),
                Value<String?> doctorOrderCh = const Value.absent(),
                Value<String?> doctorOrderEn = const Value.absent(),
                Value<String?> directorName = const Value.absent(),
                Value<String?> assistStaff = const Value.absent(),
                Value<DateTime> treatmentTime = const Value.absent(),
              }) => TreatmentCompanion(
                treatmentId: treatmentId,
                medicalId: medicalId,
                tentativeCategoryId: tentativeCategoryId,
                tentative: tentative,
                secondaryDiagnosis1: secondaryDiagnosis1,
                secondaryDiagnosis2: secondaryDiagnosis2,
                triageId: triageId,
                treatmentOnSiteId: treatmentOnSiteId,
                actionSummary: actionSummary,
                actionSummaryOther: actionSummaryOther,
                resultId: resultId,
                transportRequired: transportRequired,
                transportMethod: transportMethod,
                referralHospitalId: referralHospitalId,
                referralHospitalFinal: referralHospitalFinal,
                arrivalTime: arrivalTime,
                clearanceId: clearanceId,
                expeditedClearanceId: expeditedClearanceId,
                doctorOrderCh: doctorOrderCh,
                doctorOrderEn: doctorOrderEn,
                directorName: directorName,
                assistStaff: assistStaff,
                treatmentTime: treatmentTime,
              ),
          createCompanionCallback:
              ({
                Value<int> treatmentId = const Value.absent(),
                required int medicalId,
                Value<int?> tentativeCategoryId = const Value.absent(),
                Value<String?> tentative = const Value.absent(),
                Value<String?> secondaryDiagnosis1 = const Value.absent(),
                Value<String?> secondaryDiagnosis2 = const Value.absent(),
                Value<int?> triageId = const Value.absent(),
                Value<int?> treatmentOnSiteId = const Value.absent(),
                Value<String?> actionSummary = const Value.absent(),
                Value<String?> actionSummaryOther = const Value.absent(),
                Value<int?> resultId = const Value.absent(),
                Value<bool?> transportRequired = const Value.absent(),
                Value<String?> transportMethod = const Value.absent(),
                Value<int?> referralHospitalId = const Value.absent(),
                Value<String?> referralHospitalFinal = const Value.absent(),
                Value<DateTime?> arrivalTime = const Value.absent(),
                Value<int?> clearanceId = const Value.absent(),
                Value<int?> expeditedClearanceId = const Value.absent(),
                Value<String?> doctorOrderCh = const Value.absent(),
                Value<String?> doctorOrderEn = const Value.absent(),
                Value<String?> directorName = const Value.absent(),
                Value<String?> assistStaff = const Value.absent(),
                Value<DateTime> treatmentTime = const Value.absent(),
              }) => TreatmentCompanion.insert(
                treatmentId: treatmentId,
                medicalId: medicalId,
                tentativeCategoryId: tentativeCategoryId,
                tentative: tentative,
                secondaryDiagnosis1: secondaryDiagnosis1,
                secondaryDiagnosis2: secondaryDiagnosis2,
                triageId: triageId,
                treatmentOnSiteId: treatmentOnSiteId,
                actionSummary: actionSummary,
                actionSummaryOther: actionSummaryOther,
                resultId: resultId,
                transportRequired: transportRequired,
                transportMethod: transportMethod,
                referralHospitalId: referralHospitalId,
                referralHospitalFinal: referralHospitalFinal,
                arrivalTime: arrivalTime,
                clearanceId: clearanceId,
                expeditedClearanceId: expeditedClearanceId,
                doctorOrderCh: doctorOrderCh,
                doctorOrderEn: doctorOrderEn,
                directorName: directorName,
                assistStaff: assistStaff,
                treatmentTime: treatmentTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TreatmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable: $$TreatmentTableReferences
                                    ._medicalIdTable(db),
                                referencedColumn: $$TreatmentTableReferences
                                    ._medicalIdTable(db)
                                    .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TreatmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreatmentTable,
      TreatmentData,
      $$TreatmentTableFilterComposer,
      $$TreatmentTableOrderingComposer,
      $$TreatmentTableAnnotationComposer,
      $$TreatmentTableCreateCompanionBuilder,
      $$TreatmentTableUpdateCompanionBuilder,
      (TreatmentData, $$TreatmentTableReferences),
      TreatmentData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$MedicalStaffAssignmentTableCreateCompanionBuilder =
    MedicalStaffAssignmentCompanion Function({
      Value<int> staffAssignmentId,
      required int medicalId,
      required String staffRole,
      Value<int?> staffId,
      Value<String?> staffName,
      Value<bool> isPrimary,
      Value<Uint8List?> signature,
      Value<DateTime?> signedAt,
      Value<DateTime> assignedAt,
    });
typedef $$MedicalStaffAssignmentTableUpdateCompanionBuilder =
    MedicalStaffAssignmentCompanion Function({
      Value<int> staffAssignmentId,
      Value<int> medicalId,
      Value<String> staffRole,
      Value<int?> staffId,
      Value<String?> staffName,
      Value<bool> isPrimary,
      Value<Uint8List?> signature,
      Value<DateTime?> signedAt,
      Value<DateTime> assignedAt,
    });

final class $$MedicalStaffAssignmentTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicalStaffAssignmentTable,
          MedicalStaffAssignmentData
        > {
  $$MedicalStaffAssignmentTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.medicalStaffAssignment.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicalStaffAssignmentTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalStaffAssignmentTable> {
  $$MedicalStaffAssignmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get staffAssignmentId => $composableBuilder(
    column: $table.staffAssignmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get staffRole => $composableBuilder(
    column: $table.staffRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get staffId => $composableBuilder(
    column: $table.staffId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get staffName => $composableBuilder(
    column: $table.staffName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalStaffAssignmentTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalStaffAssignmentTable> {
  $$MedicalStaffAssignmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get staffAssignmentId => $composableBuilder(
    column: $table.staffAssignmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get staffRole => $composableBuilder(
    column: $table.staffRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get staffId => $composableBuilder(
    column: $table.staffId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get staffName => $composableBuilder(
    column: $table.staffName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalStaffAssignmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalStaffAssignmentTable> {
  $$MedicalStaffAssignmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get staffAssignmentId => $composableBuilder(
    column: $table.staffAssignmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get staffRole =>
      $composableBuilder(column: $table.staffRole, builder: (column) => column);

  GeneratedColumn<int> get staffId =>
      $composableBuilder(column: $table.staffId, builder: (column) => column);

  GeneratedColumn<String> get staffName =>
      $composableBuilder(column: $table.staffName, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<Uint8List> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<DateTime> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => column,
  );

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalStaffAssignmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalStaffAssignmentTable,
          MedicalStaffAssignmentData,
          $$MedicalStaffAssignmentTableFilterComposer,
          $$MedicalStaffAssignmentTableOrderingComposer,
          $$MedicalStaffAssignmentTableAnnotationComposer,
          $$MedicalStaffAssignmentTableCreateCompanionBuilder,
          $$MedicalStaffAssignmentTableUpdateCompanionBuilder,
          (MedicalStaffAssignmentData, $$MedicalStaffAssignmentTableReferences),
          MedicalStaffAssignmentData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$MedicalStaffAssignmentTableTableManager(
    _$AppDatabase db,
    $MedicalStaffAssignmentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalStaffAssignmentTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MedicalStaffAssignmentTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MedicalStaffAssignmentTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> staffAssignmentId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<String> staffRole = const Value.absent(),
                Value<int?> staffId = const Value.absent(),
                Value<String?> staffName = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<Uint8List?> signature = const Value.absent(),
                Value<DateTime?> signedAt = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
              }) => MedicalStaffAssignmentCompanion(
                staffAssignmentId: staffAssignmentId,
                medicalId: medicalId,
                staffRole: staffRole,
                staffId: staffId,
                staffName: staffName,
                isPrimary: isPrimary,
                signature: signature,
                signedAt: signedAt,
                assignedAt: assignedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> staffAssignmentId = const Value.absent(),
                required int medicalId,
                required String staffRole,
                Value<int?> staffId = const Value.absent(),
                Value<String?> staffName = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<Uint8List?> signature = const Value.absent(),
                Value<DateTime?> signedAt = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
              }) => MedicalStaffAssignmentCompanion.insert(
                staffAssignmentId: staffAssignmentId,
                medicalId: medicalId,
                staffRole: staffRole,
                staffId: staffId,
                staffName: staffName,
                isPrimary: isPrimary,
                signature: signature,
                signedAt: signedAt,
                assignedAt: assignedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicalStaffAssignmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable:
                                    $$MedicalStaffAssignmentTableReferences
                                        ._medicalIdTable(db),
                                referencedColumn:
                                    $$MedicalStaffAssignmentTableReferences
                                        ._medicalIdTable(db)
                                        .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicalStaffAssignmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalStaffAssignmentTable,
      MedicalStaffAssignmentData,
      $$MedicalStaffAssignmentTableFilterComposer,
      $$MedicalStaffAssignmentTableOrderingComposer,
      $$MedicalStaffAssignmentTableAnnotationComposer,
      $$MedicalStaffAssignmentTableCreateCompanionBuilder,
      $$MedicalStaffAssignmentTableUpdateCompanionBuilder,
      (MedicalStaffAssignmentData, $$MedicalStaffAssignmentTableReferences),
      MedicalStaffAssignmentData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$SpecialNotesTableCreateCompanionBuilder =
    SpecialNotesCompanion Function({
      Value<int> noteId,
      required int medicalId,
      Value<String?> selectedNotes,
      Value<String?> otherNotes,
      Value<DateTime> createdAt,
    });
typedef $$SpecialNotesTableUpdateCompanionBuilder =
    SpecialNotesCompanion Function({
      Value<int> noteId,
      Value<int> medicalId,
      Value<String?> selectedNotes,
      Value<String?> otherNotes,
      Value<DateTime> createdAt,
    });

final class $$SpecialNotesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SpecialNotesTable, SpecialNotesData> {
  $$SpecialNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalRecordTable _medicalIdTable(_$AppDatabase db) =>
      db.medicalRecord.createAlias(
        $_aliasNameGenerator(
          db.specialNotes.medicalId,
          db.medicalRecord.medicalId,
        ),
      );

  $$MedicalRecordTableProcessedTableManager get medicalId {
    final $_column = $_itemColumn<int>('medical_id')!;

    final manager = $$MedicalRecordTableTableManager(
      $_db,
      $_db.medicalRecord,
    ).filter((f) => f.medicalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpecialNotesTableFilterComposer
    extends Composer<_$AppDatabase, $SpecialNotesTable> {
  $$SpecialNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedNotes => $composableBuilder(
    column: $table.selectedNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherNotes => $composableBuilder(
    column: $table.otherNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalRecordTableFilterComposer get medicalId {
    final $$MedicalRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableFilterComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecialNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $SpecialNotesTable> {
  $$SpecialNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedNotes => $composableBuilder(
    column: $table.selectedNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherNotes => $composableBuilder(
    column: $table.otherNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalRecordTableOrderingComposer get medicalId {
    final $$MedicalRecordTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableOrderingComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecialNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpecialNotesTable> {
  $$SpecialNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get selectedNotes => $composableBuilder(
    column: $table.selectedNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherNotes => $composableBuilder(
    column: $table.otherNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicalRecordTableAnnotationComposer get medicalId {
    final $$MedicalRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalId,
      referencedTable: $db.medicalRecord,
      getReferencedColumn: (t) => t.medicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpecialNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpecialNotesTable,
          SpecialNotesData,
          $$SpecialNotesTableFilterComposer,
          $$SpecialNotesTableOrderingComposer,
          $$SpecialNotesTableAnnotationComposer,
          $$SpecialNotesTableCreateCompanionBuilder,
          $$SpecialNotesTableUpdateCompanionBuilder,
          (SpecialNotesData, $$SpecialNotesTableReferences),
          SpecialNotesData,
          PrefetchHooks Function({bool medicalId})
        > {
  $$SpecialNotesTableTableManager(_$AppDatabase db, $SpecialNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpecialNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpecialNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpecialNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> noteId = const Value.absent(),
                Value<int> medicalId = const Value.absent(),
                Value<String?> selectedNotes = const Value.absent(),
                Value<String?> otherNotes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SpecialNotesCompanion(
                noteId: noteId,
                medicalId: medicalId,
                selectedNotes: selectedNotes,
                otherNotes: otherNotes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> noteId = const Value.absent(),
                required int medicalId,
                Value<String?> selectedNotes = const Value.absent(),
                Value<String?> otherNotes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SpecialNotesCompanion.insert(
                noteId: noteId,
                medicalId: medicalId,
                selectedNotes: selectedNotes,
                otherNotes: otherNotes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SpecialNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicalId,
                                referencedTable: $$SpecialNotesTableReferences
                                    ._medicalIdTable(db),
                                referencedColumn: $$SpecialNotesTableReferences
                                    ._medicalIdTable(db)
                                    .medicalId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpecialNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpecialNotesTable,
      SpecialNotesData,
      $$SpecialNotesTableFilterComposer,
      $$SpecialNotesTableOrderingComposer,
      $$SpecialNotesTableAnnotationComposer,
      $$SpecialNotesTableCreateCompanionBuilder,
      $$SpecialNotesTableUpdateCompanionBuilder,
      (SpecialNotesData, $$SpecialNotesTableReferences),
      SpecialNotesData,
      PrefetchHooks Function({bool medicalId})
    >;
typedef $$Icd10CodeTableCreateCompanionBuilder =
    Icd10CodeCompanion Function({
      Value<int> id,
      required String code,
      required String nameEn,
      required String nameCh,
      required bool isLeaf,
    });
typedef $$Icd10CodeTableUpdateCompanionBuilder =
    Icd10CodeCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameEn,
      Value<String> nameCh,
      Value<bool> isLeaf,
    });

class $$Icd10CodeTableFilterComposer
    extends Composer<_$AppDatabase, $Icd10CodeTable> {
  $$Icd10CodeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameCh => $composableBuilder(
    column: $table.nameCh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLeaf => $composableBuilder(
    column: $table.isLeaf,
    builder: (column) => ColumnFilters(column),
  );
}

class $$Icd10CodeTableOrderingComposer
    extends Composer<_$AppDatabase, $Icd10CodeTable> {
  $$Icd10CodeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameCh => $composableBuilder(
    column: $table.nameCh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLeaf => $composableBuilder(
    column: $table.isLeaf,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$Icd10CodeTableAnnotationComposer
    extends Composer<_$AppDatabase, $Icd10CodeTable> {
  $$Icd10CodeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameCh =>
      $composableBuilder(column: $table.nameCh, builder: (column) => column);

  GeneratedColumn<bool> get isLeaf =>
      $composableBuilder(column: $table.isLeaf, builder: (column) => column);
}

class $$Icd10CodeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $Icd10CodeTable,
          Icd10CodeData,
          $$Icd10CodeTableFilterComposer,
          $$Icd10CodeTableOrderingComposer,
          $$Icd10CodeTableAnnotationComposer,
          $$Icd10CodeTableCreateCompanionBuilder,
          $$Icd10CodeTableUpdateCompanionBuilder,
          (
            Icd10CodeData,
            BaseReferences<_$AppDatabase, $Icd10CodeTable, Icd10CodeData>,
          ),
          Icd10CodeData,
          PrefetchHooks Function()
        > {
  $$Icd10CodeTableTableManager(_$AppDatabase db, $Icd10CodeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$Icd10CodeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$Icd10CodeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$Icd10CodeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameCh = const Value.absent(),
                Value<bool> isLeaf = const Value.absent(),
              }) => Icd10CodeCompanion(
                id: id,
                code: code,
                nameEn: nameEn,
                nameCh: nameCh,
                isLeaf: isLeaf,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameEn,
                required String nameCh,
                required bool isLeaf,
              }) => Icd10CodeCompanion.insert(
                id: id,
                code: code,
                nameEn: nameEn,
                nameCh: nameCh,
                isLeaf: isLeaf,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$Icd10CodeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $Icd10CodeTable,
      Icd10CodeData,
      $$Icd10CodeTableFilterComposer,
      $$Icd10CodeTableOrderingComposer,
      $$Icd10CodeTableAnnotationComposer,
      $$Icd10CodeTableCreateCompanionBuilder,
      $$Icd10CodeTableUpdateCompanionBuilder,
      (
        Icd10CodeData,
        BaseReferences<_$AppDatabase, $Icd10CodeTable, Icd10CodeData>,
      ),
      Icd10CodeData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SexTableTableManager get sex => $$SexTableTableManager(_db, _db.sex);
  $$NationalityTableTableManager get nationality =>
      $$NationalityTableTableManager(_db, _db.nationality);
  $$AirlineTableTableManager get airline =>
      $$AirlineTableTableManager(_db, _db.airline);
  $$TravelStatusTableTableManager get travelStatus =>
      $$TravelStatusTableTableManager(_db, _db.travelStatus);
  $$LocationTableTableManager get location =>
      $$LocationTableTableManager(_db, _db.location);
  $$IncidentPlaceCategoryTableTableManager get incidentPlaceCategory =>
      $$IncidentPlaceCategoryTableTableManager(_db, _db.incidentPlaceCategory);
  $$IncidentPlaceCategory2TableTableManager get incidentPlaceCategory2 =>
      $$IncidentPlaceCategory2TableTableManager(
        _db,
        _db.incidentPlaceCategory2,
      );
  $$ReportingUnitTableTableManager get reportingUnit =>
      $$ReportingUnitTableTableManager(_db, _db.reportingUnit);
  $$ChiefComplaintTypeTableTableManager get chiefComplaintType =>
      $$ChiefComplaintTypeTableTableManager(_db, _db.chiefComplaintType);
  $$ChiefComplaintDetailTableTableManager get chiefComplaintDetail =>
      $$ChiefComplaintDetailTableTableManager(_db, _db.chiefComplaintDetail);
  $$DiagnosisCategoryTableTableManager get diagnosisCategory =>
      $$DiagnosisCategoryTableTableManager(_db, _db.diagnosisCategory);
  $$TriageLevelTableTableManager get triageLevel =>
      $$TriageLevelTableTableManager(_db, _db.triageLevel);
  $$TreatmentOnSiteTableTableManager get treatmentOnSite =>
      $$TreatmentOnSiteTableTableManager(_db, _db.treatmentOnSite);
  $$TreatmentResultTableTableManager get treatmentResult =>
      $$TreatmentResultTableTableManager(_db, _db.treatmentResult);
  $$ReferralHospitalTableTableManager get referralHospital =>
      $$ReferralHospitalTableTableManager(_db, _db.referralHospital);
  $$ActionItemTableTableManager get actionItem =>
      $$ActionItemTableTableManager(_db, _db.actionItem);
  $$MedicalStaffTableTableManager get medicalStaff =>
      $$MedicalStaffTableTableManager(_db, _db.medicalStaff);
  $$SpecialNoteRefTableTableManager get specialNoteRef =>
      $$SpecialNoteRefTableTableManager(_db, _db.specialNoteRef);
  $$NursingPhraseTableTableManager get nursingPhrase =>
      $$NursingPhraseTableTableManager(_db, _db.nursingPhrase);
  $$MedicalRecordTableTableManager get medicalRecord =>
      $$MedicalRecordTableTableManager(_db, _db.medicalRecord);
  $$PatientTableTableManager get patient =>
      $$PatientTableTableManager(_db, _db.patient);
  $$FlightRecordTableTableManager get flightRecord =>
      $$FlightRecordTableTableManager(_db, _db.flightRecord);
  $$FlightTransitLocationsTableTableManager get flightTransitLocations =>
      $$FlightTransitLocationsTableTableManager(
        _db,
        _db.flightTransitLocations,
      );
  $$IncidentRecordTableTableManager get incidentRecord =>
      $$IncidentRecordTableTableManager(_db, _db.incidentRecord);
  $$ChiefComplaintTableTableManager get chiefComplaint =>
      $$ChiefComplaintTableTableManager(_db, _db.chiefComplaint);
  $$HealthAssessmentFormTableTableManager get healthAssessmentForm =>
      $$HealthAssessmentFormTableTableManager(_db, _db.healthAssessmentForm);
  $$MedicalMediaTableTableManager get medicalMedia =>
      $$MedicalMediaTableTableManager(_db, _db.medicalMedia);
  $$MedicalAssessmentTableTableManager get medicalAssessment =>
      $$MedicalAssessmentTableTableManager(_db, _db.medicalAssessment);
  $$MedicalHistoryTableTableManager get medicalHistory =>
      $$MedicalHistoryTableTableManager(_db, _db.medicalHistory);
  $$TreatmentTableTableManager get treatment =>
      $$TreatmentTableTableManager(_db, _db.treatment);
  $$MedicalStaffAssignmentTableTableManager get medicalStaffAssignment =>
      $$MedicalStaffAssignmentTableTableManager(
        _db,
        _db.medicalStaffAssignment,
      );
  $$SpecialNotesTableTableManager get specialNotes =>
      $$SpecialNotesTableTableManager(_db, _db.specialNotes);
  $$Icd10CodeTableTableManager get icd10Code =>
      $$Icd10CodeTableTableManager(_db, _db.icd10Code);
}
