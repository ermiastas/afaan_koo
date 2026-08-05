import 'package:flutter/material.dart';

class BrushSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const BrushSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.brush),
        Expanded(
          child: Slider(
            min: 2,
            max: 40,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Text(value.toInt().toString()),
      ],
    );
  }
}