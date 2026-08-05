import 'dart:io';

import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Media storage backed by a Supabase Storage bucket named `media`.
class StorageService {
  StorageService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final Logger logger = Logger();
  static const _bucket = 'media';

  Future<String?> uploadImage(String filePath, String folder) =>
      _upload(filePath, folder, 'jpg');

  Future<String?> uploadAudio(String filePath, String folder) =>
      _upload(filePath, folder, 'mp3');

  Future<String?> _upload(String filePath, String folder, String extension) async {
    try {
      final path = '$folder/${DateTime.now().millisecondsSinceEpoch}.$extension';
      await _client.storage.from(_bucket).upload(path, File(filePath));
      return _client.storage.from(_bucket).getPublicUrl(path);
    } catch (error, stackTrace) {
      logger.e('Media upload failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> deleteFile(String storagePath) async {
    try {
      await _client.storage.from(_bucket).remove([storagePath]);
    } catch (error, stackTrace) {
      logger.e('Media deletion failed', error: error, stackTrace: stackTrace);
    }
  }
}
