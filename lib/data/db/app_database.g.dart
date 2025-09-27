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
  late final VisitsDao visitsDao = VisitsDao(this as AppDatabase);
  late final PatientProfilesDao patientProfilesDao = PatientProfilesDao(
    this as AppDatabase,
  );
  late final AccidentRecordsDao accidentRecordsDao = AccidentRecordsDao(
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$AccidentRecordsTableTableManager get accidentRecords =>
      $$AccidentRecordsTableTableManager(_db, _db.accidentRecords);
}
