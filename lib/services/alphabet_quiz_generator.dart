import '../models/quiz.dart';
import '../models/quiz_type.dart';



class AlphabetQuizGenerator {



static List<Quiz> generate(){


final letters=[

"A",

"B",

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


sound:"",


options:[],


answer:letter,


tracingLetter:

letter,


tracingSmallLetter:

letter.toLowerCase(),


);



}).toList();



}



}