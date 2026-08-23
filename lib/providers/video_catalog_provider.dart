import 'package:flutter/material.dart';

import '../models/video_item.dart';
import '../services/local_content_service.dart';

/// The TV library is driven by videos an administrator adds. Display names are
/// inferred from a title when present, otherwise from the selected file or URL.
class VideoCatalogProvider extends ChangeNotifier {
  VideoCatalogProvider({LocalContentService? contentService})
      : _contentService = contentService ?? LocalContentService();

  final LocalContentService _contentService;
  List<VideoItem> _videos = const [];
  bool _loading = false;

  List<VideoItem> get videos => List.unmodifiable(_videos);
  bool get isLoading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      final entries = await _contentService.getContent('videos');
      _videos = entries
          .map(_videoFromContent)
          .whereType<VideoItem>()
          .toList()
        ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  VideoItem? _videoFromContent(Map<String, dynamic> content) {
    final source = _firstNonEmpty([
      content['videoUrl'],
      content['video'],
      content['source'],
    ]);
    if (source.isEmpty) return null;

    final title = _displayName(_firstNonEmpty([content['title'], source]));
    return VideoItem(
      id: content['id']?.toString() ?? source,
      title: title,
      titleEnglish: _firstNonEmpty([content['english'], content['titleEnglish']]),
      description: _firstNonEmpty([content['description'], 'Viidiyoo $title']),
      thumbnail: _firstNonEmpty([content['image'], content['thumbnail']]),
      videoUrl: source,
      category: title.substring(0, 1).toUpperCase(),
      color: _colorFor(title),
      rewardXP: _toInt(content['rewardXP'], fallback: 20),
    );
  }

  String _firstNonEmpty(Iterable<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  String _displayName(String value) {
    final withoutQuery = value.split('?').first;
    final fileName = withoutQuery.split(RegExp(r'[\\/]')).last;
    final withoutExtension = fileName.replaceFirst(RegExp(r'\.[^.]+$'), '');
    final words = withoutExtension
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (words.isEmpty) return 'Viidiyoo haaraa';
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
    return colors[name.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % colors.length];
  }

  int _toInt(Object? value, {required int fallback}) =>
      int.tryParse(value?.toString() ?? '') ?? fallback;
}
