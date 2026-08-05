class LowercaseLetter {
  final String letter;
  final String image;
  final String sound;

  const LowercaseLetter({
    required this.letter,
    required this.image,
    required this.sound,
  });
}

const lowercaseLetters = [
  LowercaseLetter(
    letter: 'a',
    image: 'assets/images/alphabet/a.png',
    sound: 'a.mp3',
  ),
  LowercaseLetter(
    letter: 'b',
    image: 'assets/images/alphabet/b.png',
    sound: 'b.mp3',
  ),
  // Continue through the Afaan Oromo alphabet...
];