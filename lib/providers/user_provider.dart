import 'package:flutter/material.dart';

import '../models/user_profile.dart';



class UserProvider extends ChangeNotifier {


UserProfile? _user;



UserProfile? get user =>
_user;



bool get hasUser =>
_user != null;



void setUser(UserProfile profile){


_user = profile;


notifyListeners();


}



void clearUser(){


_user = null;


notifyListeners();


}


}