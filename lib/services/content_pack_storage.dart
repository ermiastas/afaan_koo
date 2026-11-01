import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/content_pack_installation.dart';

class ContentPackRegistryState {
  const ContentPackRegistryState({
    required this.installations,
    required this.pending,
  });

  final Map<String, ContentPackInstallation> installations;
  final Map<String, ContentPackInstallation> pending;
}

class ContentPackStorage {
  ContentPackStorage({
    Future<SharedPreferences> Function()? preferencesLoader,
  }) : _preferencesLoader =
            preferencesLoader ?? SharedPreferences.getInstance;

  static const registryKey = 'content_pack_registry_v1';

  final Future<SharedPreferences> Function()
      _preferencesLoader;

  Future<ContentPackRegistryState> readState() async {
    final preferences = await _preferencesLoader();

    final encoded = preferences.getString(
      registryKey,
    );

    if (encoded == null || encoded.isEmpty) {
      return const ContentPackRegistryState(
        installations: {},
        pending: {},
      );
    }

    try {
      final decoded = jsonDecode(encoded);

      if (decoded is! Map) {
        return const ContentPackRegistryState(
          installations: {},
          pending: {},
        );
      }

      final installations = <String,
          ContentPackInstallation>{};

      final pending = <String,
          ContentPackInstallation>{};

      _readSection(
        decoded['installations'],
        installations,
      );

      _readSection(
        decoded['pending'],
        pending,
      );

      // Backward compatibility with the original registry format.
      if (decoded['installations'] == null &&
          decoded['pending'] == null) {
        _readSection(
          decoded,
          installations,
        );
      }

      return ContentPackRegistryState(
        installations: installations,
        pending: pending,
      );
    } catch (_) {
      return const ContentPackRegistryState(
        installations: {},
        pending: {},
      );
    }
  }

  Future<Map<String, ContentPackInstallation>> read() async {
    final state = await readState();

    return state.installations;
  }

  Future<void> writeState(
    ContentPackRegistryState state,
  ) async {
    final preferences = await _preferencesLoader();

    final encoded = <String, dynamic>{
      'installations': {
        for (final entry
            in state.installations.entries)
          entry.key: entry.value.toJson(),
      },
      'pending': {
        for (final entry in state.pending.entries)
          entry.key: entry.value.toJson(),
      },
    };

    await preferences.setString(
      registryKey,
      jsonEncode(encoded),
    );
  }

  Future<void> write(
    Map<String, ContentPackInstallation>
        installations,
  ) async {
    final current = await readState();

    await writeState(
      ContentPackRegistryState(
        installations: installations,
        pending: current.pending,
      ),
    );
  }

  Future<void> clear() async {
    final preferences = await _preferencesLoader();

    await preferences.remove(
      registryKey,
    );
  }

  void _readSection(
    dynamic section,
    Map<String, ContentPackInstallation>
        target,
  ) {
    if (section is! Map) {
      return;
    }

    section.forEach((key, value) {
      if (key is! String || value is! Map) {
        return;
      }

      final installation =
          ContentPackInstallation.tryFromJson(
        Map<String, dynamic>.from(value),
      );

      if (installation != null &&
          installation.packId == key) {
        target[key] = installation;
      }
    });
  }
}
