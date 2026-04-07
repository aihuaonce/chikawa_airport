import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';

/// BodyMapProvider - 快取狀態管理
/// 負責管理人形圖繪圖資料的快取狀態
class BodyMapProvider extends ChangeNotifier {
  String? _cachedJson;
  int? _currentMedicalId;
  bool _hasUnsavedChanges = false;

  String? get cachedJson => _cachedJson;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  void setMedicalId(int medicalId) {
    if (_currentMedicalId != medicalId) {
      _currentMedicalId = medicalId;
      _hasUnsavedChanges = false;
      _cachedJson = null;
    }
  }

  void updateCache(String? json) {
    if (_cachedJson != json) {
      _cachedJson = json;
      _hasUnsavedChanges = true;
      notifyListeners();
    }
  }

  void markAsSaved() {
    _hasUnsavedChanges = false;
  }

  void clear() {
    _cachedJson = null;
    _currentMedicalId = null;
    _hasUnsavedChanges = false;
    notifyListeners();
  }
}

/// AmbulanceBodyMap - 使用 FlutterPainter 重構的人形圖 Widget
class AmbulanceBodyMap extends StatefulWidget {
  final int medicalId;

  // === 新增：公開的 GlobalKey ===
  static final GlobalKey<_AmbulanceBodyMapState> globalKey =
      GlobalKey<_AmbulanceBodyMapState>();

  const AmbulanceBodyMap({super.key, required this.medicalId});

  @override
  State<AmbulanceBodyMap> createState() => _AmbulanceBodyMapState();
}

class _AmbulanceBodyMapState extends State<AmbulanceBodyMap> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color markerColor = Color(0xFFE53935);

  PainterController? _controller;
  bool _isLoading = true;
  String? _rawErrorMessage;
  ui.Image? _backgroundImage;
  bool _isSaving = false;
  bool get isLoading => _isLoading;

  BodyMapProvider? _bodyMapProvider;
  AppDatabase? _db;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bodyMapProvider = context.read<BodyMapProvider>();
    _db = context.read<AppDatabase>();
  }

  @override
  void initState() {
    super.initState();
    // initState runs before didChangeDependencies, so we need to get db here too
    _bodyMapProvider = context.read<BodyMapProvider>();
    _db = context.read<AppDatabase>();
    _initializeAndLoadPainter();
  }

  @override
  void dispose() {
    _saveToDatabase();
    _controller?.dispose();
    _backgroundImage?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AmbulanceBodyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.medicalId != widget.medicalId) {
      _saveToDatabase();
      _initializeAndLoadPainter();
    }
  }

  /// 儲存到資料庫（離開頁面時呼叫）
  Future<void> _saveToDatabase() async {
    if (_controller == null) return;

    try {
      final drawables = _controller!.drawables;
      final drawablesList = drawables
          .map((d) => _drawableToJson(d))
          .whereType<Map<String, dynamic>>()
          .toList();

      final jsonString = drawablesList.isEmpty
          ? null
          : jsonEncode(drawablesList);

      if (_db != null) {
        await _db!.ambulanceDao.updateBodyMap(widget.medicalId, jsonString);
      }

      _bodyMapProvider?.updateCache(jsonString);
      _bodyMapProvider?.markAsSaved();
    } catch (e) {
      debugPrint('儲存 BodyMap 到資料庫失敗: $e');
    }
  }

  /// 初始化並載入 Painter
  Future<void> _initializeAndLoadPainter() async {
    try {
      // 設定 Provider 的 medicalId
      _bodyMapProvider?.setMedicalId(widget.medicalId);

      final jsonStr = await _db?.ambulanceDao.getBodyMap(widget.medicalId);

      // 更新快取
      _bodyMapProvider?.updateCache(jsonStr);

      _backgroundImage = await _loadBodyMapBackground();
      if (!mounted) return;

      _controller = PainterController(
        settings: PainterSettings(
          freeStyle: FreeStyleSettings(color: markerColor, strokeWidth: 2),
          text: TextSettings(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );

      // 設定背景圖片
      _controller!.background = _backgroundImage!.backgroundDrawable;

      // 載入現有資料
      if (jsonStr != null &&
          jsonStr.isNotEmpty &&
          jsonStr != 'null' &&
          jsonStr != '[]') {
        _loadDrawablesFromJson(jsonStr);
      }

      // 設置監聽
      _setupControllerListener();

      // 使用 postFrameCallback 確保 controller 完全初始化後再觸發 rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _rawErrorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// 公開給報表頁面使用：把目前畫好的內容（背景 + 所有筆跡）渲染成圖片
  Future<Uint8List?> renderToImage() async {
    if (_controller == null) return null;

    try {
      // 使用較高解析度，讓筆跡更清楚
      final ui.Image renderedImage = await _controller!.renderImage(
        const Size(1000, 1400),
      );

      final ByteData? byteData = await renderedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('BodyMap 渲染失敗: $e');
      return null;
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

      final drawablesList = drawables
          .map((d) => _drawableToJson(d))
          .whereType<Map<String, dynamic>>()
          .toList();

      final jsonString = drawablesList.isEmpty
          ? null
          : jsonEncode(drawablesList);

      // 更新本地快取
      if (mounted) {
        _bodyMapProvider?.updateCache(jsonString);
      }
    } catch (e) {
      debugPrint('更新 BodyMap 資料失敗: $e');
    }
  }

  /// 儲存到資料庫
  Future<void> saveData() async {
    if (_controller == null || _isSaving) {
      return;
    }

    if (!mounted) return;

    _isSaving = true;
    if (!mounted) return;

    try {
      final drawables = _controller!.drawables;
      String? jsonString;

      if (drawables.isNotEmpty) {
        final drawablesList = drawables
            .map((d) => _drawableToJson(d))
            .whereType<Map<String, dynamic>>()
            .toList();
        jsonString = jsonEncode(drawablesList);
      }

      await _db?.ambulanceDao.updateBodyMap(widget.medicalId, jsonString);

      // 更新 Provider 狀態
      _bodyMapProvider?.updateCache(jsonString);
      _bodyMapProvider?.markAsSaved();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('BodyMap 儲存成功'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BodyMap 儲存失敗: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      _isSaving = false;
    }
  }

  /// 儲存到快取（切換頁面時呼叫）
  void _saveToCache() {
    if (_controller == null) return;

    try {
      final drawables = _controller!.drawables;
      final drawablesList = drawables
          .map((d) => _drawableToJson(d))
          .whereType<Map<String, dynamic>>()
          .toList();

      final jsonString = drawablesList.isEmpty
          ? null
          : jsonEncode(drawablesList);
    } catch (e) {
      // Silent fail for cache updates
    }
  }

  Future<ui.Image> _loadBodyMapBackground() async {
    const String imagePath = 'assets/images/body_diagram_placeholder.jpg';
    final ByteData data = await rootBundle.load(imagePath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
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
          final color = Color(json['color'] as int? ?? markerColor.value);
          final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 2.0;
          return FreeStyleDrawable(
            path: points,
            color: color,
            strokeWidth: strokeWidth,
          );

        case 'TextDrawable':
          final text = json['text'] as String? ?? '';
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
      debugPrint('解析 drawable 失敗: $json , 錯誤: $e');
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_rawErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '載入失敗: $_rawErrorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _rawErrorMessage = null;
                });
                _initializeAndLoadPainter();
              },
              child: const Text('重試'),
            ),
          ],
        ),
      );
    }

    if (_controller == null || _backgroundImage == null) {
      return const Center(child: Text('初始化失敗'));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 側邊工具列
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: _buildVerticalToolbar(),
        ),
        // 主畫面
        Expanded(
          child: Column(
            children: [
              // Canvas
              Expanded(child: _buildBodyCanvas()),
              // 底部動作按鈕
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalToolbar() {
    return Container(
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // 平移/縮放
          IconButton(
            icon: Icon(
              Icons.open_with,
              color: _controller?.freeStyleMode == FreeStyleMode.none
                  ? primaryColor
                  : textMuted,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _controller?.freeStyleMode = FreeStyleMode.none;
              });
            },
            tooltip: '平移/縮放',
          ),
          // 自由繪圖
          IconButton(
            icon: Icon(
              Icons.brush,
              color: _controller?.freeStyleMode == FreeStyleMode.draw
                  ? primaryColor
                  : textMuted,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _controller?.freeStyleMode = FreeStyleMode.draw;
              });
            },
            tooltip: '自由繪圖',
          ),
          // 新增文字
          IconButton(
            icon: const Icon(Icons.text_fields, size: 22),
            onPressed: () {
              setState(() {
                _controller?.freeStyleMode = FreeStyleMode.none;
              });
              _controller?.addText();
            },
            tooltip: '新增文字',
          ),
          const Divider(height: 16, indent: 8, endIndent: 8),
          // 復原
          IconButton(
            icon: Icon(
              Icons.undo,
              size: 22,
              color: _controller?.canUndo == true
                  ? textDark
                  : textMuted.withValues(alpha: 0.3),
            ),
            onPressed: _controller?.canUndo == true
                ? () => _controller?.undo()
                : null,
            tooltip: '復原',
          ),
          // 重做
          IconButton(
            icon: Icon(
              Icons.redo,
              size: 22,
              color: _controller?.canRedo == true
                  ? textDark
                  : textMuted.withValues(alpha: 0.3),
            ),
            onPressed: _controller?.canRedo == true
                ? () => _controller?.redo()
                : null,
            tooltip: '重做',
          ),
          const Divider(height: 16, indent: 8, endIndent: 8),
          // 顏色選擇
          _buildColorPicker(),
          // 清除
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 22,
              color: Colors.red.shade400,
            ),
            onPressed: _showClearConfirmationDialog,
            tooltip: '清除全部',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return PopupMenuButton<Color>(
      icon: Icon(
        Icons.color_lens,
        color: _controller?.settings.freeStyle.color ?? markerColor,
        size: 20,
      ),
      tooltip: '顏色',
      onSelected: (color) {
        setState(() {
          _controller?.settings = _controller!.settings.copyWith(
            freeStyle: _controller!.settings.freeStyle.copyWith(color: color),
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

  Widget _buildBodyCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final imageWidth = _backgroundImage!.width.toDouble();
        final imageHeight = _backgroundImage!.height.toDouble();

        return Center(
          child: SizedBox(
            width: canvasWidth,
            height: constraints.maxHeight,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(50),
              minScale: 0.5,
              maxScale: 4.0,
              panEnabled: _controller?.freeStyleMode == FreeStyleMode.none,
              scaleEnabled: _controller?.freeStyleMode == FreeStyleMode.none,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: FlutterPainter(controller: _controller!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 儲存按鈕
          SizedBox(
            width: 100,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : saveData,
              icon: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, size: 16),
              label: Text(
                _isSaving ? '儲存中' : '儲存',
                style: const TextStyle(fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('清除確認'),
        content: const Text('確定要清除所有繪圖嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _controller?.clearDrawables();
              _updateBodyMapData();
              Navigator.pop(dialogContext);
            },
            child: const Text('確認', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
