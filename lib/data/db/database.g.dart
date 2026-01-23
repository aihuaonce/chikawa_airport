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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [nationalityId, name, code];
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
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
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
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
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
  final String? code;
  const NationalityData({
    required this.nationalityId,
    required this.name,
    this.code,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['nationality_id'] = Variable<int>(nationalityId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    return map;
  }

  NationalityCompanion toCompanion(bool nullToAbsent) {
    return NationalityCompanion(
      nationalityId: Value(nationalityId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
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
      code: serializer.fromJson<String?>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nationalityId': serializer.toJson<int>(nationalityId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
    };
  }

  NationalityData copyWith({
    int? nationalityId,
    String? name,
    Value<String?> code = const Value.absent(),
  }) => NationalityData(
    nationalityId: nationalityId ?? this.nationalityId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
  );
  NationalityData copyWithCompanion(NationalityCompanion data) {
    return NationalityData(
      nationalityId: data.nationalityId.present
          ? data.nationalityId.value
          : this.nationalityId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NationalityData(')
          ..write('nationalityId: $nationalityId, ')
          ..write('name: $name, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(nationalityId, name, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NationalityData &&
          other.nationalityId == this.nationalityId &&
          other.name == this.name &&
          other.code == this.code);
}

class NationalityCompanion extends UpdateCompanion<NationalityData> {
  final Value<int> nationalityId;
  final Value<String> name;
  final Value<String?> code;
  const NationalityCompanion({
    this.nationalityId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
  });
  NationalityCompanion.insert({
    this.nationalityId = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
  }) : name = Value(name);
  static Insertable<NationalityData> custom({
    Expression<int>? nationalityId,
    Expression<String>? name,
    Expression<String>? code,
  }) {
    return RawValuesInsertable({
      if (nationalityId != null) 'nationality_id': nationalityId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
    });
  }

  NationalityCompanion copyWith({
    Value<int>? nationalityId,
    Value<String>? name,
    Value<String?>? code,
  }) {
    return NationalityCompanion(
      nationalityId: nationalityId ?? this.nationalityId,
      name: name ?? this.name,
      code: code ?? this.code,
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
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NationalityCompanion(')
          ..write('nationalityId: $nationalityId, ')
          ..write('name: $name, ')
          ..write('code: $code')
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
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [locationId, code, name, countryCode];
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
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
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
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
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
  final String countryCode;
  const LocationData({
    required this.locationId,
    required this.code,
    required this.name,
    required this.countryCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['location_id'] = Variable<int>(locationId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['country_code'] = Variable<String>(countryCode);
    return map;
  }

  LocationCompanion toCompanion(bool nullToAbsent) {
    return LocationCompanion(
      locationId: Value(locationId),
      code: Value(code),
      name: Value(name),
      countryCode: Value(countryCode),
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
      countryCode: serializer.fromJson<String>(json['countryCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'locationId': serializer.toJson<int>(locationId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'countryCode': serializer.toJson<String>(countryCode),
    };
  }

  LocationData copyWith({
    int? locationId,
    String? code,
    String? name,
    String? countryCode,
  }) => LocationData(
    locationId: locationId ?? this.locationId,
    code: code ?? this.code,
    name: name ?? this.name,
    countryCode: countryCode ?? this.countryCode,
  );
  LocationData copyWithCompanion(LocationCompanion data) {
    return LocationData(
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationData(')
          ..write('locationId: $locationId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('countryCode: $countryCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(locationId, code, name, countryCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationData &&
          other.locationId == this.locationId &&
          other.code == this.code &&
          other.name == this.name &&
          other.countryCode == this.countryCode);
}

class LocationCompanion extends UpdateCompanion<LocationData> {
  final Value<int> locationId;
  final Value<String> code;
  final Value<String> name;
  final Value<String> countryCode;
  const LocationCompanion({
    this.locationId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.countryCode = const Value.absent(),
  });
  LocationCompanion.insert({
    this.locationId = const Value.absent(),
    required String code,
    required String name,
    required String countryCode,
  }) : code = Value(code),
       name = Value(name),
       countryCode = Value(countryCode);
  static Insertable<LocationData> custom({
    Expression<int>? locationId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? countryCode,
  }) {
    return RawValuesInsertable({
      if (locationId != null) 'location_id': locationId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (countryCode != null) 'country_code': countryCode,
    });
  }

  LocationCompanion copyWith({
    Value<int>? locationId,
    Value<String>? code,
    Value<String>? name,
    Value<String>? countryCode,
  }) {
    return LocationCompanion(
      locationId: locationId ?? this.locationId,
      code: code ?? this.code,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
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
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationCompanion(')
          ..write('locationId: $locationId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('countryCode: $countryCode')
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
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicalRecordData({
    required this.medicalId,
    required this.isEmergency,
    required this.hasAmbulance,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medical_id'] = Variable<int>(medicalId);
    map['is_emergency'] = Variable<bool>(isEmergency);
    map['has_ambulance'] = Variable<bool>(hasAmbulance);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalRecordCompanion toCompanion(bool nullToAbsent) {
    return MedicalRecordCompanion(
      medicalId: Value(medicalId),
      isEmergency: Value(isEmergency),
      hasAmbulance: Value(hasAmbulance),
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
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalRecordData copyWith({
    int? medicalId,
    bool? isEmergency,
    bool? hasAmbulance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicalRecordData(
    medicalId: medicalId ?? this.medicalId,
    isEmergency: isEmergency ?? this.isEmergency,
    hasAmbulance: hasAmbulance ?? this.hasAmbulance,
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(medicalId, isEmergency, hasAmbulance, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalRecordData &&
          other.medicalId == this.medicalId &&
          other.isEmergency == this.isEmergency &&
          other.hasAmbulance == this.hasAmbulance &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicalRecordCompanion extends UpdateCompanion<MedicalRecordData> {
  final Value<int> medicalId;
  final Value<bool> isEmergency;
  final Value<bool> hasAmbulance;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MedicalRecordCompanion({
    this.medicalId = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.hasAmbulance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MedicalRecordCompanion.insert({
    this.medicalId = const Value.absent(),
    this.isEmergency = const Value.absent(),
    this.hasAmbulance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<MedicalRecordData> custom({
    Expression<int>? medicalId,
    Expression<bool>? isEmergency,
    Expression<bool>? hasAmbulance,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (medicalId != null) 'medical_id': medicalId,
      if (isEmergency != null) 'is_emergency': isEmergency,
      if (hasAmbulance != null) 'has_ambulance': hasAmbulance,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MedicalRecordCompanion copyWith({
    Value<int>? medicalId,
    Value<bool>? isEmergency,
    Value<bool>? hasAmbulance,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MedicalRecordCompanion(
      medicalId: medicalId ?? this.medicalId,
      isEmergency: isEmergency ?? this.isEmergency,
      hasAmbulance: hasAmbulance ?? this.hasAmbulance,
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
    with TableInfo<$FlightTransitLocationsTable, FlightTransitLocation> {
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
    Insertable<FlightTransitLocation> instance, {
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
  FlightTransitLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlightTransitLocation(
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

class FlightTransitLocation extends DataClass
    implements Insertable<FlightTransitLocation> {
  final int id;
  final int flightRecordId;
  final int locationId;
  final int stopOrder;
  const FlightTransitLocation({
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

  factory FlightTransitLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlightTransitLocation(
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

  FlightTransitLocation copyWith({
    int? id,
    int? flightRecordId,
    int? locationId,
    int? stopOrder,
  }) => FlightTransitLocation(
    id: id ?? this.id,
    flightRecordId: flightRecordId ?? this.flightRecordId,
    locationId: locationId ?? this.locationId,
    stopOrder: stopOrder ?? this.stopOrder,
  );
  FlightTransitLocation copyWithCompanion(
    FlightTransitLocationsCompanion data,
  ) {
    return FlightTransitLocation(
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
    return (StringBuffer('FlightTransitLocation(')
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
      (other is FlightTransitLocation &&
          other.id == this.id &&
          other.flightRecordId == this.flightRecordId &&
          other.locationId == this.locationId &&
          other.stopOrder == this.stopOrder);
}

class FlightTransitLocationsCompanion
    extends UpdateCompanion<FlightTransitLocation> {
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
  static Insertable<FlightTransitLocation> custom({
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SexTable sex = $SexTable(this);
  late final $NationalityTable nationality = $NationalityTable(this);
  late final $AirlineTable airline = $AirlineTable(this);
  late final $TravelStatusTable travelStatus = $TravelStatusTable(this);
  late final $LocationTable location = $LocationTable(this);
  late final $MedicalRecordTable medicalRecord = $MedicalRecordTable(this);
  late final $PatientTable patient = $PatientTable(this);
  late final $FlightRecordTable flightRecord = $FlightRecordTable(this);
  late final $FlightTransitLocationsTable flightTransitLocations =
      $FlightTransitLocationsTable(this);
  late final ReferenceDao referenceDao = ReferenceDao(this as AppDatabase);
  late final MedicalDao medicalDao = MedicalDao(this as AppDatabase);
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
    medicalRecord,
    patient,
    flightRecord,
    flightTransitLocations,
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
      Value<String?> code,
    });
typedef $$NationalityTableUpdateCompanionBuilder =
    NationalityCompanion Function({
      Value<int> nationalityId,
      Value<String> name,
      Value<String?> code,
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
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

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

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
                Value<String?> code = const Value.absent(),
              }) => NationalityCompanion(
                nationalityId: nationalityId,
                name: name,
                code: code,
              ),
          createCompanionCallback:
              ({
                Value<int> nationalityId = const Value.absent(),
                required String name,
                Value<String?> code = const Value.absent(),
              }) => NationalityCompanion.insert(
                nationalityId: nationalityId,
                name: name,
                code: code,
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
      required String countryCode,
    });
typedef $$LocationTableUpdateCompanionBuilder =
    LocationCompanion Function({
      Value<int> locationId,
      Value<String> code,
      Value<String> name,
      Value<String> countryCode,
    });

final class $$LocationTableReferences
    extends BaseReferences<_$AppDatabase, $LocationTable, LocationData> {
  $$LocationTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $FlightTransitLocationsTable,
    List<FlightTransitLocation>
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

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
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

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
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

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

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
                Value<String> countryCode = const Value.absent(),
              }) => LocationCompanion(
                locationId: locationId,
                code: code,
                name: name,
                countryCode: countryCode,
              ),
          createCompanionCallback:
              ({
                Value<int> locationId = const Value.absent(),
                required String code,
                required String name,
                required String countryCode,
              }) => LocationCompanion.insert(
                locationId: locationId,
                code: code,
                name: name,
                countryCode: countryCode,
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
                      FlightTransitLocation
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
typedef $$MedicalRecordTableCreateCompanionBuilder =
    MedicalRecordCompanion Function({
      Value<int> medicalId,
      Value<bool> isEmergency,
      Value<bool> hasAmbulance,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MedicalRecordTableUpdateCompanionBuilder =
    MedicalRecordCompanion Function({
      Value<int> medicalId,
      Value<bool> isEmergency,
      Value<bool> hasAmbulance,
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
          PrefetchHooks Function({bool patientRefs, bool flightRecordRefs})
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
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicalRecordCompanion(
                medicalId: medicalId,
                isEmergency: isEmergency,
                hasAmbulance: hasAmbulance,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> medicalId = const Value.absent(),
                Value<bool> isEmergency = const Value.absent(),
                Value<bool> hasAmbulance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicalRecordCompanion.insert(
                medicalId: medicalId,
                isEmergency: isEmergency,
                hasAmbulance: hasAmbulance,
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
              ({patientRefs = false, flightRecordRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (patientRefs) db.patient,
                    if (flightRecordRefs) db.flightRecord,
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
      PrefetchHooks Function({bool patientRefs, bool flightRecordRefs})
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
    List<FlightTransitLocation>
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
                          FlightTransitLocation
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
          FlightTransitLocation
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
          FlightTransitLocation,
          $$FlightTransitLocationsTableFilterComposer,
          $$FlightTransitLocationsTableOrderingComposer,
          $$FlightTransitLocationsTableAnnotationComposer,
          $$FlightTransitLocationsTableCreateCompanionBuilder,
          $$FlightTransitLocationsTableUpdateCompanionBuilder,
          (FlightTransitLocation, $$FlightTransitLocationsTableReferences),
          FlightTransitLocation,
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
      FlightTransitLocation,
      $$FlightTransitLocationsTableFilterComposer,
      $$FlightTransitLocationsTableOrderingComposer,
      $$FlightTransitLocationsTableAnnotationComposer,
      $$FlightTransitLocationsTableCreateCompanionBuilder,
      $$FlightTransitLocationsTableUpdateCompanionBuilder,
      (FlightTransitLocation, $$FlightTransitLocationsTableReferences),
      FlightTransitLocation,
      PrefetchHooks Function({bool flightRecordId, bool locationId})
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
}
