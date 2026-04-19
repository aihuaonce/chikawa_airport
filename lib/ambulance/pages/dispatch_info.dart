import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/db/database.dart';
import '../../data/models/sync_service_provider.dart';
import '../../medical/widgets/reference_search_sheet.dart';

class DispatchInfo extends StatefulWidget {
  final int medicalId;

  const DispatchInfo({super.key, required this.medicalId});

  @override
  State<DispatchInfo> createState() => _DispatchInfoState();
}

class _DispatchInfoState extends State<DispatchInfo> {
  // 樣式顏色定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Colors.white;

  // 控制器
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _locationRemarksController =
      TextEditingController();
  final TextEditingController _dispatchTimeController = TextEditingController();
  final TextEditingController _arrivalSceneController = TextEditingController();
  final TextEditingController _leavingSceneController = TextEditingController();
  final TextEditingController _arrivalHospitalController =
      TextEditingController();
  final TextEditingController _leavingHospitalController =
      TextEditingController();
  final TextEditingController _returnStandbyController =
      TextEditingController();

  // FocusNodes for auto-save on blur
  final FocusNode _licensePlateFocus = FocusNode();
  final FocusNode _locationRemarksFocus = FocusNode();

  // 狀態變數
  String _transportReason = '病情需要'; // 病情需要, 病人/家屬要求
  int? _ambulanceRecordId; // 真實的救護車紀錄 ID

  // 用於監聽同步狀態
  SyncServiceProvider? _syncProvider;
  DateTime? _lastSyncTime;

  // 資料庫資料
  List<IncidentPlaceCategoryData> _locations = [];
  List<IncidentPlaceCategory2Data> _location2s = []; // 二級地點列表
  List<ReferralHospitalData> _hospitals = [];
  int? _selectedLocationId;
  int? _selectedLocation2Id; // 二級地點 ID
  int? _selectedHospitalId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();

    // 綁定 FocusListener 以在失焦時儲存
    _licensePlateFocus.addListener(_onFocusChange);
    _locationRemarksFocus.addListener(_onFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 監聽同步服務
    _syncProvider = context.watch<SyncServiceProvider>();
  }

  // 同步完成後刷新資料
  void _onSyncComplete() {
    if (mounted) {
      _loadData(); // 重新載入資料
      debugPrint('系統：救護車派遣資訊已從同步刷新');
    }
  }

  void _onFocusChange() {
    if (!_licensePlateFocus.hasFocus && !_locationRemarksFocus.hasFocus) {
      _saveData();
    }
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    _locationRemarksController.dispose();
    _dispatchTimeController.dispose();
    _arrivalSceneController.dispose();
    _leavingSceneController.dispose();
    _arrivalHospitalController.dispose();
    _leavingHospitalController.dispose();
    _returnStandbyController.dispose();

    _licensePlateFocus.removeListener(_onFocusChange);
    _licensePlateFocus.dispose();
    _locationRemarksFocus.removeListener(_onFocusChange);
    _locationRemarksFocus.dispose();

    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final db = context.read<AppDatabase>();

      // 載入選項資料 (用於預先顯示名稱，實際搜尋使用 ReferenceSearchSheet)
      _locations = await db.ambulanceDao.getIncidentLocations();
      _hospitals = await db.ambulanceDao.getHospitals();

      // 透過 medicalId 查詢紀錄
      final record = await db.ambulanceDao.getAmbulanceRecordByMedicalId(
        widget.medicalId,
      );

      if (record != null) {
        _ambulanceRecordId = record.ambulanceId;

        _licensePlateController.text = record.licensePlate ?? '';
        _locationRemarksController.text = record.locationRemarks ?? '';
        _dispatchTimeController.text = _formatDate(record.dispatchTime);
        _arrivalSceneController.text = _formatDate(record.arrivalTime);
        _leavingSceneController.text = _formatDate(record.leavingSceneTime);
        _arrivalHospitalController.text = _formatDate(
          record.arrivalHospitalTime,
        );
        _leavingHospitalController.text = _formatDate(
          record.leavingHospitalTime,
        );
        _returnStandbyController.text = _formatDate(record.returnStandbyTime);

        _selectedLocationId = record.incidentLocationId;
        _selectedLocation2Id = record.incidentLocation2Id; // 載入二級地點
        _selectedHospitalId = record.hospitalId;
        if (record.transportReason != null &&
            record.transportReason!.isNotEmpty) {
          _transportReason = record.transportReason!;
        }

        // 若有一級地點，載入對應的二級地點
        if (_selectedLocationId != null) {
          _location2s = await db.ambulanceDao.getIncidentLocation2s(
            _selectedLocationId!,
          );
        }
      } else {
        // 沒有紀錄，執行自動代入
        await _autoFillFromMedicalRecord(db, widget.medicalId);
      }
    } catch (e) {
      debugPrint('Error loading ambulance data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 從 MedicalRecord 相關表格自動代入資料
  Future<void> _autoFillFromMedicalRecord(AppDatabase db, int medicalId) async {
    bool dataChanged = false;

    // 1. 代入 IncidentRecord 資料
    if (_selectedLocationId == null ||
        _locationRemarksController.text.isEmpty) {
      final incident = await db.ambulanceDao.getIncidentRecordByMedicalId(
        medicalId,
      );

      debugPrint('IncidentRecord found for auto-fill: $incident');

      if (incident != null) {
        if (_selectedLocationId == null) {
          _selectedLocationId = incident.incidentPlaceCategoryId;
          // 同時載入二級地點列表
          _location2s = await db.ambulanceDao.getIncidentLocation2s(
            _selectedLocationId!,
          );

          // 代入二級地點
          if (incident.incidentPlaceCategory2Id != null) {
            _selectedLocation2Id = incident.incidentPlaceCategory2Id;
          }

          dataChanged = true;
        }

        if (_locationRemarksController.text.isEmpty &&
            incident.incidentPlaceFinal != null) {
          _locationRemarksController.text = incident.incidentPlaceFinal!;
          dataChanged = true;
        }
      }
    }

    // 2. 代入 ReferralForm 資料 (醫院)
    if (_selectedHospitalId == null) {
      final referral = await db.ambulanceDao.getReferralFormByMedicalId(
        medicalId,
      );
      if (referral != null && referral.hospitalName != null) {
        await _tryMatchHospital(referral.hospitalName!);
      }
    }

    // 3. 代入 Treatment 資料 (如果 ReferralForm 沒有資料)
    if (_selectedHospitalId == null) {
      final treatment = await db.ambulanceDao.getTreatmentByMedicalId(
        medicalId,
      );
      if (treatment != null) {
        // A. 優先嘗試 ID
        if (treatment.referralHospitalId != null) {
          try {
            final hospital = _hospitals.firstWhere(
              (h) => h.id == treatment.referralHospitalId,
            );
            _selectedHospitalId = hospital.id;
            dataChanged = true;
            debugPrint(
              'Hospital matched by Treatment ID: ${treatment.referralHospitalId}',
            );
          } catch (e) {
            debugPrint(
              'Treatment Hospital ID ${treatment.referralHospitalId} not found in list',
            );
          }
        }

        // B. 如果 ID 沒中，嘗試名稱 (referralHospitalFinal)
        if (_selectedHospitalId == null &&
            treatment.referralHospitalFinal != null) {
          debugPrint(
            'Trying match by Treatment Final Name: ${treatment.referralHospitalFinal}',
          );
          await _tryMatchHospital(treatment.referralHospitalFinal!);
        }
      }
    }

    if (dataChanged) {
      // 這裡不直接儲存，因為還沒有 ambulanceId。
      // 等到使用者修改或離開頁面時，_saveData 會處理新增邏輯。
      // 但如果希望一進入就建立紀錄，也可以在這裡呼叫 _saveData。
      // 為了 UX (避免產生太多空紀錄)，我們通常等到使用者操作再存，
      // 但為了確保代入資料不遺失，這裡可以選擇先存。
      // 考慮到這是「自動代入」，若使用者不喜歡可以改，所以先只更新 UI 狀態。
      // 然而，如果 _saveData 邏輯是依賴 _ambulanceRecordId 來判斷 update/insert，
      // 那第一次 _saveData 會執行 insert。
    }
  }

  // 輔助方法：嘗試比對醫院名稱或 ID
  Future<void> _tryMatchHospital(String hospitalName) async {
    debugPrint('Matching hospital name/id: $hospitalName');

    // 嘗試解析為 ID
    final hospitalId = int.tryParse(hospitalName);
    if (hospitalId != null) {
      // 若是數字，直接比對 ID
      try {
        final hospital = _hospitals.firstWhere((h) => h.id == hospitalId);
        setState(() => _selectedHospitalId = hospital.id);
        debugPrint('Hospital matched by ID: ${hospital.name}');
      } catch (e) {
        debugPrint('Hospital ID $hospitalId not found in list');
      }
    } else {
      // 若不是數字，嘗試名稱模糊比對
      try {
        // 標準化：去空格、轉小寫、統一括號等 (這裡簡化處理)
        String normalize(String s) =>
            s.replaceAll(RegExp(r'\s+'), '').toLowerCase();

        final targetName = normalize(hospitalName);

        final hospital = _hospitals.firstWhere((h) {
          final currentName = normalize(h.name);
          return currentName == targetName ||
              currentName.contains(targetName) ||
              targetName.contains(currentName);
        });

        setState(() => _selectedHospitalId = hospital.id);
        debugPrint('Hospital matched by Name: ${hospital.name}');
      } catch (e) {
        debugPrint('Hospital name "$hospitalName" not found (fuzzy match)');
      }
    }
  }

  Future<void> _saveData() async {
    if (!mounted) return;

    try {
      final db = context.read<AppDatabase>();

      final companion = AmbulanceRecordsCompanion(
        medicalId: drift.Value(widget.medicalId), // 確保關聯到 medicalId
        licensePlate: drift.Value(_licensePlateController.text),
        incidentLocationId: drift.Value(_selectedLocationId),
        incidentLocation2Id: drift.Value(_selectedLocation2Id),
        locationRemarks: drift.Value(_locationRemarksController.text),
        dispatchTime: drift.Value(_parseDate(_dispatchTimeController.text)),
        arrivalTime: drift.Value(_parseDate(_arrivalSceneController.text)),
        hospitalId: drift.Value(_selectedHospitalId),
        transportReason: drift.Value(_transportReason),
        leavingSceneTime: drift.Value(_parseDate(_leavingSceneController.text)),
        arrivalHospitalTime: drift.Value(
          _parseDate(_arrivalHospitalController.text),
        ),
        leavingHospitalTime: drift.Value(
          _parseDate(_leavingHospitalController.text),
        ),
        returnStandbyTime: drift.Value(
          _parseDate(_returnStandbyController.text),
        ),
        updatedAt: drift.Value(DateTime.now()),
      );

      if (_ambulanceRecordId == null) {
        // 新增紀錄
        final newId = await db.ambulanceDao.createAmbulanceRecord(companion);
        setState(() {
          _ambulanceRecordId = newId;
        });
      } else {
        // 更新紀錄
        final updateCompanion = companion.copyWith(
          ambulanceId: drift.Value(_ambulanceRecordId!),
        );
        await db.ambulanceDao.updateAmbulanceRecord(updateCompanion);
      }
    } catch (e) {
      debugPrint('Error saving ambulance data: $e');
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(date);
  }

  DateTime? _parseDate(String text) {
    if (text.isEmpty) return null;
    try {
      return DateFormat('yyyy/MM/dd HH:mm:ss').parse(text);
    } catch (e) {
      return null;
    }
  }

  // 更新時間為現在
  void _updateNow(TextEditingController controller) {
    setState(() {
      controller.text = DateFormat(
        'yyyy/MM/dd HH:mm:ss',
      ).format(DateTime.now());
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 監聽同步服務
    _syncProvider = context.watch<SyncServiceProvider>();
    final currentSyncTime = _syncProvider?.lastSyncTime;

    // 頁面首次載入時同步一次（為了顯示之前同步下來的資料）
    if (currentSyncTime != null && _lastSyncTime != currentSyncTime) {
      _lastSyncTime = currentSyncTime;
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          _loadData();
          debugPrint('系統：救護車派遣資訊已刷新同步下來的資料');
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一排：車牌 與 地點 (一級 & 二級)
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFieldWrapper(
                '車牌號碼 License Plate No.',
                _buildTextField(
                  hint: '輸入車牌號碼',
                  controller: _licensePlateController,
                  focusNode: _licensePlateFocus,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: _buildFieldWrapper(
                '發生地點 Incident Location',
                Row(
                  children: [
                    Expanded(child: _buildLocationSelection()),
                    const SizedBox(width: 8),
                    Expanded(child: _buildLocation2Selection()),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第二排：地點備註 (全寬)
        _buildFieldWrapper(
          '地點備註 Location Remarks',
          _buildTextField(
            hint: '請詳述具體地點資訊...',
            maxLines: 3,
            controller: _locationRemarksController,
            focusNode: _locationRemarksFocus,
          ),
        ),

        const SizedBox(height: 24),

        // 第三排：出勤時間 與 到達現場時間
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                '出勤日期與時間 Dispatch Time',
                _dispatchTimeController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTimeField(
                '到達現場時間 Arrival Time',
                _arrivalSceneController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第四排：送往醫院 與 運送原因
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                '送往醫院或地點 Hospital/Destination',
                _buildHospitalSelection(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFieldWrapper(
                '運送原因 Transport Reason',
                _buildSegmentedControl(['病情需要', '病人/家屬要求'], _transportReason, (
                  v,
                ) {
                  setState(() => _transportReason = v);
                  _saveData();
                }),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第五排：離開現場時間 與 到達醫院時間
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                '離開現場時間 Leaving Scene',
                _leavingSceneController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTimeField(
                '到達醫院時間 Arrival Hospital',
                _arrivalHospitalController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 第六排：離開醫院時間 與 返回待命時間
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                '離開醫院時間 Leaving Hospital',
                _leavingHospitalController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTimeField(
                '返回待命時間 Return to Standby',
                _returnStandbyController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- UI 子組件 ---

  Widget _buildTimeField(String label, TextEditingController controller) {
    return _buildFieldWrapper(
      label,
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              hint: 'YYYY/MM/DD HH:mm:ss',
              controller: controller,
              readOnly: true,
            ),
          ),
          const SizedBox(width: 8),
          _buildNowButton(() => _updateNow(controller)),
        ],
      ),
    );
  }

  Widget _buildNowButton(VoidCallback onPressed) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.withValues(alpha: 0.1),
          foregroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text(
          'NOW',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: options.map((opt) {
          bool isSel = current == opt;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSel ? Colors.white : textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 選擇器實作 ---

  Widget _buildLocationSelection() {
    // 尋找當前選擇的物件
    IncidentPlaceCategoryData? selectedItem;
    try {
      if (_selectedLocationId != null) {
        selectedItem = _locations.firstWhere(
          (e) => e.id == _selectedLocationId,
        );
      }
    } catch (_) {}

    return _buildSelectionField(
      text: selectedItem?.name ?? '',
      hint: '主地點',
      icon: Icons.location_on_outlined,
      onTap: () async {
        final db = context.read<AppDatabase>();
        final result =
            await ReferenceSearchSheet.show<IncidentPlaceCategoryData>(
              context,
              title: '選擇發生地點',
              searchFunction: db.ambulanceDao.searchIncidentLocations,
              initialSelection: selectedItem,
              isSelectedComparator: (a, b) => a.id == b?.id,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      color: isSelected ? primaryColor : textDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: primaryColor)
                      : null,
                );
              },
            );

        if (result != null) {
          if (!mounted) return;

          setState(() {
            _selectedLocationId = result.id;
            // 清空二級地點並重置列表
            _selectedLocation2Id = null;
            _location2s = [];
          });

          // 載入新的二級地點
          final db = context.read<AppDatabase>();
          final newSubLocations = await db.ambulanceDao.getIncidentLocation2s(
            result.id,
          );

          setState(() {
            _location2s = newSubLocations;
          });

          _saveData();
        }
      },
    );
  }

  Widget _buildLocation2Selection() {
    // 若未選擇一級地點或該地點無二級選項，則禁用
    if (_selectedLocationId == null) {
      return _buildDisabledSelectionField('次地點');
    }

    // 尋找當前選擇的物件
    IncidentPlaceCategory2Data? selectedItem;
    try {
      if (_selectedLocation2Id != null) {
        selectedItem = _location2s.firstWhere(
          (e) => e.id == _selectedLocation2Id,
        );
      }
    } catch (_) {}

    return _buildSelectionField(
      text: selectedItem?.name ?? '',
      hint: '次地點',
      icon: Icons.subdirectory_arrow_right_rounded,
      onTap: () async {
        final db = context.read<AppDatabase>();
        final result =
            await ReferenceSearchSheet.show<IncidentPlaceCategory2Data>(
              context,
              title: '選擇次要地點',
              searchFunction: (query) => db.ambulanceDao
                  .searchIncidentLocation2s(query, _selectedLocationId),
              initialSelection: selectedItem,
              isSelectedComparator: (a, b) => a.id == b?.id,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      color: isSelected ? primaryColor : textDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: primaryColor)
                      : null,
                );
              },
            );

        if (result != null) {
          setState(() => _selectedLocation2Id = result.id);
          _saveData();
        }
      },
    );
  }

  Widget _buildHospitalSelection() {
    // 尋找當前選擇的物件
    ReferralHospitalData? selectedItem;
    try {
      if (_selectedHospitalId != null) {
        selectedItem = _hospitals.firstWhere(
          (e) => e.id == _selectedHospitalId,
        );
      }
    } catch (_) {}

    return _buildSelectionField(
      text: selectedItem?.name ?? '',
      hint: '選擇醫院',
      icon: Icons.local_hospital_outlined,
      onTap: () async {
        final db = context.read<AppDatabase>();
        final result = await ReferenceSearchSheet.show<ReferralHospitalData>(
          context,
          title: '選擇醫院',
          searchFunction: db.ambulanceDao.searchHospitals,
          initialSelection: selectedItem,
          isSelectedComparator: (a, b) => a.id == b?.id,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: item.address != null ? Text(item.address!) : null,
              trailing: isSelected
                  ? const Icon(Icons.check, color: primaryColor)
                  : null,
            );
          },
        );

        if (result != null) {
          setState(() => _selectedHospitalId = result.id);
          _saveData();
        }
      },
    );
  }

  // --- 基礎元件 ---

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label.toUpperCase()),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
    bool readOnly = false,
    FocusNode? focusNode,
  }) {
    return SizedBox(
      height: maxLines == 1 ? 44 : null,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textMuted.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          filled: true,
          fillColor: bgField,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionField({
    required String text,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text.isNotEmpty ? text : hint,
                style: TextStyle(
                  color: text.isNotEmpty
                      ? textDark
                      : textMuted.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledSelectionField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // 灰色背景表示禁用
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.subdirectory_arrow_right_rounded,
            size: 18,
            color: textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(
                color: textMuted.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
