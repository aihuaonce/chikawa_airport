//referralform.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../data/db/daos.dart';
import '../data/models/referral_data.dart';
import 'nav2.dart';

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
    "周志勃",
    "金霍歌",
    "徐丕",
    "康曉妍",
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
                    child: const Text("重寫"),
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
                    child: const Text("儲存"),
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
                  const Text(
                    "聯絡人資料",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow("姓名：", "請填寫聯絡人姓名", contactNameCtrl),
                  const SizedBox(height: 8),
                  _buildInputRow("電話：", "請填寫聯絡人電話", contactPhoneCtrl),
                  const SizedBox(height: 8),
                  _buildInputRow("地址：", "請填寫聯絡人地址", contactAddressCtrl),

                  const Divider(thickness: 1, height: 32),

                  // 第二部分 - 診斷
                  const Text(
                    "診斷ICD-10-CM/PCS病名",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildInputRow("主診斷：", "請輸入...", mainDiagnosisCtrl),
                  const SizedBox(height: 8),
                  _buildInputRow("副診斷1：", "請輸入...", subDiagnosis1Ctrl),
                  const SizedBox(height: 8),
                  _buildInputRow("副診斷2：", "請輸入...", subDiagnosis2Ctrl),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildLeftCard(data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightCard(data)),
                    ],
                  ),

                  const Divider(thickness: 1, height: 32),

                  // 第三部分 - 醫師資訊
                  const Text(
                    "診治醫生姓名",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown("醫師姓名：", doctorList, data.doctorIdx, (idx) {
                    data.doctorIdx = idx;
                    data.update();
                  }),
                  if (data.doctorIdx == doctorList.indexOf("其他"))
                    _buildInputRow("其他：", "請輸入姓名", otherDoctorCtrl),

                  const SizedBox(height: 12),
                  const Text(
                    "診治醫生科別",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildDropdown("醫師科別：", deptList, data.deptIdx, (idx) {
                    data.deptIdx = idx;
                    data.update();
                  }),
                  if (data.deptIdx == deptList.indexOf("其他"))
                    _buildInputRow("其他：", "請輸入科別", otherDeptCtrl),

                  const SizedBox(height: 12),
                  const Text(
                    "診治醫師簽名",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                          ? const Text(
                              "點擊簽名",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Image.memory(data.doctorSignature!),
                    ),
                  ),

                  const Divider(thickness: 1, height: 32),

                  // 第四部分 - 轉診院所
                  Row(
                    children: [
                      Expanded(child: _buildLeftCard4(data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightCard4(data)),
                    ],
                  ),

                  const Divider(thickness: 1, height: 32),

                  // 同意區塊
                  const Text(
                    "經醫師解釋病情及轉診目的後同意轉院。",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "同意人簽名",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                          ? const Text(
                              "點擊簽名",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Image.memory(data.consentSignature!),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInputRow("與病人關係：", "請填寫同意人與病人關係", relationCtrl),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "簽名日期：${_formatDateTime(data.consentDateTime ?? DateTime.now())}",
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          data.consentDateTime = DateTime.now();
                          data.update();
                        },
                        child: const Text("更新時間"),
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

  Widget _buildInputRow(String label, String hint, TextEditingController ctrl) {
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

  Widget _buildLeftCard(ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("檢查及治療摘要", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("1. 最近一次檢查結果日期"),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.lastExamDate = d;
              data.update();
            }),
            child: Text(_formatDate(data.lastExamDate ?? DateTime.now())),
          ),
          const SizedBox(height: 8),
          const Text("2. 最近一次用藥或手術名稱日期"),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.lastMedicationDate = d;
              data.update();
            }),
            child: Text(_formatDate(data.lastMedicationDate ?? DateTime.now())),
          ),
        ],
      ),
    ),
  );

  Widget _buildRightCard(ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("轉診目的", style: TextStyle(fontWeight: FontWeight.bold)),
          ...List.generate(referralPurposes.length, (i) {
            if (i == 3) {
              return _buildRadioWithInput(
                i,
                "進一步檢查",
                "檢查項目：",
                "請填寫檢查項目",
                furtherExamCtrl,
                data,
              );
            } else if (i == 5) {
              return _buildRadioWithInput(
                i,
                "其他",
                "其他轉診目的：",
                "請填寫其他轉診目的",
                otherPurposeCtrl,
                data,
              );
            } else {
              return _buildRadio(i, referralPurposes[i], data);
            }
          }),
        ],
      ),
    ),
  );

  Widget _buildLeftCard4(ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("開單日期", style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.issueDate = d;
              data.update();
            }),
            child: Text("日期：${_formatDate(data.issueDate ?? DateTime.now())}"),
          ),
          const SizedBox(height: 8),
          const Text("安排就醫日期", style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => _pickDate(context, (d) {
              data.appointmentDate = d;
              data.update();
            }),
            child: Text(
              "日期：${_formatDate(data.appointmentDate ?? DateTime.now())}",
            ),
          ),
          const SizedBox(height: 8),
          _buildInputRow("安排就醫科別：", "選填就醫科別", appointmentDeptCtrl),
          const SizedBox(height: 8),
          _buildInputRow("安排就醫診間：", "選填就醫診間", appointmentRoomCtrl),
          const SizedBox(height: 8),
          _buildInputRow("安排就醫號碼：", "選填就醫號碼", appointmentNumberCtrl),
        ],
      ),
    ),
  );

  Widget _buildRightCard4(ReferralData data) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputRow("建議轉診院所名稱：", "聯新國際醫院", referralHospitalCtrl),
          const SizedBox(height: 8),
          _buildDropdown("建議院所科別：", deptList, data.referralDeptIdx, (idx) {
            data.referralDeptIdx = idx;
            data.update();
          }),
          if (data.referralDeptIdx == deptList.indexOf("其他"))
            _buildInputRow("其他：", "請輸入科別", otherReferralDeptCtrl),
          const SizedBox(height: 8),
          _buildInputRow("建議院所醫師姓名：", "視情況填寫轉診院所醫師", referralDoctorCtrl),
          const SizedBox(height: 8),
          _buildInputRow("建議院所地址：", "請填寫院所地址", referralAddressCtrl),
          const SizedBox(height: 8),
          _buildInputRow("建議院所電話：", "請填寫院所電話", referralPhoneCtrl),
        ],
      ),
    ),
  );

  Widget _buildRadio(int value, String text, ReferralData data) {
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
            child: _buildInputRow(label, hint, ctrl),
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

  String _formatDate(DateTime dt) {
    return '${dt.year}年${dt.month.toString().padLeft(2, '0')}月${dt.day.toString().padLeft(2, '0')}日';
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}年${dt.month.toString().padLeft(2, '0')}月${dt.day.toString().padLeft(2, '0')}日';
  }
}
