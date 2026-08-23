
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RajiSpeechService {
  RajiSpeechService._();

  static final FlutterTts _tts =
      FlutterTts();

  static bool _initialized = false;

  static bool _available = true;

  static String? _selectedLanguage;

  // =====================================================
  // INITIALIZE
  // =====================================================

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      if (kIsWeb) {
        await _initializeWeb();
      } else if (Platform.isAndroid) {
        await _initializeAndroid();
      } else if (Platform.isIOS) {
        await _initializeIOS();
      }

      await _configure();

      _initialized = true;
    } catch (e) {
      debugPrint(
        'Raji TTS initialization failed: $e',
      );

      _available = false;
    }
  }

  // =====================================================
  // WEB
  // =====================================================

  static Future<void>
      _initializeWeb() async {
    try {
      await _tts.awaitSpeakCompletion(
        true,
      );
    } catch (e) {
      debugPrint(
        'Raji Web TTS setup failed: $e',
      );
    }
  }

  // =====================================================
  // ANDROID
  // =====================================================

  static Future<void>
      _initializeAndroid() async {
    try {
      await _tts.awaitSpeakCompletion(
        true,
      );

      await _tts.setQueueMode(
        1,
      );
    } catch (e) {
      debugPrint(
        'Raji Android TTS setup failed: $e',
      );
    }
  }

  // =====================================================
  // IOS
  // =====================================================

  static Future<void>
      _initializeIOS() async {
    try {
      await _tts.awaitSpeakCompletion(
        true,
      );
    } catch (e) {
      debugPrint(
        'Raji iOS TTS setup failed: $e',
      );
    }
  }

  // =====================================================
  // CONFIGURE
  // =====================================================

  static Future<void> _configure() async {
    try {
      await _tts.setSpeechRate(
        0.42,
      );

      await _tts.setPitch(
        1.05,
      );

      await _tts.setVolume(
        1.0,
      );

      await _selectBestLanguage();
    } catch (e) {
      debugPrint(
        'Raji TTS configuration failed: $e',
      );
    }
  }

  // =====================================================
  // FIND BEST LANGUAGE
  // =====================================================

  static Future<void>
      _selectBestLanguage() async {
    try {
      final languages =
          await _tts.getLanguages;

      if (languages is! List) {
        return;
      }

      final available =
          languages
              .map(
                (language) =>
                    language.toString(),
              )
              .toList();

      debugPrint(
        'Available TTS languages: '
        '$available',
      );

      final candidates = <String>[
        'om-ET',
        'om',
        'sw-KE',
        'sw',
        'en-US',
        'en',
      ];

      for (final candidate
          in candidates) {
        if (available.contains(
          candidate,
        )) {
          _selectedLanguage =
              candidate;

          await _tts.setLanguage(
            candidate,
          );

          debugPrint(
            'Raji TTS language: '
            '$candidate',
          );

          return;
        }
      }

      // Some Android engines return
      // language codes with different
      // capitalization.

      for (final candidate
          in candidates) {
        final match =
            available.cast<String?>().firstWhere(
                  (language) =>
                      language
                          ?.toLowerCase() ==
                      candidate
                          .toLowerCase(),
                  orElse: () => null,
                );

        if (match != null) {
          _selectedLanguage =
              match;

          await _tts.setLanguage(
            match,
          );

          return;
        }
      }

      debugPrint(
        'No Oromo-compatible TTS '
        'voice was found.',
      );
    } catch (e) {
      debugPrint(
        'Could not detect TTS languages: '
        '$e',
      );
    }
  }

  // =====================================================
  // SPEAK
  // =====================================================

  static Future<void> speak(
    String text,
  ) async {
    final cleanText =
        text.trim();

    if (cleanText.isEmpty) {
      return;
    }

    await initialize();

    if (!_available) {
      return;
    }

    try {
      await stop();

      final prepared =
          _prepareOromoText(
        cleanText,
      );

      await _tts.speak(
        prepared,
      );
    } catch (e) {
      debugPrint(
        'Raji TTS speak failed: $e',
      );
    }
  }

  // =====================================================
  // STOP
  // =====================================================

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint(
        'Raji TTS stop failed: $e',
      );
    }
  }

  // =====================================================
  // PAUSE
  // =====================================================

  static Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      debugPrint(
        'Raji TTS pause failed: $e',
      );
    }
  }

  // =====================================================
  // SPEECH RATE
  // =====================================================

  static Future<void>
      setSpeechRate(
    double rate,
  ) async {
    await initialize();

    try {
      await _tts.setSpeechRate(
        rate.clamp(
          0.25,
          0.75,
        ),
      );
    } catch (e) {
      debugPrint(
        'Raji speech rate failed: $e',
      );
    }
  }

  // =====================================================
  // PITCH
  // =====================================================

  static Future<void> setPitch(
    double pitch,
  ) async {
    await initialize();

    try {
      await _tts.setPitch(
        pitch.clamp(
          0.5,
          1.5,
        ),
      );
    } catch (e) {
      debugPrint(
        'Raji pitch failed: $e',
      );
    }
  }

  // =====================================================
  // AVAILABILITY
  // =====================================================

  static bool get isAvailable =>
      _available;

  // =====================================================
  // LANGUAGE
  // =====================================================

  static String?
      get selectedLanguage =>
          _selectedLanguage;

  // =====================================================
  // OROMO TEXT PREPARATION
  // =====================================================

  static String _prepareOromoText(
    String text,
  ) {
    var result =
        text.trim();

    // ---------------------------------------------------
    // Remove markdown formatting
    // ---------------------------------------------------

    result = result.replaceAll(
      RegExp(r'\*\*(.*?)\*\*'),
      r'$1',
    );

    result = result.replaceAll(
      RegExp(r'\*(.*?)\*'),
      r'$1',
    );

    result = result.replaceAll(
      RegExp(r'#+\s*'),
      '',
    );

    // ---------------------------------------------------
    // Remove excessive whitespace
    // ---------------------------------------------------

    result = result.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    // ---------------------------------------------------
    // Small pronunciation pauses
    // ---------------------------------------------------

    result = result.replaceAll(
      '!',
      '! ',
    );

    result = result.replaceAll(
      '?',
      '? ',
    );

    result = result.replaceAll(
      ':',
      ': ',
    );

    result = result.replaceAll(
      ';',
      '; ',
    );

    result = result.replaceAll(
      '  ',
      ' ',
    );

    return result.trim();
  }
}
