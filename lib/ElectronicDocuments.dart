import 'package:flutter/material.dart';
import 'nav2.dart';

class ElectronicDocumentsPage extends StatefulWidget {
  const ElectronicDocumentsPage({super.key});

  @override
  State<ElectronicDocumentsPage> createState() => _ElectronicDocumentsPageState();
}

class _ElectronicDocumentsPageState extends State<ElectronicDocumentsPage> {
  // ── 兩組單選 ─────────────────────────────────────────────
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

  int? _toSelected;
  int? _fromSelected;

  // 你想要的「大卡片」樣式參數（可以自己調）
  static const double _outerHpad = 48; // 版面左右留白（讓底色露出更多/更少）
  static const double _cardMaxWidth = 1100; // 卡片最大寬（寬螢幕不會太長）
  static const EdgeInsets _cardMargin = EdgeInsets.fromLTRB(24, 0, 24, 16); // 卡片外圍 margin
  static const double _radius = 16; // 圓角

  @override
  Widget build(BuildContext context) {
    return Nav2Page(
      selectedIndex: 7, // 高亮「電傳文件」
      child: Theme(
        data: Theme.of(context).copyWith(
          // 整體字體稍微縮小點，和你上一頁一致
          textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 0.92),
        ),
        child: Container(
          color: const Color(0xFFE6F6FB),
          padding: const EdgeInsets.symmetric(horizontal: _outerHpad, vertical: 16),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
                child: _bigCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 如果 Nav2Page 裡的姓名輸入在外層，這裡就不放；保留一點空間就好
                      const SizedBox(height: 4),

                      // ── TO 區塊 ─────────────────────────────────
                      _SectionTitle(_toTitle),
                      const SizedBox(height: 10),
                      _RadioList(
                        options: _toOptions,
                        groupValue: _toSelected,
                        onChanged: (int v) => setState(() => _toSelected = v),
                      ),

                      const SizedBox(height: 28),

                      // ── FROM 區塊 ───────────────────────────────
                      _SectionTitle(_fromTitle),
                      const SizedBox(height: 10),
                      _RadioList(
                        options: _fromOptions,
                        groupValue: _fromSelected,
                        onChanged: (int v) => setState(() => _fromSelected = v),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 一張大卡片
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

/// 區段標題（粗體、黑色）
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

/// 單選清單（垂直 Radio）
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
