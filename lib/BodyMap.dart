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
  String? _errorMessage;
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
      _errorMessage = null;
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
    if (_controller == null) return;

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

      // 先寫入資料庫
      final dao = context.read<PatientProfilesDao>();
      await dao.upsertBodyMap(widget.visitId, jsonString);

      // 再從資料庫讀回來確保同步
      final profile = await dao.getByVisitId(widget.visitId);
      final dataModel = context.read<BodyMapData>();
      dataModel.setBodyMap(profile?.bodyMapJson);

      debugPrint("✅ 儲存並重新讀取 BodyMap: ${dataModel.bodyMapJson}");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("人形圖儲存成功")));
      }
    } catch (e) {
      debugPrint("儲存 BodyMap 發生錯誤: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("儲存失敗: $e")));
      }
    }
  }

  // ===============================================
  // 資料與繪圖板處理邏輯
  // ===============================================
  Future<void> _initializeAndLoadPainter() async {
    try {
      final dataModel = context.read<BodyMapData>();
      final dao = context.read<PatientProfilesDao>();

      final profile = await dao.getByVisitId(widget.visitId);
      dataModel.setBodyMap(profile?.bodyMapJson);

      _backgroundImage = await _loadBodyMapBackground();

      if (!mounted) return;

      _controller = PainterController(
        settings: PainterSettings(
          text: TextSettings(
            focusNode: FocusNode(),
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          freeStyle: const FreeStyleSettings(color: Colors.red, strokeWidth: 3),
          scale: const ScaleSettings(enabled: true, minScale: 1, maxScale: 5),
        ),
      );
      _controller!.background = _backgroundImage!.backgroundDrawable;

      if (dataModel.bodyMapJson != null &&
          dataModel.bodyMapJson!.trim().isNotEmpty) {
        // ...
      } else {}

      setState(() {
        _loading = false;
      });
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _errorMessage = "無法載入人形圖資源: $e"; // 顯示更精確的錯誤訊息
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
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _errorMessage = null;
                });
                _initializeAndLoadPainter();
              },
              child: const Text("重試"),
            ),
          ],
        ),
      );
    }

    if (_controller == null || _backgroundImage == null) {
      return const Center(child: Text("無法初始化繪圖板資源，請重試。"));
    }

    return Container(
      color: const Color(0xFFE6F6FB),
      child: Stack(
        children: [
          // 🎨 放大一點點的繪圖板
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: _backgroundImage!.width / _backgroundImage!.height,
                child: FlutterPainter(controller: _controller!),
              ),
            ),
          ),

          // 🧰 懸浮在左邊的垂直工具列
          Positioned(
            top: 50,
            left: 8,
            bottom: 50,
            child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: _controller!,
              builder: (context, _, __) => _buildVerticalToolbar(),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================
  // Helper Widgets
  // ===============================================
  Widget _buildVerticalToolbar() {
    return Container(
      width: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2), // 陰影往右下
          ),
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
              tooltip: "移動 / 縮放",
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
              tooltip: "自由繪圖",
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () => _controller!.addText(),
              tooltip: "新增文字",
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _controller!.canUndo
                  ? () => _controller!.undo()
                  : null,
              tooltip: "撤銷",
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _controller!.canRedo
                  ? () => _controller!.redo()
                  : null,
              tooltip: "重做",
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
              tooltip: "橡皮擦",
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _showClearConfirmationDialog,
              tooltip: "清除全部",
            ),
            const Divider(),
            _buildColorPicker(),
            _buildStrokeWidthPicker(),
            const Divider(),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportAsImage,
              tooltip: "匯出圖片",
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("確認清除"),
        content: const Text("確定要清除所有繪圖嗎?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              _controller!.clearDrawables();
              Navigator.pop(context);
            },
            child: const Text("確定", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return PopupMenuButton<Color>(
      icon: Icon(
        Icons.color_lens,
        color: _controller!.settings.freeStyle.color,
      ),
      tooltip: "顏色",
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

  Widget _buildStrokeWidthPicker() {
    return PopupMenuButton<double>(
      icon: const Icon(Icons.line_weight),
      tooltip: "筆刷粗細",
      onSelected: (width) => setState(() {
        _controller!.settings = _controller!.settings.copyWith(
          freeStyle: _controller!.settings.freeStyle.copyWith(
            strokeWidth: width,
          ),
        );
      }),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 2.0, child: Text("細")),
        const PopupMenuItem(value: 4.0, child: Text("中")),
        const PopupMenuItem(value: 6.0, child: Text("粗")),
        const PopupMenuItem(value: 8.0, child: Text("特粗")),
      ],
    );
  }

  Future<void> _exportAsImage() async {
    if (_controller == null) return;
    try {
      // 確保使用背景圖的實際大小來渲染
      final image = await _controller!.renderImage(
        Size(
          _backgroundImage!.width.toDouble(),
          _backgroundImage!.height.toDouble(),
        ),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // 這裡您可以實作儲存檔案或分享的功能
      // 例如：使用 `image_gallery_saver` 或 `share_plus` 套件

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("圖片已成功渲染 (待儲存)")));
      }
    } catch (e) {
      debugPrint("匯出圖片失敗: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("匯出失敗: $e")));
      }
    }
  }
}
