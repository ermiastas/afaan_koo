import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:afaan_koo_app/models/content_pack.dart';
import 'package:afaan_koo_app/services/content_pack_downloader.dart';
import 'package:afaan_koo_app/services/content_pack_installer.dart';
import 'package:afaan_koo_app/services/content_pack_manager.dart';
import 'package:afaan_koo_app/services/content_pack_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeContentPackDownloader extends ContentPackDownloader {
  _FakeContentPackDownloader(this._files);

  final Map<String, File> _files;

  @override
  Future<File> download({
    required String url,
    required String destination,
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    final source = _files[url];

    if (source == null) {
      throw ContentPackDownloadException(
        'No test archive registered for $url.',
      );
    }

    final destinationFile = File(destination);
    await destinationFile.parent.create(recursive: true);
    await source.copy(destinationFile.path);

    final length = await destinationFile.length();

    onProgress?.call(
      ContentPackDownloadProgress(
        receivedBytes: length,
        totalBytes: length,
      ),
    );

    return destinationFile;
  }

  @override
  void cancel() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testRoot;
  late ContentPackInstaller installer;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'lesson_progress_v1': '{"animals":1.0}',
    });

    testRoot = await Directory.systemTemp.createTemp(
      'afaankoo_content_pack_manager_test_',
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

  test('records a locally completed installation', () async {
    const pack = ContentPack(
      id: 'uumama_v1',
      slug: 'uumama',
      title: 'Uumama',
      description: 'Bineensota, biqiltuu fi haala qilleensaa.',
      version: 1,
      sizeBytes: 18400000,
      lessonCount: 3,
      category: 'Uumama',
      minAppVersion: '1.0.0',
      language: 'om',
      isActive: true,
      checksum: 'catalog-checksum',
    );

    final manager = ContentPackManager(
      initializationCleanup: () async {},
    );

    await manager.beginInstallation(pack);

    expect(
      await manager.getStatus(pack.id),
      ContentPackInstallationStatus.installing,
    );

    await manager.completeInstallation(
      pack: pack,
      verifiedChecksum: 'verified-checksum',
      localPath: '/content-packs/uumama_v1',
      installedAt: DateTime.utc(2026, 9, 29),
    );

    expect(await manager.isInstalled(pack.id), isTrue);
    expect(await manager.getInstalledVersion(pack.id), 1);
  });

  test(
    'keeps the installed version usable when an update is available',
    () async {
      const pack = ContentPack(
        id: 'uumama_v1',
        slug: 'uumama',
        title: 'Uumama',
        description: 'Bineensota, biqiltuu fi haala qilleensaa.',
        version: 1,
        sizeBytes: 18400000,
        lessonCount: 3,
        category: 'Uumama',
        minAppVersion: '1.0.0',
        language: 'om',
        isActive: true,
        checksum: 'catalog-checksum',
      );

      final manager = ContentPackManager(
        initializationCleanup: () async {},
      );

      await manager.beginInstallation(pack);

      await manager.completeInstallation(
        pack: pack,
        verifiedChecksum: 'verified-checksum',
        localPath: '/content-packs/uumama_v1',
      );

      await manager.markUpdateAvailable(
        const ContentPack(
          id: 'uumama_v1',
          slug: 'uumama',
          title: 'Uumama',
          description: 'Bineensota, biqiltuu fi haala qilleensaa.',
          version: 2,
          sizeBytes: 20000000,
          lessonCount: 3,
          category: 'Uumama',
          minAppVersion: '1.0.0',
          language: 'om',
          isActive: true,
          checksum: 'new-catalog-checksum',
        ),
      );

      expect(await manager.isInstalled(pack.id), isTrue);
      expect(await manager.getInstalledVersion(pack.id), 1);

      expect(
        await manager.getStatus(pack.id),
        ContentPackInstallationStatus.updateAvailable,
      );
    },
  );

  test(
    'removes a local record without changing lesson progress',
    () async {
      const pack = ContentPack(
        id: 'uumama_v1',
        slug: 'uumama',
        title: 'Uumama',
        description: 'Bineensota, biqiltuu fi haala qilleensaa.',
        version: 1,
        sizeBytes: 18400000,
        lessonCount: 3,
        category: 'Uumama',
        minAppVersion: '1.0.0',
        language: 'om',
        isActive: true,
        checksum: 'catalog-checksum',
      );

      final manager = ContentPackManager(
        initializationCleanup: () async {},
      );

      await manager.beginInstallation(pack);

      await manager.completeInstallation(
        pack: pack,
        verifiedChecksum: 'verified-checksum',
        localPath: '/content-packs/uumama_v1',
      );

      await manager.removePack(pack.id);

      expect(await manager.isInstalled(pack.id), isFalse);

      final preferences = await SharedPreferences.getInstance();

      expect(
        preferences.getString('lesson_progress_v1'),
        '{"animals":1.0}',
      );
    },
  );

  test(
    'successfully updates from v1 to v2 while preserving v1 files',
    () async {
      final v1Archive = await _createPackArchive(
        root: testRoot,
        packId: 'uumama_v1',
        version: 1,
        lessonText: 'Bineensa v1',
      );

      final v2Archive = await _createPackArchive(
        root: testRoot,
        packId: 'uumama_v1',
        version: 2,
        lessonText: 'Bineensa v2',
      );

      final v1Checksum = await _sha256File(v1Archive);
      final v2Checksum = await _sha256File(v2Archive);

      final packV1 = _createPack(
        version: 1,
        checksum: v1Checksum,
        downloadUrl: 'test://uumama-v1',
      );

      final packV2 = _createPack(
        version: 2,
        checksum: v2Checksum,
        downloadUrl: 'test://uumama-v2',
      );

      final downloader = _FakeContentPackDownloader({
        'test://uumama-v1': v1Archive,
        'test://uumama-v2': v2Archive,
      });

      final manager = ContentPackManager(
        downloader: downloader,
        installer: installer,
        initializationCleanup: () async {},
      );

      await manager.downloadAndInstall(
        pack: packV1,
      );

      expect(await manager.getInstalledVersion(packV1.id), 1);

      final v1Directory = await installer.getInstallationDirectory(
        packId: packV1.id,
        version: 1,
      );

      final v1Lesson = File(
        '${v1Directory.path}${Platform.pathSeparator}'
        'lessons${Platform.pathSeparator}lesson.txt',
      );

      expect(await v1Lesson.readAsString(), 'Bineensa v1');

      await manager.updatePack(
        pack: packV2,
      );

      expect(await manager.isInstalled(packV2.id), isTrue);
      expect(await manager.getInstalledVersion(packV2.id), 2);

      final installation = await manager.getInstallation(packV2.id);

      expect(installation, isNotNull);
      expect(installation!.version, 2);
      expect(
        installation.status,
        ContentPackInstallationStatus.installed,
      );

      final v2Directory = await installer.getInstallationDirectory(
        packId: packV2.id,
        version: 2,
      );

      final v2Lesson = File(
        '${v2Directory.path}${Platform.pathSeparator}'
        'lessons${Platform.pathSeparator}lesson.txt',
      );

      expect(await v2Lesson.readAsString(), 'Bineensa v2');

      expect(await v1Directory.exists(), isTrue);
      expect(await v1Lesson.exists(), isTrue);
      expect(await v1Lesson.readAsString(), 'Bineensa v1');

      final temporaryRoot = await installer.getTemporaryRootDirectory();

      final temporaryEntries = await temporaryRoot.list().toList();

      expect(temporaryEntries, isEmpty);
    },
  );

  test(
    'failed v2 update preserves active v1 installation and progress',
    () async {
      final v1Archive = await _createPackArchive(
        root: testRoot,
        packId: 'uumama_v1',
        version: 1,
        lessonText: 'Bineensa v1',
      );

      final v1Checksum = await _sha256File(v1Archive);

      final packV1 = _createPack(
        version: 1,
        checksum: v1Checksum,
        downloadUrl: 'test://uumama-v1',
      );

      final v2Archive = await _createPackArchive(
        root: testRoot,
        packId: 'uumama_v1',
        version: 2,
        lessonText: 'Bineensa v2',
        manifestChecksumOverride:
            '0000000000000000000000000000000000000000000000000000000000000000',
      );

      final v2Checksum = await _sha256File(v2Archive);

      final packV2 = _createPack(
        version: 2,
        checksum: v2Checksum,
        downloadUrl: 'test://uumama-v2',
      );

      final downloader = _FakeContentPackDownloader({
        'test://uumama-v1': v1Archive,
        'test://uumama-v2': v2Archive,
      });

      final manager = ContentPackManager(
        downloader: downloader,
        installer: installer,
        initializationCleanup: () async {},
      );

      await manager.downloadAndInstall(
        pack: packV1,
      );

      final v1Directory = await installer.getInstallationDirectory(
        packId: packV1.id,
        version: 1,
      );

      final v1Lesson = File(
        '${v1Directory.path}${Platform.pathSeparator}'
        'lessons${Platform.pathSeparator}lesson.txt',
      );

      expect(await v1Lesson.readAsString(), 'Bineensa v1');

      await expectLater(
        manager.updatePack(pack: packV2),
        throwsA(isA<ContentPackValidationException>()),
      );

      expect(await manager.isInstalled(packV1.id), isTrue);
      expect(await manager.getInstalledVersion(packV1.id), 1);

      final active = await manager.getInstallation(packV1.id);

      expect(active, isNotNull);
      expect(active!.version, 1);
      expect(
        active.status,
        ContentPackInstallationStatus.installed,
      );

      expect(await v1Directory.exists(), isTrue);
      expect(await v1Lesson.exists(), isTrue);
      expect(await v1Lesson.readAsString(), 'Bineensa v1');

      final pending = await manager.getStatus(packV1.id);

      expect(
        pending,
        ContentPackInstallationStatus.installed,
      );

      final preferences = await SharedPreferences.getInstance();

      expect(
        preferences.getString('lesson_progress_v1'),
        '{"animals":1.0}',
      );

      final v2Directory = await installer.getInstallationDirectory(
        packId: packV2.id,
        version: 2,
      );

      expect(await v2Directory.exists(), isFalse);

      final temporaryRoot = await installer.getTemporaryRootDirectory();

      final temporaryEntries = await temporaryRoot.list().toList();

      expect(temporaryEntries, isEmpty);
    },
  );
}

ContentPack _createPack({
  required int version,
  required String checksum,
  required String downloadUrl,
}) {
  return ContentPack(
    id: 'uumama_v1',
    slug: 'uumama',
    title: 'Uumama',
    description: 'Bineensota, biqiltuu fi haala qilleensaa.',
    version: version,
    sizeBytes: 1000,
    lessonCount: 1,
    category: 'Uumama',
    minAppVersion: '1.0.0',
    language: 'om',
    isActive: true,
    downloadUrl: downloadUrl,
    checksum: checksum,
  );
}

Future<File> _createPackArchive({
  required Directory root,
  required String packId,
  required int version,
  required String lessonText,
  String? manifestChecksumOverride,
}) async {
  final archive = Archive();

  archive.addFile(
    ArchiveFile(
      'lessons/lesson.txt',
      utf8.encode(lessonText).length,
      Uint8List.fromList(utf8.encode(lessonText)),
    ),
  );

  final initialManifest = {
    'id': packId,
    'name': 'Uumama',
    'version': version,
    'min_app_version': '1.0.0',
    'lesson_count': 1,
    'size_bytes': 1000,
    'language': 'om',
    'checksum': manifestChecksumOverride ??
        '0000000000000000000000000000000000000000000000000000000000000000',
    'is_active': true,
  };

  archive.addFile(
    ArchiveFile(
      'manifest.json',
      utf8.encode(jsonEncode(initialManifest)).length,
      Uint8List.fromList(
        utf8.encode(jsonEncode(initialManifest)),
      ),
    ),
  );

  final logicalChecksum =
      const ContentPackValidator().calculateArchiveContentChecksum(archive);

  final manifest = {
    ...initialManifest,
    'checksum': manifestChecksumOverride ?? logicalChecksum,
  };

  final finalArchive = Archive();

  final lessonBytes = Uint8List.fromList(
    utf8.encode(lessonText),
  );

  final manifestBytes = Uint8List.fromList(
    utf8.encode(jsonEncode(manifest)),
  );

  finalArchive.addFile(
    ArchiveFile(
      'lessons/lesson.txt',
      lessonBytes.length,
      lessonBytes,
    ),
  );

  finalArchive.addFile(
    ArchiveFile(
      'manifest.json',
      manifestBytes.length,
      manifestBytes,
    ),
  );

  final encoder = ZipEncoder();
  final bytes = encoder.encode(finalArchive);

  final file = File(
    '${root.path}${Platform.pathSeparator}'
    '${packId}_v$version.zip',
  );

  await file.writeAsBytes(bytes, flush: true);

  return file;
}

Future<String> _sha256File(File file) async {
  final bytes = await file.readAsBytes();
  return sha256.convert(bytes).toString();
}
