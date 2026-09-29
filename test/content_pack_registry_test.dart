import 'package:afaan_koo_app/models/content_pack.dart';
import 'package:afaan_koo_app/services/content_pack_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'lesson_progress_v1': '{"animals":1.0}',
    });
  });

  test('persists an installed pack without changing lesson progress', () async {
    final registry = ContentPackRegistry();
    await registry.load();

    await registry.markInstalled(
      packId: 'uumama_v1',
      version: 1,
      sizeBytes: 18400000,
      checksum: 'verified-checksum',
      localPath: '/content-packs/uumama_v1',
      installedAt: DateTime.utc(2026, 9, 29),
    );

    final reloadedRegistry = ContentPackRegistry();
    await reloadedRegistry.load();

    expect(reloadedRegistry.isInstalled('uumama_v1'), isTrue);
    expect(reloadedRegistry.getInstalledVersion('uumama_v1'), 1);
    expect(
      reloadedRegistry.getStatus('uumama_v1'),
      ContentPackInstallationStatus.installed,
    );

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('lesson_progress_v1'), '{"animals":1.0}');
  });

  test('retains usable content when an update is available', () async {
    final registry = ContentPackRegistry();
    await registry.load();

    await registry.markInstalled(
      packId: 'uumama_v1',
      version: 1,
      sizeBytes: 18400000,
      checksum: 'verified-checksum',
      localPath: '/content-packs/uumama_v1',
    );
    await registry.recordStatus(
      packId: 'uumama_v1',
      version: 1,
      status: ContentPackInstallationStatus.updateAvailable,
    );

    expect(registry.isInstalled('uumama_v1'), isTrue);
    expect(
      registry.getStatus('uumama_v1'),
      ContentPackInstallationStatus.updateAvailable,
    );
  });

  test('removes only the pack registry entry', () async {
    final registry = ContentPackRegistry();
    await registry.load();
    await registry.markInstalled(
      packId: 'uumama_v1',
      version: 1,
      sizeBytes: 18400000,
      checksum: 'verified-checksum',
      localPath: '/content-packs/uumama_v1',
    );

    await registry.remove('uumama_v1');

    expect(registry.isInstalled('uumama_v1'), isFalse);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('lesson_progress_v1'), '{"animals":1.0}');
  });
}
