import 'dart:typed_data';

/// Platform-neutral persistent store used only for derived colouring data.
/// Implementations intentionally never receive a bundled source asset path to
/// write to, which protects original educational images from overwrites.
class ColoringCacheStore {
  Future<String?> readText(String key) async => null;
  Future<void> writeText(String key, String value) async {}
  Future<Uint8List?> readBytes(String key) async => null;
  Future<String?> writeBytes(String key, Uint8List value) async => null;
  Future<void> delete(String key) async {}
}
