// lib/PersonalInformationPage.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/patient_data.dart';
import '../l10n/app_translations.dart'; // 【新增】引入翻譯
import 'nav2.dart';

class PersonalInformationPage extends StatefulWidget {
  final int visitId;

  const PersonalInformationPage({super.key, required this.visitId});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  late TextEditingController idController;
  late TextEditingController addrController;
  late TextEditingController phoneController;
  late TextEditingController reasonController;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    addrController = TextEditingController();
    phoneController = TextEditingController();
    reasonController = TextEditingController();
    _loadPatientProfile();
  }

  @override
  void dispose() {
    idController.dispose();
    addrController.dispose();
    phoneController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Future<void> saveData() async {
    _formKey.currentState?.validate();
    try {
      await _save();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadPatientProfile() async {
    try {
      final dao = context.read<PatientProfilesDao>();
      final profile = await dao.getByVisitId(widget.visitId);

      if (!mounted) return;

      final patientData = context.read<PatientData>();
      if (profile != null) {
        patientData.gender = profile.gender;
        patientData.reason = profile.reason;
        patientData.nationality = profile.nationality;
        patientData.birthday = profile.birthday;
        patientData.age = profile.age;
        patientData.idNumber = profile.idNumber;
        patientData.address = profile.address;
        patientData.phone = profile.phone;
        patientData.photoBase64 = profile.photoPath;
        patientData.update();

        idController.text = patientData.idNumber ?? '';
        addrController.text = patientData.address ?? '';
        phoneController.text = patientData.phone ?? '';
        reasonController.text = patientData.reason ?? '';
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _pickBirthday() async {
    final patientData = context.read<PatientData>();
    final picked = await showDatePicker(
      context: context,
      initialDate: patientData.birthday ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      patientData.birthday = picked;
      patientData.age = _calculateAge(picked);
      patientData.update();
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int years = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  Future<void> _pickPhoto() async {
    if (!mounted) return;
    final t = AppTranslations.of(context); // 【新增】
    try {
      final patientData = context.read<PatientData>();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        List<int> bytes = await file.readAsBytes();
        String base64Image = base64Encode(bytes);

        setState(() {
          patientData.photoBase64 = base64Image;
        });
        patientData.update();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.photoSelectionFailed}$e')),
        ); // 【修改】
      }
    }
  }

  Future<void> _save() async {
    try {
      final patientData = context.read<PatientData>();
      final dao = context.read<PatientProfilesDao>();

      patientData.idNumber = idController.text.trim();
      patientData.address = addrController.text.trim();
      patientData.phone = phoneController.text.trim();

      await dao.upsertByVisitId(
        visitId: widget.visitId,
        birthday: patientData.birthday,
        gender: patientData.gender,
        reason: patientData.reason,
        nationality: patientData.nationality,
        idNumber: patientData.idNumber,
        address: patientData.address,
        phone: patientData.phone,
        photoPath: patientData.photoBase64,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _onTextFieldChanged() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final patientData = context.read<PatientData>();
        patientData.idNumber = idController.text.trim();
        patientData.address = addrController.text.trim();
        patientData.phone = phoneController.text.trim();
        patientData.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    final t = AppTranslations.of(context); // 【新增】

    // 【新增】動態建立選項列表
    final purposeOptions = {
      '航空公司機組員': t.airlineCrew,
      '旅客/民眾': t.passenger,
      '機場內部員工': t.airportStaff,
    };

    final nationalityOptions = {
      '台灣': t.taiwanNationality,
      '美國': t.nationalityUSA,
      '越南': t.nationalityVietnam,
      '泰國': t.nationalityThailand,
      '印尼': t.nationalityIndonesia,
      '菲律賓': t.nationalityPhilippines,
      '香港': t.nationalityHongKong,
      '澳門': t.nationalityMacau,
      '加拿大': t.nationalityCanada,
      '中國大陸': t.nationalityChina,
      '日本': t.nationalityJapan,
      '其他': t.nationalityOther,
    };

    return Consumer<PatientData>(
      builder: (context, patientData, _) {
        return Form(
          key: _formKey,
          child: Container(
            color: const Color(0xFFE6F6FB),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                width: 900,
                margin: const EdgeInsets.symmetric(vertical: 32),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(t.personalInformation), // 【修改】
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                        ),
                        child: patientData.photoBase64 != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(patientData.photoBase64!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: _pickBirthday,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: t.birthday, // 【修改】
                          border: const OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                patientData.birthday == null
                                    ? t
                                          .notSelected // 【修改】
                                    : t.formatDate(
                                        patientData.birthday!,
                                      ), // 【修改】使用新方法
                              ),
                            ),
                            const Icon(Icons.calendar_today, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: t.age, // 【修改】
                        border: const OutlineInputBorder(),
                      ),
                      child: Text(
                        patientData.age != null
                            ? t.ageWithUnit(patientData.age!) // 【修改】使用新方法
                            : t.birthdayNotSelected, // 【修改】
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(t.gender), // 【修改】
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(t.male), // 【修改】
                            value: '男', // DB value
                            groupValue: patientData.gender,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) {
                              patientData.gender = v;
                              patientData.update();
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(t.female), // 【修改】
                            value: '女', // DB value
                            groupValue: patientData.gender,
                            activeColor: const Color(0xFF83ACA9),
                            onChanged: (v) {
                              patientData.gender = v;
                              patientData.update();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: t.passportOrId, // 【修改】
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.enterPassportOrId; // 【修改】
                        }
                        return null;
                      },
                      onChanged: (val) {
                        patientData.idNumber = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(t.purposeOfVisit), // 【修改】
                    Column(
                      children: purposeOptions.entries.map((entry) {
                        return RadioListTile<String>(
                          title: Text(entry.value),
                          value: entry.key,
                          groupValue: patientData.reason,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.reason = v;
                            patientData.update();
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(t.nationality), // 【修改】
                    Column(
                      children: nationalityOptions.entries.map((entry) {
                        return RadioListTile<String>(
                          title: Text(entry.value),
                          value: entry.key,
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addrController,
                      decoration: InputDecoration(
                        labelText: t.address, // 【修改】
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (val) {
                        patientData.address = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: t.contactNumber, // 【修改】
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.enterContactNumber; // 【修改】
                        }
                        return null;
                      },
                      onChanged: (val) {
                        patientData.phone = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
