// lib/nav3.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Nav3Section extends StatefulWidget {
  const Nav3Section({super.key});

  @override
  State<Nav3Section> createState() => _Nav3SectionState();
}

class _Nav3SectionState extends State<Nav3Section> {
  static const String _placeholder = '請輸入患者姓名（必填）';

  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {})); // 任何輸入變化都重建 UI
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  // 量測文字寬度，讓底線長度和文字一致
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
    // 顯示樣式
    final redStyle = const TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: Color(0xFFDC3545), // 紅
    );
    final blackStyle = const TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: Colors.black87, // 黑
    );

    final bool showRed = _controller.text.isEmpty;

    // 目前要顯示哪段文字，用來決定底線長度
    final String displayText = showRed ? _placeholder : _controller.text;
    final TextStyle displayStyle = showRed ? redStyle : blackStyle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _textWidth(displayText, displayStyle) + 6; // 多 6px 餘裕
        final width = math.min(constraints.maxWidth, w);

        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // 1) 真正的輸入框（只放使用者的文字）
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
                  // 不用 TextField 自帶 hintText，我們用覆蓋層自己畫紅字
                ),
              ),

              // 2) 紅字覆蓋層：只有在輸入為空時顯示
              if (showRed)
                IgnorePointer(
                  child: Text(
                    _placeholder,
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
