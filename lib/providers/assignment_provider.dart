import 'package:flutter/material.dart';

import '../models/lesson_assignment.dart';



class AssignmentProvider extends ChangeNotifier {



final List<LessonAssignment> _assignments = [];



List<LessonAssignment> get assignments =>
    _assignments;





void assignLesson(
    LessonAssignment assignment
){

  _assignments.add(assignment);

  notifyListeners();

}





List<LessonAssignment> getClassAssignments(
    String classId
){

  return _assignments
      .where(
        (a)=>a.classId == classId,
      )
      .toList();

}





void removeAssignment(
    String id
){

  _assignments.removeWhere(
    (a)=>a.id == id,
  );


  notifyListeners();

}


}