import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() =>
      _AnimatedBackgroundState();
}

class _AnimatedBackgroundState
    extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _cloudController;
  late final AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..repeat();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //---------------------------------
        // Background Gradient
        //---------------------------------

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [

                Color(0xff9ED9FF),

                Color(0xffDDF5FF),

                Color(0xffFFFDF7),

              ],
            ),
          ),
        ),

        //---------------------------------
        // Sun
        //---------------------------------

        const Positioned(
          top: -40,
          right: -40,
          child: _Sun(),
        ),

        //---------------------------------
        // Clouds
        //---------------------------------

        AnimatedBuilder(
          animation: _cloudController,
          builder: (_, __) {
            return Stack(
              children: [

                _cloud(
                  top: 60,
                  start: -150,
                  end: 450,
                  size: 120,
                  value: _cloudController.value,
                ),

                _cloud(
                  top: 150,
                  start: 420,
                  end: -200,
                  size: 90,
                  value: _cloudController.value,
                ),

                _cloud(
                  top: 240,
                  start: -120,
                  end: 480,
                  size: 110,
                  value: _cloudController.value,
                ),
              ],
            );
          },
        ),

        //---------------------------------
        // Floating bubbles
        //---------------------------------

        AnimatedBuilder(
          animation: _bubbleController,
          builder: (_, __) {

            return CustomPaint(
              painter: BubblePainter(
                _bubbleController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        //---------------------------------
        // Child
        //---------------------------------

        SafeArea(
          child: widget.child,
        ),
      ],
    );
  }

  Widget _cloud({
    required double top,
    required double start,
    required double end,
    required double size,
    required double value,
  }) {
    return Positioned(
      top: top,
      left: start + ((end - start) * value),
      child: Icon(
        Icons.cloud,
        color: Colors.white.withValues(alpha:.95),
        size: size,
      ),
    );
  }
}

class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow.withValues(alpha:.35),
      ),
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xfffff59d),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final double animationValue;

  BubblePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color =
          Colors.white.withValues(alpha:.22);

    final random =
        math.Random(7);

    for (int i = 0; i < 30; i++) {

      final x =
          random.nextDouble() *
              size.width;

      final radius =
          8 +
              random.nextDouble() *
                  18;

      final startY =
          size.height +
              random.nextDouble() *
                  size.height;

      final y =
          startY -
              (animationValue *
                  size.height *
                  2);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      BubblePainter oldDelegate) {

    return true;
  }
}