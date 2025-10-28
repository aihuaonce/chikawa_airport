import 'package:chikawa_airport/data/db/daos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/emergency_data.dart';
import 'l10n/app_translations.dart';
import 'data/db/app_database.dart';

class EmergencyPersonalPage extends StatefulWidget {
  final int visitId;
  const EmergencyPersonalPage({super.key, required this.visitId});

  @override
  State<EmergencyPersonalPage> createState() => _EmergencyPersonalPageState();
}

class _EmergencyPersonalPageState extends State<EmergencyPersonalPage> {
  late final Future<PatientProfile?> _patientProfileFuture;

  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _lightGreen = Color(0xFF83ACA9);
  static const Color _border = Color(0xFFCBD5E1);

  static const double _labelMinW = 84;
  static const double _labelMaxW = 108;
  static const double _labelGap = 8;

  @override
  void initState() {
    super.initState();
    // 【修改】在 initState 中初始化 Future，只執行一次資料庫查詢
    final patientProfilesDao = context.read<PatientProfilesDao>();
    _patientProfileFuture = patientProfilesDao.getByVisitId(widget.visitId);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return FutureBuilder<PatientProfile?>(
      future: _patientProfileFuture,
      builder: (context, snapshot) {
        // 狀況 1: 正在載入中
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 狀況 2: 發生錯誤
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // 狀況 3: 資料載入成功
        final profile = snapshot.data;

        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _rowTop(
                        label: t.idNumber,
                        // 【修改】使用 _DisplayField 來顯示資料
                        child: _DisplayField(
                          text: profile?.idNumber,
                          hint: t.dataNotAvailable,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _rowTop(
                        label: t.gender,
                        child: _DisplayField(
                          text: profile?.gender,
                          hint: t.dataNotAvailable,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _rowTop(
                        label: t.birthDate,
                        child: _DisplayField(
                          // 如果有生日，就格式化它
                          text: profile?.birthday == null
                              ? null
                              : t.formatDate(profile!.birthday!),
                          hint: t.dataNotAvailable,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _rowTop(
                        label: t.passportNumber,
                        child: _DisplayField(
                          text: null, // 假設 PatientProfiles 沒有此欄位
                          hint: t.dataNotAvailable, // 例如："資料未提供"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _DisplayField({required String? text, required String hint}) {
    final hasText = text != null && text.isNotEmpty;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Container(
        width: double.infinity, // 佔滿可用寬度
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          hasText ? text : hint,
          style: TextStyle(
            fontSize: 15.5,
            color: hasText ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rowTop({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: _labelMinW,
            maxWidth: _labelMaxW,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 15.5,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: _labelGap), // <-- 現在這裡可以找到定義了
        Expanded(
          child: Align(alignment: Alignment.topLeft, child: child),
        ),
      ],
    );
  }
}
