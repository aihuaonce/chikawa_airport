// lib/ElectronicDocumentsPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/electronic_document_data.dart';
import 'l10n/app_translations.dart';
import 'nav2.dart';

class ElectronicDocumentsPage extends StatefulWidget {
  final int visitId;
  const ElectronicDocumentsPage({super.key, required this.visitId});

  @override
  State<ElectronicDocumentsPage> createState() =>
      _ElectronicDocumentsPageState();
}

class _ElectronicDocumentsPageState extends State<ElectronicDocumentsPage>
    with
        AutomaticKeepAliveClientMixin<ElectronicDocumentsPage>,
        SavableStateMixin<ElectronicDocumentsPage> {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  // =================== 統一外觀樣式 ===================
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1000;
  static const double _radius = 16;
  static const Color _deepGreen = Color(0xFF274C4A);
  static const Color _border = Color(0xFFCBD5E1);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    if (!mounted) return;
    final t = AppTranslations.of(context);
    try {
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveElectronicDocFailed}$e')),
        );
      }
      rethrow;
    }
  }

  // ===============================================
  // 資料處理邏輯
  // ===============================================
  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final dao = context.read<ElectronicDocumentsDao>();
      final dataModel = context.read<ElectronicDocumentData>();
      final record = await dao.getByVisitId(widget.visitId);

      dataModel.clear();

      if (record != null) {
        dataModel.toSelectedIndex = record.toSelectedIndex;
        dataModel.fromSelectedIndex = record.fromSelectedIndex;
      }
      dataModel.update();
    } catch (e) {
      // 錯誤處理
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    final dao = context.read<ElectronicDocumentsDao>();
    final dataModel = context.read<ElectronicDocumentData>();

    // ✅ 正確做法：直接呼叫您在 dataModel 中定義好的新方法
    await dataModel.saveToDatabase(widget.visitId, dao);
  }

  // ===============================================
  // UI Build Method
  // ===============================================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context);

    final List<String> toOptions = [t.toOption1, t.toOption2];
    final List<String> fromOptions = [t.fromOption1, t.fromOption2];

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<ElectronicDocumentData>(
      builder: (context, dataModel, child) {
        return Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(
            horizontal: _outerHpad,
            vertical: 16,
          ),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
                child: _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _SectionTitle(t.toOOC),
                      const SizedBox(height: 10),
                      _RadioList(
                        options: toOptions,
                        groupValue: dataModel.toSelectedIndex,
                        onChanged: (int v) {
                          dataModel.toSelectedIndex = v;
                          dataModel.update();
                        },
                      ),
                      const SizedBox(height: 28),
                      _SectionTitle(t.fromMedicalCenter),
                      const SizedBox(height: 10),
                      _RadioList(
                        options: fromOptions,
                        groupValue: dataModel.fromSelectedIndex,
                        onChanged: (int v) {
                          dataModel.fromSelectedIndex = v;
                          dataModel.update();
                        },
                      ),
                      const SizedBox(height: 8),
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

  // ===============================================
  // 美編樣式 (統一白卡外觀)
  // ===============================================
  Widget _bigCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // 柔和陰影
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
        border: const Border(
          top: BorderSide(color: _border),
          right: BorderSide(color: _border),
          bottom: BorderSide(color: _border),
          left: BorderSide(color: _border),
        ),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        height: 1.25,
      ),
    );
  }
}

class _RadioList extends StatelessWidget {
  const _RadioList({
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  final List<String> options;
  final int? groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(options.length, (int i) {
        final bool selected = groupValue == i;
        return InkWell(
          onTap: () => onChanged(i),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 20,
                  color: selected ? const Color(0xFF274C4A) : Colors.black45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    options[i],
                    style: const TextStyle(
                      fontSize: 15.5,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
