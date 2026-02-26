import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';

class AmbulanceBodyMap extends StatefulWidget {
  final int medicalId;

  const AmbulanceBodyMap({super.key, required this.medicalId});

  @override
  State<AmbulanceBodyMap> createState() => _AmbulanceBodyMapState();
}

class _AmbulanceBodyMapState extends State<AmbulanceBodyMap> {
  PainterController? _controller;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePainter();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializePainter() async {
    try {
      final db = context.read<AppDatabase>();
      final bodyMapJson = await db.ambulanceDao.getBodyMap(widget.medicalId);

      _controller = PainterController(
        settings: PainterSettings(
          freeStyle: FreeStyleSettings(color: Colors.red, strokeWidth: 2),
          text: TextSettings(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );

      if (bodyMapJson != null &&
          bodyMapJson.isNotEmpty &&
          bodyMapJson != 'null') {
        _loadDrawablesFromJson(bodyMapJson);
      }

      _setupControllerListener();

      if (mounted) {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
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
    if (_controller == null || !mounted) return;

    final drawables = _controller!.drawables;

    final drawablesList = drawables
        .map((d) => _drawableToJson(d))
        .whereType<Map<String, dynamic>>()
        .toList();

    final jsonString = drawablesList.isEmpty ? null : jsonEncode(drawablesList);

    _saveToDatabase(jsonString);
  }

  Future<void> _saveToDatabase(String? jsonString) async {
    try {
      final db = context.read<AppDatabase>();
      await db.ambulanceDao.updateBodyMap(widget.medicalId, jsonString);
    } catch (e) {
      debugPrint('儲存身體地圖失敗: $e');
    }
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
          debugPrint('解析單筆 Drawable 失敗: $e');
        }
      }

      if (drawables.isNotEmpty) {
        _controller!.addDrawables(drawables);
      }
    } catch (e) {
      debugPrint('JSON 解析失敗: $e');
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
          return null;
      }
    } catch (e) {
      debugPrint('解析 drawable 失敗: $json, 錯誤: $e');
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '載入失敗: $_errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => _loading = true);
                _initializePainter();
              },
              child: const Text('重試'),
            ),
          ],
        ),
      );
    }

    if (_controller == null) {
      return const Center(child: Text('初始化失敗'));
    }

    final bool isDrawing = _controller!.freeStyleMode == FreeStyleMode.draw;

    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  width: constraints.maxWidth * 0.95,
                  height: constraints.maxHeight * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    physics: isDrawing
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 3.0,
                      panEnabled: !isDrawing,
                      scaleEnabled: !isDrawing,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.95,
                        height: constraints.maxHeight * 0.9,
                        child: FlutterPainter(controller: _controller!),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 16,
          left: 8,
          bottom: 16,
          child: ValueListenableBuilder<PainterControllerValue>(
            valueListenable: _controller!,
            builder: (context, _, __) => _buildToolbar(),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      width: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
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
                Icons.open_with,
                color: _controller!.freeStyleMode == FreeStyleMode.none
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: () {
                setState(() {
                  _controller!.freeStyleMode = FreeStyleMode.none;
                });
              },
              tooltip: '平移/縮放',
            ),
            IconButton(
              icon: Icon(
                Icons.brush,
                color: _controller!.freeStyleMode == FreeStyleMode.draw
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: () {
                setState(() {
                  _controller!.freeStyleMode = FreeStyleMode.draw;
                });
              },
              tooltip: '繪圖',
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () {
                setState(() {
                  _controller!.freeStyleMode = FreeStyleMode.none;
                });
                _controller!.addText();
              },
              tooltip: '新增文字',
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _controller!.canUndo
                  ? () => _controller!.undo()
                  : null,
              tooltip: '復原',
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _controller!.canRedo
                  ? () => _controller!.redo()
                  : null,
              tooltip: '重做',
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _showClearConfirmationDialog(),
              tooltip: '清除全部',
            ),
            _buildColorPicker(),
            _buildStrokeWidthPicker(),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認清除'),
        content: const Text('確定要清除所有筆跡和文字嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _controller!.clearDrawables();
              _updateBodyMapData();
              Navigator.pop(context);
            },
            child: const Text('確認', style: TextStyle(color: Colors.red)),
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
      tooltip: '顏色',
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
    final List<Map<String, dynamic>> strokeOptions = [
      {'value': 2.0, 'label': '細'},
      {'value': 4.0, 'label': '中'},
      {'value': 6.0, 'label': '粗'},
      {'value': 8.0, 'label': '特粗'},
    ];

    return PopupMenuButton<double>(
      icon: const Icon(Icons.line_weight),
      tooltip: '線條粗細',
      onSelected: (width) => setState(() {
        if (_controller != null) {
          _controller!.settings = _controller!.settings.copyWith(
            freeStyle: _controller!.settings.freeStyle.copyWith(
              strokeWidth: width,
            ),
          );
        }
      }),
      itemBuilder: (context) => strokeOptions
          .map(
            (opt) => PopupMenuItem<double>(
              value: opt['value'] as double,
              child: Text(opt['label'] as String),
            ),
          )
          .toList(),
    );
  }
}
