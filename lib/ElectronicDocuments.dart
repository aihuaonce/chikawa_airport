// lib/ElectronicDocumentsPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/electronic_document_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
import 'nav2.dart'; // 為了使用 SavableStateMixin

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

  // UI 樣式參數
  static const double _outerHpad = 48;
  static const double _cardMaxWidth = 1100;
  static const EdgeInsets _cardMargin = EdgeInsets.fromLTRB(24, 0, 24, 16);
  static const double _radius = 16;

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
    final t = AppTranslations.of(context); // 【新增】
    try {
      await _saveData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.saveElectronicDocFailed}$e')),
        ); // 【修改】
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
    await dao.upsertByVisitId(
      visitId: widget.visitId,
      toSelectedIndex: dataModel.toSelectedIndex,
      fromSelectedIndex: dataModel.fromSelectedIndex,
    );
  }

  // ===============================================
  // UI Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context); // 【新增】

    // 【新增】動態建立翻譯後的選項列表
    // 假設選項的順序和數量是固定的
    final List<String> toOptions = [t.toOption1, t.toOption2];

    final List<String> fromOptions = [t.fromOption1, t.fromOption2];

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<ElectronicDocumentData>(
      builder: (context, dataModel, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 0.92),
          ),
          child: Container(
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
                        _SectionTitle(t.toOOC), // 【修改】
                        const SizedBox(height: 10),
                        _RadioList(
                          options: toOptions, // 【修改】
                          groupValue: dataModel.toSelectedIndex,
                          onChanged: (int v) {
                            dataModel.toSelectedIndex = v;
                            dataModel.update();
                          },
                        ),
                        const SizedBox(height: 28),
                        _SectionTitle(t.fromMedicalCenter), // 【修改】
                        const SizedBox(height: 10),
                        _RadioList(
                          options: fromOptions, // 【修改】
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
          ),
        );
      },
    );
  }

  // ===============================================
  // Helper Widgets (無須修改)
  // ===============================================

  Widget _bigCard({required Widget child}) {
    return Container(
      margin: _cardMargin,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
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
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    return Text(text, style: style);
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
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: Colors.black87, height: 1.3);

    return Column(
      children: List.generate(options.length, (int i) {
        return InkWell(
          onTap: () => onChanged(i),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: groupValue,
                  onChanged: (v) => onChanged(v!),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(options[i], style: textStyle)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
