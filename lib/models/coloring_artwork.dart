import 'coloring_action.dart';

class ColoringArtwork {
  const ColoringArtwork({
    required this.id,
    required this.coloringPageId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.svgMarkup,
    required this.colorsUsed,
    required this.actions,
    this.imagePath,
    this.lessonId,
    this.category,
    this.timeSpent = Duration.zero,
  });

  final String id;
  final String coloringPageId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath;
  final String? lessonId;
  final String? category;
  final Duration timeSpent;
  final List<int> colorsUsed;
  final List<ColoringAction> actions;
  final String svgMarkup;

  ColoringArtwork copyWith({String? title, DateTime? updatedAt}) =>
      ColoringArtwork(
        id: id,
        coloringPageId: coloringPageId,
        title: title ?? this.title,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        imagePath: imagePath,
        lessonId: lessonId,
        category: category,
        timeSpent: timeSpent,
        colorsUsed: colorsUsed,
        actions: actions,
        svgMarkup: svgMarkup,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'coloringPageId': coloringPageId,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'imagePath': imagePath,
        'lessonId': lessonId,
        'category': category,
        'timeSpentMs': timeSpent.inMilliseconds,
        'colorsUsed': colorsUsed,
        'actions': actions.map((item) => item.toJson()).toList(),
        'svgMarkup': svgMarkup,
      };

  factory ColoringArtwork.fromJson(Map<String, dynamic> json) =>
      ColoringArtwork(
        id: json['id'] as String,
        coloringPageId: json['coloringPageId'] as String,
        title: json['title'] as String? ?? 'Suuraa Koo',
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        imagePath: json['imagePath'] as String?,
        lessonId: json['lessonId'] as String?,
        category: json['category'] as String?,
        timeSpent: Duration(milliseconds: json['timeSpentMs'] as int? ?? 0),
        colorsUsed: List<int>.from(json['colorsUsed'] ?? const []),
        actions: (json['actions'] as List<dynamic>? ?? const [])
            .map((item) =>
                ColoringAction.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        svgMarkup: json['svgMarkup'] as String? ?? '',
      );
}
