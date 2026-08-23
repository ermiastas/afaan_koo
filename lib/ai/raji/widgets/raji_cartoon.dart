import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Raji's animated, non-emoji cartoon form. The drawing is vector based so it
/// remains sharp at every size and does not require a bundled image asset.
class RajiCartoon extends StatefulWidget {
  const RajiCartoon({super.key, this.size = 72, this.thinking = false});

  final double size;
  final bool thinking;

  @override
  State<RajiCartoon> createState() => _RajiCartoonState();
}

class _RajiCartoonState extends State<RajiCartoon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final wave = math.sin(_controller.value * math.pi * 2);
        return Transform.translate(
          offset: Offset(0, wave * -3),
          child: Transform.rotate(
            angle: wave * .035,
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: _RajiCartoonPainter(
                phase: _controller.value,
                thinking: widget.thinking,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _RajiCartoonPainter extends CustomPainter {
  const _RajiCartoonPainter({required this.phase, required this.thinking});

  final double phase;
  final bool thinking;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 100;
    final paint = Paint()..isAntiAlias = true;

    // Friendly round owl body and wings.
    paint.color = const Color(0xff5C4DB1);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(50 * unit, 62 * unit), width: 62 * unit, height: 64 * unit),
        paint);
    paint.color = const Color(0xff7769C6);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(24 * unit, 62 * unit), width: 29 * unit, height: 40 * unit),
        paint);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(76 * unit, 62 * unit), width: 29 * unit, height: 40 * unit),
        paint);

    // Head, ears and warm face.
    paint.color = const Color(0xff45367F);
    final head = Path()
      ..moveTo(22 * unit, 46 * unit)
      ..lineTo(27 * unit, 17 * unit)
      ..lineTo(42 * unit, 25 * unit)
      ..quadraticBezierTo(50 * unit, 20 * unit, 58 * unit, 25 * unit)
      ..lineTo(73 * unit, 17 * unit)
      ..lineTo(78 * unit, 46 * unit)
      ..quadraticBezierTo(78 * unit, 82 * unit, 50 * unit, 82 * unit)
      ..quadraticBezierTo(22 * unit, 82 * unit, 22 * unit, 46 * unit)
      ..close();
    canvas.drawPath(head, paint);
    paint.color = const Color(0xffF9E7C5);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(50 * unit, 50 * unit), width: 49 * unit, height: 49 * unit),
        paint);

    // Big expressive eyes. Blink briefly once per loop.
    final blink = (phase > .87 && phase < .96) ? .12 : 1.0;
    _eye(canvas, Offset(40 * unit, 47 * unit), 11 * unit, blink, paint);
    _eye(canvas, Offset(60 * unit, 47 * unit), 11 * unit, blink, paint);

    // Beak and smile.
    paint.color = const Color(0xffF4A340);
    final beak = Path()
      ..moveTo(50 * unit, 54 * unit)
      ..lineTo(44 * unit, 63 * unit)
      ..lineTo(56 * unit, 63 * unit)
      ..close();
    canvas.drawPath(beak, paint);
    paint
      ..color = const Color(0xff3E2C52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * unit
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(50 * unit, 67 * unit), width: 16 * unit, height: 9 * unit),
      0,
      math.pi,
      false,
      paint,
    );

    if (thinking) {
      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0xffF4A340);
      for (final dot in const [Offset(73, 20), Offset(82, 13), Offset(91, 7)]) {
        canvas.drawCircle(Offset(dot.dx * unit, dot.dy * unit), 3.5 * unit, paint);
      }
    }
  }

  void _eye(Canvas canvas, Offset center, double radius, double blink, Paint paint) {
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 2 * blink),
      paint,
    );
    paint.color = const Color(0xff2B214B);
    canvas.drawCircle(center, radius * .43 * blink, paint);
    paint.color = Colors.white;
    canvas.drawCircle(center.translate(radius * -.14, radius * -.16), radius * .13 * blink, paint);
  }

  @override
  bool shouldRepaint(covariant _RajiCartoonPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.thinking != thinking;
}
