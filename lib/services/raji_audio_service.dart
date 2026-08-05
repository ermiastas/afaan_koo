import 'audio_service.dart';

/// Named Raji clips routed through the shared audio preferences and player.
class RajiAudioService {
  RajiAudioService._();

  static Future<void> play(String file) async {
    await AudioService().playSound('assets/audio/raji/$file.mp3');
  }

  static Future<void> welcome() => play('welcome');
  static Future<void> correct() => play('excellent');
  static Future<void> wrong() => play('try_again');
  static Future<void> lessonComplete() => play('lesson_complete');
  static Future<void> reward() => play('great_job');
  static Future<void> encourage() => play('encorage');
}
