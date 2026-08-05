import 'package:flutter/material.dart';

class AnimatedRaji extends StatefulWidget {
  final Widget child;

  const AnimatedRaji({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedRaji> createState() => _AnimatedRajiState();
}

class _AnimatedRajiState extends State<AnimatedRaji>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(
            0,
            -4 * _controller.value,
          ),
          child: child,
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