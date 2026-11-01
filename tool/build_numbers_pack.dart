import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

Future<void> main() async {
  final source = File('lib/content/numbers/numbers.json');

  if (!await source.exists()) {
    throw StateError('lib/content/numbers/numbers.json hin argamne.');
  }

  final decoded = jsonDecode(await source.readAsString());
  if (decoded is! List) {
    throw const FormatException('numbers.json tarree JSON ta’uu qaba.');
  }

  final lessons = <Map<String, dynamic>>[];

  for (final value in decoded) {
    if (value is! Map) continue;

    final item = Map<String, dynamic>.from(value);

    // The new number UI renders large, colorful numerals.
    item.remove('image');
    item.remove('sound');

    lessons.add(item);
  }

  final lessonBytes = Uint8List.fromList(
    utf8.encode(const JsonEncoder.withIndent('  ').convert(lessons)),
  );

  final contentArchive = Archive()
    ..addFile(
      ArchiveFile(
        'lessons/numbers.json',
        lessonBytes.length,
        lessonBytes,
      ),
    );

  final contentChecksum = calculateContentChecksum(contentArchive);

  final manifest = <String, dynamic>{
    'id': 'numbers',
    'name': 'Lakkoofsota Afaan Oromoo',
    'version': 1,
    'min_app_version': '1.0.0',
    'lesson_count': lessons.length,
    'size_bytes': 0,
    'language': 'om',
    'checksum': contentChecksum,
    'is_active': true,
  };

  final output = File('build/content_packs/numbers_v1.zip');
  await output.parent.create(recursive: true);

  List<int> zipBytes = [];

  // Iterate because the manifest contains size_bytes.
  for (var attempt = 0; attempt < 5; attempt++) {
    final archive = Archive()
      ..addFile(
        ArchiveFile(
          'lessons/numbers.json',
          lessonBytes.length,
          lessonBytes,
        ),
      );

    final manifestBytes = Uint8List.fromList(
      utf8.encode(jsonEncode(manifest)),
    );

    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );

    zipBytes = ZipEncoder().encode(archive);

    if (manifest['size_bytes'] == zipBytes.length) break;
    manifest['size_bytes'] = zipBytes.length;
  }

  // Rebuild using the final manifest value.
  final finalArchive = Archive()
    ..addFile(
      ArchiveFile(
        'lessons/numbers.json',
        lessonBytes.length,
        lessonBytes,
      ),
    );

  final finalManifestBytes = Uint8List.fromList(
    utf8.encode(jsonEncode(manifest)),
  );

  finalArchive.addFile(
    ArchiveFile(
      'manifest.json',
      finalManifestBytes.length,
      finalManifestBytes,
    ),
  );

  zipBytes = ZipEncoder().encode(finalArchive);
  await output.writeAsBytes(zipBytes, flush: true);

  stdout.writeln('\nNUMBERS PACK CREATED');
  stdout.writeln('ZIP: ${output.absolute.path}');
  stdout.writeln('Pack ID: numbers');
  stdout.writeln('Version: 1');
  stdout.writeln('Lessons: ${lessons.length}');
  stdout.writeln('Media files: 0');
  stdout.writeln('ZIP size: ${zipBytes.length} bytes');
  stdout.writeln('Catalog SHA-256: ${sha256.convert(zipBytes)}');
  stdout.writeln('Manifest content SHA-256: $contentChecksum');
}

String calculateContentChecksum(Archive archive) {
  final files = archive.where((entry) => entry.isFile).toList()
    ..sort((a, b) => a.name.compareTo(b.name));

  final builder = BytesBuilder(copy: false);

  for (final file in files) {
    final pathBytes = utf8.encode(file.name.replaceAll('\\', '/'));
    final bytes = file.content;

    builder.add(_int64(pathBytes.length));
    builder.add(pathBytes);
    builder.add(_int64(bytes.length));
    builder.add(bytes);
  }

  return sha256.convert(builder.takeBytes()).toString();
}

Uint8List _int64(int value) {
  final data = ByteData(8);
  data.setUint64(0, value, Endian.big);
  return data.buffer.asUint8List();
}
