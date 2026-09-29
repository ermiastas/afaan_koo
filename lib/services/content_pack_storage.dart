import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/content_pack_installation.dart';

/// SharedPreferences adapter for the local content-pack registry.
class ContentPackStorage {
  ContentPackStorage({
    Future<SharedPreferences> Function()? preferencesLoader,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const registryKey = 'content_pack_registry_v1';

  final Future<SharedPreferences> Function() _preferencesLoader;

  Future<Map<String, ContentPackInstallation>> read() async {
    final preferences = await _preferencesLoader();
    final encoded = preferences.getString(registryKey);

    if (encoded == null || encoded.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) {
        return {};
      }

      final installations = <String, ContentPackInstallation>{};
      decoded.forEach((key, value) {
        if (key is! String || value is! Map) {
          return;
        }

        final installation = ContentPackInstallation.tryFromJson(
          Map<String, dynamic>.from(value),
        );
        if (installation != null && installation.packId == key) {
          installations[key] = installation;
        }
      });

      return installations;
    } on FormatException {
      return {};
    }
  }

  Future<void> write(Map<String, ContentPackInstallation> installations) async {
    final preferences = await _preferencesLoader();
    final encoded = <String, dynamic>{
      for (final entry in installations.entries) entry.key: entry.value.toJson(),
    };

    await preferences.setString(registryKey, jsonEncode(encoded));
  }

  Future<void> clear() async {
    final preferences = await _preferencesLoader();
    await preferences.remove(registryKey);
  }
}
