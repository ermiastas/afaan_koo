class Lesson {


 final String title;
 final String category;
 final String image;
 final String rajiMessage;

 final int totalQuestions;
 final int completedQuestions;


 Lesson({

 required this.title,
 required this.category,
 required this.image,
 required this.rajiMessage,

 this.totalQuestions=10,
 this.completedQuestions=0,

 });


 double get progress =>
 totalQuestions==0
 ?0
 :
 completedQuestions /
 totalQuestions;


 bool get completed =>
 progress>=1;

}