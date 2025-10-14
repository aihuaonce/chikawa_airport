//referralform.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../data/db/daos.dart';
import '../data/models/referral_data.dart';
import 'nav2.dart';
import '../l10n/app_translations.dart';


class ReferralFormPage extends StatefulWidget {
  final int visitId;

  const ReferralFormPage({super.key, required this.visitId});

  @override
  State<ReferralFormPage> createState() => _ReferralFormPageState();
}

class _ReferralFormPageState extends State<ReferralFormPage>
    with
        AutomaticKeepAliveClientMixin<ReferralFormPage>,
        SavableStateMixin<ReferralFormPage> {
  // ===============================================
  // 實作 SavablePage 的 saveData() 方法
  // ===============================================
  @override
  Future<void> saveData() async {
    try {
      _syncControllersToData();
      await _saveData();
    } catch (e) {
      rethrow;
    }
  }

  // ===============================================
  // 保持頁面存活
  // ===============================================
  @override
  bool get wantKeepAlive => true;

  // ===============================================
  // 狀態變數
  // ===============================================
  bool _isLoading = true;

  // 選項列表
  final List<String> doctorList = const [
    "方詩旋",
    "古璿正",
    "江旺財",
    "呂學政",
    "周志勇",
    "金霈歌",
    "徐丕",
    "康曉妤",
    "其他",
  ];

  final List<String> deptList = const [
    "急診醫學科",
    "不分科",
    "家醫科",
    "內科",
    "外科",
    "小兒科",
    "婦產科",
    "骨科",
    "眼科",
    "其他",
  ];

  final List<String> referralPurposes = const [
    "急診治療",
    "住院治療",
    "門診治療",
    "進一步檢查",
    "轉回轉出或適當之院所繼續追蹤",
    "其他",
  ];

  // 簽名控制器
  final SignatureController _doctorSignController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _consentSignController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // 文字欄位控制器
  final TextEditingController contactNameCtrl = TextEditingController();
  final TextEditingController contactPhoneCtrl = TextEditingController();
  final TextEditingController contactAddressCtrl = TextEditingController();
  final TextEditingController mainDiagnosisCtrl = TextEditingController();
  final TextEditingController subDiagnosis1Ctrl = TextEditingController();
  final TextEditingController subDiagnosis2Ctrl = TextEditingController();
  final TextEditingController furtherExamCtrl = TextEditingController();
  final TextEditingController otherPurposeCtrl = TextEditingController();
  final TextEditingController otherDoctorCtrl = TextEditingController();
  final TextEditingController otherDeptCtrl = TextEditingController();
  final TextEditingController appointmentDeptCtrl = TextEditingController();
  final TextEditingController appointmentRoomCtrl = TextEditingController();
  final TextEditingController appointmentNumberCtrl = TextEditingController();
  final TextEditingController referralHospitalCtrl = TextEditingController();
  final TextEditingController otherReferralDeptCtrl = TextEditingController();
  final TextEditingController referralDoctorCtrl = TextEditingController();
  final TextEditingController referralAddressCtrl = TextEditingController();
  final TextEditingController referralPhoneCtrl = TextEditingController();
  final TextEditingController relationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    contactNameCtrl.dispose();
    contactPhoneCtrl.dispose();
    contactAddressCtrl.dispose();
    mainDiagnosisCtrl.dispose();
    subDiagnosis1Ctrl.dispose();
    subDiagnosis2Ctrl.dispose();
    furtherExamCtrl.dispose();
    otherPurposeCtrl.dispose();
    otherDoctorCtrl.dispose();
    otherDeptCtrl.dispose();
    appointmentDeptCtrl.dispose();
    appointmentRoomCtrl.dispose();
    appointmentNumberCtrl.dispose();
    referralHospitalCtrl.dispose();
    otherReferralDeptCtrl.dispose();
    referralDoctorCtrl.dispose();
    referralAddressCtrl.dispose();
    referralPhoneCtrl.dispose();
    relationCtrl.dispose();
    _doctorSignController.dispose();
    _consentSignController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final dao = context.read<ReferralFormsDao>();
      final referralData = context.read<ReferralData>();
      final record = await dao.getByVisitId(widget.visitId);

      if (!mounted) return;

      if (record != null) {
        // 從資料庫載入到 ReferralData
        referralData.contactName = record.contactName;
        referralData.contactPhone = record.contactPhone;
        referralData.contactAddress = record.contactAddress;
        referralData.mainDiagnosis = record.mainDiagnosis;
        referralData.subDiagnosis1 = record.subDiagnosis1;
        referralData.subDiagnosis2 = record.subDiagnosis2;
        referralData.lastExamDate = record.lastExamDate;
        referralData.lastMedicationDate = record.lastMedicationDate;
        referralData.referralPurposeIdx = record.referralPurposeIdx;
        referralData.furtherExamDetail = record.furtherExamDetail;
        referralData.otherPurposeDetail = record.otherPurposeDetail;
        referralData.doctorIdx = record.doctorIdx;
        referralData.otherDoctorName = record.otherDoctorName;
        referralData.deptIdx = record.deptIdx;
        referralData.otherDeptName = record.otherDeptName;
        referralData.doctorSignature = record.doctorSignature;
        referralData.issueDate = record.issueDate;
        referralData.appointmentDate = record.appointmentDate;
        referralData.appointmentDept = record.appointmentDept;
        referralData.appointmentRoom = record.appointmentRoom;
        referralData.appointmentNumber = record.appointmentNumber;
        referralData.referralHospitalName = record.referralHospitalName;
        referralData.referralDeptIdx = record.referralDeptIdx;
        referralData.otherReferralDept = record.otherReferralDept;
        referralData.referralDoctorName = record.referralDoctorName;
        referralData.referralAddress = record.referralAddress;
        referralData.referralPhone = record.referralPhone;
        referralData.consentSignature = record.consentSignature;
        referralData.relationToPatient = record.relationToPatient;
        referralData.consentDateTime = record.consentDateTime;
        referralData.update();
      } else {
        // 新記錄的預設值
        final now = DateTime.now();
        referralData.issueDate = now;
        referralData.appointmentDate = now;
        referralData.lastExamDate = now;
        referralData.lastMedicationDate = now;
        referralData.consentDateTime = now;
        referralData.update();
      }

      _syncControllersFromData(referralData);
    } catch (e) {
      debugPrint('載入轉診表單資料錯誤: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _syncControllersFromData(ReferralData data) {
    contactNameCtrl.text = data.contactName ?? '';
    contactPhoneCtrl.text = data.contactPhone ?? '';
    contactAddressCtrl.text = data.contactAddress ?? '';
    mainDiagnosisCtrl.text = data.mainDiagnosis ?? '';
    subDiagnosis1Ctrl.text = data.subDiagnosis1 ?? '';
    subDiagnosis2Ctrl.text = data.subDiagnosis2 ?? '';
    furtherExamCtrl.text = data.furtherExamDetail ?? '';
    otherPurposeCtrl.text = data.otherPurposeDetail ?? '';
    otherDoctorCtrl.text = data.otherDoctorName ?? '';
    otherDeptCtrl.text = data.otherDeptName ?? '';
    appointmentDeptCtrl.text = data.appointmentDept ?? '';
    appointmentRoomCtrl.text = data.appointmentRoom ?? '';
    appointmentNumberCtrl.text = data.appointmentNumber ?? '';
    referralHospitalCtrl.text = data.referralHospitalName ?? '';
    otherReferralDeptCtrl.text = data.otherReferralDept ?? '';
    referralDoctorCtrl.text = data.referralDoctorName ?? '';
    referralAddressCtrl.text = data.referralAddress ?? '';
    referralPhoneCtrl.text = data.referralPhone ?? '';
    relationCtrl.text = data.relationToPatient ?? '';
  }

  void _syncControllersToData() {
    final data = context.read<ReferralData>();

    data.contactName = contactNameCtrl.text.trim().isEmpty
        ? null
        : contactNameCtrl.text.trim();
    data.contactPhone = contactPhoneCtrl.text.trim().isEmpty
        ? null
        : contactPhoneCtrl.text.trim();
    data.contactAddress = contactAddressCtrl.text.trim().isEmpty
        ? null
        : contactAddressCtrl.text.trim();
    data.mainDiagnosis = mainDiagnosisCtrl.text.trim().isEmpty
        ? null
        : mainDiagnosisCtrl.text.trim();
    data.subDiagnosis1 = subDiagnosis1Ctrl.text.trim().isEmpty
        ? null
        : subDiagnosis1Ctrl.text.trim();
    data.subDiagnosis2 = subDiagnosis2Ctrl.text.trim().isEmpty
        ? null
        : subDiagnosis2Ctrl.text.trim();
    data.furtherExamDetail = furtherExamCtrl.text.trim().isEmpty
        ? null
        : furtherExamCtrl.text.trim();
    data.otherPurposeDetail = otherPurposeCtrl.text.trim().isEmpty
        ? null
        : otherPurposeCtrl.text.trim();
    data.otherDoctorName = otherDoctorCtrl.text.trim().isEmpty
        ? null
        : otherDoctorCtrl.text.trim();
    data.otherDeptName = otherDeptCtrl.text.trim().isEmpty
        ? null
        : otherDeptCtrl.text.trim();
    data.appointmentDept = appointmentDeptCtrl.text.trim().isEmpty
        ? null
        : appointmentDeptCtrl.text.trim();
    data.appointmentRoom = appointmentRoomCtrl.text.trim().isEmpty
        ? null
        : appointmentRoomCtrl.text.trim();
    data.appointmentNumber = appointmentNumberCtrl.text.trim().isEmpty
        ? null
        : appointmentNumberCtrl.text.trim();
    data.referralHospitalName = referralHospitalCtrl.text.trim().isEmpty
        ? null
        : referralHospitalCtrl.text.trim();
    data.otherReferralDept = otherReferralDeptCtrl.text.trim().isEmpty
        ? null
        : otherReferralDeptCtrl.text.trim();
    data.referralDoctorName = referralDoctorCtrl.text.trim().isEmpty
        ? null
        : referralDoctorCtrl.text.trim();
    data.referralAddress = referralAddressCtrl.text.trim().isEmpty
        ? null
        : referralAddressCtrl.text.trim();
    data.referralPhone = referralPhoneCtrl.text.trim().isEmpty
        ? null
        : referralPhoneCtrl.text.trim();
    data.relationToPatient = relationCtrl.text.trim().isEmpty
        ? null
        : relationCtrl.text.trim();
  }

  Future<void> _saveData() async {
    try {
      final dao = context.read<ReferralFormsDao>();
      final data = context.read<ReferralData>();

      await dao.upsertByVisitId(
        visitId: widget.visitId,
        contactName: data.contactName,
        contactPhone: data.contactPhone,
        contactAddress: data.contactAddress,
        mainDiagnosis: data.mainDiagnosis,
        subDiagnosis1: data.subDiagnosis1,
        subDiagnosis2: data.subDiagnosis2,
        lastExamDate: data.lastExamDate,
        lastMedicationDate: data.lastMedicationDate,
        referralPurposeIdx: data.referralPurposeIdx,
        furtherExamDetail: data.furtherExamDetail,
        otherPurposeDetail: data.otherPurposeDetail,
        doctorIdx: data.doctorIdx,
        otherDoctorName: data.otherDoctorName,
        deptIdx: data.deptIdx,
        otherDeptName: data.otherDeptName,
        doctorSignature: data.doctorSignature,
        issueDate: data.issueDate,
        appointmentDate: data.appointmentDate,
        appointmentDept: data.appointmentDept,
        appointmentRoom: data.appointmentRoom,
        appointmentNumber: data.appointmentNumber,
        referralHospitalName: data.referralHospitalName,
        referralDeptIdx: data.referralDeptIdx,
        otherReferralDept: data.otherReferralDept,
        referralDoctorName: data.referralDoctorName,
        referralAddress: data.referralAddress,
        referralPhone: data.referralPhone,
        consentSignature: data.consentSignature,
        relationToPatient: data.relationToPatient,
        consentDateTime: data.consentDateTime,
      );

      debugPrint('轉診表單儲存成功');
    } catch (e) {
      debugPrint('儲存轉診表單錯誤: $e');
      rethrow;
    }
  }

  void _openSignaturePad(
    SignatureController controller,
    Function(Uint8List) onSaved,
  ) {
    final t = AppTranslations.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Expanded(
                child: Signature(
                  controller: controller,
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: controller.clear,
                    child: Text(t.redraw),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (controller.isNotEmpty) {
                        final data = await controller.toPngBytes();
                        if (data != null) {
                          onSaved(data);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(t.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Consumer<ReferralData>(
      builder: (context, data, _) {
        return Container(
          color: const Color(0xFFE6F6FB),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 950,
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 第一部分 - 聯絡人資料
                  Text(
                    t.isZh ? "聯絡人資料" : "Contact Information",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow(t, "${t.name}：", t.isZh ? "請填寫聯絡人姓名" : "Enter contact name", contactNameCtrl),
                  const SizedBox(height: 8),
                  _buildInputRow(t, "${t.phone}：", t.isZh ? "請填寫聯絡人電話" : "Enter contact phone", contactPhoneCtrl),
                  const SizedBox(height: 8),
                  _buildInputRow(t, "${t.address}：", t.isZh ? "請填寫聯絡人地址" : "Enter contact address", contactAddressCtrl),

                  const Divider(thickness: 1, height: 32),

                  // 第二部分 - 診斷
                  Text(
                    t.isZh ? "診斷ICD-10-CM/PCS病名" : "Diagnosis ICD-10-CM/PCS",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow(t, "${t.mainDiagnosis}：", t.isZh ? "請輸入..." : "Please enter...", mainDiagnosisCtrl),
                  const SizedBox(height: 8),
                  _buildInputRow(t, "${t.secondaryDiagnosis1}：", t.isZh ? "請輸入..." : "Please enter...", subDiagnosis1Ctrl),
                  const SizedBox(height: 8),
                  _buildInputRow(t, "${t.secondaryDiagnosis2}：", t.isZh ? "請輸入..." : "Please enter...", subDiagnosis2Ctrl),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildLeftCard(t, data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightCard(t, data)),
                    ],
                  ),

                  const Divider(thickness: 1, height: 32),

                  // 第三部分 - 醫師資訊
                  Text(
                    t.isZh ? "診治醫生姓名" : "Attending Physician Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(t, t.isZh ? "醫師姓名：" : "Physician Name:", doctorList, data.doctorIdx, (idx) {
                    data.doctorIdx = idx;
                    data.update();
                  }),
                  if (data.doctorIdx == doctorList.indexOf("其他"))
                    _buildInputRow(t, "${t.other}：", t.enterName, otherDoctorCtrl),

                  const SizedBox(height: 12),
                  Text(
                    t.isZh ? "診治醫生科別" : "Physician Department",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildDropdown(t, t.isZh ? "醫師科別：" : "Physician Dept:", deptList, data.deptIdx, (idx) {
                    data.deptIdx = idx;
                    data.update();
                  }),
                  if (data.deptIdx == deptList.indexOf("其他"))
                    _buildInputRow(t, "${t.other}：", t.isZh ? "請輸入科別" : "Enter department", otherDeptCtrl),

                  const SizedBox(height: 12),
                  Text(
                    t.isZh ? "診治醫師簽名" : "Physician Signature",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () =>
                        _openSignaturePad(_doctorSignController, (signData) {
                          setState(() => data.doctorSignature = signData);
                          data.update();
                        }),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: data.doctorSignature == null
                          ? Text(
                              t.tapToSign,
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Image.memory(data.doctorSignature!),
                    ),
                  ),

                  const Divider(thickness: 1, height: 32),

                  // 第四部分 - 轉診院所
                  Row(
                    children: [
                      Expanded(child: _buildLeftCard4(t, data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightCard4(t, data)),
                    ],
                  ),

                  const Divider(thickness: 1, height: 32),

                  // 同意區塊
                  Text(
                    t.isZh ? "經醫師解釋病情及轉診目的後同意轉院。" : "After explanation by physician, agree to referral.",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.isZh ? "同意人簽名" : "Consent Signature",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () =>
                        _openSignaturePad(_consentSignController, (signData) {
                          setState(() => data.consentSignature = signData);
                          data.update();
                        }),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: data.consentSignature == null
                          ? Text(
                              t.tapToSign,
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Image.memory(data.consentSignature!),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInputRow(t, t.isZh ? "與病人關係：" : "Relation to Patient:", t.isZh ? "請填寫同意人與病人關係" : "Enter relation", relationCtrl),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${t.isZh ? '簽名日期：' : 'Signature Date: '}${_formatDateTime(t, data.consentDateTime ?? DateTime.now())}",
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          data.consentDateTime = DateTime.now();
                          data.update();
                        },
                        child: Text(t.isZh ? "更新時間" : "Update Time"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= UI 小積木 =================

  Widget _buildInputRow(AppTranslations t, String label, String hint, TextEditingController ctrl) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: hint.length * 15.0 + 30,
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (_) => _syncControllersToData(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    AppTranslations t,
    String label,
    List<String> items,
    int? selectedIdx,
    Function(int) onChanged,
  ) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<int>(
            value: selectedIdx,
            items: List.generate(
              items.length,
              (i) => DropdownMenuItem(value: i, child: Text(items[i])),
            ),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftCard(AppTranslations t, ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.isZh ? "檢查及治療摘要" : "Exam & Treatment Summary", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(t.isZh ? "1. 最近一次檢查結果日期" : "1. Last Exam Date"),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.lastExamDate = d;
              data.update();
            }),
            child: Text(_formatDate(t, data.lastExamDate ?? DateTime.now())),
          ),
          const SizedBox(height: 8),
          Text(t.isZh ? "2. 最近一次用藥或手術名稱日期" : "2. Last Medication/Surgery Date"),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.lastMedicationDate = d;
              data.update();
            }),
            child: Text(_formatDate(t, data.lastMedicationDate ?? DateTime.now())),
          ),
        ],
      ),
    ),
  );

  Widget _buildRightCard(AppTranslations t, ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.isZh ? "轉診目的" : "Referral Purpose", style: const TextStyle(fontWeight: FontWeight.bold)),
          ...List.generate(referralPurposes.length, (i) {
            if (i == 3) {
              return _buildRadioWithInput(
                t,
                i,
                referralPurposes[i],
                t.isZh ? "檢查項目：" : "Exam Items:",
                t.isZh ? "請填寫檢查項目" : "Enter exam items",
                furtherExamCtrl,
                data,
              );
            } else if (i == 5) {
              return _buildRadioWithInput(
                t,
                i,
                referralPurposes[i],
                t.isZh ? "其他轉診目的：" : "Other Purpose:",
                t.isZh ? "請填寫其他轉診目的" : "Enter other purpose",
                otherPurposeCtrl,
                data,
              );
            } else {
              return _buildRadio(t, i, referralPurposes[i], data);
            }
          }),
        ],
      ),
    ),
  );

  Widget _buildLeftCard4(AppTranslations t, ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.isZh ? "開單日期" : "Issue Date", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.issueDate = d;
              data.update();
            }),
            child: Text("${t.date}：${_formatDate(t, data.issueDate ?? DateTime.now())}"),
          ),
          const SizedBox(height: 8),
          Text(t.isZh ? "安排就醫日期" : "Appointment Date", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.appointmentDate = d;
              data.update();
            }),
            child: Text(
              "${t.date}：${_formatDate(t, data.appointmentDate ?? DateTime.now())}",
            ),
          ),
          const SizedBox(height: 8),
          _buildInputRow(t, t.isZh ? "安排就醫科別：" : "Appointment Dept:", t.isZh ? "選填就醫科別" : "Optional dept", appointmentDeptCtrl),
          const SizedBox(height: 8),
          _buildInputRow(t, t.isZh ? "安排就醫診間：" : "Appointment Room:", t.isZh ? "選填就醫診間" : "Optional room", appointmentRoomCtrl),
          const SizedBox(height: 8),
          _buildInputRow(t, t.isZh ? "安排就醫號碼：" : "Appointment No:", t.isZh ? "選填就醫號碼" : "Optional number", appointmentNumberCtrl),
        ],
      ),
    ),
  );

  Widget _buildRightCard4(AppTranslations t, ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputRow(t, t.isZh ? "建議轉診院所名稱：" : "Referral Hospital:", t.isZh ? "諾新國際醫院" : "Landseed Hospital", referralHospitalCtrl),
          const SizedBox(height: 8),
          _buildDropdown(t, t.isZh ? "建議院所科別：" : "Referral Dept:", deptList, data.referralDeptIdx, (idx) {
            data.referralDeptIdx = idx;
            data.update();
          }),
          if (data.referralDeptIdx == deptList.indexOf("其他"))
            _buildInputRow(t, "${t.other}：", t.isZh ? "請輸入科別" : "Enter department", otherReferralDeptCtrl),
          const SizedBox(height: 8),
          _buildInputRow(t, t.isZh ? "建議院所醫師姓名：" : "Referral Doctor:", t.isZh ? "視情況填寫轉診院所醫師" : "Optional", referralDoctorCtrl),
          const SizedBox(height: 8),
          _buildInputRow(t, t.isZh ? "建議院所地址：" : "Hospital Address:", t.isZh ? "請填寫院所地址" : "Enter address", referralAddressCtrl),
          const SizedBox(height: 8),
          _buildInputRow(t, t.isZh ? "建議院所電話：" : "Hospital Phone:", t.isZh ? "請填寫院所電話" : "Enter phone", referralPhoneCtrl),
        ],
      ),
    ),
  );

  Widget _buildRadio(AppTranslations t, int value, String text, ReferralData data) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: data.referralPurposeIdx,
          onChanged: (val) {
            data.referralPurposeIdx = val;
            data.update();
          },
        ),
        Text(text),
      ],
    );
  }

  Widget _buildRadioWithInput(
    AppTranslations t,
    int value,
    String text,
    String label,
    String hint,
    TextEditingController ctrl,
    ReferralData data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<int>(
              value: value,
              groupValue: data.referralPurposeIdx,
              onChanged: (val) {
                data.referralPurposeIdx = val;
                data.update();
              },
            ),
            Text(text),
          ],
        ),
        if (data.referralPurposeIdx == value)
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: _buildInputRow(t, label, hint, ctrl),
          ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    ValueChanged<DateTime> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  String _formatDate(AppTranslations t, DateTime dt) {
    return t.formatDate(dt);
  }

  String _formatDateTime(AppTranslations t, DateTime dt) {
    return t.formatDate(dt);
  }
}