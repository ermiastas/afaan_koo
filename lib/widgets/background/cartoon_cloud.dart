import 'package:flutter/material.dart';

class CartoonCloud extends StatelessWidget {
  final double width;
  final double opacity;

  const CartoonCloud({
    super.key,
    this.width = 160,
    this.opacity = .7,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(width, width * .55),
        painter: CloudPainter(),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: .08)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      );

    final path = Path();

    path.addOval(Rect.fromCircle(
      center: Offset(size.width * .25, size.height * .55),
      radius: size.height * .22,
    ));

    path.addOval(Rect.fromCircle(
      center: Offset(size.width * .45, size.height * .35),
      radius: size.height * .28,
    ));

    path.addOval(Rect.fromCircle(
      center: Offset(size.width * .68, size.height * .50),
      radius: size.height * .24,
    ));

    path.addRRect(
      RRect.fromLTRBR(
        size.width * .15,
        size.height * .45,
        size.width * .82,
        size.height * .78,
        const Radius.circular(50),
      ),
    );

    canvas.drawPath(path, shadow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}