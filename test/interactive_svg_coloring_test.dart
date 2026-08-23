import 'package:afaan_koo_app/widgets/coloring/interactive_svg_coloring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('fills a region and supports undo and redo', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final key = GlobalKey<InteractiveSvgColoringState>();
    const svg = '<svg viewBox="0 0 96 96">'
        '<path id="body" fill="#FFFFFF" d="M0 0H48V48H0Z"/>'
        '<path id="eye" fill="#FFFFFF" d="M48 0H96V48H48Z"/>'
        '</svg>';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: InteractiveSvgColoring(
          key: key,
          pageId: 'test-page',
          svgMarkup: svg,
          selectedColor: Colors.red,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    key.currentState!.fillRegion('body', Colors.red);
    await tester.pump();
    expect(key.currentState!.session.colors['body'], Colors.red);

    key.currentState!.undo();
    await tester.pump();
    expect(key.currentState!.session.colors['body'], Colors.white);

    key.currentState!.redo();
    await tester.pump();
    expect(key.currentState!.session.colors['body'], Colors.red);
  });
}
