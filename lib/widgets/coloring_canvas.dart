
import 'package:flutter/material.dart';

import '../models/draw_point.dart';
import '../painters/coloring_painter.dart';

class ColoringCanvas extends StatefulWidget {
  final String outlineImage;

  const ColoringCanvas({
    super.key,
    required this.outlineImage,
  });

  @override
  State<ColoringCanvas> createState() => _ColoringCanvasState();
}

class _ColoringCanvasState extends State<ColoringCanvas> {
  final GlobalKey repaintKey = GlobalKey();

  final List<DrawingPoint?> _points = [];

  Color selectedColor = Colors.red;

  double brushSize = 12;

  bool eraser = false;

  void startDraw(DragStartDetails details) {
    final box =
        repaintKey.currentContext!.findRenderObject() as RenderBox;

    final point =
        box.globalToLocal(details.globalPosition);

    setState(() {
      _points.add(
        DrawingPoint(
          offset: point,
          paint: Paint()
            ..color = eraser ? Colors.white : selectedColor
            ..strokeWidth = brushSize
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        ),
      );
    });
  }

  void draw(DragUpdateDetails details) {
    final box =
        repaintKey.currentContext!.findRenderObject() as RenderBox;

    final point =
        box.globalToLocal(details.globalPosition);

    setState(() {
      _points.add(
        DrawingPoint(
          offset: point,
          paint: Paint()
            ..color = eraser ? Colors.white : selectedColor
            ..strokeWidth = brushSize
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        ),
      );
    });
  }

  void endDraw(DragEndDetails details) {
    _points.add(null);
  }

  void undo() {
    if (_points.isEmpty) return;

    setState(() {
      while (_points.isNotEmpty) {
        final last = _points.removeLast();

        if (last == null) break;
      }
    });
  }

  void clearCanvas() {
    setState(() {
      _points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Drawing area
        Expanded(
          child: RepaintBoundary(
            key: repaintKey,
            child: GestureDetector(
              onPanStart: startDraw,
              onPanUpdate: draw,
              onPanEnd: endDraw,
              child: Stack(
                children: [

                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),

                  Positioned.fill(
                    child: Image.asset(
                      widget.outlineImage,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Positioned.fill(
                    child: CustomPaint(
                      painter: ColoringPainter(_points),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// Brush Size
        Row(
          children: [

            const Icon(Icons.brush),

            Expanded(
              child: Slider(
                value: brushSize,
                min: 2,
                max: 40,
                onChanged: (v) {
                  setState(() {
                    brushSize = v;
                  });
                },
              ),
            ),

            Text(
              brushSize.toInt().toString(),
            ),
          ],
        ),

        /// Color Palette
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [

              _color(Colors.red),
              _color(Colors.orange),
              _color(Colors.yellow),
              _color(Colors.green),
              _color(Colors.blue),
              _color(Colors.purple),
              _color(Colors.pink),
              _color(Colors.brown),
              _color(Colors.black),

            ],
          ),
        ),

        const SizedBox(height: 10),

        /// Toolbar
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [

            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: undo,
            ),

            IconButton(
              icon: const Icon(Icons.cleaning_services),
              onPressed: clearCanvas,
            ),

            IconButton(
              icon: Icon(
                eraser
                    ? Icons.auto_fix_off
                    : Icons.auto_fix_high,
              ),
              onPressed: () {
                setState(() {
                  eraser = !eraser;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _color(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          eraser = false;
          selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color
                ? Colors.black
                : Colors.white,
            width: 3,
          ),
        ),
      ),
    );
  }
}