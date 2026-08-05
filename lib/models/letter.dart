import 'letter_example.dart';

enum LetterType {
  vowel,
  consonant,
}

class Letter {
  /// Display
  final String uppercase;
  final String lowercase;

  /// Letter name (Ba, Cha, Dha...)
  final String name;

  /// Primary example (kept for backward compatibility)
  final String example;

  /// Multiple examples (new)
  final List<LetterExample> examples;

  /// Optional English translation of the primary example
  final String? exampleEnglish;

  /// Letter image
  final String image;

  /// Pronunciation audio
  final String sound;

  /// Vowel or consonant
  final LetterType type;

  /// Tracing asset (optional)
  final String? tracing;

  const Letter({
    required this.uppercase,
    required this.lowercase,
    required this.name,
    required this.example,
    this.examples = const [],
    this.exampleEnglish,
    required this.image,
    required this.sound,
    required this.type,
    this.tracing,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    final upper =
        json['uppercase'] ??
        json['letter'] ??
        '';

    final lower =
        json['lowercase'] ??
        upper.toString().toLowerCase();

    return Letter(
      uppercase: upper,

      lowercase: lower,

      name: json['name'] ?? upper,

      example:
          json['example'] ??
          json['wordOromo'] ??
          '',

      examples: json['examples'] != null
          ? (json['examples'] as List)
              .map(
                (e) => LetterExample.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : [],

      exampleEnglish:
          json['exampleEnglish'] ??
          json['wordEnglish'],

      image:
          json['image'] ?? '',

      sound:
          json['sound'] ?? '',

      type:
          (json['type']
            .toString()
            .toLowerCase()
            .contains('vowel'))
          ? LetterType.vowel
          : LetterType.consonant,

      tracing:
          json['tracing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uppercase': uppercase,
      'lowercase': lowercase,
      'name': name,
      'example': example,
      'examples': examples
          .map((e) => e.toJson())
          .toList(),
      'exampleEnglish': exampleEnglish,
      'image': image,
      'sound': sound,
      'type': type.name,
      'tracing': tracing,
    };
  }

  bool get isVowel => type == LetterType.vowel;

  bool get isConsonant => type == LetterType.consonant;
  String get display {

    if (uppercase.length > 1) {

      return "$uppercase  $lowercase";

    }

    return "$uppercase  $lowercase";

}
  /// Returns all examples.
  /// If the examples list is empty, it falls back to the single example.
  List<LetterExample> get allExamples {
    if (examples.isNotEmpty) {
      return examples;
    }

    return [
      LetterExample(
        wordOromo: example,
        wordEnglish: exampleEnglish,
        image: image,
        sound: sound,
      ),
    ];
  }
}