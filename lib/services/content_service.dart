import 'logger_service.dart';
import '../models/animal.dart';
import '../models/color_item.dart';
import '../models/number_item.dart';
import '../models/story.dart';
import '../models/song.dart';
import '../models/word_item.dart';
import '../models/letter.dart';
import '../models/quiz.dart';
import '../models/assistant_message.dart';

import 'json_loader.dart';
import 'firebase_content_service.dart';



class ContentService {


final JsonLoader loader =
JsonLoader();


final FirebaseContentService firebase =
FirebaseContentService();





// =============================
// ANIMALS
// =============================

Future<List<Animal>> getAnimals() async {


try {


final online =
await firebase.getCollection("animals");


if(online.isNotEmpty){


return online
.map(
(item)=>
Animal.fromJson(item),
)
.toList();


}


}

catch(e){

LoggerService.logger.i(
"Using local animals.json"
);

}



final data =
await loader.animals();



return data
.map(
(item)=>
Animal.fromJson(item),
)
.toList();


}







// =============================
// COLORS
// =============================

Future<List<ColorItem>> getColors() async {


final data =
await loader.colors();



return data
.map(
(item)=>
ColorItem.fromJson(item),
)
.toList();


}







// =============================
// NUMBERS
// =============================

Future<List<NumberItem>> getNumbers() async {


final data =
await loader.numbers();



return data
.map(
(item)=>
NumberItem.fromJson(item),
)
.toList();


}







// =============================
// STORIES
// =============================

Future<List<Story>> getStories() async {


final data =
await loader.stories();



return data
.map(
(item)=>
Story.fromJson(item),
)
.toList();


}







// =============================
// SONGS
// =============================

Future<List<Song>> getSongs() async {


final data =
await loader.songs();



return data
.map(
(item)=>
Song.fromJson(item),
)
.toList();


}







// =============================
// LETTERS
// =============================

Future<List<Letter>> getLetters() async {


final data =
await loader.letters();



return data
.map(
(item)=>
Letter.fromJson(item),
)
.toList();


}







// =============================
// WORDS
// =============================

Future<List<WordItem>> getWords() async {


try {


final online =
await firebase.getCollection("words");


if(online.isNotEmpty){


return online
.map(
(item)=>
WordItem.fromJson(item),
)
.toList();


}


}

catch(e){

LoggerService.logger.i(
"Using local words.json"
);

}



final data =
await loader.words();



return data
.map(
(item)=>
WordItem.fromJson(item),
)
.toList();


}







// =============================
// QUIZZES
// =============================

Future<List<Quiz>> getQuizzes() async {


final data =
await loader.quizzes();



return data
.map(
(item)=>
Quiz.fromJson(item),
)
.toList();


}







// =============================
// KOREE MESSAGES
// =============================

Future<List<AssistantMessage>> getKooreeMessages() async {


final data =
await loader.kooreeMessages();



return data
.map(
(item)=>
AssistantMessage.fromJson(item),
)
.toList();


}



}