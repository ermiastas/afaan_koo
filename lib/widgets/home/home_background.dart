import 'dart:math';
import 'package:flutter/material.dart';

class HomeBackground extends StatefulWidget {
  final Widget child;

  const HomeBackground({
    super.key,
    required this.child,
  });

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Random random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCloud({
    required double top,
    required double size,
    required double speed,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final screenWidth = MediaQuery.of(context).size.width;

        double x =
            (screenWidth + size) *
                ((_controller.value * speed) % 1.0) -
            size;

        return Positioned(
          left: x,
          top: top,
          child: Opacity(
            opacity: 0.9,
            child: Icon(
              Icons.cloud,
              color: Colors.white,
              size: size,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBubble() {
    final left = random.nextDouble();

    final size = random.nextDouble() * 14 + 8;

    final duration = random.nextDouble() * .4 + .6;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final screen = MediaQuery.of(context).size;

        final y = screen.height * (1 - ((_controller.value * duration) % 1));

        return Positioned(
          left: left * screen.width,
          top: y,
          child: Opacity(
            opacity: .15,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHill({
    required Alignment alignment,
    required Color color,
    required double height,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(250),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF81D4FA),
                Color(0xFFE1F5FE),
              ],
            ),
          ),
        ),

        // Sun
        Positioned(
          top: 40,
          right: 30,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: .95, end: 1.05),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (_, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            onEnd: () => setState(() {}),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: Colors.amber,
              size: 80,
            ),
          ),
        ),

        // Clouds
        _buildCloud(
          top: 60,
          size: 80,
          speed: .18,
        ),

        _buildCloud(
          top: 130,
          size: 60,
          speed: .28,
        ),

        _buildCloud(
          top: 180,
          size: 100,
          speed: .12,
        ),

        // Bubbles
        ...List.generate(
          18,
          (_) => _buildBubble(),
        ),

        // Hills
        Positioned(
          bottom: 120,
          left: -80,
          right: -80,
          child: _buildHill(
            alignment: Alignment.bottomCenter,
            color: const Color(0xFF8BC34A),
            height: screen.height * .30,
          ),
        ),

        Positioned(
          bottom: 0,
          left: -40,
          right: -40,
          child: _buildHill(
            alignment: Alignment.bottomCenter,
            color: const Color(0xFF66BB6A),
            height: screen.height * .22,
          ),
        ),

        SafeArea(
          child: widget.child,
        ),
      ],
    );
  }
}