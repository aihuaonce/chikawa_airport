import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';

class EmergencyPersonalInfo extends StatefulWidget {
  final int emergencyId;

  const EmergencyPersonalInfo({super.key, required this.emergencyId});

  @override
  State<EmergencyPersonalInfo> createState() => _EmergencyPersonalInfoState();
}

class _EmergencyPersonalInfoState extends State<EmergencyPersonalInfo> {
  // 顏色與樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgReadOnly = Color(0xFFF8FAFC); // 稍微灰一點代表唯讀

  PatientData? _patient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    try {
      final dao = context.read<AppDatabase>().medicalDao;
      final patient = await dao.getPatientByMedicalId(widget.emergencyId);
      if (mounted) {
        setState(() {
          _patient = patient;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading patient: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Prepare display values
    final idNo = _patient?.idNo ?? '';
    final birthDate = _patient?.birthday != null
        ? DateFormat('yyyy/MM/dd').format(_patient!.birthday!)
        : '';
    
    final sexName = context
            .read<ReferenceService>()
            .getSexById(_patient?.sexId)
            ?.name ??
        '';
        
    final passportNo = _patient?.passportOrIdNo ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 移除標題，直接開始佈局
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 左側欄位 ---
            Expanded(
              child: Column(
                children: [
                  _buildFieldWrapper(
                    '身分證字號 ID Number',
                    _buildReadOnlyField(value: idNo),
                  ),
                  const SizedBox(height: 24),
                  _buildFieldWrapper(
                    '出生日期 Birth Date',
                    _buildReadOnlyField(
                      value: birthDate,
                      suffixIcon: Icons.calendar_today,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 32), // 左右欄間距
            // --- 右側欄位 ---
            Expanded(
              child: Column(
                children: [
                  _buildFieldWrapper(
                    '性別 Gender',
                    _buildReadOnlyField(
                      value: sexName,
                      suffixIcon: Icons.expand_more,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFieldWrapper(
                    '護照號碼 Passport Number',
                    _buildReadOnlyField(value: passportNo),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- UI 元件方法 ---

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  // 建立唯讀狀態的顯示框 (取代原本的 TextField 與 Dropdown)
  Widget _buildReadOnlyField({required String value, IconData? suffixIcon}) {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgReadOnly, // 使用唯讀背景色
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: textMuted.withValues(alpha: 0.5), size: 18),
        ],
      ),
    );
  }
}
