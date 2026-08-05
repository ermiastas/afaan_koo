class LetterExample {
  /// Afaan Oromo word
  final String wordOromo;

  /// Optional English translation
  final String? wordEnglish;

  /// Example image
  final String image;

  /// Optional pronunciation audio
  final String? sound;

  /// Optional example sentence
  final String? sentenceOromo;

  /// Optional English translation of the sentence
  final String? sentenceEnglish;

  const LetterExample({
    required this.wordOromo,
    this.wordEnglish,
    required this.image,
    this.sound,
    this.sentenceOromo,
    this.sentenceEnglish,
  });

  factory LetterExample.fromJson(Map<String, dynamic> json) {
    return LetterExample(
      wordOromo: json['wordOromo'] ?? '',
      wordEnglish: json['wordEnglish'],
      image: json['image'] ?? '',
      sound: json['sound'],
      sentenceOromo: json['sentenceOromo'],
      sentenceEnglish: json['sentenceEnglish'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordOromo': wordOromo,
      'wordEnglish': wordEnglish,
      'image': image,
      'sound': sound,
      'sentenceOromo': sentenceOromo,
      'sentenceEnglish': sentenceEnglish,
    };
  }
}