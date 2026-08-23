import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class ColoringCacheStore {
  String _key(String key) => 'afaan_koo_coloring_cache_$key';

  Future<String?> readText(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_key(key));
  }

  Future<void> writeText(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key(key), value);
  }

  Future<Uint8List?> readBytes(String key) async {
    final value = await readText(key);
    return value == null ? null : base64Decode(value);
  }

  Future<String?> writeBytes(String key, Uint8List value) async {
    await writeText(key, base64Encode(value));
    return _key(key);
  }

  Future<void> delete(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_key(key));
  }
}
