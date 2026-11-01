import 'package:shared_preferences/shared_preferences.dart';

class VideoFavoritesService {
  static const String _key = 'afaankoo_tv_favorite_videos_v1';

  Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  Future<bool> isFavorite(String videoId) async {
    final favorites = await loadFavorites();
    return favorites.contains(videoId);
  }

  Future<bool> toggleFavorite(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = (prefs.getStringList(_key) ?? const <String>[]).toSet();

    if (favorites.contains(videoId)) {
      favorites.remove(videoId);
    } else {
      favorites.add(videoId);
    }

    await prefs.setStringList(_key, favorites.toList());
    return favorites.contains(videoId);
  }
}
