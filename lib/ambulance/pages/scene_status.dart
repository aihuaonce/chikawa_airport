import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../../data/db/tables/sync_tables.dart';

class AmbulanceSceneStatus extends StatefulWidget {
  final int medicalId;
  const AmbulanceSceneStatus({super.key, required this.medicalId});

  @override
  State<AmbulanceSceneStatus> createState() => _AmbulanceSceneStatusState();
}

class _AmbulanceSceneStatusState extends State<AmbulanceSceneStatus> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // --- 狀態變數 ---
  bool _isInitialized = false;

  // Selected Categories
  final List<String> _mainCategories = []; // 'Trauma', 'NonTrauma'

  // Selected Items (loaded from DB)
  final List<String> _selectedTraumaGroups = [];
  final List<String> _selectedNonTraumaGroups = [];
  final List<String> _selectedGeneralTrauma = [];
  final List<String> _selectedMechanism = [];
  final List<String> _selectedAcute = [];
  final List<String> _selectedGeneralDisease = [];
  final List<String> _selectedAllergies = [];
  final List<String> _selectedHistories = [];

  // Options (loaded from DB)
  List<String> _traumaGroupOptions = [];
  List<String> _nonTraumaGroupOptions = [];
  List<String> _generalTraumaOptions = [];
  List<String> _mechanismOptions = [];
  List<String> _acuteOptions = [];
  List<String> _generalDiseaseOptions = [];
  List<String> _allergyOptions = [];
  List<String> _historyOptions = [];

  // Scalars
  String _isProxyComplaint = '否 No';
  String _allergyStatus = '無';
  String _historyStatus = '無';

  // Controllers
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _fallHeightController = TextEditingController();
  final TextEditingController _burnDegreeController = TextEditingController();
  final TextEditingController _burnAreaController = TextEditingController();
  final TextEditingController _otherTraumaController = TextEditingController();
  final TextEditingController _allergyNoteController = TextEditingController();
  final TextEditingController _historyNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _fallHeightController.dispose();
    _burnDegreeController.dispose();
    _burnAreaController.dispose();
    _otherTraumaController.dispose();
    _allergyNoteController.dispose();
    _historyNoteController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = context.read<AppDatabase>();
    final dao = db.ambulanceDao;

    // 1. Initialize Reference Data (if needed)
    await dao.initializeAmbulanceReferenceData();

    // 2. Load Options
    _traumaGroupOptions = (await dao.getReferenceItemsByCategory(
      'TraumaGroup',
    )).map((e) => e.name).toList();
    _nonTraumaGroupOptions = (await dao.getReferenceItemsByCategory(
      'NonTraumaGroup',
    )).map((e) => e.name).toList();
    _generalTraumaOptions = (await dao.getReferenceItemsByCategory(
      'GeneralTrauma',
    )).map((e) => e.name).toList();
    _mechanismOptions = (await dao.getReferenceItemsByCategory(
      'Mechanism',
    )).map((e) => e.name).toList();
    _acuteOptions = (await dao.getReferenceItemsByCategory(
      'Acute',
    )).map((e) => e.name).toList();
    _generalDiseaseOptions = (await dao.getReferenceItemsByCategory(
      'GeneralDisease',
    )).map((e) => e.name).toList();
    _allergyOptions = (await dao.getReferenceItemsByCategory(
      'Allergy',
    )).map((e) => e.name).toList();
    _historyOptions = (await dao.getReferenceItemsByCategory(
      'History',
    )).map((e) => e.name).toList();

    // 3. Load Record
    final record = await dao.getSceneRecord(widget.medicalId);
    if (record != null) {
      _complaintController.text = record.patientComplaint ?? '';
      _isProxyComplaint = record.isProxyComplaint ? '是 Yes' : '否 No';
      _fallHeightController.text = record.fallHeight ?? '';
      _burnDegreeController.text = record.burnDegree ?? '';
      _burnAreaController.text = record.burnArea ?? '';
      _otherTraumaController.text = record.otherTraumaNote ?? '';
      _allergyStatus = record.allergyStatus;
      _allergyNoteController.text = record.allergyNote ?? '';
      _historyStatus = record.historyStatus;
      _historyNoteController.text = record.historyNote ?? '';

      // Load Selected Links
      final sceneId = record.id;
      _selectedTraumaGroups.addAll(
        await dao.getSelectedLinkNames(sceneId, 'TraumaGroup'),
      );
      _selectedNonTraumaGroups.addAll(
        await dao.getSelectedLinkNames(sceneId, 'NonTraumaGroup'),
      );
      _selectedGeneralTrauma.addAll(
        await dao.getSelectedLinkNames(sceneId, 'GeneralTrauma'),
      );
      _selectedMechanism.addAll(
        await dao.getSelectedLinkNames(sceneId, 'Mechanism'),
      );
      _selectedAcute.addAll(await dao.getSelectedLinkNames(sceneId, 'Acute'));
      _selectedGeneralDisease.addAll(
        await dao.getSelectedLinkNames(sceneId, 'GeneralDisease'),
      );
      _selectedAllergies.addAll(
        await dao.getSelectedLinkNames(sceneId, 'Allergy'),
      );
      _selectedHistories.addAll(
        await dao.getSelectedLinkNames(sceneId, 'History'),
      );

      // Infer Main Categories
      if (_selectedTraumaGroups.isNotEmpty) _mainCategories.add('Trauma');
      if (_selectedNonTraumaGroups.isNotEmpty) _mainCategories.add('NonTrauma');
    }

    setState(() {
      _isInitialized = true;
    });
  }

  // --- Auto-Save Helpers ---

  Future<void> _updateRecord({
    drift.Value<String?>? patientComplaint,
    drift.Value<bool>? isProxyComplaint,
    drift.Value<String?>? fallHeight,
    drift.Value<String?>? burnDegree,
    drift.Value<String?>? burnArea,
    drift.Value<String?>? otherTraumaNote,
    drift.Value<String>? allergyStatus,
    drift.Value<String?>? allergyNote,
    drift.Value<String>? historyStatus,
    drift.Value<String?>? historyNote,
    // ✅ 新增：同步狀態
    drift.Value<int>? syncStatus,
  }) async {
    if (!_isInitialized) return;
    final dao = context.read<AppDatabase>().ambulanceDao;

    await dao.updateSceneRecord(
      AmbulanceSceneRecordsCompanion(
        medicalId: drift.Value(widget.medicalId),
        patientComplaint: patientComplaint ?? const drift.Value.absent(),
        isProxyComplaint: isProxyComplaint ?? const drift.Value.absent(),
        fallHeight: fallHeight ?? const drift.Value.absent(),
        burnDegree: burnDegree ?? const drift.Value.absent(),
        burnArea: burnArea ?? const drift.Value.absent(),
        otherTraumaNote: otherTraumaNote ?? const drift.Value.absent(),
        allergyStatus: allergyStatus ?? const drift.Value.absent(),
        allergyNote: allergyNote ?? const drift.Value.absent(),
        historyStatus: historyStatus ?? const drift.Value.absent(),
        historyNote: historyNote ?? const drift.Value.absent(),
        // ✅ 標記為待同步狀態
        syncStatus: syncStatus ?? const drift.Value(SyncStatus.pending),
      ),
    );
  }

  Future<void> _updateLinks(String category, List<String> selected) async {
    if (!_isInitialized) return;
    final dao = context.read<AppDatabase>().ambulanceDao;

    // Ensure record exists first
    final recordId = await dao.updateSceneRecord(
      AmbulanceSceneRecordsCompanion(medicalId: drift.Value(widget.medicalId)),
    );

    await dao.updateSelectedLinks(recordId, category, selected);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 案件分類 (可複選)
        _buildLabel('病況分類 CATEGORY (可複選)'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildMainCategoryButton('創傷 Trauma', 'Trauma'),
            const SizedBox(width: 12),
            _buildMainCategoryButton('非創傷 Non-Trauma', 'NonTrauma'),
          ],
        ),

        const SizedBox(height: 24),

        // 2. 創傷/非創傷動態區塊
        if (_mainCategories.contains('Trauma')) ...[
          _buildLabel('創傷項目'),
          const SizedBox(height: 10),
          _buildChipGrid(
            options: _traumaGroupOptions,
            selectedList: _selectedTraumaGroups,
            onChanged: (val) =>
                _updateLinks('TraumaGroup', _selectedTraumaGroups),
          ),
          if (_selectedTraumaGroups.contains('一般外傷'))
            _buildSubContainer(
              '一般外傷細項',
              _buildChipGrid(
                options: _generalTraumaOptions,
                selectedList: _selectedGeneralTrauma,
                onChanged: (s) =>
                    _updateLinks('GeneralTrauma', _selectedGeneralTrauma),
              ),
            ),
          if (_selectedTraumaGroups.contains('受傷機轉'))
            _buildSubContainer(
              '受傷機轉分類',
              _buildChipGrid(
                options: _mechanismOptions,
                selectedList: _selectedMechanism,
                onChanged: (s) => _updateLinks('Mechanism', _selectedMechanism),
              ),
            ),
          if (_selectedTraumaGroups.contains('墜落傷'))
            _buildSubContainer(
              '墜落傷詳情',
              _buildTextField(
                controller: _fallHeightController,
                hint: '墜落高度',
                prefixIcon: Icons.height,
                onChanged: (val) => _updateRecord(fallHeight: drift.Value(val)),
              ),
            ),
          if (_selectedTraumaGroups.contains('燒燙傷'))
            _buildSubContainer(
              '燒燙傷詳情',
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _burnDegreeController,
                      hint: '度數',
                      onChanged: (val) =>
                          _updateRecord(burnDegree: drift.Value(val)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _burnAreaController,
                      hint: '面積',
                      suffixText: '%',
                      onChanged: (val) =>
                          _updateRecord(burnArea: drift.Value(val)),
                    ),
                  ),
                ],
              ),
            ),
          if (_selectedTraumaGroups.contains('其它'))
            _buildSubContainer(
              '其它創傷說明',
              _buildTextField(
                controller: _otherTraumaController,
                hint: '請描述其它創傷狀況...',
                prefixIcon: Icons.edit_note,
                onChanged: (val) =>
                    _updateRecord(otherTraumaNote: drift.Value(val)),
              ),
            ),

          const SizedBox(height: 24),
        ],

        if (_mainCategories.contains('NonTrauma')) ...[
          _buildLabel('非創傷項目'),
          const SizedBox(height: 10),
          _buildChipGrid(
            options: _nonTraumaGroupOptions,
            selectedList: _selectedNonTraumaGroups,
            onChanged: (val) =>
                _updateLinks('NonTraumaGroup', _selectedNonTraumaGroups),
          ),
          if (_selectedNonTraumaGroups.contains('急症'))
            _buildSubContainer(
              '急症詳細分類',
              _buildChipGrid(
                options: _acuteOptions,
                selectedList: _selectedAcute,
                onChanged: (s) => _updateLinks('Acute', _selectedAcute),
              ),
            ),
          if (_selectedNonTraumaGroups.contains('一般疾病'))
            _buildSubContainer(
              '一般疾病詳細分類',
              _buildChipGrid(
                options: _generalDiseaseOptions,
                selectedList: _selectedGeneralDisease,
                onChanged: (s) =>
                    _updateLinks('GeneralDisease', _selectedGeneralDisease),
              ),
            ),
        ],

        const SizedBox(height: 32),
        const Divider(color: borderColor),
        const SizedBox(height: 32),

        // 4. 主訴與代訴
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '病患主訴 PATIENT COMPLAINT',
                _buildTextField(
                  controller: _complaintController,
                  hint: '請輸入病患自述內容',
                  onChanged: (val) =>
                      _updateRecord(patientComplaint: drift.Value(val)),
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('家屬或同事友人代訴 PROXY?'),
                  const SizedBox(height: 10),
                  _buildSegmentedControl(['否 No', '是 Yes'], _isProxyComplaint, (
                    v,
                  ) {
                    setState(() => _isProxyComplaint = v);
                    _updateRecord(isProxyComplaint: drift.Value(v == '是 Yes'));
                  }),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 5. 過敏史區塊
        _buildHistoryToggleSection('過敏史 Allergy History', _allergyStatus, (
          val,
        ) {
          setState(() {
            _allergyStatus = val;
            if (val != '有') {
              _selectedAllergies.clear();
              _updateLinks('Allergy', []); // Clear DB links
            }
          });
          _updateRecord(allergyStatus: drift.Value(val));
        }),
        if (_allergyStatus == '有') ...[
          const SizedBox(height: 12),
          _buildDynamicHistoryContainer(
            _buildChipGrid(
              options: _allergyOptions,
              selectedList: _selectedAllergies,
              onChanged: (s) => _updateLinks('Allergy', _selectedAllergies),
            ),
            _selectedAllergies
                .isNotEmpty, // Always show note if '有' or maybe only if items selected?
            // Actually requirement says "請註明具體過敏原", usually implies text input is always available or conditional.
            // Following original logic: _selectedAllergies.isNotEmpty
            '請註明具體過敏原',
            _allergyNoteController,
            (val) => _updateRecord(allergyNote: drift.Value(val)),
          ),
        ],

        const SizedBox(height: 24),

        // 6. 過去病史區塊
        _buildHistoryToggleSection(
          '過去病史 Past Medical History',
          _historyStatus,
          (val) {
            setState(() {
              _historyStatus = val;
              if (val != '有') {
                _selectedHistories.clear();
                _updateLinks('History', []);
              }
            });
            _updateRecord(historyStatus: drift.Value(val));
          },
        ),
        if (_historyStatus == '有') ...[
          const SizedBox(height: 12),
          _buildDynamicHistoryContainer(
            _buildChipGrid(
              options: _historyOptions,
              selectedList: _selectedHistories,
              onChanged: (s) => _updateLinks('History', _selectedHistories),
            ),
            _selectedHistories.contains('其它'),
            '請說明其它病史詳情...',
            _historyNoteController,
            (val) => _updateRecord(historyNote: drift.Value(val)),
          ),
        ],

        const SizedBox(height: 60),
      ],
    );
  }

  // ... (Keep existing helpers but modify as needed) ...

  // --- 新增：主類別的複選按鈕 ---
  Widget _buildMainCategoryButton(String label, String value) {
    bool isSelected = _mainCategories.contains(value);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _mainCategories.remove(value);
              // Clear related links
              if (value == 'Trauma') {
                _selectedTraumaGroups.clear();
                _updateLinks('TraumaGroup', []);
                _selectedGeneralTrauma.clear();
                _updateLinks('GeneralTrauma', []);
                _selectedMechanism.clear();
                _updateLinks('Mechanism', []);
              } else {
                _selectedNonTraumaGroups.clear();
                _updateLinks('NonTraumaGroup', []);
                _selectedAcute.clear();
                _updateLinks('Acute', []);
                _selectedGeneralDisease.clear();
                _updateLinks('GeneralDisease', []);
              }
            } else {
              _mainCategories.add(value);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : borderColor,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : textDark,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 動態歷史紀錄容器
  Widget _buildDynamicHistoryContainer(
    Widget chips,
    bool showInput,
    String inputHint,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chips,
          if (showInput) ...[
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller,
              hint: inputHint,
              prefixIcon: Icons.edit_note,
              onChanged: onChanged,
            ),
          ],
        ],
      ),
    );
  }

  // ... (SubContainer, ChipGrid, SegmentedControl, Label, FieldWrapper - Keep as is) ...

  Widget _buildSubContainer(String label, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildChipGrid({
    required List<String> options,
    required List<String> selectedList,
    required Function(String) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: options.map((opt) {
        bool isSelected = selectedList.contains(opt);
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected ? selectedList.remove(opt) : selectedList.add(opt);
            });
            onChanged(opt);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? primaryColor : borderColor,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: isSelected ? Colors.white : textDark,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSelected = current == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryToggleSection(
    String title,
    String currentVal,
    Function(String) onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title),
        const SizedBox(height: 8),
        _buildSegmentedControl(['無', '不詳', '有'], currentVal, onToggle),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 8), field],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    IconData? prefixIcon,
    String? suffixText,
    Function(String)? onChanged,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 18, color: primaryColor)
              : null,
          suffixText: suffixText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
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
}
