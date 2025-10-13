// lib/nav3.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

class Nav3Section extends StatefulWidget {
  const Nav3Section({super.key});

  @override
  State<Nav3Section> createState() => _Nav3SectionState();
}

class _Nav3SectionState extends State<Nav3Section> {
  // 【修改】移除靜態的 placeholder 字串
  // static const String _placeholder = '請輸入患者姓名（必填）';

  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  double _textWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return tp.width;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context); // 【新增】取得翻譯物件
    final String placeholder =
        t.patientNamePlaceholder; // 【新增】取得翻譯後的 placeholder

    // 顯示樣式
    const redStyle = TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: Color(0xFFDC3545),
    );
    const blackStyle = TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );

    final bool showRed = _controller.text.isEmpty;

    // 【修改】使用翻譯後的 placeholder
    final String displayText = showRed ? placeholder : _controller.text;
    final TextStyle displayStyle = showRed ? redStyle : blackStyle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _textWidth(displayText, displayStyle) + 6;
        final width = math.min(constraints.maxWidth, w);

        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // 1) 真正的輸入框
              TextField(
                controller: _controller,
                focusNode: _focus,
                maxLines: 1,
                style: blackStyle,
                cursorColor: Colors.black87,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 6),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black87),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black87),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black87),
                  ),
                ),
              ),

              // 2) 紅字覆蓋層
              if (showRed)
                IgnorePointer(
                  child: Text(
                    placeholder, // 【修改】使用翻譯後的 placeholder
                    style: redStyle,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
