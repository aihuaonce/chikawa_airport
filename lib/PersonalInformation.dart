import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value; // for Drift Value()

import 'nav2.dart';
import '../data/db/daos.dart';
import '../data/db/app_database.dart';

class PersonalInformationPage extends StatefulWidget {
  final int visitId; // ★ 新增：必須知道是哪一筆個案

  const PersonalInformationPage({super.key, required this.visitId});

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

  // === TextEditingController (必須綁定 TextField 才能取值) ===
  final TextEditingController idController = TextEditingController();
  final TextEditingController addrController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //載入現有的個人資料
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
        // 設定 State 變數
        gender = profile.gender;
        reason = profile.reason;
        nationality = profile.nationality;
        birthday = profile.birthday;
        age = profile.birthday != null
            ? _calculateAge(profile.birthday!)
            : null;
        // 設定 TextEditingController
        idController.text = profile.idNumber ?? '';
        addrController.text = profile.address ?? '';
        phoneController.text = profile.phone ?? '';
      });
    }

    setState(() {
      _isLoading = false; // 載入完成
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
      initialDate: DateTime(1990, 1, 1),
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

    // 1. 儲存/更新 PatientProfile 詳細資料 (DAO 處理回寫 Visits 摘要)
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

    // 2. 顯示成功訊息
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('個人資料已儲存')));

    // 3. ★ 關鍵修正：直接跳轉到 Home Page，並移除所有舊的路由
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false, // 移除所有前面的頁面
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Nav2Page(
        selectedIndex: 0,
        visitId: widget.visitId,
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
                  // ===== 個人資料 =====
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
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: const Icon(Icons.save),
      ),
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
