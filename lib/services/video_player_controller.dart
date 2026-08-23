import 'dart:typed_data';

import 'package:video_player/video_player.dart';

import 'video_player_controller_stub.dart'
    if (dart.library.io) 'video_player_controller_io.dart' as platform;

/// Creates a video controller for:
/// - Flutter assets
/// - Network URLs
/// - Selected local video files
/// - Video bytes on Web
VideoPlayerController createVideoPlayerController(
  String source,
) {
  return platform.createVideoPlayerController(source);
}

/// Creates a video controller directly from bytes.
///
/// This is useful for Flutter Web because local file paths
/// are not available on Web.
Future<VideoPlayerController> createVideoPlayerControllerFromBytes(
  Uint8List bytes,
  String fileName,
) {
  // The platform implementation is supplied by conditional imports.
  // ignore: undefined_function
  return platform.createVideoPlayerControllerFromBytes(
    bytes,
    fileName,
  );
}