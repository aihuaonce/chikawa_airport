// lib/pages/PersonalInformation.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import 'nav2.dart';

class PatientData extends ChangeNotifier {
  String? gender;
  String? reason;
  String? nationality;
  DateTime? birthday;
  int? age;
  String? idNumber;
  String? address;
  String? phone;

  void update() => notifyListeners();

  void clear() {
    gender = null;
    reason = null;
    nationality = null;
    birthday = null;
    age = null;
    idNumber = null;
    address = null;
    phone = null;
    notifyListeners();
  }
}

class PersonalInformationPage extends StatefulWidget implements SavablePage {
  final int visitId;

  const PersonalInformationPage({super.key, required this.visitId});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();

  // 使用 GlobalKey 來存取 state
  static final GlobalKey<_PersonalInformationPageState> pageKey =
      GlobalKey<_PersonalInformationPageState>();

  @override
  Future<void> saveData() async {
    final state = pageKey.currentState;
    if (state != null) await state._save();
  }
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  late TextEditingController idController;
  late TextEditingController addrController;
  late TextEditingController phoneController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    addrController = TextEditingController();
    phoneController = TextEditingController();
    _loadPatientProfile();
  }

  @override
  void dispose() {
    idController.dispose();
    addrController.dispose();
    phoneController.dispose();
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
      patientData.update();

      idController.text = patientData.idNumber ?? '';
      addrController.text = patientData.address ?? '';
      phoneController.text = patientData.phone ?? '';
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

  // 供 Nav2 按鈕呼叫的儲存方法
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
      photoPath: null,
    );

    if (!mounted) return;
    patientData.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Consumer<PatientData>(
      builder: (context, patientData, _) {
        idController.text = patientData.idNumber ?? '';
        addrController.text = patientData.address ?? '';
        phoneController.text = patientData.phone ?? '';

        return Container(
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
                  const Text(
                    '個人資料',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '年齡',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      patientData.age != null
                          ? '${patientData.age} 歲'
                          : '尚未選擇生日',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SectionTitle('性別'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('男'),
                          value: '男',
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
                          title: const Text('女'),
                          value: '女',
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
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: '護照號或身份證字號',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => patientData.idNumber = v,
                  ),
                  const SizedBox(height: 16),
                  const _SectionTitle('為何至機場？'),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('航空公司機組員'),
                        value: '航空公司機組員',
                        groupValue: patientData.reason,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.reason = v;
                          patientData.update();
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('旅客/民眾'),
                        value: '旅客/民眾',
                        groupValue: patientData.reason,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.reason = v;
                          patientData.update();
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('機場內部員工'),
                        value: '機場內部員工',
                        groupValue: patientData.reason,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.reason = v;
                          patientData.update();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _SectionTitle('國籍'),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('台灣 (中華民國) TAIWAN'),
                        value: '台灣',
                        groupValue: patientData.nationality,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.nationality = v;
                          patientData.update();
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('美國 UNITED STATES'),
                        value: '美國',
                        groupValue: patientData.nationality,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.nationality = v;
                          patientData.update();
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('日本 JAPAN'),
                        value: '日本',
                        groupValue: patientData.nationality,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.nationality = v;
                          patientData.update();
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('其他國籍'),
                        value: '其他',
                        groupValue: patientData.nationality,
                        activeColor: const Color(0xFF83ACA9),
                        onChanged: (v) {
                          patientData.nationality = v;
                          patientData.update();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addrController,
                    decoration: const InputDecoration(
                      labelText: '地址',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => patientData.address = v,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: '聯絡電話',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => patientData.phone = v,
                  ),
                  const SizedBox(height: 24),
                ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
