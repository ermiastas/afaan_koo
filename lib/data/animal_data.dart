
class Animal {
  final String nameOromo;
  final String nameEnglish;
  final String image;
  final String sound;
  final String type;

  Animal({
    required this.nameOromo,
    required this.nameEnglish,
    required this.image,
    required this.sound,
    required this.type,
  });
}


// Animal database
final List<Animal> animalData = [

  Animal(
    nameOromo: "Leenca",
    nameEnglish: "Lion",
    image: "assets/images/lion.png",
    sound: "lion.mp3",
    type: "Wild Animal",
  ),

  Animal(
    nameOromo: "Arba",
    nameEnglish: "Elephant",
    image: "assets/images/elephant.png",
    sound: "elephant.mp3",
    type: "Wild Animal",
  ),

  Animal(
    nameOromo: "Qamalee",
    nameEnglish: "Monkey",
    image: "assets/images/monkey.png",
    sound: "monkey.mp3",
    type: "Wild Animal",
  ),

  Animal(
    nameOromo: "Saree",
    nameEnglish: "Dog",
    image: "assets/images/dog.png",
    sound: "dog.mp3",
    type: "Domestic Animal",
  ),

  Animal(
    nameOromo: "Adurree",
    nameEnglish: "Cat",
    image: "assets/images/cat.png",
    sound: "cat.mp3",
    type: "Domestic Animal",
  ),

];