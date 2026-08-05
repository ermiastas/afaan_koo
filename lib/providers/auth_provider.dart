import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';



class AuthProvider extends ChangeNotifier {



  final SupabaseClient _client =
      Supabase.instance.client;



  AppUser? _user;



  AppUser? get user =>
      _user;



  bool get isLoggedIn =>
      _user != null;



  UserRole? get role =>
      _user?.role;





  // ==================================
  // Supabase Login
  // ==================================


  Future<String?> login({


    required String email,


    required String password,


  }) async {


    try {



      final response =
      await _client.auth.signInWithPassword(


        email: email,


        password: password,


      );



      final authUser =
          response.user;



      if(authUser == null){


        return "Login failed";


      }



      await loadProfile(
        authUser.id,
      );



      return null;



    }

    catch(e){


      return e.toString();


    }


  }









  // ==================================
  // Register User
  // ==================================


  Future<String?> register({


    required String name,


    required String email,


    required String password,


    required UserRole role,


  }) async {



    try {



      final response =
      await _client.auth.signUp(


        email: email,


        password: password,


      );



      final authUser =
          response.user;



      if(authUser == null){


        return "Registration failed";


      }





      await _client
          .from('profiles')
          .insert({


        'id':
        authUser.id,


        'name':
        name,


        'email':
        email,


        'role':
        role.name,


      });






      await loadProfile(
        authUser.id,
      );



      return null;



    }

    catch(e){


      return e.toString();


    }


  }









  // ==================================
  // Load Profile
  // ==================================


  Future<void> loadProfile(
      String id
      ) async {



    final data =
    await _client

        .from('profiles')

        .select()

        .eq(
          'id',
          id,
        )

        .maybeSingle();





    if(data == null){


      return;


    }





    _user =
        AppUser(


          id:
          data['id'],


          name:
          data['name'] ?? '',


          email:
          data['email'] ?? '',



          role:
          _convertRole(
            data['role'],
          ),


        );




    notifyListeners();


  }









  // ==================================
  // Convert Database Role
  // ==================================


  UserRole _convertRole(
      String? value
      ){



    switch(value){


      case "parent":

        return UserRole.parent;



      case "teacher":

        return UserRole.teacher;



      case "admin":

        return UserRole.admin;



      default:

        return UserRole.student;


    }


  }









  // ==================================
  // Logout
  // ==================================


  Future<void> logout() async {


    await _client
        .auth
        .signOut();



    _user = null;



    notifyListeners();


  }









  // ==================================
  // Role Helpers
  // ==================================


  bool isStudent(){


    return role ==
        UserRole.student;


  }






  bool isParent(){


    return role ==
        UserRole.parent;


  }






  bool isTeacher(){


    return role ==
        UserRole.teacher;


  }






  bool isAdmin(){


    return role ==
        UserRole.admin;


  }




}