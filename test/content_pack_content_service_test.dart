import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afaan_koo_app/models/content_pack.dart';
import 'package:afaan_koo_app/services/content_pack_content_service.dart';
import 'package:afaan_koo_app/services/content_pack_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDirectory;
  late Directory packDirectory;
  late ContentPackContentService contentService;
  late ContentPackManager manager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    tempDirectory = await Directory.systemTemp.createTemp(
      'afaankoo_pack_content_test_',
    );

    packDirectory = Directory(
      '${tempDirectory.path}${Platform.pathSeparator}animals_v1',
    );

    await Directory(
      '${packDirectory.path}${Platform.pathSeparator}lessons',
    ).create(recursive: true);

    await Directory(
      '${packDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images',
    ).create(recursive: true);

    manager = ContentPackManager(
      initializationCleanup: () async {},
    );

    contentService = ContentPackContentService(
      contentPackManager: manager,
    );

    final pack = ContentPack(
      id: 'animals',
      slug: 'animals',
      title: 'Animals',
      description: 'Animal lessons',
      version: 1,
      sizeBytes: 100,
      lessonCount: 1,
      category: 'animals',
      minAppVersion: '1.0.0',
      language: 'om',
      isActive: true,
      checksum: 'test-checksum',
    );

    await manager.completeInstallation(
      pack: pack,
      verifiedChecksum: 'test-checksum',
      localPath: packDirectory.path,
    );
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  test('reads a lesson JSON list from the installed pack', () async {
    final lessonFile = File(
      '${packDirectory.path}${Platform.pathSeparator}lessons'
      '${Platform.pathSeparator}animals.json',
    );

    await lessonFile.writeAsString(
      jsonEncode([
        {
          'id': 'lion',
          'nameOromo': 'Leenca',
          'nameEnglish': 'Lion',
        },
      ]),
    );

    final lessons = await contentService.readLessonList(
      'animals',
      'animals.json',
    );

    expect(lessons, isNotNull);
    expect(lessons, hasLength(1));
    expect(lessons!.first['id'], 'lion');
    expect(lessons.first['nameOromo'], 'Leenca');
  });

  test('resolves media inside the installed pack', () async {
    final imageFile = File(
      '${packDirectory.path}${Platform.pathSeparator}media'
      '${Platform.pathSeparator}images'
      '${Platform.pathSeparator}lion.png',
    );

    await imageFile.writeAsBytes([1, 2, 3]);

    final result = await contentService.resolveMediaFile(
      'animals',
      'media/images/lion.png',
    );

    expect(result, isNotNull);
    expect(await result!.exists(), isTrue);
    expect(await result.readAsBytes(), [1, 2, 3]);
  });

  test('returns null when a lesson file does not exist', () async {
    final result = await contentService.readLessonList(
      'animals',
      'missing.json',
    );

    expect(result, isNull);
  });

  test('rejects media paths that escape the pack', () async {
    expect(
      () => contentService.resolveMediaFile(
        'animals',
        'media/../outside.png',
      ),
      throwsArgumentError,
    );
  });

  test('rejects lesson paths that escape the pack', () async {
    await expectLater(
      contentService.readLessonList(
        'animals',
        '../outside.json',
      ),
      throwsArgumentError,
    );
  });
}

