import 'package:flutter/material.dart';

class CountingWidget extends StatelessWidget {
  final int count;

  final IconData icon;

  final Color color;

  final double size;

  const CountingWidget({
    super.key,
    required this.count,
    this.icon = Icons.circle,
    this.color = Colors.orange,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox();
    }

    // Prevent overcrowding
    final displayCount = count > 20 ? 20 : count;

    return Column(
      children: [

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            displayCount,
            (_) => Icon(
              icon,
              color: color,
              size: size,
            ),
          ),
        ),

        if (count > 20) ...[
          const SizedBox(height: 8),

          Text(
            "$count wantoota",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],

      ],
    );
  }
}