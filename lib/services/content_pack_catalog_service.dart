import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/content_pack.dart';
import 'backend_config.dart';
import 'supabase_service.dart';
//import '../data/alphabet_data.dart' as alphabet_data;
//import '../models/letter_example.dart';

class ContentPackCatalogService {
  const ContentPackCatalogService();

  static const _bucket = 'content-packs';
  static const _signedUrlExpirySeconds = 3600;

  Future<List<ContentPack>> fetchActivePacks() async {
    final client = SupabaseService.client;

    if (client == null) {
      debugPrint(
        'CONTENT_PACK_DEBUG: SupabaseService.client is NULL.',
      );
      debugPrint(
        'CONTENT_PACK_DEBUG: BackendConfig.isConfigured='
        '${BackendConfig.isConfigured}',
      );
      return const [];
    }

    debugPrint(
      'CONTENT_PACK_DEBUG: SupabaseService.client is available.',
    );

    try {
      final rows =
          await client.from('content_packs').select().eq('is_active', true);

      debugPrint(
        'CONTENT_PACK_DEBUG: catalog rows=${rows.length}',
      );

      final packs = <ContentPack>[];

      for (final row in rows) {
        final json = Map<String, dynamic>.from(row);

        debugPrint(
          'CONTENT_PACK_DEBUG: catalog row id=${json['id']} '
          'download_url=${json['download_url']}',
        );

        final pack = ContentPack.fromJson(json);

        try {
          json['download_url'] = await _resolveDownloadUrl(
            client,
            pack.downloadUrl,
          );

          debugPrint(
            'CONTENT_PACK_DEBUG: signed URL resolved for '
            '${pack.id}: ${json['download_url'] != null}',
          );
        } catch (e, s) {
          debugPrint(
            'CONTENT_PACK_DEBUG: signed URL FAILED for '
            '${pack.id}: $e',
          );
          debugPrint('$s');
          rethrow;
        }

        packs.add(ContentPack.fromJson(json));
      }

      return packs.toList(growable: false);
    } catch (e, s) {
      debugPrint(
        'CONTENT_PACK_DEBUG: catalog query FAILED: $e',
      );
      debugPrint('$s');
      rethrow;
    }
  }

  Future<String?> _resolveDownloadUrl(
    SupabaseClient client,
    String? value,
  ) async {
    final raw = value?.trim();

    if (raw == null || raw.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(raw);
    final scheme = uri?.scheme.toLowerCase();

    if (scheme == 'http' || scheme == 'https') {
      return raw;
    }

    var storagePath = raw;

    while (storagePath.startsWith('/')) {
      storagePath = storagePath.substring(1);
    }

    if (storagePath.isEmpty ||
        storagePath.contains('..') ||
        storagePath.contains('\\')) {
      throw const FormatException(
        'Invalid content-pack Storage path.',
      );
    }

    return client.storage.from(_bucket).createSignedUrl(
          storagePath,
          _signedUrlExpirySeconds,
        );
  }
}
