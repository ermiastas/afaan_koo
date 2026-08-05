import 'dart:math';

import '../models/quiz.dart';
import '../models/quiz_type.dart';


class MathQuizGenerator {


  static final Random _random = Random();



  // ============================
  // Addition Quiz
  // ============================

  static Quiz generateAddition(){

    int a =
    _random.nextInt(10) + 1;


    int b =
    _random.nextInt(10) + 1;


    int answer =
    a + b;



    List<String> options = [

      answer.toString(),

      (answer + 1).toString(),

      (answer - 1).toString(),

      (answer + 2).toString(),

    ];



    options.shuffle();



    return Quiz(

      id:
      "addition_${a}_$b",


      category:
      "math",


      type:
      QuizType.addition,


      question:

      "$a + $b = ?",


      image:

      "assets/images/math.png",


      sound:

      "",


      options:

      options,


      answer:

      answer.toString(),

    );


  }








  // ============================
  // Counting Quiz
  // ============================


  static Quiz generateCounting(){


    int number =

    _random.nextInt(10)+1;



    return Quiz(


      id:

      "count_$number",


      category:

      "counting",


      type:

      QuizType.counting,



      question:

      "Wantoota meeqa jiru?\n\n🍎 " * number,



      image:

      "assets/images/apple.png",


      sound:

      "",



      options:[


        number.toString(),


        (number+1).toString(),


        (number-1).toString(),


        (number+2).toString(),


      ],



      answer:

      number.toString(),


    );

  }







  // ============================
  // Generate many quizzes
  // ============================


  static List<Quiz> generateMathQuizPack(){

    List<Quiz> quizzes=[];



    for(int i=0;i<10;i++){

      quizzes.add(
        generateAddition(),
      );


    }



    for(int i=0;i<10;i++){

      quizzes.add(
        generateCounting(),
      );

    }



    return quizzes;

  }



}