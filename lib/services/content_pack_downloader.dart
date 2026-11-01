import 'dart:io';

import 'package:dio/dio.dart';

/// Progress information emitted while downloading a content pack.
class ContentPackDownloadProgress {
  const ContentPackDownloadProgress({
    required this.receivedBytes,
    required this.totalBytes,
  });

  final int receivedBytes;
  final int totalBytes;

  double? get fraction {
    if (totalBytes <= 0) {
      return null;
    }

    final value = receivedBytes / totalBytes;

    if (value < 0) {
      return 0;
    }

    if (value > 1) {
      return 1;
    }

    return value;
  }
}

/// Downloads content-pack ZIP files to local temporary storage.
///
/// This service is responsible only for downloading bytes.
/// Validation and installation are handled by:
///
/// - ContentPackValidator
/// - ContentPackInstaller
class ContentPackDownloader {
  ContentPackDownloader({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  final Dio _dio;

  CancelToken? _cancelToken;

  bool get isDownloading => _cancelToken != null;

  /// Downloads a content-pack archive.
  ///
  /// The destination is expected to be a temporary ZIP path.
  Future<File> download({
    required String url,
    required String destination,
    void Function(ContentPackDownloadProgress progress)? onProgress,
  }) async {
    if (url.trim().isEmpty) {
      throw ArgumentError.value(
        url,
        'url',
        'Download URL must not be empty.',
      );
    }

    if (destination.trim().isEmpty) {
      throw ArgumentError.value(
        destination,
        'destination',
        'Destination must not be empty.',
      );
    }

    if (_cancelToken != null) {
      throw StateError(
        'A content-pack download is already running.',
      );
    }

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final file = File(destination);

    try {
      final parent = file.parent;

      if (!await parent.exists()) {
        await parent.create(
          recursive: true,
        );
      }

      await _dio.download(
        url,
        destination,
        cancelToken: cancelToken,
        deleteOnError: true,
        onReceiveProgress: (
          received,
          total,
        ) {
          onProgress?.call(
            ContentPackDownloadProgress(
              receivedBytes: received,
              totalBytes: total,
            ),
          );
        },
      );

      if (!await file.exists()) {
        throw const ContentPackDownloadException(
          'The content-pack download completed, '
          'but the file was not created.',
        );
      }

      final length = await file.length();

      if (length <= 0) {
        throw const ContentPackDownloadException(
          'The downloaded content-pack file is empty.',
        );
      }

      return file;
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        throw const ContentPackDownloadCancelledException();
      }

      throw ContentPackDownloadException(
        error.message ??
            'Content-pack download failed.',
        error,
      );
    } finally {
      _cancelToken = null;
    }
  }

  /// Cancels the current download, if one exists.
  void cancel() {
    _cancelToken?.cancel(
      'Content-pack download cancelled.',
    );
  }

  /// Releases the HTTP client.
  Future<void> dispose() async {
    _cancelToken?.cancel(
      'Content-pack downloader disposed.',
    );

    _cancelToken = null;

    _dio.close(
      force: true,
    );
  }
}

/// General download failure.
class ContentPackDownloadException implements Exception {
  const ContentPackDownloadException(
    this.message, [
    this.cause,
  ]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    return 'ContentPackDownloadException: $message';
  }
}

/// Raised when the user cancels a content-pack download.
class ContentPackDownloadCancelledException
    implements Exception {
  const ContentPackDownloadCancelledException();

  @override
  String toString() {
    return 'ContentPackDownloadCancelledException';
  }
}