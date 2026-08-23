import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileProvider extends ChangeNotifier {


  static const String _nameKey =
      "child_name";


  static const String _avatarKey =
      "child_avatar";



  String _name = "Obboleessa";


  String _avatar = "😊";



  String get name => _name;


  String get avatar => _avatar;




  Future<void> load() async {



    final prefs =
    await SharedPreferences.getInstance();



    _name =
        prefs.getString(_nameKey)
        ?? "Leenca Xiqqaa";



    _avatar =
        prefs.getString(_avatarKey)
        ?? "😊";



    notifyListeners();


  }






  Future<void> setName(String name) async {


    _name = name;


    final prefs =
    await SharedPreferences.getInstance();



    await prefs.setString(

      _nameKey,

      name,

    );


    notifyListeners();


  }






  Future<void> setAvatar(String avatar) async {



    _avatar = avatar;



    final prefs =
    await SharedPreferences.getInstance();



    await prefs.setString(

      _avatarKey,

      avatar,

    );



    notifyListeners();



  }



}