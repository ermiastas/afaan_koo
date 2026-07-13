import 'package:flutter/material.dart';

import '../models/admin.dart';



class AdminProvider extends ChangeNotifier {



Admin? _admin;



Admin? get admin => _admin;



bool get isAdmin =>
_admin != null;





void login(Admin admin){


_admin = admin;


notifyListeners();


}





void logout(){


_admin = null;


notifyListeners();


}





}