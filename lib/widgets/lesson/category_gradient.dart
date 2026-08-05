import 'package:flutter/material.dart';


class CategoryGradient {


  static LinearGradient get(String category){


    switch(category){


      case "Afaan fi Lakkoofsa":
        return const LinearGradient(
          colors:[
            Color(0xff4facfe),
            Color(0xff00f2fe),
          ],
        );


      case "Uumama":
        return const LinearGradient(
          colors:[
            Color(0xff43e97b),
            Color(0xff38f9d7),
          ],
        );


      case "Fayyaa fi Nageenya":
        return const LinearGradient(
          colors:[
            Color(0xffff9a9e),
            Color(0xfffad0c4),
          ],
        );


      case "Aadaa fi Safuu Oromoo":
        return const LinearGradient(
          colors:[
            Color(0xffffd86f),
            Color(0xfffc6262),
          ],
        );


      case "Jireenya Guyyaa Guyyaa":
        return const LinearGradient(
          colors:[
            Color(0xffa18cd1),
            Color(0xfffbc2eb),
          ],
        );


      default:

        return const LinearGradient(
          colors:[
            Color(0xff89f7fe),
            Color(0xff66a6ff),
          ],
        );

    }

  }

}