import 'package:flutter/material.dart';

/// Holds the active state of one coloring session.
///
/// This service is intentionally UI-independent. It does not save to disk
/// and does not render SVG. Persistence belongs to ColoringProgressService.
class ColoringStateService {
  final Map<String, Color> _colors = {};

  /// Returns true when at least one region has been colored.
  bool get hasColors => _colors.isNotEmpty;

  /// Number of regions currently colored.
  int get coloredRegionCount => _colors.length;

  /// Returns a read-only snapshot of the current colors.
  Map<String, Color> get colors => Map.unmodifiable(_colors);

  /// Returns the color for a region.
  ///
  /// White is used as the visual default for an uncolored region.
  Color getColor(String id) {
    return _colors[id] ?? Colors.white;
  }

  /// Returns whether a region has explicitly been colored.
  ///
  /// This is different from checking whether its color is white.
  bool isColored(String id) {
    return _colors.containsKey(id);
  }

  /// Sets the color for a region.
  void updateColor(
    String id,
    Color color,
  ) {
    _colors[id] = color;
  }

  /// Removes a region from the colored set.
  ///
  /// This represents an erase operation, rather than coloring the region
  /// white.
  void erase(String id) {
    _colors.remove(id);
  }

  /// Restores a complete color map.
  void restore(
    Map<String, Color> colors,
  ) {
    _colors
      ..clear()
      ..addAll(colors);
  }

  /// Removes all coloring state.
  void clear() {
    _colors.clear();
  }

  /// Creates an independent snapshot of the current state.
  Map<String, Color> snapshot() {
    return Map<String, Color>.from(_colors);
  }
}