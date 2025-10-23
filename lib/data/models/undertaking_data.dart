// lib/data/models/undertaking_data.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chikawa_airport/data/db/app_database.dart';
import 'package:drift/drift.dart';
import '../db/daos.dart';

class UndertakingData extends ChangeNotifier {
  //==================================================================
  // 1. 狀態屬性 (State Properties)
  //==================================================================

  // 用來暫存從資料庫讀取的病患原始資料
  String? patientName;
  String? patientIdNumber;

  // 切結書欄位的狀態
  String? signerName;
  String? signerId;
  bool isSelf = false;
  String? relation;
  String? address;
  String? phone;
  String? doctor = "江旺財";
  Uint8List? signatureBytes;

  final List<String> doctorList = const [
    "方詩旋",
    "古璿正",
    "江旺財",
    "呂學政",
    "周志勃",
    "金霍歌",
    "徐丕",
    "康曉妍",
  ];

  // ✅ 新增：持有對 UI 層 TextEditingController 的引用
  // 這樣可以直接在 Model 中更新 UI 文字，實現完全的邏輯分離
  TextEditingController? _signerController;
  TextEditingController? _signerIdController;
  TextEditingController? _relationController;
  TextEditingController? _addressController;
  TextEditingController? _phoneController;

  void update() => notifyListeners();

  //==================================================================
  // 2. 初始化與清理 (Initialization & Cleanup)
  //==================================================================

  /// ✅ 新增：讓 Page 可以將它的 Controllers 註冊到這個 Model 中
  void initControllers({
    required TextEditingController signerController,
    required TextEditingController signerIdController,
    required TextEditingController relationController,
    required TextEditingController addressController,
    required TextEditingController phoneController,
  }) {
    _signerController = signerController;
    _signerIdController = signerIdController;
    _relationController = relationController;
    _addressController = addressController;
    _phoneController = phoneController;

    // ✅ 新增：監聽 Controller 的變化，即時更新預覽文字
    // (這部分是為了 UI 即時反應，也可以省略，改為只在儲存前同步)
    _signerController?.addListener(() {
      if (signerName != _signerController?.text) {
        signerName = _signerController?.text;
        notifyListeners(); // 更新 UI 上的預覽文字
      }
    });
    _signerIdController?.addListener(() {
      if (signerId != _signerIdController?.text) {
        signerId = _signerIdController?.text;
        notifyListeners(); // 更新 UI 上的預覽文字
      }
    });
  }

  void clear() {
    patientName = null;
    patientIdNumber = null;
    signerName = null;
    signerId = null;
    isSelf = false;
    relation = null;
    address = null;
    phone = null;
    doctor = "江旺財";
    signatureBytes = null;
    notifyListeners();
  }

  //==================================================================
  // 3. 商業邏輯 (Business Logic)
  //==================================================================

  /// ✅ 新增：處理 "是否為本人" Checkbox 的邏輯
  void toggleIsSelf(bool newValue) {
    isSelf = newValue;

    if (isSelf) {
      // 如果勾選為本人，自動帶入資料
      signerName = patientName;
      signerId = patientIdNumber;
      relation = '本人';

      // 同步更新到 Controller
      _signerController?.text = patientName ?? '';
      _signerIdController?.text = patientIdNumber ?? '';
      _relationController?.text = '本人';
    } else {
      // 如果取消勾選，清空關係欄位
      relation = '';
      _relationController?.clear();
    }
    notifyListeners(); // 通知 UI 更新 Checkbox 和預覽文字
  }

  /// ✅ 新增：從 UI Controllers 同步資料到 Model 的屬性中
  /// 這個方法會在儲存前被呼叫，確保 Model 持有最新的資料
  void _syncDataFromControllers() {
    signerName = _signerController?.text.trim();
    signerId = _signerIdController?.text.trim();
    relation = _relationController?.text.trim();
    address = _addressController?.text.trim();
    phone = _phoneController?.text.trim();
  }

  //==================================================================
  // 4. 資料庫互動 (Database Interaction)
  //==================================================================

  /// ✅ 修改：將 Page 中的 loadData 邏輯完整搬移至此
  Future<void> loadDataForVisit(
    int visitId, {
    required UndertakingsDao undertakingDao,
    required VisitsDao visitsDao,
    required PatientProfilesDao profileDao,
  }) async {
    // 平行獲取所有需要的資料
    final results = await Future.wait([
      undertakingDao.getByVisitId(visitId),
      visitsDao.getById(visitId),
      profileDao.getByVisitId(visitId),
    ]);

    final record = results[0] as Undertaking?;
    final visit = results[1] as Visit?;
    final profile = results[2] as PatientProfile?;

    // 將病患的原始資料存入 Model
    patientName = visit?.patientName;
    patientIdNumber = profile?.idNumber;

    // 載入已儲存的切結書資料
    if (record != null) {
      signerName = record.signerName;
      signerId = record.signerId;
      isSelf = record.isSelf;
      relation = record.relation;
      address = record.address;
      phone = record.phone;
      doctor = record.doctor ?? "江旺財";
      signatureBytes = record.signatureBytes;
    } else {
      // 如果是新的切結書，可以設定預設值
      isSelf = false;
      doctor = "江旺財";
    }

    // 將 Model 中的資料同步到 UI Controllers
    _signerController?.text = signerName ?? '';
    _signerIdController?.text = signerId ?? '';
    _relationController?.text = relation ?? '';
    _addressController?.text = address ?? '';
    _phoneController?.text = phone ?? '';

    notifyListeners(); // 通知 UI 刷新
  }

  /// ✅ 修改：儲存前先同步一次資料
  Future<void> saveToDatabase(
    int visitId,
    UndertakingsDao undertakingDao,
    VisitsDao visitsDao,
  ) async {
    // 1. 從 UI Controllers 同步最新的文字到 Model
    _syncDataFromControllers();

    // 2. 執行資料庫操作
    try {
      await undertakingDao.upsert(_toCompanion(visitId));
      await visitsDao.updateVisit(visitId, _toVisitsCompanion());
      print('✅ 切結書與 Visits 摘要已更新');
    } catch (e) {
      print('❌ 儲存切結書資料失敗: $e');
      rethrow;
    }
  }

  //==================================================================
  // 5. 資料轉換 (Data Conversion) - 設為私有方法
  //==================================================================

  UndertakingsCompanion _toCompanion(int visitId) {
    return UndertakingsCompanion(
      visitId: Value(visitId),
      signerName: Value(signerName),
      signerId: Value(signerId),
      isSelf: Value(isSelf),
      relation: Value(relation),
      address: Value(address),
      phone: Value(phone),
      doctor: Value(doctor),
      signatureBytes: Value(signatureBytes),
    );
  }

  VisitsCompanion _toVisitsCompanion() {
    return VisitsCompanion(
      note: Value('切結書人: ${signerName ?? ""} / 醫師: ${doctor ?? ""}'),
    );
  }
}
