import 'package:flutter/material.dart';

/// A consistent, closed picture boundary for coloring previews and canvases.
/// The inner white mat keeps the artwork visually contained instead of letting
/// it appear open-ended against the page background.
class ColoringFrame extends StatelessWidget {
  const ColoringFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffF4B942), Color(0xffD98922)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xffFFF9E8),
            border: Border.all(color: const Color(0xff8C5418), width: 2),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Padding(
            padding: padding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(color: Colors.white, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
