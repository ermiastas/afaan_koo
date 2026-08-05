import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/brush_type.dart';
import '../../models/drawing_point.dart';
import '../../models/paint_mode.dart';
import '../../providers/reward_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/paint/brush_picker.dart';
import '../../widgets/paint/color_picker.dart';
import '../../widgets/paint/drawing_canvas.dart';
import '../../widgets/paint/paint_toolbar.dart';
import '../../widgets/paint/sticker_picker.dart';
import 'gallery_screen.dart';

class PaintCanvasScreen extends StatefulWidget {
  const PaintCanvasScreen({super.key, this.selectedSticker});

  final String? selectedSticker;

  @override
  State<PaintCanvasScreen> createState() => _PaintCanvasScreenState();
}

class _PaintCanvasScreenState extends State<PaintCanvasScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final List<List<DrawingPoint>> _strokes = [];
  final List<List<DrawingPoint>> _redoStrokes = [];

  String? _selectedSticker;
  Color _selectedColor = Colors.red;
  Color _canvasColor = Colors.white;
  double _brushSize = 8;
  BrushType _selectedBrush = BrushType.normal;
  PaintMode _selectedMode = PaintMode.brush;
  bool _isSaving = false;

  static const _paintColors = <Color>[
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.deepPurple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.black,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _selectedSticker = widget.selectedSticker;
  }

  List<DrawingPoint?> get _points {
    final points = <DrawingPoint?>[];
    for (final stroke in _strokes) {
      points.addAll(stroke);
      points.add(null);
    }
    return points;
  }

  void _startStroke(Offset position) {
    if (_selectedMode == PaintMode.bucket) {
      setState(() {
        _canvasColor = _selectedColor;
        _redoStrokes.clear();
      });
      return;
    }

    if (_selectedMode == PaintMode.sticker) {
      final sticker = _selectedSticker ?? '\u{2B50}';
      setState(() {
        _strokes.add([
          DrawingPoint(
            offset: position,
            paint: Paint()..color = Colors.transparent,
            mode: PaintMode.sticker,
            sticker: sticker,
          ),
        ]);
        _redoStrokes.clear();
      });
      return;
    }

    setState(() {
      _strokes.add([_newPoint(position)]);
      _redoStrokes.clear();
    });
  }

  void _extendStroke(Offset position) {
    if (_strokes.isEmpty ||
        _selectedMode == PaintMode.bucket ||
        _selectedMode == PaintMode.sticker) {
      return;
    }
    final stroke = _strokes.last;
    if (stroke.isNotEmpty && (stroke.last.offset - position).distance < 1.5) {
      return;
    }
    setState(() => stroke.add(_newPoint(position)));
  }

  DrawingPoint _newPoint(Offset position) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = _brushSize
      ..color = _paintColorFor(position);

    if (_selectedBrush == BrushType.glow) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    }

    switch (_selectedMode) {
      case PaintMode.pencil:
        paint.strokeWidth = 3;
        break;
      case PaintMode.marker:
        paint
          ..strokeWidth = _brushSize + 10
          ..color = _selectedColor.withValues(alpha: .45);
        break;
      case PaintMode.eraser:
        paint
          ..strokeWidth = _brushSize + 12
          ..color = _canvasColor;
        break;
      case PaintMode.rainbow:
        paint.color = HSVColor.fromAHSV(
          1,
          (position.dx + position.dy) % 360,
          .85,
          .95,
        ).toColor();
        break;
      case PaintMode.glitter:
      case PaintMode.brush:
      case PaintMode.bucket:
      case PaintMode.sticker:
      case PaintMode.text:
        break;
    }

    return DrawingPoint(
      offset: position,
      paint: paint,
      mode: _selectedMode,
      brushType: _selectedBrush,
    );
  }

  Color _paintColorFor(Offset position) {
    if (_selectedBrush == BrushType.rainbow) {
      return HSVColor.fromAHSV(1, (position.dx + position.dy) % 360, .85, .95)
          .toColor();
    }
    return _selectedColor;
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _redoStrokes.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStrokes.isEmpty) return;
    setState(() => _strokes.add(_redoStrokes.removeLast()));
  }

  Future<void> _confirmClear() async {
    if (_strokes.isEmpty && _canvasColor == Colors.white) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear drawing?'),
        content: const Text('This removes the current drawing from the canvas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        _strokes.clear();
        _redoStrokes.clear();
        _canvasColor = Colors.white;
      });
    }
  }

  Future<void> _saveDrawing() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final image = await _screenshotController.capture(pixelRatio: 2);
      if (image == null) throw StateError('The drawing could not be captured.');

      final directory = await getApplicationDocumentsDirectory();
      final folder = Directory('${directory.path}/paintings');
      await folder.create(recursive: true);
      final file = File('${folder.path}/${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(image, flush: true);
      if (!mounted) return;

      await context.read<RewardProvider>().addXP(20);
      if (!mounted) return;
      _showSavedDialog();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your drawing could not be saved. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSavedDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great work!'),
        content: const Text('Your drawing was saved. You earned 20 XP.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AfaanKoo Paint Studio'),
        actions: [
          IconButton(
            tooltip: 'Open saved drawings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GalleryScreen()),
            ),
            icon: const Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, 8, padding, 12),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Screenshot(
                      controller: _screenshotController,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) => _startStroke(details.localPosition),
                        onPanUpdate: (details) => _extendStroke(details.localPosition),
                        child: CustomPaint(
                          painter: DrawingCanvas(
                            points: _points,
                            backgroundColor: _canvasColor,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: constraints.maxHeight * .42),
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 12),
                    child: Column(
                      children: [
                        BrushPicker(
                          selectedBrush: _selectedBrush,
                          onBrushSelected: (brush) => setState(() {
                            _selectedBrush = brush;
                            _selectedMode = brush == BrushType.rainbow
                                ? PaintMode.rainbow
                                : brush == BrushType.magic
                                    ? PaintMode.glitter
                                    : PaintMode.brush;
                          }),
                        ),
                        StickerPicker(
                          onStickerSelected: (sticker) => setState(() {
                            _selectedSticker = sticker.emoji;
                            _selectedMode = PaintMode.sticker;
                          }),
                        ),
                        PaintColorPicker(
                          colors: _paintColors,
                          selectedColor: _selectedColor,
                          onColorSelected: (color) => setState(() {
                            _selectedColor = color;
                            if (_selectedMode == PaintMode.bucket) {
                              _selectedMode = PaintMode.brush;
                            }
                          }),
                        ),
                        PaintToolbar(
                          selectedMode: _selectedMode,
                          brushSize: _brushSize,
                          canUndo: _strokes.isNotEmpty,
                          canRedo: _redoStrokes.isNotEmpty,
                          isSaving: _isSaving,
                          onBrushChanged: (value) => setState(() => _brushSize = value),
                          onModeChanged: (mode) => setState(() => _selectedMode = mode),
                          onUndo: _undo,
                          onRedo: _redo,
                          onClear: _confirmClear,
                          onSave: _saveDrawing,
                          onGallery: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GalleryScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
