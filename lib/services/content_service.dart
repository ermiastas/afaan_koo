import '../models/animal.dart';
import '../models/word_item.dart';
import '../models/letter.dart';
import '../models/quiz.dart';
import '../models/color_item.dart';
import '../models/number_item.dart';
import '../models/story.dart';
import '../models/song.dart';
import '../models/assistant_message.dart';

import 'json_loader.dart';
import 'local_content_service.dart';
//import 'math_quiz_generator.dart';
//import 'alphabet_quiz_generator.dart';
import 'quiz_generator.dart';


class ContentService {


  final JsonLoader jsonLoader = JsonLoader();

  final LocalContentService local = LocalContentService();



  Future<List<dynamic>> getMergedContent(
    String category,
    Future<List<dynamic>> Function() jsonFallback,
  ) async {


    final jsonData = await jsonFallback();


    final localData = await local.getContent(
      category,
    );


    final List<dynamic> merged = [];


    merged.addAll(jsonData);



    for (final item in localData) {


      final exists = merged.any((old) {


        if (item["id"] != null &&
            old["id"] != null) {

          return item["id"] == old["id"];

        }


        return false;

      });



      if (!exists) {

        merged.add(item);

      }


    }



    return merged;

  }






  Future<List<Animal>> getAnimals() async {


    final data = await getMergedContent(
      "animals",
      jsonLoader.animals,
    );



    return data.map((item) {


      return Animal.fromJson(
        Map<String, dynamic>.from(item),
      );


    }).toList();


  }







  Future<List<WordItem>> getWords() async {


    final data = await getMergedContent(
      "words",
      jsonLoader.words,
    );



    return data.map((item) {


      return WordItem.fromJson(
        Map<String, dynamic>.from(item),
      );


    }).toList();


  }







  Future<List<Letter>> getLetters() async {


    final data = await getMergedContent(
      "alphabet",
      jsonLoader.letters,
    );



    return data.map((item) {


      final json = Map<String, dynamic>.from(item);



      // Compatibility with old alphabet JSON
      // Converts old fields into the new Letter model

      return Letter.fromJson({

        "uppercase":
            json["uppercase"] ??
            json["letter"] ??
            "",


        "lowercase":
            json["lowercase"] ??
            (json["letter"] ?? "").toString().toLowerCase(),


        "name":
            json["name"] ??
            json["letter"] ??
            "",


        "example":
            json["example"] ??
            json["wordOromo"] ??
            "",


        "image":
            json["image"] ??
            "",


        "sound":
            json["sound"] ??
            "",

      });


    }).toList();


  }

Future<List<Quiz>> getQuizzes() async {


  final List<Quiz> quizzes=[];



  // JSON quizzes

  final data = await getMergedContent(
    "quiz",
    jsonLoader.quizzes,
  );



  quizzes.addAll(

    data.map((item){

      return Quiz.fromJson(

        Map<String,dynamic>.from(item),

      );

    }),

  );





  // Automatic quizzes

  quizzes.addAll(

    QuizGenerator.generateAll(),

  );




  return quizzes;


}





  Future<List<ColorItem>> getColors() async {


    final data = await getMergedContent(
      "colors",
      jsonLoader.colors,
    );


    return data.map((item) {


      return ColorItem.fromJson(
        Map<String,dynamic>.from(item),
      );


    }).toList();


  }








  Future<List<NumberItem>> getNumbers() async {


    final data = await getMergedContent(
      "numbers",
      jsonLoader.numbers,
    );


    return data.map((item) {


      return NumberItem.fromJson(
        Map<String,dynamic>.from(item),
      );


    }).toList();


  }








  Future<List<Story>> getStories() async {


    final data = await getMergedContent(
      "stories",
      jsonLoader.stories,
    );


    return data.map((item) {


      return Story.fromJson(
        Map<String,dynamic>.from(item),
      );


    }).toList();


  }








  Future<List<Song>> getSongs() async {


    final data = await getMergedContent(
      "songs",
      jsonLoader.songs,
    );


    return data.map((item) {


      return Song.fromJson(
        Map<String,dynamic>.from(item),
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
        Map<String,dynamic>.from(item),
      );


    }).toList();


  }


}