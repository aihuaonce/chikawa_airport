// lib/BodyMapPage.dart
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:provider/provider.dart';
import 'data/db/daos.dart';
import 'data/models/body_map_data.dart';
import 'l10n/app_translations.dart'; // 【新增】引入翻譯
import 'nav2.dart';

class BodyMapPage extends StatefulWidget {
  final int visitId;
  const BodyMapPage({super.key, required this.visitId});

  @override
  State<BodyMapPage> createState() => _BodyMapPageState();
}

class _BodyMapPageState extends State<BodyMapPage>
    with
        AutomaticKeepAliveClientMixin<BodyMapPage>,
        SavableStateMixin<BodyMapPage> {
  @override
  bool get wantKeepAlive => true;

  PainterController? _controller;
  bool _loading = true;
  String? _rawErrorMessage; // 【修改】儲存原始錯誤訊息
  ui.Image? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadPainter();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _backgroundImage?.dispose();
    super.dispose();
  }

  Future<void> reloadFromDatabase() async {
    debugPrint("🔄 BodyMap 開始重新載入...");
    setState(() {
      _loading = true;
      _rawErrorMessage = null;
    });
    _controller?.dispose();
    _controller = null;
    await _initializeAndLoadPainter();
  }

  // ===============================================
  // SavableStateMixin 介面實作
  // ===============================================
  @override
  Future<void> saveData() async {
    if (_controller == null || !mounted) return;
    final t = AppTranslations.of(context); // 【新增】

    final drawables = _controller!.drawables;
    if (drawables.isEmpty) {
      debugPrint("沒有畫任何東西，不儲存 BodyMap。");
      return;
    }

    try {
      final drawablesList = drawables
          .map((d) => _drawableToJson(d))
          .whereType<Map<String, dynamic>>()
          .toList();

      final jsonString = jsonEncode(drawablesList);

      final dao = context.read<PatientProfilesDao>();
      await dao.upsertBodyMap(widget.visitId, jsonString);

      final profile = await dao.getByVisitId(widget.visitId);
      final dataModel = context.read<BodyMapData>();
      dataModel.setBodyMap(profile?.bodyMapJson);

      debugPrint("✅ 儲存並重新讀取 BodyMap: ${dataModel.bodyMapJson}");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.bodyMapSaveSuccess))); // 【修改】
      }
    } catch (e) {
      debugPrint("儲存 BodyMap 發生錯誤: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${t.bodyMapSaveFailed}$e")),
        ); // 【修改】
      }
    }
  }

  // ===============================================
  // 資料與繪圖板處理邏輯
  // ===============================================
  Future<void> _initializeAndLoadPainter() async {
    try {
      // ... (內部邏輯不變)
      final dataModel = context.read<BodyMapData>();
      final dao = context.read<PatientProfilesDao>();
      final profile = await dao.getByVisitId(widget.visitId);
      dataModel.setBodyMap(profile?.bodyMapJson);
      _backgroundImage = await _loadBodyMapBackground();
      if (!mounted) return;
      _controller = PainterController(
        /* ... settings ... */
      );
      _controller!.background = _backgroundImage!.backgroundDrawable;
      if (dataModel.bodyMapJson != null &&
          dataModel.bodyMapJson!.trim().isNotEmpty) {
        try {
          final List<dynamic> jsonData = jsonDecode(dataModel.bodyMapJson!);
          final drawables = <Drawable>[];
          for (var json in jsonData) {
            try {
              final d = _drawableFromJson(Map<String, dynamic>.from(json));
              if (d != null) drawables.add(d);
            } catch (e) {
              debugPrint("❌ 解析單筆 Drawable 失敗: $json , 錯誤: $e");
            }
          }
          if (drawables.isNotEmpty) _controller!.addDrawables(drawables);
        } catch (e) {
          debugPrint("❌ 整體 JSON 解析失敗: $e");
        }
      }
      setState(() => _loading = false);
    } catch (e) {
      debugPrint("載入 BodyMap 發生錯誤: $e");
      if (mounted) {
        setState(() {
          _rawErrorMessage = e.toString(); // 【修改】
          _loading = false;
        });
      }
    }
  }

  Future<ui.Image> _loadBodyMapBackground() async {
    try {
      const String imagePath = 'assets/images/body_diagram_placeholder.jpg';
      final ByteData data = await rootBundle.load(imagePath);
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      return frameInfo.image;
    } catch (e) {
      rethrow;
    }
  }

  Drawable? _drawableFromJson(Map<String, dynamic> json) {
    // ... (此函數內部不包含用戶可見文字，無需修改)
    try {
      final type = json['type'] as String?;
      if (type == null) return null;
      switch (type) {
        case 'FreeStyleDrawable':
          final pointsList = (json['path'] ?? json['points']) as List? ?? [];
          final points = pointsList.map((point) {
            final p = point as List;
            return Offset((p[0] as num).toDouble(), (p[1] as num).toDouble());
          }).toList();
          final color = Color(json['color'] as int? ?? Colors.red.value);
          final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 3.0;
          return FreeStyleDrawable(
            path: points,
            color: color,
            strokeWidth: strokeWidth,
          );

        case 'TextDrawable':
          final text = json['text'] as String? ?? "";
          final positionList = (json['position'] as List?) ?? [0, 0];
          final position = Offset(
            (positionList[0] as num).toDouble(),
            (positionList[1] as num).toDouble(),
          );
          final styleJson = (json['style'] as Map<String, dynamic>?) ?? {};
          final textStyle = TextStyle(
            color: Color(styleJson['color'] as int? ?? Colors.black.value),
            fontSize: (styleJson['fontSize'] as num?)?.toDouble() ?? 18.0,
            fontWeight:
                FontWeight.values[styleJson['fontWeightIndex'] as int? ??
                    FontWeight.normal.index],
          );
          return TextDrawable(text: text, position: position, style: textStyle);

        default:
          debugPrint("未知的 drawable 類型: $type");
          return null;
      }
    } catch (e) {
      debugPrint("解析 drawable 失敗: $json , 錯誤: $e");
      return null;
    }
  }

  Map<String, dynamic>? _drawableToJson(Drawable drawable) {
    // ... (此函數內部不包含用戶可見文字，無需修改)
    if (drawable is FreeStyleDrawable) {
      return {
        'type': 'FreeStyleDrawable',
        'path': drawable.path.map((p) => [p.dx, p.dy]).toList(),
        'color': drawable.color.value,
        'strokeWidth': drawable.strokeWidth,
      };
    } else if (drawable is TextDrawable) {
      return {
        'type': 'TextDrawable',
        'text': drawable.text,
        'position': [drawable.position.dx, drawable.position.dy],
        'style': {
          'color': drawable.style.color?.value ?? Colors.black.value,
          'fontSize': drawable.style.fontSize ?? 18.0,
          'fontWeightIndex':
              (drawable.style.fontWeight ?? FontWeight.normal).index,
        },
      };
    }
    return null;
  }

  // ===============================================
  // UI Build Method
  // ===============================================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = AppTranslations.of(context); // 【新增】

    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_rawErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${t.bodyMapLoadFailed}$_rawErrorMessage', // 【修改】
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _rawErrorMessage = null;
                });
                _initializeAndLoadPainter();
              },
              child: Text(t.retry), // 【修改】
            ),
          ],
        ),
      );
    }

    if (_controller == null || _backgroundImage == null) {
      return Center(child: Text(t.bodyMapInitFailed)); // 【修改】
    }

    return Container(
      color: const Color(0xFFE6F6FB),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: _backgroundImage!.width / _backgroundImage!.height,
                child: FlutterPainter(controller: _controller!),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 8,
            bottom: 50,
            child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: _controller!,
              builder: (context, _, __) => _buildVerticalToolbar(t), // 【修改】
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================
  // Helper Widgets
  // ===============================================
  Widget _buildVerticalToolbar(AppTranslations t) {
    // 【修改】
    return Container(
      width: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.pan_tool,
                color: _controller!.freeStyleMode == FreeStyleMode.none
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: () => setState(() {
                _controller!.freeStyleMode = FreeStyleMode.none;
              }),
              tooltip: t.moveZoom, // 【修改】
            ),
            IconButton(
              icon: Icon(
                Icons.brush,
                color: _controller!.freeStyleMode == FreeStyleMode.draw
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: () => setState(() {
                _controller!.freeStyleMode = FreeStyleMode.draw;
              }),
              tooltip: t.freeDraw, // 【修改】
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () => _controller!.addText(),
              tooltip: t.addText, // 【修改】
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _controller!.canUndo
                  ? () => _controller!.undo()
                  : null,
              tooltip: t.undo, // 【修改】
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _controller!.canRedo
                  ? () => _controller!.redo()
                  : null,
              tooltip: t.redo, // 【修改】
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: _controller!.freeStyleMode == FreeStyleMode.erase
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: () => setState(() {
                _controller!.freeStyleMode = FreeStyleMode.erase;
              }),
              tooltip: t.eraser, // 【修改】
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _showClearConfirmationDialog(t), // 【修改】
              tooltip: t.clearAllItems, // 【修改】
            ),
            const Divider(),
            _buildColorPicker(t), // 【修改】
            _buildStrokeWidthPicker(t), // 【修改】
            const Divider(),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _exportAsImage(t), // 【修改】
              tooltip: t.exportImage, // 【修改】
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmationDialog(AppTranslations t) {
    // 【修改】
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.confirmClearTitle), // 【修改】
        content: Text(t.confirmClearContent), // 【修改】
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel), // 【修改】
          ),
          TextButton(
            onPressed: () {
              _controller!.clearDrawables();
              Navigator.pop(context);
            },
            child: Text(
              t.confirm,
              style: const TextStyle(color: Colors.red),
            ), // 【修改】
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(AppTranslations t) {
    // 【修改】
    return PopupMenuButton<Color>(
      icon: Icon(
        Icons.color_lens,
        color: _controller!.settings.freeStyle.color,
      ),
      tooltip: t.color, // 【修改】
      onSelected: (color) {
        setState(() {
          _controller!.settings = _controller!.settings.copyWith(
            freeStyle: _controller!.settings.freeStyle.copyWith(color: color),
            text: _controller!.settings.text.copyWith(
              textStyle: _controller!.settings.text.textStyle.copyWith(
                color: color,
              ),
            ),
          );
        });
      },
      itemBuilder: (context) =>
          [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.black,
                Colors.orange,
                Colors.purple,
              ]
              .map(
                (color) => PopupMenuItem(
                  value: color,
                  child: Container(width: 100, height: 30, color: color),
                ),
              )
              .toList(),
    );
  }

  Widget _buildStrokeWidthPicker(AppTranslations t) {
    // 【修改】
    final strokeOptions = [
      {'value': 2.0, 'label': t.strokeThin},
      {'value': 4.0, 'label': t.strokeMedium},
      {'value': 6.0, 'label': t.strokeThick},
      {'value': 8.0, 'label': t.strokeExtraThick},
    ];

    return PopupMenuButton<double>(
      icon: const Icon(Icons.line_weight),
      tooltip: t.strokeWidth, // 【修改】
      onSelected: (width) => setState(() {
        _controller!.settings = _controller!.settings.copyWith(
          freeStyle: _controller!.settings.freeStyle.copyWith(
            strokeWidth: width,
          ),
        );
      }),
      itemBuilder: (context) => strokeOptions.map((opt) {
        return PopupMenuItem(
          value: opt['value'] as double,
          child: Text(opt['label'] as String),
        );
      }).toList(),
    );
  }

  Future<void> _exportAsImage(AppTranslations t) async {
    // 【修改】
    if (_controller == null || !mounted) return;
    try {
      final image = await _controller!.renderImage(
        Size(
          _backgroundImage!.width.toDouble(),
          _backgroundImage!.height.toDouble(),
        ),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.imageRenderedSuccess))); // 【修改】
      }
    } catch (e) {
      debugPrint("匯出圖片失敗: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${t.exportFailed}$e"))); // 【修改】
      }
    }
  }
}
