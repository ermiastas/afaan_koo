
// ignore_for_file: uri_does_not_exist, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RajiTtsService {
  RajiTtsService({
    FlutterTts? tts,
  }) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  bool _initialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // ---------------------------------------------------
      // General speech settings
      // ---------------------------------------------------

      await _tts.setPitch(1.05);
      await _tts.setSpeechRate(0.42);
      await _tts.setVolume(1.0);

      // ---------------------------------------------------
      // Speech callbacks
      // ---------------------------------------------------

      _tts.setStartHandler(() {
        _isSpeaking = true;
      });

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _tts.setCancelHandler(() {
        _isSpeaking = false;
      });

      _tts.setErrorHandler((message) {
        _isSpeaking = false;

        debugPrint(
          'Raji TTS error: $message',
        );
      });

      _initialized = true;
    } catch (e) {
      debugPrint(
        'Raji TTS initialization failed: $e',
      );
    }
  }

  Future<bool> isOromoAvailable() async {
    await initialize();

    try {
      final languages =
          await _tts.getLanguages;

      if (languages is! List) {
        return false;
      }

      for (final language
          in languages) {
        final value =
            language.toString()
                .toLowerCase();

        if (value == 'om-et' ||
            value.startsWith('om-')) {
          return true;
        }
      }
    } catch (e) {
      debugPrint(
        'Could not check Oromo TTS: $e',
      );
    }

    return false;
  }

  Future<void> speak(
    String text,
  ) async {
    final cleanText =
        text.trim();

    if (cleanText.isEmpty) {
      return;
    }

    await initialize();

    try {
      await stop();

      final hasOromo =
          await isOromoAvailable();

      if (hasOromo) {
        await _tts.setLanguage(
          'om-ET',
        );
      } else {
        // -------------------------------------------------
        // Important:
        //
        // We do NOT pretend another language is Oromo.
        // If om-ET isn't available, we still attempt to
        // speak using the device's default voice.
        //
        // Later we can replace this with a dedicated
        // Oromo TTS backend or recorded Afaan Oromo audio.
        // -------------------------------------------------
        debugPrint(
          '⚠️ Oromo TTS voice not available '
          'on this device.',
        );
      }

      _isSpeaking = true;

      await _tts.speak(
        cleanText,
      );
    } catch (e) {
      _isSpeaking = false;

      debugPrint(
        'Raji TTS speak failed: $e',
      );
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (e) {
      debugPrint(
        'Raji TTS stop failed: $e',
      );
    }
  }

  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      debugPrint(
        'Raji TTS pause failed: $e',
      );
    }
  }

  Future<void> dispose() async {
    try {
      await stop();
    } catch (_) {}
  }
}
