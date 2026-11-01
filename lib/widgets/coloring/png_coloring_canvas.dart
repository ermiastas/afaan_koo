import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../services/png_coloring_engine.dart';

class PngColoringCanvas extends StatefulWidget {
  const PngColoringCanvas({
    super.key,
    required this.imageBytes,
  });

  final Uint8List imageBytes;

  @override
  State<PngColoringCanvas> createState() => _PngColoringCanvasState();
}

class _PngColoringCanvasState extends State<PngColoringCanvas> {
  final PngColoringEngine _engine = const PngColoringEngine();

  late img.Image _image;
  late Uint8List _originalBytes;
  late Uint8List _currentBytes;

  final List<Uint8List> _undoStack = [];

  Color _selectedColor = Colors.red;
  int _regionCount = 0;
  bool _ready = false;

  static const _palette = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _loadImage(widget.imageBytes);
  }

  void _loadImage(Uint8List bytes) {
    final decoded = _engine.decode(bytes);

    if (decoded == null) {
      _ready = false;
      return;
    }

    _image = decoded;
    _originalBytes = Uint8List.fromList(bytes);
    _currentBytes = Uint8List.fromList(bytes);

    _updateRegionCount();
    _ready = true;
  }

  void _updateRegionCount() {
    final regions = _engine.detectEnclosedRegions(
      image: _image,
      minimumPixels: 16,
    );

    _regionCount = regions.length;
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _fillAt(Offset localPosition, Size displaySize) {
    if (!_ready) return;

    final x = localPosition.dx.round();
    final y = localPosition.dy.round();

    if (x < 0 || y < 0 || x >= _image.width || y >= _image.height) {
      return;
    }

    final before = Uint8List.fromList(
      _engine.encodePng(_image),
    );

    final changed = _engine.floodFill(
      image: _image,
      startX: x,
      startY: y,
      fillColor: img.ColorRgb8(
        _selectedColor.r.round().clamp(0, 255),
        _selectedColor.g.round().clamp(0, 255),
        _selectedColor.b.round().clamp(0, 255),
      ),
      tolerance: 24,
    );

    if (changed == 0) {
      return;
    }

    _undoStack.add(before);
    _currentBytes = _engine.encodePng(_image);
    _updateRegionCount();

    setState(() {});
  }

  Size _fittedImageSize(Size availableSize) {
    final imageAspect = _image.width / _image.height;
    final availableAspect = availableSize.width / availableSize.height;

    if (imageAspect > availableAspect) {
      return Size(
        availableSize.width,
        availableSize.width / imageAspect,
      );
    }

    return Size(
      availableSize.height * imageAspect,
      availableSize.height,
    );
  }

  void _undo() {
    if (_undoStack.isEmpty) return;

    final previous = _undoStack.removeLast();
    final decoded = _engine.decode(previous);

    if (decoded == null) return;

    setState(() {
      _image = decoded;
      _currentBytes = Uint8List.fromList(previous);
      _updateRegionCount();
    });
  }

  void _reset() {
    final decoded = _engine.decode(_originalBytes);

    if (decoded == null) return;

    setState(() {
      _image = decoded;
      _currentBytes = Uint8List.fromList(_originalBytes);
      _undoStack.clear();
      _updateRegionCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(
        child: Text('Suuraa PNG banuun hin dandaÃ¢â‚¬â„¢amne.'),
      );
    }

    return Column(
      children: [
        _topBar(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                  color: Color(0x18000000),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 6,
              boundaryMargin: const EdgeInsets.all(120),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageSize = _fittedImageSize(
                      constraints.biggest,
                    );

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) {
                        _fillAt(
                          details.localPosition,
                          imageSize,
                        );
                      },
                      child: SizedBox(
                        width: imageSize.width,
                        height: imageSize.height,
                        child: Image.memory(
                          _currentBytes,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        _palettePicker(),
        _bottomTools(),
      ],
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Bakka halluu dibamu: $_regionCount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Undo',
            onPressed: _undoStack.isEmpty ? null : _undo,
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
    );
  }

  Widget _palettePicker() {
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: _palette.map((color) {
          final selected = color.toARGB32() == _selectedColor.toARGB32();

          return GestureDetector(
            onTap: () => _selectColor(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Colors.deepOrange : Colors.white,
                  width: selected ? 4 : 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    color: Color(0x22000000),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _bottomTools() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _tool(
              Icons.format_color_fill_rounded,
              'Paint Bucket',
            ),
            const SizedBox(width: 8),
            _tool(
              Icons.zoom_in_rounded,
              'Zoom',
            ),
          ],
        ),
      ),
    );
  }

  Widget _tool(IconData icon, String label) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
