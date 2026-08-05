import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final Color selected;
  final ValueChanged<Color> onChanged;

  const ColorPalette({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.white,
    Colors.grey,
    Colors.cyan,
    Colors.lime,
    Colors.teal,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];

          return GestureDetector(
            onTap: () => onChanged(color),
            child: Container(
              margin: const EdgeInsets.all(6),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected == color
                      ? Colors.black
                      : Colors.white,
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}