import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Shared, failure-safe audio playback for lessons, games, and rewards.
///
/// A single player avoids overlapping pronunciation clips and retains the
/// current volume/mute preference for the full app session.
class AudioService {
  factory AudioService() => _instance;

  AudioService._();

  static final AudioService _instance = AudioService._();
  final AudioPlayer _player = AudioPlayer();

  bool _muted = false;
  double _volume = 1;

  bool get isMuted => _muted;
  double get volume => _volume;

  Future<void> setMuted(bool value) async {
    _muted = value;
    await _player.setVolume(value ? 0 : _volume);
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0).toDouble();
    await _player.setVolume(_muted ? 0 : _volume);
  }

  /// Preloads packaged clips where the platform supports it. A failed preload
  /// is intentionally non-fatal: the clip can still be attempted on demand.
  Future<void> preload(Iterable<String> paths) async {
    for (final path in paths) {
      final assetPath = _normaliseAssetPath(path);
      try {
        await _player.setSource(AssetSource(assetPath));
      } catch (error) {
        debugPrint('Audio preload skipped for $path: $error');
      }
    }
  }

  Future<bool> playSound(String path) async {
    if (_muted || path.trim().isEmpty) return false;

    try {
      await _player.stop();
      await _player.setVolume(_volume);
      if (path.startsWith('/')) {
        await _player.play(DeviceFileSource(path));
      } else {
        await _player.play(AssetSource(_normaliseAssetPath(path)));
      }
      return true;
    } catch (error) {
      debugPrint('Audio playback failed for $path: $error');
      return false;
    }
  }

  Future<bool> play(String path) => playSound(path);

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();

  String _normaliseAssetPath(String path) =>
      path.startsWith('assets/') ? path.substring('assets/'.length) : path;
}
