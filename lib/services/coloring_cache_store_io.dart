import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ColoringCacheStore {
  Directory? _directory;

  Future<Directory> get _root async {
    if (_directory != null) return _directory!;
    try {
      final appDirectory = await getApplicationSupportDirectory();
      _directory = Directory(
          '${appDirectory.path}${Platform.pathSeparator}coloring_cache');
    } catch (_) {
      // Keeps widget tests and unsupported desktop hosts offline-capable.
      _directory = Directory(
          '${Directory.systemTemp.path}${Platform.pathSeparator}afaan_koo_coloring_cache');
    }
    if (!await _directory!.exists()) await _directory!.create(recursive: true);
    return _directory!;
  }

  String _safeName(String key) =>
      base64Url.encode(utf8.encode(key)).replaceAll('=', '');

  Future<File> _file(String key, String extension) async {
    final root = await _root;
    return File(
        '${root.path}${Platform.pathSeparator}${_safeName(key)}.$extension');
  }

  Future<String?> readText(String key) async {
    final file = await _file(key, 'json');
    return await file.exists() ? file.readAsString() : null;
  }

  Future<void> writeText(String key, String value) async {
    final file = await _file(key, 'json');
    await file.writeAsString(value, flush: true);
  }

  Future<Uint8List?> readBytes(String key) async {
    final file = await _file(key, 'bin');
    return await file.exists() ? file.readAsBytes() : null;
  }

  Future<String?> writeBytes(String key, Uint8List value) async {
    final file = await _file(key, 'bin');
    await file.writeAsBytes(value, flush: true);
    return file.path;
  }

  Future<void> delete(String key) async {
    for (final extension in ['json', 'bin']) {
      final file = await _file(key, extension);
      if (await file.exists()) await file.delete();
    }
  }
}
