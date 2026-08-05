import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AgeProvider extends ChangeNotifier {


static const String key =
"student_age";



int _age = 5;



int get age => _age;



Future<void> load() async {


final prefs =
await SharedPreferences.getInstance();



_age =
prefs.getInt(key) ?? 5;


notifyListeners();


}





Future<void> setAge(int value) async {


_age=value;


final prefs =
await SharedPreferences.getInstance();



await prefs.setInt(

key,

value,

);



notifyListeners();


}



}