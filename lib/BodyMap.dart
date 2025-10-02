// lib/BodyMapPage.dart
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeAndLoadPainter();
  }

  @override
  void dispose() {
    _controller?.dispose();
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

      // 讀取最新 BodyMap JSON
      final profile = await dao.getByVisitId(widget.visitId);
      dataModel.setBodyMap(profile?.bodyMapJson);
      debugPrint("📥 從 DB 讀取 JSON: ${dataModel.bodyMapJson}");

      final backgroundImage = await _loadBodyMapBackground();
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
      _controller!.background = backgroundImage.backgroundDrawable;

      // 準備還原 Drawables
      if (dataModel.bodyMapJson != null &&
          dataModel.bodyMapJson!.trim().isNotEmpty) {
        try {
          final List<dynamic> jsonData = jsonDecode(dataModel.bodyMapJson!);
          debugPrint("📝 JSON 解析數量: ${jsonData.length}");

          final drawables = <Drawable>[];

          for (var json in jsonData) {
            try {
              final d = _drawableFromJson(Map<String, dynamic>.from(json));
              if (d != null) {
                drawables.add(d);
                debugPrint("✅ 解析成功 Drawable: $d");
              } else {
                debugPrint("⚠️ Drawable 解析結果為 null: $json");
              }
            } catch (e) {
              debugPrint("❌ 解析單筆 Drawable 失敗: $json , 錯誤: $e");
            }
          }

          debugPrint("🎨 最終解析出的 drawables 數量: ${drawables.length}");

          if (drawables.isNotEmpty) {
            _controller!.addDrawables(drawables);
            debugPrint("✨ 成功加入到 Controller: ${drawables.length} 個");
          } else {
            debugPrint("⚠️ 沒有任何 Drawable 被還原到畫布");
          }
        } catch (e) {
          debugPrint("❌ 整體 JSON 解析失敗: $e");
        }
      } else {
        debugPrint("⚠️ bodyMapJson 為空，沒有任何圖可以還原");
      }

      setState(() => _loading = false);
    } catch (e) {
      debugPrint("載入 BodyMap 發生錯誤: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "載入圖片失敗: $e";
          _loading = false;
        });
      }
    }
  }

  Future<ui.Image> _loadBodyMapBackground() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 600, 1000), paint);
    paint
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final picture = recorder.endRecording();
    return await picture.toImage(600, 1000);
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

    if (_controller == null) return const Center(child: Text("無法載入繪圖板"));

    return Container(
      color: const Color(0xFFE6F6FB),
      child: Column(
        children: [
          ValueListenableBuilder<PainterControllerValue>(
            valueListenable: _controller!,
            builder: (context, _, __) => _buildToolbar(),
          ),
          Expanded(child: FlutterPainter(controller: _controller!)),
        ],
      ),
    );
  }

  // ===============================================
  // Helper Widgets
  // ===============================================
  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.brush,
              color: _controller!.freeStyleMode == FreeStyleMode.draw
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            onPressed: () =>
                setState(() => _controller!.freeStyleMode = FreeStyleMode.draw),
            tooltip: "自由繪圖",
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _controller!.addText(),
            tooltip: "新增文字",
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _controller!.canUndo ? () => _controller!.undo() : null,
            tooltip: "撤銷",
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _controller!.canRedo ? () => _controller!.redo() : null,
            tooltip: "重做",
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: _controller!.freeStyleMode == FreeStyleMode.erase
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            onPressed: () => setState(
              () => _controller!.freeStyleMode = FreeStyleMode.erase,
            ),
            tooltip: "橡皮擦",
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _showClearConfirmationDialog(),
            tooltip: "清除全部",
          ),
          const VerticalDivider(),
          _buildColorPicker(),
          _buildStrokeWidthPicker(),
          const VerticalDivider(),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportAsImage,
            tooltip: "匯出圖片",
          ),
        ],
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
      final image = await _controller!.renderImage(const Size(600, 1000));
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("圖片已匯出 (功能待實作)")));
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
