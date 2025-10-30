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
import 'l10n/app_translations.dart';
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
  String? _rawErrorMessage;
  ui.Image? _backgroundImage;
  bool _isSaving = false;

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

  // ===============================================
  // SavableStateMixin 介面實作 - nav5 會調用這個方法
  // ===============================================
  @override
  Future<void> saveData() async {
    if (_controller == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    if (_isSaving) {
      return;
    }

    _isSaving = true;
    final t = AppTranslations.of(context);

    try {
      final drawables = _controller!.drawables;

      if (drawables.isEmpty) {
        _isSaving = false;
        return;
      }

      final drawablesList = drawables
          .map((d) => _drawableToJson(d))
          .whereType<Map<String, dynamic>>()
          .toList();

      final jsonString = jsonEncode(drawablesList);

      final dao = context.read<PatientProfilesDao>();
      debugPrint("開始寫入資料庫，visitId: ${widget.visitId}");

      await dao.upsertBodyMap(widget.visitId, jsonString);

      debugPrint("BodyMap 資料庫寫入完成");

      // 更新本地狀態
      final dataModel = context.read<BodyMapData>();
      dataModel.setBodyMap(jsonString);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BodyMap ${t.saveSuccess}'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint("Stack trace: $stackTrace");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BodyMap ${t.saveFailed}: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      rethrow;
    } finally {
      _isSaving = false;
    }
  }

  // ===============================================
  // 初始化與載入邏輯
  // ===============================================
  Future<void> _initializeAndLoadPainter() async {
    try {
      final bodyMapData = context.read<BodyMapData>();
      final dao = context.read<PatientProfilesDao>();

      // 從資料庫載入最新資料
      final profile = await dao.getByVisitId(widget.visitId);

      // 【修正】正確檢查資料是否存在
      final hasBodyMapData =
          profile?.bodyMapJson != null &&
          profile?.bodyMapJson != "null" &&
          profile?.bodyMapJson != "[]";

      if (hasBodyMapData) {
        bodyMapData.setBodyMap(profile?.bodyMapJson, visitId: widget.visitId);
      } else {
        bodyMapData.setBodyMap(null, visitId: widget.visitId);
      }

      _backgroundImage = await _loadBodyMapBackground();
      if (!mounted) return;

      _controller = PainterController(
        settings: PainterSettings(
          freeStyle: FreeStyleSettings(color: Colors.red, strokeWidth: 4),
          text: TextSettings(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );

      _controller!.background = _backgroundImage!.backgroundDrawable;

      // 載入現有資料
      if (hasBodyMapData) {
        _loadDrawablesFromJson(profile!.bodyMapJson!);
      } else {}

      setState(() => _loading = false);

      // 初始化完成後設置監聽
      _setupControllerListener();
    } catch (e) {
      if (mounted) {
        setState(() {
          _rawErrorMessage = e.toString();
          _loading = false;
        });
      }
    }
  }

  void _setupControllerListener() {
    _controller?.addListener(() {
      if (mounted && _controller != null) {
        _updateBodyMapData();
      }
    });
  }

  void _updateBodyMapData() {
    try {
      if (_controller == null || !mounted) return;

      final drawables = _controller!.drawables;

      // 如果沒有繪圖內容,清除資料
      if (drawables.isEmpty) {
        context.read<BodyMapData>().setBodyMap(null, visitId: widget.visitId);
        return;
      }

      // 轉換並儲存
      final drawablesList = drawables
          .map((d) => _drawableToJson(d))
          .whereType<Map<String, dynamic>>()
          .toList();

      final jsonString = jsonEncode(drawablesList);
      context.read<BodyMapData>().setBodyMap(
        jsonString,
        visitId: widget.visitId,
      );
    } catch (e) {}
  }

  void _loadDrawablesFromJson(String jsonString) {
    try {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final drawables = <Drawable>[];

      for (var json in jsonData) {
        try {
          final d = _drawableFromJson(Map<String, dynamic>.from(json));
          if (d != null) drawables.add(d);
        } catch (e) {
          debugPrint("解析單筆 Drawable 失敗: $e");
        }
      }

      if (drawables.isNotEmpty) {
        _controller!.addDrawables(drawables);
      }
    } catch (e) {
      debugPrint("JSON 解析失敗: $e");
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

  // ===============================================
  // JSON 序列化/反序列化
  // ===============================================
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
    final t = AppTranslations.of(context);

    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_rawErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${t.bodyMapLoadFailed}$_rawErrorMessage',
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
              child: Text(t.retry),
            ),
          ],
        ),
      );
    }

    if (_controller == null || _backgroundImage == null) {
      return Center(child: Text(t.bodyMapInitFailed));
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
              builder: (context, _, __) => _buildVerticalToolbar(t),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================
  // Helper Widgets - 只有繪圖工具，沒有儲存按鈕
  // ===============================================
  Widget _buildVerticalToolbar(AppTranslations t) {
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
              tooltip: t.moveZoom,
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
              tooltip: t.freeDraw,
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () => _controller!.addText(),
              tooltip: t.addText,
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _controller!.canUndo
                  ? () => _controller!.undo()
                  : null,
              tooltip: t.undo,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _controller!.canRedo
                  ? () => _controller!.redo()
                  : null,
              tooltip: t.redo,
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
              tooltip: t.eraser,
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _showClearConfirmationDialog(t),
              tooltip: t.clearAllItems,
            ),
            const Divider(),
            _buildColorPicker(t),
            _buildStrokeWidthPicker(t),
            const Divider(),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _exportAsImage(t),
              tooltip: t.exportImage,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmationDialog(AppTranslations t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.confirmClearTitle),
        content: Text(t.confirmClearContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              _controller!.clearDrawables();
              Navigator.pop(context);
            },
            child: Text(t.confirm, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(AppTranslations t) {
    return PopupMenuButton<Color>(
      icon: Icon(
        Icons.color_lens,
        color: _controller!.settings.freeStyle.color,
      ),
      tooltip: t.color,
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
    final strokeOptions = [
      {'value': 2.0, 'label': t.strokeThin},
      {'value': 4.0, 'label': t.strokeMedium},
      {'value': 6.0, 'label': t.strokeThick},
      {'value': 8.0, 'label': t.strokeExtraThick},
    ];

    return PopupMenuButton<double>(
      icon: const Icon(Icons.line_weight),
      tooltip: t.strokeWidth,
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
        ).showSnackBar(SnackBar(content: Text(t.imageRenderedSuccess)));
      }
    } catch (e) {
      debugPrint("匯出圖片失敗: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${t.exportFailed}$e")));
      }
    }
  }
}
