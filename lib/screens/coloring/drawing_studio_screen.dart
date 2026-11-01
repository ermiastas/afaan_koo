import 'dart:math' as math;

import 'package:flutter/material.dart';

enum DrawingTool {
  pencil,
  brush,
  crayon,
  marker,
  eraser,
  bucket,
  line,
  rectangle,
  circle,
  triangle,
}

enum DrawingElementType {
  stroke,
  line,
  rectangle,
  circle,
  triangle,
}

class DrawingElement {
  const DrawingElement({
    required this.type,
    required this.color,
    required this.width,
    this.points = const <Offset>[],
    this.start,
    this.end,
    this.filled = false,
  });

  final DrawingElementType type;
  final Color color;
  final double width;
  final List<Offset> points;
  final Offset? start;
  final Offset? end;
  final bool filled;

  DrawingElement copyWith({
    List<Offset>? points,
    Color? color,
    bool? filled,
  }) {
    return DrawingElement(
      type: type,
      color: color ?? this.color,
      width: width,
      points: points ?? this.points,
      start: start,
      end: end,
      filled: filled ?? this.filled,
    );
  }
}

class DrawingStudioScreen extends StatefulWidget {
  const DrawingStudioScreen({
    super.key,
    this.title = 'Suuraa Koo Kalaqi',
  });

  final String title;

  @override
  State<DrawingStudioScreen> createState() => _DrawingStudioScreenState();
}

class _DrawingStudioScreenState extends State<DrawingStudioScreen> {
  final List<DrawingElement> _elements = <DrawingElement>[];
  final List<DrawingElement> _redoStack = <DrawingElement>[];

  DrawingTool _tool = DrawingTool.brush;
  Color _color = Colors.red;
  double _strokeWidth = 8;
  Offset? _start;
  DrawingElement? _previewElement;
  bool _showColorPanel = false;

  static const List<Color> _colors = <Color>[
    Color(0xffF44336),
    Color(0xffFF7043),
    Color(0xffFFB300),
    Color(0xffFFEB3B),
    Color(0xff8BC34A),
    Color(0xff4CAF50),
    Color(0xff00BCD4),
    Color(0xff2196F3),
    Color(0xff3F51B5),
    Color(0xff9C27B0),
    Color(0xffE91E63),
    Color(0xff795548),
    Color(0xff424242),
    Color(0xff000000),
    Color(0xffffffff),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF7FF),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Undo',
            onPressed: _elements.isEmpty ? null : _undo,
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            tooltip: 'Redo',
            onPressed: _redoStack.isEmpty ? null : _redo,
            icon: const Icon(Icons.redo_rounded),
          ),
          IconButton(
            tooltip: 'Clear',
            onPressed: _elements.isEmpty ? null : _clear,
            icon: const Icon(Icons.delete_sweep_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _toolBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: ColoredBox(
                    color: Colors.white,
                    child: InteractiveViewer(
                      minScale: 0.6,
                      maxScale: 5,
                      boundaryMargin: const EdgeInsets.all(160),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (details) {
                              if (_tool == DrawingTool.bucket) {
                                _bucketTap(details.localPosition);
                              }
                            },
                            onPanStart: (details) {
                              _startDrawing(details.localPosition);
                            },
                            onPanUpdate: (details) {
                              _updateDrawing(details.localPosition);
                            },
                            onPanEnd: (_) {
                              _finishDrawing();
                            },
                            child: CustomPaint(
                              size: Size(
                                math.max(constraints.maxWidth, 320),
                                math.max(constraints.maxHeight, 320),
                              ),
                              painter: _DrawingPainter(
                                elements: _elements,
                                previewElement: _previewElement,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _colorPanel(),
            _sizePanel(),
          ],
        ),
      ),
    );
  }

  Widget _toolBar() {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            _toolButton(
              DrawingTool.pencil,
              Icons.edit_rounded,
              'Pencil',
            ),
            _toolButton(
              DrawingTool.brush,
              Icons.brush_rounded,
              'Brush',
            ),
            _toolButton(
              DrawingTool.crayon,
              Icons.colorize_rounded,
              'Crayon',
            ),
            _toolButton(
              DrawingTool.marker,
              Icons.border_color_rounded,
              'Marker',
            ),
            _toolButton(
              DrawingTool.bucket,
              Icons.format_color_fill_rounded,
              'Bucket',
            ),
            _toolButton(
              DrawingTool.eraser,
              Icons.auto_fix_off_rounded,
              'Eraser',
            ),
            const VerticalDivider(width: 8),
            _toolButton(
              DrawingTool.line,
              Icons.show_chart_rounded,
              'Line',
            ),
            _toolButton(
              DrawingTool.rectangle,
              Icons.crop_square_rounded,
              'Square',
            ),
            _toolButton(
              DrawingTool.circle,
              Icons.circle_outlined,
              'Circle',
            ),
            _toolButton(
              DrawingTool.triangle,
              Icons.change_history_rounded,
              'Triangle',
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolButton(
    DrawingTool tool,
    IconData icon,
    String label,
  ) {
    final selected = _tool == tool;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
      child: Material(
        color: selected
            ? Colors.deepOrange.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              _tool = tool;
              _previewElement = null;
              _start = null;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 25,
                  color: selected ? Colors.deepOrange : Colors.black87,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? Colors.deepOrange : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: _showColorPanel ? 64 : 0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.white),
      child: _showColorPanel
          ? ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                for (final color in _colors)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _color = color;
                        _showColorPanel = false;
                        if (_tool == DrawingTool.eraser) {
                          _tool = DrawingTool.brush;
                        }
                      });
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color.toARGB32() == color.toARGB32()
                              ? Colors.deepOrange
                              : Colors.grey.shade300,
                          width: _color.toARGB32() == color.toARGB32() ? 4 : 2,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _sizePanel() {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(
                  () => _showColorPanel = !_showColorPanel,
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.palette_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.line_weight_rounded),
              Expanded(
                child: Slider(
                  value: _strokeWidth,
                  min: 2,
                  max: 40,
                  divisions: 19,
                  label: '${_strokeWidth.round()}',
                  onChanged: (value) {
                    setState(() => _strokeWidth = value);
                  },
                ),
              ),
              Text(
                '${_strokeWidth.round()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Offset>? _findClosedLineRegion(Offset position) {
    final lines = _elements
        .where((element) =>
            element.type == DrawingElementType.line &&
            element.start != null &&
            element.end != null)
        .toList();

    if (lines.length < 3) return null;

    const tolerance = 18.0;
    final adjacency = <int, List<int>>{};

    bool near(Offset a, Offset b) => (a - b).distance <= tolerance;

    for (var i = 0; i < lines.length; i++) {
      adjacency[i] = <int>[];
      for (var j = 0; j < lines.length; j++) {
        if (i == j) continue;

        final a = lines[i];
        final b = lines[j];

        if (near(a.start!, b.start!) ||
            near(a.start!, b.end!) ||
            near(a.end!, b.start!) ||
            near(a.end!, b.end!)) {
          adjacency[i]!.add(j);
        }
      }
    }

    List<Offset>? trace(
      int current,
      int start,
      List<int> path,
      Set<int> used,
    ) {
      if (path.length > lines.length) return null;

      final element = lines[current];
      final currentEnd = element.end!;

      for (final next in adjacency[current]!) {
        if (next == start && path.length >= 3) {
          final closing = lines[next];
          final gap = math.min(
            (currentEnd - closing.start!).distance,
            (currentEnd - closing.end!).distance,
          );

          if (gap <= tolerance) {
            final points = <Offset>[];
            for (final index in path) {
              final line = lines[index];
              points.add(line.start!);
            }

            final center = points.fold<Offset>(
                  Offset.zero,
                  (sum, point) => sum + point,
                ) /
                points.length.toDouble();

            if (_pointInPolygon(position, points) ||
                _pointInPolygon(center, points)) {
              return points;
            }
          }
        }

        if (used.contains(next)) continue;

        final nextLine = lines[next];
        final connectsToEnd = near(currentEnd, nextLine.start!) ||
            near(currentEnd, nextLine.end!);

        if (!connectsToEnd) continue;

        final result = trace(
          next,
          start,
          <int>[...path, next],
          <int>{...used, next},
        );

        if (result != null && _pointInPolygon(position, result)) {
          return result;
        }
      }

      return null;
    }

    for (var start = 0; start < lines.length; start++) {
      final result = trace(
        start,
        start,
        <int>[start],
        <int>{start},
      );

      if (result != null) return result;
    }

    return null;
  }

  bool _pointInPolygon(Offset point, List<Offset> polygon) {
    if (polygon.length < 3) return false;

    var inside = false;

    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final a = polygon[i];
      final b = polygon[j];

      final crosses = ((a.dy > point.dy) != (b.dy > point.dy)) &&
          point.dx < (b.dx - a.dx) * (point.dy - a.dy) / (b.dy - a.dy) + a.dx;

      if (crosses) inside = !inside;
    }

    return inside;
  }

  void _bucketTap(Offset position) {
    final region = _findClosedLineRegion(position);
    if (region != null) {
      setState(() {
        _elements.add(
          DrawingElement(
            type: DrawingElementType.stroke,
            color: _color,
            width: 0,
            points: region,
            filled: true,
          ),
        );
        _redoStack.clear();
      });
      return;
    }

    for (var i = _elements.length - 1; i >= 0; i--) {
      final element = _elements[i];
      if (!element.filled && _hitTestElement(element, position)) {
        setState(() {
          _elements[i] = element.copyWith(color: _color, filled: true);
          _redoStack.clear();
        });
        return;
      }
    }
  }

  void _startDrawing(Offset position) {
    _start = position;

    if (_tool == DrawingTool.line ||
        _tool == DrawingTool.rectangle ||
        _tool == DrawingTool.circle ||
        _tool == DrawingTool.triangle) {
      setState(() {
        _previewElement = _makeShape(
          type: _tool,
          start: position,
          end: position,
        );
      });
      return;
    }

    final element = DrawingElement(
      type: DrawingElementType.stroke,
      color: _tool == DrawingTool.eraser ? Colors.transparent : _color,
      width: _effectiveWidth(),
      points: <Offset>[position],
    );

    setState(() {
      _elements.add(element);
      _redoStack.clear();
    });
  }

  void _updateDrawing(Offset position) {
    if (_start == null) return;

    if (_tool == DrawingTool.line ||
        _tool == DrawingTool.rectangle ||
        _tool == DrawingTool.circle ||
        _tool == DrawingTool.triangle) {
      setState(() {
        _previewElement = _makeShape(
          type: _tool,
          start: _start!,
          end: position,
        );
      });
      return;
    }

    if (_elements.isEmpty) return;

    final last = _elements.last;

    setState(() {
      _elements[_elements.length - 1] = last.copyWith(
        points: <Offset>[
          ...last.points,
          position,
        ],
      );
    });
  }

  void _finishDrawing() {
    if (_start == null) return;

    if (_previewElement != null) {
      setState(() {
        _elements.add(_previewElement!);
        _previewElement = null;
        _redoStack.clear();
      });
    }

    _start = null;
  }

  DrawingElement _makeShape({
    required DrawingTool type,
    required Offset start,
    required Offset end,
  }) {
    final elementType = switch (type) {
      DrawingTool.line => DrawingElementType.line,
      DrawingTool.rectangle => DrawingElementType.rectangle,
      DrawingTool.circle => DrawingElementType.circle,
      DrawingTool.triangle => DrawingElementType.triangle,
      _ => DrawingElementType.line,
    };

    return DrawingElement(
      type: elementType,
      color: _color,
      width: _effectiveWidth(),
      start: start,
      end: end,
    );
  }

  double _effectiveWidth() {
    return switch (_tool) {
      DrawingTool.pencil => _strokeWidth * 0.45,
      DrawingTool.brush => _strokeWidth,
      DrawingTool.crayon => _strokeWidth * 1.35,
      DrawingTool.marker => _strokeWidth * 1.8,
      DrawingTool.eraser => _strokeWidth * 2.5,
      _ => _strokeWidth,
    };
  }

  void _undo() {
    if (_elements.isEmpty) return;

    setState(() {
      _redoStack.add(_elements.removeLast());
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;

    setState(() {
      _elements.add(_redoStack.removeLast());
    });
  }

  void _clear() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Suuraa haquu?'),
          content: const Text(
            'Wanti ati kaaste hundi ni haqama.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Lakkii'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _elements.clear();
                  _redoStack.clear();
                  _previewElement = null;
                  _start = null;
                });
              },
              child: const Text('Eeyyee, haqi'),
            ),
          ],
        );
      },
    );
  }

  bool _hitTestElement(DrawingElement element, Offset position) {
    if (element.type == DrawingElementType.stroke) {
      final points = element.points;
      if (points.length < 3) return false;

      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      path.close();

      final gap = (points.first - points.last).distance;
      final maxGap = math.max(element.width * 3, 24);
      return gap <= maxGap && path.contains(position);
    }

    final start = element.start;
    final end = element.end;
    if (start == null || end == null) return false;

    switch (element.type) {
      case DrawingElementType.rectangle:
        return Rect.fromPoints(start, end)
            .inflate(element.width + 12)
            .contains(position);
      case DrawingElementType.circle:
        final radius = (end - start).distance / 2;
        final center = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
        return (position - center).distance <= radius + element.width + 12;
      case DrawingElementType.triangle:
        final left = math.min(start.dx, end.dx);
        final right = math.max(start.dx, end.dx);
        final top = math.min(start.dy, end.dy);
        final bottom = math.max(start.dy, end.dy);
        final path = Path()
          ..moveTo((left + right) / 2, top)
          ..lineTo(right, bottom)
          ..lineTo(left, bottom)
          ..close();
        return path.contains(position);
      case DrawingElementType.line:
      case DrawingElementType.stroke:
        return false;
    }
  }
}

class _DrawingPainter extends CustomPainter {
  const _DrawingPainter({
    required this.elements,
    required this.previewElement,
  });

  final List<DrawingElement> elements;
  final DrawingElement? previewElement;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, background);

    for (final element in elements) {
      _paintElement(canvas, element);
    }

    if (previewElement != null) {
      _paintElement(canvas, previewElement!);
    }
  }

  void _paintElement(
    Canvas canvas,
    DrawingElement element,
  ) {
    final isEraser = element.color.toARGB32() == Colors.transparent.toARGB32();

    final paint = Paint()
      ..color = isEraser ? Colors.white : element.color
      ..strokeWidth = element.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = element.filled && !isEraser
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..isAntiAlias = true;

    if (element.type == DrawingElementType.stroke) {
      _paintStroke(canvas, paint, element);
      return;
    }

    final start = element.start;
    final end = element.end;

    if (start == null || end == null) return;

    switch (element.type) {
      case DrawingElementType.line:
        canvas.drawLine(start, end, paint);
      case DrawingElementType.rectangle:
        canvas.drawRect(
          Rect.fromPoints(start, end),
          paint,
        );
      case DrawingElementType.circle:
        final radius = (end - start).distance / 2;
        final center = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );
        canvas.drawCircle(center, radius, paint);
      case DrawingElementType.triangle:
        final left = math.min(start.dx, end.dx);
        final right = math.max(start.dx, end.dx);
        final top = math.min(start.dy, end.dy);
        final bottom = math.max(start.dy, end.dy);

        final path = Path()
          ..moveTo((left + right) / 2, top)
          ..lineTo(right, bottom)
          ..lineTo(left, bottom)
          ..close();

        canvas.drawPath(path, paint);
      case DrawingElementType.stroke:
        break;
    }
  }

  void _paintStroke(
    Canvas canvas,
    Paint paint,
    DrawingElement element,
  ) {
    final points = element.points;

    if (points.isEmpty) return;

    if (points.length == 1) {
      canvas.drawCircle(
        points.first,
        element.width / 2,
        paint..style = PaintingStyle.fill,
      );
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var index = 1; index < points.length.toDouble(); index++) {
      final point = points[index];
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) {
    return oldDelegate.elements != elements ||
        oldDelegate.previewElement != previewElement;
  }
}

