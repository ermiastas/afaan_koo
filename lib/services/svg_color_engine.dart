import 'package:flutter/services.dart';
import 'package:xml/xml.dart';


class SvgColorEngine {


  Future<String> recolorSvg({

    required String asset,

    required String partId,

    required String color,

  }) async {


    final svgString =
        await rootBundle.loadString(asset);



    final document =
        XmlDocument.parse(svgString);



    final paths =
        document.findAllElements("path");



    for(final path in paths){


      final id =
          path.getAttribute("id");



      if(id == partId){


        path.setAttribute(

          "fill",

          color,

        );


      }


    }



    return document.toXmlString();

  }


}