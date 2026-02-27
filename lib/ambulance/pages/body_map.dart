import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/db/database.dart';

class BodyMarker {
  final String id;
  double x;
  double y;
  String description;

  BodyMarker({
    required this.id,
    required this.x,
    required this.y,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'description': description,
  };

  factory BodyMarker.fromJson(Map<String, dynamic> json) => BodyMarker(
    id: json['id'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    description: json['description'] as String,
  );
}

class AmbulanceBodyMap extends StatefulWidget {
  final int medicalId;

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

  List<BodyMarker> _markers = [];
  bool _isLoading = true;
  Size? _canvasSize;
  BodyMarker? _editingMarker;
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = context.read<AppDatabase>();
    final jsonStr = await db.ambulanceDao.getBodyMap(widget.medicalId);

    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final Map<String, dynamic> data = json.decode(jsonStr);
        final markerList =
            (data['markers'] as List<dynamic>?)
                ?.map((e) => BodyMarker.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        setState(() {
          _markers = markerList;
        });
      } catch (e) {
        debugPrint('Error parsing body map JSON: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final db = context.read<AppDatabase>();
    final Map<String, dynamic> data = {
      'markers': _markers.map((m) => m.toJson()).toList(),
    };
    await db.ambulanceDao.updateBodyMap(widget.medicalId, json.encode(data));
  }

  void _onMarkerTap(BodyMarker marker) {
    _showMarkerDetailDialog(marker);
  }

  void _showAddDescriptionDialog(double x, double y) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 0,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_location_alt_outlined,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          '新增標記',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                      color: textMuted,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notes, size: 14, color: textMuted),
                        SizedBox(width: 6),
                        Text(
                          '症狀描述',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'SYMPTOM',
                          style: TextStyle(fontSize: 11, color: textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '輸入症狀描述...',
                        hintStyle: TextStyle(
                          color: textMuted.withValues(alpha: 0.4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: borderColor)),
                  color: Color(0xFFF8FAFC),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        foregroundColor: textMuted,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('取消 Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        final description = controller.text.trim();
                        final marker = BodyMarker(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          x: x,
                          y: y,
                          description: description,
                        );
                        setState(() {
                          _markers.add(marker);
                        });
                        _saveData();
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text(
                        '確認',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMarkerDetailDialog(BodyMarker marker) {
    final editController = TextEditingController(text: marker.description);
    bool isEditing = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: markerColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: markerColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            isEditing ? '編輯標記' : '標記詳情',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(dialogContext),
                        color: textMuted,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notes, size: 14, color: textMuted),
                          SizedBox(width: 6),
                          Text(
                            '症狀描述',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'SYMPTOM',
                            style: TextStyle(fontSize: 11, color: textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (isEditing)
                        TextField(
                          controller: editController,
                          autofocus: true,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Text(
                            marker.description.isEmpty
                                ? '（無描述）'
                                : marker.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: marker.description.isEmpty
                                  ? textMuted
                                  : textDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                    color: Color(0xFFF8FAFC),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isEditing) ...[
                        TextButton(
                          onPressed: () =>
                              setDialogState(() => isEditing = false),
                          style: TextButton.styleFrom(
                            foregroundColor: textMuted,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('取消 Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              marker.description = editController.text.trim();
                            });
                            _saveData();
                            Navigator.pop(dialogContext);
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: const Text(
                            '儲存',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () =>
                              setDialogState(() => isEditing = true),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text(
                            '編輯',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: const BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: dialogContext,
                              builder: (confirmContext) => Dialog(
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 0,
                                child: SizedBox(
                                  width: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(
                                                  alpha: 0.1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.warning_amber_rounded,
                                                color: Colors.red,
                                                size: 32,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              '刪除確認',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textDark,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              '確定要刪除此標記嗎？',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: borderColor),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () => Navigator.pop(
                                                  confirmContext,
                                                ),
                                                child: const Text('取消'),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(confirmContext);
                                                  setState(() {
                                                    _markers.removeWhere(
                                                      (m) => m.id == marker.id,
                                                    );
                                                  });
                                                  _saveData();
                                                  Navigator.pop(dialogContext);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text('刪除'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text(
                            '刪除',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 0,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          '清除確認',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                      color: textMuted,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '確定要清除所有標記嗎？',
                  style: TextStyle(fontSize: 14, color: textMuted),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: borderColor)),
                  color: Color(0xFFF8FAFC),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        foregroundColor: textMuted,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('取消 Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _markers.clear();
                        });
                        _saveData();
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.delete_forever, size: 18),
                      label: const Text(
                        '清除全部',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBodyCanvas(),
        const SizedBox(height: 16),
        _buildMarkerCount(),
        const SizedBox(height: 24),
        _buildClearButton(),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildBodyCanvas() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasWidth = constraints.maxWidth;
            final canvasHeight = canvasWidth * 1.2;
            _canvasSize = Size(canvasWidth, canvasHeight);

            return SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/body_diagram_placeholder.jpg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '找不到人形圖圖片',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ..._buildMarkerWidgets(canvasWidth, canvasHeight),
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapUp: (details) => _handleTap(
                        details.localPosition,
                        Size(canvasWidth, canvasHeight),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildMarkerWidgets(double width, double height) {
    return _markers.asMap().entries.map((entry) {
      final index = entry.key;
      final marker = entry.value;
      return Positioned(
        left: marker.x * width - 24,
        top: marker.y * height - 24,
        child: GestureDetector(
          onTap: () => _onMarkerTap(marker),
          onPanUpdate: (details) {
            final newX = (marker.x * width + details.delta.dx) / width;
            final newY = (marker.y * height + details.delta.dy) / height;

            if (newX >= 0 && newX <= 1 && newY >= 0 && newY <= 1) {
              setState(() {
                marker.x = newX;
                marker.y = newY;
              });
            }
          },
          onPanEnd: (details) {
            _saveData();
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _handleTap(Offset position, Size canvasSize) {
    final x = position.dx / canvasSize.width;
    final y = position.dy / canvasSize.height;

    for (final marker in _markers) {
      final markerX = marker.x;
      final markerY = marker.y;
      final distance =
          ((x - markerX) * (x - markerX) + (y - markerY) * (y - markerY));
      if (distance < 0.002) {
        _onMarkerTap(marker);
        return;
      }
    }

    if (x >= 0 && x <= 1 && y >= 0 && y <= 1) {
      _showAddDescriptionDialog(x, y);
    }
  }

  Widget _buildMarkerCount() {
    final count = _markers.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: count > 0
                      ? primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '已標示: $count 處',
                  style: TextStyle(
                    color: count > 0 ? primaryColor : textMuted,
                    fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          if (count > 0) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: borderColor),
            const SizedBox(height: 12),
            const Text(
              '標記內容',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _markers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final marker = _markers[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            marker.description.isEmpty
                                ? '（無描述）'
                                : marker.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: marker.description.isEmpty
                                  ? textMuted
                                  : textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _clearAll,
        icon: const Icon(Icons.delete_forever, size: 18),
        label: const Text('清除全部'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade400,
          side: BorderSide(color: Colors.red.shade200),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
