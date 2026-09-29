import 'package:afaan_koo_app/models/content_pack.dart';
import 'package:afaan_koo_app/services/content_pack_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'lesson_progress_v1': '{"animals":1.0}',
    });
  });

  test('records a locally completed installation', () async {
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

  test('keeps the installed version usable when an update is available', () async {
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
  });

  test('removes a local record without changing lesson progress', () async {
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
    expect(preferences.getString('lesson_progress_v1'), '{"animals":1.0}');
  });
}
