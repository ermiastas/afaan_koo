import 'package:flutter/foundation.dart';

@immutable
class ColoringPage {
  /// Unique page ID
  final String id;

  /// Category ID (animals, fruits, alphabet...)
  final String category;

  /// Afaan Oromoo name
  final String titleOromo;

  /// English name
  final String titleEnglish;

  /// SVG or PNG outline image
  final String image;

  /// Thumbnail shown in library
  final String thumbnail;

  /// Audio pronunciation
  final String sound;

  /// Emoji fallback
  final String emoji;

  /// XP awarded
  final int rewardXP;

  /// Difficulty (1-5)
  final int difficulty;

  /// Premium page
  final bool premium;

  /// Favorite page
  final bool favorite;

  /// Completed
  final bool completed;

  /// Stars earned (0-3)
  final int stars;

  /// Supported ages
  final List<int> ages;

  /// Tags for searching
  final List<String> tags;

  /// Derived SVG markup. This is kept separately from [image], which remains
  /// the original educational asset used for previews and provenance.
  final String? svgMarkup;

  /// Learning origin retained when a page is generated from lesson content.
  final String? lessonId;
  final String? lessonTitle;
  final String? sourceAssetId;
  final bool isNew;

  const ColoringPage({
    required this.id,
    required this.category,
    required this.titleOromo,
    required this.titleEnglish,
    required this.image,
    this.thumbnail = "",
    this.sound = "",
    this.emoji = "🎨",
    this.rewardXP = 10,
    this.difficulty = 1,
    this.premium = false,
    this.favorite = false,
    this.completed = false,
    this.stars = 0,
    this.ages = const [3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    this.tags = const [],
    this.svgMarkup,
    this.lessonId,
    this.lessonTitle,
    this.sourceAssetId,
    this.isNew = false,
  });

  factory ColoringPage.fromJson(Map<String, dynamic> json) {
    return ColoringPage(
      id: json["id"] ?? "",
      category: json["category"] ?? "",
      titleOromo: json["titleOromo"] ?? "",
      titleEnglish: json["titleEnglish"] ?? "",
      image: json["image"] ?? "",
      thumbnail: json["thumbnail"] ?? json["image"] ?? "",
      sound: json["sound"] ?? "",
      emoji: json["emoji"] ?? "🎨",
      rewardXP: json["rewardXP"] ?? 10,
      difficulty: json["difficulty"] ?? 1,
      premium: json["premium"] ?? false,
      favorite: json["favorite"] ?? false,
      completed: json["completed"] ?? false,
      stars: json["stars"] ?? 0,
      ages: json["ages"] != null
          ? List<int>.from(json["ages"])
          : const [3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      tags: json["tags"] != null ? List<String>.from(json["tags"]) : const [],
      svgMarkup: json['svgMarkup'] as String?,
      lessonId: json['lessonId'] as String?,
      lessonTitle: json['lessonTitle'] as String?,
      sourceAssetId: json['sourceAssetId'] as String?,
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category": category,
      "titleOromo": titleOromo,
      "titleEnglish": titleEnglish,
      "image": image,
      "thumbnail": thumbnail,
      "sound": sound,
      "emoji": emoji,
      "rewardXP": rewardXP,
      "difficulty": difficulty,
      "premium": premium,
      "favorite": favorite,
      "completed": completed,
      "stars": stars,
      "ages": ages,
      "tags": tags,
      "svgMarkup": svgMarkup,
      "lessonId": lessonId,
      "lessonTitle": lessonTitle,
      "sourceAssetId": sourceAssetId,
      "isNew": isNew,
    };
  }

  ColoringPage copyWith({
    String? id,
    String? category,
    String? titleOromo,
    String? titleEnglish,
    String? image,
    String? thumbnail,
    String? sound,
    String? emoji,
    int? rewardXP,
    int? difficulty,
    bool? premium,
    bool? favorite,
    bool? completed,
    int? stars,
    List<int>? ages,
    List<String>? tags,
    String? svgMarkup,
    String? lessonId,
    String? lessonTitle,
    String? sourceAssetId,
    bool? isNew,
  }) {
    return ColoringPage(
      id: id ?? this.id,
      category: category ?? this.category,
      titleOromo: titleOromo ?? this.titleOromo,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      image: image ?? this.image,
      thumbnail: thumbnail ?? this.thumbnail,
      sound: sound ?? this.sound,
      emoji: emoji ?? this.emoji,
      rewardXP: rewardXP ?? this.rewardXP,
      difficulty: difficulty ?? this.difficulty,
      premium: premium ?? this.premium,
      favorite: favorite ?? this.favorite,
      completed: completed ?? this.completed,
      stars: stars ?? this.stars,
      ages: ages ?? this.ages,
      tags: tags ?? this.tags,
      svgMarkup: svgMarkup ?? this.svgMarkup,
      lessonId: lessonId ?? this.lessonId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      sourceAssetId: sourceAssetId ?? this.sourceAssetId,
      isNew: isNew ?? this.isNew,
    );
  }
}
