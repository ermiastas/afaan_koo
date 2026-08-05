import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import '../models/svg_part.dart';



class SvgParserService {



  Future<List<SvgPart>> loadSvgParts(

      String asset,

      ) async {


    final svgString =
        await rootBundle.loadString(asset);



    final document =
        XmlDocument.parse(svgString);



    final paths =
        document.findAllElements('path');



    return paths.map((path){


      return SvgPart(

        id:
        path.getAttribute('id')
            ??
            DateTime.now()
                .millisecondsSinceEpoch
                .toString(),


        pathData:
        path.getAttribute('d')
            ??
            "",

      );


    }).toList();



  }


}