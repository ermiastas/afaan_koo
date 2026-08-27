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
    final document = XmlDocument.parse(svg);

    if (!validation.isValid && !_isSupportedLegacySvg(document)) {
      throw StateError(
        'Cannot recolor invalid SVG: '
        '${validation.reason ?? 'unknown validation error'}',
      );
    }

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
      // A class-based fill rule has higher precedence than a presentation
      // attribute. Remove it so bundled legacy SVGs visibly update.
      path.removeAttribute('class');
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

  bool _isSupportedLegacySvg(XmlDocument document) {
    const allowedElements = <String>{
      'svg',
      'defs',
      'style',
      'linearGradient',
      'radialGradient',
      'stop',
      'g',
      'path',
    };
    final root = document.rootElement;
    if (root.name.local != 'svg') return false;

    for (final element in document.descendants.whereType<XmlElement>()) {
      if (!allowedElements.contains(element.name.local)) return false;
      for (final attribute in element.attributes) {
        final name = attribute.name.local.toLowerCase();
        final value = attribute.value.toLowerCase();
        if (name.startsWith('on') || value.contains('javascript:')) {
          return false;
        }
      }
    }

    return document.findAllElements('path').any((path) =>
        (path.getAttribute('id') ?? '').isNotEmpty &&
        (path.getAttribute('d') ?? '').isNotEmpty);
  }
}
