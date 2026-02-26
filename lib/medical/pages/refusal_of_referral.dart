import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/signature_field.dart';
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
  
  // 初始化標記
  bool _isPatientInitialized = false;
  bool _isFormInitialized = false;

  Uint8List? _signatorySignature;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;
    final viewModel = Provider.of<TreatmentViewModel>(context);
    _updateControllers(viewModel);
  }

  // 初始化並帶入資料
  void _updateControllers(TreatmentViewModel viewModel) {
    // 1. 處理病患基本資料 (唯讀，有資料就更新，除非已經手動修改過 - 但此處為唯讀所以直接更新)
    final patient = viewModel.patient;
    if (patient != null && !_isPatientInitialized) {
      _patientNameController.text = patient.name ?? '';
      _patientIdController.text = patient.passportOrIdNo ?? '';
      if (patient.birthday != null) {
        _patientBirthController.text = DateFormat(
          'yyyy/MM/dd',
        ).format(patient.birthday!);
      }
      _isPatientInitialized = true;
    }

    // 2. 處理主責醫師 (若未選擇，嘗試自動帶入)
    if (_selectedDoctor == null && viewModel.medicalStaffList.isNotEmpty) {
      // 輔助函式：根據 ID 查找姓名
      String? findStaffName(int? staffId) {
        if (staffId == null) return null;
        try {
          return viewModel.medicalStaffList
              .firstWhere((s) => s.id == staffId)
              .name;
        } catch (_) {
          return null;
        }
      }

      try {
        final primaryDoctor = viewModel.staffAssignments.firstWhere(
          (a) =>
              viewModel.getStaffRoleCode(a.staffRoleId) == 'DOCTOR' &&
              a.isPrimary,
        );
        // 優先使用 assignment 中的姓名，若無則透過 ID 查找
        _selectedDoctor =
            primaryDoctor.staffName ?? findStaffName(primaryDoctor.staffId);
      } catch (_) {
        // 若無主責醫師，嘗試找任一醫師
        try {
          final anyDoctor = viewModel.staffAssignments.firstWhere(
            (a) => viewModel.getStaffRoleCode(a.staffRoleId) == 'DOCTOR',
          );
          _selectedDoctor =
              anyDoctor.staffName ?? findStaffName(anyDoctor.staffId);
        } catch (_) {}
      }
    }

    // 3. 處理轉診單/切結書資料
    final form = viewModel.referralForm;
    if (form != null && !_isFormInitialized) {
      // 填入已存資料
      if (form.contactName != null) {
        _signatoryNameController.text = form.contactName!;
      }
      if (form.contactIdNo != null) {
        _signatoryIdController.text = form.contactIdNo!;
      }
      if (form.otherRelationship != null) {
        _relationshipController.text = form.otherRelationship!;
      }
      if (form.contactAddress != null) {
        _addressController.text = form.contactAddress!;
      }
      if (form.contactPhone != null) {
        _phoneController.text = form.contactPhone!;
      }
      if (form.consentSignature != null) {
        _signatorySignature = form.consentSignature;
      }

      // 若資料庫無資料，且為「本人」模式，則自動帶入病患資料
      if (_isSelf &&
          (form.contactName == null || form.contactName!.isEmpty) &&
          patient != null) {
        Future.microtask(() => _updateSignatoryInfo(viewModel));
      }
      
      _isFormInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreatmentViewModel>();
    
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
                '病患姓名 PATIENT NAME',
                _buildTextField(
                  hint: '例如: CHEN TAI MAN',
                  controller: _patientNameController,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '身分證字號 ID NO.',
                _buildTextField(
                  hint: '例如: P12345678',
                  controller: _patientIdController,
                  readOnly: true,
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
                    onChanged: (val) =>
                        viewModel.updateReferralConsent(otherRelationship: val),
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
                  onChanged: (val) =>
                      viewModel.updateReferralContactInfo(name: val),
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
                  onChanged: (val) =>
                      viewModel.updateReferralContactInfo(idNo: val),
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
                  onChanged: (val) =>
                      viewModel.updateReferralContactInfo(address: val),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '電話 Phone',
                _buildTextField(
                  hint: '請輸入聯絡電話',
                  controller: _phoneController,
                  onChanged: (val) =>
                      viewModel.updateReferralContactInfo(phone: val),
                ),
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
                SignatureField(
                  placeholder: 'Digital Signature Area (請在此區域簽名)',
                  value: _signatorySignature,
                  onChanged: (data) {
                    setState(() => _signatorySignature = data);
                    viewModel.updateReferralConsent(signature: data);
                  },
                ),
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
              Text(
                '本人：${_patientNameController.text}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const Spacer(),
              Text(
                '身分證字號 ID No.：${_patientIdController.text}',
                style: const TextStyle(
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
              Text(
                _selectedDoctor ?? '___________',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                  decoration: TextDecoration.underline,
                ),
              ),
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
          Text(
            'I: ${_patientNameController.text}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          Text(
            'Date of birth: ${_patientBirthController.text}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          Text(
            'Passport / I.D. No: ${_patientIdController.text}',
            style: const TextStyle(
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
            patient.passportOrIdNo ?? patient.idNo ?? '';
        _addressController.text = patient.address ?? '';
        _phoneController.text = patient.telephone ?? '';

        viewModel.updateReferralContactInfo(
          name: patient.name,
          idNo: patient.passportOrIdNo ?? patient.idNo,
          address: patient.address,
          phone: patient.telephone,
        );
      }
    } else {
      _signatoryNameController.clear();
      _signatoryIdController.clear();
      _relationshipController.clear();
      _addressController.clear();
      _phoneController.clear();

      viewModel.updateReferralContactInfo(
        name: '',
        idNo: '',
        address: '',
        phone: '',
      );
    }
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
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
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
