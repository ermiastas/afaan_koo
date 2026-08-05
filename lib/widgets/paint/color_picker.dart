import 'package:flutter/material.dart';

class PaintColorPicker extends StatelessWidget {

  final List<Color> colors;

  final Color selectedColor;

  final ValueChanged<Color> onColorSelected;

  const PaintColorPicker({

    super.key,

    required this.colors,

    required this.selectedColor,

    required this.onColorSelected,

  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 72,

      child: ListView.builder(

        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 12),

        itemCount: colors.length,

        itemBuilder: (context, index) {

          final color = colors[index];

          final selected = color == selectedColor;

          return GestureDetector(

            onTap: () {

              onColorSelected(color);

            },

            child: AnimatedContainer(

              duration: const Duration(milliseconds: 250),

              curve: Curves.easeOut,

              margin: const EdgeInsets.symmetric(

                horizontal: 6,

                vertical: 8,

              ),

              width: selected ? 58 : 48,

              height: selected ? 58 : 48,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color: color,

                boxShadow: [

                  BoxShadow(

                    color: color.withValues(alpha: .5),

                    blurRadius: selected ? 14 : 4,

                    spreadRadius: selected ? 2 : 0,

                  ),

                ],

                border: Border.all(

                  color: Colors.white,

                  width: selected ? 4 : 2,

                ),

              ),

            ),

          );

        },

      ),

    );

  }

}