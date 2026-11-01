import 'dart:io';
import 'dart:typed_data';

import 'package:video_player/video_player.dart';

Future<VideoPlayerController> createVideoPlayerControllerFromBytes(
  Uint8List bytes,
  String fileName,
) {
  throw UnsupportedError(
    'Byte-based video playback is only supported on Web.',
  );
}

VideoPlayerController createVideoPlayerController(String source) {
  if (source.trim().isEmpty) {
    throw ArgumentError('Video source cannot be empty.');
  }

  if (source.startsWith('assets/')) {
    return VideoPlayerController.asset(source);
  }

  if (source.startsWith('http://') || source.startsWith('https://')) {
    return VideoPlayerController.networkUrl(
      Uri.parse(source),
    );
  }

  final file = File(source);

  if (!file.existsSync()) {
    throw FileSystemException(
      'Video file does not exist.',
      source,
    );
  }

  return VideoPlayerController.file(file);
}
