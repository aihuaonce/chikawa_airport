import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../data/models/patient_data.dart';
import '../data/db/daos.dart';
import '../nav2.dart';

class PersonalInformationPage extends StatefulWidget implements SavablePage {
  final int visitId;

  const PersonalInformationPage({super.key, required this.visitId});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();

  @override
  Future<void> saveData() async {
    final state = _PersonalInformationPageState.pageKey.currentState;
    if (state != null) await state._save();
  }

  static final GlobalKey<_PersonalInformationPageState> pageKey =
      GlobalKey<_PersonalInformationPageState>();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  late TextEditingController idController;
  late TextEditingController addrController;
  late TextEditingController phoneController;
  late TextEditingController reasonController;
  late TextEditingController nationalityController;
  late TextEditingController noteController;
  File? _photo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    addrController = TextEditingController();
    phoneController = TextEditingController();
    reasonController = TextEditingController();
    nationalityController = TextEditingController();
    noteController = TextEditingController();
    _loadPatientProfile();
  }

  @override
  void dispose() {
    idController.dispose();
    addrController.dispose();
    phoneController.dispose();
    reasonController.dispose();
    nationalityController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientProfile() async {
    final dao = context.read<PatientProfilesDao>();
    final profile = await dao.getByVisitId(widget.visitId);

    if (!mounted) return;
    final patientData = context.read<PatientData>();

    if (profile != null) {
      patientData.gender = profile.gender;
      patientData.reason = profile.reason;
      patientData.nationality = profile.nationality;
      patientData.birthday = profile.birthday;
      patientData.age = profile.birthday != null
          ? _calculateAge(profile.birthday!)
          : null;
      patientData.idNumber = profile.idNumber;
      patientData.address = profile.address;
      patientData.phone = profile.phone;
      patientData.photoPath = profile.photoPath;
      patientData.note = profile.note;
      patientData.update();

      idController.text = patientData.idNumber ?? '';
      addrController.text = patientData.address ?? '';
      phoneController.text = patientData.phone ?? '';
      reasonController.text = patientData.reason ?? '';
      nationalityController.text = patientData.nationality ?? '';
      noteController.text = patientData.note ?? '';
      if (patientData.photoPath != null) _photo = File(patientData.photoPath!);
    }

    setState(() {
      _isLoading = false;
    });
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

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photo = File(picked.path);
      });
      final patientData = context.read<PatientData>();
      patientData.photoPath = picked.path;
      patientData.update();
    }
  }

  Future<void> _save() async {
    final patientData = context.read<PatientData>();
    final dao = context.read<PatientProfilesDao>();

    await dao.upsertByVisitId(
      visitId: widget.visitId,
      birthday: patientData.birthday,
      gender: patientData.gender,
      reason: patientData.reason,
      nationality: patientData.nationality,
      idNumber: patientData.idNumber,
      address: patientData.address,
      phone: patientData.phone,
      photoPath: patientData.photoPath,
    );

    // 回寫備註到 Visits 主檔
    final visitsDao = context.read<VisitsDao>();
    await visitsDao.updateVisitSummary(widget.visitId, note: patientData.note);
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Consumer<PatientData>(
      builder: (context, patientData, _) {
        return SingleChildScrollView(
          child: Container(
            width: 900,
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '個人資料',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                // 生日
                InkWell(
                  onTap: _pickBirthday,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '生日',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      patientData.birthday == null
                          ? '尚未選擇'
                          : '${patientData.birthday!.year}-${patientData.birthday!.month}-${patientData.birthday!.day}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 年齡
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '年齡',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(patientData.age?.toString() ?? ''),
                ),
                _buildTextField(
                  label: '性別',
                  controller: TextEditingController(text: patientData.gender),
                  onChanged: (v) {
                    patientData.gender = v;
                    patientData.update();
                  },
                ),
                _buildTextField(
                  label: '就醫原因',
                  controller: reasonController,
                  onChanged: (v) {
                    patientData.reason = v;
                    patientData.update();
                  },
                ),
                _buildTextField(
                  label: '國籍',
                  controller: nationalityController,
                  onChanged: (v) {
                    patientData.nationality = v;
                    patientData.update();
                  },
                ),
                _buildTextField(
                  label: '身分證號',
                  controller: idController,
                  onChanged: (v) {
                    patientData.idNumber = v;
                    patientData.update();
                  },
                ),
                _buildTextField(
                  label: '地址',
                  controller: addrController,
                  onChanged: (v) {
                    patientData.address = v;
                    patientData.update();
                  },
                ),
                _buildTextField(
                  label: '電話',
                  controller: phoneController,
                  onChanged: (v) {
                    patientData.phone = v;
                    patientData.update();
                  },
                ),
                const SizedBox(height: 16),
                // 備註
                _buildTextField(
                  label: '備註',
                  controller: noteController,
                  onChanged: (v) {
                    patientData.note = v;
                    patientData.update();
                  },
                ),
                const SizedBox(height: 16),
                // 照片上傳
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickPhoto,
                      child: const Text('上傳照片'),
                    ),
                    const SizedBox(width: 16),
                    _photo != null
                        ? Image.file(
                            _photo!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : const Text('尚未上傳照片'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
