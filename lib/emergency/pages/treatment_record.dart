import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';
import '../../medical/widgets/reference_search_sheet.dart';
import '../../medical/widgets/signature_field.dart';

class EmergencyTreatmentRecord extends StatefulWidget {
  final int emergencyId;

  const EmergencyTreatmentRecord({super.key, required this.emergencyId});

  @override
  State<EmergencyTreatmentRecord> createState() =>
      _EmergencyTreatmentRecordState();
}

class _EmergencyTreatmentRecordState extends State<EmergencyTreatmentRecord> {
  // --- 1. 樣式與顏色定義 ---
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);
  static const Color headerBg = Color(0xFFF8FAFC);

  // --- 2. 控制器定義 ---
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _intubationTimeController =
      TextEditingController();
  final TextEditingController _intubationSizeController =
      TextEditingController();
  final TextEditingController _intubationNotesController =
      TextEditingController();
  final TextEditingController _ivLineTimeController = TextEditingController();
  final TextEditingController _ivLineSizeController = TextEditingController();
  final TextEditingController _ivLineNotesController = TextEditingController();
  final TextEditingController _cprStartTimeController = TextEditingController();
  final TextEditingController _cprEndTimeController = TextEditingController();
  final TextEditingController _cprNotesController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _endRecordController = TextEditingController();
  final TextEditingController _assistStaffInputController =
      TextEditingController();
  final TextEditingController _postOthersController = TextEditingController();

  final TextEditingController _initEController = TextEditingController();
  final TextEditingController _initVController = TextEditingController();
  final TextEditingController _initMController = TextEditingController();
  final TextEditingController _initHRController = TextEditingController();
  final TextEditingController _initRRController = TextEditingController();
  final TextEditingController _initBPController = TextEditingController();
  final TextEditingController _initTempController = TextEditingController();
  final TextEditingController _initLeftPupilSizeController =
      TextEditingController();
  final TextEditingController _initRightPupilSizeController =
      TextEditingController();

  final TextEditingController _postEController = TextEditingController();
  final TextEditingController _postVController = TextEditingController();
  final TextEditingController _postMController = TextEditingController();
  final TextEditingController _postHRController = TextEditingController();
  final TextEditingController _postRRController = TextEditingController();
  final TextEditingController _postBPController = TextEditingController();
  final TextEditingController _postTempController = TextEditingController();
  final TextEditingController _postLeftPupilSizeController =
      TextEditingController();
  final TextEditingController _postRightPupilSizeController =
      TextEditingController();

  int? _initGcsTotal;
  int? _postGcsTotal;

  // --- 3. 狀態變數與資料列表 ---
  EmergencyTreatmentData? _emergencyTreatment;
  MedicalAssessmentData? _initialAssessment;
  MedicalAssessmentData? _postAssessment;
  // _firstAidLogs 已移除，改用 StreamBuilder 訂閱
  final List<EmergencyAssistStaffData> _assistStaffList = [];

  String _initLeftPupilReaction = '+';
  String _initRightPupilReaction = '+';
  String? _intubationMethod;
  String _postLeftPupilReaction = '+';
  String _postRightPupilReaction = '+';
  String? _postRespirationMode;
  String _firstAidResult = '轉診';

  // Staff Assignments
  MedicalStaffAssignmentData? _aidDoctor;
  MedicalStaffAssignmentData? _aidNurse;
  MedicalStaffAssignmentData? _aidEmt;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  // --- 資料載入與初始化 ---

  Future<void> _initialLoad() async {
    await _loadData(fullReload: true);
  }

  Future<void> _loadData({bool fullReload = false}) async {
    try {
      final db = context.read<AppDatabase>();
      final dao = db.emergencyDao;
      // Removed unused refService
      // final refService = context.read<ReferenceService>();

      // 1. 獲取 EmergencyTreatment
      final treatment = await dao.getOrCreateEmergencyTreatment(
        widget.emergencyId,
      );
      _emergencyTreatment = treatment;

      // 2. 獲取 Assessments
      // Initial: Try to find existing assessment by medicalId if not linked
      if (treatment.initialAssessmentId != null) {
        _initialAssessment = await dao.getOrCreateAssessment(
          treatment.initialAssessmentId,
          widget.emergencyId,
        );
      } else {
        // Try to find latest existing assessment (e.g. from Triage)
        final existing = await dao.getLatestAssessment(widget.emergencyId);
        if (existing != null) {
          _initialAssessment = existing;
        } else {
          _initialAssessment = await dao.getOrCreateAssessment(
            null,
            widget.emergencyId,
          );
        }
      }

      // Post: Always specific to this treatment phase
      _postAssessment = await dao.getOrCreateAssessment(
        treatment.postAssessmentId,
        widget.emergencyId,
      );

      // 如果剛創建，需要更新 EmergencyTreatment 的 FKs
      if (treatment.initialAssessmentId == null ||
          treatment.postAssessmentId == null) {
        await dao.updateEmergencyTreatment(
          EmergencyTreatmentCompanion(
            id: drift.Value(treatment.id),
            // Add medicalId to be safe, although partial update shouldn't need it if we use write logic
            // But let's keep it minimal for partial update
            initialAssessmentId: drift.Value(_initialAssessment!.assessmentId),
            postAssessmentId: drift.Value(_postAssessment!.assessmentId),
          ),
        );
      }

      // 4. 獲取 Staff Assignments (Doctor, Nurse, EMT)
      final assignments = await (db.select(
        db.medicalStaffAssignment,
      )..where((t) => t.medicalId.equals(widget.emergencyId))).get();

      // Filter by role codes
      // Need to resolve role IDs from code. Fetch directly from DB to ensure reliability.
      final roles = await db.select(db.medicalStaffRole).get();

      final doctorRole = roles.where((r) => r.code == 'DOCTOR').firstOrNull?.id;
      final nurseRole = roles.where((r) => r.code == 'NURSE').firstOrNull?.id;
      final emtRole = roles.where((r) => r.code == 'EMT').firstOrNull?.id;

      _aidDoctor = assignments
          .where((a) => a.staffRoleId == doctorRole)
          .firstOrNull;
      _aidNurse = assignments
          .where((a) => a.staffRoleId == nurseRole)
          .firstOrNull;
      _aidEmt = assignments.where((a) => a.staffRoleId == emtRole).firstOrNull;

      // 4.1 獲取協助人員列表
      final assistStaff = await dao.getAssistStaff(treatment.id);
      _assistStaffList.clear();
      _assistStaffList.addAll(assistStaff);

      // 5. 獲取 Diagnosis (from Treatment table)
      final mainTreatment =
          await (db.select(db.treatment)
                ..where((t) => t.medicalId.equals(widget.emergencyId)))
              .getSingleOrNull();
      String diagnosisText = '';
      if (mainTreatment?.tentativeCategoryId != null) {
        // Fetch Category Name directly from DB
        final category =
            await (db.select(db.diagnosisCategory)..where(
                  (t) => t.id.equals(mainTreatment!.tentativeCategoryId!),
                ))
                .getSingleOrNull();
        diagnosisText = category?.name ?? '';
      }

      // --- 填充控制器 (Only on full reload) ---
      if (fullReload) {
        _populateControllers(diagnosisText);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading emergency data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _populateControllers(String diagnosisFromTreatment) async {
    if (_emergencyTreatment == null) return;
    final t = _emergencyTreatment!;

    _startTimeController.text = t.startTime != null
        ? DateFormat('HH:mm:ss').format(t.startTime!)
        : '';
    // Diagnosis: Display from Treatment table if available, else from Emergency table (if we decide to store it there too, but let's prefer Treatment table display)
    _diagnosisController.text = diagnosisFromTreatment.isNotEmpty
        ? diagnosisFromTreatment
        : (t.diagnosis ?? '');
    _contextController.text = t.incidentContext ?? '';

    _intubationTimeController.text = t.intubationStartTime != null
        ? DateFormat('HH:mm:ss').format(t.intubationStartTime!)
        : '';
    _intubationMethod = t.intubationMethod;
    _intubationSizeController.text = t.intubationSize ?? '';
    _intubationNotesController.text = t.intubationNotes ?? '';

    _ivLineTimeController.text = t.ivLineStartTime != null
        ? DateFormat('HH:mm:ss').format(t.ivLineStartTime!)
        : '';
    _ivLineSizeController.text = t.ivLineSize ?? '';
    _ivLineNotesController.text = t.ivLineNotes ?? '';

    _cprStartTimeController.text = t.cprStartTime != null
        ? DateFormat('HH:mm:ss').format(t.cprStartTime!)
        : '';
    _cprEndTimeController.text = t.cprEndTime != null
        ? DateFormat('HH:mm:ss').format(t.cprEndTime!)
        : '';
    _cprNotesController.text = t.cprNotes ?? '';

    _postRespirationMode = t.postRespirationMode;
    _postOthersController.text = t.postRespirationOthers ?? '';

    _endTimeController.text = t.endTime != null
        ? DateFormat('HH:mm:ss').format(t.endTime!)
        : '';
    if (t.result != null) _firstAidResult = t.result!;
    _endRecordController.text = t.endCareNotes ?? '';

    // Assessments
    await _populateAssessment(_initialAssessment, isPost: false);
    await _populateAssessment(_postAssessment, isPost: true);
  }

  Future<String> _getPupilReactionSymbol(int? id, String? text) async {
    if (text != null && text.isNotEmpty) return text;
    if (id == null) return '+'; // Default

    final db = context.read<AppDatabase>();
    final ref = await (db.select(
      db.pupilReactionRef,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return ref?.symbol ?? '+';
  }

  Future<void> _populateAssessment(
    MedicalAssessmentData? a, {
    required bool isPost,
  }) async {
    if (a == null) return;
    // ... existing controller population ...
    final eCtrl = isPost ? _postEController : _initEController;
    final vCtrl = isPost ? _postVController : _initVController;
    final mCtrl = isPost ? _postMController : _initMController;
    final hrCtrl = isPost ? _postHRController : _initHRController;
    final rrCtrl = isPost ? _postRRController : _initRRController;
    final bpCtrl = isPost ? _postBPController : _initBPController;
    final tempCtrl = isPost ? _postTempController : _initTempController;
    final leftSizeCtrl = isPost
        ? _postLeftPupilSizeController
        : _initLeftPupilSizeController;
    final rightSizeCtrl = isPost
        ? _postRightPupilSizeController
        : _initRightPupilSizeController;

    eCtrl.text = a.gcsE ?? '';
    vCtrl.text = a.gcsV ?? '';
    mCtrl.text = a.gcsM ?? '';
    hrCtrl.text = a.pulse?.toString() ?? '';
    rrCtrl.text = a.breath?.toString() ?? '';
    bpCtrl.text = (a.systolic != null || a.diastolic != null)
        ? '${a.systolic ?? ''}/${a.diastolic ?? ''}'
        : '';
    tempCtrl.text = a.temperature?.toString() ?? '';
    leftSizeCtrl.text = a.leftPupilSize?.toString() ?? '';
    rightSizeCtrl.text = a.rightPupilSize?.toString() ?? '';

    // Calculate GCS Total
    int e = int.tryParse(eCtrl.text) ?? 0;
    int v = int.tryParse(vCtrl.text) ?? 0;
    int m = int.tryParse(mCtrl.text) ?? 0;
    int? total = (e > 0 && v > 0 && m > 0) ? (e + v + m) : null;

    // Async fetch pupil reactions if needed
    final leftReaction = await _getPupilReactionSymbol(
      a.leftPupilReactionId,
      a.leftPupilReaction,
    );
    final rightReaction = await _getPupilReactionSymbol(
      a.rightPupilReactionId,
      a.rightPupilReaction,
    );

    setState(() {
      if (isPost) {
        _postGcsTotal = total;
        _postLeftPupilReaction = leftReaction;
        _postRightPupilReaction = rightReaction;
      } else {
        _initGcsTotal = total;
        _initLeftPupilReaction = leftReaction;
        _initRightPupilReaction = rightReaction;
      }
    });
  }

  // --- 資料儲存 ---

  Future<void> _saveEmergencyTreatment() async {
    if (_emergencyTreatment == null) return;
    final dao = context.read<AppDatabase>().emergencyDao;

    await dao.updateEmergencyTreatment(
      EmergencyTreatmentCompanion(
        id: drift.Value(_emergencyTreatment!.id),
        startTime: drift.Value(_parseTime(_startTimeController.text)),
        diagnosis: drift.Value(_diagnosisController.text),
        incidentContext: drift.Value(_contextController.text),
        intubationStartTime: drift.Value(
          _parseTime(_intubationTimeController.text),
        ),
        intubationMethod: drift.Value(_intubationMethod),
        intubationSize: drift.Value(_intubationSizeController.text),
        intubationNotes: drift.Value(_intubationNotesController.text),
        ivLineStartTime: drift.Value(_parseTime(_ivLineTimeController.text)),
        ivLineSize: drift.Value(_ivLineSizeController.text),
        ivLineNotes: drift.Value(_ivLineNotesController.text),
        cprStartTime: drift.Value(_parseTime(_cprStartTimeController.text)),
        cprEndTime: drift.Value(_parseTime(_cprEndTimeController.text)),
        cprNotes: drift.Value(_cprNotesController.text),
        postRespirationMode: drift.Value(_postRespirationMode),
        postRespirationOthers: drift.Value(_postOthersController.text),
        endTime: drift.Value(_parseTime(_endTimeController.text)),
        result: drift.Value(_firstAidResult),
        endCareNotes: drift.Value(_endRecordController.text),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<void> _saveAssessment({required bool isPost}) async {
    final dao = context.read<AppDatabase>().emergencyDao;
    final a = isPost ? _postAssessment : _initialAssessment;
    if (a == null) return;

    final eCtrl = isPost ? _postEController : _initEController;
    final vCtrl = isPost ? _postVController : _initVController;
    final mCtrl = isPost ? _postMController : _initMController;
    final hrCtrl = isPost ? _postHRController : _initHRController;
    final rrCtrl = isPost ? _postRRController : _initRRController;
    final bpCtrl = isPost ? _postBPController : _initBPController;
    final tempCtrl = isPost ? _postTempController : _initTempController;
    final leftSizeCtrl = isPost
        ? _postLeftPupilSizeController
        : _initLeftPupilSizeController;
    final rightSizeCtrl = isPost
        ? _postRightPupilSizeController
        : _initRightPupilSizeController;

    // Parse BP
    int? systolic, diastolic;
    if (bpCtrl.text.contains('/')) {
      final parts = bpCtrl.text.split('/');
      if (parts.length == 2) {
        systolic = int.tryParse(parts[0]);
        diastolic = int.tryParse(parts[1]);
      }
    } else {
      systolic = int.tryParse(bpCtrl.text);
    }

    int e = int.tryParse(eCtrl.text) ?? 0;
    int v = int.tryParse(vCtrl.text) ?? 0;
    int m = int.tryParse(mCtrl.text) ?? 0;
    int? gcsTotal = (e > 0 && v > 0 && m > 0) ? (e + v + m) : null;

    // Get pupil reactions
    final leftReaction = isPost
        ? _postLeftPupilReaction
        : _initLeftPupilReaction;
    final rightReaction = isPost
        ? _postRightPupilReaction
        : _initRightPupilReaction;

    await dao.updateAssessment(
      MedicalAssessmentCompanion(
        assessmentId: drift.Value(a.assessmentId),
        gcsE: drift.Value(eCtrl.text),
        gcsM: drift.Value(mCtrl.text),
        gcsV: drift.Value(vCtrl.text),
        gcs: drift.Value(gcsTotal),
        pulse: drift.Value(int.tryParse(hrCtrl.text)),
        breath: drift.Value(int.tryParse(rrCtrl.text)),
        systolic: drift.Value(systolic),
        diastolic: drift.Value(diastolic),
        temperature: drift.Value(double.tryParse(tempCtrl.text)),
        leftPupilSize: drift.Value(double.tryParse(leftSizeCtrl.text)),
        leftPupilReaction: drift.Value(leftReaction),
        rightPupilSize: drift.Value(double.tryParse(rightSizeCtrl.text)),
        rightPupilReaction: drift.Value(rightReaction),
      ),
    );
  }

  // Helper for time parsing (assuming HH:mm:ss for today)
  DateTime? _parseTime(String timeStr) {
    if (timeStr.isEmpty) return null;
    try {
      final now = DateTime.now();
      final format = DateFormat('HH:mm:ss');
      final dt = format.parse(timeStr);
      return DateTime(
        now.year,
        now.month,
        now.day,
        dt.hour,
        dt.minute,
        dt.second,
      );
    } catch (_) {
      return null;
    }
  }

  // --- Logic Methods ---

  void _calculateGcs(bool isPost) {
    setState(() {
      int e =
          int.tryParse(
            isPost ? _postEController.text : _initEController.text,
          ) ??
          0;
      int v =
          int.tryParse(
            isPost ? _postVController.text : _initVController.text,
          ) ??
          0;
      int m =
          int.tryParse(
            isPost ? _postMController.text : _initMController.text,
          ) ??
          0;

      if (e > 0 && v > 0 && m > 0) {
        if (isPost) {
          _postGcsTotal = e + v + m;
        } else {
          _initGcsTotal = e + v + m;
        }
      } else {
        if (isPost) {
          _postGcsTotal = null;
        } else {
          _initGcsTotal = null;
        }
      }
    });
    _saveAssessment(isPost: isPost);
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 頂部基本資訊
          Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '急救開始時間 First Aid Start Time',
                  _buildTimePickerField(_startTimeController),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildFieldWrapper(
                  '診斷 Diagnosis',
                  _buildTextField(
                    hint: '例如: Sudden Cardiac Arrest',
                    controller: _diagnosisController,
                    readOnly: true, // Assuming read from DB only
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildFieldWrapper(
                  '發生情境 Incident Context',
                  _buildTextField(
                    hint: '例如: Collapsed near gate',
                    controller: _contextController,
                    onChanged: (_) => _saveEmergencyTreatment(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Divider(color: borderColor),
          const SizedBox(height: 32),

          // 2. 病況
          _buildSubTitle('病況 Patient Condition'),
          const SizedBox(height: 16),
          _buildLabel('GCS 指數評估'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: 'E',
                  controller: _initEController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateGcs(false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  hint: 'V',
                  controller: _initVController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateGcs(false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  hint: 'M',
                  controller: _initMController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateGcs(false),
                ),
              ),
              const SizedBox(width: 8),
              _buildGcsBox('Total', totalValue: _initGcsTotal, isTotal: true),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildPupilSection(
                  '左瞳孔 Left Pupil',
                  _initLeftPupilReaction,
                  (v) => setState(() => _initLeftPupilReaction = v),
                  _initLeftPupilSizeController,
                  false,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildPupilSection(
                  '右瞳孔 Right Pupil',
                  _initRightPupilReaction,
                  (v) => setState(() => _initRightPupilReaction = v),
                  _initRightPupilSizeController,
                  false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '心跳 Heart Rate (次/分)',
                  _buildTextField(
                    hint: 'BPM',
                    controller: _initHRController,
                    onChanged: (_) => _saveAssessment(isPost: false),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '呼吸 Respiration (次/分)',
                  _buildTextField(
                    hint: 'RR',
                    controller: _initRRController,
                    onChanged: (_) => _saveAssessment(isPost: false),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '血壓 Blood Pressure',
                  _buildTextField(
                    hint: 'mm/Hg',
                    controller: _initBPController,
                    onChanged: (_) => _saveAssessment(isPost: false),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWrapper(
                  '體溫 Temp',
                  _buildTextField(
                    hint: '°C',
                    controller: _initTempController,
                    onChanged: (_) => _saveAssessment(isPost: false),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 3. 插管
          _buildColoredSection(
            title: '插管 Intubation',
            color: bgField,
            child: Row(
              children: [
                Expanded(
                  child: _buildFieldWrapper(
                    '開始時間',
                    _buildTimePickerField(_intubationTimeController),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '插管方式',
                    _buildIntubationMethodSelection(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '管號 Size',
                    _buildTextField(
                      hint: 'Size',
                      controller: _intubationSizeController,
                      onChanged: (_) => _saveEmergencyTreatment(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '備註 Notes',
                    _buildTextField(
                      hint: 'Remarks',
                      controller: _intubationNotesController,
                      onChanged: (_) => _saveEmergencyTreatment(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 4. 靜脈注射
          _buildColoredSection(
            title: '靜脈注射 IV Line',
            color: bgField,
            child: Row(
              children: [
                Expanded(
                  child: _buildFieldWrapper(
                    '開始時間',
                    _buildTimePickerField(_ivLineTimeController),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '針頭尺寸 Needle Size',
                    _buildTextField(
                      hint: 'Gauge',
                      controller: _ivLineSizeController,
                      onChanged: (_) => _saveEmergencyTreatment(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '記錄 Notes',
                    _buildTextField(
                      hint: 'Location/Status',
                      controller: _ivLineNotesController,
                      onChanged: (_) => _saveEmergencyTreatment(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 5. 胸外按壓
          _buildColoredSection(
            title: '胸外按壓 Cardiac Massage',
            icon: Icons.favorite,
            color: const Color(0xFFFEF2F2),
            titleColor: const Color(0xFFDC2626),
            child: Row(
              children: [
                Expanded(
                  child: _buildFieldWrapper(
                    '開始時間',
                    _buildTimePickerField(_cprStartTimeController),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '結束時間',
                    _buildTimePickerField(_cprEndTimeController),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFieldWrapper(
                    '記錄 Notes',
                    _buildTextField(
                      hint: 'CPR Outcome',
                      controller: _cprNotesController,
                      onChanged: (_) => _saveEmergencyTreatment(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 6. 急救處置及用藥記錄表
          _buildTableContainer(
            title: '急救處置及用藥記錄表 FIRST AID & MEDS LOG',
            onAdd: () => _showFirstAidLogModal(),
            child: _emergencyTreatment != null
                ? StreamBuilder<List<FirstAidLogData>>(
                    stream: context
                        .read<AppDatabase>()
                        .emergencyDao
                        .watchFirstAidLogs(_emergencyTreatment!.id),
                    builder: (context, snapshot) {
                      final logs = snapshot.data ?? [];
                      return _buildFirstAidMedsTable(logs);
                    },
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 32),
          const Divider(color: borderColor),
          const SizedBox(height: 32),

          // 7. 急救後病況
          _buildPostFirstAidConditionSection(),

          const SizedBox(height: 32),

          // 8. 急救結束與簽署區塊
          _buildFinalSigningSection(),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  // --- UI 元件實作 ---

  Widget _buildFirstAidMedsTable(List<FirstAidLogData> logs) {
    final flexes = [3, 2, 2, 2, 3, 2, 2, 4, 1];
    final labels = [
      '記錄時間',
      '心跳',
      '血壓',
      '呼吸',
      'O2(L/min;%)',
      'Shock(J)',
      'Epi(mg)',
      '其他藥物',
      '操作',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1250,
        child: Column(
          children: [
            _buildTableHeaderRow(labels, flexes),
            if (logs.isEmpty)
              Container(
                width: 1250,
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: const Text(
                  '無記錄，請點擊 Add Row 新增',
                  style: TextStyle(color: textMuted, fontSize: 13),
                ),
              ),
            ...logs.map((log) {
              return _buildDataRow(flexes, [
                _buildCompactTimeField(log.time ?? ''),
                Center(
                  child: Text(
                    log.heartRate ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    log.bloodPressure ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    log.respirationRate ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    log.o2 ?? '--',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Center(
                  child: Text(
                    log.shock ?? '--',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    log.epinephrine ?? '--',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  log.otherMeds ?? '--',
                  style: const TextStyle(fontSize: 12, color: textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
                // 操作按鈕
                Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () async {
                      await context
                          .read<AppDatabase>()
                          .emergencyDao
                          .deleteFirstAidLog(log.id);
                    },
                  ),
                ),
              ]);
            }),
          ],
        ),
      ),
    );
  }

  void _showFirstAidLogModal() {
    final TextEditingController timeCtrl = TextEditingController(
      text: DateFormat('HH:mm:ss').format(DateTime.now()),
    );
    final TextEditingController hrCtrl = TextEditingController();
    final TextEditingController bpCtrl = TextEditingController();
    final TextEditingController rrCtrl = TextEditingController();
    final TextEditingController o2Ctrl = TextEditingController();
    final TextEditingController shockCtrl = TextEditingController();
    final TextEditingController epiCtrl = TextEditingController();
    // 使用藥物列表（包含選擇的藥物和劑量）
    List<Map<String, dynamic>> tempOtherMeds = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (stateContext, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '新增急救處置與用藥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildFieldWrapper(
                            '記錄時間',
                            _buildTextField(hint: '', controller: timeCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            '心跳 (BPM)',
                            _buildTextField(hint: '請輸入心跳', controller: hrCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            '血壓 (mmHg)',
                            _buildTextField(hint: '請輸入血壓', controller: bpCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFieldWrapper(
                            '呼吸 (RR)',
                            _buildTextField(hint: '請輸入呼吸', controller: rrCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            'O2 (L;%)',
                            _buildTextField(
                              hint: '例：Ambu 15L',
                              controller: o2Ctrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            'DC Shock (J)',
                            _buildTextField(
                              hint: '若無則空白',
                              controller: shockCtrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFieldWrapper(
                            'Epinephrine',
                            _buildTextField(hint: '若無則空白', controller: epiCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // 藥物搜尋與選擇區塊
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('使用其它藥物記錄 OTHER MEDS'),
                        TextButton.icon(
                          onPressed: () {
                            // 開啟藥物搜尋對話框
                            _showDrugSearchDialog(
                              sheetContext,
                              setModalState,
                              tempOtherMeds,
                            );
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('搜尋並新增藥物'),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    // 已選藥物列表
                    ...tempOtherMeds.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  e.value['category'] ?? '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  key: ValueKey(e.value['name']),
                                  initialValue: e.value['dose'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  key: ValueKey('${e.value['name']}_${e.key}'),
                                  initialValue: e.value['dose'] ?? '',
                                  style: TextStyle(fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: '劑量',
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: textMuted,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                  ),
                                  onChanged: (v) => e.value['dose'] = v,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => setModalState(
                                  () => tempOtherMeds.removeAt(e.key),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              final dao = context
                                  .read<AppDatabase>()
                                  .emergencyDao;
                              // Format meds to string (include category)
                              String otherMedsStr = tempOtherMeds
                                  .map((m) {
                                    final name = m['name'] as String? ?? '';
                                    final category =
                                        m['category'] as String? ?? '';
                                    final dose = m['dose'] as String? ?? '';
                                    return "$category:$name($dose)";
                                  })
                                  .join(", ");

                              await dao.addFirstAidLog(
                                FirstAidLogCompanion.insert(
                                  emergencyTreatmentId: _emergencyTreatment!.id,
                                  time: drift.Value(timeCtrl.text),
                                  heartRate: drift.Value(hrCtrl.text),
                                  bloodPressure: drift.Value(bpCtrl.text),
                                  respirationRate: drift.Value(rrCtrl.text),
                                  o2: drift.Value(o2Ctrl.text),
                                  shock: drift.Value(shockCtrl.text),
                                  epinephrine: drift.Value(epiCtrl.text),
                                  otherMeds: drift.Value(otherMedsStr),
                                ),
                              );
                              if (context.mounted) Navigator.pop(context);
                              // 不需要 _loadData()，Stream 會自動更新 UI
                              _loadData();
                            },
                            child: const Text('確認加入'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 藥物搜尋對話框
  void _showDrugSearchDialog(
    BuildContext sheetContext,
    StateSetter outerSetModalState,
    List<Map<String, dynamic>> outerTempOtherMeds,
  ) {
    final TextEditingController searchCtrl = TextEditingController();
    List<DrugRefData> searchResults = [];
    // 引用外部的 tempOtherMeds 和 setModalState
    final outerStateSetter = outerSetModalState;
    final drugList = outerTempOtherMeds;

    showDialog(
      context: sheetContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              child: Container(
                width: 500,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: borderColor)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.medication,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                '搜尋藥物',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            color: const Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                    ),
                    // Search input
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: searchCtrl,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '輸入藥物名稱或類別進行搜尋...',
                          hintStyle: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.normal,
                          ),
                          prefixIcon: Icon(Icons.search, color: primaryColor),
                          suffixIcon: searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  onPressed: () {
                                    searchCtrl.clear();
                                    setDialogState(() {
                                      searchResults = [];
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (val) {
                          _performDrugSearchInDialog(val, searchResults, (r) {
                            setDialogState(() {
                              searchResults = r;
                            });
                          });
                        },
                      ),
                    ),
                    // Results list
                    Flexible(
                      child: searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 48,
                                    color: borderColor,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    searchCtrl.text.isEmpty
                                        ? '請輸入關鍵字進行搜尋'
                                        : '找不到符合的藥物',
                                    style: TextStyle(
                                      color: textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: borderColor),
                                ),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final drug = searchResults[index];
                                  return InkWell(
                                    onTap: () {
                                      // 新增藥物到列表
                                      outerStateSetter(() {
                                        drugList.add({
                                          'name': drug.name,
                                          'category': drug.category,
                                          'dose': '',
                                        });
                                      });
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: borderColor.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              drug.category,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              drug.name,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: primaryColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 藥物搜尋（在對話框中使用）
  Future<void> _performDrugSearchInDialog(
    String query,
    List<DrugRefData> currentResults,
    void Function(List<DrugRefData>) updateResults,
  ) async {
    try {
      final refService = context.read<ReferenceService>();
      final drugs = refService.drugList;

      if (query.isEmpty) {
        updateResults(drugs);
        return;
      }

      final lowerQuery = query.toLowerCase();
      final results = drugs
          .where(
            (d) =>
                d.name.toLowerCase().contains(lowerQuery) ||
                d.category.toLowerCase().contains(lowerQuery),
          )
          .toList();

      updateResults(results);
    } catch (e) {
      debugPrint('Drug search error: $e');
      updateResults([]);
    }
  }

  // --- 表格對齊工具 ---

  Widget _buildTableHeaderRow(List<String> labels, List<int> flexes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: labels
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                flex: flexes[e.key],
                child: Text(
                  e.value,
                  style: const TextStyle(
                    color: Color(0xFF5E878D),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDataRow(List<int> flexes, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: List.generate(
          children.length,
          (i) => Expanded(
            flex: flexes[i],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: children[i],
            ),
          ),
        ),
      ),
    );
  }

  // --- 基礎組件 ---

  Widget _buildTimePickerField(TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            hint: 'HH:mm:ss',
            controller: controller,
            onChanged: (_) => _saveEmergencyTreatment(),
          ),
        ),
        const SizedBox(width: 8),
        _buildNowButton(controller),
      ],
    );
  }

  Widget _buildCompactTimeField(String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.access_time, size: 12, color: textMuted),
      ],
    );
  }

  Widget _buildNowButton(TextEditingController controller) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: () {
          setState(
            () =>
                controller.text = DateFormat('HH:mm:ss').format(DateTime.now()),
          );
          _saveEmergencyTreatment();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: primaryColor.withValues(alpha: 0.05),
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'NOW',
          style: TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    Function(String)? onChanged,
    Color? textColor,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 44 : null,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: textAlign,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 14,
          color: textColor ?? textDark,
          fontWeight: textColor != null ? FontWeight.bold : FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: textMuted, fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer({
    required String title,
    required VoidCallback onAdd,
    required Widget child,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5E878D),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'Add Row',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildColoredSection({
    required String title,
    required Widget child,
    required Color color,
    IconData? icon,
    Color titleColor = primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: titleColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDeleteBtn(VoidCallback onTap) => IconButton(
    icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 18),
    onPressed: onTap,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
  );
  Widget _buildEmptyRow() => Container(
    padding: const EdgeInsets.all(16),
    alignment: Alignment.center,
    child: const Text(
      '無記錄，請點擊 Add Row 新增',
      style: TextStyle(color: textMuted, fontSize: 12),
    ),
  );
  Widget _buildSubTitle(String text) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      color: primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    ),
  );
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
  );
  Widget _buildFieldWrapper(String label, Widget field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildLabel(label), const SizedBox(height: 6), field],
  );
  Widget _buildGcsBox(String label, {int? totalValue, bool isTotal = false}) {
    return Container(
      width: 110,
      height: 44,
      decoration: BoxDecoration(
        color: isTotal ? primaryColor.withValues(alpha: 0.05) : Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        isTotal ? (totalValue != null ? 'Total: $totalValue' : 'Total') : label,
        style: TextStyle(
          color: isTotal && totalValue != null
              ? primaryColor
              : textMuted.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPupilSection(
    String side,
    String currentReact,
    Function(String) onReact,
    TextEditingController sizeController,
    bool isPost,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(side),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: ['+', '-', '±'].map((opt) {
                  bool isSel = currentReact == opt;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onReact(opt),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel ? primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          opt,
                          style: TextStyle(
                            color: isSel ? Colors.white : textMuted,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTextField(
              hint: 'mm',
              textAlign: TextAlign.center,
              controller: sizeController,
              onChanged: (_) => _saveAssessment(isPost: isPost),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildPostFirstAidConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubTitle('急救後病況 Post-Resuscitation Status'),
        const SizedBox(height: 20),

        _buildLabel('GCS 指數評估'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hint: 'E',
                controller: _postEController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                hint: 'V',
                controller: _postVController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                hint: 'M',
                controller: _postMController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateGcs(true),
              ),
            ),
            const SizedBox(width: 8),
            _buildGcsBox('Total', totalValue: _postGcsTotal, isTotal: true),
            const Spacer(),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _buildPupilSection(
                '左瞳孔 Left Pupil',
                _postLeftPupilReaction,
                (v) => setState(() => _postLeftPupilReaction = v),
                _postLeftPupilSizeController,
                true,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildPupilSection(
                '右瞳孔 Right Pupil',
                _postRightPupilReaction,
                (v) => setState(() => _postRightPupilReaction = v),
                _postRightPupilSizeController,
                true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '心跳 Heart Rate',
                _buildTextField(
                  hint: 'BPM',
                  controller: _postHRController,
                  onChanged: (_) => _saveAssessment(isPost: true),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '呼吸 Respiration',
                _buildRespirationModeSelection(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '血壓 Blood Pressure',
                _buildTextField(
                  hint: 'mm/Hg',
                  controller: _postBPController,
                  onChanged: (_) => _saveAssessment(isPost: true),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '其它補充 Others',
                _buildTextField(
                  hint: '補充說明...',
                  controller: _postOthersController,
                  onChanged: (_) => _saveEmergencyTreatment(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinalSigningSection() {
    final refService = context.read<ReferenceService>();
    final doctors = refService.getStaffByRole('DOCTOR');
    final nurses = refService.getStaffByRole('NURSE');
    final emts = refService.getStaffByRole('EMT');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubTitle('急救結束記錄與簽署 Final Documentation'),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '急救結束時間 End Time',
                _buildTimePickerField(_endTimeController),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper('急救結果 Result', _buildResultSelection()),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildFieldWrapper(
          '急救結束記錄 End of Care Notes',
          _buildTextField(
            hint: '請輸入急救結束時的總結紀錄...',
            maxLines: 3,
            controller: _endRecordController,
            onChanged: (_) => _saveEmergencyTreatment(),
          ),
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救醫師 Doctor',
                _buildStaffSelection(
                  '選擇醫師',
                  _aidDoctor,
                  doctors,
                  (staff) => _assignStaff(staff, 'DOCTOR'),
                ),
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(child: SizedBox()),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救護理師 Nurse',
                _buildStaffSelection(
                  '選擇護理師',
                  _aidNurse,
                  nurses,
                  (staff) => _assignStaff(staff, 'NURSE'),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '護理師簽名 Nurse Signature',
                SignatureField(
                  placeholder: '護理師簽署',
                  value: _aidNurse?.signature,
                  onChanged: (data) => _updateSignature(_aidNurse, data),
                  onTap: _aidNurse == null
                      ? () => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('請先選擇護理師')))
                      : null,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '急救 EMT',
                _buildStaffSelection(
                  '選擇 EMT',
                  _aidEmt,
                  emts,
                  (staff) => _assignStaff(staff, 'EMT'),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                'EMT 簽名 EMT Signature',
                SignatureField(
                  placeholder: 'EMT 簽署',
                  value: _aidEmt?.signature,
                  onChanged: (data) => _updateSignature(_aidEmt, data),
                  onTap: _aidEmt == null
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('請先選擇 EMT')),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        _buildLabel('協助人員表 Assist Staff'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hint: '輸入人員姓名後點擊右側新增...',
                controller: _assistStaffInputController,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_assistStaffInputController.text.isNotEmpty) {
                    await context
                        .read<AppDatabase>()
                        .emergencyDao
                        .addAssistStaff(
                          EmergencyAssistStaffCompanion.insert(
                            emergencyTreatmentId: _emergencyTreatment!.id,
                            name: _assistStaffInputController.text,
                          ),
                        );
                    _assistStaffInputController.clear();
                    _loadData();
                  }
                },
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('新增人員'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  foregroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_assistStaffList.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _assistStaffList
                .map(
                  (s) => Chip(
                    label: Text(
                      s.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: bgField,
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.red,
                    ),
                    onDeleted: () async {
                      await context
                          .read<AppDatabase>()
                          .emergencyDao
                          .deleteAssistStaff(s.id);
                      _loadData();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: borderColor),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  // --- 選擇欄位 Helper (Generic) ---
  Widget _buildReferenceSelection<T>({
    required String label,
    required String? value, // Current Display Value
    required IconData icon,
    required String title,
    required Future<List<T>> Function(String) searchFunction,
    required String Function(T) getName,
    required Function(T) onSelected,
  }) {
    return _buildSelectionField(
      text: value ?? '',
      hint: label,
      icon: icon,
      onTap: () async {
        await ReferenceSearchSheet.show<T>(
          context,
          title: title,
          searchFunction: searchFunction,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(getName(item)),
              selected: isSelected,
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () => Navigator.pop(context, item),
            );
          },
        ).then((selected) {
          if (selected != null) {
            onSelected(selected);
          }
        });
      },
    );
  }

  // --- 重構後的 UI Components ---

  // 1. 插管方式 (Replace Dropdown)
  Widget _buildIntubationMethodSelection() {
    return _buildReferenceSelection<IntubationMethodRefData>(
      label: '插管方式',
      value: _intubationMethod,
      icon: Icons.medical_services,
      title: '選擇插管方式',
      searchFunction: (query) async {
        final db = context.read<AppDatabase>();
        return (db.select(db.intubationMethodRef)
              ..where((t) => t.isActive.equals(true))
              ..where((t) => t.name.contains(query)))
            .get();
      },
      getName: (item) => item.name,
      onSelected: (item) {
        setState(() {
          _intubationMethod = item.name;
        });
        _saveEmergencyTreatment();
      },
    );
  }

  // 2. 呼吸模式 (Replace Dropdown)
  Widget _buildRespirationModeSelection() {
    return _buildReferenceSelection<RespirationModeRefData>(
      label: '選擇方式',
      value: _postRespirationMode,
      icon: Icons.air,
      title: '選擇呼吸模式',
      searchFunction: (query) async {
        final db = context.read<AppDatabase>();
        return (db.select(db.respirationModeRef)
              ..where((t) => t.isActive.equals(true))
              ..where((t) => t.name.contains(query)))
            .get();
      },
      getName: (item) => item.name,
      onSelected: (item) {
        setState(() {
          _postRespirationMode = item.name;
        });
        _saveEmergencyTreatment();
      },
    );
  }

  // 3. 處置結果 (Replace SegmentedControl)
  Widget _buildResultSelection() {
    return _buildReferenceSelection<TreatmentResultData>(
      label: '選擇結果',
      value: _firstAidResult,
      icon: Icons.assignment_turned_in,
      title: '選擇處置結果',
      searchFunction: (query) async {
        final db = context.read<AppDatabase>();
        return (db.select(db.treatmentResult)
              ..where((t) => t.isActive.equals(true))
              ..where((t) => t.name.contains(query)))
            .get();
      },
      getName: (item) => item.name,
      onSelected: (item) {
        setState(() {
          _firstAidResult = item.name;
        });
        _saveEmergencyTreatment();
      },
    );
  }

  // --- Staff Logic ---

  Widget _buildStaffSelection(
    String hint,
    MedicalStaffAssignmentData? currentAssignment,
    List<MedicalStaffData> staffList,
    Function(MedicalStaffData) onSelect,
  ) {
    return _buildSelectionField(
      text: currentAssignment?.staffName ?? '',
      hint: hint,
      icon: Icons.person,
      onTap: () async {
        final result = await ReferenceSearchSheet.show<MedicalStaffData>(
          context,
          title: hint,
          searchFunction: (query) async {
            if (query.isEmpty) return staffList;
            return staffList
                .where(
                  (s) =>
                      s.name.contains(query) ||
                      (s.employeeId?.contains(query) ?? false),
                )
                .toList();
          },
          initialSelection: currentAssignment != null
              ? staffList
                    .where((s) => s.id == currentAssignment.staffId)
                    .firstOrNull
              : null,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.employeeId ?? ''),
              trailing: isSelected ? const Icon(Icons.check) : null,
            );
          },
        );

        if (result != null) {
          onSelect(result);
        }
      },
    );
  }

  Widget _buildSelectionField({
    required String text,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text.isNotEmpty ? text : hint,
                style: TextStyle(
                  color: text.isNotEmpty
                      ? textDark
                      : textMuted.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: textMuted),
          ],
        ),
      ),
    );
  }

  Future<void> _assignStaff(MedicalStaffData staff, String roleCode) async {
    final db = context.read<AppDatabase>();

    // Fetch role ID directly from DB
    final role = await (db.select(
      db.medicalStaffRole,
    )..where((r) => r.code.equals(roleCode))).getSingleOrNull();
    final roleId = role?.id;

    if (roleId == null) return;

    // Check if assignment exists for this role
    final existing =
        await (db.select(db.medicalStaffAssignment)..where(
              (t) =>
                  t.medicalId.equals(widget.emergencyId) &
                  t.staffRoleId.equals(roleId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await db.emergencyDao.updateMedicalStaffAssignment(
        MedicalStaffAssignmentCompanion(
          staffAssignmentId: drift.Value(existing.staffAssignmentId),
          staffId: drift.Value(staff.id),
          staffName: drift.Value(staff.name),
        ),
      );
    } else {
      await db.into(db.medicalStaffAssignment).insert(
            MedicalStaffAssignmentCompanion(
              medicalId: drift.Value(widget.emergencyId),
              staffRoleId: drift.Value(roleId),
              staffId: drift.Value(staff.id),
              staffName: drift.Value(staff.name),
              isPrimary: drift.Value(true),
              syncStatus: const drift.Value(1),
            ),
          );
    }
    _loadData(); // Partial reload, won't overwrite controllers
  }

  Future<void> _updateSignature(
    MedicalStaffAssignmentData? assignment,
    drift.Uint8List? signature,
  ) async {
    if (assignment == null) return;
    final db = context.read<AppDatabase>();
    await db.emergencyDao.updateMedicalStaffAssignment(
      MedicalStaffAssignmentCompanion(
        staffAssignmentId: drift.Value(assignment.staffAssignmentId),
        signature: drift.Value(signature),
        signedAt: drift.Value(DateTime.now()),
      ),
    );
    _loadData(); // Partial reload
  }
}
