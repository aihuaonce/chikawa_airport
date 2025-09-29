// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VisitsTable extends Visits with TableInfo<$VisitsTable, Visit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientNameMeta = const VerificationMeta(
    'patientName',
  );
  @override
  late final GeneratedColumn<String> patientName = GeneratedColumn<String>(
    'patient_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationalityMeta = const VerificationMeta(
    'nationality',
  );
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
    'nationality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deptMeta = const VerificationMeta('dept');
  @override
  late final GeneratedColumn<String> dept = GeneratedColumn<String>(
    'dept',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filledByMeta = const VerificationMeta(
    'filledBy',
  );
  @override
  late final GeneratedColumn<String> filledBy = GeneratedColumn<String>(
    'filled_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    visitId,
    patientName,
    gender,
    nationality,
    dept,
    note,
    filledBy,
    uploadedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('patient_name')) {
      context.handle(
        _patientNameMeta,
        patientName.isAcceptableOrUnknown(
          data['patient_name']!,
          _patientNameMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('nationality')) {
      context.handle(
        _nationalityMeta,
        nationality.isAcceptableOrUnknown(
          data['nationality']!,
          _nationalityMeta,
        ),
      );
    }
    if (data.containsKey('dept')) {
      context.handle(
        _deptMeta,
        dept.isAcceptableOrUnknown(data['dept']!, _deptMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('filled_by')) {
      context.handle(
        _filledByMeta,
        filledBy.isAcceptableOrUnknown(data['filled_by']!, _filledByMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
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
  Set<GeneratedColumn> get $primaryKey => {visitId};
  @override
  Visit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visit(
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      patientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_name'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      nationality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationality'],
      ),
      dept: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dept'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      filledBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filled_by'],
      ),
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
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
  $VisitsTable createAlias(String alias) {
    return $VisitsTable(attachedDatabase, alias);
  }
}

class Visit extends DataClass implements Insertable<Visit> {
  final int visitId;
  final String? patientName;
  final String? gender;
  final String? nationality;
  final String? dept;
  final String? note;
  final String? filledBy;
  final DateTime uploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Visit({
    required this.visitId,
    this.patientName,
    this.gender,
    this.nationality,
    this.dept,
    this.note,
    this.filledBy,
    required this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visit_id'] = Variable<int>(visitId);
    if (!nullToAbsent || patientName != null) {
      map['patient_name'] = Variable<String>(patientName);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || dept != null) {
      map['dept'] = Variable<String>(dept);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || filledBy != null) {
      map['filled_by'] = Variable<String>(filledBy);
    }
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VisitsCompanion toCompanion(bool nullToAbsent) {
    return VisitsCompanion(
      visitId: Value(visitId),
      patientName: patientName == null && nullToAbsent
          ? const Value.absent()
          : Value(patientName),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      nationality: nationality == null && nullToAbsent
          ? const Value.absent()
          : Value(nationality),
      dept: dept == null && nullToAbsent ? const Value.absent() : Value(dept),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      filledBy: filledBy == null && nullToAbsent
          ? const Value.absent()
          : Value(filledBy),
      uploadedAt: Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Visit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visit(
      visitId: serializer.fromJson<int>(json['visitId']),
      patientName: serializer.fromJson<String?>(json['patientName']),
      gender: serializer.fromJson<String?>(json['gender']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      dept: serializer.fromJson<String?>(json['dept']),
      note: serializer.fromJson<String?>(json['note']),
      filledBy: serializer.fromJson<String?>(json['filledBy']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitId': serializer.toJson<int>(visitId),
      'patientName': serializer.toJson<String?>(patientName),
      'gender': serializer.toJson<String?>(gender),
      'nationality': serializer.toJson<String?>(nationality),
      'dept': serializer.toJson<String?>(dept),
      'note': serializer.toJson<String?>(note),
      'filledBy': serializer.toJson<String?>(filledBy),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Visit copyWith({
    int? visitId,
    Value<String?> patientName = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> nationality = const Value.absent(),
    Value<String?> dept = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> filledBy = const Value.absent(),
    DateTime? uploadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Visit(
    visitId: visitId ?? this.visitId,
    patientName: patientName.present ? patientName.value : this.patientName,
    gender: gender.present ? gender.value : this.gender,
    nationality: nationality.present ? nationality.value : this.nationality,
    dept: dept.present ? dept.value : this.dept,
    note: note.present ? note.value : this.note,
    filledBy: filledBy.present ? filledBy.value : this.filledBy,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Visit copyWithCompanion(VisitsCompanion data) {
    return Visit(
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      patientName: data.patientName.present
          ? data.patientName.value
          : this.patientName,
      gender: data.gender.present ? data.gender.value : this.gender,
      nationality: data.nationality.present
          ? data.nationality.value
          : this.nationality,
      dept: data.dept.present ? data.dept.value : this.dept,
      note: data.note.present ? data.note.value : this.note,
      filledBy: data.filledBy.present ? data.filledBy.value : this.filledBy,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visit(')
          ..write('visitId: $visitId, ')
          ..write('patientName: $patientName, ')
          ..write('gender: $gender, ')
          ..write('nationality: $nationality, ')
          ..write('dept: $dept, ')
          ..write('note: $note, ')
          ..write('filledBy: $filledBy, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    visitId,
    patientName,
    gender,
    nationality,
    dept,
    note,
    filledBy,
    uploadedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visit &&
          other.visitId == this.visitId &&
          other.patientName == this.patientName &&
          other.gender == this.gender &&
          other.nationality == this.nationality &&
          other.dept == this.dept &&
          other.note == this.note &&
          other.filledBy == this.filledBy &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VisitsCompanion extends UpdateCompanion<Visit> {
  final Value<int> visitId;
  final Value<String?> patientName;
  final Value<String?> gender;
  final Value<String?> nationality;
  final Value<String?> dept;
  final Value<String?> note;
  final Value<String?> filledBy;
  final Value<DateTime> uploadedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VisitsCompanion({
    this.visitId = const Value.absent(),
    this.patientName = const Value.absent(),
    this.gender = const Value.absent(),
    this.nationality = const Value.absent(),
    this.dept = const Value.absent(),
    this.note = const Value.absent(),
    this.filledBy = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VisitsCompanion.insert({
    this.visitId = const Value.absent(),
    this.patientName = const Value.absent(),
    this.gender = const Value.absent(),
    this.nationality = const Value.absent(),
    this.dept = const Value.absent(),
    this.note = const Value.absent(),
    this.filledBy = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Visit> custom({
    Expression<int>? visitId,
    Expression<String>? patientName,
    Expression<String>? gender,
    Expression<String>? nationality,
    Expression<String>? dept,
    Expression<String>? note,
    Expression<String>? filledBy,
    Expression<DateTime>? uploadedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (visitId != null) 'visit_id': visitId,
      if (patientName != null) 'patient_name': patientName,
      if (gender != null) 'gender': gender,
      if (nationality != null) 'nationality': nationality,
      if (dept != null) 'dept': dept,
      if (note != null) 'note': note,
      if (filledBy != null) 'filled_by': filledBy,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VisitsCompanion copyWith({
    Value<int>? visitId,
    Value<String?>? patientName,
    Value<String?>? gender,
    Value<String?>? nationality,
    Value<String?>? dept,
    Value<String?>? note,
    Value<String?>? filledBy,
    Value<DateTime>? uploadedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VisitsCompanion(
      visitId: visitId ?? this.visitId,
      patientName: patientName ?? this.patientName,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      dept: dept ?? this.dept,
      note: note ?? this.note,
      filledBy: filledBy ?? this.filledBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (patientName.present) {
      map['patient_name'] = Variable<String>(patientName.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (dept.present) {
      map['dept'] = Variable<String>(dept.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (filledBy.present) {
      map['filled_by'] = Variable<String>(filledBy.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
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
    return (StringBuffer('VisitsCompanion(')
          ..write('visitId: $visitId, ')
          ..write('patientName: $patientName, ')
          ..write('gender: $gender, ')
          ..write('nationality: $nationality, ')
          ..write('dept: $dept, ')
          ..write('note: $note, ')
          ..write('filledBy: $filledBy, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PatientProfilesTable extends PatientProfiles
    with TableInfo<$PatientProfilesTable, PatientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationalityMeta = const VerificationMeta(
    'nationality',
  );
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
    'nationality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
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
    id,
    visitId,
    birthday,
    age,
    gender,
    reason,
    nationality,
    idNumber,
    address,
    phone,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
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
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('nationality')) {
      context.handle(
        _nationalityMeta,
        nationality.isAcceptableOrUnknown(
          data['nationality']!,
          _nationalityMeta,
        ),
      );
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
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
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birthday'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      nationality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationality'],
      ),
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
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
  $PatientProfilesTable createAlias(String alias) {
    return $PatientProfilesTable(attachedDatabase, alias);
  }
}

class PatientProfile extends DataClass implements Insertable<PatientProfile> {
  final int id;
  final int visitId;
  final DateTime? birthday;
  final int? age;
  final String? gender;
  final String? reason;
  final String? nationality;
  final String? idNumber;
  final String? address;
  final String? phone;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PatientProfile({
    required this.id,
    required this.visitId,
    this.birthday,
    this.age,
    this.gender,
    this.reason,
    this.nationality,
    this.idNumber,
    this.address,
    this.phone,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['visit_id'] = Variable<int>(visitId);
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || idNumber != null) {
      map['id_number'] = Variable<String>(idNumber);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PatientProfilesCompanion toCompanion(bool nullToAbsent) {
    return PatientProfilesCompanion(
      id: Value(id),
      visitId: Value(visitId),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      nationality: nationality == null && nullToAbsent
          ? const Value.absent()
          : Value(nationality),
      idNumber: idNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idNumber),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PatientProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientProfile(
      id: serializer.fromJson<int>(json['id']),
      visitId: serializer.fromJson<int>(json['visitId']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      age: serializer.fromJson<int?>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      reason: serializer.fromJson<String?>(json['reason']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      idNumber: serializer.fromJson<String?>(json['idNumber']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'visitId': serializer.toJson<int>(visitId),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'age': serializer.toJson<int?>(age),
      'gender': serializer.toJson<String?>(gender),
      'reason': serializer.toJson<String?>(reason),
      'nationality': serializer.toJson<String?>(nationality),
      'idNumber': serializer.toJson<String?>(idNumber),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PatientProfile copyWith({
    int? id,
    int? visitId,
    Value<DateTime?> birthday = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> reason = const Value.absent(),
    Value<String?> nationality = const Value.absent(),
    Value<String?> idNumber = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PatientProfile(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    birthday: birthday.present ? birthday.value : this.birthday,
    age: age.present ? age.value : this.age,
    gender: gender.present ? gender.value : this.gender,
    reason: reason.present ? reason.value : this.reason,
    nationality: nationality.present ? nationality.value : this.nationality,
    idNumber: idNumber.present ? idNumber.value : this.idNumber,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PatientProfile copyWithCompanion(PatientProfilesCompanion data) {
    return PatientProfile(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      reason: data.reason.present ? data.reason.value : this.reason,
      nationality: data.nationality.present
          ? data.nationality.value
          : this.nationality,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfile(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('birthday: $birthday, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('reason: $reason, ')
          ..write('nationality: $nationality, ')
          ..write('idNumber: $idNumber, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    birthday,
    age,
    gender,
    reason,
    nationality,
    idNumber,
    address,
    phone,
    photoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientProfile &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.birthday == this.birthday &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.reason == this.reason &&
          other.nationality == this.nationality &&
          other.idNumber == this.idNumber &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientProfilesCompanion extends UpdateCompanion<PatientProfile> {
  final Value<int> id;
  final Value<int> visitId;
  final Value<DateTime?> birthday;
  final Value<int?> age;
  final Value<String?> gender;
  final Value<String?> reason;
  final Value<String?> nationality;
  final Value<String?> idNumber;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PatientProfilesCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.birthday = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.reason = const Value.absent(),
    this.nationality = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PatientProfilesCompanion.insert({
    this.id = const Value.absent(),
    required int visitId,
    this.birthday = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.reason = const Value.absent(),
    this.nationality = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : visitId = Value(visitId);
  static Insertable<PatientProfile> custom({
    Expression<int>? id,
    Expression<int>? visitId,
    Expression<DateTime>? birthday,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? reason,
    Expression<String>? nationality,
    Expression<String>? idNumber,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (birthday != null) 'birthday': birthday,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (reason != null) 'reason': reason,
      if (nationality != null) 'nationality': nationality,
      if (idNumber != null) 'id_number': idNumber,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PatientProfilesCompanion copyWith({
    Value<int>? id,
    Value<int>? visitId,
    Value<DateTime?>? birthday,
    Value<int?>? age,
    Value<String?>? gender,
    Value<String?>? reason,
    Value<String?>? nationality,
    Value<String?>? idNumber,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PatientProfilesCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      birthday: birthday ?? this.birthday,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      reason: reason ?? this.reason,
      nationality: nationality ?? this.nationality,
      idNumber: idNumber ?? this.idNumber,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
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
    return (StringBuffer('PatientProfilesCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('birthday: $birthday, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('reason: $reason, ')
          ..write('nationality: $nationality, ')
          ..write('idNumber: $idNumber, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AccidentRecordsTable extends AccidentRecords
    with TableInfo<$AccidentRecordsTable, AccidentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccidentRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _incidentDateMeta = const VerificationMeta(
    'incidentDate',
  );
  @override
  late final GeneratedColumn<DateTime> incidentDate = GeneratedColumn<DateTime>(
    'incident_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyTimeMeta = const VerificationMeta(
    'notifyTime',
  );
  @override
  late final GeneratedColumn<DateTime> notifyTime = GeneratedColumn<DateTime>(
    'notify_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pickUpTimeMeta = const VerificationMeta(
    'pickUpTime',
  );
  @override
  late final GeneratedColumn<DateTime> pickUpTime = GeneratedColumn<DateTime>(
    'pick_up_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicArriveTimeMeta = const VerificationMeta(
    'medicArriveTime',
  );
  @override
  late final GeneratedColumn<DateTime> medicArriveTime =
      GeneratedColumn<DateTime>(
        'medic_arrive_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ambulanceDepartTimeMeta =
      const VerificationMeta('ambulanceDepartTime');
  @override
  late final GeneratedColumn<DateTime> ambulanceDepartTime =
      GeneratedColumn<DateTime>(
        'ambulance_depart_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _checkTimeMeta = const VerificationMeta(
    'checkTime',
  );
  @override
  late final GeneratedColumn<DateTime> checkTime = GeneratedColumn<DateTime>(
    'check_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _reportUnitIdxMeta = const VerificationMeta(
    'reportUnitIdx',
  );
  @override
  late final GeneratedColumn<int> reportUnitIdx = GeneratedColumn<int>(
    'report_unit_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherReportUnitMeta = const VerificationMeta(
    'otherReportUnit',
  );
  @override
  late final GeneratedColumn<String> otherReportUnit = GeneratedColumn<String>(
    'other_report_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifierMeta = const VerificationMeta(
    'notifier',
  );
  @override
  late final GeneratedColumn<String> notifier = GeneratedColumn<String>(
    'notifier',
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
  static const VerificationMeta _placeIdxMeta = const VerificationMeta(
    'placeIdx',
  );
  @override
  late final GeneratedColumn<int> placeIdx = GeneratedColumn<int>(
    'place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeNoteMeta = const VerificationMeta(
    'placeNote',
  );
  @override
  late final GeneratedColumn<String> placeNote = GeneratedColumn<String>(
    'place_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _t1PlaceIdxMeta = const VerificationMeta(
    't1PlaceIdx',
  );
  @override
  late final GeneratedColumn<int> t1PlaceIdx = GeneratedColumn<int>(
    't1_place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _t2PlaceIdxMeta = const VerificationMeta(
    't2PlaceIdx',
  );
  @override
  late final GeneratedColumn<int> t2PlaceIdx = GeneratedColumn<int>(
    't2_place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remotePlaceIdxMeta = const VerificationMeta(
    'remotePlaceIdx',
  );
  @override
  late final GeneratedColumn<int> remotePlaceIdx = GeneratedColumn<int>(
    'remote_place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cargoPlaceIdxMeta = const VerificationMeta(
    'cargoPlaceIdx',
  );
  @override
  late final GeneratedColumn<int> cargoPlaceIdx = GeneratedColumn<int>(
    'cargo_place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _novotelPlaceIdxMeta = const VerificationMeta(
    'novotelPlaceIdx',
  );
  @override
  late final GeneratedColumn<int> novotelPlaceIdx = GeneratedColumn<int>(
    'novotel_place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cabinPlaceIdxMeta = const VerificationMeta(
    'cabinPlaceIdx',
  );
  @override
  late final GeneratedColumn<int> cabinPlaceIdx = GeneratedColumn<int>(
    'cabin_place_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<String> cost = GeneratedColumn<String>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _within10minMeta = const VerificationMeta(
    'within10min',
  );
  @override
  late final GeneratedColumn<int> within10min = GeneratedColumn<int>(
    'within10min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonLandingMeta = const VerificationMeta(
    'reasonLanding',
  );
  @override
  late final GeneratedColumn<bool> reasonLanding = GeneratedColumn<bool>(
    'reason_landing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reason_landing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reasonOnlineMeta = const VerificationMeta(
    'reasonOnline',
  );
  @override
  late final GeneratedColumn<bool> reasonOnline = GeneratedColumn<bool>(
    'reason_online',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reason_online" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reasonOtherMeta = const VerificationMeta(
    'reasonOther',
  );
  @override
  late final GeneratedColumn<bool> reasonOther = GeneratedColumn<bool>(
    'reason_other',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reason_other" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reasonOtherTextMeta = const VerificationMeta(
    'reasonOtherText',
  );
  @override
  late final GeneratedColumn<String> reasonOtherText = GeneratedColumn<String>(
    'reason_other_text',
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
    id,
    visitId,
    incidentDate,
    notifyTime,
    pickUpTime,
    medicArriveTime,
    ambulanceDepartTime,
    checkTime,
    landingTime,
    reportUnitIdx,
    otherReportUnit,
    notifier,
    phone,
    placeIdx,
    placeNote,
    t1PlaceIdx,
    t2PlaceIdx,
    remotePlaceIdx,
    cargoPlaceIdx,
    novotelPlaceIdx,
    cabinPlaceIdx,
    occArrived,
    cost,
    within10min,
    reasonLanding,
    reasonOnline,
    reasonOther,
    reasonOtherText,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accident_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccidentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('incident_date')) {
      context.handle(
        _incidentDateMeta,
        incidentDate.isAcceptableOrUnknown(
          data['incident_date']!,
          _incidentDateMeta,
        ),
      );
    }
    if (data.containsKey('notify_time')) {
      context.handle(
        _notifyTimeMeta,
        notifyTime.isAcceptableOrUnknown(data['notify_time']!, _notifyTimeMeta),
      );
    }
    if (data.containsKey('pick_up_time')) {
      context.handle(
        _pickUpTimeMeta,
        pickUpTime.isAcceptableOrUnknown(
          data['pick_up_time']!,
          _pickUpTimeMeta,
        ),
      );
    }
    if (data.containsKey('medic_arrive_time')) {
      context.handle(
        _medicArriveTimeMeta,
        medicArriveTime.isAcceptableOrUnknown(
          data['medic_arrive_time']!,
          _medicArriveTimeMeta,
        ),
      );
    }
    if (data.containsKey('ambulance_depart_time')) {
      context.handle(
        _ambulanceDepartTimeMeta,
        ambulanceDepartTime.isAcceptableOrUnknown(
          data['ambulance_depart_time']!,
          _ambulanceDepartTimeMeta,
        ),
      );
    }
    if (data.containsKey('check_time')) {
      context.handle(
        _checkTimeMeta,
        checkTime.isAcceptableOrUnknown(data['check_time']!, _checkTimeMeta),
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
    if (data.containsKey('report_unit_idx')) {
      context.handle(
        _reportUnitIdxMeta,
        reportUnitIdx.isAcceptableOrUnknown(
          data['report_unit_idx']!,
          _reportUnitIdxMeta,
        ),
      );
    }
    if (data.containsKey('other_report_unit')) {
      context.handle(
        _otherReportUnitMeta,
        otherReportUnit.isAcceptableOrUnknown(
          data['other_report_unit']!,
          _otherReportUnitMeta,
        ),
      );
    }
    if (data.containsKey('notifier')) {
      context.handle(
        _notifierMeta,
        notifier.isAcceptableOrUnknown(data['notifier']!, _notifierMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('place_idx')) {
      context.handle(
        _placeIdxMeta,
        placeIdx.isAcceptableOrUnknown(data['place_idx']!, _placeIdxMeta),
      );
    }
    if (data.containsKey('place_note')) {
      context.handle(
        _placeNoteMeta,
        placeNote.isAcceptableOrUnknown(data['place_note']!, _placeNoteMeta),
      );
    }
    if (data.containsKey('t1_place_idx')) {
      context.handle(
        _t1PlaceIdxMeta,
        t1PlaceIdx.isAcceptableOrUnknown(
          data['t1_place_idx']!,
          _t1PlaceIdxMeta,
        ),
      );
    }
    if (data.containsKey('t2_place_idx')) {
      context.handle(
        _t2PlaceIdxMeta,
        t2PlaceIdx.isAcceptableOrUnknown(
          data['t2_place_idx']!,
          _t2PlaceIdxMeta,
        ),
      );
    }
    if (data.containsKey('remote_place_idx')) {
      context.handle(
        _remotePlaceIdxMeta,
        remotePlaceIdx.isAcceptableOrUnknown(
          data['remote_place_idx']!,
          _remotePlaceIdxMeta,
        ),
      );
    }
    if (data.containsKey('cargo_place_idx')) {
      context.handle(
        _cargoPlaceIdxMeta,
        cargoPlaceIdx.isAcceptableOrUnknown(
          data['cargo_place_idx']!,
          _cargoPlaceIdxMeta,
        ),
      );
    }
    if (data.containsKey('novotel_place_idx')) {
      context.handle(
        _novotelPlaceIdxMeta,
        novotelPlaceIdx.isAcceptableOrUnknown(
          data['novotel_place_idx']!,
          _novotelPlaceIdxMeta,
        ),
      );
    }
    if (data.containsKey('cabin_place_idx')) {
      context.handle(
        _cabinPlaceIdxMeta,
        cabinPlaceIdx.isAcceptableOrUnknown(
          data['cabin_place_idx']!,
          _cabinPlaceIdxMeta,
        ),
      );
    }
    if (data.containsKey('occ_arrived')) {
      context.handle(
        _occArrivedMeta,
        occArrived.isAcceptableOrUnknown(data['occ_arrived']!, _occArrivedMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('within10min')) {
      context.handle(
        _within10minMeta,
        within10min.isAcceptableOrUnknown(
          data['within10min']!,
          _within10minMeta,
        ),
      );
    }
    if (data.containsKey('reason_landing')) {
      context.handle(
        _reasonLandingMeta,
        reasonLanding.isAcceptableOrUnknown(
          data['reason_landing']!,
          _reasonLandingMeta,
        ),
      );
    }
    if (data.containsKey('reason_online')) {
      context.handle(
        _reasonOnlineMeta,
        reasonOnline.isAcceptableOrUnknown(
          data['reason_online']!,
          _reasonOnlineMeta,
        ),
      );
    }
    if (data.containsKey('reason_other')) {
      context.handle(
        _reasonOtherMeta,
        reasonOther.isAcceptableOrUnknown(
          data['reason_other']!,
          _reasonOtherMeta,
        ),
      );
    }
    if (data.containsKey('reason_other_text')) {
      context.handle(
        _reasonOtherTextMeta,
        reasonOtherText.isAcceptableOrUnknown(
          data['reason_other_text']!,
          _reasonOtherTextMeta,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccidentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccidentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      incidentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}incident_date'],
      ),
      notifyTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}notify_time'],
      ),
      pickUpTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pick_up_time'],
      ),
      medicArriveTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}medic_arrive_time'],
      ),
      ambulanceDepartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ambulance_depart_time'],
      ),
      checkTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_time'],
      ),
      landingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}landing_time'],
      ),
      reportUnitIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}report_unit_idx'],
      ),
      otherReportUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_report_unit'],
      ),
      notifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notifier'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      placeIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_idx'],
      ),
      placeNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_note'],
      ),
      t1PlaceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t1_place_idx'],
      ),
      t2PlaceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t2_place_idx'],
      ),
      remotePlaceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_place_idx'],
      ),
      cargoPlaceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cargo_place_idx'],
      ),
      novotelPlaceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}novotel_place_idx'],
      ),
      cabinPlaceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cabin_place_idx'],
      ),
      occArrived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}occ_arrived'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost'],
      ),
      within10min: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}within10min'],
      ),
      reasonLanding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reason_landing'],
      )!,
      reasonOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reason_online'],
      )!,
      reasonOther: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reason_other'],
      )!,
      reasonOtherText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_other_text'],
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
  $AccidentRecordsTable createAlias(String alias) {
    return $AccidentRecordsTable(attachedDatabase, alias);
  }
}

class AccidentRecord extends DataClass implements Insertable<AccidentRecord> {
  final int id;
  final int visitId;
  final DateTime? incidentDate;
  final DateTime? notifyTime;
  final DateTime? pickUpTime;
  final DateTime? medicArriveTime;
  final DateTime? ambulanceDepartTime;
  final DateTime? checkTime;
  final DateTime? landingTime;
  final int? reportUnitIdx;
  final String? otherReportUnit;
  final String? notifier;
  final String? phone;
  final int? placeIdx;
  final String? placeNote;
  final int? t1PlaceIdx;
  final int? t2PlaceIdx;
  final int? remotePlaceIdx;
  final int? cargoPlaceIdx;
  final int? novotelPlaceIdx;
  final int? cabinPlaceIdx;
  final bool occArrived;
  final String? cost;
  final int? within10min;
  final bool reasonLanding;
  final bool reasonOnline;
  final bool reasonOther;
  final String? reasonOtherText;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AccidentRecord({
    required this.id,
    required this.visitId,
    this.incidentDate,
    this.notifyTime,
    this.pickUpTime,
    this.medicArriveTime,
    this.ambulanceDepartTime,
    this.checkTime,
    this.landingTime,
    this.reportUnitIdx,
    this.otherReportUnit,
    this.notifier,
    this.phone,
    this.placeIdx,
    this.placeNote,
    this.t1PlaceIdx,
    this.t2PlaceIdx,
    this.remotePlaceIdx,
    this.cargoPlaceIdx,
    this.novotelPlaceIdx,
    this.cabinPlaceIdx,
    required this.occArrived,
    this.cost,
    this.within10min,
    required this.reasonLanding,
    required this.reasonOnline,
    required this.reasonOther,
    this.reasonOtherText,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['visit_id'] = Variable<int>(visitId);
    if (!nullToAbsent || incidentDate != null) {
      map['incident_date'] = Variable<DateTime>(incidentDate);
    }
    if (!nullToAbsent || notifyTime != null) {
      map['notify_time'] = Variable<DateTime>(notifyTime);
    }
    if (!nullToAbsent || pickUpTime != null) {
      map['pick_up_time'] = Variable<DateTime>(pickUpTime);
    }
    if (!nullToAbsent || medicArriveTime != null) {
      map['medic_arrive_time'] = Variable<DateTime>(medicArriveTime);
    }
    if (!nullToAbsent || ambulanceDepartTime != null) {
      map['ambulance_depart_time'] = Variable<DateTime>(ambulanceDepartTime);
    }
    if (!nullToAbsent || checkTime != null) {
      map['check_time'] = Variable<DateTime>(checkTime);
    }
    if (!nullToAbsent || landingTime != null) {
      map['landing_time'] = Variable<DateTime>(landingTime);
    }
    if (!nullToAbsent || reportUnitIdx != null) {
      map['report_unit_idx'] = Variable<int>(reportUnitIdx);
    }
    if (!nullToAbsent || otherReportUnit != null) {
      map['other_report_unit'] = Variable<String>(otherReportUnit);
    }
    if (!nullToAbsent || notifier != null) {
      map['notifier'] = Variable<String>(notifier);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || placeIdx != null) {
      map['place_idx'] = Variable<int>(placeIdx);
    }
    if (!nullToAbsent || placeNote != null) {
      map['place_note'] = Variable<String>(placeNote);
    }
    if (!nullToAbsent || t1PlaceIdx != null) {
      map['t1_place_idx'] = Variable<int>(t1PlaceIdx);
    }
    if (!nullToAbsent || t2PlaceIdx != null) {
      map['t2_place_idx'] = Variable<int>(t2PlaceIdx);
    }
    if (!nullToAbsent || remotePlaceIdx != null) {
      map['remote_place_idx'] = Variable<int>(remotePlaceIdx);
    }
    if (!nullToAbsent || cargoPlaceIdx != null) {
      map['cargo_place_idx'] = Variable<int>(cargoPlaceIdx);
    }
    if (!nullToAbsent || novotelPlaceIdx != null) {
      map['novotel_place_idx'] = Variable<int>(novotelPlaceIdx);
    }
    if (!nullToAbsent || cabinPlaceIdx != null) {
      map['cabin_place_idx'] = Variable<int>(cabinPlaceIdx);
    }
    map['occ_arrived'] = Variable<bool>(occArrived);
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<String>(cost);
    }
    if (!nullToAbsent || within10min != null) {
      map['within10min'] = Variable<int>(within10min);
    }
    map['reason_landing'] = Variable<bool>(reasonLanding);
    map['reason_online'] = Variable<bool>(reasonOnline);
    map['reason_other'] = Variable<bool>(reasonOther);
    if (!nullToAbsent || reasonOtherText != null) {
      map['reason_other_text'] = Variable<String>(reasonOtherText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccidentRecordsCompanion toCompanion(bool nullToAbsent) {
    return AccidentRecordsCompanion(
      id: Value(id),
      visitId: Value(visitId),
      incidentDate: incidentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(incidentDate),
      notifyTime: notifyTime == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyTime),
      pickUpTime: pickUpTime == null && nullToAbsent
          ? const Value.absent()
          : Value(pickUpTime),
      medicArriveTime: medicArriveTime == null && nullToAbsent
          ? const Value.absent()
          : Value(medicArriveTime),
      ambulanceDepartTime: ambulanceDepartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(ambulanceDepartTime),
      checkTime: checkTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkTime),
      landingTime: landingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(landingTime),
      reportUnitIdx: reportUnitIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(reportUnitIdx),
      otherReportUnit: otherReportUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(otherReportUnit),
      notifier: notifier == null && nullToAbsent
          ? const Value.absent()
          : Value(notifier),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      placeIdx: placeIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(placeIdx),
      placeNote: placeNote == null && nullToAbsent
          ? const Value.absent()
          : Value(placeNote),
      t1PlaceIdx: t1PlaceIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(t1PlaceIdx),
      t2PlaceIdx: t2PlaceIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(t2PlaceIdx),
      remotePlaceIdx: remotePlaceIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePlaceIdx),
      cargoPlaceIdx: cargoPlaceIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(cargoPlaceIdx),
      novotelPlaceIdx: novotelPlaceIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(novotelPlaceIdx),
      cabinPlaceIdx: cabinPlaceIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(cabinPlaceIdx),
      occArrived: Value(occArrived),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      within10min: within10min == null && nullToAbsent
          ? const Value.absent()
          : Value(within10min),
      reasonLanding: Value(reasonLanding),
      reasonOnline: Value(reasonOnline),
      reasonOther: Value(reasonOther),
      reasonOtherText: reasonOtherText == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonOtherText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccidentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccidentRecord(
      id: serializer.fromJson<int>(json['id']),
      visitId: serializer.fromJson<int>(json['visitId']),
      incidentDate: serializer.fromJson<DateTime?>(json['incidentDate']),
      notifyTime: serializer.fromJson<DateTime?>(json['notifyTime']),
      pickUpTime: serializer.fromJson<DateTime?>(json['pickUpTime']),
      medicArriveTime: serializer.fromJson<DateTime?>(json['medicArriveTime']),
      ambulanceDepartTime: serializer.fromJson<DateTime?>(
        json['ambulanceDepartTime'],
      ),
      checkTime: serializer.fromJson<DateTime?>(json['checkTime']),
      landingTime: serializer.fromJson<DateTime?>(json['landingTime']),
      reportUnitIdx: serializer.fromJson<int?>(json['reportUnitIdx']),
      otherReportUnit: serializer.fromJson<String?>(json['otherReportUnit']),
      notifier: serializer.fromJson<String?>(json['notifier']),
      phone: serializer.fromJson<String?>(json['phone']),
      placeIdx: serializer.fromJson<int?>(json['placeIdx']),
      placeNote: serializer.fromJson<String?>(json['placeNote']),
      t1PlaceIdx: serializer.fromJson<int?>(json['t1PlaceIdx']),
      t2PlaceIdx: serializer.fromJson<int?>(json['t2PlaceIdx']),
      remotePlaceIdx: serializer.fromJson<int?>(json['remotePlaceIdx']),
      cargoPlaceIdx: serializer.fromJson<int?>(json['cargoPlaceIdx']),
      novotelPlaceIdx: serializer.fromJson<int?>(json['novotelPlaceIdx']),
      cabinPlaceIdx: serializer.fromJson<int?>(json['cabinPlaceIdx']),
      occArrived: serializer.fromJson<bool>(json['occArrived']),
      cost: serializer.fromJson<String?>(json['cost']),
      within10min: serializer.fromJson<int?>(json['within10min']),
      reasonLanding: serializer.fromJson<bool>(json['reasonLanding']),
      reasonOnline: serializer.fromJson<bool>(json['reasonOnline']),
      reasonOther: serializer.fromJson<bool>(json['reasonOther']),
      reasonOtherText: serializer.fromJson<String?>(json['reasonOtherText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'visitId': serializer.toJson<int>(visitId),
      'incidentDate': serializer.toJson<DateTime?>(incidentDate),
      'notifyTime': serializer.toJson<DateTime?>(notifyTime),
      'pickUpTime': serializer.toJson<DateTime?>(pickUpTime),
      'medicArriveTime': serializer.toJson<DateTime?>(medicArriveTime),
      'ambulanceDepartTime': serializer.toJson<DateTime?>(ambulanceDepartTime),
      'checkTime': serializer.toJson<DateTime?>(checkTime),
      'landingTime': serializer.toJson<DateTime?>(landingTime),
      'reportUnitIdx': serializer.toJson<int?>(reportUnitIdx),
      'otherReportUnit': serializer.toJson<String?>(otherReportUnit),
      'notifier': serializer.toJson<String?>(notifier),
      'phone': serializer.toJson<String?>(phone),
      'placeIdx': serializer.toJson<int?>(placeIdx),
      'placeNote': serializer.toJson<String?>(placeNote),
      't1PlaceIdx': serializer.toJson<int?>(t1PlaceIdx),
      't2PlaceIdx': serializer.toJson<int?>(t2PlaceIdx),
      'remotePlaceIdx': serializer.toJson<int?>(remotePlaceIdx),
      'cargoPlaceIdx': serializer.toJson<int?>(cargoPlaceIdx),
      'novotelPlaceIdx': serializer.toJson<int?>(novotelPlaceIdx),
      'cabinPlaceIdx': serializer.toJson<int?>(cabinPlaceIdx),
      'occArrived': serializer.toJson<bool>(occArrived),
      'cost': serializer.toJson<String?>(cost),
      'within10min': serializer.toJson<int?>(within10min),
      'reasonLanding': serializer.toJson<bool>(reasonLanding),
      'reasonOnline': serializer.toJson<bool>(reasonOnline),
      'reasonOther': serializer.toJson<bool>(reasonOther),
      'reasonOtherText': serializer.toJson<String?>(reasonOtherText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AccidentRecord copyWith({
    int? id,
    int? visitId,
    Value<DateTime?> incidentDate = const Value.absent(),
    Value<DateTime?> notifyTime = const Value.absent(),
    Value<DateTime?> pickUpTime = const Value.absent(),
    Value<DateTime?> medicArriveTime = const Value.absent(),
    Value<DateTime?> ambulanceDepartTime = const Value.absent(),
    Value<DateTime?> checkTime = const Value.absent(),
    Value<DateTime?> landingTime = const Value.absent(),
    Value<int?> reportUnitIdx = const Value.absent(),
    Value<String?> otherReportUnit = const Value.absent(),
    Value<String?> notifier = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<int?> placeIdx = const Value.absent(),
    Value<String?> placeNote = const Value.absent(),
    Value<int?> t1PlaceIdx = const Value.absent(),
    Value<int?> t2PlaceIdx = const Value.absent(),
    Value<int?> remotePlaceIdx = const Value.absent(),
    Value<int?> cargoPlaceIdx = const Value.absent(),
    Value<int?> novotelPlaceIdx = const Value.absent(),
    Value<int?> cabinPlaceIdx = const Value.absent(),
    bool? occArrived,
    Value<String?> cost = const Value.absent(),
    Value<int?> within10min = const Value.absent(),
    bool? reasonLanding,
    bool? reasonOnline,
    bool? reasonOther,
    Value<String?> reasonOtherText = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AccidentRecord(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    incidentDate: incidentDate.present ? incidentDate.value : this.incidentDate,
    notifyTime: notifyTime.present ? notifyTime.value : this.notifyTime,
    pickUpTime: pickUpTime.present ? pickUpTime.value : this.pickUpTime,
    medicArriveTime: medicArriveTime.present
        ? medicArriveTime.value
        : this.medicArriveTime,
    ambulanceDepartTime: ambulanceDepartTime.present
        ? ambulanceDepartTime.value
        : this.ambulanceDepartTime,
    checkTime: checkTime.present ? checkTime.value : this.checkTime,
    landingTime: landingTime.present ? landingTime.value : this.landingTime,
    reportUnitIdx: reportUnitIdx.present
        ? reportUnitIdx.value
        : this.reportUnitIdx,
    otherReportUnit: otherReportUnit.present
        ? otherReportUnit.value
        : this.otherReportUnit,
    notifier: notifier.present ? notifier.value : this.notifier,
    phone: phone.present ? phone.value : this.phone,
    placeIdx: placeIdx.present ? placeIdx.value : this.placeIdx,
    placeNote: placeNote.present ? placeNote.value : this.placeNote,
    t1PlaceIdx: t1PlaceIdx.present ? t1PlaceIdx.value : this.t1PlaceIdx,
    t2PlaceIdx: t2PlaceIdx.present ? t2PlaceIdx.value : this.t2PlaceIdx,
    remotePlaceIdx: remotePlaceIdx.present
        ? remotePlaceIdx.value
        : this.remotePlaceIdx,
    cargoPlaceIdx: cargoPlaceIdx.present
        ? cargoPlaceIdx.value
        : this.cargoPlaceIdx,
    novotelPlaceIdx: novotelPlaceIdx.present
        ? novotelPlaceIdx.value
        : this.novotelPlaceIdx,
    cabinPlaceIdx: cabinPlaceIdx.present
        ? cabinPlaceIdx.value
        : this.cabinPlaceIdx,
    occArrived: occArrived ?? this.occArrived,
    cost: cost.present ? cost.value : this.cost,
    within10min: within10min.present ? within10min.value : this.within10min,
    reasonLanding: reasonLanding ?? this.reasonLanding,
    reasonOnline: reasonOnline ?? this.reasonOnline,
    reasonOther: reasonOther ?? this.reasonOther,
    reasonOtherText: reasonOtherText.present
        ? reasonOtherText.value
        : this.reasonOtherText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccidentRecord copyWithCompanion(AccidentRecordsCompanion data) {
    return AccidentRecord(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      incidentDate: data.incidentDate.present
          ? data.incidentDate.value
          : this.incidentDate,
      notifyTime: data.notifyTime.present
          ? data.notifyTime.value
          : this.notifyTime,
      pickUpTime: data.pickUpTime.present
          ? data.pickUpTime.value
          : this.pickUpTime,
      medicArriveTime: data.medicArriveTime.present
          ? data.medicArriveTime.value
          : this.medicArriveTime,
      ambulanceDepartTime: data.ambulanceDepartTime.present
          ? data.ambulanceDepartTime.value
          : this.ambulanceDepartTime,
      checkTime: data.checkTime.present ? data.checkTime.value : this.checkTime,
      landingTime: data.landingTime.present
          ? data.landingTime.value
          : this.landingTime,
      reportUnitIdx: data.reportUnitIdx.present
          ? data.reportUnitIdx.value
          : this.reportUnitIdx,
      otherReportUnit: data.otherReportUnit.present
          ? data.otherReportUnit.value
          : this.otherReportUnit,
      notifier: data.notifier.present ? data.notifier.value : this.notifier,
      phone: data.phone.present ? data.phone.value : this.phone,
      placeIdx: data.placeIdx.present ? data.placeIdx.value : this.placeIdx,
      placeNote: data.placeNote.present ? data.placeNote.value : this.placeNote,
      t1PlaceIdx: data.t1PlaceIdx.present
          ? data.t1PlaceIdx.value
          : this.t1PlaceIdx,
      t2PlaceIdx: data.t2PlaceIdx.present
          ? data.t2PlaceIdx.value
          : this.t2PlaceIdx,
      remotePlaceIdx: data.remotePlaceIdx.present
          ? data.remotePlaceIdx.value
          : this.remotePlaceIdx,
      cargoPlaceIdx: data.cargoPlaceIdx.present
          ? data.cargoPlaceIdx.value
          : this.cargoPlaceIdx,
      novotelPlaceIdx: data.novotelPlaceIdx.present
          ? data.novotelPlaceIdx.value
          : this.novotelPlaceIdx,
      cabinPlaceIdx: data.cabinPlaceIdx.present
          ? data.cabinPlaceIdx.value
          : this.cabinPlaceIdx,
      occArrived: data.occArrived.present
          ? data.occArrived.value
          : this.occArrived,
      cost: data.cost.present ? data.cost.value : this.cost,
      within10min: data.within10min.present
          ? data.within10min.value
          : this.within10min,
      reasonLanding: data.reasonLanding.present
          ? data.reasonLanding.value
          : this.reasonLanding,
      reasonOnline: data.reasonOnline.present
          ? data.reasonOnline.value
          : this.reasonOnline,
      reasonOther: data.reasonOther.present
          ? data.reasonOther.value
          : this.reasonOther,
      reasonOtherText: data.reasonOtherText.present
          ? data.reasonOtherText.value
          : this.reasonOtherText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccidentRecord(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('incidentDate: $incidentDate, ')
          ..write('notifyTime: $notifyTime, ')
          ..write('pickUpTime: $pickUpTime, ')
          ..write('medicArriveTime: $medicArriveTime, ')
          ..write('ambulanceDepartTime: $ambulanceDepartTime, ')
          ..write('checkTime: $checkTime, ')
          ..write('landingTime: $landingTime, ')
          ..write('reportUnitIdx: $reportUnitIdx, ')
          ..write('otherReportUnit: $otherReportUnit, ')
          ..write('notifier: $notifier, ')
          ..write('phone: $phone, ')
          ..write('placeIdx: $placeIdx, ')
          ..write('placeNote: $placeNote, ')
          ..write('t1PlaceIdx: $t1PlaceIdx, ')
          ..write('t2PlaceIdx: $t2PlaceIdx, ')
          ..write('remotePlaceIdx: $remotePlaceIdx, ')
          ..write('cargoPlaceIdx: $cargoPlaceIdx, ')
          ..write('novotelPlaceIdx: $novotelPlaceIdx, ')
          ..write('cabinPlaceIdx: $cabinPlaceIdx, ')
          ..write('occArrived: $occArrived, ')
          ..write('cost: $cost, ')
          ..write('within10min: $within10min, ')
          ..write('reasonLanding: $reasonLanding, ')
          ..write('reasonOnline: $reasonOnline, ')
          ..write('reasonOther: $reasonOther, ')
          ..write('reasonOtherText: $reasonOtherText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    visitId,
    incidentDate,
    notifyTime,
    pickUpTime,
    medicArriveTime,
    ambulanceDepartTime,
    checkTime,
    landingTime,
    reportUnitIdx,
    otherReportUnit,
    notifier,
    phone,
    placeIdx,
    placeNote,
    t1PlaceIdx,
    t2PlaceIdx,
    remotePlaceIdx,
    cargoPlaceIdx,
    novotelPlaceIdx,
    cabinPlaceIdx,
    occArrived,
    cost,
    within10min,
    reasonLanding,
    reasonOnline,
    reasonOther,
    reasonOtherText,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccidentRecord &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.incidentDate == this.incidentDate &&
          other.notifyTime == this.notifyTime &&
          other.pickUpTime == this.pickUpTime &&
          other.medicArriveTime == this.medicArriveTime &&
          other.ambulanceDepartTime == this.ambulanceDepartTime &&
          other.checkTime == this.checkTime &&
          other.landingTime == this.landingTime &&
          other.reportUnitIdx == this.reportUnitIdx &&
          other.otherReportUnit == this.otherReportUnit &&
          other.notifier == this.notifier &&
          other.phone == this.phone &&
          other.placeIdx == this.placeIdx &&
          other.placeNote == this.placeNote &&
          other.t1PlaceIdx == this.t1PlaceIdx &&
          other.t2PlaceIdx == this.t2PlaceIdx &&
          other.remotePlaceIdx == this.remotePlaceIdx &&
          other.cargoPlaceIdx == this.cargoPlaceIdx &&
          other.novotelPlaceIdx == this.novotelPlaceIdx &&
          other.cabinPlaceIdx == this.cabinPlaceIdx &&
          other.occArrived == this.occArrived &&
          other.cost == this.cost &&
          other.within10min == this.within10min &&
          other.reasonLanding == this.reasonLanding &&
          other.reasonOnline == this.reasonOnline &&
          other.reasonOther == this.reasonOther &&
          other.reasonOtherText == this.reasonOtherText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccidentRecordsCompanion extends UpdateCompanion<AccidentRecord> {
  final Value<int> id;
  final Value<int> visitId;
  final Value<DateTime?> incidentDate;
  final Value<DateTime?> notifyTime;
  final Value<DateTime?> pickUpTime;
  final Value<DateTime?> medicArriveTime;
  final Value<DateTime?> ambulanceDepartTime;
  final Value<DateTime?> checkTime;
  final Value<DateTime?> landingTime;
  final Value<int?> reportUnitIdx;
  final Value<String?> otherReportUnit;
  final Value<String?> notifier;
  final Value<String?> phone;
  final Value<int?> placeIdx;
  final Value<String?> placeNote;
  final Value<int?> t1PlaceIdx;
  final Value<int?> t2PlaceIdx;
  final Value<int?> remotePlaceIdx;
  final Value<int?> cargoPlaceIdx;
  final Value<int?> novotelPlaceIdx;
  final Value<int?> cabinPlaceIdx;
  final Value<bool> occArrived;
  final Value<String?> cost;
  final Value<int?> within10min;
  final Value<bool> reasonLanding;
  final Value<bool> reasonOnline;
  final Value<bool> reasonOther;
  final Value<String?> reasonOtherText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AccidentRecordsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.incidentDate = const Value.absent(),
    this.notifyTime = const Value.absent(),
    this.pickUpTime = const Value.absent(),
    this.medicArriveTime = const Value.absent(),
    this.ambulanceDepartTime = const Value.absent(),
    this.checkTime = const Value.absent(),
    this.landingTime = const Value.absent(),
    this.reportUnitIdx = const Value.absent(),
    this.otherReportUnit = const Value.absent(),
    this.notifier = const Value.absent(),
    this.phone = const Value.absent(),
    this.placeIdx = const Value.absent(),
    this.placeNote = const Value.absent(),
    this.t1PlaceIdx = const Value.absent(),
    this.t2PlaceIdx = const Value.absent(),
    this.remotePlaceIdx = const Value.absent(),
    this.cargoPlaceIdx = const Value.absent(),
    this.novotelPlaceIdx = const Value.absent(),
    this.cabinPlaceIdx = const Value.absent(),
    this.occArrived = const Value.absent(),
    this.cost = const Value.absent(),
    this.within10min = const Value.absent(),
    this.reasonLanding = const Value.absent(),
    this.reasonOnline = const Value.absent(),
    this.reasonOther = const Value.absent(),
    this.reasonOtherText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccidentRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int visitId,
    this.incidentDate = const Value.absent(),
    this.notifyTime = const Value.absent(),
    this.pickUpTime = const Value.absent(),
    this.medicArriveTime = const Value.absent(),
    this.ambulanceDepartTime = const Value.absent(),
    this.checkTime = const Value.absent(),
    this.landingTime = const Value.absent(),
    this.reportUnitIdx = const Value.absent(),
    this.otherReportUnit = const Value.absent(),
    this.notifier = const Value.absent(),
    this.phone = const Value.absent(),
    this.placeIdx = const Value.absent(),
    this.placeNote = const Value.absent(),
    this.t1PlaceIdx = const Value.absent(),
    this.t2PlaceIdx = const Value.absent(),
    this.remotePlaceIdx = const Value.absent(),
    this.cargoPlaceIdx = const Value.absent(),
    this.novotelPlaceIdx = const Value.absent(),
    this.cabinPlaceIdx = const Value.absent(),
    this.occArrived = const Value.absent(),
    this.cost = const Value.absent(),
    this.within10min = const Value.absent(),
    this.reasonLanding = const Value.absent(),
    this.reasonOnline = const Value.absent(),
    this.reasonOther = const Value.absent(),
    this.reasonOtherText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : visitId = Value(visitId);
  static Insertable<AccidentRecord> custom({
    Expression<int>? id,
    Expression<int>? visitId,
    Expression<DateTime>? incidentDate,
    Expression<DateTime>? notifyTime,
    Expression<DateTime>? pickUpTime,
    Expression<DateTime>? medicArriveTime,
    Expression<DateTime>? ambulanceDepartTime,
    Expression<DateTime>? checkTime,
    Expression<DateTime>? landingTime,
    Expression<int>? reportUnitIdx,
    Expression<String>? otherReportUnit,
    Expression<String>? notifier,
    Expression<String>? phone,
    Expression<int>? placeIdx,
    Expression<String>? placeNote,
    Expression<int>? t1PlaceIdx,
    Expression<int>? t2PlaceIdx,
    Expression<int>? remotePlaceIdx,
    Expression<int>? cargoPlaceIdx,
    Expression<int>? novotelPlaceIdx,
    Expression<int>? cabinPlaceIdx,
    Expression<bool>? occArrived,
    Expression<String>? cost,
    Expression<int>? within10min,
    Expression<bool>? reasonLanding,
    Expression<bool>? reasonOnline,
    Expression<bool>? reasonOther,
    Expression<String>? reasonOtherText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (incidentDate != null) 'incident_date': incidentDate,
      if (notifyTime != null) 'notify_time': notifyTime,
      if (pickUpTime != null) 'pick_up_time': pickUpTime,
      if (medicArriveTime != null) 'medic_arrive_time': medicArriveTime,
      if (ambulanceDepartTime != null)
        'ambulance_depart_time': ambulanceDepartTime,
      if (checkTime != null) 'check_time': checkTime,
      if (landingTime != null) 'landing_time': landingTime,
      if (reportUnitIdx != null) 'report_unit_idx': reportUnitIdx,
      if (otherReportUnit != null) 'other_report_unit': otherReportUnit,
      if (notifier != null) 'notifier': notifier,
      if (phone != null) 'phone': phone,
      if (placeIdx != null) 'place_idx': placeIdx,
      if (placeNote != null) 'place_note': placeNote,
      if (t1PlaceIdx != null) 't1_place_idx': t1PlaceIdx,
      if (t2PlaceIdx != null) 't2_place_idx': t2PlaceIdx,
      if (remotePlaceIdx != null) 'remote_place_idx': remotePlaceIdx,
      if (cargoPlaceIdx != null) 'cargo_place_idx': cargoPlaceIdx,
      if (novotelPlaceIdx != null) 'novotel_place_idx': novotelPlaceIdx,
      if (cabinPlaceIdx != null) 'cabin_place_idx': cabinPlaceIdx,
      if (occArrived != null) 'occ_arrived': occArrived,
      if (cost != null) 'cost': cost,
      if (within10min != null) 'within10min': within10min,
      if (reasonLanding != null) 'reason_landing': reasonLanding,
      if (reasonOnline != null) 'reason_online': reasonOnline,
      if (reasonOther != null) 'reason_other': reasonOther,
      if (reasonOtherText != null) 'reason_other_text': reasonOtherText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccidentRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? visitId,
    Value<DateTime?>? incidentDate,
    Value<DateTime?>? notifyTime,
    Value<DateTime?>? pickUpTime,
    Value<DateTime?>? medicArriveTime,
    Value<DateTime?>? ambulanceDepartTime,
    Value<DateTime?>? checkTime,
    Value<DateTime?>? landingTime,
    Value<int?>? reportUnitIdx,
    Value<String?>? otherReportUnit,
    Value<String?>? notifier,
    Value<String?>? phone,
    Value<int?>? placeIdx,
    Value<String?>? placeNote,
    Value<int?>? t1PlaceIdx,
    Value<int?>? t2PlaceIdx,
    Value<int?>? remotePlaceIdx,
    Value<int?>? cargoPlaceIdx,
    Value<int?>? novotelPlaceIdx,
    Value<int?>? cabinPlaceIdx,
    Value<bool>? occArrived,
    Value<String?>? cost,
    Value<int?>? within10min,
    Value<bool>? reasonLanding,
    Value<bool>? reasonOnline,
    Value<bool>? reasonOther,
    Value<String?>? reasonOtherText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AccidentRecordsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      incidentDate: incidentDate ?? this.incidentDate,
      notifyTime: notifyTime ?? this.notifyTime,
      pickUpTime: pickUpTime ?? this.pickUpTime,
      medicArriveTime: medicArriveTime ?? this.medicArriveTime,
      ambulanceDepartTime: ambulanceDepartTime ?? this.ambulanceDepartTime,
      checkTime: checkTime ?? this.checkTime,
      landingTime: landingTime ?? this.landingTime,
      reportUnitIdx: reportUnitIdx ?? this.reportUnitIdx,
      otherReportUnit: otherReportUnit ?? this.otherReportUnit,
      notifier: notifier ?? this.notifier,
      phone: phone ?? this.phone,
      placeIdx: placeIdx ?? this.placeIdx,
      placeNote: placeNote ?? this.placeNote,
      t1PlaceIdx: t1PlaceIdx ?? this.t1PlaceIdx,
      t2PlaceIdx: t2PlaceIdx ?? this.t2PlaceIdx,
      remotePlaceIdx: remotePlaceIdx ?? this.remotePlaceIdx,
      cargoPlaceIdx: cargoPlaceIdx ?? this.cargoPlaceIdx,
      novotelPlaceIdx: novotelPlaceIdx ?? this.novotelPlaceIdx,
      cabinPlaceIdx: cabinPlaceIdx ?? this.cabinPlaceIdx,
      occArrived: occArrived ?? this.occArrived,
      cost: cost ?? this.cost,
      within10min: within10min ?? this.within10min,
      reasonLanding: reasonLanding ?? this.reasonLanding,
      reasonOnline: reasonOnline ?? this.reasonOnline,
      reasonOther: reasonOther ?? this.reasonOther,
      reasonOtherText: reasonOtherText ?? this.reasonOtherText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (incidentDate.present) {
      map['incident_date'] = Variable<DateTime>(incidentDate.value);
    }
    if (notifyTime.present) {
      map['notify_time'] = Variable<DateTime>(notifyTime.value);
    }
    if (pickUpTime.present) {
      map['pick_up_time'] = Variable<DateTime>(pickUpTime.value);
    }
    if (medicArriveTime.present) {
      map['medic_arrive_time'] = Variable<DateTime>(medicArriveTime.value);
    }
    if (ambulanceDepartTime.present) {
      map['ambulance_depart_time'] = Variable<DateTime>(
        ambulanceDepartTime.value,
      );
    }
    if (checkTime.present) {
      map['check_time'] = Variable<DateTime>(checkTime.value);
    }
    if (landingTime.present) {
      map['landing_time'] = Variable<DateTime>(landingTime.value);
    }
    if (reportUnitIdx.present) {
      map['report_unit_idx'] = Variable<int>(reportUnitIdx.value);
    }
    if (otherReportUnit.present) {
      map['other_report_unit'] = Variable<String>(otherReportUnit.value);
    }
    if (notifier.present) {
      map['notifier'] = Variable<String>(notifier.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (placeIdx.present) {
      map['place_idx'] = Variable<int>(placeIdx.value);
    }
    if (placeNote.present) {
      map['place_note'] = Variable<String>(placeNote.value);
    }
    if (t1PlaceIdx.present) {
      map['t1_place_idx'] = Variable<int>(t1PlaceIdx.value);
    }
    if (t2PlaceIdx.present) {
      map['t2_place_idx'] = Variable<int>(t2PlaceIdx.value);
    }
    if (remotePlaceIdx.present) {
      map['remote_place_idx'] = Variable<int>(remotePlaceIdx.value);
    }
    if (cargoPlaceIdx.present) {
      map['cargo_place_idx'] = Variable<int>(cargoPlaceIdx.value);
    }
    if (novotelPlaceIdx.present) {
      map['novotel_place_idx'] = Variable<int>(novotelPlaceIdx.value);
    }
    if (cabinPlaceIdx.present) {
      map['cabin_place_idx'] = Variable<int>(cabinPlaceIdx.value);
    }
    if (occArrived.present) {
      map['occ_arrived'] = Variable<bool>(occArrived.value);
    }
    if (cost.present) {
      map['cost'] = Variable<String>(cost.value);
    }
    if (within10min.present) {
      map['within10min'] = Variable<int>(within10min.value);
    }
    if (reasonLanding.present) {
      map['reason_landing'] = Variable<bool>(reasonLanding.value);
    }
    if (reasonOnline.present) {
      map['reason_online'] = Variable<bool>(reasonOnline.value);
    }
    if (reasonOther.present) {
      map['reason_other'] = Variable<bool>(reasonOther.value);
    }
    if (reasonOtherText.present) {
      map['reason_other_text'] = Variable<String>(reasonOtherText.value);
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
    return (StringBuffer('AccidentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('incidentDate: $incidentDate, ')
          ..write('notifyTime: $notifyTime, ')
          ..write('pickUpTime: $pickUpTime, ')
          ..write('medicArriveTime: $medicArriveTime, ')
          ..write('ambulanceDepartTime: $ambulanceDepartTime, ')
          ..write('checkTime: $checkTime, ')
          ..write('landingTime: $landingTime, ')
          ..write('reportUnitIdx: $reportUnitIdx, ')
          ..write('otherReportUnit: $otherReportUnit, ')
          ..write('notifier: $notifier, ')
          ..write('phone: $phone, ')
          ..write('placeIdx: $placeIdx, ')
          ..write('placeNote: $placeNote, ')
          ..write('t1PlaceIdx: $t1PlaceIdx, ')
          ..write('t2PlaceIdx: $t2PlaceIdx, ')
          ..write('remotePlaceIdx: $remotePlaceIdx, ')
          ..write('cargoPlaceIdx: $cargoPlaceIdx, ')
          ..write('novotelPlaceIdx: $novotelPlaceIdx, ')
          ..write('cabinPlaceIdx: $cabinPlaceIdx, ')
          ..write('occArrived: $occArrived, ')
          ..write('cost: $cost, ')
          ..write('within10min: $within10min, ')
          ..write('reasonLanding: $reasonLanding, ')
          ..write('reasonOnline: $reasonOnline, ')
          ..write('reasonOther: $reasonOther, ')
          ..write('reasonOtherText: $reasonOtherText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FlightLogsTable extends FlightLogs
    with TableInfo<$FlightLogsTable, FlightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _airlineIndexMeta = const VerificationMeta(
    'airlineIndex',
  );
  @override
  late final GeneratedColumn<int> airlineIndex = GeneratedColumn<int>(
    'airline_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _useOtherAirlineMeta = const VerificationMeta(
    'useOtherAirline',
  );
  @override
  late final GeneratedColumn<bool> useOtherAirline = GeneratedColumn<bool>(
    'use_other_airline',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_other_airline" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _otherAirlineMeta = const VerificationMeta(
    'otherAirline',
  );
  @override
  late final GeneratedColumn<String> otherAirline = GeneratedColumn<String>(
    'other_airline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flightNoMeta = const VerificationMeta(
    'flightNo',
  );
  @override
  late final GeneratedColumn<String> flightNo = GeneratedColumn<String>(
    'flight_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _travelStatusIndexMeta = const VerificationMeta(
    'travelStatusIndex',
  );
  @override
  late final GeneratedColumn<int> travelStatusIndex = GeneratedColumn<int>(
    'travel_status_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherTravelStatusMeta = const VerificationMeta(
    'otherTravelStatus',
  );
  @override
  late final GeneratedColumn<String> otherTravelStatus =
      GeneratedColumn<String>(
        'other_travel_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _departureMeta = const VerificationMeta(
    'departure',
  );
  @override
  late final GeneratedColumn<String> departure = GeneratedColumn<String>(
    'departure',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _viaMeta = const VerificationMeta('via');
  @override
  late final GeneratedColumn<String> via = GeneratedColumn<String>(
    'via',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    id,
    visitId,
    airlineIndex,
    useOtherAirline,
    otherAirline,
    flightNo,
    travelStatusIndex,
    otherTravelStatus,
    departure,
    via,
    destination,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('airline_index')) {
      context.handle(
        _airlineIndexMeta,
        airlineIndex.isAcceptableOrUnknown(
          data['airline_index']!,
          _airlineIndexMeta,
        ),
      );
    }
    if (data.containsKey('use_other_airline')) {
      context.handle(
        _useOtherAirlineMeta,
        useOtherAirline.isAcceptableOrUnknown(
          data['use_other_airline']!,
          _useOtherAirlineMeta,
        ),
      );
    }
    if (data.containsKey('other_airline')) {
      context.handle(
        _otherAirlineMeta,
        otherAirline.isAcceptableOrUnknown(
          data['other_airline']!,
          _otherAirlineMeta,
        ),
      );
    }
    if (data.containsKey('flight_no')) {
      context.handle(
        _flightNoMeta,
        flightNo.isAcceptableOrUnknown(data['flight_no']!, _flightNoMeta),
      );
    }
    if (data.containsKey('travel_status_index')) {
      context.handle(
        _travelStatusIndexMeta,
        travelStatusIndex.isAcceptableOrUnknown(
          data['travel_status_index']!,
          _travelStatusIndexMeta,
        ),
      );
    }
    if (data.containsKey('other_travel_status')) {
      context.handle(
        _otherTravelStatusMeta,
        otherTravelStatus.isAcceptableOrUnknown(
          data['other_travel_status']!,
          _otherTravelStatusMeta,
        ),
      );
    }
    if (data.containsKey('departure')) {
      context.handle(
        _departureMeta,
        departure.isAcceptableOrUnknown(data['departure']!, _departureMeta),
      );
    }
    if (data.containsKey('via')) {
      context.handle(
        _viaMeta,
        via.isAcceptableOrUnknown(data['via']!, _viaMeta),
      );
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      airlineIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}airline_index'],
      ),
      useOtherAirline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_other_airline'],
      )!,
      otherAirline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_airline'],
      ),
      flightNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flight_no'],
      ),
      travelStatusIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travel_status_index'],
      ),
      otherTravelStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_travel_status'],
      ),
      departure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure'],
      ),
      via: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}via'],
      ),
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FlightLogsTable createAlias(String alias) {
    return $FlightLogsTable(attachedDatabase, alias);
  }
}

class FlightLog extends DataClass implements Insertable<FlightLog> {
  final int id;
  final int visitId;
  final int? airlineIndex;
  final bool useOtherAirline;
  final String? otherAirline;
  final String? flightNo;
  final int? travelStatusIndex;
  final String? otherTravelStatus;
  final String? departure;
  final String? via;
  final String? destination;
  final DateTime updatedAt;
  const FlightLog({
    required this.id,
    required this.visitId,
    this.airlineIndex,
    required this.useOtherAirline,
    this.otherAirline,
    this.flightNo,
    this.travelStatusIndex,
    this.otherTravelStatus,
    this.departure,
    this.via,
    this.destination,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['visit_id'] = Variable<int>(visitId);
    if (!nullToAbsent || airlineIndex != null) {
      map['airline_index'] = Variable<int>(airlineIndex);
    }
    map['use_other_airline'] = Variable<bool>(useOtherAirline);
    if (!nullToAbsent || otherAirline != null) {
      map['other_airline'] = Variable<String>(otherAirline);
    }
    if (!nullToAbsent || flightNo != null) {
      map['flight_no'] = Variable<String>(flightNo);
    }
    if (!nullToAbsent || travelStatusIndex != null) {
      map['travel_status_index'] = Variable<int>(travelStatusIndex);
    }
    if (!nullToAbsent || otherTravelStatus != null) {
      map['other_travel_status'] = Variable<String>(otherTravelStatus);
    }
    if (!nullToAbsent || departure != null) {
      map['departure'] = Variable<String>(departure);
    }
    if (!nullToAbsent || via != null) {
      map['via'] = Variable<String>(via);
    }
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FlightLogsCompanion toCompanion(bool nullToAbsent) {
    return FlightLogsCompanion(
      id: Value(id),
      visitId: Value(visitId),
      airlineIndex: airlineIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(airlineIndex),
      useOtherAirline: Value(useOtherAirline),
      otherAirline: otherAirline == null && nullToAbsent
          ? const Value.absent()
          : Value(otherAirline),
      flightNo: flightNo == null && nullToAbsent
          ? const Value.absent()
          : Value(flightNo),
      travelStatusIndex: travelStatusIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(travelStatusIndex),
      otherTravelStatus: otherTravelStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(otherTravelStatus),
      departure: departure == null && nullToAbsent
          ? const Value.absent()
          : Value(departure),
      via: via == null && nullToAbsent ? const Value.absent() : Value(via),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      updatedAt: Value(updatedAt),
    );
  }

  factory FlightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlightLog(
      id: serializer.fromJson<int>(json['id']),
      visitId: serializer.fromJson<int>(json['visitId']),
      airlineIndex: serializer.fromJson<int?>(json['airlineIndex']),
      useOtherAirline: serializer.fromJson<bool>(json['useOtherAirline']),
      otherAirline: serializer.fromJson<String?>(json['otherAirline']),
      flightNo: serializer.fromJson<String?>(json['flightNo']),
      travelStatusIndex: serializer.fromJson<int?>(json['travelStatusIndex']),
      otherTravelStatus: serializer.fromJson<String?>(
        json['otherTravelStatus'],
      ),
      departure: serializer.fromJson<String?>(json['departure']),
      via: serializer.fromJson<String?>(json['via']),
      destination: serializer.fromJson<String?>(json['destination']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'visitId': serializer.toJson<int>(visitId),
      'airlineIndex': serializer.toJson<int?>(airlineIndex),
      'useOtherAirline': serializer.toJson<bool>(useOtherAirline),
      'otherAirline': serializer.toJson<String?>(otherAirline),
      'flightNo': serializer.toJson<String?>(flightNo),
      'travelStatusIndex': serializer.toJson<int?>(travelStatusIndex),
      'otherTravelStatus': serializer.toJson<String?>(otherTravelStatus),
      'departure': serializer.toJson<String?>(departure),
      'via': serializer.toJson<String?>(via),
      'destination': serializer.toJson<String?>(destination),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FlightLog copyWith({
    int? id,
    int? visitId,
    Value<int?> airlineIndex = const Value.absent(),
    bool? useOtherAirline,
    Value<String?> otherAirline = const Value.absent(),
    Value<String?> flightNo = const Value.absent(),
    Value<int?> travelStatusIndex = const Value.absent(),
    Value<String?> otherTravelStatus = const Value.absent(),
    Value<String?> departure = const Value.absent(),
    Value<String?> via = const Value.absent(),
    Value<String?> destination = const Value.absent(),
    DateTime? updatedAt,
  }) => FlightLog(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    airlineIndex: airlineIndex.present ? airlineIndex.value : this.airlineIndex,
    useOtherAirline: useOtherAirline ?? this.useOtherAirline,
    otherAirline: otherAirline.present ? otherAirline.value : this.otherAirline,
    flightNo: flightNo.present ? flightNo.value : this.flightNo,
    travelStatusIndex: travelStatusIndex.present
        ? travelStatusIndex.value
        : this.travelStatusIndex,
    otherTravelStatus: otherTravelStatus.present
        ? otherTravelStatus.value
        : this.otherTravelStatus,
    departure: departure.present ? departure.value : this.departure,
    via: via.present ? via.value : this.via,
    destination: destination.present ? destination.value : this.destination,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FlightLog copyWithCompanion(FlightLogsCompanion data) {
    return FlightLog(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      airlineIndex: data.airlineIndex.present
          ? data.airlineIndex.value
          : this.airlineIndex,
      useOtherAirline: data.useOtherAirline.present
          ? data.useOtherAirline.value
          : this.useOtherAirline,
      otherAirline: data.otherAirline.present
          ? data.otherAirline.value
          : this.otherAirline,
      flightNo: data.flightNo.present ? data.flightNo.value : this.flightNo,
      travelStatusIndex: data.travelStatusIndex.present
          ? data.travelStatusIndex.value
          : this.travelStatusIndex,
      otherTravelStatus: data.otherTravelStatus.present
          ? data.otherTravelStatus.value
          : this.otherTravelStatus,
      departure: data.departure.present ? data.departure.value : this.departure,
      via: data.via.present ? data.via.value : this.via,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightLog(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('airlineIndex: $airlineIndex, ')
          ..write('useOtherAirline: $useOtherAirline, ')
          ..write('otherAirline: $otherAirline, ')
          ..write('flightNo: $flightNo, ')
          ..write('travelStatusIndex: $travelStatusIndex, ')
          ..write('otherTravelStatus: $otherTravelStatus, ')
          ..write('departure: $departure, ')
          ..write('via: $via, ')
          ..write('destination: $destination, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    airlineIndex,
    useOtherAirline,
    otherAirline,
    flightNo,
    travelStatusIndex,
    otherTravelStatus,
    departure,
    via,
    destination,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlightLog &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.airlineIndex == this.airlineIndex &&
          other.useOtherAirline == this.useOtherAirline &&
          other.otherAirline == this.otherAirline &&
          other.flightNo == this.flightNo &&
          other.travelStatusIndex == this.travelStatusIndex &&
          other.otherTravelStatus == this.otherTravelStatus &&
          other.departure == this.departure &&
          other.via == this.via &&
          other.destination == this.destination &&
          other.updatedAt == this.updatedAt);
}

class FlightLogsCompanion extends UpdateCompanion<FlightLog> {
  final Value<int> id;
  final Value<int> visitId;
  final Value<int?> airlineIndex;
  final Value<bool> useOtherAirline;
  final Value<String?> otherAirline;
  final Value<String?> flightNo;
  final Value<int?> travelStatusIndex;
  final Value<String?> otherTravelStatus;
  final Value<String?> departure;
  final Value<String?> via;
  final Value<String?> destination;
  final Value<DateTime> updatedAt;
  const FlightLogsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.airlineIndex = const Value.absent(),
    this.useOtherAirline = const Value.absent(),
    this.otherAirline = const Value.absent(),
    this.flightNo = const Value.absent(),
    this.travelStatusIndex = const Value.absent(),
    this.otherTravelStatus = const Value.absent(),
    this.departure = const Value.absent(),
    this.via = const Value.absent(),
    this.destination = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FlightLogsCompanion.insert({
    this.id = const Value.absent(),
    required int visitId,
    this.airlineIndex = const Value.absent(),
    this.useOtherAirline = const Value.absent(),
    this.otherAirline = const Value.absent(),
    this.flightNo = const Value.absent(),
    this.travelStatusIndex = const Value.absent(),
    this.otherTravelStatus = const Value.absent(),
    this.departure = const Value.absent(),
    this.via = const Value.absent(),
    this.destination = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : visitId = Value(visitId);
  static Insertable<FlightLog> custom({
    Expression<int>? id,
    Expression<int>? visitId,
    Expression<int>? airlineIndex,
    Expression<bool>? useOtherAirline,
    Expression<String>? otherAirline,
    Expression<String>? flightNo,
    Expression<int>? travelStatusIndex,
    Expression<String>? otherTravelStatus,
    Expression<String>? departure,
    Expression<String>? via,
    Expression<String>? destination,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (airlineIndex != null) 'airline_index': airlineIndex,
      if (useOtherAirline != null) 'use_other_airline': useOtherAirline,
      if (otherAirline != null) 'other_airline': otherAirline,
      if (flightNo != null) 'flight_no': flightNo,
      if (travelStatusIndex != null) 'travel_status_index': travelStatusIndex,
      if (otherTravelStatus != null) 'other_travel_status': otherTravelStatus,
      if (departure != null) 'departure': departure,
      if (via != null) 'via': via,
      if (destination != null) 'destination': destination,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FlightLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? visitId,
    Value<int?>? airlineIndex,
    Value<bool>? useOtherAirline,
    Value<String?>? otherAirline,
    Value<String?>? flightNo,
    Value<int?>? travelStatusIndex,
    Value<String?>? otherTravelStatus,
    Value<String?>? departure,
    Value<String?>? via,
    Value<String?>? destination,
    Value<DateTime>? updatedAt,
  }) {
    return FlightLogsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      airlineIndex: airlineIndex ?? this.airlineIndex,
      useOtherAirline: useOtherAirline ?? this.useOtherAirline,
      otherAirline: otherAirline ?? this.otherAirline,
      flightNo: flightNo ?? this.flightNo,
      travelStatusIndex: travelStatusIndex ?? this.travelStatusIndex,
      otherTravelStatus: otherTravelStatus ?? this.otherTravelStatus,
      departure: departure ?? this.departure,
      via: via ?? this.via,
      destination: destination ?? this.destination,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (airlineIndex.present) {
      map['airline_index'] = Variable<int>(airlineIndex.value);
    }
    if (useOtherAirline.present) {
      map['use_other_airline'] = Variable<bool>(useOtherAirline.value);
    }
    if (otherAirline.present) {
      map['other_airline'] = Variable<String>(otherAirline.value);
    }
    if (flightNo.present) {
      map['flight_no'] = Variable<String>(flightNo.value);
    }
    if (travelStatusIndex.present) {
      map['travel_status_index'] = Variable<int>(travelStatusIndex.value);
    }
    if (otherTravelStatus.present) {
      map['other_travel_status'] = Variable<String>(otherTravelStatus.value);
    }
    if (departure.present) {
      map['departure'] = Variable<String>(departure.value);
    }
    if (via.present) {
      map['via'] = Variable<String>(via.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightLogsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('airlineIndex: $airlineIndex, ')
          ..write('useOtherAirline: $useOtherAirline, ')
          ..write('otherAirline: $otherAirline, ')
          ..write('flightNo: $flightNo, ')
          ..write('travelStatusIndex: $travelStatusIndex, ')
          ..write('otherTravelStatus: $otherTravelStatus, ')
          ..write('departure: $departure, ')
          ..write('via: $via, ')
          ..write('destination: $destination, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TreatmentsTable extends Treatments
    with TableInfo<$TreatmentsTable, Treatment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _screeningCheckedMeta = const VerificationMeta(
    'screeningChecked',
  );
  @override
  late final GeneratedColumn<bool> screeningChecked = GeneratedColumn<bool>(
    'screening_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("screening_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _screeningMethodsJsonMeta =
      const VerificationMeta('screeningMethodsJson');
  @override
  late final GeneratedColumn<String> screeningMethodsJson =
      GeneratedColumn<String>(
        'screening_methods_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _otherScreeningMethodMeta =
      const VerificationMeta('otherScreeningMethod');
  @override
  late final GeneratedColumn<String> otherScreeningMethod =
      GeneratedColumn<String>(
        'other_screening_method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _healthDataJsonMeta = const VerificationMeta(
    'healthDataJson',
  );
  @override
  late final GeneratedColumn<String> healthDataJson = GeneratedColumn<String>(
    'health_data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mainSymptomMeta = const VerificationMeta(
    'mainSymptom',
  );
  @override
  late final GeneratedColumn<int> mainSymptom = GeneratedColumn<int>(
    'main_symptom',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _traumaSymptomsJsonMeta =
      const VerificationMeta('traumaSymptomsJson');
  @override
  late final GeneratedColumn<String> traumaSymptomsJson =
      GeneratedColumn<String>(
        'trauma_symptoms_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nonTraumaSymptomsJsonMeta =
      const VerificationMeta('nonTraumaSymptomsJson');
  @override
  late final GeneratedColumn<String> nonTraumaSymptomsJson =
      GeneratedColumn<String>(
        'non_trauma_symptoms_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _symptomNoteMeta = const VerificationMeta(
    'symptomNote',
  );
  @override
  late final GeneratedColumn<String> symptomNote = GeneratedColumn<String>(
    'symptom_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoTypesJsonMeta = const VerificationMeta(
    'photoTypesJson',
  );
  @override
  late final GeneratedColumn<String> photoTypesJson = GeneratedColumn<String>(
    'photo_types_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyCheckHeadMeta = const VerificationMeta(
    'bodyCheckHead',
  );
  @override
  late final GeneratedColumn<String> bodyCheckHead = GeneratedColumn<String>(
    'body_check_head',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyCheckChestMeta = const VerificationMeta(
    'bodyCheckChest',
  );
  @override
  late final GeneratedColumn<String> bodyCheckChest = GeneratedColumn<String>(
    'body_check_chest',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyCheckAbdomenMeta = const VerificationMeta(
    'bodyCheckAbdomen',
  );
  @override
  late final GeneratedColumn<String> bodyCheckAbdomen = GeneratedColumn<String>(
    'body_check_abdomen',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyCheckLimbsMeta = const VerificationMeta(
    'bodyCheckLimbs',
  );
  @override
  late final GeneratedColumn<String> bodyCheckLimbs = GeneratedColumn<String>(
    'body_check_limbs',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyCheckOtherMeta = const VerificationMeta(
    'bodyCheckOther',
  );
  @override
  late final GeneratedColumn<String> bodyCheckOther = GeneratedColumn<String>(
    'body_check_other',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<String> temperature = GeneratedColumn<String>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pulseMeta = const VerificationMeta('pulse');
  @override
  late final GeneratedColumn<String> pulse = GeneratedColumn<String>(
    'pulse',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _respirationMeta = const VerificationMeta(
    'respiration',
  );
  @override
  late final GeneratedColumn<String> respiration = GeneratedColumn<String>(
    'respiration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpSystolicMeta = const VerificationMeta(
    'bpSystolic',
  );
  @override
  late final GeneratedColumn<String> bpSystolic = GeneratedColumn<String>(
    'bp_systolic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpDiastolicMeta = const VerificationMeta(
    'bpDiastolic',
  );
  @override
  late final GeneratedColumn<String> bpDiastolic = GeneratedColumn<String>(
    'bp_diastolic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2Meta = const VerificationMeta('spo2');
  @override
  late final GeneratedColumn<String> spo2 = GeneratedColumn<String>(
    'spo2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consciousClearMeta = const VerificationMeta(
    'consciousClear',
  );
  @override
  late final GeneratedColumn<bool> consciousClear = GeneratedColumn<bool>(
    'conscious_clear',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("conscious_clear" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _evmEMeta = const VerificationMeta('evmE');
  @override
  late final GeneratedColumn<String> evmE = GeneratedColumn<String>(
    'evm_e',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evmVMeta = const VerificationMeta('evmV');
  @override
  late final GeneratedColumn<String> evmV = GeneratedColumn<String>(
    'evm_v',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evmMMeta = const VerificationMeta('evmM');
  @override
  late final GeneratedColumn<String> evmM = GeneratedColumn<String>(
    'evm_m',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftPupilScaleMeta = const VerificationMeta(
    'leftPupilScale',
  );
  @override
  late final GeneratedColumn<int> leftPupilScale = GeneratedColumn<int>(
    'left_pupil_scale',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftPupilSizeMeta = const VerificationMeta(
    'leftPupilSize',
  );
  @override
  late final GeneratedColumn<String> leftPupilSize = GeneratedColumn<String>(
    'left_pupil_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightPupilScaleMeta = const VerificationMeta(
    'rightPupilScale',
  );
  @override
  late final GeneratedColumn<int> rightPupilScale = GeneratedColumn<int>(
    'right_pupil_scale',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightPupilSizeMeta = const VerificationMeta(
    'rightPupilSize',
  );
  @override
  late final GeneratedColumn<String> rightPupilSize = GeneratedColumn<String>(
    'right_pupil_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _historyMeta = const VerificationMeta(
    'history',
  );
  @override
  late final GeneratedColumn<int> history = GeneratedColumn<int>(
    'history',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergyMeta = const VerificationMeta(
    'allergy',
  );
  @override
  late final GeneratedColumn<int> allergy = GeneratedColumn<int>(
    'allergy',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialDiagnosisMeta = const VerificationMeta(
    'initialDiagnosis',
  );
  @override
  late final GeneratedColumn<String> initialDiagnosis = GeneratedColumn<String>(
    'initial_diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisCategoryMeta = const VerificationMeta(
    'diagnosisCategory',
  );
  @override
  late final GeneratedColumn<int> diagnosisCategory = GeneratedColumn<int>(
    'diagnosis_category',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedICD10MainMeta = const VerificationMeta(
    'selectedICD10Main',
  );
  @override
  late final GeneratedColumn<String> selectedICD10Main =
      GeneratedColumn<String>(
        'selected_i_c_d10_main',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _selectedICD10Sub1Meta = const VerificationMeta(
    'selectedICD10Sub1',
  );
  @override
  late final GeneratedColumn<String> selectedICD10Sub1 =
      GeneratedColumn<String>(
        'selected_i_c_d10_sub1',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _selectedICD10Sub2Meta = const VerificationMeta(
    'selectedICD10Sub2',
  );
  @override
  late final GeneratedColumn<String> selectedICD10Sub2 =
      GeneratedColumn<String>(
        'selected_i_c_d10_sub2',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _triageCategoryMeta = const VerificationMeta(
    'triageCategory',
  );
  @override
  late final GeneratedColumn<int> triageCategory = GeneratedColumn<int>(
    'triage_category',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onSiteTreatmentsJsonMeta =
      const VerificationMeta('onSiteTreatmentsJson');
  @override
  late final GeneratedColumn<String> onSiteTreatmentsJson =
      GeneratedColumn<String>(
        'on_site_treatments_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ekgCheckedMeta = const VerificationMeta(
    'ekgChecked',
  );
  @override
  late final GeneratedColumn<bool> ekgChecked = GeneratedColumn<bool>(
    'ekg_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ekg_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ekgReadingMeta = const VerificationMeta(
    'ekgReading',
  );
  @override
  late final GeneratedColumn<String> ekgReading = GeneratedColumn<String>(
    'ekg_reading',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sugarCheckedMeta = const VerificationMeta(
    'sugarChecked',
  );
  @override
  late final GeneratedColumn<bool> sugarChecked = GeneratedColumn<bool>(
    'sugar_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sugar_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sugarReadingMeta = const VerificationMeta(
    'sugarReading',
  );
  @override
  late final GeneratedColumn<String> sugarReading = GeneratedColumn<String>(
    'sugar_reading',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestReferralMeta = const VerificationMeta(
    'suggestReferral',
  );
  @override
  late final GeneratedColumn<bool> suggestReferral = GeneratedColumn<bool>(
    'suggest_referral',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("suggest_referral" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _intubationCheckedMeta = const VerificationMeta(
    'intubationChecked',
  );
  @override
  late final GeneratedColumn<bool> intubationChecked = GeneratedColumn<bool>(
    'intubation_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("intubation_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cprCheckedMeta = const VerificationMeta(
    'cprChecked',
  );
  @override
  late final GeneratedColumn<bool> cprChecked = GeneratedColumn<bool>(
    'cpr_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cpr_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _oxygenTherapyCheckedMeta =
      const VerificationMeta('oxygenTherapyChecked');
  @override
  late final GeneratedColumn<bool> oxygenTherapyChecked = GeneratedColumn<bool>(
    'oxygen_therapy_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("oxygen_therapy_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _medicalCertificateCheckedMeta =
      const VerificationMeta('medicalCertificateChecked');
  @override
  late final GeneratedColumn<bool> medicalCertificateChecked =
      GeneratedColumn<bool>(
        'medical_certificate_checked',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("medical_certificate_checked" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _prescriptionCheckedMeta =
      const VerificationMeta('prescriptionChecked');
  @override
  late final GeneratedColumn<bool> prescriptionChecked = GeneratedColumn<bool>(
    'prescription_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prescription_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _otherCheckedMeta = const VerificationMeta(
    'otherChecked',
  );
  @override
  late final GeneratedColumn<bool> otherChecked = GeneratedColumn<bool>(
    'other_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("other_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _otherSummaryMeta = const VerificationMeta(
    'otherSummary',
  );
  @override
  late final GeneratedColumn<String> otherSummary = GeneratedColumn<String>(
    'other_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referralPassageTypeMeta =
      const VerificationMeta('referralPassageType');
  @override
  late final GeneratedColumn<int> referralPassageType = GeneratedColumn<int>(
    'referral_passage_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referralAmbulanceTypeMeta =
      const VerificationMeta('referralAmbulanceType');
  @override
  late final GeneratedColumn<int> referralAmbulanceType = GeneratedColumn<int>(
    'referral_ambulance_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referralHospitalIdxMeta =
      const VerificationMeta('referralHospitalIdx');
  @override
  late final GeneratedColumn<int> referralHospitalIdx = GeneratedColumn<int>(
    'referral_hospital_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referralOtherHospitalMeta =
      const VerificationMeta('referralOtherHospital');
  @override
  late final GeneratedColumn<String> referralOtherHospital =
      GeneratedColumn<String>(
        'referral_other_hospital',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _referralEscortMeta = const VerificationMeta(
    'referralEscort',
  );
  @override
  late final GeneratedColumn<String> referralEscort = GeneratedColumn<String>(
    'referral_escort',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intubationTypeMeta = const VerificationMeta(
    'intubationType',
  );
  @override
  late final GeneratedColumn<int> intubationType = GeneratedColumn<int>(
    'intubation_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oxygenTypeMeta = const VerificationMeta(
    'oxygenType',
  );
  @override
  late final GeneratedColumn<int> oxygenType = GeneratedColumn<int>(
    'oxygen_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oxygenFlowMeta = const VerificationMeta(
    'oxygenFlow',
  );
  @override
  late final GeneratedColumn<String> oxygenFlow = GeneratedColumn<String>(
    'oxygen_flow',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicalCertificateTypesJsonMeta =
      const VerificationMeta('medicalCertificateTypesJson');
  @override
  late final GeneratedColumn<String> medicalCertificateTypesJson =
      GeneratedColumn<String>(
        'medical_certificate_types_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _prescriptionRowsJsonMeta =
      const VerificationMeta('prescriptionRowsJson');
  @override
  late final GeneratedColumn<String> prescriptionRowsJson =
      GeneratedColumn<String>(
        'prescription_rows_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _followUpResultsJsonMeta =
      const VerificationMeta('followUpResultsJson');
  @override
  late final GeneratedColumn<String> followUpResultsJson =
      GeneratedColumn<String>(
        'follow_up_results_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _otherHospitalIdxMeta = const VerificationMeta(
    'otherHospitalIdx',
  );
  @override
  late final GeneratedColumn<int> otherHospitalIdx = GeneratedColumn<int>(
    'other_hospital_idx',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedMainDoctorMeta =
      const VerificationMeta('selectedMainDoctor');
  @override
  late final GeneratedColumn<String> selectedMainDoctor =
      GeneratedColumn<String>(
        'selected_main_doctor',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _selectedMainNurseMeta = const VerificationMeta(
    'selectedMainNurse',
  );
  @override
  late final GeneratedColumn<String> selectedMainNurse =
      GeneratedColumn<String>(
        'selected_main_nurse',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nurseSignatureMeta = const VerificationMeta(
    'nurseSignature',
  );
  @override
  late final GeneratedColumn<String> nurseSignature = GeneratedColumn<String>(
    'nurse_signature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedEMTMeta = const VerificationMeta(
    'selectedEMT',
  );
  @override
  late final GeneratedColumn<String> selectedEMT = GeneratedColumn<String>(
    'selected_e_m_t',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emtSignatureMeta = const VerificationMeta(
    'emtSignature',
  );
  @override
  late final GeneratedColumn<String> emtSignature = GeneratedColumn<String>(
    'emt_signature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _helperNamesTextMeta = const VerificationMeta(
    'helperNamesText',
  );
  @override
  late final GeneratedColumn<String> helperNamesText = GeneratedColumn<String>(
    'helper_names_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedHelpersJsonMeta =
      const VerificationMeta('selectedHelpersJson');
  @override
  late final GeneratedColumn<String> selectedHelpersJson =
      GeneratedColumn<String>(
        'selected_helpers_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _specialNotesJsonMeta = const VerificationMeta(
    'specialNotesJson',
  );
  @override
  late final GeneratedColumn<String> specialNotesJson = GeneratedColumn<String>(
    'special_notes_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherSpecialNoteMeta = const VerificationMeta(
    'otherSpecialNote',
  );
  @override
  late final GeneratedColumn<String> otherSpecialNote = GeneratedColumn<String>(
    'other_special_note',
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
    id,
    visitId,
    screeningChecked,
    screeningMethodsJson,
    otherScreeningMethod,
    healthDataJson,
    mainSymptom,
    traumaSymptomsJson,
    nonTraumaSymptomsJson,
    symptomNote,
    photoTypesJson,
    bodyCheckHead,
    bodyCheckChest,
    bodyCheckAbdomen,
    bodyCheckLimbs,
    bodyCheckOther,
    temperature,
    pulse,
    respiration,
    bpSystolic,
    bpDiastolic,
    spo2,
    consciousClear,
    evmE,
    evmV,
    evmM,
    leftPupilScale,
    leftPupilSize,
    rightPupilScale,
    rightPupilSize,
    history,
    allergy,
    initialDiagnosis,
    diagnosisCategory,
    selectedICD10Main,
    selectedICD10Sub1,
    selectedICD10Sub2,
    triageCategory,
    onSiteTreatmentsJson,
    ekgChecked,
    ekgReading,
    sugarChecked,
    sugarReading,
    suggestReferral,
    intubationChecked,
    cprChecked,
    oxygenTherapyChecked,
    medicalCertificateChecked,
    prescriptionChecked,
    otherChecked,
    otherSummary,
    referralPassageType,
    referralAmbulanceType,
    referralHospitalIdx,
    referralOtherHospital,
    referralEscort,
    intubationType,
    oxygenType,
    oxygenFlow,
    medicalCertificateTypesJson,
    prescriptionRowsJson,
    followUpResultsJson,
    otherHospitalIdx,
    selectedMainDoctor,
    selectedMainNurse,
    nurseSignature,
    selectedEMT,
    emtSignature,
    helperNamesText,
    selectedHelpersJson,
    specialNotesJson,
    otherSpecialNote,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treatments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Treatment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('screening_checked')) {
      context.handle(
        _screeningCheckedMeta,
        screeningChecked.isAcceptableOrUnknown(
          data['screening_checked']!,
          _screeningCheckedMeta,
        ),
      );
    }
    if (data.containsKey('screening_methods_json')) {
      context.handle(
        _screeningMethodsJsonMeta,
        screeningMethodsJson.isAcceptableOrUnknown(
          data['screening_methods_json']!,
          _screeningMethodsJsonMeta,
        ),
      );
    }
    if (data.containsKey('other_screening_method')) {
      context.handle(
        _otherScreeningMethodMeta,
        otherScreeningMethod.isAcceptableOrUnknown(
          data['other_screening_method']!,
          _otherScreeningMethodMeta,
        ),
      );
    }
    if (data.containsKey('health_data_json')) {
      context.handle(
        _healthDataJsonMeta,
        healthDataJson.isAcceptableOrUnknown(
          data['health_data_json']!,
          _healthDataJsonMeta,
        ),
      );
    }
    if (data.containsKey('main_symptom')) {
      context.handle(
        _mainSymptomMeta,
        mainSymptom.isAcceptableOrUnknown(
          data['main_symptom']!,
          _mainSymptomMeta,
        ),
      );
    }
    if (data.containsKey('trauma_symptoms_json')) {
      context.handle(
        _traumaSymptomsJsonMeta,
        traumaSymptomsJson.isAcceptableOrUnknown(
          data['trauma_symptoms_json']!,
          _traumaSymptomsJsonMeta,
        ),
      );
    }
    if (data.containsKey('non_trauma_symptoms_json')) {
      context.handle(
        _nonTraumaSymptomsJsonMeta,
        nonTraumaSymptomsJson.isAcceptableOrUnknown(
          data['non_trauma_symptoms_json']!,
          _nonTraumaSymptomsJsonMeta,
        ),
      );
    }
    if (data.containsKey('symptom_note')) {
      context.handle(
        _symptomNoteMeta,
        symptomNote.isAcceptableOrUnknown(
          data['symptom_note']!,
          _symptomNoteMeta,
        ),
      );
    }
    if (data.containsKey('photo_types_json')) {
      context.handle(
        _photoTypesJsonMeta,
        photoTypesJson.isAcceptableOrUnknown(
          data['photo_types_json']!,
          _photoTypesJsonMeta,
        ),
      );
    }
    if (data.containsKey('body_check_head')) {
      context.handle(
        _bodyCheckHeadMeta,
        bodyCheckHead.isAcceptableOrUnknown(
          data['body_check_head']!,
          _bodyCheckHeadMeta,
        ),
      );
    }
    if (data.containsKey('body_check_chest')) {
      context.handle(
        _bodyCheckChestMeta,
        bodyCheckChest.isAcceptableOrUnknown(
          data['body_check_chest']!,
          _bodyCheckChestMeta,
        ),
      );
    }
    if (data.containsKey('body_check_abdomen')) {
      context.handle(
        _bodyCheckAbdomenMeta,
        bodyCheckAbdomen.isAcceptableOrUnknown(
          data['body_check_abdomen']!,
          _bodyCheckAbdomenMeta,
        ),
      );
    }
    if (data.containsKey('body_check_limbs')) {
      context.handle(
        _bodyCheckLimbsMeta,
        bodyCheckLimbs.isAcceptableOrUnknown(
          data['body_check_limbs']!,
          _bodyCheckLimbsMeta,
        ),
      );
    }
    if (data.containsKey('body_check_other')) {
      context.handle(
        _bodyCheckOtherMeta,
        bodyCheckOther.isAcceptableOrUnknown(
          data['body_check_other']!,
          _bodyCheckOtherMeta,
        ),
      );
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
    if (data.containsKey('respiration')) {
      context.handle(
        _respirationMeta,
        respiration.isAcceptableOrUnknown(
          data['respiration']!,
          _respirationMeta,
        ),
      );
    }
    if (data.containsKey('bp_systolic')) {
      context.handle(
        _bpSystolicMeta,
        bpSystolic.isAcceptableOrUnknown(data['bp_systolic']!, _bpSystolicMeta),
      );
    }
    if (data.containsKey('bp_diastolic')) {
      context.handle(
        _bpDiastolicMeta,
        bpDiastolic.isAcceptableOrUnknown(
          data['bp_diastolic']!,
          _bpDiastolicMeta,
        ),
      );
    }
    if (data.containsKey('spo2')) {
      context.handle(
        _spo2Meta,
        spo2.isAcceptableOrUnknown(data['spo2']!, _spo2Meta),
      );
    }
    if (data.containsKey('conscious_clear')) {
      context.handle(
        _consciousClearMeta,
        consciousClear.isAcceptableOrUnknown(
          data['conscious_clear']!,
          _consciousClearMeta,
        ),
      );
    }
    if (data.containsKey('evm_e')) {
      context.handle(
        _evmEMeta,
        evmE.isAcceptableOrUnknown(data['evm_e']!, _evmEMeta),
      );
    }
    if (data.containsKey('evm_v')) {
      context.handle(
        _evmVMeta,
        evmV.isAcceptableOrUnknown(data['evm_v']!, _evmVMeta),
      );
    }
    if (data.containsKey('evm_m')) {
      context.handle(
        _evmMMeta,
        evmM.isAcceptableOrUnknown(data['evm_m']!, _evmMMeta),
      );
    }
    if (data.containsKey('left_pupil_scale')) {
      context.handle(
        _leftPupilScaleMeta,
        leftPupilScale.isAcceptableOrUnknown(
          data['left_pupil_scale']!,
          _leftPupilScaleMeta,
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
    if (data.containsKey('right_pupil_scale')) {
      context.handle(
        _rightPupilScaleMeta,
        rightPupilScale.isAcceptableOrUnknown(
          data['right_pupil_scale']!,
          _rightPupilScaleMeta,
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
    if (data.containsKey('history')) {
      context.handle(
        _historyMeta,
        history.isAcceptableOrUnknown(data['history']!, _historyMeta),
      );
    }
    if (data.containsKey('allergy')) {
      context.handle(
        _allergyMeta,
        allergy.isAcceptableOrUnknown(data['allergy']!, _allergyMeta),
      );
    }
    if (data.containsKey('initial_diagnosis')) {
      context.handle(
        _initialDiagnosisMeta,
        initialDiagnosis.isAcceptableOrUnknown(
          data['initial_diagnosis']!,
          _initialDiagnosisMeta,
        ),
      );
    }
    if (data.containsKey('diagnosis_category')) {
      context.handle(
        _diagnosisCategoryMeta,
        diagnosisCategory.isAcceptableOrUnknown(
          data['diagnosis_category']!,
          _diagnosisCategoryMeta,
        ),
      );
    }
    if (data.containsKey('selected_i_c_d10_main')) {
      context.handle(
        _selectedICD10MainMeta,
        selectedICD10Main.isAcceptableOrUnknown(
          data['selected_i_c_d10_main']!,
          _selectedICD10MainMeta,
        ),
      );
    }
    if (data.containsKey('selected_i_c_d10_sub1')) {
      context.handle(
        _selectedICD10Sub1Meta,
        selectedICD10Sub1.isAcceptableOrUnknown(
          data['selected_i_c_d10_sub1']!,
          _selectedICD10Sub1Meta,
        ),
      );
    }
    if (data.containsKey('selected_i_c_d10_sub2')) {
      context.handle(
        _selectedICD10Sub2Meta,
        selectedICD10Sub2.isAcceptableOrUnknown(
          data['selected_i_c_d10_sub2']!,
          _selectedICD10Sub2Meta,
        ),
      );
    }
    if (data.containsKey('triage_category')) {
      context.handle(
        _triageCategoryMeta,
        triageCategory.isAcceptableOrUnknown(
          data['triage_category']!,
          _triageCategoryMeta,
        ),
      );
    }
    if (data.containsKey('on_site_treatments_json')) {
      context.handle(
        _onSiteTreatmentsJsonMeta,
        onSiteTreatmentsJson.isAcceptableOrUnknown(
          data['on_site_treatments_json']!,
          _onSiteTreatmentsJsonMeta,
        ),
      );
    }
    if (data.containsKey('ekg_checked')) {
      context.handle(
        _ekgCheckedMeta,
        ekgChecked.isAcceptableOrUnknown(data['ekg_checked']!, _ekgCheckedMeta),
      );
    }
    if (data.containsKey('ekg_reading')) {
      context.handle(
        _ekgReadingMeta,
        ekgReading.isAcceptableOrUnknown(data['ekg_reading']!, _ekgReadingMeta),
      );
    }
    if (data.containsKey('sugar_checked')) {
      context.handle(
        _sugarCheckedMeta,
        sugarChecked.isAcceptableOrUnknown(
          data['sugar_checked']!,
          _sugarCheckedMeta,
        ),
      );
    }
    if (data.containsKey('sugar_reading')) {
      context.handle(
        _sugarReadingMeta,
        sugarReading.isAcceptableOrUnknown(
          data['sugar_reading']!,
          _sugarReadingMeta,
        ),
      );
    }
    if (data.containsKey('suggest_referral')) {
      context.handle(
        _suggestReferralMeta,
        suggestReferral.isAcceptableOrUnknown(
          data['suggest_referral']!,
          _suggestReferralMeta,
        ),
      );
    }
    if (data.containsKey('intubation_checked')) {
      context.handle(
        _intubationCheckedMeta,
        intubationChecked.isAcceptableOrUnknown(
          data['intubation_checked']!,
          _intubationCheckedMeta,
        ),
      );
    }
    if (data.containsKey('cpr_checked')) {
      context.handle(
        _cprCheckedMeta,
        cprChecked.isAcceptableOrUnknown(data['cpr_checked']!, _cprCheckedMeta),
      );
    }
    if (data.containsKey('oxygen_therapy_checked')) {
      context.handle(
        _oxygenTherapyCheckedMeta,
        oxygenTherapyChecked.isAcceptableOrUnknown(
          data['oxygen_therapy_checked']!,
          _oxygenTherapyCheckedMeta,
        ),
      );
    }
    if (data.containsKey('medical_certificate_checked')) {
      context.handle(
        _medicalCertificateCheckedMeta,
        medicalCertificateChecked.isAcceptableOrUnknown(
          data['medical_certificate_checked']!,
          _medicalCertificateCheckedMeta,
        ),
      );
    }
    if (data.containsKey('prescription_checked')) {
      context.handle(
        _prescriptionCheckedMeta,
        prescriptionChecked.isAcceptableOrUnknown(
          data['prescription_checked']!,
          _prescriptionCheckedMeta,
        ),
      );
    }
    if (data.containsKey('other_checked')) {
      context.handle(
        _otherCheckedMeta,
        otherChecked.isAcceptableOrUnknown(
          data['other_checked']!,
          _otherCheckedMeta,
        ),
      );
    }
    if (data.containsKey('other_summary')) {
      context.handle(
        _otherSummaryMeta,
        otherSummary.isAcceptableOrUnknown(
          data['other_summary']!,
          _otherSummaryMeta,
        ),
      );
    }
    if (data.containsKey('referral_passage_type')) {
      context.handle(
        _referralPassageTypeMeta,
        referralPassageType.isAcceptableOrUnknown(
          data['referral_passage_type']!,
          _referralPassageTypeMeta,
        ),
      );
    }
    if (data.containsKey('referral_ambulance_type')) {
      context.handle(
        _referralAmbulanceTypeMeta,
        referralAmbulanceType.isAcceptableOrUnknown(
          data['referral_ambulance_type']!,
          _referralAmbulanceTypeMeta,
        ),
      );
    }
    if (data.containsKey('referral_hospital_idx')) {
      context.handle(
        _referralHospitalIdxMeta,
        referralHospitalIdx.isAcceptableOrUnknown(
          data['referral_hospital_idx']!,
          _referralHospitalIdxMeta,
        ),
      );
    }
    if (data.containsKey('referral_other_hospital')) {
      context.handle(
        _referralOtherHospitalMeta,
        referralOtherHospital.isAcceptableOrUnknown(
          data['referral_other_hospital']!,
          _referralOtherHospitalMeta,
        ),
      );
    }
    if (data.containsKey('referral_escort')) {
      context.handle(
        _referralEscortMeta,
        referralEscort.isAcceptableOrUnknown(
          data['referral_escort']!,
          _referralEscortMeta,
        ),
      );
    }
    if (data.containsKey('intubation_type')) {
      context.handle(
        _intubationTypeMeta,
        intubationType.isAcceptableOrUnknown(
          data['intubation_type']!,
          _intubationTypeMeta,
        ),
      );
    }
    if (data.containsKey('oxygen_type')) {
      context.handle(
        _oxygenTypeMeta,
        oxygenType.isAcceptableOrUnknown(data['oxygen_type']!, _oxygenTypeMeta),
      );
    }
    if (data.containsKey('oxygen_flow')) {
      context.handle(
        _oxygenFlowMeta,
        oxygenFlow.isAcceptableOrUnknown(data['oxygen_flow']!, _oxygenFlowMeta),
      );
    }
    if (data.containsKey('medical_certificate_types_json')) {
      context.handle(
        _medicalCertificateTypesJsonMeta,
        medicalCertificateTypesJson.isAcceptableOrUnknown(
          data['medical_certificate_types_json']!,
          _medicalCertificateTypesJsonMeta,
        ),
      );
    }
    if (data.containsKey('prescription_rows_json')) {
      context.handle(
        _prescriptionRowsJsonMeta,
        prescriptionRowsJson.isAcceptableOrUnknown(
          data['prescription_rows_json']!,
          _prescriptionRowsJsonMeta,
        ),
      );
    }
    if (data.containsKey('follow_up_results_json')) {
      context.handle(
        _followUpResultsJsonMeta,
        followUpResultsJson.isAcceptableOrUnknown(
          data['follow_up_results_json']!,
          _followUpResultsJsonMeta,
        ),
      );
    }
    if (data.containsKey('other_hospital_idx')) {
      context.handle(
        _otherHospitalIdxMeta,
        otherHospitalIdx.isAcceptableOrUnknown(
          data['other_hospital_idx']!,
          _otherHospitalIdxMeta,
        ),
      );
    }
    if (data.containsKey('selected_main_doctor')) {
      context.handle(
        _selectedMainDoctorMeta,
        selectedMainDoctor.isAcceptableOrUnknown(
          data['selected_main_doctor']!,
          _selectedMainDoctorMeta,
        ),
      );
    }
    if (data.containsKey('selected_main_nurse')) {
      context.handle(
        _selectedMainNurseMeta,
        selectedMainNurse.isAcceptableOrUnknown(
          data['selected_main_nurse']!,
          _selectedMainNurseMeta,
        ),
      );
    }
    if (data.containsKey('nurse_signature')) {
      context.handle(
        _nurseSignatureMeta,
        nurseSignature.isAcceptableOrUnknown(
          data['nurse_signature']!,
          _nurseSignatureMeta,
        ),
      );
    }
    if (data.containsKey('selected_e_m_t')) {
      context.handle(
        _selectedEMTMeta,
        selectedEMT.isAcceptableOrUnknown(
          data['selected_e_m_t']!,
          _selectedEMTMeta,
        ),
      );
    }
    if (data.containsKey('emt_signature')) {
      context.handle(
        _emtSignatureMeta,
        emtSignature.isAcceptableOrUnknown(
          data['emt_signature']!,
          _emtSignatureMeta,
        ),
      );
    }
    if (data.containsKey('helper_names_text')) {
      context.handle(
        _helperNamesTextMeta,
        helperNamesText.isAcceptableOrUnknown(
          data['helper_names_text']!,
          _helperNamesTextMeta,
        ),
      );
    }
    if (data.containsKey('selected_helpers_json')) {
      context.handle(
        _selectedHelpersJsonMeta,
        selectedHelpersJson.isAcceptableOrUnknown(
          data['selected_helpers_json']!,
          _selectedHelpersJsonMeta,
        ),
      );
    }
    if (data.containsKey('special_notes_json')) {
      context.handle(
        _specialNotesJsonMeta,
        specialNotesJson.isAcceptableOrUnknown(
          data['special_notes_json']!,
          _specialNotesJsonMeta,
        ),
      );
    }
    if (data.containsKey('other_special_note')) {
      context.handle(
        _otherSpecialNoteMeta,
        otherSpecialNote.isAcceptableOrUnknown(
          data['other_special_note']!,
          _otherSpecialNoteMeta,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Treatment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Treatment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      screeningChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}screening_checked'],
      )!,
      screeningMethodsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}screening_methods_json'],
      ),
      otherScreeningMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_screening_method'],
      ),
      healthDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_data_json'],
      ),
      mainSymptom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}main_symptom'],
      ),
      traumaSymptomsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trauma_symptoms_json'],
      ),
      nonTraumaSymptomsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}non_trauma_symptoms_json'],
      ),
      symptomNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_note'],
      ),
      photoTypesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_types_json'],
      ),
      bodyCheckHead: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_check_head'],
      ),
      bodyCheckChest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_check_chest'],
      ),
      bodyCheckAbdomen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_check_abdomen'],
      ),
      bodyCheckLimbs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_check_limbs'],
      ),
      bodyCheckOther: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_check_other'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temperature'],
      ),
      pulse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pulse'],
      ),
      respiration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}respiration'],
      ),
      bpSystolic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bp_systolic'],
      ),
      bpDiastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bp_diastolic'],
      ),
      spo2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spo2'],
      ),
      consciousClear: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}conscious_clear'],
      )!,
      evmE: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evm_e'],
      ),
      evmV: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evm_v'],
      ),
      evmM: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evm_m'],
      ),
      leftPupilScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}left_pupil_scale'],
      ),
      leftPupilSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}left_pupil_size'],
      ),
      rightPupilScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}right_pupil_scale'],
      ),
      rightPupilSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}right_pupil_size'],
      ),
      history: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}history'],
      ),
      allergy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allergy'],
      ),
      initialDiagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_diagnosis'],
      ),
      diagnosisCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diagnosis_category'],
      ),
      selectedICD10Main: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_i_c_d10_main'],
      ),
      selectedICD10Sub1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_i_c_d10_sub1'],
      ),
      selectedICD10Sub2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_i_c_d10_sub2'],
      ),
      triageCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triage_category'],
      ),
      onSiteTreatmentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}on_site_treatments_json'],
      ),
      ekgChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ekg_checked'],
      )!,
      ekgReading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ekg_reading'],
      ),
      sugarChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sugar_checked'],
      )!,
      sugarReading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sugar_reading'],
      ),
      suggestReferral: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}suggest_referral'],
      )!,
      intubationChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}intubation_checked'],
      )!,
      cprChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cpr_checked'],
      )!,
      oxygenTherapyChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}oxygen_therapy_checked'],
      )!,
      medicalCertificateChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}medical_certificate_checked'],
      )!,
      prescriptionChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prescription_checked'],
      )!,
      otherChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}other_checked'],
      )!,
      otherSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_summary'],
      ),
      referralPassageType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referral_passage_type'],
      ),
      referralAmbulanceType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referral_ambulance_type'],
      ),
      referralHospitalIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referral_hospital_idx'],
      ),
      referralOtherHospital: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referral_other_hospital'],
      ),
      referralEscort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referral_escort'],
      ),
      intubationType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intubation_type'],
      ),
      oxygenType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}oxygen_type'],
      ),
      oxygenFlow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oxygen_flow'],
      ),
      medicalCertificateTypesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_certificate_types_json'],
      ),
      prescriptionRowsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescription_rows_json'],
      ),
      followUpResultsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}follow_up_results_json'],
      ),
      otherHospitalIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}other_hospital_idx'],
      ),
      selectedMainDoctor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_main_doctor'],
      ),
      selectedMainNurse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_main_nurse'],
      ),
      nurseSignature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nurse_signature'],
      ),
      selectedEMT: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_e_m_t'],
      ),
      emtSignature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emt_signature'],
      ),
      helperNamesText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}helper_names_text'],
      ),
      selectedHelpersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_helpers_json'],
      ),
      specialNotesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}special_notes_json'],
      ),
      otherSpecialNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_special_note'],
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
  $TreatmentsTable createAlias(String alias) {
    return $TreatmentsTable(attachedDatabase, alias);
  }
}

class Treatment extends DataClass implements Insertable<Treatment> {
  final int id;
  final int visitId;
  final bool screeningChecked;
  final String? screeningMethodsJson;
  final String? otherScreeningMethod;
  final String? healthDataJson;
  final int? mainSymptom;
  final String? traumaSymptomsJson;
  final String? nonTraumaSymptomsJson;
  final String? symptomNote;
  final String? photoTypesJson;
  final String? bodyCheckHead;
  final String? bodyCheckChest;
  final String? bodyCheckAbdomen;
  final String? bodyCheckLimbs;
  final String? bodyCheckOther;
  final String? temperature;
  final String? pulse;
  final String? respiration;
  final String? bpSystolic;
  final String? bpDiastolic;
  final String? spo2;
  final bool consciousClear;
  final String? evmE;
  final String? evmV;
  final String? evmM;
  final int? leftPupilScale;
  final String? leftPupilSize;
  final int? rightPupilScale;
  final String? rightPupilSize;
  final int? history;
  final int? allergy;
  final String? initialDiagnosis;
  final int? diagnosisCategory;
  final String? selectedICD10Main;
  final String? selectedICD10Sub1;
  final String? selectedICD10Sub2;
  final int? triageCategory;
  final String? onSiteTreatmentsJson;
  final bool ekgChecked;
  final String? ekgReading;
  final bool sugarChecked;
  final String? sugarReading;
  final bool suggestReferral;
  final bool intubationChecked;
  final bool cprChecked;
  final bool oxygenTherapyChecked;
  final bool medicalCertificateChecked;
  final bool prescriptionChecked;
  final bool otherChecked;
  final String? otherSummary;
  final int? referralPassageType;
  final int? referralAmbulanceType;
  final int? referralHospitalIdx;
  final String? referralOtherHospital;
  final String? referralEscort;
  final int? intubationType;
  final int? oxygenType;
  final String? oxygenFlow;
  final String? medicalCertificateTypesJson;
  final String? prescriptionRowsJson;
  final String? followUpResultsJson;
  final int? otherHospitalIdx;
  final String? selectedMainDoctor;
  final String? selectedMainNurse;
  final String? nurseSignature;
  final String? selectedEMT;
  final String? emtSignature;
  final String? helperNamesText;
  final String? selectedHelpersJson;
  final String? specialNotesJson;
  final String? otherSpecialNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Treatment({
    required this.id,
    required this.visitId,
    required this.screeningChecked,
    this.screeningMethodsJson,
    this.otherScreeningMethod,
    this.healthDataJson,
    this.mainSymptom,
    this.traumaSymptomsJson,
    this.nonTraumaSymptomsJson,
    this.symptomNote,
    this.photoTypesJson,
    this.bodyCheckHead,
    this.bodyCheckChest,
    this.bodyCheckAbdomen,
    this.bodyCheckLimbs,
    this.bodyCheckOther,
    this.temperature,
    this.pulse,
    this.respiration,
    this.bpSystolic,
    this.bpDiastolic,
    this.spo2,
    required this.consciousClear,
    this.evmE,
    this.evmV,
    this.evmM,
    this.leftPupilScale,
    this.leftPupilSize,
    this.rightPupilScale,
    this.rightPupilSize,
    this.history,
    this.allergy,
    this.initialDiagnosis,
    this.diagnosisCategory,
    this.selectedICD10Main,
    this.selectedICD10Sub1,
    this.selectedICD10Sub2,
    this.triageCategory,
    this.onSiteTreatmentsJson,
    required this.ekgChecked,
    this.ekgReading,
    required this.sugarChecked,
    this.sugarReading,
    required this.suggestReferral,
    required this.intubationChecked,
    required this.cprChecked,
    required this.oxygenTherapyChecked,
    required this.medicalCertificateChecked,
    required this.prescriptionChecked,
    required this.otherChecked,
    this.otherSummary,
    this.referralPassageType,
    this.referralAmbulanceType,
    this.referralHospitalIdx,
    this.referralOtherHospital,
    this.referralEscort,
    this.intubationType,
    this.oxygenType,
    this.oxygenFlow,
    this.medicalCertificateTypesJson,
    this.prescriptionRowsJson,
    this.followUpResultsJson,
    this.otherHospitalIdx,
    this.selectedMainDoctor,
    this.selectedMainNurse,
    this.nurseSignature,
    this.selectedEMT,
    this.emtSignature,
    this.helperNamesText,
    this.selectedHelpersJson,
    this.specialNotesJson,
    this.otherSpecialNote,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['visit_id'] = Variable<int>(visitId);
    map['screening_checked'] = Variable<bool>(screeningChecked);
    if (!nullToAbsent || screeningMethodsJson != null) {
      map['screening_methods_json'] = Variable<String>(screeningMethodsJson);
    }
    if (!nullToAbsent || otherScreeningMethod != null) {
      map['other_screening_method'] = Variable<String>(otherScreeningMethod);
    }
    if (!nullToAbsent || healthDataJson != null) {
      map['health_data_json'] = Variable<String>(healthDataJson);
    }
    if (!nullToAbsent || mainSymptom != null) {
      map['main_symptom'] = Variable<int>(mainSymptom);
    }
    if (!nullToAbsent || traumaSymptomsJson != null) {
      map['trauma_symptoms_json'] = Variable<String>(traumaSymptomsJson);
    }
    if (!nullToAbsent || nonTraumaSymptomsJson != null) {
      map['non_trauma_symptoms_json'] = Variable<String>(nonTraumaSymptomsJson);
    }
    if (!nullToAbsent || symptomNote != null) {
      map['symptom_note'] = Variable<String>(symptomNote);
    }
    if (!nullToAbsent || photoTypesJson != null) {
      map['photo_types_json'] = Variable<String>(photoTypesJson);
    }
    if (!nullToAbsent || bodyCheckHead != null) {
      map['body_check_head'] = Variable<String>(bodyCheckHead);
    }
    if (!nullToAbsent || bodyCheckChest != null) {
      map['body_check_chest'] = Variable<String>(bodyCheckChest);
    }
    if (!nullToAbsent || bodyCheckAbdomen != null) {
      map['body_check_abdomen'] = Variable<String>(bodyCheckAbdomen);
    }
    if (!nullToAbsent || bodyCheckLimbs != null) {
      map['body_check_limbs'] = Variable<String>(bodyCheckLimbs);
    }
    if (!nullToAbsent || bodyCheckOther != null) {
      map['body_check_other'] = Variable<String>(bodyCheckOther);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<String>(temperature);
    }
    if (!nullToAbsent || pulse != null) {
      map['pulse'] = Variable<String>(pulse);
    }
    if (!nullToAbsent || respiration != null) {
      map['respiration'] = Variable<String>(respiration);
    }
    if (!nullToAbsent || bpSystolic != null) {
      map['bp_systolic'] = Variable<String>(bpSystolic);
    }
    if (!nullToAbsent || bpDiastolic != null) {
      map['bp_diastolic'] = Variable<String>(bpDiastolic);
    }
    if (!nullToAbsent || spo2 != null) {
      map['spo2'] = Variable<String>(spo2);
    }
    map['conscious_clear'] = Variable<bool>(consciousClear);
    if (!nullToAbsent || evmE != null) {
      map['evm_e'] = Variable<String>(evmE);
    }
    if (!nullToAbsent || evmV != null) {
      map['evm_v'] = Variable<String>(evmV);
    }
    if (!nullToAbsent || evmM != null) {
      map['evm_m'] = Variable<String>(evmM);
    }
    if (!nullToAbsent || leftPupilScale != null) {
      map['left_pupil_scale'] = Variable<int>(leftPupilScale);
    }
    if (!nullToAbsent || leftPupilSize != null) {
      map['left_pupil_size'] = Variable<String>(leftPupilSize);
    }
    if (!nullToAbsent || rightPupilScale != null) {
      map['right_pupil_scale'] = Variable<int>(rightPupilScale);
    }
    if (!nullToAbsent || rightPupilSize != null) {
      map['right_pupil_size'] = Variable<String>(rightPupilSize);
    }
    if (!nullToAbsent || history != null) {
      map['history'] = Variable<int>(history);
    }
    if (!nullToAbsent || allergy != null) {
      map['allergy'] = Variable<int>(allergy);
    }
    if (!nullToAbsent || initialDiagnosis != null) {
      map['initial_diagnosis'] = Variable<String>(initialDiagnosis);
    }
    if (!nullToAbsent || diagnosisCategory != null) {
      map['diagnosis_category'] = Variable<int>(diagnosisCategory);
    }
    if (!nullToAbsent || selectedICD10Main != null) {
      map['selected_i_c_d10_main'] = Variable<String>(selectedICD10Main);
    }
    if (!nullToAbsent || selectedICD10Sub1 != null) {
      map['selected_i_c_d10_sub1'] = Variable<String>(selectedICD10Sub1);
    }
    if (!nullToAbsent || selectedICD10Sub2 != null) {
      map['selected_i_c_d10_sub2'] = Variable<String>(selectedICD10Sub2);
    }
    if (!nullToAbsent || triageCategory != null) {
      map['triage_category'] = Variable<int>(triageCategory);
    }
    if (!nullToAbsent || onSiteTreatmentsJson != null) {
      map['on_site_treatments_json'] = Variable<String>(onSiteTreatmentsJson);
    }
    map['ekg_checked'] = Variable<bool>(ekgChecked);
    if (!nullToAbsent || ekgReading != null) {
      map['ekg_reading'] = Variable<String>(ekgReading);
    }
    map['sugar_checked'] = Variable<bool>(sugarChecked);
    if (!nullToAbsent || sugarReading != null) {
      map['sugar_reading'] = Variable<String>(sugarReading);
    }
    map['suggest_referral'] = Variable<bool>(suggestReferral);
    map['intubation_checked'] = Variable<bool>(intubationChecked);
    map['cpr_checked'] = Variable<bool>(cprChecked);
    map['oxygen_therapy_checked'] = Variable<bool>(oxygenTherapyChecked);
    map['medical_certificate_checked'] = Variable<bool>(
      medicalCertificateChecked,
    );
    map['prescription_checked'] = Variable<bool>(prescriptionChecked);
    map['other_checked'] = Variable<bool>(otherChecked);
    if (!nullToAbsent || otherSummary != null) {
      map['other_summary'] = Variable<String>(otherSummary);
    }
    if (!nullToAbsent || referralPassageType != null) {
      map['referral_passage_type'] = Variable<int>(referralPassageType);
    }
    if (!nullToAbsent || referralAmbulanceType != null) {
      map['referral_ambulance_type'] = Variable<int>(referralAmbulanceType);
    }
    if (!nullToAbsent || referralHospitalIdx != null) {
      map['referral_hospital_idx'] = Variable<int>(referralHospitalIdx);
    }
    if (!nullToAbsent || referralOtherHospital != null) {
      map['referral_other_hospital'] = Variable<String>(referralOtherHospital);
    }
    if (!nullToAbsent || referralEscort != null) {
      map['referral_escort'] = Variable<String>(referralEscort);
    }
    if (!nullToAbsent || intubationType != null) {
      map['intubation_type'] = Variable<int>(intubationType);
    }
    if (!nullToAbsent || oxygenType != null) {
      map['oxygen_type'] = Variable<int>(oxygenType);
    }
    if (!nullToAbsent || oxygenFlow != null) {
      map['oxygen_flow'] = Variable<String>(oxygenFlow);
    }
    if (!nullToAbsent || medicalCertificateTypesJson != null) {
      map['medical_certificate_types_json'] = Variable<String>(
        medicalCertificateTypesJson,
      );
    }
    if (!nullToAbsent || prescriptionRowsJson != null) {
      map['prescription_rows_json'] = Variable<String>(prescriptionRowsJson);
    }
    if (!nullToAbsent || followUpResultsJson != null) {
      map['follow_up_results_json'] = Variable<String>(followUpResultsJson);
    }
    if (!nullToAbsent || otherHospitalIdx != null) {
      map['other_hospital_idx'] = Variable<int>(otherHospitalIdx);
    }
    if (!nullToAbsent || selectedMainDoctor != null) {
      map['selected_main_doctor'] = Variable<String>(selectedMainDoctor);
    }
    if (!nullToAbsent || selectedMainNurse != null) {
      map['selected_main_nurse'] = Variable<String>(selectedMainNurse);
    }
    if (!nullToAbsent || nurseSignature != null) {
      map['nurse_signature'] = Variable<String>(nurseSignature);
    }
    if (!nullToAbsent || selectedEMT != null) {
      map['selected_e_m_t'] = Variable<String>(selectedEMT);
    }
    if (!nullToAbsent || emtSignature != null) {
      map['emt_signature'] = Variable<String>(emtSignature);
    }
    if (!nullToAbsent || helperNamesText != null) {
      map['helper_names_text'] = Variable<String>(helperNamesText);
    }
    if (!nullToAbsent || selectedHelpersJson != null) {
      map['selected_helpers_json'] = Variable<String>(selectedHelpersJson);
    }
    if (!nullToAbsent || specialNotesJson != null) {
      map['special_notes_json'] = Variable<String>(specialNotesJson);
    }
    if (!nullToAbsent || otherSpecialNote != null) {
      map['other_special_note'] = Variable<String>(otherSpecialNote);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TreatmentsCompanion toCompanion(bool nullToAbsent) {
    return TreatmentsCompanion(
      id: Value(id),
      visitId: Value(visitId),
      screeningChecked: Value(screeningChecked),
      screeningMethodsJson: screeningMethodsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(screeningMethodsJson),
      otherScreeningMethod: otherScreeningMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(otherScreeningMethod),
      healthDataJson: healthDataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(healthDataJson),
      mainSymptom: mainSymptom == null && nullToAbsent
          ? const Value.absent()
          : Value(mainSymptom),
      traumaSymptomsJson: traumaSymptomsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(traumaSymptomsJson),
      nonTraumaSymptomsJson: nonTraumaSymptomsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(nonTraumaSymptomsJson),
      symptomNote: symptomNote == null && nullToAbsent
          ? const Value.absent()
          : Value(symptomNote),
      photoTypesJson: photoTypesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(photoTypesJson),
      bodyCheckHead: bodyCheckHead == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyCheckHead),
      bodyCheckChest: bodyCheckChest == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyCheckChest),
      bodyCheckAbdomen: bodyCheckAbdomen == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyCheckAbdomen),
      bodyCheckLimbs: bodyCheckLimbs == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyCheckLimbs),
      bodyCheckOther: bodyCheckOther == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyCheckOther),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      pulse: pulse == null && nullToAbsent
          ? const Value.absent()
          : Value(pulse),
      respiration: respiration == null && nullToAbsent
          ? const Value.absent()
          : Value(respiration),
      bpSystolic: bpSystolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bpSystolic),
      bpDiastolic: bpDiastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bpDiastolic),
      spo2: spo2 == null && nullToAbsent ? const Value.absent() : Value(spo2),
      consciousClear: Value(consciousClear),
      evmE: evmE == null && nullToAbsent ? const Value.absent() : Value(evmE),
      evmV: evmV == null && nullToAbsent ? const Value.absent() : Value(evmV),
      evmM: evmM == null && nullToAbsent ? const Value.absent() : Value(evmM),
      leftPupilScale: leftPupilScale == null && nullToAbsent
          ? const Value.absent()
          : Value(leftPupilScale),
      leftPupilSize: leftPupilSize == null && nullToAbsent
          ? const Value.absent()
          : Value(leftPupilSize),
      rightPupilScale: rightPupilScale == null && nullToAbsent
          ? const Value.absent()
          : Value(rightPupilScale),
      rightPupilSize: rightPupilSize == null && nullToAbsent
          ? const Value.absent()
          : Value(rightPupilSize),
      history: history == null && nullToAbsent
          ? const Value.absent()
          : Value(history),
      allergy: allergy == null && nullToAbsent
          ? const Value.absent()
          : Value(allergy),
      initialDiagnosis: initialDiagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(initialDiagnosis),
      diagnosisCategory: diagnosisCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosisCategory),
      selectedICD10Main: selectedICD10Main == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedICD10Main),
      selectedICD10Sub1: selectedICD10Sub1 == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedICD10Sub1),
      selectedICD10Sub2: selectedICD10Sub2 == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedICD10Sub2),
      triageCategory: triageCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(triageCategory),
      onSiteTreatmentsJson: onSiteTreatmentsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(onSiteTreatmentsJson),
      ekgChecked: Value(ekgChecked),
      ekgReading: ekgReading == null && nullToAbsent
          ? const Value.absent()
          : Value(ekgReading),
      sugarChecked: Value(sugarChecked),
      sugarReading: sugarReading == null && nullToAbsent
          ? const Value.absent()
          : Value(sugarReading),
      suggestReferral: Value(suggestReferral),
      intubationChecked: Value(intubationChecked),
      cprChecked: Value(cprChecked),
      oxygenTherapyChecked: Value(oxygenTherapyChecked),
      medicalCertificateChecked: Value(medicalCertificateChecked),
      prescriptionChecked: Value(prescriptionChecked),
      otherChecked: Value(otherChecked),
      otherSummary: otherSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(otherSummary),
      referralPassageType: referralPassageType == null && nullToAbsent
          ? const Value.absent()
          : Value(referralPassageType),
      referralAmbulanceType: referralAmbulanceType == null && nullToAbsent
          ? const Value.absent()
          : Value(referralAmbulanceType),
      referralHospitalIdx: referralHospitalIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(referralHospitalIdx),
      referralOtherHospital: referralOtherHospital == null && nullToAbsent
          ? const Value.absent()
          : Value(referralOtherHospital),
      referralEscort: referralEscort == null && nullToAbsent
          ? const Value.absent()
          : Value(referralEscort),
      intubationType: intubationType == null && nullToAbsent
          ? const Value.absent()
          : Value(intubationType),
      oxygenType: oxygenType == null && nullToAbsent
          ? const Value.absent()
          : Value(oxygenType),
      oxygenFlow: oxygenFlow == null && nullToAbsent
          ? const Value.absent()
          : Value(oxygenFlow),
      medicalCertificateTypesJson:
          medicalCertificateTypesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalCertificateTypesJson),
      prescriptionRowsJson: prescriptionRowsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(prescriptionRowsJson),
      followUpResultsJson: followUpResultsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpResultsJson),
      otherHospitalIdx: otherHospitalIdx == null && nullToAbsent
          ? const Value.absent()
          : Value(otherHospitalIdx),
      selectedMainDoctor: selectedMainDoctor == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedMainDoctor),
      selectedMainNurse: selectedMainNurse == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedMainNurse),
      nurseSignature: nurseSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(nurseSignature),
      selectedEMT: selectedEMT == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedEMT),
      emtSignature: emtSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(emtSignature),
      helperNamesText: helperNamesText == null && nullToAbsent
          ? const Value.absent()
          : Value(helperNamesText),
      selectedHelpersJson: selectedHelpersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedHelpersJson),
      specialNotesJson: specialNotesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(specialNotesJson),
      otherSpecialNote: otherSpecialNote == null && nullToAbsent
          ? const Value.absent()
          : Value(otherSpecialNote),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Treatment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Treatment(
      id: serializer.fromJson<int>(json['id']),
      visitId: serializer.fromJson<int>(json['visitId']),
      screeningChecked: serializer.fromJson<bool>(json['screeningChecked']),
      screeningMethodsJson: serializer.fromJson<String?>(
        json['screeningMethodsJson'],
      ),
      otherScreeningMethod: serializer.fromJson<String?>(
        json['otherScreeningMethod'],
      ),
      healthDataJson: serializer.fromJson<String?>(json['healthDataJson']),
      mainSymptom: serializer.fromJson<int?>(json['mainSymptom']),
      traumaSymptomsJson: serializer.fromJson<String?>(
        json['traumaSymptomsJson'],
      ),
      nonTraumaSymptomsJson: serializer.fromJson<String?>(
        json['nonTraumaSymptomsJson'],
      ),
      symptomNote: serializer.fromJson<String?>(json['symptomNote']),
      photoTypesJson: serializer.fromJson<String?>(json['photoTypesJson']),
      bodyCheckHead: serializer.fromJson<String?>(json['bodyCheckHead']),
      bodyCheckChest: serializer.fromJson<String?>(json['bodyCheckChest']),
      bodyCheckAbdomen: serializer.fromJson<String?>(json['bodyCheckAbdomen']),
      bodyCheckLimbs: serializer.fromJson<String?>(json['bodyCheckLimbs']),
      bodyCheckOther: serializer.fromJson<String?>(json['bodyCheckOther']),
      temperature: serializer.fromJson<String?>(json['temperature']),
      pulse: serializer.fromJson<String?>(json['pulse']),
      respiration: serializer.fromJson<String?>(json['respiration']),
      bpSystolic: serializer.fromJson<String?>(json['bpSystolic']),
      bpDiastolic: serializer.fromJson<String?>(json['bpDiastolic']),
      spo2: serializer.fromJson<String?>(json['spo2']),
      consciousClear: serializer.fromJson<bool>(json['consciousClear']),
      evmE: serializer.fromJson<String?>(json['evmE']),
      evmV: serializer.fromJson<String?>(json['evmV']),
      evmM: serializer.fromJson<String?>(json['evmM']),
      leftPupilScale: serializer.fromJson<int?>(json['leftPupilScale']),
      leftPupilSize: serializer.fromJson<String?>(json['leftPupilSize']),
      rightPupilScale: serializer.fromJson<int?>(json['rightPupilScale']),
      rightPupilSize: serializer.fromJson<String?>(json['rightPupilSize']),
      history: serializer.fromJson<int?>(json['history']),
      allergy: serializer.fromJson<int?>(json['allergy']),
      initialDiagnosis: serializer.fromJson<String?>(json['initialDiagnosis']),
      diagnosisCategory: serializer.fromJson<int?>(json['diagnosisCategory']),
      selectedICD10Main: serializer.fromJson<String?>(
        json['selectedICD10Main'],
      ),
      selectedICD10Sub1: serializer.fromJson<String?>(
        json['selectedICD10Sub1'],
      ),
      selectedICD10Sub2: serializer.fromJson<String?>(
        json['selectedICD10Sub2'],
      ),
      triageCategory: serializer.fromJson<int?>(json['triageCategory']),
      onSiteTreatmentsJson: serializer.fromJson<String?>(
        json['onSiteTreatmentsJson'],
      ),
      ekgChecked: serializer.fromJson<bool>(json['ekgChecked']),
      ekgReading: serializer.fromJson<String?>(json['ekgReading']),
      sugarChecked: serializer.fromJson<bool>(json['sugarChecked']),
      sugarReading: serializer.fromJson<String?>(json['sugarReading']),
      suggestReferral: serializer.fromJson<bool>(json['suggestReferral']),
      intubationChecked: serializer.fromJson<bool>(json['intubationChecked']),
      cprChecked: serializer.fromJson<bool>(json['cprChecked']),
      oxygenTherapyChecked: serializer.fromJson<bool>(
        json['oxygenTherapyChecked'],
      ),
      medicalCertificateChecked: serializer.fromJson<bool>(
        json['medicalCertificateChecked'],
      ),
      prescriptionChecked: serializer.fromJson<bool>(
        json['prescriptionChecked'],
      ),
      otherChecked: serializer.fromJson<bool>(json['otherChecked']),
      otherSummary: serializer.fromJson<String?>(json['otherSummary']),
      referralPassageType: serializer.fromJson<int?>(
        json['referralPassageType'],
      ),
      referralAmbulanceType: serializer.fromJson<int?>(
        json['referralAmbulanceType'],
      ),
      referralHospitalIdx: serializer.fromJson<int?>(
        json['referralHospitalIdx'],
      ),
      referralOtherHospital: serializer.fromJson<String?>(
        json['referralOtherHospital'],
      ),
      referralEscort: serializer.fromJson<String?>(json['referralEscort']),
      intubationType: serializer.fromJson<int?>(json['intubationType']),
      oxygenType: serializer.fromJson<int?>(json['oxygenType']),
      oxygenFlow: serializer.fromJson<String?>(json['oxygenFlow']),
      medicalCertificateTypesJson: serializer.fromJson<String?>(
        json['medicalCertificateTypesJson'],
      ),
      prescriptionRowsJson: serializer.fromJson<String?>(
        json['prescriptionRowsJson'],
      ),
      followUpResultsJson: serializer.fromJson<String?>(
        json['followUpResultsJson'],
      ),
      otherHospitalIdx: serializer.fromJson<int?>(json['otherHospitalIdx']),
      selectedMainDoctor: serializer.fromJson<String?>(
        json['selectedMainDoctor'],
      ),
      selectedMainNurse: serializer.fromJson<String?>(
        json['selectedMainNurse'],
      ),
      nurseSignature: serializer.fromJson<String?>(json['nurseSignature']),
      selectedEMT: serializer.fromJson<String?>(json['selectedEMT']),
      emtSignature: serializer.fromJson<String?>(json['emtSignature']),
      helperNamesText: serializer.fromJson<String?>(json['helperNamesText']),
      selectedHelpersJson: serializer.fromJson<String?>(
        json['selectedHelpersJson'],
      ),
      specialNotesJson: serializer.fromJson<String?>(json['specialNotesJson']),
      otherSpecialNote: serializer.fromJson<String?>(json['otherSpecialNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'visitId': serializer.toJson<int>(visitId),
      'screeningChecked': serializer.toJson<bool>(screeningChecked),
      'screeningMethodsJson': serializer.toJson<String?>(screeningMethodsJson),
      'otherScreeningMethod': serializer.toJson<String?>(otherScreeningMethod),
      'healthDataJson': serializer.toJson<String?>(healthDataJson),
      'mainSymptom': serializer.toJson<int?>(mainSymptom),
      'traumaSymptomsJson': serializer.toJson<String?>(traumaSymptomsJson),
      'nonTraumaSymptomsJson': serializer.toJson<String?>(
        nonTraumaSymptomsJson,
      ),
      'symptomNote': serializer.toJson<String?>(symptomNote),
      'photoTypesJson': serializer.toJson<String?>(photoTypesJson),
      'bodyCheckHead': serializer.toJson<String?>(bodyCheckHead),
      'bodyCheckChest': serializer.toJson<String?>(bodyCheckChest),
      'bodyCheckAbdomen': serializer.toJson<String?>(bodyCheckAbdomen),
      'bodyCheckLimbs': serializer.toJson<String?>(bodyCheckLimbs),
      'bodyCheckOther': serializer.toJson<String?>(bodyCheckOther),
      'temperature': serializer.toJson<String?>(temperature),
      'pulse': serializer.toJson<String?>(pulse),
      'respiration': serializer.toJson<String?>(respiration),
      'bpSystolic': serializer.toJson<String?>(bpSystolic),
      'bpDiastolic': serializer.toJson<String?>(bpDiastolic),
      'spo2': serializer.toJson<String?>(spo2),
      'consciousClear': serializer.toJson<bool>(consciousClear),
      'evmE': serializer.toJson<String?>(evmE),
      'evmV': serializer.toJson<String?>(evmV),
      'evmM': serializer.toJson<String?>(evmM),
      'leftPupilScale': serializer.toJson<int?>(leftPupilScale),
      'leftPupilSize': serializer.toJson<String?>(leftPupilSize),
      'rightPupilScale': serializer.toJson<int?>(rightPupilScale),
      'rightPupilSize': serializer.toJson<String?>(rightPupilSize),
      'history': serializer.toJson<int?>(history),
      'allergy': serializer.toJson<int?>(allergy),
      'initialDiagnosis': serializer.toJson<String?>(initialDiagnosis),
      'diagnosisCategory': serializer.toJson<int?>(diagnosisCategory),
      'selectedICD10Main': serializer.toJson<String?>(selectedICD10Main),
      'selectedICD10Sub1': serializer.toJson<String?>(selectedICD10Sub1),
      'selectedICD10Sub2': serializer.toJson<String?>(selectedICD10Sub2),
      'triageCategory': serializer.toJson<int?>(triageCategory),
      'onSiteTreatmentsJson': serializer.toJson<String?>(onSiteTreatmentsJson),
      'ekgChecked': serializer.toJson<bool>(ekgChecked),
      'ekgReading': serializer.toJson<String?>(ekgReading),
      'sugarChecked': serializer.toJson<bool>(sugarChecked),
      'sugarReading': serializer.toJson<String?>(sugarReading),
      'suggestReferral': serializer.toJson<bool>(suggestReferral),
      'intubationChecked': serializer.toJson<bool>(intubationChecked),
      'cprChecked': serializer.toJson<bool>(cprChecked),
      'oxygenTherapyChecked': serializer.toJson<bool>(oxygenTherapyChecked),
      'medicalCertificateChecked': serializer.toJson<bool>(
        medicalCertificateChecked,
      ),
      'prescriptionChecked': serializer.toJson<bool>(prescriptionChecked),
      'otherChecked': serializer.toJson<bool>(otherChecked),
      'otherSummary': serializer.toJson<String?>(otherSummary),
      'referralPassageType': serializer.toJson<int?>(referralPassageType),
      'referralAmbulanceType': serializer.toJson<int?>(referralAmbulanceType),
      'referralHospitalIdx': serializer.toJson<int?>(referralHospitalIdx),
      'referralOtherHospital': serializer.toJson<String?>(
        referralOtherHospital,
      ),
      'referralEscort': serializer.toJson<String?>(referralEscort),
      'intubationType': serializer.toJson<int?>(intubationType),
      'oxygenType': serializer.toJson<int?>(oxygenType),
      'oxygenFlow': serializer.toJson<String?>(oxygenFlow),
      'medicalCertificateTypesJson': serializer.toJson<String?>(
        medicalCertificateTypesJson,
      ),
      'prescriptionRowsJson': serializer.toJson<String?>(prescriptionRowsJson),
      'followUpResultsJson': serializer.toJson<String?>(followUpResultsJson),
      'otherHospitalIdx': serializer.toJson<int?>(otherHospitalIdx),
      'selectedMainDoctor': serializer.toJson<String?>(selectedMainDoctor),
      'selectedMainNurse': serializer.toJson<String?>(selectedMainNurse),
      'nurseSignature': serializer.toJson<String?>(nurseSignature),
      'selectedEMT': serializer.toJson<String?>(selectedEMT),
      'emtSignature': serializer.toJson<String?>(emtSignature),
      'helperNamesText': serializer.toJson<String?>(helperNamesText),
      'selectedHelpersJson': serializer.toJson<String?>(selectedHelpersJson),
      'specialNotesJson': serializer.toJson<String?>(specialNotesJson),
      'otherSpecialNote': serializer.toJson<String?>(otherSpecialNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Treatment copyWith({
    int? id,
    int? visitId,
    bool? screeningChecked,
    Value<String?> screeningMethodsJson = const Value.absent(),
    Value<String?> otherScreeningMethod = const Value.absent(),
    Value<String?> healthDataJson = const Value.absent(),
    Value<int?> mainSymptom = const Value.absent(),
    Value<String?> traumaSymptomsJson = const Value.absent(),
    Value<String?> nonTraumaSymptomsJson = const Value.absent(),
    Value<String?> symptomNote = const Value.absent(),
    Value<String?> photoTypesJson = const Value.absent(),
    Value<String?> bodyCheckHead = const Value.absent(),
    Value<String?> bodyCheckChest = const Value.absent(),
    Value<String?> bodyCheckAbdomen = const Value.absent(),
    Value<String?> bodyCheckLimbs = const Value.absent(),
    Value<String?> bodyCheckOther = const Value.absent(),
    Value<String?> temperature = const Value.absent(),
    Value<String?> pulse = const Value.absent(),
    Value<String?> respiration = const Value.absent(),
    Value<String?> bpSystolic = const Value.absent(),
    Value<String?> bpDiastolic = const Value.absent(),
    Value<String?> spo2 = const Value.absent(),
    bool? consciousClear,
    Value<String?> evmE = const Value.absent(),
    Value<String?> evmV = const Value.absent(),
    Value<String?> evmM = const Value.absent(),
    Value<int?> leftPupilScale = const Value.absent(),
    Value<String?> leftPupilSize = const Value.absent(),
    Value<int?> rightPupilScale = const Value.absent(),
    Value<String?> rightPupilSize = const Value.absent(),
    Value<int?> history = const Value.absent(),
    Value<int?> allergy = const Value.absent(),
    Value<String?> initialDiagnosis = const Value.absent(),
    Value<int?> diagnosisCategory = const Value.absent(),
    Value<String?> selectedICD10Main = const Value.absent(),
    Value<String?> selectedICD10Sub1 = const Value.absent(),
    Value<String?> selectedICD10Sub2 = const Value.absent(),
    Value<int?> triageCategory = const Value.absent(),
    Value<String?> onSiteTreatmentsJson = const Value.absent(),
    bool? ekgChecked,
    Value<String?> ekgReading = const Value.absent(),
    bool? sugarChecked,
    Value<String?> sugarReading = const Value.absent(),
    bool? suggestReferral,
    bool? intubationChecked,
    bool? cprChecked,
    bool? oxygenTherapyChecked,
    bool? medicalCertificateChecked,
    bool? prescriptionChecked,
    bool? otherChecked,
    Value<String?> otherSummary = const Value.absent(),
    Value<int?> referralPassageType = const Value.absent(),
    Value<int?> referralAmbulanceType = const Value.absent(),
    Value<int?> referralHospitalIdx = const Value.absent(),
    Value<String?> referralOtherHospital = const Value.absent(),
    Value<String?> referralEscort = const Value.absent(),
    Value<int?> intubationType = const Value.absent(),
    Value<int?> oxygenType = const Value.absent(),
    Value<String?> oxygenFlow = const Value.absent(),
    Value<String?> medicalCertificateTypesJson = const Value.absent(),
    Value<String?> prescriptionRowsJson = const Value.absent(),
    Value<String?> followUpResultsJson = const Value.absent(),
    Value<int?> otherHospitalIdx = const Value.absent(),
    Value<String?> selectedMainDoctor = const Value.absent(),
    Value<String?> selectedMainNurse = const Value.absent(),
    Value<String?> nurseSignature = const Value.absent(),
    Value<String?> selectedEMT = const Value.absent(),
    Value<String?> emtSignature = const Value.absent(),
    Value<String?> helperNamesText = const Value.absent(),
    Value<String?> selectedHelpersJson = const Value.absent(),
    Value<String?> specialNotesJson = const Value.absent(),
    Value<String?> otherSpecialNote = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Treatment(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    screeningChecked: screeningChecked ?? this.screeningChecked,
    screeningMethodsJson: screeningMethodsJson.present
        ? screeningMethodsJson.value
        : this.screeningMethodsJson,
    otherScreeningMethod: otherScreeningMethod.present
        ? otherScreeningMethod.value
        : this.otherScreeningMethod,
    healthDataJson: healthDataJson.present
        ? healthDataJson.value
        : this.healthDataJson,
    mainSymptom: mainSymptom.present ? mainSymptom.value : this.mainSymptom,
    traumaSymptomsJson: traumaSymptomsJson.present
        ? traumaSymptomsJson.value
        : this.traumaSymptomsJson,
    nonTraumaSymptomsJson: nonTraumaSymptomsJson.present
        ? nonTraumaSymptomsJson.value
        : this.nonTraumaSymptomsJson,
    symptomNote: symptomNote.present ? symptomNote.value : this.symptomNote,
    photoTypesJson: photoTypesJson.present
        ? photoTypesJson.value
        : this.photoTypesJson,
    bodyCheckHead: bodyCheckHead.present
        ? bodyCheckHead.value
        : this.bodyCheckHead,
    bodyCheckChest: bodyCheckChest.present
        ? bodyCheckChest.value
        : this.bodyCheckChest,
    bodyCheckAbdomen: bodyCheckAbdomen.present
        ? bodyCheckAbdomen.value
        : this.bodyCheckAbdomen,
    bodyCheckLimbs: bodyCheckLimbs.present
        ? bodyCheckLimbs.value
        : this.bodyCheckLimbs,
    bodyCheckOther: bodyCheckOther.present
        ? bodyCheckOther.value
        : this.bodyCheckOther,
    temperature: temperature.present ? temperature.value : this.temperature,
    pulse: pulse.present ? pulse.value : this.pulse,
    respiration: respiration.present ? respiration.value : this.respiration,
    bpSystolic: bpSystolic.present ? bpSystolic.value : this.bpSystolic,
    bpDiastolic: bpDiastolic.present ? bpDiastolic.value : this.bpDiastolic,
    spo2: spo2.present ? spo2.value : this.spo2,
    consciousClear: consciousClear ?? this.consciousClear,
    evmE: evmE.present ? evmE.value : this.evmE,
    evmV: evmV.present ? evmV.value : this.evmV,
    evmM: evmM.present ? evmM.value : this.evmM,
    leftPupilScale: leftPupilScale.present
        ? leftPupilScale.value
        : this.leftPupilScale,
    leftPupilSize: leftPupilSize.present
        ? leftPupilSize.value
        : this.leftPupilSize,
    rightPupilScale: rightPupilScale.present
        ? rightPupilScale.value
        : this.rightPupilScale,
    rightPupilSize: rightPupilSize.present
        ? rightPupilSize.value
        : this.rightPupilSize,
    history: history.present ? history.value : this.history,
    allergy: allergy.present ? allergy.value : this.allergy,
    initialDiagnosis: initialDiagnosis.present
        ? initialDiagnosis.value
        : this.initialDiagnosis,
    diagnosisCategory: diagnosisCategory.present
        ? diagnosisCategory.value
        : this.diagnosisCategory,
    selectedICD10Main: selectedICD10Main.present
        ? selectedICD10Main.value
        : this.selectedICD10Main,
    selectedICD10Sub1: selectedICD10Sub1.present
        ? selectedICD10Sub1.value
        : this.selectedICD10Sub1,
    selectedICD10Sub2: selectedICD10Sub2.present
        ? selectedICD10Sub2.value
        : this.selectedICD10Sub2,
    triageCategory: triageCategory.present
        ? triageCategory.value
        : this.triageCategory,
    onSiteTreatmentsJson: onSiteTreatmentsJson.present
        ? onSiteTreatmentsJson.value
        : this.onSiteTreatmentsJson,
    ekgChecked: ekgChecked ?? this.ekgChecked,
    ekgReading: ekgReading.present ? ekgReading.value : this.ekgReading,
    sugarChecked: sugarChecked ?? this.sugarChecked,
    sugarReading: sugarReading.present ? sugarReading.value : this.sugarReading,
    suggestReferral: suggestReferral ?? this.suggestReferral,
    intubationChecked: intubationChecked ?? this.intubationChecked,
    cprChecked: cprChecked ?? this.cprChecked,
    oxygenTherapyChecked: oxygenTherapyChecked ?? this.oxygenTherapyChecked,
    medicalCertificateChecked:
        medicalCertificateChecked ?? this.medicalCertificateChecked,
    prescriptionChecked: prescriptionChecked ?? this.prescriptionChecked,
    otherChecked: otherChecked ?? this.otherChecked,
    otherSummary: otherSummary.present ? otherSummary.value : this.otherSummary,
    referralPassageType: referralPassageType.present
        ? referralPassageType.value
        : this.referralPassageType,
    referralAmbulanceType: referralAmbulanceType.present
        ? referralAmbulanceType.value
        : this.referralAmbulanceType,
    referralHospitalIdx: referralHospitalIdx.present
        ? referralHospitalIdx.value
        : this.referralHospitalIdx,
    referralOtherHospital: referralOtherHospital.present
        ? referralOtherHospital.value
        : this.referralOtherHospital,
    referralEscort: referralEscort.present
        ? referralEscort.value
        : this.referralEscort,
    intubationType: intubationType.present
        ? intubationType.value
        : this.intubationType,
    oxygenType: oxygenType.present ? oxygenType.value : this.oxygenType,
    oxygenFlow: oxygenFlow.present ? oxygenFlow.value : this.oxygenFlow,
    medicalCertificateTypesJson: medicalCertificateTypesJson.present
        ? medicalCertificateTypesJson.value
        : this.medicalCertificateTypesJson,
    prescriptionRowsJson: prescriptionRowsJson.present
        ? prescriptionRowsJson.value
        : this.prescriptionRowsJson,
    followUpResultsJson: followUpResultsJson.present
        ? followUpResultsJson.value
        : this.followUpResultsJson,
    otherHospitalIdx: otherHospitalIdx.present
        ? otherHospitalIdx.value
        : this.otherHospitalIdx,
    selectedMainDoctor: selectedMainDoctor.present
        ? selectedMainDoctor.value
        : this.selectedMainDoctor,
    selectedMainNurse: selectedMainNurse.present
        ? selectedMainNurse.value
        : this.selectedMainNurse,
    nurseSignature: nurseSignature.present
        ? nurseSignature.value
        : this.nurseSignature,
    selectedEMT: selectedEMT.present ? selectedEMT.value : this.selectedEMT,
    emtSignature: emtSignature.present ? emtSignature.value : this.emtSignature,
    helperNamesText: helperNamesText.present
        ? helperNamesText.value
        : this.helperNamesText,
    selectedHelpersJson: selectedHelpersJson.present
        ? selectedHelpersJson.value
        : this.selectedHelpersJson,
    specialNotesJson: specialNotesJson.present
        ? specialNotesJson.value
        : this.specialNotesJson,
    otherSpecialNote: otherSpecialNote.present
        ? otherSpecialNote.value
        : this.otherSpecialNote,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Treatment copyWithCompanion(TreatmentsCompanion data) {
    return Treatment(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      screeningChecked: data.screeningChecked.present
          ? data.screeningChecked.value
          : this.screeningChecked,
      screeningMethodsJson: data.screeningMethodsJson.present
          ? data.screeningMethodsJson.value
          : this.screeningMethodsJson,
      otherScreeningMethod: data.otherScreeningMethod.present
          ? data.otherScreeningMethod.value
          : this.otherScreeningMethod,
      healthDataJson: data.healthDataJson.present
          ? data.healthDataJson.value
          : this.healthDataJson,
      mainSymptom: data.mainSymptom.present
          ? data.mainSymptom.value
          : this.mainSymptom,
      traumaSymptomsJson: data.traumaSymptomsJson.present
          ? data.traumaSymptomsJson.value
          : this.traumaSymptomsJson,
      nonTraumaSymptomsJson: data.nonTraumaSymptomsJson.present
          ? data.nonTraumaSymptomsJson.value
          : this.nonTraumaSymptomsJson,
      symptomNote: data.symptomNote.present
          ? data.symptomNote.value
          : this.symptomNote,
      photoTypesJson: data.photoTypesJson.present
          ? data.photoTypesJson.value
          : this.photoTypesJson,
      bodyCheckHead: data.bodyCheckHead.present
          ? data.bodyCheckHead.value
          : this.bodyCheckHead,
      bodyCheckChest: data.bodyCheckChest.present
          ? data.bodyCheckChest.value
          : this.bodyCheckChest,
      bodyCheckAbdomen: data.bodyCheckAbdomen.present
          ? data.bodyCheckAbdomen.value
          : this.bodyCheckAbdomen,
      bodyCheckLimbs: data.bodyCheckLimbs.present
          ? data.bodyCheckLimbs.value
          : this.bodyCheckLimbs,
      bodyCheckOther: data.bodyCheckOther.present
          ? data.bodyCheckOther.value
          : this.bodyCheckOther,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      pulse: data.pulse.present ? data.pulse.value : this.pulse,
      respiration: data.respiration.present
          ? data.respiration.value
          : this.respiration,
      bpSystolic: data.bpSystolic.present
          ? data.bpSystolic.value
          : this.bpSystolic,
      bpDiastolic: data.bpDiastolic.present
          ? data.bpDiastolic.value
          : this.bpDiastolic,
      spo2: data.spo2.present ? data.spo2.value : this.spo2,
      consciousClear: data.consciousClear.present
          ? data.consciousClear.value
          : this.consciousClear,
      evmE: data.evmE.present ? data.evmE.value : this.evmE,
      evmV: data.evmV.present ? data.evmV.value : this.evmV,
      evmM: data.evmM.present ? data.evmM.value : this.evmM,
      leftPupilScale: data.leftPupilScale.present
          ? data.leftPupilScale.value
          : this.leftPupilScale,
      leftPupilSize: data.leftPupilSize.present
          ? data.leftPupilSize.value
          : this.leftPupilSize,
      rightPupilScale: data.rightPupilScale.present
          ? data.rightPupilScale.value
          : this.rightPupilScale,
      rightPupilSize: data.rightPupilSize.present
          ? data.rightPupilSize.value
          : this.rightPupilSize,
      history: data.history.present ? data.history.value : this.history,
      allergy: data.allergy.present ? data.allergy.value : this.allergy,
      initialDiagnosis: data.initialDiagnosis.present
          ? data.initialDiagnosis.value
          : this.initialDiagnosis,
      diagnosisCategory: data.diagnosisCategory.present
          ? data.diagnosisCategory.value
          : this.diagnosisCategory,
      selectedICD10Main: data.selectedICD10Main.present
          ? data.selectedICD10Main.value
          : this.selectedICD10Main,
      selectedICD10Sub1: data.selectedICD10Sub1.present
          ? data.selectedICD10Sub1.value
          : this.selectedICD10Sub1,
      selectedICD10Sub2: data.selectedICD10Sub2.present
          ? data.selectedICD10Sub2.value
          : this.selectedICD10Sub2,
      triageCategory: data.triageCategory.present
          ? data.triageCategory.value
          : this.triageCategory,
      onSiteTreatmentsJson: data.onSiteTreatmentsJson.present
          ? data.onSiteTreatmentsJson.value
          : this.onSiteTreatmentsJson,
      ekgChecked: data.ekgChecked.present
          ? data.ekgChecked.value
          : this.ekgChecked,
      ekgReading: data.ekgReading.present
          ? data.ekgReading.value
          : this.ekgReading,
      sugarChecked: data.sugarChecked.present
          ? data.sugarChecked.value
          : this.sugarChecked,
      sugarReading: data.sugarReading.present
          ? data.sugarReading.value
          : this.sugarReading,
      suggestReferral: data.suggestReferral.present
          ? data.suggestReferral.value
          : this.suggestReferral,
      intubationChecked: data.intubationChecked.present
          ? data.intubationChecked.value
          : this.intubationChecked,
      cprChecked: data.cprChecked.present
          ? data.cprChecked.value
          : this.cprChecked,
      oxygenTherapyChecked: data.oxygenTherapyChecked.present
          ? data.oxygenTherapyChecked.value
          : this.oxygenTherapyChecked,
      medicalCertificateChecked: data.medicalCertificateChecked.present
          ? data.medicalCertificateChecked.value
          : this.medicalCertificateChecked,
      prescriptionChecked: data.prescriptionChecked.present
          ? data.prescriptionChecked.value
          : this.prescriptionChecked,
      otherChecked: data.otherChecked.present
          ? data.otherChecked.value
          : this.otherChecked,
      otherSummary: data.otherSummary.present
          ? data.otherSummary.value
          : this.otherSummary,
      referralPassageType: data.referralPassageType.present
          ? data.referralPassageType.value
          : this.referralPassageType,
      referralAmbulanceType: data.referralAmbulanceType.present
          ? data.referralAmbulanceType.value
          : this.referralAmbulanceType,
      referralHospitalIdx: data.referralHospitalIdx.present
          ? data.referralHospitalIdx.value
          : this.referralHospitalIdx,
      referralOtherHospital: data.referralOtherHospital.present
          ? data.referralOtherHospital.value
          : this.referralOtherHospital,
      referralEscort: data.referralEscort.present
          ? data.referralEscort.value
          : this.referralEscort,
      intubationType: data.intubationType.present
          ? data.intubationType.value
          : this.intubationType,
      oxygenType: data.oxygenType.present
          ? data.oxygenType.value
          : this.oxygenType,
      oxygenFlow: data.oxygenFlow.present
          ? data.oxygenFlow.value
          : this.oxygenFlow,
      medicalCertificateTypesJson: data.medicalCertificateTypesJson.present
          ? data.medicalCertificateTypesJson.value
          : this.medicalCertificateTypesJson,
      prescriptionRowsJson: data.prescriptionRowsJson.present
          ? data.prescriptionRowsJson.value
          : this.prescriptionRowsJson,
      followUpResultsJson: data.followUpResultsJson.present
          ? data.followUpResultsJson.value
          : this.followUpResultsJson,
      otherHospitalIdx: data.otherHospitalIdx.present
          ? data.otherHospitalIdx.value
          : this.otherHospitalIdx,
      selectedMainDoctor: data.selectedMainDoctor.present
          ? data.selectedMainDoctor.value
          : this.selectedMainDoctor,
      selectedMainNurse: data.selectedMainNurse.present
          ? data.selectedMainNurse.value
          : this.selectedMainNurse,
      nurseSignature: data.nurseSignature.present
          ? data.nurseSignature.value
          : this.nurseSignature,
      selectedEMT: data.selectedEMT.present
          ? data.selectedEMT.value
          : this.selectedEMT,
      emtSignature: data.emtSignature.present
          ? data.emtSignature.value
          : this.emtSignature,
      helperNamesText: data.helperNamesText.present
          ? data.helperNamesText.value
          : this.helperNamesText,
      selectedHelpersJson: data.selectedHelpersJson.present
          ? data.selectedHelpersJson.value
          : this.selectedHelpersJson,
      specialNotesJson: data.specialNotesJson.present
          ? data.specialNotesJson.value
          : this.specialNotesJson,
      otherSpecialNote: data.otherSpecialNote.present
          ? data.otherSpecialNote.value
          : this.otherSpecialNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Treatment(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('screeningChecked: $screeningChecked, ')
          ..write('screeningMethodsJson: $screeningMethodsJson, ')
          ..write('otherScreeningMethod: $otherScreeningMethod, ')
          ..write('healthDataJson: $healthDataJson, ')
          ..write('mainSymptom: $mainSymptom, ')
          ..write('traumaSymptomsJson: $traumaSymptomsJson, ')
          ..write('nonTraumaSymptomsJson: $nonTraumaSymptomsJson, ')
          ..write('symptomNote: $symptomNote, ')
          ..write('photoTypesJson: $photoTypesJson, ')
          ..write('bodyCheckHead: $bodyCheckHead, ')
          ..write('bodyCheckChest: $bodyCheckChest, ')
          ..write('bodyCheckAbdomen: $bodyCheckAbdomen, ')
          ..write('bodyCheckLimbs: $bodyCheckLimbs, ')
          ..write('bodyCheckOther: $bodyCheckOther, ')
          ..write('temperature: $temperature, ')
          ..write('pulse: $pulse, ')
          ..write('respiration: $respiration, ')
          ..write('bpSystolic: $bpSystolic, ')
          ..write('bpDiastolic: $bpDiastolic, ')
          ..write('spo2: $spo2, ')
          ..write('consciousClear: $consciousClear, ')
          ..write('evmE: $evmE, ')
          ..write('evmV: $evmV, ')
          ..write('evmM: $evmM, ')
          ..write('leftPupilScale: $leftPupilScale, ')
          ..write('leftPupilSize: $leftPupilSize, ')
          ..write('rightPupilScale: $rightPupilScale, ')
          ..write('rightPupilSize: $rightPupilSize, ')
          ..write('history: $history, ')
          ..write('allergy: $allergy, ')
          ..write('initialDiagnosis: $initialDiagnosis, ')
          ..write('diagnosisCategory: $diagnosisCategory, ')
          ..write('selectedICD10Main: $selectedICD10Main, ')
          ..write('selectedICD10Sub1: $selectedICD10Sub1, ')
          ..write('selectedICD10Sub2: $selectedICD10Sub2, ')
          ..write('triageCategory: $triageCategory, ')
          ..write('onSiteTreatmentsJson: $onSiteTreatmentsJson, ')
          ..write('ekgChecked: $ekgChecked, ')
          ..write('ekgReading: $ekgReading, ')
          ..write('sugarChecked: $sugarChecked, ')
          ..write('sugarReading: $sugarReading, ')
          ..write('suggestReferral: $suggestReferral, ')
          ..write('intubationChecked: $intubationChecked, ')
          ..write('cprChecked: $cprChecked, ')
          ..write('oxygenTherapyChecked: $oxygenTherapyChecked, ')
          ..write('medicalCertificateChecked: $medicalCertificateChecked, ')
          ..write('prescriptionChecked: $prescriptionChecked, ')
          ..write('otherChecked: $otherChecked, ')
          ..write('otherSummary: $otherSummary, ')
          ..write('referralPassageType: $referralPassageType, ')
          ..write('referralAmbulanceType: $referralAmbulanceType, ')
          ..write('referralHospitalIdx: $referralHospitalIdx, ')
          ..write('referralOtherHospital: $referralOtherHospital, ')
          ..write('referralEscort: $referralEscort, ')
          ..write('intubationType: $intubationType, ')
          ..write('oxygenType: $oxygenType, ')
          ..write('oxygenFlow: $oxygenFlow, ')
          ..write('medicalCertificateTypesJson: $medicalCertificateTypesJson, ')
          ..write('prescriptionRowsJson: $prescriptionRowsJson, ')
          ..write('followUpResultsJson: $followUpResultsJson, ')
          ..write('otherHospitalIdx: $otherHospitalIdx, ')
          ..write('selectedMainDoctor: $selectedMainDoctor, ')
          ..write('selectedMainNurse: $selectedMainNurse, ')
          ..write('nurseSignature: $nurseSignature, ')
          ..write('selectedEMT: $selectedEMT, ')
          ..write('emtSignature: $emtSignature, ')
          ..write('helperNamesText: $helperNamesText, ')
          ..write('selectedHelpersJson: $selectedHelpersJson, ')
          ..write('specialNotesJson: $specialNotesJson, ')
          ..write('otherSpecialNote: $otherSpecialNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    visitId,
    screeningChecked,
    screeningMethodsJson,
    otherScreeningMethod,
    healthDataJson,
    mainSymptom,
    traumaSymptomsJson,
    nonTraumaSymptomsJson,
    symptomNote,
    photoTypesJson,
    bodyCheckHead,
    bodyCheckChest,
    bodyCheckAbdomen,
    bodyCheckLimbs,
    bodyCheckOther,
    temperature,
    pulse,
    respiration,
    bpSystolic,
    bpDiastolic,
    spo2,
    consciousClear,
    evmE,
    evmV,
    evmM,
    leftPupilScale,
    leftPupilSize,
    rightPupilScale,
    rightPupilSize,
    history,
    allergy,
    initialDiagnosis,
    diagnosisCategory,
    selectedICD10Main,
    selectedICD10Sub1,
    selectedICD10Sub2,
    triageCategory,
    onSiteTreatmentsJson,
    ekgChecked,
    ekgReading,
    sugarChecked,
    sugarReading,
    suggestReferral,
    intubationChecked,
    cprChecked,
    oxygenTherapyChecked,
    medicalCertificateChecked,
    prescriptionChecked,
    otherChecked,
    otherSummary,
    referralPassageType,
    referralAmbulanceType,
    referralHospitalIdx,
    referralOtherHospital,
    referralEscort,
    intubationType,
    oxygenType,
    oxygenFlow,
    medicalCertificateTypesJson,
    prescriptionRowsJson,
    followUpResultsJson,
    otherHospitalIdx,
    selectedMainDoctor,
    selectedMainNurse,
    nurseSignature,
    selectedEMT,
    emtSignature,
    helperNamesText,
    selectedHelpersJson,
    specialNotesJson,
    otherSpecialNote,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Treatment &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.screeningChecked == this.screeningChecked &&
          other.screeningMethodsJson == this.screeningMethodsJson &&
          other.otherScreeningMethod == this.otherScreeningMethod &&
          other.healthDataJson == this.healthDataJson &&
          other.mainSymptom == this.mainSymptom &&
          other.traumaSymptomsJson == this.traumaSymptomsJson &&
          other.nonTraumaSymptomsJson == this.nonTraumaSymptomsJson &&
          other.symptomNote == this.symptomNote &&
          other.photoTypesJson == this.photoTypesJson &&
          other.bodyCheckHead == this.bodyCheckHead &&
          other.bodyCheckChest == this.bodyCheckChest &&
          other.bodyCheckAbdomen == this.bodyCheckAbdomen &&
          other.bodyCheckLimbs == this.bodyCheckLimbs &&
          other.bodyCheckOther == this.bodyCheckOther &&
          other.temperature == this.temperature &&
          other.pulse == this.pulse &&
          other.respiration == this.respiration &&
          other.bpSystolic == this.bpSystolic &&
          other.bpDiastolic == this.bpDiastolic &&
          other.spo2 == this.spo2 &&
          other.consciousClear == this.consciousClear &&
          other.evmE == this.evmE &&
          other.evmV == this.evmV &&
          other.evmM == this.evmM &&
          other.leftPupilScale == this.leftPupilScale &&
          other.leftPupilSize == this.leftPupilSize &&
          other.rightPupilScale == this.rightPupilScale &&
          other.rightPupilSize == this.rightPupilSize &&
          other.history == this.history &&
          other.allergy == this.allergy &&
          other.initialDiagnosis == this.initialDiagnosis &&
          other.diagnosisCategory == this.diagnosisCategory &&
          other.selectedICD10Main == this.selectedICD10Main &&
          other.selectedICD10Sub1 == this.selectedICD10Sub1 &&
          other.selectedICD10Sub2 == this.selectedICD10Sub2 &&
          other.triageCategory == this.triageCategory &&
          other.onSiteTreatmentsJson == this.onSiteTreatmentsJson &&
          other.ekgChecked == this.ekgChecked &&
          other.ekgReading == this.ekgReading &&
          other.sugarChecked == this.sugarChecked &&
          other.sugarReading == this.sugarReading &&
          other.suggestReferral == this.suggestReferral &&
          other.intubationChecked == this.intubationChecked &&
          other.cprChecked == this.cprChecked &&
          other.oxygenTherapyChecked == this.oxygenTherapyChecked &&
          other.medicalCertificateChecked == this.medicalCertificateChecked &&
          other.prescriptionChecked == this.prescriptionChecked &&
          other.otherChecked == this.otherChecked &&
          other.otherSummary == this.otherSummary &&
          other.referralPassageType == this.referralPassageType &&
          other.referralAmbulanceType == this.referralAmbulanceType &&
          other.referralHospitalIdx == this.referralHospitalIdx &&
          other.referralOtherHospital == this.referralOtherHospital &&
          other.referralEscort == this.referralEscort &&
          other.intubationType == this.intubationType &&
          other.oxygenType == this.oxygenType &&
          other.oxygenFlow == this.oxygenFlow &&
          other.medicalCertificateTypesJson ==
              this.medicalCertificateTypesJson &&
          other.prescriptionRowsJson == this.prescriptionRowsJson &&
          other.followUpResultsJson == this.followUpResultsJson &&
          other.otherHospitalIdx == this.otherHospitalIdx &&
          other.selectedMainDoctor == this.selectedMainDoctor &&
          other.selectedMainNurse == this.selectedMainNurse &&
          other.nurseSignature == this.nurseSignature &&
          other.selectedEMT == this.selectedEMT &&
          other.emtSignature == this.emtSignature &&
          other.helperNamesText == this.helperNamesText &&
          other.selectedHelpersJson == this.selectedHelpersJson &&
          other.specialNotesJson == this.specialNotesJson &&
          other.otherSpecialNote == this.otherSpecialNote &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TreatmentsCompanion extends UpdateCompanion<Treatment> {
  final Value<int> id;
  final Value<int> visitId;
  final Value<bool> screeningChecked;
  final Value<String?> screeningMethodsJson;
  final Value<String?> otherScreeningMethod;
  final Value<String?> healthDataJson;
  final Value<int?> mainSymptom;
  final Value<String?> traumaSymptomsJson;
  final Value<String?> nonTraumaSymptomsJson;
  final Value<String?> symptomNote;
  final Value<String?> photoTypesJson;
  final Value<String?> bodyCheckHead;
  final Value<String?> bodyCheckChest;
  final Value<String?> bodyCheckAbdomen;
  final Value<String?> bodyCheckLimbs;
  final Value<String?> bodyCheckOther;
  final Value<String?> temperature;
  final Value<String?> pulse;
  final Value<String?> respiration;
  final Value<String?> bpSystolic;
  final Value<String?> bpDiastolic;
  final Value<String?> spo2;
  final Value<bool> consciousClear;
  final Value<String?> evmE;
  final Value<String?> evmV;
  final Value<String?> evmM;
  final Value<int?> leftPupilScale;
  final Value<String?> leftPupilSize;
  final Value<int?> rightPupilScale;
  final Value<String?> rightPupilSize;
  final Value<int?> history;
  final Value<int?> allergy;
  final Value<String?> initialDiagnosis;
  final Value<int?> diagnosisCategory;
  final Value<String?> selectedICD10Main;
  final Value<String?> selectedICD10Sub1;
  final Value<String?> selectedICD10Sub2;
  final Value<int?> triageCategory;
  final Value<String?> onSiteTreatmentsJson;
  final Value<bool> ekgChecked;
  final Value<String?> ekgReading;
  final Value<bool> sugarChecked;
  final Value<String?> sugarReading;
  final Value<bool> suggestReferral;
  final Value<bool> intubationChecked;
  final Value<bool> cprChecked;
  final Value<bool> oxygenTherapyChecked;
  final Value<bool> medicalCertificateChecked;
  final Value<bool> prescriptionChecked;
  final Value<bool> otherChecked;
  final Value<String?> otherSummary;
  final Value<int?> referralPassageType;
  final Value<int?> referralAmbulanceType;
  final Value<int?> referralHospitalIdx;
  final Value<String?> referralOtherHospital;
  final Value<String?> referralEscort;
  final Value<int?> intubationType;
  final Value<int?> oxygenType;
  final Value<String?> oxygenFlow;
  final Value<String?> medicalCertificateTypesJson;
  final Value<String?> prescriptionRowsJson;
  final Value<String?> followUpResultsJson;
  final Value<int?> otherHospitalIdx;
  final Value<String?> selectedMainDoctor;
  final Value<String?> selectedMainNurse;
  final Value<String?> nurseSignature;
  final Value<String?> selectedEMT;
  final Value<String?> emtSignature;
  final Value<String?> helperNamesText;
  final Value<String?> selectedHelpersJson;
  final Value<String?> specialNotesJson;
  final Value<String?> otherSpecialNote;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TreatmentsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.screeningChecked = const Value.absent(),
    this.screeningMethodsJson = const Value.absent(),
    this.otherScreeningMethod = const Value.absent(),
    this.healthDataJson = const Value.absent(),
    this.mainSymptom = const Value.absent(),
    this.traumaSymptomsJson = const Value.absent(),
    this.nonTraumaSymptomsJson = const Value.absent(),
    this.symptomNote = const Value.absent(),
    this.photoTypesJson = const Value.absent(),
    this.bodyCheckHead = const Value.absent(),
    this.bodyCheckChest = const Value.absent(),
    this.bodyCheckAbdomen = const Value.absent(),
    this.bodyCheckLimbs = const Value.absent(),
    this.bodyCheckOther = const Value.absent(),
    this.temperature = const Value.absent(),
    this.pulse = const Value.absent(),
    this.respiration = const Value.absent(),
    this.bpSystolic = const Value.absent(),
    this.bpDiastolic = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.consciousClear = const Value.absent(),
    this.evmE = const Value.absent(),
    this.evmV = const Value.absent(),
    this.evmM = const Value.absent(),
    this.leftPupilScale = const Value.absent(),
    this.leftPupilSize = const Value.absent(),
    this.rightPupilScale = const Value.absent(),
    this.rightPupilSize = const Value.absent(),
    this.history = const Value.absent(),
    this.allergy = const Value.absent(),
    this.initialDiagnosis = const Value.absent(),
    this.diagnosisCategory = const Value.absent(),
    this.selectedICD10Main = const Value.absent(),
    this.selectedICD10Sub1 = const Value.absent(),
    this.selectedICD10Sub2 = const Value.absent(),
    this.triageCategory = const Value.absent(),
    this.onSiteTreatmentsJson = const Value.absent(),
    this.ekgChecked = const Value.absent(),
    this.ekgReading = const Value.absent(),
    this.sugarChecked = const Value.absent(),
    this.sugarReading = const Value.absent(),
    this.suggestReferral = const Value.absent(),
    this.intubationChecked = const Value.absent(),
    this.cprChecked = const Value.absent(),
    this.oxygenTherapyChecked = const Value.absent(),
    this.medicalCertificateChecked = const Value.absent(),
    this.prescriptionChecked = const Value.absent(),
    this.otherChecked = const Value.absent(),
    this.otherSummary = const Value.absent(),
    this.referralPassageType = const Value.absent(),
    this.referralAmbulanceType = const Value.absent(),
    this.referralHospitalIdx = const Value.absent(),
    this.referralOtherHospital = const Value.absent(),
    this.referralEscort = const Value.absent(),
    this.intubationType = const Value.absent(),
    this.oxygenType = const Value.absent(),
    this.oxygenFlow = const Value.absent(),
    this.medicalCertificateTypesJson = const Value.absent(),
    this.prescriptionRowsJson = const Value.absent(),
    this.followUpResultsJson = const Value.absent(),
    this.otherHospitalIdx = const Value.absent(),
    this.selectedMainDoctor = const Value.absent(),
    this.selectedMainNurse = const Value.absent(),
    this.nurseSignature = const Value.absent(),
    this.selectedEMT = const Value.absent(),
    this.emtSignature = const Value.absent(),
    this.helperNamesText = const Value.absent(),
    this.selectedHelpersJson = const Value.absent(),
    this.specialNotesJson = const Value.absent(),
    this.otherSpecialNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TreatmentsCompanion.insert({
    this.id = const Value.absent(),
    required int visitId,
    this.screeningChecked = const Value.absent(),
    this.screeningMethodsJson = const Value.absent(),
    this.otherScreeningMethod = const Value.absent(),
    this.healthDataJson = const Value.absent(),
    this.mainSymptom = const Value.absent(),
    this.traumaSymptomsJson = const Value.absent(),
    this.nonTraumaSymptomsJson = const Value.absent(),
    this.symptomNote = const Value.absent(),
    this.photoTypesJson = const Value.absent(),
    this.bodyCheckHead = const Value.absent(),
    this.bodyCheckChest = const Value.absent(),
    this.bodyCheckAbdomen = const Value.absent(),
    this.bodyCheckLimbs = const Value.absent(),
    this.bodyCheckOther = const Value.absent(),
    this.temperature = const Value.absent(),
    this.pulse = const Value.absent(),
    this.respiration = const Value.absent(),
    this.bpSystolic = const Value.absent(),
    this.bpDiastolic = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.consciousClear = const Value.absent(),
    this.evmE = const Value.absent(),
    this.evmV = const Value.absent(),
    this.evmM = const Value.absent(),
    this.leftPupilScale = const Value.absent(),
    this.leftPupilSize = const Value.absent(),
    this.rightPupilScale = const Value.absent(),
    this.rightPupilSize = const Value.absent(),
    this.history = const Value.absent(),
    this.allergy = const Value.absent(),
    this.initialDiagnosis = const Value.absent(),
    this.diagnosisCategory = const Value.absent(),
    this.selectedICD10Main = const Value.absent(),
    this.selectedICD10Sub1 = const Value.absent(),
    this.selectedICD10Sub2 = const Value.absent(),
    this.triageCategory = const Value.absent(),
    this.onSiteTreatmentsJson = const Value.absent(),
    this.ekgChecked = const Value.absent(),
    this.ekgReading = const Value.absent(),
    this.sugarChecked = const Value.absent(),
    this.sugarReading = const Value.absent(),
    this.suggestReferral = const Value.absent(),
    this.intubationChecked = const Value.absent(),
    this.cprChecked = const Value.absent(),
    this.oxygenTherapyChecked = const Value.absent(),
    this.medicalCertificateChecked = const Value.absent(),
    this.prescriptionChecked = const Value.absent(),
    this.otherChecked = const Value.absent(),
    this.otherSummary = const Value.absent(),
    this.referralPassageType = const Value.absent(),
    this.referralAmbulanceType = const Value.absent(),
    this.referralHospitalIdx = const Value.absent(),
    this.referralOtherHospital = const Value.absent(),
    this.referralEscort = const Value.absent(),
    this.intubationType = const Value.absent(),
    this.oxygenType = const Value.absent(),
    this.oxygenFlow = const Value.absent(),
    this.medicalCertificateTypesJson = const Value.absent(),
    this.prescriptionRowsJson = const Value.absent(),
    this.followUpResultsJson = const Value.absent(),
    this.otherHospitalIdx = const Value.absent(),
    this.selectedMainDoctor = const Value.absent(),
    this.selectedMainNurse = const Value.absent(),
    this.nurseSignature = const Value.absent(),
    this.selectedEMT = const Value.absent(),
    this.emtSignature = const Value.absent(),
    this.helperNamesText = const Value.absent(),
    this.selectedHelpersJson = const Value.absent(),
    this.specialNotesJson = const Value.absent(),
    this.otherSpecialNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : visitId = Value(visitId);
  static Insertable<Treatment> custom({
    Expression<int>? id,
    Expression<int>? visitId,
    Expression<bool>? screeningChecked,
    Expression<String>? screeningMethodsJson,
    Expression<String>? otherScreeningMethod,
    Expression<String>? healthDataJson,
    Expression<int>? mainSymptom,
    Expression<String>? traumaSymptomsJson,
    Expression<String>? nonTraumaSymptomsJson,
    Expression<String>? symptomNote,
    Expression<String>? photoTypesJson,
    Expression<String>? bodyCheckHead,
    Expression<String>? bodyCheckChest,
    Expression<String>? bodyCheckAbdomen,
    Expression<String>? bodyCheckLimbs,
    Expression<String>? bodyCheckOther,
    Expression<String>? temperature,
    Expression<String>? pulse,
    Expression<String>? respiration,
    Expression<String>? bpSystolic,
    Expression<String>? bpDiastolic,
    Expression<String>? spo2,
    Expression<bool>? consciousClear,
    Expression<String>? evmE,
    Expression<String>? evmV,
    Expression<String>? evmM,
    Expression<int>? leftPupilScale,
    Expression<String>? leftPupilSize,
    Expression<int>? rightPupilScale,
    Expression<String>? rightPupilSize,
    Expression<int>? history,
    Expression<int>? allergy,
    Expression<String>? initialDiagnosis,
    Expression<int>? diagnosisCategory,
    Expression<String>? selectedICD10Main,
    Expression<String>? selectedICD10Sub1,
    Expression<String>? selectedICD10Sub2,
    Expression<int>? triageCategory,
    Expression<String>? onSiteTreatmentsJson,
    Expression<bool>? ekgChecked,
    Expression<String>? ekgReading,
    Expression<bool>? sugarChecked,
    Expression<String>? sugarReading,
    Expression<bool>? suggestReferral,
    Expression<bool>? intubationChecked,
    Expression<bool>? cprChecked,
    Expression<bool>? oxygenTherapyChecked,
    Expression<bool>? medicalCertificateChecked,
    Expression<bool>? prescriptionChecked,
    Expression<bool>? otherChecked,
    Expression<String>? otherSummary,
    Expression<int>? referralPassageType,
    Expression<int>? referralAmbulanceType,
    Expression<int>? referralHospitalIdx,
    Expression<String>? referralOtherHospital,
    Expression<String>? referralEscort,
    Expression<int>? intubationType,
    Expression<int>? oxygenType,
    Expression<String>? oxygenFlow,
    Expression<String>? medicalCertificateTypesJson,
    Expression<String>? prescriptionRowsJson,
    Expression<String>? followUpResultsJson,
    Expression<int>? otherHospitalIdx,
    Expression<String>? selectedMainDoctor,
    Expression<String>? selectedMainNurse,
    Expression<String>? nurseSignature,
    Expression<String>? selectedEMT,
    Expression<String>? emtSignature,
    Expression<String>? helperNamesText,
    Expression<String>? selectedHelpersJson,
    Expression<String>? specialNotesJson,
    Expression<String>? otherSpecialNote,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (screeningChecked != null) 'screening_checked': screeningChecked,
      if (screeningMethodsJson != null)
        'screening_methods_json': screeningMethodsJson,
      if (otherScreeningMethod != null)
        'other_screening_method': otherScreeningMethod,
      if (healthDataJson != null) 'health_data_json': healthDataJson,
      if (mainSymptom != null) 'main_symptom': mainSymptom,
      if (traumaSymptomsJson != null)
        'trauma_symptoms_json': traumaSymptomsJson,
      if (nonTraumaSymptomsJson != null)
        'non_trauma_symptoms_json': nonTraumaSymptomsJson,
      if (symptomNote != null) 'symptom_note': symptomNote,
      if (photoTypesJson != null) 'photo_types_json': photoTypesJson,
      if (bodyCheckHead != null) 'body_check_head': bodyCheckHead,
      if (bodyCheckChest != null) 'body_check_chest': bodyCheckChest,
      if (bodyCheckAbdomen != null) 'body_check_abdomen': bodyCheckAbdomen,
      if (bodyCheckLimbs != null) 'body_check_limbs': bodyCheckLimbs,
      if (bodyCheckOther != null) 'body_check_other': bodyCheckOther,
      if (temperature != null) 'temperature': temperature,
      if (pulse != null) 'pulse': pulse,
      if (respiration != null) 'respiration': respiration,
      if (bpSystolic != null) 'bp_systolic': bpSystolic,
      if (bpDiastolic != null) 'bp_diastolic': bpDiastolic,
      if (spo2 != null) 'spo2': spo2,
      if (consciousClear != null) 'conscious_clear': consciousClear,
      if (evmE != null) 'evm_e': evmE,
      if (evmV != null) 'evm_v': evmV,
      if (evmM != null) 'evm_m': evmM,
      if (leftPupilScale != null) 'left_pupil_scale': leftPupilScale,
      if (leftPupilSize != null) 'left_pupil_size': leftPupilSize,
      if (rightPupilScale != null) 'right_pupil_scale': rightPupilScale,
      if (rightPupilSize != null) 'right_pupil_size': rightPupilSize,
      if (history != null) 'history': history,
      if (allergy != null) 'allergy': allergy,
      if (initialDiagnosis != null) 'initial_diagnosis': initialDiagnosis,
      if (diagnosisCategory != null) 'diagnosis_category': diagnosisCategory,
      if (selectedICD10Main != null) 'selected_i_c_d10_main': selectedICD10Main,
      if (selectedICD10Sub1 != null) 'selected_i_c_d10_sub1': selectedICD10Sub1,
      if (selectedICD10Sub2 != null) 'selected_i_c_d10_sub2': selectedICD10Sub2,
      if (triageCategory != null) 'triage_category': triageCategory,
      if (onSiteTreatmentsJson != null)
        'on_site_treatments_json': onSiteTreatmentsJson,
      if (ekgChecked != null) 'ekg_checked': ekgChecked,
      if (ekgReading != null) 'ekg_reading': ekgReading,
      if (sugarChecked != null) 'sugar_checked': sugarChecked,
      if (sugarReading != null) 'sugar_reading': sugarReading,
      if (suggestReferral != null) 'suggest_referral': suggestReferral,
      if (intubationChecked != null) 'intubation_checked': intubationChecked,
      if (cprChecked != null) 'cpr_checked': cprChecked,
      if (oxygenTherapyChecked != null)
        'oxygen_therapy_checked': oxygenTherapyChecked,
      if (medicalCertificateChecked != null)
        'medical_certificate_checked': medicalCertificateChecked,
      if (prescriptionChecked != null)
        'prescription_checked': prescriptionChecked,
      if (otherChecked != null) 'other_checked': otherChecked,
      if (otherSummary != null) 'other_summary': otherSummary,
      if (referralPassageType != null)
        'referral_passage_type': referralPassageType,
      if (referralAmbulanceType != null)
        'referral_ambulance_type': referralAmbulanceType,
      if (referralHospitalIdx != null)
        'referral_hospital_idx': referralHospitalIdx,
      if (referralOtherHospital != null)
        'referral_other_hospital': referralOtherHospital,
      if (referralEscort != null) 'referral_escort': referralEscort,
      if (intubationType != null) 'intubation_type': intubationType,
      if (oxygenType != null) 'oxygen_type': oxygenType,
      if (oxygenFlow != null) 'oxygen_flow': oxygenFlow,
      if (medicalCertificateTypesJson != null)
        'medical_certificate_types_json': medicalCertificateTypesJson,
      if (prescriptionRowsJson != null)
        'prescription_rows_json': prescriptionRowsJson,
      if (followUpResultsJson != null)
        'follow_up_results_json': followUpResultsJson,
      if (otherHospitalIdx != null) 'other_hospital_idx': otherHospitalIdx,
      if (selectedMainDoctor != null)
        'selected_main_doctor': selectedMainDoctor,
      if (selectedMainNurse != null) 'selected_main_nurse': selectedMainNurse,
      if (nurseSignature != null) 'nurse_signature': nurseSignature,
      if (selectedEMT != null) 'selected_e_m_t': selectedEMT,
      if (emtSignature != null) 'emt_signature': emtSignature,
      if (helperNamesText != null) 'helper_names_text': helperNamesText,
      if (selectedHelpersJson != null)
        'selected_helpers_json': selectedHelpersJson,
      if (specialNotesJson != null) 'special_notes_json': specialNotesJson,
      if (otherSpecialNote != null) 'other_special_note': otherSpecialNote,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TreatmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? visitId,
    Value<bool>? screeningChecked,
    Value<String?>? screeningMethodsJson,
    Value<String?>? otherScreeningMethod,
    Value<String?>? healthDataJson,
    Value<int?>? mainSymptom,
    Value<String?>? traumaSymptomsJson,
    Value<String?>? nonTraumaSymptomsJson,
    Value<String?>? symptomNote,
    Value<String?>? photoTypesJson,
    Value<String?>? bodyCheckHead,
    Value<String?>? bodyCheckChest,
    Value<String?>? bodyCheckAbdomen,
    Value<String?>? bodyCheckLimbs,
    Value<String?>? bodyCheckOther,
    Value<String?>? temperature,
    Value<String?>? pulse,
    Value<String?>? respiration,
    Value<String?>? bpSystolic,
    Value<String?>? bpDiastolic,
    Value<String?>? spo2,
    Value<bool>? consciousClear,
    Value<String?>? evmE,
    Value<String?>? evmV,
    Value<String?>? evmM,
    Value<int?>? leftPupilScale,
    Value<String?>? leftPupilSize,
    Value<int?>? rightPupilScale,
    Value<String?>? rightPupilSize,
    Value<int?>? history,
    Value<int?>? allergy,
    Value<String?>? initialDiagnosis,
    Value<int?>? diagnosisCategory,
    Value<String?>? selectedICD10Main,
    Value<String?>? selectedICD10Sub1,
    Value<String?>? selectedICD10Sub2,
    Value<int?>? triageCategory,
    Value<String?>? onSiteTreatmentsJson,
    Value<bool>? ekgChecked,
    Value<String?>? ekgReading,
    Value<bool>? sugarChecked,
    Value<String?>? sugarReading,
    Value<bool>? suggestReferral,
    Value<bool>? intubationChecked,
    Value<bool>? cprChecked,
    Value<bool>? oxygenTherapyChecked,
    Value<bool>? medicalCertificateChecked,
    Value<bool>? prescriptionChecked,
    Value<bool>? otherChecked,
    Value<String?>? otherSummary,
    Value<int?>? referralPassageType,
    Value<int?>? referralAmbulanceType,
    Value<int?>? referralHospitalIdx,
    Value<String?>? referralOtherHospital,
    Value<String?>? referralEscort,
    Value<int?>? intubationType,
    Value<int?>? oxygenType,
    Value<String?>? oxygenFlow,
    Value<String?>? medicalCertificateTypesJson,
    Value<String?>? prescriptionRowsJson,
    Value<String?>? followUpResultsJson,
    Value<int?>? otherHospitalIdx,
    Value<String?>? selectedMainDoctor,
    Value<String?>? selectedMainNurse,
    Value<String?>? nurseSignature,
    Value<String?>? selectedEMT,
    Value<String?>? emtSignature,
    Value<String?>? helperNamesText,
    Value<String?>? selectedHelpersJson,
    Value<String?>? specialNotesJson,
    Value<String?>? otherSpecialNote,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TreatmentsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      screeningChecked: screeningChecked ?? this.screeningChecked,
      screeningMethodsJson: screeningMethodsJson ?? this.screeningMethodsJson,
      otherScreeningMethod: otherScreeningMethod ?? this.otherScreeningMethod,
      healthDataJson: healthDataJson ?? this.healthDataJson,
      mainSymptom: mainSymptom ?? this.mainSymptom,
      traumaSymptomsJson: traumaSymptomsJson ?? this.traumaSymptomsJson,
      nonTraumaSymptomsJson:
          nonTraumaSymptomsJson ?? this.nonTraumaSymptomsJson,
      symptomNote: symptomNote ?? this.symptomNote,
      photoTypesJson: photoTypesJson ?? this.photoTypesJson,
      bodyCheckHead: bodyCheckHead ?? this.bodyCheckHead,
      bodyCheckChest: bodyCheckChest ?? this.bodyCheckChest,
      bodyCheckAbdomen: bodyCheckAbdomen ?? this.bodyCheckAbdomen,
      bodyCheckLimbs: bodyCheckLimbs ?? this.bodyCheckLimbs,
      bodyCheckOther: bodyCheckOther ?? this.bodyCheckOther,
      temperature: temperature ?? this.temperature,
      pulse: pulse ?? this.pulse,
      respiration: respiration ?? this.respiration,
      bpSystolic: bpSystolic ?? this.bpSystolic,
      bpDiastolic: bpDiastolic ?? this.bpDiastolic,
      spo2: spo2 ?? this.spo2,
      consciousClear: consciousClear ?? this.consciousClear,
      evmE: evmE ?? this.evmE,
      evmV: evmV ?? this.evmV,
      evmM: evmM ?? this.evmM,
      leftPupilScale: leftPupilScale ?? this.leftPupilScale,
      leftPupilSize: leftPupilSize ?? this.leftPupilSize,
      rightPupilScale: rightPupilScale ?? this.rightPupilScale,
      rightPupilSize: rightPupilSize ?? this.rightPupilSize,
      history: history ?? this.history,
      allergy: allergy ?? this.allergy,
      initialDiagnosis: initialDiagnosis ?? this.initialDiagnosis,
      diagnosisCategory: diagnosisCategory ?? this.diagnosisCategory,
      selectedICD10Main: selectedICD10Main ?? this.selectedICD10Main,
      selectedICD10Sub1: selectedICD10Sub1 ?? this.selectedICD10Sub1,
      selectedICD10Sub2: selectedICD10Sub2 ?? this.selectedICD10Sub2,
      triageCategory: triageCategory ?? this.triageCategory,
      onSiteTreatmentsJson: onSiteTreatmentsJson ?? this.onSiteTreatmentsJson,
      ekgChecked: ekgChecked ?? this.ekgChecked,
      ekgReading: ekgReading ?? this.ekgReading,
      sugarChecked: sugarChecked ?? this.sugarChecked,
      sugarReading: sugarReading ?? this.sugarReading,
      suggestReferral: suggestReferral ?? this.suggestReferral,
      intubationChecked: intubationChecked ?? this.intubationChecked,
      cprChecked: cprChecked ?? this.cprChecked,
      oxygenTherapyChecked: oxygenTherapyChecked ?? this.oxygenTherapyChecked,
      medicalCertificateChecked:
          medicalCertificateChecked ?? this.medicalCertificateChecked,
      prescriptionChecked: prescriptionChecked ?? this.prescriptionChecked,
      otherChecked: otherChecked ?? this.otherChecked,
      otherSummary: otherSummary ?? this.otherSummary,
      referralPassageType: referralPassageType ?? this.referralPassageType,
      referralAmbulanceType:
          referralAmbulanceType ?? this.referralAmbulanceType,
      referralHospitalIdx: referralHospitalIdx ?? this.referralHospitalIdx,
      referralOtherHospital:
          referralOtherHospital ?? this.referralOtherHospital,
      referralEscort: referralEscort ?? this.referralEscort,
      intubationType: intubationType ?? this.intubationType,
      oxygenType: oxygenType ?? this.oxygenType,
      oxygenFlow: oxygenFlow ?? this.oxygenFlow,
      medicalCertificateTypesJson:
          medicalCertificateTypesJson ?? this.medicalCertificateTypesJson,
      prescriptionRowsJson: prescriptionRowsJson ?? this.prescriptionRowsJson,
      followUpResultsJson: followUpResultsJson ?? this.followUpResultsJson,
      otherHospitalIdx: otherHospitalIdx ?? this.otherHospitalIdx,
      selectedMainDoctor: selectedMainDoctor ?? this.selectedMainDoctor,
      selectedMainNurse: selectedMainNurse ?? this.selectedMainNurse,
      nurseSignature: nurseSignature ?? this.nurseSignature,
      selectedEMT: selectedEMT ?? this.selectedEMT,
      emtSignature: emtSignature ?? this.emtSignature,
      helperNamesText: helperNamesText ?? this.helperNamesText,
      selectedHelpersJson: selectedHelpersJson ?? this.selectedHelpersJson,
      specialNotesJson: specialNotesJson ?? this.specialNotesJson,
      otherSpecialNote: otherSpecialNote ?? this.otherSpecialNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (screeningChecked.present) {
      map['screening_checked'] = Variable<bool>(screeningChecked.value);
    }
    if (screeningMethodsJson.present) {
      map['screening_methods_json'] = Variable<String>(
        screeningMethodsJson.value,
      );
    }
    if (otherScreeningMethod.present) {
      map['other_screening_method'] = Variable<String>(
        otherScreeningMethod.value,
      );
    }
    if (healthDataJson.present) {
      map['health_data_json'] = Variable<String>(healthDataJson.value);
    }
    if (mainSymptom.present) {
      map['main_symptom'] = Variable<int>(mainSymptom.value);
    }
    if (traumaSymptomsJson.present) {
      map['trauma_symptoms_json'] = Variable<String>(traumaSymptomsJson.value);
    }
    if (nonTraumaSymptomsJson.present) {
      map['non_trauma_symptoms_json'] = Variable<String>(
        nonTraumaSymptomsJson.value,
      );
    }
    if (symptomNote.present) {
      map['symptom_note'] = Variable<String>(symptomNote.value);
    }
    if (photoTypesJson.present) {
      map['photo_types_json'] = Variable<String>(photoTypesJson.value);
    }
    if (bodyCheckHead.present) {
      map['body_check_head'] = Variable<String>(bodyCheckHead.value);
    }
    if (bodyCheckChest.present) {
      map['body_check_chest'] = Variable<String>(bodyCheckChest.value);
    }
    if (bodyCheckAbdomen.present) {
      map['body_check_abdomen'] = Variable<String>(bodyCheckAbdomen.value);
    }
    if (bodyCheckLimbs.present) {
      map['body_check_limbs'] = Variable<String>(bodyCheckLimbs.value);
    }
    if (bodyCheckOther.present) {
      map['body_check_other'] = Variable<String>(bodyCheckOther.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<String>(temperature.value);
    }
    if (pulse.present) {
      map['pulse'] = Variable<String>(pulse.value);
    }
    if (respiration.present) {
      map['respiration'] = Variable<String>(respiration.value);
    }
    if (bpSystolic.present) {
      map['bp_systolic'] = Variable<String>(bpSystolic.value);
    }
    if (bpDiastolic.present) {
      map['bp_diastolic'] = Variable<String>(bpDiastolic.value);
    }
    if (spo2.present) {
      map['spo2'] = Variable<String>(spo2.value);
    }
    if (consciousClear.present) {
      map['conscious_clear'] = Variable<bool>(consciousClear.value);
    }
    if (evmE.present) {
      map['evm_e'] = Variable<String>(evmE.value);
    }
    if (evmV.present) {
      map['evm_v'] = Variable<String>(evmV.value);
    }
    if (evmM.present) {
      map['evm_m'] = Variable<String>(evmM.value);
    }
    if (leftPupilScale.present) {
      map['left_pupil_scale'] = Variable<int>(leftPupilScale.value);
    }
    if (leftPupilSize.present) {
      map['left_pupil_size'] = Variable<String>(leftPupilSize.value);
    }
    if (rightPupilScale.present) {
      map['right_pupil_scale'] = Variable<int>(rightPupilScale.value);
    }
    if (rightPupilSize.present) {
      map['right_pupil_size'] = Variable<String>(rightPupilSize.value);
    }
    if (history.present) {
      map['history'] = Variable<int>(history.value);
    }
    if (allergy.present) {
      map['allergy'] = Variable<int>(allergy.value);
    }
    if (initialDiagnosis.present) {
      map['initial_diagnosis'] = Variable<String>(initialDiagnosis.value);
    }
    if (diagnosisCategory.present) {
      map['diagnosis_category'] = Variable<int>(diagnosisCategory.value);
    }
    if (selectedICD10Main.present) {
      map['selected_i_c_d10_main'] = Variable<String>(selectedICD10Main.value);
    }
    if (selectedICD10Sub1.present) {
      map['selected_i_c_d10_sub1'] = Variable<String>(selectedICD10Sub1.value);
    }
    if (selectedICD10Sub2.present) {
      map['selected_i_c_d10_sub2'] = Variable<String>(selectedICD10Sub2.value);
    }
    if (triageCategory.present) {
      map['triage_category'] = Variable<int>(triageCategory.value);
    }
    if (onSiteTreatmentsJson.present) {
      map['on_site_treatments_json'] = Variable<String>(
        onSiteTreatmentsJson.value,
      );
    }
    if (ekgChecked.present) {
      map['ekg_checked'] = Variable<bool>(ekgChecked.value);
    }
    if (ekgReading.present) {
      map['ekg_reading'] = Variable<String>(ekgReading.value);
    }
    if (sugarChecked.present) {
      map['sugar_checked'] = Variable<bool>(sugarChecked.value);
    }
    if (sugarReading.present) {
      map['sugar_reading'] = Variable<String>(sugarReading.value);
    }
    if (suggestReferral.present) {
      map['suggest_referral'] = Variable<bool>(suggestReferral.value);
    }
    if (intubationChecked.present) {
      map['intubation_checked'] = Variable<bool>(intubationChecked.value);
    }
    if (cprChecked.present) {
      map['cpr_checked'] = Variable<bool>(cprChecked.value);
    }
    if (oxygenTherapyChecked.present) {
      map['oxygen_therapy_checked'] = Variable<bool>(
        oxygenTherapyChecked.value,
      );
    }
    if (medicalCertificateChecked.present) {
      map['medical_certificate_checked'] = Variable<bool>(
        medicalCertificateChecked.value,
      );
    }
    if (prescriptionChecked.present) {
      map['prescription_checked'] = Variable<bool>(prescriptionChecked.value);
    }
    if (otherChecked.present) {
      map['other_checked'] = Variable<bool>(otherChecked.value);
    }
    if (otherSummary.present) {
      map['other_summary'] = Variable<String>(otherSummary.value);
    }
    if (referralPassageType.present) {
      map['referral_passage_type'] = Variable<int>(referralPassageType.value);
    }
    if (referralAmbulanceType.present) {
      map['referral_ambulance_type'] = Variable<int>(
        referralAmbulanceType.value,
      );
    }
    if (referralHospitalIdx.present) {
      map['referral_hospital_idx'] = Variable<int>(referralHospitalIdx.value);
    }
    if (referralOtherHospital.present) {
      map['referral_other_hospital'] = Variable<String>(
        referralOtherHospital.value,
      );
    }
    if (referralEscort.present) {
      map['referral_escort'] = Variable<String>(referralEscort.value);
    }
    if (intubationType.present) {
      map['intubation_type'] = Variable<int>(intubationType.value);
    }
    if (oxygenType.present) {
      map['oxygen_type'] = Variable<int>(oxygenType.value);
    }
    if (oxygenFlow.present) {
      map['oxygen_flow'] = Variable<String>(oxygenFlow.value);
    }
    if (medicalCertificateTypesJson.present) {
      map['medical_certificate_types_json'] = Variable<String>(
        medicalCertificateTypesJson.value,
      );
    }
    if (prescriptionRowsJson.present) {
      map['prescription_rows_json'] = Variable<String>(
        prescriptionRowsJson.value,
      );
    }
    if (followUpResultsJson.present) {
      map['follow_up_results_json'] = Variable<String>(
        followUpResultsJson.value,
      );
    }
    if (otherHospitalIdx.present) {
      map['other_hospital_idx'] = Variable<int>(otherHospitalIdx.value);
    }
    if (selectedMainDoctor.present) {
      map['selected_main_doctor'] = Variable<String>(selectedMainDoctor.value);
    }
    if (selectedMainNurse.present) {
      map['selected_main_nurse'] = Variable<String>(selectedMainNurse.value);
    }
    if (nurseSignature.present) {
      map['nurse_signature'] = Variable<String>(nurseSignature.value);
    }
    if (selectedEMT.present) {
      map['selected_e_m_t'] = Variable<String>(selectedEMT.value);
    }
    if (emtSignature.present) {
      map['emt_signature'] = Variable<String>(emtSignature.value);
    }
    if (helperNamesText.present) {
      map['helper_names_text'] = Variable<String>(helperNamesText.value);
    }
    if (selectedHelpersJson.present) {
      map['selected_helpers_json'] = Variable<String>(
        selectedHelpersJson.value,
      );
    }
    if (specialNotesJson.present) {
      map['special_notes_json'] = Variable<String>(specialNotesJson.value);
    }
    if (otherSpecialNote.present) {
      map['other_special_note'] = Variable<String>(otherSpecialNote.value);
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
    return (StringBuffer('TreatmentsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('screeningChecked: $screeningChecked, ')
          ..write('screeningMethodsJson: $screeningMethodsJson, ')
          ..write('otherScreeningMethod: $otherScreeningMethod, ')
          ..write('healthDataJson: $healthDataJson, ')
          ..write('mainSymptom: $mainSymptom, ')
          ..write('traumaSymptomsJson: $traumaSymptomsJson, ')
          ..write('nonTraumaSymptomsJson: $nonTraumaSymptomsJson, ')
          ..write('symptomNote: $symptomNote, ')
          ..write('photoTypesJson: $photoTypesJson, ')
          ..write('bodyCheckHead: $bodyCheckHead, ')
          ..write('bodyCheckChest: $bodyCheckChest, ')
          ..write('bodyCheckAbdomen: $bodyCheckAbdomen, ')
          ..write('bodyCheckLimbs: $bodyCheckLimbs, ')
          ..write('bodyCheckOther: $bodyCheckOther, ')
          ..write('temperature: $temperature, ')
          ..write('pulse: $pulse, ')
          ..write('respiration: $respiration, ')
          ..write('bpSystolic: $bpSystolic, ')
          ..write('bpDiastolic: $bpDiastolic, ')
          ..write('spo2: $spo2, ')
          ..write('consciousClear: $consciousClear, ')
          ..write('evmE: $evmE, ')
          ..write('evmV: $evmV, ')
          ..write('evmM: $evmM, ')
          ..write('leftPupilScale: $leftPupilScale, ')
          ..write('leftPupilSize: $leftPupilSize, ')
          ..write('rightPupilScale: $rightPupilScale, ')
          ..write('rightPupilSize: $rightPupilSize, ')
          ..write('history: $history, ')
          ..write('allergy: $allergy, ')
          ..write('initialDiagnosis: $initialDiagnosis, ')
          ..write('diagnosisCategory: $diagnosisCategory, ')
          ..write('selectedICD10Main: $selectedICD10Main, ')
          ..write('selectedICD10Sub1: $selectedICD10Sub1, ')
          ..write('selectedICD10Sub2: $selectedICD10Sub2, ')
          ..write('triageCategory: $triageCategory, ')
          ..write('onSiteTreatmentsJson: $onSiteTreatmentsJson, ')
          ..write('ekgChecked: $ekgChecked, ')
          ..write('ekgReading: $ekgReading, ')
          ..write('sugarChecked: $sugarChecked, ')
          ..write('sugarReading: $sugarReading, ')
          ..write('suggestReferral: $suggestReferral, ')
          ..write('intubationChecked: $intubationChecked, ')
          ..write('cprChecked: $cprChecked, ')
          ..write('oxygenTherapyChecked: $oxygenTherapyChecked, ')
          ..write('medicalCertificateChecked: $medicalCertificateChecked, ')
          ..write('prescriptionChecked: $prescriptionChecked, ')
          ..write('otherChecked: $otherChecked, ')
          ..write('otherSummary: $otherSummary, ')
          ..write('referralPassageType: $referralPassageType, ')
          ..write('referralAmbulanceType: $referralAmbulanceType, ')
          ..write('referralHospitalIdx: $referralHospitalIdx, ')
          ..write('referralOtherHospital: $referralOtherHospital, ')
          ..write('referralEscort: $referralEscort, ')
          ..write('intubationType: $intubationType, ')
          ..write('oxygenType: $oxygenType, ')
          ..write('oxygenFlow: $oxygenFlow, ')
          ..write('medicalCertificateTypesJson: $medicalCertificateTypesJson, ')
          ..write('prescriptionRowsJson: $prescriptionRowsJson, ')
          ..write('followUpResultsJson: $followUpResultsJson, ')
          ..write('otherHospitalIdx: $otherHospitalIdx, ')
          ..write('selectedMainDoctor: $selectedMainDoctor, ')
          ..write('selectedMainNurse: $selectedMainNurse, ')
          ..write('nurseSignature: $nurseSignature, ')
          ..write('selectedEMT: $selectedEMT, ')
          ..write('emtSignature: $emtSignature, ')
          ..write('helperNamesText: $helperNamesText, ')
          ..write('selectedHelpersJson: $selectedHelpersJson, ')
          ..write('specialNotesJson: $specialNotesJson, ')
          ..write('otherSpecialNote: $otherSpecialNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MedicalCostsTable extends MedicalCosts
    with TableInfo<$MedicalCostsTable, MedicalCost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalCostsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _chargeMethodMeta = const VerificationMeta(
    'chargeMethod',
  );
  @override
  late final GeneratedColumn<String> chargeMethod = GeneratedColumn<String>(
    'charge_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitFeeMeta = const VerificationMeta(
    'visitFee',
  );
  @override
  late final GeneratedColumn<String> visitFee = GeneratedColumn<String>(
    'visit_fee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ambulanceFeeMeta = const VerificationMeta(
    'ambulanceFee',
  );
  @override
  late final GeneratedColumn<String> ambulanceFee = GeneratedColumn<String>(
    'ambulance_fee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _agreementSignaturePathMeta =
      const VerificationMeta('agreementSignaturePath');
  @override
  late final GeneratedColumn<String> agreementSignaturePath =
      GeneratedColumn<String>(
        'agreement_signature_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _witnessSignaturePathMeta =
      const VerificationMeta('witnessSignaturePath');
  @override
  late final GeneratedColumn<String> witnessSignaturePath =
      GeneratedColumn<String>(
        'witness_signature_path',
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
    id,
    visitId,
    chargeMethod,
    visitFee,
    ambulanceFee,
    note,
    photoPath,
    agreementSignaturePath,
    witnessSignaturePath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_costs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalCost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('charge_method')) {
      context.handle(
        _chargeMethodMeta,
        chargeMethod.isAcceptableOrUnknown(
          data['charge_method']!,
          _chargeMethodMeta,
        ),
      );
    }
    if (data.containsKey('visit_fee')) {
      context.handle(
        _visitFeeMeta,
        visitFee.isAcceptableOrUnknown(data['visit_fee']!, _visitFeeMeta),
      );
    }
    if (data.containsKey('ambulance_fee')) {
      context.handle(
        _ambulanceFeeMeta,
        ambulanceFee.isAcceptableOrUnknown(
          data['ambulance_fee']!,
          _ambulanceFeeMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('agreement_signature_path')) {
      context.handle(
        _agreementSignaturePathMeta,
        agreementSignaturePath.isAcceptableOrUnknown(
          data['agreement_signature_path']!,
          _agreementSignaturePathMeta,
        ),
      );
    }
    if (data.containsKey('witness_signature_path')) {
      context.handle(
        _witnessSignaturePathMeta,
        witnessSignaturePath.isAcceptableOrUnknown(
          data['witness_signature_path']!,
          _witnessSignaturePathMeta,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalCost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalCost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      chargeMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}charge_method'],
      ),
      visitFee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_fee'],
      ),
      ambulanceFee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ambulance_fee'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      agreementSignaturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agreement_signature_path'],
      ),
      witnessSignaturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}witness_signature_path'],
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
  $MedicalCostsTable createAlias(String alias) {
    return $MedicalCostsTable(attachedDatabase, alias);
  }
}

class MedicalCost extends DataClass implements Insertable<MedicalCost> {
  final int id;
  final int visitId;
  final String? chargeMethod;
  final String? visitFee;
  final String? ambulanceFee;
  final String? note;
  final String? photoPath;
  final String? agreementSignaturePath;
  final String? witnessSignaturePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicalCost({
    required this.id,
    required this.visitId,
    this.chargeMethod,
    this.visitFee,
    this.ambulanceFee,
    this.note,
    this.photoPath,
    this.agreementSignaturePath,
    this.witnessSignaturePath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['visit_id'] = Variable<int>(visitId);
    if (!nullToAbsent || chargeMethod != null) {
      map['charge_method'] = Variable<String>(chargeMethod);
    }
    if (!nullToAbsent || visitFee != null) {
      map['visit_fee'] = Variable<String>(visitFee);
    }
    if (!nullToAbsent || ambulanceFee != null) {
      map['ambulance_fee'] = Variable<String>(ambulanceFee);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || agreementSignaturePath != null) {
      map['agreement_signature_path'] = Variable<String>(
        agreementSignaturePath,
      );
    }
    if (!nullToAbsent || witnessSignaturePath != null) {
      map['witness_signature_path'] = Variable<String>(witnessSignaturePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalCostsCompanion toCompanion(bool nullToAbsent) {
    return MedicalCostsCompanion(
      id: Value(id),
      visitId: Value(visitId),
      chargeMethod: chargeMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(chargeMethod),
      visitFee: visitFee == null && nullToAbsent
          ? const Value.absent()
          : Value(visitFee),
      ambulanceFee: ambulanceFee == null && nullToAbsent
          ? const Value.absent()
          : Value(ambulanceFee),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      agreementSignaturePath: agreementSignaturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(agreementSignaturePath),
      witnessSignaturePath: witnessSignaturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(witnessSignaturePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicalCost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalCost(
      id: serializer.fromJson<int>(json['id']),
      visitId: serializer.fromJson<int>(json['visitId']),
      chargeMethod: serializer.fromJson<String?>(json['chargeMethod']),
      visitFee: serializer.fromJson<String?>(json['visitFee']),
      ambulanceFee: serializer.fromJson<String?>(json['ambulanceFee']),
      note: serializer.fromJson<String?>(json['note']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      agreementSignaturePath: serializer.fromJson<String?>(
        json['agreementSignaturePath'],
      ),
      witnessSignaturePath: serializer.fromJson<String?>(
        json['witnessSignaturePath'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'visitId': serializer.toJson<int>(visitId),
      'chargeMethod': serializer.toJson<String?>(chargeMethod),
      'visitFee': serializer.toJson<String?>(visitFee),
      'ambulanceFee': serializer.toJson<String?>(ambulanceFee),
      'note': serializer.toJson<String?>(note),
      'photoPath': serializer.toJson<String?>(photoPath),
      'agreementSignaturePath': serializer.toJson<String?>(
        agreementSignaturePath,
      ),
      'witnessSignaturePath': serializer.toJson<String?>(witnessSignaturePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalCost copyWith({
    int? id,
    int? visitId,
    Value<String?> chargeMethod = const Value.absent(),
    Value<String?> visitFee = const Value.absent(),
    Value<String?> ambulanceFee = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> agreementSignaturePath = const Value.absent(),
    Value<String?> witnessSignaturePath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicalCost(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    chargeMethod: chargeMethod.present ? chargeMethod.value : this.chargeMethod,
    visitFee: visitFee.present ? visitFee.value : this.visitFee,
    ambulanceFee: ambulanceFee.present ? ambulanceFee.value : this.ambulanceFee,
    note: note.present ? note.value : this.note,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    agreementSignaturePath: agreementSignaturePath.present
        ? agreementSignaturePath.value
        : this.agreementSignaturePath,
    witnessSignaturePath: witnessSignaturePath.present
        ? witnessSignaturePath.value
        : this.witnessSignaturePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicalCost copyWithCompanion(MedicalCostsCompanion data) {
    return MedicalCost(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      chargeMethod: data.chargeMethod.present
          ? data.chargeMethod.value
          : this.chargeMethod,
      visitFee: data.visitFee.present ? data.visitFee.value : this.visitFee,
      ambulanceFee: data.ambulanceFee.present
          ? data.ambulanceFee.value
          : this.ambulanceFee,
      note: data.note.present ? data.note.value : this.note,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      agreementSignaturePath: data.agreementSignaturePath.present
          ? data.agreementSignaturePath.value
          : this.agreementSignaturePath,
      witnessSignaturePath: data.witnessSignaturePath.present
          ? data.witnessSignaturePath.value
          : this.witnessSignaturePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalCost(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('chargeMethod: $chargeMethod, ')
          ..write('visitFee: $visitFee, ')
          ..write('ambulanceFee: $ambulanceFee, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath, ')
          ..write('agreementSignaturePath: $agreementSignaturePath, ')
          ..write('witnessSignaturePath: $witnessSignaturePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    chargeMethod,
    visitFee,
    ambulanceFee,
    note,
    photoPath,
    agreementSignaturePath,
    witnessSignaturePath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalCost &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.chargeMethod == this.chargeMethod &&
          other.visitFee == this.visitFee &&
          other.ambulanceFee == this.ambulanceFee &&
          other.note == this.note &&
          other.photoPath == this.photoPath &&
          other.agreementSignaturePath == this.agreementSignaturePath &&
          other.witnessSignaturePath == this.witnessSignaturePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicalCostsCompanion extends UpdateCompanion<MedicalCost> {
  final Value<int> id;
  final Value<int> visitId;
  final Value<String?> chargeMethod;
  final Value<String?> visitFee;
  final Value<String?> ambulanceFee;
  final Value<String?> note;
  final Value<String?> photoPath;
  final Value<String?> agreementSignaturePath;
  final Value<String?> witnessSignaturePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MedicalCostsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.chargeMethod = const Value.absent(),
    this.visitFee = const Value.absent(),
    this.ambulanceFee = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.agreementSignaturePath = const Value.absent(),
    this.witnessSignaturePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MedicalCostsCompanion.insert({
    this.id = const Value.absent(),
    required int visitId,
    this.chargeMethod = const Value.absent(),
    this.visitFee = const Value.absent(),
    this.ambulanceFee = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.agreementSignaturePath = const Value.absent(),
    this.witnessSignaturePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : visitId = Value(visitId);
  static Insertable<MedicalCost> custom({
    Expression<int>? id,
    Expression<int>? visitId,
    Expression<String>? chargeMethod,
    Expression<String>? visitFee,
    Expression<String>? ambulanceFee,
    Expression<String>? note,
    Expression<String>? photoPath,
    Expression<String>? agreementSignaturePath,
    Expression<String>? witnessSignaturePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (chargeMethod != null) 'charge_method': chargeMethod,
      if (visitFee != null) 'visit_fee': visitFee,
      if (ambulanceFee != null) 'ambulance_fee': ambulanceFee,
      if (note != null) 'note': note,
      if (photoPath != null) 'photo_path': photoPath,
      if (agreementSignaturePath != null)
        'agreement_signature_path': agreementSignaturePath,
      if (witnessSignaturePath != null)
        'witness_signature_path': witnessSignaturePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MedicalCostsCompanion copyWith({
    Value<int>? id,
    Value<int>? visitId,
    Value<String?>? chargeMethod,
    Value<String?>? visitFee,
    Value<String?>? ambulanceFee,
    Value<String?>? note,
    Value<String?>? photoPath,
    Value<String?>? agreementSignaturePath,
    Value<String?>? witnessSignaturePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MedicalCostsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      chargeMethod: chargeMethod ?? this.chargeMethod,
      visitFee: visitFee ?? this.visitFee,
      ambulanceFee: ambulanceFee ?? this.ambulanceFee,
      note: note ?? this.note,
      photoPath: photoPath ?? this.photoPath,
      agreementSignaturePath:
          agreementSignaturePath ?? this.agreementSignaturePath,
      witnessSignaturePath: witnessSignaturePath ?? this.witnessSignaturePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (chargeMethod.present) {
      map['charge_method'] = Variable<String>(chargeMethod.value);
    }
    if (visitFee.present) {
      map['visit_fee'] = Variable<String>(visitFee.value);
    }
    if (ambulanceFee.present) {
      map['ambulance_fee'] = Variable<String>(ambulanceFee.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (agreementSignaturePath.present) {
      map['agreement_signature_path'] = Variable<String>(
        agreementSignaturePath.value,
      );
    }
    if (witnessSignaturePath.present) {
      map['witness_signature_path'] = Variable<String>(
        witnessSignaturePath.value,
      );
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
    return (StringBuffer('MedicalCostsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('chargeMethod: $chargeMethod, ')
          ..write('visitFee: $visitFee, ')
          ..write('ambulanceFee: $ambulanceFee, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath, ')
          ..write('agreementSignaturePath: $agreementSignaturePath, ')
          ..write('witnessSignaturePath: $witnessSignaturePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VisitsTable visits = $VisitsTable(this);
  late final $PatientProfilesTable patientProfiles = $PatientProfilesTable(
    this,
  );
  late final $AccidentRecordsTable accidentRecords = $AccidentRecordsTable(
    this,
  );
  late final $FlightLogsTable flightLogs = $FlightLogsTable(this);
  late final $TreatmentsTable treatments = $TreatmentsTable(this);
  late final $MedicalCostsTable medicalCosts = $MedicalCostsTable(this);
  late final VisitsDao visitsDao = VisitsDao(this as AppDatabase);
  late final PatientProfilesDao patientProfilesDao = PatientProfilesDao(
    this as AppDatabase,
  );
  late final AccidentRecordsDao accidentRecordsDao = AccidentRecordsDao(
    this as AppDatabase,
  );
  late final FlightLogsDao flightLogsDao = FlightLogsDao(this as AppDatabase);
  late final TreatmentsDao treatmentsDao = TreatmentsDao(this as AppDatabase);
  late final MedicalCostsDao medicalCostsDao = MedicalCostsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    visits,
    patientProfiles,
    accidentRecords,
    flightLogs,
    treatments,
    medicalCosts,
  ];
}

typedef $$VisitsTableCreateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> visitId,
      Value<String?> patientName,
      Value<String?> gender,
      Value<String?> nationality,
      Value<String?> dept,
      Value<String?> note,
      Value<String?> filledBy,
      Value<DateTime> uploadedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$VisitsTableUpdateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> visitId,
      Value<String?> patientName,
      Value<String?> gender,
      Value<String?> nationality,
      Value<String?> dept,
      Value<String?> note,
      Value<String?> filledBy,
      Value<DateTime> uploadedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$VisitsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dept => $composableBuilder(
    column: $table.dept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filledBy => $composableBuilder(
    column: $table.filledBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
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
}

class $$VisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dept => $composableBuilder(
    column: $table.dept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filledBy => $composableBuilder(
    column: $table.filledBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
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

class $$VisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dept =>
      $composableBuilder(column: $table.dept, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get filledBy =>
      $composableBuilder(column: $table.filledBy, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitsTable,
          Visit,
          $$VisitsTableFilterComposer,
          $$VisitsTableOrderingComposer,
          $$VisitsTableAnnotationComposer,
          $$VisitsTableCreateCompanionBuilder,
          $$VisitsTableUpdateCompanionBuilder,
          (Visit, BaseReferences<_$AppDatabase, $VisitsTable, Visit>),
          Visit,
          PrefetchHooks Function()
        > {
  $$VisitsTableTableManager(_$AppDatabase db, $VisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> visitId = const Value.absent(),
                Value<String?> patientName = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> dept = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> filledBy = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VisitsCompanion(
                visitId: visitId,
                patientName: patientName,
                gender: gender,
                nationality: nationality,
                dept: dept,
                note: note,
                filledBy: filledBy,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> visitId = const Value.absent(),
                Value<String?> patientName = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> dept = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> filledBy = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VisitsCompanion.insert(
                visitId: visitId,
                patientName: patientName,
                gender: gender,
                nationality: nationality,
                dept: dept,
                note: note,
                filledBy: filledBy,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitsTable,
      Visit,
      $$VisitsTableFilterComposer,
      $$VisitsTableOrderingComposer,
      $$VisitsTableAnnotationComposer,
      $$VisitsTableCreateCompanionBuilder,
      $$VisitsTableUpdateCompanionBuilder,
      (Visit, BaseReferences<_$AppDatabase, $VisitsTable, Visit>),
      Visit,
      PrefetchHooks Function()
    >;
typedef $$PatientProfilesTableCreateCompanionBuilder =
    PatientProfilesCompanion Function({
      Value<int> id,
      required int visitId,
      Value<DateTime?> birthday,
      Value<int?> age,
      Value<String?> gender,
      Value<String?> reason,
      Value<String?> nationality,
      Value<String?> idNumber,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PatientProfilesTableUpdateCompanionBuilder =
    PatientProfilesCompanion Function({
      Value<int> id,
      Value<int> visitId,
      Value<DateTime?> birthday,
      Value<int?> age,
      Value<String?> gender,
      Value<String?> reason,
      Value<String?> nationality,
      Value<String?> idNumber,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PatientProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableFilterComposer({
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

  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
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

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
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

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
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
}

class $$PatientProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableOrderingComposer({
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

  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
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

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
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

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
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

class $$PatientProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PatientProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientProfilesTable,
          PatientProfile,
          $$PatientProfilesTableFilterComposer,
          $$PatientProfilesTableOrderingComposer,
          $$PatientProfilesTableAnnotationComposer,
          $$PatientProfilesTableCreateCompanionBuilder,
          $$PatientProfilesTableUpdateCompanionBuilder,
          (
            PatientProfile,
            BaseReferences<
              _$AppDatabase,
              $PatientProfilesTable,
              PatientProfile
            >,
          ),
          PatientProfile,
          PrefetchHooks Function()
        > {
  $$PatientProfilesTableTableManager(
    _$AppDatabase db,
    $PatientProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> visitId = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PatientProfilesCompanion(
                id: id,
                visitId: visitId,
                birthday: birthday,
                age: age,
                gender: gender,
                reason: reason,
                nationality: nationality,
                idNumber: idNumber,
                address: address,
                phone: phone,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int visitId,
                Value<DateTime?> birthday = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PatientProfilesCompanion.insert(
                id: id,
                visitId: visitId,
                birthday: birthday,
                age: age,
                gender: gender,
                reason: reason,
                nationality: nationality,
                idNumber: idNumber,
                address: address,
                phone: phone,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatientProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientProfilesTable,
      PatientProfile,
      $$PatientProfilesTableFilterComposer,
      $$PatientProfilesTableOrderingComposer,
      $$PatientProfilesTableAnnotationComposer,
      $$PatientProfilesTableCreateCompanionBuilder,
      $$PatientProfilesTableUpdateCompanionBuilder,
      (
        PatientProfile,
        BaseReferences<_$AppDatabase, $PatientProfilesTable, PatientProfile>,
      ),
      PatientProfile,
      PrefetchHooks Function()
    >;
typedef $$AccidentRecordsTableCreateCompanionBuilder =
    AccidentRecordsCompanion Function({
      Value<int> id,
      required int visitId,
      Value<DateTime?> incidentDate,
      Value<DateTime?> notifyTime,
      Value<DateTime?> pickUpTime,
      Value<DateTime?> medicArriveTime,
      Value<DateTime?> ambulanceDepartTime,
      Value<DateTime?> checkTime,
      Value<DateTime?> landingTime,
      Value<int?> reportUnitIdx,
      Value<String?> otherReportUnit,
      Value<String?> notifier,
      Value<String?> phone,
      Value<int?> placeIdx,
      Value<String?> placeNote,
      Value<int?> t1PlaceIdx,
      Value<int?> t2PlaceIdx,
      Value<int?> remotePlaceIdx,
      Value<int?> cargoPlaceIdx,
      Value<int?> novotelPlaceIdx,
      Value<int?> cabinPlaceIdx,
      Value<bool> occArrived,
      Value<String?> cost,
      Value<int?> within10min,
      Value<bool> reasonLanding,
      Value<bool> reasonOnline,
      Value<bool> reasonOther,
      Value<String?> reasonOtherText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$AccidentRecordsTableUpdateCompanionBuilder =
    AccidentRecordsCompanion Function({
      Value<int> id,
      Value<int> visitId,
      Value<DateTime?> incidentDate,
      Value<DateTime?> notifyTime,
      Value<DateTime?> pickUpTime,
      Value<DateTime?> medicArriveTime,
      Value<DateTime?> ambulanceDepartTime,
      Value<DateTime?> checkTime,
      Value<DateTime?> landingTime,
      Value<int?> reportUnitIdx,
      Value<String?> otherReportUnit,
      Value<String?> notifier,
      Value<String?> phone,
      Value<int?> placeIdx,
      Value<String?> placeNote,
      Value<int?> t1PlaceIdx,
      Value<int?> t2PlaceIdx,
      Value<int?> remotePlaceIdx,
      Value<int?> cargoPlaceIdx,
      Value<int?> novotelPlaceIdx,
      Value<int?> cabinPlaceIdx,
      Value<bool> occArrived,
      Value<String?> cost,
      Value<int?> within10min,
      Value<bool> reasonLanding,
      Value<bool> reasonOnline,
      Value<bool> reasonOther,
      Value<String?> reasonOtherText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$AccidentRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AccidentRecordsTable> {
  $$AccidentRecordsTableFilterComposer({
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

  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notifyTime => $composableBuilder(
    column: $table.notifyTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pickUpTime => $composableBuilder(
    column: $table.pickUpTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get medicArriveTime => $composableBuilder(
    column: $table.medicArriveTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ambulanceDepartTime => $composableBuilder(
    column: $table.ambulanceDepartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkTime => $composableBuilder(
    column: $table.checkTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get landingTime => $composableBuilder(
    column: $table.landingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reportUnitIdx => $composableBuilder(
    column: $table.reportUnitIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherReportUnit => $composableBuilder(
    column: $table.otherReportUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notifier => $composableBuilder(
    column: $table.notifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get placeIdx => $composableBuilder(
    column: $table.placeIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeNote => $composableBuilder(
    column: $table.placeNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get t1PlaceIdx => $composableBuilder(
    column: $table.t1PlaceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get t2PlaceIdx => $composableBuilder(
    column: $table.t2PlaceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remotePlaceIdx => $composableBuilder(
    column: $table.remotePlaceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cargoPlaceIdx => $composableBuilder(
    column: $table.cargoPlaceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get novotelPlaceIdx => $composableBuilder(
    column: $table.novotelPlaceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cabinPlaceIdx => $composableBuilder(
    column: $table.cabinPlaceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get occArrived => $composableBuilder(
    column: $table.occArrived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get within10min => $composableBuilder(
    column: $table.within10min,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reasonLanding => $composableBuilder(
    column: $table.reasonLanding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reasonOnline => $composableBuilder(
    column: $table.reasonOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reasonOther => $composableBuilder(
    column: $table.reasonOther,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonOtherText => $composableBuilder(
    column: $table.reasonOtherText,
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
}

class $$AccidentRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccidentRecordsTable> {
  $$AccidentRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notifyTime => $composableBuilder(
    column: $table.notifyTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pickUpTime => $composableBuilder(
    column: $table.pickUpTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get medicArriveTime => $composableBuilder(
    column: $table.medicArriveTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ambulanceDepartTime => $composableBuilder(
    column: $table.ambulanceDepartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkTime => $composableBuilder(
    column: $table.checkTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get landingTime => $composableBuilder(
    column: $table.landingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reportUnitIdx => $composableBuilder(
    column: $table.reportUnitIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherReportUnit => $composableBuilder(
    column: $table.otherReportUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notifier => $composableBuilder(
    column: $table.notifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get placeIdx => $composableBuilder(
    column: $table.placeIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeNote => $composableBuilder(
    column: $table.placeNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get t1PlaceIdx => $composableBuilder(
    column: $table.t1PlaceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get t2PlaceIdx => $composableBuilder(
    column: $table.t2PlaceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remotePlaceIdx => $composableBuilder(
    column: $table.remotePlaceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cargoPlaceIdx => $composableBuilder(
    column: $table.cargoPlaceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get novotelPlaceIdx => $composableBuilder(
    column: $table.novotelPlaceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cabinPlaceIdx => $composableBuilder(
    column: $table.cabinPlaceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get occArrived => $composableBuilder(
    column: $table.occArrived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get within10min => $composableBuilder(
    column: $table.within10min,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reasonLanding => $composableBuilder(
    column: $table.reasonLanding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reasonOnline => $composableBuilder(
    column: $table.reasonOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reasonOther => $composableBuilder(
    column: $table.reasonOther,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonOtherText => $composableBuilder(
    column: $table.reasonOtherText,
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

class $$AccidentRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccidentRecordsTable> {
  $$AccidentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get notifyTime => $composableBuilder(
    column: $table.notifyTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pickUpTime => $composableBuilder(
    column: $table.pickUpTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get medicArriveTime => $composableBuilder(
    column: $table.medicArriveTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ambulanceDepartTime => $composableBuilder(
    column: $table.ambulanceDepartTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checkTime =>
      $composableBuilder(column: $table.checkTime, builder: (column) => column);

  GeneratedColumn<DateTime> get landingTime => $composableBuilder(
    column: $table.landingTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reportUnitIdx => $composableBuilder(
    column: $table.reportUnitIdx,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherReportUnit => $composableBuilder(
    column: $table.otherReportUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notifier =>
      $composableBuilder(column: $table.notifier, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<int> get placeIdx =>
      $composableBuilder(column: $table.placeIdx, builder: (column) => column);

  GeneratedColumn<String> get placeNote =>
      $composableBuilder(column: $table.placeNote, builder: (column) => column);

  GeneratedColumn<int> get t1PlaceIdx => $composableBuilder(
    column: $table.t1PlaceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get t2PlaceIdx => $composableBuilder(
    column: $table.t2PlaceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remotePlaceIdx => $composableBuilder(
    column: $table.remotePlaceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cargoPlaceIdx => $composableBuilder(
    column: $table.cargoPlaceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get novotelPlaceIdx => $composableBuilder(
    column: $table.novotelPlaceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cabinPlaceIdx => $composableBuilder(
    column: $table.cabinPlaceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get occArrived => $composableBuilder(
    column: $table.occArrived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get within10min => $composableBuilder(
    column: $table.within10min,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reasonLanding => $composableBuilder(
    column: $table.reasonLanding,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reasonOnline => $composableBuilder(
    column: $table.reasonOnline,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reasonOther => $composableBuilder(
    column: $table.reasonOther,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonOtherText => $composableBuilder(
    column: $table.reasonOtherText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccidentRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccidentRecordsTable,
          AccidentRecord,
          $$AccidentRecordsTableFilterComposer,
          $$AccidentRecordsTableOrderingComposer,
          $$AccidentRecordsTableAnnotationComposer,
          $$AccidentRecordsTableCreateCompanionBuilder,
          $$AccidentRecordsTableUpdateCompanionBuilder,
          (
            AccidentRecord,
            BaseReferences<
              _$AppDatabase,
              $AccidentRecordsTable,
              AccidentRecord
            >,
          ),
          AccidentRecord,
          PrefetchHooks Function()
        > {
  $$AccidentRecordsTableTableManager(
    _$AppDatabase db,
    $AccidentRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccidentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccidentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccidentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> visitId = const Value.absent(),
                Value<DateTime?> incidentDate = const Value.absent(),
                Value<DateTime?> notifyTime = const Value.absent(),
                Value<DateTime?> pickUpTime = const Value.absent(),
                Value<DateTime?> medicArriveTime = const Value.absent(),
                Value<DateTime?> ambulanceDepartTime = const Value.absent(),
                Value<DateTime?> checkTime = const Value.absent(),
                Value<DateTime?> landingTime = const Value.absent(),
                Value<int?> reportUnitIdx = const Value.absent(),
                Value<String?> otherReportUnit = const Value.absent(),
                Value<String?> notifier = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<int?> placeIdx = const Value.absent(),
                Value<String?> placeNote = const Value.absent(),
                Value<int?> t1PlaceIdx = const Value.absent(),
                Value<int?> t2PlaceIdx = const Value.absent(),
                Value<int?> remotePlaceIdx = const Value.absent(),
                Value<int?> cargoPlaceIdx = const Value.absent(),
                Value<int?> novotelPlaceIdx = const Value.absent(),
                Value<int?> cabinPlaceIdx = const Value.absent(),
                Value<bool> occArrived = const Value.absent(),
                Value<String?> cost = const Value.absent(),
                Value<int?> within10min = const Value.absent(),
                Value<bool> reasonLanding = const Value.absent(),
                Value<bool> reasonOnline = const Value.absent(),
                Value<bool> reasonOther = const Value.absent(),
                Value<String?> reasonOtherText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccidentRecordsCompanion(
                id: id,
                visitId: visitId,
                incidentDate: incidentDate,
                notifyTime: notifyTime,
                pickUpTime: pickUpTime,
                medicArriveTime: medicArriveTime,
                ambulanceDepartTime: ambulanceDepartTime,
                checkTime: checkTime,
                landingTime: landingTime,
                reportUnitIdx: reportUnitIdx,
                otherReportUnit: otherReportUnit,
                notifier: notifier,
                phone: phone,
                placeIdx: placeIdx,
                placeNote: placeNote,
                t1PlaceIdx: t1PlaceIdx,
                t2PlaceIdx: t2PlaceIdx,
                remotePlaceIdx: remotePlaceIdx,
                cargoPlaceIdx: cargoPlaceIdx,
                novotelPlaceIdx: novotelPlaceIdx,
                cabinPlaceIdx: cabinPlaceIdx,
                occArrived: occArrived,
                cost: cost,
                within10min: within10min,
                reasonLanding: reasonLanding,
                reasonOnline: reasonOnline,
                reasonOther: reasonOther,
                reasonOtherText: reasonOtherText,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int visitId,
                Value<DateTime?> incidentDate = const Value.absent(),
                Value<DateTime?> notifyTime = const Value.absent(),
                Value<DateTime?> pickUpTime = const Value.absent(),
                Value<DateTime?> medicArriveTime = const Value.absent(),
                Value<DateTime?> ambulanceDepartTime = const Value.absent(),
                Value<DateTime?> checkTime = const Value.absent(),
                Value<DateTime?> landingTime = const Value.absent(),
                Value<int?> reportUnitIdx = const Value.absent(),
                Value<String?> otherReportUnit = const Value.absent(),
                Value<String?> notifier = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<int?> placeIdx = const Value.absent(),
                Value<String?> placeNote = const Value.absent(),
                Value<int?> t1PlaceIdx = const Value.absent(),
                Value<int?> t2PlaceIdx = const Value.absent(),
                Value<int?> remotePlaceIdx = const Value.absent(),
                Value<int?> cargoPlaceIdx = const Value.absent(),
                Value<int?> novotelPlaceIdx = const Value.absent(),
                Value<int?> cabinPlaceIdx = const Value.absent(),
                Value<bool> occArrived = const Value.absent(),
                Value<String?> cost = const Value.absent(),
                Value<int?> within10min = const Value.absent(),
                Value<bool> reasonLanding = const Value.absent(),
                Value<bool> reasonOnline = const Value.absent(),
                Value<bool> reasonOther = const Value.absent(),
                Value<String?> reasonOtherText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccidentRecordsCompanion.insert(
                id: id,
                visitId: visitId,
                incidentDate: incidentDate,
                notifyTime: notifyTime,
                pickUpTime: pickUpTime,
                medicArriveTime: medicArriveTime,
                ambulanceDepartTime: ambulanceDepartTime,
                checkTime: checkTime,
                landingTime: landingTime,
                reportUnitIdx: reportUnitIdx,
                otherReportUnit: otherReportUnit,
                notifier: notifier,
                phone: phone,
                placeIdx: placeIdx,
                placeNote: placeNote,
                t1PlaceIdx: t1PlaceIdx,
                t2PlaceIdx: t2PlaceIdx,
                remotePlaceIdx: remotePlaceIdx,
                cargoPlaceIdx: cargoPlaceIdx,
                novotelPlaceIdx: novotelPlaceIdx,
                cabinPlaceIdx: cabinPlaceIdx,
                occArrived: occArrived,
                cost: cost,
                within10min: within10min,
                reasonLanding: reasonLanding,
                reasonOnline: reasonOnline,
                reasonOther: reasonOther,
                reasonOtherText: reasonOtherText,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccidentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccidentRecordsTable,
      AccidentRecord,
      $$AccidentRecordsTableFilterComposer,
      $$AccidentRecordsTableOrderingComposer,
      $$AccidentRecordsTableAnnotationComposer,
      $$AccidentRecordsTableCreateCompanionBuilder,
      $$AccidentRecordsTableUpdateCompanionBuilder,
      (
        AccidentRecord,
        BaseReferences<_$AppDatabase, $AccidentRecordsTable, AccidentRecord>,
      ),
      AccidentRecord,
      PrefetchHooks Function()
    >;
typedef $$FlightLogsTableCreateCompanionBuilder =
    FlightLogsCompanion Function({
      Value<int> id,
      required int visitId,
      Value<int?> airlineIndex,
      Value<bool> useOtherAirline,
      Value<String?> otherAirline,
      Value<String?> flightNo,
      Value<int?> travelStatusIndex,
      Value<String?> otherTravelStatus,
      Value<String?> departure,
      Value<String?> via,
      Value<String?> destination,
      Value<DateTime> updatedAt,
    });
typedef $$FlightLogsTableUpdateCompanionBuilder =
    FlightLogsCompanion Function({
      Value<int> id,
      Value<int> visitId,
      Value<int?> airlineIndex,
      Value<bool> useOtherAirline,
      Value<String?> otherAirline,
      Value<String?> flightNo,
      Value<int?> travelStatusIndex,
      Value<String?> otherTravelStatus,
      Value<String?> departure,
      Value<String?> via,
      Value<String?> destination,
      Value<DateTime> updatedAt,
    });

class $$FlightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FlightLogsTable> {
  $$FlightLogsTableFilterComposer({
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

  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get airlineIndex => $composableBuilder(
    column: $table.airlineIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useOtherAirline => $composableBuilder(
    column: $table.useOtherAirline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherAirline => $composableBuilder(
    column: $table.otherAirline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flightNo => $composableBuilder(
    column: $table.flightNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get travelStatusIndex => $composableBuilder(
    column: $table.travelStatusIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherTravelStatus => $composableBuilder(
    column: $table.otherTravelStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departure => $composableBuilder(
    column: $table.departure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get via => $composableBuilder(
    column: $table.via,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightLogsTable> {
  $$FlightLogsTableOrderingComposer({
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

  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get airlineIndex => $composableBuilder(
    column: $table.airlineIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useOtherAirline => $composableBuilder(
    column: $table.useOtherAirline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherAirline => $composableBuilder(
    column: $table.otherAirline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flightNo => $composableBuilder(
    column: $table.flightNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get travelStatusIndex => $composableBuilder(
    column: $table.travelStatusIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherTravelStatus => $composableBuilder(
    column: $table.otherTravelStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departure => $composableBuilder(
    column: $table.departure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get via => $composableBuilder(
    column: $table.via,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightLogsTable> {
  $$FlightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<int> get airlineIndex => $composableBuilder(
    column: $table.airlineIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get useOtherAirline => $composableBuilder(
    column: $table.useOtherAirline,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherAirline => $composableBuilder(
    column: $table.otherAirline,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flightNo =>
      $composableBuilder(column: $table.flightNo, builder: (column) => column);

  GeneratedColumn<int> get travelStatusIndex => $composableBuilder(
    column: $table.travelStatusIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherTravelStatus => $composableBuilder(
    column: $table.otherTravelStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departure =>
      $composableBuilder(column: $table.departure, builder: (column) => column);

  GeneratedColumn<String> get via =>
      $composableBuilder(column: $table.via, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FlightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightLogsTable,
          FlightLog,
          $$FlightLogsTableFilterComposer,
          $$FlightLogsTableOrderingComposer,
          $$FlightLogsTableAnnotationComposer,
          $$FlightLogsTableCreateCompanionBuilder,
          $$FlightLogsTableUpdateCompanionBuilder,
          (
            FlightLog,
            BaseReferences<_$AppDatabase, $FlightLogsTable, FlightLog>,
          ),
          FlightLog,
          PrefetchHooks Function()
        > {
  $$FlightLogsTableTableManager(_$AppDatabase db, $FlightLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> visitId = const Value.absent(),
                Value<int?> airlineIndex = const Value.absent(),
                Value<bool> useOtherAirline = const Value.absent(),
                Value<String?> otherAirline = const Value.absent(),
                Value<String?> flightNo = const Value.absent(),
                Value<int?> travelStatusIndex = const Value.absent(),
                Value<String?> otherTravelStatus = const Value.absent(),
                Value<String?> departure = const Value.absent(),
                Value<String?> via = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlightLogsCompanion(
                id: id,
                visitId: visitId,
                airlineIndex: airlineIndex,
                useOtherAirline: useOtherAirline,
                otherAirline: otherAirline,
                flightNo: flightNo,
                travelStatusIndex: travelStatusIndex,
                otherTravelStatus: otherTravelStatus,
                departure: departure,
                via: via,
                destination: destination,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int visitId,
                Value<int?> airlineIndex = const Value.absent(),
                Value<bool> useOtherAirline = const Value.absent(),
                Value<String?> otherAirline = const Value.absent(),
                Value<String?> flightNo = const Value.absent(),
                Value<int?> travelStatusIndex = const Value.absent(),
                Value<String?> otherTravelStatus = const Value.absent(),
                Value<String?> departure = const Value.absent(),
                Value<String?> via = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlightLogsCompanion.insert(
                id: id,
                visitId: visitId,
                airlineIndex: airlineIndex,
                useOtherAirline: useOtherAirline,
                otherAirline: otherAirline,
                flightNo: flightNo,
                travelStatusIndex: travelStatusIndex,
                otherTravelStatus: otherTravelStatus,
                departure: departure,
                via: via,
                destination: destination,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightLogsTable,
      FlightLog,
      $$FlightLogsTableFilterComposer,
      $$FlightLogsTableOrderingComposer,
      $$FlightLogsTableAnnotationComposer,
      $$FlightLogsTableCreateCompanionBuilder,
      $$FlightLogsTableUpdateCompanionBuilder,
      (FlightLog, BaseReferences<_$AppDatabase, $FlightLogsTable, FlightLog>),
      FlightLog,
      PrefetchHooks Function()
    >;
typedef $$TreatmentsTableCreateCompanionBuilder =
    TreatmentsCompanion Function({
      Value<int> id,
      required int visitId,
      Value<bool> screeningChecked,
      Value<String?> screeningMethodsJson,
      Value<String?> otherScreeningMethod,
      Value<String?> healthDataJson,
      Value<int?> mainSymptom,
      Value<String?> traumaSymptomsJson,
      Value<String?> nonTraumaSymptomsJson,
      Value<String?> symptomNote,
      Value<String?> photoTypesJson,
      Value<String?> bodyCheckHead,
      Value<String?> bodyCheckChest,
      Value<String?> bodyCheckAbdomen,
      Value<String?> bodyCheckLimbs,
      Value<String?> bodyCheckOther,
      Value<String?> temperature,
      Value<String?> pulse,
      Value<String?> respiration,
      Value<String?> bpSystolic,
      Value<String?> bpDiastolic,
      Value<String?> spo2,
      Value<bool> consciousClear,
      Value<String?> evmE,
      Value<String?> evmV,
      Value<String?> evmM,
      Value<int?> leftPupilScale,
      Value<String?> leftPupilSize,
      Value<int?> rightPupilScale,
      Value<String?> rightPupilSize,
      Value<int?> history,
      Value<int?> allergy,
      Value<String?> initialDiagnosis,
      Value<int?> diagnosisCategory,
      Value<String?> selectedICD10Main,
      Value<String?> selectedICD10Sub1,
      Value<String?> selectedICD10Sub2,
      Value<int?> triageCategory,
      Value<String?> onSiteTreatmentsJson,
      Value<bool> ekgChecked,
      Value<String?> ekgReading,
      Value<bool> sugarChecked,
      Value<String?> sugarReading,
      Value<bool> suggestReferral,
      Value<bool> intubationChecked,
      Value<bool> cprChecked,
      Value<bool> oxygenTherapyChecked,
      Value<bool> medicalCertificateChecked,
      Value<bool> prescriptionChecked,
      Value<bool> otherChecked,
      Value<String?> otherSummary,
      Value<int?> referralPassageType,
      Value<int?> referralAmbulanceType,
      Value<int?> referralHospitalIdx,
      Value<String?> referralOtherHospital,
      Value<String?> referralEscort,
      Value<int?> intubationType,
      Value<int?> oxygenType,
      Value<String?> oxygenFlow,
      Value<String?> medicalCertificateTypesJson,
      Value<String?> prescriptionRowsJson,
      Value<String?> followUpResultsJson,
      Value<int?> otherHospitalIdx,
      Value<String?> selectedMainDoctor,
      Value<String?> selectedMainNurse,
      Value<String?> nurseSignature,
      Value<String?> selectedEMT,
      Value<String?> emtSignature,
      Value<String?> helperNamesText,
      Value<String?> selectedHelpersJson,
      Value<String?> specialNotesJson,
      Value<String?> otherSpecialNote,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TreatmentsTableUpdateCompanionBuilder =
    TreatmentsCompanion Function({
      Value<int> id,
      Value<int> visitId,
      Value<bool> screeningChecked,
      Value<String?> screeningMethodsJson,
      Value<String?> otherScreeningMethod,
      Value<String?> healthDataJson,
      Value<int?> mainSymptom,
      Value<String?> traumaSymptomsJson,
      Value<String?> nonTraumaSymptomsJson,
      Value<String?> symptomNote,
      Value<String?> photoTypesJson,
      Value<String?> bodyCheckHead,
      Value<String?> bodyCheckChest,
      Value<String?> bodyCheckAbdomen,
      Value<String?> bodyCheckLimbs,
      Value<String?> bodyCheckOther,
      Value<String?> temperature,
      Value<String?> pulse,
      Value<String?> respiration,
      Value<String?> bpSystolic,
      Value<String?> bpDiastolic,
      Value<String?> spo2,
      Value<bool> consciousClear,
      Value<String?> evmE,
      Value<String?> evmV,
      Value<String?> evmM,
      Value<int?> leftPupilScale,
      Value<String?> leftPupilSize,
      Value<int?> rightPupilScale,
      Value<String?> rightPupilSize,
      Value<int?> history,
      Value<int?> allergy,
      Value<String?> initialDiagnosis,
      Value<int?> diagnosisCategory,
      Value<String?> selectedICD10Main,
      Value<String?> selectedICD10Sub1,
      Value<String?> selectedICD10Sub2,
      Value<int?> triageCategory,
      Value<String?> onSiteTreatmentsJson,
      Value<bool> ekgChecked,
      Value<String?> ekgReading,
      Value<bool> sugarChecked,
      Value<String?> sugarReading,
      Value<bool> suggestReferral,
      Value<bool> intubationChecked,
      Value<bool> cprChecked,
      Value<bool> oxygenTherapyChecked,
      Value<bool> medicalCertificateChecked,
      Value<bool> prescriptionChecked,
      Value<bool> otherChecked,
      Value<String?> otherSummary,
      Value<int?> referralPassageType,
      Value<int?> referralAmbulanceType,
      Value<int?> referralHospitalIdx,
      Value<String?> referralOtherHospital,
      Value<String?> referralEscort,
      Value<int?> intubationType,
      Value<int?> oxygenType,
      Value<String?> oxygenFlow,
      Value<String?> medicalCertificateTypesJson,
      Value<String?> prescriptionRowsJson,
      Value<String?> followUpResultsJson,
      Value<int?> otherHospitalIdx,
      Value<String?> selectedMainDoctor,
      Value<String?> selectedMainNurse,
      Value<String?> nurseSignature,
      Value<String?> selectedEMT,
      Value<String?> emtSignature,
      Value<String?> helperNamesText,
      Value<String?> selectedHelpersJson,
      Value<String?> specialNotesJson,
      Value<String?> otherSpecialNote,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TreatmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TreatmentsTable> {
  $$TreatmentsTableFilterComposer({
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

  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get screeningChecked => $composableBuilder(
    column: $table.screeningChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get screeningMethodsJson => $composableBuilder(
    column: $table.screeningMethodsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherScreeningMethod => $composableBuilder(
    column: $table.otherScreeningMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthDataJson => $composableBuilder(
    column: $table.healthDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mainSymptom => $composableBuilder(
    column: $table.mainSymptom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traumaSymptomsJson => $composableBuilder(
    column: $table.traumaSymptomsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nonTraumaSymptomsJson => $composableBuilder(
    column: $table.nonTraumaSymptomsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomNote => $composableBuilder(
    column: $table.symptomNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoTypesJson => $composableBuilder(
    column: $table.photoTypesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyCheckHead => $composableBuilder(
    column: $table.bodyCheckHead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyCheckChest => $composableBuilder(
    column: $table.bodyCheckChest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyCheckAbdomen => $composableBuilder(
    column: $table.bodyCheckAbdomen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyCheckLimbs => $composableBuilder(
    column: $table.bodyCheckLimbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyCheckOther => $composableBuilder(
    column: $table.bodyCheckOther,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get respiration => $composableBuilder(
    column: $table.respiration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get consciousClear => $composableBuilder(
    column: $table.consciousClear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evmE => $composableBuilder(
    column: $table.evmE,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evmV => $composableBuilder(
    column: $table.evmV,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evmM => $composableBuilder(
    column: $table.evmM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leftPupilScale => $composableBuilder(
    column: $table.leftPupilScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leftPupilSize => $composableBuilder(
    column: $table.leftPupilSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rightPupilScale => $composableBuilder(
    column: $table.rightPupilScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rightPupilSize => $composableBuilder(
    column: $table.rightPupilSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get history => $composableBuilder(
    column: $table.history,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allergy => $composableBuilder(
    column: $table.allergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialDiagnosis => $composableBuilder(
    column: $table.initialDiagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diagnosisCategory => $composableBuilder(
    column: $table.diagnosisCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedICD10Main => $composableBuilder(
    column: $table.selectedICD10Main,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedICD10Sub1 => $composableBuilder(
    column: $table.selectedICD10Sub1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedICD10Sub2 => $composableBuilder(
    column: $table.selectedICD10Sub2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triageCategory => $composableBuilder(
    column: $table.triageCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onSiteTreatmentsJson => $composableBuilder(
    column: $table.onSiteTreatmentsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ekgChecked => $composableBuilder(
    column: $table.ekgChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ekgReading => $composableBuilder(
    column: $table.ekgReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sugarChecked => $composableBuilder(
    column: $table.sugarChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sugarReading => $composableBuilder(
    column: $table.sugarReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get suggestReferral => $composableBuilder(
    column: $table.suggestReferral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get intubationChecked => $composableBuilder(
    column: $table.intubationChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cprChecked => $composableBuilder(
    column: $table.cprChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get oxygenTherapyChecked => $composableBuilder(
    column: $table.oxygenTherapyChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get medicalCertificateChecked => $composableBuilder(
    column: $table.medicalCertificateChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get prescriptionChecked => $composableBuilder(
    column: $table.prescriptionChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get otherChecked => $composableBuilder(
    column: $table.otherChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherSummary => $composableBuilder(
    column: $table.otherSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referralPassageType => $composableBuilder(
    column: $table.referralPassageType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referralAmbulanceType => $composableBuilder(
    column: $table.referralAmbulanceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referralHospitalIdx => $composableBuilder(
    column: $table.referralHospitalIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referralOtherHospital => $composableBuilder(
    column: $table.referralOtherHospital,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referralEscort => $composableBuilder(
    column: $table.referralEscort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intubationType => $composableBuilder(
    column: $table.intubationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get oxygenType => $composableBuilder(
    column: $table.oxygenType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oxygenFlow => $composableBuilder(
    column: $table.oxygenFlow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalCertificateTypesJson => $composableBuilder(
    column: $table.medicalCertificateTypesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prescriptionRowsJson => $composableBuilder(
    column: $table.prescriptionRowsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get followUpResultsJson => $composableBuilder(
    column: $table.followUpResultsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get otherHospitalIdx => $composableBuilder(
    column: $table.otherHospitalIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedMainDoctor => $composableBuilder(
    column: $table.selectedMainDoctor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedMainNurse => $composableBuilder(
    column: $table.selectedMainNurse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nurseSignature => $composableBuilder(
    column: $table.nurseSignature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedEMT => $composableBuilder(
    column: $table.selectedEMT,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emtSignature => $composableBuilder(
    column: $table.emtSignature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get helperNamesText => $composableBuilder(
    column: $table.helperNamesText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedHelpersJson => $composableBuilder(
    column: $table.selectedHelpersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialNotesJson => $composableBuilder(
    column: $table.specialNotesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherSpecialNote => $composableBuilder(
    column: $table.otherSpecialNote,
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
}

class $$TreatmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TreatmentsTable> {
  $$TreatmentsTableOrderingComposer({
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

  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get screeningChecked => $composableBuilder(
    column: $table.screeningChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screeningMethodsJson => $composableBuilder(
    column: $table.screeningMethodsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherScreeningMethod => $composableBuilder(
    column: $table.otherScreeningMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthDataJson => $composableBuilder(
    column: $table.healthDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mainSymptom => $composableBuilder(
    column: $table.mainSymptom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traumaSymptomsJson => $composableBuilder(
    column: $table.traumaSymptomsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nonTraumaSymptomsJson => $composableBuilder(
    column: $table.nonTraumaSymptomsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomNote => $composableBuilder(
    column: $table.symptomNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoTypesJson => $composableBuilder(
    column: $table.photoTypesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyCheckHead => $composableBuilder(
    column: $table.bodyCheckHead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyCheckChest => $composableBuilder(
    column: $table.bodyCheckChest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyCheckAbdomen => $composableBuilder(
    column: $table.bodyCheckAbdomen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyCheckLimbs => $composableBuilder(
    column: $table.bodyCheckLimbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyCheckOther => $composableBuilder(
    column: $table.bodyCheckOther,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get respiration => $composableBuilder(
    column: $table.respiration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get consciousClear => $composableBuilder(
    column: $table.consciousClear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evmE => $composableBuilder(
    column: $table.evmE,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evmV => $composableBuilder(
    column: $table.evmV,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evmM => $composableBuilder(
    column: $table.evmM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leftPupilScale => $composableBuilder(
    column: $table.leftPupilScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leftPupilSize => $composableBuilder(
    column: $table.leftPupilSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rightPupilScale => $composableBuilder(
    column: $table.rightPupilScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rightPupilSize => $composableBuilder(
    column: $table.rightPupilSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get history => $composableBuilder(
    column: $table.history,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allergy => $composableBuilder(
    column: $table.allergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialDiagnosis => $composableBuilder(
    column: $table.initialDiagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diagnosisCategory => $composableBuilder(
    column: $table.diagnosisCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedICD10Main => $composableBuilder(
    column: $table.selectedICD10Main,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedICD10Sub1 => $composableBuilder(
    column: $table.selectedICD10Sub1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedICD10Sub2 => $composableBuilder(
    column: $table.selectedICD10Sub2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triageCategory => $composableBuilder(
    column: $table.triageCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onSiteTreatmentsJson => $composableBuilder(
    column: $table.onSiteTreatmentsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ekgChecked => $composableBuilder(
    column: $table.ekgChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ekgReading => $composableBuilder(
    column: $table.ekgReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sugarChecked => $composableBuilder(
    column: $table.sugarChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sugarReading => $composableBuilder(
    column: $table.sugarReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get suggestReferral => $composableBuilder(
    column: $table.suggestReferral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get intubationChecked => $composableBuilder(
    column: $table.intubationChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cprChecked => $composableBuilder(
    column: $table.cprChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get oxygenTherapyChecked => $composableBuilder(
    column: $table.oxygenTherapyChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get medicalCertificateChecked => $composableBuilder(
    column: $table.medicalCertificateChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get prescriptionChecked => $composableBuilder(
    column: $table.prescriptionChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get otherChecked => $composableBuilder(
    column: $table.otherChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherSummary => $composableBuilder(
    column: $table.otherSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referralPassageType => $composableBuilder(
    column: $table.referralPassageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referralAmbulanceType => $composableBuilder(
    column: $table.referralAmbulanceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referralHospitalIdx => $composableBuilder(
    column: $table.referralHospitalIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referralOtherHospital => $composableBuilder(
    column: $table.referralOtherHospital,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referralEscort => $composableBuilder(
    column: $table.referralEscort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intubationType => $composableBuilder(
    column: $table.intubationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get oxygenType => $composableBuilder(
    column: $table.oxygenType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oxygenFlow => $composableBuilder(
    column: $table.oxygenFlow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalCertificateTypesJson => $composableBuilder(
    column: $table.medicalCertificateTypesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prescriptionRowsJson => $composableBuilder(
    column: $table.prescriptionRowsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get followUpResultsJson => $composableBuilder(
    column: $table.followUpResultsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get otherHospitalIdx => $composableBuilder(
    column: $table.otherHospitalIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedMainDoctor => $composableBuilder(
    column: $table.selectedMainDoctor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedMainNurse => $composableBuilder(
    column: $table.selectedMainNurse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nurseSignature => $composableBuilder(
    column: $table.nurseSignature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedEMT => $composableBuilder(
    column: $table.selectedEMT,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emtSignature => $composableBuilder(
    column: $table.emtSignature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get helperNamesText => $composableBuilder(
    column: $table.helperNamesText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedHelpersJson => $composableBuilder(
    column: $table.selectedHelpersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialNotesJson => $composableBuilder(
    column: $table.specialNotesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherSpecialNote => $composableBuilder(
    column: $table.otherSpecialNote,
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

class $$TreatmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreatmentsTable> {
  $$TreatmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<bool> get screeningChecked => $composableBuilder(
    column: $table.screeningChecked,
    builder: (column) => column,
  );

  GeneratedColumn<String> get screeningMethodsJson => $composableBuilder(
    column: $table.screeningMethodsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherScreeningMethod => $composableBuilder(
    column: $table.otherScreeningMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get healthDataJson => $composableBuilder(
    column: $table.healthDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mainSymptom => $composableBuilder(
    column: $table.mainSymptom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get traumaSymptomsJson => $composableBuilder(
    column: $table.traumaSymptomsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nonTraumaSymptomsJson => $composableBuilder(
    column: $table.nonTraumaSymptomsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptomNote => $composableBuilder(
    column: $table.symptomNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoTypesJson => $composableBuilder(
    column: $table.photoTypesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyCheckHead => $composableBuilder(
    column: $table.bodyCheckHead,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyCheckChest => $composableBuilder(
    column: $table.bodyCheckChest,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyCheckAbdomen => $composableBuilder(
    column: $table.bodyCheckAbdomen,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyCheckLimbs => $composableBuilder(
    column: $table.bodyCheckLimbs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyCheckOther => $composableBuilder(
    column: $table.bodyCheckOther,
    builder: (column) => column,
  );

  GeneratedColumn<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pulse =>
      $composableBuilder(column: $table.pulse, builder: (column) => column);

  GeneratedColumn<String> get respiration => $composableBuilder(
    column: $table.respiration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spo2 =>
      $composableBuilder(column: $table.spo2, builder: (column) => column);

  GeneratedColumn<bool> get consciousClear => $composableBuilder(
    column: $table.consciousClear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evmE =>
      $composableBuilder(column: $table.evmE, builder: (column) => column);

  GeneratedColumn<String> get evmV =>
      $composableBuilder(column: $table.evmV, builder: (column) => column);

  GeneratedColumn<String> get evmM =>
      $composableBuilder(column: $table.evmM, builder: (column) => column);

  GeneratedColumn<int> get leftPupilScale => $composableBuilder(
    column: $table.leftPupilScale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leftPupilSize => $composableBuilder(
    column: $table.leftPupilSize,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rightPupilScale => $composableBuilder(
    column: $table.rightPupilScale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rightPupilSize => $composableBuilder(
    column: $table.rightPupilSize,
    builder: (column) => column,
  );

  GeneratedColumn<int> get history =>
      $composableBuilder(column: $table.history, builder: (column) => column);

  GeneratedColumn<int> get allergy =>
      $composableBuilder(column: $table.allergy, builder: (column) => column);

  GeneratedColumn<String> get initialDiagnosis => $composableBuilder(
    column: $table.initialDiagnosis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diagnosisCategory => $composableBuilder(
    column: $table.diagnosisCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedICD10Main => $composableBuilder(
    column: $table.selectedICD10Main,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedICD10Sub1 => $composableBuilder(
    column: $table.selectedICD10Sub1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedICD10Sub2 => $composableBuilder(
    column: $table.selectedICD10Sub2,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triageCategory => $composableBuilder(
    column: $table.triageCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get onSiteTreatmentsJson => $composableBuilder(
    column: $table.onSiteTreatmentsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ekgChecked => $composableBuilder(
    column: $table.ekgChecked,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ekgReading => $composableBuilder(
    column: $table.ekgReading,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sugarChecked => $composableBuilder(
    column: $table.sugarChecked,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sugarReading => $composableBuilder(
    column: $table.sugarReading,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get suggestReferral => $composableBuilder(
    column: $table.suggestReferral,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get intubationChecked => $composableBuilder(
    column: $table.intubationChecked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cprChecked => $composableBuilder(
    column: $table.cprChecked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get oxygenTherapyChecked => $composableBuilder(
    column: $table.oxygenTherapyChecked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get medicalCertificateChecked => $composableBuilder(
    column: $table.medicalCertificateChecked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get prescriptionChecked => $composableBuilder(
    column: $table.prescriptionChecked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get otherChecked => $composableBuilder(
    column: $table.otherChecked,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherSummary => $composableBuilder(
    column: $table.otherSummary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referralPassageType => $composableBuilder(
    column: $table.referralPassageType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referralAmbulanceType => $composableBuilder(
    column: $table.referralAmbulanceType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referralHospitalIdx => $composableBuilder(
    column: $table.referralHospitalIdx,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referralOtherHospital => $composableBuilder(
    column: $table.referralOtherHospital,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referralEscort => $composableBuilder(
    column: $table.referralEscort,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intubationType => $composableBuilder(
    column: $table.intubationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get oxygenType => $composableBuilder(
    column: $table.oxygenType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oxygenFlow => $composableBuilder(
    column: $table.oxygenFlow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicalCertificateTypesJson => $composableBuilder(
    column: $table.medicalCertificateTypesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prescriptionRowsJson => $composableBuilder(
    column: $table.prescriptionRowsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get followUpResultsJson => $composableBuilder(
    column: $table.followUpResultsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get otherHospitalIdx => $composableBuilder(
    column: $table.otherHospitalIdx,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedMainDoctor => $composableBuilder(
    column: $table.selectedMainDoctor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedMainNurse => $composableBuilder(
    column: $table.selectedMainNurse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nurseSignature => $composableBuilder(
    column: $table.nurseSignature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedEMT => $composableBuilder(
    column: $table.selectedEMT,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emtSignature => $composableBuilder(
    column: $table.emtSignature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get helperNamesText => $composableBuilder(
    column: $table.helperNamesText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedHelpersJson => $composableBuilder(
    column: $table.selectedHelpersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specialNotesJson => $composableBuilder(
    column: $table.specialNotesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherSpecialNote => $composableBuilder(
    column: $table.otherSpecialNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TreatmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreatmentsTable,
          Treatment,
          $$TreatmentsTableFilterComposer,
          $$TreatmentsTableOrderingComposer,
          $$TreatmentsTableAnnotationComposer,
          $$TreatmentsTableCreateCompanionBuilder,
          $$TreatmentsTableUpdateCompanionBuilder,
          (
            Treatment,
            BaseReferences<_$AppDatabase, $TreatmentsTable, Treatment>,
          ),
          Treatment,
          PrefetchHooks Function()
        > {
  $$TreatmentsTableTableManager(_$AppDatabase db, $TreatmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> visitId = const Value.absent(),
                Value<bool> screeningChecked = const Value.absent(),
                Value<String?> screeningMethodsJson = const Value.absent(),
                Value<String?> otherScreeningMethod = const Value.absent(),
                Value<String?> healthDataJson = const Value.absent(),
                Value<int?> mainSymptom = const Value.absent(),
                Value<String?> traumaSymptomsJson = const Value.absent(),
                Value<String?> nonTraumaSymptomsJson = const Value.absent(),
                Value<String?> symptomNote = const Value.absent(),
                Value<String?> photoTypesJson = const Value.absent(),
                Value<String?> bodyCheckHead = const Value.absent(),
                Value<String?> bodyCheckChest = const Value.absent(),
                Value<String?> bodyCheckAbdomen = const Value.absent(),
                Value<String?> bodyCheckLimbs = const Value.absent(),
                Value<String?> bodyCheckOther = const Value.absent(),
                Value<String?> temperature = const Value.absent(),
                Value<String?> pulse = const Value.absent(),
                Value<String?> respiration = const Value.absent(),
                Value<String?> bpSystolic = const Value.absent(),
                Value<String?> bpDiastolic = const Value.absent(),
                Value<String?> spo2 = const Value.absent(),
                Value<bool> consciousClear = const Value.absent(),
                Value<String?> evmE = const Value.absent(),
                Value<String?> evmV = const Value.absent(),
                Value<String?> evmM = const Value.absent(),
                Value<int?> leftPupilScale = const Value.absent(),
                Value<String?> leftPupilSize = const Value.absent(),
                Value<int?> rightPupilScale = const Value.absent(),
                Value<String?> rightPupilSize = const Value.absent(),
                Value<int?> history = const Value.absent(),
                Value<int?> allergy = const Value.absent(),
                Value<String?> initialDiagnosis = const Value.absent(),
                Value<int?> diagnosisCategory = const Value.absent(),
                Value<String?> selectedICD10Main = const Value.absent(),
                Value<String?> selectedICD10Sub1 = const Value.absent(),
                Value<String?> selectedICD10Sub2 = const Value.absent(),
                Value<int?> triageCategory = const Value.absent(),
                Value<String?> onSiteTreatmentsJson = const Value.absent(),
                Value<bool> ekgChecked = const Value.absent(),
                Value<String?> ekgReading = const Value.absent(),
                Value<bool> sugarChecked = const Value.absent(),
                Value<String?> sugarReading = const Value.absent(),
                Value<bool> suggestReferral = const Value.absent(),
                Value<bool> intubationChecked = const Value.absent(),
                Value<bool> cprChecked = const Value.absent(),
                Value<bool> oxygenTherapyChecked = const Value.absent(),
                Value<bool> medicalCertificateChecked = const Value.absent(),
                Value<bool> prescriptionChecked = const Value.absent(),
                Value<bool> otherChecked = const Value.absent(),
                Value<String?> otherSummary = const Value.absent(),
                Value<int?> referralPassageType = const Value.absent(),
                Value<int?> referralAmbulanceType = const Value.absent(),
                Value<int?> referralHospitalIdx = const Value.absent(),
                Value<String?> referralOtherHospital = const Value.absent(),
                Value<String?> referralEscort = const Value.absent(),
                Value<int?> intubationType = const Value.absent(),
                Value<int?> oxygenType = const Value.absent(),
                Value<String?> oxygenFlow = const Value.absent(),
                Value<String?> medicalCertificateTypesJson =
                    const Value.absent(),
                Value<String?> prescriptionRowsJson = const Value.absent(),
                Value<String?> followUpResultsJson = const Value.absent(),
                Value<int?> otherHospitalIdx = const Value.absent(),
                Value<String?> selectedMainDoctor = const Value.absent(),
                Value<String?> selectedMainNurse = const Value.absent(),
                Value<String?> nurseSignature = const Value.absent(),
                Value<String?> selectedEMT = const Value.absent(),
                Value<String?> emtSignature = const Value.absent(),
                Value<String?> helperNamesText = const Value.absent(),
                Value<String?> selectedHelpersJson = const Value.absent(),
                Value<String?> specialNotesJson = const Value.absent(),
                Value<String?> otherSpecialNote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TreatmentsCompanion(
                id: id,
                visitId: visitId,
                screeningChecked: screeningChecked,
                screeningMethodsJson: screeningMethodsJson,
                otherScreeningMethod: otherScreeningMethod,
                healthDataJson: healthDataJson,
                mainSymptom: mainSymptom,
                traumaSymptomsJson: traumaSymptomsJson,
                nonTraumaSymptomsJson: nonTraumaSymptomsJson,
                symptomNote: symptomNote,
                photoTypesJson: photoTypesJson,
                bodyCheckHead: bodyCheckHead,
                bodyCheckChest: bodyCheckChest,
                bodyCheckAbdomen: bodyCheckAbdomen,
                bodyCheckLimbs: bodyCheckLimbs,
                bodyCheckOther: bodyCheckOther,
                temperature: temperature,
                pulse: pulse,
                respiration: respiration,
                bpSystolic: bpSystolic,
                bpDiastolic: bpDiastolic,
                spo2: spo2,
                consciousClear: consciousClear,
                evmE: evmE,
                evmV: evmV,
                evmM: evmM,
                leftPupilScale: leftPupilScale,
                leftPupilSize: leftPupilSize,
                rightPupilScale: rightPupilScale,
                rightPupilSize: rightPupilSize,
                history: history,
                allergy: allergy,
                initialDiagnosis: initialDiagnosis,
                diagnosisCategory: diagnosisCategory,
                selectedICD10Main: selectedICD10Main,
                selectedICD10Sub1: selectedICD10Sub1,
                selectedICD10Sub2: selectedICD10Sub2,
                triageCategory: triageCategory,
                onSiteTreatmentsJson: onSiteTreatmentsJson,
                ekgChecked: ekgChecked,
                ekgReading: ekgReading,
                sugarChecked: sugarChecked,
                sugarReading: sugarReading,
                suggestReferral: suggestReferral,
                intubationChecked: intubationChecked,
                cprChecked: cprChecked,
                oxygenTherapyChecked: oxygenTherapyChecked,
                medicalCertificateChecked: medicalCertificateChecked,
                prescriptionChecked: prescriptionChecked,
                otherChecked: otherChecked,
                otherSummary: otherSummary,
                referralPassageType: referralPassageType,
                referralAmbulanceType: referralAmbulanceType,
                referralHospitalIdx: referralHospitalIdx,
                referralOtherHospital: referralOtherHospital,
                referralEscort: referralEscort,
                intubationType: intubationType,
                oxygenType: oxygenType,
                oxygenFlow: oxygenFlow,
                medicalCertificateTypesJson: medicalCertificateTypesJson,
                prescriptionRowsJson: prescriptionRowsJson,
                followUpResultsJson: followUpResultsJson,
                otherHospitalIdx: otherHospitalIdx,
                selectedMainDoctor: selectedMainDoctor,
                selectedMainNurse: selectedMainNurse,
                nurseSignature: nurseSignature,
                selectedEMT: selectedEMT,
                emtSignature: emtSignature,
                helperNamesText: helperNamesText,
                selectedHelpersJson: selectedHelpersJson,
                specialNotesJson: specialNotesJson,
                otherSpecialNote: otherSpecialNote,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int visitId,
                Value<bool> screeningChecked = const Value.absent(),
                Value<String?> screeningMethodsJson = const Value.absent(),
                Value<String?> otherScreeningMethod = const Value.absent(),
                Value<String?> healthDataJson = const Value.absent(),
                Value<int?> mainSymptom = const Value.absent(),
                Value<String?> traumaSymptomsJson = const Value.absent(),
                Value<String?> nonTraumaSymptomsJson = const Value.absent(),
                Value<String?> symptomNote = const Value.absent(),
                Value<String?> photoTypesJson = const Value.absent(),
                Value<String?> bodyCheckHead = const Value.absent(),
                Value<String?> bodyCheckChest = const Value.absent(),
                Value<String?> bodyCheckAbdomen = const Value.absent(),
                Value<String?> bodyCheckLimbs = const Value.absent(),
                Value<String?> bodyCheckOther = const Value.absent(),
                Value<String?> temperature = const Value.absent(),
                Value<String?> pulse = const Value.absent(),
                Value<String?> respiration = const Value.absent(),
                Value<String?> bpSystolic = const Value.absent(),
                Value<String?> bpDiastolic = const Value.absent(),
                Value<String?> spo2 = const Value.absent(),
                Value<bool> consciousClear = const Value.absent(),
                Value<String?> evmE = const Value.absent(),
                Value<String?> evmV = const Value.absent(),
                Value<String?> evmM = const Value.absent(),
                Value<int?> leftPupilScale = const Value.absent(),
                Value<String?> leftPupilSize = const Value.absent(),
                Value<int?> rightPupilScale = const Value.absent(),
                Value<String?> rightPupilSize = const Value.absent(),
                Value<int?> history = const Value.absent(),
                Value<int?> allergy = const Value.absent(),
                Value<String?> initialDiagnosis = const Value.absent(),
                Value<int?> diagnosisCategory = const Value.absent(),
                Value<String?> selectedICD10Main = const Value.absent(),
                Value<String?> selectedICD10Sub1 = const Value.absent(),
                Value<String?> selectedICD10Sub2 = const Value.absent(),
                Value<int?> triageCategory = const Value.absent(),
                Value<String?> onSiteTreatmentsJson = const Value.absent(),
                Value<bool> ekgChecked = const Value.absent(),
                Value<String?> ekgReading = const Value.absent(),
                Value<bool> sugarChecked = const Value.absent(),
                Value<String?> sugarReading = const Value.absent(),
                Value<bool> suggestReferral = const Value.absent(),
                Value<bool> intubationChecked = const Value.absent(),
                Value<bool> cprChecked = const Value.absent(),
                Value<bool> oxygenTherapyChecked = const Value.absent(),
                Value<bool> medicalCertificateChecked = const Value.absent(),
                Value<bool> prescriptionChecked = const Value.absent(),
                Value<bool> otherChecked = const Value.absent(),
                Value<String?> otherSummary = const Value.absent(),
                Value<int?> referralPassageType = const Value.absent(),
                Value<int?> referralAmbulanceType = const Value.absent(),
                Value<int?> referralHospitalIdx = const Value.absent(),
                Value<String?> referralOtherHospital = const Value.absent(),
                Value<String?> referralEscort = const Value.absent(),
                Value<int?> intubationType = const Value.absent(),
                Value<int?> oxygenType = const Value.absent(),
                Value<String?> oxygenFlow = const Value.absent(),
                Value<String?> medicalCertificateTypesJson =
                    const Value.absent(),
                Value<String?> prescriptionRowsJson = const Value.absent(),
                Value<String?> followUpResultsJson = const Value.absent(),
                Value<int?> otherHospitalIdx = const Value.absent(),
                Value<String?> selectedMainDoctor = const Value.absent(),
                Value<String?> selectedMainNurse = const Value.absent(),
                Value<String?> nurseSignature = const Value.absent(),
                Value<String?> selectedEMT = const Value.absent(),
                Value<String?> emtSignature = const Value.absent(),
                Value<String?> helperNamesText = const Value.absent(),
                Value<String?> selectedHelpersJson = const Value.absent(),
                Value<String?> specialNotesJson = const Value.absent(),
                Value<String?> otherSpecialNote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TreatmentsCompanion.insert(
                id: id,
                visitId: visitId,
                screeningChecked: screeningChecked,
                screeningMethodsJson: screeningMethodsJson,
                otherScreeningMethod: otherScreeningMethod,
                healthDataJson: healthDataJson,
                mainSymptom: mainSymptom,
                traumaSymptomsJson: traumaSymptomsJson,
                nonTraumaSymptomsJson: nonTraumaSymptomsJson,
                symptomNote: symptomNote,
                photoTypesJson: photoTypesJson,
                bodyCheckHead: bodyCheckHead,
                bodyCheckChest: bodyCheckChest,
                bodyCheckAbdomen: bodyCheckAbdomen,
                bodyCheckLimbs: bodyCheckLimbs,
                bodyCheckOther: bodyCheckOther,
                temperature: temperature,
                pulse: pulse,
                respiration: respiration,
                bpSystolic: bpSystolic,
                bpDiastolic: bpDiastolic,
                spo2: spo2,
                consciousClear: consciousClear,
                evmE: evmE,
                evmV: evmV,
                evmM: evmM,
                leftPupilScale: leftPupilScale,
                leftPupilSize: leftPupilSize,
                rightPupilScale: rightPupilScale,
                rightPupilSize: rightPupilSize,
                history: history,
                allergy: allergy,
                initialDiagnosis: initialDiagnosis,
                diagnosisCategory: diagnosisCategory,
                selectedICD10Main: selectedICD10Main,
                selectedICD10Sub1: selectedICD10Sub1,
                selectedICD10Sub2: selectedICD10Sub2,
                triageCategory: triageCategory,
                onSiteTreatmentsJson: onSiteTreatmentsJson,
                ekgChecked: ekgChecked,
                ekgReading: ekgReading,
                sugarChecked: sugarChecked,
                sugarReading: sugarReading,
                suggestReferral: suggestReferral,
                intubationChecked: intubationChecked,
                cprChecked: cprChecked,
                oxygenTherapyChecked: oxygenTherapyChecked,
                medicalCertificateChecked: medicalCertificateChecked,
                prescriptionChecked: prescriptionChecked,
                otherChecked: otherChecked,
                otherSummary: otherSummary,
                referralPassageType: referralPassageType,
                referralAmbulanceType: referralAmbulanceType,
                referralHospitalIdx: referralHospitalIdx,
                referralOtherHospital: referralOtherHospital,
                referralEscort: referralEscort,
                intubationType: intubationType,
                oxygenType: oxygenType,
                oxygenFlow: oxygenFlow,
                medicalCertificateTypesJson: medicalCertificateTypesJson,
                prescriptionRowsJson: prescriptionRowsJson,
                followUpResultsJson: followUpResultsJson,
                otherHospitalIdx: otherHospitalIdx,
                selectedMainDoctor: selectedMainDoctor,
                selectedMainNurse: selectedMainNurse,
                nurseSignature: nurseSignature,
                selectedEMT: selectedEMT,
                emtSignature: emtSignature,
                helperNamesText: helperNamesText,
                selectedHelpersJson: selectedHelpersJson,
                specialNotesJson: specialNotesJson,
                otherSpecialNote: otherSpecialNote,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreatmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreatmentsTable,
      Treatment,
      $$TreatmentsTableFilterComposer,
      $$TreatmentsTableOrderingComposer,
      $$TreatmentsTableAnnotationComposer,
      $$TreatmentsTableCreateCompanionBuilder,
      $$TreatmentsTableUpdateCompanionBuilder,
      (Treatment, BaseReferences<_$AppDatabase, $TreatmentsTable, Treatment>),
      Treatment,
      PrefetchHooks Function()
    >;
typedef $$MedicalCostsTableCreateCompanionBuilder =
    MedicalCostsCompanion Function({
      Value<int> id,
      required int visitId,
      Value<String?> chargeMethod,
      Value<String?> visitFee,
      Value<String?> ambulanceFee,
      Value<String?> note,
      Value<String?> photoPath,
      Value<String?> agreementSignaturePath,
      Value<String?> witnessSignaturePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MedicalCostsTableUpdateCompanionBuilder =
    MedicalCostsCompanion Function({
      Value<int> id,
      Value<int> visitId,
      Value<String?> chargeMethod,
      Value<String?> visitFee,
      Value<String?> ambulanceFee,
      Value<String?> note,
      Value<String?> photoPath,
      Value<String?> agreementSignaturePath,
      Value<String?> witnessSignaturePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$MedicalCostsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalCostsTable> {
  $$MedicalCostsTableFilterComposer({
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

  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chargeMethod => $composableBuilder(
    column: $table.chargeMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitFee => $composableBuilder(
    column: $table.visitFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ambulanceFee => $composableBuilder(
    column: $table.ambulanceFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agreementSignaturePath => $composableBuilder(
    column: $table.agreementSignaturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get witnessSignaturePath => $composableBuilder(
    column: $table.witnessSignaturePath,
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
}

class $$MedicalCostsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalCostsTable> {
  $$MedicalCostsTableOrderingComposer({
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

  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chargeMethod => $composableBuilder(
    column: $table.chargeMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitFee => $composableBuilder(
    column: $table.visitFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ambulanceFee => $composableBuilder(
    column: $table.ambulanceFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agreementSignaturePath => $composableBuilder(
    column: $table.agreementSignaturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get witnessSignaturePath => $composableBuilder(
    column: $table.witnessSignaturePath,
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

class $$MedicalCostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalCostsTable> {
  $$MedicalCostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get chargeMethod => $composableBuilder(
    column: $table.chargeMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visitFee =>
      $composableBuilder(column: $table.visitFee, builder: (column) => column);

  GeneratedColumn<String> get ambulanceFee => $composableBuilder(
    column: $table.ambulanceFee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get agreementSignaturePath => $composableBuilder(
    column: $table.agreementSignaturePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get witnessSignaturePath => $composableBuilder(
    column: $table.witnessSignaturePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicalCostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalCostsTable,
          MedicalCost,
          $$MedicalCostsTableFilterComposer,
          $$MedicalCostsTableOrderingComposer,
          $$MedicalCostsTableAnnotationComposer,
          $$MedicalCostsTableCreateCompanionBuilder,
          $$MedicalCostsTableUpdateCompanionBuilder,
          (
            MedicalCost,
            BaseReferences<_$AppDatabase, $MedicalCostsTable, MedicalCost>,
          ),
          MedicalCost,
          PrefetchHooks Function()
        > {
  $$MedicalCostsTableTableManager(_$AppDatabase db, $MedicalCostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalCostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalCostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalCostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> visitId = const Value.absent(),
                Value<String?> chargeMethod = const Value.absent(),
                Value<String?> visitFee = const Value.absent(),
                Value<String?> ambulanceFee = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> agreementSignaturePath = const Value.absent(),
                Value<String?> witnessSignaturePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicalCostsCompanion(
                id: id,
                visitId: visitId,
                chargeMethod: chargeMethod,
                visitFee: visitFee,
                ambulanceFee: ambulanceFee,
                note: note,
                photoPath: photoPath,
                agreementSignaturePath: agreementSignaturePath,
                witnessSignaturePath: witnessSignaturePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int visitId,
                Value<String?> chargeMethod = const Value.absent(),
                Value<String?> visitFee = const Value.absent(),
                Value<String?> ambulanceFee = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> agreementSignaturePath = const Value.absent(),
                Value<String?> witnessSignaturePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MedicalCostsCompanion.insert(
                id: id,
                visitId: visitId,
                chargeMethod: chargeMethod,
                visitFee: visitFee,
                ambulanceFee: ambulanceFee,
                note: note,
                photoPath: photoPath,
                agreementSignaturePath: agreementSignaturePath,
                witnessSignaturePath: witnessSignaturePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicalCostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalCostsTable,
      MedicalCost,
      $$MedicalCostsTableFilterComposer,
      $$MedicalCostsTableOrderingComposer,
      $$MedicalCostsTableAnnotationComposer,
      $$MedicalCostsTableCreateCompanionBuilder,
      $$MedicalCostsTableUpdateCompanionBuilder,
      (
        MedicalCost,
        BaseReferences<_$AppDatabase, $MedicalCostsTable, MedicalCost>,
      ),
      MedicalCost,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$AccidentRecordsTableTableManager get accidentRecords =>
      $$AccidentRecordsTableTableManager(_db, _db.accidentRecords);
  $$FlightLogsTableTableManager get flightLogs =>
      $$FlightLogsTableTableManager(_db, _db.flightLogs);
  $$TreatmentsTableTableManager get treatments =>
      $$TreatmentsTableTableManager(_db, _db.treatments);
  $$MedicalCostsTableTableManager get medicalCosts =>
      $$MedicalCostsTableTableManager(_db, _db.medicalCosts);
}
