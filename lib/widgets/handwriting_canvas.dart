import 'package:flutter/material.dart';

import '../handwriting/handwriting_painter.dart';
import '../handwriting/tracing_engine.dart';
import '../models/handwriting_stroke.dart';

class HandwritingCanvas extends StatefulWidget {
  final String target;
  final List<HandwritingStroke> strokes;
  final VoidCallback onComplete;

  const HandwritingCanvas({
    super.key,
    required this.target,
    required this.strokes,
    required this.onComplete,
  });

  @override
  HandwritingCanvasState createState() => HandwritingCanvasState();
}

class HandwritingCanvasState extends State<HandwritingCanvas>
    with SingleTickerProviderStateMixin {
  final List<Offset> _points = [];

  final List<Offset> _animatedPoints = [];

  bool _completed = false;

  late final AnimationController _controller;
  Size _canvasSize = const Size(300, 300);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addListener(_updateAnimation);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HandwritingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.target != widget.target) {
      clear();

      _controller
        ..reset()
        ..forward();
    }
  }

  void _updateAnimation() {
    final allPoints = <Offset>[];

    for (final stroke in widget.strokes) {
      for (final point in stroke.points) {
        allPoints.add(
          Offset(
            point[0].toDouble(),
            point[1].toDouble(),
          ),
        );
      }
    }

    final visible =
        (allPoints.length * _controller.value).round();

    setState(() {
      _animatedPoints
        ..clear()
        ..addAll(allPoints.take(visible));
    });
  }

  void _checkAccuracy() {
    if (_completed) return;

    final accuracy = TracingEngine.calculateAccuracy(
      _points,
      widget.strokes,
      _canvasSize,
    );

    if (accuracy >= 0.70) {
      _completed = true;
      widget.onComplete();
    }
  }

  void _addPoint(Offset point) {
    if (_completed) return;

    if (_points.isNotEmpty &&
        _points.last != Offset.infinite &&
        (_points.last - point).distance < 1.5) {
      return;
    }

    setState(() {
      _points.add(point);
    });
  }

  //==========================
  // Public methods
  //==========================

  void clear() {
    setState(() {
      _points.clear();
      _completed = false;
    });
  }

  void undo() {
    if (_points.isEmpty) return;

    setState(() {
      while (_points.isNotEmpty && _points.last == Offset.infinite) {
        _points.removeLast();
      }
      while (_points.isNotEmpty) {
        final last = _points.removeLast();

        if (last == Offset.infinite) {
          break;
        }
      }
    });
  }

  void replay() {
    _controller
      ..reset()
      ..forward();

    setState(() {
      _animatedPoints.clear();
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_updateAnimation)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.blue.shade200,
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,

              onPanStart: (details) {
                _addPoint(details.localPosition);
              },

              onPanUpdate: (details) {
                _addPoint(details.localPosition);
              },

              onPanEnd: (_) {
                setState(() => _points.add(Offset.infinite));
                _checkAccuracy();
              },

              child: CustomPaint(
                size: Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                ),
                painter: HandwritingPainter(
                  letter: widget.target,
                  strokes: widget.strokes,
                  animatedPoints: _animatedPoints,
                  userPoints: _points,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
