import 'package:flutter/material.dart';

import 'cartoon_cloud.dart';

class MovingClouds extends StatefulWidget {
  const MovingClouds({super.key});

  @override
  State<MovingClouds> createState() => _MovingCloudsState();
}

class _MovingCloudsState extends State<MovingClouds>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {

            final width = MediaQuery.of(context).size.width;

            return Stack(
              children: [

                _cloud(
                  left: -140 + (width + 300) * _controller.value,
                  top: 50,
                  scale: 1.1,
                  opacity: .55,
                ),

                _cloud(
                  left: width -
                      ((width + 300) * _controller.value),
                  top: 130,
                  scale: .8,
                  opacity: .45,
                ),

                _cloud(
                  left: -200 +
                      (width + 450) * _controller.value,
                  top: 240,
                  scale: 1.4,
                  opacity: .35,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cloud({
    required double left,
    required double top,
    required double scale,
    required double opacity,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: 
          CartoonCloud(
          width: 170 * scale,
            opacity: opacity,
)
        ),
      ),
    );
  }
}