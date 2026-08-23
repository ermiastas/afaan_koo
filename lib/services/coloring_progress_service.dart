import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the child's coloring progress locally.
///
/// The service deliberately stores only serializable state and does not know
/// anything about Flutter widgets or SVG rendering.
class ColoringProgressService {
  const ColoringProgressService();

  static const String _keyPrefix = 'coloring_state_';

  String _key(String pageId) {
    return '$_keyPrefix$pageId';
  }

  /// Saves the current colors for a coloring page.
  ///
  /// A region is represented by its stable SVG region ID.
  Future<void> saveColoring({
    required String pageId,
    required Map<String, Color> colors,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final data = <String, int>{
      for (final entry in colors.entries) entry.key: entry.value.toARGB32(),
    };

    await prefs.setString(
      _key(pageId),
      jsonEncode(data),
    );
  }

  /// Loads previously saved colors.
  ///
  /// Invalid or corrupted entries are ignored instead of crashing the
  /// coloring screen.
  Future<Map<String, Color>> loadColoring(
    String pageId,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_key(pageId));

    if (raw == null || raw.trim().isEmpty) {
      return <String, Color>{};
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! Map) {
        return <String, Color>{};
      }

      final result = <String, Color>{};

      for (final entry in decoded.entries) {
        final id = entry.key.toString();

        final value = entry.value;

        final argb = value is int
            ? value
            : int.tryParse(value.toString());

        if (argb == null) {
          continue;
        }

        result[id] = Color(argb);
      }

      return result;
    } catch (_) {
      // Corrupted local data should never prevent the child from opening
      // the coloring page.
      return <String, Color>{};
    }
  }

  /// Deletes all saved coloring progress for one page.
  Future<void> clearColoring(String pageId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key(pageId));
  }

  /// Checks whether local progress exists for a page.
  Future<bool> hasSavedColoring(String pageId) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(_key(pageId));
  }
}