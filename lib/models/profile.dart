//import 'package:flutter/material.dart';


class Profile {


  final String id;

  final String name;

  final String email;

  final String role;



  const Profile({

    required this.id,

    required this.name,

    required this.email,

    required this.role,

  });





  factory Profile.fromMap(
      Map<String,dynamic> map
      ){

    return Profile(

      id:
      map['id'] ?? '',


      name:
      map['name'] ?? '',


      email:
      map['email'] ?? '',


      role:
      map['role'] ?? 'student',

    );

  }




  Map<String,dynamic> toMap(){

    return {

      'id':id,

      'name':name,

      'email':email,

      'role':role,

    };

  }


}