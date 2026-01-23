import 'package:chikawa_airport/data/models/medical_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/db/database.dart';

class PersonalInfo extends StatefulWidget {
  final int medicalId;

  const PersonalInfo({super.key, required this.medicalId});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // 顏色與樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  // 控制器
  late TextEditingController _nameController;
  late TextEditingController _passportController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passportController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _birthdayController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passportController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  // 當 ViewModel 資料載入後，同步到 Controller
  void _updateControllers(PatientData patient) {
    final birthday = patient.birthday;

    if (_isInitialized) return;

    _nameController.text = patient.name ?? '';
    _passportController.text = patient.passportOrIdNo ?? '';
    _phoneController.text = patient.telephone ?? '';
    _addressController.text = patient.address ?? '';

    if (birthday != null) {
      _birthdayController.text = DateFormat('yyyy/MM/dd').format(birthday);
    }

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 ViewModel
    final viewModel = context.watch<MedicalViewModel>();
    final patient = viewModel.patient;

    // 確保資料載入後填入控制器
    if (patient != null) {
      _updateControllers(patient);
    }

    if (patient == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左側欄
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('拍照或選取護照照片 PASSPORT/ID PHOTO'),
                  const SizedBox(height: 10),
                  _buildPhotoUploadSection(),
                  const SizedBox(height: 24),

                  _buildLabel('患者姓名 PATIENT NAME'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: '請輸入患者姓名',
                    onChanged: (val) => viewModel.updatePatientName(val),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('生日 DATE OF BIRTH'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _birthdayController,
                              hint: 'YYYY/MM/DD',
                              suffixIcon: Icons.calendar_today_outlined,
                              readOnly: true,
                              onTap: () => _selectDate(context, viewModel),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('年齡 AGE'),
                            const SizedBox(height: 8),
                            // 年齡自動計算並顯示
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: bgField,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                patient.age?.toString() ?? '0',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('性別 GENDER'),
                  const SizedBox(height: 8),
                  SlidingGenderToggle(
                    selectedIndex: patient.sexId ?? 0,
                    onChanged: (index) => viewModel.updateSexId(index),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 48),

            // 右側欄
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('護照/身份證字號 ID/PASSPORT NO.'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passportController,
                    hint: '請輸入證件號碼',
                    suffixIcon: Icons.check_circle_outline,
                    suffixColor: Colors.green,
                    onChanged: (val) => viewModel.updatePassport(val),
                  ),
                  const SizedBox(height: 24),

                  _buildLabel('國籍 NATIONALITY'),
                  const SizedBox(height: 8),
                  _buildNationalityDropdown(viewModel, patient),

                  const SizedBox(height: 24),
                  _buildLabel('聯絡電話 CONTACT PHONE'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _phoneController,
                    hint: '例如: +852 1234 5678',
                    onChanged: (val) => viewModel.updatePhone(val),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('地址 ADDRESS'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _addressController,
                    hint: '請輸入詳細居住地址',
                    maxLines: 4,
                    onChanged: (val) => viewModel.updateAddress(val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 日期選擇器
  Future<void> _selectDate(
    BuildContext context,
    MedicalViewModel viewModel,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      viewModel.updateBirthday(picked);
      _birthdayController.text = DateFormat('yyyy/MM/dd').format(picked);
    }
  }

  // 單一輸入框元件
  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    String? initialValue,
    IconData? suffixIcon,
    Color? suffixColor,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.5),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: suffixColor ?? textMuted, size: 20)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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

  // 國籍下拉選單
  Widget _buildNationalityDropdown(
    MedicalViewModel viewModel,
    PatientData patient,
  ) {
    // 從 ViewModel 取得當前選中的國籍
    final selectedNationality = viewModel.getNationalityById(
      patient.nationalityId,
    );

    return DropdownButtonFormField<NationalityData>(
      value: selectedNationality,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
      hint: Row(
        children: [
          const Icon(Icons.search, size: 18, color: textMuted),
          const SizedBox(width: 8),
          Text(
            '請選取國籍',
            style: TextStyle(
              color: textMuted.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
      icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: textMuted),
      items: viewModel.nationalityOptions.map((nationality) {
        return DropdownMenuItem<NationalityData>(
          value: nationality,
          child: Text(
            '${nationality.code ?? ''} ${nationality.name}',
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        );
      }).toList(),
      onChanged: (NationalityData? newValue) {
        if (newValue != null) {
          viewModel.updateNationalityId(newValue.nationalityId);
        }
      },
    );
  }

  // 照片上傳區塊
  Widget _buildPhotoUploadSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: bgField,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, color: textMuted, size: 28),
                Text(
                  'Preview',
                  style: TextStyle(color: textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _buildSmallButton(
                  Icons.camera_alt_outlined,
                  'Camera / 拍照',
                  true,
                ),
                const SizedBox(height: 8),
                _buildSmallButton(
                  Icons.folder_open_outlined,
                  'Gallery / 選取照片',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 小按鈕元件
  Widget _buildSmallButton(IconData icon, String label, bool isPrimary) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isPrimary ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isPrimary ? primaryColor : borderColor),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: isPrimary ? Colors.white : textDark),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : textDark,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 標籤元件
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// 性別切換元件
class SlidingGenderToggle extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const SlidingGenderToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> _options = const ['Male', 'Female', 'Other'];

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
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _getAlignment(selectedIndex),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
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
            children: List.generate(_options.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      _options[index],
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

  Alignment _getAlignment(int index) {
    if (index == 0) return Alignment.centerLeft;
    if (index == 1) return Alignment.center;
    return Alignment.centerRight;
  }
}
