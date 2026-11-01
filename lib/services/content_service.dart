import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/animal.dart';
import '../models/word_item.dart';
import '../models/letter.dart';
import '../models/letter_example.dart';
import '../data/alphabet_data.dart' as alphabet_data;
import '../models/quiz.dart';
import '../models/color_item.dart';
import '../models/number_item.dart';
import '../models/story.dart';
import '../models/song.dart';
import '../models/assistant_message.dart';

import 'json_loader.dart';
import 'local_content_service.dart';
import 'content_pack_manager.dart';
import 'content_pack_content_service.dart';

class ContentService {
  String? _quizCategoryForLesson(String lessonId) {
    if (lessonId.startsWith('math_')) return 'math';

    const mapping = <String, String>{
      'alphabet': 'alphabet',
      'qubee': 'alphabet',
      'animals': 'animals',
      'body': 'body',
      'colors': 'colors',
      'fruit': 'fruits',
      'fruits': 'fruits',
      'number': 'numbers',
      'numbers': 'numbers',
      'homeObject': 'objects',
      'home_objects': 'objects',
      'plants': 'nature',
      'school': 'school',
      'school_supplies': 'school',
      'traffic': 'traffic',
      'vegetables': 'vegetables',
      'math': 'math',
    };

    return mapping[lessonId];
  }

  ContentService({
    ContentPackManager? contentPackManager,
  }) : _contentPackManager = contentPackManager ?? ContentPackManager() {
    _packContentService = ContentPackContentService(
      contentPackManager: _contentPackManager,
    );
  }

  final JsonLoader jsonLoader = JsonLoader();
  final LocalContentService local = LocalContentService();
  final ContentPackManager _contentPackManager;
  late final ContentPackContentService _packContentService;

  /// Loads content from an optional installed pack, bundled JSON,
  /// and local content.
  ///
  /// Sources are merged in this order of priority:
  /// 1. Installed pack
  /// 2. Bundled JSON
  /// 3. Local content
  ///
  /// An item with an existing ID is not overwritten by a lower-priority
  /// source. If the pack or requested file is missing, the other sources
  /// remain available.
  ///
  /// Pass packId and fileName only after verifying the pack catalog
  /// and the installed pack's actual JSON filename.
  Future<List<dynamic>> getMergedContent(
    String category,
    Future<List<dynamic>> Function() jsonFallback, {
    String? packId,
    String? fileName,
  }) async {
    List<dynamic>? installedData;

    final resolvedPackId = packId?.trim();
    final resolvedFileName = fileName?.trim();

    if (resolvedPackId != null &&
        resolvedPackId.isNotEmpty &&
        resolvedFileName != null &&
        resolvedFileName.isNotEmpty) {
      installedData = await _packContentService.readLessonList(
        resolvedPackId,
        resolvedFileName,
      );
    }

    final jsonData = await jsonFallback();
    final localData = await local.getContent(category);

    final merged = <dynamic>[];
    final seenIds = <Object?>{};

    void addItems(List<dynamic> items) {
      for (final item in items) {
        if (item is Map && item['id'] != null) {
          final id = item['id'];

          if (!seenIds.add(id)) {
            continue;
          }
        }

        merged.add(item);
      }
    }

    if (installedData != null) {
      addItems(installedData);
    }

    addItems(jsonData);
    addItems(localData);

    return merged;
  }

  Future<List<Animal>> getAnimals() async {
    final installedData = await _loadInstalledAnimals();

    final data = installedData ??
        await getMergedContent(
          "animals",
          jsonLoader.animals,
        );

    return data.map((item) {
      return Animal.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<List<dynamic>?> _loadInstalledAnimals() async {
    for (final packId in ['animals_v2']) {
      try {
        final installation = await _contentPackManager.getInstallation(packId);

        if (installation == null ||
            !installation.isUsable ||
            installation.localPath == null ||
            installation.localPath!.trim().isEmpty) {
          continue;
        }

        final decoded = await _packContentService.readLessonList(
          packId,
          'animals.json',
        );

        if (decoded == null) continue;

        final animals = <Map<String, dynamic>>[];

        for (final item in decoded.whereType<Map>()) {
          final resolved = await _resolveInstalledAnimalPaths(
            Map<String, dynamic>.from(item),
            installation.localPath!,
            packId: packId,
          );

          animals.add(resolved);
        }

        return animals;
      } catch (error) {
        debugPrint('Could not load animal pack "$packId": $error');
      }
    }

    return null;
  }

  Future<List<dynamic>?> _loadInstalledNumbers() async {
    try {
      final installation = await _contentPackManager.getInstallation(
        'numbers',
      );

      if (installation == null ||
          !installation.isUsable ||
          installation.localPath == null ||
          installation.localPath!.trim().isEmpty) {
        return null;
      }

      final decoded = await _packContentService.readLessonList(
        'numbers',
        'numbers.json',
      );

      if (decoded == null) {
        return null;
      }

      return decoded.whereType<Map>().map((item) {
        final number = Map<String, dynamic>.from(item);
        final image = number['image'];

        if (image is String) {
          final relativePath = image.replaceAll('\\', '/');

          if (_isSafePackMediaPath(relativePath)) {
            number['image'] = _joinPath(
              installation.localPath!,
              relativePath.replaceAll('/', Platform.pathSeparator),
            );
          }
        }

        return number;
      }).toList(growable: false);
    } catch (_) {
      // Keep bundled content as the fallback.
      return null;
    }
  }

  Future<Map<String, dynamic>> _resolveInstalledAnimalPaths(
    Map<String, dynamic> item,
    String installationPath, {
    required String packId,
  }) async {
    final resolved = Map<String, dynamic>.from(item);
    final image = resolved['image'];

    if (image is! String || image.isEmpty) {
      return resolved;
    }

    // Keep already-resolved data URIs unchanged.
    if (image.startsWith('data:image/')) {
      return resolved;
    }

    final relativePath = image.replaceAll('\\', '/');

    if (!_isSafePackMediaPath(relativePath)) {
      return resolved;
    }

    if (kIsWeb) {
      final bytes = await _packContentService.readMediaBytes(
        packId,
        relativePath,
      );

      if (bytes == null || bytes.isEmpty) {
        return resolved;
      }

      final extension = relativePath.split('.').last.toLowerCase();

      const mimeTypes = <String, String>{
        'png': 'image/png',
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'webp': 'image/webp',
        'gif': 'image/gif',
      };

      final mimeType = mimeTypes[extension];

      if (mimeType == null) {
        debugPrint('Unsupported animal image format: $extension');
        return resolved;
      }

      resolved['image'] = 'data:$mimeType;base64,${base64Encode(bytes)}';

      return resolved;
    }

    resolved['image'] = _joinPath(
      installationPath,
      relativePath.replaceAll('/', Platform.pathSeparator),
    );

    return resolved;
  }

  bool _isSafePackMediaPath(String path) {
    if (!path.startsWith('media/')) {
      return false;
    }

    if (path.contains('/../') || path.endsWith('/..') || path.contains('../')) {
      return false;
    }

    return true;
  }

  String _joinPath(
    String first, [
    String? second,
    String? third,
    String? fourth,
  ]) {
    final segments = <String>[
      first,
      if (second != null && second.trim().isNotEmpty) second,
      if (third != null && third.trim().isNotEmpty) third,
      if (fourth != null && fourth.trim().isNotEmpty) fourth,
    ];

    if (segments.isEmpty) {
      return '';
    }

    return segments
        .map((segment) => segment.replaceAll('\\', Platform.pathSeparator))
        .map((segment) => segment.replaceAll(RegExp(r'^[\\/]+|[\\/]+$'), ''))
        .where((segment) => segment.isNotEmpty)
        .join(Platform.pathSeparator);
  }

Future<List<WordItem>> getWords() async {
  final installation = await _contentPackManager.getInstallation('words');

  List<dynamic> data;

  if (installation != null &&
      installation.isUsable &&
      installation.localPath != null &&
      installation.localPath!.trim().isNotEmpty) {
    final installedData = await _packContentService.readLessonList(
      'words',
      'words.json',
    );

    if (installedData != null) {
      data = <dynamic>[];

      for (final item in installedData.whereType<Map>()) {
        data.add(
          await _resolveInstalledAnimalPaths(
            Map<String, dynamic>.from(item),
            installation.localPath!,
            packId: 'words',
          ),
        );
      }

      return data
          .map((item) => WordItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  data = await getMergedContent(
    'words',
    jsonLoader.words,
    packId: 'words',
    fileName: 'words.json',
  );

  return data
      .map((item) => WordItem.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

  Future<List<Letter>> _loadInstalledAlphabet() async {
    try {
      final installation =
          await _contentPackManager.getInstallation('alphabet');

      if (installation == null ||
          !installation.isUsable ||
          installation.localPath == null ||
          installation.localPath!.trim().isEmpty) {
        return [];
      }

      final decoded = await _packContentService.readLessonList(
        'alphabet',
        'alphabet.json',
      );

      if (decoded == null) return [];

      final installedByLetter = <String, Map<String, dynamic>>{};

      for (final item in decoded) {
        if (item is! Map) continue;

        final json = Map<String, dynamic>.from(item);
        final key = (json['letter'] ?? json['uppercase'] ?? '')
            .toString()
            .trim()
            .toUpperCase();

        if (key.isNotEmpty) installedByLetter[key] = json;
      }

      final mergedLetters = <Letter>[];

      for (final baseLetter in alphabet_data.letters) {
        final key = baseLetter.uppercase.trim().toUpperCase();
        final installed = installedByLetter[key];

        if (installed == null) {
          mergedLetters.add(baseLetter);
          continue;
        }

        final word = (installed['word'] ??
                installed['wordOromo'] ??
                installed['example'] ??
                '')
            .toString()
            .trim();

        final english = (installed['english'] ??
                installed['wordEnglish'] ??
                installed['exampleEnglish'] ??
                '')
            .toString()
            .trim();

        final examples = List<LetterExample>.from(baseLetter.examples);

        if (word.isNotEmpty &&
            !examples.any(
              (example) =>
                  example.wordOromo.trim().toLowerCase() == word.toLowerCase(),
            )) {
          examples.add(
            LetterExample(
              wordOromo: word,
              wordEnglish: english.isEmpty ? null : english,
              image: '',
              sound: null,
            ),
          );
        }

        mergedLetters.add(
          Letter(
            uppercase: baseLetter.uppercase,
            lowercase: baseLetter.lowercase,
            name: baseLetter.name,
            example: word.isNotEmpty ? word : baseLetter.example,
            exampleEnglish:
                english.isNotEmpty ? english : baseLetter.exampleEnglish,
            examples: examples,
            sound: baseLetter.sound,
            type: baseLetter.type,
            tracing: baseLetter.tracing,
          ),
        );
      }

      return mergedLetters;
    } catch (_) {
      return [];
    }
  }

  Future<List<Letter>> getLetters() async {
    final installedData = await _loadInstalledAlphabet();

    if (installedData.isNotEmpty) {
      return installedData;
    }

    return alphabet_data.letters;
  }

  Future<List<Quiz>> getQuizzes({String? lessonId}) async {
    final List<Quiz> quizzes = [];
    final data = await getMergedContent(
      "quiz",
      jsonLoader.quizzes,
      packId: "quizzes",
      fileName: "quizzes.json",
    );
    quizzes.addAll(
      data.map(
        (item) => Quiz.fromJson(
          Map<String, dynamic>.from(item),
        ),
      ),
    );

    if (lessonId != null) {
      final category = _quizCategoryForLesson(lessonId);
      quizzes.removeWhere((quiz) =>
          quiz.category != category ||
          (lessonId == 'plants' && quiz.id != 'nature_tree'));
    }

    return quizzes;
  }

  Future<List<ColorItem>> getColors() async {
    final data = await getMergedContent("colors", jsonLoader.colors,
        packId: "colors", fileName: "colors.json");

    return data.map((item) {
      return ColorItem.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<List<NumberItem>> getNumbers() async {
    final installedData = await _loadInstalledNumbers();

    final data = installedData ??
        await getMergedContent(
          'numbers',
          jsonLoader.numbers,
        );

    return data
        .map(
          (item) => NumberItem.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);
  }

  Future<List<Story>> getStories() async {
    final data = await getMergedContent("stories", jsonLoader.stories,
        packId: "stories", fileName: "stories.json");

    return data.map((item) {
      return Story.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<List<Song>> getSongs() async {
    final data = await getMergedContent("songs", jsonLoader.songs,
        packId: "songs", fileName: "songs.json");

    return data.map((item) {
      return Song.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<List<AssistantMessage>> getKooreeMessages() async {
    final data = await getMergedContent(
      "kooree",
      jsonLoader.kooreeMessages,
    );

    return data.map((item) {
      return AssistantMessage.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}
