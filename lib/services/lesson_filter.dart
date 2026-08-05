import '../models/app_lesson.dart';


List<AppLesson> getLessonsForAge(
    List<AppLesson> lessons,
    int age,
){

  return lessons.where(

    (lesson)=>

      lesson.ages.contains(age)

  ).toList();

}