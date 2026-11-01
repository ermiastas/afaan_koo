import 'package:flutter_test/flutter_test.dart';
import '../tool/export_lesson_data.dart' as exporter;

void main() {
  test('Export AfaanKoo lesson data', () async {
    await exporter.main();
  });
}
