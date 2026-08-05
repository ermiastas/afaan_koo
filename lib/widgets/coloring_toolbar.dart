import 'package:flutter/material.dart';

class ColoringToolbar extends StatelessWidget {
  final VoidCallback undo;
  final VoidCallback clear;
  final VoidCallback save;

  const ColoringToolbar({
    super.key,
    required this.undo,
    required this.clear,
    required this.save,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: undo,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: clear,
        ),
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: save,
        ),
      ],
    );
  }
}