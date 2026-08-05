import '../models/quiz.dart';
import '../models/quiz_type.dart';



class QuizGenerator {



  // =====================================================
  // Generate all automatic quizzes
  // =====================================================


  static List<Quiz> generateAll(
      {List<dynamic>? letters}
      ){


    final quizzes = <Quiz>[];



    quizzes.addAll(

      generateAlphabetTracing(),

    );



    quizzes.addAll(

      generateNumberTracing(),

    );



    quizzes.addAll(

      generateAdditionQuiz(),

    );



    if(letters != null){


      quizzes.addAll(

        generateAlphabetContentQuizzes(
            letters
        ),

      );


    }



    return quizzes;


  }









  // =====================================================
  // Alphabet tracing
  // =====================================================


  static List<Quiz> generateAlphabetTracing(){



    final letters = [

      "A","B","C","D","E",
      "F","G","H","I","J",
      "K","L","M","N","O",
      "P","Q","R","S","T",
      "U","V","W","X","Y","Z",

      "Ch",
      "Dh",
      "Ny",
      "Ph",
      "Sh",

    ];




    return letters.map((letter){



      return Quiz(


        id:

        "trace_$letter",



        category:

        "alphabet",



        type:

        QuizType.alphabetTracing,



        question:

        "Qubee $letter barreessi",



        image:"",



        sound:

        "assets/audio/alphabet/${letter.toLowerCase()}.mp3",



        options:[],



        answer:

        letter,



        tracingLetter:

        letter,



        tracingSmallLetter:

        letter.toLowerCase(),


      );



    }).toList();


  }









  // =====================================================
  // Generate quizzes from letter.json
  // =====================================================


  static List<Quiz> generateAlphabetContentQuizzes(

      List<dynamic> letters

      ){



    final quizzes = <Quiz>[];



    for(final item in letters){



      final letter =
      item["letter"] ?? "";



      final word =
      item["word"] ?? "";



      final english =
      item["english"] ?? "";



      final image =
      item["image"] ?? "";



      final sound =
      item["sound"] ?? "";





      // -----------------------------
      // Picture quiz
      // -----------------------------


      quizzes.add(



        Quiz(


          id:

          "picture_$letter",



          category:

          "alphabet",



          type:

          QuizType.imageChoice,



          question:

          "Kun maal?",



          image:

          "assets/images/alphabet/$image",



          sound:

          "assets/audio/alphabet/$sound",



          options:

          _createOptions(

              word,

              letters,

              "word"

          ),



          answer:

          word,



        ),



      );







      // -----------------------------
      // First letter quiz
      // -----------------------------


      quizzes.add(



        Quiz(



          id:

          "first_letter_$letter",



          category:

          "alphabet",



          type:

          QuizType.multipleChoice,



          question:

          "$word jechuun qubee kamiin jalqaba?",



          image:

          "assets/images/alphabet/$image",



          sound:"",



          options:

          _letterOptions(

              letter,

              letters

          ),



          answer:

          letter,



        ),



      );









      // -----------------------------
      // English meaning
      // -----------------------------


      quizzes.add(



        Quiz(



          id:

          "meaning_$letter",



          category:

          "alphabet",



          type:

          QuizType.multipleChoice,



          question:

          "$word jechuun Ingiliffaan maal jechuudha?",



          image:

          "assets/images/alphabet/$image",



          sound:"",



          options:

          _createOptions(

              english,

              letters,

              "english"

          ),



          answer:

          english,



        ),



      );









      // -----------------------------
      // Spelling quiz
      // -----------------------------


      quizzes.add(



        Quiz(



          id:

          "spell_$letter",



          category:

          "alphabet",



          type:

          QuizType.spelling,



          question:

          "Jechoota kana guuti:\n\n${_hideLetter(word)}",



          image:

          "assets/images/alphabet/$image",



          sound:"",



          options:

          [

            word,

            _randomWord(letters),

            _randomWord(letters),

            _randomWord(letters),

          ],



          answer:

          word,



        ),



      );









      // -----------------------------
      // Audio quiz
      // -----------------------------


      quizzes.add(



        Quiz(



          id:

          "audio_$letter",



          category:

          "alphabet",



          type:

          QuizType.audioChoice,



          question:

          "Sagalee kana eenyu?",



          image:"",



          sound:

          "assets/audio/alphabet/$sound",



          options:

          _letterOptions(

              letter,

              letters

          ),



          answer:

          letter,



        ),



      );



    }





    return quizzes;


  }









  // =====================================================
  // Number tracing
  // =====================================================


  static List<Quiz> generateNumberTracing(){



    return List.generate(

      10,

          (number){



        return Quiz(



          id:

          "number_$number",



          category:

          "numbers",



          type:

          QuizType.numberTracing,



          question:

          "Lakkoofsa $number barreessi",



          image:"",



          sound:"",



          options:[],



          answer:

          "$number",



        );



      },

    );


  }









  // =====================================================
  // Addition
  // =====================================================


  static List<Quiz> generateAdditionQuiz(){



    final list = [

      [1,2],

      [2,3],

      [3,4],

      [5,2],

      [6,3],

      [7,1],

      [8,2],

      [9,5],

    ];




    return list.map((x){



      final a=x[0];

      final b=x[1];

      final answer=a+b;



      return Quiz(



        id:

        "addition_${a}_$b",



        category:

        "math",



        type:

        QuizType.addition,



        question:

        "$a + $b = ?",



        image:"",



        sound:"",



        options:

        [

          "$answer",

          "${answer+1}",

          "${answer+2}",

          "${answer-1}",

        ],



        answer:

        "$answer",



      );



    }).toList();



  }









  // =====================================================
  // Helpers
  // =====================================================



  static List<String> _createOptions(

      String answer,

      List<dynamic> data,

      String field

      ){



    final options=<String>[];



    options.add(answer);



    for(final item in data){


      final value =
      item[field] ?? "";


      if(value != answer &&
          value.toString().isNotEmpty){


        options.add(
            value
        );


      }
      

      if(options.length==4){
        break;
        
      }

    }



    options.shuffle();



    return options;


  }








  static List<String> _letterOptions(

      String answer,

      List<dynamic> data

      ){



    final options=<String>[];



    options.add(answer);



    for(final item in data){


      final value =
      item["letter"] ?? "";



      if(value != answer){


        options.add(value);


      }



      if(options.length==4){
        break;
      }

    }



    options.shuffle();



    return options;


  }









  static String _randomWord(

      List<dynamic> data

      ){



    if(data.isEmpty){
      return "";

    }

    return data[0]["word"] ?? "";

    
  }









  static String _hideLetter(

      String word

      ){



    if(word.length < 2){
      return word;
    }


    final middle =
    word.length ~/ 2;



    return word.replaceRange(

      middle,

      middle+1,

      "_",

    );


  }



}