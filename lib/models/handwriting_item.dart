import 'handwriting_stroke.dart';


class HandwritingItem {

  final String character;

  final String lowercase;

  final String name;

  final String sound;

  final String category;

  final List<HandwritingStroke> strokes;


  const HandwritingItem({

    required this.character,

    required this.lowercase,

    required this.name,

    required this.sound,

    required this.category,

    required this.strokes,

  });

}