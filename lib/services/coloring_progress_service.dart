import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ColoringProgressService {


  Future<void> saveColoring({

    required String pageId,

    required Map<String, Color> colors,

  }) async {


    final prefs =
        await SharedPreferences.getInstance();



    final Map<String,String> data = {};



    colors.forEach((key,value){


      data[key] =
          value.toARGB32().toString();


    });



    await prefs.setString(

      "coloring_$pageId",

      jsonEncode(data),

    );


  }





  Future<Map<String,Color>> loadColoring(

      String pageId,

      ) async {


    final prefs =
        await SharedPreferences.getInstance();



    final saved =
        prefs.getString(

          "coloring_$pageId",

        );



    if(saved == null){

      return {};

    }



    final Map<String,dynamic> data =
        jsonDecode(saved);



    final Map<String,Color> result = {};



    data.forEach((key,value){


      result[key] =

          Color(

            int.parse(value),

          );


    });



    return result;


  }





  Future<void> clearColoring(

      String pageId,

      ) async {


    final prefs =
        await SharedPreferences.getInstance();



    await prefs.remove(

      "coloring_$pageId",

    );


  }



}