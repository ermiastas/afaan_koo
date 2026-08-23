import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class PickedMedia {
  const PickedMedia({
    required this.name,
    required this.bytes,
    this.path,
  });

  final String name;
  final Uint8List bytes;
  final String? path;
}

class MediaService {
  final ImagePicker picker = ImagePicker();

  /// Pick image from gallery.
  ///
  /// Uses bytes so it works on Flutter Web as well as mobile.
  Future<PickedMedia?> pickImage() async {
    final result = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (result == null) {
      return null;
    }

    final bytes = await result.readAsBytes();

    return PickedMedia(
      name: result.name,
      bytes: bytes,
      path: result.path,
    );
  }

  /// Pick audio file.
  ///
  /// `bytes` is required for Flutter Web because `path`
  /// is not available there.
  Future<PickedMedia?> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;

    final bytes = file.bytes;

    if (bytes == null) {
      throw Exception('Unable to read selected audio file.');
    }

    return PickedMedia(
      name: file.name,
      bytes: bytes,
      path: file.path,
    );
  }

  /// Pick video file.
  ///
  /// `bytes` is required for Flutter Web because `path`
  /// is not available there.
  Future<PickedMedia?> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;

    final bytes = file.bytes;

    if (bytes == null) {
      throw Exception('Unable to read selected video file.');
    }

    return PickedMedia(
      name: file.name,
      bytes: bytes,
      path: file.path,
    );
  }
}