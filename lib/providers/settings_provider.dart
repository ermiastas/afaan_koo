import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/audio_service.dart';

/// Persists child-safe app preferences independently from lesson progress.
class SettingsProvider extends ChangeNotifier {
  static const _themeKey = 'settings_theme_mode_v1';
  static const _soundKey = 'settings_sound_v1';
  static const _musicKey = 'settings_music_v1';
  static const _notificationsKey = 'settings_notifications_v1';
  static const _volumeKey = 'settings_volume_v1';

  ThemeMode _themeMode = ThemeMode.system;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _notificationsEnabled = false;
  double _volume = 1;

  ThemeMode get themeMode => _themeMode;
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  double get volume => _volume;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedTheme = preferences.getString(_themeKey);
    _themeMode = switch (savedTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _soundEnabled = preferences.getBool(_soundKey) ?? true;
    _musicEnabled = preferences.getBool(_musicKey) ?? true;
    _notificationsEnabled = preferences.getBool(_notificationsKey) ?? false;
    _volume = preferences.getDouble(_volumeKey) ?? 1;
    await AudioService().setVolume(_volume);
    await AudioService().setMuted(!_soundEnabled);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeKey, value.name);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundKey, value);
    await AudioService().setMuted(!value);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool value) async {
    _musicEnabled = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_musicKey, value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0).toDouble();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(_volumeKey, _volume);
    await AudioService().setVolume(_volume);
    notifyListeners();
  }
}
