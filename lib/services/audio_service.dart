import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Shared, failure-safe audio playback for lessons, games, rewards, and Raji.
///
/// The service is a singleton, but the underlying AudioPlayer is recreated
/// automatically whenever a screen has disposed it. This prevents one screen
/// from permanently disabling audio for the rest of the application.
///
/// Audio operations are serialized so multiple widgets cannot simultaneously
/// stop, configure, and play the same player.
class AudioService {
  factory AudioService() => _instance;

  AudioService._();

  static final AudioService _instance = AudioService._();

  AudioPlayer? _player;

  bool _muted = false;
  double _volume = 1.0;

  /// Serializes operations on the shared player.
  Future<void> _operation = Future<void>.value();

  /// Used to avoid repeatedly triggering the exact same clip immediately.
  String? _lastPath;
  DateTime? _lastPlayTime;

  static const Duration _duplicateWindow = Duration(milliseconds: 250);

  bool get isMuted => _muted;
  double get volume => _volume;

  /// Creates a player when needed.
  ///
  /// This is intentionally lazy so the service does not create a web audio
  /// player before it is actually needed.
  AudioPlayer _ensurePlayer() {
    final existing = _player;

    if (existing != null) {
      return existing;
    }

    final player = AudioPlayer();

    _player = player;

    return player;
  }

  /// Runs an operation after all previous audio operations have completed.
  ///
  /// Errors are contained so one failed audio operation does not break the
  /// queue for subsequent sounds.
  Future<T> _enqueue<T>(Future<T> Function() action) {
    final previous = _operation;

    final next = previous.catchError((Object error, StackTrace stack) {
      debugPrint('Previous audio operation failed: $error');
    }).then((_) => action());

    _operation = next.then<void>(
      (_) {},
      onError: (Object error, StackTrace stack) {
        debugPrint('Audio operation failed: $error');
      },
    );

    return next;
  }

  Future<void> setMuted(bool value) {
    return _enqueue<void>(() async {
      _muted = value;

      final player = _player;
      if (player == null) {
        return;
      }

      try {
        await player.setVolume(_muted ? 0.0 : _volume);
      } catch (error) {
        debugPrint('Audio mute update failed: $error');
      }
    });
  }

  Future<void> setVolume(double value) {
    return _enqueue<void>(() async {
      _volume = value.clamp(0.0, 1.0).toDouble();

      final player = _player;
      if (player == null) {
        return;
      }

      try {
        await player.setVolume(_muted ? 0.0 : _volume);
      } catch (error) {
        debugPrint('Audio volume update failed: $error');
      }
    });
  }

  /// Preloads packaged clips where supported by the platform.
  ///
  /// A failed preload is intentionally non-fatal because the clip can still
  /// be attempted when requested.
  Future<void> preload(Iterable<String> paths) {
    return _enqueue<void>(() async {
      final player = _ensurePlayer();

      for (final path in paths) {
        final trimmed = path.trim();

        if (trimmed.isEmpty) {
          continue;
        }

        final assetPath = _normaliseAssetPath(trimmed);

        try {
          await player.setSource(AssetSource(assetPath));
        } catch (error) {
          debugPrint('Audio preload skipped for $path: $error');
        }
      }
    });
  }

  /// Plays an application audio file.
  ///
  /// Returns true when playback was successfully started and false when the
  /// request was muted, invalid, or failed.
  Future<bool> playSound(String path) {
    final trimmedPath = path.trim();

    if (_muted || trimmedPath.isEmpty) {
      return Future<bool>.value(false);
    }

    return _enqueue<bool>(() async {
      if (_muted) {
        return false;
      }

      final now = DateTime.now();

      // Prevent accidental duplicate calls from widgets that may initialize
      // more than once within a very short period.
      if (_lastPath == trimmedPath &&
          _lastPlayTime != null &&
          now.difference(_lastPlayTime!) < _duplicateWindow) {
        debugPrint('Duplicate audio request skipped: $trimmedPath');
        return false;
      }

      _lastPath = trimmedPath;
      _lastPlayTime = now;

      // Skip missing bundled assets before attempting playback.
      if (!trimmedPath.startsWith('/')) {
        final assetPath = _normaliseAssetPath(trimmedPath);

        try {
          await rootBundle.load('assets/$assetPath');
        } catch (_) {
          debugPrint('Audio asset not found; playback skipped: $trimmedPath');
          return false;
        }
      }

      AudioPlayer player = _ensurePlayer();

      try {
        // Stop anything currently playing before starting the new clip.
        await player.stop();

        // Reapply the current volume because a player may have just been
        // recreated after a previous screen disposed it.
        await player.setVolume(_muted ? 0.0 : _volume);

        if (trimmedPath.startsWith('/')) {
          await player.play(DeviceFileSource(trimmedPath));
        } else {
          await player.play(
            AssetSource(_normaliseAssetPath(trimmedPath)),
          );
        }

        return true;
      } catch (error) {
        debugPrint(
          'Audio playback failed for $trimmedPath: $error',
        );

        // The player may have become invalid between operations, especially
        // on Flutter Web. Remove it so the next request gets a fresh player.
        if (identical(_player, player)) {
          _player = null;

          try {
            await player.dispose();
          } catch (_) {
            // The player may already have been disposed.
          }
        }

        return false;
      }
    });
  }

  Future<bool> play(String path) => playSound(path);

  Future<void> stop() {
    return _enqueue<void>(() async {
      final player = _player;

      if (player == null) {
        return;
      }

      try {
        await player.stop();
      } catch (error) {
        debugPrint('Audio stop failed: $error');
      }
    });
  }

  /// Releases the current player.
  ///
  /// IMPORTANT:
  /// AudioService is a singleton, so disposing it does NOT permanently
  /// disable the service. The next playback request automatically creates a
  /// new AudioPlayer.
  Future<void> dispose() {
    return _enqueue<void>(() async {
      final player = _player;

      if (player == null) {
        return;
      }

      _player = null;

      try {
        await player.stop();
      } catch (error) {
        debugPrint('Audio stop during dispose failed: $error');
      }

      try {
        await player.dispose();
      } catch (error) {
        debugPrint('Audio dispose failed: $error');
      }
    });
  }

  String _normaliseAssetPath(String path) {
    final trimmed = path.trim();

    if (trimmed.startsWith('assets/')) {
      return trimmed.substring('assets/'.length);
    }

    return trimmed;
  }
}
