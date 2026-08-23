import 'dart:typed_data';

import 'package:video_player/video_player.dart';

VideoPlayerController createVideoPlayerController(String source) {
  if (source.startsWith('assets/')) {
    return VideoPlayerController.asset(source);
  }

  if (source.startsWith('http://') ||
      source.startsWith('https://')) {
    return VideoPlayerController.networkUrl(
      Uri.parse(source),
    );
  }

  throw UnsupportedError(
    'Local video paths are not supported on this platform. '
    'Use video bytes instead.',
  );
}

Future<VideoPlayerController> createVideoPlayerControllerFromBytes(
  Uint8List bytes,
  String fileName,
) {
  throw UnsupportedError(
    'Byte-based video playback is not supported by this platform.',
  );
}