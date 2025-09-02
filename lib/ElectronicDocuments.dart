import 'package:flutter/material.dart';
import 'nav2.dart';

/// 電傳文件頁（只做 TO / FROM 單選區；上方固定橫條 & 姓名輸入已由 Nav2Page/你的元件負責）
/// 直接當作 Nav2Page 的 child 使用。
class ElectronicDocumentsPage extends StatefulWidget {
  const ElectronicDocumentsPage({super.key});

  @override
  State<ElectronicDocumentsPage> createState() => _ElectronicDocumentsPageState();
}

class _ElectronicDocumentsPageState extends State<ElectronicDocumentsPage> {
  // ─── 兩組單選的選項 ─────────────────────────────────────────────
  static const String _toTitle = 'TO：桃園國際機場股份有限公司營運控制中心';
  static const List<String> _toOptions = <String>[
    'T1 03-3063578',
    'T2 03-3063367',
  ];

  static const String _fromTitle = 'FROM：聯新國際醫院桃園國際機場醫療中心';
  static const List<String> _fromOptions = <String>[
    'T1 03-3834225',
    'T2 03-3983485',
  ];

  // ─── 目前被選中的索引（單選） ─────────────────────────────────
  int? _toSelected;    // 例如 0 代表第一個、1 代表第二個
  int? _fromSelected;  // 同上

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      selectedIndex: 7, // ← 將上方 pill 高亮在「電傳文件」
      child: Theme(
        // ① 整體字體縮放（0.92 = 小一點；1.0 = 原本；1.08 = 大一點）
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 0.92),
        ),
        child: Padding(
          // ② 整體內容「往右一些」：把 left 調大即可（例如 32、40、56）
          padding: const EdgeInsets.fromLTRB(62, 16, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 若你有自己的「請輸入患者姓名（必填）」元件，放在這裡即可
                // 例如：const NameRequiredBar(),
                // 這裡先預留一點空間
                const SizedBox(height: 8),

                // ── TO 區塊 ────────────────────────────────────────
                _SectionTitle(_toTitle),
                const SizedBox(height: 8),
                _RadioList(
                  options: _toOptions,
                  groupValue: _toSelected,
                  onChanged: (int v) => setState(() => _toSelected = v),
                ),

                const SizedBox(height: 28),

                // ── FROM 區塊 ──────────────────────────────────────
                _SectionTitle(_fromTitle),
                const SizedBox(height: 8),
                _RadioList(
                  options: _fromOptions,
                  groupValue: _fromSelected,
                  onChanged: (int v) => setState(() => _fromSelected = v),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 區段標題（例如：TO：／FROM：）
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

/// 單選清單（垂直排列的一組 Radio）
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
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.black87,
          height: 1.3,
        );

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
