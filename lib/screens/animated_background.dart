import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        /// Sky Gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff87CEEB),
                  Color(0xffB3E5FC),
                  Color(0xffE1F5FE),
                ],
              ),
            ),
          ),
        ),

        /// Bubble Painter
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: BubblePainter(_controller.value),
              );
            },
          ),
        ),

        widget.child,
      ],
    );
  }
}

class BubblePainter extends CustomPainter {
  final double progress;

  BubblePainter(this.progress);

  final Random random = Random(7);

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .18)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 35; i++) {

      final radius = 10 + random.nextDouble() * 30;

      final x = random.nextDouble() * size.width;

      double y =
          size.height -
          ((progress * size.height * 1.3) +
                  random.nextDouble() * size.height) %
              (size.height + 80);

      canvas.drawCircle(Offset(x, y), radius, paint);

      canvas.drawCircle(
        Offset(x - radius / 4, y - radius / 4),
        radius / 5,
        Paint()..color = Colors.white70,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) => true;
}