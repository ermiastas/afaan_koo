import 'dart:math';
import 'package:flutter/material.dart';

class FloatingBubblesBackground extends StatefulWidget {
  final Widget child;

  const FloatingBubblesBackground({
    super.key,
    required this.child,
  });

  @override
  State<FloatingBubblesBackground> createState() =>
      _FloatingBubblesBackgroundState();
}

class _FloatingBubblesBackgroundState
    extends State<FloatingBubblesBackground>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  final random = Random();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }


  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {

        return Stack(
          children: [

            ...List.generate(12, (index){

              double move =
                  sin(controller.value * 2 * pi + index) * 20;

              return Positioned(
                left: random.nextDouble() *
                    MediaQuery.of(context).size.width,

                top:
                40 +
                ((index * 60) % 500) +
                move,

                child: Container(
                  width: 15 + index % 4 * 8,
                  height: 15 + index % 4 * 8,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.white.withValues(alpha:
                      0.25,
                    ),
                  ),
                ),
              );
            }),

            widget.child,
          ],
        );
      },
    );
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
}