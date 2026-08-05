import 'package:flutter/material.dart';

import '../models/admin.dart';
import '../models/admin_stats.dart';

import '../services/supabase_service.dart';



class AdminProvider extends ChangeNotifier {



  Admin? _admin;



  Admin? get admin =>
      _admin;



  bool get isAdmin =>
      _admin != null;





  AdminStats _stats =
      const AdminStats(

        totalUsers:0,

        students:0,

        teachers:0,

        parents:0,

        lessons:0,

        games:0,

      );



  AdminStats get stats =>
      _stats;






  // =============================
  // Load Admin Profile
  // =============================


  Future<void> loadAdmin() async {


    final id =
        SupabaseService.userId;



    if(id == null){

      return;

    }



    final data =
        await SupabaseService
        .client!
        .from('admins')
        .select()
        .eq('id', id)
        .maybeSingle();



    if(data != null){


      _admin =
          Admin.fromMap(data);



      notifyListeners();


    }


  }


// =============================
// Local Admin Login
// =============================

void login(Admin admin){

  _admin = admin;

  notifyListeners();

}




  // =============================
  // Load Dashboard Statistics
  // =============================


  Future<void> loadStats() async {



    final client =
      SupabaseService.client!;



    final users =
        await client
        .from('profiles')
        .select();



    final lessons =
        await client
        .from('lessons')
        .select();



    final games =
        await client
        .from('games')
        .select();




    _stats =
        AdminStats(

          totalUsers:
          users.length,


          students:
          users
          .where(
              (u)=>
              u['role']=='student'
          )
          .length,


          teachers:
          users
          .where(
              (u)=>
              u['role']=='teacher'
          )
          .length,


          parents:
          users
          .where(
              (u)=>
              u['role']=='parent'
          )
          .length,


          lessons:
          lessons.length,


          games:
          games.length,

        );



    notifyListeners();


  }







  // =============================
  // Logout
  // =============================


  Future<void> logout() async {


    await SupabaseService
      .client!
      .auth
      .signOut();



    _admin=null;


    notifyListeners();


  }


}