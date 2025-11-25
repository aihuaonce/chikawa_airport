// lib/PersonalInformationPage.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../data/db/daos.dart';
import '../data/models/patient_data.dart';
import '../l10n/app_translations.dart';
import 'nav2.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

class PersonalInformationPage extends StatefulWidget {
  final int visitId;

  const PersonalInformationPage({super.key, required this.visitId});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage>
    with AutomaticKeepAliveClientMixin, SavableStateMixin {
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController passportController;
  late TextEditingController addrController;
  late TextEditingController phoneController;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    idController = TextEditingController();
    passportController = TextEditingController();
    addrController = TextEditingController();
    phoneController = TextEditingController();
    _loadPatientProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    passportController.dispose();
    addrController.dispose();
    phoneController.dispose();
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

      final visitDao = context.read<VisitsDao>();
      final visit = await visitDao.getById(widget.visitId);

      if (!mounted) return;

      final patientData = context.read<PatientData>();
      if (profile != null) {
        patientData.gender = profile.gender;
        patientData.reason = profile.reason;
        patientData.nationality = profile.nationality;
        patientData.birthday = profile.birthday;
        patientData.age = profile.age;
        patientData.idNumber = profile.idNumber;
        patientData.passportNumber = profile.passportNumber;
        patientData.address = profile.address;
        patientData.phone = profile.phone;
        patientData.photoBase64 = profile.photoPath;
        patientData.update();

        idController.text = patientData.idNumber ?? '';
        passportController.text = patientData.passportNumber ?? '';
        addrController.text = patientData.address ?? '';
        phoneController.text = patientData.phone ?? '';
      }

      if (visit != null && visit.patientName != null) {
        nameController.text = visit.patientName!;
        patientData.patientName = visit.patientName;
        patientData.update();
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

  Future<void> _pickPhoto() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);

    try {
      final patientData = context.read<PatientData>();
      final ImagePicker picker = ImagePicker();

      // 顯示選項對話框：從相簿選擇 或 拍照
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('選擇照片來源'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('從相簿選擇'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('拍照'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );
      if (source == null) return;

      // --- 取得圖片 ---
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      final uuid = Uuid();
      final filename = '${uuid.v4()}.jpg';

      // --- 暫存到本地 ---
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$filename');
      await tempFile.writeAsBytes(bytes);

      // --- 建立 Multipart 上傳 ---
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://noncatastrophic-marketwise-jame.ngrok-free.dev/todos/upload/'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          tempFile.path,
          filename: filename,
        ),
      );

      // --- 發送請求 ---
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);

        // --- MRZ 自動填入 ---
        if (data['mrz_result'] != null && data['mrz_result'] is List) {
          final mrz = data['mrz_result'];

          setState(() {
            nameController.text = mrz[1].replaceAll('<', ''); // 姓名
            idController.text = mrz[5].replaceAll('<', ''); // 證號
            passportController.text = mrz[0].replaceAll('<', ''); // 護照
            patientData.gender = (mrz[4].toUpperCase() == 'M') ? '男' : '女';

            // 國籍對照字典（示例，可自行擴充）
            const mrzToNationality = {
              "TWN": "台灣",
              "USA": "美國",
              "VNM": "越南",
              "THA": "泰國",
              "IDN": "印尼",
              "PHL": "菲律賓",
              "HKG": "香港",
              "MAC": "澳門",
              "CAN": "加拿大",
              "CHN": "中國大陸",
              "JPN": "日本",
            };
            patientData.nationality =
                mrzToNationality[mrz[2].toUpperCase()] ?? '其他';

            // 生日 & 年齡
            final birthDate = _parseDate(mrz[3]);
            if (birthDate != null) {
              patientData.birthday = birthDate;
              patientData.age = _calculateAge(birthDate);
            }

            patientData.update();
          });
        }

        // --- 更新照片顯示 ---
        setState(() {
          patientData.photoBase64 = base64Encode(bytes);
          patientData.update();
        });
      } else {
        print('❌ 上傳失敗: ${response.statusCode}');
        print('伺服器錯誤回應: $responseBody');
      }
    } catch (e, stack) {
      print('⚠️ Flutter 端錯誤: $e');
      print('🔍 錯誤堆疊: $stack');
    }
  }

  /// MRZ 日期 (YYMMDD) 轉 DateTime
  DateTime? _parseDate(String dateStr) {
    try {
      if (dateStr.length != 6) return null;
      final year = int.parse(dateStr.substring(0, 2));
      final month = int.parse(dateStr.substring(2, 4));
      final day = int.parse(dateStr.substring(4, 6));
      final fullYear = (year < 25 ? 2000 + year : 1900 + year);
      return DateTime(fullYear, month, day);
    } catch (_) {
      return null;
    }
  }

  /// 計算年齡
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _save() async {
    try {
      final patientData = context.read<PatientData>();
      final patientDao = context.read<PatientProfilesDao>();
      final visitsDao = context.read<VisitsDao>();

      // 步驟 1：在儲存前，確保將 Controller 的最新內容同步到 patientData
      patientData.patientName = nameController.text.trim();
      patientData.idNumber = idController.text.trim();
      patientData.address = addrController.text.trim();
      patientData.phone = phoneController.text.trim();

      await patientData.saveToDatabase(widget.visitId, patientDao, visitsDao);
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
        patientData.patientName = nameController.text.trim();
        patientData.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    final t = AppTranslations.of(context);

    // ✅ 改為文字對應（key 是資料庫值，value 是顯示文字）
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
                    _SectionTitle(t.personalInformation),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: t.patientNamePlaceholder,
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: nameController.text.isEmpty
                              ? const Color(0xFFDC3545)
                              : Colors.black54,
                          fontWeight: nameController.text.isEmpty
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.patientNamePlaceholder;
                        }
                        return null;
                      },
                      onChanged: (val) {
                        patientData.patientName = val.trim();
                        _onTextFieldChanged();
                        setState(() {});
                      },
                    ),
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
                          labelText: t.birthday,
                          border: const OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                patientData.birthday == null
                                    ? t.notSelected
                                    : t.formatDate(patientData.birthday!),
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
                        labelText: t.age,
                        border: const OutlineInputBorder(),
                      ),
                      child: Text(
                        patientData.age != null
                            ? t.ageWithUnit(patientData.age!)
                            : t.birthdayNotSelected,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(t.gender),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(t.male),
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
                            title: Text(t.female),
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
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: t.Id,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.enterId;
                        }
                        return null;
                      },
                      onChanged: (val) {
                        patientData.idNumber = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passportController,
                      decoration: InputDecoration(
                        labelText: t.passportId,
                        hintText: t.enterPassportId,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        patientData.passportNumber = val.trim();
                        _onTextFieldChanged();
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(t.purposeOfVisit),
                    Column(
                      children: purposeOptions.entries.map((entry) {
                        return RadioListTile<String>(
                          title: Text(entry.value),
                          value: entry.key, // ✅ 直接存中文
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
                    _SectionTitle(t.nationality),
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
                        labelText: t.address,
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
                        labelText: t.contactNumber,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.enterContactNumber;
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
