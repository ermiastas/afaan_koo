import 'package:flutter/material.dart';

import 'coloring/coloring_home_screen.dart';

/// Legacy route kept for callers that still open `ColoringBookScreen`.
/// The dynamic catalog-backed home is now the single colouring entry point.
class ColoringBookScreen extends StatelessWidget {
  const ColoringBookScreen({super.key});

  @override
  Widget build(BuildContext context) => const ColoringHomeScreen();
}
