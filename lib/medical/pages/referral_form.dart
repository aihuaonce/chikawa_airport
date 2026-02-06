import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/medical/referral_form_view.dart';
import '../../data/models/medical/treatment_view.dart';
import '../../data/db/database.dart';
import '../widgets/reference_search_sheet.dart';
import '../widgets/signature_field.dart';

class ReferralForm extends StatefulWidget {
  final int medicalId;

  const ReferralForm({super.key, required this.medicalId});

  @override
  State<ReferralForm> createState() => _ReferralFormState();
}

class _ReferralFormState extends State<ReferralForm> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // 聯絡人資料
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _contactAddressController =
      TextEditingController();

  // 診斷
  final TextEditingController _primaryDiagnosisController =
      TextEditingController();
  final TextEditingController _secondaryDiagnosis1Controller =
      TextEditingController();
  final TextEditingController _secondaryDiagnosis2Controller =
      TextEditingController();

  // 檢查及治療摘要
  final TextEditingController _recentExamResultController =
      TextEditingController();
  final TextEditingController _examDateController = TextEditingController();
  final TextEditingController _recentMedicationController =
      TextEditingController();
  final TextEditingController _medDateController = TextEditingController();

  // 轉診目的
  final TextEditingController _otherPurposeController = TextEditingController();

  // 醫師交辦
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _doctorDepartmentController =
      TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // 建議轉診院所
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalDeptController = TextEditingController();
  final TextEditingController _hospitalDoctorController =
      TextEditingController();
  final TextEditingController _hospitalPhoneController =
      TextEditingController();
  final TextEditingController _hospitalAddressController =
      TextEditingController();

  // 安排就醫
  final TextEditingController _scheduledDateController =
      TextEditingController();
  final TextEditingController _scheduledDeptController =
      TextEditingController();
  final TextEditingController _scheduledRoomController =
      TextEditingController();
  final TextEditingController _scheduledNumberController =
      TextEditingController();

  // 聲明與同意
  final TextEditingController _consentDateTimeController =
      TextEditingController();
  final TextEditingController _otherRelationController =
      TextEditingController();

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    // 每次進入頁面時，嘗試從其他模組（如處置）帶入最新資料
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<ReferralFormViewModel>();
      // 如果有資料更新（從 DB 帶入新的預設值），則重置控制器初始化狀態，讓 _updateControllers 重新填值
      final updated = await viewModel.populateMissingData();
      if (updated && mounted) {
        setState(() {
          _controllersInitialized = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // 聯絡人資料
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _contactAddressController.dispose();

    // 診斷
    _primaryDiagnosisController.dispose();
    _secondaryDiagnosis1Controller.dispose();
    _secondaryDiagnosis2Controller.dispose();

    // 檢查及治療摘要
    _recentExamResultController.dispose();
    _examDateController.dispose();
    _recentMedicationController.dispose();
    _medDateController.dispose();

    // 轉診目的
    _otherPurposeController.dispose();

    // 醫師交辦
    _doctorNameController.dispose();
    _doctorDepartmentController.dispose();
    _orderDateController.dispose();
    _notesController.dispose();

    // 建議轉診院所
    _hospitalNameController.dispose();
    _hospitalDeptController.dispose();
    _hospitalDoctorController.dispose();
    _hospitalPhoneController.dispose();
    _hospitalAddressController.dispose();

    // 安排就醫
    _scheduledDateController.dispose();
    _scheduledDeptController.dispose();
    _scheduledRoomController.dispose();
    _scheduledNumberController.dispose();

    // 聲明與同意
    _consentDateTimeController.dispose();
    _otherRelationController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(
    TextEditingController controller, {
    Function(DateTime)? onDateSelected,
  }) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: const ColorScheme.light(primary: primaryColor)),
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted = DateFormat('yyyy/MM/dd').format(picked);
      controller.text = formatted;
      onDateSelected?.call(picked);
    }
  }

  void _updateControllers(
    ReferralFormViewModel viewModel,
    TreatmentViewModel treatmentViewModel,
  ) {
    if (_controllersInitialized || viewModel.form == null) return;

    final form = viewModel.form!;

    // 聯絡人資料
    _contactNameController.text = form.contactName ?? '';
    _contactPhoneController.text = form.contactPhone ?? '';
    _contactAddressController.text = form.contactAddress ?? '';

    // 診斷
    _primaryDiagnosisController.text = form.primaryDiagnosis ?? '';
    _secondaryDiagnosis1Controller.text = form.secondaryDiagnosis1 ?? '';
    _secondaryDiagnosis2Controller.text = form.secondaryDiagnosis2 ?? '';

    // 檢查及治療摘要
    _recentExamResultController.text = form.recentExamResult ?? '';
    _examDateController.text = form.examDate != null
        ? DateFormat('yyyy/MM/dd').format(form.examDate!)
        : '';
    _recentMedicationController.text = form.recentMedication ?? '';
    _medDateController.text = form.medicationDate != null
        ? DateFormat('yyyy/MM/dd').format(form.medicationDate!)
        : '';

    // 轉診目的
    _otherPurposeController.text = form.otherPurpose ?? '';

    // 醫師交辦
    _doctorNameController.text = form.doctorName ?? '';
    _doctorDepartmentController.text = form.doctorDepartment ?? '';
    _orderDateController.text = form.orderDate != null
        ? DateFormat('yyyy/MM/dd').format(form.orderDate!)
        : '';
    _notesController.text = form.notes ?? '';

    // 建議轉診院所
    _hospitalNameController.text = form.hospitalName ?? '';
    _hospitalDeptController.text = form.hospitalDept ?? '';
    _hospitalDoctorController.text = form.hospitalDoctor ?? '';
    _hospitalPhoneController.text = form.hospitalPhone ?? '';
    _hospitalAddressController.text = form.hospitalAddress ?? '';

    // 安排就醫
    _scheduledDateController.text = form.scheduledDate != null
        ? DateFormat('yyyy/MM/dd').format(form.scheduledDate!)
        : '';
    _scheduledDeptController.text = form.scheduledDept ?? '';
    _scheduledRoomController.text = form.scheduledRoom ?? '';
    _scheduledNumberController.text = form.scheduledNumber ?? '';

    // 聲明與同意
    _consentDateTimeController.text = form.consentDateTime != null
        ? DateFormat('yyyy/MM/dd HH:mm').format(form.consentDateTime!)
        : '';
    _otherRelationController.text = form.otherRelationship ?? '';

    _controllersInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReferralFormViewModel>();
    final treatmentViewModel = context.watch<TreatmentViewModel>();

    // 同步 ViewModel 資料到 Controllers
    _updateControllers(viewModel, treatmentViewModel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 聯絡人資料
        _buildSectionTitle('1. 聯絡人資料 Contact Info'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '姓名 Name',
                _buildTextField(
                  hint: '請輸入姓名',
                  controller: _contactNameController,
                  onChanged: (v) => viewModel.updateContactInfo(name: v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '電話 Phone',
                _buildTextField(
                  hint: '聯絡電話',
                  controller: _contactPhoneController,
                  onChanged: (v) => viewModel.updateContactInfo(phone: v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldWrapper(
          '地址 Address',
          _buildTextField(
            hint: '詳細居住地址',
            controller: _contactAddressController,
            onChanged: (v) => viewModel.updateContactInfo(address: v),
          ),
        ),

        const SizedBox(height: 32),

        // 2. 診斷病名
        _buildSectionTitle('2. 診斷病名 Diagnosis ICD-10'),
        const SizedBox(height: 12),
        _buildFieldWrapper(
          '主診斷 Primary Diagnosis',
          _buildTextField(
            hint: '搜尋 ICD-10 代碼或診斷描述',
            controller: _primaryDiagnosisController,
            onChanged: (v) => viewModel.updateDiagnosis(primary: v),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '副診斷 1 Secondary #1',
                _buildTextField(
                  hint: '選填',
                  controller: _secondaryDiagnosis1Controller,
                  onChanged: (v) => viewModel.updateDiagnosis(secondary1: v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '副診斷 2 Secondary #2',
                _buildTextField(
                  hint: '選填',
                  controller: _secondaryDiagnosis2Controller,
                  onChanged: (v) => viewModel.updateDiagnosis(secondary2: v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 3. 檢查及治療摘要
        _buildSectionTitle('3. 檢查及治療摘要 Summary'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '最近一次檢查結果 Recent Result',
                _buildTextField(
                  hint: '實驗室或影像檢查發現',
                  controller: _recentExamResultController,
                  onChanged: (v) =>
                      viewModel.updateExamSummary(recentExamResult: v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '檢查日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _examDateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    _examDateController,
                    onDateSelected: (date) =>
                        viewModel.updateExamSummary(examDate: date),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '最近一次用藥或手術名稱 Medication/Surgery',
                _buildTextField(
                  hint: '藥物名稱或處置流程',
                  controller: _recentMedicationController,
                  onChanged: (v) =>
                      viewModel.updateExamSummary(recentMedication: v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '處置日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _medDateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    _medDateController,
                    onDateSelected: (date) =>
                        viewModel.updateExamSummary(medicationDate: date),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 4. 轉診目的
        _buildSectionTitle('4. 轉診目的 Purpose of Referral'),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: Row(
            children: [
              ...viewModel.referralPurposes
                  .map((purpose) {
                    final isLast = purpose == viewModel.referralPurposes.last;
                    return [
                      _buildPurposeToggle(
                        purpose,
                        viewModel.selectedPurpose?.id == purpose.id,
                        (selected) => viewModel.updateReferralPurpose(
                          selected ? purpose.id : null,
                        ),
                      ),
                      if (!isLast) const SizedBox(width: 8),
                    ];
                  })
                  .expand((widgets) => widgets),
            ],
          ),
        ),

        if (viewModel.selectedPurpose?.name == '其它') ...[
          const SizedBox(height: 12),
          _buildFieldWrapper(
            '請註明其它目的 Specify Other Purpose',
            _buildTextField(
              hint: '請輸入其它轉診目的說明...',
              controller: _otherPurposeController,
              onChanged: (v) => viewModel.updateReferralPurpose(
                viewModel.selectedPurpose?.id,
                otherPurpose: v,
              ),
            ),
          ),
        ],

        const SizedBox(height: 32),

        // 5. 醫師交辦與簽署
        _buildSectionTitle('5. 醫師交辦與簽署 Physician & Staff'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '診治醫師姓名 Doctor Name',
                _buildTextField(
                  hint: '醫師姓名',
                  controller: _doctorNameController,
                  onChanged: (v) => viewModel.updateDoctorInfo(name: v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '診治醫師科別 Department',
                _buildTextField(
                  hint: '科別',
                  controller: _doctorDepartmentController,
                  onChanged: (v) => viewModel.updateDoctorInfo(department: v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '診治醫師簽名 Signature',
                SignatureField(
                  placeholder: '醫師簽名',
                  value: viewModel.form?.doctorSignature,
                  onChanged: (data) => viewModel.updateDoctorSignature(data),
                  height: 108,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '開單日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _orderDateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    _orderDateController,
                    onDateSelected: (date) =>
                        viewModel.updateDoctorInfo(orderDate: date),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldWrapper(
          '注意事項 Notes',
          _buildTextField(
            hint: '特殊醫囑或指示...',
            maxLines: 3,
            controller: _notesController,
            onChanged: (v) => viewModel.updateDoctorInfo(notes: v),
          ),
        ),

        const SizedBox(height: 32),

        // 6. 建議轉診院所
        _buildSectionTitle('6. 建議轉診院所 Suggested Institution'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '院所名稱 Name',
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        hint: '醫療機構名稱',
                        controller: _hospitalNameController,
                        onChanged: (v) => viewModel.updateHospitalInfo(name: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await ReferenceSearchSheet.show<
                              ReferralHospitalData
                            >(
                              context,
                              title: '選擇轉診院所',
                              searchFunction: (query) async {
                                final refService =
                                    treatmentViewModel.refService;
                                if (query.isEmpty) {
                                  return refService.referralHospitals;
                                }
                                return refService.referralHospitals
                                    .where(
                                      (h) =>
                                          h.name.contains(query) ||
                                          (h.phone?.contains(query) ?? false),
                                    )
                                    .toList();
                              },
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(item.phone ?? ''),
                                );
                              },
                            );

                        if (result != null) {
                          viewModel.updateHospitalInfo(
                            name: result.name,
                            phone: result.phone,
                            address: result.address,
                          );
                          _hospitalNameController.text = result.name;
                          _hospitalPhoneController.text = result.phone ?? '';
                          _hospitalAddressController.text =
                              result.address ?? '';
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '科別 Dept',
                _buildTextField(
                  hint: '建議科別',
                  controller: _hospitalDeptController,
                  onChanged: (v) => viewModel.updateHospitalInfo(dept: v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '醫師姓名 Doctor',
                _buildTextField(
                  hint: '建議醫師',
                  controller: _hospitalDoctorController,
                  onChanged: (v) => viewModel.updateHospitalInfo(doctor: v),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFieldWrapper(
                '電話 Phone',
                _buildTextField(
                  hint: '聯絡電話',
                  controller: _hospitalPhoneController,
                  onChanged: (v) => viewModel.updateHospitalInfo(phone: v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldWrapper(
          '地址 Address',
          _buildTextField(
            hint: '院所詳細地址',
            controller: _hospitalAddressController,
            onChanged: (v) => viewModel.updateHospitalInfo(address: v),
          ),
        ),

        const SizedBox(height: 32),

        // 7. 安排就醫
        _buildSectionTitle('7. 安排就醫 Scheduled Visit'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '日期 Date',
                _buildTextField(
                  hint: 'YYYY/MM/DD',
                  controller: _scheduledDateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    _scheduledDateController,
                    onDateSelected: (date) =>
                        viewModel.updateScheduledVisit(date: date),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFieldWrapper(
                '科別 Dept',
                _buildTextField(
                  hint: '就醫科別',
                  controller: _scheduledDeptController,
                  onChanged: (v) => viewModel.updateScheduledVisit(dept: v),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFieldWrapper(
                '診間 Room',
                _buildTextField(
                  hint: '診間號碼',
                  controller: _scheduledRoomController,
                  onChanged: (v) => viewModel.updateScheduledVisit(room: v),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFieldWrapper(
                '號碼 No.',
                _buildTextField(
                  hint: '掛號號碼',
                  controller: _scheduledNumberController,
                  onChanged: (v) => viewModel.updateScheduledVisit(number: v),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 8. 聲明與同意
        _buildSectionTitle('8. 聲明與同意 Declaration & Consent'),
        const SizedBox(height: 12),
        _buildConsentSection(viewModel),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件 ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 44 : null,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 13,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
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
      ),
    );
  }

  Widget _buildPurposeToggle(
    ReferralPurposeData purpose,
    bool isSelected,
    Function(bool) onToggle,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(!isSelected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              if (isSelected)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    purpose.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildConsentSection(ReferralFormViewModel viewModel) {
    final selectedRelationship = viewModel.selectedRelationship;
    final isOther =
        selectedRelationship?.name == '其他' ||
        selectedRelationship?.nameEn?.toLowerCase() == 'other';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '經醫師解釋病情及轉診目的後同意轉院。',
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildFieldWrapper(
                  '同意人簽名 Consenter Signature',
                  SignatureField(
                    placeholder: '同意人簽名',
                    value: viewModel.form?.consentSignature,
                    onChanged: (data) => viewModel.updateConsentSignature(data),
                    height: isOther ? 168 : 108,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildFieldWrapper(
                      '與病人關係 Relationship',
                      _buildRelationshipDropdown(viewModel),
                    ),
                    if (isOther) ...[
                      const SizedBox(height: 16),
                      _buildFieldWrapper(
                        '請註明關係 Specify Relationship',
                        _buildTextField(
                          hint: '例如：朋友、同事',
                          controller: _otherRelationController,
                          onChanged: (v) => viewModel.updateConsent(
                            relationshipId: selectedRelationship?.id,
                            otherRelationship: v,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildFieldWrapper(
                      '日期與時間 Signature Date/Time',
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              hint: 'YYYY/MM/DD HH:mm',
                              controller: _consentDateTimeController,
                              onChanged: (v) {
                                final date = DateFormat(
                                  'yyyy/MM/dd HH:mm',
                                ).tryParse(v);
                                viewModel.updateConsent(
                                  relationshipId: selectedRelationship?.id,
                                  consentDateTime: date,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                final now = DateTime.now();
                                _consentDateTimeController.text = DateFormat(
                                  'yyyy/MM/dd HH:mm',
                                ).format(now);
                                viewModel.updateConsent(
                                  relationshipId: selectedRelationship?.id,
                                  consentDateTime: now,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'NOW',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipDropdown(ReferralFormViewModel viewModel) {
    final selectedRelationship = viewModel.selectedRelationship;
    final relationshipTypes = viewModel.relationshipTypes;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RelationshipTypeData?>(
          value: selectedRelationship,
          isExpanded: true,
          items: relationshipTypes.map((type) {
            return DropdownMenuItem<RelationshipTypeData>(
              value: type,
              child: Text(
                type.nameEn != null && type.nameEn!.isNotEmpty
                    ? '${type.name} (${type.nameEn})'
                    : type.name,
                style: const TextStyle(fontSize: 14, color: textDark),
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              viewModel.updateConsent(relationshipId: v.id);
            }
          },
        ),
      ),
    );
  }
}
