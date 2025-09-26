// lib/pages/PersonalInformation.dart (已修正)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

// 移除 import 'nav2.dart'; 因為 PersonalInformationPage 不需要直接使用 Nav2Page

import '../data/db/daos.dart';
import '../data/db/app_database.dart';

// 移除 typedef CloseNav2Callback = void Function();

class PersonalInformationPage extends StatefulWidget {
  final int visitId; // 必須知道是哪一筆個案
  // 移除 final CloseNav2Callback? closeNav2;

  const PersonalInformationPage({
    super.key,
    required this.visitId,
    // 移除 this.closeNav2,
  });

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String? gender;
  String? reason;
  String? nationality;
  DateTime? birthday;
  int? age;

  final TextEditingController idController = TextEditingController();
  final TextEditingController addrController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
    final PatientProfile? profile = await dao.getByVisitId(widget.visitId);

    if (!mounted) return;

    if (profile != null) {
      setState(() {
        gender = profile.gender;
        reason = profile.reason;
        nationality = profile.nationality;
        birthday = profile.birthday;
        // 如果您在資料庫中存了 age，這裡可以讀取。如果只算，則保持 _calculateAge。
        age = profile.birthday != null
            ? _calculateAge(profile.birthday!)
            : null;

        idController.text = profile.idNumber ?? '';
        addrController.text = profile.address ?? '';
        phoneController.text = profile.phone ?? '';
      });
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthday ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthday = picked;
        age = _calculateAge(picked);
      });
    }
  }

  Future<void> _save() async {
    final dao = context.read<PatientProfilesDao>();

    await dao.upsertByVisitId(
      visitId: widget.visitId,
      birthday: birthday,
      gender: gender,
      reason: reason,
      nationality: nationality,
      idNumber: idController.text.trim().isEmpty
          ? null
          : idController.text.trim(),
      address: addrController.text.trim().isEmpty
          ? null
          : addrController.text.trim(),
      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      photoPath: null,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('個人資料已儲存')));

    // ★ 核心修改：移除 Callback，改為使用 Navigator.pop(context) 返回上一頁 (即 HomePage)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
              _SectionTitle('個人資料'),
              const SizedBox(height: 16),

              // 照片
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

              // 出生日期
              InkWell(
                onTap: _pickBirthday,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '生日',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    birthday == null
                        ? '尚未選擇'
                        : '${birthday!.year}-${birthday!.month}-${birthday!.day}',
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
                child: Text(age != null ? '$age 歲' : '尚未選擇生日'),
              ),
              const SizedBox(height: 16),

              // 性別
              _SectionTitle('性別'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('男'),
                      value: '男',
                      groupValue: gender,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => gender = v),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('女'),
                      value: '女',
                      groupValue: gender,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => gender = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 證號
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: '護照號或身份證字號',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 為何至機場？
              _SectionTitle('為何至機場？'),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('航空公司機組員'),
                    value: '航空公司機組員',
                    groupValue: reason,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => reason = v),
                  ),
                  RadioListTile<String>(
                    title: const Text('旅客/民眾'),
                    value: '旅客/民眾',
                    groupValue: reason,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => reason = v),
                  ),
                  RadioListTile<String>(
                    title: const Text('機場內部員工'),
                    value: '機場內部員工',
                    groupValue: reason,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => reason = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 國籍
              _SectionTitle('國籍'),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('台灣 (中華民國) TAIWAN'),
                    value: '台灣',
                    groupValue: nationality,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => nationality = v),
                  ),
                  RadioListTile<String>(
                    title: const Text('美國 UNITED STATES'),
                    value: '美國',
                    groupValue: nationality,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => nationality = v),
                  ),
                  RadioListTile<String>(
                    title: const Text('日本 JAPAN'),
                    value: '日本',
                    groupValue: nationality,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => nationality = v),
                  ),
                  RadioListTile<String>(
                    title: const Text('其他國籍'),
                    value: '其他',
                    groupValue: nationality,
                    activeColor: const Color(0xFF83ACA9),
                    onChanged: (v) => setState(() => nationality = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 地址
              TextField(
                controller: addrController,
                decoration: const InputDecoration(
                  labelText: '地址',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 聯絡電話
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '聯絡電話',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('儲存並返回首頁'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF83ACA9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
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
