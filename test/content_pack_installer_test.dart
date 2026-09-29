import 'dart:convert';
import 'dart:io';

import 'package:afaan_koo_app/models/content_pack.dart';
import 'package:afaan_koo_app/services/content_pack_installer.dart';
import 'package:afaan_koo_app/services/content_pack_validator.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testRoot;
  late ContentPackInstaller installer;

  const pack = ContentPack(
    id: 'uumama_v1',
    slug: 'uumama',
    title: 'Uumama',
    description: 'Bineensota, biqiltuu fi haala qilleensaa.',
    version: 1,
    sizeBytes: 0,
    lessonCount: 1,
    category: 'Uumama',
    minAppVersion: '1.0.0',
    language: 'om',
    isActive: true,
    checksum: 'catalog-checksum',
  );

  setUp(() async {
    testRoot = await Directory.systemTemp.createTemp(
      'afaankoo_content_pack_installer_test_',
    );

    installer = ContentPackInstaller(
      rootDirectoryProvider: () async => testRoot,
    );
  });

  tearDown(() async {
    if (await testRoot.exists()) {
      await testRoot.delete(recursive: true);
    }
  });

  test(
    'does not overwrite an existing installation directory',
    () async {
      final archiveFile = await _createValidPackArchive(
        directory: testRoot,
        pack: pack,
      );

      final firstInstallationPath = await installer.install(
        archiveFile: archiveFile,
        pack: pack,
      );

      final existingInstallation = Directory(firstInstallationPath);

      expect(await existingInstallation.exists(), isTrue);

      final protectedFile = File(
        '${existingInstallation.path}${Platform.pathSeparator}protected.txt',
      );

      await protectedFile.writeAsString(
        'existing installation must survive',
        flush: true,
      );

      expect(await protectedFile.exists(), isTrue);

      await expectLater(
        installer.install(
          archiveFile: archiveFile,
          pack: pack,
        ),
        throwsA(
          isA<ContentPackInstallationException>().having(
            (error) => error.message,
            'message',
            'The target installation directory already exists.',
          ),
        ),
      );

      expect(await existingInstallation.exists(), isTrue);
      expect(await protectedFile.exists(), isTrue);
      expect(
        await protectedFile.readAsString(),
        'existing installation must survive',
      );
    },
  );
}

Future<File> _createValidPackArchive({
  required Directory directory,
  required ContentPack pack,
}) async {
  final lessonBytes = utf8.encode(
    jsonEncode({
      'id': 'uumama_lesson_1',
      'title': 'Bineensota',
      'category': 'Uumama',
      'language': 'om',
    }),
  );

  final contentArchive = Archive();

  contentArchive.addFile(
    ArchiveFile(
      'lessons/lesson_1.json',
      lessonBytes.length,
      lessonBytes,
    ),
  );

  const validator = ContentPackValidator();

  final contentChecksum =
      validator.calculateArchiveContentChecksum(contentArchive);

  final manifest = {
    'id': pack.id,
    'name': pack.title,
    'version': pack.version,
    'min_app_version': pack.minAppVersion,
    'lesson_count': pack.lessonCount,
    'size_bytes': pack.sizeBytes,
    'language': pack.language,
    'checksum': contentChecksum,
    'is_active': true,
  };

  final archive = Archive();

  archive.addFile(
    ArchiveFile(
      'manifest.json',
      utf8.encode(jsonEncode(manifest)).length,
      utf8.encode(jsonEncode(manifest)),
    ),
  );

  archive.addFile(
    ArchiveFile(
      'lessons/lesson_1.json',
      lessonBytes.length,
      lessonBytes,
    ),
  );

  final encoded = ZipEncoder().encode(archive);

  final archiveFile = File(
    '${directory.path}${Platform.pathSeparator}uumama_v1.zip',
  );

  await archiveFile.writeAsBytes(
    encoded,
    flush: true,
  );

  return archiveFile;
}
