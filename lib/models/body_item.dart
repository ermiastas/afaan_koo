//import 'package:flutter/material.dart';
import 'learning_item.dart';


class BodyItem extends LearningItem {

  BodyItem({

    required super.nameOromo,
    required super.nameEnglish,
    required super.image,
    required super.sound,

  });


  factory BodyItem.fromJson(Map<String,dynamic> json){

    return BodyItem(

      nameOromo: json["nameOromo"] ?? "",

      nameEnglish: json["nameEnglish"] ?? "",

      image: json["image"] ?? "",

      sound: json["sound"] ?? "",

    );

  }

}