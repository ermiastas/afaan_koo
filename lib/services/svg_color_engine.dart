import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import 'svg_safety_validator.dart';

/// Handles safe recoloring of AfaanKoo SVG coloring pages.
///
/// This service deliberately operates only on validated SVG markup.
class SvgColorEngine {
  const SvgColorEngine({
    SvgSafetyValidator? validator,
  }) : _validator = validator ?? const SvgSafetyValidator();

  final SvgSafetyValidator _validator;

  Future<String> recolorSvg({
    required String asset,
    required String partId,
    required String color,
  }) async {
    final svgString = await rootBundle.loadString(asset);

    return recolorMarkup(
      svg: svgString,
      colors: <String, String>{
        partId: color,
      },
    );
  }

  String recolorMarkup({
    required String svg,
    required Map<String, String> colors,
  }) {
    final validation = _validator.validate(svg);

    if (!validation.isValid) {
      throw StateError(
        'Cannot recolor invalid SVG: '
        '${validation.reason ?? 'unknown validation error'}',
      );
    }

    final document = XmlDocument.parse(svg);

    for (final path in document.findAllElements('path')) {
      final id = path.getAttribute('id');

      if (id == null) {
        continue;
      }

      final color = colors[id];

      if (color == null) {
        continue;
      }

      if (!_isSafeColor(color)) {
        continue;
      }

      path.setAttribute(
        'fill',
        color,
      );
    }

    return document.toXmlString();
  }

  bool _isSafeColor(String color) {
    final value = color.trim();

    // AfaanKoo uses hexadecimal colors internally.
    return RegExp(
      r'^#[0-9a-fA-F]{6}$',
    ).hasMatch(value);
  }
}