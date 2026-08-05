import '../models/video_quiz.dart';
import '../models/video_question.dart';

final List<VideoQuiz> videoQuizzes = [

  VideoQuiz(

    id: "animals_quiz",

    videoId: "animals_001",

    title: "Bineensota",

    rewardXP: 25,

    rewardCoins: 15,

    questions: [

      VideoQuestion(

        question: "Arbaan eenyu?",

        options: [

          "🐘",

          "🐶",

          "🐱",

          "🦁",

        ],

        correctIndex: 0,

      ),

      VideoQuestion(

        question: "Leenci halluu maalii qaba?",

        options: [

          "Gurraacha",

          "Diimaa",

          "Keelloo",

          "Adii",

        ],

        correctIndex: 2,

      ),

      VideoQuestion(

        question: "Sareen maal jedha?",

        options: [

          "Meow",

          "Woof",

          "Moo",

          "Neigh",

        ],

        correctIndex: 1,

      ),

    ],

  ),

];