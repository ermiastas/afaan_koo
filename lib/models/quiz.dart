import 'quiz_type.dart';


class Quiz {


final String id;

final String category;

final QuizType type;


final String question;

final String image;

final String sound;


final List<String> options;


final String answer;


// tracing support

final String? tracingLetter;

final String? tracingSmallLetter;

final int? numberToTrace;

Quiz({

required this.id,

required this.category,

required this.type,

required this.question,

required this.image,

required this.sound,

required this.options,

required this.answer,


this.tracingLetter,

this.tracingSmallLetter,
this.numberToTrace,

});




factory Quiz.fromJson(
Map<String,dynamic> json
){


return Quiz(

id:
json["id"] ?? "",


category:
json["category"] ?? "",



type:

QuizType.values.firstWhere(

(e)=>

e.name ==
json["type"],

orElse:

()=>QuizType.multipleChoice,

),



question:

json["question"] ?? "",



image:

json["image"] ?? "",



sound:

json["sound"] ?? "",



options:

List<String>.from(

json["options"] ?? []

),



answer:

json["answer"] ?? "",



tracingLetter:

json["tracingLetter"],



tracingSmallLetter:

json["tracingSmallLetter"],

numberToTrace:

json["numberToTrace"],


);


}


}