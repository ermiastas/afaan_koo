import 'package:flutter/material.dart';

import '../models/teacher.dart';



class TeacherProvider extends ChangeNotifier {


 Teacher? _teacher;


 Teacher? get teacher =>
     _teacher;



 bool get isTeacher =>
     _teacher != null;




 void loginTeacher(
     Teacher teacher
 ){

   _teacher = teacher;

   notifyListeners();

 }



 void logout(){

   _teacher=null;

   notifyListeners();

 }



}