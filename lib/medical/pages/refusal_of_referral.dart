import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical/treatment_view.dart';

class RefusalOfReferral extends StatefulWidget {
  final int medicalId;

  const RefusalOfReferral({super.key, required this.medicalId});

  @override
  State<RefusalOfReferral> createState() => _RefusalOfReferralState();
}

class _RefusalOfReferralState extends State<RefusalOfReferral> {
  // 樣式顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // 控制器 - 病患基本資料 (圖二)
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _patientBirthController = TextEditingController();

  // 控制器 - 立切結書人資訊
  final TextEditingController _signatoryNameController =
      TextEditingController();
  final TextEditingController _signatoryIdController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentDateController = TextEditingController();

  // 狀態變數
  bool _isSelf = true;
  String? _selectedDoctor; // 改為 nullable 以支援動態載入
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentDateController.text = DateFormat(
      'yyyy/MM/dd',
    ).format(DateTime.now());
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientIdController.dispose();
    _patientBirthController.dispose();
    _signatoryNameController.dispose();
    _signatoryIdController.dispose();
    _relationshipController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _currentDateController.dispose();
    super.dispose();
  }

  // 初始化並帶入資料
  void _updateControllers(TreatmentViewModel viewModel) {
    if (_isInitialized) return;

    // 檢查關鍵資料是否已載入
    if (viewModel.patient == null || viewModel.medicalStaffList.isEmpty) {
      return;
    }

    final patient = viewModel.patient;
    if (patient != null) {
      if (_patientNameController.text.isEmpty) {
        _patientNameController.text = patient.name ?? '';
      }
      if (_patientIdController.text.isEmpty) {
        _patientIdController.text = patient.passportOrIdNo ?? '';
      }
      if (_patientBirthController.text.isEmpty && patient.birthday != null) {
        _patientBirthController.text = DateFormat(
          'yyyy/MM/dd',
        ).format(patient.birthday!);
      }
    }

    // 嘗試帶入主責醫師
    if (_selectedDoctor == null) {
      try {
        final primaryDoctor = viewModel.staffAssignments.firstWhere(
          (a) =>
              viewModel.getStaffRoleCode(a.staffRoleId) == 'DOCTOR' &&
              a.isPrimary,
        );
        if (primaryDoctor.staffName != null) {
          _selectedDoctor = primaryDoctor.staffName;
        }
      } catch (_) {
        // 若無主責醫師，嘗試找任一醫師
        try {
          final anyDoctor = viewModel.staffAssignments.firstWhere(
            (a) => viewModel.getStaffRoleCode(a.staffRoleId) == 'DOCTOR',
          );
          if (anyDoctor.staffName != null) {
            _selectedDoctor = anyDoctor.staffName;
          }
        } catch (_) {}
      }
    }

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreatmentViewModel>();
    _updateControllers(viewModel);

    // 檢查處置結果是否為拒絕轉診
    final treatment = viewModel.treatment;
    final refusedResult = viewModel.treatmentResults
        .where((r) => r.name.contains('拒絕') || r.name.contains('Refused'))
        .firstOrNull;

    if (treatment == null ||
        refusedResult == null ||
        treatment.resultId != refusedResult.id) {
      return const Center(
        child: Text(
          '此案件非拒絕轉診，無需填寫此切結書。\n(This form is only for Refusal of Referral)',
          textAlign: TextAlign.center,
          style: TextStyle(color: textMuted, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 病患基本資料 (圖二)
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '本人/病患姓名 PATIENT NAME',
                _buildTextField(
                  hint: '例如: CHEN TAI MAN',
                  controller: _patientNameController,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '身分證/護照號碼 ID/PASSPORT NO',
                _buildTextField(
                  hint: '例如: P12345678',
                  controller: _patientIdController,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '出生日期 BIRTH DATE',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _patientBirthController,
                  suffixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(context, _patientBirthController),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 2. 中英文切結內容 (圖一)
        _buildSectionHeader(
          '切結內容 Legal Statement',
          'Bilingual declaration for Against Medical Advice (AMA).',
        ),
        const SizedBox(height: 16),
        _buildLegalStatementBox(viewModel),

        const SizedBox(height: 32),

        // 3. 身份驗證區塊
        _buildSectionHeader(
          '立切結書人資訊 Signatory Information',
          'Information of the person signing this document.',
        ),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildIdentityToggle(viewModel),
            const SizedBox(width: 24),
            if (!_isSelf)
              Expanded(
                child: _buildFieldWrapper(
                  '與病患關係 Relationship',
                  _buildTextField(
                    hint: '例如：本人、父母、配偶',
                    controller: _relationshipController,
                  ),
                ),
              )
            else
              const Spacer(),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '立切結書人姓名 Signatory Name',
                _buildTextField(
                  hint: '請輸入姓名',
                  controller: _signatoryNameController,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '身分證字號 Signatory ID',
                _buildTextField(
                  hint: '請輸入身分證或護照號碼',
                  controller: _signatoryIdController,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '住址 Address',
                _buildTextField(
                  hint: '請輸入詳細聯絡地址',
                  controller: _addressController,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '電話 Phone',
                _buildTextField(hint: '請輸入聯絡電話', controller: _phoneController),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 4. 簽名與日期
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '立切結書人簽署 Signature',
                _buildSignaturePad('Digital Signature Area (請在此區域簽名)'),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '日期 Date',
                _buildTextField(
                  hint: '',
                  controller: _currentDateController,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () => _selectDate(context, _currentDateController),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 組件實作 ---

  Widget _buildLegalStatementBox(TreatmentViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 中文部分
          Row(
            children: [
              const Text(
                '本人：',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const Spacer(),
              const Text(
                '身分證字號：',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${_currentDateController.text} 於桃園國際機場接受聯新國際醫院桃園國際機場醫療中心醫師 ',
                style: const TextStyle(fontSize: 14, color: textDark),
              ),
              _buildDoctorDropdown(viewModel),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '診視，醫師建議轉診至醫院繼續治療，但本人因個人因素拒絕醫師「繼續治療」之建議，致生一切後果願自行負責，與聯新國際醫院桃園國際機場醫療中心無涉。',
            style: TextStyle(fontSize: 14, color: textDark, height: 1.6),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: borderColor),
          ),

          // 英文部分 (圖一精確還原)
          const Text(
            'I:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const Text(
            'Date of birth:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const Text(
            'Passport / I.D. No:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Here by clarified that I / my family patient had been notified by Dr. ${_selectedDoctor ?? '_____'} of Landseed Medical Clinic at Taiwan Taoyuan Int'l Airport, I am /my family patient is now in illness/necessary condition which needed to be transported to an advanced hospital facilities for further test and treatment. But under my our personal status/consideration, I/We decided to handle this situation by myself/ourselves, against any further medical advice I am hereby signing this consent clarified that I am /and my family are willing to take all the risks and hold all the responsibilities of any consequences, even hazardous to my/my family member's health or life integrity unexpectedly.",
            style: TextStyle(
              fontSize: 13,
              color: textMuted,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityToggle(TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('是否為本人？ Is Self?'),
        const SizedBox(height: 8),
        Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildToggleItem('本人 Self', _isSelf, true, viewModel),
              _buildToggleItem('代簽 Proxy', !_isSelf, false, viewModel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(
    String label,
    bool active,
    bool value,
    TreatmentViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelf = value;
          _updateSignatoryInfo(viewModel);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : textMuted,
          ),
        ),
      ),
    );
  }

  void _updateSignatoryInfo(TreatmentViewModel viewModel) {
    if (_isSelf) {
      final patient = viewModel.patient;
      if (patient != null) {
        _signatoryNameController.text = patient.name ?? '';
        _signatoryIdController.text =
            patient.idNo ?? patient.passportOrIdNo ?? '';
        _addressController.text = patient.address ?? '';
        _phoneController.text = patient.telephone ?? '';
      }
    } else {
      _signatoryNameController.clear();
      _signatoryIdController.clear();
      _relationshipController.clear();
      _addressController.clear();
      _phoneController.clear();
    }
  }

  Widget _buildDoctorDropdown(TreatmentViewModel viewModel) {
    // 篩選出醫師清單
    final doctors = viewModel.medicalStaffList
        .where((s) => s.role == 'Doctor')
        .map((s) => s.name)
        .toSet() // 去重
        .toList();

    // 確保當前選擇的醫師在清單中
    if (_selectedDoctor != null && !doctors.contains(_selectedDoctor)) {
      doctors.add(_selectedDoctor!);
    }

    // 若清單為空，提供預設選項
    if (doctors.isEmpty) {
      doctors.add('醫師 A');
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedDoctor,
        hint: const Text('請選擇醫師'),
        icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDoctor = newValue!;
          });
        },
        items: doctors.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  Widget _buildSignaturePad(String placeholder) {
    return AspectRatio(
      aspectRatio: 2.5 / 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.draw_outlined, color: borderColor, size: 40),
                  Text(
                    placeholder,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  '重寫 Clear',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 基礎組件 ---

  Widget _buildSectionHeader(String title, String subTitle) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subTitle,
              style: const TextStyle(color: textMuted, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 10,
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
    required TextEditingController controller,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        fontSize: 14,
        color: textDark,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.4),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: primaryColor, size: 18)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
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
