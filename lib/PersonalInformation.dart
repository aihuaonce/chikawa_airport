import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/patient_data.dart';
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

  // 實現 saveData 方法 - 這個方法會被 Nav2Page 呼叫
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('選擇照片失敗: ${e.toString()}')));
      }
    }
  }

  Future<void> _save() async {
    try {
      final patientData = context.read<PatientData>();
      final dao = context.read<PatientProfilesDao>();

      // 確保控制器的資料同步到 PatientData
      patientData.idNumber = idController.text.trim();
      patientData.address = addrController.text.trim();
      patientData.phone = phoneController.text.trim();

      print('visitId: ${widget.visitId}');
      print('gender: ${patientData.gender}');
      print('nationality: ${patientData.nationality}');
      print('birthday: ${patientData.birthday}');
      print('reason: ${patientData.reason}');
      print('idNumber: ${patientData.idNumber}');
      print('address: ${patientData.address}');
      print('phone: ${patientData.phone}');
      print('hasPhoto: ${patientData.photoBase64 != null}');

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


      // 注意：這裡不要清空 patientData，讓 Nav2Page 統一處理
    } catch (e) {
      rethrow;
    }
  }

  // 當使用者離開這個頁面時自動儲存
  void _onTextFieldChanged() {
    // 延遲儲存，避免每次輸入都觸發
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
                    // ===== 個人資料 =====
                    _SectionTitle('個人資料'),
                    const SizedBox(height: 16),
                    // 照片
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
                    // 出生日期
                    InkWell(
                      onTap: _pickBirthday,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '生日',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                patientData.birthday == null
                                    ? '尚未選擇'
                                    : '${patientData.birthday!.year}-${patientData.birthday!.month.toString().padLeft(2, '0')}-${patientData.birthday!.day.toString().padLeft(2, '0')}',
                              ),
                            ),
                            const Icon(Icons.calendar_today, size: 20),
                          ],
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
                      child: Text(
                        patientData.age != null
                            ? '${patientData.age} 歲'
                            : '尚未選擇生日',
                      ),
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
                    // 證號
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: '護照號或身份證字號',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '請輸入護照號或身份證字號';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        patientData.idNumber = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    // 為何至機場？
                    _SectionTitle('為何至機場？'),
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
                    // 國籍
                    _SectionTitle('國籍'),
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
                          title: const Text('越南 VIETNAM'),
                          value: '越南',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('泰國 THAILAND'),
                          value: '泰國',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('印尼 INDONESIA'),
                          value: '印尼',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('菲律賓 PHILIPPINES'),
                          value: '菲律賓',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('香港 HONG KONG'),
                          value: '香港',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('澳門 MACAU'),
                          value: '澳門',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('加拿大 CANADA'),
                          value: '加拿大',
                          groupValue: patientData.nationality,
                          activeColor: const Color(0xFF83ACA9),
                          onChanged: (v) {
                            patientData.nationality = v;
                            patientData.update();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('中國大陸 CHINA'),
                          value: '中國大陸',
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
                    // 地址
                    TextFormField(
                      controller: addrController,
                      decoration: const InputDecoration(
                        labelText: '地址',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (val) {
                        patientData.address = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    // 聯絡電話
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: '聯絡電話',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '請輸入聯絡電話';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        patientData.phone = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 24),
                    // 手動儲存按鈕（可選）
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await saveData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('個人資料已儲存'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('儲存失敗: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('儲存個人資料'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF83ACA9),
                          foregroundColor: Colors.white,
                        ),
                      ),
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
