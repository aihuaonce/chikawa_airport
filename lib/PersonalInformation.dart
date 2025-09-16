import 'package:flutter/material.dart';
import 'nav2.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

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

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int years = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      selectedIndex: 0,
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
                TextField(
                  decoration: const InputDecoration(
                    labelText: '生日',
                    border: OutlineInputBorder(),
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
                      title: const Text('越南 VIETNAM'),
                      value: '越南',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('泰國 THAILAND'),
                      value: '泰國',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('印度 INDONESIA'),
                      value: '印度',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('菲律賓 PHILIPPINES'),
                      value: '菲律賓',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('香港 HONG KONG'),
                      value: '香港',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('澳門 MACAU'),
                      value: '澳門',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('加拿大 CANADA'),
                      value: '加拿大',
                      groupValue: nationality,
                      activeColor: const Color(0xFF83ACA9),
                      onChanged: (v) => setState(() => nationality = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('中國大陸 CHINA'),
                      value: '中國大陸',
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
                  decoration: const InputDecoration(
                    labelText: '地址',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 聯絡電話
                TextField(
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
