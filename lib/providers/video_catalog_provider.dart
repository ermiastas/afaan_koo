import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_item.dart';

/// Loads the AfaanKoo TV+ library exclusively from the official Afaan Koo
/// YouTube channel through the Supabase Edge Function.
class VideoCatalogProvider extends ChangeNotifier {
  List<VideoItem> _videos = const [];
  bool _loading = false;
  String? _error;

  static const String _channelId = 'UC8TaFP8aI0fOuqFOqs3tYyQ';
  static const String _functionName = 'youtube-channel-videos';

  List<VideoItem> get videos => List.unmodifiable(_videos);
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> load() async {
    if (_loading) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.functions.invoke(
        _functionName,
        body: const {},
      );

      final data = response.data;
      debugPrint('TV+ YouTube response type: ${data.runtimeType}');
      debugPrint('TV+ YouTube response: $data');
      if (data is! Map) {
        throw const FormatException('YouTube catalog response is invalid.');
      }

      final channel = data['channel'];
      if (channel is! Map || channel['id']?.toString() != _channelId) {
        throw const FormatException(
          'The returned channel is not the official Afaan Koo channel.',
        );
      }

      final rawVideos = data['videos'];
      if (rawVideos is! List) {
        throw const FormatException('YouTube video list is invalid.');
      }

      _videos = rawVideos
          .whereType<Map>()
          .map((item) => _videoFromYouTube(Map<String, dynamic>.from(item)))
          .whereType<VideoItem>()
          .toList()
        ..sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    } catch (e) {
      _error = 'Viidiyoo AfaanKoo TV+ fe\'uu hin dandeenye.';
      _videos = const [];
      debugPrint('AfaanKoo TV+ YouTube error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  VideoItem? _videoFromYouTube(Map<String, dynamic> content) {
    if (content['channelOnly'] != true) return null;

    final channelId = content['youtubeChannelId']?.toString() ?? '';
    if (channelId != _channelId) return null;

    final videoId = content['youtubeVideoId']?.toString().trim() ?? '';
    if (videoId.isEmpty) return null;

    final title = _displayName(
      content['title']?.toString().trim() ?? '',
    );

    return VideoItem(
      id: videoId,
      title: title,
      titleEnglish: '',
      description: content['description']?.toString().trim().isNotEmpty == true
          ? content['description'].toString().trim()
          : 'Viidiyoo Afaan Koo',
      thumbnail: content['thumbnail']?.toString() ?? '',
      videoUrl: content['videoUrl']?.toString() ??
          'https://www.youtube.com/watch?v=$videoId',
      youtubeVideoId: videoId,
      source: 'youtube',
      category: 'AfaanKoo',
      color: _colorFor(title),
      downloadable: false,
    );
  }

  String _displayName(String value) {
    if (value.isEmpty) return 'Viidiyoo AfaanKoo';

    final words = value
        .replaceAll(RegExp(r'[_\\-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (words.isEmpty) return 'Viidiyoo AfaanKoo';

    return words[0].toUpperCase() + words.substring(1);
  }

  Color _colorFor(String name) {
    const colors = [
      Color(0xff1976D2),
      Color(0xff2E7D32),
      Color(0xffE65100),
      Color(0xff7B1FA2),
      Color(0xffC2185B),
      Color(0xff00838F),
    ];

    return colors[
        name.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % colors.length];
  }
}
