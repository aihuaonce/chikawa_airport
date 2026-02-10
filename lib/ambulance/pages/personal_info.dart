import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../../medical/widgets/signature_field.dart';

class AmbulancePersonalInfo extends StatefulWidget {
  final int medicalId;

  const AmbulancePersonalInfo({super.key, required this.medicalId});

  @override
  State<AmbulancePersonalInfo> createState() => _AmbulancePersonalInfoState();
}

class _AmbulancePersonalInfoState extends State<AmbulancePersonalInfo> {
  // 樣式顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Colors.white;

  // 狀態變數
  int? _selectedSexId;
  List<SexData> _sexList = [];
  bool _isHandled = false; // 控制是否經手的開關
  bool _isInitialized = false;

  // Controllers
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _financialController = TextEditingController();
  final TextEditingController _custodianController = TextEditingController();

  Uint8List? _custodianSignature;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _idController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _financialController.dispose();
    _custodianController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = context.read<AppDatabase>();

    // Load Reference Data
    final sexData = await db.referenceDao.getAllSex();
    // Ensure consistent order: Male(1), Female(2), Other(3)
    _sexList = sexData.toList()..sort((a, b) => a.sexId.compareTo(b.sexId));

    // Load Patient Data
    final patient = await db.medicalDao.getPatientByMedicalId(widget.medicalId);
    if (patient != null) {
      _selectedSexId = patient.sexId;
      _idController.text = patient.idNo ?? patient.passportOrIdNo ?? '';
      _addressController.text = patient.address ?? '';

      if (patient.birthday != null) {
        final age = DateTime.now().year - patient.birthday!.year;
        _ageController.text = age.toString();
      }
    }

    // Load Ambulance Personal Property
    final property = await db.ambulanceDao.getPersonalProperty(
      widget.medicalId,
    );
    if (property != null) {
      _isHandled = property.isHandled;
      _financialController.text = property.financialDetails ?? '';
      _custodianController.text = property.custodianName ?? '';
      _custodianSignature = property.custodianSignature;
    }

    _isInitialized = true;
    if (mounted) setState(() {});
  }

  // Helper to save patient data
  Future<void> _updatePatientColumn(PatientCompanion companion) async {
    if (!_isInitialized) return;
    final db = context.read<AppDatabase>();
    await db.medicalDao.updatePatientColumn(widget.medicalId, companion);
  }

  // Helper to save property data
  Future<void> _updatePropertyData({
    drift.Value<bool>? isHandled,
    drift.Value<String?>? financialDetails,
    drift.Value<String?>? custodianName,
    drift.Value<Uint8List?>? custodianSignature,
  }) async {
    if (!_isInitialized) return;
    final db = context.read<AppDatabase>();
    await db.ambulanceDao.updatePersonalProperty(
      AmbulancePersonalPropertyCompanion(
        medicalId: drift.Value(widget.medicalId),
        isHandled: isHandled ?? const drift.Value.absent(),
        financialDetails: financialDetails ?? const drift.Value.absent(),
        custodianName: custodianName ?? const drift.Value.absent(),
        custodianSignature: custodianSignature ?? const drift.Value.absent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一排：性別 與 身分證字號
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper('性別 GENDER', _buildGenderToggle()),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '身分證字號/護照號碼 ID/PASSPORT NO.',
                _buildTextField(
                  controller: _idController,
                  hint: '輸入號碼',
                  onChanged: (val) => _updatePatientColumn(
                    PatientCompanion(idNo: drift.Value(val)),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：年齡 與 地址
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '年齡 AGE',
                _buildTextField(
                  controller: _ageController,
                  hint: '輸入年齡',
                  isNumber: true,
                  onChanged: (val) {
                    // Note: We don't typically update birthday from age directly as it's imprecise,
                    // but we can't store age in Patient table directly without a column.
                    // For now, assume age is display-only or derived, unless we want to estimate birthday.
                    // If the user requirement implies saving age, we might need a birthday estimation or an age column.
                    // Given the current Patient table structure, we'll skip saving age to birthday for now
                    // to avoid overwriting precise birthdays with estimates.
                  },
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '地址 ADDRESS',
                _buildTextField(
                  controller: _addressController,
                  hint: '輸入詳細居住地址',
                  onChanged: (val) => _updatePatientColumn(
                    PatientCompanion(address: drift.Value(val)),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第三排：病患財務明細
        _buildFieldWrapper(
          '病患財務明細 PATIENT\'S FINANCIAL DETAILS',
          _buildTextField(
            controller: _financialController,
            hint: '請列出經手的現金、貴重物品或其他物品...',
            maxLines: 4,
            onChanged: (val) =>
                _updatePropertyData(financialDetails: drift.Value(val)),
          ),
        ),

        const SizedBox(height: 24),

        // 第四排：是否有經手開關
        _buildFieldWrapper('是否有經手財務/隨身物品? HANDLED?', _buildToggleRow('開啟經手記錄')),

        // ===== 動態顯示區域：只有 _isHandled 為 true 時才出現 =====
        if (_isHandled) ...[
          const SizedBox(height: 24),
          _buildFieldWrapper(
            '保管人姓名 CUSTODIAN NAME',
            _buildTextField(
              controller: _custodianController,
              hint: '請輸入負責保管之人員姓名',
              onChanged: (val) =>
                  _updatePropertyData(custodianName: drift.Value(val)),
            ),
          ),
          const SizedBox(height: 24),

          // 呼叫簽名元件
          _buildSignatureArea('保管人簽名 CUSTODIAN SIGNATURE', '請於此區域內進行數位簽署'),
        ],

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件實作 ---

  Widget _buildGenderToggle() {
    if (_sexList.isEmpty) {
      return const SizedBox(
        height: 44,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Find index of selected sex
    int? selectedIndex;
    if (_selectedSexId != null) {
      final index = _sexList.indexWhere((s) => s.sexId == _selectedSexId);
      if (index != -1) selectedIndex = index;
    }

    return SlidingToggle(
      selectedIndex: selectedIndex,
      options: _sexList.map((s) => s.name).toList(),
      onChanged: (index) {
        if (index >= 0 && index < _sexList.length) {
          final newSexId = _sexList[index].sexId;
          setState(() => _selectedSexId = newSexId);
          _updatePatientColumn(PatientCompanion(sexId: drift.Value(newSexId)));
        }
      },
    );
  }

  Widget _buildToggleRow(String label) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _isHandled ? primaryColor.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _isHandled ? primaryColor : borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: _isHandled ? primaryColor : textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: _isHandled,
            onChanged: (v) {
              setState(() => _isHandled = v);
              _updatePropertyData(isHandled: drift.Value(v));
            },
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureArea(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        SignatureField(
          placeholder: placeholder,
          value: _custodianSignature,
          onChanged: (data) {
            setState(() {
              _custodianSignature = data;
            });
            _updatePropertyData(custodianSignature: drift.Value(data));
          },
          borderColor: borderColor,
        ),
      ],
    );
  }

  // --- 基礎元件 ---

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
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool isNumber = false,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 14, color: textDark),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
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
    );
  }
}

class SlidingToggle extends StatelessWidget {
  final int? selectedIndex;
  final List<String> options;
  final Function(int) onChanged;

  const SlidingToggle({
    super.key,
    required this.selectedIndex,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          if (selectedIndex != null)
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: _getAlignment(selectedIndex!, options.length),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FractionallySizedBox(
                  widthFactor: 1 / options.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: List.generate(options.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      options[index],
                      style: TextStyle(
                        color: selectedIndex == index
                            ? const Color(0xFF007A8A)
                            : const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Alignment _getAlignment(int index, int total) {
    if (total <= 1) return Alignment.center;
    return Alignment(-1.0 + (index / (total - 1)) * 2.0, 0);
  }
}
